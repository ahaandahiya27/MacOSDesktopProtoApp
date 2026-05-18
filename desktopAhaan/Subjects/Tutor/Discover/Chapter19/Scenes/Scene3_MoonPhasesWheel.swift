import SwiftUI

/// Scene 3 — Moon Phases Wheel.
/// Eight moon phase cards in a 2x4 grid. Each card shows a Shape-drawn moon and
/// phase name. Tap to see explanation. After all 8 explored, Got It appears.
///
/// Big Sur (macOS 11) compatible: the moon glyph is rendered via a custom
/// `Shape` rather than SwiftUI's `Canvas` (which is macOS 12+). The visual
/// output is identical on both macOS 11 and modern macOS.
struct Scene3_MoonPhasesWheel: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var selectedPhase: Int? = nil
    @State private var exploredPhases: Set<Int> = []
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private struct MoonPhase: Identifiable {
        let id: Int
        let name: String
        let illuminationFraction: Double   // 0 = new, 1 = full
        let waxing: Bool                   // true = lit from right, false = lit from left
        let description: String
    }

    private let phases: [MoonPhase] = [
        MoonPhase(id: 0, name: "New Moon",
                  illuminationFraction: 0.0, waxing: true,
                  description: "The Moon is between Earth and the Sun. The lit side faces away from us, so the Moon looks completely dark. This marks the start of a new lunar cycle."),
        MoonPhase(id: 1, name: "Waxing Crescent",
                  illuminationFraction: 0.25, waxing: true,
                  description: "A thin sliver of light appears on the right side. \"Waxing\" means growing. The Moon is moving so more of its sunlit side becomes visible to us each night."),
        MoonPhase(id: 2, name: "First Quarter",
                  illuminationFraction: 0.5, waxing: true,
                  description: "Exactly half of the Moon's face is lit, on the right side. It is called \"quarter\" because the Moon has completed one-quarter of its orbit around Earth."),
        MoonPhase(id: 3, name: "Waxing Gibbous",
                  illuminationFraction: 0.75, waxing: true,
                  description: "More than half the Moon is lit. \"Gibbous\" means swollen or humped. The Moon is almost full and very bright in the evening sky."),
        MoonPhase(id: 4, name: "Full Moon",
                  illuminationFraction: 1.0, waxing: true,
                  description: "The entire face of the Moon is lit by the Sun. Earth is between the Sun and Moon. This is the brightest phase and happens roughly every 29.5 days."),
        MoonPhase(id: 5, name: "Waning Gibbous",
                  illuminationFraction: 0.75, waxing: false,
                  description: "The light starts shrinking from the right side. \"Waning\" means decreasing. The Moon rises later each night after full moon."),
        MoonPhase(id: 6, name: "Last Quarter",
                  illuminationFraction: 0.5, waxing: false,
                  description: "Half the Moon is lit, but this time on the left side. The Moon has completed three-quarters of its orbit. It is often visible in the morning sky."),
        MoonPhase(id: 7, name: "Waning Crescent",
                  illuminationFraction: 0.25, waxing: false,
                  description: "A thin sliver of light on the left side. The cycle is almost complete. Soon the Moon will be \"new\" again and the 29.5-day cycle restarts."),
    ]

    private var allDone: Bool { exploredPhases.count == phases.count }

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 14), count: 4)

    var body: some View {
        // Refactored ZStack-overlap pattern to ScrollView+VStack so
        // explanation cards don't cover the interactive content.
        ScrollView {
            VStack(spacing: 14) {
                VStack(spacing: 12) {
                    Text("Moon Phases")
                        .font(.largeTitle.bold())
                        .foregroundColor(DesignTokens.BrandColor.canvasText)
                        .padding(.top, 18)

                    Text("Tap each phase to learn what you see in the sky.")
                        .font(.callout)
                        .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)

                    // 2 x 4 grid
                    LazyVGrid(columns: columns, spacing: 14) {
                        ForEach(phases) { phase in
                            phaseCard(for: phase)
                        }
                    }
                    .frame(maxWidth: 560)
                    .padding(.top, 8)

                    Text("\(exploredPhases.count) / \(phases.count) phases explored")
                        .font(.caption.weight(.medium))
                        .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                        .padding(.top, 4)

                    Spacer()
                }
                .frame(maxWidth: .infinity)

                Group {
                    SoftShadowCard(padding: 18) {
                        VStack(alignment: .leading, spacing: 8) {
                            if let idx = selectedPhase, let phase = phases.first(where: { $0.id == idx }) {
                                Label(phase.name, systemImage: "moon.fill")
                                    .font(.title2.bold())
                                Text(phase.description)
                                    .font(.body)
                                    .lineSpacing(4)
                            } else {
                                Label("Phases of the Moon", systemImage: SFSymbolCompat.name("hand.tap.fill"))
                                    .font(.title2.bold())
                                Text("The Moon does not produce its own light -- it reflects sunlight. As it orbits Earth, we see different amounts of the lit side. One full cycle takes about 29.5 days. Tap each card to explore!")
                                    .font(.body)
                                    .lineSpacing(4)
                            }
                        }
                    }
                    .frame(maxWidth: DesignTokens.contentMaxWidth)

                    LookingAheadCallout(
                        title: "Class 11 Physics → JEE (Lunar Cycle)",
                        detail: "29.5 days from new moon → new moon = the *synodic* month. The moon's actual orbit takes only 27.3 days (sidereal month), but during that time Earth moves a chunk of its own orbit around the Sun, so the moon needs to 'catch up' to the same Sun-Earth-Moon geometry. JEE Physics asks the difference between sidereal and synodic periods — same problem for Mercury, Venus, satellites."
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)

                    TryAtHomeCallout(
                        title: "Moon-phase diary for 30 days",
                        detail: "Each clear evening, look at the moon (any direction visible). Sketch the shape in a notebook with the date. After 30 days you have a hand-drawn lunar calendar. You'll see the lit-side direction follows the Sun's position — the moon is half-lit always, you just see different angles. The Hindu calendar's tithi system is built on these same observations."
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)

                    if allDone {
                        GotItButton { onComplete() }
                            .padding(.bottom, 12)
                    }
                
                }
                .padding(.horizontal, 24)
            
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
        }
    }

    // MARK: - Phase Card

    private func phaseCard(for phase: MoonPhase) -> some View {
        let isSelected = selectedPhase == phase.id
        let isExplored = exploredPhases.contains(phase.id)

        return Button {
            withAnimation(reduceMotion ? .none : .spring()) {
                selectedPhase = phase.id
                exploredPhases.insert(phase.id)
            }
        } label: {
            VStack(spacing: 8) {
                // Shape-drawn moon (macOS 11 compatible — was Canvas before)
                ZStack {
                    Circle().fill(Color.gray.opacity(0.2))
                    MoonLitShape(fraction: phase.illuminationFraction,
                                 waxing: phase.waxing)
                        .fill(Color.white.opacity(0.9))
                    Circle().stroke(Color.gray.opacity(0.4), lineWidth: 1)
                }
                .frame(width: 56, height: 56)

                Text(phase.name)
                    .font(.caption.weight(.semibold))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
                    .foregroundColor(isSelected ? Color.compatIndigo : .primary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .padding(.horizontal, 6)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(isSelected ? Color.compatIndigo.opacity(0.1) : Color.white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .strokeBorder(
                        isSelected ? Color.compatIndigo : (isExplored ? .green.opacity(0.5) : .gray.opacity(0.25)),
                        lineWidth: 2
                    )
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(phase.name). \(isExplored ? "Explored" : "Not yet explored")")
    }

}

// MARK: - MoonLitShape (Big Sur friendly replacement for the old Canvas)

/// The lit portion of the Moon for a given phase. Used to be drawn inside a
/// SwiftUI `Canvas` block; Canvas is macOS 12+ so on Big Sur we draw the
/// same arcs inside a `Shape` (macOS 10.15+).
///
/// `fraction`: 0 = new (fully dark, empty path), 0.25 = crescent,
/// 0.5 = half, 0.75 = gibbous, 1 = full.
/// `waxing`: true = lit from the right, false = lit from the left.
struct MoonLitShape: Shape {
    let fraction: Double
    let waxing: Bool

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2 - 2

        // New moon — nothing lit.
        if fraction <= 0.001 { return path }

        let moonRect = CGRect(
            x: center.x - radius, y: center.y - radius,
            width: radius * 2, height: radius * 2
        )

        // Full moon — whole disc lit.
        if fraction >= 0.999 {
            path.addEllipse(in: moonRect)
            return path
        }

        // Partial phase: a semicircle on the lit side joined to a quadratic
        // terminator curve on the inside. Geometry matches the old Canvas
        // version 1:1 so visual output is identical on modern macOS.
        let startAngle: Angle = .degrees(-90)
        let endAngle: Angle = .degrees(90)

        if waxing {
            path.addArc(center: center, radius: radius,
                        startAngle: startAngle, endAngle: endAngle,
                        clockwise: false)
            let terminatorX = radius * (1 - 2 * fraction)
            path.addQuadCurve(
                to: CGPoint(x: center.x, y: center.y - radius),
                control: CGPoint(x: center.x + terminatorX, y: center.y)
            )
        } else {
            path.addArc(center: center, radius: radius,
                        startAngle: endAngle, endAngle: startAngle,
                        clockwise: false)
            let terminatorX = radius * (2 * fraction - 1)
            path.addQuadCurve(
                to: CGPoint(x: center.x, y: center.y + radius),
                control: CGPoint(x: center.x + terminatorX, y: center.y)
            )
        }

        path.closeSubpath()
        return path
    }
}
