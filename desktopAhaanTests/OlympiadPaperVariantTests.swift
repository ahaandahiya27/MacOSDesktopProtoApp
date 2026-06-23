import XCTest
@testable import desktopAhaan

/// Pins the 207 P3/P4/P5 practice-paper variants added programmatically
/// by `OlympiadPaperRegistry+VariantPapers.swift`. The base + Advanced
/// papers (138 total) keep their own checks in
/// `OlympiadExamHallTests`; this suite covers strictly the variant set:
/// catalog shape, bundle resolution of every emitted filename, ID
/// uniqueness, and per-subject coverage.
@MainActor
final class OlympiadPaperVariantTests: XCTestCase {

    /// 69 base chapters × 3 ramps (P3, P4, P5) = 207 variant papers.
    /// A regression here means either a base paper was dropped or a
    /// variant tag wasn't expanded.
    func testVariantCount() {
        XCTAssertEqual(OlympiadPaperRegistry.variantPapers.count, 207,
            "Expected 207 variant papers (69 base × 3 ramps). Got \(OlympiadPaperRegistry.variantPapers.count).")
    }

    /// All 4 subjects must contribute variants — if a subject's base
    /// registry slips back to an empty array, the variant generator
    /// silently emits nothing for it.
    func testAllFourSubjectsContributeVariants() {
        let bySubject = Dictionary(grouping: OlympiadPaperRegistry.variantPapers,
                                   by: { $0.subjectName })
        for subject in ["Science", "Maths", "Sanskrit", "Social Science"] {
            let count = bySubject[subject]?.count ?? 0
            XCTAssertGreaterThan(count, 0,
                "Subject '\(subject)' should have variant papers; got \(count).")
            // Every base chapter must spawn exactly 3 variants
            XCTAssertEqual(count % 3, 0,
                "Subject '\(subject)' variant count (\(count)) should be a multiple of 3 (P3, P4, P5 per chapter).")
        }
    }

    /// Every variant's `_QuestionPaper.md`, `_Solutions.md`, `.html`,
    /// and `.pdf` filename must resolve to a real file in the test-host
    /// app bundle. If even one is missing, opening that paper from the
    /// hub silently no-ops — fail loudly here instead.
    func testEveryVariantResolvesAllFourBundleFiles() {
        let bundle = Bundle(for: type(of: self))
        let hostBundle = appHostBundle(testBundle: bundle)
        for paper in OlympiadPaperRegistry.variantPapers {
            assertResolves(hostBundle: hostBundle,
                           file: paper.questionPaperMD, paperId: paper.id)
            assertResolves(hostBundle: hostBundle,
                           file: paper.solutionsMD, paperId: paper.id)
            assertResolves(hostBundle: hostBundle,
                           file: paper.questionPaperHTML, paperId: paper.id)
            assertResolves(hostBundle: hostBundle,
                           file: paper.questionPaperPDF, paperId: paper.id)
        }
    }

    /// Variant IDs are derived from the base paper id + tag — any
    /// collision would indicate a base paper itself wasn't unique, or
    /// the tagging suffix got duplicated. The OlympiadExamHallTests'
    /// `testAllRegistryIdsAreUnique` covers `allPapers` globally; this
    /// is a narrower pin on the variant subset alone for clearer
    /// failure signal.
    func testVariantIdsAreUnique() {
        let ids = OlympiadPaperRegistry.variantPapers.map { $0.id }
        XCTAssertEqual(Set(ids).count, ids.count,
            "Duplicate variant IDs detected. Total: \(ids.count), unique: \(Set(ids).count).")
    }

    /// Variants must be marked `.foundation` — they're harder ramps
    /// inside the foundation track, not new `.advanced` anchors. The
    /// exam-hall test asserts there are exactly 69 advanced papers; if
    /// a variant ever leaked the `.advanced` tag, that count would
    /// drift and the timer/marking surface would route them through
    /// the Advanced-only code paths.
    func testVariantsAreFoundationTier() {
        for paper in OlympiadPaperRegistry.variantPapers {
            XCTAssertEqual(paper.tier, .foundation,
                "\(paper.id) should be tier=.foundation (variants are foundation-track ramps).")
        }
    }

    /// Display title must end with " — Practice Paper N" for N in
    /// {3,4,5} so the hub card text is consistent across variants.
    func testVariantDisplayTitleEndsWithPracticePaperNumber() {
        let allowed: Set<String> = ["3", "4", "5"]
        for paper in OlympiadPaperRegistry.variantPapers {
            // Expected shape: "<Chapter title> — Practice Paper N"
            let parts = paper.displayTitle.components(separatedBy: " — Practice Paper ")
            guard parts.count == 2, let n = parts.last, allowed.contains(n) else {
                XCTFail("Variant \(paper.id) display title (\(paper.displayTitle)) doesn't match '… — Practice Paper {3|4|5}'.")
                continue
            }
        }
    }

    // MARK: - Helpers

    /// Test-host trick: when xcodebuild runs unit tests with TEST_HOST
    /// pointing at the app, the resources live in the host's bundle,
    /// not the test bundle. Walk up to .../desktopAhaan.app/Contents/
    /// Resources/ from the test bundle path.
    private func appHostBundle(testBundle: Bundle) -> Bundle {
        // The xcodebuild Test invocation hosts the unit test bundle
        // inside the app bundle (`TEST_HOST=…/desktopAhaan.app/Contents/
        // MacOS/desktopAhaan`), so `Bundle.main` already IS the app
        // bundle. Use main here — defensive fallback to the test
        // bundle so the test runs even in unusual hosting modes.
        return Bundle.main
    }

    private func assertResolves(hostBundle: Bundle, file: String,
                                paperId: String,
                                file fileName: StaticString = #file,
                                line: UInt = #line) {
        let stem = (file as NSString).deletingPathExtension
        let ext = (file as NSString).pathExtension
        let direct = hostBundle.url(forResource: stem, withExtension: ext,
                                    subdirectory: "TestPapers")
        let flat = hostBundle.url(forResource: stem, withExtension: ext)
        XCTAssertTrue(direct != nil || flat != nil,
            "Paper \(paperId): bundled file \(file) not found in TestPapers/ subdir or flat.",
            file: fileName, line: line)
    }
}
