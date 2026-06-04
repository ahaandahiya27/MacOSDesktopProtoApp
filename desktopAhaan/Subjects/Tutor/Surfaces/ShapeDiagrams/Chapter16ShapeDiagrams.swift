import SwiftUI

// MARK: - Chapter 16 shape diagrams  (Water: A Precious Resource)
//
// Pure-SwiftUI schematic diagrams for the four ch16 `shapeDiagram`
// MediaAssets. Big Sur / legacy-GPU rules honoured.

// MARK: - ch16_water_cycle

/// The water cycle: the sun evaporates water from seas and lakes; it rises,
/// cools and condenses into clouds; it falls again as rain or snow and
/// collects back in rivers and seas — round and round.
struct WaterCycleDiagram: View {
    var body: some View {
        SDFigure(tint: Color.compatBlue) {
            GeometryReader { geo in
                content(w: geo.size.width, h: geo.size.height)
            }
        }
    }
    // Body split into typed helpers so the Swift 5.5 type-checker on the
    // Big-Sur iMac never solves one deep GeometryReader→ZStack result-builder
    // closure full of inline CGFloat coordinate math in a single pass.
    private func content(w: CGFloat, h: CGFloat) -> some View {
        ZStack {
            scene(w: w, h: h)
            labels(w: w, h: h)
        }
    }
    private func scene(w: CGFloat, h: CGFloat) -> some View {
        Group {
            Circle().fill(.orange.opacity(0.7)).frame(width: 24, height: 24).position(x: w * 0.14, y: h * 0.16)
            CloudShape16().fill(.white.opacity(0.9)).frame(width: 70, height: 28).position(x: w * 0.6, y: h * 0.2)
            // Sea
            Rectangle().fill(Color.compatBlue.opacity(0.35)).frame(width: w, height: h * 0.22).position(x: w / 2, y: h * 0.9)
        }
    }
    private func labels(w: CGFloat, h: CGFloat) -> some View {
        Group {
            Image(systemName: SFSymbolCompat.name("arrow.up"))
                .font(.system(size: 16, weight: .bold)).foregroundColor(.orange).position(x: w * 0.22, y: h * 0.55)
            // Rain
            ForEach(0..<4, id: \.self) { i in
                Capsule().fill(Color.compatBlue.opacity(0.6)).frame(width: 2, height: 9)
                    .position(x: w * (0.52 + Double(i) * 0.05), y: h * 0.5)
            }
            SDLabel(text: "Evaporation", color: .orange).position(x: w * 0.2, y: h * 0.4)
            SDLabel(text: "Condensation → clouds").position(x: w * 0.6, y: h * 0.36)
            SDLabel(text: "Rain", color: Color.compatBlue).position(x: w * 0.58, y: h * 0.62)
            SDLabel(text: "Collects in sea", color: Color.compatBlue).position(x: w / 2, y: h * 0.92)
        }
    }
}

/// A small cloud (three bumps).
private struct CloudShape16: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.addEllipse(in: CGRect(x: rect.minX, y: rect.midY, width: rect.width * 0.5, height: rect.height * 0.6))
        p.addEllipse(in: CGRect(x: rect.midX - rect.width * 0.2, y: rect.minY, width: rect.width * 0.5, height: rect.height))
        p.addEllipse(in: CGRect(x: rect.midX, y: rect.midY * 0.7, width: rect.width * 0.55, height: rect.height * 0.7))
        return p
    }
}

// MARK: - ch16_aquifer

/// Groundwater: rain soaks through permeable soil and rock until it sits on a
/// hard impermeable layer. The top of this saturated zone is the water table;
/// a well must reach below it.
struct AquiferDiagram: View {
    var body: some View {
        SDFigure(tint: Color.compatBrown) {
            GeometryReader { geo in
                content(w: geo.size.width, h: geo.size.height)
            }
        }
    }
    // Body split into typed helpers so the Swift 5.5 type-checker on the
    // Big-Sur iMac never solves one deep GeometryReader→ZStack result-builder
    // closure full of inline CGFloat coordinate math in a single pass.
    private func content(w: CGFloat, h: CGFloat) -> some View {
        ZStack {
            layers(w: w, h: h)
            labels(w: w, h: h)
        }
    }
    private func layers(w: CGFloat, h: CGFloat) -> some View {
        Group {
            // Layers
            Rectangle().fill(Color.compatBrown.opacity(0.35)).frame(width: w, height: h * 0.3).position(x: w / 2, y: h * 0.2)
            Rectangle().fill(Color.compatBlue.opacity(0.3)).frame(width: w, height: h * 0.32).position(x: w / 2, y: h * 0.55)
            Rectangle().fill(DesignTokens.BrandColor.canvasTextSecondary.opacity(0.4)).frame(width: w, height: h * 0.2).position(x: w / 2, y: h * 0.85)
            // Water table line
            Rectangle().fill(Color.compatBlue.opacity(0.8)).frame(width: w, height: 2).position(x: w / 2, y: h * 0.4)
            // Well
            Rectangle().fill(DesignTokens.BrandColor.canvasText.opacity(0.4)).frame(width: 12, height: h * 0.6).position(x: w * 0.78, y: h * 0.45)
        }
    }
    private func labels(w: CGFloat, h: CGFloat) -> some View {
        Group {
            SDLabel(text: "Permeable soil", color: Color.compatBrown).position(x: w * 0.28, y: h * 0.2)
            SDLabel(text: "Water table", color: Color.compatBlue).position(x: w * 0.3, y: h * 0.4)
            SDLabel(text: "Aquifer (saturated)", color: Color.compatBlue).position(x: w * 0.34, y: h * 0.58)
            SDLabel(text: "Impermeable rock").position(x: w * 0.4, y: h * 0.85)
            SDLabel(text: "Well").position(x: w * 0.78, y: h * 0.12)
        }
    }
}

// MARK: - ch16_drip_system

/// Drip irrigation: water trickles drop by drop from narrow pipes straight to
/// each plant's roots — the most water-saving way to irrigate.
struct DripSystemDiagram: View {
    var body: some View {
        SDFigure(tint: Color.compatBlue) {
            GeometryReader { geo in
                let w = geo.size.width, h = geo.size.height
                ZStack {
                    Group {
                        // Main pipe
                        Capsule().fill(Color.compatBlue.opacity(0.5)).frame(width: w * 0.8, height: 10).position(x: w / 2, y: h * 0.28)
                        // Drips + plants
                        ForEach(0..<4, id: \.self) { i in
                            dripColumn(i: i, w: w, h: h)
                        }
                    }
                    SDLabel(text: "Drips straight to roots — saves water", color: Color.compatBlue).position(x: w / 2, y: h * 0.92)
                }
            }
        }
    }

    private func dripColumn(i: Int, w: CGFloat, h: CGFloat) -> some View {
        let x = w * (0.2 + CGFloat(i) * 0.2)
        return ZStack {
            Capsule().fill(Color.compatBlue.opacity(0.7)).frame(width: 4, height: 8).position(x: x, y: h * 0.42)
            Image(systemName: SFSymbolCompat.name("leaf.fill"))
                .font(.system(size: 15)).foregroundColor(.green).position(x: x, y: h * 0.62)
        }
    }
}

// MARK: - ch16_baori

/// A baori (stepwell): a staircase cut deep into the ground so people could
/// always walk down to the water however far its level dropped — traditional
/// rainwater harvesting.
struct BaoriDiagram: View {
    var body: some View {
        SDFigure(tint: Color.compatBrown) {
            GeometryReader { geo in
                let w = geo.size.width, h = geo.size.height
                ZStack {
                    Group {
                        // Ground + descending steps
                        ForEach(0..<5, id: \.self) { i in
                            stair(i: i, w: w, h: h)
                        }
                        // Water at the bottom
                        Rectangle().fill(Color.compatBlue.opacity(0.5))
                            .frame(width: w * 0.36, height: h * 0.22).position(x: w * 0.74, y: h * 0.78)
                    }
                    Group {
                        SDLabel(text: "Steps down", color: Color.compatBrown).position(x: w * 0.28, y: h * 0.2)
                        SDLabel(text: "Stored water", color: Color.compatBlue).position(x: w * 0.74, y: h * 0.78)
                    }
                }
            }
        }
    }

    private func stair(i: Int, w: CGFloat, h: CGFloat) -> some View {
        let x = w * (0.12 + CGFloat(i) * 0.12)
        let y = h * (0.32 + CGFloat(i) * 0.12)
        return Rectangle().fill(Color.compatBrown.opacity(0.5))
            .frame(width: w * 0.12, height: 12).position(x: x, y: y)
    }
}
