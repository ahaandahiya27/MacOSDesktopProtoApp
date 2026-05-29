import XCTest

// MARK: - MathsDiscoverWalkUITests
//
// Closes Family K.2 of BUG_FREE_CERTIFICATION_REPORT.md — the
// "maths Discover Mode 0/15 UI-tested" gap.
//
// Mirror of `Crash1_TryDiscoverMode_Ch1` (science) and
// `Crash_BeyondThenDiscover` for the maths pack. The walk:
//   Sidebar → Maths → Ch.{5,10} → Try Discover Mode → Discover shell.
//
// If Discover Mode regresses on either chapter (over-release, missing
// scene wiring, pack-id leak), the click returns to a non-Discover
// state and the title assertion fails — by process death in the
// crash case, or by timeout in the structural case.
//
// Wiring + invocation: same as `Crash1_TryDiscoverMode_Ch1.swift`
// header. Default test runs skip the UI bundle via
// `-skip-testing:desktopAhaanUITests` in scripts/ci-build-test.sh.
// Opt-in via `bash scripts/ci-build-test.sh --ui` on a Mac where
// the runner has been granted Accessibility permission.
//
// Why two chapters (5 + 10)?
//   • Ch.5 (Parallel and Intersecting Lines) — covers the early
//     geometry surface; Discover scenes use protractor + line-pair
//     interactions.
//   • Ch.10 (Operations with Integers) — the original maths
//     Discover pilot; covers number-line + sign-rules scenes plus
//     the boss-quiz wiring.
// Together they exercise both geometry-style and arithmetic-style
// scene families.

final class MathsDiscoverWalkUITests: XCTestCase {

    func testTryDiscoverModeFromMathsCh5_doesNotCrash() throws {
        try walkMathsChapter(number: 5, titleSubstring: "Parallel and Intersecting Lines")
    }

    func testTryDiscoverModeFromMathsCh10_doesNotCrash() throws {
        try walkMathsChapter(number: 10, titleSubstring: "Operations with Integers")
    }

    // MARK: - Walk

    private func walkMathsChapter(number: Int, titleSubstring: String) throws {
        let app = XCUIApplication(bundleIdentifier: "com.emoha.desktopAhaan")
        app.launch()

        AXHelpers.dismissWelcomeUI(in: app)

        let mathsRow = app.descendants(matching: .any)["subject-row-maths_class7"].firstMatch
        XCTAssertTrue(mathsRow.waitForExistence(timeout: 5),
                      "Sidebar row 'subject-row-maths_class7' did not appear.")
        mathsRow.click()

        let chapter = app.buttons["chapter-\(number)"].firstMatch
        XCTAssertTrue(chapter.waitForExistence(timeout: 5),
                      "Chapter \(number) row 'chapter-\(number)' did not appear.")
        chapter.click()

        let tryDiscover = app.buttons["try-discover-mode"].firstMatch
        XCTAssertTrue(tryDiscover.waitForExistence(timeout: 5),
                      "Discover banner 'try-discover-mode' did not appear for maths Ch.\(number).")
        tryDiscover.click()

        // Final assertion: the Discover shell rendered with the
        // expected chapter title substring. Crash signal: process
        // exits before this resolves; structural signal: title
        // never matches.
        let discoverTitle = app.staticTexts.matching(
            NSPredicate(format: "label CONTAINS %@", "Discover")
        ).matching(
            NSPredicate(format: "label CONTAINS %@", titleSubstring)
        ).firstMatch
        XCTAssertTrue(discoverTitle.waitForExistence(timeout: 5),
                      "Discover shell did not render after Try Discover Mode click on " +
                      "maths Ch.\(number) ('\(titleSubstring)') — regression or pack-id mismatch.")
    }
}
