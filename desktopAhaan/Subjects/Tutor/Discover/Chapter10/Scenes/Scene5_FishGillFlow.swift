import SwiftUI

/// Scene 5 — Fish Gill Flow. Animation showing water in through mouth,
/// out over gills; O₂ captured.
struct Scene5_FishGillFlow: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var x: CGFloat = -120
    @State private var tick: TimeInterval = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        // Wrapped in ScrollView so the scene scrolls on
        // shorter windows and overflowing content remains accessible.
        ScrollView {
            LazyVStack(alignment: .center, spacing: 14) {
                Text("Fish Gill Flow").font(.largeTitle.bold()).foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                Text("Watch how a fish pulls oxygen out of water using its gills.")
                    .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)

                ZStack {
                    RoundedRectangle(cornerRadius: 18).fill(Color.blue.opacity(0.15))
                        .frame(width: 420, height: 220)
                    Text("🐟").font(.system(size: 80))
                    Text("💧").font(.system(size: 24))
                        .offset(x: x, y: -10)
                        .onChange(of: tick) { _ in
                            guard !reduceMotion else { return }
                            x += 2
                            if x > 180 { x = -180 }
                        }
                        .timedScene(idealFPS: 30, tick: $tick)
                }

                SoftShadowCard(padding: 18) {
                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                        Label("Gills: underwater oxygen filters", systemImage: "drop.fill")
                            .font(.title2.bold())
                        Text("Fish gulp water through the mouth and force it out over feathery gills. Dissolved oxygen passes from the water into the blood inside the gills. CO₂ moves the other way and floats off into the water.")
                            .font(.body).lineSpacing(4)
                    }
                }
                .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, DesignTokens.Spacing.xl)

                LookingAheadCallout(
                    title: "Class 11 Bio → NEET",
                    detail: "Class 11 'Breathing and Exchange of Gases' contrasts the counter-current flow in fish gills (which extracts ~80% of dissolved O₂) with the parallel-flow alveoli of mammals (~25% extraction). Counter-current efficiency is a perennial NEET question."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, DesignTokens.Spacing.xl)

                TryAtHomeCallout(
                    title: "Aquarium watch",
                    detail: "If you have an aquarium at home (or pass one at a pet shop), watch a fish closely. Its mouth opens and closes; its gill covers flap. Every cycle pulls one mouthful of water across the gills."
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
