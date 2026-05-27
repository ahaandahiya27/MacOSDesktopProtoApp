import XCTest
@testable import desktopAhaan

/// Wiring contract for the per-chapter `_selfcheck` HTML article
/// surface — 5-question pre-Boss-Quiz revision quizzes. Mirrors
/// the established routing-ratchet pattern.
final class SelfCheckArticleRoutingTests: XCTestCase {

    func testEverySelfCheckEntryIsInternallyConsistent() {
        let keys = ArticleIndex.entries.keys.filter { $0.hasSuffix("_selfcheck") }
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

    func testEveryChapterHasSelfCheckArticleEntry() throws {
        let pack = try loadSciencePack()
        var missing: [String] = []
        for chapter in pack.chapters {
            if ArticleIndex.entries["\(chapter.id)_selfcheck"] == nil {
                missing.append(chapter.id)
            }
        }
        XCTAssertTrue(missing.isEmpty,
            "Chapters missing `_selfcheck` entry:\n" +
            missing.map { "  - \($0)" }.joined(separator: "\n"))
    }

    func testSelfCheckHtmlFilesExistAndTitleMatchesChapter() throws {
        let keys = ArticleIndex.entries.keys.filter { $0.hasSuffix("_selfcheck") }
        for key in keys {
            guard let entry = ArticleIndex.entries[key] else { continue }
            let name = entry.filename.replacingOccurrences(of: ".html", with: "")
            let url = Bundle.main.url(forResource: name, withExtension: "html",
                                      subdirectory: entry.chapterFolder)
                ?? Bundle.main.url(forResource: name, withExtension: "html")
            guard let resolved = url, let html = try? String(contentsOf: resolved, encoding: .utf8) else {
                XCTFail("SelfCheck HTML for '\(key)' not findable.")
                continue
            }
            let chPrefix = chapterPrefix(from: key)
            if chPrefix.hasPrefix("mch") {
                XCTAssertTrue(html.contains("data-article-id=\"\(key)\""),
                    "SelfCheck HTML at \(resolved.lastPathComponent) doesn't declare data-article-id=\"\(key)\".")
            } else {
                let expectedFragment = "Chapter \(Int(chPrefix.dropFirst(2)) ?? -1)"
                XCTAssertTrue(html.contains(expectedFragment),
                    "SelfCheck HTML at \(resolved.lastPathComponent) doesn't contain '\(expectedFragment)'.")
            }
        }
    }

    func testSelfCheckArticlesHaveAtLeastThreeQuestions() throws {
        let keys = ArticleIndex.entries.keys.filter { $0.hasSuffix("_selfcheck") }
        for key in keys {
            guard let entry = ArticleIndex.entries[key] else { continue }
            let name = entry.filename.replacingOccurrences(of: ".html", with: "")
            let url = Bundle.main.url(forResource: name, withExtension: "html",
                                      subdirectory: entry.chapterFolder)
                ?? Bundle.main.url(forResource: name, withExtension: "html")
            guard let resolved = url, let html = try? String(contentsOf: resolved, encoding: .utf8) else { continue }
            // Bespoke Ch.1 uses "Question N" h2 prefix; generator uses same shape.
            let qCount = html.components(separatedBy: "Question").count - 1
            XCTAssertGreaterThanOrEqual(qCount, 3,
                "Article '\(key)' has \(qCount) Question references — expected ≥ 3.")
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
