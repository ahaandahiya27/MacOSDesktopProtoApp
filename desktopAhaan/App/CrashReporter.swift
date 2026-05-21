import Foundation
import os.log

/// Captures uncaught Objective-C exceptions and Unix fatal signals
/// (SIGABRT/SIGILL/SIGBUS/SIGSEGV/SIGFPE/SIGPIPE) to a plain-text log
/// file in the user's Application Support directory:
///
///   ~/Library/Application Support/desktopAhaan/crashlogs/
///       crashlog-YYYY-MM-DD.txt
///
/// Each entry includes timestamp, kind (exception/signal/data-issue),
/// message, and the current call stack symbols. The file is append-only
/// per day so repeated launches collect every crash without overwriting.
///
/// The workflow Rohan wants:
///   1. App captures crashes here on the iMac.
///   2. He commits the crashlog file (or pastes it back to Claude).
///   3. Claude reads the log next session and fixes the root cause.
///   4. After the fix lands, he calls `CrashReporter.shared.clearAllLogs()`
///      (e.g., from a hidden Debug menu, or by deleting the folder
///      manually) and the cycle starts fresh.
///
/// Big Sur (macOS 11) / Swift 5.5 compatible:
///  - Pure Foundation + os.Logger. No async/await escapes the actor;
///    file writes are synchronous via FileHandle so a crash mid-write
///    still flushes what we have.
///  - `signal()` and `NSSetUncaughtExceptionHandler()` exist on every
///    Apple platform since 10.x.
final class CrashReporter {
    static let shared = CrashReporter()

    /// Folder where crash logs are written (one append-only file per UTC day).
    /// Exposed so the Help menu's "Reveal Crash Logs in Finder" can locate it.
    let logDirectoryURL: URL
    private let logger = Logger(subsystem: "in.emoha.desktopAhaan", category: "crash")
    private let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.dateFormat = "yyyy-MM-dd"
        f.timeZone = TimeZone(identifier: "UTC")
        return f
    }()
    private let timestampFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS ZZZZZ"
        return f
    }()

    /// Hard cap on how many daily crashlog files to keep. Older files are
    /// pruned on `install()` and on each rotate check. 30 keeps roughly a
    /// month of context, plenty for diagnosing patterns but bounded so a
    /// long-running install never grows unbounded under the child's home
    /// directory.
    private let maxLogFiles: Int = 30
    /// Hard cap on a single daily file's size in bytes. A runaway loop
    /// hitting a data-issue every frame could otherwise write megabytes
    /// per minute. When today's file exceeds this, it gets rotated to a
    /// `.bak` and a fresh file starts; pruning then enforces `maxLogFiles`.
    private let maxLogFileSizeBytes: Int = 1_048_576  // 1 MB

    private init() {
        // Resolve ~/Library/Application Support/desktopAhaan/crashlogs/
        let fm = FileManager.default
        let base = (try? fm.url(for: .applicationSupportDirectory,
                                in: .userDomainMask,
                                appropriateFor: nil,
                                create: true)) ?? URL(fileURLWithPath: NSHomeDirectory())
            .appendingPathComponent("Library/Application Support")
        let appDir = base.appendingPathComponent("desktopAhaan", isDirectory: true)
        self.logDirectoryURL = appDir.appendingPathComponent("crashlogs", isDirectory: true)
        try? fm.createDirectory(at: self.logDirectoryURL,
                                withIntermediateDirectories: true,
                                attributes: nil)
    }

    /// Wires Objective-C exception handler + Unix signal handlers.
    /// Idempotent — calling twice replaces with the same handler.
    func install() {
        // Skip the entire crash-reporting setup under XCTest. The test
        // runner kills the host process between suites without going
        // through applicationWillTerminate, so the cleanExit flag will
        // always read false on the next test launch and we'd log a
        // misleading "previous session crashed" RECOVERY breadcrumb on
        // every CI run. Detect via XCTestConfigurationFilePath, the
        // env var Xcode sets only inside the test runner.
        if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil {
            logger.info("CrashReporter install skipped (running under XCTest).")
            return
        }
        NSSetUncaughtExceptionHandler { exception in
            CrashReporter.shared.recordException(exception)
        }
        for sig in [SIGABRT, SIGILL, SIGBUS, SIGSEGV, SIGFPE, SIGPIPE] {
            signal(sig) { signo in
                CrashReporter.shared.recordSignal(signo)
                // Reset to default and re-raise so the OS still gets the
                // crash and produces its own .crash report in Console.
                signal(signo, SIG_DFL)
                raise(signo)
            }
        }
        // Prune now so a long-idle install doesn't carry months of files
        // forward across launches.
        pruneOldLogs()
        // Session-bookkeeping breadcrumb (B11): if the previous session
        // didn't set "cleanExit" we know it ended in a crash. Write that
        // observation into today's log so the parent investigating
        // crashlogs sees crash → relaunch pairs without needing a helper
        // binary. UserDefaults read is the only persistent state we need.
        let defaults = UserDefaults.standard
        let prevCleanExit = defaults.bool(forKey: "desktopAhaan.lastSessionCleanExit")
        if defaults.object(forKey: "desktopAhaan.lastSessionCleanExit") != nil && !prevCleanExit {
            let entry = formatEntry(kind: "RECOVERY",
                                    message: "previous session ended without a clean quit — likely crashed",
                                    origin: "CrashReporter.install",
                                    stack: [])
            appendToCurrentLog(entry)
        }
        // Default to "not clean" — applicationWillTerminate flips it to true.
        defaults.set(false, forKey: "desktopAhaan.lastSessionCleanExit")
        logger.info("CrashReporter installed; logs go to \(self.logDirectoryURL.path, privacy: .public)")
    }

    // MARK: - Hang detector (DG5, DEBUG-only)
    //
    // Background watchdog that pings the main thread every 250ms. If the
    // ping doesn't get processed within `hangThresholdSeconds`, main is
    // stuck — we log a `HANG` entry into today's crashlog with the
    // observed block duration. The kid never sees this; it's a developer
    // diagnostic. Release builds skip the whole thing (`startHangDetection`
    // is a no-op outside DEBUG) so there's zero shipping-cost.
    //
    // False-positive shield: bounded at `maxHangsPerSession` entries per
    // session to prevent a 10-minute background sleep / wake from filling
    // a crashlog. `hangCurrentlyReported` flag also collapses a single
    // long hang into one log entry (not one per check tick).
    //
    // Race-shielded with a private NSLock — heartbeat read/write from two
    // threads (main publishes; background reads), but Date is a value
    // type and the lock keeps `lastMainHeartbeat` / `hangsLoggedThisSession`
    // safe. The DEBUG-only nature means tolerable rare false-positives
    // from clock skew are fine.

    #if DEBUG
    private let hangLock = NSLock()
    private var hangTimer: DispatchSourceTimer?
    private var lastMainHeartbeat: Date = Date()
    private var hangCurrentlyReported: Bool = false
    private var hangsLoggedThisSession: Int = 0
    private let hangThresholdSeconds: TimeInterval = 1.0
    private let hangCheckIntervalSeconds: TimeInterval = 0.25
    private let maxHangsPerSession: Int = 30
    #endif

    /// Starts the main-thread hang watchdog. DEBUG-only; release builds
    /// no-op. Idempotent — calling twice is a no-op after the first.
    /// Call from `applicationDidFinishLaunching` so the run-loop is fully
    /// up before the heartbeat starts (avoids false positives during
    /// launch cascade).
    func startHangDetection() {
        #if DEBUG
        // XCTest deliberately blocks the main thread with XCTWaiter
        // while it ticks down async expectations — that's the test
        // harness doing exactly what it's designed to do, not a real
        // hang. Detected via XCTestConfigurationFilePath, the
        // environment variable Xcode sets only inside the test runner.
        // Suppress here so the crashlog stays focused on user-facing
        // hangs and recovery breadcrumbs aren't polluted.
        if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil {
            logger.info("Hang detector skipped (running under XCTest).")
            return
        }
        guard hangTimer == nil else { return }
        let queue = DispatchQueue(
            label: "com.emoha.desktopAhaan.hang-detector",
            qos: .utility
        )
        let timer = DispatchSource.makeTimerSource(queue: queue)
        timer.schedule(deadline: .now() + hangCheckIntervalSeconds,
                       repeating: hangCheckIntervalSeconds)
        timer.setEventHandler { [weak self] in
            self?.hangCheckTick()
        }
        timer.resume()
        hangTimer = timer
        logger.info("Hang detector started (DEBUG, threshold \(Int(self.hangThresholdSeconds * 1000), privacy: .public)ms).")
        #endif
    }

    #if DEBUG
    private func hangCheckTick() {
        let now = Date()
        hangLock.lock()
        let lastTick = lastMainHeartbeat
        let alreadyReporting = hangCurrentlyReported
        let count = hangsLoggedThisSession
        hangLock.unlock()

        let elapsed = now.timeIntervalSince(lastTick)

        if elapsed > hangThresholdSeconds {
            if !alreadyReporting && count < maxHangsPerSession {
                hangLock.lock()
                hangCurrentlyReported = true
                hangsLoggedThisSession += 1
                hangLock.unlock()

                let ms = Int(elapsed * 1000)
                logDataIssue("HANG: main thread blocked for ~\(ms) ms (threshold \(Int(hangThresholdSeconds * 1000))ms)")

                // Capture a post-hang main-thread stack. The block runs as
                // soon as the main thread unblocks, so the symbols are not
                // the frames that WERE running during the hang — they're
                // the frames immediately AFTER the hang resolves. In
                // practice that's a useful breadcrumb anyway: the function
                // that finally let main breathe is usually adjacent to the
                // function that held it. DEBUG-only.
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    let frames = Thread.callStackSymbols.prefix(20).joined(separator: "\n  ")
                    self.logDataIssue("HANG post-recovery main stack (top 20):\n  \(frames)")
                }
            }
        } else if alreadyReporting {
            // Main woke up — clear the latch so we can log the next hang.
            hangLock.lock()
            hangCurrentlyReported = false
            hangLock.unlock()
        }

        // Heartbeat back to main. If main runs the closure, lastMainHeartbeat
        // updates; if main is stuck, the closure sits in the queue and the
        // next background tick sees stale data.
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.hangLock.lock()
            self.lastMainHeartbeat = Date()
            self.hangLock.unlock()
        }
    }
    #endif

    /// Called by applicationWillTerminate so the next launch can tell
    /// "clean quit" from "crashed mid-session".
    func markCleanExit() {
        UserDefaults.standard.set(true, forKey: "desktopAhaan.lastSessionCleanExit")
    }

    /// Enforce `maxLogFiles` by deleting the oldest files first. Called
    /// on install + after every rotation. Non-fatal — failures are logged
    /// but never throw out of the crash handler.
    private func pruneOldLogs() {
        let files = allLogFiles()
        guard files.count > maxLogFiles else { return }
        let excess = files.count - maxLogFiles
        let fm = FileManager.default
        for url in files.prefix(excess) {
            try? fm.removeItem(at: url)
        }
        logger.info("CrashReporter: pruned \(excess, privacy: .public) old log file(s)")
    }

    /// Path of the log file for today (one file per UTC day, append-only).
    var currentLogFileURL: URL {
        let day = dateFormatter.string(from: Date())
        return logDirectoryURL.appendingPathComponent("crashlog-\(day).txt")
    }

    /// Quick listing of every crashlog file present, oldest first.
    func allLogFiles() -> [URL] {
        let fm = FileManager.default
        guard let urls = try? fm.contentsOfDirectory(at: logDirectoryURL,
                                                    includingPropertiesForKeys: [.contentModificationDateKey],
                                                    options: [.skipsHiddenFiles]) else {
            return []
        }
        return urls
            .filter { $0.lastPathComponent.hasPrefix("crashlog-") }
            .sorted { ($0.lastPathComponent) < ($1.lastPathComponent) }
    }

    /// Delete all log files. Call this AFTER you've committed/handed the
    /// crash logs off to Claude for analysis and the fix has landed.
    @discardableResult
    func clearAllLogs() -> Int {
        let fm = FileManager.default
        var removed = 0
        for url in allLogFiles() {
            if (try? fm.removeItem(at: url)) != nil {
                removed += 1
            }
        }
        logger.info("CrashReporter: cleared \(removed) log file(s)")
        return removed
    }

    // MARK: - Public entry points used by the rest of the app

    /// Record a non-fatal data-quality issue (e.g., duplicate IDs in JSON).
    /// Does NOT terminate. Writes one line to today's log.
    func logDataIssue(_ message: String,
                      file: String = #file,
                      line: Int = #line) {
        let entry = formatEntry(kind: "DATA",
                                message: message,
                                origin: "\((file as NSString).lastPathComponent):\(line)",
                                stack: [])
        appendToCurrentLog(entry)
        logger.error("data-issue: \(message, privacy: .public)")
    }

    // MARK: - Internals

    private func recordException(_ exception: NSException) {
        let stack = exception.callStackSymbols
        let msg = "\(exception.name.rawValue): \(exception.reason ?? "no reason")"
        let entry = formatEntry(kind: "EXCEPTION",
                                message: msg,
                                origin: "NSUncaughtExceptionHandler",
                                stack: stack)
        appendToCurrentLog(entry)
    }

    private func recordSignal(_ signo: Int32) {
        let name: String
        switch signo {
        case SIGABRT: name = "SIGABRT (e.g. Swift fatalError / precondition / abort)"
        case SIGILL: name = "SIGILL (illegal instruction)"
        case SIGBUS: name = "SIGBUS (bus error / unaligned access)"
        case SIGSEGV: name = "SIGSEGV (bad pointer dereference)"
        case SIGFPE: name = "SIGFPE (arithmetic — divide by zero etc.)"
        case SIGPIPE: name = "SIGPIPE (write to closed pipe)"
        default: name = "signal \(signo)"
        }
        let stack = Thread.callStackSymbols
        let entry = formatEntry(kind: "SIGNAL",
                                message: name,
                                origin: "POSIX signal handler",
                                stack: stack)
        appendToCurrentLog(entry)
    }

    private func formatEntry(kind: String,
                             message: String,
                             origin: String,
                             stack: [String]) -> String {
        let timestamp = timestampFormatter.string(from: Date())
        var out = ""
        out += "═══════════════════════════════════════════════════════════\n"
        out += "[\(kind)] \(timestamp)\n"
        out += "origin : \(origin)\n"
        out += "message: \(message)\n"
        if !stack.isEmpty {
            out += "stack  :\n"
            for line in stack {
                out += "    \(line)\n"
            }
        }
        out += "═══════════════════════════════════════════════════════════\n\n"
        return out
    }

    /// Synchronous append so we still flush if the next instruction crashes.
    /// Rotates today's file off to `.bak` and starts a fresh one when it
    /// exceeds `maxLogFileSizeBytes`, so a runaway data-issue loop can't
    /// fill the disk.
    private func appendToCurrentLog(_ entry: String) {
        let url = currentLogFileURL
        let data = entry.data(using: .utf8) ?? Data()
        let fm = FileManager.default

        rotateIfNeeded(url: url, incomingBytes: data.count)

        if !fm.fileExists(atPath: url.path) {
            try? data.write(to: url, options: .atomic)
            pruneOldLogs()
            return
        }
        if let handle = try? FileHandle(forWritingTo: url) {
            do {
                try handle.seekToEnd()
                try handle.write(contentsOf: data)
                try handle.close()
            } catch {
                // Last resort — at least don't crash inside the crash handler.
                try? data.write(to: url, options: .atomic)
            }
        }
    }

    /// If appending would push today's file past `maxLogFileSizeBytes`,
    /// rename it to `<name>.bak-<timestamp>` and let the next write create
    /// a fresh file. Then enforce `maxLogFiles` so we don't accumulate.
    private func rotateIfNeeded(url: URL, incomingBytes: Int) {
        let fm = FileManager.default
        guard let attrs = try? fm.attributesOfItem(atPath: url.path),
              let size = attrs[.size] as? Int else { return }
        if size + incomingBytes <= maxLogFileSizeBytes { return }

        let stamp = ISO8601DateFormatter().string(from: Date())
            .replacingOccurrences(of: ":", with: "-")
        let backup = url.deletingPathExtension()
            .appendingPathExtension("bak-\(stamp).txt")
        try? fm.moveItem(at: url, to: backup)
        logger.info("CrashReporter: rotated oversize log to \(backup.lastPathComponent, privacy: .public)")
        pruneOldLogs()
    }
}
