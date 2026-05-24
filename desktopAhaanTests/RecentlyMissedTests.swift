import XCTest
@testable import desktopAhaan

/// Coverage for `DataStore.recentlyMissedQuestionIds(limit:)`. The
/// aggregator powers the new "Recently missed" segment in Daily
/// Practice and (later) the chapter-detail "Stuck here?" strip in
/// D4. Definition of missed lives in one place — these tests pin
/// it.
@MainActor
final class RecentlyMissedTests: XCTestCase {

    override func setUp() async throws {
        try await super.setUp()
        await MainActor.run {
            DataStore.shared.questionReviews = [:]
        }
    }

    private func review(
        id: String,
        bucket: Int,
        lastReviewedAt: Date,
        totalReviews: Int = 1
    ) -> QuestionReview {
        QuestionReview(
            questionId: id,
            bucket: bucket,
            ease: 2.5,
            intervalDays: 1,
            lastReviewedAt: lastReviewedAt,
            nextDueAt: lastReviewedAt,
            totalReviews: totalReviews,
            lapses: 0
        )
    }

    func testReturnsOnlyMissedQuestions() {
        // 5 reviews; 2 of them are missed (bucket ≤ 1).
        let now = Date(timeIntervalSince1970: 1_700_000_000)
        DataStore.shared.questionReviews = [
            "q_solid":   review(id: "q_solid",   bucket: 3, lastReviewedAt: now),
            "q_mastered": review(id: "q_mastered", bucket: 5, lastReviewedAt: now),
            "q_missed_1": review(id: "q_missed_1", bucket: 0, lastReviewedAt: now),
            "q_hard":     review(id: "q_hard",     bucket: 1, lastReviewedAt: now.addingTimeInterval(-60)),
            "q_brandnew": review(id: "q_brandnew", bucket: 0, lastReviewedAt: now,
                                 totalReviews: 0)  // never answered — excluded
        ]
        let missed = DataStore.shared.recentlyMissedQuestionIds()
        XCTAssertEqual(Set(missed), Set(["q_missed_1", "q_hard"]),
                       "should include bucket 0 and bucket 1 rows with totalReviews > 0; exclude bucket ≥ 2 and brand-new rows")
    }

    func testOrdersByLastReviewedAtDescending() {
        let now = Date(timeIntervalSince1970: 1_700_000_000)
        DataStore.shared.questionReviews = [
            "old":    review(id: "old",    bucket: 0, lastReviewedAt: now.addingTimeInterval(-3_600)),
            "newest": review(id: "newest", bucket: 0, lastReviewedAt: now),
            "middle": review(id: "middle", bucket: 1, lastReviewedAt: now.addingTimeInterval(-60))
        ]
        let missed = DataStore.shared.recentlyMissedQuestionIds()
        XCTAssertEqual(missed, ["newest", "middle", "old"])
    }

    func testHonoursLimit() {
        let now = Date(timeIntervalSince1970: 1_700_000_000)
        var map: [String: QuestionReview] = [:]
        for i in 0..<25 {
            let id = "q\(i)"
            map[id] = review(id: id, bucket: 0, lastReviewedAt: now.addingTimeInterval(TimeInterval(-i)))
        }
        DataStore.shared.questionReviews = map
        XCTAssertEqual(DataStore.shared.recentlyMissedQuestionIds(limit: 5).count, 5)
        XCTAssertEqual(DataStore.shared.recentlyMissedQuestionIds(limit: 25).count, 25)
        XCTAssertEqual(DataStore.shared.recentlyMissedQuestionIds(limit: 100).count, 25)
    }

    func testStoreWithOnlySolidQuestionsReturnsEmpty() {
        // Direct in-memory fixture — the singleton's disk-loaded
        // state can carry over from sibling tests in this target
        // (reviews.json reload races with setUp's clear), so this
        // test sets the map explicitly to its own clean shape.
        let now = Date(timeIntervalSince1970: 1_700_000_000)
        DataStore.shared.questionReviews = [
            "q_a": review(id: "q_a", bucket: 4, lastReviewedAt: now),
            "q_b": review(id: "q_b", bucket: 5, lastReviewedAt: now)
        ]
        XCTAssertEqual(DataStore.shared.recentlyMissedQuestionIds(), [],
                       "no bucket-≤1 rows should yield an empty list")
    }

    func testEphemeralIdsAppearInTheListWhenMissed() {
        // Boss-quiz ephemerals participate in the missed list just
        // like canonical question ids — the resolver downstream will
        // either find them in SubjectRegistry (bookEnd) or skip them
        // (bossquiz_*), but the aggregation itself doesn't care.
        let now = Date(timeIntervalSince1970: 1_700_000_000)
        DataStore.shared.questionReviews = [
            "bossquiz_ch04_q03": review(id: "bossquiz_ch04_q03",
                                        bucket: 0, lastReviewedAt: now)
        ]
        XCTAssertEqual(DataStore.shared.recentlyMissedQuestionIds(),
                       ["bossquiz_ch04_q03"])
    }
}
