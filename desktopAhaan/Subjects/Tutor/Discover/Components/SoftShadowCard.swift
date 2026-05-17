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
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(Color(NSColor.windowBackgroundColor))
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(Color.primary.opacity(0.08), lineWidth: 0.5)
            )
            .shadow(color: .black.opacity(0.08), radius: 14, x: 0, y: 6)
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
struct GotItButton: View {
    var label: String = "I get it!"
    var systemImage: String = "checkmark.seal.fill"
    var tint: Color = .green
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Label(label, systemImage: systemImage)
                .font(.title3.bold())
                .padding(.horizontal, 28)
                .padding(.vertical, 14)
        }
        .buttonStyle(FilledCTAButtonStyle(tint: tint))
        .keyboardShortcut(.space, modifiers: [])
        .accessibilityHint("Marks this scene as complete and moves on.")
    }
}

/// Filled primary-action button style. Big-Sur-safe substitute for the
/// macOS 12 `.borderedProminent` style. Carries a soft accent-tinted shadow
/// to anchor the CTA against the Discover gradient background, a clear
/// disabled state, and a press-feedback scale + overlay so taps register.
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
