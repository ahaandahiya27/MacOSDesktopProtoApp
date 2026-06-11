import SwiftUI

// MARK: - Chapter 18 shape diagrams  (Wastewater Story)
//
// Pure-SwiftUI schematic diagrams for the four ch18 `shapeDiagram`
// MediaAssets. Big Sur / legacy-GPU rules honoured.

// MARK: - ch18_wwtp_flow

/// How a sewage treatment plant cleans dirty water step by step: bar screens
/// catch big solids, grit settles out, air is bubbled through to grow helpful
/// microbes, then the sludge settles, leaving cleaner water.
struct WWTPFlowDiagram: View {
    private let steps = ["Bar screen", "Grit tank", "Aeration", "Settling", "Clean water"]
    var body: some View {
        SDFigure(tint: Color.compatBlue) {
            VStack(spacing: DesignTokens.Spacing.sm) {
                SDLabel(text: "Dirty water in → cleaner water out", color: Color.compatBlue)
                HStack(spacing: 3) {
                    ForEach(0..<steps.count, id: \.self) { i in
                        stepNode(steps[i], last: i == steps.count - 1, clean: i == steps.count - 1)
                    }
                }
            }
        }
    }

    private func stepNode(_ title: String, last: Bool, clean: Bool) -> some View {
        HStack(spacing: 3) {
            VStack(spacing: 3) {
                RoundedRectangle(cornerRadius: 4)
                    .fill((clean ? Color.compatBlue : DesignTokens.BrandColor.canvasTextSecondary).opacity(clean ? 0.4 : 0.25))
                    .overlay(RoundedRectangle(cornerRadius: 4).strokeBorder(Color.compatBlue.opacity(0.5), lineWidth: 1))
                    .frame(width: 40, height: 30)
                Text(title).font(.system(size: 8, weight: .semibold)).foregroundColor(DesignTokens.BrandColor.canvasText).fixedSize()
            }
            if !last {
                Image(systemName: SFSymbolCompat.name("arrow.right"))
                    .font(.system(size: 10, weight: .bold)).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
            }
        }
    }
}

// MARK: - ch18_sulabh_toilet

/// A twin-pit toilet: waste goes to one covered pit while the other rests and
/// its contents turn into safe compost — low-cost sanitation with no sewer.
struct SulabhToiletDiagram: View {
    var body: some View {
        SDFigure(tint: Color.compatBrown) {
            GeometryReader { geo in
                content(w: geo.size.width, h: geo.size.height)
            }
        }
    }

    // Body split into typed helpers so the Swift 5.5 type-checker on the
    // Big-Sur iMac (Xcode 13.2.1) never has to solve one deep
    // GeometryReader→ZStack result-builder closure full of inline CGFloat
    // coordinate math in a single pass — that recursion overflows the
    // compiler stack → `Segmentation fault: 11`.
    private func content(w: CGFloat, h: CGFloat) -> some View {
        ZStack {
            pitsAndPlumbing(w: w, h: h)
        }
    }

    private func pitsAndPlumbing(w: CGFloat, h: CGFloat) -> some View {
        let centerX: CGFloat = w / 2
        let panY: CGFloat = h * 0.18
        let leftPitX: CGFloat = w * 0.3
        let rightPitX: CGFloat = w * 0.7
        let junctionTopY: CGFloat = h * 0.28
        let junctionBottomY: CGFloat = h * 0.5
        return Group {
            // Toilet pan
            Ellipse().fill(.white.opacity(0.9)).overlay(Ellipse().stroke(DesignTokens.BrandColor.canvasTextSecondary.opacity(0.5), lineWidth: 1.5))
                .frame(width: 34, height: 20).position(x: centerX, y: panY)
            // Two pits
            pit(x: leftPitX, h: h, label: "Pit in use", active: true)
            pit(x: rightPitX, h: h, label: "Resting → compost", active: false)
            // Y junction
            Path { p in
                p.move(to: CGPoint(x: centerX, y: junctionTopY))
                p.addLine(to: CGPoint(x: leftPitX, y: junctionBottomY))
                p.move(to: CGPoint(x: centerX, y: junctionTopY))
                p.addLine(to: CGPoint(x: rightPitX, y: junctionBottomY))
            }.stroke(Color.compatBrown.opacity(0.6), lineWidth: 4)
        }
    }

    private func pit(x: CGFloat, h: CGFloat, label: String, active: Bool) -> some View {
        let pitY: CGFloat = h * 0.7
        return VStack(spacing: DesignTokens.Spacing.xs) {
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.compatBrown.opacity(active ? 0.5 : 0.25))
                .overlay(RoundedRectangle(cornerRadius: 6).strokeBorder(Color.compatBrown.opacity(0.6), lineWidth: 1.5))
                .frame(width: 56, height: 44)
            SDLabel(text: label, color: Color.compatBrown)
        }
        .position(x: x, y: pitY)
    }
}

// MARK: - ch18_biogas_plant

/// A biogas plant: animal dung and waste rot in a sealed dome without air, and
/// the bacteria give off biogas (mostly methane) for cooking, leaving slurry
/// that makes good manure.
struct BiogasPlantDiagram: View {
    var body: some View {
        SDFigure(tint: .green) {
            GeometryReader { geo in
                content(w: geo.size.width, h: geo.size.height)
            }
        }
    }

    // Body split into typed helpers so the Swift 5.5 type-checker on the
    // Big-Sur iMac (Xcode 13.2.1) never has to solve one deep
    // GeometryReader→ZStack result-builder closure full of inline CGFloat
    // coordinate math in a single pass — that recursion overflows the
    // compiler stack → `Segmentation fault: 11`.
    private func content(w: CGFloat, h: CGFloat) -> some View {
        ZStack {
            digester(w: w, h: h)
            gasLabels(w: w, h: h)
        }
    }

    private func digester(w: CGFloat, h: CGFloat) -> some View {
        let centerX: CGFloat = w / 2
        let tankW: CGFloat = w * 0.4
        let tankH: CGFloat = h * 0.4
        let tankY: CGFloat = h * 0.62
        let domeW: CGFloat = w * 0.4
        let domeH: CGFloat = h * 0.3
        let domeY: CGFloat = h * 0.4
        let pipeH: CGFloat = h * 0.18
        let pipeY: CGFloat = h * 0.18
        return Group {
            // Digester tank with dome
            Rectangle().fill(Color.compatBrown.opacity(0.35)).frame(width: tankW, height: tankH).position(x: centerX, y: tankY)
            DomeShape().fill(.green.opacity(0.3))
                .overlay(DomeShape().stroke(.green.opacity(0.6), lineWidth: 2))
                .frame(width: domeW, height: domeH).position(x: centerX, y: domeY)
            // Gas outlet pipe
            Rectangle().fill(.green.opacity(0.6)).frame(width: 6, height: pipeH).position(x: centerX, y: pipeY)
        }
    }

    private func gasLabels(w: CGFloat, h: CGFloat) -> some View {
        let centerX: CGFloat = w / 2
        let flameY: CGFloat = h * 0.1
        let biogasLabelX: CGFloat = w * 0.72
        let biogasLabelY: CGFloat = h * 0.22
        let dungLabelY: CGFloat = h * 0.7
        return Group {
            Image(systemName: SFSymbolCompat.name("flame.fill"))
                .font(.system(size: 16)).foregroundColor(.orange).position(x: centerX, y: flameY)
            SDLabel(text: "Biogas (methane)", color: .green).position(x: biogasLabelX, y: biogasLabelY)
            SDLabel(text: "Dung + waste", color: Color.compatBrown).position(x: centerX, y: dungLabelY)
        }
    }
}

/// A half-dome (digester gas holder).
private struct DomeShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        p.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.maxY),
                       control: CGPoint(x: rect.midX, y: rect.minY - rect.height * 0.3))
        p.closeSubpath()
        return p
    }
}

// MARK: - ch18_septic_tank

/// A septic tank for homes without a sewer: waste water settles so solids sink
/// as sludge, grease floats as scum, and the clearer liquid in the middle
/// flows out to a soak pit.
struct SepticTankDiagram: View {
    var body: some View {
        SDFigure(tint: Color.compatBrown) {
            GeometryReader { geo in
                content(w: geo.size.width, h: geo.size.height)
            }
        }
    }

    // Body split into typed helpers so the Swift 5.5 type-checker on the
    // Big-Sur iMac (Xcode 13.2.1) never has to solve one deep
    // GeometryReader→ZStack result-builder closure full of inline CGFloat
    // coordinate math in a single pass — that recursion overflows the
    // compiler stack → `Segmentation fault: 11`.
    private func content(w: CGFloat, h: CGFloat) -> some View {
        ZStack {
            tankLayers(w: w, h: h)
            tankLabels(w: w, h: h)
        }
    }

    private func tankLayers(w: CGFloat, h: CGFloat) -> some View {
        let centerX: CGFloat = w / 2
        let tankW: CGFloat = w * 0.7
        let tankH: CGFloat = h * 0.5
        let tankY: CGFloat = h * 0.5
        let layerW: CGFloat = w * 0.68
        let scumH: CGFloat = h * 0.12
        let scumY: CGFloat = h * 0.3
        let liquidH: CGFloat = h * 0.2
        let liquidY: CGFloat = h * 0.5
        let sludgeH: CGFloat = h * 0.12
        let sludgeY: CGFloat = h * 0.68
        return Group {
            // Tank
            Rectangle().stroke(DesignTokens.BrandColor.canvasText.opacity(0.6), lineWidth: 2)
                .frame(width: tankW, height: tankH).position(x: centerX, y: tankY)
            // Layers: scum (top), liquid (mid), sludge (bottom)
            layer(Color.compatBrown, w: layerW, h: scumH, x: centerX, y: scumY)
            layer(Color.compatBlue, w: layerW, h: liquidH, x: centerX, y: liquidY)
            layer(DesignTokens.BrandColor.canvasTextSecondary, w: layerW, h: sludgeH, x: centerX, y: sludgeY)
        }
    }

    private func tankLabels(w: CGFloat, h: CGFloat) -> some View {
        let centerX: CGFloat = w / 2
        let scumY: CGFloat = h * 0.3
        let liquidY: CGFloat = h * 0.5
        let sludgeY: CGFloat = h * 0.68
        return Group {
            SDLabel(text: "Scum (floats)", color: Color.compatBrown).position(x: centerX, y: scumY)
            SDLabel(text: "Liquid → out", color: Color.compatBlue).position(x: centerX, y: liquidY)
            SDLabel(text: "Sludge (sinks)").position(x: centerX, y: sludgeY)
        }
    }

    private func layer(_ c: Color, w: CGFloat, h: CGFloat, x: CGFloat, y: CGFloat) -> some View {
        Rectangle().fill(c.opacity(0.4)).frame(width: w, height: h).position(x: x, y: y)
    }
}
