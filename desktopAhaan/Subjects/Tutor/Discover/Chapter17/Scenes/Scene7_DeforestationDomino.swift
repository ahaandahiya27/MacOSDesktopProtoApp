import SwiftUI

/// Scene 7 — Deforestation Domino. Tap to topple consequences one by one.
struct Scene7_DeforestationDomino: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var fallen: Int = 0
    private let chain = [
        "🪓 Forest cut",
        "🌧 Less rain locally",
        "🟫 Soil erodes",
        "🌊 Floods downstream",
        "🌡 Temperature rises",
        "🦒 Animals lose homes",
    ]

    var body: some View {
        // Wrapped in ScrollView so the scene scrolls on
        // shorter windows and overflowing content remains accessible.
        ScrollView {
            LazyVStack(alignment: .center, spacing: 14) {
                Text("Deforestation Domino").font(.largeTitle.bold()).foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                Text("Each domino is a consequence. Tap to topple them.")
                    .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)

                VStack(spacing: 6) {
                    ForEach(0..<chain.count, id: \.self) { i in
                        HStack {
                            Text(chain[i])
                                .font(.headline)
                                .foregroundColor(i < fallen ? .red : .secondary)
                            Spacer()
                            if i < fallen { Image(systemName: "arrow.down").foregroundColor(.red) }
                        }
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.95)))
                        .offset(x: i < fallen ? 0 : -20)
                        .opacity(i < fallen ? 1 : 0.55)
                        .respectReduceMotion(animation: .easeOut(duration: 0.35))
                    }
                }
                .frame(maxWidth: 480)

                Button(fallen < chain.count ? "Topple next" : "Reset") {
                    if fallen < chain.count { fallen += 1 } else { fallen = 0 }
                }
                .accentColor(Color.compatIndigo)

                SoftShadowCard(padding: 14) {
                    Text("Forest loss doesn't stop at the chainsaw. The damage cascades through climate, water, soil and wildlife — often hurting communities thousands of km away.")
                        .font(.callout).lineSpacing(4)
                }
                .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, DesignTokens.Spacing.xl)

                LookingAheadCallout(
                    title: "Class 12 Bio → NEET",
                    detail: "Class 12 'Biodiversity & Conservation' covers the effects of deforestation in India and worldwide. Case studies include the Chipko movement, Silent Valley and Project Tiger. NEET asks for the causes of biodiversity loss every year. The four are habitat loss, over-exploitation, invasive species and co-extinction."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, DesignTokens.Spacing.xl)

                TryAtHomeCallout(
                    title: "News-search exercise",
                    detail: "Search 'deforestation India 2024' on a news site. Pick one story. Identify which dominoes from this scene applied to that case: was there flooding? topsoil loss? wildlife displacement? climate impact?"
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, DesignTokens.Spacing.xl)

                GotItButton { onComplete() }.padding(.bottom, DesignTokens.Spacing.md)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, DesignTokens.Spacing.md)
        }
    }
}
