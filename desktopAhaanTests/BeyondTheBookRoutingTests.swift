import XCTest
@testable import desktopAhaan

/// Wiring contract for the "Beyond the Book" card on ChapterDetailView.
///
/// The card looks up `ArticleIndex.entries["\(chapter.id)_beyond"]`
/// (see `ChapterDetailView.beyondTheBookEntry`). If a chapter
/// publishes a Beyond article, the lookup MUST return an entry whose
/// id, filename, chapterFolder, and on-disk HTML all reference the
/// SAME chapter — otherwise the modal title says "Chapter N" while
/// the article renders Chapter M's content.
///
/// Frozen 2026-05-25 after a bug report claimed Ch.1's Beyond card
/// opened Ch.2's article ("Beyond the Book — Chapter 2: Nutrition in
/// Animals" with stomach / tongue-map / gut-microbiome content).
/// Current main routes correctly; this test pins the contract so a
/// future content edit OR a hardcoded chapter-number off-by-one
/// can't silently re-introduce the bug.
final class BeyondTheBookRoutingTests: XCTestCase {

    /// Every key in `ArticleIndex.entries` ending in `_beyond` MUST be
    /// internally consistent: key prefix == entry.id prefix ==
    /// filename prefix == chapterFolder's chapter-number suffix.
    func testEveryBeyondEntryIsInternallyConsistent() {
        let beyondKeys = ArticleIndex.entries.keys.filter { $0.hasSuffix("_beyond") }
        XCTAssertFalse(beyondKeys.isEmpty,
            "Expected at least one beyond-the-book entry in ArticleIndex.entries.")

        for key in beyondKeys {
            guard let entry = ArticleIndex.entries[key] else {
                XCTFail("Lookup miss for key '\(key)' that we just enumerated.")
                continue
            }
            let chPrefix = chapterPrefix(from: key)
            XCTAssertEqual(entry.id, key,
                "ArticleIndex entry for key '\(key)' has mismatched id '\(entry.id)' — " +
                "ChapterDetailView's lookup `entries[\"\\(chapter.id)_beyond\"]` " +
                "expects entry.id == key.")
            XCTAssertEqual(entry.filename, "\(key).html",
                "Beyond entry '\(key)' has filename '\(entry.filename)' — must be '\(key).html' " +
                "so the modal loads the right file from disk.")
            let (chNumber, expectedFolder) = chapterNumberAndFolder(fromPrefix: chPrefix)
            XCTAssertEqual(entry.chapterFolder, expectedFolder,
                "Beyond entry '\(key)' points at chapterFolder '\(entry.chapterFolder)' — " +
                "must be '\(expectedFolder)' to render Ch.\(chNumber)'s content. " +
                "An off-by-one here is the exact 2026-05-25 reported bug.")
        }
    }

    /// For every science chapter that DOES publish a Beyond article,
    /// the chapter's id maps cleanly through ChapterDetailView's
    /// lookup pattern. Cross-checks the data layer against the
    /// authored science_class7.json (chapter.id "chNN") and the on-
    /// disk HTML data-article-id attribute.
    func testChapterIdMatchesBeyondArticleAcrossPack() throws {
        let pack = try loadSciencePack()
        var missing: [String] = []
        for chapter in pack.chapters {
            let key = "\(chapter.id)_beyond"
            guard let entry = ArticleIndex.entries[key] else {
                // 2026-05-26 follow-up: 17 generated beyond articles
                // brought this surface to 19/19. We now require EVERY
                // chapter to publish a Beyond article. Missing entries
                // are a regression.
                missing.append(chapter.id)
                continue
            }
            // Same chapter prefix on key + entry + filename — guards
            // against any future entry where `key == "chNN_beyond"`
            // but `entry.filename == "chMM_beyond.html"` (the reported
            // off-by-one shape).
            XCTAssertTrue(entry.filename.hasPrefix(chapter.id + "_"),
                "Chapter '\(chapter.id)' (Ch.\(chapter.number) — \(chapter.title)) " +
                "has Beyond entry pointing at filename '\(entry.filename)'. " +
                "Filename must start with '\(chapter.id)_' so the article matches the chapter.")
            XCTAssertEqual(entry.chapterFolder, "Articles/Chapter\(chapter.number)",
                "Chapter '\(chapter.id)' (Ch.\(chapter.number)) has Beyond entry " +
                "in folder '\(entry.chapterFolder)' — must be 'Articles/Chapter\(chapter.number)'.")
        }
        XCTAssertTrue(missing.isEmpty,
            "Chapters missing a `_beyond` entry — 19/19 coverage broken " +
            "(generated 2026-05-26 to bring the surface to full coverage):\n" +
            missing.map { "  - \($0)" }.joined(separator: "\n"))
    }

    /// Sanity: the HTML file each Beyond entry references actually
    /// exists in Bundle.main AND its <title> matches the chapter
    /// number. This is the test that would have caught the reported
    /// bug at content-author-time: if someone copy-pastes ch02's
    /// HTML into ch01_beyond.html, the <title> mismatch trips this.
    func testBeyondHtmlFilesExistAndTitleMatchesChapter() throws {
        let beyondKeys = ArticleIndex.entries.keys.filter { $0.hasSuffix("_beyond") }
        for key in beyondKeys {
            guard let entry = ArticleIndex.entries[key] else { continue }
            let name = entry.filename.replacingOccurrences(of: ".html", with: "")
            let url = Bundle.main.url(forResource: name, withExtension: "html",
                                      subdirectory: entry.chapterFolder)
                ?? Bundle.main.url(forResource: name, withExtension: "html")
            guard let resolved = url, let html = try? String(contentsOf: resolved, encoding: .utf8) else {
                XCTFail("Beyond HTML for '\(key)' not findable in bundle " +
                        "(filename='\(entry.filename)', folder='\(entry.chapterFolder)').")
                continue
            }
            let chPrefix = chapterPrefix(from: key)
            if chPrefix.hasPrefix("mch") || chPrefix.hasPrefix("sch") || chPrefix.hasPrefix("ssch") {
                // Maths/Sanskrit/Social-Science Beyond articles are titled by chapter
                // NAME, not "Chapter N", so the file-identity invariant is the
                // anti-bug guarantee here: the on-disk HTML's
                // data-article-id MUST equal the entry key. A copy-paste
                // from another chapter trips this exactly like the
                // "Chapter N" substring trips it for Science.
                XCTAssertTrue(html.contains("data-article-id=\"\(key)\""),
                    "Beyond HTML at \(resolved.lastPathComponent) doesn't declare " +
                    "data-article-id=\"\(key)\" — the file's content might be from a " +
                    "different chapter (the 2026-05-25 reported bug shape).")
            } else {
                let expectedTitleFragment = "Chapter \(Int(chPrefix.dropFirst(2)) ?? -1)"
                XCTAssertTrue(html.contains(expectedTitleFragment),
                    "Beyond HTML at \(resolved.lastPathComponent) doesn't contain " +
                    "'\(expectedTitleFragment)' in its <title>/breadcrumb/h1. The " +
                    "file's content might be from a different chapter — exactly " +
                    "the 2026-05-25 reported bug shape (modal renders Ch.M while " +
                    "card says Ch.N).")
            }
        }
    }

    // MARK: - Helpers

    /// "ch01_beyond" → "ch01"
    private func chapterPrefix(from beyondKey: String) -> String {
        return String(beyondKey.split(separator: "_").first ?? "")
    }

    /// Maps a chapter prefix to its number and on-disk folder, honouring the
    /// per-pack naming convention: Science uses `chNN` → `Articles/ChapterN`,
    /// Maths uses `mchNN` → `Articles/MathsChapterN`, Sanskrit uses `schNN`
    /// → `Articles/SanskritChapterN`, Social Science uses `sschNN` →
    /// `Articles/SocialScienceChapterN`. Order matters — check the longer
    /// prefixes (`ssch`, `mch`, `sch`) BEFORE the `ch` fallback, since they
    /// all start with `ch` after their leading letters.
    private func chapterNumberAndFolder(fromPrefix prefix: String) -> (Int, String) {
        if prefix.hasPrefix("ssch") {
            let n = Int(prefix.dropFirst(4)) ?? -1
            return (n, "Articles/SocialScienceChapter\(n)")
        }
        if prefix.hasPrefix("mch") {
            let n = Int(prefix.dropFirst(3)) ?? -1
            return (n, "Articles/MathsChapter\(n)")
        }
        if prefix.hasPrefix("sch") {
            let n = Int(prefix.dropFirst(3)) ?? -1
            return (n, "Articles/SanskritChapter\(n)")
        }
        let n = Int(prefix.dropFirst(2)) ?? -1
        return (n, "Articles/Chapter\(n)")
    }

    private func loadSciencePack() throws -> SubjectPack {
        guard let url = Bundle.main.url(forResource: "science_class7", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            throw XCTSkip("science_class7.json missing from test bundle resources.")
        }
        return try JSONDecoder().decode(SubjectPack.self, from: data)
    }
}
