import XCTest
@testable import desktopAhaan

/// Pin that the Boss Challenge Papers ship in the app bundle and that the
/// catalog can resolve each paper's PDF + Solutions HTML by filename. A
/// pure-Bundle test — no AppKit, no DataStore. Runs against the app
/// bundle the test target hosts (`@testable import desktopAhaan`), so a
/// missing `Copy Bundle Resources` entry surfaces here before iMac
/// verification.
@MainActor
final class BossChallengePapersCatalogTests: XCTestCase {

    /// The catalog must surface at least the seven numbered papers shipped
    /// on 2026-06-17 plus Boss Paper 00. We assert ≥ 8 (rather than == 8)
    /// so the test doesn't fight the ongoing content-generation loop that
    /// adds new papers without touching the catalog code.
    func testLoadAllReturnsBundledPapers() {
        let papers = BossChallengePapersCatalog.loadAll()
        XCTAssertGreaterThanOrEqual(papers.count, 8,
            "Expected at least 8 papers (Boss_00 + Paper_01…Paper_07). Got \(papers.count).")
    }

    /// Every paper the catalog surfaces must have a resolvable Question
    /// Paper file AND a resolvable Solutions file. If either is missing
    /// from Copy Bundle Resources, the Open buttons would silently no-op
    /// — fail loudly here instead.
    func testEveryPaperResolvesQuestionAndSolutionsBundleURLs() {
        let papers = BossChallengePapersCatalog.loadAll()
        XCTAssertFalse(papers.isEmpty, "Catalog returned no papers.")
        for paper in papers {
            let qpURL = BossChallengePapersCatalog.bundleURL(
                forFilename: paper.questionPaperFilename)
            XCTAssertNotNil(qpURL,
                "Question paper missing from bundle for \(paper.displayTitle): "
                + paper.questionPaperFilename)
            let solURL = BossChallengePapersCatalog.bundleURL(
                forFilename: paper.solutionsFilename)
            XCTAssertNotNil(solURL,
                "Solutions HTML missing from bundle for \(paper.displayTitle): "
                + paper.solutionsFilename)
        }
    }

    /// Boss Paper 00 has a different naming convention (`MCQ_Questions.pdf`
    /// instead of `QuestionPaper.pdf`) and is the only paper without a
    /// numeric two-letter chapter slug. Pin that the catalog recognises it
    /// and sorts it first.
    func testBossPaper00IsFirstAndHasExpectedFilenames() {
        let papers = BossChallengePapersCatalog.loadAll()
        guard let first = papers.first else {
            XCTFail("No papers loaded.")
            return
        }
        XCTAssertEqual(first.number, "00",
            "Boss Paper 00 should sort first. Got: \(first.displayTitle).")
        XCTAssertEqual(first.questionPaperFilename, "Boss_Paper_00_MCQ_Questions.pdf")
        XCTAssertEqual(first.solutionsFilename, "Boss_Paper_00_Solutions.html")
    }

    /// PAPERS_MANIFEST.md drives the chapter labels for the numbered
    /// papers. Pin a known good entry so a future manifest-format change
    /// either updates this test or surfaces as a regression.
    func testPaper01ChaptersComeFromManifest() {
        let papers = BossChallengePapersCatalog.loadAll()
        guard let paper01 = papers.first(where: { $0.number == "01" }) else {
            XCTFail("Paper 01 not in the catalog.")
            return
        }
        XCTAssertEqual(paper01.chapters,
                       ["Heat", "Nutrition in Plants", "Integers"])
    }

    /// Catalog ordering: Boss_00 first, then numbered papers ascending.
    /// Important because the UI renders in catalog order — flipping the
    /// sort would jumble the kid's mental model of "Paper 01 → 02 → 03".
    func testCatalogIsOrderedBoss00ThenAscendingNumbers() {
        let numbers = BossChallengePapersCatalog.loadAll().map { $0.number }
        guard !numbers.isEmpty else {
            XCTFail("Catalog empty.")
            return
        }
        // After Boss_00 (if present), the rest must be strictly ascending.
        let numbered = numbers.first == "00" ? Array(numbers.dropFirst()) : numbers
        for (i, n) in numbered.enumerated() where i > 0 {
            XCTAssertTrue(numbered[i - 1] < n,
                "Catalog out of order at index \(i): \(numbered[i - 1]) → \(n).")
        }
    }
}
