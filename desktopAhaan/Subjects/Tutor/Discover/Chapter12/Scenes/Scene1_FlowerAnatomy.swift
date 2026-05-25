import SwiftUI

/// Scene 1 — Flower Anatomy. Tap each part to learn its role.
struct Scene1_FlowerAnatomy: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    enum Part: String, CaseIterable, Identifiable {
        case petal = "Petal", stamen = "Stamen", pistil = "Pistil (Carpel)", sepal = "Sepal"
        var id: String { rawValue }
        var emoji: String {
            switch self { case .petal: return "🌸"; case .stamen: return "🟡"; case .pistil: return "🌿"; case .sepal: return "🍃" }
        }
        var role: String {
            switch self {
            case .petal:  return "Bright leaves that attract pollinators with colour and scent."
            case .stamen: return "Male part. Anther on top makes pollen; filament holds it up."
            case .pistil: return "Female part. Has stigma (catches pollen), style, and ovary (holds eggs)."
            case .sepal:  return "Green leaf-like covers that protect the bud before it opens."
            }
        }
    }

    @State private var pick: Part = .petal

    var body: some View {
        // Wrapped in ScrollView so the scene scrolls on
        // shorter windows and overflowing content remains accessible.
        ScrollView {
            LazyVStack(alignment: .center, spacing: 14) {
                Text("Flower Anatomy").font(.largeTitle.bold()).foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                Text("Tap a part to find out what it does.").font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)

                ZStack {
                    RoundedRectangle(cornerRadius: 18).fill(Color.pink.opacity(0.10)).frame(width: 320, height: 220)
                    Text("🌷").font(.system(size: 120))
                        .accessibilityLabel("A flower showing its sepals, petals, stamen and pistil")
                }

                HStack(spacing: 10) {
                    ForEach(Part.allCases) { p in
                        Button { pick = p } label: {
                            VStack {
                                Text(p.emoji).font(.system(size: 28))
                                Text(p.rawValue).font(.caption)
                            }
                            .padding(8)
                            .background(RoundedRectangle(cornerRadius: 8).fill(pick == p ? Color.compatIndigo.opacity(0.15) : Color.white.opacity(0.95)))
                        }
                        .buttonStyle(.plain)
                    }
                }

                SoftShadowCard(padding: 18) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(pick.rawValue).font(.title3.bold())
                        Text(pick.role).font(.body).lineSpacing(4)
                    }
                }
                .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, 24)

                HotspotDiagram(
                    title: "Parts of a flower — tap each number",
                    baseSymbol: "leaf.fill",
                    baseColor: .pink,
                    hotspots: [
                        .init(x: 0.50, y: 0.10, label: "Stigma",
                              detail: "The sticky top of the pistil. Catches pollen grains that pollinators or wind deposit."),
                        .init(x: 0.50, y: 0.30, label: "Style",
                              detail: "The slender stalk between stigma and ovary. Pollen tubes grow down through it to reach the egg."),
                        .init(x: 0.50, y: 0.55, label: "Ovary (with ovules inside)",
                              detail: "Female part. Holds the ovules (future seeds). After fertilisation the ovary swells into a fruit."),
                        .init(x: 0.25, y: 0.40, label: "Stamen — anther + filament",
                              detail: "Male part. The anther produces pollen grains; the filament holds it up where pollinators can reach it."),
                        .init(x: 0.75, y: 0.40, label: "Petals",
                              detail: "Coloured, often scented. Their job is to attract pollinators (bees, butterflies, birds, beetles)."),
                        .init(x: 0.50, y: 0.85, label: "Sepals",
                              detail: "Usually green, leaf-like. Protect the flower bud while it grows; sit at the base of the open flower.")
                    ]
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)

                LookingAheadCallout(
                    title: "Class 12 Bio → NEET",
                    detail: "Class 12 'Sexual Reproduction in Flowering Plants' covers microsporogenesis (pollen formation in anther), megasporogenesis (egg formation in ovule), and the embryo-sac structure (8 nuclei / 7 cells)."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)

                TryAtHomeCallout(
                    title: "Dissect a hibiscus",
                    detail: "Pluck one fresh hibiscus flower from a garden or roadside. Gently pull it apart on a plate — count 5 petals, 5 fused sepals, many stamens (the yellow-orange male parts), and one pistil with a sticky stigma. India's national-list flower for biology practicals."
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
