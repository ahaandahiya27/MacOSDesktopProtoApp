import XCTest
@testable import desktopAhaan

// MARK: - MockTestBuildTests
//
// v9 Exam Simulation · Phase 1. Live-half tests over `DataStore.buildMockTest`
// (gathering across all four banks + reuse of the v6 planner), the persistence
// round-trip, and the deliberate SRS recording path — run on one seeded,
// ISOLATED temp store over the live registry.
@MainActor
final class MockTestBuildTests: XCTestCase {

    private func loadedRegistry() async throws -> SubjectRegistry {
        let registry = SubjectRegistry()
        for _ in 0..<50 {
            if !registry.isLoading && !registry.packs.isEmpty { break }
            try? await Task.sleep(nanoseconds: 50_000_000)
        }
        guard !registry.packs.isEmpty else { throw XCTSkip("No packs loaded in 2.5 s.") }
        return registry
    }

    private func tempStore() -> DataStore {
        let dir = FileManager.default.temporaryDirectory
            .appendingPathComponent("mocktest-\(UUID().uuidString)")
        return DataStore(streakCalendar: nil, storeDir: dir, autoLoad: false)
    }

    private func srsSignature(_ reviews: [String: QuestionReview]) -> [String: String] {
        reviews.mapValues {
            "\($0.totalReviews)|\($0.lapses)|\($0.bucket)|\($0.ease)|\($0.intervalDays)|\($0.nextDueAt.timeIntervalSince1970)"
        }
    }

    private func config(_ selection: MockTestSubjectSelection,
                        _ band: MockTestDifficultyBand,
                        count: Int) -> MockTestConfig {
        MockTestConfig(selection: selection, band: band,
                       questionCount: count, timeLimitSeconds: 1200)
    }

    // MARK: - Build

    func testBuildIsDeterministicAndHasNoDuplicates() async throws {
        let registry = try await loadedRegistry()
        let store = tempStore()
        let now = Date()
        let cfg = config(.mixed, .balanced, count: 20)

        let first = store.buildMockTest(registry: registry, config: cfg, now: now)
        let second = store.buildMockTest(registry: registry, config: cfg, now: now)
        XCTAssertEqual(first.questions.map { $0.id }, second.questions.map { $0.id },
            "Same config + same review state → identical paper.")
        XCTAssertFalse(first.isEmpty, "The live packs yield a non-empty balanced paper.")
        XCTAssertLessThanOrEqual(first.count, 20, "Never exceeds the requested count.")
        XCTAssertEqual(Set(first.questions.map { $0.id }).count, first.count,
            "No duplicate question appears twice in one paper.")
    }

    func testBuildIsReadOnlyOverSRS() async throws {
        let registry = try await loadedRegistry()
        let store = tempStore()
        // Seed a few reviews so there's real mastery signal to weight by.
        var reviews: [String: QuestionReview] = [:]
        let past = Date().addingTimeInterval(-3600)
        if let pack = registry.pack(withId: "science_class7") {
            var taken = 0
            outer: for chapter in pack.chapters {
                for topic in chapter.topics {
                    for q in topic.questions {
                        reviews[q.id] = QuestionReview(
                            questionId: q.id, bucket: taken % 4, ease: 2.1,
                            intervalDays: 3, lastReviewedAt: past, nextDueAt: past,
                            totalReviews: 2, lapses: 0, packId: pack.id)
                        taken += 1
                        if taken >= 6 { break outer }
                    }
                }
            }
        }
        store.questionReviews = reviews
        let before = srsSignature(store.questionReviews)
        _ = store.buildMockTest(registry: registry, config: config(.mixed, .balanced, count: 30))
        XCTAssertEqual(srsSignature(store.questionReviews), before,
            "buildMockTest must never mutate questionReviews.")
    }

    func testBuildSingleSubjectDrawsOnlyThatPack() async throws {
        let registry = try await loadedRegistry()
        let store = tempStore()
        let cfg = config(.single(packId: "maths_class7"), .balanced, count: 15)
        let paper = store.buildMockTest(registry: registry, config: cfg)
        try XCTSkipIf(paper.isEmpty, "Maths pack produced no eligible MCQs.")
        XCTAssertTrue(paper.questions.allSatisfy { $0.packId == "maths_class7" },
            "A single-subject paper draws only from the chosen pack.")
    }

    func testBuildFoundationBandFiltersByDifficulty() async throws {
        let registry = try await loadedRegistry()
        let store = tempStore()
        let cfg = config(.mixed, .foundation, count: 30)
        let paper = store.buildMockTest(registry: registry, config: cfg)
        try XCTSkipIf(paper.isEmpty, "No foundation-band MCQs across the packs.")
        XCTAssertTrue(
            paper.questions.allSatisfy { MockTestDifficultyBand.foundation.admits(difficulty: $0.question.difficulty) },
            "Every question in a Foundation paper is difficulty 1–2.")
    }

    func testBuildEmptyWhenNoRegistry() {
        let store = tempStore()
        let paper = store.buildMockTest(registry: nil, config: config(.mixed, .balanced, count: 10))
        XCTAssertTrue(paper.isEmpty)
    }

    // MARK: - Persistence round-trip

    func testRecordAndLoadResultsRoundTrip() async throws {
        let store = tempStore()
        let r1 = makeResult(takenAt: Date(timeIntervalSince1970: 1_000))
        let r2 = makeResult(takenAt: Date(timeIntervalSince1970: 2_000))
        store.recordMockTestResult(r2)
        store.recordMockTestResult(r1)   // out of order on purpose
        let loaded = store.loadMockTestResults()
        XCTAssertEqual(loaded.count, 2)
        XCTAssertEqual(loaded.map { $0.takenAt }, [r1.takenAt, r2.takenAt],
            "Stored oldest → newest regardless of insertion order.")
        XCTAssertEqual(store.latestMockTestResult()?.takenAt, r2.takenAt)
    }

    func testHistoryIsCapped() {
        let store = tempStore()
        for i in 0..<(DataStore.mockTestHistoryCap + 10) {
            store.recordMockTestResult(makeResult(takenAt: Date(timeIntervalSince1970: Double(i) * 100)))
        }
        XCTAssertEqual(store.loadMockTestResults().count, DataStore.mockTestHistoryCap,
            "History never grows past the cap.")
    }

    // MARK: - SRS recording (the one deliberate write)

    func testRecordReviewsOnlyWritesAnsweredQuestions() {
        let store = tempStore()
        XCTAssertTrue(store.questionReviews.isEmpty)
        let result = makeResultWithOutcomes()
        let recorded = store.recordMockTestReviews(result, at: Date())
        XCTAssertEqual(recorded, 2, "Two answered questions recorded; the unanswered one skipped.")
        XCTAssertNotNil(store.questionReviews["mt_correct"], "Correct answer recorded a review.")
        XCTAssertNotNil(store.questionReviews["mt_wrong"], "Wrong answer recorded a review.")
        XCTAssertNil(store.questionReviews["mt_skipped"], "Unanswered question is NOT recorded.")
        // The correct answer should carry a higher bucket than the wrong (.forgot
        // resets to 0); proves quality was mapped, not just a blind write.
        XCTAssertEqual(store.questionReviews["mt_wrong"]?.bucket, 0)
        XCTAssertGreaterThanOrEqual(store.questionReviews["mt_correct"]?.bucket ?? 0, 1)
    }

    // MARK: - Fixtures

    private func makeResult(takenAt: Date) -> MockTestResult {
        MockTestResult(
            takenAt: takenAt, band: .balanced, isMixed: true,
            timeLimitSeconds: 600, autoSubmitted: false,
            totalQuestions: 1, correctCount: 1, wrongCount: 0, unansweredCount: 0,
            totalMarks: 4, maxMarks: 4, totalSecondsSpent: 30,
            perSubject: [], perTopic: [], outcomes: [])
    }

    private func outcome(_ id: String, selected: String?, correct: Bool) -> MockTestQuestionOutcome {
        MockTestQuestionOutcome(
            paperId: "p::\(id)", packId: "science_class7", questionId: id,
            subjectTitle: "Science", chapterTitle: "Ch 1", topicKey: "t1",
            topicTitle: "T1", bank: .topic, prompt: "p", correctAnswer: "a",
            selectedAnswer: selected, isCorrect: correct,
            secondsSpent: 10, marksAwarded: correct ? 4 : (selected == nil ? 0 : -1))
    }

    private func makeResultWithOutcomes() -> MockTestResult {
        let outcomes = [
            outcome("mt_correct", selected: "a", correct: true),
            outcome("mt_wrong", selected: "b", correct: false),
            outcome("mt_skipped", selected: nil, correct: false)
        ]
        return MockTestResult(
            takenAt: Date(), band: .balanced, isMixed: false,
            timeLimitSeconds: 600, autoSubmitted: false,
            totalQuestions: 3, correctCount: 1, wrongCount: 1, unansweredCount: 1,
            totalMarks: 3, maxMarks: 12, totalSecondsSpent: 30,
            perSubject: [], perTopic: [], outcomes: outcomes)
    }
}
