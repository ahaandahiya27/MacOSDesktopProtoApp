import XCTest
@testable import desktopAhaan

/// Pins `StreakBadge.shouldShow(streakDays:lastDate:today:)` — the
/// pure predicate that gates whether the chapter-list streak badge
/// is visible. Catches future regressions where the visibility
/// rules drift away from `DataStore.creditReviewStreak`'s
/// day-boundary math.
///
/// Visibility rules in scope:
///   - Hidden if `streakDays == 0`.
///   - Hidden if `lastDate` is empty (UserDefaults default).
///   - Hidden if `lastDate` is older than yesterday.
///   - Shown if `lastDate` is today.
///   - Shown if `lastDate` is yesterday (streak still alive).
final class StreakBadgeVisibilityTests: XCTestCase {

    private let today = ymd(year: 2026, month: 5, day: 26)

    func testHiddenWhenStreakDaysZero() {
        XCTAssertFalse(StreakBadge.shouldShow(streakDays: 0,
                                              lastDate: "2026-05-26",
                                              today: today))
    }

    func testHiddenWhenLastDateEmpty() {
        XCTAssertFalse(StreakBadge.shouldShow(streakDays: 5,
                                              lastDate: "",
                                              today: today))
    }

    func testShownWhenLastDateIsToday() {
        XCTAssertTrue(StreakBadge.shouldShow(streakDays: 1,
                                             lastDate: "2026-05-26",
                                             today: today))
        XCTAssertTrue(StreakBadge.shouldShow(streakDays: 42,
                                             lastDate: "2026-05-26",
                                             today: today))
    }

    func testShownWhenLastDateIsYesterday() {
        XCTAssertTrue(StreakBadge.shouldShow(streakDays: 3,
                                             lastDate: "2026-05-25",
                                             today: today))
    }

    func testHiddenWhenLastDateIsTwoDaysAgo() {
        XCTAssertFalse(StreakBadge.shouldShow(streakDays: 7,
                                              lastDate: "2026-05-24",
                                              today: today),
            "Two-day gap means the next review resets the counter — " +
            "the displayed streak value would mislead.")
    }

    func testHiddenWhenLastDateIsAYearAgo() {
        XCTAssertFalse(StreakBadge.shouldShow(streakDays: 365,
                                              lastDate: "2025-05-26",
                                              today: today))
    }

    // MARK: - Helpers

    private static func ymd(year: Int, month: Int, day: Int) -> Date {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = TimeZone.current
        let comps = DateComponents(year: year, month: month, day: day)
        return cal.date(from: comps) ?? Date()
    }
}
