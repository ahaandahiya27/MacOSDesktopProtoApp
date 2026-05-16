import SwiftUI

/// Scene 3 — Moon Phases Wheel.
/// Eight moon phase cards in a 2x4 grid. Each card shows a Canvas-drawn moon and
/// phase name. Tap to see explanation. After all 8 explored, Got It appears.
@available(macOS 12, *)
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
        GeometryReader { _ in
            ZStack {
                VStack(spacing: 12) {
                    Text("Moon Phases")
                        .font(.largeTitle.bold())
                        .padding(.top, 18)

                    Text("Tap each phase to learn what you see in the sky.")
                        .font(.callout)
                        .foregroundColor(.secondary)

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
                        .foregroundColor(.secondary)
                        .padding(.top, 4)

                    Spacer()
                }
                .frame(maxWidth: .infinity)

                VStack(spacing: 14) {
                    Spacer()

                    SoftShadowCard(padding: 18) {
                        VStack(alignment: .leading, spacing: 8) {
                            if let idx = selectedPhase, let phase = phases.first(where: { $0.id == idx }) {
                                Label(phase.name, systemImage: "moon.fill")
                                    .font(.title2.bold())
                                Text(phase.description)
                                    .font(.body)
                                    .lineSpacing(4)
                            } else {
                                Label("Phases of the Moon", systemImage: "hand.tap.fill")
                                    .font(.title2.bold())
                                Text("The Moon does not produce its own light -- it reflects sunlight. As it orbits Earth, we see different amounts of the lit side. One full cycle takes about 29.5 days. Tap each card to explore!")
                                    .font(.body)
                                    .lineSpacing(4)
                            }
                        }
                    }
                    .frame(maxWidth: 640)

                    if allDone {
                        GotItButton { onComplete() }
                            .padding(.bottom, 12)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .padding(.horizontal, 24)
            }
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
                // Canvas-drawn moon
                Canvas { ctx, size in
                    drawMoon(ctx: ctx, size: size,
                             fraction: phase.illuminationFraction,
                             waxing: phase.waxing)
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
                    .fill(isSelected ? Color.compatIndigo.opacity(0.1) : Color(NSColor.windowBackgroundColor))
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

    // MARK: - Canvas Moon Drawing

    /// Draws a moon phase using arcs.
    /// `fraction` 0 = new (dark), 0.25 = crescent, 0.5 = half, 0.75 = gibbous, 1 = full.
    /// `waxing` true = lit from right, false = lit from left.
    private func drawMoon(ctx: GraphicsContext, size: CGSize,
                          fraction: Double, waxing: Bool) {
        let center = CGPoint(x: size.width / 2, y: size.height / 2)
        let radius = min(size.width, size.height) / 2 - 2

        // Dark background circle (the moon body)
        let moonRect = CGRect(x: center.x - radius, y: center.y - radius,
                              width: radius * 2, height: radius * 2)
        ctx.fill(Path(ellipseIn: moonRect), with: .color(.gray.opacity(0.2)))

        // Outline
        ctx.stroke(Path(ellipseIn: moonRect), with: .color(.gray.opacity(0.4)), lineWidth: 1)

        if fraction <= 0.001 {
            // New moon: fully dark -- nothing more to draw
            return
        }

        // Build lit portion path
        var litPath = Path()

        if fraction >= 0.999 {
            // Full moon: entire circle lit
            litPath.addEllipse(in: moonRect)
        } else {
            // Build lit half using two arcs:
            // 1) A semicircle arc on the lit side
            // 2) An elliptical arc for the terminator

            let startAngle: Angle = .degrees(-90)
            let endAngle: Angle = .degrees(90)

            if waxing {
                // Lit semicircle on the right
                litPath.addArc(center: center, radius: radius,
                               startAngle: startAngle, endAngle: endAngle,
                               clockwise: false)

                // Terminator curve (elliptical)
                let terminatorX = radius * (1 - 2 * fraction)
                litPath.addQuadCurve(
                    to: CGPoint(x: center.x, y: center.y - radius),
                    control: CGPoint(x: center.x + terminatorX, y: center.y)
                )
            } else {
                // Lit semicircle on the left
                litPath.addArc(center: center, radius: radius,
                               startAngle: endAngle, endAngle: startAngle,
                               clockwise: false)

                // Terminator curve
                let terminatorX = radius * (2 * fraction - 1)
                litPath.addQuadCurve(
                    to: CGPoint(x: center.x, y: center.y + radius),
                    control: CGPoint(x: center.x + terminatorX, y: center.y)
                )
            }

            litPath.closeSubpath()
        }

        ctx.fill(litPath, with: .color(.white.opacity(0.9)))
    }
}
