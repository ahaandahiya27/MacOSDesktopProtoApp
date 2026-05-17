import SwiftUI

/// Scene 4 — Forest as Sponge. Toggle forest cover. Rain → flood or held?
struct Scene4_ForestAsSponge: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var hasForest = true

    var body: some View {
        VStack(spacing: 14) {
            Text("Forest as Sponge").font(.largeTitle.bold()).foregroundColor(ChapterTheme.accent(for: chapter.id)).padding(.top, 18)
            Text("Toggle the forest cover. Pour the same rain on both.")
                .font(.callout).foregroundColor(.secondary)

            Picker("", selection: $hasForest) {
                Text("🌳 With forest").tag(true)
                Text("🪓 Cleared land").tag(false)
            }.pickerStyle(.segmented).frame(maxWidth: 320)

            ZStack {
                RoundedRectangle(cornerRadius: 18).fill(Color.compatCyan.opacity(0.12))
                    .frame(width: 360, height: 220)
                VStack(spacing: 6) {
                    Text("☁️🌧").font(.system(size: 30))
                    Text(hasForest ? "🌳🌳🌳" : "⛰⛰⛰").font(.system(size: 36))
                    Text(hasForest ? "💧 Slow soak — recharges aquifer"
                                   : "🌊 Flash flood + erosion")
                        .font(.headline)
                        .foregroundColor(hasForest ? .green : .red)
                        .padding(.horizontal, 6)
                }
            }

            SoftShadowCard(padding: 18) {
                VStack(alignment: .leading, spacing: 8) {
                    Label("Living water tank", systemImage: "drop.degreesign")
                        .font(.title2.bold())
                    Text("Tree canopies break the force of raindrops. Roots hold the soil and let water seep down slowly. Cleared land lets rain run off fast — flooding rivers and stripping topsoil.")
                        .font(.body).lineSpacing(4)
                }
            }
            .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, 24)

            LookingAheadCallout(
                title: "Class 11 Geography",
                detail: "Class 11 Geography 'The Atmosphere and Hydrosphere' covers the water cycle in detail — evapotranspiration from forests is a key driver of the global hydrological cycle. Forests act as 'biotic pumps' that maintain regional rainfall patterns."
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            TryAtHomeCallout(
                title: "Bare patch vs grass patch",
                detail: "Find two small patches of ground in a park — one bare soil, one covered in grass. Sprinkle 1 litre of water on each. Time how long until water vanishes (gets absorbed). Grass-patch beats bare-soil every time."
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            GotItButton { onComplete() }.padding(.bottom, 12)
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
