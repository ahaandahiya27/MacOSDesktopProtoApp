import SwiftUI

/// Scene 5 — Rainwater Harvesting. Toggle gutters + tank; rainfall fills the tank.
struct Scene5_RainwaterHarvesting: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var hasGutters = false
    @State private var hasTank = false

    private var working: Bool { hasGutters && hasTank }

    var body: some View {
        // Wrapped in ScrollView so the scene scrolls on
        // shorter windows and overflowing content remains accessible.
        ScrollView {
            LazyVStack(alignment: .center, spacing: 14) {
                Text("Rainwater Harvesting").font(.largeTitle.bold()).foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                Text("Add gutters and a tank to your roof. Catch the rain.")
                    .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)

                ZStack {
                    RoundedRectangle(cornerRadius: 18).fill(Color.compatCyan.opacity(0.10))
                        .frame(width: 360, height: 240)
                    VStack(spacing: DesignTokens.Spacing.xs) {
                        Text("☁️🌧").font(.system(size: 36))
                        Text("🏠").font(.system(size: 64))
                        Text(working ? "🪣 ← collected!" : "❌ runoff lost").font(.headline)
                            .foregroundColor(working ? .green : .red)
                    }
                }

                VStack(spacing: DesignTokens.Spacing.sm) {
                    Toggle("Install gutters",     isOn: $hasGutters)
                    Toggle("Install storage tank", isOn: $hasTank)
                }
                .frame(maxWidth: 360)

                SoftShadowCard(padding: 18) {
                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                        Label("Free water from the sky", systemImage: "cloud.rain.fill")
                            .font(.title2.bold())
                        Text("Most rooftops drain rainwater straight into the street. Add a gutter and a storage tank and you can collect thousands of litres a year — for gardens, cleaning, or even recharging the aquifer through a soak-pit.")
                            .font(.body).lineSpacing(4)
                    }
                }
                .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, DesignTokens.Spacing.xl)

                ProcessTimeline(
                    title: "The water cycle — where rooftop water came from",
                    steps: [
                        .init(title: "Evaporation",
                              detail: "Sun heats oceans, rivers and lakes. Liquid water turns into invisible vapour and rises."),
                        .init(title: "Condensation",
                              detail: "High in the cool atmosphere, vapour clusters around dust specks and turns back into tiny water droplets — that's a cloud."),
                        .init(title: "Precipitation",
                              detail: "When droplets collide and grow heavy enough, they fall as rain, snow, sleet or hail. India's monsoon = three months of this."),
                        .init(title: "Surface runoff",
                              detail: "Most rain hits roofs, roads, and bare ground and slides off into drains — the water you're catching with a harvester would otherwise leave."),
                        .init(title: "Infiltration + groundwater",
                              detail: "Some water seeps into soil, percolates down to the water table, joins underground aquifers. Soak-pits help this happen on purpose."),
                        .init(title: "Back to ocean (or your tap)",
                              detail: "Rivers, aquifers and tanks deliver the water to the sea — or via the city pipe to your kitchen — and the cycle starts again.")
                    ],
                    accent: Color.compatCyan
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, DesignTokens.Spacing.xl)

                LookingAheadCallout(
                    title: "Class 10 Geography",
                    detail: "Class 10 covers many rainwater-harvesting structures. Rajasthan has khadins. Himachal has kuls. Ladakh has zings. Tamil Nadu has eris. Maharashtra has bhandaras. CBSE asks about regional methods every year."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, DesignTokens.Spacing.xl)

                TryAtHomeCallout(
                    title: "Rooftop bucket",
                    detail: "Next rain shower, place a clean wide-mouth bucket directly under the rain (clear of dust). Time it: 15 minutes of moderate rain typically fills it 5-10 cm. A small house roof can collect HUNDREDS of buckets a year."
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
