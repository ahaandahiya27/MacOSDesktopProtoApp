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
// IMPORTANT — wiring note before this test can actually drive UI:
//
// This file currently lives in desktopAhaanTests (a unit-test bundle,
// `com.apple.product-type.bundle.unit-test`). It is NOT yet referenced
// from desktopAhaan.xcodeproj/project.pbxproj — search confirms zero
// matches for `Crash_BeyondThenDiscover` / `CrashRepros` in the
// project file. Two reasons it cannot be auto-enabled in this session:
//
//   a) XCUIApplication-driven tests want a UI-test bundle
//      (`com.apple.product-type.bundle.ui-testing`) — that target
//      doesn't exist in this project yet. From a unit-test bundle the
//      XCUIApplication launch can succeed but AX driving is unsupported
//      and frequently no-ops.
//   b) Even with a UI-test target, on the dev Mac the test process
//      needs Accessibility (AX) granted in System Settings → Privacy &
//      Security → Accessibility. That's a manual user step.
//
// On the iMac (Big Sur, the actual deploy target where the crash
// reproduces), once a UI-test target is added and the binary is
// AX-granted once, this test becomes a permanent regression lock.
// Accessibility identifiers wired below now match the buttons on
// ChapterListView, ChapterDetailView (Discover banner), and the
// Beyond-the-Book card in ChapterDetailView — see commits f4ec573
// and the current commit.

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
