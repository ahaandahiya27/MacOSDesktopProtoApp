import SwiftUI

/// Scene 3 — Refraction Pool. Drop a pencil into water; it appears to bend.
struct Scene3_RefractionPool: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var inWater = false
    @State private var poolDepthM: Double = 2          // free-play: real pool depth in metres

    var body: some View {
        VStack(spacing: 14) {
            Text("Refraction Pool").font(.largeTitle.bold()).foregroundColor(ChapterTheme.accent(for: chapter.id)).padding(.top, 18)
            Text("Dip a pencil into water. Notice how it appears to break at the surface.")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)

            ZStack(alignment: .center) {
                VStack(spacing: 0) {
                    Rectangle().fill(Color.white).frame(width: 280, height: 100)
                    Rectangle().fill(Color.blue.opacity(0.35)).frame(width: 280, height: 100)
                }
                .clipShape(RoundedRectangle(cornerRadius: 8))

                if inWater {
                    VStack(spacing: -8) {
                        Rectangle().fill(Color.compatBrown).frame(width: 8, height: 80)
                            .rotationEffect(.degrees(15), anchor: .bottom)
                        Rectangle().fill(Color.compatBrown).frame(width: 8, height: 80)
                            .rotationEffect(.degrees(-25), anchor: .top)
                    }
                } else {
                    Rectangle().fill(Color.compatBrown).frame(width: 8, height: 160)
                        .rotationEffect(.degrees(15))
                }
            }

            Button(inWater ? "Pull pencil out" : "Dip pencil in water") { inWater.toggle() }
                .accentColor(Color.compatIndigo)

            SoftShadowCard(padding: 18) {
                VStack(alignment: .leading, spacing: 8) {
                    Label("Light bends when it changes medium", systemImage: "drop.fill")
                        .font(.title2.bold())
                    Text("When light goes from air into water, it slows down and changes direction. Your eye thinks the pencil is where the light SEEMS to come from — so it looks broken. This bending is called refraction.")
                        .font(.body).lineSpacing(4)
                }
            }
            .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, 24)

            TryAtHomeCallout(
                title: "The reappearing coin",
                detail: "Drop a coin into an opaque bowl. Step back until the rim hides the coin. Without moving, ask someone to slowly pour water into the bowl. The coin appears — refraction bends the light around the rim."
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            DiscoveryWidget(
                title: "Discovery — apparent vs real pool depth",
                subtitle: "Apparent depth = real depth ÷ refractive index (water ≈ 1.33). Drag to see why pools look shallower.",
                value: $poolDepthM,
                range: 0.5...4,
                step: 0.1,
                valueLabel: { v in String(format: "Real depth: %.1f m", v) },
                output: apparentDepthExplanation
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            GotItButton { onComplete() }.padding(.bottom, 12)
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func apparentDepthExplanation(_ real: Double) -> String {
        let apparent = real / 1.33
        let label: String
        switch real {
        case ..<1:
            label = "Wading pool. Looks even shallower — pretty safe for tiny kids."
        case ..<2:
            label = "Children's pool. Looks ~25% shallower — common cause of misjudged dives."
        case 2..<3:
            label = "Standard adult pool. Looks deceptively safer than it is — always check the depth sign."
        default:
            label = "Deep dive zone. Looks far more inviting than it should — never jump without checking."
        }
        return String(format: "Looks like %.1f m. (Real: %.1f m.) ", apparent, real) + label
    }
}
