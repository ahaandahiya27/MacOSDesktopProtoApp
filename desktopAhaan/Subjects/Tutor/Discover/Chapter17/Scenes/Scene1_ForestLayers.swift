import SwiftUI

/// Scene 1 — Forest Layers. Tap canopy → understory → shrub → floor.
struct Scene1_ForestLayers: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    enum Layer: String, CaseIterable, Identifiable {
        case canopy = "Canopy", understory = "Understory", shrub = "Shrub", floor = "Forest floor"
        var id: String { rawValue }
        var blurb: String {
            switch self {
            case .canopy:     return "Top umbrella of tall trees. Most sunlight here. Home to birds, monkeys, leopards."
            case .understory: return "Mid-level smaller trees, woody vines. Filtered light. Many young trees waiting their turn."
            case .shrub:      return "Bushes, ferns, and grasses. Where deer and rodents browse."
            case .floor:      return "Dark, damp ground covered in leaf litter. Decomposers and insects thrive."
            }
        }
    }
    @State private var pick: Layer = .canopy

    var body: some View {
        VStack(spacing: 14) {
            Text("Forest Layers").font(.largeTitle.bold()).padding(.top, 18)
            Text("A forest is built like a 4-storey building. Tap each floor.")
                .font(.callout).foregroundColor(.secondary)

            VStack(spacing: 2) {
                ForEach(Layer.allCases) { l in
                    Button { pick = l } label: {
                        HStack { Text(l.rawValue).foregroundColor(.white); Spacer() }
                            .padding()
                            .frame(width: 320, height: 50)
                            .background(layerColor(l).opacity(0.85))
                            .overlay(Rectangle().strokeBorder(pick == l ? Color.compatIndigo : .clear, lineWidth: 3))
                    }
                    .buttonStyle(.plain)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))

            SoftShadowCard(padding: 16) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(pick.rawValue).font(.title3.bold())
                    Text(pick.blurb).font(.body).lineSpacing(4)
                }
            }
            .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, 24)

            GotItButton { onComplete() }.padding(.bottom, 12)
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func layerColor(_ l: Layer) -> Color {
        switch l {
        case .canopy:     return Color(red: 0.1, green: 0.4, blue: 0.1)
        case .understory: return Color(red: 0.2, green: 0.55, blue: 0.2)
        case .shrub:      return Color(red: 0.35, green: 0.65, blue: 0.25)
        case .floor:      return Color(red: 0.35, green: 0.25, blue: 0.15)
        }
    }
}
