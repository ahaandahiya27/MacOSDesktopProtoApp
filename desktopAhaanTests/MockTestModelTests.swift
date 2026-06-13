import XCTest
@testable import desktopAhaan

// MARK: - MockTestModelTests
//
// v9 Exam Simulation · Phase 1. Pure value-model tests: config clamps, presets,
// difficulty-band admission, the marking scheme, and the paper's derived
// properties. No registry, no DataStore.
final class MockTestModelTests: XCTestCase {

    // MARK: - Difficulty band

    func testDifficultyBandAdmission() {
        XCTAssertTrue(MockTestDifficultyBand.foundation.admits(difficulty: 1))
        XCTAssertTrue(MockTestDifficultyBand.foundation.admits(difficulty: 2))
        XCTAssertFalse(MockTestDifficultyBand.foundation.admits(difficulty: 3))

        XCTAssertTrue(MockTestDifficultyBand.challenge.admits(difficulty: 3))
        XCTAssertTrue(MockTestDifficultyBand.challenge.admits(difficulty: 5))
        XCTAssertFalse(MockTestDifficultyBand.challenge.admits(difficulty: 2))

        // Balanced admits the whole 1…5 spread.
        for d in 1...5 { XCTAssertTrue(MockTestDifficultyBand.balanced.admits(difficulty: d)) }
    }

    func testDifficultyBandClampsOutOfRangeDifficulty() {
        // A datum at 0 or 9 is clamped into 1…5 before the range test, so it
        // can't silently fall out of every band.
        XCTAssertTrue(MockTestDifficultyBand.foundation.admits(difficulty: 0))
        XCTAssertTrue(MockTestDifficultyBand.challenge.admits(difficulty: 9))
    }

    // MARK: - Config clamps

    func testConfigClampsCountAndTime() {
        let c = MockTestConfig(selection: .mixed, band: .balanced,
                               questionCount: 0, timeLimitSeconds: 5)
        XCTAssertEqual(c.questionCount, 1, "Count floored at 1.")
        XCTAssertEqual(c.timeLimitSeconds, 60, "Time floored at 60 s.")
    }

    func testSubjectSelectionHelpers() {
        XCTAssertTrue(MockTestSubjectSelection.mixed.isMixed)
        XCTAssertNil(MockTestSubjectSelection.mixed.singlePackId)
        let single = MockTestSubjectSelection.single(packId: "science_class7")
        XCTAssertFalse(single.isMixed)
        XCTAssertEqual(single.singlePackId, "science_class7")
    }

    // MARK: - Presets

    func testPresets() {
        XCTAssertEqual(MockTestPreset.quick.questionCount, 15)
        XCTAssertEqual(MockTestPreset.quick.timeLimitSeconds, 20 * 60)
        XCTAssertEqual(MockTestPreset.standard.questionCount, 30)
        XCTAssertEqual(MockTestPreset.standard.timeLimitSeconds, 45 * 60)
        XCTAssertEqual(MockTestPreset.quick.summary, "15 Q · 20 min")

        let config = MockTestPreset.standard.config(
            selection: .single(packId: "maths_class7"), band: .challenge)
        XCTAssertEqual(config.questionCount, 30)
        XCTAssertEqual(config.timeLimitSeconds, 45 * 60)
        XCTAssertEqual(config.band, .challenge)
        XCTAssertEqual(config.selection.singlePackId, "maths_class7")
    }

    // MARK: - Marking scheme

    func testMarkingScheme() {
        let std = MockTestMarkingScheme.standard
        XCTAssertEqual(std.marks(correct: true, answered: true), 4)
        XCTAssertEqual(std.marks(correct: false, answered: true), -1)
        XCTAssertEqual(std.marks(correct: false, answered: false), 0)
        XCTAssertEqual(std.marks(correct: true, answered: false), 0,
            "Unanswered is always 0, even if the 'correct' flag were set.")

        let gentle = MockTestMarkingScheme.gentle
        XCTAssertEqual(gentle.marks(correct: true, answered: true), 1)
        XCTAssertEqual(gentle.marks(correct: false, answered: true), 0)
    }

    // MARK: - Paper derived properties

    func testPaperDerivedProperties() {
        func q(_ id: String) -> Question {
            Question(id: id, prompt: "p", questionType: .mcq, options: ["a", "b"],
                     answer: "a", solutionSteps: [], commonMistakes: [], variations: [],
                     difficulty: 2, pageRefs: [], needsHumanReview: false)
        }
        func mq(_ pack: String, _ subject: String, _ qid: String) -> MockTestQuestion {
            MockTestQuestion(packId: pack, subjectTitle: subject, chapterId: "1",
                             chapterTitle: "Ch 1", topicKey: "t1", topicTitle: "T1",
                             bank: .topic, question: q(qid))
        }
        let config = MockTestConfig(selection: .mixed, band: .balanced,
                                    questionCount: 3, timeLimitSeconds: 600)
        let p = MockTestPaper(questions: [
            mq("sci", "Science", "a"), mq("sci", "Science", "b"), mq("mat", "Maths", "c")
        ], config: config, generatedAt: Date())

        XCTAssertFalse(p.isEmpty)
        XCTAssertEqual(p.count, 3)
        XCTAssertEqual(p.subjectTitles, ["Science", "Maths"], "First-appearance order.")
        XCTAssertEqual(p.subjectCounts["sci"], 2)
        XCTAssertEqual(p.subjectCounts["mat"], 1)

        // Composite identity disambiguates a bare id shared across packs.
        XCTAssertEqual(mq("sci", "Science", "ch01_q1").id, "sci::ch01_q1")
        XCTAssertNotEqual(mq("sci", "Science", "ch01_q1").id, mq("san", "Sanskrit", "ch01_q1").id)
    }

    func testEmptyPaperIsEmpty() {
        let config = MockTestConfig(selection: .mixed, band: .balanced,
                                    questionCount: 5, timeLimitSeconds: 600)
        let p = MockTestPaper(questions: [], config: config, generatedAt: Date())
        XCTAssertTrue(p.isEmpty)
        XCTAssertEqual(p.count, 0)
        XCTAssertTrue(p.subjectTitles.isEmpty)
    }
}
