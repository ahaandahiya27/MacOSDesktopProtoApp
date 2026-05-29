import Foundation
import SwiftUI

// MARK: - Achievement / Badge system
//
// 24 badges across 5 families × 4 tiers. The whole model is pure value
// types so the unlock logic is unit-testable without any FS I/O, AppKit,
// or DataStore. The engine (`AchievementEngine`) builds an
// `AchievementSnapshot` from the live `DataStore` + `SubjectRegistry` and
// asks each `Achievement.criterion` whether it's satisfied.
//
// Big Sur compatible: plain enums/structs, no @Observable, no macOS 12+
// APIs, no Combine in this file. Colors route through `Color.compat*` /
// `DesignTokens.BrandColor.*` (never a raw `Color.yellow` on text). SF
// Symbols are not used here — badges render their `emoji` glyph, which is
// version-independent.

/// Four achievement tiers, ordered worst → best so `rawValue` doubles as
/// a sort key. The tint is used for the unlocked badge's ring + the
/// gallery sort grouping.
enum AchievementTier: Int, Codable, CaseIterable, Hashable, Identifiable {
    case bronze = 0
    case silver = 1
    case gold = 2
    case platinum = 3

    var id: Int { rawValue }

    var displayName: String {
        switch self {
        case .bronze:   return "Bronze"
        case .silver:   return "Silver"
        case .gold:     return "Gold"
        case .platinum: return "Platinum"
        }
    }

    /// Deep, WCAG-friendly tints — never a raw system primary. Bronze /
    /// silver / gold / platinum read as warm-brown / slate / deep-gold /
    /// indigo so they stay distinct for a colour-blind kid too.
    var tint: Color {
        switch self {
        case .bronze:   return Color.compatBrown
        case .silver:   return DesignTokens.BrandColor.canvasTextSecondary
        case .gold:     return DesignTokens.BrandColor.mnemonic
        case .platinum: return Color.compatIndigo
        }
    }

    /// Whether unlocking a badge at this tier should play the short
    /// celebratory sound. Per the brief, only gold + platinum chime.
    var playsCelebrationSound: Bool {
        self == .gold || self == .platinum
    }
}

/// The five badge families. Used only for grouping / display order in the
/// gallery; the unlock logic lives entirely in `AchievementCriterion`.
enum AchievementFamily: Int, CaseIterable, Hashable, Identifiable {
    case streak = 0
    case mastery = 1
    case discover = 2
    case article = 3
    case quiz = 4

    var id: Int { rawValue }

    var displayName: String {
        switch self {
        case .streak:   return "Streaks"
        case .mastery:  return "Mastery"
        case .discover: return "Discover"
        case .article:  return "Reading"
        case .quiz:     return "Quizzes"
        }
    }
}

// MARK: - Snapshot

/// A frozen read of every metric the 24 criteria need. Built by
/// `AchievementEngine.snapshot()` from `DataStore` + `SubjectRegistry`
/// state; passed by value into the pure criterion evaluator so tests can
/// construct any world directly without standing up the app.
struct AchievementSnapshot: Hashable {
    // Streak — read from the all-time best so a lapsed streak still
    // counts toward the streak badges (a badge, once earned, stays).
    var bestStreakDays: Int = 0

    // Mastery — "mastered concept" == a concept the kid has explicitly
    // marked understood (the thumbs-up on ConceptDetailView). Chapter /
    // subject "fully mastered" == every concept id in that scope is in
    // the understood set.
    var conceptsMastered: Int = 0
    var chaptersFullyMastered: Int = 0
    var subjectsFullyMastered: Int = 0

    // Discover — scene completions + per-chapter completion counts
    // (Science host pack). `discoverChaptersComplete` counts chapters
    // whose completed-scene count has reached that chapter's authored
    // scene total.
    var discoverScenesCompleted: Int = 0
    var discoverChaptersComplete: Int = 0

    // Articles — total read + the count of distinct Science chapters for
    // which the "Beyond the Book" article (`chNN_beyond`) has been read.
    var articlesRead: Int = 0
    var beyondTheBookChaptersRead: Int = 0

    // Quiz — distinct chapters with at least one Boss-Quiz review on
    // record (engaged ≈ attempted/passed; see `bossQuizzesPassed`
    // doc on the criterion). Plus the two "perfect" flags.
    var bossQuizzesPassed: Int = 0
    var quickCheckPerfectDay: Bool = false
    var dailyPracticePerfectWeek: Bool = false
}

// MARK: - Progress

/// The result of evaluating a criterion against a snapshot. Carries the
/// `current` / `target` pair so the gallery can render a "3 / 10"
/// progress hint and auto-hide badges the kid hasn't started
/// (`hasStarted == false`).
struct AchievementProgress: Hashable {
    let current: Int
    let target: Int

    /// Unlocked once the current value reaches the target.
    var isUnlocked: Bool { current >= target }

    /// True once the kid has made ANY progress toward this badge. The
    /// gallery uses this to keep not-yet-started badges out of view so
    /// the case grows over time rather than showing 24 grey cells on
    /// day one.
    var hasStarted: Bool { current > 0 }

    /// 0…1 completion fraction, clamped. `target == 0` reads as complete
    /// (defensive — no criterion ships a zero target).
    var fraction: Double {
        guard target > 0 else { return 1 }
        return min(1.0, Double(current) / Double(target))
    }
}

// MARK: - Criterion

/// Every unlock rule, modelled as a metric + threshold (or a boolean
/// flag). `progress(in:)` is a pure function of the snapshot so the
/// whole system is testable by constructing snapshots directly.
enum AchievementCriterion: Hashable {
    case bestStreakAtLeast(Int)
    case conceptsMasteredAtLeast(Int)
    case chaptersFullyMasteredAtLeast(Int)
    case subjectsFullyMasteredAtLeast(Int)
    case discoverScenesAtLeast(Int)
    case discoverChaptersCompleteAtLeast(Int)
    case articlesReadAtLeast(Int)
    case beyondTheBookChaptersAtLeast(Int)
    case bossQuizzesPassedAtLeast(Int)
    case quickCheckPerfectDay
    case dailyPracticePerfectWeek

    func progress(in s: AchievementSnapshot) -> AchievementProgress {
        switch self {
        case .bestStreakAtLeast(let n):
            return AchievementProgress(current: s.bestStreakDays, target: n)
        case .conceptsMasteredAtLeast(let n):
            return AchievementProgress(current: s.conceptsMastered, target: n)
        case .chaptersFullyMasteredAtLeast(let n):
            return AchievementProgress(current: s.chaptersFullyMastered, target: n)
        case .subjectsFullyMasteredAtLeast(let n):
            return AchievementProgress(current: s.subjectsFullyMastered, target: n)
        case .discoverScenesAtLeast(let n):
            return AchievementProgress(current: s.discoverScenesCompleted, target: n)
        case .discoverChaptersCompleteAtLeast(let n):
            return AchievementProgress(current: s.discoverChaptersComplete, target: n)
        case .articlesReadAtLeast(let n):
            return AchievementProgress(current: s.articlesRead, target: n)
        case .beyondTheBookChaptersAtLeast(let n):
            return AchievementProgress(current: s.beyondTheBookChaptersRead, target: n)
        case .bossQuizzesPassedAtLeast(let n):
            return AchievementProgress(current: s.bossQuizzesPassed, target: n)
        case .quickCheckPerfectDay:
            return AchievementProgress(current: s.quickCheckPerfectDay ? 1 : 0, target: 1)
        case .dailyPracticePerfectWeek:
            return AchievementProgress(current: s.dailyPracticePerfectWeek ? 1 : 0, target: 1)
        }
    }
}

// MARK: - Achievement

/// One badge. `id` is the stable persistence key (never change a shipped
/// id — `AchievementCatalogRatchetTests` pins all 24). `criterion` drives
/// both the unlock check and the gallery progress hint.
struct Achievement: Identifiable, Hashable {
    let id: String
    let title: String
    /// One-line "how to earn this" shown on locked cells + the detail
    /// sheet. Kid-friendly, imperative, no jargon.
    let detail: String
    let tier: AchievementTier
    let family: AchievementFamily
    /// Display glyph — version-independent, so no `SFSymbolCompat`
    /// routing needed.
    let emoji: String
    let criterion: AchievementCriterion

    func progress(in snapshot: AchievementSnapshot) -> AchievementProgress {
        criterion.progress(in: snapshot)
    }

    func isUnlocked(in snapshot: AchievementSnapshot) -> Bool {
        criterion.progress(in: snapshot).isUnlocked
    }
}

// MARK: - The 24-badge catalog

extension Achievement {

    /// The canonical badge set. Order here is the gallery's display order
    /// (family, then ascending threshold). Ids + count are pinned by
    /// `AchievementCatalogRatchetTests`.
    static let all: [Achievement] = streakFamily + masteryFamily
        + discoverFamily + articleFamily + quizFamily

    /// `id → Achievement` lookup. Duplicate-id-safe (keeps first) — the
    /// ratchet test proves there are no duplicates, but the runtime path
    /// stays soft so a future typo can't crash the gallery.
    static let byId: [String: Achievement] = Dictionary(
        all.map { ($0.id, $0) }, uniquingKeysWith: { first, _ in first }
    )

    // 🔥 Streak family (6)
    static let streakFamily: [Achievement] = [
        Achievement(id: "streak_first_day", title: "First Day",
                    detail: "Answer a practice question on any day to start your streak.",
                    tier: .bronze, family: .streak, emoji: "🔥",
                    criterion: .bestStreakAtLeast(1)),
        Achievement(id: "streak_7", title: "Week Warrior",
                    detail: "Practise 7 days in a row.",
                    tier: .bronze, family: .streak, emoji: "🔥",
                    criterion: .bestStreakAtLeast(7)),
        Achievement(id: "streak_14", title: "Two-Week Streak",
                    detail: "Practise 14 days in a row.",
                    tier: .silver, family: .streak, emoji: "🔥",
                    criterion: .bestStreakAtLeast(14)),
        Achievement(id: "streak_30", title: "Month of Momentum",
                    detail: "Practise 30 days in a row.",
                    tier: .silver, family: .streak, emoji: "🔥",
                    criterion: .bestStreakAtLeast(30)),
        Achievement(id: "streak_60", title: "Unstoppable",
                    detail: "Practise 60 days in a row.",
                    tier: .gold, family: .streak, emoji: "🔥",
                    criterion: .bestStreakAtLeast(60)),
        Achievement(id: "streak_100", title: "Century Streak",
                    detail: "Practise 100 days in a row.",
                    tier: .platinum, family: .streak, emoji: "🔥",
                    criterion: .bestStreakAtLeast(100))
    ]

    // 🌱 Mastery family (6)
    static let masteryFamily: [Achievement] = [
        Achievement(id: "mastery_1", title: "First Spark",
                    detail: "Mark your first concept as understood.",
                    tier: .bronze, family: .mastery, emoji: "🌱",
                    criterion: .conceptsMasteredAtLeast(1)),
        Achievement(id: "mastery_10", title: "Ten Down",
                    detail: "Understand 10 concepts.",
                    tier: .silver, family: .mastery, emoji: "🌿",
                    criterion: .conceptsMasteredAtLeast(10)),
        Achievement(id: "mastery_50", title: "Half a Hundred",
                    detail: "Understand 50 concepts.",
                    tier: .gold, family: .mastery, emoji: "🌳",
                    criterion: .conceptsMasteredAtLeast(50)),
        Achievement(id: "mastery_100", title: "Century of Concepts",
                    detail: "Understand 100 concepts.",
                    tier: .platinum, family: .mastery, emoji: "🏵️",
                    criterion: .conceptsMasteredAtLeast(100)),
        Achievement(id: "mastery_chapter", title: "Chapter Champion",
                    detail: "Understand every concept in one chapter.",
                    tier: .silver, family: .mastery, emoji: "📗",
                    criterion: .chaptersFullyMasteredAtLeast(1)),
        Achievement(id: "mastery_subject", title: "Subject Master",
                    detail: "Understand every concept in a whole subject.",
                    tier: .gold, family: .mastery, emoji: "🎓",
                    criterion: .subjectsFullyMasteredAtLeast(1))
    ]

    // 🚀 Discover family (4)
    static let discoverFamily: [Achievement] = [
        Achievement(id: "discover_first", title: "Lift-Off",
                    detail: "Finish your first Discover scene.",
                    tier: .bronze, family: .discover, emoji: "🚀",
                    criterion: .discoverScenesAtLeast(1)),
        Achievement(id: "discover_chapter", title: "Scene Explorer",
                    detail: "Complete every Discover scene in one chapter.",
                    tier: .silver, family: .discover, emoji: "🧭",
                    criterion: .discoverChaptersCompleteAtLeast(1)),
        Achievement(id: "discover_5_chapters", title: "Five-Chapter Voyager",
                    detail: "Complete Discover Mode in 5 chapters.",
                    tier: .gold, family: .discover, emoji: "🛰️",
                    criterion: .discoverChaptersCompleteAtLeast(5)),
        Achievement(id: "discover_all_science", title: "Discover Master",
                    detail: "Complete Discover Mode in all 19 Science chapters.",
                    tier: .platinum, family: .discover, emoji: "🌌",
                    criterion: .discoverChaptersCompleteAtLeast(19))
    ]

    // 📖 Article family (4)
    static let articleFamily: [Achievement] = [
        Achievement(id: "article_first", title: "First Read",
                    detail: "Read your first article.",
                    tier: .bronze, family: .article, emoji: "📖",
                    criterion: .articlesReadAtLeast(1)),
        Achievement(id: "article_10", title: "Bookworm",
                    detail: "Read 10 articles.",
                    tier: .silver, family: .article, emoji: "📚",
                    criterion: .articlesReadAtLeast(10)),
        Achievement(id: "article_50", title: "Library Legend",
                    detail: "Read 50 articles.",
                    tier: .gold, family: .article, emoji: "🏛️",
                    criterion: .articlesReadAtLeast(50)),
        Achievement(id: "article_beyond_each_chapter", title: "Beyond the Book",
                    detail: "Read the Beyond-the-Book article for all 19 Science chapters.",
                    tier: .platinum, family: .article, emoji: "🔭",
                    criterion: .beyondTheBookChaptersAtLeast(19))
    ]

    // 🏆 Quiz family (4)
    static let quizFamily: [Achievement] = [
        Achievement(id: "quiz_boss_first", title: "Boss Beaten",
                    detail: "Take on your first Boss Quiz.",
                    tier: .bronze, family: .quiz, emoji: "🏆",
                    criterion: .bossQuizzesPassedAtLeast(1)),
        Achievement(id: "quiz_boss_10", title: "Boss Hunter",
                    detail: "Take on Boss Quizzes in 10 chapters.",
                    tier: .gold, family: .quiz, emoji: "👑",
                    criterion: .bossQuizzesPassedAtLeast(10)),
        Achievement(id: "quiz_quickcheck_perfect_day", title: "Sharp Shooter",
                    detail: "Get a perfect day on your quick-checks (3+ correct, none missed).",
                    tier: .silver, family: .quiz, emoji: "🎯",
                    criterion: .quickCheckPerfectDay),
        Achievement(id: "quiz_practice_perfect_week", title: "Perfect Week",
                    detail: "Finish your whole Daily Plan 7 days in a row.",
                    tier: .platinum, family: .quiz, emoji: "🌟",
                    criterion: .dailyPracticePerfectWeek)
    ]
}
