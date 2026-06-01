import Foundation

// MARK: - ExpertChallengePlanner
//
// v6 Learning Journey · Phase 5. The PURE core of the Expert Challenge Ladder:
// given a subject's expert questions already grouped by tier and the subject's
// mastery fraction, it produces the three `ExpertTierSet`s with their unlock
// flags. FS-free, DataStore-free, fully unit-testable. The `@MainActor` half —
// gathering + classifying the questions from the live packs — lives in
// `DataStore+ExpertChallenge.swift`. Mirrors the MasteryEngine / JourneyPlanner
// split.
//
// READ-ONLY over the SRS: nothing here reads or writes reviews.
//
// Big Sur compatible: Foundation-only value math, no macOS 12+ APIs.

enum ExpertChallengePlanner {

    /// Build all three tier sets for a subject (every tier always present, even
    /// when it has no questions), marking each unlocked iff `masteryFraction`
    /// meets the tier's `unlockMastery` threshold. Pure.
    static func tierSets(
        questionsByTier: [ExpertTier: [AssessmentQuestion]],
        masteryFraction: Double
    ) -> [ExpertTierSet] {
        ExpertTier.allCases.map { tier in
            ExpertTierSet(
                tier: tier,
                isUnlocked: masteryFraction >= tier.unlockMastery,
                questions: questionsByTier[tier] ?? [])
        }
    }
}
