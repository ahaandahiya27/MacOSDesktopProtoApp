import SwiftUI

/// Scene 5 — Tropical Rainforest Life.
/// Layered rainforest: canopy, understory, forest floor. Tap each layer to see animals + adaptations.

struct Scene5_TropicalRainforestLife: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var selectedLayer: Int? = nil
    @State private var exploredLayers: Set<Int> = []
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private struct ForestLayer: Identifiable {
        let id: Int
        let name: String
        let color: Color
        let heightFraction: CGFloat
        let animals: [(name: String, adaptation: String)]
    }

    private let layers: [ForestLayer] = [
        ForestLayer(id: 0, name: "Canopy", color: .green.opacity(0.7), heightFraction: 0.33,
                    animals: [
                        (name: "Toucan", adaptation: "Large beak helps reach fruit on thin branches and acts as a heat radiator to cool down"),
                        (name: "Sloth", adaptation: "Moves slowly to conserve energy; algae grows on fur for camouflage"),
                    ]),
        ForestLayer(id: 1, name: "Understory", color: .green.opacity(0.5), heightFraction: 0.33,
                    animals: [
                        (name: "Monkey", adaptation: "Prehensile (gripping) tail acts like a fifth hand for swinging between branches"),
                        (name: "Lion-tailed Macaque", adaptation: "Rain-shedding fur keeps dry in heavy downpours; cheek pouches store food"),
                    ]),
        ForestLayer(id: 2, name: "Forest Floor", color: Color.compatBrown.opacity(0.5), heightFraction: 0.34,
                    animals: [
                        (name: "Poison Dart Frog", adaptation: "Bright warning colours (red, yellow, blue) tell predators: 'I am toxic!'"),
                        (name: "Elephant", adaptation: "Sensitive trunk navigates dense undergrowth; large ears radiate excess heat"),
                    ]),
    ]

    private var allExplored: Bool { exploredLayers.count == layers.count }

    var body: some View {
        // Refactored ZStack-overlap to ScrollView+VStack so the bottom
        // card stack doesn't overlay the rainforest-layer buttons.
        ScrollView {
            LazyVStack(alignment: .center, spacing: 14) {
                mainColumn
                bottomOverlay
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, DesignTokens.Spacing.md)
        }
    }

    @ViewBuilder
    private var mainColumn: some View {
        VStack(spacing: DesignTokens.Spacing.md) {
            Text("Tropical Rainforest Life")
                .font(.title2.bold())
                .padding(.top, 14)

            Text("\(exploredLayers.count) / \(layers.count) layers explored")
                .font(.caption.weight(.medium))
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)

            layersStack
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, DesignTokens.Spacing.xl)
    }

    @ViewBuilder
    private var layersStack: some View {
        VStack(spacing: 0) {
            ForEach(layers) { layer in
                layerButton(layer)
            }
        }
        .frame(maxWidth: 500)
        .clipShape(RoundedRectangle(cornerRadius: DesignTokens.Radius.card))
        .overlay(
            RoundedRectangle(cornerRadius: DesignTokens.Radius.card)
                .strokeBorder(.gray.opacity(0.3), lineWidth: 1)
        )
    }

    @ViewBuilder
    private func layerButton(_ layer: ForestLayer) -> some View {
        let isSelected = selectedLayer == layer.id
        let isExplored = exploredLayers.contains(layer.id)

        Button {
            withAnimation(reduceMotion ? .none : .spring()) {
                selectedLayer = layer.id
                exploredLayers.insert(layer.id)
            }
        } label: {
            layerButtonLabel(layer, isSelected: isSelected, isExplored: isExplored)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(layer.name) layer. \(isExplored ? "Explored" : "Tap to explore")")
        .accessibilityHint("Selects this rainforest layer to see its inhabitants")
    }

    @ViewBuilder
    private func layerButtonLabel(_ layer: ForestLayer, isSelected: Bool, isExplored: Bool) -> some View {
        ZStack {
            Rectangle()
                .fill(isSelected ? layer.color.opacity(0.9) : layer.color.opacity(0.5))

            VStack(spacing: DesignTokens.Spacing.xs) {
                Text(layer.name)
                    .font(.headline.bold())
                    .foregroundColor(.white)

                HStack(spacing: DesignTokens.Spacing.md) {
                    ForEach(layer.animals, id: \.name) { animal in
                        Text(animal.name)
                            .font(.caption)
                            .padding(.horizontal, DesignTokens.Spacing.sm)
                            .padding(.vertical, 3)
                            .background(Capsule().fill(.white.opacity(0.3)))
                            .foregroundColor(.white)
                    }
                }

                if isExplored {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.white)
                        .font(.caption)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 80)
        .overlay(
            Rectangle()
                .strokeBorder(isSelected ? .white : .clear, lineWidth: 2)
        )
    }

    @ViewBuilder
    private var bottomOverlay: some View {
        VStack(spacing: 14) {
            detailCard
                .frame(maxWidth: DesignTokens.contentMaxWidth)

            LookingAheadCallout(
                title: "Class 11 Biology → NEET (Biodiversity hotspots)",
                detail: "Tropical rainforests cover ~7% of Earth's land but host >50% of species — the highest biodiversity per square km on the planet. NEET asks the 4 stratification layers (emergent / canopy / understorey / forest floor) and why each houses different species. India's Western Ghats are one of the 36 global biodiversity hotspots — Class 12 Ecology tests this often."
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)

            TryAtHomeCallout(
                title: "Mini-rainforest in a jar",
                detail: "Wash an empty jam jar. Add 2 cm pebbles → 1 cm activated charcoal → 3 cm potting soil. Plant 2-3 small moss or fern pieces. Spritz with water. Seal the lid. The jar is now a closed ecosystem — moisture evaporates, condenses on the glass, drips back down (water cycle). With light, it'll self-sustain for months. You've built a terrarium that mimics rainforest humidity recycling."
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)

            if allExplored {
                GotItButton { onComplete() }
                    .padding(.bottom, DesignTokens.Spacing.md)
            }
        }
        .padding(.horizontal, DesignTokens.Spacing.xl)
    }

    @ViewBuilder
    private var detailCard: some View {
        SoftShadowCard(padding: 18) {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                if let idx = selectedLayer, let layer = layers.first(where: { $0.id == idx }) {
                    Label(layer.name, systemImage: "leaf.fill")
                        .font(.title2.bold())
                        .foregroundColor(layer.color)

                    ForEach(layer.animals, id: \.name) { animal in
                        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xxs) {
                            Text(animal.name)
                                .font(.body.bold())
                            Text(animal.adaptation)
                                .font(.callout)
                                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                                .lineSpacing(3)
                        }
                        .padding(.top, DesignTokens.Spacing.xs)
                    }
                } else {
                    Label("Rainforest Layers", systemImage: SFSymbolCompat.name("tree.fill"))
                        .font(.title2.bold())
                    Text("Tropical rainforests are hot and humid all year, with heavy rainfall. They have three main layers — canopy, understory, and forest floor — each with unique animals. Tap a layer to explore!")
                        .font(.body)
                        .lineSpacing(4)
                }
            }
        }
    }
}
