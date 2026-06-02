import SwiftUI

// MARK: - Chapter 4 shape diagrams  (Heat)
//
// Pure-SwiftUI schematic diagrams for the four ch04 `shapeDiagram`
// MediaAssets. Big Sur / legacy-GPU rules honoured.

// MARK: - ch04_thermometer

/// A clinical thermometer: glass bulb of mercury at the base, a fine
/// capillary with a kink (so the reading holds), and a 35–42 °C scale.
struct ThermometerDiagram: View {
    var body: some View {
        SDFigure(tint: .red) {
            GeometryReader { geo in
                let w = geo.size.width, h = geo.size.height
                let cx = w / 2
                ZStack {
                    Group {
                        // Glass tube
                        Capsule()
                            .fill(Color.white.opacity(0.85))
                            .overlay(Capsule().stroke(DesignTokens.BrandColor.canvasTextSecondary.opacity(0.5), lineWidth: 1.5))
                            .frame(width: 16, height: h * 0.7)
                            .position(x: cx, y: h * 0.42)
                        // Mercury column rising from the bulb
                        Capsule()
                            .fill(Color.red.opacity(0.7))
                            .frame(width: 7, height: h * 0.4)
                            .position(x: cx, y: h * 0.52)
                        // Bulb
                        Circle()
                            .fill(Color.red.opacity(0.75))
                            .frame(width: 26, height: 26)
                            .position(x: cx, y: h * 0.84)
                    }
                    Group {
                        ForEach(0..<6, id: \.self) { i in
                            tick(i: i, cx: cx, h: h)
                        }
                        SDLabel(text: "Bulb", color: .red).position(x: cx + 34, y: h * 0.84)
                        SDLabel(text: "Kink").position(x: cx - 30, y: h * 0.66)
                        Rectangle().fill(DesignTokens.BrandColor.canvasText)
                            .frame(width: 10, height: 2)
                            .position(x: cx, y: h * 0.66)
                    }
                }
            }
        }
    }

    private func tick(i: Int, cx: CGFloat, h: CGFloat) -> some View {
        let value = 35 + i
        let y = h * 0.66 - CGFloat(i) * (h * 0.5 / 6)
        return HStack(spacing: 3) {
            Rectangle().fill(DesignTokens.BrandColor.canvasTextSecondary).frame(width: 6, height: 1.5)
            Text("\(value)")
                .font(.system(size: 8))
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
        }
        .position(x: cx + 26, y: y)
    }
}

// MARK: - ch04_three_modes

/// The three ways heat travels: conduction (through a solid), convection
/// (circulating fluid) and radiation (rays across empty space).
struct ThreeModesDiagram: View {
    var body: some View {
        SDFigure(tint: .orange) {
            HStack(spacing: 8) {
                conduction
                convection
                radiation
            }
        }
    }

    private var conduction: some View {
        VStack(spacing: 5) {
            Text("Conduction").font(.system(size: 10, weight: .bold)).foregroundColor(DesignTokens.BrandColor.canvasText)
            ZStack {
                Capsule().fill(Color.compatBrown.opacity(0.4)).frame(width: 60, height: 16)
                HStack(spacing: 4) {
                    ForEach(0..<3, id: \.self) { i in
                        Circle().fill(Color.red.opacity(0.7 - Double(i) * 0.18)).frame(width: 8, height: 8)
                    }
                }
            }
            SDLabel(text: "through metal")
        }
    }

    private var convection: some View {
        VStack(spacing: 5) {
            Text("Convection").font(.system(size: 10, weight: .bold)).foregroundColor(DesignTokens.BrandColor.canvasText)
            ZStack {
                RoundedRectangle(cornerRadius: 4).fill(Color.compatBlue.opacity(0.25)).frame(width: 54, height: 40)
                Image(systemName: SFSymbolCompat.name("arrow.triangle.2.circlepath"))
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(Color.compatBlue)
            }
            SDLabel(text: "in water / air", color: Color.compatBlue)
        }
    }

    private var radiation: some View {
        VStack(spacing: 5) {
            Text("Radiation").font(.system(size: 10, weight: .bold)).foregroundColor(DesignTokens.BrandColor.canvasText)
            ZStack {
                ForEach(0..<8, id: \.self) { i in
                    Rectangle().fill(Color.orange.opacity(0.6))
                        .frame(width: 2, height: 16)
                        .offset(y: -16)
                        .rotationEffect(.degrees(Double(i) * 45))
                }
                Circle().fill(Color.orange.opacity(0.8)).frame(width: 22, height: 22)
            }
            .frame(height: 40)
            SDLabel(text: "rays / no medium", color: .orange)
        }
    }
}

// MARK: - ch04_thermos_flask

/// Why a vacuum flask keeps drinks hot or cold: a double glass wall with a
/// vacuum (stops conduction & convection), silvered surfaces (stop radiation)
/// and an insulating stopper.
struct ThermosFlaskDiagram: View {
    var body: some View {
        SDFigure(tint: Color.compatTeal) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12).fill(Color.compatTeal.opacity(0.18))
                        .frame(width: 96, height: 150)
                    RoundedRectangle(cornerRadius: 9).strokeBorder(DesignTokens.BrandColor.canvasTextSecondary.opacity(0.6), lineWidth: 6)
                        .frame(width: 78, height: 128)            // double wall + vacuum gap
                    RoundedRectangle(cornerRadius: 6).fill(Color.compatBlue.opacity(0.35))
                        .frame(width: 54, height: 108)            // hot drink
                    RoundedRectangle(cornerRadius: 4).fill(Color.compatBrown.opacity(0.6))
                        .frame(width: 60, height: 18).offset(y: -76) // stopper
                }
                VStack(alignment: .leading, spacing: 8) {
                    SDLabel(text: "Stopper — stops convection", color: Color.compatBrown)
                    SDLabel(text: "Vacuum gap — stops conduction")
                    SDLabel(text: "Silvered walls — stop radiation")
                    SDLabel(text: "Drink stays hot / cold", color: Color.compatBlue)
                }
            }
        }
    }
}

// MARK: - ch04_sea_breeze

/// The sea breeze: by day the land heats faster than the sea, warm air rises
/// over the land, and cool air flows in from the sea to take its place.
struct SeaBreezeDiagram: View {
    var body: some View {
        SDFigure(tint: Color.compatBlue) {
            GeometryReader { geo in
                let w = geo.size.width, h = geo.size.height
                ZStack {
                    Group {
                        // Sun
                        Circle().fill(Color.orange.opacity(0.8)).frame(width: 26, height: 26)
                            .position(x: w * 0.18, y: h * 0.16)
                        // Sea (left) and land (right)
                        Rectangle().fill(Color.compatBlue.opacity(0.35))
                            .frame(width: w * 0.5, height: h * 0.3)
                            .position(x: w * 0.25, y: h * 0.82)
                        Rectangle().fill(Color.compatBrown.opacity(0.5))
                            .frame(width: w * 0.5, height: h * 0.3)
                            .position(x: w * 0.75, y: h * 0.82)
                    }
                    Group {
                        // Warm air rising over land
                        Image(systemName: SFSymbolCompat.name("arrow.up"))
                            .font(.system(size: 20, weight: .bold)).foregroundColor(.red.opacity(0.7))
                            .position(x: w * 0.75, y: h * 0.5)
                        // Cool sea breeze flowing toward land
                        Image(systemName: SFSymbolCompat.name("arrow.right"))
                            .font(.system(size: 20, weight: .bold)).foregroundColor(Color.compatBlue)
                            .position(x: w * 0.45, y: h * 0.62)
                        SDLabel(text: "Sea", color: Color.compatBlue).position(x: w * 0.22, y: h * 0.82)
                        SDLabel(text: "Land (warmer)", color: Color.compatBrown).position(x: w * 0.75, y: h * 0.82)
                        SDLabel(text: "Cool breeze", color: Color.compatBlue).position(x: w * 0.42, y: h * 0.5)
                    }
                }
            }
        }
    }
}
