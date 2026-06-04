import SwiftUI

// MARK: - Chapter 17 shape diagrams  (Forests: Our Lifeline)
//
// Pure-SwiftUI schematic diagrams for the four ch17 `shapeDiagram`
// MediaAssets. Big Sur / legacy-GPU rules honoured.

// MARK: - ch17_forest_layers

/// A forest grows in layers: tall trees form the canopy, smaller trees the
/// understorey, then shrubs, and the forest floor of herbs and litter.
struct ForestLayersDiagram: View {
    private let layers: [(String, Color, CGFloat)] = [
        ("Canopy — tall trees", .green, 0.7),
        ("Understorey — small trees", .green, 0.5),
        ("Shrub layer — bushes", .green, 0.35),
        ("Forest floor — herbs, litter", Color.compatBrown, 0.5)
    ]
    var body: some View {
        SDFigure(tint: .green) {
            VStack(spacing: 3) {
                ForEach(0..<layers.count, id: \.self) { i in
                    band(layers[i].0, layers[i].1, layers[i].2)
                }
            }
        }
    }

    private func band(_ name: String, _ c: Color, _ opacity: CGFloat) -> some View {
        ZStack {
            Rectangle().fill(c.opacity(Double(opacity) * 0.5))
            SDLabel(text: name, color: c)
        }
        .frame(maxHeight: .infinity)
    }
}

// MARK: - ch17_food_pyramid

/// A food pyramid (or food chain) in the forest: many plants (producers) feed
/// fewer plant-eaters, which feed still fewer meat-eaters at the top.
struct FoodPyramidDiagram: View {
    private let levels: [(String, Color, CGFloat)] = [
        ("Top carnivores", .red, 0.3),
        ("Carnivores", .orange, 0.55),
        ("Herbivores", Color.compatBrown, 0.78),
        ("Plants (producers)", .green, 1.0)
    ]
    var body: some View {
        SDFigure(tint: .green) {
            GeometryReader { geo in
                content(w: geo.size.width)
            }
        }
    }

    private func content(w: CGFloat) -> some View {
        VStack(spacing: 3) {
            ForEach(0..<levels.count, id: \.self) { i in
                let barW: CGFloat = w * levels[i].2
                ZStack {
                    RoundedRectangle(cornerRadius: 4).fill(levels[i].1.opacity(0.45))
                        .frame(width: barW)
                    SDLabel(text: levels[i].0, color: levels[i].1)
                }
                .frame(maxHeight: .infinity)
            }
        }
    }
}

// MARK: - ch17_nutrient_cycle

/// The forest recycles everything: dead leaves and animals are broken down by
/// decomposers into nutrients in the soil, which plants take up to grow and
/// feed animals again.
struct NutrientCycleDiagram: View {
    private let stages = ["Plants", "Animals", "Dead matter", "Decomposers", "Soil nutrients"]
    var body: some View {
        SDFigure(tint: Color.compatBrown) {
            GeometryReader { geo in
                content(w: geo.size.width, h: geo.size.height)
            }
        }
    }

    private func content(w: CGFloat, h: CGFloat) -> some View {
        let cx: CGFloat = w / 2
        let cy: CGFloat = h / 2
        let r: CGFloat = min(w, h) * 0.36
        let d: CGFloat = r * 2
        return ZStack {
            Circle().stroke(Color.compatBrown.opacity(0.4),
                            style: StrokeStyle(lineWidth: 2, dash: [4, 3]))
                .frame(width: d, height: d).position(x: cx, y: cy)
            SDLabel(text: "Nothing wasted", color: Color.compatBrown).position(x: cx, y: cy)
            Group {
                ForEach(0..<stages.count, id: \.self) { i in
                    node(stages[i], i: i, count: stages.count, cx: cx, cy: cy, r: r)
                }
            }
        }
    }

    private func node(_ title: String, i: Int, count: Int, cx: CGFloat, cy: CGFloat, r: CGFloat) -> some View {
        let angle: CGFloat = CGFloat(i) / CGFloat(count) * 2 * .pi - .pi / 2
        let x: CGFloat = cx + r * cos(angle)
        let y: CGFloat = cy + r * sin(angle)
        return SDLabel(text: title, color: .green).position(x: x, y: y)
    }
}

// MARK: - ch17_deforestation

/// Cutting down a forest costs more than its trees: bare land erodes, holds
/// less water and draws less rain, and wildlife loses its home.
struct DeforestationDiagram: View {
    var body: some View {
        SDFigure(tint: .green) {
            HStack(spacing: 14) {
                side(forest: true, title: "Forest", notes: ["Holds soil", "More rain", "Homes for animals"], tint: .green)
                Image(systemName: SFSymbolCompat.name("arrow.right"))
                    .font(.system(size: 16, weight: .bold)).foregroundColor(.red)
                side(forest: false, title: "Cleared", notes: ["Soil erodes", "Less rain", "Wildlife lost"], tint: Color.compatBrown)
            }
        }
    }

    private func side(forest: Bool, title: String, notes: [String], tint: Color) -> some View {
        VStack(spacing: 5) {
            HStack(spacing: 3) {
                ForEach(0..<3, id: \.self) { _ in
                    Image(systemName: SFSymbolCompat.name(forest ? "leaf.fill" : "circle.fill"))
                        .font(.system(size: forest ? 14 : 7)).foregroundColor(forest ? .green : Color.compatBrown)
                }
            }
            Text(title).font(.system(size: 11, weight: .bold)).foregroundColor(DesignTokens.BrandColor.canvasText)
            ForEach(0..<notes.count, id: \.self) { i in
                SDLabel(text: notes[i], color: tint)
            }
        }
    }
}
