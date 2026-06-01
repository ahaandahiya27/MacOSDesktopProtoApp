import XCTest
@testable import desktopAhaan

// MARK: - MilestoneCheckpointResultTests
//
// v6 Learning Journey · Phase 4 M3. Covers the pure `MilestoneCheckpointResult.from`
// tally and the `DataStore` checkpoint-history persistence (append, latest, cap,
// read-only over the SRS).
@MainActor
final class MilestoneCheckpointResultTests: XCTestCase {

    private func aq(_ id: String, pack: String, title: String) -> AssessmentQuestion {
        AssessmentQuestion(
            packId: pack, subjectTitle: title, chapterTitle: "Chapter",
            question: Question(id: id, prompt: "p", questionType: .mcq,
                               options: ["a", "b"], answer: "a", solutionSteps: [],
                               commonMistakes: [], variations: [], difficulty: 2,
                               pageRefs: [], needsHumanReview: false))
    }

    private func tempStore() -> DataStore {
        let dir = FileManager.default.temporaryDirectory
            .appendingPathComponent("mcr-\(UUID().uuidString)")
        return DataStore(streakCalendar: nil, storeDir: dir, autoLoad: false)
    }

    private let base = Date(timeIntervalSince1970: 1_700_000_000)

    // MARK: - Pure tally

    func testFromTalliesScoreAndPerSubjectInOrder() {
        let assessment = MilestoneAssessment(
            questions: [aq("q1", pack: "P1", title: "One"),
                        aq("q2", pack: "P1", title: "One"),
                        aq("q3", pack: "P2", title: "Two")],
            generatedAt: base, subjectCounts: ["P1": 2, "P2": 1])
        let result = MilestoneCheckpointResult.from(
            assessment: assessment,
            correctById: ["q1": true, "q2": false, "q3": true],
            takenAt: base)

        XCTAssertEqual(result.correctCount, 2)
        XCTAssertEqual(result.totalQuestions, 3)
        XCTAssertEqual(result.scoreFraction, 2.0 / 3.0, accuracy: 1e-9)
        // Subject order matches first appearance in the quiz.
        XCTAssertEqual(result.perSubject.map { $0.packId }, ["P1", "P2"])
        XCTAssertEqual(result.perSubject[0].correct, 1)
        XCTAssertEqual(result.perSubject[0].total, 2)
        XCTAssertEqual(result.perSubject[1].correct, 1)
        XCTAssertEqual(result.perSubject[1].total, 1)
        XCTAssertEqual(result.perSubject[1].fraction, 1.0, accuracy: 1e-9)
    }

    func testFromHandlesEmptyAssessment() {
        let empty = MilestoneAssessment(questions: [], generatedAt: base, subjectCounts: [:])
        let result = MilestoneCheckpointResult.from(
            assessment: empty, correctById: [:], takenAt: base)
        XCTAssertEqual(result.correctCount, 0)
        XCTAssertEqual(result.totalQuestions, 0)
        XCTAssertEqual(result.scoreFraction, 0)
        XCTAssertTrue(result.perSubject.isEmpty)
    }

    // MARK: - Persistence

    private func sample(_ offset: TimeInterval, correct: Int = 4) -> MilestoneCheckpointResult {
        MilestoneCheckpointResult(
            takenAt: base.addingTimeInterval(offset), correctCount: correct,
            totalQuestions: 8,
            perSubject: [MilestoneSubjectScore(packId: "P1", subjectTitle: "One",
                                               correct: correct, total: 8)])
    }

    func testRecordAppendsAndLatestReturnsNewest() {
        let store = tempStore()
        store.recordCheckpointResult(sample(0, correct: 3))
        store.recordCheckpointResult(sample(100, correct: 7))
        store.flushSavesBeforeQuit()

        let all = store.loadCheckpointResults()
        XCTAssertEqual(all.count, 2)
        XCTAssertEqual(all.map { $0.correctCount }, [3, 7], "Stored oldest → newest.")
        XCTAssertEqual(store.latestCheckpointResult()?.correctCount, 7,
            "Latest is the most recently taken.")
    }

    func testRecordCapsHistoryToMostRecent() {
        let store = tempStore()
        // Record more than the cap; only the most recent should survive.
        let n = DataStore.milestoneCheckpointHistoryCap + 5
        for i in 0..<n { store.recordCheckpointResult(sample(TimeInterval(i), correct: i % 8)) }
        store.flushSavesBeforeQuit()

        let all = store.loadCheckpointResults()
        XCTAssertEqual(all.count, DataStore.milestoneCheckpointHistoryCap,
            "History is capped.")
        // The survivors are the most recent ones (largest offsets).
        XCTAssertEqual(all.first?.takenAt, base.addingTimeInterval(TimeInterval(5)),
            "The oldest survivor is offset 5 (the first 5 were dropped).")
        XCTAssertEqual(all.last?.takenAt, base.addingTimeInterval(TimeInterval(n - 1)))
    }

    func testRecordIsReadOnlyOverSRS() {
        let store = tempStore()
        store.questionReviews = [
            "q1": QuestionReview(questionId: "q1", bucket: 2, ease: 2.4, intervalDays: 3,
                                 lastReviewedAt: base, nextDueAt: base, totalReviews: 3,
                                 lapses: 0, packId: "science_class7")]
        let before = store.questionReviews

        store.recordCheckpointResult(sample(0))
        store.flushSavesBeforeQuit()

        XCTAssertEqual(store.questionReviews, before,
            "Recording a checkpoint must not touch the SRS.")
    }
}
