import SwiftUI

/// Scene 1 — Where Drain Water Goes. Follow the pipe from sink to treatment plant.
struct Scene1_WhereDrainWaterGoes: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var step: Int = 0
    private let path = ["🚿 Sink / toilet", "🚰 House drain", "🕳 Sewer pipe", "🏭 Wastewater plant", "🌊 Clean → river"]

    var body: some View {
        // Wrapped in ScrollView so the scene scrolls on
        // shorter windows and overflowing content remains accessible.
        ScrollView {
            LazyVStack(alignment: .center, spacing: 14) {
                Text("Where Does Drain Water Go?").font(.largeTitle.bold()).foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                Text("Tap Next to follow the journey from your tap to the river.")
                    .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)

                VStack(spacing: DesignTokens.Spacing.sm) {
                    ForEach(0..<path.count, id: \.self) { i in
                        HStack {
                            Text(path[i]).font(.headline)
                                .foregroundColor(i <= step ? Color.compatIndigo : .secondary)
                            Spacer()
                            if i <= step {
                                Image(systemName: "drop.fill").foregroundColor(.blue)
                                    .accessibilityLabel("Reached this stage of the wastewater journey")
                            }
                        }
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.95)))
                    }
                }
                .frame(maxWidth: 480)

                HStack(spacing: 14) {
                    Button("Next step") { step = min(step + 1, path.count - 1) }.accentColor(Color.compatIndigo)
                    Button("Reset") { step = 0 }
                }

                SoftShadowCard(padding: 14) {
                    Text("Wastewater (or sewage) is the dirty water from kitchens, bathrooms and industries. It travels through underground sewer pipes to a treatment plant before being returned to rivers or the sea.")
                        .font(.callout).lineSpacing(4)
                }
                .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, DesignTokens.Spacing.xl)

                LookingAheadCallout(
                    title: "Class 12 Bio → NEET",
                    detail: "Class 12 'Environmental Issues' covers sewage treatment. The primary stage is physical. The secondary stage is biological. The tertiary stage is chemical. BOD and COD measure pollution. NEET tests BOD-curve questions every year."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, DesignTokens.Spacing.xl)

                TryAtHomeCallout(
                    title: "Trace your kitchen sink",
                    detail: "Open the cabinet under your kitchen sink. Follow the pipe out of the wall as far as you can see. It goes through the floor, the wall, joins the main sewer line on your street — and from there, kilometres to a treatment plant."
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
