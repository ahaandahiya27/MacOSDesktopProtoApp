import Foundation

// MARK: - Coalesced-write infrastructure (design)
//
// Hot mutators (recordReview / markSceneComplete / toggleToughQuestion
// / etc.) can fire several times per second during a review session.
// The full-file rewrite-on-every-change pattern was producing back-to-
// back fsyncs that contributed to multi-hundred-ms main-thread hangs
// on the Big Sur iMac's spinning disk.
//
// Two layers of mitigation:
//
//   1. Coalescing (`saveCoalesced(_:to:)`): within the 250 ms debounce
//      window the LAST submission wins. Intermediate states would be
//      overwritten on the very next mutation anyway, so dropping them
//      is safe. Encoding happens on main at submission time so the
//      payload reflects the model snapshot exactly when the user
//      acted.
//
//   2. Off-main writes (`performAtomicWrite`): the `Data.write(to:
//      options:.atomic)` call — which does the fsync — runs on the
//      shared `saveQueue` (serial, .userInitiated background). The
//      main thread is never blocked by the disk fsync at runtime.
//      Error reports hop back via `DispatchQueue.main.async` to
//      mutate the @Published `lastSaveError` banner.
//
// Invariants:
//   - `applicationWillTerminate` calls `flushSavesBeforeQuit()` which
//     dispatches all pending writes and then `saveQueue.sync { }`s to
//     block main until they land — accepting the brief stall at quit
//     time so data is durable.
//   - The cold `save(_:to:)` path stays for one-shot user-driven
//     operations (e.g. clearAll). It also encodes on main and writes
//     off main, same pattern as the coalesced path.
//   - Captures-by-value of the encoded snapshot at submission time
//     means the off-main write sees a frozen copy of the data even
//     if the in-memory model mutates again before the write lands.
//
// The storage (`pendingSavePayloads`, `pendingSaveTimers`,
// `coalesceDelaySeconds`) lives in DataStore.swift because Swift
// doesn't allow stored properties in extensions. The behavioural
// surface lives here.

extension DataStore {

    /// Serial background queue for the actual `Data.write(to:options:.atomic)`
    /// calls. Encoding happens on main (cheap; ms for the largest files we
    /// store), but the fsync inside the atomic write is the part that
    /// stalls — single-digit ms on SSD, tens to a couple hundred ms on the
    /// Big Sur iMac's spinning disk. `static` because per-instance would
    /// give one DataStore its own queue; serial ordering across all callers
    /// is exactly what we want for atomicity (different files don't
    /// interleave; same file's later writes overwrite earlier ones).
    nonisolated static let saveQueue = DispatchQueue(
        label: "com.emoha.desktopAhaan.DataStore.save",
        qos: .userInitiated
    )

    /// Cold-path save: encode on main, atomic-write off main. Error path
    /// reports back to the @MainActor `lastSaveError` banner via a
    /// `DispatchQueue.main.async` hop. The hop converts the Cocoa error
    /// into its `localizedDescription` String on the background side so
    /// the cross-thread value stays Sendable (NSError isn't).
    func save<T: Encodable>(_ items: [T], to filename: String) {
        let url = storeDir.appendingPathComponent(filename)
        let data: Data
        do {
            data = try JSONEncoder().encode(items)
        } catch {
            // Encode failure is on main and rare (only happens if a
            // Codable conformance is broken). Surface immediately.
            lastSaveError = "Could not save data (\(filename)). Changes may be lost."
            Self.logger.error("encode \(filename, privacy: .public) failed: \(error.localizedDescription, privacy: .public)")
            return
        }
        Self.performAtomicWrite(data: data, to: url, filename: filename) { [weak self] errorDescription in
            // Always on main via DispatchQueue.main.async hop.
            guard let self = self else { return }
            if let errorDescription = errorDescription {
                self.lastSaveError = "Could not save data (\(filename)). Changes may be lost."
                Self.logger.error("save \(filename, privacy: .public) failed: \(errorDescription, privacy: .public)")
            } else {
                self.lastSaveError = nil
            }
        }
    }

    /// Off-main atomic-write helper. Schedules the write on `saveQueue`,
    /// converts any error to its String description on the background
    /// side, and hops back to main via `DispatchQueue.main.async` to
    /// invoke `completion`. Sendable-clean (String only) — no NSError
    /// crosses the actor hop.
    nonisolated static func performAtomicWrite(
        data: Data,
        to url: URL,
        filename: String,
        completion: @escaping (String?) -> Void
    ) {
        saveQueue.async {
            // Use a single-assignment `let` so the value crossing the
            // queue hop is captured immutably. Big Sur / Swift 5.5
            // diagnoses a `var` captured into a concurrently-executing
            // `DispatchQueue.main.async` closure as a concurrency error.
            let errorDescription: String?
            do {
                try data.write(to: url, options: .atomic)
                errorDescription = nil
            } catch {
                errorDescription = error.localizedDescription
            }
            // Hop back to main for the completion. The completion mutates
            // @Published `lastSaveError` which must be on the main actor.
            DispatchQueue.main.async {
                completion(errorDescription)
            }
        }
    }

    /// Debounced write for high-frequency mutators. Encodes the snapshot
    /// at submission time, stashes it under the filename key, and resets
    /// a debounce timer; if another submission arrives within the window
    /// it replaces the payload (only the latest matters since each save
    /// rewrites the file in full). Net effect: rapid mutations land as
    /// one off-main write of the latest state at the end of the
    /// coalescing window.
    func saveCoalesced<T: Encodable>(_ items: [T], to filename: String) {
        let url = storeDir.appendingPathComponent(filename)
        let encoded: Data
        do {
            encoded = try JSONEncoder().encode(items)
        } catch {
            lastSaveError = "Could not encode \(filename). Changes may be lost."
            Self.logger.error("encode \(filename, privacy: .public) failed: \(error.localizedDescription, privacy: .public)")
            return
        }
        pendingSavePayloads[filename] = (url, encoded)
        pendingSaveTimers[filename]?.invalidate()
        pendingSaveTimers[filename] = Timer.scheduledTimer(
            withTimeInterval: coalesceDelaySeconds, repeats: false
        ) { [weak self] _ in
            Task { @MainActor [weak self] in
                self?.flushPendingSave(filename: filename)
            }
        }
    }

    /// Consume the pending payload for `filename` (if any) and dispatch
    /// it to the off-main saveQueue for an atomic write. The dequeue
    /// happens on main (so two main-actor calls for the same filename
    /// can't double-dispatch the same payload); the actual write runs
    /// in the background.
    func flushPendingSave(filename: String) {
        pendingSaveTimers.removeValue(forKey: filename)?.invalidate()
        guard let payload = pendingSavePayloads.removeValue(forKey: filename) else { return }
        Self.performAtomicWrite(data: payload.data, to: payload.url, filename: filename) { [weak self] errorDescription in
            guard let self = self else { return }
            if let errorDescription = errorDescription {
                self.lastSaveError = "Could not save data (\(filename)). Changes may be lost."
                Self.logger.error("coalesced-save \(filename, privacy: .public) failed: \(errorDescription, privacy: .public)")
            } else {
                self.lastSaveError = nil
            }
        }
    }

    /// Drain every pending coalesced write synchronously. Called from
    /// `applicationWillTerminate` so a clean ⌘Q doesn't lose mutations
    /// that landed inside the last 250ms debounce window. Safe to call
    /// when nothing is pending — no-op.
    ///
    /// `saveQueue.sync { }` after dispatching all pending writes blocks
    /// the calling thread (main) until the serial queue has drained.
    /// Standard pattern — saveQueue runs on a background thread and
    /// doesn't need main to make progress, so no deadlock. Bounded by
    /// the size of `pendingSavePayloads` (≤ 11 files of kilobytes each).
    ///
    /// **2026-06-05 audit**: the drain WAS unbounded. AppKit kills any
    /// `applicationWillTerminate` that runs more than ~5 seconds. If the
    /// disk is stalled (slow Big-Sur fsync on the spinning-disk iMac,
    /// TimeMachine snapshot mid-quit, full-disk allocation retry), the
    /// kernel would SIGKILL us before `markCleanExit()` flipped the flag,
    /// and the next launch would log a SPURIOUS RECOVERY entry. Capped
    /// the wait at 1.5 seconds via a DispatchGroup timeout. Trade-off
    /// documented: at most one debounce window of data can be lost on
    /// a stuck-disk quit — which is strictly better than the alternative
    /// of the kernel killing us at an arbitrary point during the drain.
    func flushSavesBeforeQuit() {
        let filenames = Array(pendingSavePayloads.keys)
        for filename in filenames {
            flushPendingSave(filename: filename)
        }
        // Bounded drain. The serial queue runs every dispatched write in
        // FIFO order; we hop one trailing async block onto the queue and
        // wait for THAT block to signal a semaphore, with a 1.5 s cap.
        let drainSignal = DispatchSemaphore(value: 0)
        Self.saveQueue.async {
            drainSignal.signal()
        }
        let result = drainSignal.wait(timeout: .now() + 1.5)
        if result == .timedOut {
            // 5+ pending writes still running. Surface to the next launch's
            // crashlog so the parent sees the stuck-disk pattern.
            CrashReporter.shared.logDataIssue(
                "flushSavesBeforeQuit timed out at 1.5s — some saves may not have landed before quit"
            )
        }
    }

    /// Number of writes still queued in the coalesced-save buffer. Used
    /// by `applicationWillTerminate` to detect a truncation event at
    /// shutdown. Read on the main actor.
    var pendingSaveCount: Int { pendingSavePayloads.count }
}
