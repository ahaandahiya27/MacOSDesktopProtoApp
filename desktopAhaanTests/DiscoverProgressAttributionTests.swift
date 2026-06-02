import XCTest
@testable import desktopAhaan

// MARK: - DiscoverProgressAttributionTests
//
// v8 Longitudinal Insights · Phase 4. Pins the per-subject Discover attribution:
// the pure id-prefix inference, the init that auto-populates packId, and the
// forward-compatible decode of legacy `discover.json` rows (absent packId → nil,
// recovered via `resolvedPackId`).

final class DiscoverProgressAttributionTests: XCTestCase {

    func testInferredPackIdByPrefix() {
        XCTAssertEqual(DiscoverProgress.inferredPackId(fromChapterId: "ch01"), "science_class7")
        XCTAssertEqual(DiscoverProgress.inferredPackId(fromChapterId: "ch19"), "science_class7")
        XCTAssertEqual(DiscoverProgress.inferredPackId(fromChapterId: "mch06"), "maths_class7")
        XCTAssertEqual(DiscoverProgress.inferredPackId(fromChapterId: "sch03"), "sanskrit_class7")
        XCTAssertEqual(DiscoverProgress.inferredPackId(fromChapterId: "ssch20"), "socialscience_class7")
    }

    func testInferencePrefixOrderingIsUnambiguous() {
        // ssch must not be swallowed by sch; mch/sch must not be by ch.
        XCTAssertEqual(DiscoverProgress.inferredPackId(fromChapterId: "ssch01"), "socialscience_class7")
        XCTAssertEqual(DiscoverProgress.inferredPackId(fromChapterId: "sch01"), "sanskrit_class7")
        XCTAssertEqual(DiscoverProgress.inferredPackId(fromChapterId: "mch01"), "maths_class7")
        XCTAssertNil(DiscoverProgress.inferredPackId(fromChapterId: "weird99"))
    }

    func testInitAutoPopulatesPackIdFromChapterId() {
        let maths = DiscoverProgress(chapterId: "mch06", sceneId: "scene1")
        XCTAssertEqual(maths.packId, "maths_class7")
        // Explicit packId wins over inference.
        let forced = DiscoverProgress(chapterId: "mch06", sceneId: "scene1",
                                      packId: "science_class7")
        XCTAssertEqual(forced.packId, "science_class7")
    }

    func testLegacyRowDecodesWithoutPackIdAndRecovers() throws {
        // A discover.json row written before the packId field existed.
        let legacyJSON = """
        [{"id":"mch06::scene1","chapterId":"mch06","sceneId":"scene1",
          "completedAt":760000000}]
        """.data(using: .utf8)!
        let rows = try JSONDecoder().decode([DiscoverProgress].self, from: legacyJSON)
        XCTAssertEqual(rows.count, 1)
        XCTAssertNil(rows[0].packId, "Absent packId must decode cleanly as nil.")
        XCTAssertEqual(rows[0].resolvedPackId, "maths_class7",
            "resolvedPackId recovers the subject from the chapter-id prefix.")
    }

    func testRoundTripPreservesPackId() throws {
        let row = DiscoverProgress(chapterId: "ssch09", sceneId: "scene2",
                                   score: 3, maxScore: 4)
        let data = try JSONEncoder().encode([row])
        let back = try JSONDecoder().decode([DiscoverProgress].self, from: data)
        XCTAssertEqual(back.first?.packId, "socialscience_class7")
        XCTAssertEqual(back.first?.score, 3)
        XCTAssertEqual(back.first?.maxScore, 4)
    }
}
