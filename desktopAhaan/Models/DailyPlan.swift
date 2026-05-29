import Foundation

// MARK: - Daily Plan model
//
// The "today's 5 things" adaptive plan: 3 SRS reviews due now, 1 unmastered
// concept to read, 1 Discover scene to attempt. Pure value types so the
// rollup + reconciliation logic is unit-testable without standing up the
// app. The DataStore-coupled construction lives in `DataStore+DailyPlan`.
//
// Big Sur compatible: Foundation-only value types, no macOS 12+ APIs.

/// The three kinds of plan item. Raw values are the persistence contract
/// (they land in `dailyplan.json`) — never rename a shipped case.
enum DailyPlanItemKind: String, Codable, Hashable {
    case review     // an SRS question due now
    case concept    // an unmastered concept to read
    case discover   // a Discover scene/chapter to attempt

    /// Version-independent glyph (no `SFSymbolCompat` routing needed — these
    /// are emoji, not SF Symbols).
    var emoji: String {
        switch self {
        case .review:   return "🔁"
        case .concept:  return "💡"
        case .discover: return "🚀"
        }
    }

    var sectionLabel: String {
        switch self {
        case .review:   return "Review"
        case .concept:  return "Learn"
        case .discover: return "Discover"
        }
    }
}

/// One actionable row in the plan. `targetId` is the questionId / conceptId /
/// chapterId the row navigates to; `packId` scopes the navigation route.
struct DailyPlanItem: Identifiable, Codable, Hashable {
    let id: String              // "<kind>:<packId>:<targetId>" — stable per plan-day
    let kind: DailyPlanItemKind
    let packId: String
    let targetId: String
    let title: String
    let subtitle: String
    var isDone: Bool
    var isSkipped: Bool

    /// For `.discover` rows: the chapter's completed-scene count captured at
    /// plan build time, so reconciliation can detect "a new scene was
    /// finished today" without knowing which scene. nil for other kinds.
    var discoverBaselineScenes: Int?

    init(kind: DailyPlanItemKind, packId: String, targetId: String,
         title: String, subtitle: String,
         isDone: Bool = false, isSkipped: Bool = false,
         discoverBaselineScenes: Int? = nil) {
        self.id = "\(kind.rawValue):\(packId):\(targetId)"
        self.kind = kind
        self.packId = packId
        self.targetId = targetId
        self.title = title
        self.subtitle = subtitle
        self.isDone = isDone
        self.isSkipped = isSkipped
        self.discoverBaselineScenes = discoverBaselineScenes
    }

    /// Still needs the kid's attention (neither finished nor dismissed).
    var isActionable: Bool { !isDone && !isSkipped }
}

/// A whole day's plan. `planDay` is the 3 AM-boundary start-of-day this plan
/// belongs to (see `DailyPlan.planDay(for:)`); a stored plan whose `planDay`
/// no longer matches "now" is stale and gets rebuilt.
struct DailyPlan: Codable, Hashable {
    let planDay: Date
    var items: [DailyPlanItem]

    /// Items the kid actually finished (Done — skipped doesn't count).
    var doneCount: Int { items.filter { $0.isDone }.count }

    /// Items still needing attention.
    var remainingCount: Int { items.filter { $0.isActionable }.count }

    /// Total items in the plan (typically 5).
    var itemCount: Int { items.count }

    /// "Cleared the plan": every item is dealt with (done or skipped) and at
    /// least one was actually done. This is the streak driver — a kid who
    /// skips everything hasn't completed their plan. Documented on the
    /// `quiz_practice_perfect_week` badge.
    var isComplete: Bool {
        !items.isEmpty
            && items.allSatisfy { !$0.isActionable }
            && items.contains { $0.isDone }
    }

    // MARK: - Plan-day boundary

    /// The 3 AM-local boundary the brief specifies: a plan "rolls over" at
    /// 3 AM, so anything done between midnight and 3 AM still counts toward
    /// the previous calendar day's plan. Implemented by shifting `now` back
    /// 3 hours and taking the start of that day, so two instants share a
    /// plan-day iff this value is equal.
    static let rolloverHour = 3

    static func planDay(for now: Date, calendar: Calendar = .current) -> Date {
        let shifted = calendar.date(byAdding: .hour, value: -rolloverHour, to: now) ?? now
        return calendar.startOfDay(for: shifted)
    }

    /// True when `now` falls inside this plan's plan-day.
    func covers(_ now: Date, calendar: Calendar = .current) -> Bool {
        DailyPlan.planDay(for: now, calendar: calendar) == planDay
    }
}

// MARK: - Persistence keys

/// UserDefaults keys for the Daily Plan streak + the notification opt-in.
/// Kept here (not in `AppStorageKeys`, which is owned by another surface) so
/// the whole Daily Plan feature stays inside this agent's files. The streak
/// is a `UserDefaults` int so `AchievementEngine` can read it for the
/// `quiz_practice_perfect_week` badge without loading the plan file.
enum DailyPlanStorage {
    /// Consecutive plan-days the kid completed their whole plan.
    static let streakKey = "dailyPlanStreakDays"
    /// ISO-day string of the last completed plan-day (dedupes same-day credit).
    static let streakLastDayKey = "dailyPlanStreakLastDay"
    /// All-time best plan-completion streak.
    static let streakBestKey = "dailyPlanStreakBest"

    /// Whether the 5pm daily reminder is enabled. Default OFF — opt-in.
    static let reminderEnabledKey = "dailyPlanReminderEnabled"
    /// Whether we've already asked for notification permission once, so the
    /// opt-in prompt doesn't nag on every Daily Plan open.
    static let notifPermissionAskedKey = "dailyPlanNotifPermissionAsked"
}
