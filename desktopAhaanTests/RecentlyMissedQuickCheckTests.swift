import XCTest
@testable import desktopAhaan

/// End-to-end coverage for the scene-quick-check migration's
/// learning-loop payoff: a wrong-answer scene quick-check must
/// surface in Daily Practice "Recently Missed" with the correct
/// chapter context.
///
/// Mirrors `RecentlyMissedBossQuizTests` exactly — scoped to the new
/// `scenecheck_` id prefix.
@MainActor
final class RecentlyMissedQuickCheckTests: XCTestCase {

    override func setUp() async throws {
        try await super.setUp()
        await MainActor.run {
            DataStore.shared.questionReviews = [:]
        }
    }

    /// The golden path: kid gets Ch.7 scene quick-check Q0 wrong → it
    /// lands in `recentlyMissedQuestionIds()` → SubjectRegistry resolves
    /// it back to (pack=science_class7, chapter=ch07).
    func testWrongAnswerSurfacesInRecentlyMissedWithCorrectChapter() async throws {
        let qcId = "scenecheck_ch07_q00"

        DataStore.shared.recordReview(
            questionId: qcId,
            quality: .forgot,
            at: Date(timeIntervalSince1970: 1_700_000_000)
        )

        let missed = DataStore.shared.recentlyMissedQuestionIds()
        XCTAssertTrue(missed.contains(qcId),
            "A `.forgot` review should land in recentlyMissedQuestionIds. " +
            "Got: \(missed)")

        let registry = SubjectRegistry()
        await waitForPacksLoaded(registry)
        let location = registry.location(forQuestionId: qcId)
        XCTAssertNotNil(location,
            "SubjectRegistry should resolve `\(qcId)` to a pack+chapter " +
            "after the migration.")
        XCTAssertEqual(location?.pack.id, "science_class7")
        XCTAssertEqual(location?.chapter.number, 7)
        XCTAssertEqual(location?.question.id, qcId)
        XCTAssertEqual(location?.question.effectiveSource, .sceneQuickCheck)
        XCTAssertFalse(location?.question.commonMistakes.isEmpty ?? true,
            "Post-enrichment, every quick-check must carry commonMistakes — " +
            "QuestionDetailView's commonMistakesCard otherwise renders blank " +
            "when the kid lands on it from Recently Missed.")
    }

    /// Multiple wrong answers across chapters all show up, in
    /// most-recent-first order.
    func testMultipleWrongAnswersAcrossChaptersAllSurface() async throws {
        let now = Date(timeIntervalSince1970: 1_700_000_000)
        let entries: [(String, TimeInterval)] = [
            ("scenecheck_ch04_q01", 0),
            ("scenecheck_ch08_q02", 60),
            ("scenecheck_ch13_q03", 120),
        ]
        for (id, dt) in entries {
            DataStore.shared.recordReview(
                questionId: id, quality: .forgot,
                at: now.addingTimeInterval(dt)
            )
        }

        let missed = DataStore.shared.recentlyMissedQuestionIds()
        XCTAssertEqual(Array(missed.prefix(3)),
                       ["scenecheck_ch13_q03", "scenecheck_ch08_q02", "scenecheck_ch04_q01"],
                       "Recently-missed is sorted by lastReviewedAt desc.")

        let registry = SubjectRegistry()
        await waitForPacksLoaded(registry)
        for (id, _) in entries {
            XCTAssertNotNil(registry.location(forQuestionId: id),
                "SubjectRegistry should resolve \(id) post-migration.")
        }
    }

    // MARK: - Helpers

    private func waitForPacksLoaded(_ registry: SubjectRegistry) async {
        for _ in 0..<50 {
            if !registry.isLoading && !registry.packs.isEmpty { return }
            try? await Task.sleep(nanoseconds: 50_000_000)
        }
    }
}
