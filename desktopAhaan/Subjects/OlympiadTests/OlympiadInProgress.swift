import Foundation

// MARK: - OlympiadInProgress
//
// Mid-quiz state for ONE Olympiad paper that hasn't been submitted
// yet. Persisted to `olympiad_in_progress.json` so the kid can quit
// (Cmd-Q, lid close, crash) and resume from exactly the question they
// left on, with their selected options + mark-for-review flags intact
// AND the countdown clock continuing from `startedAt` (not reset to
// the full 90 minutes — that would defeat the timed-rehearsal point).
//
// Multiple in-progress papers can coexist: the kid might be partway
// through Maths Ch15 when they decide to start Science Ch13. The hub
// shows a "Resume Quiz · Q23/60" CTA on each paper with an active
// record. Submitting the paper clears its record.

struct OlympiadInProgress: Codable, Equatable, Identifiable {
    /// Equal to `paperId` — the store is per-paper, never multi-row
    /// for the same paper. Identifiable so SwiftUI's ForEach can use
    /// it directly.
    var id: String { paperId }

    /// `OlympiadPaper.id`, e.g. "olympiad_science_ch13".
    let paperId: String

    /// Per-question selected option letter, mirror of
    /// `OlympiadQuizView.selectedByQuestionId`.
    var selectedByQuestionId: [String: String]

    /// Question ids the kid flagged. Stored as an array (Set isn't
    /// Codable JSON-canonical) and re-Set on restore.
    var markedForReviewQuestionIds: [String]

    /// 0-based index into the paper's questions list — the question
    /// the kid was on when we last persisted.
    var currentIndex: Int

    /// Wall-clock time the kid first tapped Take Quiz. The countdown
    /// is computed as `suggestedTimeMinutes × 60 − (now − startedAt)`.
    /// Persisted so quitting + resuming doesn't refill the clock.
    let startedAt: Date

    /// Last time this record was written. Used for "Resume — paused
    /// 4 minutes ago" hints in the hub if we ever surface them.
    var lastUpdatedAt: Date
}
