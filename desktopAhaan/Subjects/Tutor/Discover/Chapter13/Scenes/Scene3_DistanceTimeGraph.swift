import SwiftUI

/// Scene 3 — Distance–Time Graph. Pick a motion; the graph is drawn.
struct Scene3_DistanceTimeGraph: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    enum Motion: String, CaseIterable, Identifiable {
        case still = "At rest"
        case uniform = "Uniform speed"
        case accelerating = "Speeding up"
        var id: String { rawValue }
    }
    @State private var motion: Motion = .uniform

    private func y(for x: Double) -> Double {
        switch motion {
        case .still:        return 0
        case .uniform:      return x
        case .accelerating: return x * x * 0.1
        }
    }

    var body: some View {
        VStack(spacing: 14) {
            Text("Distance–Time Graph").font(.largeTitle.bold()).foregroundColor(ChapterTheme.accent(for: chapter.id)).padding(.top, 18)
            Text("Pick a motion. Watch how the line changes shape.")
                .font(.callout).foregroundColor(.secondary)

            Picker("", selection: $motion) {
                ForEach(Motion.allCases) { Text($0.rawValue).tag($0) }
            }.pickerStyle(.segmented).frame(maxWidth: 460)

            DistanceTimePlot(yFunction: y)
                .frame(width: 360, height: 240)
                .accessibilityLabel("Distance vs time graph for \(motion.rawValue)")

            SoftShadowCard(padding: 18) {
                VStack(alignment: .leading, spacing: 8) {
                    Label("Shape tells the story", systemImage: "chart.line.uptrend.xyaxis")
                        .font(.title2.bold())
                    Text("Flat line = standing still. Straight slanted line = uniform speed. Curve that gets steeper = speeding up. You can read distance, speed and motion type just from the shape.")
                        .font(.body).lineSpacing(4)
                }
            }
            .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, 24)

            LookingAheadCallout(
                title: "Class 11 Physics → JEE",
                detail: "The slope of a distance-time graph is velocity. The slope of a velocity-time graph is acceleration. These reading-the-graph skills become the heart of Class 11 Kinematics and reappear in JEE Mechanics."
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            TryAtHomeCallout(
                title: "Walk-a-graph game",
                detail: "On a long corridor, mark every metre with chalk. Walk slowly for 5 seconds, then stop for 5, then run for 5. Have a friend write down where you are each second. Plot the points on graph paper. You just made a distance-time graph of your own motion."
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            GotItButton { onComplete() }.padding(.bottom, 12)
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

/// Proper distance-vs-time plot with x and y axes, dashed grid lines at
/// integer steps, and labelled axis ends. macOS 11 safe — pure `Path`.
/// Layers are extracted into Shapes so Swift 5.5's type-checker can resolve
/// the GeometryReader closure without timing out.
private struct DistanceTimePlot: View {
    let yFunction: (Double) -> Double

    var body: some View {
        GeometryReader { geo in
            plotContent(size: geo.size)
        }
    }

    @ViewBuilder
    private func plotContent(size: CGSize) -> some View {
        let layout = PlotLayout(size: size)
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.06))

            GridShape(layout: layout)
                .stroke(Color.gray.opacity(0.20),
                        style: StrokeStyle(lineWidth: 0.5, dash: [3, 3]))

            AxesShape(layout: layout)
                .stroke(Color.gray.opacity(0.75), lineWidth: 1.5)

            CurveShape(layout: layout, yFunction: yFunction)
                .stroke(Color.compatIndigo, lineWidth: 3)

            axisLabels(layout: layout, size: size)
        }
    }

    private func axisLabels(layout: PlotLayout, size: CGSize) -> some View {
        ZStack {
            Text("distance")
                .font(.caption2.bold())
                .foregroundColor(.secondary)
                .rotationEffect(.degrees(-90))
                .position(x: layout.padLeft - 18,
                          y: layout.padTop + layout.plotH / 2)
            Text("time →")
                .font(.caption2.bold())
                .foregroundColor(.secondary)
                .position(x: size.width - 30, y: size.height - 8)
            Text("0")
                .font(.caption2)
                .foregroundColor(.secondary)
                .position(x: layout.padLeft - 8, y: size.height - layout.padBottom + 8)
        }
    }
}

/// Holds layout constants + axis-mapping helpers so the Shape structs below
/// don't need to recompute them on every redraw.
private struct PlotLayout {
    let size: CGSize
    let padLeft: CGFloat = 32
    let padBottom: CGFloat = 26
    let padTop: CGFloat = 10
    let padRight: CGFloat = 14

    var plotW: CGFloat { size.width - padLeft - padRight }
    var plotH: CGFloat { size.height - padTop - padBottom }

    func sx(_ t: Double) -> CGFloat {
        padLeft + CGFloat(t / 10.0) * plotW
    }
    func sy(_ v: Double) -> CGFloat {
        let clamped = min(max(v, 0), 10)
        return padTop + (1 - CGFloat(clamped / 10.0)) * plotH
    }
}

private struct GridShape: Shape {
    let layout: PlotLayout
    func path(in rect: CGRect) -> Path {
        var p = Path()
        for step in 1...10 {
            let x = layout.sx(Double(step))
            p.move(to: CGPoint(x: x, y: layout.padTop))
            p.addLine(to: CGPoint(x: x, y: rect.height - layout.padBottom))
        }
        for step in 1...10 {
            let y = layout.sy(Double(step))
            p.move(to: CGPoint(x: layout.padLeft, y: y))
            p.addLine(to: CGPoint(x: rect.width - layout.padRight, y: y))
        }
        return p
    }
}

private struct AxesShape: Shape {
    let layout: PlotLayout
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: layout.padLeft, y: layout.padTop))
        p.addLine(to: CGPoint(x: layout.padLeft, y: rect.height - layout.padBottom))
        p.addLine(to: CGPoint(x: rect.width - layout.padRight, y: rect.height - layout.padBottom))
        return p
    }
}

private struct CurveShape: Shape {
    let layout: PlotLayout
    let yFunction: (Double) -> Double
    func path(in rect: CGRect) -> Path {
        var p = Path()
        var first = true
        for stepInt in 0...100 {
            let step = Double(stepInt) / 10.0
            let pt = CGPoint(x: layout.sx(step), y: layout.sy(yFunction(step)))
            if first {
                p.move(to: pt)
                first = false
            } else {
                p.addLine(to: pt)
            }
        }
        return p
    }
}
