import XCTest

// MARK: - HomeExperimentsUITests
//
// Open→assert→dismiss→re-mount walk for the "Try at Home" home-experiments
// sheet. The sheet mounts from `TryAtHomeCard` on the chapter detail page
// (ChapterDetailView+EnrichmentCards.swift) via
// `sheetCoordinator.presented = .homeExperiments` (ChapterDetailView.swift),
// and renders `HomeExperimentsSheet` (ChapterDetailView+HomeExperiments.swift).
//
// The card auto-hides on chapters with no authored experiments
// (`HomeExperimentLibrary.hasExperiments(...)`). Ch.1 is the canonical
// chapter WITH experiments — `HomeExperimentLibrary.experiments["ch01"]`
// has five, the first being "Iodine starch map of a leaf". We pin Ch.1 so
// the walk is deterministic; the card's presence doubles as a check that
// Ch.1 still has experiments in the library.
//
// All queried strings are copied verbatim from source:
//   - card accessibilityLabel "Try at Home": TryAtHomeCard
//   - first experiment title:                HomeExperimentLibrary.experiments["ch01"][0].title
//   - sheet close button "Close":            HomeExperimentsSheet header
//
// Why assert the first-experiment title and not the sheet's "Try at Home"
// header: the card label is ALSO "Try at Home", so that string is in the
// tree before the sheet even presents. The experiment title only appears
// once the sheet has mounted — an unambiguous proxy for "the sheet opened."
//
// Big Sur compat — same rules as GoldenPathUITests. `--ui` opt-in (AX grant
// on the runner); without it the clicks no-op and assertions fail by
// timeout (correct failure mode).

final class HomeExperimentsUITests: XCTestCase {

    private func launchedApp() -> XCUIApplication {
        let app = XCUIApplication(bundleIdentifier: "com.emoha.desktopAhaan")
        app.launch()
        AXHelpers.dismissWelcomeUI(in: app)
        return app
    }

    func testHomeExperimentsSheet_OpenAndDismiss() throws {
        let app = launchedApp()
        XCTAssertTrue(AXHelpers.openChapter(1, in: app),
                      "Ch.1 chapter detail did not render — Try at Home mount unreachable.")

        // The Try at Home card — accessibilityLabel set in TryAtHomeCard.
        // If Ch.1 ever loses its authored experiments the card auto-hides,
        // so this also pins "Ch.1 still has home experiments."
        let card = app.buttons["Try at Home"].firstMatch
        XCTAssertTrue(card.waitForExistence(timeout: 3),
                      "Try at Home card missing on Ch.1 — chapter detail mount changed, or Ch.1 lost its experiments.")
        card.click()

        // Sheet present — assert the first experiment's title text. This is
        // distinct from the card/sheet "Try at Home" header (which is
        // ambiguous), so it only matches once the sheet has mounted.
        let firstExperiment = app.staticTexts["Iodine starch map of a leaf"].firstMatch
        XCTAssertTrue(firstExperiment.waitForExistence(timeout: 5),
                      "Home experiments sheet did not present within 5s — deferred sheetCoordinator.presented = .homeExperiments path likely broken.")

        // Dismiss. The sheet's "Close" button carries .cancelAction, so
        // Escape is the most portable dismiss path across SwiftUI sheet
        // implementations (same approach as the Glossary walk).
        app.typeKey(.escape, modifierFlags: [])
        usleep(300_000) // 0.3s — sheet dismount settle.

        // Back to the chapter detail.
        XCTAssertTrue(card.waitForExistence(timeout: 5),
                      "Chapter detail did not re-mount after the home experiments sheet dismissed.")
    }
}
