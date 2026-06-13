import XCTest
@testable import desktopAhaan

// MARK: - MockTestRunStateTests
//
// v9 Exam Simulation · Phase 5. Drives the `MockTestRunState` machine directly
// (no real timer, fixed clock) to pin the clock, answering, mark-for-review,
// navigation, submit (manual + auto), and leak-safety. Grading correctness lives
// in `MockTestEngineTests`; this file owns the live-runner behaviour.
@MainActor
final class MockTestRunStateTests: XCTestCase {

    // MARK: - Builders

    private func question(_ id: String, answer: String = "a") -> Question {
        Question(id: id, prompt: "Prompt \(id)", questionType: .mcq,
                 options: ["a", "b", "c"], answer: answer, solutionSteps: [],
                 commonMistakes: [], variations: [], difficulty: 2,
                 pageRefs: [], needsHumanReview: false)
    }

    private func mq(_ pack: String, _ id: String, topic: String = "t1") -> MockTestQuestion {
        MockTestQuestion(packId: pack, subjectTitle: "Subject \(pack)", chapterId: "1",
                         chapterTitle: "Ch 1", topicKey: topic, topicTitle: "Topic \(topic)",
                         bank: .topic, question: question(id))
    }

    private func paper(_ count: Int, timeLimit: Int = 600) -> MockTestPaper {
        let qs = (0..<count).map { mq("p", "q\($0)", topic: "t\($0 % 3)") }
        let config = MockTestConfig(selection: .single(packId: "p"), band: .balanced,
                                    questionCount: count, timeLimitSeconds: timeLimit)
        return MockTestPaper(questions: qs, config: config, generatedAt: Date(timeIntervalSince1970: 0))
    }

    private func run(_ count: Int, timeLimit: Int = 600) -> MockTestRunState {
        MockTestRunState(paper: paper(count, timeLimit: timeLimit),
                         schedulesTimer: false, clock: { Date(timeIntervalSince1970: 42) })
    }

    // MARK: - Clock

    func testTickDecrementsAndChargesCurrentQuestion() {
        let r = run(3, timeLimit: 600)
        XCTAssertEqual(r.remainingSeconds, 600)
        r.tick()
        XCTAssertEqual(r.remainingSeconds, 599)
        r.tick()
        XCTAssertEqual(r.remainingSeconds, 598)
        // Both seconds charged to question 0 (the on-screen one).
        XCTAssertEqual(r.secondsByPaperId[r.paper.questions[0].id], 2)
        XCTAssertNil(r.secondsByPaperId[r.paper.questions[1].id])
    }

    func testTimeChargedToWhicheverQuestionIsOnScreen() {
        let r = run(2, timeLimit: 600)
        r.tick()                 // charges q0
        r.goNext()
        r.tick(); r.tick()       // charges q1 twice
        XCTAssertEqual(r.secondsByPaperId[r.paper.questions[0].id], 1)
        XCTAssertEqual(r.secondsByPaperId[r.paper.questions[1].id], 2)
    }

    func testAutoSubmitsWhenClockReachesZero() {
        let r = run(2, timeLimit: 60)
        for _ in 0..<59 { r.tick(); XCTAssertFalse(r.isFinished) }
        XCTAssertEqual(r.remainingSeconds, 1)
        r.tick()                 // 60th tick zeroes the clock and auto-submits.
        XCTAssertEqual(r.remainingSeconds, 0)
        XCTAssertTrue(r.isFinished)
        XCTAssertTrue(r.didAutoSubmit)
        XCTAssertEqual(r.result?.autoSubmitted, true)
        // A tick after finishing is a no-op.
        r.tick()
        XCTAssertEqual(r.remainingSeconds, 0)
    }

    func testIsLowTimeInLastMinute() {
        let r = run(1, timeLimit: 90)
        XCTAssertFalse(r.isLowTime)
        for _ in 0..<30 { r.tick() }   // 90 → 60
        XCTAssertTrue(r.isLowTime, "≤ 60s left is low-time.")
    }

    // MARK: - Answering + marking

    func testSelectRecordsAnswerForCurrentQuestionOnly() {
        let r = run(3)
        r.select("b")
        XCTAssertEqual(r.selection(forPaperId: r.paper.questions[0].id), "b")
        XCTAssertTrue(r.isAnswered(r.paper.questions[0].id))
        XCTAssertFalse(r.isAnswered(r.paper.questions[1].id))
        XCTAssertEqual(r.answeredCount, 1)
        // Re-selecting overwrites, doesn't add.
        r.select("c")
        XCTAssertEqual(r.selection(forPaperId: r.paper.questions[0].id), "c")
        XCTAssertEqual(r.answeredCount, 1)
    }

    func testMarkForReviewToggles() {
        let r = run(2)
        let id = r.paper.questions[0].id
        XCTAssertFalse(r.isMarked(id))
        r.toggleMarkForReview()
        XCTAssertTrue(r.isMarked(id))
        XCTAssertEqual(r.markedCount, 1)
        r.toggleMarkForReview()
        XCTAssertFalse(r.isMarked(id))
    }

    func testAnsweredFraction() {
        let r = run(4)
        XCTAssertEqual(r.answeredFraction, 0)
        r.select("a"); r.goNext(); r.select("a")
        XCTAssertEqual(r.answeredFraction, 0.5, accuracy: 0.0001)
    }

    // MARK: - Navigation

    func testNavigationClampsAtBounds() {
        let r = run(3)
        XCTAssertFalse(r.canGoPrevious)
        XCTAssertTrue(r.canGoNext)
        r.goPrevious()                       // clamped — stays at 0
        XCTAssertEqual(r.index, 0)
        r.goNext(); r.goNext()               // → 2 (last)
        XCTAssertEqual(r.index, 2)
        XCTAssertFalse(r.canGoNext)
        r.goNext()                           // clamped — stays at 2
        XCTAssertEqual(r.index, 2)
        r.go(to: 1)
        XCTAssertEqual(r.index, 1)
        r.go(to: 99)                         // clamped to last
        XCTAssertEqual(r.index, 2)
    }

    func testStatusReflectsState() {
        let r = run(4)
        r.select("a")                        // q0 answered, current
        r.go(to: 1); r.toggleMarkForReview() // q1 marked
        r.go(to: 2); r.select("a"); r.toggleMarkForReview() // q2 answered + marked
        r.go(to: 3)                          // q3 current, untouched
        XCTAssertEqual(r.status(forIndex: 0), .answered)
        XCTAssertEqual(r.status(forIndex: 1), .marked)
        XCTAssertEqual(r.status(forIndex: 2), .markedAnswered)
        XCTAssertEqual(r.status(forIndex: 3), .current)
    }

    // MARK: - Submit

    func testManualSubmitGradesAndIsIdempotent() {
        let r = run(3)
        r.select("a")                        // q0 correct
        r.goNext(); r.select("b")            // q1 wrong
        r.submit()
        XCTAssertTrue(r.isFinished)
        XCTAssertFalse(r.didAutoSubmit)
        let result = r.result
        XCTAssertEqual(result?.correctCount, 1)
        XCTAssertEqual(result?.wrongCount, 1)
        XCTAssertEqual(result?.unansweredCount, 1)
        XCTAssertEqual(result?.takenAt, Date(timeIntervalSince1970: 42),
            "Grading uses the injected clock, not the wall clock.")
        // Second submit is ignored — result unchanged.
        r.submit(auto: true)
        XCTAssertEqual(r.result?.takenAt, Date(timeIntervalSince1970: 42))
        XCTAssertFalse(r.didAutoSubmit, "A no-op submit cannot flip the auto flag.")
    }

    func testSelectAndNavigateAreNoOpsAfterFinish() {
        let r = run(2)
        r.submit()
        let answeredBefore = r.answeredCount
        r.select("a")
        r.goNext()
        XCTAssertEqual(r.answeredCount, answeredBefore, "No answering after submit.")
        XCTAssertEqual(r.index, 0, "No navigation after submit.")
    }

    func testFormat() {
        XCTAssertEqual(MockTestRunState.format(0), "00:00")
        XCTAssertEqual(MockTestRunState.format(65), "01:05")
        XCTAssertEqual(MockTestRunState.format(2_700), "45:00")
        XCTAssertEqual(MockTestRunState.format(-5), "00:00", "Negative clamps to 00:00.")
    }

    // MARK: - Leak safety

    func testRunStateDeallocsWithNoTimerRetained() {
        weak var weakRun: MockTestRunState?
        autoreleasepool {
            let r = MockTestRunState(paper: paper(2), schedulesTimer: false)
            weakRun = r
            r.tick()
            XCTAssertNotNil(weakRun)
        }
        XCTAssertNil(weakRun, "With no scheduled timer, the run state must not leak.")
    }
}
