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
            .background(RoundedRectangle(cornerRadius: 10).fill(tint.opacity(0.06)))
    }
}

private struct PartLabel: View {
    let text: String
    var color: Color = DesignTokens.BrandColor.canvasText
    var body: some View {
        Text(text)
            .font(.system(size: 10, weight: .semibold))
            .foregroundColor(color)
            .padding(.horizontal, 6).padding(.vertical, 2)
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
                let w = geo.size.width, h = geo.size.height
                let cx = w / 2, cy = h / 2
                let ow = min(w * 0.9, h * 2.0), oh = min(h * 0.78, w * 0.5)
                ZStack {
                    // Outer membrane + stroma
                    Ellipse()
                        .fill(Color.compatMint.opacity(0.30))
                        .overlay(Ellipse().strokeBorder(Color.green.opacity(0.75), lineWidth: 2.5))
                        .frame(width: ow, height: oh)
                        .position(x: cx, y: cy)
                    // Three grana (thylakoid stacks)
                    ForEach(0..<3, id: \.self) { i in
                        granum
                            .position(x: cx + CGFloat(i - 1) * ow * 0.26, y: cy)
                    }
                    PartLabel(text: "Outer membrane", color: .green)
                        .position(x: cx, y: max(12, cy - oh / 2 - 2))
                    PartLabel(text: "Stroma")
                        .position(x: cx + ow * 0.30, y: cy + oh * 0.30)
                    PartLabel(text: "Thylakoid stacks (grana)", color: .green)
                        .position(x: cx, y: min(h - 10, cy + oh / 2 + 4))
                }
            }
        }
    }

    private var granum: some View {
        VStack(spacing: 2) {
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
                let w = geo.size.width, h = geo.size.height
                HStack(spacing: 0) {
                    stoma(open: true, label: "Open (day)", w: w / 2, h: h)
                    stoma(open: false, label: "Closed (night)", w: w / 2, h: h)
                }
            }
        }
    }

    private func stoma(open: Bool, label: String, w: CGFloat, h: CGFloat) -> some View {
        let cellW = min(w * 0.16, 26)
        let cellH = min(h * 0.5, 78)
        let gap: CGFloat = open ? cellW * 0.95 : 1.5
        return VStack(spacing: 8) {
            ZStack {
                HStack(spacing: gap) {
                    GuardCell(flip: false).frame(width: cellW, height: cellH)
                    GuardCell(flip: true).frame(width: cellW, height: cellH)
                }
                if open {
                    PartLabel(text: "pore", color: .green)
                        .position(x: w / 2, y: cellH / 2)
                }
            }
            .frame(width: w, height: cellH + 6)
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
                HStack(spacing: 8) {
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
            .padding(.horizontal, 8).padding(.vertical, 5)
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
        ZStack {
            HStack(spacing: 3) {
                ForEach(0..<max(4, Int(w / 26)), id: \.self) { _ in
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
        ZStack {
            HStack(spacing: 6) {
                ForEach(0..<max(5, Int(w / 30)), id: \.self) { i in
                    Circle()
                        .fill(Color.green.opacity(0.28))
                        .overlay(Circle().strokeBorder(Color.green.opacity(0.6), lineWidth: 1))
                        .frame(width: i % 2 == 0 ? 20 : 15)
                }
            }
            // Vascular bundle: a small xylem/phloem pair
            HStack(spacing: 2) {
                Circle().fill(Color.compatBrown.opacity(0.6)).frame(width: 12, height: 12)
                Circle().fill(Color.compatBlue.opacity(0.55)).frame(width: 12, height: 12)
            }
            .padding(4)
            .background(RoundedRectangle(cornerRadius: 6).fill(Color.white.opacity(0.7)))
            .overlay(PartLabel(text: "Vein").offset(y: 16))
        }
        .frame(height: 44)
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
