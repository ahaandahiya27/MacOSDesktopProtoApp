import SwiftUI

/// White surface, 16pt corner radius, soft drop shadow. Reused everywhere in
/// Discover Mode so cards have one consistent look.
struct SoftShadowCard<Content: View>: View {
    var padding: CGFloat = 20
    var cornerRadius: CGFloat = DesignTokens.cornerRadiusLarge
    @ViewBuilder var content: () -> Content

    var body: some View {
        content()
            .padding(padding)
            // Fixed-light fill (not Color(NSColor.windowBackgroundColor),
            // which adapts to dark mode and turns this card into a dark
            // slab on the still-pale Discover canvas — the visible
            // "camouflage" symptom the kid sees on the iMac). The canvas
            // is locked-light by design, so the cards on it must be too.
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(Color.white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(Color.black.opacity(0.10), lineWidth: 0.5)
            )
            .shadow(color: .black.opacity(0.10), radius: 14, x: 0, y: 6)
            // Force any inherited `.foregroundColor(.primary)` inside the
            // card to read as a fixed-light token, so dark-mode users
            // don't get white text on a now-white card.
            .foregroundColor(DesignTokens.BrandColor.canvasText)
    }
}

/// The standard sky-to-grass background gradient used by every Discover scene.
struct DiscoverBackground: View {
    var body: some View {
        LinearGradient(
            colors: [
                Color(red: 0.88, green: 0.95, blue: 1.0),
                Color(red: 0.96, green: 1.0, blue: 0.92),
                Color(red: 0.85, green: 0.95, blue: 0.78)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
}

/// Standard "I get it!" button used at the bottom of each scene to mark
/// completion. Calls back to the parent driver.
///
/// Uses `FilledCTAButtonStyle` instead of `.bordered` so the primary action
/// reads as a primary action on the 5K iMac canvas — `.bordered` rendered
/// almost invisibly against the pale Discover gradient. macOS 12+ would have
/// `.borderedProminent`; we recreate it manually for Big Sur compatibility.
///
/// `tint` priority: explicit param > environment `\.chapterAccent` (set by
/// `DiscoverShell`) > fallback `.green`. So 152 existing `GotItButton(action:)`
/// call-sites in scene files pick up their chapter's accent colour
/// automatically inside Discover Mode (DM6) without per-file edits.
///
/// **Canonical call form** (CP8) — prefer the named-param style:
///
///     GotItButton(action: onComplete)
///
/// Trailing-closure form `GotItButton { onComplete() }` also compiles
/// (single-closure-param), but the named form keeps grep / refactor
/// rename safety because `action:` shows up as a stable token rather
/// than a bare `{`. Existing scene files mix both — leave as-is until a
/// future content pass.
struct GotItButton: View {
    var label: String = "I get it!"
    var systemImage: String = "checkmark.seal.fill"
    var tint: Color? = nil
    var action: () -> Void

    @Environment(\.chapterAccent) private var envChapterAccent
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var celebrating: Bool = false

    var body: some View {
        Button(action: handleTap) {
            Label(label, systemImage: systemImage)
                .font(.title3.bold())
                .padding(.horizontal, 28)
                .padding(.vertical, 14)
                // Celebration scale-pop (MO3) — brief outward bounce after
                // the press-state compression of `FilledCTAButtonStyle`, so
                // the tap reads as "click! pop! done!" before the scene
                // transitions. Suppressed when Reduce Motion is on.
                .scaleEffect(celebrating ? 1.12 : 1.0)
                .animation(reduceMotion ? nil : .spring(response: 0.32, dampingFraction: 0.55),
                           value: celebrating)
        }
        .buttonStyle(FilledCTAButtonStyle(tint: tint ?? envChapterAccent))
        .keyboardShortcut(.space, modifiers: [])
        .pointingCursor()
        .accessibilityHint("Marks this scene as complete and moves on.")
    }

    private func handleTap() {
        // Reduce-Motion users skip the celebration delay entirely.
        if reduceMotion {
            action()
            return
        }
        // Debounce repeated taps during the celebration window.
        guard !celebrating else { return }
        celebrating = true
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 350_000_000)
            celebrating = false
            action()
        }
    }
}

// MARK: - Chapter-accent environment

private struct ChapterAccentKey: EnvironmentKey {
    /// Default outside `DiscoverShell` — keeps `GotItButton` green when used
    /// off-Discover (e.g., a future modal CTA). `DiscoverShell` overrides
    /// this with the chapter's `ChapterTheme.accent(for:)` colour.
    static let defaultValue: Color = .green
}

extension EnvironmentValues {
    var chapterAccent: Color {
        get { self[ChapterAccentKey.self] }
        set { self[ChapterAccentKey.self] = newValue }
    }
}

/// Press-feedback button style with no chrome — equivalent to
/// `.buttonStyle(.plain)` plus a brief inward scale on press. Designed for
/// small custom tappables (stepper dots, badges, chips) where the absence of
/// a default press visual makes the click feel unresponsive. Honours
/// Reduce Motion (no scale when the env value is on).
///
/// macOS 10.15+ compatible — `@Environment(\.accessibilityReduceMotion)`
/// available since iOS 13 / macOS 10.15.
struct PressableButtonStyle: ButtonStyle {
    var pressedScale: CGFloat = 0.85
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed && !reduceMotion ? pressedScale : 1.0)
            .animation(reduceMotion ? nil : .spring(response: 0.25, dampingFraction: 0.6),
                       value: configuration.isPressed)
    }
}

/// **The** primary-action button style for Discover Mode and beyond. Pair with
/// a tappable `Button`, never a passive `Label`. Use this for: scene completion
/// ("I get it!"), modal confirmations, "Start Quiz", "Submit" actions. For
/// secondary actions (Prev/Next, Cancel) keep using system `.bordered` or
/// `.automatic`. For destructive actions, override `tint` to `.red`.
///
/// Big-Sur-safe substitute for the macOS 12 `.borderedProminent` style.
/// Carries a soft accent-tinted shadow to anchor the CTA against the Discover
/// gradient background, a clear disabled state (0.42 opacity), and a
/// press-feedback scale + overlay so taps register visually.
private struct FilledCTAButtonStyle: ButtonStyle {
    let tint: Color
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(tint)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.white.opacity(configuration.isPressed ? 0.18 : 0))
            )
            .shadow(color: tint.opacity(isEnabled ? 0.35 : 0), radius: 8, x: 0, y: 4)
            .opacity(isEnabled ? 1.0 : 0.42)
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}
