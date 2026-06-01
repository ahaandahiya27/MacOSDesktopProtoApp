import XCTest
@testable import desktopAhaan

// MARK: - JourneyPlannerTests
//
// v6 Learning Journey · Phase 3. Pins the pure, registry-free core of the
// cross-subject `JourneyPlanner`: the weak-first subject focus order derived
// from a `MasteryEngine` snapshot, and the weak-first round-robin that spreads
// due reviews across subjects. Uses fabricated snapshots (mirroring
// `MasteryEngineTests`) so no registry / DataStore is needed. The `@MainActor`
// `buildWholeJourneyPlan` path is exercised by `JourneyPlanIntegrationTests`.
final class JourneyPlannerTests: XCTestCase {

    // MARK: - Fabrication helpers (mirror MasteryEngineTests)

    private func chapter(_ packId: String, _ chapterId: String, _ number: Int,
                         _ counts: [MasteryLevel: Int]) -> ChapterMasterySummary {
        ChapterMasterySummary(
            subjectPackId: packId, chapterId: chapterId, chapterNumber: number,
            chapterTitle: "Chapter \(number)", counts: counts, topicSummaries: [])
    }

    private func subject(_ packId: String, _ chapters: [ChapterMasterySummary],
                         reviewable: Int) -> SubjectMasterySnapshot {
        let total = chapters.reduce(0) { $0 + $1.totalReviewed }
        return SubjectMasterySnapshot(
            packId: packId, subjectTitle: packId,
            summary: MasterySummary(subjectPackId: packId, chapters: chapters,
                                    dueCount: 0, totalReviewed: total),
            totalReviewableQuestions: reviewable, dueCount: 0)
    }

    /// Distributions reused from MasteryEngineTests so the mastery fractions are
    /// pinned by that suite too: [.mastered:N] → 1.0, [.learning:N] → 0.0,
    /// [.mastered:1,.learning:9] → 0.1, [.mastered:1,.learning:1] → 0.5.
    private func started(_ packId: String, mastery: [MasteryLevel: Int],
                         reviewable: Int) -> SubjectMasterySnapshot {
        subject(packId, [chapter(packId, "c1", 1, mastery)], reviewable: reviewable)
    }

    private func unstarted(_ packId: String, reviewable: Int) -> SubjectMasterySnapshot {
        subject(packId, [], reviewable: reviewable)
    }

    // MARK: - subjectFocusOrder

    func testFocusOrderIsWeakestStartedFirstThenUnstartedInRegistryOrder() {
        // Registry order interleaves started + unstarted on purpose.
        let snap = MasteryEngine.overall(from: [
            started("strong", mastery: [.mastered: 20], reviewable: 50),        // 1.0
            unstarted("ux", reviewable: 100),
            started("weak", mastery: [.mastered: 1, .learning: 9], reviewable: 50), // 0.1
            unstarted("uy", reviewable: 50),
            started("mid", mastery: [.mastered: 1, .learning: 1], reviewable: 50)   // 0.5
        ])
        XCTAssertEqual(JourneyPlanner.subjectFocusOrder(snap),
                       ["weak", "mid", "strong", "ux", "uy"],
            "Started subjects weakest-first by mastery; unstarted follow in registry order.")
    }

    func testFocusOrderTieBreaksOnCoverageThenRegistryOrder() {
        // All four are 0.0 mastery (all-learning) → tie broken by coverage asc,
        // then registry order for an exact coverage tie.
        let snap = MasteryEngine.overall(from: [
            started("highcov", mastery: [.learning: 50], reviewable: 100), // cov .50
            started("eqA", mastery: [.learning: 10], reviewable: 100),     // cov .10
            started("lowcov", mastery: [.learning: 5], reviewable: 100),   // cov .05
            started("eqB", mastery: [.learning: 10], reviewable: 100)      // cov .10
        ])
        XCTAssertEqual(JourneyPlanner.subjectFocusOrder(snap),
                       ["lowcov", "eqA", "eqB", "highcov"],
            "Equal mastery → thinner coverage first; equal coverage → registry order.")
    }

    func testFocusOrderEmptySnapshot() {
        XCTAssertEqual(JourneyPlanner.subjectFocusOrder(MasteryEngine.overall(from: [])), [])
    }

    func testFocusRankMatchesOrderPositions() {
        let snap = MasteryEngine.overall(from: [
            started("strong", mastery: [.mastered: 20], reviewable: 50),
            started("weak", mastery: [.mastered: 1, .learning: 9], reviewable: 50),
            unstarted("ux", reviewable: 100)
        ])
        let order = JourneyPlanner.subjectFocusOrder(snap)
        let rank = JourneyPlanner.focusRank(snap)
        for (i, packId) in order.enumerated() {
            XCTAssertEqual(rank[packId], i, "\(packId) rank must equal its order position.")
        }
        XCTAssertEqual(rank.count, order.count)
    }

    // MARK: - roundRobinReviews

    /// Compare a result to expected as "packId:questionId" strings (tuples
    /// aren't directly Equatable).
    private func keys(_ picks: [(packId: String, questionId: String)]) -> [String] {
        picks.map { "\($0.packId):\($0.questionId)" }
    }

    func testRoundRobinSpreadsWeakSubjectFirst() {
        let picks = JourneyPlanner.roundRobinReviews(
            dueByPack: ["strong": ["s1", "s2", "s3"], "weak": ["w1", "w2"]],
            order: ["weak", "strong"], max: 3)
        XCTAssertEqual(keys(picks), ["weak:w1", "strong:s1", "weak:w2"],
            "Weak subject is served first each round; reviews interleave, capped at max.")
    }

    func testRoundRobinPreservesPerSubjectOrderAndDrains() {
        let picks = JourneyPlanner.roundRobinReviews(
            dueByPack: ["a": ["a1", "a2"], "b": ["b1"]],
            order: ["a", "b"], max: 5)
        XCTAssertEqual(keys(picks), ["a:a1", "b:b1", "a:a2"],
            "Round-robin in focus order, each subject's internal order preserved.")
        XCTAssertEqual(picks.count, 3, "max above the supply drains every queue.")
    }

    func testRoundRobinRespectsMaxAndHandlesEmpty() {
        XCTAssertTrue(JourneyPlanner.roundRobinReviews(
            dueByPack: ["a": ["a1", "a2"]], order: ["a"], max: 0).isEmpty)
        XCTAssertTrue(JourneyPlanner.roundRobinReviews(
            dueByPack: [:], order: ["a", "b"], max: 3).isEmpty)
        let one = JourneyPlanner.roundRobinReviews(
            dueByPack: ["a": ["a1", "a2", "a3"]], order: ["a"], max: 2)
        XCTAssertEqual(keys(one), ["a:a1", "a:a2"], "A single subject still respects max.")
    }

    func testRoundRobinIncludesPacksAbsentFromOrderDeterministically() {
        // 'z' is due but not in the focus order (defensive path): it must still
        // be served, appended after the ordered packs by sorted pack id.
        let picks = JourneyPlanner.roundRobinReviews(
            dueByPack: ["a": ["a1"], "z": ["z1", "z2"]],
            order: ["a"], max: 5)
        XCTAssertEqual(keys(picks), ["a:a1", "z:z1", "z:z2"],
            "A due pack missing from the snapshot is still drained, deterministically.")
    }

    // MARK: - JourneyMode storage

    func testJourneyModeStorageRoundTripAndDefault() {
        let suite = "journeytest-\(UUID().uuidString)"
        guard let d = UserDefaults(suiteName: suite) else {
            return XCTFail("Could not create a test UserDefaults suite.")
        }
        defer { d.removePersistentDomain(forName: suite) }

        XCTAssertEqual(JourneyPlannerStorage.currentMode(d), .today,
            "Absent key defaults to .today (no behavioural change for existing users).")
        JourneyPlannerStorage.setMode(.wholeJourney, d)
        XCTAssertEqual(JourneyPlannerStorage.currentMode(d), .wholeJourney)
        JourneyPlannerStorage.setMode(.today, d)
        XCTAssertEqual(JourneyPlannerStorage.currentMode(d), .today)
    }

    func testJourneyModeRawValuesAreStablePersistenceContract() {
        // Raw values land in UserDefaults — never rename a shipped case.
        XCTAssertEqual(JourneyMode.today.rawValue, "today")
        XCTAssertEqual(JourneyMode.wholeJourney.rawValue, "wholeJourney")
        XCTAssertEqual(Set(JourneyMode.allCases), [.today, .wholeJourney])
    }
}
