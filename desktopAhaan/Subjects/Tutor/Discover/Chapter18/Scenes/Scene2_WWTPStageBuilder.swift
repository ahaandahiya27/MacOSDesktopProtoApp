import SwiftUI

/// Scene 2 — WWTP Stage Builder. Tap each stage to learn what it removes.
struct Scene2_WWTPStageBuilder: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    enum Stage: String, CaseIterable, Identifiable {
        case barScreen = "Bar screen", grit = "Grit chamber", aeration = "Aeration tank", clarifier = "Clarifier", sludge = "Sludge digester"
        var id: String { rawValue }
        var role: String {
            switch self {
            case .barScreen: return "Metal bars catch rags, plastics and large solids before pumps."
            case .grit:      return "Slow tank lets sand, pebbles and coffee grounds sink to the bottom."
            case .aeration:  return "Air is bubbled in; helpful microbes eat dissolved organic waste."
            case .clarifier: return "Calm tank where dead microbes settle into a thick sludge at the bottom."
            case .sludge:    return "Sludge is dried; microbes here produce biogas (methane) from it."
            }
        }
    }
    @State private var pick: Stage = .barScreen

    var body: some View {
        VStack(spacing: 14) {
            Text("WWTP Stage Builder").font(.largeTitle.bold()).foregroundColor(ChapterTheme.accent(for: chapter.id)).padding(.top, 18)
            Text("Tap each stage. See what it cleans out.").font(.callout).foregroundColor(.secondary)

            HStack(spacing: 6) {
                ForEach(Stage.allCases) { s in
                    Button { pick = s } label: {
                        VStack {
                            Text(stageEmoji(s)).font(.system(size: 36))
                            Text(s.rawValue).font(.caption2)
                        }
                        .padding(6)
                        .frame(width: 90)
                        .background(RoundedRectangle(cornerRadius: 8).fill(pick == s ? Color.compatIndigo.opacity(0.15) : Color.gray.opacity(0.06)))
                    }
                    .buttonStyle(.plain)
                }
            }

            SoftShadowCard(padding: 18) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(pick.rawValue).font(.title3.bold())
                    Text(pick.role).font(.body).lineSpacing(4)
                }
            }
            .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, 24)

            GotItButton { onComplete() }.padding(.bottom, 12)
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func stageEmoji(_ s: Stage) -> String {
        switch s {
        case .barScreen: return "▮▮▮"
        case .grit:      return "🪨"
        case .aeration:  return "🫧"
        case .clarifier: return "🧪"
        case .sludge:    return "🟤"
        }
    }
}
