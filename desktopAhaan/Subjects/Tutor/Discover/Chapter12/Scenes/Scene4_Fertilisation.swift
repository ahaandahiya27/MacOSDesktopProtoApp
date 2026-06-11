import SwiftUI

/// Scene 4 — Fertilisation. Slider for time: pollen → tube grows → ovule fertilised → seed.
struct Scene4_Fertilisation: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var stage: Double = 0   // 0..3

    private var stageInfo: (emoji: String, label: String) {
        switch Int(stage) {
        case 0: return ("🟡 → 🌸", "Pollen lands on stigma")
        case 1: return ("🟡↓🌿", "Pollen tube grows down the style")
        case 2: return ("✨🥚", "Sperm nucleus meets the egg in the ovary")
        default: return ("🌱", "Fertilised ovule becomes a seed")
        }
    }

    var body: some View {
        // Wrapped in ScrollView so the scene scrolls on
        // shorter windows and overflowing content remains accessible.
        ScrollView {
            LazyVStack(alignment: .center, spacing: 14) {
                Text("Fertilisation").font(.largeTitle.bold()).foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                Text("Slide forward to see how a seed is formed.").font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)

                ZStack {
                    RoundedRectangle(cornerRadius: 18).fill(Color.green.opacity(0.12))
                        .frame(width: 320, height: 220)
                    VStack(spacing: 6) {
                        Text(stageInfo.emoji).font(.system(size: 64))
                        Text(stageInfo.label).font(.headline).foregroundColor(Color.compatIndigo)
                    }
                }

                Slider(value: $stage, in: 0...3, step: 1).frame(maxWidth: 460).padding(.horizontal, DesignTokens.Spacing.xl)
                HStack {
                    Text("1. Pollination").font(.caption); Spacer()
                    Text("2. Tube"        ).font(.caption); Spacer()
                    Text("3. Fusion"      ).font(.caption); Spacer()
                    Text("4. Seed"        ).font(.caption)
                }.frame(maxWidth: 460).padding(.horizontal, DesignTokens.Spacing.xl)

                SoftShadowCard(padding: 18) {
                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                        Label("Pollination ≠ Fertilisation", systemImage: SFSymbolCompat.name("leaf.arrow.triangle.circlepath"))
                            .font(.title2.bold())
                        Text("Pollination is just the delivery of pollen. Fertilisation happens later: the pollen grows a tube down to the ovary, where its sperm nucleus fuses with the egg. The ovule then becomes a seed and the ovary becomes a fruit.")
                            .font(.body).lineSpacing(4)
                    }
                }
                .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, DesignTokens.Spacing.xl)

                LookingAheadCallout(
                    title: "Class 12 Bio → NEET",
                    detail: "Class 12 'Sexual Reproduction in Flowering Plants' covers microsporogenesis, megasporogenesis, and the famous double fertilisation. Two male gametes take part. One fuses with the egg to make a diploid zygote. The other fuses with the central cell to make a triploid endosperm nucleus. That the endosperm is triploid (3n) is a guaranteed NEET fact."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, DesignTokens.Spacing.xl)

                TryAtHomeCallout(
                    title: "Watch a flower become a fruit",
                    detail: "Mark one fresh flower on a tomato or chilli plant with a coloured thread. Check daily. Over 4-6 weeks you'll watch the petals fall, the ovary swell, and a tiny green fruit form where the flower was."
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
