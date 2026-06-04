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
        let sunX: CGFloat = w * 0.14
        let sunY: CGFloat = h * 0.16
        let cloudX: CGFloat = w * 0.6
        let cloudY: CGFloat = h * 0.2
        let seaH: CGFloat = h * 0.22
        let midX: CGFloat = w / 2
        let seaY: CGFloat = h * 0.9
        return Group {
            Circle().fill(.orange.opacity(0.7)).frame(width: 24, height: 24).position(x: sunX, y: sunY)
            CloudShape16().fill(.white.opacity(0.9)).frame(width: 70, height: 28).position(x: cloudX, y: cloudY)
            // Sea
            Rectangle().fill(Color.compatBlue.opacity(0.35)).frame(width: w, height: seaH).position(x: midX, y: seaY)
        }
    }
    private func labels(w: CGFloat, h: CGFloat) -> some View {
        let arrowX: CGFloat = w * 0.22
        let arrowY: CGFloat = h * 0.55
        let rainY: CGFloat = h * 0.5
        let evapX: CGFloat = w * 0.2
        let evapY: CGFloat = h * 0.4
        let condX: CGFloat = w * 0.6
        let condY: CGFloat = h * 0.36
        let rainLabelX: CGFloat = w * 0.58
        let rainLabelY: CGFloat = h * 0.62
        let midX: CGFloat = w / 2
        let seaLabelY: CGFloat = h * 0.92
        return Group {
            Image(systemName: SFSymbolCompat.name("arrow.up"))
                .font(.system(size: 16, weight: .bold)).foregroundColor(.orange).position(x: arrowX, y: arrowY)
            // Rain
            ForEach(0..<4, id: \.self) { i in
                rainDrop(i: i, w: w, rainY: rainY)
            }
            SDLabel(text: "Evaporation", color: .orange).position(x: evapX, y: evapY)
            SDLabel(text: "Condensation → clouds").position(x: condX, y: condY)
            SDLabel(text: "Rain", color: Color.compatBlue).position(x: rainLabelX, y: rainLabelY)
            SDLabel(text: "Collects in sea", color: Color.compatBlue).position(x: midX, y: seaLabelY)
        }
    }
    private func rainDrop(i: Int, w: CGFloat, rainY: CGFloat) -> some View {
        let dropX: CGFloat = w * (0.52 + Double(i) * 0.05)
        return Capsule().fill(Color.compatBlue.opacity(0.6)).frame(width: 2, height: 9)
            .position(x: dropX, y: rainY)
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
        let midX: CGFloat = w / 2
        let soilH: CGFloat = h * 0.3
        let soilY: CGFloat = h * 0.2
        let aquiferH: CGFloat = h * 0.32
        let aquiferY: CGFloat = h * 0.55
        let rockH: CGFloat = h * 0.2
        let rockY: CGFloat = h * 0.85
        let tableY: CGFloat = h * 0.4
        let wellH: CGFloat = h * 0.6
        let wellX: CGFloat = w * 0.78
        let wellY: CGFloat = h * 0.45
        return Group {
            // Layers
            Rectangle().fill(Color.compatBrown.opacity(0.35)).frame(width: w, height: soilH).position(x: midX, y: soilY)
            Rectangle().fill(Color.compatBlue.opacity(0.3)).frame(width: w, height: aquiferH).position(x: midX, y: aquiferY)
            Rectangle().fill(DesignTokens.BrandColor.canvasTextSecondary.opacity(0.4)).frame(width: w, height: rockH).position(x: midX, y: rockY)
            // Water table line
            Rectangle().fill(Color.compatBlue.opacity(0.8)).frame(width: w, height: 2).position(x: midX, y: tableY)
            // Well
            Rectangle().fill(DesignTokens.BrandColor.canvasText.opacity(0.4)).frame(width: 12, height: wellH).position(x: wellX, y: wellY)
        }
    }
    private func labels(w: CGFloat, h: CGFloat) -> some View {
        let soilLabelX: CGFloat = w * 0.28
        let soilLabelY: CGFloat = h * 0.2
        let tableLabelX: CGFloat = w * 0.3
        let tableLabelY: CGFloat = h * 0.4
        let aquiferLabelX: CGFloat = w * 0.34
        let aquiferLabelY: CGFloat = h * 0.58
        let rockLabelX: CGFloat = w * 0.4
        let rockLabelY: CGFloat = h * 0.85
        let wellLabelX: CGFloat = w * 0.78
        let wellLabelY: CGFloat = h * 0.12
        return Group {
            SDLabel(text: "Permeable soil", color: Color.compatBrown).position(x: soilLabelX, y: soilLabelY)
            SDLabel(text: "Water table", color: Color.compatBlue).position(x: tableLabelX, y: tableLabelY)
            SDLabel(text: "Aquifer (saturated)", color: Color.compatBlue).position(x: aquiferLabelX, y: aquiferLabelY)
            SDLabel(text: "Impermeable rock").position(x: rockLabelX, y: rockLabelY)
            SDLabel(text: "Well").position(x: wellLabelX, y: wellLabelY)
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
                content(w: geo.size.width, h: geo.size.height)
            }
        }
    }

    private func content(w: CGFloat, h: CGFloat) -> some View {
        let pipeW: CGFloat = w * 0.8
        let midX: CGFloat = w / 2
        let pipeY: CGFloat = h * 0.28
        let captionY: CGFloat = h * 0.92
        return ZStack {
            Group {
                // Main pipe
                Capsule().fill(Color.compatBlue.opacity(0.5)).frame(width: pipeW, height: 10).position(x: midX, y: pipeY)
                // Drips + plants
                ForEach(0..<4, id: \.self) { i in
                    dripColumn(i: i, w: w, h: h)
                }
            }
            SDLabel(text: "Drips straight to roots — saves water", color: Color.compatBlue).position(x: midX, y: captionY)
        }
    }

    private func dripColumn(i: Int, w: CGFloat, h: CGFloat) -> some View {
        let x: CGFloat = w * (0.2 + CGFloat(i) * 0.2)
        let dripY: CGFloat = h * 0.42
        let leafY: CGFloat = h * 0.62
        return ZStack {
            Capsule().fill(Color.compatBlue.opacity(0.7)).frame(width: 4, height: 8).position(x: x, y: dripY)
            Image(systemName: SFSymbolCompat.name("leaf.fill"))
                .font(.system(size: 15)).foregroundColor(.green).position(x: x, y: leafY)
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
                content(w: geo.size.width, h: geo.size.height)
            }
        }
    }

    private func content(w: CGFloat, h: CGFloat) -> some View {
        ZStack {
            stepsAndWater(w: w, h: h)
            labels(w: w, h: h)
        }
    }

    private func stepsAndWater(w: CGFloat, h: CGFloat) -> some View {
        let waterW: CGFloat = w * 0.36
        let waterH: CGFloat = h * 0.22
        let waterX: CGFloat = w * 0.74
        let waterY: CGFloat = h * 0.78
        return Group {
            // Ground + descending steps
            ForEach(0..<5, id: \.self) { i in
                stair(i: i, w: w, h: h)
            }
            // Water at the bottom
            Rectangle().fill(Color.compatBlue.opacity(0.5))
                .frame(width: waterW, height: waterH).position(x: waterX, y: waterY)
        }
    }

    private func labels(w: CGFloat, h: CGFloat) -> some View {
        let stepsLabelX: CGFloat = w * 0.28
        let stepsLabelY: CGFloat = h * 0.2
        let waterLabelX: CGFloat = w * 0.74
        let waterLabelY: CGFloat = h * 0.78
        return Group {
            SDLabel(text: "Steps down", color: Color.compatBrown).position(x: stepsLabelX, y: stepsLabelY)
            SDLabel(text: "Stored water", color: Color.compatBlue).position(x: waterLabelX, y: waterLabelY)
        }
    }

    private func stair(i: Int, w: CGFloat, h: CGFloat) -> some View {
        let x: CGFloat = w * (0.12 + CGFloat(i) * 0.12)
        let y: CGFloat = h * (0.32 + CGFloat(i) * 0.12)
        let stairW: CGFloat = w * 0.12
        return Rectangle().fill(Color.compatBrown.opacity(0.5))
            .frame(width: stairW, height: 12).position(x: x, y: y)
    }
}
