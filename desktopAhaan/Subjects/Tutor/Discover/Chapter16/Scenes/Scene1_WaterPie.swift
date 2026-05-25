import SwiftUI

/// Scene 1 — Earth's Water Pie. Bar shows: ocean 97%, frozen 2%, fresh liquid <1%.
struct Scene1_WaterPie: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    var body: some View {
        // Wrapped in ScrollView so the scene scrolls on
        // shorter windows and overflowing content remains accessible.
        ScrollView {
            LazyVStack(alignment: .center, spacing: 14) {
                Text("Earth's Water Pie").font(.largeTitle.bold()).foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                Text("Earth is 70% water — but how much is actually drinkable?")
                    .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)

                HStack(spacing: 0) {
                    Rectangle().fill(Color.blue).frame(width: 388, height: 50)
                        .overlay(Text("Oceans 97%").foregroundColor(.white).font(.headline))
                    Rectangle().fill(Color.compatCyan).frame(width: 8, height: 50)
                        .overlay(Text("❄️").font(.title3))
                    Rectangle().fill(Color.green).frame(width: 4, height: 50)
                }
                .frame(width: 400)
                .clipShape(RoundedRectangle(cornerRadius: 8))

                HStack {
                    Rectangle().fill(Color.blue).frame(width: 14, height: 14); Text("Salty oceans 97%").font(.caption)
                    Spacer()
                    Rectangle().fill(Color.compatCyan).frame(width: 14, height: 14); Text("Frozen ice 2%").font(.caption)
                    Spacer()
                    Rectangle().fill(Color.green).frame(width: 14, height: 14); Text("Fresh water <1%").font(.caption)
                }
                .frame(maxWidth: 460)

                SoftShadowCard(padding: 18) {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Less than 1% is drinkable", systemImage: "drop.fill")
                            .font(.title2.bold())
                        Text("Most of Earth's water is in the salty oceans. About 2% is frozen in glaciers and polar ice. Only the tiny green sliver — lakes, rivers, groundwater — is fresh liquid water we can drink, grow crops with, or use in industry.")
                            .font(.body).lineSpacing(4)
                    }
                }
                .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, 24)

                LookingAheadCallout(
                    title: "Class 9 Geography → CBSE",
                    detail: "Class 9 Geography Ch 'Water Resources' goes deeper into India's freshwater stress — depleting groundwater in Punjab, Haryana, Western UP; inter-state river disputes (Cauvery, Yamuna); and the National Water Policy framework. CBSE Class 10 Civics also covers SDG 6: Clean Water and Sanitation."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)

                TryAtHomeCallout(
                    title: "Earth's water in a litre",
                    detail: "Measure 1 litre of water in a jug — that represents all of Earth's water. Pour out 30 mL — that's all freshwater. Now isolate just 0.6 mL — that's the freshwater we can actually USE. The rest is frozen or trapped underground. Tiny."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)

                RelatedConceptsCallout(
                    title: "Related: Ch 7 (Weather), Ch 8 (Winds), Ch 18 (Wastewater)",
                    detail: "The water cycle is the engine: evaporation → clouds (Ch 7) → wind carries them (Ch 8) → rain falls back. After we use it, Ch 18 shows how it returns to the same cycle through treatment plants."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)

                GotItButton { onComplete() }.padding(.bottom, 12)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
        }
    }
}
