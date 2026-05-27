import XCTest
@testable import desktopAhaan

// MARK: - CrossPackReviewResolutionTests
//
// Pins the fix for cross-pack bare-id mis-attribution introduced when the
// Maths pack landed alongside Science. Bare topic-question ids
// (`chNN_tNN_qNN`) are ALLOWED to collide across packs, so resolving a
// review by id alone is ambiguous — the flat index returns whichever pack
// sorts first (Maths). `QuestionReview.packId` (captured at record time)
// plus `SubjectRegistry.location(forQuestionId:preferredPackId:)` make the
// resolution unambiguous, so Recently-Missed / Daily Practice / Mastery
// attribute the review to the subject the kid actually answered it in.
@MainActor
final class CrossPackReviewResolutionTests: XCTestCase {

    /// A question id that exists in BOTH science and maths (95 such
    /// collisions as of the 2026-05-27 audit).
    private let collidingId = "ch01_t01_q01"

    override func setUp() async throws {
        try await super.setUp()
        DataStore.shared.questionReviews = [:]
    }

    func testPreferredPackIdResolvesCollidingIdToOwningPack() async throws {
        let registry = SubjectRegistry()
        await waitForPacksLoaded(registry)

        // Sanity: the id really does live in both packs.
        let inScience = registry.location(forQuestionId: collidingId,
                                          preferredPackId: "science_class7")
        let inMaths = registry.location(forQuestionId: collidingId,
                                        preferredPackId: "maths_class7")
        try XCTSkipIf(inScience == nil || inMaths == nil,
            "Expected \(collidingId) in both science + maths packs.")

        XCTAssertEqual(inScience?.pack.id, "science_class7",
            "preferredPackId must pin resolution to the science pack.")
        XCTAssertEqual(inMaths?.pack.id, "maths_class7",
            "preferredPackId must pin resolution to the maths pack.")

        // The bare (no-preference) lookup still returns SOMETHING — the
        // first-writer-wins behaviour is preserved for legacy callers.
        XCTAssertNotNil(registry.location(forQuestionId: collidingId),
            "Bare lookup should still resolve (first-writer-wins).")
    }

    func testRecordReviewStoresPackId() throws {
        DataStore.shared.recordReview(
            questionId: collidingId, quality: .forgot,
            at: Date(timeIntervalSince1970: 1_700_000_000),
            packId: "science_class7"
        )
        XCTAssertEqual(DataStore.shared.questionReviews[collidingId]?.packId,
                       "science_class7",
            "recordReview(packId:) must persist the owning pack so downstream " +
            "surfaces can disambiguate colliding ids.")
    }

    func testReReviewBackfillsPackIdButNilNeverClearsIt() throws {
        let t = Date(timeIntervalSince1970: 1_700_000_000)
        // First review tags the pack.
        DataStore.shared.recordReview(questionId: collidingId, quality: .forgot,
                                      at: t, packId: "science_class7")
        // A later review WITHOUT a packId (e.g. from a context that doesn't
        // know it) must not wipe the previously-recorded pack.
        DataStore.shared.recordReview(questionId: collidingId, quality: .good,
                                      at: t.addingTimeInterval(60))
        XCTAssertEqual(DataStore.shared.questionReviews[collidingId]?.packId,
                       "science_class7",
            "A nil packId on re-review must preserve the prior pack tag.")
    }

    func testRecentlyMissedResolvesToRecordedPack() async throws {
        DataStore.shared.recordReview(
            questionId: collidingId, quality: .forgot,
            at: Date(timeIntervalSince1970: 1_700_000_000),
            packId: "science_class7"
        )
        let registry = SubjectRegistry()
        await waitForPacksLoaded(registry)

        let resolved = DataStore.shared.recentlyMissedQuestionIds().compactMap {
            registry.location(forQuestionId: $0,
                              preferredPackId: DataStore.shared.questionReviews[$0]?.packId)
        }
        XCTAssertEqual(resolved.first?.pack.id, "science_class7",
            "A review recorded in science must resolve back to science in " +
            "the recently-missed surface, not to whichever pack sorts first.")
    }

    // MARK: - Helpers

    private func waitForPacksLoaded(_ registry: SubjectRegistry) async {
        for _ in 0..<50 {
            if !registry.isLoading && !registry.packs.isEmpty { return }
            try? await Task.sleep(nanoseconds: 50_000_000)
        }
    }
}
