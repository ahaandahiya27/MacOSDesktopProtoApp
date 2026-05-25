import XCTest
@testable import desktopAhaan

/// End-to-end coverage for the boss-quiz content migration's
/// learning-loop payoff (Hour 4-5, 2026-05-25): a wrong-answer Boss
/// Quiz item must surface in Daily Practice "Recently Missed" with
/// the correct chapter context.
///
/// Before this migration the SRS write was an "ephemeral" id that
/// `SubjectRegistry.location(forQuestionId:)` couldn't resolve, so
/// Daily Practice silently dropped the row. After the migration the
/// same id corresponds to a real pack `Question`, so the resolver
/// returns the (pack, chapter, question) triple and the row renders.
@MainActor
final class RecentlyMissedBossQuizTests: XCTestCase {

    override func setUp() async throws {
        try await super.setUp()
        await MainActor.run {
            DataStore.shared.questionReviews = [:]
        }
    }

    /// The golden path: kid gets Ch.1 Boss Quiz Q0 wrong → it lands
    /// in `recentlyMissedQuestionIds()` → SubjectRegistry resolves
    /// it back to (pack=science_class7, chapter=ch01).
    func testWrongAnswerSurfacesInRecentlyMissedWithCorrectChapter() async throws {
        let bossId = "bossquiz_ch01_q00"

        DataStore.shared.recordReview(
            questionId: bossId,
            quality: .forgot,
            at: Date(timeIntervalSince1970: 1_700_000_000)
        )

        let missed = DataStore.shared.recentlyMissedQuestionIds()
        XCTAssertTrue(missed.contains(bossId),
            "A `.forgot` review should land in recentlyMissedQuestionIds. " +
            "Got: \(missed)")

        let registry = SubjectRegistry()
        await waitForPacksLoaded(registry)
        let location = registry.location(forQuestionId: bossId)
        XCTAssertNotNil(location,
            "SubjectRegistry should resolve `\(bossId)` to a pack+chapter " +
            "after the migration. The Hour 1 commit wired the lookup; " +
            "the Hour 3 commit wrote the data.")
        XCTAssertEqual(location?.pack.id, "science_class7")
        XCTAssertEqual(location?.chapter.number, 1)
        XCTAssertEqual(location?.question.id, bossId)
        XCTAssertEqual(location?.question.effectiveSource, .bossQuiz)
    }

    /// Multiple wrong answers across chapters all show up, in
    /// most-recent-first order.
    func testMultipleWrongAnswersAcrossChaptersAllSurface() async throws {
        let now = Date(timeIntervalSince1970: 1_700_000_000)
        let entries: [(String, TimeInterval)] = [
            ("bossquiz_ch01_q01", 0),
            ("bossquiz_ch05_q02", 60),
            ("bossquiz_ch12_q03", 120),
        ]
        for (id, dt) in entries {
            DataStore.shared.recordReview(
                questionId: id, quality: .forgot,
                at: now.addingTimeInterval(dt)
            )
        }

        let missed = DataStore.shared.recentlyMissedQuestionIds()
        XCTAssertEqual(Array(missed.prefix(3)),
                       ["bossquiz_ch12_q03", "bossquiz_ch05_q02", "bossquiz_ch01_q01"],
                       "Recently-missed is sorted by lastReviewedAt desc.")

        let registry = SubjectRegistry()
        await waitForPacksLoaded(registry)
        for (id, _) in entries {
            XCTAssertNotNil(registry.location(forQuestionId: id),
                "SubjectRegistry should resolve \(id) post-migration.")
        }
    }

    /// A question answered correctly enough times to graduate past
    /// the "learning" bucket (≤1) MUST drop out of recently-missed.
    /// `recentlyMissedQuestionIds()` filters by `bucket <= 1`, so a
    /// single `.good` keeps it at bucket 1 (still learning); two
    /// good answers spaced a day apart promote it to bucket 2 and
    /// it should disappear from the surface.
    func testTwoCorrectAnswersGraduateOutOfRecentlyMissed() {
        let id = "bossquiz_ch07_q00"
        let day1 = Date(timeIntervalSince1970: 1_700_000_000)
        let day2 = day1.addingTimeInterval(86_400)
        DataStore.shared.recordReview(questionId: id, quality: .good, at: day1)
        DataStore.shared.recordReview(questionId: id, quality: .good, at: day2)

        let row = DataStore.shared.questionReviews[id]
        XCTAssertNotNil(row, "Two good answers should have created a review row.")
        XCTAssertGreaterThan(row?.bucket ?? 0, 1,
            "Two consecutive `.good` answers should promote bucket above 1. " +
            "Got bucket: \(row?.bucket ?? -1).")
        let missed = DataStore.shared.recentlyMissedQuestionIds()
        XCTAssertFalse(missed.contains(id),
            "A question with bucket > 1 should not surface as recently-missed.")
    }

    // MARK: - Helpers

    private func waitForPacksLoaded(_ registry: SubjectRegistry) async {
        // SubjectRegistry decodes packs off-thread. Poll briefly.
        for _ in 0..<50 {
            if !registry.isLoading && !registry.packs.isEmpty { return }
            try? await Task.sleep(nanoseconds: 50_000_000)
        }
    }
}
