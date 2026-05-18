import SwiftUI

/// Scene 2 — Pendulum Lab. Slider for length → period changes (T ∝ √L).
struct Scene2_PendulumLab: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var length: Double = 1.0   // metres
    @State private var angle: Double = 30
    @State private var phase: Double = 0       // radians, accumulated smoothly
    @State private var lastTick: TimeInterval = 0
    @State private var tick: TimeInterval = 0
    @State private var famousPendulum: Int = 2   // DiscoveryStepper: preset historic pendulum
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var period: Double { 2.0 * .pi * sqrt(length / 9.81) }

    var body: some View {
        VStack(spacing: 14) {
            Text("Pendulum Lab").font(.largeTitle.bold()).foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            Text("Change the string length. The period changes too.")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)

            ZStack {
                Rectangle().fill(Color.gray.opacity(0.4)).frame(width: 200, height: 4)
                Path { p in
                    p.move(to: CGPoint(x: 100, y: 2))
                    p.addLine(to: CGPoint(x: 100 + sin(angle * .pi / 180) * length * 100,
                                          y: 2 + cos(angle * .pi / 180) * length * 100))
                }
                .stroke(Color.compatIndigo, lineWidth: 2)
                .frame(width: 200, height: 200, alignment: .top)
                Circle().fill(Color.compatIndigo)
                    .frame(width: 28, height: 28)
                    .offset(x: CGFloat(sin(angle * .pi / 180) * length * 100),
                            y: CGFloat(cos(angle * .pi / 180) * length * 100) - 100)
            }
            .frame(width: 240, height: 260)
            .onChange(of: tick) { newTick in
                guard !reduceMotion else { return }
                let dt = max(0, newTick - lastTick)
                lastTick = newTick
                // Advance phase smoothly even when `period` (length) changes.
                phase = (phase + (2 * .pi / period) * dt).truncatingRemainder(dividingBy: 2 * .pi)
                angle = 30 * cos(phase)
            }
            .timedScene(idealFPS: 30, tick: $tick)

            HStack(alignment: .center, spacing: 18) {
                VStack(spacing: 6) {
                    Text("Length: \(String(format: "%.2f", length)) m").font(.headline)
                    Text("Period (1 swing): \(String(format: "%.2f", period)) s")
                        .font(.title3.weight(.semibold))
                        .foregroundColor(Color.compatIndigo)
                }
                PeriodLengthCurve(currentLength: length)
                    .frame(width: 200, height: 90)
                    .accessibilityLabel("Period grows with the square root of length")
            }

            Slider(value: $length, in: 0.2...2.0, step: 0.05).frame(maxWidth: 460).padding(.horizontal, 24)

            SoftShadowCard(padding: 18) {
                VStack(alignment: .leading, spacing: 8) {
                    Label("Longer string → slower swing", systemImage: SFSymbolCompat.name("metronome"))
                        .font(.title2.bold())
                    Text("The time for one swing depends only on the string length, not on the mass or how far you pull it back. Galileo discovered this. It's why pendulums were used for accurate clocks for 300 years.")
                        .font(.body).lineSpacing(4)
                }
            }
            .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, 24)

            // Grouped to stay within Swift 5.5's 10-child ViewBuilder limit.
            Group {
                LookingAheadCallout(
                    title: "Class 11 Physics → JEE",
                    detail: "The √L relationship you just discovered is the formula T = 2π√(L/g). In Class 11 you'll meet it again under Simple Harmonic Motion, then in JEE under Oscillations and Waves — every year, multiple questions."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)

                TryAtHomeCallout(
                    title: "DIY pendulum",
                    detail: "Tie a small weight (a key, a metal washer) to one end of a 50-cm string. Hold the other end against a doorframe. Set it swinging. Time 20 swings, divide by 20 — that's the period. Now halve the string and repeat. The new period is shorter (T scales with √L)."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)
            }

            DiscoveryStepper(
                title: "Discovery — historic pendulums",
                subtitle: "Pick a famous pendulum length. The slider above shows its swing live.",
                options: ["Pocket (0.10 m)", "Wall (0.25 m)", "Grandfather (1.0 m)", "Big Ben (4.0 m)"],
                selection: $famousPendulum,
                outputs: [
                    "≈ 0.6 s per swing. Pocket-watch escapement scale. Very quick tick.",
                    "≈ 1.0 s per swing. A typical wall-clock pendulum.",
                    "≈ 2.0 s per swing. The classic 'grandfather' tick-tock once per second.",
                    "≈ 4.0 s per swing. London's Big Ben — 13.5-tonne bob, used for the BBC's pip signal."
                ]
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)
            .onChange(of: famousPendulum) { newIndex in
                let presets: [Double] = [0.10, 0.25, 1.0, 4.0]
                let target = presets[max(0, min(newIndex, presets.count - 1))]
                length = min(2.0, max(0.2, target))
            }

            GotItButton { onComplete() }.padding(.bottom, 12)
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

/// Mini-chart: period (y) as a function of length (x), for L = 0.2…2.0 m.
/// The current `length` is highlighted with a dot + dashed guide so the kid
/// can see where they are on the √L curve in real time.
///
/// macOS 11 compatible — pure `Path` + `Text`, no Charts framework, no
/// TimelineView, no Canvas.
private struct PeriodLengthCurve: View {
    let currentLength: Double

    var body: some View {
        GeometryReader { geo in
            curveContent(size: geo.size)
        }
    }

    @ViewBuilder
    private func curveContent(size: CGSize) -> some View {
        let layout = PendulumPlotLayout(size: size)
        let cx = layout.x(for: currentLength)
        let cy = layout.y(for: PendulumPlotLayout.period(currentLength))
        ZStack {
            PendulumAxesShape(layout: layout)
                .stroke(Color.gray.opacity(0.6), lineWidth: 1)

            PendulumCurveShape(layout: layout)
                .stroke(Color.compatIndigo, lineWidth: 2)

            PendulumGuideShape(currentLength: currentLength, layout: layout)
                .stroke(Color.compatIndigo.opacity(0.5),
                        style: StrokeStyle(lineWidth: 1, dash: [3, 3]))

            Circle()
                .fill(Color.compatIndigo)
                .frame(width: 8, height: 8)
                .position(x: cx, y: cy)

            Text("T")
                .font(.caption2.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                .position(x: layout.padLeft - 12, y: layout.padTop + 6)
            Text("L")
                .font(.caption2.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                .position(x: size.width - 10, y: size.height - layout.padBottom - 8)
        }
    }
}

/// Layout constants + axis mapping for the pendulum period-vs-length plot.
private struct PendulumPlotLayout {
    let size: CGSize
    let padLeft: CGFloat = 26
    let padBottom: CGFloat = 16
    let padTop: CGFloat = 4
    let padRight: CGFloat = 4

    static let xMin: Double = 0.2
    static let xMax: Double = 2.0
    static let yMax: Double = 2.0 * .pi * 0.4517539514526256   // sqrt(2.0/9.81) constant

    var plotW: CGFloat { size.width - padLeft - padRight }
    var plotH: CGFloat { size.height - padTop - padBottom }

    static func period(_ l: Double) -> Double {
        2.0 * .pi * sqrt(l / 9.81)
    }

    func x(for l: Double) -> CGFloat {
        padLeft + CGFloat((l - Self.xMin) / (Self.xMax - Self.xMin)) * plotW
    }
    func y(for t: Double) -> CGFloat {
        padTop + (1 - CGFloat(t / Self.yMax)) * plotH
    }
}

private struct PendulumAxesShape: Shape {
    let layout: PendulumPlotLayout
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: layout.padLeft, y: layout.padTop))
        p.addLine(to: CGPoint(x: layout.padLeft, y: rect.height - layout.padBottom))
        p.addLine(to: CGPoint(x: rect.width - 2, y: rect.height - layout.padBottom))
        return p
    }
}

private struct PendulumCurveShape: Shape {
    let layout: PendulumPlotLayout
    func path(in rect: CGRect) -> Path {
        var p = Path()
        var first = true
        // 45 sample steps from xMin to xMax
        for i in 0...45 {
            let step = PendulumPlotLayout.xMin + (PendulumPlotLayout.xMax - PendulumPlotLayout.xMin) * Double(i) / 45.0
            let pt = CGPoint(x: layout.x(for: step),
                             y: layout.y(for: PendulumPlotLayout.period(step)))
            if first { p.move(to: pt); first = false } else { p.addLine(to: pt) }
        }
        return p
    }
}

private struct PendulumGuideShape: Shape {
    let currentLength: Double
    let layout: PendulumPlotLayout
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let cx = layout.x(for: currentLength)
        let cy = layout.y(for: PendulumPlotLayout.period(currentLength))
        p.move(to: CGPoint(x: cx, y: rect.height - layout.padBottom))
        p.addLine(to: CGPoint(x: cx, y: cy))
        p.addLine(to: CGPoint(x: layout.padLeft, y: cy))
        return p
    }
}
