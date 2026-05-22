import XCTest

// MARK: - Crash1_TryDiscoverMode_Ch1 (regression lock for C1)
//
// C1 is the `EXC_BAD_ACCESS (code=1)` in `libobjc.A.dylib`objc_release`
// that Xcode caught while paused on the Try Discover Mode CTA in Ch.1
// on 2026-05-21. Suspected sites were NSHostingView teardown,
// AVSpeechSynthesizer delegate, NSTimer target, Combine sink without
// `[weak self]`, `var delegate:` instead of `weak var`, `@unchecked
// Sendable` — all enumerated and mitigated in CRASH_LEDGER C1 row.
//
// This test is the minimal walk that proves the entire path stays
// clean:
//   Sidebar → Science → Ch.1 → Try Discover Mode → Discover shell renders.
//
// If C1 returns, the click on Try Discover Mode raises the over-release
// during the next render commit and the process exits before
// `waitForExistence` for the Discover title can resolve — the assertion
// fails by process death, which is the correct failure mode.
//
// Wiring + invocation: same as Crash_BeyondThenDiscover.swift — see its
// header. Default test runs skip the UI bundle via
// `-skip-testing:desktopAhaanUITests` in scripts/ci-build-test.sh;
// explicit run via:
//
//     xcodebuild test \
//       -scheme desktopAhaan \
//       -destination 'platform=macOS' \
//       -only-testing:desktopAhaanUITests/Crash1_TryDiscoverMode_Ch1
//
// First run on a fresh machine prompts for Accessibility — grant it to
// the runner once. Without the grant the click calls silently no-op
// and the assertion fails by timeout.

final class Crash1_TryDiscoverMode_Ch1: XCTestCase {
    func testTryDiscoverModeFromCh1_doesNotCrash() throws {
        let app = XCUIApplication(bundleIdentifier: "com.emoha.desktopAhaan")
        app.launch()

        dismissWelcomeIfNeeded(in: app)

        let scienceRow = app.descendants(matching: .any)["subject-row-science_class7"].firstMatch
        XCTAssertTrue(scienceRow.waitForExistence(timeout: 5),
                      "Sidebar row 'subject-row-science_class7' did not appear.")
        scienceRow.click()

        let chapter1 = app.buttons["chapter-1"].firstMatch
        XCTAssertTrue(chapter1.waitForExistence(timeout: 5),
                      "Chapter 1 row 'chapter-1' did not appear.")
        chapter1.click()

        let tryDiscover = app.buttons["try-discover-mode"].firstMatch
        XCTAssertTrue(tryDiscover.waitForExistence(timeout: 5),
                      "Discover banner 'try-discover-mode' did not appear.")
        tryDiscover.click()

        // Final assertion: if C1 over-release returned, the process is
        // gone before this can resolve. Match the Discover shell by
        // title substring (chapter number + topic title).
        let discoverTitle = app.staticTexts.matching(
            NSPredicate(format: "label CONTAINS %@", "Discover")
        ).matching(
            NSPredicate(format: "label CONTAINS %@", "Nutrition in Plants")
        ).firstMatch
        XCTAssertTrue(discoverTitle.waitForExistence(timeout: 5),
                      "Discover shell did not render after Try Discover Mode click — C1 over-release likely returned.")
    }

    private func dismissWelcomeIfNeeded(in app: XCUIApplication) {
        let letsGo = app.buttons["welcome-lets-go"]
        if letsGo.waitForExistence(timeout: 2) {
            letsGo.click()
        }
    }
}
