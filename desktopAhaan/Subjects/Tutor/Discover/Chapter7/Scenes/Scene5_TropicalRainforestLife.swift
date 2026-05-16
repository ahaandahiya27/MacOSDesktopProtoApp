import SwiftUI

/// Scene 5 — Tropical Rainforest Life.
/// Layered rainforest: canopy, understory, forest floor. Tap each layer to see animals + adaptations.
@available(macOS 12, *)
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
        ForestLayer(id: 2, name: "Forest Floor", color: .brown.opacity(0.5), heightFraction: 0.34,
                    animals: [
                        (name: "Poison Dart Frog", adaptation: "Bright warning colours (red, yellow, blue) tell predators: 'I am toxic!'"),
                        (name: "Elephant", adaptation: "Sensitive trunk navigates dense undergrowth; large ears radiate excess heat"),
                    ]),
    ]

    private var allExplored: Bool { exploredLayers.count == layers.count }

    var body: some View {
        GeometryReader { _ in
            ZStack {
                mainColumn
                bottomOverlay
            }
        }
    }

    @ViewBuilder
    private var mainColumn: some View {
        VStack(spacing: 12) {
            Text("Tropical Rainforest Life")
                .font(.title2.bold())
                .padding(.top, 14)

            Text("\(exploredLayers.count) / \(layers.count) layers explored")
                .font(.caption.weight(.medium))
                .foregroundColor(.secondary)

            layersStack
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 24)
    }

    @ViewBuilder
    private var layersStack: some View {
        VStack(spacing: 0) {
            ForEach(layers) { layer in
                layerButton(layer)
            }
        }
        .frame(maxWidth: 500)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
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
    }

    @ViewBuilder
    private func layerButtonLabel(_ layer: ForestLayer, isSelected: Bool, isExplored: Bool) -> some View {
        ZStack {
            Rectangle()
                .fill(isSelected ? layer.color.opacity(0.9) : layer.color.opacity(0.5))

            VStack(spacing: 4) {
                Text(layer.name)
                    .font(.headline.bold())
                    .foregroundColor(.white)

                HStack(spacing: 12) {
                    ForEach(layer.animals, id: \.name) { animal in
                        Text(animal.name)
                            .font(.caption)
                            .padding(.horizontal, 8)
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
            Spacer()
            detailCard
                .frame(maxWidth: 640)

            if allExplored {
                GotItButton { onComplete() }
                    .padding(.bottom, 12)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .padding(.horizontal, 24)
    }

    @ViewBuilder
    private var detailCard: some View {
        SoftShadowCard(padding: 18) {
            VStack(alignment: .leading, spacing: 8) {
                if let idx = selectedLayer, let layer = layers.first(where: { $0.id == idx }) {
                    Label(layer.name, systemImage: "leaf.fill")
                        .font(.title2.bold())
                        .foregroundColor(layer.color)

                    ForEach(layer.animals, id: \.name) { animal in
                        VStack(alignment: .leading, spacing: 2) {
                            Text(animal.name)
                                .font(.body.bold())
                            Text(animal.adaptation)
                                .font(.callout)
                                .foregroundColor(.secondary)
                                .lineSpacing(3)
                        }
                        .padding(.top, 4)
                    }
                } else {
                    Label("Rainforest Layers", systemImage: "tree.fill")
                        .font(.title2.bold())
                    Text("Tropical rainforests are hot and humid all year, with heavy rainfall. They have three main layers — canopy, understory, and forest floor — each with unique animals. Tap a layer to explore!")
                        .font(.body)
                        .lineSpacing(4)
                }
            }
        }
    }
}
