import Foundation
import SwiftUI

// MARK: - MasteryLevel
//
// A view-only bucket derived from a `QuestionReview`'s SM-2 state at
// read time. No persistence — the source of truth stays
// `QuestionReview.bucket` + `.ease` + `.intervalDays`. The mastery
// dashboard groups review rows into these buckets for a one-glance
// readout of how confident the kid is on each chapter.
//
// Why a separate enum rather than reusing `QuestionReview.bucket`:
//   - `bucket` runs 0..5 and is internal scheduler state ("how many
//     successful reviews in a row"). It's not a good UI label — a kid
//     doesn't read "bucket 3" and learn anything.
//   - The display mapping ("3-4 successful reviews → Confident") is
//     itself a tunable that may change as we learn how the kid uses
//     the system. Keeping that mapping in one place — the
//     `from(review:)` static — means a single edit re-tints every
//     surface.
//   - Future surfaces (sidebar progress bar, chapter detail header
//     chip, mastery dashboard cells) all read the same mapping.

enum MasteryLevel: Int, Codable, CaseIterable, Hashable, Identifiable {
    case learning  = 0
    case familiar  = 1
    case confident = 2
    case mastered  = 3

    var id: Int { rawValue }

    /// Short, kid-friendly display name. Avoids "elementary" / "expert"
    /// language — these are stages on a learning curve, not grades.
    var displayName: String {
        switch self {
        case .learning:  return "Learning"
        case .familiar:  return "Familiar"
        case .confident: return "Confident"
        case .mastered:  return "Mastered"
        }
    }

    /// One-line caption that explains the level. Used in the mastery
    /// dashboard's legend + as the VoiceOver hint on each grid cell.
    var caption: String {
        switch self {
        case .learning:  return "Just introduced or last answer was forgot."
        case .familiar:  return "One or two correct in a row — still settling in."
        case .confident: return "Three or four correct in a row — review gap is widening."
        case .mastered:  return "Long-interval stable. Reviews come days or weeks apart."
        }
    }

    /// BrandColor-driven tint. Uses the existing deep-hue tokens so the
    /// dashboard passes WCAG on the standard surfaces — never a raw
    /// system primary.
    var tint: Color {
        switch self {
        case .learning:  return DesignTokens.BrandColor.canvasTextSecondary
        case .familiar:  return DesignTokens.BrandColor.mnemonicAccent
        case .confident: return Color.compatIndigo
        case .mastered:  return DesignTokens.BrandColor.primaryAction
        }
    }

    // MARK: - Derivation

    /// Map a single `QuestionReview` into a `MasteryLevel`. Tunable —
    /// the boundaries below come from the SM-2 scheduler's bucket
    /// semantics (see SM2Scheduler in DataStore.swift):
    ///
    ///   - bucket 0  → Learning (brand new OR last answer was Forgot)
    ///   - bucket 1..2 → Familiar (one or two correct in a row)
    ///   - bucket 3..4 → Confident
    ///   - bucket == 5 AND intervalDays >= 21 → Mastered
    ///
    /// The 21-day floor on Mastered prevents the kid from short-circuiting
    /// to "Mastered" via five Easy taps in a single session — Mastered
    /// requires the scheduler to have stretched the interval to at least
    /// three weeks, which only happens via repeated correct answers.
    static func from(review: QuestionReview) -> MasteryLevel {
        if review.totalReviews == 0 || review.bucket == 0 {
            return .learning
        }
        if review.bucket >= 5 && review.intervalDays >= 21 {
            return .mastered
        }
        if review.bucket >= 3 {
            return .confident
        }
        return .familiar
    }
}
