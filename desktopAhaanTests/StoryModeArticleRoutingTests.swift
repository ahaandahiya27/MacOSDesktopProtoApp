import XCTest
@testable import desktopAhaan

/// Wiring contract for the per-chapter `_storymode` HTML article
/// surface — narrative scenes from real-world examples. Mirrors
/// the established routing-ratchet pattern.
final class StoryModeArticleRoutingTests: XCTestCase {

    func testEveryStoryModeEntryIsInternallyConsistent() {
        let keys = ArticleIndex.entries.keys.filter { $0.hasSuffix("_storymode") }
        XCTAssertFalse(keys.isEmpty)
        for key in keys {
            guard let entry = ArticleIndex.entries[key] else { continue }
            XCTAssertEqual(entry.id, key)
            XCTAssertEqual(entry.filename, "\(key).html")
            let chPrefix = chapterPrefix(from: key)
            let chNumber = Int(chPrefix.dropFirst(2)) ?? -1
            XCTAssertEqual(entry.chapterFolder, "Articles/Chapter\(chNumber)")
        }
    }

    func testEveryChapterHasStoryModeArticleEntry() throws {
        let pack = try loadSciencePack()
        var missing: [String] = []
        for chapter in pack.chapters {
            if ArticleIndex.entries["\(chapter.id)_storymode"] == nil {
                missing.append(chapter.id)
            }
        }
        XCTAssertTrue(missing.isEmpty,
            "Chapters missing `_storymode` entry:\n" +
            missing.map { "  - \($0)" }.joined(separator: "\n"))
    }

    func testStoryModeHtmlFilesExistAndTitleMatchesChapter() throws {
        let keys = ArticleIndex.entries.keys.filter { $0.hasSuffix("_storymode") }
        for key in keys {
            guard let entry = ArticleIndex.entries[key] else { continue }
            let name = entry.filename.replacingOccurrences(of: ".html", with: "")
            let url = Bundle.main.url(forResource: name, withExtension: "html",
                                      subdirectory: entry.chapterFolder)
                ?? Bundle.main.url(forResource: name, withExtension: "html")
            guard let resolved = url, let html = try? String(contentsOf: resolved, encoding: .utf8) else {
                XCTFail("StoryMode HTML for '\(key)' not findable.")
                continue
            }
            let chPrefix = chapterPrefix(from: key)
            let expectedFragment = "Chapter \(Int(chPrefix.dropFirst(2)) ?? -1)"
            XCTAssertTrue(html.contains(expectedFragment),
                "StoryMode HTML at \(resolved.lastPathComponent) doesn't contain '\(expectedFragment)'.")
        }
    }

    func testStoryModeArticlesHaveAtLeastThreeScenes() throws {
        let keys = ArticleIndex.entries.keys.filter { $0.hasSuffix("_storymode") }
        for key in keys {
            guard let entry = ArticleIndex.entries[key] else { continue }
            let name = entry.filename.replacingOccurrences(of: ".html", with: "")
            let url = Bundle.main.url(forResource: name, withExtension: "html",
                                      subdirectory: entry.chapterFolder)
                ?? Bundle.main.url(forResource: name, withExtension: "html")
            guard let resolved = url, let html = try? String(contentsOf: resolved, encoding: .utf8) else { continue }
            // Bespoke Ch.1 uses "<h2>HH:MM" timestamp; generator uses "Scene N — ...".
            // Both flavors have at least 3 h2 sections.
            let h2Count = html.components(separatedBy: "<h2>").count - 1
            XCTAssertGreaterThanOrEqual(h2Count, 3,
                "Article '\(key)' has \(h2Count) <h2> sections — expected ≥ 3 scenes.")
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
