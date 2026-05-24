import XCTest

// MARK: - GoldenPathUITests
//
// Five XCUIAutomation walks covering the new chapter-detail surfaces
// shipped on 2026-05-23..24:
//   - ConceptMapView (commit 21d4d42 — generalised from Ch1ConceptMap
//     to chapter-agnostic Component, now mounts on all 19 chapters).
//   - RelatedChaptersStrip (commit 011cfac — Surface 4 cross-chapter
//     pill strip derived from the concept-map graph).
//   - PilotInteractiveSheetCoordinator (commit 84eed29 — extracted
//     presentedSheet into an ObservableObject, lifted every CTA to a
//     sister file).
//
// Why XCUIAutomation when we have 269 unit tests:
//   The unit suite covers pure-data logic — concept-map derivation,
//   coordinator state, JSON shape. It cannot cover *that the taps
//   land on the right destination*. The original
//   `Crash_BeyondThenDiscover` test (C2) demonstrates the value: a
//   sheet-dismiss → nav-push race recurred three times before the
//   `DispatchQueue.main.async` defer fix stuck. A UI test pinned
//   that path; the unit suite couldn't.
//
// Wiring + invocation: same pattern as Crash1 / Crash_BeyondThenDiscover.
// The pre-push hook script (`scripts/ci-build-test.sh`) passes
// `-skip-testing:desktopAhaanUITests` so default test runs do not try
// to drive AX on machines without an Accessibility grant. Explicit
// run on a machine that has granted AX to the runner:
//
//     xcodebuild test \
//       -scheme desktopAhaan \
//       -destination 'platform=macOS' \
//       -only-testing:desktopAhaanUITests/GoldenPathUITests
//
// First run on a fresh machine prompts for Accessibility under
// System Settings → Privacy & Security → Accessibility — grant it
// to `desktopAhaanUITests-Runner.app`. Without the grant the click
// calls silently no-op and assertions fail by timeout (correct
// failure mode — no false-confidence pass).
//
// Big Sur (iMac late-2014 / 11.7.11) compat:
//   - XCUIApplication / launch() / .buttons[] / .staticTexts[]: all
//     macOS 10.13+ baseline.
//   - waitForExistence(timeout:): macOS 10.13+.
//   - No `app.accessibilityLabel` (that's macOS 13+) — every query
//     goes through `app.buttons[<id-or-label>]`.
//   - No async/await wait helpers (Swift 5.5 baseline is fine but
//     XCTest's `await` waiters need macOS 13). Plain
//     `XCTAssertTrue(.waitForExistence(timeout:))` everywhere.

final class GoldenPathUITests: XCTestCase {

    // MARK: - Helpers

    /// Launch the app, dismiss the welcome / what's-new sheet, and
    /// return the running XCUIApplication. Reused by every test.
    private func launchedApp() -> XCUIApplication {
        let app = XCUIApplication(bundleIdentifier: "com.emoha.desktopAhaan")
        app.launch()
        AXHelpers.dismissWelcomeUI(in: app)
        return app
    }

    /// Open a specific chapter from the launched app and wait until
    /// the chapter detail page has stably rendered (proxied by the
    /// Try Discover Mode banner, which ships for every Science chapter).
    @discardableResult
    private func openChapter(_ n: Int, in app: XCUIApplication) -> Bool {
        AXHelpers.openChapter(n, in: app)
    }

    // MARK: - 1. Chapter detail renders all expected new surfaces

    /// Sanity check that the chapter detail page mounts every new
    /// surface that recent commits added. If any of the four
    /// architectural pieces (coordinator refactor, ConceptMapView
    /// generalisation, RelatedChaptersStrip, tour CTA) silently
    /// breaks its mount, one of the four `waitForExistence` checks
    /// below catches it before the more-detailed per-surface tests
    /// run.
    func testCh1ChapterDetailRendersExpectedSurfaces() throws {
        let app = launchedApp()
        XCTAssertTrue(openChapter(1, in: app),
                      "Ch.1 chapter detail did not render — sidebar / chapter row navigation broken before this test even started.")

        // Try Discover Mode banner — known stable identifier.
        XCTAssertTrue(app.buttons["try-discover-mode"].firstMatch.waitForExistence(timeout: 3),
                      "try-discover-mode banner missing on Ch.1.")

        // Inside the Leaf CTA — accessibilityLabel set in
        // ChapterDetailView+PropagatedCTAs.swift's
        // insideTheLeafTourCTA().
        XCTAssertTrue(app.buttons["Inside the Leaf — five-stop guided tour"].firstMatch.waitForExistence(timeout: 3),
                      "Inside the Leaf CTA missing on Ch.1 — Ch.1 pilot mount or coordinator refactor likely regressed.")

        // ConceptMapView CTA — accessibilityLabel set on the chapter-
        // agnostic conceptMapCTA() in the sister file. Should appear
        // on every chapter with conceptMap data (all 19 today).
        XCTAssertTrue(app.buttons["See the connections — concept map for this chapter"].firstMatch.waitForExistence(timeout: 3),
                      "See-the-connections CTA missing on Ch.1 — ConceptMapView generalisation likely regressed.")
    }

    // MARK: - 2. ConceptMapView sheet round-trip

    /// Open the ConceptMapView sheet on Ch.1, assert it renders, then
    /// close it via its labeled close button. Catches:
    ///   - coordinator's presentDeferred(_:) failing to advance
    ///   - .sheet(item:) binding broken
    ///   - ConceptMapView's body crashing on load
    ///   - close button accessibilityLabel drift
    func testConceptMapSheet_OpenAndDismiss() throws {
        let app = launchedApp()
        XCTAssertTrue(openChapter(1, in: app))

        let cta = app.buttons["See the connections — concept map for this chapter"].firstMatch
        XCTAssertTrue(cta.waitForExistence(timeout: 3))
        cta.click()

        // The sheet's close button has accessibilityLabel "Close
        // concept map" — appears once the sheet has presented.
        let closeBtn = app.buttons["Close concept map"].firstMatch
        XCTAssertTrue(closeBtn.waitForExistence(timeout: 5),
                      "ConceptMapView sheet did not present within 5s of the CTA tap.")

        closeBtn.click()

        // After close, the CTA from the chapter detail should be back
        // in the tree. waitForExistence handles the dismount animation.
        XCTAssertTrue(cta.waitForExistence(timeout: 5),
                      "Chapter detail did not re-mount after ConceptMapView sheet dismissed.")
    }

    // MARK: - 3. InsideTheLeafTour round-trip

    /// Open the Ch.1 pilot tour, assert the title stop renders,
    /// dismiss. Pins the entire Ch.1 pilot CTA + coordinator path
    /// end-to-end.
    func testInsideTheLeafTour_OpenAndDismiss() throws {
        let app = launchedApp()
        XCTAssertTrue(openChapter(1, in: app))

        let cta = app.buttons["Inside the Leaf — five-stop guided tour"].firstMatch
        XCTAssertTrue(cta.waitForExistence(timeout: 3))
        cta.click()

        // Tour's first stop title (from TourStop.outside.title).
        let firstStopTitle = app.staticTexts["Outside the leaf"].firstMatch
        XCTAssertTrue(firstStopTitle.waitForExistence(timeout: 5),
                      "InsideTheLeafTour did not present within 5s — coordinator's presentDeferred(.insideTheLeafTour) likely broken.")

        // Close button accessibilityLabel set in
        // InsideTheLeafTour.swift's header bar.
        let closeBtn = app.buttons["Close leaf tour"].firstMatch
        XCTAssertTrue(closeBtn.waitForExistence(timeout: 2))
        closeBtn.click()

        // Back to the chapter detail.
        XCTAssertTrue(cta.waitForExistence(timeout: 5),
                      "Chapter detail did not re-mount after InsideTheLeafTour dismissed.")
    }

    // MARK: - 4. RelatedChaptersStrip — visible on chapter with pointers

    /// Ch.7 (Weather/Climate) has two cross-chapter pointers from
    /// its authored conceptMap (commit aac7c4f content + 4373a9f
    /// strip). Assert the strip's header and at least one chip
    /// render. If the strip silently fails to derive its targets
    /// (e.g. RelatedChaptersStrip.targetCounts regresses), this
    /// fails by timeout.
    func testRelatedChaptersStrip_VisibleOnCh7() throws {
        let app = launchedApp()
        XCTAssertTrue(openChapter(7, in: app))

        // Strip header accessibilityLabel — built from
        // "Related chapters — N chapter(s) linked via concept map".
        // Ch.7 has 2 cross-chapter pointers; the chip count matches.
        let stripHeader = app.staticTexts["RELATED CHAPTERS"].firstMatch
        XCTAssertTrue(stripHeader.waitForExistence(timeout: 5),
                      "RelatedChaptersStrip header not visible on Ch.7 — derivation may have regressed.")

        // At least one chip should be tappable. Ch.7 reaches into
        // ch04 (Heat) and ch17 (Forest: Our Lifeline) — match either.
        // The chip's accessibilityLabel is
        // "Open Chapter N: <title> — N concept link[s]".
        let ch4Chip = app.buttons["Open Chapter 4: Heat — 1 concept link"].firstMatch
        let ch17Chip = app.buttons["Open Chapter 17: Forest: Our Lifeline — 1 concept link"].firstMatch
        let anyChipVisible = ch4Chip.waitForExistence(timeout: 3) || ch17Chip.waitForExistence(timeout: 3)
        XCTAssertTrue(anyChipVisible,
                      "No related-chapter chip resolved on Ch.7 — strip's chapter-title lookup may have broken.")
    }

    // MARK: - 5. RelatedChaptersStrip — tap navigates to target chapter

    /// The whole point of the strip: tapping a chip pushes to that
    /// chapter. Validates the full nav chain (chip → coordinator-
    /// agnostic nav.push → ChapterDetailView for the target). The
    /// only chip we can pin reliably across content edits is the
    /// Ch.7 → Ch.4 link, since the Ch.4 Heat title is unlikely to
    /// change.
    func testRelatedChaptersStrip_TapNavigatesToTargetChapter() throws {
        let app = launchedApp()
        XCTAssertTrue(openChapter(7, in: app))

        let ch4Chip = app.buttons["Open Chapter 4: Heat — 1 concept link"].firstMatch
        XCTAssertTrue(ch4Chip.waitForExistence(timeout: 5),
                      "Ch.4 chip not visible on Ch.7 — content authoring may have dropped the pointer.")
        ch4Chip.click()

        // After nav.push to Ch.4, the chapter detail's
        // navigationTitle is "Ch. 4 — Heat" and the Try Discover
        // Mode banner remounts. Either is a stable proxy. Use the
        // banner since it's a Button (more reliable to query).
        XCTAssertTrue(app.buttons["try-discover-mode"].firstMatch.waitForExistence(timeout: 5),
                      "Ch.4 detail did not render after tapping the Ch.7 → Ch.4 chip — Surface 4 nav broken.")

        // Tighter assertion: the Ch.4 chapter title should appear in
        // the static text tree (rendered in the navigation title +
        // the chapter card header on the detail page).
        let ch4Title = app.staticTexts.matching(
            NSPredicate(format: "label CONTAINS %@", "Heat")
        ).firstMatch
        XCTAssertTrue(ch4Title.waitForExistence(timeout: 3),
                      "Ch.4 'Heat' chapter title not in the AX tree after navigation.")
    }
}
