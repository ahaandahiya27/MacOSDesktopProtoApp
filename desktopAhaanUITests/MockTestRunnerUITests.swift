import XCTest

// MARK: - MockTestRunnerUITests
//
// v9 Exam Simulation. End-to-end happy-path smoke of the Mock Test surface:
//
//     launch → dismiss welcome → ⌘⌥M (open Mock Test) → Start →
//     interact in the runner (mark-for-review + jump via the grid) →
//     Submit → confirm "Submit anyway" → assert the report mounted.
//
// Every refactor that touches `MockTestView`'s phase routing, the
// `MockTestWindowPresenter`, `MockTestRunState`, or the setup/runner/report
// view wiring can break this walk silently — the unit suite can't see the
// window flow. One assertion per hop catches a regression at its boundary.
//
// Accessibility grant required to run (it's `--ui` opt-in; the default
// ci-build-test skips execution but still COMPILES this target). First-time
// setup on the runner machine:
//
//   System Settings → Privacy & Security → Accessibility →
//   desktopAhaanUITests-Runner.app  (enable the toggle)
//
// Big Sur (iMac late-2014 / 11.7.11) compat: every query uses
// `app.buttons[<id>]` + `waitForExistence(timeout:)`; sleeps use `usleep()`.
// No macOS 12+ APIs.

final class MockTestRunnerUITests: XCTestCase {

    private func launchedApp() -> XCUIApplication {
        let app = XCUIApplication(bundleIdentifier: "com.emoha.desktopAhaan")
        app.launch()
        AXHelpers.dismissWelcomeUI(in: app)
        return app
    }

    func test_setupToReport_endToEnd() throws {
        let app = launchedApp()

        // Hop 1 — open the Mock Test window via ⌘⌥M (wired in desktopAhaanApp).
        app.typeKey("m", modifierFlags: [.command, .option])
        let startBtn = app.buttons["mocktest-start"].firstMatch
        XCTAssertTrue(startBtn.waitForExistence(timeout: 5),
                      "Mock Test setup did not open — ⌘⌥M / MockTestWindowPresenter may have regressed.")

        // Hop 2 — default config (Mixed · Balanced · Quick) → build + start.
        startBtn.click()
        usleep(400_000) // let the paper build + the runner mount.

        // Hop 3 — the runner is up. The clock + submit button are stable proxies
        // present only on the running surface.
        let submitBtn = app.buttons["mocktest-submit"].firstMatch
        XCTAssertTrue(submitBtn.waitForExistence(timeout: 5),
                      "Mock Test runner did not mount after Start — build/empty-state or runner wiring regressed.")
        XCTAssertTrue(app.staticTexts["mocktest-clock"].firstMatch.waitForExistence(timeout: 2)
                      || app.otherElements["mocktest-clock"].firstMatch.waitForExistence(timeout: 1),
                      "Countdown clock missing from the runner header.")

        // Hop 4 — exercise the runner: flag for review, then jump via the grid.
        let markBtn = app.buttons["mocktest-mark-review"].firstMatch
        if markBtn.waitForExistence(timeout: 2) { markBtn.click(); usleep(150_000) }
        let gridCell2 = app.buttons["mocktest-grid-2"].firstMatch
        if gridCell2.waitForExistence(timeout: 2) { gridCell2.click(); usleep(150_000) }

        // Hop 5 — submit. With questions left unanswered, the confirm alert
        // appears; take the destructive "Submit anyway" path.
        submitBtn.click()
        let confirm = app.buttons["Submit anyway"].firstMatch
        if confirm.waitForExistence(timeout: 2) {
            confirm.click()
        }
        usleep(400_000) // let grading + the report mount.

        // Hop 6 — the report is up. The "New test" + "Done" actions exist only on
        // the report screen, so either is a reliable proxy that grading + the
        // report view mounted.
        let newBtn = app.buttons["mocktest-new"].firstMatch
        let doneBtn = app.buttons["mocktest-done"].firstMatch
        let reportMounted = newBtn.waitForExistence(timeout: 5)
            || doneBtn.waitForExistence(timeout: 1)
        XCTAssertTrue(reportMounted,
                      "Mock Test report did not mount after Submit — grading or report routing regressed.")
    }
}
