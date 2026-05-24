import Foundation

// MARK: - DataStore · ephemeral reviews
//
// The textbook-canonical answer path (`recordReview`) keys on
// `Question.id` strings that resolve through
// `SubjectRegistry.location(forQuestionId:)` to a real Question +
// Topic + Chapter triple. Boss-quiz and scene-quick-check items are
// hand-authored Swift literals — they answer the same kid the same
// way but live outside the pack JSON, so their ids don't resolve
// through that registry.
//
// `recordEphemeralReview` is the same write path with a clearer name
// at the call site. Internally it delegates to `recordReview` so the
// scheduler, coalesced save, and streak credit all stay in one
// place. The only behavioural difference lives at READ time, in the
// DailyPracticeView resolver, which already silently skips
// unresolvable ids via `compactMap { subjectRegistry.location(forQuestionId:) }`.
//
// Stable id format chosen for the boss-quiz wiring (D2):
//   "bossquiz_ch<NN>_q<II>"  e.g. "bossquiz_ch01_q07"
//
// NN is the zero-padded chapter number; II is the zero-padded item
// index within that chapter's quiz array. Padding stops a future
// sort from putting q10 before q2.

extension DataStore {

    /// Record an answer to a Question that isn't a textbook-canonical
    /// row — boss-quiz MCQs, scene quick-checks, future enrichment
    /// surfaces. Behaviour matches `recordReview` exactly; the
    /// parameter is renamed to `ephemeralId` at the call site so the
    /// distinction is visible at every call.
    func recordEphemeralReview(
        ephemeralId: String,
        quality: ReviewQuality,
        at now: Date = Date()
    ) {
        recordReview(questionId: ephemeralId, quality: quality, at: now)
    }

    /// True if `id` looks like an ephemeral synthetic id. Used by the
    /// recently-missed surface (D3) to decide whether "Retry" navigates
    /// to a Question detail view or to the chapter's boss-quiz scene.
    /// Plain prefix sniff — no regex, no allocation. Future ephemeral
    /// kinds (scene quick-checks, articles, etc.) extend this list.
    static func isEphemeralReviewId(_ id: String) -> Bool {
        for prefix in Self.ephemeralIdPrefixes {
            if id.hasPrefix(prefix) { return true }
        }
        return false
    }

    /// Known synthetic-id prefixes. Update this when wiring a new
    /// surface; `BossQuizSRSWiringTests.testEphemeralIdShape` pins
    /// the format every wiring uses.
    static let ephemeralIdPrefixes: [String] = [
        "bossquiz_ch",
        "scenecheck_ch"
    ]
}
