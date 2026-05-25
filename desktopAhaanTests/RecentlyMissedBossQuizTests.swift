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

    /// A correct answer DOESN'T land in recently-missed.
    /// Guards against a regression that would noise up the surface.
    func testCorrectAnswerDoesNotSurfaceInRecentlyMissed() {
        DataStore.shared.recordReview(
            questionId: "bossquiz_ch07_q00",
            quality: .good,
            at: Date(timeIntervalSince1970: 1_700_000_000)
        )
        let missed = DataStore.shared.recentlyMissedQuestionIds()
        XCTAssertFalse(missed.contains("bossquiz_ch07_q00"),
            ".good answers shouldn't surface in recently-missed.")
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
