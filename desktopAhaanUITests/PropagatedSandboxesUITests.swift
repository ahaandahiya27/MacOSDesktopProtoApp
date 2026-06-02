import XCTest

// MARK: - PropagatedSandboxesUITests
//
// One mount-and-interact walk for each of the nine propagated Science
// "Build-a-…" sandboxes. Unlike the tours, these are NOT coordinator
// sheets — they mount inline in the chapter scroll via
// `BuildA*Sandbox(chapterId:)` (see ChapterDetailView+PropagatedCTAs.swift,
// ch1PilotInteractives + propagatedPilotInteractivesA/B). So a walk:
//   1. open the chapter,
//   2. assert the sandbox container exists — it may be below the fold, but
//      the macOS AX tree includes off-screen elements for waitForExistence
//      and `.click()` auto-scrolls,
//   3. tap one stable control — every sandbox has an explainer-toggle
//      Button (collapsed label varies per sandbox; expands to a
//      "Hide …" label),
//   4. assert the post-tap state — the toggle flips to its expanded label,
//      which only appears after the tap. Deterministic two-state change.
//
// Why the explainer toggle and not a slider: the four-ish input sliders
// are continuous (the output readout changes by fractions), so there's no
// single deterministic post-tap string. The explainer toggle is the one
// discrete control common to all nine sandboxes, and its label flip is an
// exact, source-grounded assertion.
//
// All queried strings are copied verbatim from source:
//   - container accessibilityLabel:  the sandbox's `.accessibilityLabel(...)`
//   - toggle collapsed/expanded text: the sandbox's `explainerToggle`
// Both are matched with a CONTAINS predicate so a leading chevron glyph
// the Button may fold into its synthesized label can't break the query.
//
// Big Sur compat — same rules as GoldenPathUITests: no `app.accessibilityLabel`,
// `waitForExistence(timeout:)`, no async waiters. `--ui` opt-in (AX grant
// on the runner); without it the clicks no-op and assertions fail by
// timeout (correct failure mode).

final class PropagatedSandboxesUITests: XCTestCase {

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

    /// Shared body for the nine sandbox walks. `collapsedToggle` is the
    /// label of the explainer button before any tap (varies per sandbox);
    /// `expandedToggle` is the label it flips to after the tap. Both use a
    /// CONTAINS predicate so a decorative chevron in the Button's label
    /// slot doesn't defeat the match.
    private func runSandboxWalk(chapter: Int,
                                containerLabel: String,
                                collapsedToggle: String,
                                expandedToggle: String,
                                file: StaticString = #file,
                                line: UInt = #line) {
        let app = launchedApp()
        XCTAssertTrue(openChapter(chapter, in: app),
                      "Ch.\(chapter) chapter detail did not render — sandbox mount unreachable.",
                      file: file, line: line)

        // The sandbox is an accessibilityElement(children: .contain)
        // container; query it across element types (it surfaces as a
        // group/any). It may be below the fold — the AX tree includes
        // off-screen elements for waitForExistence.
        let container = app.descendants(matching: .any)[containerLabel].firstMatch
        XCTAssertTrue(container.waitForExistence(timeout: 5),
                      "Sandbox container '\(containerLabel)' missing on Ch.\(chapter) — inline mount likely regressed.",
                      file: file, line: line)

        let toggle = app.buttons.matching(
            NSPredicate(format: "label CONTAINS %@", collapsedToggle)
        ).firstMatch
        XCTAssertTrue(toggle.waitForExistence(timeout: 3),
                      "Explainer toggle '\(collapsedToggle)' missing in '\(containerLabel)' on Ch.\(chapter).",
                      file: file, line: line)
        // .click() auto-scrolls the off-screen control into view first.
        toggle.click()

        // Post-tap state: the toggle flips to its expanded label, which
        // only appears once the explainer has been revealed.
        let expanded = app.buttons.matching(
            NSPredicate(format: "label CONTAINS %@", expandedToggle)
        ).firstMatch
        XCTAssertTrue(expanded.waitForExistence(timeout: 3),
                      "Sandbox '\(containerLabel)' did not respond to the explainer tap on Ch.\(chapter) — expected toggle to flip to '\(expandedToggle)'.",
                      file: file, line: line)
    }

    // MARK: - Ch.1 — Build-a-plant

    func testBuildAPlantSandbox_MountsAndInteracts() throws {
        runSandboxWalk(
            chapter: 1,
            containerLabel: "Build-a-plant sandbox",
            collapsedToggle: "Why does this happen?",
            expandedToggle: "Hide explanation"
        )
    }

    // MARK: - Ch.4 — Build-a-heat-flow

    func testBuildAHeatFlowSandbox_MountsAndInteracts() throws {
        runSandboxWalk(
            chapter: 4,
            containerLabel: "Build-a-heat-flow sandbox",
            collapsedToggle: "Why does this happen?",
            expandedToggle: "Hide explanation"
        )
    }

    // MARK: - Ch.5 — Build-a-pH

    func testBuildAPHSandbox_MountsAndInteracts() throws {
        runSandboxWalk(
            chapter: 5,
            containerLabel: "Build-a-pH sandbox",
            collapsedToggle: "What is pH actually measuring?",
            expandedToggle: "Hide explanation"
        )
    }

    // MARK: - Ch.6 — Build-a-reaction

    func testBuildAReactionSandbox_MountsAndInteracts() throws {
        runSandboxWalk(
            chapter: 6,
            containerLabel: "Build-a-reaction sandbox",
            collapsedToggle: "Why does this happen?",
            expandedToggle: "Hide explanation"
        )
    }

    // MARK: - Ch.7 — Build-a-climate

    func testBuildAClimateSandbox_MountsAndInteracts() throws {
        runSandboxWalk(
            chapter: 7,
            containerLabel: "Build-a-climate sandbox",
            collapsedToggle: "Why these four factors?",
            expandedToggle: "Hide explanation"
        )
    }

    // MARK: - Ch.8 — Build-a-wind

    func testBuildAWindSandbox_MountsAndInteracts() throws {
        runSandboxWalk(
            chapter: 8,
            containerLabel: "Build-a-wind sandbox",
            collapsedToggle: "Why does the wind curve?",
            expandedToggle: "Hide explanation"
        )
    }

    // MARK: - Ch.9 — Build-a-soil

    func testBuildASoilSandbox_MountsAndInteracts() throws {
        runSandboxWalk(
            chapter: 9,
            containerLabel: "Build-a-soil sandbox",
            collapsedToggle: "Why is loam the ideal?",
            expandedToggle: "Hide explanation"
        )
    }

    // MARK: - Ch.13 — Build-a-motion

    func testBuildAMotionSandbox_MountsAndInteracts() throws {
        runSandboxWalk(
            chapter: 13,
            containerLabel: "Build-a-motion sandbox",
            collapsedToggle: "Show the formulas",
            expandedToggle: "Hide formulas"
        )
    }

    // MARK: - Ch.16 — Build-a-water-cycle

    func testBuildAWaterCycleSandbox_MountsAndInteracts() throws {
        runSandboxWalk(
            chapter: 16,
            containerLabel: "Build-a-water-cycle sandbox",
            collapsedToggle: "Why does the level drop even when it rains?",
            expandedToggle: "Hide explanation"
        )
    }
}
