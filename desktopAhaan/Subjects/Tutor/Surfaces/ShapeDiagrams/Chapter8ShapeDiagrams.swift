import SwiftUI

// MARK: - Chapter 8 shape diagrams  (Winds, Storms and Cyclones)
//
// Pure-SwiftUI schematic diagrams for the four ch08 `shapeDiagram`
// MediaAssets. Big Sur / legacy-GPU rules honoured.

// MARK: - ch08_high_low_pressure

/// Wind is moving air: it always flows from a region of HIGH air pressure to
/// a region of LOW air pressure. The bigger the difference, the faster it
/// blows.
struct HighLowPressureDiagram: View {
    var body: some View {
        SDFigure(tint: Color.compatBlue) {
            VStack(spacing: 12) {
                HStack(spacing: 16) {
                    pressureNode("H", "High pressure", .red)
                    VStack(spacing: 2) {
                        SDArrow(color: .green)
                        SDLabel(text: "WIND", color: .green)
                    }
                    pressureNode("L", "Low pressure", Color.compatBlue)
                }
                SDLabel(text: "Air flows High → Low; bigger gap = stronger wind")
            }
        }
    }

    private func pressureNode(_ letter: String, _ caption: String, _ c: Color) -> some View {
        VStack(spacing: 5) {
            ZStack {
                Circle().fill(c.opacity(0.22)).overlay(Circle().stroke(c.opacity(0.6), lineWidth: 2))
                    .frame(width: 56, height: 56)
                Text(letter).font(.system(size: 26, weight: .heavy)).foregroundColor(c)
            }
            SDLabel(text: caption, color: c)
        }
    }
}

// MARK: - ch08_cyclone_spiral

/// A cyclone is a giant spiral of stormy winds whirling around a calm centre
/// — the "eye". This shows the spiral arms and the eye.
struct CycloneSpiralDiagram: View {
    // Big Sur / Swift 5.5 fix: the deep GeometryReader+ZStack closure is split
    // into typed helper funcs so the type-checker doesn't overflow its stack.
    var body: some View {
        SDFigure(tint: Color.compatBlue) {
            GeometryReader { geo in
                content(w: geo.size.width, h: geo.size.height)
            }
        }
    }

    private func content(w: CGFloat, h: CGFloat) -> some View {
        let cx = w / 2, cy = h / 2
        return ZStack {
            SpiralShape(turns: 3, maxRadius: min(w, h) * 0.42)
                .stroke(Color.compatBlue.opacity(0.6),
                        style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .frame(width: min(w, h) * 0.85, height: min(w, h) * 0.85)
                .position(x: cx, y: cy)
            Circle().fill(Color.white.opacity(0.85))
                .overlay(Circle().stroke(Color.compatBlue.opacity(0.6), lineWidth: 1.5))
                .frame(width: 26, height: 26).position(x: cx, y: cy)
            SDLabel(text: "Eye (calm)", color: Color.compatBlue).position(x: cx, y: cy + 28)
            SDLabel(text: "Spiralling storm winds", color: Color.compatBlue).position(x: cx, y: 12)
        }
    }
}

/// An Archimedean spiral built from line segments (no trig in the view body).
private struct SpiralShape: Shape {
    let turns: Int
    let maxRadius: CGFloat
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let cx = rect.midX, cy = rect.midY
        let steps = turns * 48
        for i in 0...steps {
            let t = CGFloat(i) / CGFloat(steps)
            let angle = t * CGFloat(turns) * 2 * .pi
            let r = t * maxRadius
            let pt = CGPoint(x: cx + r * cos(angle), y: cy + r * sin(angle))
            if i == 0 { p.move(to: pt) } else { p.addLine(to: pt) }
        }
        return p
    }
}

// MARK: - ch08_coriolis

/// The Coriolis effect: because the Earth spins, moving winds appear to curve
/// rather than travel in a straight line — which is why cyclones spiral.
struct CoriolisDiagram: View {
    // Big Sur / Swift 5.5 fix: the deep GeometryReader+ZStack closure is split
    // into typed helper funcs so the type-checker doesn't overflow its stack.
    var body: some View {
        SDFigure(tint: .green) {
            GeometryReader { geo in
                content(w: geo.size.width, h: geo.size.height)
            }
        }
    }

    private func content(w: CGFloat, h: CGFloat) -> some View {
        let s = min(w, h) * 0.78
        let cx = w / 2, cy = h / 2
        return ZStack {
            Circle().fill(Color.compatBlue.opacity(0.16))
                .overlay(Circle().strokeBorder(Color.compatBlue.opacity(0.5), lineWidth: 1.5))
                .frame(width: s, height: s).position(x: cx, y: cy)
            Image(systemName: SFSymbolCompat.name("arrow.triangle.2.circlepath"))
                .font(.system(size: 16, weight: .semibold)).foregroundColor(Color.compatBlue)
                .position(x: cx, y: cy)
            paths(w: w, h: h, cx: cx, cy: cy, s: s)
        }
    }

    private func paths(w: CGFloat, h: CGFloat, cx: CGFloat, cy: CGFloat, s: CGFloat) -> some View {
        Group {
            // Intended straight path
            Path { p in
                p.move(to: CGPoint(x: cx - s * 0.35, y: cy - s * 0.3))
                p.addLine(to: CGPoint(x: cx + s * 0.35, y: cy - s * 0.3))
            }.stroke(DesignTokens.BrandColor.canvasTextSecondary.opacity(0.5),
                     style: StrokeStyle(lineWidth: 1.5, dash: [4, 3]))
            // Actual curved (deflected) path
            CurvedArrowShape()
                .stroke(.red.opacity(0.75), style: StrokeStyle(lineWidth: 2.5, lineCap: .round))
                .frame(width: s * 0.7, height: s * 0.4)
                .position(x: cx, y: cy - s * 0.18)
            SDLabel(text: "straight").position(x: cx, y: cy - s * 0.42)
            SDLabel(text: "curved by spin", color: .red).position(x: cx, y: cy + s * 0.1)
        }
    }
}

/// A gently curving arrow used for the deflected wind path.
private struct CurvedArrowShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.minX, y: rect.minY))
        p.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.maxY),
                       control: CGPoint(x: rect.midX, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.maxX - 8, y: rect.maxY - 9))
        p.move(to: CGPoint(x: rect.maxX, y: rect.maxY))
        p.addLine(to: CGPoint(x: rect.maxX - 10, y: rect.maxY - 1))
        return p
    }
}

// MARK: - ch08_thunderstorm

/// Inside a thunderstorm cloud: warm air rushes up and cold air sinks down;
/// these violent up- and down-draughts build the charge that flashes as
/// lightning, with heavy rain below.
struct ThunderstormDiagram: View {
    // Big Sur / Swift 5.5 fix: the deep GeometryReader+ZStack closure is split
    // into typed helper funcs so the type-checker doesn't overflow its stack.
    var body: some View {
        SDFigure(tint: Color.compatPurple) {
            GeometryReader { geo in
                content(w: geo.size.width, h: geo.size.height)
            }
        }
    }

    private func content(w: CGFloat, h: CGFloat) -> some View {
        ZStack {
            cloud(w: w, h: h)
            draughts(w: w, h: h)
        }
    }

    private func cloud(w: CGFloat, h: CGFloat) -> some View {
        Group {
            CloudShape8().fill(DesignTokens.BrandColor.canvasTextSecondary.opacity(0.4))
                .frame(width: w * 0.7, height: h * 0.45).position(x: w / 2, y: h * 0.3)
            // Lightning bolt
            BoltShape().fill(.yellow.opacity(0.9))
                .frame(width: 18, height: 40).position(x: w * 0.5, y: h * 0.62)
        }
    }

    private func draughts(w: CGFloat, h: CGFloat) -> some View {
        Group {
            Image(systemName: SFSymbolCompat.name("arrow.up"))
                .font(.system(size: 16, weight: .bold)).foregroundColor(.red.opacity(0.7))
                .position(x: w * 0.36, y: h * 0.34)
            Image(systemName: SFSymbolCompat.name("arrow.down"))
                .font(.system(size: 16, weight: .bold)).foregroundColor(Color.compatBlue)
                .position(x: w * 0.64, y: h * 0.34)
            // Rain
            ForEach(0..<5, id: \.self) { i in
                Capsule().fill(Color.compatBlue.opacity(0.6)).frame(width: 2, height: 9)
                    .position(x: w * (0.34 + Double(i) * 0.08), y: h * 0.82)
            }
            SDLabel(text: "updraft", color: .red).position(x: w * 0.22, y: h * 0.34)
            SDLabel(text: "downdraft", color: Color.compatBlue).position(x: w * 0.8, y: h * 0.34)
        }
    }
}

/// A flat-bottomed storm cloud.
private struct CloudShape8: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.addEllipse(in: CGRect(x: rect.minX, y: rect.midY * 0.8, width: rect.width * 0.45, height: rect.height * 0.7))
        p.addEllipse(in: CGRect(x: rect.midX - rect.width * 0.22, y: rect.minY, width: rect.width * 0.5, height: rect.height * 0.8))
        p.addEllipse(in: CGRect(x: rect.midX + rect.width * 0.05, y: rect.midY * 0.7, width: rect.width * 0.5, height: rect.height * 0.75))
        p.addRect(CGRect(x: rect.minX + rect.width * 0.1, y: rect.midY, width: rect.width * 0.8, height: rect.height * 0.45))
        return p
    }
}

/// A lightning bolt zig-zag.
private struct BoltShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.midX + rect.width * 0.2, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        p.addLine(to: CGPoint(x: rect.midX, y: rect.midY))
        p.addLine(to: CGPoint(x: rect.midX - rect.width * 0.2, y: rect.maxY))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.midY * 0.9))
        p.addLine(to: CGPoint(x: rect.midX + rect.width * 0.1, y: rect.midY * 0.9))
        p.closeSubpath()
        return p
    }
}
