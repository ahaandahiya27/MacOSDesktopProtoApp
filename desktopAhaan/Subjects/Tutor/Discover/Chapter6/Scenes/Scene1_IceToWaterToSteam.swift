import SwiftUI

/// Scene 1 — Ice to Water to Steam.
/// Temperature slider from -10 C to 120 C. Canvas particles speed up with temperature.
/// Ice melts at 0 C, water boils at 100 C. All three are H2O — physical changes.
struct Scene1_IceToWaterToSteam: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var temperature: Double = -10
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var phase: MatterPhase {
        if temperature < 0 { return .ice }
        if temperature < 100 { return .water }
        return .steam
    }

    private enum MatterPhase: String {
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
            case .ice: return .cyan
            case .water: return .blue
            case .steam: return .gray
            }
        }
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack(spacing: 16) {
                    Text("Ice to Water to Steam")
                        .font(.largeTitle.bold())
                        .padding(.top, 18)

                    Text("Slide the temperature to see H₂O change state.")
                        .font(.callout)
                        .foregroundStyle(.secondary)

                    Spacer()

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
                                    .foregroundStyle(phase.color)
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
                        .foregroundStyle(temperatureColor)

                    Text(phase.rawValue)
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(phase.color)

                    // Slider
                    VStack(spacing: 4) {
                        Slider(value: $temperature, in: -10...120, step: 1)
                            .frame(maxWidth: 460)
                            .accessibilityLabel("Temperature slider")
                        HStack {
                            Text("-10°C").font(.caption).foregroundStyle(.secondary)
                            Spacer()
                            Text("0°C").font(.caption).foregroundStyle(.cyan)
                            Spacer()
                            Text("100°C").font(.caption).foregroundStyle(.orange)
                            Spacer()
                            Text("120°C").font(.caption).foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: 460)
                    }
                    .padding(.horizontal, 24)

                    Spacer()
                    Spacer()
                }
                .frame(maxWidth: .infinity)

                VStack(spacing: 14) {
                    Spacer()
                    SoftShadowCard(padding: 18) {
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Same substance, different forms", systemImage: "drop.triangle.fill")
                                .font(.title2.bold())
                            Text("Ice, water, and steam are all H₂O. Changing between them is a physical change — no new substance is formed. You can always reverse it: freeze water back to ice, or condense steam back to water.")
                                .font(.body)
                                .lineSpacing(4)
                        }
                    }
                    .frame(maxWidth: 640)
                    GotItButton { onComplete() }
                        .padding(.bottom, 12)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .padding(.horizontal, 24)
            }
        }
    }

    // MARK: - Particle Canvas

    private var particleCanvas: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 20)) { timeline in
            let t = timeline.date.timeIntervalSince1970
            Canvas { context, size in
                var ctx = context
                let speed = max(0.1, (temperature + 10) / 130.0)
                let count = 20

                for i in 0..<count {
                    let seed = Double(i) * 1.618
                    let baseX = (seed * 73.0).truncatingRemainder(dividingBy: 1.0)
                    let baseY = (seed * 137.0).truncatingRemainder(dividingBy: 1.0)

                    let jitterX = sin(t * speed * 3.0 + seed * 5.0) * Double(speed) * 30.0
                    let jitterY = cos(t * speed * 2.5 + seed * 7.0) * Double(speed) * 30.0

                    let x = baseX * Double(size.width) + jitterX
                    let y: Double
                    if phase == .steam {
                        let rise = (t * speed * 40.0 + seed * 50.0)
                            .truncatingRemainder(dividingBy: Double(size.height))
                        y = Double(size.height) - rise + jitterY * 0.5
                    } else {
                        y = baseY * Double(size.height) + jitterY
                    }

                    let radius: CGFloat = phase == .ice ? 10 : (phase == .water ? 7 : 5)
                    let rect = CGRect(
                        x: x - Double(radius),
                        y: y - Double(radius),
                        width: Double(radius) * 2,
                        height: Double(radius) * 2
                    )

                    ctx.opacity = phase == .steam ? 0.4 : 0.7
                    if phase == .ice {
                        ctx.fill(Path(CGRect(
                            x: rect.origin.x, y: rect.origin.y,
                            width: rect.width, height: rect.height
                        )), with: .color(.cyan.opacity(0.6)))
                    } else {
                        ctx.fill(Path(ellipseIn: rect), with: .color(phase.color.opacity(0.6)))
                    }
                }
            }
        }
    }

    private var temperatureColor: Color {
        if temperature < 0 { return .cyan }
        if temperature < 50 { return .blue }
        if temperature < 100 { return .orange }
        return .red
    }
}
