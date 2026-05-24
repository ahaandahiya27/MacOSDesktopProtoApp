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

    // MARK: - 6. Notebook sheet — open + persist + dismiss + re-open

    /// The kid's notebook is the only surface where they create
    /// irreplaceable data. If a refactor ever silently breaks the
    /// write path, the kid loses their notes with no recovery. This
    /// test does a full round-trip: open the sheet, type a unique
    /// sentinel string, dismiss, re-open, assert the sentinel is
    /// still in the editor.
    ///
    /// Persistence happens via `.onChange(of: draft)` on every
    /// keystroke (DataStore.setChapterNote is sync + atomic), so by
    /// the time the close happens the data is already on disk. The
    /// re-open verifies the read-back path matches.
    func testNotebookSheet_OpenWritePersistAndReopen() throws {
        let app = launchedApp()
        XCTAssertTrue(openChapter(1, in: app))

        // Sentinel includes a timestamp so consecutive runs of the
        // test on the same chapter don't collide on assertion. A
        // previous test's note that survived in DataStore would
        // otherwise show up in the editor and mask a true write
        // failure.
        let sentinel = "ui-test sentinel \(Int(Date().timeIntervalSince1970))"

        // Open the notebook via the "My Notebook" hero card. The
        // accessibilityLabel is set in NotebookCard (see
        // ChapterDetailView+Notebook.swift).
        let notebookBtn = app.buttons["My Notebook"].firstMatch
        XCTAssertTrue(notebookBtn.waitForExistence(timeout: 3),
                      "Notebook CTA missing on Ch.1 — chapter detail mount changed.")
        notebookBtn.click()

        // Sheet present — assert the title text is visible.
        let sheetTitle = app.staticTexts["My Notebook"].firstMatch
        XCTAssertTrue(sheetTitle.waitForExistence(timeout: 5),
                      "Notebook sheet did not present.")

        // The TextEditor is the only text input in the sheet; type
        // into it. Click first to focus, then typeText. usleep gives
        // the .onChange persistence cycle one runloop to commit.
        let editor = app.textViews.firstMatch
        XCTAssertTrue(editor.waitForExistence(timeout: 2),
                      "Notebook TextEditor not in AX tree.")
        editor.click()
        editor.typeText(sentinel)
        usleep(500_000) // 0.5s — covers DataStore.setChapterNote atomic write

        // Done button has .keyboardShortcut(.defaultAction), so
        // pressing Return is the most reliable way to dismiss. The
        // sheet's dismiss closure also runs the "captured" defensive
        // write through DispatchQueue.main.async — by the time the
        // sheet dismounts, the value is on disk.
        app.typeKey(.return, modifierFlags: [])
        usleep(500_000) // 0.5s — sheet dismount + deferred write commit

        // Re-open. The same DataStore instance + chapter id should
        // produce the same draft string.
        XCTAssertTrue(notebookBtn.waitForExistence(timeout: 3),
                      "Notebook button missing after sheet dismissed.")
        notebookBtn.click()
        XCTAssertTrue(sheetTitle.waitForExistence(timeout: 5),
                      "Notebook sheet did not re-present.")

        // The sentinel should be in the TextEditor's value.
        // textViews on macOS surface their content via .value.
        let reopenedEditor = app.textViews.firstMatch
        XCTAssertTrue(reopenedEditor.waitForExistence(timeout: 2),
                      "Re-opened notebook TextEditor not in AX tree.")
        let editorValue = (reopenedEditor.value as? String) ?? ""
        XCTAssertTrue(editorValue.contains(sentinel),
                      "Notebook persistence regressed — sentinel '\(sentinel)' not in re-opened editor (saw: '\(editorValue.prefix(120))').")

        // Cleanup: clear the editor + close so we don't leave junk
        // in the user's actual chapter notes on the test machine.
        reopenedEditor.click()
        app.typeKey("a", modifierFlags: .command)
        app.typeKey(.delete, modifierFlags: [])
        app.typeKey(.return, modifierFlags: [])
    }

    // MARK: - 7. Glossary sheet — open + dismiss

    /// Glossary is chapter-scoped; the code path is identical across
    /// every chapter that has a non-empty glossary. One test on Ch.1
    /// (10 glossary terms as of 2026-05-24) covers the whole class.
    /// Auto-hides when chapter.glossary is empty, so the assertion
    /// "the button exists" doubles as "Ch.1 still has terms in JSON".
    func testGlossarySheet_OpenAndDismiss() throws {
        let app = launchedApp()
        XCTAssertTrue(openChapter(1, in: app))

        // Glossary button accessibilityLabel format is
        // "Glossary — N terms". Ch.1 currently has 10 terms; if a
        // content edit changes the count, this needs updating.
        // Using BEGINSWITH on the label predicate would be more
        // resilient — but pinning the exact count also catches an
        // accidental drop in glossary content.
        let glossaryBtn = app.buttons["Glossary — 10 terms"].firstMatch
        XCTAssertTrue(glossaryBtn.waitForExistence(timeout: 3),
                      "Ch.1 glossary button missing or term count drifted from 10 — check chapter.glossary in science_class7.json.")
        glossaryBtn.click()

        // GlossarySheet's body renders "Glossary" as its title and
        // has a close action (.cancelAction). Assert the title text
        // appears so we know the sheet mounted (the button label
        // "Glossary — 10 terms" only exists on the chapter detail,
        // not in the sheet itself).
        let sheetTitle = app.staticTexts["Glossary"].firstMatch
        XCTAssertTrue(sheetTitle.waitForExistence(timeout: 5),
                      "Glossary sheet did not present within 5s of the CTA tap.")

        // Dismiss via Escape (.cancelAction is wired on the close
        // button inside GlossarySheet) — the most portable dismiss
        // path across SwiftUI sheet implementations.
        app.typeKey(.escape, modifierFlags: [])
        usleep(300_000)

        // Back to chapter detail.
        XCTAssertTrue(glossaryBtn.waitForExistence(timeout: 5),
                      "Chapter detail did not re-mount after glossary dismissed.")
    }

    // MARK: - 8. InsideTheWireTour — propagated-tour smoke test

    /// The leaf tour (test #3) covers Ch.1 — but Ch.1 is the pilot,
    /// not a propagated mount. The propagated tours live in
    /// `propagatedPilotInteractivesB` (commit 599f0f8 + 84eed29).
    /// Pinning ONE propagated tour proves the coordinator's
    /// `presentDeferred(.insideTheWireTour)` path works and that the
    /// sister-file `insideTheWireTourCTA(coordinator:)` function
    /// wiring is intact. Picking Wire (Ch.14) over Lens (Ch.15)
    /// because Ch.14 is in the physics cluster — different chapter
    /// cohort, different `else-if` arm in the dispatcher, more
    /// representative of "did the propagation pattern survive."
    func testInsideTheWireTour_OpenAndDismiss() throws {
        let app = launchedApp()
        XCTAssertTrue(openChapter(14, in: app),
                      "Ch.14 chapter detail did not render — propagated mount unreachable.")

        let cta = app.buttons["Inside the wire — five-stop electron-flow tour"].firstMatch
        XCTAssertTrue(cta.waitForExistence(timeout: 3),
                      "Inside the Wire CTA missing on Ch.14 — propagatedPilotInteractivesB ch14 mount likely regressed.")
        cta.click()

        // First stop title from WireTourStop.battery.title.
        let firstStopTitle = app.staticTexts["At the battery's negative terminal"].firstMatch
        XCTAssertTrue(firstStopTitle.waitForExistence(timeout: 5),
                      "InsideTheWireTour did not present — coordinator's presentDeferred(.insideTheWireTour) may have regressed.")

        // Close button accessibilityLabel set in
        // InsideTheWireTour.swift's header bar.
        let closeBtn = app.buttons["Close wire tour"].firstMatch
        XCTAssertTrue(closeBtn.waitForExistence(timeout: 2))
        closeBtn.click()

        XCTAssertTrue(cta.waitForExistence(timeout: 5),
                      "Ch.14 chapter detail did not re-mount after wire tour dismissed.")
    }
}
