import SwiftUI

// MARK: - Chapter 9 shape diagrams  (Soil)
//
// Pure-SwiftUI schematic diagrams for the four ch09 `shapeDiagram`
// MediaAssets. Big Sur / legacy-GPU rules honoured.

// MARK: - ch09_soil_profile

/// A vertical slice through the ground — the soil profile — showing its
/// horizons from the dark humus-rich topsoil down to the solid bedrock.
struct SoilProfileDiagram: View {
    private let horizons: [(String, String, Color, CGFloat)] = [
        ("O / A — Topsoil", "humus, roots", Color.compatBrown, 0.9),
        ("B — Subsoil", "minerals, clay", Color.compatBrown, 0.6),
        ("C — Weathered rock", "broken rock bits", DesignTokens.BrandColor.canvasTextSecondary, 0.45),
        ("Bedrock", "solid rock", DesignTokens.BrandColor.canvasTextSecondary, 0.7)
    ]
    var body: some View {
        SDFigure(tint: Color.compatBrown) {
            VStack(spacing: 3) {
                ForEach(0..<horizons.count, id: \.self) { i in
                    layer(horizons[i].0, horizons[i].1, horizons[i].2, horizons[i].3)
                }
            }
        }
    }

    private func layer(_ name: String, _ note: String, _ c: Color, _ opacity: CGFloat) -> some View {
        ZStack {
            Rectangle().fill(c.opacity(Double(opacity) * 0.5))
            HStack(spacing: 6) {
                Text(name).font(.system(size: 10, weight: .bold)).foregroundColor(DesignTokens.BrandColor.canvasText)
                SDLabel(text: note, color: c)
            }
        }
        .frame(maxHeight: .infinity)
    }
}

// MARK: - ch09_soil_types

/// Three soils compared by their grain size, which decides how fast water
/// drains: coarse sandy (drains fast), fine clayey (holds water), balanced
/// loamy (best for most crops).
struct SoilTypesDiagram: View {
    var body: some View {
        SDFigure(tint: Color.compatBrown) {
            HStack(spacing: 12) {
                jar("Sandy", "drains fast", grains: 4, size: 11)
                jar("Clayey", "holds water", grains: 18, size: 4)
                jar("Loamy", "best for crops", grains: 9, size: 7)
            }
        }
    }

    private func jar(_ name: String, _ note: String, grains: Int, size: CGFloat) -> some View {
        VStack(spacing: 5) {
            Text(name).font(.system(size: 11, weight: .bold)).foregroundColor(DesignTokens.BrandColor.canvasText)
            ZStack {
                RoundedRectangle(cornerRadius: 5).fill(Color.compatBrown.opacity(0.15))
                    .overlay(RoundedRectangle(cornerRadius: 5).strokeBorder(Color.compatBrown.opacity(0.5), lineWidth: 1.5))
                grainCluster(count: grains, size: size)
            }
            .frame(width: 60, height: 56)
            SDLabel(text: note, color: Color.compatBrown)
        }
    }

    private func grainCluster(count: Int, size: CGFloat) -> some View {
        // A simple fixed grid of grains scaled to size.
        let columns = 4
        let rows = (count + columns - 1) / columns
        return VStack(spacing: 2) {
            ForEach(0..<rows, id: \.self) { r in
                HStack(spacing: 2) {
                    ForEach(0..<columns, id: \.self) { c in
                        Circle()
                            .fill(Color.compatBrown.opacity(r * columns + c < count ? 0.6 : 0))
                            .frame(width: size, height: size)
                    }
                }
            }
        }
    }
}

// MARK: - ch09_erosion

/// Soil erosion: on bare ground rain washes the fertile topsoil away, but a
/// cover of plant roots holds the soil in place.
struct ErosionDiagram: View {
    var body: some View {
        SDFigure(tint: Color.compatBlue) {
            HStack(spacing: 14) {
                slope(protected: false, caption: "Bare → washed away")
                slope(protected: true, caption: "Plants hold soil")
            }
        }
    }

    private func slope(protected: Bool, caption: String) -> some View {
        VStack(spacing: 5) {
            ZStack {
                SlopeShape().fill(Color.compatBrown.opacity(0.45))
                    .frame(width: 90, height: 56)
                if protected {
                    HStack(spacing: 6) {
                        ForEach(0..<4, id: \.self) { _ in
                            Image(systemName: SFSymbolCompat.name("leaf.fill"))
                                .font(.system(size: 11)).foregroundColor(.green)
                        }
                    }.offset(y: -6)
                } else {
                    Image(systemName: SFSymbolCompat.name("arrow.down.right"))
                        .font(.system(size: 18, weight: .bold)).foregroundColor(Color.compatBlue)
                        .offset(x: 14, y: 8)
                }
            }
            SDLabel(text: caption, color: protected ? .green : Color.compatBlue)
        }
    }
}

/// A right-triangle hill slope (flat base, hypotenuse falling left→right).
private struct SlopeShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        p.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        p.closeSubpath()
        return p
    }
}

// MARK: - ch09_contour_terracing

/// Terrace farming on a hillside: cutting the slope into level steps slows
/// the run-off so water soaks in and soil stays put.
struct ContourTerracingDiagram: View {
    var body: some View {
        SDFigure(tint: .green) {
            GeometryReader { geo in
                let w = geo.size.width, h = geo.size.height
                ZStack {
                    // Hillside
                    SlopeShape9().fill(Color.compatBrown.opacity(0.35))
                        .frame(width: w * 0.9, height: h * 0.8).position(x: w / 2, y: h * 0.55)
                    // Level terrace steps with a little water on each
                    Group {
                        ForEach(0..<4, id: \.self) { i in
                            terraceStep(i: i, w: w, h: h)
                        }
                        SDLabel(text: "Level steps slow run-off", color: .green).position(x: w / 2, y: h * 0.06)
                    }
                }
            }
        }
    }

    private func terraceStep(i: Int, w: CGFloat, h: CGFloat) -> some View {
        // Steps widen and descend toward the foot of the slope; each shares a
        // common left margin so they read as cut into the hillside.
        let leftMargin = w * 0.08
        let width = w * (0.3 + CGFloat(i) * 0.14)
        let y = h * (0.28 + CGFloat(i) * 0.16)
        return RoundedRectangle(cornerRadius: 2)
            .fill(Color.compatBlue.opacity(0.4))
            .overlay(RoundedRectangle(cornerRadius: 2).strokeBorder(.green.opacity(0.6), lineWidth: 1.5))
            .frame(width: width, height: 12)
            .position(x: leftMargin + width / 2, y: y)
    }
}

/// A broad hillside triangle for the terracing scene.
private struct SlopeShape9: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        p.closeSubpath()
        return p
    }
}
