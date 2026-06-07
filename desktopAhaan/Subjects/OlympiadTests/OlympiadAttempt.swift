import Foundation

// MARK: - OlympiadAttempt
//
// One persisted attempt of an Olympiad paper. Captured on the score
// screen (`OlympiadQuizResultView`) once the kid has submitted — never
// while the quiz is in progress. The attempt sits OUTSIDE the SRS
// layer (same stance the Milestone Checkpoint takes): Olympiad papers
// are graded summatively, not folded into the spaced-repetition queue.
//
// Stored at `~/Library/Application Support/com.emoha.desktopAhaan/data/
// olympiad_attempts.json` via the standard `DataStore` coalesced-write
// pipeline. A single attempt is ≈ 130 bytes JSON; even 200 attempts a
// year is ~25 KB, so no retention cap is needed (we'll revisit if the
// file grows past 1 MB).

struct OlympiadAttempt: Codable, Identifiable, Hashable {
    /// Unique attempt id. Lets the kid retake a paper any number of
    /// times without overwriting the prior row — the hub surfaces both
    /// "best" and "most recent".
    let id: UUID
    /// `OlympiadPaper.id`, e.g. "olympiad_science_ch13". Stable across
    /// app launches (the registry is hardcoded).
    let paperId: String
    /// Wall-clock time the kid hit Submit Paper.
    let attemptedAt: Date
    /// Counts. Always sum to `OlympiadPaper.questionCount` (60 today).
    let correct: Int
    let wrong: Int
    let skipped: Int
    /// Signed total under the paper's +4/-1/0 scheme. Can be negative
    /// if the kid guesses badly (negative marking is real here).
    let scoreOutOfMax: Int
    /// Denominator for percentage compute. Snapshotted from the paper
    /// at attempt time so a future tweak to the marking scheme doesn't
    /// retroactively change historical percentages.
    let maxMarks: Int
    /// Clamped 0…100. Negative scores show as 0 (a negative percentage
    /// is meaningless to the kid).
    let percentage: Int
}

extension OlympiadAttempt {
    /// Convenience used by the hub. Returns nil for an empty list so
    /// the call-site can render "Not attempted yet" without branching.
    static func bestByPercentage(_ list: [OlympiadAttempt]) -> OlympiadAttempt? {
        list.max(by: { $0.percentage < $1.percentage })
    }

    /// Convenience used by the hub. Returns the most-recent attempt
    /// (latest `attemptedAt`) or nil if the list is empty.
    static func mostRecent(_ list: [OlympiadAttempt]) -> OlympiadAttempt? {
        list.max(by: { $0.attemptedAt < $1.attemptedAt })
    }
}
