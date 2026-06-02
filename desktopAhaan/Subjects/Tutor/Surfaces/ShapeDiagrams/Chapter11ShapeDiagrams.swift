import SwiftUI

// MARK: - Chapter 11 shape diagrams  (Transportation in Animals and Plants)
//
// Pure-SwiftUI schematic diagrams for the four ch11 `shapeDiagram`
// MediaAssets. Big Sur / legacy-GPU rules honoured.

// MARK: - ch11_heart_4chambers

/// The human heart's four chambers: two upper atria receive blood, two lower
/// ventricles pump it out. The right side handles oxygen-poor blood (blue),
/// the left side oxygen-rich blood (red).
struct HeartChambersDiagram: View {
    var body: some View {
        SDFigure(tint: .red) {
            GeometryReader { geo in
                let w = geo.size.width, h = geo.size.height
                let cx = w / 2
                ZStack {
                    Group {
                        chamber("Right atrium", Color.compatBlue, x: cx - w * 0.18, y: h * 0.3, dw: w * 0.3, dh: h * 0.3)
                        chamber("Left atrium", .red, x: cx + w * 0.18, y: h * 0.3, dw: w * 0.3, dh: h * 0.3)
                        chamber("Right ventricle", Color.compatBlue, x: cx - w * 0.18, y: h * 0.68, dw: w * 0.3, dh: h * 0.4)
                        chamber("Left ventricle", .red, x: cx + w * 0.18, y: h * 0.68, dw: w * 0.3, dh: h * 0.4)
                    }
                    Rectangle().fill(DesignTokens.BrandColor.canvasTextSecondary.opacity(0.4))
                        .frame(width: 1.5, height: h * 0.8).position(x: cx, y: h * 0.5)
                    SDLabel(text: "Septum divides L / R").position(x: cx, y: h * 0.96)
                }
            }
        }
    }

    private func chamber(_ name: String, _ c: Color, x: CGFloat, y: CGFloat, dw: CGFloat, dh: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: 8).fill(c.opacity(0.28))
            .overlay(RoundedRectangle(cornerRadius: 8).strokeBorder(c.opacity(0.6), lineWidth: 1.5))
            .overlay(SDLabel(text: name, color: c))
            .frame(width: dw, height: dh)
            .position(x: x, y: y)
    }
}

// MARK: - ch11_nephron

/// The kidney's filtering unit, the nephron: blood is filtered in a tiny ball
/// of vessels (the glomerulus), then useful substances are reabsorbed along a
/// looping tubule, leaving urine.
struct NephronDiagram: View {
    var body: some View {
        SDFigure(tint: Color.compatBlue) {
            GeometryReader { geo in
                let w = geo.size.width, h = geo.size.height
                ZStack {
                    Group {
                        // Glomerulus cup
                        Circle().fill(.red.opacity(0.4))
                            .overlay(Circle().stroke(.red.opacity(0.6), lineWidth: 1.5))
                            .frame(width: 34, height: 34).position(x: w * 0.28, y: h * 0.3)
                        // Looping tubule
                        TubuleShape().stroke(Color.compatBlue.opacity(0.6),
                                             style: StrokeStyle(lineWidth: 4, lineCap: .round))
                            .frame(width: w * 0.55, height: h * 0.6).position(x: w * 0.55, y: h * 0.55)
                    }
                    Group {
                        SDLabel(text: "Glomerulus (filters blood)", color: .red).position(x: w * 0.34, y: h * 0.12)
                        SDLabel(text: "Tubule (reabsorbs)", color: Color.compatBlue).position(x: w * 0.6, y: h * 0.9)
                        Image(systemName: SFSymbolCompat.name("arrow.down"))
                            .font(.system(size: 13, weight: .bold)).foregroundColor(Color.compatBlue)
                            .position(x: w * 0.85, y: h * 0.8)
                        SDLabel(text: "urine").position(x: w * 0.92, y: h * 0.92)
                    }
                }
            }
        }
    }
}

/// A U-shaped (loop of Henle) tubule path.
private struct TubuleShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.minX, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.minX + rect.width * 0.3, y: rect.maxY - 10))
        p.addQuadCurve(to: CGPoint(x: rect.minX + rect.width * 0.55, y: rect.maxY - 10),
                       control: CGPoint(x: rect.minX + rect.width * 0.42, y: rect.maxY + 12))
        p.addLine(to: CGPoint(x: rect.minX + rect.width * 0.78, y: rect.minY + 14))
        p.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.maxY),
                       control: CGPoint(x: rect.maxX, y: rect.minY + 6))
        return p
    }
}

// MARK: - ch11_xylem_phloem

/// A plant's two transport pipes, side by side in a vascular bundle: xylem
/// carries water UP from the roots; phloem carries food DOWN from the leaves.
struct XylemPhloemDiagram: View {
    var body: some View {
        SDFigure(tint: .green) {
            HStack(spacing: 28) {
                pipe(title: "Xylem", note: "water ↑", color: Color.compatBlue, up: true)
                pipe(title: "Phloem", note: "food ↓", color: .green, up: false)
            }
        }
    }

    private func pipe(title: String, note: String, color: Color, up: Bool) -> some View {
        VStack(spacing: 5) {
            Text(title).font(.system(size: 12, weight: .bold)).foregroundColor(DesignTokens.BrandColor.canvasText)
            ZStack {
                RoundedRectangle(cornerRadius: 6).fill(color.opacity(0.2))
                    .overlay(RoundedRectangle(cornerRadius: 6).strokeBorder(color.opacity(0.6), lineWidth: 1.5))
                    .frame(width: 30, height: 96)
                Image(systemName: SFSymbolCompat.name(up ? "arrow.up" : "arrow.down"))
                    .font(.system(size: 22, weight: .bold)).foregroundColor(color)
            }
            SDLabel(text: note, color: color)
        }
    }
}

// MARK: - ch11_blood_cells

/// What blood is made of: red cells (carry oxygen), white cells (fight germs)
/// and platelets (clot wounds), all floating in liquid plasma.
struct BloodCellsDiagram: View {
    var body: some View {
        SDFigure(tint: .red) {
            VStack(spacing: 10) {
                SDLabel(text: "Plasma (liquid) carries…", color: Color.compatBlue)
                HStack(spacing: 16) {
                    cell("RBC", "carries O₂", .red) {
                        AnyView(Circle().fill(.red.opacity(0.55))
                            .overlay(Circle().fill(.red.opacity(0.25)).frame(width: 10, height: 10)))
                    }
                    cell("WBC", "fights germs", Color.compatPurple) {
                        AnyView(Circle().fill(Color.compatPurple.opacity(0.5))
                            .overlay(Circle().fill(Color.compatPurple.opacity(0.8)).frame(width: 9, height: 9)))
                    }
                    cell("Platelets", "clot wounds", DesignTokens.BrandColor.canvasTextSecondary) {
                        AnyView(DiamondCell())
                    }
                }
            }
        }
    }

    private func cell(_ name: String, _ note: String, _ c: Color, glyph: () -> AnyView) -> some View {
        VStack(spacing: 4) {
            glyph().frame(width: 26, height: 26)
            Text(name).font(.system(size: 10, weight: .bold)).foregroundColor(DesignTokens.BrandColor.canvasText)
            SDLabel(text: note, color: c)
        }
    }
}

/// A small irregular platelet glyph.
private struct DiamondCell: View {
    var body: some View {
        Circle().fill(DesignTokens.BrandColor.canvasTextSecondary.opacity(0.45))
            .frame(width: 16, height: 16)
    }
}
