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

    static var compatBrown: Color {
        if #available(macOS 12, *) {
            return .brown
        } else {
            return Color(red: 0.6, green: 0.42, blue: 0.25)
        }
    }

    static var sanskritPrimary: Color { compatIndigo }
    static let sanskritAccent = Color.orange
    static let sanskritBackground = Color(NSColor.windowBackgroundColor)
}

// MARK: - AppStorage keys

/// Central registry for every `@AppStorage` key the app uses. Routing every
/// key through this enum prevents typo-driven progress loss across the eight
/// Discover chapter dispatchers (a single misspelled key silently forks a
/// fresh cursor on next launch).
enum AppStorageKeys {
    /// One-time first-launch welcome overlay dismissal flag.
    static let hasSeenWelcome = "hasSeenWelcome"

    /// Per-chapter Discover Mode scene cursor (0-indexed). `chapterNumber`
    /// is the integer chapter number (1, 2, ..., 19 in the current pack).
    static func discoverScene(_ chapterNumber: Int) -> String {
        String(format: "discover_scene_ch%02d", chapterNumber)
    }
}

// MARK: - SF Symbols backfill for Big Sur

/// Big Sur ships SF Symbols 2.0. Symbols introduced in SF Symbols 3 (macOS 12)
/// or 4 (macOS 13) render as missing glyphs on macOS 11. Call sites pass the
/// modern symbol name; on macOS 12+ this is returned unchanged, on Big Sur the
/// closest SF Symbols 1/2 equivalent is substituted.
enum SFSymbolCompat {
    static func name(_ modern: String) -> String {
        if #available(macOS 12, *) {
            return modern
        }
        switch modern {
        case "bird.fill":                  return "pawprint.fill"
        case "flask.fill":                 return "drop.fill"
        case "mouth.fill":                 return "sparkles"
        case "frying.pan.fill":            return "fork.knife"
        case "globe.europe.africa.fill":   return "globe"
        case "globe.americas.fill":        return "globe"
        case "hand.raised.fingers.spread": return "hand.raised.fill"
        case "hand.tap.fill":              return "hand.point.up.left.fill"
        case "hand.tap":                   return "hand.point.up.left"
        case "leaf.arrow.circlepath":      return "leaf.fill"
        case "thermometer.medium":         return "thermometer"
        case "thermometer.high":           return "thermometer"
        case "shield.lefthalf.filled":     return "shield.fill"
        case "water.waves":                return "drop.fill"
        case "list.bullet.clipboard.fill": return "list.bullet"
        default:                           return modern
        }
    }
}

// MARK: - Hardware tier for the 2014 iMac target

/// Picks animation budgets that work on a Late-2014 iMac (AMD R9 M290X 2 GB).
/// On macOS 11 we assume we're on that hardware and halve particle / frame
/// rate budgets. On modern macOS we keep the rich animations.
enum HardwareTier {
    static var isLegacy: Bool {
        if #available(macOS 12, *) { return false }
        return true
    }
    static var particleBudget: Int { isLegacy ? 40 : 80 }
    static var animationFPS: Double { isLegacy ? 20 : 30 }
    static var animationInterval: TimeInterval { 1.0 / animationFPS }

    /// Returns the slower of `ideal` and the legacy interval, so a scene that
    /// asks for 30 fps gets capped at 20 fps on the 2014 iMac, while a scene
    /// that already runs at 15 fps stays at 15 fps everywhere.
    static func interval(ideal: TimeInterval) -> TimeInterval {
        isLegacy ? max(ideal, animationInterval) : ideal
    }
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

    /// Cap for text-heavy reading panels (concept explanations, question
    /// prompts). Sized so a 27" 5K iMac canvas (logical ~2560pt wide minus
    /// ~280pt sidebar) is mostly filled without violating a comfortable
    /// 80-character line length on body text.
    static let contentMaxWidth: CGFloat = 1100

    /// Cap for chapter/topic lists where the cards have richer horizontal
    /// content (icons + meta + chevrons) and can use more canvas.
    static let contentMaxWidthWide: CGFloat = 1280
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

/// Sets the Sanskrit locale on text when the active subject pack id starts
/// with `sanskrit_`, so the system picks Devanagari-tuned glyph metrics.
/// Does not override `.font(...)` on the wrapped view.
struct DevanagariAwareFont: ViewModifier {
    let packId: String

    func body(content: Content) -> some View {
        if packId.hasPrefix("sanskrit_") {
            content.environment(\.locale, Locale(identifier: "sa"))
        } else {
            content
        }
    }
}

extension View {
    func devanagariFont(size: CGFloat = 17) -> some View {
        modifier(DevanagariFont(size: size))
    }

    /// Applies a Sanskrit (Devanagari) text locale only when the active pack
    /// is the Sanskrit one. Lets the surrounding `.font(...)` size win while
    /// nudging the system to use Devanagari-tuned glyph metrics on macOS.
    func devanagariAwareLocale(packId: String) -> some View {
        modifier(DevanagariAwareFont(packId: packId))
    }

    func onArrowKeys(left: @escaping () -> Void, right: @escaping () -> Void) -> some View {
        modifier(ArrowKeyModifier(onLeft: left, onRight: right))
    }

    /// Pauses a Timer-driven scene when the SwiftUI scene phase leaves
    /// `.active` (app backgrounded), and resumes when it comes back. Pair
    /// with `startAnimation` / `stopAnimation` helpers that guard against
    /// double-starts. Saves GPU/CPU on the 2014 iMac when the user tabs away.
    func pauseTimerWhenBackgrounded(start: @escaping () -> Void,
                                    stop: @escaping () -> Void) -> some View {
        modifier(ScenePhasePauseModifier(start: start, stop: stop))
    }

    /// One-line replacement for the ~20-line `@State tick` /
    /// `@State animationTimer` / `startAnimation` / `stopAnimation` /
    /// `.onAppear` / `.onDisappear` / `.pauseTimerWhenBackgrounded` boilerplate
    /// that every Timer-driven Discover scene used to inline. Pass an `idealFPS`
    /// (`HardwareTier.interval` is applied so Big Sur gets the legacy floor)
    /// and a `Binding<TimeInterval>` for the scene's tick. Respects
    /// reduce-motion (no timer is created) and pauses on app background.
    func timedScene(idealFPS: Double = 30, tick: Binding<TimeInterval>) -> some View {
        modifier(TimedSceneModifier(idealFPS: idealFPS, tick: tick))
    }
}

private struct ScenePhasePauseModifier: ViewModifier {
    let start: () -> Void
    let stop: () -> Void
    @Environment(\.scenePhase) private var scenePhase

    func body(content: Content) -> some View {
        content.onChange(of: scenePhase) { phase in
            if phase == .active { start() } else { stop() }
        }
    }
}

/// Owns the timer lifecycle for a `timedScene(idealFPS:tick:)` call. Honors
/// reduce-motion (no timer is created), pauses on app backgrounding, and
/// invalidates the timer on view disappear.
private struct TimedSceneModifier: ViewModifier {
    let idealFPS: Double
    @Binding var tick: TimeInterval
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.scenePhase) private var scenePhase
    @State private var animationTimer: Timer? = nil
    @State private var startDate = Date()

    func body(content: Content) -> some View {
        content
            .onAppear { start() }
            .onDisappear { stop() }
            .onChange(of: scenePhase) { phase in
                if phase == .active { start() } else { stop() }
            }
    }

    private func start() {
        guard !reduceMotion, animationTimer == nil else { return }
        startDate = Date()
        let interval = HardwareTier.interval(ideal: 1.0 / idealFPS)
        animationTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            tick = Date().timeIntervalSince(startDate)
        }
    }

    private func stop() {
        animationTimer?.invalidate()
        animationTimer = nil
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
