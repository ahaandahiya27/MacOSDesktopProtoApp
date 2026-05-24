import XCTest
@testable import desktopAhaan

/// Pure-derivation tests on `MasteryLevel.from(review:)`. Each row in
/// the table exercises one of the four buckets at a specific
/// QuestionReview state; the table doubles as documentation of the
/// boundary conditions.
final class MasteryLevelTests: XCTestCase {

    // MARK: - Fixtures

    private func review(
        bucket: Int = 0,
        ease: Double = 2.5,
        intervalDays: Int = 0,
        totalReviews: Int = 0,
        lapses: Int = 0
    ) -> QuestionReview {
        QuestionReview(
            questionId: "q",
            bucket: bucket,
            ease: ease,
            intervalDays: intervalDays,
            lastReviewedAt: Date(timeIntervalSince1970: 1_700_000_000),
            nextDueAt: Date(timeIntervalSince1970: 1_700_000_000),
            totalReviews: totalReviews,
            lapses: lapses
        )
    }

    // MARK: - Derivation rows

    func testBrandNewReviewIsLearning() {
        let r = review(bucket: 0, totalReviews: 0)
        XCTAssertEqual(MasteryLevel.from(review: r), .learning)
    }

    func testBucketZeroAfterForgotIsLearning() {
        // Kid answered once, hit Forgot, bucket reset to 0.
        let r = review(bucket: 0, ease: 2.3, intervalDays: 0,
                       totalReviews: 3, lapses: 1)
        XCTAssertEqual(MasteryLevel.from(review: r), .learning)
    }

    func testBucketOneIsFamiliar() {
        let r = review(bucket: 1, ease: 2.5, intervalDays: 1, totalReviews: 1)
        XCTAssertEqual(MasteryLevel.from(review: r), .familiar)
    }

    func testBucketTwoIsFamiliar() {
        let r = review(bucket: 2, ease: 2.5, intervalDays: 3, totalReviews: 2)
        XCTAssertEqual(MasteryLevel.from(review: r), .familiar)
    }

    func testBucketThreeIsConfident() {
        let r = review(bucket: 3, ease: 2.5, intervalDays: 7, totalReviews: 3)
        XCTAssertEqual(MasteryLevel.from(review: r), .confident)
    }

    func testBucketFourIsConfident() {
        let r = review(bucket: 4, ease: 2.5, intervalDays: 17, totalReviews: 4)
        XCTAssertEqual(MasteryLevel.from(review: r), .confident)
    }

    func testBucketFiveWithShortIntervalStillConfident() {
        // Bucket can hit 5 quickly via easy taps but the 21-day
        // interval floor on Mastered keeps it at Confident until the
        // scheduler has truly stretched the gap.
        let r = review(bucket: 5, ease: 2.5, intervalDays: 10, totalReviews: 5)
        XCTAssertEqual(MasteryLevel.from(review: r), .confident)
    }

    func testBucketFiveWithLongIntervalIsMastered() {
        let r = review(bucket: 5, ease: 2.7, intervalDays: 21, totalReviews: 6)
        XCTAssertEqual(MasteryLevel.from(review: r), .mastered)
    }

    func testBucketFiveAt22DaysIsMastered() {
        let r = review(bucket: 5, ease: 2.6, intervalDays: 22, totalReviews: 7)
        XCTAssertEqual(MasteryLevel.from(review: r), .mastered)
    }

    // MARK: - Display surface

    func testEveryLevelHasNonEmptyDisplayMetadata() {
        for level in MasteryLevel.allCases {
            XCTAssertFalse(level.displayName.isEmpty,
                           "\(level) has empty displayName")
            XCTAssertFalse(level.caption.isEmpty,
                           "\(level) has empty caption")
        }
    }

    func testRawValuesMatchOrder() {
        // Order in the enum is the visual progression — Learning at
        // the bottom of the mastery bar, Mastered at the top. The
        // dashboard's segmented bar relies on rawValue ordering.
        XCTAssertEqual(MasteryLevel.learning.rawValue,  0)
        XCTAssertEqual(MasteryLevel.familiar.rawValue,  1)
        XCTAssertEqual(MasteryLevel.confident.rawValue, 2)
        XCTAssertEqual(MasteryLevel.mastered.rawValue,  3)
    }
}
