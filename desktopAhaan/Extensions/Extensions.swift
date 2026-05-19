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

    /// Set to true after the student dismisses the "all 19 Discover
    /// chapters complete" celebration overlay (DM7/EM4). Prevents the
    /// overlay from reappearing on every launch once seen.
    static let hasSeenAllChaptersCelebration = "hasSeenAllChaptersCelebration"

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
        case "frying.pan.fill":            return "flame.fill"  // was "fork.knife" — also SF Symbols 3+, cascaded warning on Big Sur
        case "fork.knife":                 return "flame.fill"  // SF Symbols 3+ — added 2026-05-17 after iMac runtime warning
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
        // --- Round 2 audit (Big Sur compile-and-run sweep) ---
        case "metronome":                  return "clock.fill"
        case "barometer":                  return "thermometer"
        case "bubbles.and.sparkles":       return "sparkles"
        case "flag.checkered":             return "flag.fill"
        case "drop.degreesign":            return "drop.fill"
        case "testtube.2":                 return "drop.fill"
        case "tree.fill":                  return "leaf.fill"
        case "nose.fill":                  return "face.smiling"
        case "lungs.fill":                 return "wind"
        case "gauge.medium":               return "gauge"
        case "internaldrive":              return "externaldrive"
        case "wave.3.right":               return "wifi"
        case "hand.draw.fill":             return "hand.point.up.fill"
        case "character.book.closed":      return "book.closed"
        case "leaf.arrow.triangle.circlepath": return "leaf.fill"
        case "hare.fill":                  return "tortoise"
        case "figure.2.and.child.holdinghands": return "person.2.fill"  // SF Symbols 4+ — added 2026-05-17 after iMac runtime warning
        case "pencil.and.ruler.fill":      return "pencil"              // SF Symbols 3+ — added 2026-05-17 after iMac runtime warning
        case "figure.run":                 return "figure.walk"         // SF Symbols 3+ — defensive add 2026-05-17 (figure.walk is SF Symbols 1)
        case "gearshape.2":                return "gearshape.fill"      // SF Symbols 3+ — defensive add 2026-05-17
        case "arrowshape.down.fill":       return "arrow.down.circle.fill" // SF Symbols 3+ — added 2026-05-18 after iMac runtime warning
        case "humidity.fill":              return "drop.fill"              // SF Symbols 4+ — added 2026-05-19 (Ch.7 Scene 2 weather station)
        case "circle.inset.filled":        return "circle.fill"            // SF Symbols 4+ — added 2026-05-19 (Ch.7 Scene 4 polar bear)
        case "diamond.fill":               return "suit.diamond.fill"      // SF Symbols 3+ — added 2026-05-19 (Ch.15 Scene 8 kaleidoscope)
        case "rainbow":                    return "sparkles"               // SF Symbols 4+ — added 2026-05-19 (Ch.15 Scene 4 prism)
        case "powerplug":                  return "bolt.fill"              // SF Symbols 4+ — added 2026-05-19 (Ch.14 Scene 6 electromagnet)
        case "chart.line.uptrend.xyaxis":  return "chart.bar.fill"         // SF Symbols 3+ — added 2026-05-19 (Ch.13 Scene 3 distance-time graph)
        case "sun.and.horizon.fill":       return "sunrise.fill"           // SF Symbols 3+ — added 2026-05-19 (Ch.19 Scene 5 spring/neap tides)
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

    // MARK: - Structured token namespaces (phase 2 of visual sweep)
    //
    // The flat constants above stay as-is for source-compatibility with the
    // 100+ existing call sites. New code should prefer these structured
    // namespaces — they make intent legible (`Spacing.md` over the magic
    // number `12`) and give phases 3 / 5 / 6 a single place to refine values
    // (e.g., Phase 3 will swap BrandColor hues to WCAG-measured pairs).
    //
    // Phase 2 only adds primitives — no call-site migration happens here.

    /// Spacing scale used for padding, stack spacing, gutters.
    /// Aliases the existing `spacing*` constants where applicable so a future
    /// migration can be a mechanical find-replace.
    enum Spacing {
        static let xxs: CGFloat = 2
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8     // = spacingTight
        static let md: CGFloat = 12    // = spacingMedium
        static let lg: CGFloat = 16    // = spacingRelaxed
        static let xl: CGFloat = 24    // = spacingWide
        static let xxl: CGFloat = 32
        static let xxxl: CGFloat = 48
    }

    /// Corner radii — names mirror Spacing's scale so a `md` radius pairs
    /// visually with `md` spacing without a lookup table.
    enum Radius {
        static let pill: CGFloat = 999
        static let sm: CGFloat = 8     // = cornerRadiusSmall
        static let md: CGFloat = 10    // = cornerRadiusMedium
        static let card: CGFloat = 14  // = cornerRadiusCard
        static let lg: CGFloat = 16    // = cornerRadiusLarge
        static let xl: CGFloat = 22
    }

    /// Semantic font roles. Today these all wrap stock SwiftUI Fonts; the
    /// indirection exists so Phase 6 can swap (e.g.) `pageTitle` to a
    /// larger size on 5K canvases (TY1 in the Z taxonomy) without
    /// touching every call site.
    ///
    /// macOS 11 baseline only — `.title2` / `.title3` (macOS 11+),
    /// `.bold()` / `.weight(...)` (macOS 10.15+), `Font.system(_:design:)`
    /// (macOS 10.15+). No `.foregroundStyle`, no `.monospaced()` modifier.
    enum Typography {
        /// Largest heading — reserved for hero / first-launch screens.
        static let heroTitle: Font = .system(size: 48, weight: .bold)
        /// Per-scene page title (was inline `.largeTitle.bold()` in scenes).
        static let pageTitle: Font = .largeTitle.bold()
        /// Section heading in the DiscoverShell header (`Phase 1` introduced).
        static let sectionTitle: Font = .title2.bold()
        /// Card / callout / panel heading.
        static let cardTitle: Font = .title3.bold()
        /// Inline section header (above paragraphs / inside cards).
        static let sectionHeader: Font = Font.headline
        /// Emphasised inline body text.
        static let bodyEmphasis: Font = Font.body.weight(.semibold)
        /// Default reading body.
        static let body: Font = Font.body
        /// Long-form callout body — looser than `.body` for paragraph reads.
        static let bodyRelaxed: Font = Font.callout
        /// Counters, badges, "Scene 3 of 9" — semibold caption.
        static let metaCaption: Font = Font.caption.weight(.medium)
        /// Tiny tertiary meta — timestamps, tooltips.
        static let microCaption: Font = Font.caption2
        /// Monospaced inline (mnemonic per-letter rows).
        static let mono: Font = .system(.callout, design: .monospaced)
        /// Monospaced display (mnemonic hook word).
        static let monoBold: Font = .system(.title2, design: .monospaced).weight(.bold)

        // Line-height (`.lineSpacing`) constants paired with the Font roles.
        // Apply via `Text(...).lineSpacing(DesignTokens.Typography.bodyLineSpacing)`.
        // Existing scenes/cards used a mix of 3 / 4 / no `lineSpacing`; these
        // formalise the rhythm for the Phase 6 typography pass.
        static let tightLineSpacing: CGFloat = 1   // captions, single-line meta
        static let bodyLineSpacing: CGFloat = 3    // default reading body
        static let looseLineSpacing: CGFloat = 5   // long-form / callout body
    }

    /// Semantic colour roles. The defaults today match what the components
    /// already use (purple = LookingAhead, orange = TryAtHome, yellow =
    /// Mnemonic, teal = RelatedConcepts, green = primary CTA / completed).
    /// Phase 3 will replace these with WCAG-measured pairs that work on
    /// the Discover gradient canvas in both Light and Dark mode.
    ///
    /// Direct system colours (`.purple` / `.orange` / `.yellow` / `.green`)
    /// are macOS 10.15 baseline. `Color.compatTeal` lives in this file too
    /// (further down) as a Big-Sur-safe fallback for system `.teal`.
    enum BrandColor {
        // Discover-Mode callout tints — semantic names, not hue names.
        static let lookingAhead: Color = .purple
        static let tryAtHome: Color = .orange
        static let mnemonic: Color = .yellow
        static let mnemonicAccent: Color = .orange
        static let relatedConcepts: Color = Color.compatTeal

        // Action / state.
        static let primaryAction: Color = .green
        static let success: Color = .green
        static let danger: Color = .red
        static let warning: Color = .orange

        // Neutral surfaces.
        static let mutedSurface: Color = Color.gray.opacity(0.25)
        static let dividerLine: Color = Color.primary.opacity(0.08)

        // Fixed text colours for the always-light Discover canvas.
        // The `DiscoverBackground` gradient is intentionally sunshine-themed
        // regardless of system colour scheme, so on-canvas body text must
        // NOT follow `.primary` (which renders white in system Dark Mode →
        // invisible on the light canvas). Pin these to RGB values that
        // sit at AA contrast on the pale-blue/pale-green gradient.
        //
        // Hue chosen as a soft near-black (Material Design slate ~#212121)
        // — strong contrast without the harshness of pure black.
        static let canvasText: Color = Color(red: 0.13, green: 0.13, blue: 0.13)
        /// Secondary on-canvas text — captions, meta, "Animals: …" subhead.
        static let canvasTextSecondary: Color = Color(red: 0.36, green: 0.38, blue: 0.42)
    }
}

// MARK: - Monospaced-digit fonts (Big-Sur-safe)

extension Font {
    /// Big-Sur-safe monospaced-digit caption font for counters that change in
    /// real time ("Scene N of M · X done", score readouts, badge numbers).
    /// SwiftUI's `.monospacedDigit()` modifier on Font is macOS 12+; this
    /// builds the same effect via AppKit's `NSFont.monospacedDigitSystemFont`
    /// which has shipped since macOS 10.7, so digit columns stay aligned as
    /// the number changes — no jitter as widths shift between `1` and `8`.
    static var monoDigitCaption: Font {
        Font(NSFont.monospacedDigitSystemFont(
            ofSize: NSFont.smallSystemFontSize,
            weight: .medium
        ))
    }
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
    /// Solid-white pill chrome for on-canvas controls (segmented Pickers,
    /// Menus, Toggles) in Discover Mode. The native macOS rendering of
    /// these controls uses a translucent background that disappears
    /// against the pale Discover gradient — the kid sees "ghost" labels
    /// floating on the canvas. This modifier gives every control an
    /// opaque card so the labels always pop, regardless of system
    /// appearance or chapter accent hue.
    func discoverControlChrome() -> some View {
        self
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white.opacity(0.95))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .strokeBorder(Color.black.opacity(0.12), lineWidth: 0.5)
                    )
            )
    }

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

// MARK: - Pointing-hand cursor on hover

extension View {
    /// Switches the mouse cursor to a pointing-hand while hovering this view.
    /// SwiftUI's `Button` on macOS keeps the default arrow cursor — fine for
    /// adults but Ahaan (7) relies on the cursor change as a primary
    /// clickability signal. Apply on Discover-Mode chrome buttons + any other
    /// custom-built tappables.
    ///
    /// macOS 11 compatible — `.onHover` is macOS 11+, `NSCursor` is in AppKit.
    /// Uses push/pop so nested hovers don't leave a sticky cursor.
    func pointingCursor() -> some View {
        onHover { hovering in
            if hovering {
                NSCursor.pointingHand.push()
            } else {
                NSCursor.pop()
            }
        }
    }
}
