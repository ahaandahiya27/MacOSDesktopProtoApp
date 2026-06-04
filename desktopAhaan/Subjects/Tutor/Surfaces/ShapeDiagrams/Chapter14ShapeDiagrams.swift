import SwiftUI

// MARK: - Chapter 14 shape diagrams  (Electric Current and Its Effects)
//
// Pure-SwiftUI schematic diagrams for the four ch14 `shapeDiagram`
// MediaAssets. Big Sur / legacy-GPU rules honoured.

// MARK: - ch14_simple_circuit

/// A simple electric circuit: a cell pushes current around a loop of wire,
/// through a closed switch, to light a bulb.
struct SimpleCircuitDiagram: View {
    // Split into small typed helpers so Swift 5.5's type-checker doesn't
    // overflow its stack on one deep @ViewBuilder closure. No visual change.
    var body: some View {
        SDFigure(tint: .orange) {
            GeometryReader { geo in
                content(w: geo.size.width, h: geo.size.height)
            }
        }
    }

    private func content(w: CGFloat, h: CGFloat) -> some View {
        let inset: CGFloat = min(w, h) * 0.18
        let frameW: CGFloat = w - inset * 2
        let frameH: CGFloat = h - inset * 2
        let midX: CGFloat = w / 2
        let midY: CGFloat = h / 2
        return ZStack {
            Rectangle().stroke(DesignTokens.BrandColor.canvasText.opacity(0.6), lineWidth: 2.5)
                .frame(width: frameW, height: frameH)
                .position(x: midX, y: midY)
            components(w: w, h: h, inset: inset)
            labels(w: w, h: h, inset: inset)
        }
    }

    private func components(w: CGFloat, h: CGFloat, inset: CGFloat) -> some View {
        let midX: CGFloat = w / 2
        let midY: CGFloat = h / 2
        let bulbY: CGFloat = h - inset
        let switchX: CGFloat = w - inset
        return Group {
            // Cell (top)
            CellGlyph().frame(width: 40, height: 18).position(x: midX, y: inset)
            // Bulb (bottom)
            ZStack {
                Circle().fill(.yellow.opacity(0.7)).frame(width: 24, height: 24)
                Image(systemName: SFSymbolCompat.name("multiply"))
                    .font(.system(size: 12, weight: .bold)).foregroundColor(.orange)
            }.position(x: midX, y: bulbY)
            // Switch (right side) — closed
            Capsule().fill(DesignTokens.BrandColor.canvasText.opacity(0.5))
                .frame(width: 22, height: 6).rotationEffect(.degrees(-18))
                .position(x: switchX, y: midY)
        }
    }

    private func labels(w: CGFloat, h: CGFloat, inset: CGFloat) -> some View {
        let midX: CGFloat = w / 2
        let cellLabelY: CGFloat = inset - 16
        let bulbLabelY: CGFloat = h - inset + 18
        let switchLabelX: CGFloat = w - inset
        let switchLabelY: CGFloat = h / 2 - 18
        return Group {
            SDLabel(text: "Cell").position(x: midX, y: cellLabelY)
            SDLabel(text: "Bulb", color: .orange).position(x: midX, y: bulbLabelY)
            SDLabel(text: "Switch").position(x: switchLabelX, y: switchLabelY)
        }
    }
}

/// A battery cell symbol: a long (+) and short (−) plate.
private struct CellGlyph: View {
    var body: some View {
        HStack(spacing: 3) {
            Rectangle().fill(DesignTokens.BrandColor.canvasText).frame(width: 3, height: 18)
            Rectangle().fill(DesignTokens.BrandColor.canvasText).frame(width: 3, height: 9)
        }
    }
}

// MARK: - ch14_electromagnet

/// An electromagnet: when current flows through a coil wound on an iron core,
/// the core becomes a magnet and attracts iron objects — and stops when the
/// current is switched off.
struct ElectromagnetDiagram: View {
    // Split into small typed helpers so Swift 5.5's type-checker doesn't
    // overflow its stack on one deep @ViewBuilder closure. No visual change.
    var body: some View {
        SDFigure(tint: Color.compatBlue) {
            GeometryReader { geo in
                content(w: geo.size.width, h: geo.size.height)
            }
        }
    }

    private func content(w: CGFloat, h: CGFloat) -> some View {
        ZStack {
            coreAndCoil(w: w, h: h)
            pinsAndLabels(w: w, h: h)
        }
    }

    private func coreAndCoil(w: CGFloat, h: CGFloat) -> some View {
        let coreW: CGFloat = w * 0.5
        let midX: CGFloat = w / 2
        let coreY: CGFloat = h * 0.45
        let coilStartX: CGFloat = w * 0.28
        let coilStep: CGFloat = w * 0.44 / 5
        let batteryY: CGFloat = h * 0.16
        return Group {
            // Iron core
            RoundedRectangle(cornerRadius: 4).fill(DesignTokens.BrandColor.canvasTextSecondary.opacity(0.5))
                .frame(width: coreW, height: 22).position(x: midX, y: coreY)
            // Coil turns
            ForEach(0..<6, id: \.self) { i in
                let coilX: CGFloat = coilStartX + CGFloat(i) * coilStep
                Ellipse().stroke(Color.compatBrown.opacity(0.7), lineWidth: 2.5)
                    .frame(width: 16, height: 34)
                    .position(x: coilX, y: coreY)
            }
            // Battery
            CellGlyph2().frame(width: 30, height: 20).position(x: midX, y: batteryY)
        }
    }

    private func pinsAndLabels(w: CGFloat, h: CGFloat) -> some View {
        let pinStartX: CGFloat = w * 0.74
        let pinY: CGFloat = h * 0.7
        let midX: CGFloat = w / 2
        let ironLabelY: CGFloat = h * 0.62
        let coilLabelX: CGFloat = w * 0.3
        let coilLabelY: CGFloat = h * 0.2
        let pinsLabelX: CGFloat = w * 0.78
        let pinsLabelY: CGFloat = h * 0.85
        return Group {
            // Attracted pins
            ForEach(0..<3, id: \.self) { i in
                let pinX: CGFloat = pinStartX + CGFloat(i) * 6
                Capsule().fill(DesignTokens.BrandColor.canvasTextSecondary)
                    .frame(width: 3, height: 12)
                    .position(x: pinX, y: pinY)
            }
            SDLabel(text: "Iron core").position(x: midX, y: ironLabelY)
            SDLabel(text: "Coil + current", color: Color.compatBrown).position(x: coilLabelX, y: coilLabelY)
            SDLabel(text: "Attracts pins").position(x: pinsLabelX, y: pinsLabelY)
        }
    }
}

private struct CellGlyph2: View {
    var body: some View {
        HStack(spacing: 3) {
            Rectangle().fill(DesignTokens.BrandColor.canvasText).frame(width: 3, height: 18)
            Rectangle().fill(DesignTokens.BrandColor.canvasText).frame(width: 3, height: 9)
        }
    }
}

// MARK: - ch14_fuse_mcb

/// Two safety devices that break a circuit if too much current flows: a fuse
/// has a thin wire that melts, while an MCB is a switch that trips and can be
/// reset.
struct FuseMCBDiagram: View {
    var body: some View {
        SDFigure(tint: .red) {
            HStack(spacing: 18) {
                device(title: "Fuse", note: "thin wire melts") {
                    AnyView(
                        ZStack {
                            Capsule().fill(Color.compatBrown.opacity(0.25)).frame(width: 70, height: 22)
                            Path { p in
                                p.move(to: CGPoint(x: 8, y: 11))
                                p.addLine(to: CGPoint(x: 28, y: 11))
                                p.addLine(to: CGPoint(x: 34, y: 5))
                                p.addLine(to: CGPoint(x: 40, y: 17))
                                p.addLine(to: CGPoint(x: 62, y: 11))
                            }.stroke(.red.opacity(0.7), lineWidth: 1.5).frame(width: 70, height: 22)
                        }
                    )
                }
                device(title: "MCB", note: "trips & resets") {
                    AnyView(
                        ZStack {
                            RoundedRectangle(cornerRadius: 4).fill(DesignTokens.BrandColor.canvasTextSecondary.opacity(0.3))
                                .frame(width: 34, height: 46)
                            Capsule().fill(.red.opacity(0.6)).frame(width: 10, height: 22).offset(y: -4)
                        }
                    )
                }
            }
        }
    }

    private func device(title: String, note: String, glyph: () -> AnyView) -> some View {
        VStack(spacing: 6) {
            Text(title).font(.system(size: 12, weight: .bold)).foregroundColor(DesignTokens.BrandColor.canvasText)
            glyph().frame(height: 48)
            SDLabel(text: note, color: .red)
        }
    }
}

// MARK: - ch14_orsted

/// Oersted's discovery: a current-carrying wire makes a nearby compass needle
/// swing — the first proof that electricity produces magnetism.
struct OerstedDiagram: View {
    // Split into small typed helpers so Swift 5.5's type-checker doesn't
    // overflow its stack on one deep @ViewBuilder closure. No visual change.
    var body: some View {
        SDFigure(tint: Color.compatBlue) {
            GeometryReader { geo in
                content(w: geo.size.width, h: geo.size.height)
            }
        }
    }

    private func content(w: CGFloat, h: CGFloat) -> some View {
        ZStack {
            wireAndCompass(w: w, h: h)
            labels(w: w, h: h)
        }
    }

    private func wireAndCompass(w: CGFloat, h: CGFloat) -> some View {
        let wireW: CGFloat = w * 0.7
        let midX: CGFloat = w / 2
        let wireY: CGFloat = h * 0.3
        let arrowX: CGFloat = w * 0.82
        let compassY: CGFloat = h * 0.62
        return Group {
            // Wire carrying current
            Rectangle().fill(Color.compatBrown.opacity(0.6)).frame(width: wireW, height: 5)
                .position(x: midX, y: wireY)
            Image(systemName: SFSymbolCompat.name("arrow.right"))
                .font(.system(size: 13, weight: .bold)).foregroundColor(Color.compatBrown)
                .position(x: arrowX, y: wireY)
            // Compass below the wire
            Circle().stroke(DesignTokens.BrandColor.canvasText.opacity(0.6), lineWidth: 2)
                .frame(width: 60, height: 60).position(x: midX, y: compassY)
            CompassNeedle().fill(.red.opacity(0.8))
                .frame(width: 44, height: 12).rotationEffect(.degrees(35))
                .position(x: midX, y: compassY)
        }
    }

    private func labels(w: CGFloat, h: CGFloat) -> some View {
        let midX: CGFloat = w / 2
        let currentLabelY: CGFloat = h * 0.16
        let needleLabelY: CGFloat = h * 0.9
        return Group {
            SDLabel(text: "Current in wire", color: Color.compatBrown).position(x: midX, y: currentLabelY)
            SDLabel(text: "Needle deflects", color: .red).position(x: midX, y: needleLabelY)
        }
    }
}

/// A two-tipped compass needle.
private struct CompassNeedle: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.minX, y: rect.midY))
        p.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        p.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        p.closeSubpath()
        return p
    }
}
