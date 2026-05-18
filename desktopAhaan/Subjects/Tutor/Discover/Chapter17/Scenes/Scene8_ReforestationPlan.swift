import SwiftUI

/// Scene 8 — Reforestation Plan. Toggle actions; counter shows trees planted.
struct Scene8_ReforestationPlan: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var actions: [Bool] = Array(repeating: false, count: 5)
    private let texts = [
        "Plant 5 saplings in our locality",
        "Adopt a tree at school",
        "Avoid single-use paper products",
        "Compost kitchen waste at home",
        "Take part in a Van Mahotsav drive",
    ]
    private var trees: Int { actions.enumerated().reduce(0) { $0 + (actions[$1.offset] ? [5, 1, 2, 1, 10][$1.offset] : 0) } }

    var body: some View {
        // Wrapped in ScrollView so the scene scrolls on
        // shorter windows and overflowing content remains accessible.
        ScrollView {
    VStack(spacing: 14) {
                Text("Reforestation Plan").font(.largeTitle.bold()).foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                Text("Pick actions you'll commit to. We'll count the trees you help.")
                    .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary).multilineTextAlignment(.center)

                VStack(spacing: 8) {
                    ForEach(0..<actions.count, id: \.self) { i in
                        Toggle(texts[i], isOn: $actions[i])
                            .padding(10)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.95)))
                    }
                }
                .frame(maxWidth: 560)

                Text("Trees helped: \(trees) 🌳")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.green)

                SoftShadowCard(padding: 14) {
                    Text("Van Mahotsav (July first week) is India's annual tree-planting festival. Started in 1950 by Dr K M Munshi, it has planted millions of trees.")
                        .font(.callout).lineSpacing(4)
                }
                .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, 24)

                LookingAheadCallout(
                    title: "Class 12 Bio + Civics",
                    detail: "Class 12 'Biodiversity & Conservation' covers in-situ (national parks, biosphere reserves, sacred groves) and ex-situ (zoos, botanical gardens, seed banks) strategies. Class 10 Civics covers India's Forest Rights Act 2006 and the role of local communities."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)

                TryAtHomeCallout(
                    title: "Plant a sapling",
                    detail: "Visit a nursery, pick a native tree sapling (neem, banyan, peepal). Plant it in a corner of your garden or school grounds. Water daily for two weeks, then weekly. In five years, you've given the planet a tree that absorbs 21 kg of CO₂ a year."
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
