import SwiftUI

/// Scene 6 — Vegetative Propagation. Pick a plant; see which part grows a new one.
struct Scene6_VegetativePropagation: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    enum Plant: String, CaseIterable, Identifiable {
        case potato = "Potato", rose = "Rose", bryophyllum = "Bryophyllum", onion = "Onion"
        var id: String { rawValue }
        var emoji: String {
            switch self { case .potato: return "🥔"; case .rose: return "🌹"; case .bryophyllum: return "🌱"; case .onion: return "🧅" }
        }
        var partUsed: String {
            switch self {
            case .potato:      return "Tuber — the 'eyes' sprout new shoots"
            case .rose:        return "Stem cutting — sticks into soil & grows roots"
            case .bryophyllum: return "Leaf margin — buds grow into mini-plants and fall off"
            case .onion:       return "Bulb — stores food underground, sprouts new plants"
            }
        }
    }

    @State private var plant: Plant = .potato

    var body: some View {
        // Wrapped in ScrollView so the scene scrolls on
        // shorter windows and overflowing content remains accessible.
        ScrollView {
            LazyVStack(alignment: .center, spacing: 14) {
                Text("Vegetative Propagation").font(.largeTitle.bold()).foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                Text("No flowers, no seeds — these plants clone themselves.")
                    .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)

                Picker("", selection: $plant) {
                    ForEach(Plant.allCases) { Text($0.rawValue).tag($0) }
                }.pickerStyle(.segmented).discoverControlChrome().frame(maxWidth: 460)

                Text(plant.emoji).font(.system(size: 96))

                SoftShadowCard(padding: 18) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(plant.rawValue).font(.title3.bold())
                        Text(plant.partUsed).font(.body).lineSpacing(4)
                        Text("Offspring are genetic clones of the parent — fast and reliable, but no variety.").font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    }
                }
                .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, 24)

                LookingAheadCallout(
                    title: "Class 12 Bio",
                    detail: "Class 12 Bio covers the commercial uses: micropropagation in tissue culture (cloning orchids and bananas at scale), grafting in fruit trees, runners in strawberries and suckers in bananas. NEET asks these in Plant Biotechnology."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)

                TryAtHomeCallout(
                    title: "Money-plant cutting",
                    detail: "Cut a stem from a money-plant (or pothos) so it includes 2 nodes. Place the cut end in a glass of water on a windowsill. Roots will sprout in 7-14 days. No seed needed — you've cloned the parent."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)

                GotItButton { onComplete() }.padding(.bottom, 12)
                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
        }

        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
