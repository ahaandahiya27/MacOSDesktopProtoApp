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
            VStack(spacing: 8) {
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
        Group {
            // Toilet pan
            Ellipse().fill(.white.opacity(0.9)).overlay(Ellipse().stroke(DesignTokens.BrandColor.canvasTextSecondary.opacity(0.5), lineWidth: 1.5))
                .frame(width: 34, height: 20).position(x: w / 2, y: h * 0.18)
            // Two pits
            pit(x: w * 0.3, h: h, label: "Pit in use", active: true)
            pit(x: w * 0.7, h: h, label: "Resting → compost", active: false)
            // Y junction
            Path { p in
                p.move(to: CGPoint(x: w / 2, y: h * 0.28))
                p.addLine(to: CGPoint(x: w * 0.3, y: h * 0.5))
                p.move(to: CGPoint(x: w / 2, y: h * 0.28))
                p.addLine(to: CGPoint(x: w * 0.7, y: h * 0.5))
            }.stroke(Color.compatBrown.opacity(0.6), lineWidth: 4)
        }
    }

    private func pit(x: CGFloat, h: CGFloat, label: String, active: Bool) -> some View {
        VStack(spacing: 4) {
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.compatBrown.opacity(active ? 0.5 : 0.25))
                .overlay(RoundedRectangle(cornerRadius: 6).strokeBorder(Color.compatBrown.opacity(0.6), lineWidth: 1.5))
                .frame(width: 56, height: 44)
            SDLabel(text: label, color: Color.compatBrown)
        }
        .position(x: x, y: h * 0.7)
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
        Group {
            // Digester tank with dome
            Rectangle().fill(Color.compatBrown.opacity(0.35)).frame(width: w * 0.4, height: h * 0.4).position(x: w / 2, y: h * 0.62)
            DomeShape().fill(.green.opacity(0.3))
                .overlay(DomeShape().stroke(.green.opacity(0.6), lineWidth: 2))
                .frame(width: w * 0.4, height: h * 0.3).position(x: w / 2, y: h * 0.4)
            // Gas outlet pipe
            Rectangle().fill(.green.opacity(0.6)).frame(width: 6, height: h * 0.18).position(x: w / 2, y: h * 0.18)
        }
    }

    private func gasLabels(w: CGFloat, h: CGFloat) -> some View {
        Group {
            Image(systemName: SFSymbolCompat.name("flame.fill"))
                .font(.system(size: 16)).foregroundColor(.orange).position(x: w / 2, y: h * 0.1)
            SDLabel(text: "Biogas (methane)", color: .green).position(x: w * 0.72, y: h * 0.22)
            SDLabel(text: "Dung + waste", color: Color.compatBrown).position(x: w / 2, y: h * 0.7)
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
        Group {
            // Tank
            Rectangle().stroke(DesignTokens.BrandColor.canvasText.opacity(0.6), lineWidth: 2)
                .frame(width: w * 0.7, height: h * 0.5).position(x: w / 2, y: h * 0.5)
            // Layers: scum (top), liquid (mid), sludge (bottom)
            layer(Color.compatBrown, w: w * 0.68, h: h * 0.12, x: w / 2, y: h * 0.3)
            layer(Color.compatBlue, w: w * 0.68, h: h * 0.2, x: w / 2, y: h * 0.5)
            layer(DesignTokens.BrandColor.canvasTextSecondary, w: w * 0.68, h: h * 0.12, x: w / 2, y: h * 0.68)
        }
    }

    private func tankLabels(w: CGFloat, h: CGFloat) -> some View {
        Group {
            SDLabel(text: "Scum (floats)", color: Color.compatBrown).position(x: w / 2, y: h * 0.3)
            SDLabel(text: "Liquid → out", color: Color.compatBlue).position(x: w / 2, y: h * 0.5)
            SDLabel(text: "Sludge (sinks)").position(x: w / 2, y: h * 0.68)
        }
    }

    private func layer(_ c: Color, w: CGFloat, h: CGFloat, x: CGFloat, y: CGFloat) -> some View {
        Rectangle().fill(c.opacity(0.4)).frame(width: w, height: h).position(x: x, y: y)
    }
}
