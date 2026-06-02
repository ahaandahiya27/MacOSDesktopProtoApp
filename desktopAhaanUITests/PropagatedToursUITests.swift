import XCTest

// MARK: - PropagatedToursUITests
//
// One open→assert-first-stop→close→re-mount walk for each of the four
// propagated Science tours that did NOT have a walk before this file:
//   - Ch.2  digestive  (InsideTheDigestiveTour)
//   - Ch.10 alveolus   (InsideTheAlveolusTour)
//   - Ch.11 xylem       (InsideTheXylemAscentTour)
//   - Ch.15 lens        (InsideTheLensTour)
//
// The Ch.1 leaf tour (`testInsideTheLeafTour_OpenAndDismiss`) and the
// Ch.14 wire tour (`testInsideTheWireTour_OpenAndDismiss`) already live
// in GoldenPathUITests — this file fills in the remaining propagated
// tours so the whole `propagatedPilotInteractives` dispatcher + every
// `coordinator.presentDeferred(.insideThe*Tour)` arm is pinned, not just
// two representatives.
//
// Each test is a faithful copy of the wire-tour shape:
//   open chapter → CTA exists → click → first-stop title exists →
//   close button click → CTA re-mounts.
//
// All queried strings are copied verbatim from source:
//   - CTA accessibilityLabel:    ChapterDetailView+PropagatedCTAs.swift
//   - first-stop title:          the per-tour `<Foo>TourStop.<first>.title`
//   - close button accessibility label: the per-tour header bar
//
// Big Sur (iMac late-2014 / 11.7.11) compat — same rules as
// GoldenPathUITests: `app.buttons[<label>]` / `app.staticTexts[<label>]`,
// no `app.accessibilityLabel`, plain `waitForExistence(timeout:)`,
// `usleep` for settle. The UI-test bundle is `--ui` opt-in — without an
// Accessibility grant to the runner the clicks no-op and these assertions
// fail by timeout (the correct, no-false-confidence failure mode).

final class PropagatedToursUITests: XCTestCase {

    // MARK: - Helpers (mirror GoldenPathUITests)

    private func launchedApp() -> XCUIApplication {
        let app = XCUIApplication(bundleIdentifier: "com.emoha.desktopAhaan")
        app.launch()
        AXHelpers.dismissWelcomeUI(in: app)
        return app
    }

    @discardableResult
    private func openChapter(_ n: Int, in app: XCUIApplication) -> Bool {
        AXHelpers.openChapter(n, in: app)
    }

    /// Shared body for the four tour walks. Keeping the structure in one
    /// place — instead of four near-identical copies — means a drift in
    /// the open/close protocol gets fixed once. The per-tour strings are
    /// the only thing that varies, so they're the only thing each test
    /// passes in.
    private func runTourWalk(chapter: Int,
                             ctaLabel: String,
                             firstStopTitle: String,
                             closeLabel: String,
                             file: StaticString = #file,
                             line: UInt = #line) {
        let app = launchedApp()
        XCTAssertTrue(openChapter(chapter, in: app),
                      "Ch.\(chapter) chapter detail did not render — propagated mount unreachable.",
                      file: file, line: line)

        let cta = app.buttons[ctaLabel].firstMatch
        XCTAssertTrue(cta.waitForExistence(timeout: 3),
                      "CTA '\(ctaLabel)' missing on Ch.\(chapter) — propagatedPilotInteractives mount likely regressed.",
                      file: file, line: line)
        cta.click()

        // First stop's title is rendered standalone in the tour's
        // narration card (`Text(current.title)`), so it's a queryable
        // staticText once the sheet has presented.
        let firstStop = app.staticTexts[firstStopTitle].firstMatch
        XCTAssertTrue(firstStop.waitForExistence(timeout: 5),
                      "Tour did not present within 5s on Ch.\(chapter) — coordinator's presentDeferred path likely broken (expected first stop '\(firstStopTitle)').",
                      file: file, line: line)

        // Close button accessibilityLabel set in the tour header bar.
        let closeBtn = app.buttons[closeLabel].firstMatch
        XCTAssertTrue(closeBtn.waitForExistence(timeout: 2),
                      "Close button '\(closeLabel)' not in tour header on Ch.\(chapter).",
                      file: file, line: line)
        closeBtn.click()

        XCTAssertTrue(cta.waitForExistence(timeout: 5),
                      "Ch.\(chapter) chapter detail did not re-mount after the tour dismissed.",
                      file: file, line: line)
    }

    // MARK: - Ch.2 — InsideTheDigestiveTour

    func testInsideTheDigestiveTour_OpenAndDismiss() throws {
        runTourWalk(
            chapter: 2,
            ctaLabel: "Inside the digestive system — five-stop tour",
            firstStopTitle: "Mouth — chewing + saliva",
            closeLabel: "Close digestive tour"
        )
    }

    // MARK: - Ch.10 — InsideTheAlveolusTour

    func testInsideTheAlveolusTour_OpenAndDismiss() throws {
        runTourWalk(
            chapter: 10,
            ctaLabel: "Inside an alveolus — five-stop respiratory tour",
            firstStopTitle: "At the nostril — first filter",
            closeLabel: "Close alveolus tour"
        )
    }

    // MARK: - Ch.11 — InsideTheXylemAscentTour

    func testInsideTheXylemTour_OpenAndDismiss() throws {
        runTourWalk(
            chapter: 11,
            ctaLabel: "The xylem ascent — five-stop tour of water rising up a plant",
            firstStopTitle: "At a root hair — water enters by osmosis",
            closeLabel: "Close xylem tour"
        )
    }

    // MARK: - Ch.15 — InsideTheLensTour

    func testInsideTheLensTour_OpenAndDismiss() throws {
        runTourWalk(
            chapter: 15,
            ctaLabel: "Inside the lens — five-stop refraction tour",
            firstStopTitle: "Light leaves a distant object",
            closeLabel: "Close lens tour"
        )
    }
}
