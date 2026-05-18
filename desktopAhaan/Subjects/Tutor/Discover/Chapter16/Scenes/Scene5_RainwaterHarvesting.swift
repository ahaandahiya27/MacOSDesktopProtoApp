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
        VStack(spacing: 14) {
            Text("Rainwater Harvesting").font(.largeTitle.bold()).foregroundColor(ChapterTheme.accent(for: chapter.id)).padding(.top, 18)
            Text("Add gutters and a tank to your roof. Catch the rain.")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)

            ZStack {
                RoundedRectangle(cornerRadius: 18).fill(Color.compatCyan.opacity(0.10))
                    .frame(width: 360, height: 240)
                VStack(spacing: 4) {
                    Text("☁️🌧").font(.system(size: 36))
                    Text("🏠").font(.system(size: 64))
                    Text(working ? "🪣 ← collected!" : "❌ runoff lost").font(.headline)
                        .foregroundColor(working ? .green : .red)
                }
            }

            VStack(spacing: 8) {
                Toggle("Install gutters",     isOn: $hasGutters)
                Toggle("Install storage tank", isOn: $hasTank)
            }
            .frame(maxWidth: 360)

            SoftShadowCard(padding: 18) {
                VStack(alignment: .leading, spacing: 8) {
                    Label("Free water from the sky", systemImage: "cloud.rain.fill")
                        .font(.title2.bold())
                    Text("Most rooftops drain rainwater straight into the street. Add a gutter and a storage tank and you can collect thousands of litres a year — for gardens, cleaning, or even recharging the aquifer through a soak-pit.")
                        .font(.body).lineSpacing(4)
                }
            }
            .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, 24)

            LookingAheadCallout(
                title: "Class 10 Geography",
                detail: "Class 10 covers rainwater-harvesting structures — khadins (Rajasthan), kuls (Himachal), zings (Ladakh), eris (Tamil Nadu), bhandaras (Maharashtra). CBSE asks regional water-harvesting techniques every year."
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            TryAtHomeCallout(
                title: "Rooftop bucket",
                detail: "Next rain shower, place a clean wide-mouth bucket directly under the rain (clear of dust). Time it: 15 minutes of moderate rain typically fills it 5-10 cm. A small house roof can collect HUNDREDS of buckets a year."
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            GotItButton { onComplete() }.padding(.bottom, 12)
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
