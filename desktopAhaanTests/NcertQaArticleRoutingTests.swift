import XCTest
@testable import desktopAhaan

/// Wiring contract for the per-chapter `_ncert_qa` HTML article
/// surface — NCERT Exercise model answers + examiner-checks for
/// exam-prep revision. Mirrors `CommonMistakesRoutingTests` and
/// `GlossaryArticleRoutingTests` (same 19/19 floor, same off-by-
/// one guards).
final class NcertQaArticleRoutingTests: XCTestCase {

    func testEveryNcertQaEntryIsInternallyConsistent() {
        let keys = ArticleIndex.entries.keys.filter { $0.hasSuffix("_ncert_qa") }
        XCTAssertFalse(keys.isEmpty,
            "Expected at least one NCERT Q&A entry in ArticleIndex.entries.")
        for key in keys {
            guard let entry = ArticleIndex.entries[key] else { continue }
            XCTAssertEqual(entry.id, key)
            XCTAssertEqual(entry.filename, "\(key).html")
            let chPrefix = chapterPrefix(from: key)
            let chNumber = Int(chPrefix.dropFirst(2)) ?? -1
            XCTAssertEqual(entry.chapterFolder, "Articles/Chapter\(chNumber)",
                "Entry '\(key)' has chapterFolder '\(entry.chapterFolder)' — must be 'Articles/Chapter\(chNumber)'.")
        }
    }

    func testEveryChapterHasNcertQaArticleEntry() throws {
        let pack = try loadSciencePack()
        var missing: [String] = []
        for chapter in pack.chapters {
            if ArticleIndex.entries["\(chapter.id)_ncert_qa"] == nil {
                missing.append(chapter.id)
            }
        }
        XCTAssertTrue(missing.isEmpty,
            "Chapters missing a `_ncert_qa` entry — 19/19 broken:\n" +
            missing.map { "  - \($0)" }.joined(separator: "\n"))
    }

    func testNcertQaHtmlFilesExistAndTitleMatchesChapter() throws {
        let keys = ArticleIndex.entries.keys.filter { $0.hasSuffix("_ncert_qa") }
        for key in keys {
            guard let entry = ArticleIndex.entries[key] else { continue }
            let name = entry.filename.replacingOccurrences(of: ".html", with: "")
            let url = Bundle.main.url(forResource: name, withExtension: "html",
                                      subdirectory: entry.chapterFolder)
                ?? Bundle.main.url(forResource: name, withExtension: "html")
            guard let resolved = url, let html = try? String(contentsOf: resolved, encoding: .utf8) else {
                XCTFail("NCERT Q&A HTML for '\(key)' not findable.")
                continue
            }
            let chPrefix = chapterPrefix(from: key)
            let expectedFragment = "Chapter \(Int(chPrefix.dropFirst(2)) ?? -1)"
            XCTAssertTrue(html.contains(expectedFragment),
                "NCERT Q&A HTML at \(resolved.lastPathComponent) doesn't contain '\(expectedFragment)'.")
        }
    }

    /// At least 4 Q&A sections per article (the generator's stop-and-ask
    /// threshold). Ch.1's bespoke article has 8.
    func testNcertQaArticlesHaveAtLeastFourQuestions() throws {
        let keys = ArticleIndex.entries.keys.filter { $0.hasSuffix("_ncert_qa") }
        for key in keys {
            guard let entry = ArticleIndex.entries[key] else { continue }
            let name = entry.filename.replacingOccurrences(of: ".html", with: "")
            let url = Bundle.main.url(forResource: name, withExtension: "html",
                                      subdirectory: entry.chapterFolder)
                ?? Bundle.main.url(forResource: name, withExtension: "html")
            guard let resolved = url, let html = try? String(contentsOf: resolved, encoding: .utf8) else { continue }
            let count = html.components(separatedBy: "<h2>Q").count - 1
            XCTAssertGreaterThanOrEqual(count, 4,
                "Article '\(key)' has only \(count) Q&A sections — expected ≥ 4.")
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
