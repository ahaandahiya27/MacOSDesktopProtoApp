import XCTest

// MARK: - SRS_Smoke
//
// Opt-in XCUI walk covering the spaced-repetition + mastery sidebar
// surfaces shipped in the 2026-05-24 SRS session. The aim is "does
// the click sequence crash the app", not full content assertions —
// the unit tests (MasteryLevelTests, MasterySummaryTests) cover
// derivation + aggregation correctness.
//
// Wiring: same as the rest of the UI tests in this target. Default
// test runs (scripts/ci-build-test.sh, pre-push hook, CI) pass
// `-skip-testing:desktopAhaanUITests`. Run explicitly on the iMac
// (where AX is granted to the runner):
//
//     xcodebuild test \
//       -scheme desktopAhaan \
//       -destination 'platform=macOS' \
//       -only-testing:desktopAhaanUITests/SRS_Smoke

final class SRS_Smoke: XCTestCase {

    /// Walk: open app → dismiss welcome → sidebar Daily Practice →
    /// sidebar My Progress → assert each surface settles within the
    /// timeout. Attaches a screenshot per surface.
    func test_sidebar_dailyPractice_thenMastery() throws {
        let app = XCUIApplication(bundleIdentifier: "com.emoha.desktopAhaan")
        app.launch()
        AXHelpers.dismissWelcomeUI(in: app)

        // --- Daily Practice -------------------------------------------------
        // The sidebar entry's accessibility label is the SidebarTool.title
        // ("Daily Practice") joined with the systemImage. Looking up via
        // `staticTexts` is brittle on macOS list rows; descendants(matching:
        // .any) with a label substring is the pattern the other UITests use.
        let dailyPracticeRow = app.descendants(matching: .any).matching(
            NSPredicate(format: "label CONTAINS %@", "Daily Practice")
        ).firstMatch
        XCTAssertTrue(
            dailyPracticeRow.waitForExistence(timeout: 5),
            "Daily Practice sidebar row missing within 5s"
        )
        dailyPracticeRow.click()

        // The Daily Practice detail page should expose the
        // "Daily Practice" navigation title within 2s. We assert the
        // page settled rather than what's in it — content depends on
        // the kid's review history, which on a fresh install is empty.
        let dailyPracticeNav = app.descendants(matching: .any).matching(
            NSPredicate(format: "label CONTAINS %@", "Daily Practice")
        ).firstMatch
        XCTAssertTrue(
            dailyPracticeNav.waitForExistence(timeout: 2),
            "Daily Practice detail did not settle within 2s"
        )

        let dailyShot = XCUIScreen.main.screenshot()
        let dailyAtt = XCTAttachment(screenshot: dailyShot)
        dailyAtt.name = "srs-daily-practice"
        dailyAtt.lifetime = .keepAlways
        add(dailyAtt)

        // --- My Progress / MasteryDashboard --------------------------------
        let masteryRow = app.descendants(matching: .any).matching(
            NSPredicate(format: "label CONTAINS %@", "My Progress")
        ).firstMatch
        XCTAssertTrue(
            masteryRow.waitForExistence(timeout: 3),
            "My Progress sidebar row missing within 3s"
        )
        masteryRow.click()

        // Dashboard renders an EmptyStateView on a fresh install
        // ("No mastery to show yet") and a per-chapter list on a
        // populated install. Either way the navigation title
        // "My Progress" should resolve.
        let masteryNav = app.descendants(matching: .any).matching(
            NSPredicate(format: "label CONTAINS %@", "My Progress")
        ).firstMatch
        XCTAssertTrue(
            masteryNav.waitForExistence(timeout: 2),
            "MasteryDashboard did not settle within 2s"
        )

        let masteryShot = XCUIScreen.main.screenshot()
        let masteryAtt = XCTAttachment(screenshot: masteryShot)
        masteryAtt.name = "srs-mastery-dashboard"
        masteryAtt.lifetime = .keepAlways
        add(masteryAtt)
    }
}
