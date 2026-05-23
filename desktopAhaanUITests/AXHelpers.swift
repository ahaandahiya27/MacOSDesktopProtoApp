import XCTest

// MARK: - Shared UITest helpers
//
// Used by Crash1_TryDiscoverMode_Ch1, Crash_BeyondThenDiscover, and
// Surface_AuditWalker. Keeps the welcome-dismiss / chapter-open
// boilerplate in one place so when the welcome UI changes (it has
// twice in 2026-05) every test follows along automatically.
//
// All helpers are no-throw / no-fail-by-themselves so a test caller
// can decide whether a missing element is an assertion miss or a
// benign branch.

enum AXHelpers {
    /// Dismiss whatever welcome / onboarding sheet may be on screen
    /// at first launch. Handles three known surfaces:
    ///
    /// 1. The retired single-panel WelcomeSheet (button identifier
    ///    `welcome-lets-go`). Kept here for backwards-compatibility
    ///    with installs that still have `hasSeenWelcome=false` but
    ///    have NOT seen the new tour yet.
    /// 2. The current 3-panel WelcomeTourSheet (button identifier
    ///    `welcome-tour-primary` — same id for Next + Done). Walks
    ///    all 3 panels by clicking the primary until the sheet
    ///    dismounts.
    /// 3. The version-bump WhatsNewSheet (button identifier
    ///    `whats-new-done`).
    ///
    /// First match wins so a fresh install only does the tour walk;
    /// a post-tour user only sees what's-new at most once.
    static func dismissWelcomeUI(in app: XCUIApplication) {
        // (1) Legacy single-panel welcome.
        let letsGo = app.buttons["welcome-lets-go"]
        if letsGo.waitForExistence(timeout: 1) {
            letsGo.click()
            return
        }

        // (2) Current 3-panel WelcomeTourSheet. The "Next" / "Done"
        // button shares an accessibilityIdentifier so we just click
        // it up to 3 times until the sheet is gone. The same button
        // also responds to .defaultAction (Return), but a click is
        // more reliable when running in a host that's not the
        // focused window.
        let tourPrimary = app.buttons["welcome-tour-primary"]
        if tourPrimary.waitForExistence(timeout: 1) {
            for _ in 0..<4 {
                guard tourPrimary.exists else { break }
                tourPrimary.click()
                usleep(250_000) // 0.25s — let the panel swap commit.
            }
            return
        }

        // (3) What's New auto-presents after a version bump on a
        // user who has already seen the tour. Dismiss it the same
        // way.
        let whatsNewDone = app.buttons["whats-new-done"]
        if whatsNewDone.waitForExistence(timeout: 1) {
            whatsNewDone.click()
        }
    }

    /// Navigate to a specific chapter from a freshly-launched app.
    /// Returns `true` if the chapter detail page appears within the
    /// given timeout; the caller can XCTAssert that.
    @discardableResult
    static func openChapter(_ number: Int, in app: XCUIApplication,
                            timeout: TimeInterval = 5) -> Bool {
        // Sidebar → Science. The descendants(matching:) form catches
        // the row whether it lands under .table, .list, or .group on
        // the various macOS versions we target.
        let scienceRow = app.descendants(matching: .any)["subject-row-science_class7"].firstMatch
        guard scienceRow.waitForExistence(timeout: timeout) else { return false }
        if !scienceRow.isSelected { scienceRow.click() }

        let row = app.buttons["chapter-\(number)"].firstMatch
        guard row.waitForExistence(timeout: timeout) else { return false }
        row.click()
        // Wait until the chapter detail page settles. The Try
        // Discover Mode banner is a stable proxy (it ships for
        // every Science chapter).
        return app.buttons["try-discover-mode"].firstMatch
            .waitForExistence(timeout: timeout)
    }

    /// Pop the current chapter back to the chapter list via ⌘[
    /// (the navigateBackCommand wired in desktopAhaanApp.swift's
    /// Edit menu). Pairs with `openChapter(_:)` for sequential
    /// walks across all 19 chapters.
    static func navigateBack(in app: XCUIApplication) {
        app.typeKey("[", modifierFlags: .command)
        usleep(300_000)
    }
}
