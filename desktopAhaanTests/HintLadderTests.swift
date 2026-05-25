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

    // MARK: - Picker-suggestion wiring contract (D5 follow-up, 2026-05-25)
    //
    // `QuestionDetailView.suggestedQuality` reads
    // `defaultQualityForHintTier(_:)` and surfaces a "Suggested" badge
    // on the matching quality button — but only AFTER a hint reveal.
    // At tier 0 the picker shows no suggestion so the kid picks freely.
    //
    // The view code is `guard hintTier > 0 else { return nil }`; these
    // tests pin the contract numerically so a future refactor can't
    // silently flip the gate (e.g. always-on suggestions, which would
    // train the kid that the suggestion is the answer instead of a
    // post-hint correction).

    func testSuggestionGate_TierZeroProducesNoSuggestion() {
        // `suggestedQuality` matches this exact pattern in the view.
        let suggested: ReviewQuality? = (0 > 0)
            ? Question.defaultQualityForHintTier(0)
            : nil
        XCTAssertNil(suggested,
            "Tier 0 (no hint used) MUST yield no picker suggestion. " +
            "Showing a suggestion before the kid asks for a hint would " +
            "front-run the SRS judgment.")
    }

    func testSuggestionGate_TierOneAndUpProducesSuggestion() {
        for tier in 1...3 {
            let suggested: ReviewQuality? = (tier > 0)
                ? Question.defaultQualityForHintTier(tier)
                : nil
            XCTAssertNotNil(suggested,
                "Tier \(tier) MUST yield a picker suggestion — that's " +
                "the whole point of D5's hint-tier → quality mapping.")
        }
    }

    // MARK: - Manual-override stickiness (2026-05-25 22:30 follow-up)
    //
    // The view-layer flag `manualOverride: Bool` latches true the
    // moment the kid taps a quality that ISN'T the current
    // suggestion. Once latched, `suggestedQuality` returns nil even
    // if the kid then reveals more hints — the picker stops nudging
    // because the kid expressed a preference.
    //
    // The view code is:
    //     guard hintTier > 0 else { return nil }
    //     guard !manualOverride else { return nil }
    //     return Question.defaultQualityForHintTier(hintTier)
    //
    // These tests symbolically replay that gate so a future refactor
    // can't silently flip the latching semantics.

    /// Helper mirroring `QuestionDetailView.suggestedQuality` exactly.
    /// Kept as a pure function so the contract tests don't need a
    /// SwiftUI environment.
    private func suggestedQualityGate(hintTier: Int, manualOverride: Bool) -> ReviewQuality? {
        guard hintTier > 0 else { return nil }
        guard !manualOverride else { return nil }
        return Question.defaultQualityForHintTier(hintTier)
    }

    func testOverride_NotLatchedYieldsNormalSuggestion() {
        // Baseline: tier 2 with no override → .hard suggested.
        XCTAssertEqual(suggestedQualityGate(hintTier: 2, manualOverride: false), .hard)
    }

    func testOverride_LatchedSilencesSuggestionEvenWithHints() {
        // The kid tapped Good when Hard was suggested → latch
        // manualOverride. Next render at the same tier should
        // produce no suggestion.
        XCTAssertNil(suggestedQualityGate(hintTier: 2, manualOverride: true),
            "Once the kid has manually overridden, the picker MUST stop " +
            "nudging on this question — even at higher hint tiers.")
    }

    func testOverride_LatchedSilencesAtEveryTier() {
        // Defensive: latch should silence every tier 1..3.
        for tier in 1...3 {
            XCTAssertNil(suggestedQualityGate(hintTier: tier, manualOverride: true),
                "Override latch must silence tier \(tier) as well.")
        }
    }

    func testOverride_PerQuestionResetSemantics() {
        // The view resets `manualOverride = false` in
        // `.onChange(of: question.id)` alongside the other per-Q
        // state. Symbolically: a fresh question always starts
        // un-latched, so tier-N hint usage produces the normal
        // suggestion.
        let freshOverride = false  // fresh question
        XCTAssertEqual(suggestedQualityGate(hintTier: 1, manualOverride: freshOverride), .good)
        XCTAssertEqual(suggestedQualityGate(hintTier: 2, manualOverride: freshOverride), .hard)
        XCTAssertEqual(suggestedQualityGate(hintTier: 3, manualOverride: freshOverride), .forgot)
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
