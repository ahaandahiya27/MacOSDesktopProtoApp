import CoreGraphics
import Foundation

// MARK: - First-launch window clamp
//
// Pure function so the policy is unit-testable without spinning up an
// NSScreen / app target. `visible` is `NSScreen.main?.visibleFrame.size`
// at call time; pass nil to model the "no screen attached" path (e.g.
// during headless test runs). Returns the design size unchanged when
// both dimensions fit; otherwise scales to `comfortableFraction` of the
// visible area so the window has off-edge breathing room.
//
// `comfortableFraction = 0.85` per the POLISH_TODOS guidance — at 0.95
// the window opened uncomfortably close to the screen edges on a 13"
// MBP; at 0.85 it lands with ~7.5% margin on each side.
//
// Lived in `desktopAhaanApp.swift` until 2026-06-18, when the Help menu
// grew past the 600-LOC sister-file ceiling and this small pure helper
// became the natural seam to lift. `WindowClampTests` already covers
// the behaviour — that file targets this symbol directly.
func clampWindowIdeal(
    design: CGSize,
    visible: CGSize?,
    comfortableFraction: CGFloat = 0.85
) -> CGSize {
    guard let visible = visible else { return design }
    let fits = design.width <= visible.width && design.height <= visible.height
    if fits { return design }
    return CGSize(
        width: visible.width * comfortableFraction,
        height: visible.height * comfortableFraction
    )
}
