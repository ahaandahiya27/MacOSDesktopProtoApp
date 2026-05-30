import XCTest
@testable import desktopAhaan

/// Exercises the pure `PracticeWindow` band table, the `Question`
/// intrinsic-band mapping, and the engine's pure `rank(...)` core. No FS,
/// no app — every assertion is a function of value types.
@MainActor
final class AdaptiveDifficultyBandTests: XCTestCase {

    private func window(_ outcomes: [Bool]) -> PracticeWindow {
        var w = PracticeWindow()
        for o in outcomes { w.record(o) }
        return w
    }

    // MARK: - Band table (full 5-answer window)

    func testFivePerfectBiasesToStretchThenChallenge() {
        let w = window([true, true, true, true, true])
        XCTAssertEqual(w.band, .stretch)
        XCTAssertEqual(w.preferredBands, [.stretch, .challenge, .core, .easy])
    }

    func testFourOfFiveBiasesToCoreThenStretch() {
        let w = window([true, false, true, true, true])   // 4/5
        XCTAssertEqual(w.correctCount, 4)
        XCTAssertEqual(w.band, .core)
        XCTAssertEqual(w.preferredBands, [.core, .stretch, .easy, .challenge])
    }

    func testThreeOfFiveIsCoreOnlyPrimary() {
        let w = window([true, false, true, false, true])  // 3/5
        XCTAssertEqual(w.correctCount, 3)
        XCTAssertEqual(w.band, .core)
        XCTAssertEqual(w.preferredBands.first, .core)
    }

    func testTwoOfFiveOrWorseBiasesToEasyThenCore() {
        let two = window([true, false, false, true, false])   // 2/5
        XCTAssertEqual(two.band, .easy)
        XCTAssertEqual(two.preferredBands, [.easy, .core, .stretch, .challenge])

        let zero = window([false, false, false, false, false]) // 0/5
        XCTAssertEqual(zero.band, .easy)
    }

    // MARK: - Rolling eviction

    func testWindowCapsAtFiveAndEvictsOldest() {
        // Six trues then... the oldest falls off; window stays 5.
        var w = window([false, false, false, false, false])   // 0/5 → easy
        XCTAssertEqual(w.band, .easy)
        for _ in 0..<5 { w.record(true) }                     // push 5 trues
        XCTAssertEqual(w.sampleCount, 5)
        XCTAssertEqual(w.correctCount, 5)
        XCTAssertEqual(w.band, .stretch, "Five fresh corrects evict the old misses.")
    }

    // MARK: - Partial-window neutrality

    func testEmptyWindowIsCore() {
        XCTAssertEqual(PracticeWindow().band, .core)
    }

    func testPartialCleanRunStaysCore() {
        // 2/2 correct is NOT enough to unlock stretch — needs a full window.
        XCTAssertEqual(window([true, true]).band, .core)
    }

    func testStrugglingPartialRunDropsToEasy() {
        // ≤40% correct on a partial window nudges to easy early.
        XCTAssertEqual(window([false, false, false]).band, .easy)   // 0/3
        XCTAssertEqual(window([true, false, false, false]).band, .easy) // 1/4 = 25%
    }

    // MARK: - Question intrinsic band

    private func q(_ id: String, difficulty: Int, prompt: String = "p",
                   options: [String]? = nil) -> Question {
        Question(id: id, prompt: prompt, questionType: .mcq, options: options,
                 answer: "a", solutionSteps: [], commonMistakes: [],
                 variations: [], difficulty: difficulty, pageRefs: [],
                 needsHumanReview: false)
    }

    func testIntrinsicBandHonoursAuthoredDifficulty() {
        XCTAssertEqual(q("a", difficulty: 1).intrinsicBand, .easy)
        XCTAssertEqual(q("b", difficulty: 2).intrinsicBand, .core)
        XCTAssertEqual(q("c", difficulty: 3).intrinsicBand, .core)
        XCTAssertEqual(q("d", difficulty: 4).intrinsicBand, .stretch)
        XCTAssertEqual(q("e", difficulty: 5).intrinsicBand, .challenge)
    }

    func testIntrinsicBandInfersWhenDifficultyOutOfRange() {
        // difficulty 0 (out of authored range) → infer from length + options.
        let shortQ = q("s", difficulty: 0, prompt: String(repeating: "x", count: 10))
        XCTAssertEqual(shortQ.intrinsicBand, .easy)
        let longQ = q("l", difficulty: 0,
                      prompt: String(repeating: "x", count: 200),
                      options: ["1", "2", "3", "4", "5"])
        XCTAssertEqual(longQ.intrinsicBand, .challenge)
    }

    // MARK: - Pure rank()

    func testRankPrefersBandMatchAndRespectsK() {
        let easy = q("easy", difficulty: 1)
        let core = q("core", difficulty: 3)
        let challenge = q("chal", difficulty: 5)
        // Target stretch → challenge (dist 1) beats core (dist 1 too) ... tie
        // broken by ease then order. Use a clearer target: easy.
        let ranked = AdaptiveDifficultyEngine.rank(
            questions: [challenge, core, easy], targetBand: .easy,
            easeFor: { _ in nil }, k: 2)
        XCTAssertEqual(ranked.map { $0.id }, ["easy", "core"],
                       "Closest-to-target bands come first; k caps the result.")
    }

    func testRankTieBreaksByLowerEaseFirst() {
        let a = q("a", difficulty: 3)
        let b = q("b", difficulty: 3)   // same band → tie on distance
        let ranked = AdaptiveDifficultyEngine.rank(
            questions: [a, b], targetBand: .core,
            easeFor: { id in id == "b" ? 1.4 : 2.5 }, k: 2)
        XCTAssertEqual(ranked.first?.id, "b",
                       "Lower-ease (harder for the kid) question surfaces first.")
    }

    func testRankZeroKReturnsEmpty() {
        XCTAssertTrue(AdaptiveDifficultyEngine.rank(
            questions: [q("a", difficulty: 1)], targetBand: .core,
            easeFor: { _ in nil }, k: 0).isEmpty)
    }
}
