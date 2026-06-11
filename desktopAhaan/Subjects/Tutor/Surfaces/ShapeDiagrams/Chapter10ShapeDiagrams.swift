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
                content(w: geo.size.width, h: geo.size.height)
            }
        }
    }

    // Body split into typed helpers AND every coordinate pre-computed as
    // an explicit `CGFloat` local before it reaches a SwiftUI view modifier.
    // Inline `h * 0.3` / `w * 0.16` inside `.frame(...)` / `.position(...)`
    // still forces the Swift 5.5 type-checker on the Big-Sur iMac to solve
    // CGFloat * Double overloads inside a Group's @ViewBuilder closure —
    // the recursion overflows the compiler stack → `Segmentation fault: 11`.
    // Hoisting the math out makes every modifier arg a plain CGFloat ref.
    private func content(w: CGFloat, h: CGFloat) -> some View {
        let cx = w / 2
        return ZStack {
            airway(w: w, h: h, cx: cx)
            lowerParts(w: w, h: h, cx: cx)
        }
    }

    private func airway(w: CGFloat, h: CGFloat, cx: CGFloat) -> some View {
        let tracheaH: CGFloat = h * 0.3
        let tracheaY: CGFloat = h * 0.2
        let bronchiTopY: CGFloat = h * 0.34
        let bronchiBottomY: CGFloat = h * 0.46
        let bronchiSpread: CGFloat = w * 0.16
        let lungW: CGFloat = w * 0.28
        let lungH: CGFloat = h * 0.45
        let lungOffset: CGFloat = w * 0.17
        let lungY: CGFloat = h * 0.55
        let lungLeftX: CGFloat = cx - lungOffset
        let lungRightX: CGFloat = cx + lungOffset
        let bronchiLeftX: CGFloat = cx - bronchiSpread
        let bronchiRightX: CGFloat = cx + bronchiSpread
        return Group {
            Capsule().fill(Color.compatBlue.opacity(0.4))
                .frame(width: 12, height: tracheaH)
                .position(x: cx, y: tracheaY)
            Path { p in
                p.move(to: CGPoint(x: cx, y: bronchiTopY))
                p.addLine(to: CGPoint(x: bronchiLeftX, y: bronchiBottomY))
                p.move(to: CGPoint(x: cx, y: bronchiTopY))
                p.addLine(to: CGPoint(x: bronchiRightX, y: bronchiBottomY))
            }.stroke(Color.compatBlue.opacity(0.5), lineWidth: 6)
            LungShape(flip: false).fill(.pink.opacity(0.4))
                .frame(width: lungW, height: lungH)
                .position(x: lungLeftX, y: lungY)
            LungShape(flip: true).fill(.pink.opacity(0.4))
                .frame(width: lungW, height: lungH)
                .position(x: lungRightX, y: lungY)
        }
    }

    private func lowerParts(w: CGFloat, h: CGFloat, cx: CGFloat) -> some View {
        let diaphragmHalfW: CGFloat = w * 0.32
        let diaphragmY: CGFloat = h * 0.84
        let diaphragmControlY: CGFloat = h * 0.72
        let diaphragmLeftX: CGFloat = cx - diaphragmHalfW
        let diaphragmRightX: CGFloat = cx + diaphragmHalfW
        let tracheaLabelX: CGFloat = cx + 44
        let tracheaLabelY: CGFloat = h * 0.18
        let lungsLabelY: CGFloat = h * 0.55
        let diaphragmLabelY: CGFloat = h * 0.9
        return Group {
            Path { p in
                p.move(to: CGPoint(x: diaphragmLeftX, y: diaphragmY))
                p.addQuadCurve(to: CGPoint(x: diaphragmRightX, y: diaphragmY),
                               control: CGPoint(x: cx, y: diaphragmControlY))
            }.stroke(Color.compatBrown.opacity(0.6), lineWidth: 3)
            SDLabel(text: "Trachea", color: Color.compatBlue).position(x: tracheaLabelX, y: tracheaLabelY)
            SDLabel(text: "Lungs", color: .pink).position(x: cx, y: lungsLabelY)
            SDLabel(text: "Diaphragm", color: Color.compatBrown).position(x: cx, y: diaphragmLabelY)
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
                content(w: geo.size.width, h: geo.size.height)
            }
        }
    }

    // See LungAnatomyDiagram comment — same Swift 5.5 segfault class. Every
    // coordinate is hoisted to a typed `CGFloat` local so no view modifier
    // arg is an arithmetic expression.
    private func content(w: CGFloat, h: CGFloat) -> some View {
        let cx: CGFloat = w * 0.42
        let cy: CGFloat = h * 0.5
        return ZStack {
            sacCluster(w: w, h: h, cx: cx, cy: cy)
            gasLabels(w: w, h: h, cx: cx)
        }
    }

    private func sacCluster(w: CGFloat, h: CGFloat, cx: CGFloat, cy: CGFloat) -> some View {
        let capsuleW: CGFloat = w * 0.7
        let capsuleH: CGFloat = h * 0.55
        return Group {
            ForEach(0..<5, id: \.self) { i in
                alveolarSac(i: i, cx: cx, cy: cy)
            }
            Capsule().stroke(.red.opacity(0.6), lineWidth: 2)
                .frame(width: capsuleW, height: capsuleH).position(x: cx, y: cy)
        }
    }

    private func gasLabels(w: CGFloat, h: CGFloat, cx: CGFloat) -> some View {
        let arrowX: CGFloat = w * 0.78
        let topRowY: CGFloat = h * 0.36
        let bottomRowY: CGFloat = h * 0.62
        let labelX: CGFloat = w * 0.9
        let alveoliLabelY: CGFloat = h * 0.92
        return Group {
            Image(systemName: SFSymbolCompat.name("arrow.right"))
                .font(.system(size: 13, weight: .bold)).foregroundColor(.red)
                .position(x: arrowX, y: topRowY)
            Image(systemName: SFSymbolCompat.name("arrow.left"))
                .font(.system(size: 13, weight: .bold)).foregroundColor(Color.compatBlue)
                .position(x: arrowX, y: bottomRowY)
            SDLabel(text: "O₂ in", color: .red).position(x: labelX, y: topRowY)
            SDLabel(text: "CO₂ out", color: Color.compatBlue).position(x: labelX, y: bottomRowY)
            SDLabel(text: "Alveoli", color: .pink).position(x: cx, y: alveoliLabelY)
        }
    }

    private func alveolarSac(i: Int, cx: CGFloat, cy: CGFloat) -> some View {
        let col: CGFloat = CGFloat(i % 3 - 1)
        let row: CGFloat = CGFloat(i / 3)
        let x: CGFloat = cx + col * 28
        let y: CGFloat = cy + row * 28 - 14
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
            VStack(spacing: DesignTokens.Spacing.sm) {
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
            VStack(spacing: DesignTokens.Spacing.md) {
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
