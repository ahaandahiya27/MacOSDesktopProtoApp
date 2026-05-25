import Foundation

/// Helpers that live on `Question` but are specific to the boss-quiz
/// surface (`Scene9_BossQuiz*`). Pulled out of the 19 Scene9 view
/// files on 2026-05-25 to retire the per-file
/// `private func bossExplanation(_ q: Question) -> String { ... }`
/// duplication.
///
/// Voice / convention pinned in `scripts/migrate_boss_quiz_to_pack.py`:
/// each boss-quiz item's "explanation" body is the first entry of its
/// `solutionSteps` array. Boss Qs ship with a single solution step by
/// design (the post-answer reveal card is one short paragraph); if a
/// future content edit empties that array, fall back to a friendly
/// default so the reveal card never renders empty.
extension Question {
    /// One-line post-answer reveal text used by every Scene9_BossQuiz
    /// view. Returns "Got it!" if the solutionSteps array is empty
    /// (defensive — shouldn't happen in steady state) or if the first
    /// step itself is empty.
    var bossExplanation: String {
        let step = solutionSteps.first ?? ""
        return step.isEmpty ? "Got it!" : step
    }
}
