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

    /// Heavier smoke: walks every chapter and clicks each visible CTA
    /// (Beyond the Book → close, Try Discover Mode → ⌘W, My Notebook,
    /// any DeepDive disclosure, the article-open button + Read Aloud
    /// toggle). Per the 2026-05-24 polish brief.
    ///
    /// Opt-in only — runs explicitly via
    ///     -only-testing:desktopAhaanUITests/Surface_AuditWalker/test_surfaceAuditWalker_allChapters_smoke
    ///
    /// The test does NOT assert presence of any single CTA (the
    /// structural walker above covers that). Its job is to prove the
    /// click sequence doesn't crash the app — the iMac's WebKit /
    /// AppKit interactions are where the 2026-05 crash classes
    /// historically lived (C1..C4), and a one-shot click walk catches
    /// new regressions the unit suite can't reach.
    func test_surfaceAuditWalker_allChapters_smoke() throws {
        let app = XCUIApplication(bundleIdentifier: "com.emoha.desktopAhaan")
        app.launch()
        AXHelpers.dismissWelcomeUI(in: app)

        for chapterNumber in 1...19 {
            let opened = AXHelpers.openChapter(chapterNumber, in: app, timeout: 5)
            XCTAssertTrue(
                opened,
                "Chapter \(chapterNumber): detail did not render within 5s."
            )
            guard opened else { continue }

            // ----- Try Discover Mode → close it -----
            let discover = app.buttons["try-discover-mode"].firstMatch
            if discover.exists {
                discover.click()
                usleep(500_000)
                // ⌘W closes the Discover window without dismissing
                // the chapter detail behind it.
                app.typeKey("w", modifierFlags: .command)
                usleep(400_000)
            }

            // ----- Beyond the Book (article) — open then close -----
            let articleButton = app.descendants(matching: .any).matching(
                NSPredicate(format: "label CONTAINS %@", "Read the full article")
            ).firstMatch
            if articleButton.waitForExistence(timeout: 1.0) {
                articleButton.click()
                usleep(800_000)

                // Tap Read Aloud if present, let it speak briefly,
                // then stop.
                let readAloud = app.descendants(matching: .any).matching(
                    NSPredicate(
                        format: "label BEGINSWITH 'Read' OR label CONTAINS 'aloud' OR label CONTAINS 'Resume reading'"
                    )
                ).firstMatch
                if readAloud.waitForExistence(timeout: 1.0) {
                    readAloud.click()
                    sleep(2)
                    // Hitting the same control toggles to pause /
                    // resume / start depending on state — clicking
                    // it again on a paused/playing button stops the
                    // narration in two of three branches; explicit
                    // ⌘. (cancel) is the safer stop on the third.
                    if readAloud.exists { readAloud.click() }
                    app.typeKey(".", modifierFlags: .command)
                    usleep(400_000)
                }

                // Close the article sheet.
                app.typeKey("w", modifierFlags: .command)
                usleep(400_000)
            }

            // ----- My Notebook -----
            let notebook = app.descendants(matching: .any).matching(
                NSPredicate(format: "label CONTAINS %@", "My Notebook")
            ).firstMatch
            if notebook.waitForExistence(timeout: 0.8) {
                notebook.click()
                usleep(500_000)
                app.typeKey("w", modifierFlags: .command)
                usleep(400_000)
            }

            // ----- Per-chapter screenshot for the run log -----
            let screenshot = XCUIScreen.main.screenshot()
            let attachment = XCTAttachment(screenshot: screenshot)
            attachment.name = "ch\(String(format: "%02d", chapterNumber))-interaction"
            attachment.lifetime = .keepAlways
            add(attachment)

            AXHelpers.navigateBack(in: app)
        }
    }
}
