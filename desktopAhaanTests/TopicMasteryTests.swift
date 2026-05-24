import XCTest
@testable import desktopAhaan

/// Per-topic mastery aggregation tests. Validates that
/// `DataStore.masterySummary` with a `topicLocator` correctly
/// partitions reviews into per-topic buckets while preserving the
/// existing per-chapter counts (no double-counting).
@MainActor
final class TopicMasteryTests: XCTestCase {

    override func setUp() async throws {
        try await super.setUp()
        await MainActor.run {
            DataStore.shared.questionReviews = [:]
        }
    }

    private func review(
        id: String,
        bucket: Int = 1,
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

    /// Synthetic locator that returns chapter ch01 for any question
    /// starting with "ch01_", with topic id = first 9 chars
    /// (`ch01_tNN`). Lets tests reason about the partition without
    /// loading a real pack.
    private let chapterLocator: (String) -> (chapterId: String, chapterTitle: String, chapterNumber: Int)? = { id in
        guard id.hasPrefix("ch01_") else { return nil }
        return (chapterId: "ch01", chapterTitle: "Chapter 1", chapterNumber: 1)
    }

    /// Topic id derived from a "ch01_tNN_qII"-shaped question id.
    /// Topic display order = N (so t1 lands before t2 in the
    /// sorted result).
    private let topicLocator: (String) -> TopicLocation? = { id in
        guard id.hasPrefix("ch01_t") else { return nil }
        let prefix = String(id.prefix(8))  // "ch01_tNN"
        let topicNumStart = id.index(id.startIndex, offsetBy: 6)
        let topicNumEnd = id.index(topicNumStart, offsetBy: 2)
        let numString = String(id[topicNumStart..<topicNumEnd])
        let order = Int(numString) ?? 0
        return TopicLocation(
            topicId: prefix,
            topicTitle: "Topic \(numString)",
            displayOrder: order
        )
    }

    // MARK: - Basic partition

    func testReviewsBucketedByTopic() {
        let store = DataStore.shared
        store.questionReviews = [
            "ch01_t01_q1": review(id: "ch01_t01_q1", bucket: 0),  // Topic 1 / Learning
            "ch01_t01_q2": review(id: "ch01_t01_q2", bucket: 3),  // Topic 1 / Confident
            "ch01_t01_q3": review(id: "ch01_t01_q3", bucket: 1),  // Topic 1 / Familiar
            "ch01_t02_q1": review(id: "ch01_t02_q1", bucket: 5, intervalDays: 30, totalReviews: 6) // Topic 2 / Mastered
        ]

        let summary = store.masterySummary(
            forPackId: "science_class7",
            chapters: [],
            locator: chapterLocator,
            topicLocator: topicLocator
        )

        XCTAssertEqual(summary.chapters.count, 1)
        let chapter = summary.chapters[0]
        XCTAssertEqual(chapter.topicSummaries.count, 2)

        let t1 = chapter.topicSummaries.first { $0.topicId == "ch01_t01" }!
        XCTAssertEqual(t1.counts[.learning], 1)
        XCTAssertEqual(t1.counts[.familiar], 1)
        XCTAssertEqual(t1.counts[.confident], 1)
        XCTAssertEqual(t1.totalReviewed, 3)

        let t2 = chapter.topicSummaries.first { $0.topicId == "ch01_t02" }!
        XCTAssertEqual(t2.counts[.mastered], 1)
        XCTAssertEqual(t2.totalReviewed, 1)
    }

    // MARK: - Display order

    func testTopicsSortedByDisplayOrder() {
        let store = DataStore.shared
        // Seed reviews out of order to prove sort works.
        store.questionReviews = [
            "ch01_t03_q1": review(id: "ch01_t03_q1"),
            "ch01_t01_q1": review(id: "ch01_t01_q1"),
            "ch01_t02_q1": review(id: "ch01_t02_q1")
        ]
        let summary = store.masterySummary(
            forPackId: "science_class7",
            chapters: [],
            locator: chapterLocator,
            topicLocator: topicLocator
        )
        let order = summary.chapters[0].topicSummaries.map(\.displayOrder)
        XCTAssertEqual(order, [1, 2, 3],
                       "topics must appear in displayOrder ascending")
    }

    // MARK: - Empty drill-down

    func testEmptyTopicSummariesWhenTopicLocatorOmitted() {
        let store = DataStore.shared
        store.questionReviews = [
            "ch01_t01_q1": review(id: "ch01_t01_q1", bucket: 2)
        ]
        // No topicLocator passed — backwards-compat path.
        let summary = store.masterySummary(
            forPackId: "science_class7",
            chapters: [],
            locator: chapterLocator
        )
        XCTAssertEqual(summary.chapters.count, 1)
        XCTAssertTrue(summary.chapters[0].topicSummaries.isEmpty,
            "topicLocator nil → topicSummaries empty (pre-D6 behaviour preserved)")
    }

    func testEmptyTopicSummariesWhenTopicLocatorReturnsNil() {
        let store = DataStore.shared
        store.questionReviews = [
            "ch01_t01_q1": review(id: "ch01_t01_q1", bucket: 2)
        ]
        let summary = store.masterySummary(
            forPackId: "science_class7",
            chapters: [],
            locator: chapterLocator,
            topicLocator: { _ in nil }
        )
        // Chapter-level counts still populate even if topic
        // metadata is unknown.
        XCTAssertEqual(summary.chapters[0].counts[.familiar], 1)
        XCTAssertTrue(summary.chapters[0].topicSummaries.isEmpty)
    }

    // MARK: - Chapter-level + topic-level agree

    func testChapterCountsEqualSumOfTopicCounts() {
        let store = DataStore.shared
        store.questionReviews = [
            "ch01_t01_q1": review(id: "ch01_t01_q1", bucket: 0),
            "ch01_t01_q2": review(id: "ch01_t01_q2", bucket: 3),
            "ch01_t02_q1": review(id: "ch01_t02_q1", bucket: 1),
            "ch01_t02_q2": review(id: "ch01_t02_q2", bucket: 5, intervalDays: 30, totalReviews: 6),
            "ch01_t02_q3": review(id: "ch01_t02_q3", bucket: 4)
        ]
        let summary = store.masterySummary(
            forPackId: "science_class7",
            chapters: [],
            locator: chapterLocator,
            topicLocator: topicLocator
        )
        let chapter = summary.chapters[0]
        let topicSum: [MasteryLevel: Int] = chapter.topicSummaries.reduce(into: [:]) { acc, t in
            for (level, count) in t.counts {
                acc[level, default: 0] += count
            }
        }
        for level in MasteryLevel.allCases {
            XCTAssertEqual(
                topicSum[level] ?? 0,
                chapter.counts[level] ?? 0,
                "chapter and topic counts disagree on \(level)"
            )
        }
    }
}
