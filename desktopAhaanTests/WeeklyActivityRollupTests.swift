import XCTest
@testable import desktopAhaan

/// Pins the `DataStore.weeklyActivity(endingAt:)` rollup shipped in the
/// Parent / Weekly Progress Dashboard sweep (2026-05-29). Verifies the
/// day-bucketing math, per-subject attribution, the inclusive/exclusive
/// window boundary, concept-visit counting, discover attribution, the
/// mastery delta, and the minute estimate.
///
/// Uses the `storeDir:` + `autoLoad: false` init for isolation and a
/// fixed UTC Gregorian calendar so the day math is deterministic
/// regardless of the runner's timezone.
@MainActor
final class WeeklyActivityRollupTests: XCTestCase {

    private var tmp: URL!
    private var store: DataStore!

    /// Fixed UTC calendar — all day boundaries land predictably.
    private var cal: Calendar = {
        var c = Calendar(identifier: .gregorian)
        c.timeZone = TimeZone(identifier: "UTC")!
        return c
    }()

    /// 2026-05-29 12:00:00 UTC — a stable "now" for the window.
    private var endDate: Date!

    override func setUp() async throws {
        try await super.setUp()
        tmp = URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent("desktopAhaan-weekly-\(UUID().uuidString)")
        try FileManager.default.createDirectory(at: tmp, withIntermediateDirectories: true)
        store = DataStore(streakCalendar: nil, storeDir: tmp, autoLoad: false)
        var comps = DateComponents()
        comps.year = 2026; comps.month = 5; comps.day = 29
        comps.hour = 12; comps.minute = 0; comps.second = 0
        endDate = cal.date(from: comps)!
    }

    override func tearDown() async throws {
        try? FileManager.default.removeItem(at: tmp)
        store = nil
        tmp = nil
        try await super.tearDown()
    }

    // MARK: - Helpers

    /// Build a review whose `lastReviewedAt` is `daysAgo` whole days
    /// before `endDate` (at the same time-of-day) with the SM-2 state
    /// that maps to the requested mastery level.
    private func seedReview(
        _ id: String, packId: String?, daysAgo: Int,
        bucket: Int = 1, intervalDays: Int = 1, totalReviews: Int = 1
    ) {
        let when = cal.date(byAdding: .day, value: -daysAgo, to: endDate)!
        store.questionReviews[id] = QuestionReview(
            questionId: id, bucket: bucket, ease: 2.5,
            intervalDays: intervalDays, lastReviewedAt: when,
            nextDueAt: when, totalReviews: totalReviews, lapses: 0, packId: packId
        )
    }

    private func seedDiscover(chapterId: String, sceneId: String, daysAgo: Int) {
        let row = DiscoverProgress(chapterId: chapterId, sceneId: sceneId)
        row.completedAt = cal.date(byAdding: .day, value: -daysAgo, to: endDate)!
        store.discoverProgress.append(row)
    }

    // MARK: - Shape

    func testEmptyRollupHasSevenEmptyDays() {
        let activity = store.weeklyActivity(endingAt: endDate, calendar: cal)
        XCTAssertEqual(activity.days.count, 7, "Rollup is always exactly 7 days.")
        XCTAssertEqual(activity.totalReviews, 0)
        XCTAssertEqual(activity.totalConcepts, 0)
        XCTAssertEqual(activity.totalDiscoverScenes, 0)
        XCTAssertFalse(activity.hasAnyActivity)
        XCTAssertTrue(activity.days.allSatisfy { $0.isEmpty })
        XCTAssertTrue(activity.masteryDelta.isEmpty)
    }

    func testDaysAreOldestFirstAndStartOfDay() {
        let activity = store.weeklyActivity(endingAt: endDate, calendar: cal)
        // days[6] is today's start-of-day; days[0] is six days earlier.
        XCTAssertEqual(activity.days.last!.date, cal.startOfDay(for: endDate))
        XCTAssertEqual(activity.weekStart, activity.days.first!.date)
        let expectedStart = cal.date(byAdding: .day, value: -6, to: cal.startOfDay(for: endDate))!
        XCTAssertEqual(activity.weekStart, expectedStart)
        // Strictly increasing.
        for i in 1..<activity.days.count {
            XCTAssertLessThan(activity.days[i - 1].date, activity.days[i].date)
        }
    }

    // MARK: - Review bucketing

    func testReviewsBucketByDayAndPackWithWeekTotals() {
        // 14 reviews across 5 days, 3 packs.
        // Day 0 (today): 3 science, 2 maths
        seedReview("q1", packId: "science_class7", daysAgo: 0)
        seedReview("q2", packId: "science_class7", daysAgo: 0)
        seedReview("q3", packId: "science_class7", daysAgo: 0)
        seedReview("q4", packId: "maths_class7", daysAgo: 0)
        seedReview("q5", packId: "maths_class7", daysAgo: 0)
        // Day 1: 2 sanskrit
        seedReview("q6", packId: "sanskrit_class7", daysAgo: 1)
        seedReview("q7", packId: "sanskrit_class7", daysAgo: 1)
        // Day 3: 3 science
        seedReview("q8", packId: "science_class7", daysAgo: 3)
        seedReview("q9", packId: "science_class7", daysAgo: 3)
        seedReview("q10", packId: "science_class7", daysAgo: 3)
        // Day 5: 1 maths, 1 sanskrit
        seedReview("q11", packId: "maths_class7", daysAgo: 5)
        seedReview("q12", packId: "sanskrit_class7", daysAgo: 5)
        // Day 6 boundary edge: 2 science
        seedReview("q13", packId: "science_class7", daysAgo: 6)
        seedReview("q14", packId: "science_class7", daysAgo: 6)

        let activity = store.weeklyActivity(endingAt: endDate, calendar: cal)
        XCTAssertEqual(activity.totalReviews, 14)
        XCTAssertTrue(activity.hasAnyActivity)

        // Today (days[6]) = 3 science + 2 maths.
        let today = activity.days[6]
        XCTAssertEqual(today.perSubject["science_class7"]?.reviews, 3)
        XCTAssertEqual(today.perSubject["maths_class7"]?.reviews, 2)
        XCTAssertNil(today.perSubject["sanskrit_class7"])

        // daysAgo:1 → index 5.
        XCTAssertEqual(activity.days[5].perSubject["sanskrit_class7"]?.reviews, 2)
        // daysAgo:3 → index 3.
        XCTAssertEqual(activity.days[3].perSubject["science_class7"]?.reviews, 3)
        // daysAgo:6 → index 0 (oldest day still in window).
        XCTAssertEqual(activity.days[0].perSubject["science_class7"]?.reviews, 2)
    }

    // MARK: - Window boundary

    func testReviewExactlyAtEndDateIncludedAndOneSecondLaterExcluded() {
        store.questionReviews["onEdge"] = QuestionReview(
            questionId: "onEdge", bucket: 1, ease: 2.5, intervalDays: 1,
            lastReviewedAt: endDate, nextDueAt: endDate,
            totalReviews: 1, lapses: 0, packId: "science_class7")
        store.questionReviews["future"] = QuestionReview(
            questionId: "future", bucket: 1, ease: 2.5, intervalDays: 1,
            lastReviewedAt: endDate.addingTimeInterval(1),
            nextDueAt: endDate, totalReviews: 1, lapses: 0, packId: "science_class7")

        let activity = store.weeklyActivity(endingAt: endDate, calendar: cal)
        XCTAssertEqual(activity.totalReviews, 1,
            "Review at exactly endDate counts; one a second later is out of window.")
    }

    func testReviewSevenDaysAgoIsOutsideWindow() {
        // daysAgo:7 falls before the oldest in-window day (days[0] is
        // six days back at start-of-day). A review 7 whole days before
        // endDate's time-of-day is earlier than that start-of-day.
        seedReview("old", packId: "science_class7", daysAgo: 7)
        let activity = store.weeklyActivity(endingAt: endDate, calendar: cal)
        XCTAssertEqual(activity.totalReviews, 0)
    }

    // MARK: - Concept visits

    func testConceptVisitsCountPerDayAndPack() {
        store.recordConceptVisit(id: "c1", packId: "science_class7",
                                 at: cal.date(byAdding: .day, value: 0, to: endDate)!)
        store.recordConceptVisit(id: "c2", packId: "science_class7",
                                 at: endDate)
        store.recordConceptVisit(id: "c3", packId: "maths_class7",
                                 at: cal.date(byAdding: .day, value: -2, to: endDate)!)

        let activity = store.weeklyActivity(endingAt: endDate, calendar: cal)
        XCTAssertEqual(activity.totalConcepts, 3)
        XCTAssertEqual(activity.days[6].perSubject["science_class7"]?.conceptsVisited, 2)
        XCTAssertEqual(activity.days[4].perSubject["maths_class7"]?.conceptsVisited, 1)
    }

    func testRevisitingSameConceptCountsOnce() {
        // Two visits to the same concept on the same day → last-visit-wins,
        // so it counts once (conceptVisitHistory is keyed by concept id).
        store.recordConceptVisit(id: "c1", packId: "science_class7",
                                 at: endDate.addingTimeInterval(-3600))
        store.recordConceptVisit(id: "c1", packId: "science_class7", at: endDate)
        let activity = store.weeklyActivity(endingAt: endDate, calendar: cal)
        XCTAssertEqual(activity.totalConcepts, 1)
    }

    // MARK: - Discover attribution

    func testDiscoverScenesAttributedToHostPack() {
        seedDiscover(chapterId: "ch01", sceneId: "scene1", daysAgo: 0)
        seedDiscover(chapterId: "ch01", sceneId: "scene2", daysAgo: 0)
        seedDiscover(chapterId: "ch04", sceneId: "scene1", daysAgo: 2)

        let activity = store.weeklyActivity(endingAt: endDate, calendar: cal)
        XCTAssertEqual(activity.totalDiscoverScenes, 3)
        XCTAssertEqual(activity.days[6].perSubject[DiscoverMode.hostPackId]?.discoverScenesCompleted, 2)
        XCTAssertEqual(activity.days[4].perSubject[DiscoverMode.hostPackId]?.discoverScenesCompleted, 1)
        // topChapter on today's host-pack activity is ch01 (2 scenes > ch04 0 today).
        XCTAssertEqual(activity.days[6].perSubject[DiscoverMode.hostPackId]?.topChapter, "ch01")
    }

    // MARK: - Mastery delta

    func testMasteryDeltaCountsConfidentAndMasteredExcludesLearning() {
        // Mastered: bucket>=5 && intervalDays>=21.
        seedReview("m1", packId: "science_class7", daysAgo: 0,
                   bucket: 5, intervalDays: 21, totalReviews: 4)
        // Confident: bucket>=3 (but not mastered).
        seedReview("c1", packId: "science_class7", daysAgo: 1,
                   bucket: 3, intervalDays: 5, totalReviews: 3)
        seedReview("c2", packId: "maths_class7", daysAgo: 1,
                   bucket: 4, intervalDays: 8, totalReviews: 3)
        // Familiar: bucket 1..2 with reviews.
        seedReview("f1", packId: "science_class7", daysAgo: 2,
                   bucket: 1, intervalDays: 1, totalReviews: 1)
        // Learning: bucket 0 → excluded from the delta.
        seedReview("l1", packId: "science_class7", daysAgo: 0,
                   bucket: 0, intervalDays: 0, totalReviews: 0)

        let delta = store.weeklyActivity(endingAt: endDate, calendar: cal).masteryDelta
        XCTAssertEqual(delta.newMastered, 1)
        XCTAssertEqual(delta.newConfident, 2)
        XCTAssertEqual(delta.newFamiliar, 1)
        XCTAssertFalse(delta.isEmpty)
    }

    // MARK: - Minute estimate

    func testMinuteEstimateMatchesFormula() {
        // 4 reviews (×0.5 = 2) + 2 concepts (×2 = 4) + 1 discover (×3 = 3) = 9 min.
        seedReview("q1", packId: "science_class7", daysAgo: 0)
        seedReview("q2", packId: "science_class7", daysAgo: 0)
        seedReview("q3", packId: "science_class7", daysAgo: 0)
        seedReview("q4", packId: "science_class7", daysAgo: 0)
        store.recordConceptVisit(id: "c1", packId: "science_class7", at: endDate)
        store.recordConceptVisit(id: "c2", packId: "science_class7", at: endDate)
        seedDiscover(chapterId: "ch01", sceneId: "scene1", daysAgo: 0)

        let activity = store.weeklyActivity(endingAt: endDate, calendar: cal)
        XCTAssertEqual(activity.days[6].totalMinutesEstimate, 9)
        XCTAssertEqual(activity.totalMinutesEstimate, 9)
    }

    // MARK: - Streak passthrough

    func testStreakReadFromDefaults() {
        UserDefaults.standard.set(5, forKey: AppStorageKeys.reviewStreakDays)
        UserDefaults.standard.set(12, forKey: AppStorageKeys.reviewStreakBest)
        defer {
            UserDefaults.standard.removeObject(forKey: AppStorageKeys.reviewStreakDays)
            UserDefaults.standard.removeObject(forKey: AppStorageKeys.reviewStreakBest)
        }
        let activity = store.weeklyActivity(endingAt: endDate, calendar: cal)
        XCTAssertEqual(activity.streakDays, 5)
        XCTAssertEqual(activity.streakBest, 12)
    }
}
