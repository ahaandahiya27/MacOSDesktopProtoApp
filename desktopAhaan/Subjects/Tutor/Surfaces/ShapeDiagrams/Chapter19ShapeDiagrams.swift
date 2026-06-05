import SwiftUI

// MARK: - Chapter 19 shape diagrams  (Stars and the Solar System)
//
// Pure-SwiftUI schematic diagrams for the four ch19 `shapeDiagram`
// MediaAssets. Big Sur / legacy-GPU rules honoured.

// MARK: - ch19_earth_tilt

/// The Earth spins on an axis tilted about 23.5°. This tilt — not its distance
/// from the Sun — is why we get seasons: the hemisphere leaning toward the Sun
/// gets more direct light.
struct EarthTiltDiagram: View {
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
        let cx: CGFloat = w * 0.62
        let cy: CGFloat = h * 0.5
        let rBase: CGFloat = min(w, h)
        let r: CGFloat = rBase * 0.26
        return ZStack {
            bodies(w: w, h: h, cx: cx, cy: cy, r: r)
            labels(w: w, h: h, cx: cx, cy: cy, r: r)
        }
    }

    private func bodies(w: CGFloat, h: CGFloat, cx: CGFloat, cy: CGFloat, r: CGFloat) -> some View {
        let sunX: CGFloat = w * 0.12
        let raysX: CGFloat = w * 0.32
        let earthSize: CGFloat = r * 2
        let axisH: CGFloat = r * 2.6
        return Group {
            // Sun + rays
            Circle().fill(.orange.opacity(0.8)).frame(width: 30, height: 30).position(x: sunX, y: cy)
            ForEach(0..<3, id: \.self) { i in
                sunRay(i: i, cy: cy, raysX: raysX)
            }
            // Earth
            Circle().fill(Color.compatBlue.opacity(0.35))
                .overlay(Circle().strokeBorder(Color.compatBlue.opacity(0.6), lineWidth: 1.5))
                .frame(width: earthSize, height: earthSize).position(x: cx, y: cy)
            // Tilted axis (23.5°)
            Rectangle().fill(.red.opacity(0.7)).frame(width: 2.5, height: axisH)
                .rotationEffect(.degrees(23.5)).position(x: cx, y: cy)
        }
    }

    // Per-iteration helper so the ForEach @ViewBuilder closure body is
    // a single expression (no `let ... ; return ...`). Swift 5.5 rejects
    // `return` inside @ViewBuilder closures.
    private func sunRay(i: Int, cy: CGFloat, raysX: CGFloat) -> some View {
        let rayY: CGFloat = cy - 24 + CGFloat(i) * 24
        return Image(systemName: SFSymbolCompat.name("arrow.right"))
            .font(.system(size: 12, weight: .bold)).foregroundColor(.orange)
            .position(x: raysX, y: rayY)
    }

    private func labels(w: CGFloat, h: CGFloat, cx: CGFloat, cy: CGFloat, r: CGFloat) -> some View {
        let sunLabelX: CGFloat = w * 0.12
        let sunLabelY: CGFloat = cy - 26
        let tiltLabelY: CGFloat = cy - r - 14
        let seasonsLabelY: CGFloat = cy + r + 14
        return Group {
            SDLabel(text: "Sun", color: .orange).position(x: sunLabelX, y: sunLabelY)
            SDLabel(text: "Axis tilt ≈ 23.5°", color: .red).position(x: cx, y: tiltLabelY)
            SDLabel(text: "Tilt → seasons", color: Color.compatBlue).position(x: cx, y: seasonsLabelY)
        }
    }
}

// MARK: - ch19_moon_phases

/// The Moon shows different shapes through the month — new, crescent, quarter,
/// gibbous, full and back — as we see varying amounts of its sunlit half.
struct MoonPhasesDiagram: View {
    private let phases: [(String, CGFloat)] = [
        ("New", 0.0), ("Crescent", 0.25), ("First quarter", 0.5),
        ("Gibbous", 0.75), ("Full", 1.0), ("Gibbous", 0.75),
        ("Last quarter", 0.5), ("Crescent", 0.25)
    ]
    var body: some View {
        SDFigure(tint: Color.compatBlue) {
            GeometryReader { geo in
                content(w: geo.size.width, h: geo.size.height)
            }
        }
    }

    private func content(w: CGFloat, h: CGFloat) -> some View {
        let cx: CGFloat = w / 2
        let cy: CGFloat = h / 2
        let rBase: CGFloat = min(w, h)
        let r: CGFloat = rBase * 0.36
        return ZStack {
            SDLabel(text: "~29 days", color: Color.compatBlue).position(x: cx, y: cy)
            ForEach(0..<phases.count, id: \.self) { i in
                moonNode(i: i, cx: cx, cy: cy, r: r)
            }
        }
    }

    private func moonNode(i: Int, cx: CGFloat, cy: CGFloat, r: CGFloat) -> some View {
        let angle: CGFloat = CGFloat(i) / CGFloat(phases.count) * 2 * .pi - .pi / 2
        let x: CGFloat = cx + r * cos(angle)
        let y: CGFloat = cy + r * sin(angle)
        let lit: CGFloat = phases[i].1
        let litW: CGFloat = 22 * lit
        return ZStack {
            Circle().fill(DesignTokens.BrandColor.canvasTextSecondary.opacity(0.4)).frame(width: 22, height: 22)
            Circle().fill(.yellow.opacity(0.85))
                .frame(width: litW, height: 22)
        }
        .position(x: x, y: y)
    }
}

// MARK: - ch19_solar_system

/// The Sun and the eight planets orbiting it, in order outward from the Sun —
/// the inner rocky planets, then the gas and ice giants.
struct SolarSystemDiagram: View {
    private let planets: [(String, Color)] = [
        ("Me", Color.compatBrown), ("V", .orange), ("E", Color.compatBlue), ("Ma", .red),
        ("J", Color.compatBrown), ("Sa", .yellow), ("U", Color.compatTeal), ("N", Color.compatBlue)
    ]
    var body: some View {
        SDFigure(tint: .orange) {
            GeometryReader { geo in
                content(w: geo.size.width, h: geo.size.height)
            }
        }
    }

    private func content(w: CGFloat, h: CGFloat) -> some View {
        let cx: CGFloat = w * 0.12
        let cy: CGFloat = h / 2
        let captionX: CGFloat = w * 0.6
        let captionY: CGFloat = h * 0.9
        return ZStack {
            Circle().fill(.orange.opacity(0.85)).frame(width: 34, height: 34).position(x: cx, y: cy)
            ForEach(0..<planets.count, id: \.self) { i in
                planetNode(i: i, cx: cx, cy: cy, w: w)
            }
            SDLabel(text: "Sun + 8 planets", color: .orange).position(x: captionX, y: captionY)
        }
    }

    private func planetNode(i: Int, cx: CGFloat, cy: CGFloat, w: CGFloat) -> some View {
        let span: CGFloat = w - cx - 40
        let step: CGFloat = span / CGFloat(planets.count)
        let x: CGFloat = cx + 28 + CGFloat(i) * step
        let size: CGFloat = (i == 4 || i == 5) ? 18 : (i >= 6 ? 13 : 9)
        return VStack(spacing: 2) {
            Circle().fill(planets[i].1.opacity(0.7)).frame(width: size, height: size)
            Text(planets[i].0).font(.system(size: 7, weight: .semibold)).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
        }
        .position(x: x, y: cy)
    }
}

// MARK: - ch19_eclipse

/// An eclipse happens when Sun, Moon and Earth line up. A solar eclipse: the
/// Moon blocks the Sun from Earth. A lunar eclipse: the Earth's shadow falls
/// on the Moon.
struct EclipseDiagram: View {
    var body: some View {
        SDFigure(tint: Color.compatPurple) {
            VStack(spacing: 14) {
                row(title: "Solar eclipse", order: ["Sun", "Moon", "Earth"],
                    colors: [.orange, DesignTokens.BrandColor.canvasTextSecondary, Color.compatBlue],
                    note: "Moon blocks the Sun")
                row(title: "Lunar eclipse", order: ["Sun", "Earth", "Moon"],
                    colors: [.orange, Color.compatBlue, DesignTokens.BrandColor.canvasTextSecondary],
                    note: "Earth's shadow on the Moon")
            }
        }
    }

    private func row(title: String, order: [String], colors: [Color], note: String) -> some View {
        VStack(spacing: 4) {
            HStack(spacing: 10) {
                Text(title).font(.system(size: 11, weight: .bold)).foregroundColor(DesignTokens.BrandColor.canvasText)
                ForEach(0..<order.count, id: \.self) { i in
                    HStack(spacing: 4) {
                        Circle().fill(colors[i].opacity(0.7)).frame(width: 16, height: 16)
                        Text(order[i]).font(.system(size: 8)).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                        if i < order.count - 1 {
                            Rectangle().fill(DesignTokens.BrandColor.canvasTextSecondary.opacity(0.4)).frame(width: 10, height: 1)
                        }
                    }
                }
            }
            SDLabel(text: note, color: Color.compatPurple)
        }
    }
}
