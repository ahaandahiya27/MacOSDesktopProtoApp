import SwiftUI

/// Scene 8 — Conservation Hero. Toggle 3 conservation techniques; the hillside
/// goes from eroding to safe.
struct Scene8_ConservationHero: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var terracing = false
    @State private var coverCrops = false
    @State private var contour = false

    private var score: Int {
        (terracing ? 1 : 0) + (coverCrops ? 1 : 0) + (contour ? 1 : 0)
    }
    private var status: String {
        switch score {
        case 3: return "✅ Soil saved!"
        case 2: return "⚠️ Some loss"
        case 1: return "🚧 Heavy erosion"
        default: return "💀 Bare hillside"
        }
    }

    var body: some View {
        // Wrapped in ScrollView so the scene scrolls on
        // shorter windows and overflowing content remains accessible.
        ScrollView {
            LazyVStack(alignment: .center, spacing: 14) {
                Text("Conservation Hero").font(.largeTitle.bold()).foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                Text("Turn on techniques to protect this hillside.").font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)

                ZStack {
                    RoundedRectangle(cornerRadius: 18).fill(Color.green.opacity(0.18))
                        .frame(width: 380, height: 220)
                    Text(status).font(.title2.bold())
                }

                VStack(spacing: 10) {
                    Toggle("🪜 Terracing — flat steps on the slope", isOn: $terracing)
                    Toggle("🌿 Cover crops — keep soil clothed", isOn: $coverCrops)
                    Toggle("〰️ Contour ploughing — across the slope, not down", isOn: $contour)
                }
                .frame(maxWidth: 460)
                .padding(.horizontal, 24)

                SoftShadowCard(padding: 18) {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Three pillars of soil conservation", systemImage: "shield.fill")
                            .font(.title2.bold())
                        Text("Terracing slows runoff on slopes. Cover crops shield bare soil from rain. Contour ploughing forms tiny ridges that trap water. Combine all three and even a steep hillside stays fertile for generations.")
                            .font(.body).lineSpacing(4)
                    }
                }
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)

                LookingAheadCallout(
                    title: "Class 10 Geography",
                    detail: "Class 10 'Resources and Development' formalises soil conservation as a national-level issue — the National Mission for Sustainable Agriculture, watershed development, and the role of NGOs in dryland restoration."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)

                TryAtHomeCallout(
                    title: "Sloped vs flat patch",
                    detail: "Find a slope in your school playground. Water erosion has probably already worn a small gully. Compare to a flat grassy patch nearby — much less erosion. That's why hilly fields use terraces."
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
