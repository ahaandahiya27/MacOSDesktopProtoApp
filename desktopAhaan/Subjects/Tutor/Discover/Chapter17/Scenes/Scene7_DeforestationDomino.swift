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
        VStack(spacing: 14) {
            Text("Deforestation Domino").font(.largeTitle.bold()).foregroundColor(ChapterTheme.accent(for: chapter.id)).padding(.top, 18)
            Text("Each domino is a consequence. Tap to topple them.")
                .font(.callout).foregroundColor(.secondary)

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
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.06)))
                    .offset(x: i < fallen ? 0 : -20)
                    .opacity(i < fallen ? 1 : 0.55)
                    .animation(.easeOut(duration: 0.35), value: fallen)
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
            .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, 24)

            LookingAheadCallout(
                title: "Class 12 Bio → NEET",
                detail: "Class 12 'Biodiversity & Conservation' covers deforestation impacts globally and in India — the Chipko movement, Silent Valley, Project Tiger. NEET asks 'three causes of biodiversity loss' (habitat loss + over-exploitation + invasive species + co-extinction) every year."
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            GotItButton { onComplete() }.padding(.bottom, 12)
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
