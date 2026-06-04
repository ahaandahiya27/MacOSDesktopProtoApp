import SwiftUI

// MARK: - Chapter 13 shape diagrams  (Motion and Time)
//
// Pure-SwiftUI schematic diagrams for the four ch13 `shapeDiagram`
// MediaAssets. Big Sur / legacy-GPU rules honoured. The distance–time graph
// is drawn with Path (NOT the Charts framework, which is macOS 13+).

// MARK: - ch13_distance_time

/// A distance–time graph: time runs along the bottom, distance up the side.
/// A straight, sloping line means steady (uniform) speed — equal distance in
/// equal time.
struct DistanceTimeDiagram: View {
    // Split into small typed helpers so Swift 5.5's type-checker doesn't
    // overflow its stack on one deep @ViewBuilder closure. No visual change.
    var body: some View {
        SDFigure(tint: Color.compatBlue) {
            GeometryReader { geo in
                content(w: geo.size.width, h: geo.size.height)
            }
        }
    }

    private func content(w: CGFloat, h: CGFloat) -> some View {
        ZStack {
            graph(w: w, h: h)
            labels(w: w, h: h)
        }
    }

    private func graph(w: CGFloat, h: CGFloat) -> some View {
        let ox: CGFloat = w * 0.16
        let oy: CGFloat = h * 0.84
        let tx: CGFloat = w * 0.9
        let ty: CGFloat = h * 0.12
        return Group {
            // Axes
            Path { p in
                p.move(to: CGPoint(x: ox, y: ty))
                p.addLine(to: CGPoint(x: ox, y: oy))
                p.addLine(to: CGPoint(x: tx, y: oy))
            }.stroke(DesignTokens.BrandColor.canvasText.opacity(0.7), lineWidth: 2)
            // Uniform-motion line
            Path { p in
                p.move(to: CGPoint(x: ox, y: oy))
                p.addLine(to: CGPoint(x: tx, y: ty))
            }.stroke(Color.compatBlue.opacity(0.8),
                     style: StrokeStyle(lineWidth: 3, lineCap: .round))
        }
    }

    private func labels(w: CGFloat, h: CGFloat) -> some View {
        let ox: CGFloat = w * 0.16
        let oy: CGFloat = h * 0.84
        let distanceLabelX: CGFloat = ox - 14
        let distanceLabelY: CGFloat = h * 0.48
        let timeLabelX: CGFloat = w * 0.5
        let timeLabelY: CGFloat = oy + 14
        let captionX: CGFloat = w * 0.56
        let captionY: CGFloat = h * 0.28
        return Group {
            SDLabel(text: "Distance →", color: Color.compatBlue)
                .rotationEffect(.degrees(-90)).position(x: distanceLabelX, y: distanceLabelY)
            SDLabel(text: "Time →").position(x: timeLabelX, y: timeLabelY)
            SDLabel(text: "Straight line = uniform speed", color: Color.compatBlue)
                .position(x: captionX, y: captionY)
        }
    }
}

// MARK: - ch13_pendulum

/// A simple pendulum: a bob on a string swinging from a fixed pivot. One
/// full to-and-fro swing is an oscillation; the time it takes is the time
/// period, and it stays the same for a given length.
struct PendulumDiagram: View {
    // Big Sur / Swift 5.5 fix: the deep GeometryReader+ZStack closure is split
    // into typed helper funcs so the type-checker doesn't overflow its stack.
    var body: some View {
        SDFigure(tint: .orange) {
            GeometryReader { geo in
                content(w: geo.size.width, h: geo.size.height)
            }
        }
    }

    private func content(w: CGFloat, h: CGFloat) -> some View {
        let px: CGFloat = w / 2
        let py: CGFloat = h * 0.14
        let len: CGFloat = h * 0.6
        let swing: Double = 28.0
        return ZStack {
            apparatus(px: px, py: py, len: len, swing: swing)
            labels(px: px, py: py, len: len, h: h)
        }
    }

    private func apparatus(px: CGFloat, py: CGFloat, len: CGFloat, swing: Double) -> some View {
        let arcSize: CGFloat = len * 2
        return Group {
            // Pivot
            Rectangle().fill(DesignTokens.BrandColor.canvasText.opacity(0.6))
                .frame(width: 40, height: 6).position(x: px, y: py)
            // Swing arc
            SwingArcShape(radius: len, swingDegrees: swing)
                .stroke(.orange.opacity(0.5),
                        style: StrokeStyle(lineWidth: 1.5, dash: [4, 3]))
                .frame(width: arcSize, height: arcSize).position(x: px, y: py)
            // String + bob at one extreme
            stringAndBob(px: px, py: py, len: len, deg: -swing)
            stringAndBob(px: px, py: py, len: len, deg: swing, faded: true)
        }
    }

    private func labels(px: CGFloat, py: CGFloat, len: CGFloat, h: CGFloat) -> some View {
        let pivotLabelX: CGFloat = px + 40
        let bobLabelX: CGFloat = px + 36
        let bobLabelY: CGFloat = py + len
        let bottomLabelY: CGFloat = h * 0.95
        return Group {
            SDLabel(text: "Pivot").position(x: pivotLabelX, y: py)
            SDLabel(text: "Bob", color: .orange).position(x: bobLabelX, y: bobLabelY)
            SDLabel(text: "One swing = 1 oscillation").position(x: px, y: bottomLabelY)
        }
    }

    private func stringAndBob(px: CGFloat, py: CGFloat, len: CGFloat, deg: Double, faded: Bool = false) -> some View {
        let rad: CGFloat = CGFloat(deg) * .pi / 180
        let bx: CGFloat = px + len * sin(rad)
        let by: CGFloat = py + len * cos(rad)
        let op: Double = faded ? 0.3 : 0.9
        return ZStack {
            Path { p in
                p.move(to: CGPoint(x: px, y: py))
                p.addLine(to: CGPoint(x: bx, y: by))
            }.stroke(DesignTokens.BrandColor.canvasTextSecondary.opacity(op), lineWidth: 1.5)
            Circle().fill(.orange.opacity(op)).frame(width: 18, height: 18).position(x: bx, y: by)
        }
    }
}

/// The dashed arc the bob sweeps, centred on the pivot.
private struct SwingArcShape: Shape {
    let radius: CGFloat
    let swingDegrees: Double
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let c = CGPoint(x: rect.midX, y: rect.midY)
        let start = Angle.degrees(90 - swingDegrees)
        let end = Angle.degrees(90 + swingDegrees)
        p.addArc(center: c, radius: radius, startAngle: start, endAngle: end, clockwise: false)
        return p
    }
}

// MARK: - ch13_clock_history

/// How people have measured time through history: from the shadow of a
/// sundial, to water and sand clocks, to pendulum clocks, to today's
/// super-accurate quartz clocks.
struct ClockHistoryDiagram: View {
    private let clocks: [(String, String)] = [
        ("sun.max.fill", "Sundial"),
        ("drop.fill", "Water clock"),
        ("hourglass", "Sand clock"),
        ("clock.fill", "Pendulum"),
        ("clock.fill", "Quartz")
    ]
    var body: some View {
        SDFigure(tint: Color.compatBrown) {
            VStack(spacing: 8) {
                SDLabel(text: "Older → more accurate →", color: Color.compatBrown)
                HStack(spacing: 4) {
                    ForEach(0..<clocks.count, id: \.self) { i in
                        clockNode(clocks[i].0, clocks[i].1, last: i == clocks.count - 1)
                    }
                }
            }
        }
    }

    private func clockNode(_ symbol: String, _ name: String, last: Bool) -> some View {
        HStack(spacing: 3) {
            VStack(spacing: 3) {
                Image(systemName: SFSymbolCompat.name(symbol))
                    .font(.system(size: 18)).foregroundColor(Color.compatBrown)
                    .frame(width: 30, height: 30)
                    .background(Circle().fill(Color.compatBrown.opacity(0.15)))
                Text(name).font(.system(size: 8, weight: .semibold)).foregroundColor(DesignTokens.BrandColor.canvasText).fixedSize()
            }
            if !last {
                Image(systemName: SFSymbolCompat.name("arrow.right"))
                    .font(.system(size: 10, weight: .bold)).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
            }
        }
    }
}

// MARK: - ch13_speed_compare

/// Speed = distance ÷ time. Some things are far faster than others — compared
/// here as bars (a snail crawls; an aeroplane races).
struct SpeedCompareDiagram: View {
    private let movers: [(String, CGFloat)] = [
        ("Snail", 0.06), ("Walking", 0.18), ("Cycle", 0.35), ("Car", 0.7), ("Aeroplane", 1.0)
    ]
    var body: some View {
        SDFigure(tint: .green) {
            VStack(spacing: 5) {
                SDLabel(text: "Speed = distance ÷ time", color: .green)
                ForEach(0..<movers.count, id: \.self) { i in
                    let frac: CGFloat = movers[i].1
                    return HStack(spacing: 6) {
                        Text(movers[i].0)
                            .font(.system(size: 9, weight: .semibold))
                            .foregroundColor(DesignTokens.BrandColor.canvasText)
                            .frame(width: 56, alignment: .trailing)
                        GeometryReader { geo in
                            let scaled: CGFloat = geo.size.width * frac
                            let barW: CGFloat = max(6, scaled)
                            return RoundedRectangle(cornerRadius: 3)
                                .fill(Color.green.opacity(0.5))
                                .frame(width: barW, height: 12)
                        }
                        .frame(height: 12)
                    }
                }
            }
        }
    }
}
