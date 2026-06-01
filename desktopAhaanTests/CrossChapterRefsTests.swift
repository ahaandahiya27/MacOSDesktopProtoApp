import XCTest
@testable import desktopAhaan

// MARK: - CrossChapterRefsTests
//
// Pins the `crossChapterRefs` fill added in v6 Learning Journey Phase 1 · P1-F
// for the Maths (`maths_class7`) and Sanskrit (`sanskrit_class7`) packs, which
// previously shipped with ZERO outbound references — leaving the adaptive
// journey unable to weave each subject into a connected arc. Each chapter now
// carries ≥4 references that point to a REAL in-pack chapter (never itself),
// with canonical unique ids and in-pack `relatedConceptIds` anchors.
//
// The Sanskrit legacy `ch01` vocabulary deck is the documented carve-out and
// must carry NONE (a cross-ref out of it has no meaningful NEP target and would
// muddy the parity ratchets).
@MainActor
final class CrossChapterRefsTests: XCTestCase {

    func testMathsEveryChapterHasCrossChapterRefs() throws {
        let pack = try loadPack("maths_class7")
        try assertRefsValid(pack, minPerChapter: 4, exemptChapterIds: [])
    }

    func testSanskritEveryNEPChapterHasCrossChapterRefsAndLegacyDeckHasNone() throws {
        let pack = try loadPack("sanskrit_class7")
        // Legacy ch01 must carry zero outbound refs.
        if let legacy = pack.chapters.first(where: { $0.id == "ch01" }) {
            XCTAssertTrue(legacy.crossChapterRefsList.isEmpty,
                "Legacy Sanskrit ch01 deck must carry no crossChapterRefs.")
        }
        try assertRefsValid(pack, minPerChapter: 4, exemptChapterIds: ["ch01"])
    }

    /// Shared invariant check: per-chapter floor, canonical unique ids, real
    /// in-pack targets (no self-reference), and in-pack relatedConceptId anchors.
    private func assertRefsValid(_ pack: SubjectPack,
                                 minPerChapter: Int,
                                 exemptChapterIds: Set<String>) throws {
        let chapterIds = Set(pack.chapters.map { $0.id })
        let conceptIds = Set(pack.chapters.flatMap { ch in
            ch.topics.flatMap { $0.concepts.map(\.id) }
        })
        var seenRefIds = Set<String>()
        for ch in pack.chapters where !exemptChapterIds.contains(ch.id) {
            let refs = ch.crossChapterRefsList
            XCTAssertGreaterThanOrEqual(refs.count, minPerChapter,
                "\(ch.id) should carry ≥\(minPerChapter) crossChapterRefs, has \(refs.count).")
            for (i, ref) in refs.enumerated() {
                XCTAssertEqual(ref.id, "\(ch.id)_cx\(String(format: "%02d", i + 1))",
                    "\(ch.id) ref #\(i + 1) has non-canonical id \(ref.id).")
                XCTAssertTrue(seenRefIds.insert(ref.id).inserted,
                    "Duplicate crossChapterRef id \(ref.id).")
                XCTAssertTrue(chapterIds.contains(ref.toChapterId),
                    "\(ref.id) targets unknown chapter \(ref.toChapterId).")
                XCTAssertNotEqual(ref.toChapterId, ch.id,
                    "\(ref.id) is a self-reference.")
                XCTAssertFalse(ref.topic.trimmingCharacters(in: .whitespaces).isEmpty,
                    "\(ref.id) has an empty topic.")
                XCTAssertGreaterThanOrEqual(ref.pointer.count, 30,
                    "\(ref.id) pointer is too short to explain the connection.")
                for rid in ref.relatedConceptIds ?? [] {
                    XCTAssertTrue(conceptIds.contains(rid),
                        "\(ref.id) relatedConceptId \(rid) does not resolve in-pack.")
                }
            }
        }
    }

    // MARK: - Helpers

    private func loadPack(_ resource: String) throws -> SubjectPack {
        guard let url = Bundle.main.url(forResource: resource, withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            throw XCTSkip("\(resource).json missing from test bundle.")
        }
        return try JSONDecoder().decode(SubjectPack.self, from: data)
    }
}
