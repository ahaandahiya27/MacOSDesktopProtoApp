import SwiftUI

/// Scene 7 — Budding. Tap to grow a bud on yeast; it pops off into a new cell.
struct Scene7_Budding: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var stage: Int = 0   // 0 parent, 1 small bud, 2 big bud, 3 detached

    var body: some View {
        // Wrapped in ScrollView so the scene scrolls on
        // shorter windows and overflowing content remains accessible.
        ScrollView {
            LazyVStack(alignment: .center, spacing: 14) {
                Text("Budding").font(.largeTitle.bold()).foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                Text("Tap to grow the bud. Watch it become a new yeast cell.")
                    .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)

                ZStack {
                    RoundedRectangle(cornerRadius: 18).fill(Color.yellow.opacity(0.12))
                        .frame(width: 320, height: 220)
                    HStack(spacing: CGFloat([4, 8, 16, 60][min(stage, 3)])) {
                        Circle().fill(Color.orange.opacity(0.7)).frame(width: 80, height: 80)
                        Circle().fill(Color.orange.opacity(0.7))
                            .frame(width: CGFloat([0, 20, 50, 70][min(stage, 3)]),
                                   height: CGFloat([0, 20, 50, 70][min(stage, 3)]))
                    }
                    .respectReduceMotion(animation: .easeInOut(duration: 0.4))
                }

                Button("Next step") { stage = min(stage + 1, 3) }
                    .accentColor(Color.compatIndigo)

                SoftShadowCard(padding: 18) {
                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                        Label("A bump that breaks free", systemImage: "circle.grid.3x3")
                            .font(.title2.bold())
                        Text("Yeast and hydra reproduce by budding. A small outgrowth forms on the parent, grows bigger, then detaches as a complete new organism — a clone of the parent.")
                            .font(.body).lineSpacing(4)
                    }
                }
                .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, DesignTokens.Spacing.xl)

                LookingAheadCallout(
                    title: "Class 12 Bio → NEET",
                    detail: "Class 12 'Reproduction in Organisms' covers asexual modes. Amoeba uses binary fission. Plasmodium uses multiple fission. Hydra and yeast use budding. Spirogyra uses fragmentation. Rhizopus makes spores. NEET tests these every year."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, DesignTokens.Spacing.xl)

                TryAtHomeCallout(
                    title: "Watch bread rise",
                    detail: "Mix yeast + warm water + sugar + flour. Cover and wait 1 hour. The dough doubles in size because of CO₂ from yeast cells budding their way through it. Same chemistry as Scene 3 of this chapter — just baked."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, DesignTokens.Spacing.xl)

                GotItButton { onComplete() }.padding(.bottom, DesignTokens.Spacing.md)
                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, DesignTokens.Spacing.md)
        }

        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
