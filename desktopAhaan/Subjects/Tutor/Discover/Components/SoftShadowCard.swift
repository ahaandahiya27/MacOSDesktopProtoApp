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
                    .strokeBorder(.black.opacity(0.05), lineWidth: 0.5)
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
struct GotItButton: View {
    var label: String = "I get it!"
    var systemImage: String = "checkmark.seal.fill"
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Label(label, systemImage: systemImage)
                .font(.title3.bold())
                .padding(.horizontal, 22)
                .padding(.vertical, 12)
        }
        .buttonStyle(.bordered)
        .accentColor(.green)
        .keyboardShortcut(.space, modifiers: [])
        .accessibilityHint("Marks this scene as complete and moves on.")
    }
}
