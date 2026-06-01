import Foundation

// MARK: - ExpertChallengeLadder
//
// v6 Learning Journey · Phase 5. The value model for the Olympiad / Expert
// Challenge Ladder: per subject, a set of escalating TIERS of expert-grade
// multiple-choice questions, each UNLOCKED once the subject reaches a mastery
// threshold. The questions are sourced read-only from the existing content —
// the hardest topic questions (DifficultyBand `.stretch` / `.challenge`) plus
// the authored beyond-grade `deepDive` bonus questions — and never touch the SRS.
//
// Built by the pure `ExpertChallengePlanner` + the `@MainActor`
// `DataStore.buildExpertChallengeLadder`.
//
// Big Sur compatible: Foundation-only value types, no macOS 12+ APIs.

/// The three escalating expert tiers. Raw value is the display/sort order.
enum ExpertTier: Int, CaseIterable, Codable, Hashable {
    case stretch = 0
    case challenge = 1
    case olympiad = 2

    /// Kid-facing tier name.
    var title: String {
        switch self {
        case .stretch:   return "Stretch"
        case .challenge: return "Challenge"
        case .olympiad:  return "Olympiad"
        }
    }

    /// One-line description of what the tier holds.
    var blurb: String {
        switch self {
        case .stretch:
            return "Tougher questions that push past the basics."
        case .challenge:
            return "The hardest questions in the chapter — really make you think."
        case .olympiad:
            return "Beyond-grade challenges from the Dig Deeper material."
        }
    }

    /// The subject-mastery fraction (0…1) that unlocks this tier. Aligned to the
    /// `MasteryEngine` level bands: Familiar unlocks Stretch, Confident unlocks
    /// Challenge, Mastered unlocks Olympiad — so the ladder tracks the same
    /// progress the Mastery Map shows.
    var unlockMastery: Double {
        switch self {
        case .stretch:   return 0.20
        case .challenge: return 0.50
        case .olympiad:  return 0.80
        }
    }

    /// Name of the mastery level a kid must reach to unlock the tier (for the
    /// locked-state hint).
    var unlockLevelName: String {
        switch self {
        case .stretch:   return "Familiar"
        case .challenge: return "Confident"
        case .olympiad:  return "Mastered"
        }
    }

    /// Classify a candidate question into a tier, or `nil` if it isn't
    /// expert-grade. A `deepDive` bonus question is always Olympiad (authored
    /// beyond-grade); otherwise the intrinsic `DifficultyBand` decides —
    /// `.stretch` and `.challenge` only; `.easy` / `.core` are not expert-grade.
    static func classify(band: DifficultyBand, isDeepDive: Bool) -> ExpertTier? {
        if isDeepDive { return .olympiad }
        switch band {
        case .stretch:   return .stretch
        case .challenge: return .challenge
        default:         return nil
        }
    }
}

/// One tier's questions plus whether it's currently unlocked for the subject.
struct ExpertTierSet: Hashable {
    let tier: ExpertTier
    let isUnlocked: Bool
    /// Expert questions in this tier (already capped + ordered by the builder).
    /// Reuses `AssessmentQuestion` so the challenge UI can present them exactly
    /// like a milestone checkpoint.
    let questions: [AssessmentQuestion]

    var count: Int { questions.count }
    /// Unlocked AND has at least one question to play.
    var isPlayable: Bool { isUnlocked && !questions.isEmpty }
}

/// One subject's ladder: its mastery, and the three tiers (always present, even
/// when empty or locked, so the UI can show the whole climb).
struct SubjectChallengeLadder: Hashable, Identifiable {
    let packId: String
    let subjectTitle: String
    let masteryFraction: Double
    let hasStarted: Bool
    let tiers: [ExpertTierSet]

    var id: String { packId }

    /// Total expert questions available right now (unlocked tiers only).
    var unlockedQuestionCount: Int {
        tiers.filter { $0.isUnlocked }.reduce(0) { $0 + $1.count }
    }

    /// Total expert questions authored for this subject across all tiers
    /// (locked or not) — used to hide subjects that simply have no expert
    /// content yet.
    var totalQuestionCount: Int { tiers.reduce(0) { $0 + $1.count } }

    /// `true` when at least one tier is unlocked and playable.
    var hasPlayableTier: Bool { tiers.contains { $0.isPlayable } }
}

/// The whole-journey ladder across every subject, in registry order.
struct ExpertChallengeLadder: Hashable {
    let subjects: [SubjectChallengeLadder]

    /// `true` when no subject has any expert question authored at all.
    var isEmpty: Bool { subjects.allSatisfy { $0.totalQuestionCount == 0 } }

    /// Subjects that actually have expert content to show.
    var subjectsWithContent: [SubjectChallengeLadder] {
        subjects.filter { $0.totalQuestionCount > 0 }
    }
}
