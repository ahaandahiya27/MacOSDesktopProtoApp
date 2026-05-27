import XCTest
@testable import desktopAhaan

// MARK: - StuckHereStripQuickCheckTests
//
// Proves the D4 chapter-detail "Stuck here?" strip surfaces a
// recently-missed scene quick-check, alongside topic + boss-quiz ids.
//
// The strip's data source (`ChapterStuckHereStrip.signals(...)`) walks
// `chapter.allQuestionIds` intersected with the recently-missed set.
// The migration added the quick-check ids to `Chapter.allQuestionIds`,
// but nothing proved end-to-end that a missed quick-check actually lands
// in that intersection. This pins it: seed a `.forgot` review for a
// known Ch.8 quick-check, then assert the chapter-scoped intersection
// contains it.
@MainActor
final class StuckHereStripQuickCheckTests: XCTestCase {

    override func setUp() async throws {
        try await super.setUp()
        DataStore.shared.questionReviews = [:]
    }

    func testStuckHereStripIncludesMissedQuickCheck() async throws {
        let qcId = "scenecheck_ch08_q00"

        DataStore.shared.recordReview(
            questionId: qcId,
            quality: .forgot,
            at: Date(timeIntervalSince1970: 1_700_000_000)
        )

        let registry = SubjectRegistry()
        await waitForPacksLoaded(registry)

        guard let chapter = registry.packs
            .first(where: { $0.id == "science_class7" })?
            .chapters.first(where: { $0.number == 8 })
        else {
            throw XCTSkip("science_class7 Ch.8 not present in loaded packs.")
        }

        // Same shape the strip's data source uses: the chapter scope
        // intersected with the recently-missed set.
        let chapterIds = Set(chapter.allQuestionIds)
        let missed = Set(DataStore.shared.recentlyMissedQuestionIds())
        let intersection = chapterIds.intersection(missed)

        XCTAssertTrue(
            chapterIds.contains(qcId),
            "Chapter.allQuestionIds must include scene quick-check ids " +
            "for the strip to ever surface them."
        )
        XCTAssertTrue(
            intersection.contains(qcId),
            "ChapterStuckHereStrip's data source must surface " +
            "recently-missed scene quick-checks alongside topic + " +
            "boss-quiz ids. Intersection was: \(intersection.sorted())"
        )
    }

    // MARK: - Helpers

    private func waitForPacksLoaded(_ registry: SubjectRegistry) async {
        for _ in 0..<50 {
            if !registry.isLoading && !registry.packs.isEmpty { return }
            try? await Task.sleep(nanoseconds: 50_000_000)
        }
    }
}
