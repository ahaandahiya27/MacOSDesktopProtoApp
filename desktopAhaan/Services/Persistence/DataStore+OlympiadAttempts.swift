import Foundation

// MARK: - Olympiad attempt-history persistence
//
// Captures a row each time the kid submits an Olympiad paper, so the
// hub can surface "Best: 86% · Last: 3d ago · 42%" badges instead of
// the previous one-shot quiz-then-forget behaviour.
//
// Design — mirrors the milestone-checkpoint / progress-history idiom
// already used by DataStore:
//
//   • Lazy hydrate: `olympiadAttempts` is read from disk at most once
//     per process on first access/write, so a kid who never taps the
//     Olympiad sidebar never pays the read.
//
//   • Append-on-record: every submit appends a NEW row (UUID id). No
//     dedupe by paperId — multiple attempts of the same paper coexist
//     so the kid sees their improvement curve.
//
//   • No retention cap. A single row is ~130 bytes JSON; 200 attempts
//     a year is ~25 KB. Revisit if the file grows past 1 MB.
//
//   • OUTSIDE the SRS layer. No `QuestionReview` writes; no scheduling
//     side effect. Olympiad papers are graded summatively, the same
//     stance Milestone Checkpoints take.

extension DataStore {

    // MARK: - Lazy hydrate

    /// Read `olympiad_attempts.json` into `olympiadAttempts` at most
    /// once per process. Safe to call repeatedly. Main-actor; the file
    /// is a few KB at the upper bound.
    func hydrateOlympiadAttemptsIfNeeded() {
        guard !didHydrateOlympiadAttempts else { return }
        didHydrateOlympiadAttempts = true
        let result = Self.readFile(OlympiadAttempt.self,
                                   from: "olympiad_attempts.json", in: storeDir)
        if result.didRescueCorruptFile {
            lastSaveError = "Saved data couldn't be read — a backup copy was preserved next to your data. Continuing with a fresh file."
        }
        olympiadAttempts = result.items
    }

    // MARK: - Record

    /// Append a new attempt and queue a coalesced save. Idempotent at
    /// the UUID level — calling twice with the SAME id (e.g. SwiftUI's
    /// `onAppear` firing twice on a freshly-pushed sheet) is a no-op
    /// after the first write.
    @MainActor
    func recordOlympiadAttempt(_ attempt: OlympiadAttempt) {
        hydrateOlympiadAttemptsIfNeeded()
        if olympiadAttempts.contains(where: { $0.id == attempt.id }) {
            return
        }
        olympiadAttempts.append(attempt)
        saveCoalesced(olympiadAttempts, to: "olympiad_attempts.json")
    }

    // MARK: - Read accessors

    /// All attempts for one paper, newest-first. Empty list when the
    /// kid has never attempted that paper.
    func olympiadAttempts(forPaperId paperId: String) -> [OlympiadAttempt] {
        hydrateOlympiadAttemptsIfNeeded()
        return olympiadAttempts
            .filter { $0.paperId == paperId }
            .sorted { $0.attemptedAt > $1.attemptedAt }
    }

    /// The highest-percentage attempt for one paper, or nil if never
    /// attempted.
    func bestOlympiadAttempt(forPaperId paperId: String) -> OlympiadAttempt? {
        OlympiadAttempt.bestByPercentage(olympiadAttempts(forPaperId: paperId))
    }

    /// The most recent attempt for one paper, or nil if never attempted.
    func mostRecentOlympiadAttempt(forPaperId paperId: String) -> OlympiadAttempt? {
        OlympiadAttempt.mostRecent(olympiadAttempts(forPaperId: paperId))
    }
}
