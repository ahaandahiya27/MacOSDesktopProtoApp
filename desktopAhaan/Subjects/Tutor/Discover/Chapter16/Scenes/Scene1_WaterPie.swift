import SwiftUI

/// Scene 1 — Earth's Water Pie. Bar shows: ocean 97%, frozen 2%, fresh liquid <1%.
struct Scene1_WaterPie: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    var body: some View {
        VStack(spacing: 14) {
            Text("Earth's Water Pie").font(.largeTitle.bold()).padding(.top, 18)
            Text("Earth is 70% water — but how much is actually drinkable?")
                .font(.callout).foregroundColor(.secondary)

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

            GotItButton { onComplete() }.padding(.bottom, 12)
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
