import XCTest
@testable import desktopAhaan

/// Wiring contract for the per-chapter `_scientists` HTML article
/// surface — biographical "Scientist Spotlight" pages. Mirrors
/// CommonMistakesRoutingTests / GlossaryArticleRoutingTests /
/// NcertQaArticleRoutingTests.
final class ScientistsArticleRoutingTests: XCTestCase {

    func testEveryScientistsEntryIsInternallyConsistent() {
        let keys = ArticleIndex.entries.keys.filter { $0.hasSuffix("_scientists") }
        XCTAssertFalse(keys.isEmpty)
        for key in keys {
            guard let entry = ArticleIndex.entries[key] else { continue }
            XCTAssertEqual(entry.id, key)
            XCTAssertEqual(entry.filename, "\(key).html")
            let chPrefix = chapterPrefix(from: key)
            let expectedFolder = chPrefix.hasPrefix("mch")
                ? "Articles/MathsChapter\(Int(chPrefix.dropFirst(3)) ?? -1)"
                : "Articles/Chapter\(Int(chPrefix.dropFirst(2)) ?? -1)"
            XCTAssertEqual(entry.chapterFolder, expectedFolder)
        }
    }

    func testEveryChapterHasScientistsArticleEntry() throws {
        let pack = try loadSciencePack()
        var missing: [String] = []
        for chapter in pack.chapters {
            if ArticleIndex.entries["\(chapter.id)_scientists"] == nil {
                missing.append(chapter.id)
            }
        }
        XCTAssertTrue(missing.isEmpty,
            "Chapters missing `_scientists` entry — 19/19 broken:\n" +
            missing.map { "  - \($0)" }.joined(separator: "\n"))
    }

    func testScientistsHtmlFilesExistAndTitleMatchesChapter() throws {
        let keys = ArticleIndex.entries.keys.filter { $0.hasSuffix("_scientists") }
        for key in keys {
            guard let entry = ArticleIndex.entries[key] else { continue }
            let name = entry.filename.replacingOccurrences(of: ".html", with: "")
            let url = Bundle.main.url(forResource: name, withExtension: "html",
                                      subdirectory: entry.chapterFolder)
                ?? Bundle.main.url(forResource: name, withExtension: "html")
            guard let resolved = url, let html = try? String(contentsOf: resolved, encoding: .utf8) else {
                XCTFail("Scientists HTML for '\(key)' not findable.")
                continue
            }
            let chPrefix = chapterPrefix(from: key)
            if chPrefix.hasPrefix("mch") {
                XCTAssertTrue(html.contains("data-article-id=\"\(key)\""),
                    "Scientists HTML at \(resolved.lastPathComponent) doesn't declare data-article-id=\"\(key)\".")
            } else {
                let expectedFragment = "Chapter \(Int(chPrefix.dropFirst(2)) ?? -1)"
                XCTAssertTrue(html.contains(expectedFragment),
                    "Scientists HTML at \(resolved.lastPathComponent) doesn't contain '\(expectedFragment)'.")
            }
        }
    }

    func testScientistsArticlesHaveAtLeastOneProfile() throws {
        let keys = ArticleIndex.entries.keys.filter { $0.hasSuffix("_scientists") }
        for key in keys {
            // Ch.1's bespoke article has 5; generated ones have 1.
            // Floor pin: at least 1 named profile per article.
            guard let entry = ArticleIndex.entries[key] else { continue }
            let name = entry.filename.replacingOccurrences(of: ".html", with: "")
            let url = Bundle.main.url(forResource: name, withExtension: "html",
                                      subdirectory: entry.chapterFolder)
                ?? Bundle.main.url(forResource: name, withExtension: "html")
            guard let resolved = url, let html = try? String(contentsOf: resolved, encoding: .utf8) else { continue }
            // Each scientist profile section uses an `<h2>` for the
            // scientist's name (both the bespoke Ch.1 article and the
            // generator template do this).
            let h2Count = html.components(separatedBy: "<h2>").count - 1
            XCTAssertGreaterThanOrEqual(h2Count, 1,
                "Article '\(key)' has \(h2Count) <h2> sections — expected ≥ 1 scientist profile.")
        }
    }

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
