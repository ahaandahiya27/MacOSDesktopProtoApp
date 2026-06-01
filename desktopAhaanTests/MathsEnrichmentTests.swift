import XCTest
@testable import desktopAhaan

// MARK: - MathsEnrichmentTests
//
// Pins the `examConnections` + `whatIfs` fill added in v6 Learning Journey
// Phase 1 · P1-G for the Maths (`maths_class7`) pack, which previously shipped
// with ZERO of each — the last two enrichment surfaces where Science (3/ch
// each) outranked Maths. ChapterDetailView's `ExamConnectionCalloutView` and
// `WhatIfsSectionView` read these structured fields directly; below the floor,
// those surfaces go dark on the Maths tab, so this test fails loud.
//
// Each Maths chapter now carries ≥3 examConnections and ≥3 whatIfs with
// canonical unique ids (`mchNN_xcII` / `mchNN_wiII` — the `mch` namespace keeps
// them distinct from Science's `chNN_xc` / `chNN_wi` so a global Identifiable
// index never collides across packs), real in-pack `relatedConceptIds` anchors,
// and non-blank, adequately-long content.
@MainActor
final class MathsEnrichmentTests: XCTestCase {

    private let floor = 3

    func testEveryMathsChapterHasExamConnections() throws {
        let pack = try loadPack("maths_class7")
        let conceptIds = allConceptIds(pack)
        var seen = Set<String>()
        var total = 0
        for ch in pack.chapters {
            let items = ch.examConnectionsList
            XCTAssertGreaterThanOrEqual(items.count, floor,
                "\(ch.id) should carry ≥\(floor) examConnections, has \(items.count).")
            let prefix = "m\(ch.id)"   // ch01 -> mch01
            for (i, xc) in items.enumerated() {
                XCTAssertEqual(xc.id, "\(prefix)_xc\(String(format: "%02d", i + 1))",
                    "\(ch.id) examConnection #\(i + 1) has non-canonical id \(xc.id).")
                XCTAssertTrue(seen.insert(xc.id).inserted,
                    "Duplicate examConnection id \(xc.id).")
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
            "Maths should carry ≥45 examConnections total (3/ch × 15), has \(total).")
    }

    func testEveryMathsChapterHasWhatIfs() throws {
        let pack = try loadPack("maths_class7")
        let conceptIds = allConceptIds(pack)
        var seen = Set<String>()
        var total = 0
        for ch in pack.chapters {
            let items = ch.whatIfsList
            XCTAssertGreaterThanOrEqual(items.count, floor,
                "\(ch.id) should carry ≥\(floor) whatIfs, has \(items.count).")
            let prefix = "m\(ch.id)"   // ch01 -> mch01
            for (i, w) in items.enumerated() {
                XCTAssertEqual(w.id, "\(prefix)_wi\(String(format: "%02d", i + 1))",
                    "\(ch.id) whatIf #\(i + 1) has non-canonical id \(w.id).")
                XCTAssertTrue(seen.insert(w.id).inserted,
                    "Duplicate whatIf id \(w.id).")
                XCTAssertGreaterThanOrEqual(w.question.trimmingCharacters(in: .whitespaces).count, 5,
                    "\(w.id) question is too short.")
                XCTAssertGreaterThanOrEqual(w.answer.trimmingCharacters(in: .whitespaces).count, 30,
                    "\(w.id) answer is too short to guide the kid.")
                for rid in w.relatedConceptIds ?? [] {
                    XCTAssertTrue(conceptIds.contains(rid),
                        "\(w.id) relatedConceptId \(rid) does not resolve in-pack.")
                }
            }
            total += items.count
        }
        XCTAssertGreaterThanOrEqual(total, 45,
            "Maths should carry ≥45 whatIfs total (3/ch × 15), has \(total).")
    }

    /// Guards the cross-pack namespace boundary: no Maths exam/whatIf id may
    /// collide with a Science `chNN_xc` / `chNN_wi` id (they share `chNN`
    /// chapter ids but the Maths items are `mchNN`-prefixed).
    func testMathsExamWhatIfIdsAreNamespacedAwayFromScience() throws {
        let pack = try loadPack("maths_class7")
        for ch in pack.chapters {
            for xc in ch.examConnectionsList {
                XCTAssertTrue(xc.id.hasPrefix("mch"),
                    "\(xc.id) must be mch-namespaced to avoid colliding with Science.")
            }
            for w in ch.whatIfsList {
                XCTAssertTrue(w.id.hasPrefix("mch"),
                    "\(w.id) must be mch-namespaced to avoid colliding with Science.")
            }
        }
    }

    // MARK: - Helpers

    private func allConceptIds(_ pack: SubjectPack) -> Set<String> {
        Set(pack.chapters.flatMap { ch in
            ch.topics.flatMap { $0.concepts.map(\.id) }
        })
    }

    private func loadPack(_ resource: String) throws -> SubjectPack {
        guard let url = Bundle.main.url(forResource: resource, withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            throw XCTSkip("\(resource).json missing from test bundle.")
        }
        return try JSONDecoder().decode(SubjectPack.self, from: data)
    }
}
