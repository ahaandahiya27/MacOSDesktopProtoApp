import XCTest
@testable import desktopAhaan

/// Wiring contract for the per-chapter `_miniproject` HTML article
/// surface — hands-on activities. Mirrors the four prior routing
/// ratchet classes.
final class MiniProjectArticleRoutingTests: XCTestCase {

    func testEveryMiniProjectEntryIsInternallyConsistent() {
        let keys = ArticleIndex.entries.keys.filter { $0.hasSuffix("_miniproject") && !$0.hasPrefix("ssch") }
        XCTAssertFalse(keys.isEmpty)
        for key in keys {
            guard let entry = ArticleIndex.entries[key] else { continue }
            XCTAssertEqual(entry.id, key)
            XCTAssertEqual(entry.filename, "\(key).html")
            let chPrefix = chapterPrefix(from: key)
            let expectedFolder: String
            if chPrefix.hasPrefix("mch") {
                expectedFolder = "Articles/MathsChapter\(Int(chPrefix.dropFirst(3)) ?? -1)"
            } else if chPrefix.hasPrefix("sch") {
                expectedFolder = "Articles/SanskritChapter\(Int(chPrefix.dropFirst(3)) ?? -1)"
            } else {
                expectedFolder = "Articles/Chapter\(Int(chPrefix.dropFirst(2)) ?? -1)"
            }
            XCTAssertEqual(entry.chapterFolder, expectedFolder)
        }
    }

    func testEveryChapterHasMiniProjectArticleEntry() throws {
        let pack = try loadSciencePack()
        var missing: [String] = []
        for chapter in pack.chapters {
            if ArticleIndex.entries["\(chapter.id)_miniproject"] == nil {
                missing.append(chapter.id)
            }
        }
        XCTAssertTrue(missing.isEmpty,
            "Chapters missing `_miniproject` entry — 19/19 broken:\n" +
            missing.map { "  - \($0)" }.joined(separator: "\n"))
    }

    func testMiniProjectHtmlFilesExistAndTitleMatchesChapter() throws {
        let keys = ArticleIndex.entries.keys.filter { $0.hasSuffix("_miniproject") && !$0.hasPrefix("ssch") }
        for key in keys {
            guard let entry = ArticleIndex.entries[key] else { continue }
            let name = entry.filename.replacingOccurrences(of: ".html", with: "")
            let url = Bundle.main.url(forResource: name, withExtension: "html",
                                      subdirectory: entry.chapterFolder)
                ?? Bundle.main.url(forResource: name, withExtension: "html")
            guard let resolved = url, let html = try? String(contentsOf: resolved, encoding: .utf8) else {
                XCTFail("MiniProject HTML for '\(key)' not findable.")
                continue
            }
            let chPrefix = chapterPrefix(from: key)
            if chPrefix.hasPrefix("mch") || chPrefix.hasPrefix("sch") {
                XCTAssertTrue(html.contains("data-article-id=\"\(key)\""),
                    "MiniProject HTML at \(resolved.lastPathComponent) doesn't declare data-article-id=\"\(key)\".")
            } else {
                let expectedFragment = "Chapter \(Int(chPrefix.dropFirst(2)) ?? -1)"
                XCTAssertTrue(html.contains(expectedFragment),
                    "MiniProject HTML at \(resolved.lastPathComponent) doesn't contain '\(expectedFragment)'.")
            }
        }
    }

    func testMiniProjectArticlesHaveAtLeastOneProject() throws {
        let keys = ArticleIndex.entries.keys.filter { $0.hasSuffix("_miniproject") && !$0.hasPrefix("ssch") }
        for key in keys {
            guard let entry = ArticleIndex.entries[key] else { continue }
            let name = entry.filename.replacingOccurrences(of: ".html", with: "")
            let url = Bundle.main.url(forResource: name, withExtension: "html",
                                      subdirectory: entry.chapterFolder)
                ?? Bundle.main.url(forResource: name, withExtension: "html")
            guard let resolved = url, let html = try? String(contentsOf: resolved, encoding: .utf8) else { continue }
            // Each project section has a "What you'll need" sub-heading.
            let projectCount = html.components(separatedBy: "What you").count - 1
            XCTAssertGreaterThanOrEqual(projectCount, 1,
                "Article '\(key)' has \(projectCount) project sections — expected ≥ 1.")
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
