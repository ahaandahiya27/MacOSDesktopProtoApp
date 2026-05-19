import SwiftUI

/// Scene 1 — Fast or Slow. Order 4 vehicles by typical speed.
struct Scene1_FastOrSlow: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: (Int) -> Void

    struct Vehicle: Identifiable, Equatable {
        let id = UUID(); let name: String; let kmh: Int
    }

    private let correctOrder: [Vehicle] = [
        Vehicle(name: "🚲 Cycle", kmh: 15),
        Vehicle(name: "🚗 Car",   kmh: 80),
        Vehicle(name: "🚄 Train", kmh: 160),
        Vehicle(name: "✈️ Plane", kmh: 900),
    ]
    @State private var current: [Vehicle] = []
    @State private var done = false
    @State private var trySpeedKMH: Double = 60   // free-play: my own speed pick

    private var score: Int {
        zip(current, correctOrder).reduce(0) { $0 + ($1.0.id == $1.1.id ? 1 : 0) }
    }

    var body: some View {
        // Wrapped in ScrollView so the scene scrolls on
        // shorter windows and overflowing content remains accessible.
        ScrollView {
    LazyVStack(alignment: .center, spacing: 12) {
                Text("Fast or Slow?").font(.largeTitle.bold()).foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                Text("Drag/tap to order these from slowest → fastest.")
                    .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)

                VStack(spacing: 8) {
                    ForEach(Array(current.enumerated()), id: \.element.id) { i, v in
                        HStack {
                            Text("\(i + 1).").font(.headline).frame(width: 30)
                            Text(v.name).font(.headline)
                            Spacer()
                            Button("↑") { swapUp(i) }.disabled(i == 0)
                            Button("↓") { swapDown(i) }.disabled(i == current.count - 1)
                        }
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 8).fill(Color.white.opacity(0.95)))
                    }
                }
                .frame(maxWidth: 480)

                HStack(spacing: 16) {
                    Button("Check") { done = true }.accentColor(Color.compatIndigo)
                    Button("Shuffle") { current.shuffle(); done = false }
                }

                if done {
                    Text("Score: \(score) / \(correctOrder.count)").font(.title3.bold()).foregroundColor(Color.compatIndigo)
                }

                SoftShadowCard(padding: 14) {
                    Text("Speed = distance ÷ time. A cycle ≈ 15 km/h, a car ≈ 80, a train ≈ 160, a plane ≈ 900. Bigger speed = covers more ground per minute.")
                        .font(.callout).lineSpacing(4)
                }
                .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, 24)

                // Grouped to stay within Swift 5.5's 10-child ViewBuilder limit.
                Group {
                    LookingAheadCallout(
                        title: "Class 11 Physics → JEE",
                        detail: "Class 11 'Motion in a Straight Line' formalises speed (scalar) vs velocity (vector — direction matters). Average speed ≠ |average velocity| in general. JEE Kinematics tests this distinction in multi-segment journey problems every year."
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                    .padding(.horizontal, 24)

                    TryAtHomeCallout(
                        title: "Time a household member",
                        detail: "Use a stopwatch and a measured 10-metre stretch. Time everyone in your family walking it. Compute their speeds in m/s. Repeat after they jog. Plot a tiny bar chart of resting vs jogging speeds."
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                    .padding(.horizontal, 24)
                }

                DiscoveryWidget(
                    title: "Discovery — pick a speed, see the journey",
                    subtitle: "How long would 1000 km from Delhi to Mumbai take at different speeds?",
                    value: $trySpeedKMH,
                    range: 5...900,
                    step: 5,
                    valueLabel: { v in String(format: "Speed: %.0f km/h", v) },
                    output: travelTimeExplanation
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)

                if done { GotItButton { onComplete(score) }.padding(.bottom, 12) }
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
        }
        .onAppear { if current.isEmpty { current = correctOrder.shuffled() } }
    }

    private func swapUp(_ i: Int) { current.swapAt(i, i - 1); done = false }
    private func swapDown(_ i: Int) { current.swapAt(i, i + 1); done = false }

    private func travelTimeExplanation(_ kmh: Double) -> String {
        let hours = 1000.0 / max(1, kmh)
        let h = Int(hours)
        let m = Int((hours - Double(h)) * 60)
        let label: String
        switch kmh {
        case ..<20:
            label = "Cycle pace. A multi-day journey — like 19th-century travellers between Delhi and Bombay."
        case ..<100:
            label = "Car-on-highway pace. A long day's drive."
        case ..<300:
            label = "Express-train pace. Half a day."
        default:
            label = "Plane pace. About an hour each way."
        }
        return String(format: "1000 km at this speed = %dh %02dm. ", h, m) + label
    }
}
