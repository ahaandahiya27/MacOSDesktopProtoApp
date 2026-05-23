import XCTest

// MARK: - Surface_AuditWalker
//
// Mechanises the static `SURFACE_AUDIT.md` table into a runtime walk
// over all 19 Science chapters. For each chapter, opens the detail
// page and asserts that every new Phase-2 content surface (NCERT
// Q&A, Misconceptions, MediaAsset gallery, WhatIfs, Mini-projects,
// Curriculum bridge, Glossary button, Cross-chapter refs, Gallery,
// Featured scientist, DeepDive disclosure) is present in the AX
// tree by its accessibility-label substring.
//
// Attaches a per-chapter screenshot to the test result so a reviewer
// can scroll through 19 screenshots after a green run.
//
// Wiring: same as the other UI tests in this target. Default test
// runs (scripts/ci-build-test.sh, pre-push hook, CI) pass
// `-skip-testing:desktopAhaanUITests`. Run explicitly on the iMac
// (where AX is granted to the runner):
//
//     xcodebuild test \
//       -scheme desktopAhaan \
//       -destination 'platform=macOS' \
//       -only-testing:desktopAhaanUITests/Surface_AuditWalker
//
// Authoritative venue is the iMac — the dev Mac's AX permission to
// the test runner has not been granted, so all click/keystroke calls
// silently no-op there and assertions time out by design (no false
// confidence).
//
// Surface labels checked per chapter (substring matches via NSPredicate
// `CONTAINS` so the badge-count suffix on each disclosure doesn't
// break the assertion when a chapter has more or fewer items):
//
//   - "Go deeper"                  (DeepDive)
//   - "NCERT textbook questions"   (NcertQA)
//   - "Common mistakes"            (Misconceptions)
//   - "Visual library"             (MediaAssetGallery)
//   - "What if"                    (WhatIfs)
//   - "Build something"            (MiniProjects)
//   - "Where this goes in later"   (CurriculumBridge)
//   - "Glossary"                   (glossaryButton)
//   - "Connected ideas"            (CrossChapterRefs)
//   - "Gallery"                    (GallerySectionView)
//   - "Featured scientist"         (ScientistsSectionView)
//
// Topic-detail and Question-detail surfaces (Real-world examples,
// Mnemonics chip strips, Exam connection callout) are NOT walked
// here — would require a 3× nested click sequence per chapter. A
// future expansion can add `Surface_AuditWalker_Topics` and
// `Surface_AuditWalker_Questions` that dive one level deeper.

final class Surface_AuditWalker: XCTestCase {
    /// Hard cap so the walker tells you which chapter is the source
    /// of an early failure instead of bailing on the first miss.
    override var continueAfterFailure: Bool {
        get { true }
        set {}
    }

    func testWalkAllScienceChapters() throws {
        let app = XCUIApplication(bundleIdentifier: "com.emoha.desktopAhaan")
        app.launch()

        AXHelpers.dismissWelcomeUI(in: app)

        let surfaceLabels: [(name: String, substring: String)] = [
            ("DeepDive",           "Go deeper"),
            ("NCERT Q&A",          "NCERT textbook questions"),
            ("Misconceptions",     "Common mistakes"),
            ("MediaAsset gallery", "Visual library"),
            ("WhatIfs",            "What if"),
            ("Mini-projects",      "Build something"),
            ("Curriculum bridge",  "Where this goes in later"),
            ("Glossary",           "Glossary"),
            ("Cross-chapter refs", "Connected ideas"),
            ("Gallery",            "Gallery"),
            ("Featured scientist", "Featured scientist")
        ]

        for chapterNumber in 1...19 {
            let opened = AXHelpers.openChapter(chapterNumber, in: app, timeout: 5)
            XCTAssertTrue(opened, "Chapter \(chapterNumber): detail page failed to render within 5s — Try Discover Mode banner missing.")
            guard opened else {
                // Skip surface checks for this chapter but keep walking
                // (continueAfterFailure=true; we want the full picture).
                continue
            }

            for surface in surfaceLabels {
                let matched = app.descendants(matching: .any).matching(
                    NSPredicate(format: "label CONTAINS %@", surface.substring)
                ).firstMatch
                let found = matched.waitForExistence(timeout: 1.5)
                XCTAssertTrue(
                    found,
                    "Chapter \(chapterNumber): surface '\(surface.name)' missing — no AX element with label CONTAINS '\(surface.substring)'."
                )
            }

            // Per-chapter screenshot. The XCTAttachment lives on the
            // test result, so a reviewer scrolling the xcresult after
            // a green run sees 19 screenshots in chapter order.
            let screenshot = XCUIScreen.main.screenshot()
            let attachment = XCTAttachment(screenshot: screenshot)
            attachment.name = "ch\(String(format: "%02d", chapterNumber))-detail"
            attachment.lifetime = .keepAlways
            add(attachment)

            AXHelpers.navigateBack(in: app)
        }
    }
}
