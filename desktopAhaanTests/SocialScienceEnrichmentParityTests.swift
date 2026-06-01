import XCTest
@testable import desktopAhaan

// MARK: - SocialScienceEnrichmentParityTests
//
// Pins the `examConnections` + `whatIfs` top-up added in v6 Learning Journey
// Phase 1 · P1-I for the Social Science (`socialscience_class7`) pack. Every
// chapter shipped with exactly 2 of each — one below the Science floor of 3/ch
// — leaving Social Science the last subject under the shared enrichment bar.
// Each of the 20 chapters now carries ≥3 examConnections and ≥3 whatIfs with
// canonical unique ids (`sschNN_xcII` / `sschNN_wiII`), real in-pack
// `relatedConceptIds` anchors, and adequately-long content. The third whatIf
// also flows into the regenerated `_whatif` HTML article (now 3 scenarios).
final class SocialScienceEnrichmentParityTests: XCTestCase {

    private let floor = 3

    func testEveryChapterHasThreeExamConnections() throws {
        let pack = try loadPack()
        let conceptIds = allConceptIds(pack)
        var seen = Set<String>()
        var total = 0
        for ch in pack.chapters {
            let items = ch.examConnectionsList
            XCTAssertGreaterThanOrEqual(items.count, floor,
                "\(ch.id) should carry ≥\(floor) examConnections, has \(items.count).")
            for (i, xc) in items.enumerated() {
                XCTAssertEqual(xc.id, "\(ch.id)_xc\(String(format: "%02d", i + 1))",
                    "\(ch.id) examConnection #\(i + 1) has non-canonical id \(xc.id).")
                XCTAssertTrue(seen.insert(xc.id).inserted, "Duplicate examConnection id \(xc.id).")
                XCTAssertTrue(xc.id.hasPrefix("ssch"),
                    "\(xc.id) must be ssch-namespaced.")
                XCTAssertFalse(xc.title.trimmingCharacters(in: .whitespaces).isEmpty,
                    "\(xc.id) has an empty title.")
                XCTAssertFalse(xc.body.trimmingCharacters(in: .whitespaces).isEmpty,
                    "\(xc.id) has an empty body.")
                XCTAssertFalse(xc.targetExam.trimmingCharacters(in: .whitespaces).isEmpty,
                    "\(xc.id) has an empty targetExam tag.")
                for rid in xc.relatedConceptIds ?? [] {
                    XCTAssertTrue(conceptIds.contains(rid),
                        "\(xc.id) relatedConceptId \(rid) does not resolve in-pack.")
                }
            }
            total += items.count
        }
        XCTAssertGreaterThanOrEqual(total, 60,
            "Social Science should carry ≥60 examConnections total (3/ch × 20), has \(total).")
    }

    func testEveryChapterHasThreeWhatIfs() throws {
        let pack = try loadPack()
        let conceptIds = allConceptIds(pack)
        var seen = Set<String>()
        var total = 0
        for ch in pack.chapters {
            let items = ch.whatIfsList
            XCTAssertGreaterThanOrEqual(items.count, floor,
                "\(ch.id) should carry ≥\(floor) whatIfs, has \(items.count).")
            for (i, w) in items.enumerated() {
                XCTAssertEqual(w.id, "\(ch.id)_wi\(String(format: "%02d", i + 1))",
                    "\(ch.id) whatIf #\(i + 1) has non-canonical id \(w.id).")
                XCTAssertTrue(seen.insert(w.id).inserted, "Duplicate whatIf id \(w.id).")
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
        XCTAssertGreaterThanOrEqual(total, 60,
            "Social Science should carry ≥60 whatIfs total (3/ch × 20), has \(total).")
    }

    /// The regenerated `_whatif` HTML article must enumerate every whatIf in
    /// the pack — confirms the JSON top-up and the generated read-mode surface
    /// stay in sync (3 scenarios, not the stale 2).
    func testWhatIfArticlesReflectAllThreeScenarios() throws {
        let pack = try loadPack()
        for ch in pack.chapters {
            let key = "\(ch.id)_whatif"
            guard let entry = ArticleIndex.entries[key] else {
                XCTFail("Missing `_whatif` article entry for \(ch.id).")
                continue
            }
            let name = entry.filename.replacingOccurrences(of: ".html", with: "")
            let url = Bundle.main.url(forResource: name, withExtension: "html",
                                      subdirectory: entry.chapterFolder)
                ?? Bundle.main.url(forResource: name, withExtension: "html")
            guard let resolved = url, let html = try? String(contentsOf: resolved, encoding: .utf8) else {
                XCTFail("WhatIf HTML for \(key) not findable.")
                continue
            }
            let scenarioCount = html.components(separatedBy: "<h2>What if").count - 1
            XCTAssertGreaterThanOrEqual(scenarioCount, ch.whatIfsList.count,
                "\(key) article has \(scenarioCount) scenarios but the pack has \(ch.whatIfsList.count) whatIfs — stale article.")
        }
    }

    // MARK: - Helpers

    private func allConceptIds(_ pack: SubjectPack) -> Set<String> {
        Set(pack.chapters.flatMap { ch in
            ch.topics.flatMap { $0.concepts.map(\.id) }
        })
    }

    private func loadPack() throws -> SubjectPack {
        guard let url = Bundle.main.url(forResource: "socialscience_class7", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            throw XCTSkip("socialscience_class7.json missing from test bundle.")
        }
        return try JSONDecoder().decode(SubjectPack.self, from: data)
    }
}
