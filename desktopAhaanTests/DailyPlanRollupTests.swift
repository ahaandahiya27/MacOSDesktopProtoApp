import XCTest
@testable import desktopAhaan

/// Exercises the Daily Plan model (3 AM plan-day boundary, completion
/// semantics), the pure reconcile/streak helpers, and the DataStore-coupled
/// build/round-trip on a temp store. Deterministic — fixed UTC calendar +
/// temp store dirs + save/restore of the streak UserDefaults keys.
@MainActor
final class DailyPlanRollupTests: XCTestCase {

    private var utc: Calendar {
        var c = Calendar(identifier: .gregorian)
        c.timeZone = TimeZone(identifier: "UTC")!
        return c
    }

    private func tempStore() -> DataStore {
        let dir = FileManager.default.temporaryDirectory
            .appendingPathComponent("dp-\(UUID().uuidString)")
        return DataStore(streakCalendar: nil, storeDir: dir, autoLoad: false)
    }

    private func review(_ id: String, dueAt: Date) -> QuestionReview {
        QuestionReview(questionId: id, bucket: 1, ease: 2.5, intervalDays: 1,
                       lastReviewedAt: dueAt, nextDueAt: dueAt,
                       totalReviews: 1, lapses: 0)
    }

    private func date(_ y: Int, _ m: Int, _ d: Int, _ h: Int, _ min: Int = 0) -> Date {
        var c = DateComponents()
        c.year = y; c.month = m; c.day = d; c.hour = h; c.minute = min
        return utc.date(from: c)!
    }

    // MARK: - Plan-day boundary (3 AM rollover)

    func testPlanDayRollsOverAt3AM() {
        // 2 AM on May 30 belongs to the May 29 plan-day (before rollover).
        let twoAM = date(2026, 5, 30, 2)
        let elevenPMprev = date(2026, 5, 29, 23)
        XCTAssertEqual(DailyPlan.planDay(for: twoAM, calendar: utc),
                       DailyPlan.planDay(for: elevenPMprev, calendar: utc),
                       "Pre-3 AM should share the previous day's plan-day.")

        // 4 AM on May 30 starts a new plan-day.
        let fourAM = date(2026, 5, 30, 4)
        XCTAssertNotEqual(DailyPlan.planDay(for: fourAM, calendar: utc),
                          DailyPlan.planDay(for: twoAM, calendar: utc),
                          "Post-3 AM should be a new plan-day.")
    }

    func testCoversMatchesPlanDay() {
        let plan = DailyPlan(planDay: DailyPlan.planDay(for: date(2026, 5, 30, 10), calendar: utc),
                             items: [])
        XCTAssertTrue(plan.covers(date(2026, 5, 30, 20), calendar: utc))
        XCTAssertTrue(plan.covers(date(2026, 5, 31, 2), calendar: utc))   // before next 3 AM
        XCTAssertFalse(plan.covers(date(2026, 5, 31, 4), calendar: utc))  // after next 3 AM
    }

    // MARK: - Completion semantics

    func testIsCompleteRequiresAtLeastOneDoneAndNoneActionable() {
        func item(_ id: String, done: Bool, skip: Bool) -> DailyPlanItem {
            DailyPlanItem(kind: .review, packId: "p", targetId: id,
                          title: id, subtitle: "", isDone: done, isSkipped: skip)
        }
        let day = DailyPlan.planDay(for: date(2026, 5, 30, 10), calendar: utc)

        // All done → complete.
        XCTAssertTrue(DailyPlan(planDay: day, items: [
            item("a", done: true, skip: false), item("b", done: true, skip: false)
        ]).isComplete)

        // One skipped, rest done → complete (skip clears it, a done exists).
        XCTAssertTrue(DailyPlan(planDay: day, items: [
            item("a", done: true, skip: false), item("b", done: false, skip: true)
        ]).isComplete)

        // All skipped → NOT complete (no real completion).
        XCTAssertFalse(DailyPlan(planDay: day, items: [
            item("a", done: false, skip: true), item("b", done: false, skip: true)
        ]).isComplete)

        // Something still actionable → NOT complete.
        XCTAssertFalse(DailyPlan(planDay: day, items: [
            item("a", done: true, skip: false), item("b", done: false, skip: false)
        ]).isComplete)

        // Empty plan → NOT complete.
        XCTAssertFalse(DailyPlan(planDay: day, items: []).isComplete)
    }

    // MARK: - Pure reconcile

    func testReconcileAutoMarksDone() {
        let day = DailyPlan.planDay(for: date(2026, 5, 30, 10), calendar: utc)
        let plan = DailyPlan(planDay: day, items: [
            DailyPlanItem(kind: .review, packId: "science_class7", targetId: "ch01_t01_q01",
                          title: "Q", subtitle: ""),
            DailyPlanItem(kind: .concept, packId: "science_class7", targetId: "ch01_t01_c01",
                          title: "C", subtitle: ""),
            DailyPlanItem(kind: .discover, packId: "science_class7", targetId: "ch01",
                          title: "D", subtitle: "", discoverBaselineScenes: 3)
        ])
        let reconciled = DataStore.reconciled(
            plan: plan,
            understood: ["ch01_t01_c01"],                  // concept now understood
            reviewedTodayQuestionIds: ["ch01_t01_q01"],    // review answered today
            visitedTodayConceptIds: [],
            discoverScenesByChapter: ["ch01": 4])           // 4 > baseline 3
        XCTAssertTrue(reconciled.items.allSatisfy { $0.isDone })
    }

    func testReconcileLeavesUntouchedWhenNoSignal() {
        let day = DailyPlan.planDay(for: date(2026, 5, 30, 10), calendar: utc)
        let plan = DailyPlan(planDay: day, items: [
            DailyPlanItem(kind: .discover, packId: "science_class7", targetId: "ch01",
                          title: "D", subtitle: "", discoverBaselineScenes: 3)
        ])
        // Same scene count as baseline → not done.
        let reconciled = DataStore.reconciled(
            plan: plan, understood: [], reviewedTodayQuestionIds: [],
            visitedTodayConceptIds: [], discoverScenesByChapter: ["ch01": 3])
        XCTAssertFalse(reconciled.items[0].isDone)
    }

    func testReconcileConceptViaVisitToday() {
        let day = DailyPlan.planDay(for: date(2026, 5, 30, 10), calendar: utc)
        let plan = DailyPlan(planDay: day, items: [
            DailyPlanItem(kind: .concept, packId: "science_class7", targetId: "ch01_t01_c09",
                          title: "C", subtitle: "")
        ])
        let reconciled = DataStore.reconciled(
            plan: plan, understood: [], reviewedTodayQuestionIds: [],
            visitedTodayConceptIds: ["ch01_t01_c09"], discoverScenesByChapter: [:])
        XCTAssertTrue(reconciled.items[0].isDone)
    }

    // MARK: - Streak crediting (UserDefaults)

    func testStreakCreditsConsecutiveDaysAndResetsOnGap() {
        let defaults = UserDefaults.standard
        let keys = [DailyPlanStorage.streakKey, DailyPlanStorage.streakLastDayKey,
                    DailyPlanStorage.streakBestKey]
        let saved = keys.map { defaults.object(forKey: $0) }
        // Precise restore — `set(nil,…)` would NOT clear a key, leaking plan
        // streak state into sibling suites in the shared test process.
        defer {
            for (i, k) in keys.enumerated() {
                if let v = saved[i] { defaults.set(v, forKey: k) } else { defaults.removeObject(forKey: k) }
            }
        }
        for k in keys { defaults.removeObject(forKey: k) }

        let store = tempStore()
        func completePlan(_ day: Date) -> DailyPlan {
            DailyPlan(planDay: DailyPlan.planDay(for: day, calendar: utc), items: [
                DailyPlanItem(kind: .review, packId: "p", targetId: "q",
                              title: "Q", subtitle: "", isDone: true)
            ])
        }

        store.creditDailyPlanStreakIfComplete(completePlan(date(2026, 5, 28, 10)), calendar: utc)
        XCTAssertEqual(defaults.integer(forKey: DailyPlanStorage.streakKey), 1)

        // Same day again → no double credit.
        store.creditDailyPlanStreakIfComplete(completePlan(date(2026, 5, 28, 20)), calendar: utc)
        XCTAssertEqual(defaults.integer(forKey: DailyPlanStorage.streakKey), 1)

        // Next day → 2.
        store.creditDailyPlanStreakIfComplete(completePlan(date(2026, 5, 29, 10)), calendar: utc)
        XCTAssertEqual(defaults.integer(forKey: DailyPlanStorage.streakKey), 2)

        // Skip a day (gap) → reset to 1.
        store.creditDailyPlanStreakIfComplete(completePlan(date(2026, 5, 31, 10)), calendar: utc)
        XCTAssertEqual(defaults.integer(forKey: DailyPlanStorage.streakKey), 1)

        // Best holds at 2.
        XCTAssertEqual(defaults.integer(forKey: DailyPlanStorage.streakBestKey), 2)
    }

    func testIncompletePlanDoesNotCreditStreak() {
        let defaults = UserDefaults.standard
        let saved = defaults.object(forKey: DailyPlanStorage.streakKey)
        let savedLast = defaults.object(forKey: DailyPlanStorage.streakLastDayKey)
        defer {
            if let v = saved { defaults.set(v, forKey: DailyPlanStorage.streakKey) }
            else { defaults.removeObject(forKey: DailyPlanStorage.streakKey) }
            if let v = savedLast { defaults.set(v, forKey: DailyPlanStorage.streakLastDayKey) }
            else { defaults.removeObject(forKey: DailyPlanStorage.streakLastDayKey) }
        }
        defaults.removeObject(forKey: DailyPlanStorage.streakKey)
        defaults.removeObject(forKey: DailyPlanStorage.streakLastDayKey)

        let incomplete = DailyPlan(planDay: DailyPlan.planDay(for: date(2026, 5, 30, 10), calendar: utc),
                                   items: [DailyPlanItem(kind: .review, packId: "p", targetId: "q",
                                                         title: "Q", subtitle: "")])
        tempStore().creditDailyPlanStreakIfComplete(incomplete, calendar: utc)
        XCTAssertEqual(defaults.integer(forKey: DailyPlanStorage.streakKey), 0)
    }

    // MARK: - Build + persistence (temp store)

    func testBuildCapsReviewsAtThreeAndPersists() {
        let store = tempStore()
        let now = date(2026, 5, 30, 12)
        let past = date(2026, 5, 30, 8)
        var reviews: [String: QuestionReview] = [:]
        for i in 1...5 {
            let id = String(format: "ch01_t01_q%02d", i)
            reviews[id] = review(id, dueAt: past)
        }
        store.questionReviews = reviews

        let plan = store.buildDailyPlan(registry: nil, now: now, calendar: utc)
        // nil registry → no concept/discover rows; reviews capped at 3.
        let reviewItems = plan.items.filter { $0.kind == .review }
        XCTAssertEqual(reviewItems.count, 3)
        XCTAssertEqual(plan.planDay, DailyPlan.planDay(for: now, calendar: utc))

        store.saveDailyPlan(plan)
        store.flushSavesBeforeQuit()
        let loaded = store.loadDailyPlan()
        XCTAssertEqual(loaded?.items.count, plan.items.count)
        XCTAssertEqual(loaded?.planDay, plan.planDay)
    }

    func testCurrentPlanReusesFreshAndRebuildsStale() {
        let store = tempStore()
        let day1 = date(2026, 5, 30, 12)
        let stale = DailyPlan(planDay: DailyPlan.planDay(for: date(2026, 5, 25, 12), calendar: utc),
                              items: [DailyPlanItem(kind: .review, packId: "p", targetId: "old",
                                                   title: "old", subtitle: "")])
        store.saveDailyPlan(stale)
        store.flushSavesBeforeQuit()

        // Stale plan-day → rebuilt for day1 (no due reviews seeded → empty items).
        let rebuilt = store.currentDailyPlan(registry: nil, now: day1, calendar: utc)
        XCTAssertEqual(rebuilt.planDay, DailyPlan.planDay(for: day1, calendar: utc))
        XCTAssertFalse(rebuilt.items.contains { $0.targetId == "old" })
    }

    func testDayKeyFormat() {
        XCTAssertEqual(DataStore.dayKey(date(2026, 5, 9, 0), calendar: utc), "2026-05-09")
        XCTAssertEqual(DataStore.dayKey(date(2026, 12, 31, 0), calendar: utc), "2026-12-31")
    }
}
