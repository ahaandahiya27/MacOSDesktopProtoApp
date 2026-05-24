import XCTest
@testable import desktopAhaan

/// Coverage for `DataStore.recordEphemeralReview` — the shared write
/// path that boss-quiz and (future) scene-quick-check surfaces use to
/// push their answers into the SRS scheduler.
@MainActor
final class EphemeralReviewTests: XCTestCase {

    override func setUp() async throws {
        try await super.setUp()
        await MainActor.run {
            DataStore.shared.questionReviews = [:]
        }
    }

    // MARK: - Recording

    func testRecordsAReviewRowForAnEphemeralId() {
        DataStore.shared.recordEphemeralReview(
            ephemeralId: "bossquiz_ch01_q00",
            quality: .good,
            at: Date(timeIntervalSince1970: 1_700_000_000)
        )
        let row = DataStore.shared.questionReviews["bossquiz_ch01_q00"]
        XCTAssertNotNil(row)
        XCTAssertEqual(row?.questionId, "bossquiz_ch01_q00")
        XCTAssertGreaterThanOrEqual(row?.bucket ?? 0, 1,
            "first .good answer should promote the bucket from 0 to ≥1")
    }

    func testForgotResetsBucketToZero() {
        let now = Date(timeIntervalSince1970: 1_700_000_000)
        // Build up a bucket via two .good answers, then knock it back.
        DataStore.shared.recordEphemeralReview(
            ephemeralId: "bossquiz_ch01_q01", quality: .good, at: now)
        DataStore.shared.recordEphemeralReview(
            ephemeralId: "bossquiz_ch01_q01", quality: .good,
            at: now.addingTimeInterval(86_400))
        DataStore.shared.recordEphemeralReview(
            ephemeralId: "bossquiz_ch01_q01", quality: .forgot,
            at: now.addingTimeInterval(172_800))
        XCTAssertEqual(DataStore.shared.questionReviews["bossquiz_ch01_q01"]?.bucket, 0)
    }

    func testCreditsTheStreak() {
        UserDefaults.standard.removeObject(forKey: AppStorageKeys.reviewStreakDays)
        UserDefaults.standard.removeObject(forKey: AppStorageKeys.reviewStreakLastDate)

        let priorStreak = UserDefaults.standard.integer(forKey: AppStorageKeys.reviewStreakDays)
        DataStore.shared.recordEphemeralReview(
            ephemeralId: "bossquiz_ch01_q02",
            quality: .good,
            at: Date()
        )
        let afterStreak = UserDefaults.standard.integer(forKey: AppStorageKeys.reviewStreakDays)
        XCTAssertGreaterThan(afterStreak, priorStreak,
            "recordEphemeralReview should credit the daily streak the same as recordReview")
    }

    // MARK: - Due queue

    func testDueQuestionIdsIncludesEphemerals() {
        DataStore.shared.recordEphemeralReview(
            ephemeralId: "bossquiz_ch01_q03",
            quality: .forgot,                  // forgot → due ~10 min later
            at: Date().addingTimeInterval(-3_600)  // 1h ago
        )
        let due = DataStore.shared.dueQuestionIds()
        XCTAssertTrue(due.contains("bossquiz_ch01_q03"),
                      "ephemeral id should appear in the due-now queue once it's been answered + the interval has elapsed")
    }

    // MARK: - id prefix sniff

    func testIsEphemeralReviewIdRecognisesBossQuiz() {
        XCTAssertTrue(DataStore.isEphemeralReviewId("bossquiz_ch01_q00"))
        XCTAssertTrue(DataStore.isEphemeralReviewId("bossquiz_ch19_q14"))
    }

    func testIsEphemeralReviewIdRecognisesSceneCheck() {
        XCTAssertTrue(DataStore.isEphemeralReviewId("scenecheck_ch04_scene2_q1"))
    }

    func testIsEphemeralReviewIdRejectsCanonical() {
        // Real pack ids start with "chNN_t..." or similar — not in
        // the ephemeral prefix list.
        XCTAssertFalse(DataStore.isEphemeralReviewId("ch01_t01_q05"))
        XCTAssertFalse(DataStore.isEphemeralReviewId(""))
        XCTAssertFalse(DataStore.isEphemeralReviewId("random"))
    }

    // MARK: - Resolver tolerance

    func testSubjectRegistryLocationReturnsNilForEphemeralId() {
        // The DailyPracticeView resolver uses
        // `SubjectRegistry.location(forQuestionId:)` then compactMaps —
        // unresolvable ids fall through silently. Pin that the
        // registry returns nil for an ephemeral id rather than
        // crashing or fabricating a fake row.
        let registry = SubjectRegistry()
        XCTAssertNil(registry.location(forQuestionId: "bossquiz_ch01_q00"))
    }
}
