import SwiftUI
import AppKit

extension Notification.Name {
    static let openImageCommand = Notification.Name("openImageCommand")
    static let copyTranslationCommand = Notification.Name("copyTranslationCommand")
    static let speakResultCommand = Notification.Name("speakResultCommand")
    static let translateCommand = Notification.Name("translateCommand")
}

// MARK: - Color extensions for Devanagari-friendly theming
extension Color {
    static let sanskritPrimary = Color.indigo
    static let sanskritAccent = Color.orange
    static let sanskritBackground = Color(nsColor: .windowBackgroundColor)
}

// MARK: - View modifier for Devanagari text
struct DevanagariFont: ViewModifier {
    let size: CGFloat

    func body(content: Content) -> some View {
        content
            .font(.system(size: size))
            .environment(\.locale, Locale(identifier: "sa"))
    }
}

extension View {
    func devanagariFont(size: CGFloat = 17) -> some View {
        modifier(DevanagariFont(size: size))
    }
}
