import XCTest
@testable import desktopAhaan

/// Pure-policy tests on `clampWindowIdeal(design:visible:)`. The
/// function is the testable seam under
/// `SanskritKoshApp.firstLaunchFrame`; an NSScreen value is supplied
/// at call time in production, the tests pass synthetic sizes.
final class WindowClampTests: XCTestCase {

    private let design = CGSize(width: 2200, height: 1380)

    func testNoScreenReturnsDesignUnchanged() {
        // Headless test run on CI / no display: the function must
        // not crash; returning the design size is the right
        // fallback because there's no display constraint to honour.
        let result = clampWindowIdeal(design: design, visible: nil)
        XCTAssertEqual(result, design)
    }

    func testFiveKImacFitsWithoutClamp() {
        // 5K iMac at 2560×1440 logical, visibleFrame ~ 2560×1417
        // (menubar takes ~23pt). Design 2200×1380 fits inside both
        // dimensions, so the window opens at the design ideal.
        let visible = CGSize(width: 2560, height: 1417)
        let result = clampWindowIdeal(design: design, visible: visible)
        XCTAssertEqual(result, design)
    }

    func testThirteenInchMBPClampsToEightyFivePercent() {
        // 13" MBP at 1440×900 logical, visibleFrame ~ 1440×841.
        // Design exceeds visible in both axes; clamp returns 85%
        // of visible.
        let visible = CGSize(width: 1440, height: 841)
        let result = clampWindowIdeal(design: design, visible: visible)
        XCTAssertEqual(result.width,  visible.width  * 0.85, accuracy: 0.01)
        XCTAssertEqual(result.height, visible.height * 0.85, accuracy: 0.01)
    }

    func testHeightOverflowOnlyStillClampsBothDimensions() {
        // A wide-but-short display (e.g. an external monitor in
        // portrait orientation with a tall taskbar carve-out). Even
        // if the design width fits, height overflow trips the clamp
        // and both axes scale together — keeps the aspect-ratio of
        // the visible area, not the design.
        let visible = CGSize(width: 3000, height: 1000)
        let result = clampWindowIdeal(design: design, visible: visible)
        XCTAssertEqual(result.width,  3000 * 0.85, accuracy: 0.01)
        XCTAssertEqual(result.height, 1000 * 0.85, accuracy: 0.01)
    }

    func testWidthOverflowOnlyAlsoClamps() {
        // Mirror of the previous case — narrow-and-tall display.
        let visible = CGSize(width: 800, height: 2000)
        let result = clampWindowIdeal(design: design, visible: visible)
        XCTAssertEqual(result.width,  800  * 0.85, accuracy: 0.01)
        XCTAssertEqual(result.height, 2000 * 0.85, accuracy: 0.01)
    }

    func testCustomComfortableFractionOverride() {
        let visible = CGSize(width: 1440, height: 841)
        let result = clampWindowIdeal(
            design: design,
            visible: visible,
            comfortableFraction: 0.90
        )
        XCTAssertEqual(result.width,  1440 * 0.90, accuracy: 0.01)
        XCTAssertEqual(result.height, 841  * 0.90, accuracy: 0.01)
    }
}
