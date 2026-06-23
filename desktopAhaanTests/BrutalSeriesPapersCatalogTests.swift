import XCTest
@testable import desktopAhaan

/// Pins the 64-paper Brutal Series catalog. Mirrors
/// `BossChallengePapersCatalogTests` so the two practice-paper surfaces
/// stay in lockstep: catalog returns the expected count, every emitted
/// filename resolves to a real bundled file, IDs are unique, sort order
/// is stable, and the manifest is the chapter-label source of truth.
@MainActor
final class BrutalSeriesPapersCatalogTests: XCTestCase {

    /// 63 papers ship as of 2026-06-23 (B01..B63). ≥-rather-than-== so
    /// the content-generation loop adding a B64/B65 doesn't fight the test.
    func testLoadAllReturnsAtLeastSixtyPapers() {
        let papers = BrutalSeriesPapersCatalog.loadAll()
        XCTAssertGreaterThanOrEqual(papers.count, 60,
            "Expected at least 60 Brutal Series papers; got \(papers.count).")
    }

    /// Every paper's questions PDF AND solutions HTML must resolve in the
    /// bundle. Drop here if a Copy-Bundle-Resources entry slips.
    func testEveryPaperResolvesBothBundleFiles() {
        let papers = BrutalSeriesPapersCatalog.loadAll()
        XCTAssertFalse(papers.isEmpty, "Catalog returned no papers.")
        for paper in papers {
            XCTAssertNotNil(
                BrutalSeriesPapersCatalog.bundleURL(
                    forFilename: paper.questionsPdfFilename),
                "Questions PDF missing for \(paper.displayTitle): \(paper.questionsPdfFilename)")
            XCTAssertNotNil(
                BrutalSeriesPapersCatalog.bundleURL(
                    forFilename: paper.solutionsHtmlFilename),
                "Solutions HTML missing for \(paper.displayTitle): \(paper.solutionsHtmlFilename)")
        }
    }

    /// Every paper number must be `B<NN>` for a 2-digit numeric suffix.
    /// If the shape ever drifts (e.g. B100, BX1), display + sort would
    /// silently misbehave — fail here instead.
    func testEveryPaperNumberMatchesBNNShape() {
        for paper in BrutalSeriesPapersCatalog.loadAll() {
            XCTAssertEqual(paper.number.count, 3,
                "Paper \(paper.number) should be 3 chars (B + 2 digits).")
            XCTAssertEqual(paper.number.first, "B",
                "Paper \(paper.number) should start with 'B'.")
            let suffix = String(paper.number.dropFirst())
            XCTAssertNotNil(Int(suffix),
                "Paper \(paper.number) suffix '\(suffix)' should be numeric.")
        }
    }

    /// Catalog order is B01 → B02 → … → B64 ascending. Important because
    /// the hub renders cards in catalog order; flipping would scatter
    /// the kid's mental model of paper progression.
    func testCatalogIsOrderedByPaperNumberAscending() {
        let numbers = BrutalSeriesPapersCatalog.loadAll().map { $0.number }
        guard !numbers.isEmpty else {
            XCTFail("Catalog empty.")
            return
        }
        for (i, n) in numbers.enumerated() where i > 0 {
            XCTAssertTrue(numbers[i - 1] < n,
                "Catalog out of order at index \(i): \(numbers[i - 1]) → \(n).")
        }
    }

    /// Variant IDs are derived from each paper's number — uniqueness
    /// matters because SwiftUI's ForEach diffs on `id`.
    func testPaperIDsAreUnique() {
        let ids = BrutalSeriesPapersCatalog.loadAll().map { $0.id }
        XCTAssertEqual(Set(ids).count, ids.count,
            "Duplicate paper IDs detected. Total: \(ids.count), unique: \(Set(ids).count).")
    }

    /// MANIFEST.md drives the chapter labels. Pin Paper B01's known-good
    /// label so a future manifest-format change either updates this test
    /// or surfaces as a regression. Compound chapter names like
    /// "Acids, Bases & Salts" embed commas — the parser tolerates those
    /// by splitting on ` | ` (the line-level delimiter) rather than `,`.
    func testPaperB01ChaptersLabelFromManifest() {
        let papers = BrutalSeriesPapersCatalog.loadAll()
        guard let p1 = papers.first(where: { $0.number == "B01" }) else {
            XCTFail("Paper B01 not in catalog.")
            return
        }
        XCTAssertEqual(p1.chaptersLabel,
                       "Heat, Comparing Quantities, Electric Current & its Effects, Simple Equations")
    }

    /// Compound chapter names containing commas must survive the
    /// manifest parser. Paper B02 carries `"Acids, Bases & Salts"`,
    /// `"The Triangle & its Properties"`, etc. — a regression that
    /// fragmented chapter cells would surface as a truncated label here.
    func testCompoundChapterNameSurvivesManifestParse() {
        let papers = BrutalSeriesPapersCatalog.loadAll()
        guard let p2 = papers.first(where: { $0.number == "B02" }) else {
            XCTFail("Paper B02 not in catalog.")
            return
        }
        XCTAssertTrue(p2.chaptersLabel.contains("Acids, Bases & Salts"),
            "Compound chapter name should survive parse. Got: \(p2.chaptersLabel)")
    }

    /// File-pairing pin: every Questions PDF has a matching Solutions
    /// HTML with the same stem (the catalog drops papers without one;
    /// this verifies the production stream is intact).
    func testQuestionsAndSolutionsFilenamesShareStem() {
        for paper in BrutalSeriesPapersCatalog.loadAll() {
            let qStem = paper.questionsPdfFilename
                .replacingOccurrences(of: "_Questions.pdf", with: "")
            let sStem = paper.solutionsHtmlFilename
                .replacingOccurrences(of: "_Solutions.html", with: "")
            XCTAssertEqual(qStem, sStem,
                "Stem mismatch on \(paper.number): Q=\(qStem), S=\(sStem)")
        }
    }
}
