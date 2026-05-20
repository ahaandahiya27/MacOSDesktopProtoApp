import SwiftUI

/// Scene 1 — Ice to Water to Steam.
/// Temperature slider from -10 C to 120 C. Particles speed up with temperature.
/// Ice melts at 0 C, water boils at 100 C. All three are H2O — physical changes.
///
/// Big Sur (macOS 11) compatible — the Canvas/TimelineView particle field
/// is replaced with a 30 fps Timer.publish driving a ForEach of small
/// MoleculeDot views. Same particle physics, identical visual output.
struct Scene1_IceToWaterToSteam: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var temperature: Double = -10
    @State private var tick: TimeInterval = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var phase: MatterPhase {
        if temperature < 0 { return .ice }
        if temperature < 100 { return .water }
        return .steam
    }

    fileprivate enum MatterPhase: String {
        case ice = "Ice (solid)"
        case water = "Water (liquid)"
        case steam = "Steam (gas)"

        var emoji: String {
            switch self {
            case .ice: return "🧊"
            case .water: return "💧"
            case .steam: return "♨️"
            }
        }

        var color: Color {
            switch self {
            case .ice: return Color.compatCyan
            case .water: return .blue
            case .steam: return .gray
            }
        }
    }

    var body: some View {
        // ScrollView + LazyVStack: GeometryReader-collapse bug fixed by
        // removing the unused outer GeometryReader; interactive content
        // now flows naturally and the particleCanvas's own GeometryReader
        // has a real bounded canvas via its fixed-size frame.
        ScrollView {
            LazyVStack(alignment: .center, spacing: 14) {
                VStack(spacing: 16) {
                    Text("Ice to Water to Steam")
                        .font(.largeTitle.bold())
                        .foregroundColor(DesignTokens.BrandColor.canvasText)
                        .padding(.top, 18)

                    Text("Slide the temperature to see H₂O change state.")
                        .font(.callout)
                        .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)

                    // Phase display
                    ZStack {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(phase.color.opacity(0.1))
                            .frame(width: 280, height: 220)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .strokeBorder(phase.color.opacity(0.3), lineWidth: 2)
                            )

                        if reduceMotion {
                            VStack(spacing: 8) {
                                Text(phase.emoji)
                                    .font(.system(size: 72))
                                Text(phase.rawValue)
                                    .font(.headline)
                                    .foregroundColor(phase.color)
                            }
                        } else {
                            particleCanvas
                                .frame(width: 280, height: 220)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                    }
                    .accessibilityLabel("\(phase.rawValue) at \(Int(temperature)) degrees Celsius")

                    // Temperature readout
                    Text("\(Int(temperature))°C")
                        .font(.system(size: 36, weight: .bold, design: .monospaced))
                        .foregroundColor(temperatureColor)

                    Text(phase.rawValue)
                        .font(.title3.weight(.semibold))
                        .foregroundColor(phase.color)

                    // Slider
                    VStack(spacing: 4) {
                        Slider(value: $temperature, in: -10...120, step: 1)
                            .frame(maxWidth: 460)
                            .accessibilityLabel("Temperature slider")
                        HStack {
                            Text("-10°C").font(.caption).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                            Spacer()
                            Text("0°C").font(.caption).foregroundColor(Color.compatCyan)
                            Spacer()
                            Text("100°C").font(.caption).foregroundColor(DesignTokens.BrandColor.tryAtHome)
                            Spacer()
                            Text("120°C").font(.caption).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                        }
                        .frame(maxWidth: 460)
                    }
                    .padding(.horizontal, 24)
                }
                .frame(maxWidth: .infinity)

                Group {
                    SoftShadowCard(padding: 18) {
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Same substance, different forms", systemImage: "drop.triangle.fill")
                                .font(.title2.bold())
                            Text("Ice, water, and steam are all H₂O. Changing between them is a physical change — no new substance is formed. You can always reverse it: freeze water back to ice, or condense steam back to water.")
                                .font(.body)
                                .lineSpacing(4)
                        }
                    }
                    .frame(maxWidth: DesignTokens.contentMaxWidth)

                    ProcessTimeline(
                        title: "States of matter — heating water from ice to steam",
                        steps: [
                            .init(title: "Ice at −10 °C (solid)",
                                  detail: "Molecules locked in a rigid crystal lattice — they only vibrate in place. Volume is fixed; shape is fixed."),
                            .init(title: "Melting at 0 °C",
                                  detail: "Latent heat of fusion: 334 J of energy per gram, used only to break the lattice bonds. Temperature does NOT rise until all ice has melted."),
                            .init(title: "Liquid water 0 → 100 °C",
                                  detail: "Molecules slide past each other but stay close. Volume is fixed; shape takes its container. Heating raises the temperature directly."),
                            .init(title: "Boiling at 100 °C",
                                  detail: "Latent heat of vaporisation: 2260 J per gram, used to break ALL intermolecular bonds. Again the temperature pauses until every drop has turned to gas."),
                            .init(title: "Steam above 100 °C (gas)",
                                  detail: "Molecules fly free, far apart. Volume + shape both take the container. Reversal: cool steam → it condenses back to water, then freezes to ice. Same H₂O the whole time.")
                        ],
                        accent: Color.compatCyan
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)

                    LookingAheadCallout(
                        title: "Class 11 Chemistry → JEE (Phases of Matter)",
                        detail: "Ice → water → steam is *phase change* — JEE Thermodynamics asks for the latent heat: 334 J/g to melt ice (Lf), 2260 J/g to evaporate water (Lv). The amount needed to boil is 6× the amount to melt — because breaking ALL the bonds between molecules costs more than just loosening them. Same H₂O, dramatically different bond energy at each stage."
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)

                    TryAtHomeCallout(
                        title: "Watch latent heat at work",
                        detail: "Put a thermometer in a bowl of crushed ice. Add salt. Stir. The temperature drops below 0°C — sometimes to -10°C or lower. The salt makes ice melt faster, and that melting absorbs heat from the rest of the mixture (latent heat). This is the same trick old ice-cream makers use to chill cream below freezing without electricity."
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)

                    GotItButton { onComplete() }
                        .padding(.bottom, 12)
                

                }

                .padding(.horizontal, 24)
            

            }

            .frame(maxWidth: .infinity)

            .padding(.bottom, 12)

        }
        .timedScene(idealFPS: 30, tick: $tick)
    }

    // MARK: - Animation timer

    // MARK: - Molecule field (was a Canvas inside TimelineView)

    private var particleCanvas: some View {
        GeometryReader { geo in
            ZStack(alignment: .topLeading) {
                ForEach(0..<20, id: \.self) { i in
                    MoleculeDot(
                        index: i,
                        t: tick,
                        size: geo.size,
                        temperature: temperature,
                        phase: phase
                    )
                }
            }
        }
    }

    private var temperatureColor: Color {
        if temperature < 0 { return Color.compatCyan }
        if temperature < 50 { return Color.blue }
        if temperature < 100 { return Color.orange }
        return Color.red
    }
}

/// One animated H₂O molecule inside the particle field. Extracted into its
/// own struct (with explicit Double types throughout) so the Swift 5.5
/// type-checker doesn't time out on the inline trig + position math.
private struct MoleculeDot: View {
    let index: Int
    let t: TimeInterval
    let size: CGSize
    let temperature: Double
    let phase: Scene1_IceToWaterToSteam.MatterPhase

    var body: some View {
        let m = computePosition()
        return AnyShape(squareOrCircle: phase == .ice)
            .fill(m.fillColor.opacity(m.opacity))
            .frame(width: m.dotSize, height: m.dotSize)
            .position(x: CGFloat(m.x), y: CGFloat(m.y))
    }

    private struct MoleculePosition {
        let x: Double
        let y: Double
        let dotSize: CGFloat
        let opacity: Double
        let fillColor: Color
    }

    private func computePosition() -> MoleculePosition {
        let speed: Double = max(0.1, (temperature + 10) / 130.0)
        let seed: Double = Double(index) * 1.618
        let baseX: Double = (seed * 73.0).truncatingRemainder(dividingBy: 1.0)
        let baseY: Double = (seed * 137.0).truncatingRemainder(dividingBy: 1.0)
        let jitterX: Double = sin(Double(t) * speed * 3.0 + seed * 5.0) * speed * 30.0
        let jitterY: Double = cos(Double(t) * speed * 2.5 + seed * 7.0) * speed * 30.0
        let x: Double = baseX * Double(size.width) + jitterX
        let y: Double
        if phase == .steam {
            let rise: Double = (Double(t) * speed * 40.0 + seed * 50.0)
                .truncatingRemainder(dividingBy: Double(size.height))
            y = Double(size.height) - rise + jitterY * 0.5
        } else {
            y = baseY * Double(size.height) + jitterY
        }
        let dotSize: CGFloat = phase == .ice ? 20 : (phase == .water ? 14 : 10)
        let baseOpacity: Double = phase == .steam ? 0.4 : 0.7
        let opacity: Double = baseOpacity * 0.6
        let fillColor: Color = phase == .ice ? Color.compatCyan : phase.color
        return MoleculePosition(x: x, y: y, dotSize: dotSize,
                                opacity: opacity, fillColor: fillColor)
    }
}

/// Tiny type-erased Shape so MoleculeDot can swap between a square (ice)
/// and a circle (water/steam) without an `if`/`else` branch in the body
/// that confuses @ViewBuilder type inference on Swift 5.5.
private struct AnyShape: Shape {
    // @Sendable so the closure inherits Sendable in Swift 6 strict-concurrency
    // mode, matching the Shape protocol's Sendable conformance.
    private let pathBuilder: @Sendable (CGRect) -> Path
    init(squareOrCircle isSquare: Bool) {
        if isSquare {
            self.pathBuilder = { rect in Path(rect) }
        } else {
            self.pathBuilder = { rect in Path(ellipseIn: rect) }
        }
    }
    func path(in rect: CGRect) -> Path { pathBuilder(rect) }
}

// Expose the MatterPhase enum (it was a nested private enum before; make
// it accessible to MoleculeDot which lives at file scope now).
extension Scene1_IceToWaterToSteam {
    // (MatterPhase is declared on the struct already — re-export via a
    // typealias would be redundant. MoleculeDot uses the qualified name
    // Scene1_IceToWaterToSteam.MatterPhase directly above.)
}
