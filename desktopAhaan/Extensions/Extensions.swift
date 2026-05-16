import SwiftUI
import AppKit

extension Notification.Name {
    static let openImageCommand = Notification.Name("openImageCommand")
    static let copyTranslationCommand = Notification.Name("copyTranslationCommand")
    static let speakResultCommand = Notification.Name("speakResultCommand")
    static let translateCommand = Notification.Name("translateCommand")
    static let navigateBackCommand = Notification.Name("navigateBackCommand")
}

// MARK: - Color extensions for Devanagari-friendly theming
extension Color {
    static var compatIndigo: Color {
        if #available(macOS 12, *) {
            return .indigo
        } else {
            return Color(red: 0.35, green: 0.34, blue: 0.84)
        }
    }

    static var compatTeal: Color {
        if #available(macOS 12, *) {
            return .teal
        } else {
            return Color(red: 0.19, green: 0.69, blue: 0.78)
        }
    }

    static var compatCyan: Color {
        if #available(macOS 12, *) {
            return .cyan
        } else {
            return Color(red: 0.0, green: 0.75, blue: 0.95)
        }
    }

    static var compatMint: Color {
        if #available(macOS 12, *) {
            return .mint
        } else {
            return Color(red: 0.0, green: 0.78, blue: 0.74)
        }
    }

    static var sanskritPrimary: Color { compatIndigo }
    static let sanskritAccent = Color.orange
    static let sanskritBackground = Color(NSColor.windowBackgroundColor)
}

// MARK: - Design tokens

enum DesignTokens {
    static let cornerRadiusSmall: CGFloat = 8
    static let cornerRadiusMedium: CGFloat = 10
    static let cornerRadiusCard: CGFloat = 14
    static let cornerRadiusLarge: CGFloat = 16

    static let spacingTight: CGFloat = 8
    static let spacingMedium: CGFloat = 12
    static let spacingRelaxed: CGFloat = 16
    static let spacingWide: CGFloat = 24
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

    func onArrowKeys(left: @escaping () -> Void, right: @escaping () -> Void) -> some View {
        modifier(ArrowKeyModifier(onLeft: left, onRight: right))
    }
}

// MARK: - Date formatting (replaces FormatStyle which requires macOS 12+)

func formattedCurrentDate() -> String {
    let f = DateFormatter()
    f.dateStyle = .medium
    return f.string(from: Date())
}

// MARK: - SwiftUI view → NSImage (replaces ImageRenderer which requires macOS 13+)

func renderViewToImage<V: View>(_ view: V, size: CGSize) -> NSImage? {
    let hosting = NSHostingView(rootView: view)
    hosting.frame = CGRect(origin: .zero, size: size)
    guard let bitmap = hosting.bitmapImageRepForCachingDisplay(in: hosting.bounds) else {
        return nil
    }
    hosting.cacheDisplay(in: hosting.bounds, to: bitmap)
    let image = NSImage(size: size)
    image.addRepresentation(bitmap)
    return image
}

// MARK: - Arrow key handling (replaces .onKeyPress which requires macOS 14+)

private struct ArrowKeyModifier: ViewModifier {
    let onLeft: () -> Void
    let onRight: () -> Void
    @State private var monitor: Any?

    func body(content: Content) -> some View {
        content
            .onAppear {
                monitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
                    if let responder = NSApp.keyWindow?.firstResponder,
                       responder is NSTextView {
                        return event
                    }
                    if event.keyCode == 123 {
                        onLeft()
                        return nil
                    } else if event.keyCode == 124 {
                        onRight()
                        return nil
                    }
                    return event
                }
            }
            .onDisappear {
                if let m = monitor {
                    NSEvent.removeMonitor(m)
                    monitor = nil
                }
            }
    }
}
