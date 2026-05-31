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
        let keys = ArticleIndex.entries.keys.filter { $0.hasSuffix("_glossary") && !$0.hasPrefix("mch") && !$0.hasPrefix("sch") && !$0.hasPrefix("ssch") }
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
        let keys = ArticleIndex.entries.keys.filter { $0.hasSuffix("_glossary") && !$0.hasPrefix("mch") && !$0.hasPrefix("sch") && !$0.hasPrefix("ssch") }
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
        let keys = ArticleIndex.entries.keys.filter { $0.hasSuffix("_glossary") && !$0.hasPrefix("mch") && !$0.hasPrefix("sch") && !$0.hasPrefix("ssch") }
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

    // MARK: - Cross-pack glossary-key scoping (subject-leak guard)
    //
    // GlossarySheet's "Read full deck" gate built the article key from the
    // bare `chapter.id` ("ch05_glossary"), so a Maths chapter checked the
    // SCIENCE glossary article (chNN ids collide across packs). The gate now
    // routes through `ArticleIndex.packScopedKey(forPackId:baseKey:)`. This
    // pins that key across every (pack, chapter): Science → bare key,
    // Maths → `m`-prefixed, Sanskrit (no articles) → nil.

    func testGlossaryKeyIsPackScopedAcrossAllPacks() throws {
        XCTAssertEqual(ArticleIndex.packScopedKey(forPackId: "science_class7", baseKey: "ch05_glossary"),
                       "ch05_glossary")
        XCTAssertEqual(ArticleIndex.packScopedKey(forPackId: "maths_class7", baseKey: "ch05_glossary"),
                       "mch05_glossary")
        XCTAssertNil(ArticleIndex.packScopedKey(forPackId: "sanskrit_class7", baseKey: "ch05_glossary"))

        for resource in ["science_class7", "maths_class7", "sanskrit_class7"] {
            guard let pack = try? loadPack(resource) else {
                throw XCTSkip("\(resource).json missing from test bundle.")
            }
            for chapter in pack.chapters {
                let key = ArticleIndex.packScopedKey(forPackId: pack.id,
                                                     baseKey: "\(chapter.id)_glossary")
                switch pack.id {
                case "science_class7":
                    XCTAssertEqual(key, "\(chapter.id)_glossary")
                case "maths_class7":
                    XCTAssertEqual(key, "m\(chapter.id)_glossary",
                        "Maths \(chapter.id) glossary must resolve to mch…, not the Science ch… key.")
                default:
                    XCTAssertNil(key, "\(pack.id) ships no glossary articles, so the key must be nil.")
                }
            }
        }
    }

    private func chapterPrefix(from key: String) -> String {
        return String(key.split(separator: "_").first ?? "")
    }

    private func loadPack(_ resource: String) throws -> SubjectPack {
        guard let url = Bundle.main.url(forResource: resource, withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            throw XCTSkip("\(resource).json missing from test bundle.")
        }
        return try JSONDecoder().decode(SubjectPack.self, from: data)
    }

    private func loadSciencePack() throws -> SubjectPack {
        return try loadPack("science_class7")
    }
}
