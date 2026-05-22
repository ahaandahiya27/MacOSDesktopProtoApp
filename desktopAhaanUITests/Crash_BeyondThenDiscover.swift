import XCTest

// MARK: - Crash_BeyondThenDiscover (regression lock for C2)
//
// Repro: Sidebar → Science → Ch. 1 → Beyond the Book → ⌘W (sheet dismiss)
//        → Try Discover Mode → EXC_BAD_ACCESS in objc_release (before fix).
//
// Root cause (two halves of the same race):
//   1) ChapterDetailView CTAs ran their navigation/sheet mutations in the
//      same runloop tick as the sheet-dismount commit pump → parent
//      commit collided with sheet-dismount commit. Fixed in dfdbbb4 by
//      deferring every CTA mutation via DispatchQueue.main.async.
//   2) NativeArticleRepresentable handed the NSScrollView back to SwiftUI
//      for release without ordering the NSTextView teardown, so AppKit
//      could route one more delegate/layout-manager callback into a
//      freed instance during the next render commit. Fixed in ffd889c
//      by adding dismantleNSView that nils any delegate first then
//      detaches documentView before the SwiftUI commit unwinds.
//
// Wiring: this file is the only member of the `desktopAhaanUITests`
// target (`com.apple.product-type.bundle.ui-testing`). It is added to
// `desktopAhaan.xcscheme`'s TestAction with `skipped="YES"` so the
// default `xcodebuild test` run (used by the pre-push hook and CI)
// does not try to drive it. The host app is desktopAhaan.app.
//
// To run this test explicitly on the iMac (where the crash actually
// reproduces and AX has been granted once to the runner):
//
//     xcodebuild test \
//       -scheme desktopAhaan \
//       -destination 'platform=macOS' \
//       -only-testing:desktopAhaanUITests/Crash_BeyondThenDiscover
//
// First run on a fresh machine will prompt for Accessibility under
// System Settings → Privacy & Security → Accessibility — grant it to
// the test runner (`desktopAhaanUITests-Runner.app`). Without the
// grant the click/keystroke calls below silently no-op and the final
// assertion fails by timeout, which is the correct failure mode (no
// false-confidence pass).
//
// Accessibility identifiers driven below are set on:
//   - ChapterListView → "chapter-N" (the chapter row buttons)
//   - ChapterDetailView Beyond-the-Book card → "beyond-the-book"
//   - ChapterDetailView Discover banner → "try-discover-mode"

final class Crash_BeyondThenDiscover: XCTestCase {
    func testBeyondTheBookThenDiscoverMode() throws {
        let app = XCUIApplication(bundleIdentifier: "com.emoha.desktopAhaan")
        app.launch()

        dismissWelcomeIfNeeded(in: app)

        // Sidebar → Science. The row label varies by pack title, so we
        // match by substring rather than full equality to stay robust
        // against future renames.
        let scienceRow = app.staticTexts.matching(
            NSPredicate(format: "label CONTAINS %@", "Science")
        ).firstMatch
        XCTAssertTrue(scienceRow.waitForExistence(timeout: 3))
        scienceRow.click()

        // First chapter row — stable identifier "chapter-1" added in
        // ChapterListView.
        let chapter1 = app.buttons["chapter-1"].firstMatch
        XCTAssertTrue(chapter1.waitForExistence(timeout: 3))
        chapter1.click()

        // Beyond the Book — stable identifier "beyond-the-book" on
        // ChapterDetailView's BeyondTheBookCard.
        let beyondTheBook = app.buttons["beyond-the-book"].firstMatch
        XCTAssertTrue(beyondTheBook.waitForExistence(timeout: 3))
        beyondTheBook.click()
        sleep(1)

        // Close the article sheet via ⌘W (matches the keyboardShortcut
        // wired on the close button inside ArticleBrowserView).
        app.typeKey("w", modifierFlags: .command)
        usleep(300_000)

        // Try Discover Mode — stable identifier "try-discover-mode" on
        // ChapterDetailView's discover banner button.
        let tryDiscover = app.buttons["try-discover-mode"].firstMatch
        XCTAssertTrue(tryDiscover.waitForExistence(timeout: 3))
        tryDiscover.click()

        // If the dismantle/CTA-defer fix works, the Discover scene
        // renders. If the app crashed, this assertion never gets the
        // chance to evaluate — test fails through process exit.
        let discoverTitle = app.staticTexts.matching(
            NSPredicate(format: "label CONTAINS %@", "Discover")
        ).matching(
            NSPredicate(format: "label CONTAINS %@", "Nutrition in Plants")
        ).firstMatch
        XCTAssertTrue(
            discoverTitle.waitForExistence(timeout: 5),
            "Discover did not render after the Beyond→close→Discover sequence — crash signature returned."
        )
    }

    private func dismissWelcomeIfNeeded(in app: XCUIApplication) {
        let letsGo = app.buttons["Let's go"]
        if letsGo.waitForExistence(timeout: 1) {
            letsGo.click()
        }
    }
}
