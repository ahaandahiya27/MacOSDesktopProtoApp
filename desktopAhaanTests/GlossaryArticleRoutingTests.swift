import XCTest
@testable import desktopAhaan

/// Wiring contract for the per-chapter `_glossary` HTML article
/// surface. Distinct from `GlossarySheet` (the SwiftUI sheet
/// surface keyed to `chapter.glossary` JSON directly) — these
/// HTML articles are the long-form "vocabulary deck" read-mode
/// surface, surfaced via `BeyondTheBook` hub blocks and (in a
/// follow-up session) a per-chapter Vocabulary Deck card.
///
/// Mirrors `CommonMistakesRoutingTests` (2026-05-26) — same
/// 19/19 floor, same off-by-one guards.
final class GlossaryArticleRoutingTests: XCTestCase {

    func testEveryGlossaryEntryIsInternallyConsistent() {
        let keys = ArticleIndex.entries.keys.filter { $0.hasSuffix("_glossary") }
        XCTAssertFalse(keys.isEmpty,
            "Expected at least one Glossary entry in ArticleIndex.entries.")
        for key in keys {
            guard let entry = ArticleIndex.entries[key] else {
                XCTFail("Lookup miss for key '\(key)'.")
                continue
            }
            XCTAssertEqual(entry.id, key,
                "Entry '\(key)' has id '\(entry.id)' — must equal key.")
            XCTAssertEqual(entry.filename, "\(key).html",
                "Entry '\(key)' has filename '\(entry.filename)' — must be '\(key).html'.")
            let chPrefix = chapterPrefix(from: key)
            let chNumber = Int(chPrefix.dropFirst(2)) ?? -1
            XCTAssertEqual(entry.chapterFolder, "Articles/Chapter\(chNumber)",
                "Entry '\(key)' has chapterFolder '\(entry.chapterFolder)' — must be 'Articles/Chapter\(chNumber)'.")
        }
    }

    func testEveryChapterHasGlossaryArticleEntry() throws {
        let pack = try loadSciencePack()
        var missing: [String] = []
        for chapter in pack.chapters {
            let key = "\(chapter.id)_glossary"
            if ArticleIndex.entries[key] == nil {
                missing.append(chapter.id)
            }
        }
        XCTAssertTrue(missing.isEmpty,
            "Chapters missing a `_glossary` entry — 19/19 coverage broken:\n" +
            missing.map { "  - \($0)" }.joined(separator: "\n"))
    }

    func testGlossaryHtmlFilesExistAndTitleMatchesChapter() throws {
        let keys = ArticleIndex.entries.keys.filter { $0.hasSuffix("_glossary") }
        for key in keys {
            guard let entry = ArticleIndex.entries[key] else { continue }
            let name = entry.filename.replacingOccurrences(of: ".html", with: "")
            let url = Bundle.main.url(forResource: name, withExtension: "html",
                                      subdirectory: entry.chapterFolder)
                ?? Bundle.main.url(forResource: name, withExtension: "html")
            guard let resolved = url, let html = try? String(contentsOf: resolved, encoding: .utf8) else {
                XCTFail("Glossary HTML for '\(key)' not findable in bundle.")
                continue
            }
            let chPrefix = chapterPrefix(from: key)
            let expectedFragment = "Chapter \(Int(chPrefix.dropFirst(2)) ?? -1)"
            XCTAssertTrue(html.contains(expectedFragment),
                "Glossary HTML at \(resolved.lastPathComponent) doesn't contain " +
                "'\(expectedFragment)' in title/breadcrumb/h1.")
        }
    }

    /// Defensive — every generated glossary article must have at
    /// least 5 vocabulary terms. The generator script floors at 5;
    /// Ch.1's bespoke article has 30 (also passes). Pinning catches
    /// hand-edits that drop terms below the floor.
    func testGlossaryArticlesHaveAtLeastFiveTerms() throws {
        let keys = ArticleIndex.entries.keys.filter { $0.hasSuffix("_glossary") }
        for key in keys {
            guard let entry = ArticleIndex.entries[key] else { continue }
            let name = entry.filename.replacingOccurrences(of: ".html", with: "")
            let url = Bundle.main.url(forResource: name, withExtension: "html",
                                      subdirectory: entry.chapterFolder)
                ?? Bundle.main.url(forResource: name, withExtension: "html")
            guard let resolved = url, let html = try? String(contentsOf: resolved, encoding: .utf8) else {
                continue
            }
            // Count <li> elements with a <strong> opener — that's how
            // every term is rendered in both the bespoke Ch.1 article
            // and the generator template. Robust against `<ul>` style
            // changes that swap classes.
            let listItemCount = html.components(separatedBy: "<li><strong>").count - 1
            XCTAssertGreaterThanOrEqual(listItemCount, 5,
                "Glossary article '\(key)' has only \(listItemCount) term entries — " +
                "expected ≥ 5 per the generator's stop-and-ask threshold.")
        }
    }

    // MARK: - Helpers

    private func chapterPrefix(from key: String) -> String {
        return String(key.split(separator: "_").first ?? "")
    }

    private func loadSciencePack() throws -> SubjectPack {
        guard let url = Bundle.main.url(forResource: "science_class7", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            throw XCTSkip("science_class7.json missing from test bundle.")
        }
        return try JSONDecoder().decode(SubjectPack.self, from: data)
    }
}
