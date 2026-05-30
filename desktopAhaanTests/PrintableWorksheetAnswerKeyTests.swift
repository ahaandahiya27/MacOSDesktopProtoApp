import XCTest
@testable import desktopAhaan

/// Pins the worksheet answer-key derivation: each line maps the question's
/// number to the letter of its correct option.
final class PrintableWorksheetAnswerKeyTests: XCTestCase {

    private func mcq(_ id: String, options: [String], answer: String) -> Question {
        Question(id: id, prompt: "p", questionType: .mcq, options: options,
                 answer: answer, solutionSteps: [], commonMistakes: [],
                 variations: [], difficulty: 2, pageRefs: [], needsHumanReview: false)
    }

    func testOptionLetterMapping() {
        XCTAssertEqual(WorksheetSampler.optionLetter(0), "a")
        XCTAssertEqual(WorksheetSampler.optionLetter(1), "b")
        XCTAssertEqual(WorksheetSampler.optionLetter(3), "d")
    }

    func testAnswerLetterMatchesCorrectOption() {
        let q = mcq("q1", options: ["W", "X", "Y", "Z"], answer: "Y")
        XCTAssertEqual(WorksheetSampler.answerLetter(for: q), "c")
    }

    func testAnswerLetterNilWhenAnswerNotInOptions() {
        let q = mcq("q1", options: ["W", "X"], answer: "ZZZ")
        XCTAssertNil(WorksheetSampler.answerLetter(for: q))
    }

    func testAnswerKeyMatchesSelectedQuestionsInOrder() {
        let questions = [
            mcq("q1", options: ["a1", "b1", "c1", "d1"], answer: "b1"),  // b
            mcq("q2", options: ["a2", "b2", "c2", "d2"], answer: "d2"),  // d
            mcq("q3", options: ["a3", "b3", "c3", "d3"], answer: "a3")   // a
        ]
        XCTAssertEqual(WorksheetSampler.answerKey(for: questions),
                       ["1. b", "2. d", "3. a"])
    }

    func testAnswerKeyUsesQuestionMarkForUnresolvableAnswer() {
        let questions = [mcq("q1", options: ["a", "b"], answer: "nope")]
        XCTAssertEqual(WorksheetSampler.answerKey(for: questions), ["1. ?"])
    }
}
