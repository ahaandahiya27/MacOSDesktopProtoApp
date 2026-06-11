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
    // Split into typed helpers so the Swift 5.5 type-checker (Big Sur / Xcode
    // 13.2.1) doesn't overflow its stack on one deep @ViewBuilder closure.
    var body: some View {
        SDFigure(tint: .red) {
            GeometryReader { geo in
                content(w: geo.size.width, h: geo.size.height)
            }
        }
    }

    private func content(w: CGFloat, h: CGFloat) -> some View {
        let cx: CGFloat = w / 2
        let septumH: CGFloat = h * 0.8
        let septumY: CGFloat = h * 0.5
        let captionY: CGFloat = h * 0.96
        return ZStack {
            chambers(w: w, h: h, cx: cx)
            Rectangle().fill(DesignTokens.BrandColor.canvasTextSecondary.opacity(0.4))
                .frame(width: 1.5, height: septumH).position(x: cx, y: septumY)
            SDLabel(text: "Septum divides L / R").position(x: cx, y: captionY)
        }
    }

    private func chambers(w: CGFloat, h: CGFloat, cx: CGFloat) -> some View {
        let hOffset: CGFloat = w * 0.18
        let leftX: CGFloat = cx - hOffset
        let rightX: CGFloat = cx + hOffset
        let atriumY: CGFloat = h * 0.3
        let ventricleY: CGFloat = h * 0.68
        let chamberW: CGFloat = w * 0.3
        let atriumH: CGFloat = h * 0.3
        let ventricleH: CGFloat = h * 0.4
        return Group {
            chamber("Right atrium", Color.compatBlue, x: leftX, y: atriumY, dw: chamberW, dh: atriumH)
            chamber("Left atrium", .red, x: rightX, y: atriumY, dw: chamberW, dh: atriumH)
            chamber("Right ventricle", Color.compatBlue, x: leftX, y: ventricleY, dw: chamberW, dh: ventricleH)
            chamber("Left ventricle", .red, x: rightX, y: ventricleY, dw: chamberW, dh: ventricleH)
        }
    }

    private func chamber(_ name: String, _ c: Color, x: CGFloat, y: CGFloat, dw: CGFloat, dh: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: DesignTokens.Radius.sm).fill(c.opacity(0.28))
            .overlay(RoundedRectangle(cornerRadius: DesignTokens.Radius.sm).strokeBorder(c.opacity(0.6), lineWidth: 1.5))
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
    // Split into typed helpers so the Swift 5.5 type-checker (Big Sur / Xcode
    // 13.2.1) doesn't overflow its stack on one deep @ViewBuilder closure.
    var body: some View {
        SDFigure(tint: Color.compatBlue) {
            GeometryReader { geo in
                content(w: geo.size.width, h: geo.size.height)
            }
        }
    }

    private func content(w: CGFloat, h: CGFloat) -> some View {
        ZStack {
            structures(w: w, h: h)
            labels(w: w, h: h)
        }
    }

    private func structures(w: CGFloat, h: CGFloat) -> some View {
        let glomerulusX: CGFloat = w * 0.28
        let glomerulusY: CGFloat = h * 0.3
        let tubuleW: CGFloat = w * 0.55
        let tubuleH: CGFloat = h * 0.6
        let tubuleX: CGFloat = w * 0.55
        let tubuleY: CGFloat = h * 0.55
        return Group {
            // Glomerulus cup
            Circle().fill(.red.opacity(0.4))
                .overlay(Circle().stroke(.red.opacity(0.6), lineWidth: 1.5))
                .frame(width: 34, height: 34).position(x: glomerulusX, y: glomerulusY)
            // Looping tubule
            TubuleShape().stroke(Color.compatBlue.opacity(0.6),
                                 style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .frame(width: tubuleW, height: tubuleH).position(x: tubuleX, y: tubuleY)
        }
    }

    private func labels(w: CGFloat, h: CGFloat) -> some View {
        let glomLabelX: CGFloat = w * 0.34
        let glomLabelY: CGFloat = h * 0.12
        let tubLabelX: CGFloat = w * 0.6
        let tubLabelY: CGFloat = h * 0.9
        let arrowX: CGFloat = w * 0.85
        let arrowY: CGFloat = h * 0.8
        let urineX: CGFloat = w * 0.92
        let urineY: CGFloat = h * 0.92
        return Group {
            SDLabel(text: "Glomerulus (filters blood)", color: .red).position(x: glomLabelX, y: glomLabelY)
            SDLabel(text: "Tubule (reabsorbs)", color: Color.compatBlue).position(x: tubLabelX, y: tubLabelY)
            Image(systemName: SFSymbolCompat.name("arrow.down"))
                .font(.system(size: 13, weight: .bold)).foregroundColor(Color.compatBlue)
                .position(x: arrowX, y: arrowY)
            SDLabel(text: "urine").position(x: urineX, y: urineY)
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
                HStack(spacing: DesignTokens.Spacing.lg) {
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
        VStack(spacing: DesignTokens.Spacing.xs) {
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
