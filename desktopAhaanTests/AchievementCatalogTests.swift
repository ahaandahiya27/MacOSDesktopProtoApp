import XCTest
@testable import desktopAhaan

/// Pins the 24-badge catalog + proves each `AchievementCriterion` fires
/// when its metric reaches the threshold. Pure-value tests — no DataStore,
/// no FS I/O — so they're deterministic on any CI machine.
final class AchievementCatalogTests: XCTestCase {

    // MARK: - Catalog shape (ratchet)

    func testExactlyTwentyFourBadges() {
        XCTAssertEqual(Achievement.all.count, 24,
                       "The catalog must ship exactly 24 badges.")
    }

    func testAllBadgeIdsAreUniqueAndStable() {
        let ids = Achievement.all.map { $0.id }
        XCTAssertEqual(Set(ids).count, ids.count, "Badge ids must be unique.")
        // The exact id set is the persistence contract — achievements.json
        // keys on these. Changing any string orphans a kid's unlock.
        let expected: Set<String> = [
            "streak_first_day", "streak_7", "streak_14", "streak_30",
            "streak_60", "streak_100",
            "mastery_1", "mastery_10", "mastery_50", "mastery_100",
            "mastery_chapter", "mastery_subject",
            "discover_first", "discover_chapter", "discover_5_chapters",
            "discover_all_science",
            "article_first", "article_10", "article_50",
            "article_beyond_each_chapter",
            "quiz_boss_first", "quiz_boss_10",
            "quiz_quickcheck_perfect_day", "quiz_practice_perfect_week"
        ]
        XCTAssertEqual(Set(ids), expected)
    }

    func testEveryFamilyHasTheExpectedCount() {
        func count(_ f: AchievementFamily) -> Int {
            Achievement.all.filter { $0.family == f }.count
        }
        XCTAssertEqual(count(.streak), 6)
        XCTAssertEqual(count(.mastery), 6)
        XCTAssertEqual(count(.discover), 4)
        XCTAssertEqual(count(.article), 4)
        XCTAssertEqual(count(.quiz), 4)
    }

    func testEveryTierIsRepresented() {
        let tiers = Set(Achievement.all.map { $0.tier })
        XCTAssertEqual(tiers, Set(AchievementTier.allCases))
    }

    func testEveryBadgeHasNonEmptyTitleAndDetailAndEmoji() {
        for a in Achievement.all {
            XCTAssertFalse(a.title.isEmpty, "\(a.id) title empty")
            XCTAssertFalse(a.detail.isEmpty, "\(a.id) detail empty")
            XCTAssertFalse(a.emoji.isEmpty, "\(a.id) emoji empty")
        }
    }

    func testByIdLookupResolvesEveryBadge() {
        for a in Achievement.all {
            XCTAssertEqual(Achievement.byId[a.id]?.id, a.id)
        }
        XCTAssertEqual(Achievement.byId.count, 24)
    }

    // MARK: - Empty snapshot locks everything

    func testEmptySnapshotUnlocksNothing() {
        let snap = AchievementSnapshot()
        for a in Achievement.all {
            XCTAssertFalse(a.isUnlocked(in: snap),
                           "\(a.id) should be locked on a fresh snapshot.")
        }
    }

    // MARK: - Each criterion fires at its threshold

    func testStreakBadgesFireAtTheirThresholds() {
        let thresholds: [(String, Int)] = [
            ("streak_first_day", 1), ("streak_7", 7), ("streak_14", 14),
            ("streak_30", 30), ("streak_60", 60), ("streak_100", 100)
        ]
        for (id, n) in thresholds {
            let badge = Achievement.byId[id]!
            var below = AchievementSnapshot(); below.bestStreakDays = n - 1
            var at = AchievementSnapshot(); at.bestStreakDays = n
            XCTAssertFalse(badge.isUnlocked(in: below), "\(id) fired too early")
            XCTAssertTrue(badge.isUnlocked(in: at), "\(id) didn't fire at \(n)")
        }
    }

    func testMasteryCountBadgesFire() {
        let thresholds: [(String, Int)] = [
            ("mastery_1", 1), ("mastery_10", 10),
            ("mastery_50", 50), ("mastery_100", 100)
        ]
        for (id, n) in thresholds {
            var at = AchievementSnapshot(); at.conceptsMastered = n
            XCTAssertTrue(Achievement.byId[id]!.isUnlocked(in: at))
            var below = AchievementSnapshot(); below.conceptsMastered = n - 1
            XCTAssertFalse(Achievement.byId[id]!.isUnlocked(in: below))
        }
    }

    func testChapterAndSubjectMasteryFire() {
        var s = AchievementSnapshot()
        s.chaptersFullyMastered = 1
        XCTAssertTrue(Achievement.byId["mastery_chapter"]!.isUnlocked(in: s))
        XCTAssertFalse(Achievement.byId["mastery_subject"]!.isUnlocked(in: s))
        s.subjectsFullyMastered = 1
        XCTAssertTrue(Achievement.byId["mastery_subject"]!.isUnlocked(in: s))
    }

    func testDiscoverBadgesFire() {
        var s = AchievementSnapshot()
        s.discoverScenesCompleted = 1
        XCTAssertTrue(Achievement.byId["discover_first"]!.isUnlocked(in: s))
        s.discoverChaptersComplete = 5
        XCTAssertTrue(Achievement.byId["discover_chapter"]!.isUnlocked(in: s))
        XCTAssertTrue(Achievement.byId["discover_5_chapters"]!.isUnlocked(in: s))
        XCTAssertFalse(Achievement.byId["discover_all_science"]!.isUnlocked(in: s))
        s.discoverChaptersComplete = 19
        XCTAssertTrue(Achievement.byId["discover_all_science"]!.isUnlocked(in: s))
    }

    func testArticleBadgesFire() {
        var s = AchievementSnapshot()
        s.articlesRead = 50
        XCTAssertTrue(Achievement.byId["article_first"]!.isUnlocked(in: s))
        XCTAssertTrue(Achievement.byId["article_10"]!.isUnlocked(in: s))
        XCTAssertTrue(Achievement.byId["article_50"]!.isUnlocked(in: s))
        XCTAssertFalse(Achievement.byId["article_beyond_each_chapter"]!.isUnlocked(in: s))
        s.beyondTheBookChaptersRead = 19
        XCTAssertTrue(Achievement.byId["article_beyond_each_chapter"]!.isUnlocked(in: s))
    }

    func testQuizBadgesFire() {
        var s = AchievementSnapshot()
        s.bossQuizzesPassed = 1
        XCTAssertTrue(Achievement.byId["quiz_boss_first"]!.isUnlocked(in: s))
        XCTAssertFalse(Achievement.byId["quiz_boss_10"]!.isUnlocked(in: s))
        s.bossQuizzesPassed = 10
        XCTAssertTrue(Achievement.byId["quiz_boss_10"]!.isUnlocked(in: s))

        XCTAssertFalse(Achievement.byId["quiz_quickcheck_perfect_day"]!.isUnlocked(in: s))
        s.quickCheckPerfectDay = true
        XCTAssertTrue(Achievement.byId["quiz_quickcheck_perfect_day"]!.isUnlocked(in: s))

        XCTAssertFalse(Achievement.byId["quiz_practice_perfect_week"]!.isUnlocked(in: s))
        s.dailyPracticePerfectWeek = true
        XCTAssertTrue(Achievement.byId["quiz_practice_perfect_week"]!.isUnlocked(in: s))
    }

    // MARK: - Progress hint

    func testProgressFractionAndStartedFlag() {
        let badge = Achievement.byId["mastery_10"]!
        var s = AchievementSnapshot(); s.conceptsMastered = 3
        let p = badge.progress(in: s)
        XCTAssertEqual(p.current, 3)
        XCTAssertEqual(p.target, 10)
        XCTAssertTrue(p.hasStarted)
        XCTAssertFalse(p.isUnlocked)
        XCTAssertEqual(p.fraction, 0.3, accuracy: 0.0001)

        let zero = badge.progress(in: AchievementSnapshot())
        XCTAssertFalse(zero.hasStarted)
        XCTAssertEqual(zero.fraction, 0.0, accuracy: 0.0001)
    }

    func testFractionClampsToOne() {
        let badge = Achievement.byId["streak_7"]!
        var s = AchievementSnapshot(); s.bestStreakDays = 999
        XCTAssertEqual(badge.progress(in: s).fraction, 1.0, accuracy: 0.0001)
    }

    // MARK: - Tier sound gating

    func testOnlyGoldAndPlatinumPlaySound() {
        XCTAssertFalse(AchievementTier.bronze.playsCelebrationSound)
        XCTAssertFalse(AchievementTier.silver.playsCelebrationSound)
        XCTAssertTrue(AchievementTier.gold.playsCelebrationSound)
        XCTAssertTrue(AchievementTier.platinum.playsCelebrationSound)
    }
}
