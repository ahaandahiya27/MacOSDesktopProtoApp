import SwiftUI

// MARK: - Chapter 7 shape diagrams  (Weather, Climate and Adaptations)
//
// Pure-SwiftUI schematic diagrams for the four ch07 `shapeDiagram`
// MediaAssets. Big Sur / legacy-GPU rules honoured.

// MARK: - ch07_atmosphere_layers

/// The atmosphere in stacked layers by altitude: troposphere (weather lives
/// here) → stratosphere (ozone) → mesosphere → thermosphere.
struct AtmosphereLayersDiagram: View {
    private let layers: [(String, String, Color)] = [
        ("Thermosphere", "auroras", Color.compatPurple),
        ("Mesosphere", "meteors burn", Color.compatBlue),
        ("Stratosphere", "ozone layer", Color.compatTeal),
        ("Troposphere", "weather & clouds", .green)
    ]
    var body: some View {
        SDFigure(tint: Color.compatBlue) {
            VStack(spacing: 4) {
                ForEach(0..<layers.count, id: \.self) { i in
                    band(layers[i].0, layers[i].1, layers[i].2, ground: i == layers.count - 1)
                }
            }
        }
    }

    private func band(_ name: String, _ note: String, _ c: Color, ground: Bool) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5).fill(c.opacity(ground ? 0.3 : 0.2))
                .overlay(RoundedRectangle(cornerRadius: 5).strokeBorder(c.opacity(0.55), lineWidth: 1))
            HStack(spacing: 6) {
                Text(name).font(.system(size: 11, weight: .bold)).foregroundColor(DesignTokens.BrandColor.canvasText)
                SDLabel(text: note, color: c)
            }
        }
        .frame(maxHeight: .infinity)
    }
}

// MARK: - ch07_monsoon_winds

/// The summer monsoon: the land heats up, drawing in moisture-laden winds
/// from the sea that bring India its rains.
struct MonsoonWindsDiagram: View {
    // Split into small typed helpers so Swift 5.5's type-checker doesn't
    // overflow its stack on one deep @ViewBuilder closure. No visual change.
    var body: some View {
        SDFigure(tint: Color.compatTeal) {
            GeometryReader { geo in
                content(w: geo.size.width, h: geo.size.height)
            }
        }
    }

    private func content(w: CGFloat, h: CGFloat) -> some View {
        ZStack {
            terrain(w: w, h: h)
            windsAndLabels(w: w, h: h)
        }
    }

    private func terrain(w: CGFloat, h: CGFloat) -> some View {
        Group {
            // Sea (lower) and land (upper)
            Rectangle().fill(Color.compatTeal.opacity(0.3))
                .frame(width: w, height: h * 0.4).position(x: w / 2, y: h * 0.8)
            IndiaBlobShape().fill(Color.compatBrown.opacity(0.4))
                .overlay(IndiaBlobShape().stroke(Color.compatBrown.opacity(0.6), lineWidth: 1.5))
                .frame(width: w * 0.4, height: h * 0.5).position(x: w / 2, y: h * 0.4)
            // Cloud over land
            CloudShape().fill(Color.white.opacity(0.85))
                .frame(width: 64, height: 26).position(x: w / 2, y: h * 0.22)
        }
    }

    private func windsAndLabels(w: CGFloat, h: CGFloat) -> some View {
        Group {
            ForEach(0..<3, id: \.self) { i in
                Image(systemName: SFSymbolCompat.name("arrow.up"))
                    .font(.system(size: 18, weight: .bold)).foregroundColor(Color.compatTeal)
                    .position(x: w * (0.32 + Double(i) * 0.18), y: h * 0.62)
            }
            SDLabel(text: "Land (India)", color: Color.compatBrown).position(x: w / 2, y: h * 0.42)
            SDLabel(text: "Moist sea winds", color: Color.compatTeal).position(x: w / 2, y: h * 0.95)
            SDLabel(text: "Rain", color: Color.compatBlue).position(x: w / 2, y: h * 0.22)
        }
    }
}

/// A rough peninsular landmass blob (pointed south).
private struct IndiaBlobShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.minX + rect.width * 0.2, y: rect.minY))
        p.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.minY + rect.height * 0.25),
                       control: CGPoint(x: rect.maxX, y: rect.minY))
        p.addQuadCurve(to: CGPoint(x: rect.midX, y: rect.maxY),
                       control: CGPoint(x: rect.maxX - rect.width * 0.1, y: rect.maxY * 0.8))
        p.addQuadCurve(to: CGPoint(x: rect.minX, y: rect.minY + rect.height * 0.3),
                       control: CGPoint(x: rect.minX + rect.width * 0.1, y: rect.maxY * 0.8))
        p.addQuadCurve(to: CGPoint(x: rect.minX + rect.width * 0.2, y: rect.minY),
                       control: CGPoint(x: rect.minX, y: rect.minY))
        p.closeSubpath()
        return p
    }
}

/// Three overlapping bumps making a cloud.
private struct CloudShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.addEllipse(in: CGRect(x: rect.minX, y: rect.midY, width: rect.width * 0.5, height: rect.height * 0.6))
        p.addEllipse(in: CGRect(x: rect.midX - rect.width * 0.2, y: rect.minY, width: rect.width * 0.5, height: rect.height))
        p.addEllipse(in: CGRect(x: rect.midX, y: rect.midY * 0.7, width: rect.width * 0.55, height: rect.height * 0.7))
        return p
    }
}

// MARK: - ch07_polar_adapt

/// How a polar bear is built for the cold: thick white fur for camouflage and
/// warmth, a fat (blubber) layer, and small ears that lose little heat.
struct PolarAdaptDiagram: View {
    var body: some View {
        SDFigure(tint: Color.compatBlue) {
            HStack(spacing: 14) {
                ZStack {
                    BearShape().fill(Color.white.opacity(0.9))
                        .overlay(BearShape().stroke(DesignTokens.BrandColor.canvasTextSecondary.opacity(0.5), lineWidth: 1.5))
                        .frame(width: 110, height: 90)
                    Circle().fill(DesignTokens.BrandColor.canvasText).frame(width: 4, height: 4).offset(x: 30, y: -16)
                }
                VStack(alignment: .leading, spacing: 8) {
                    SDLabel(text: "White fur — camouflage")
                    SDLabel(text: "Thick fur + blubber — warmth", color: Color.compatBlue)
                    SDLabel(text: "Small ears — less heat lost")
                    SDLabel(text: "Wide paws — walk on snow", color: Color.compatBlue)
                }
            }
        }
    }
}

/// A blocky four-legged bear silhouette.
private struct BearShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let bodyTop = rect.minY + rect.height * 0.3
        p.addRoundedRect(in: CGRect(x: rect.minX, y: bodyTop,
                                    width: rect.width * 0.8, height: rect.height * 0.4),
                         cornerSize: CGSize(width: 16, height: 16))
        // Head
        p.addEllipse(in: CGRect(x: rect.maxX - rect.width * 0.34, y: rect.minY + rect.height * 0.12,
                                width: rect.width * 0.34, height: rect.height * 0.34))
        // Legs
        for lx in [0.08, 0.62] {
            p.addRect(CGRect(x: rect.minX + rect.width * lx, y: bodyTop + rect.height * 0.36,
                             width: rect.width * 0.12, height: rect.height * 0.32))
        }
        return p
    }
}

// MARK: - ch07_climate_zones

/// Earth's three climate belts by latitude: hot tropics around the equator,
/// mild temperate zones, and cold polar caps top and bottom.
struct ClimateZonesDiagram: View {
    var body: some View {
        SDFigure(tint: .green) {
            GeometryReader { geo in
                let s = min(geo.size.width, geo.size.height) * 0.8
                let cx = geo.size.width / 2, cy = geo.size.height / 2
                ZStack {
                    Circle().fill(Color.compatBlue.opacity(0.18))
                        .overlay(Circle().strokeBorder(Color.compatBlue.opacity(0.5), lineWidth: 1.5))
                        .frame(width: s, height: s).position(x: cx, y: cy)
                    Group {
                        zoneBand("Polar", color: Color.compatBlue, cx: cx, y: cy - s * 0.38, width: s * 0.4)
                        zoneBand("Temperate", color: .green, cx: cx, y: cy - s * 0.18, width: s * 0.8)
                        zoneBand("Tropical", color: .orange, cx: cx, y: cy, width: s * 0.95)
                        zoneBand("Temperate", color: .green, cx: cx, y: cy + s * 0.18, width: s * 0.8)
                        zoneBand("Polar", color: Color.compatBlue, cx: cx, y: cy + s * 0.38, width: s * 0.4)
                    }
                }
            }
        }
    }

    private func zoneBand(_ name: String, color: Color, cx: CGFloat, y: CGFloat, width: CGFloat) -> some View {
        ZStack {
            Rectangle().fill(color.opacity(0.3)).frame(width: width, height: 14)
            SDLabel(text: name, color: color)
        }
        .position(x: cx, y: y)
    }
}
