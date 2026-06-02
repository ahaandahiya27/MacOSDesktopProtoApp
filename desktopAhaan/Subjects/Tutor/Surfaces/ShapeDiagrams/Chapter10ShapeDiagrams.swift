import SwiftUI

// MARK: - Chapter 10 shape diagrams  (Respiration in Organisms)
//
// Pure-SwiftUI schematic diagrams for the four ch10 `shapeDiagram`
// MediaAssets. Big Sur / legacy-GPU rules honoured.

// MARK: - ch10_lung_anatomy

/// The breathing apparatus: air enters the windpipe (trachea), splits at the
/// bronchi into the two lungs, and the dome-shaped diaphragm below pulls the
/// air in.
struct LungAnatomyDiagram: View {
    var body: some View {
        SDFigure(tint: Color.compatBlue) {
            GeometryReader { geo in
                let w = geo.size.width, h = geo.size.height
                let cx = w / 2
                ZStack {
                    Group {
                        // Trachea
                        Capsule().fill(Color.compatBlue.opacity(0.4)).frame(width: 12, height: h * 0.3)
                            .position(x: cx, y: h * 0.2)
                        // Bronchi
                        Path { p in
                            p.move(to: CGPoint(x: cx, y: h * 0.34))
                            p.addLine(to: CGPoint(x: cx - w * 0.16, y: h * 0.46))
                            p.move(to: CGPoint(x: cx, y: h * 0.34))
                            p.addLine(to: CGPoint(x: cx + w * 0.16, y: h * 0.46))
                        }.stroke(Color.compatBlue.opacity(0.5), lineWidth: 6)
                        // Two lungs
                        LungShape(flip: false).fill(.pink.opacity(0.4))
                            .frame(width: w * 0.28, height: h * 0.45).position(x: cx - w * 0.17, y: h * 0.55)
                        LungShape(flip: true).fill(.pink.opacity(0.4))
                            .frame(width: w * 0.28, height: h * 0.45).position(x: cx + w * 0.17, y: h * 0.55)
                    }
                    Group {
                        // Diaphragm dome
                        Path { p in
                            p.move(to: CGPoint(x: cx - w * 0.32, y: h * 0.84))
                            p.addQuadCurve(to: CGPoint(x: cx + w * 0.32, y: h * 0.84),
                                           control: CGPoint(x: cx, y: h * 0.72))
                        }.stroke(Color.compatBrown.opacity(0.6), lineWidth: 3)
                        SDLabel(text: "Trachea", color: Color.compatBlue).position(x: cx + 44, y: h * 0.18)
                        SDLabel(text: "Lungs", color: .pink).position(x: cx, y: h * 0.55)
                        SDLabel(text: "Diaphragm", color: Color.compatBrown).position(x: cx, y: h * 0.9)
                    }
                }
            }
        }
    }
}

/// One lung lobe — a rounded sac, mirrored for the other side.
private struct LungShape: Shape {
    let flip: Bool
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let r = rect
        p.move(to: CGPoint(x: flip ? r.minX : r.maxX, y: r.minY))
        p.addQuadCurve(to: CGPoint(x: flip ? r.maxX : r.minX, y: r.maxY),
                       control: CGPoint(x: flip ? r.maxX : r.minX, y: r.minY))
        p.addQuadCurve(to: CGPoint(x: flip ? r.minX : r.maxX, y: r.maxY * 0.95),
                       control: CGPoint(x: flip ? r.minX : r.maxX, y: r.maxY))
        p.closeSubpath()
        return p
    }
}

// MARK: - ch10_alveolus

/// Deep in the lungs, air ends in tiny balloon-like sacs — alveoli — wrapped
/// in blood capillaries, where oxygen enters the blood and carbon dioxide
/// leaves it.
struct AlveolusDiagram: View {
    var body: some View {
        SDFigure(tint: .pink) {
            GeometryReader { geo in
                let w = geo.size.width, h = geo.size.height
                let cx = w * 0.42, cy = h * 0.5
                ZStack {
                    Group {
                        // Cluster of alveolar sacs
                        ForEach(0..<5, id: \.self) { i in
                            alveolarSac(i: i, cx: cx, cy: cy)
                        }
                        // Capillary wrapping
                        Capsule().stroke(.red.opacity(0.6), lineWidth: 2)
                            .frame(width: w * 0.7, height: h * 0.55).position(x: cx, y: cy)
                    }
                    Group {
                        Image(systemName: SFSymbolCompat.name("arrow.right"))
                            .font(.system(size: 13, weight: .bold)).foregroundColor(.red)
                            .position(x: w * 0.78, y: h * 0.36)
                        Image(systemName: SFSymbolCompat.name("arrow.left"))
                            .font(.system(size: 13, weight: .bold)).foregroundColor(Color.compatBlue)
                            .position(x: w * 0.78, y: h * 0.62)
                        SDLabel(text: "O₂ in", color: .red).position(x: w * 0.9, y: h * 0.36)
                        SDLabel(text: "CO₂ out", color: Color.compatBlue).position(x: w * 0.9, y: h * 0.62)
                        SDLabel(text: "Alveoli", color: .pink).position(x: cx, y: h * 0.92)
                    }
                }
            }
        }
    }

    private func alveolarSac(i: Int, cx: CGFloat, cy: CGFloat) -> some View {
        let col = CGFloat(i % 3 - 1)
        let row = CGFloat(i / 3)
        let x = cx + col * 28
        let y = cy + row * 28 - 14
        return Circle().fill(.pink.opacity(0.3))
            .overlay(Circle().stroke(.pink.opacity(0.6), lineWidth: 1.5))
            .frame(width: 30, height: 30)
            .position(x: x, y: y)
    }
}

// MARK: - ch10_mitochondrion

/// The mitochondrion — the cell's "powerhouse": its inner membrane is folded
/// into cristae, where glucose is broken down to release energy.
struct MitochondrionDiagram: View {
    var body: some View {
        SDFigure(tint: .orange) {
            VStack(spacing: 8) {
                ZStack {
                    Capsule().fill(.orange.opacity(0.2))
                        .overlay(Capsule().strokeBorder(.orange.opacity(0.65), lineWidth: 2))
                        .frame(width: 160, height: 80)
                    CristaeShape().stroke(.orange.opacity(0.7), lineWidth: 2)
                        .frame(width: 150, height: 56)
                }
                SDLabel(text: "Folded cristae = more surface for energy release", color: .orange)
                SDLabel(text: "glucose + O₂ → CO₂ + water + ENERGY")
            }
        }
    }
}

/// A wavy inner-membrane line standing in for the cristae folds.
private struct CristaeShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let folds = 6
        let dx = rect.width / CGFloat(folds)
        p.move(to: CGPoint(x: rect.minX, y: rect.midY))
        for i in 0..<folds {
            let x = rect.minX + CGFloat(i) * dx
            p.addLine(to: CGPoint(x: x + dx / 2, y: i % 2 == 0 ? rect.minY : rect.maxY))
            p.addLine(to: CGPoint(x: x + dx, y: rect.midY))
        }
        return p
    }
}

// MARK: - ch10_gas_exchange

/// Cellular respiration in a word equation: every living cell burns glucose
/// with oxygen to release the energy it runs on, giving off carbon dioxide
/// and water.
struct GasExchangeDiagram: View {
    var body: some View {
        SDFigure(tint: .green) {
            VStack(spacing: 12) {
                HStack(spacing: 6) {
                    SDChip(text: "Glucose", color: .green)
                    SDPlus()
                    SDChip(text: "O₂", color: .red)
                    SDArrow(color: .green)
                    SDChip(text: "CO₂", color: Color.compatBlue)
                    SDPlus()
                    SDChip(text: "Water", color: Color.compatBlue)
                }
                SDChip(text: "+ ENERGY", color: .orange)
                SDLabel(text: "Aerobic respiration — happens in every cell", color: .green)
            }
        }
    }
}
