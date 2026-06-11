import SwiftUI

// MARK: - Chapter 1 shape diagrams  (Nutrition in Plants)
//
// Pure-SwiftUI (Path / primitive Shape only) schematic diagrams for the four
// `shapeDiagram` MediaAssets authored in `science_class7.json` under ch01.
// Registered in `ShapeDiagramRegistry` so `MediaAssetView` renders real art
// instead of the "not yet illustrated" placeholder.
//
// Big Sur / legacy-GPU rules honoured throughout:
//   • No macOS 12+ APIs (no Canvas, no .foregroundStyle, no Layout).
//   • Colours via Color.compat* / system greens — no raw .mint/.teal/.cyan.
//   • Static geometry — no animation, no randomness, cheap to rasterise on
//     the AMD R9 M290X.
//   • The host (MediaAssetView) frames these to maxHeight 220, supplies the
//     caption + a single VoiceOver label, and ignores child a11y, so each
//     diagram is decorative art with small in-figure part labels.
//
// Shared layout: a `DiagramCanvas` gives the art a soft tinted backdrop and
// consistent inset; a `PartLabel` is the small rounded caption chip used to
// name internal structures.

// MARK: - Shared building blocks

private struct DiagramCanvas<Content: View>: View {
    let tint: Color
    let content: Content
    init(tint: Color, @ViewBuilder content: () -> Content) {
        self.tint = tint
        self.content = content()
    }
    var body: some View {
        content
            .padding(10)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(RoundedRectangle(cornerRadius: DesignTokens.Radius.md).fill(tint.opacity(0.06)))
    }
}

private struct PartLabel: View {
    let text: String
    var color: Color = DesignTokens.BrandColor.canvasText
    var body: some View {
        Text(text)
            .font(.system(size: 10, weight: .semibold))
            .foregroundColor(color)
            .padding(.horizontal, 6).padding(.vertical, DesignTokens.Spacing.xxs)
            .background(RoundedRectangle(cornerRadius: 4).fill(Color.white.opacity(0.82)))
            .fixedSize()
    }
}

// MARK: - ch01_chloroplast

/// Chloroplast cross-section: outer membrane (lens-shaped envelope), the
/// stroma fluid filling it, and three grana — each a stack of green
/// thylakoid discs.
struct ChloroplastDiagram: View {
    var body: some View {
        DiagramCanvas(tint: .green) {
            GeometryReader { geo in
                content(w: geo.size.width, h: geo.size.height)
            }
        }
    }
    // Body split into typed helpers so the Swift 5.5 type-checker on the
    // Big-Sur iMac never solves one deep GeometryReader→ZStack result-builder
    // closure full of inline CGFloat coordinate math in a single pass.
    private func content(w: CGFloat, h: CGFloat) -> some View {
        let cx: CGFloat = w / 2
        let cy: CGFloat = h / 2
        let owA: CGFloat = w * 0.9
        let owB: CGFloat = h * 2.0
        let ow: CGFloat = min(owA, owB)
        let ohA: CGFloat = h * 0.78
        let ohB: CGFloat = w * 0.5
        let oh: CGFloat = min(ohA, ohB)
        return ZStack {
            membrane(cx: cx, cy: cy, ow: ow, oh: oh)
            grana(cx: cx, cy: cy, ow: ow)
            labels(cx: cx, cy: cy, ow: ow, oh: oh, h: h)
        }
    }
    private func membrane(cx: CGFloat, cy: CGFloat, ow: CGFloat, oh: CGFloat) -> some View {
        // Outer membrane + stroma
        Ellipse()
            .fill(Color.compatMint.opacity(0.30))
            .overlay(Ellipse().strokeBorder(Color.green.opacity(0.75), lineWidth: 2.5))
            .frame(width: ow, height: oh)
            .position(x: cx, y: cy)
    }
    private func grana(cx: CGFloat, cy: CGFloat, ow: CGFloat) -> some View {
        // Three grana (thylakoid stacks). Body extracted to a helper so
        // the ForEach @ViewBuilder closure is a single expression.
        ForEach(0..<3, id: \.self) { i in
            granumAt(i: i, cx: cx, cy: cy, ow: ow)
        }
    }

    private func granumAt(i: Int, cx: CGFloat, cy: CGFloat, ow: CGFloat) -> some View {
        let offset: CGFloat = CGFloat(i - 1) * ow * 0.26
        let gx: CGFloat = cx + offset
        return granum.position(x: gx, y: cy)
    }
    private func labels(cx: CGFloat, cy: CGFloat, ow: CGFloat, oh: CGFloat, h: CGFloat) -> some View {
        let outerHalfH: CGFloat = oh / 2
        let outerMembraneY: CGFloat = max(12, cy - outerHalfH - 2)
        let stromaX: CGFloat = cx + ow * 0.30
        let stromaY: CGFloat = cy + oh * 0.30
        let thylakoidYCandidate: CGFloat = cy + outerHalfH + 4
        let thylakoidYCap: CGFloat = h - 10
        let thylakoidY: CGFloat = min(thylakoidYCap, thylakoidYCandidate)
        return Group {
            PartLabel(text: "Outer membrane", color: .green)
                .position(x: cx, y: outerMembraneY)
            PartLabel(text: "Stroma")
                .position(x: stromaX, y: stromaY)
            PartLabel(text: "Thylakoid stacks (grana)", color: .green)
                .position(x: cx, y: thylakoidY)
        }
    }

    private var granum: some View {
        VStack(spacing: DesignTokens.Spacing.xxs) {
            ForEach(0..<5, id: \.self) { _ in
                Ellipse()
                    .fill(Color.green.opacity(0.55))
                    .frame(width: 26, height: 7)
            }
        }
    }
}

// MARK: - ch01_stomata

/// Two guard cells forming a stoma pore, shown open (day) with a gap and
/// closed (night) touching. Guard cells are kidney shapes drawn as facing
/// thick arcs.
struct StomataDiagram: View {
    var body: some View {
        DiagramCanvas(tint: .green) {
            GeometryReader { geo in
                let w: CGFloat = geo.size.width
                let h: CGFloat = geo.size.height
                let halfW: CGFloat = w / 2
                HStack(spacing: 0) {
                    stoma(open: true, label: "Open (day)", w: halfW, h: h)
                    stoma(open: false, label: "Closed (night)", w: halfW, h: h)
                }
            }
        }
    }

    private func stoma(open: Bool, label: String, w: CGFloat, h: CGFloat) -> some View {
        let cellWRaw: CGFloat = w * 0.16
        let cellW: CGFloat = min(cellWRaw, 26)
        let cellHRaw: CGFloat = h * 0.5
        let cellH: CGFloat = min(cellHRaw, 78)
        let gap: CGFloat = open ? cellW * 0.95 : 1.5
        let centerX: CGFloat = w / 2
        let poreY: CGFloat = cellH / 2
        let outerH: CGFloat = cellH + 6
        return VStack(spacing: DesignTokens.Spacing.sm) {
            ZStack {
                HStack(spacing: gap) {
                    GuardCell(flip: false).frame(width: cellW, height: cellH)
                    GuardCell(flip: true).frame(width: cellW, height: cellH)
                }
                if open {
                    PartLabel(text: "pore", color: .green)
                        .position(x: centerX, y: poreY)
                }
            }
            .frame(width: w, height: outerH)
            PartLabel(text: label)
        }
        .frame(width: w, height: h, alignment: .center)
    }
}

/// A single kidney-shaped guard cell — a thick crescent that bows away from
/// the pore. `flip` mirrors it for the opposite side.
private struct GuardCell: View {
    let flip: Bool
    var body: some View {
        GuardCellShape()
            .fill(Color.green.opacity(0.45))
            .overlay(GuardCellShape().strokeBorder(Color.green.opacity(0.8), lineWidth: 2))
            .scaleEffect(x: flip ? -1 : 1, y: 1)
    }
}

private struct GuardCellShape: InsettableShape {
    var inset: CGFloat = 0
    func inset(by amount: CGFloat) -> GuardCellShape {
        var s = self; s.inset += amount; return s
    }
    func path(in rect: CGRect) -> Path {
        let r = rect.insetBy(dx: inset, dy: inset)
        var p = Path()
        // Outer (pore-facing) edge bows left; inner edge bows right, making a
        // crescent/kidney that fattens at top and bottom.
        p.move(to: CGPoint(x: r.minX, y: r.minY))
        p.addQuadCurve(to: CGPoint(x: r.minX, y: r.maxY),
                       control: CGPoint(x: r.maxX * 0.55 + r.minX, y: r.midY))
        p.addQuadCurve(to: CGPoint(x: r.minX, y: r.minY),
                       control: CGPoint(x: r.maxX + r.minX, y: r.midY))
        p.closeSubpath()
        return p
    }
}

// MARK: - ch01_photosynthesis_equation

/// Inputs (CO₂ + water + light) → arrow → outputs (glucose + oxygen), drawn
/// over a simple leaf so the equation reads as "this happens in the leaf".
struct PhotosynthesisEquationDiagram: View {
    var body: some View {
        DiagramCanvas(tint: .green) {
            VStack(spacing: 10) {
                HStack(spacing: DesignTokens.Spacing.sm) {
                    Group {
                        reactantChip("CO₂", Color.compatBrown)
                        plus
                        reactantChip("H₂O", Color.compatBlue)
                        plus
                        reactantChip("sunlight", .orange)
                    }
                    Image(systemName: SFSymbolCompat.name("arrow.right"))
                        .font(.title3.weight(.bold))
                        .foregroundColor(.green)
                    Group {
                        reactantChip("glucose", .green)
                        plus
                        reactantChip("O₂", Color.compatCyan)
                    }
                }
                Ch01LeafShape()
                    .fill(Color.green.opacity(0.30))
                    .overlay(Ch01LeafShape().strokeBorder(Color.green.opacity(0.75), lineWidth: 2))
                    .frame(width: 120, height: 54)
                    .overlay(PartLabel(text: "in the leaf", color: .green))
            }
        }
    }

    private var plus: some View {
        Text("+").font(.headline).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
    }

    private func reactantChip(_ t: String, _ c: Color) -> some View {
        Text(t)
            .font(.system(size: 12, weight: .semibold))
            .foregroundColor(DesignTokens.BrandColor.canvasText)
            .padding(.horizontal, DesignTokens.Spacing.sm).padding(.vertical, 5)
            .background(RoundedRectangle(cornerRadius: 7).fill(c.opacity(0.18)))
            .overlay(RoundedRectangle(cornerRadius: 7).strokeBorder(c.opacity(0.55), lineWidth: 1))
            .fixedSize()
    }
}

/// A simple pointed leaf (two mirrored quad curves) with no midrib drawn —
/// midrib is added by the caller if needed.
private struct Ch01LeafShape: InsettableShape {
    var inset: CGFloat = 0
    func inset(by amount: CGFloat) -> Ch01LeafShape { var s = self; s.inset += amount; return s }
    func path(in rect: CGRect) -> Path {
        let r = rect.insetBy(dx: inset, dy: inset)
        var p = Path()
        p.move(to: CGPoint(x: r.minX, y: r.midY))
        p.addQuadCurve(to: CGPoint(x: r.maxX, y: r.midY), control: CGPoint(x: r.midX, y: r.minY))
        p.addQuadCurve(to: CGPoint(x: r.minX, y: r.midY), control: CGPoint(x: r.midX, y: r.maxY))
        p.closeSubpath()
        return p
    }
}

// MARK: - ch01_leaf_anatomy

/// Leaf cross-section as horizontal tissue bands: upper epidermis, palisade
/// mesophyll (tall columnar cells), spongy mesophyll (loose round cells) with
/// a vascular bundle, and lower epidermis pierced by a stoma.
struct LeafAnatomyDiagram: View {
    var body: some View {
        DiagramCanvas(tint: .green) {
            GeometryReader { geo in
                let w = geo.size.width
                VStack(spacing: 3) {
                    band(Color.compatMint, height: 16, label: "Upper epidermis", w: w)
                    palisade(w: w)
                    spongy(w: w)
                    lowerEpidermisWithStoma(w: w)
                }
            }
        }
    }

    private func band(_ c: Color, height: CGFloat, label: String, w: CGFloat) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 3)
                .fill(c.opacity(0.35))
                .overlay(RoundedRectangle(cornerRadius: 3).strokeBorder(c.opacity(0.7), lineWidth: 1))
            PartLabel(text: label)
        }
        .frame(height: height)
    }

    private func palisade(w: CGFloat) -> some View {
        let cellCount: Int = max(4, Int(w / 26))
        return ZStack {
            HStack(spacing: 3) {
                ForEach(0..<cellCount, id: \.self) { _ in
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.green.opacity(0.45))
                        .overlay(RoundedRectangle(cornerRadius: 4).strokeBorder(Color.green.opacity(0.7), lineWidth: 1))
                        .frame(width: 16)
                }
            }
            PartLabel(text: "Palisade mesophyll", color: .green)
        }
        .frame(height: 40)
    }

    private func spongy(w: CGFloat) -> some View {
        let cellCount: Int = max(5, Int(w / 30))
        return ZStack {
            HStack(spacing: 6) {
                ForEach(0..<cellCount, id: \.self) { i in
                    spongyCell(i: i)
                }
            }
            // Vascular bundle: a small xylem/phloem pair
            HStack(spacing: DesignTokens.Spacing.xxs) {
                Circle().fill(Color.compatBrown.opacity(0.6)).frame(width: 12, height: 12)
                Circle().fill(Color.compatBlue.opacity(0.55)).frame(width: 12, height: 12)
            }
            .padding(DesignTokens.Spacing.xs)
            .background(RoundedRectangle(cornerRadius: 6).fill(Color.white.opacity(0.7)))
            .overlay(PartLabel(text: "Vein").offset(y: 16))
        }
        .frame(height: 44)
    }

    // Per-iteration spongy-mesophyll cell — extracted from the ForEach
    // body so the @ViewBuilder closure is single-expression. The
    // `let cellSize` + `return Circle()` pattern was rejected by Swift
    // 5.5 (caught on the 2026-06-05 iMac build).
    private func spongyCell(i: Int) -> some View {
        let cellSize: CGFloat = i % 2 == 0 ? 20 : 15
        return Circle()
            .fill(Color.green.opacity(0.28))
            .overlay(Circle().strokeBorder(Color.green.opacity(0.6), lineWidth: 1))
            .frame(width: cellSize)
    }

    private func lowerEpidermisWithStoma(w: CGFloat) -> some View {
        ZStack {
            HStack(spacing: 0) {
                RoundedRectangle(cornerRadius: 3).fill(Color.compatMint.opacity(0.35))
                Spacer().frame(width: 18)   // pore gap
                RoundedRectangle(cornerRadius: 3).fill(Color.compatMint.opacity(0.35))
            }
            .overlay(RoundedRectangle(cornerRadius: 3).strokeBorder(Color.compatMint.opacity(0.7), lineWidth: 1))
            PartLabel(text: "Lower epidermis + stoma")
        }
        .frame(height: 16)
    }
}
