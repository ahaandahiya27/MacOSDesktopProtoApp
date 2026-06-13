import SwiftUI

// MARK: - Reduce-Motion helpers
//
// The codebase has ~120 hand-rolled `@Environment(\.accessibilityReduceMotion)`
// + `reduceMotion ? .none : .easeOut(...)` patterns scattered across the
// Discover scenes. Centralised here so:
//
//   1. A future Big Sur quirk in the reduce-motion environment value
//      can be patched in one place instead of 120.
//   2. New scenes can use one of the two helpers below and not forget
//      the gate.
//
// Two surfaces:
//
//   - `withAnimationRespectingReduceMotion(_:body:)` — the imperative
//     wrapper around SwiftUI's `withAnimation(_:body:)`. Reads the
//     accessibility environment via NSApp's reduce-motion preference
//     (works without an @Environment because it's the AppKit-side
//     source of truth).
//
//   - `.respectReduceMotion(animation:)` — the declarative view
//     modifier. Use on a view whose modifier chain includes implicit
//     `.animation(_:)`. The modifier replaces the supplied animation
//     with `nil` (i.e. instant transition) when reduce-motion is on.
//
// Audit Top-10 #7 (added 2026-05-22). Migration is opportunistic:
// touch a scene → swap the hand-roll for one of these helpers.
import AppKit

/// Run `body` inside `withAnimation`, but skip the animation entirely
/// when the system's Reduce Motion preference is on. Reads the
/// AppKit-side `NSWorkspace.shared.accessibilityDisplayShouldReduceMotion`
/// flag which mirrors the SwiftUI environment value — same source of
/// truth, no need for an `@Environment` capture.
//
// Intentionally NOT `@MainActor`-isolated. Big Sur / Xcode 13.2.1 /
// Swift 5.5 rejects calling a `@MainActor` global function from a
// View's instance method (which is `nonisolated` under Swift 5.5 —
// the implicit-MainActor inference for View bodies arrived later).
// The function only reads NSWorkspace.shared (thread-safe accessor)
// and forwards to `withAnimation` (no actor enforcement on Big Sur).
// All call sites are SwiftUI view code that runs on main at runtime.
internal func withAnimationRespectingReduceMotion<Result>(
    _ animation: Animation? = .default,
    _ body: () throws -> Result
) rethrows -> Result {
    if NSWorkspace.shared.accessibilityDisplayShouldReduceMotion {
        return try body()  // no animation
    }
    return try withAnimation(animation, body)
}

extension View {
    /// Apply the supplied implicit `.animation(_:)` modifier ONLY when
    /// Reduce Motion is off. Matches the manual pattern most scenes use:
    ///
    ///     .animation(reduceMotion ? nil : .easeInOut(duration: 0.2))
    ///
    /// New code should prefer:
    ///
    ///     .respectReduceMotion(animation: .easeInOut(duration: 0.2))
    ///
    /// Reads the AppKit-side reduce-motion flag — same source of truth
    /// as SwiftUI's `@Environment(\.accessibilityReduceMotion)`.
    func respectReduceMotion(animation: Animation) -> some View {
        let reduce = NSWorkspace.shared.accessibilityDisplayShouldReduceMotion
        return self.animation(reduce ? nil : animation)
    }
}
