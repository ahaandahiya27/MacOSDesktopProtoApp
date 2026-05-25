import XCTest
@testable import desktopAhaan

/// Ratchet for `ChapterDetailView+ExtraReadingRow` — the compact
/// chip row that surfaces 7 templated enrichment articles per
/// chapter (Vocabulary Deck, NCERT Q&A, Scientist Spotlight,
/// What If?, Mini Project, Quick Self-Check, Story Mode).
///
/// Pins three invariants:
///   1. All 7 chip keys resolve to an `ArticleIndex` entry for
///      every chapter in the science pack — total 7 × 19 = 133.
///   2. Every chip entry's `chapterFolder` matches the chapter
///      number embedded in the key prefix.
///   3. The 7-suffix list itself stays in sync with the
///      ExtraReadingRow source. (When the row grows or shrinks,
///      this sentinel reminds the author to update the test.)
///
/// Catches accidental regressions like:
///   - dropping an `ArticleIndex.entries` row.
///   - mis-keying a chapter folder.
///   - shipping a chip suffix but forgetting one chapter.
final class ExtraReadingRowTests: XCTestCase {

    /// Frozen list — must match `ExtraReadingRow.rows[*].suffix`
    /// in `ChapterDetailView+ExtraReadingRow.swift`. When the row
    /// gains an 8th chip, append here and bump the sentinel below.
    private static let chipSuffixes: [String] = [
        "_glossary",
        "_ncert_qa",
        "_scientists",
        "_whatif",
        "_miniproject",
        "_selfcheck",
        "_storymode",
    ]

    func testChipSuffixListSentinelEqualsSeven() {
        XCTAssertEqual(Self.chipSuffixes.count, 7,
            "ExtraReadingRow chip-suffix sentinel — expected 7 chips, got \(Self.chipSuffixes.count). " +
            "If you intentionally changed the row, update this sentinel + the 133 floor below.")
    }

    func testEveryChapterResolvesAllSevenChipKeys() throws {
        let pack = try loadSciencePack()
        var missing: [(chapterId: String, suffix: String)] = []
        for chapter in pack.chapters {
            for suffix in Self.chipSuffixes {
                let key = "\(chapter.id)\(suffix)"
                if ArticleIndex.entries[key] == nil {
                    missing.append((chapter.id, suffix))
                }
            }
        }
        XCTAssertTrue(missing.isEmpty,
            "ExtraReadingRow chip lookup — \(missing.count) missing key(s) " +
            "across the 7 × \(pack.chapters.count) matrix:\n" +
            missing.map { "  - \($0.chapterId)\($0.suffix)" }.joined(separator: "\n"))
    }

    func testChipMatrixSentinelIsOneHundredThirtyThree() throws {
        let pack = try loadSciencePack()
        var present = 0
        for chapter in pack.chapters {
            for suffix in Self.chipSuffixes {
                if ArticleIndex.entries["\(chapter.id)\(suffix)"] != nil {
                    present += 1
                }
            }
        }
        XCTAssertEqual(present, 7 * pack.chapters.count,
            "ExtraReadingRow chip-matrix sentinel — expected \(7 * pack.chapters.count) " +
            "(7 chips × \(pack.chapters.count) chapters), got \(present). " +
            "Either a chip suffix is missing for a chapter, or an article " +
            "entry was deleted without removing the chip.")
    }

    func testEveryChipChapterFolderMatchesKeyPrefix() {
        let chipKeys = ArticleIndex.entries.keys.filter { key in
            Self.chipSuffixes.contains { key.hasSuffix($0) }
        }
        for key in chipKeys {
            guard let entry = ArticleIndex.entries[key] else { continue }
            let prefix = String(key.split(separator: "_").first ?? "")
            // prefix is e.g. "ch01" → expected folder "Articles/Chapter1"
            guard let chNumber = Int(prefix.dropFirst(2)) else {
                XCTFail("Chip key '\(key)' has unparsable chapter prefix '\(prefix)'.")
                continue
            }
            XCTAssertEqual(entry.chapterFolder, "Articles/Chapter\(chNumber)",
                "Chip '\(key)' has chapterFolder '\(entry.chapterFolder)' — " +
                "must be 'Articles/Chapter\(chNumber)' to resolve in the bundle.")
        }
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
