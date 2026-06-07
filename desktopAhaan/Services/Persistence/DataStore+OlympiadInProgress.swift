import Foundation

// MARK: - Olympiad in-progress (mid-quiz) persistence
//
// Stores one row per actively-in-progress paper. The kid can have
// multiple in-flight: Maths Ch15 partway through AND Science Ch13
// also partway through. Both surface on the hub with a "Resume" CTA.
//
// Lifecycle:
//   • Quiz view writes on every state change (option pick, navigate,
//     mark-for-review). Coalesced 250 ms — the writer is
//     `saveCoalesced`, same shared infra as every other store.
//   • Submit clears the record for that paper.
//   • Discard (from the exit-confirm guard) also clears.

extension DataStore {

    // MARK: - Lazy hydrate

    /// Read `olympiad_in_progress.json` into memory at most once per
    /// process. Same lazy-hydrate pattern as the attempts store and
    /// progress history.
    func hydrateOlympiadInProgressIfNeeded() {
        guard !didHydrateOlympiadInProgress else { return }
        didHydrateOlympiadInProgress = true
        let result = Self.readFile(OlympiadInProgress.self,
                                   from: "olympiad_in_progress.json", in: storeDir)
        if result.didRescueCorruptFile {
            lastSaveError = "Saved data couldn't be read — a backup copy was preserved next to your data. Continuing with a fresh file."
        }
        olympiadInProgress = Dictionary(
            result.items.map { ($0.paperId, $0) },
            uniquingKeysWith: { _, new in new }
        )
    }

    // MARK: - Read

    /// The in-progress record for one paper, or nil if the kid has no
    /// active attempt.
    func inProgressOlympiad(forPaperId paperId: String) -> OlympiadInProgress? {
        hydrateOlympiadInProgressIfNeeded()
        return olympiadInProgress[paperId]
    }

    // MARK: - Write

    /// Upsert (insert or replace) the in-progress record for one
    /// paper. The caller has already bumped `lastUpdatedAt` to the
    /// current time. Queues a coalesced save.
    @MainActor
    func saveOlympiadInProgress(_ record: OlympiadInProgress) {
        hydrateOlympiadInProgressIfNeeded()
        olympiadInProgress[record.paperId] = record
        saveCoalesced(Array(olympiadInProgress.values), to: "olympiad_in_progress.json")
    }

    /// Remove the in-progress record for one paper — called on submit
    /// (the attempt is now in the history store) and on "Discard quiz"
    /// from the exit-confirm sheet. No-op if no record exists.
    @MainActor
    func clearOlympiadInProgress(forPaperId paperId: String) {
        hydrateOlympiadInProgressIfNeeded()
        guard olympiadInProgress.removeValue(forKey: paperId) != nil else { return }
        saveCoalesced(Array(olympiadInProgress.values), to: "olympiad_in_progress.json")
    }
}
