import XCTest
@testable import desktopAhaan

// MARK: - SanskritExamConnectionsTests
//
// Pins the `examConnections` fill added in v6 Learning Journey Phase 1 · P1-H
// for the Sanskrit (`sanskrit_class7`) pack. The 15 NEP chapters
// (`sch01`–`sch15`) already carried `whatIfs`, `deepDive`, `bossQuestions` and
// `crossChapterRefs`, but ZERO `examConnections` — leaving
// `ExamConnectionCalloutView` dark on every Sanskrit chapter tab.
//
// Each NEP chapter now carries ≥3 examConnections with canonical unique ids
// (`schNN_xcII` — the `sch` namespace keeps them distinct from Science's
// `chNN_xc` so a global Identifiable index never collides across packs), real
// in-pack `relatedConceptIds` anchors, non-blank titles + targetExam tags, and
// adequately-long bodies. The legacy `ch01` vocabulary deck is the documented
// carve-out and must carry NONE (a `ch01_xc*` id would collide with Science).
@MainActor
final class SanskritExamConnectionsTests: XCTestCase {

    private let floor = 3

    func testEveryNEPChapterHasExamConnectionsAndLegacyDeckHasNone() throws {
        let pack = try loadPack("sanskrit_class7")
        let conceptIds = Set(pack.chapters.flatMap { ch in
            ch.topics.flatMap { $0.concepts.map(\.id) }
        })

        // Legacy ch01 must carry zero exam connections.
        if let legacy = pack.chapters.first(where: { $0.id == "ch01" }) {
            XCTAssertTrue(legacy.examConnectionsList.isEmpty,
                "Legacy Sanskrit ch01 deck must carry no examConnections.")
        }

        var seen = Set<String>()
        var total = 0
        for ch in pack.chapters where ch.id.hasPrefix("sch") {
            let items = ch.examConnectionsList
            XCTAssertGreaterThanOrEqual(items.count, floor,
                "\(ch.id) should carry ≥\(floor) examConnections, has \(items.count).")
            for (i, xc) in items.enumerated() {
                XCTAssertEqual(xc.id, "\(ch.id)_xc\(String(format: "%02d", i + 1))",
                    "\(ch.id) examConnection #\(i + 1) has non-canonical id \(xc.id).")
                XCTAssertTrue(seen.insert(xc.id).inserted,
                    "Duplicate examConnection id \(xc.id).")
                XCTAssertTrue(xc.id.hasPrefix("sch"),
                    "\(xc.id) must be sch-namespaced to avoid colliding with Science.")
                XCTAssertFalse(xc.title.trimmingCharacters(in: .whitespaces).isEmpty,
                    "\(xc.id) has an empty title.")
                XCTAssertGreaterThanOrEqual(xc.body.split(separator: " ").count, 40,
                    "\(xc.id) body is too short to be a real 'you'll see this again' pointer.")
                XCTAssertFalse(xc.targetExam.trimmingCharacters(in: .whitespaces).isEmpty,
                    "\(xc.id) has an empty targetExam tag.")
                for rid in xc.relatedConceptIds ?? [] {
                    XCTAssertTrue(conceptIds.contains(rid),
                        "\(xc.id) relatedConceptId \(rid) does not resolve in-pack.")
                }
            }
            total += items.count
        }
        XCTAssertGreaterThanOrEqual(total, 45,
            "Sanskrit should carry ≥45 examConnections total (3/ch × 15 NEP), has \(total).")
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
