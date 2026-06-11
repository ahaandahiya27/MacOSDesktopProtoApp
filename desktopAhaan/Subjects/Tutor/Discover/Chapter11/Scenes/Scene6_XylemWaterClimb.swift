import SwiftUI

/// Scene 6 — Xylem Water Climb. Animated dye crawls up celery stem.
struct Scene6_XylemWaterClimb: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var rise: CGFloat = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        // Wrapped in ScrollView so the scene scrolls on
        // shorter windows and overflowing content remains accessible.
        ScrollView {
            LazyVStack(alignment: .center, spacing: 14) {
                Text("Xylem Water Climb").font(.largeTitle.bold()).foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                Text("Put celery in coloured water. Watch the dye climb the stem.")
                    .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)

                ZStack(alignment: .bottom) {
                    RoundedRectangle(cornerRadius: 6).fill(Color.green.opacity(0.5))
                        .frame(width: 38, height: 240)
                    RoundedRectangle(cornerRadius: 4).fill(Color.red.opacity(0.7))
                        .frame(width: 28, height: rise)
                        .animation(reduceMotion ? .none : .easeInOut(duration: 2.4))
                }
                .padding(.bottom, 6)

                HStack(spacing: DesignTokens.Spacing.lg) {
                    Button("Start dye climb") { rise = 200 }.accentColor(Color.compatIndigo)
                    Button("Reset")            { rise = 0  }
                }

                SoftShadowCard(padding: 18) {
                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                        Label("Plants drink upwards", systemImage: "arrow.up")
                            .font(.title2.bold())
                        Text("Xylem are narrow tubes inside the stem. Water with dissolved minerals climbs from the roots all the way to the leaves. The pull comes from water evaporating out of the leaves (transpiration).")
                            .font(.body).lineSpacing(4)
                    }
                }
                .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, DesignTokens.Spacing.xl)

                TryAtHomeCallout(
                    title: "Celery + food colouring",
                    detail: "Put a stick of celery (with leaves) into a glass of water with a few drops of red food colouring. Look at it after 1 hour, 4 hours, overnight. Watch the dye climb."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, DesignTokens.Spacing.xl)

                GotItButton { onComplete() }.padding(.bottom, DesignTokens.Spacing.md)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, DesignTokens.Spacing.md)
        }

        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
