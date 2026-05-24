import XCTest
@testable import desktopAhaan

/// Data assertions covering `RelatedChaptersStrip.targetCounts(...)` —
/// the pure-data derivation that drives which chips render. The
/// algorithm is tested directly via synthetic `ConceptMap` instances;
/// the per-chapter expectation tests use the real bundled pack so
/// they break loudly if the JSON authoring loses a pointer.
///
/// Tests run against `science_class7.json` loaded from the bundle
/// (same pattern as ChapterContentTests / Ch2_19_StructuralRatchetTests).
final class RelatedChaptersStripTests: XCTestCase {

    // MARK: - Helpers

    private func loadPack() throws -> SubjectPack {
        guard let url = Bundle.main.url(forResource: "science_class7", withExtension: "json") else {
            throw XCTSkip("science_class7.json missing from test bundle resources.")
        }
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(SubjectPack.self, from: data)
    }

    /// Runs the strip's derivation against a real bundled chapter.
    private func realChapterTargets(in pack: SubjectPack, for chapterId: String) -> [(targetId: String, count: Int)] {
        guard let chapter = pack.chapters.first(where: { $0.id == chapterId }) else { return [] }
        let validIds = Set(pack.chapters.map { $0.id })
        return RelatedChaptersStrip.targetCounts(
            in: chapter.conceptMap,
            hostChapterId: chapter.id,
            validTargetIds: validIds
        )
    }

    // MARK: - Real-pack per-chapter expectations

    /// Ch.19 is the documented hub from the 2026-05-24 propagation
    /// (REMEDIATION_LOG, Round 7). Its concept map reaches into
    /// ch04 (convection), ch07 (climate), ch08 (cyclones), and
    /// ch16 (water cycle) — four distinct target chapters.
    func testCh19ReachesFourChapters() throws {
        let pack = try loadPack()
        let targets = realChapterTargets(in: pack, for: "ch19")
        let ids = Set(targets.map { $0.targetId })
        XCTAssertEqual(ids, ["ch04", "ch07", "ch08", "ch16"],
                       "Ch.19 should reach the four documented target chapters from the cross-chapter pointers shipped in commit 7e8a3c6.")
    }

    /// Ch.1 (the pilot chapter) reaches into bio + env clusters via
    /// pointers documented in REMEDIATION_LOG. Soft assertion: must
    /// hit at least 2 target chapters (deliberately not pinning the
    /// exact set so authoring can add more without breaking the test).
    func testCh1HasMultipleRelatedChapters() throws {
        let pack = try loadPack()
        let targets = realChapterTargets(in: pack, for: "ch01")
        XCTAssertGreaterThanOrEqual(targets.count, 2,
                                    "Ch.1 should reach at least 2 other chapters via concept-map cross-chapter pointers.")
    }

    // MARK: - Algorithm-correctness tests (synthetic ConceptMap)

    /// The derivation returns an empty list when the concept map is
    /// nil — the strip uses this signal to auto-hide.
    func testNilConceptMapYieldsNoTargets() {
        let targets = RelatedChaptersStrip.targetCounts(
            in: nil, hostChapterId: "ch01", validTargetIds: ["ch01", "ch02"]
        )
        XCTAssertTrue(targets.isEmpty,
                      "A nil conceptMap must yield zero targets (the strip will auto-hide).")
    }

    /// A concept map with no `.crossChapter` nodes (only `.concept`
    /// or `.pivot`) yields no targets.
    func testConceptMapWithoutCrossChapterNodesYieldsNoTargets() {
        let map = ConceptMap(
            nodes: [
                ConceptMapNode(id: "ch01_c01", label: "A", kind: .concept,
                               x: 0.5, y: 0.5),
                ConceptMapNode(id: "ch01_pivot", label: "Pivot", kind: .pivot,
                               x: 0.5, y: 0.5),
            ],
            edges: []
        )
        let targets = RelatedChaptersStrip.targetCounts(
            in: map, hostChapterId: "ch01", validTargetIds: ["ch01", "ch02"]
        )
        XCTAssertTrue(targets.isEmpty,
                      "Maps without crossChapter nodes must yield zero targets.")
    }

    /// Self-references and unresolved targets must both be filtered
    /// out — otherwise the kid could tap a chip that goes back to
    /// themselves OR to a chapter that doesn't exist.
    func testSelfRefsAndUnresolvedTargetsAreFiltered() {
        let map = ConceptMap(
            nodes: [
                // Self-reference — must be dropped.
                ConceptMapNode(id: "ch01:foo", label: "Self", kind: .crossChapter,
                               x: 0.5, y: 0.5),
                // Unresolved target (ch99 not in validTargetIds) — must be dropped.
                ConceptMapNode(id: "ch99:foo", label: "Ghost", kind: .crossChapter,
                               x: 0.5, y: 0.5),
                // Resolvable target — must survive.
                ConceptMapNode(id: "ch02:foo", label: "Real", kind: .crossChapter,
                               x: 0.5, y: 0.5),
            ],
            edges: []
        )
        let targets = RelatedChaptersStrip.targetCounts(
            in: map, hostChapterId: "ch01", validTargetIds: ["ch01", "ch02"]
        )
        XCTAssertEqual(targets.count, 1,
                       "Self-references and unresolved targets must be filtered; only the resolvable target survives.")
        XCTAssertEqual(targets.first?.targetId, "ch02")
    }

    /// Multiple pointers to the same target chapter must roll up to
    /// a single chip with count = N. Without this rollup the chip's
    /// "·N" badge would always show 1.
    func testRepeatedTargetsRollUpToCount() {
        let map = ConceptMap(
            nodes: [
                ConceptMapNode(id: "ch02:a", label: "A", kind: .crossChapter,
                               x: 0.5, y: 0.5),
                ConceptMapNode(id: "ch02:b", label: "B", kind: .crossChapter,
                               x: 0.5, y: 0.5),
                ConceptMapNode(id: "ch02:c", label: "C", kind: .crossChapter,
                               x: 0.5, y: 0.5),
            ],
            edges: []
        )
        let targets = RelatedChaptersStrip.targetCounts(
            in: map, hostChapterId: "ch01", validTargetIds: ["ch01", "ch02"]
        )
        XCTAssertEqual(targets.count, 1)
        XCTAssertEqual(targets.first?.count, 3,
                       "Three pointers to the same target chapter must roll up to count = 3.")
    }

    /// Result order is sorted by target chapter id so the chip strip
    /// renders stably across re-renders. Without this, SwiftUI's
    /// diffing could shuffle the chips between re-builds.
    func testResultIsSortedByTargetId() {
        let map = ConceptMap(
            nodes: [
                ConceptMapNode(id: "ch17:a", label: "L", kind: .crossChapter,
                               x: 0.5, y: 0.5),
                ConceptMapNode(id: "ch02:b", label: "B", kind: .crossChapter,
                               x: 0.5, y: 0.5),
                ConceptMapNode(id: "ch10:c", label: "M", kind: .crossChapter,
                               x: 0.5, y: 0.5),
            ],
            edges: []
        )
        let targets = RelatedChaptersStrip.targetCounts(
            in: map, hostChapterId: "ch01",
            validTargetIds: ["ch01", "ch02", "ch10", "ch17"]
        )
        XCTAssertEqual(targets.map { $0.targetId }, ["ch02", "ch10", "ch17"],
                       "Targets must sort lexicographically by id for stable view diffing.")
    }
}
