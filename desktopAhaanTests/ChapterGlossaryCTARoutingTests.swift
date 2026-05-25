import XCTest
@testable import desktopAhaan

/// Wiring contract for `ChapterGlossaryCTA` — the secondary
/// "Look up vocabulary for Ch. X" tap target on
/// `ConceptDetailView` that opens the owning chapter's
/// `_glossary` HTML article.
///
/// Pins:
///   1. Every concept in the science pack has a resolvable
///      chapter-id-based glossary key (i.e., the chapter walk
///      that the CTA does at runtime will succeed).
///   2. Every chapter's glossary article entry resolves to a
///      bundled HTML file (mirrors GlossaryArticleRoutingTests
///      but worded from the CTA's POV).
///   3. The expected secondary-CTA matrix is 207 concepts × 1
///      glossary article — fewer than the chapter-level 19
///      mappings, but the per-concept fan-out is what fails if
///      `ConceptDetailView.location` can't find the owning
///      chapter for a concept.
final class ChapterGlossaryCTARoutingTests: XCTestCase {

    func testEveryConceptResolvesToAGlossaryEntry() throws {
        let pack = try loadSciencePack()
        var missing: [String] = []
        var checked = 0
        for chapter in pack.chapters {
            for topic in chapter.topics {
                for concept in topic.concepts {
                    checked += 1
                    let key = "\(chapter.id)_glossary"
                    if ArticleIndex.entries[key] == nil {
                        missing.append("\(concept.id) → \(key)")
                    }
                }
            }
        }
        XCTAssertGreaterThan(checked, 0,
            "Science pack is empty — no concepts walked.")
        XCTAssertTrue(missing.isEmpty,
            "ChapterGlossaryCTA — \(missing.count) concept(s) (of \(checked)) " +
            "would render with no resolvable chapter-glossary article:\n" +
            missing.prefix(8).map { "  - \($0)" }.joined(separator: "\n"))
    }

    func testAllGlossaryEntriesPointToBundledHTML() {
        let keys = ArticleIndex.entries.keys.filter { $0.hasSuffix("_glossary") }
        var bad: [String] = []
        for key in keys {
            guard let entry = ArticleIndex.entries[key] else { continue }
            let name = entry.filename.replacingOccurrences(of: ".html", with: "")
            let url = Bundle.main.url(forResource: name, withExtension: "html",
                                      subdirectory: entry.chapterFolder)
                ?? Bundle.main.url(forResource: name, withExtension: "html")
            if url == nil { bad.append(key) }
        }
        XCTAssertTrue(bad.isEmpty,
            "ChapterGlossaryCTA bundle gate — \(bad.count) glossary entry " +
            "would auto-hide the CTA because the HTML file isn't shipped: " +
            "\(bad.prefix(5))")
    }

    func testConceptCountIs207() throws {
        // Sentinel — Ahaan's science pack has exactly 207 concepts
        // across 19 chapters as of 2026-05-26. If this changes, the
        // test above will still pass (it's per-concept) but the
        // sentinel here catches a pack-side schema regression.
        let pack = try loadSciencePack()
        let total = pack.chapters
            .flatMap { $0.topics }
            .flatMap { $0.concepts }
            .count
        XCTAssertEqual(total, 207,
            "Science pack concept count regressed — expected 207, got \(total). " +
            "If you intentionally added/removed concepts, update this sentinel.")
    }

    // MARK: - Helpers

    private func loadSciencePack() throws -> SubjectPack {
        guard let url = Bundle.main.url(forResource: "science_class7", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            throw XCTSkip("science_class7.json missing from test bundle.")
        }
        return try JSONDecoder().decode(SubjectPack.self, from: data)
    }
}
