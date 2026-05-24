import XCTest
@testable import desktopAhaan

/// Tests for the hint-ladder logic on `Question` — `derivedHints`
/// + `defaultQualityForHintTier(_:)`. The view's reveal state machine
/// itself lives behind `@State` so a pure test would have to spin up
/// a SwiftUI host; the helpers here capture the truth about which
/// hint level reveals which body and what quality default applies.
final class HintLadderTests: XCTestCase {

    private func question(
        hints: [String]? = nil,
        solutionSteps: [String]
    ) -> Question {
        Question(
            id: "stub", prompt: "P", questionType: .shortAnswer,
            options: nil, answer: "A",
            solutionSteps: solutionSteps, commonMistakes: [],
            variations: [], difficulty: 1, pageRefs: [],
            needsHumanReview: false,
            matchPairs: nil, source: nil, hints: hints
        )
    }

    // MARK: - derivedHints

    func testExplicitHintsTakePrecedence() {
        let q = question(
            hints: ["Look at the units.", "Re-read the diagram."],
            solutionSteps: ["Step one is to multiply.", "Step two is to add."]
        )
        XCTAssertEqual(q.derivedHints,
                       ["Look at the units.", "Re-read the diagram."])
    }

    func testExplicitHintsCappedAtTwo() {
        let q = question(
            hints: ["A", "B", "C", "D"],
            solutionSteps: ["fallback"]
        )
        XCTAssertEqual(q.derivedHints, ["A", "B"])
    }

    func testFallbackToSolutionStepsWhenHintsNil() {
        let q = question(
            hints: nil,
            solutionSteps: ["First step.", "Second step.", "Third step."]
        )
        XCTAssertEqual(q.derivedHints, ["First step.", "Second step."],
                       "with no authored hints, the ladder derives from solutionSteps.prefix(2)")
    }

    func testFallbackWhenHintsArrayIsEmpty() {
        let q = question(
            hints: [],
            solutionSteps: ["Only step."]
        )
        XCTAssertEqual(q.derivedHints, ["Only step."],
                       "empty `hints: []` should fall through to solutionSteps")
    }

    func testOneStepQuestionYieldsOneHint() {
        let q = question(
            hints: nil,
            solutionSteps: ["The single worked step."]
        )
        XCTAssertEqual(q.derivedHints, ["The single worked step."])
    }

    func testZeroStepsZeroHints() {
        let q = question(hints: nil, solutionSteps: [])
        XCTAssertEqual(q.derivedHints, [])
    }

    // MARK: - defaultQualityForHintTier

    func testTierZeroNoHintMapsToGood() {
        XCTAssertEqual(Question.defaultQualityForHintTier(0), .good)
    }

    func testTierOneFirstHintMapsToGood() {
        // A single nudge isn't a fail — the kid still answered.
        XCTAssertEqual(Question.defaultQualityForHintTier(1), .good)
    }

    func testTierTwoSecondClueMapsToHard() {
        XCTAssertEqual(Question.defaultQualityForHintTier(2), .hard)
    }

    func testTierThreeFullSolutionMapsToForgot() {
        XCTAssertEqual(Question.defaultQualityForHintTier(3), .forgot)
    }

    func testHigherTiersStillForgot() {
        // Defensive — if the state machine grows a 4th tier, the
        // default stays at the most pessimistic value rather than
        // wrapping around. .forgot is the SRS-correct floor.
        XCTAssertEqual(Question.defaultQualityForHintTier(4), .forgot)
        XCTAssertEqual(Question.defaultQualityForHintTier(99), .forgot)
    }

    // MARK: - JSON round-trip preserves hints

    func testHintsRoundTripThroughJSON() throws {
        let original = question(
            hints: ["Tip A", "Tip B"],
            solutionSteps: ["fallback"]
        )
        let encoded = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(Question.self, from: encoded)
        XCTAssertEqual(decoded.hints, ["Tip A", "Tip B"])
        XCTAssertEqual(decoded.derivedHints, ["Tip A", "Tip B"])
    }

    func testHintsDecodeAsNilWhenFieldAbsent() throws {
        let json = """
        {
          "id": "q",
          "prompt": "Stub",
          "questionType": "shortAnswer",
          "answer": "A",
          "solutionSteps": ["one","two","three"],
          "commonMistakes": [],
          "variations": [],
          "difficulty": 1,
          "pageRefs": [],
          "needsHumanReview": false
        }
        """
        let q = try JSONDecoder().decode(
            Question.self, from: json.data(using: .utf8)!
        )
        XCTAssertNil(q.hints,
                     "absent `hints` field should decode to nil — backwards compat with existing pack JSON")
        XCTAssertEqual(q.derivedHints, ["one", "two"],
                       "nil hints should derive from solutionSteps.prefix(2)")
    }
}
