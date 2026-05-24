import XCTest
@testable import desktopAhaan

/// Aggregation tests for `DataStore.masterySummary(forPackId:chapters:locator:)`.
/// The injected `locator` closure stands in for `SubjectRegistry`, so
/// the tests don't need to spin up a real registry or load a pack.
@MainActor
final class MasterySummaryTests: XCTestCase {

    // MARK: - Fixtures

    /// In-memory DataStore keyed on a temp directory so the test
    /// doesn't write to the user's real Application Support.
    private func makeStore() -> DataStore {
        // The init can't be parameterized for storage path without a
        // broader refactor, so each test runs against the shared
        // singleton — but only mutates `questionReviews`, which the
        // tests reset in setUp/tearDown so no cross-test bleed.
        return DataStore.shared
    }

    private func review(
        id: String,
        bucket: Int,
        intervalDays: Int = 1,
        totalReviews: Int = 1
    ) -> QuestionReview {
        QuestionReview(
            questionId: id,
            bucket: bucket,
            ease: 2.5,
            intervalDays: intervalDays,
            lastReviewedAt: Date(timeIntervalSince1970: 1_700_000_000),
            nextDueAt: Date(timeIntervalSince1970: 1_700_000_000),
            totalReviews: totalReviews,
            lapses: 0
        )
    }

    /// Locator that recognises ids of the form "<chapterId>:<questionId>"
    /// and maps each chapterId to a synthetic title + number. Keeps the
    /// test independent of the loaded pack.
    private let locator: (String) -> (chapterId: String, chapterTitle: String, chapterNumber: Int)? = { id in
        let parts = id.split(separator: ":", maxSplits: 1).map(String.init)
        guard parts.count == 2 else { return nil }
        let chapterId = parts[0]
        let chapterNumber: Int
        switch chapterId {
        case "ch01": chapterNumber = 1
        case "ch02": chapterNumber = 2
        case "ch03": chapterNumber = 3
        default:     chapterNumber = 99
        }
        return (chapterId, "Chapter \(chapterNumber) (test)", chapterNumber)
    }

    override func setUp() async throws {
        try await super.setUp()
        await MainActor.run {
            DataStore.shared.questionReviews = [:]
        }
    }

    // MARK: - Aggregation behaviour

    func testEmptyStoreProducesEmptySummary() {
        let store = makeStore()
        let summary = store.masterySummary(
            forPackId: "science_class7",
            chapters: [],
            locator: locator
        )
        XCTAssertTrue(summary.isEmpty)
        XCTAssertEqual(summary.totalReviewed, 0)
        XCTAssertEqual(summary.overallMasteryFraction, 0)
    }

    func testGroupsByChapterAndBucket() {
        let store = makeStore()
        store.questionReviews = [
            "ch01:q1": review(id: "ch01:q1", bucket: 0,  totalReviews: 1),   // Learning
            "ch01:q2": review(id: "ch01:q2", bucket: 2,  totalReviews: 2),   // Familiar
            "ch01:q3": review(id: "ch01:q3", bucket: 3,  totalReviews: 3),   // Confident
            "ch02:q1": review(id: "ch02:q1", bucket: 5,  intervalDays: 30, totalReviews: 6) // Mastered
        ]

        let summary = store.masterySummary(
            forPackId: "science_class7",
            chapters: [],
            locator: locator
        )

        XCTAssertEqual(summary.chapters.count, 2)
        XCTAssertEqual(summary.totalReviewed, 4)

        let ch1 = summary.chapters.first { $0.chapterId == "ch01" }
        XCTAssertNotNil(ch1)
        XCTAssertEqual(ch1?.counts[.learning],  1)
        XCTAssertEqual(ch1?.counts[.familiar],  1)
        XCTAssertEqual(ch1?.counts[.confident], 1)

        let ch2 = summary.chapters.first { $0.chapterId == "ch02" }
        XCTAssertEqual(ch2?.counts[.mastered],  1)
    }

    func testChaptersSortedByNumber() {
        let store = makeStore()
        store.questionReviews = [
            "ch03:q1": review(id: "ch03:q1", bucket: 1),
            "ch01:q1": review(id: "ch01:q1", bucket: 1),
            "ch02:q1": review(id: "ch02:q1", bucket: 1)
        ]
        let summary = store.masterySummary(
            forPackId: "science_class7",
            chapters: [],
            locator: locator
        )
        XCTAssertEqual(summary.chapters.map(\.chapterNumber), [1, 2, 3])
    }

    func testUnresolvableQuestionIdsAreSkipped() {
        let store = makeStore()
        store.questionReviews = [
            "ghost_question_id": review(id: "ghost_question_id", bucket: 4),
            "ch01:q1":            review(id: "ch01:q1", bucket: 2)
        ]
        let summary = store.masterySummary(
            forPackId: "science_class7",
            chapters: [],
            locator: locator
        )
        XCTAssertEqual(summary.totalReviewed, 1)
        XCTAssertEqual(summary.chapters.count, 1)
        XCTAssertEqual(summary.chapters.first?.chapterId, "ch01")
    }

    func testMasteryFractionWeighting() {
        let store = makeStore()
        // Two mastered, two learning → weighted = 2*1.0 + 2*0.0 = 2.0
        // total = 4, fraction = 0.5
        store.questionReviews = [
            "ch01:q1": review(id: "ch01:q1", bucket: 5, intervalDays: 30, totalReviews: 6),
            "ch01:q2": review(id: "ch01:q2", bucket: 5, intervalDays: 30, totalReviews: 6),
            "ch01:q3": review(id: "ch01:q3", bucket: 0, totalReviews: 1),
            "ch01:q4": review(id: "ch01:q4", bucket: 0, totalReviews: 1)
        ]
        let summary = store.masterySummary(
            forPackId: "science_class7",
            chapters: [],
            locator: locator
        )
        XCTAssertEqual(summary.overallMasteryFraction, 0.5, accuracy: 0.001)
        XCTAssertEqual(summary.chapters.first?.masteryFraction ?? -1, 0.5, accuracy: 0.001)
    }
}
