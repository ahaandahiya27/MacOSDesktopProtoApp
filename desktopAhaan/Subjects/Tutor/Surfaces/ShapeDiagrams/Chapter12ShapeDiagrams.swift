import SwiftUI

// MARK: - Chapter 12 shape diagrams  (Reproduction in Plants)
//
// Pure-SwiftUI schematic diagrams for the four ch12 `shapeDiagram`
// MediaAssets. Big Sur / legacy-GPU rules honoured.

// MARK: - ch12_flower_anatomy

/// The parts of a flower: protective sepals and showy petals on the outside,
/// the male stamens (anther on a filament) and the central female carpel
/// (stigma → style → ovary holding ovules).
struct FlowerAnatomyDiagram: View {
    // Split into typed helpers so the Swift 5.5 type-checker (Big Sur / Xcode
    // 13.2.1) doesn't overflow its stack on one deep @ViewBuilder closure.
    var body: some View {
        SDFigure(tint: .pink) {
            GeometryReader { geo in
                content(w: geo.size.width, h: geo.size.height)
            }
        }
    }

    private func content(w: CGFloat, h: CGFloat) -> some View {
        let cx: CGFloat = w / 2
        return ZStack {
            parts(w: w, h: h, cx: cx)
            labels(w: w, h: h, cx: cx)
        }
    }

    private func parts(w: CGFloat, h: CGFloat, cx: CGFloat) -> some View {
        let petalY: CGFloat = h * 0.55
        let sepalY: CGFloat = h * 0.82
        let ovaryY: CGFloat = h * 0.62
        let styleH: CGFloat = h * 0.28
        let styleY: CGFloat = h * 0.38
        let stigmaY: CGFloat = h * 0.22
        let stamenLeftX: CGFloat = cx - 26
        let stamenRightX: CGFloat = cx + 26
        return Group {
            // Petals (behind) and sepals
            ForEach(0..<2, id: \.self) { s in
                let petalDX: CGFloat = s == 0 ? -22 : 22
                let petalX: CGFloat = cx + petalDX
                SDLeafShape().fill(.pink.opacity(0.3))
                    .frame(width: 36, height: 80)
                    .rotationEffect(.degrees(s == 0 ? -24 : 24))
                    .position(x: petalX, y: petalY)
            }
            SDLeafShape().fill(.green.opacity(0.35)).frame(width: 26, height: 50)
                .position(x: cx, y: sepalY)
            // Carpel: ovary bulb → style → stigma
            Ellipse().fill(.green.opacity(0.4)).frame(width: 30, height: 26)
                .position(x: cx, y: ovaryY)
            Capsule().fill(.green.opacity(0.5)).frame(width: 6, height: styleH)
                .position(x: cx, y: styleY)
            Circle().fill(.green.opacity(0.6)).frame(width: 14, height: 14)
                .position(x: cx, y: stigmaY)
            // Stamens flanking the carpel
            stamen(x: stamenLeftX, h: h)
            stamen(x: stamenRightX, h: h)
        }
    }

    private func labels(w: CGFloat, h: CGFloat, cx: CGFloat) -> some View {
        let stigmaLabelX: CGFloat = cx + 40
        let stigmaLabelY: CGFloat = h * 0.22
        let styleLabelX: CGFloat = cx + 36
        let styleLabelY: CGFloat = h * 0.4
        let ovaryLabelX: CGFloat = cx + 44
        let ovaryLabelY: CGFloat = h * 0.62
        let antherLabelX: CGFloat = cx - 50
        let antherLabelY: CGFloat = h * 0.26
        let petalLabelX: CGFloat = cx - 56
        let petalLabelY: CGFloat = h * 0.58
        return Group {
            SDLabel(text: "Stigma", color: .green).position(x: stigmaLabelX, y: stigmaLabelY)
            SDLabel(text: "Style", color: .green).position(x: styleLabelX, y: styleLabelY)
            SDLabel(text: "Ovary", color: .green).position(x: ovaryLabelX, y: ovaryLabelY)
            SDLabel(text: "Anther", color: .orange).position(x: antherLabelX, y: antherLabelY)
            SDLabel(text: "Petal", color: .pink).position(x: petalLabelX, y: petalLabelY)
        }
    }

    private func stamen(x: CGFloat, h: CGFloat) -> some View {
        let filamentH: CGFloat = h * 0.3
        let filamentY: CGFloat = h * 0.42
        let antherY: CGFloat = h * 0.26
        return ZStack {
            Capsule().fill(.orange.opacity(0.4)).frame(width: 4, height: filamentH)
                .position(x: x, y: filamentY)
            Ellipse().fill(.orange.opacity(0.65)).frame(width: 16, height: 10)
                .position(x: x, y: antherY)
        }
    }
}

// MARK: - ch12_pollen_tube

/// Fertilisation: a pollen grain landing on the stigma grows a pollen tube
/// down through the style to reach an ovule in the ovary, where the male and
/// female cells fuse.
struct PollenTubeDiagram: View {
    // Split into typed helpers so the Swift 5.5 type-checker (Big Sur / Xcode
    // 13.2.1) doesn't overflow its stack on one deep @ViewBuilder closure.
    var body: some View {
        SDFigure(tint: .green) {
            GeometryReader { geo in
                content(w: geo.size.width, h: geo.size.height)
            }
        }
    }

    private func content(w: CGFloat, h: CGFloat) -> some View {
        let cx: CGFloat = w * 0.4
        return ZStack {
            structures(w: w, h: h, cx: cx)
            labels(w: w, h: h, cx: cx)
        }
    }

    private func structures(w: CGFloat, h: CGFloat, cx: CGFloat) -> some View {
        let stigmaY: CGFloat = h * 0.16
        let styleH: CGFloat = h * 0.5
        let styleY: CGFloat = h * 0.45
        let ovaryY: CGFloat = h * 0.78
        let ovuleY: CGFloat = h * 0.8
        let tubeTopY: CGFloat = h * 0.18
        let tubeBottomY: CGFloat = h * 0.74
        return Group {
            // Stigma top, style, ovary with ovule
            Circle().fill(.orange.opacity(0.6)).frame(width: 16, height: 16).position(x: cx, y: stigmaY)
            Capsule().fill(.green.opacity(0.25)).frame(width: 22, height: styleH).position(x: cx, y: styleY)
            Ellipse().fill(.green.opacity(0.3))
                .overlay(Ellipse().stroke(.green.opacity(0.6), lineWidth: 1.5))
                .frame(width: 60, height: 50).position(x: cx, y: ovaryY)
            Circle().fill(Color.compatPurple.opacity(0.6)).frame(width: 14, height: 14).position(x: cx, y: ovuleY)
            // Growing pollen tube
            Path { p in
                p.move(to: CGPoint(x: cx, y: tubeTopY))
                p.addLine(to: CGPoint(x: cx, y: tubeBottomY))
            }.stroke(.orange.opacity(0.8), style: StrokeStyle(lineWidth: 2.5, dash: [4, 3]))
        }
    }

    private func labels(w: CGFloat, h: CGFloat, cx: CGFloat) -> some View {
        let pollenLabelX: CGFloat = cx + 56
        let pollenLabelY: CGFloat = h * 0.16
        let tubeLabelX: CGFloat = cx - 44
        let tubeLabelY: CGFloat = h * 0.45
        let ovuleLabelX: CGFloat = cx + 48
        let ovuleLabelY: CGFloat = h * 0.8
        return Group {
            SDLabel(text: "Pollen on stigma", color: .orange).position(x: pollenLabelX, y: pollenLabelY)
            SDLabel(text: "Pollen tube", color: .orange).position(x: tubeLabelX, y: tubeLabelY)
            SDLabel(text: "Ovule", color: Color.compatPurple).position(x: ovuleLabelX, y: ovuleLabelY)
        }
    }
}

// MARK: - ch12_seed_dispersal

/// Why seeds travel: spreading away from the parent gives each seed light,
/// water and space. The four common ways — wind, water, animals and bursting.
struct SeedDispersalDiagram: View {
    private let modes: [(String, String)] = [
        ("wind", "Wind — winged seeds"),
        ("drop.fill", "Water — floating seeds"),
        ("pawprint.fill", "Animals — sticky / eaten"),
        ("sparkles", "Bursting — pods explode")
    ]
    var body: some View {
        SDFigure(tint: .green) {
            VStack(spacing: 8) {
                ForEach(0..<modes.count, id: \.self) { i in
                    HStack(spacing: 8) {
                        Image(systemName: SFSymbolCompat.name(modes[i].0))
                            .font(.system(size: 16)).foregroundColor(.green)
                            .frame(width: 24)
                        SDLabel(text: modes[i].1, color: .green)
                        Spacer()
                    }
                }
            }
        }
    }
}

// MARK: - ch12_vegetative

/// New plants without seeds — vegetative propagation: from a runner, a tuber's
/// eyes, the leaf-margin buds of bryophyllum, or a planted stem cutting.
struct VegetativeDiagram: View {
    private let ways: [(String, String, Color)] = [
        ("Runner", "strawberry", .green),
        ("Tuber", "potato eyes", Color.compatBrown),
        ("Leaf buds", "bryophyllum", .green),
        ("Cutting", "rose stem", Color.compatBrown)
    ]
    var body: some View {
        SDFigure(tint: .green) {
            VStack(spacing: 6) {
                SDLabel(text: "One parent → identical new plants", color: .green)
                HStack(spacing: 8) {
                    ForEach(0..<ways.count, id: \.self) { i in
                        VStack(spacing: 3) {
                            Circle().fill(ways[i].2.opacity(0.25))
                                .overlay(Circle().stroke(ways[i].2.opacity(0.6), lineWidth: 1.5))
                                .frame(width: 34, height: 34)
                            Text(ways[i].0).font(.system(size: 9, weight: .bold)).foregroundColor(DesignTokens.BrandColor.canvasText)
                            SDLabel(text: ways[i].1, color: ways[i].2)
                        }
                    }
                }
            }
        }
    }
}
