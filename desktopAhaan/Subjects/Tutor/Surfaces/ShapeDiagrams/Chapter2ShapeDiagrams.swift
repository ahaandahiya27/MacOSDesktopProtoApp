import SwiftUI

// MARK: - Chapter 2 shape diagrams  (Nutrition in Animals)
//
// Pure-SwiftUI schematic diagrams for the four ch02 `shapeDiagram`
// MediaAssets in science_class7.json. Shared building blocks live in
// ShapeDiagramKit (SDFigure / SDLabel / SDFingerShape). Big Sur / legacy-GPU
// rules honoured throughout (no macOS 12+ APIs, compat colours, static art).

// MARK: - ch02_digestive_system

/// The human alimentary canal as a top-to-bottom schematic: mouth →
/// oesophagus → J-shaped stomach → coiled small intestine framed by the
/// large intestine, with the liver as an accessory gland.
struct DigestiveSystemDiagram: View {
    // Structural split: one deep GeometryReader/ZStack closure broken into
    // small typed helpers so Swift 5.5's type-checker doesn't segfault. No
    // visual change — every coordinate/colour/string preserved verbatim.
    var body: some View {
        SDFigure(tint: Color.compatBrown) {
            GeometryReader { geo in
                content(w: geo.size.width, h: geo.size.height)
            }
        }
    }

    private func content(w: CGFloat, h: CGFloat) -> some View {
        let cx: CGFloat = w / 2
        return ZStack {
            intestines(w: w, h: h, cx: cx)
            organs(w: w, h: h, cx: cx)
            labels(w: w, h: h, cx: cx)
        }
    }

    private func intestines(w: CGFloat, h: CGFloat, cx: CGFloat) -> some View {
        let colonW: CGFloat = min(w * 0.7, 220)
        let colonH: CGFloat = h * 0.42
        let coilW: CGFloat = min(w * 0.5, 150)
        let coilH: CGFloat = h * 0.3
        let centerY: CGFloat = h * 0.66
        return Group {
            // Large intestine frame surrounding the coils
            Ch02ColonShape()
                .stroke(Color.compatBrown.opacity(0.55), lineWidth: 9)
                .frame(width: colonW, height: colonH)
                .position(x: cx, y: centerY)
            // Small intestine coils
            Ch02CoilShape()
                .stroke(Color.orange.opacity(0.65), lineWidth: 7)
                .frame(width: coilW, height: coilH)
                .position(x: cx, y: centerY)
        }
    }

    private func organs(w: CGFloat, h: CGFloat, cx: CGFloat) -> some View {
        let oesophagusH: CGFloat = h * 0.22
        let oesophagusY: CGFloat = h * 0.18
        let stomachX: CGFloat = cx + 10
        let stomachY: CGFloat = h * 0.36
        let liverX: CGFloat = cx - 46
        let liverY: CGFloat = h * 0.34
        return Group {
            // Oesophagus
            Capsule()
                .fill(Color.compatBrown.opacity(0.35))
                .frame(width: 10, height: oesophagusH)
                .position(x: cx, y: oesophagusY)
            // Stomach (J sac)
            Ch02StomachShape()
                .fill(Color.red.opacity(0.28))
                .overlay(Ch02StomachShape().stroke(Color.red.opacity(0.6), lineWidth: 2))
                .frame(width: 64, height: 52)
                .position(x: stomachX, y: stomachY)
            // Liver accessory gland
            SDLeafShape()
                .fill(Color.compatBrown.opacity(0.5))
                .frame(width: 46, height: 30)
                .position(x: liverX, y: liverY)
        }
    }

    private func labels(w: CGFloat, h: CGFloat, cx: CGFloat) -> some View {
        let oesophagusLabelX: CGFloat = cx + 52
        let oesophagusLabelY: CGFloat = h * 0.18
        let stomachLabelX: CGFloat = cx + 56
        let stomachLabelY: CGFloat = h * 0.38
        let liverLabelX: CGFloat = cx - 46
        let liverLabelY: CGFloat = h * 0.34 - 22
        let smallIntestineY: CGFloat = h * 0.66
        let largeIntestineY: CGFloat = min(h - 8, h * 0.9)
        return Group {
            SDLabel(text: "Mouth").position(x: cx, y: 10)
            SDLabel(text: "Oesophagus").position(x: oesophagusLabelX, y: oesophagusLabelY)
            SDLabel(text: "Stomach", color: .red).position(x: stomachLabelX, y: stomachLabelY)
            SDLabel(text: "Liver", color: Color.compatBrown).position(x: liverLabelX, y: liverLabelY)
            SDLabel(text: "Small intestine").position(x: cx, y: smallIntestineY)
            SDLabel(text: "Large intestine", color: Color.compatBrown).position(x: cx, y: largeIntestineY)
        }
    }
}

/// A J-shaped stomach sac: wide top curving down into a narrower pylorus.
private struct Ch02StomachShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.minX + rect.width * 0.1, y: rect.minY))
        p.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.midY),
                       control: CGPoint(x: rect.maxX, y: rect.minY))
        p.addQuadCurve(to: CGPoint(x: rect.midX, y: rect.maxY),
                       control: CGPoint(x: rect.maxX, y: rect.maxY))
        p.addQuadCurve(to: CGPoint(x: rect.minX + rect.width * 0.25, y: rect.midY),
                       control: CGPoint(x: rect.minX, y: rect.maxY))
        p.addQuadCurve(to: CGPoint(x: rect.minX + rect.width * 0.1, y: rect.minY),
                       control: CGPoint(x: rect.minX + rect.width * 0.15, y: rect.minY + rect.height * 0.25))
        p.closeSubpath()
        return p
    }
}

/// A serpentine path standing in for the coiled small intestine.
private struct Ch02CoilShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let rows = 4
        let dy = rect.height / CGFloat(rows)
        p.move(to: CGPoint(x: rect.minX, y: rect.minY + dy / 2))
        for i in 0..<rows {
            let y = rect.minY + dy / 2 + CGFloat(i) * dy
            let goRight = i % 2 == 0
            let toX = goRight ? rect.maxX : rect.minX
            p.addLine(to: CGPoint(x: toX, y: y))
            if i < rows - 1 {
                p.addQuadCurve(to: CGPoint(x: toX, y: y + dy),
                               control: CGPoint(x: toX + (goRight ? 14 : -14), y: y + dy / 2))
            }
        }
        return p
    }
}

/// An inverted-U frame standing in for the ascending / transverse /
/// descending colon around the small intestine.
private struct Ch02ColonShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        p.addLine(to: CGPoint(x: rect.minX, y: rect.minY + 12))
        p.addQuadCurve(to: CGPoint(x: rect.minX + 12, y: rect.minY),
                       control: CGPoint(x: rect.minX, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.maxX - 12, y: rect.minY))
        p.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.minY + 12),
                       control: CGPoint(x: rect.maxX, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        return p
    }
}

// MARK: - ch02_villi

/// The small-intestine lining magnified: finger-like villi projecting into
/// the lumen, each carrying a red blood capillary, hugely increasing the
/// surface area for absorption.
struct VilliDiagram: View {
    var body: some View {
        SDFigure(tint: .orange) {
            VStack(spacing: 6) {
                SDLabel(text: "Villi — finger-like folds")
                HStack(alignment: .bottom, spacing: 7) {
                    ForEach(0..<7, id: \.self) { i in
                        villus(tall: i % 2 == 0)
                    }
                }
                .frame(maxHeight: .infinity)
                // Intestinal wall the villi grow from
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.orange.opacity(0.4))
                    .frame(height: 14)
                    .overlay(SDLabel(text: "Intestinal wall", color: .orange))
            }
        }
    }

    private func villus(tall: Bool) -> some View {
        SDFingerShape()
            .fill(Color.orange.opacity(0.22))
            .overlay(SDFingerShape().stroke(Color.orange.opacity(0.6), lineWidth: 1.5))
            .overlay(
                // Capillary loop inside the villus
                Capsule()
                    .stroke(Color.red.opacity(0.7), lineWidth: 1.5)
                    .padding(.horizontal, 5)
                    .padding(.top, DesignTokens.Spacing.sm)
            )
            .frame(width: 20, height: tall ? 70 : 56)
    }
}

// MARK: - ch02_tooth_types

/// The four kinds of human teeth in one jaw quadrant: chisel-edged incisors,
/// a pointed canine, flat-topped premolars and broad molars, set in the gum.
struct ToothTypesDiagram: View {
    private let teeth: [(String, ToothKind)] = [
        ("Incisor", .incisor), ("Incisor", .incisor),
        ("Canine", .canine),
        ("Premolar", .premolar), ("Premolar", .premolar),
        ("Molar", .molar), ("Molar", .molar)
    ]
    var body: some View {
        SDFigure(tint: Color.compatBlue) {
            VStack(spacing: DesignTokens.Spacing.sm) {
                HStack(alignment: .bottom, spacing: 5) {
                    ForEach(0..<teeth.count, id: \.self) { i in
                        toothColumn(label: teeth[i].0, kind: teeth[i].1)
                    }
                }
                // Gum line
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.pink.opacity(0.4))
                    .frame(height: 16)
                    .overlay(SDLabel(text: "Gum", color: .pink))
            }
        }
    }

    private func toothColumn(label: String, kind: ToothKind) -> some View {
        VStack(spacing: 3) {
            ToothShape(kind: kind)
                .fill(Color.white.opacity(0.92))
                .overlay(ToothShape(kind: kind).stroke(Color.compatBlue.opacity(0.55), lineWidth: 1.5))
                .frame(width: kind == .molar ? 30 : (kind == .canine ? 18 : 22),
                       height: kind == .canine ? 46 : 38)
            Text(label)
                .font(.system(size: 8, weight: .medium))
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                .fixedSize()
        }
    }
}

private enum ToothKind { case incisor, canine, premolar, molar }

/// One tooth crown, shaped per kind: incisor = chisel, canine = point,
/// premolar = two cusps, molar = broad with several cusps.
private struct ToothShape: Shape {
    let kind: ToothKind
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let topY = rect.minY
        switch kind {
        case .incisor:
            p.addRoundedRect(in: rect, cornerSize: CGSize(width: 3, height: 3))
        case .canine:
            p.move(to: CGPoint(x: rect.midX, y: topY))
            p.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
            p.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            p.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            p.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
            p.closeSubpath()
        case .premolar:
            cuspTop(&p, in: rect, cusps: 2)
        case .molar:
            cuspTop(&p, in: rect, cusps: 3)
        }
        return p
    }

    /// A crown whose biting surface is a row of rounded cusps.
    private func cuspTop(_ p: inout Path, in rect: CGRect, cusps: Int) {
        let step = rect.width / CGFloat(cusps)
        p.move(to: CGPoint(x: rect.minX, y: rect.minY + 6))
        for c in 0..<cusps {
            let x0 = rect.minX + CGFloat(c) * step
            p.addQuadCurve(to: CGPoint(x: x0 + step, y: rect.minY + 6),
                           control: CGPoint(x: x0 + step / 2, y: rect.minY - 3))
        }
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        p.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        p.closeSubpath()
    }
}

// MARK: - ch02_rumen

/// Rumination in cattle: swallowed grass enters the four-chambered stomach
/// (rumen → reticulum → omasum → abomasum); softened cud travels back up to
/// the mouth to be chewed again.
struct RumenDiagram: View {
    // Structural split: deep GeometryReader/ZStack closure broken into typed
    // helpers for the Swift 5.5 type-checker. No visual change.
    var body: some View {
        SDFigure(tint: .green) {
            GeometryReader { geo in
                content(w: geo.size.width, h: geo.size.height)
            }
        }
    }

    private func content(w: CGFloat, h: CGFloat) -> some View {
        ZStack {
            chambers(w: w, h: h)
            cudReturn(w: w, h: h)
        }
    }

    private func chambers(w: CGFloat, h: CGFloat) -> some View {
        let rumenX: CGFloat = w * 0.30
        let rumenY: CGFloat = h * 0.40
        let reticulumX: CGFloat = w * 0.62
        let reticulumY: CGFloat = h * 0.30
        let omasumX: CGFloat = w * 0.74
        let omasumY: CGFloat = h * 0.58
        let abomasumX: CGFloat = w * 0.5
        let abomasumY: CGFloat = h * 0.74
        return Group {
            chamber("Rumen", .green, x: rumenX, y: rumenY, dw: 80, dh: 64)
            chamber("Reticulum", Color.compatTeal, x: reticulumX, y: reticulumY, dw: 46, dh: 40)
            chamber("Omasum", Color.compatBlue, x: omasumX, y: omasumY, dw: 42, dh: 44)
            chamber("Abomasum", Color.compatBrown, x: abomasumX, y: abomasumY, dw: 56, dh: 36)
        }
    }

    private func cudReturn(w: CGFloat, h: CGFloat) -> some View {
        let arrowW: CGFloat = w * 0.5
        let arrowH: CGFloat = h * 0.5
        let arrowX: CGFloat = w * 0.5
        let arrowY: CGFloat = h * 0.32
        let labelX: CGFloat = w * 0.5
        return Group {
            // Cud-return arrow (chambers back up to mouth)
            Ch02CudArrow()
                .stroke(Color.green.opacity(0.7),
                        style: StrokeStyle(lineWidth: 2.5, lineCap: .round, dash: [5, 3]))
                .frame(width: arrowW, height: arrowH)
                .position(x: arrowX, y: arrowY)
            SDLabel(text: "cud chewed again", color: .green)
                .position(x: labelX, y: 12)
        }
    }

    private func chamber(_ name: String, _ c: Color, x: CGFloat, y: CGFloat, dw: CGFloat, dh: CGFloat) -> some View {
        Ellipse()
            .fill(c.opacity(0.3))
            .overlay(Ellipse().stroke(c.opacity(0.7), lineWidth: 2))
            .overlay(SDLabel(text: name, color: c))
            .frame(width: dw, height: dh)
            .position(x: x, y: y)
    }
}

/// A curved arrow arcing from the stomach back up toward the mouth.
private struct Ch02CudArrow: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.maxX, y: rect.maxY))
        p.addQuadCurve(to: CGPoint(x: rect.minX, y: rect.minY),
                       control: CGPoint(x: rect.minX, y: rect.maxY))
        // Arrowhead at the top (toward the mouth)
        p.addLine(to: CGPoint(x: rect.minX + 7, y: rect.minY + 9))
        p.move(to: CGPoint(x: rect.minX, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.minX + 11, y: rect.minY + 3))
        return p
    }
}
