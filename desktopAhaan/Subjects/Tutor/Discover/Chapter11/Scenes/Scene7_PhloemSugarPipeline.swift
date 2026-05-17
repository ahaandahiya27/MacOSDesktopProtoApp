import SwiftUI

/// Scene 7 — Phloem Sugar Pipeline. Toggle between summer (sugar flows down)
/// and spring (flows up from storage).
struct Scene7_PhloemSugarPipeline: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    enum Season: String, CaseIterable, Identifiable { case summer = "Summer", spring = "Spring"; var id: String { rawValue } }
    @State private var season: Season = .summer

    var body: some View {
        VStack(spacing: 14) {
            Text("Phloem Sugar Pipeline").font(.largeTitle.bold()).foregroundColor(ChapterTheme.accent(for: chapter.id)).padding(.top, 18)
            Text("Phloem carries sugar from where it's made to where it's needed.")
                .font(.callout).foregroundColor(.secondary)

            Picker("", selection: $season) {
                ForEach(Season.allCases) { Text($0.rawValue).tag($0) }
            }.pickerStyle(.segmented).frame(maxWidth: 260)

            ZStack {
                RoundedRectangle(cornerRadius: 18).fill(Color.green.opacity(0.12))
                    .frame(width: 320, height: 320)
                VStack(spacing: 6) {
                    Text("🍃").font(.system(size: 60))
                    Text(season == .summer ? "⬇️" : "⬆️").font(.system(size: 36))
                    Text("🪵").font(.system(size: 60))
                    Text(season == .summer ? "⬇️" : "⬆️").font(.system(size: 36))
                    Text("🥔").font(.system(size: 56))
                }
            }

            Text(season == .summer
                 ? "Summer: leaves make sugar → ships it down to roots & fruit"
                 : "Spring: stored sugar in roots → moves up to grow new leaves & flowers")
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
                .font(.headline)
                .foregroundColor(Color.compatIndigo)

            SoftShadowCard(padding: 18) {
                VStack(alignment: .leading, spacing: 8) {
                    Label("Two-way sugar highway", systemImage: "arrow.up.arrow.down")
                        .font(.title2.bold())
                    Text("Unlike xylem (water only, always up), phloem can move sugar in any direction. Wherever the plant is growing or storing — that's where the sugars flow.")
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
