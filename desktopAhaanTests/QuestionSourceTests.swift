import XCTest
@testable import desktopAhaan

/// `QuestionSource` enum + the Optional `source` / `hints` decoder
/// additions on `Question`. The contract: existing
/// `science_class7.json` (which has no `source` field on any of its
/// 732 questions) must decode cleanly, and `effectiveSource` must
/// return `.bookEnd` for those entries.
final class QuestionSourceTests: XCTestCase {

    // MARK: - Enum identity

    func testCanonicalRawValues() {
        // Raw values are wire-stable — bumping them is a schema
        // migration. Pin them so a careless rename gets caught.
        XCTAssertEqual(QuestionSource.bookEnd.rawValue,         "book_end")
        XCTAssertEqual(QuestionSource.bossQuiz.rawValue,        "boss_quiz")
        XCTAssertEqual(QuestionSource.sceneQuickCheck.rawValue, "scene_quick_check")
    }

    func testDefaultIsBookEnd() {
        XCTAssertEqual(QuestionSource.default, .bookEnd)
    }

    func testAllCasesEnumerated() {
        // Catches a future case being added without bumping
        // the recently-missed router's switch statements.
        XCTAssertEqual(QuestionSource.allCases.count, 3)
    }

    // MARK: - Question.source decode

    private func question(withSourceField field: String?) throws -> Question {
        let sourceLine = field.map { "\"source\": \"\($0)\"," } ?? ""
        let json = """
        {
          "id": "ch01_t01_q01",
          "prompt": "Stub",
          "questionType": "mcq",
          "options": ["A","B"],
          "answer": "A",
          "solutionSteps": ["Pick A"],
          "commonMistakes": [],
          "variations": [],
          "difficulty": 1,
          "pageRefs": [],
          "needsHumanReview": false,
          \(sourceLine)
          "matchPairs": null
        }
        """
        let data = json.data(using: .utf8)!
        return try JSONDecoder().decode(Question.self, from: data)
    }

    func testBookEndQuestionDecodesUnchangedWhenSourceFieldAbsent() throws {
        let q = try question(withSourceField: nil)
        XCTAssertNil(q.source)
        XCTAssertEqual(q.effectiveSource, .bookEnd)
    }

    func testExplicitBookEndSourceDecodes() throws {
        let q = try question(withSourceField: "book_end")
        XCTAssertEqual(q.source, .bookEnd)
        XCTAssertEqual(q.effectiveSource, .bookEnd)
    }

    func testExplicitBossQuizSourceDecodes() throws {
        let q = try question(withSourceField: "boss_quiz")
        XCTAssertEqual(q.source, .bossQuiz)
        XCTAssertEqual(q.effectiveSource, .bossQuiz)
    }

    func testExplicitSceneQuickCheckSourceDecodes() throws {
        let q = try question(withSourceField: "scene_quick_check")
        XCTAssertEqual(q.source, .sceneQuickCheck)
        XCTAssertEqual(q.effectiveSource, .sceneQuickCheck)
    }

    func testUnknownSourceFailsDecode() {
        // The Codable system rejects an unknown raw value rather than
        // silently dropping. Pin so a future "lenient parser" doesn't
        // mask schema drift.
        XCTAssertThrowsError(try question(withSourceField: "made_up"))
    }

    // MARK: - Round-trip Question with source set

    func testQuestionWithSourceRoundTripsThroughJSON() throws {
        let original = Question(
            id: "stub_1", prompt: "P", questionType: .mcq,
            options: ["a","b"], answer: "a",
            solutionSteps: ["pick a"], commonMistakes: [], variations: [],
            difficulty: 1, pageRefs: [], needsHumanReview: false,
            matchPairs: nil,
            source: .bossQuiz,
            hints: ["First clue", "Second clue"]
        )
        let encoded = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(Question.self, from: encoded)
        XCTAssertEqual(decoded.source, .bossQuiz)
        XCTAssertEqual(decoded.hints, ["First clue", "Second clue"])
    }

    func testExistingScienceClass7PackStillDecodes() throws {
        // The big stress test — load the real pack and confirm every
        // question's `effectiveSource` resolves to `.bookEnd`. If any
        // entry now silently shipped a source field, this catches it.
        let url = Bundle.main.url(forResource: "science_class7",
                                  withExtension: "json")
        XCTAssertNotNil(url, "science_class7.json missing from bundle")
        guard let url = url else { return }
        let data = try Data(contentsOf: url)
        let pack = try JSONDecoder().decode(SubjectPack.self, from: data)
        var checked = 0
        for chapter in pack.chapters {
            for topic in chapter.topics {
                for q in topic.questions {
                    XCTAssertEqual(
                        q.effectiveSource, .bookEnd,
                        "Question \(q.id) decoded with unexpected source \(String(describing: q.source))"
                    )
                    checked += 1
                }
            }
        }
        XCTAssertGreaterThan(checked, 700,
                             "expected the science pack to carry >700 questions; got \(checked)")
    }
}
