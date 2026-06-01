import XCTest
@testable import desktopAhaan

// MARK: - MilestoneAssessmentPlannerTests
//
// v6 Learning Journey · Phase 4. Pure unit tests over the FS-free
// `MilestoneAssessmentPlanner` — slot apportionment by mastery gap and the full
// allocate → truncate → interleave compose. No registry, no DataStore, fully
// deterministic.
final class MilestoneAssessmentPlannerTests: XCTestCase {

    typealias Slot = (packId: String, weight: Double, available: Int)

    // MARK: - allocateSlots

    func testAllocateIsProportionalToWeight() {
        // D'Hondt highest-averages: weights 3:1 over 8 slots → 6:2.
        let out = MilestoneAssessmentPlanner.allocateSlots(
            [("A", 3, 10), ("B", 1, 10)], total: 8)
        XCTAssertEqual(out["A"], 6)
        XCTAssertEqual(out["B"], 2)
        XCTAssertEqual((out["A"] ?? 0) + (out["B"] ?? 0), 8, "Must sum to total.")
    }

    func testAllocateRespectsAvailableCap() {
        // A has the dominant weight but only 2 questions; the rest spill to B.
        let out = MilestoneAssessmentPlanner.allocateSlots(
            [("A", 5, 2), ("B", 1, 10)], total: 6)
        XCTAssertEqual(out["A"], 2, "A is capped at its available pool.")
        XCTAssertEqual(out["B"], 4, "Surplus slots spill to the next subject.")
        XCTAssertEqual((out["A"] ?? 0) + (out["B"] ?? 0), 6)
    }

    func testAllocateSumsToCapacityWhenTotalExceedsIt() {
        let out = MilestoneAssessmentPlanner.allocateSlots(
            [("A", 1, 2), ("B", 1, 3)], total: 10)
        XCTAssertEqual(out["A"], 2)
        XCTAssertEqual(out["B"], 3)
        XCTAssertEqual((out["A"] ?? 0) + (out["B"] ?? 0), 5,
            "Never allocate beyond Σ available.")
    }

    func testAllocateTieBreaksByInputOrderWeakestFirst() {
        // Equal weights, only 2 slots, 3 subjects → the first two (weakest-first
        // focus order) win; the third gets nothing.
        let out = MilestoneAssessmentPlanner.allocateSlots(
            [("A", 1, 10), ("B", 1, 10), ("C", 1, 10)], total: 2)
        XCTAssertEqual(out["A"], 1)
        XCTAssertEqual(out["B"], 1)
        XCTAssertNil(out["C"], "A scarce slot goes to the earlier (weaker) subject.")
    }

    func testAllocateZeroWeightStillParticipatesViaFloor() {
        // Both gaps are literally 0 (fully mastered); the floor keeps them
        // eligible so the quiz can still draw from them.
        let out = MilestoneAssessmentPlanner.allocateSlots(
            [("A", 0, 5), ("B", 0, 5)], total: 2)
        XCTAssertEqual(out["A"], 1)
        XCTAssertEqual(out["B"], 1)
    }

    func testAllocateEdgeCases() {
        XCTAssertTrue(MilestoneAssessmentPlanner.allocateSlots(
            [("A", 1, 5)], total: 0).isEmpty, "total 0 → no slots.")
        XCTAssertTrue(MilestoneAssessmentPlanner.allocateSlots(
            [("A", 1, 0), ("B", 2, 0)], total: 5).isEmpty, "No capacity → no slots.")
        XCTAssertTrue(MilestoneAssessmentPlanner.allocateSlots(
            [], total: 5).isEmpty, "No subjects → no slots.")
    }

    // MARK: - compose

    func testComposeAllocatesByGapThenInterleavesWeakestFirst() {
        // A is the weak subject (high gap weight); B is strong. A should fill
        // first (to its cap of 3), then B, and the order should lead with A.
        let pools = ["A": ["a1", "a2", "a3"], "B": ["b1", "b2", "b3"]]
        let weights = ["A": 0.9, "B": 0.1]
        let picks = MilestoneAssessmentPlanner.compose(
            poolsByPack: pools, weightByPack: weights, order: ["A", "B"], total: 4)

        XCTAssertEqual(picks.count, 4)
        XCTAssertEqual(picks.first?.packId, "A", "Weakest subject leads the quiz.")
        let aPicks = picks.filter { $0.packId == "A" }.map { $0.questionId }
        let bPicks = picks.filter { $0.packId == "B" }.map { $0.questionId }
        XCTAssertEqual(aPicks, ["a1", "a2", "a3"], "A fills to its cap, in pool order.")
        XCTAssertEqual(bPicks, ["b1"], "B gets the single leftover slot.")
        // Interleaved (round-robin), not block-by-subject: A, B, A, A.
        XCTAssertEqual(picks.map { $0.packId }, ["A", "B", "A", "A"])
    }

    func testComposeTruncatesEachPoolToItsAllocation() {
        // Long pools, small total — only the gap-ordered fronts are used.
        let pools = ["A": ["a1", "a2", "a3", "a4"], "B": ["b1", "b2", "b3", "b4"]]
        let weights = ["A": 1.0, "B": 1.0]
        let picks = MilestoneAssessmentPlanner.compose(
            poolsByPack: pools, weightByPack: weights, order: ["A", "B"], total: 2)
        XCTAssertEqual(picks.count, 2)
        XCTAssertEqual(Set(picks.map { $0.questionId }), ["a1", "b1"],
            "Equal weights, 2 slots → one from each pool's front.")
    }

    func testComposeClampsToAvailableAndHandlesEmpty() {
        let pools = ["A": ["a1", "a2"], "B": ["b1"]]
        let all = MilestoneAssessmentPlanner.compose(
            poolsByPack: pools, weightByPack: ["A": 1, "B": 1], order: ["A", "B"], total: 99)
        XCTAssertEqual(all.count, 3, "Returns everything available when total exceeds it.")
        XCTAssertEqual(Set(all.map { $0.questionId }), ["a1", "a2", "b1"])

        XCTAssertTrue(MilestoneAssessmentPlanner.compose(
            poolsByPack: [:], weightByPack: [:], order: [], total: 5).isEmpty)
        XCTAssertTrue(MilestoneAssessmentPlanner.compose(
            poolsByPack: ["A": ["a1"]], weightByPack: ["A": 1], order: ["A"], total: 0).isEmpty)
    }

    func testComposeIncludesPoolsAbsentFromOrderDeterministically() {
        // A pool whose pack isn't in `order` (defensive) is still drawn, appended
        // after the ordered packs by sorted id — nothing is silently dropped.
        let pools = ["Z": ["z1"], "A": ["a1"]]
        let picks = MilestoneAssessmentPlanner.compose(
            poolsByPack: pools, weightByPack: ["Z": 1, "A": 1], order: ["A"], total: 5)
        XCTAssertEqual(Set(picks.map { $0.questionId }), ["a1", "z1"])
        XCTAssertEqual(picks.first?.packId, "A", "Ordered pack leads the unordered one.")
    }
}
