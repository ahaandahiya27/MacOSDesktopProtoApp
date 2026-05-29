import XCTest
@testable import desktopAhaan

/// Exercises the engine's pure unlock core, the static metric helpers, the
/// `DataStore.achievementSnapshot` build, and the persistence round-trip.
/// Deterministic — temp store dirs + explicit UserDefaults seeding, no
/// dependency on a loaded `SubjectRegistry`.
@MainActor
final class AchievementEngineTests: XCTestCase {

    private func tempStore() -> DataStore {
        let dir = FileManager.default.temporaryDirectory
            .appendingPathComponent("achv-\(UUID().uuidString)")
        return DataStore(streakCalendar: nil, storeDir: dir, autoLoad: false)
    }

    private func review(
        _ id: String, bucket: Int, at date: Date
    ) -> QuestionReview {
        QuestionReview(questionId: id, bucket: bucket, ease: 2.5,
                       intervalDays: 1, lastReviewedAt: date,
                       nextDueAt: date, totalReviews: 1, lapses: 0)
    }

    // MARK: - Engine pure core

    func testNewlyUnlockedReturnsOnlyFreshBadges() {
        let engine = AchievementEngine()
        var snap = AchievementSnapshot()
        snap.conceptsMastered = 1   // unlocks mastery_1
        let first = engine.newlyUnlocked(in: snap, now: Date())
        XCTAssertEqual(first.map { $0.id }, ["mastery_1"])
        // Same snapshot again → nothing new (idempotent).
        let second = engine.newlyUnlocked(in: snap, now: Date())
        XCTAssertTrue(second.isEmpty)
        XCTAssertTrue(engine.isUnlocked("mastery_1"))
    }

    func testNewlyUnlockedStampsUnlockDate() {
        let engine = AchievementEngine()
        var snap = AchievementSnapshot(); snap.discoverScenesCompleted = 1
        let when = Date(timeIntervalSince1970: 1_700_000_000)
        _ = engine.newlyUnlocked(in: snap, now: when)
        XCTAssertEqual(engine.unlockDate("discover_first"), when)
        XCTAssertEqual(engine.unlockedCount, 1)
    }

    func testCrossingMultipleThresholdsAtOnceUnlocksAll() {
        let engine = AchievementEngine()
        var snap = AchievementSnapshot()
        snap.articlesRead = 50   // article_first + article_10 + article_50
        let newly = Set(engine.newlyUnlocked(in: snap, now: Date()).map { $0.id })
        XCTAssertEqual(newly, ["article_first", "article_10", "article_50"])
    }

    // MARK: - Static metric helpers

    func testCompletedDiscoverChapterCount() {
        // ch01 needs 21 scenes; ch03 needs 20. Build 21 ch01 rows + 5 ch03.
        var rows: [DiscoverProgress] = []
        for i in 0..<21 { rows.append(DiscoverProgress(chapterId: "ch01", sceneId: "s\(i)")) }
        for i in 0..<5  { rows.append(DiscoverProgress(chapterId: "ch03", sceneId: "s\(i)")) }
        XCTAssertEqual(DataStore.completedDiscoverChapterCount(in: rows), 1)
    }

    func testBeyondTheBookChapterCount() {
        let ids: Set<String> = ["ch01_beyond", "ch07_beyond", "ch01_glossary"]
        XCTAssertEqual(DataStore.beyondTheBookChapterCount(in: ids), 2)
    }

    func testBossQuizChapterCount() {
        let reviews: [String: QuestionReview] = [
            "bossquiz_ch01_q01": review("bossquiz_ch01_q01", bucket: 2, at: Date()),
            "bossquiz_ch01_q02": review("bossquiz_ch01_q02", bucket: 2, at: Date()),
            "bossquiz_ch05_q01": review("bossquiz_ch05_q01", bucket: 1, at: Date()),
            "ch01_t01_q01": review("ch01_t01_q01", bucket: 3, at: Date())
        ]
        // Distinct chapters with a boss review: ch01, ch05 → 2.
        XCTAssertEqual(DataStore.bossQuizChapterCount(in: reviews), 2)
    }

    func testQuickCheckPerfectDay() {
        let cal = Calendar(identifier: .gregorian)
        let today = Date(timeIntervalSince1970: 1_700_000_000)
        let yesterday = cal.date(byAdding: .day, value: -1, to: today)!
        var reviews: [String: QuestionReview] = [:]
        for i in 1...3 {
            let id = "scenecheck_ch01_q0\(i)"
            reviews[id] = review(id, bucket: 2, at: today)
        }
        XCTAssertTrue(DataStore.hasQuickCheckPerfectDay(in: reviews, now: today, calendar: cal))

        // One missed (bucket 0) today → not perfect.
        reviews["scenecheck_ch01_q02"] = review("scenecheck_ch01_q02", bucket: 0, at: today)
        XCTAssertFalse(DataStore.hasQuickCheckPerfectDay(in: reviews, now: today, calendar: cal))

        // Fewer than 3 today (move them to yesterday) → not perfect.
        var sparse: [String: QuestionReview] = [:]
        sparse["scenecheck_ch01_q01"] = review("scenecheck_ch01_q01", bucket: 2, at: today)
        sparse["scenecheck_ch01_q02"] = review("scenecheck_ch01_q02", bucket: 2, at: yesterday)
        XCTAssertFalse(DataStore.hasQuickCheckPerfectDay(in: sparse, now: today, calendar: cal))
    }

    func testChapterNumberParsing() {
        XCTAssertEqual(DataStore.chapterNumber(fromChapterId: "ch07"), 7)
        XCTAssertEqual(DataStore.chapterNumber(fromChapterId: "ch07_t01_c02"), 7)
        XCTAssertNil(DataStore.chapterNumber(fromChapterId: "sch07"))
        XCTAssertEqual(DataStore.chapterNumber(fromPrefixedId: "bossquiz_ch12_q03", prefix: "bossquiz_"), 12)
        XCTAssertNil(DataStore.chapterNumber(fromPrefixedId: "scenecheck_ch01", prefix: "bossquiz_"))
    }

    func testMasteryCounts() {
        let packs = [
            DataStore.PackConceptIds(chapters: [["a", "b"], ["c"]]),  // ch1 needs a,b; ch2 needs c
            DataStore.PackConceptIds(chapters: [["x", "y"]])
        ]
        // Understand all of pack-1 chapter-1 + chapter-2 → 2 chapters, pack-1 subject.
        let counts = DataStore.masteryCounts(packs: packs, understood: ["a", "b", "c"])
        XCTAssertEqual(counts.chapters, 2)
        XCTAssertEqual(counts.subjects, 1)
        // Empty understood → nothing.
        let zero = DataStore.masteryCounts(packs: packs, understood: [])
        XCTAssertEqual(zero.chapters, 0)
        XCTAssertEqual(zero.subjects, 0)
    }

    // MARK: - Snapshot from a live (temp) DataStore

    func testSnapshotReadsConceptsArticlesDiscover() {
        let store = tempStore()
        store.understoodConceptIds = ["ch01_t01_c01", "ch01_t01_c02"]
        store.readArticleIds = ["ch01_beyond", "ch02_intro"]
        store.discoverProgress = [
            DiscoverProgress(chapterId: "ch01", sceneId: "s1"),
            DiscoverProgress(chapterId: "ch01", sceneId: "s2")
        ]
        let snap = store.achievementSnapshot(registry: nil)
        XCTAssertEqual(snap.conceptsMastered, 2)
        XCTAssertEqual(snap.articlesRead, 2)
        XCTAssertEqual(snap.beyondTheBookChaptersRead, 1)
        XCTAssertEqual(snap.discoverScenesCompleted, 2)
        XCTAssertEqual(snap.discoverChaptersComplete, 0)  // ch01 needs 21
    }

    func testSnapshotReadsStreakBest() {
        let defaults = UserDefaults.standard
        let savedBest = defaults.object(forKey: AppStorageKeys.reviewStreakBest)
        let savedCur = defaults.object(forKey: AppStorageKeys.reviewStreakDays)
        defer {
            defaults.set(savedBest, forKey: AppStorageKeys.reviewStreakBest)
            defaults.set(savedCur, forKey: AppStorageKeys.reviewStreakDays)
        }
        defaults.set(9, forKey: AppStorageKeys.reviewStreakBest)
        defaults.set(2, forKey: AppStorageKeys.reviewStreakDays)
        let snap = tempStore().achievementSnapshot(registry: nil)
        XCTAssertEqual(snap.bestStreakDays, 9)
    }

    // MARK: - Persistence round-trip

    func testUnlockPersistenceRoundTrip() {
        let store = tempStore()
        let when = Date(timeIntervalSince1970: 1_700_000_000)
        store.saveAchievementUnlocks(["mastery_1": when, "streak_first_day": when])
        // Coalesced save → flush before reading back.
        store.flushSavesBeforeQuit()
        let loaded = store.loadAchievementUnlocks()
        XCTAssertEqual(loaded.count, 2)
        XCTAssertEqual(loaded["mastery_1"], when)
        XCTAssertEqual(loaded["streak_first_day"], when)
    }
}
