import XCTest
@testable import desktopAhaan

/// Wiring contract for the per-chapter `_whatif` HTML article
/// surface — brain-stretcher thought-experiment pages. Mirrors
/// CommonMistakesRoutingTests / GlossaryArticleRoutingTests /
/// NcertQaArticleRoutingTests / ScientistsArticleRoutingTests.
final class WhatIfArticleRoutingTests: XCTestCase {

    func testEveryWhatIfEntryIsInternallyConsistent() {
        let keys = ArticleIndex.entries.keys.filter { $0.hasSuffix("_whatif") && !$0.hasPrefix("ssch") }
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

    func testEveryChapterHasWhatIfArticleEntry() throws {
        let pack = try loadSciencePack()
        var missing: [String] = []
        for chapter in pack.chapters {
            if ArticleIndex.entries["\(chapter.id)_whatif"] == nil {
                missing.append(chapter.id)
            }
        }
        XCTAssertTrue(missing.isEmpty,
            "Chapters missing `_whatif` entry — 19/19 broken:\n" +
            missing.map { "  - \($0)" }.joined(separator: "\n"))
    }

    func testWhatIfHtmlFilesExistAndTitleMatchesChapter() throws {
        let keys = ArticleIndex.entries.keys.filter { $0.hasSuffix("_whatif") && !$0.hasPrefix("ssch") }
        for key in keys {
            guard let entry = ArticleIndex.entries[key] else { continue }
            let name = entry.filename.replacingOccurrences(of: ".html", with: "")
            let url = Bundle.main.url(forResource: name, withExtension: "html",
                                      subdirectory: entry.chapterFolder)
                ?? Bundle.main.url(forResource: name, withExtension: "html")
            guard let resolved = url, let html = try? String(contentsOf: resolved, encoding: .utf8) else {
                XCTFail("WhatIf HTML for '\(key)' not findable.")
                continue
            }
            let chPrefix = chapterPrefix(from: key)
            if chPrefix.hasPrefix("mch") || chPrefix.hasPrefix("sch") {
                XCTAssertTrue(html.contains("data-article-id=\"\(key)\""),
                    "WhatIf HTML at \(resolved.lastPathComponent) doesn't declare data-article-id=\"\(key)\".")
            } else {
                let expectedFragment = "Chapter \(Int(chPrefix.dropFirst(2)) ?? -1)"
                XCTAssertTrue(html.contains(expectedFragment),
                    "WhatIf HTML at \(resolved.lastPathComponent) doesn't contain '\(expectedFragment)'.")
            }
        }
    }

    /// At least 2 scenarios per article (the generator's stop-and-ask
    /// threshold). Each scenario is a `<h2>What if N — ...</h2>` section.
    func testWhatIfArticlesHaveAtLeastTwoScenarios() throws {
        let keys = ArticleIndex.entries.keys.filter { $0.hasSuffix("_whatif") && !$0.hasPrefix("ssch") }
        for key in keys {
            guard let entry = ArticleIndex.entries[key] else { continue }
            let name = entry.filename.replacingOccurrences(of: ".html", with: "")
            let url = Bundle.main.url(forResource: name, withExtension: "html",
                                      subdirectory: entry.chapterFolder)
                ?? Bundle.main.url(forResource: name, withExtension: "html")
            guard let resolved = url, let html = try? String(contentsOf: resolved, encoding: .utf8) else { continue }
            let scenarioCount = html.components(separatedBy: "<h2>What if").count - 1
            XCTAssertGreaterThanOrEqual(scenarioCount, 2,
                "Article '\(key)' has \(scenarioCount) scenarios — expected ≥ 2.")
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
