import SwiftUI

/// Scene 7 — Budding. Tap to grow a bud on yeast; it pops off into a new cell.
struct Scene7_Budding: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var stage: Int = 0   // 0 parent, 1 small bud, 2 big bud, 3 detached

    var body: some View {
        VStack(spacing: 14) {
            Text("Budding").font(.largeTitle.bold()).foregroundColor(ChapterTheme.accent(for: chapter.id)).padding(.top, 18)
            Text("Tap to grow the bud. Watch it become a new yeast cell.")
                .font(.callout).foregroundColor(.secondary)

            ZStack {
                RoundedRectangle(cornerRadius: 18).fill(Color.yellow.opacity(0.12))
                    .frame(width: 320, height: 220)
                HStack(spacing: CGFloat([4, 8, 16, 60][min(stage, 3)])) {
                    Circle().fill(Color.orange.opacity(0.7)).frame(width: 80, height: 80)
                    Circle().fill(Color.orange.opacity(0.7))
                        .frame(width: CGFloat([0, 20, 50, 70][min(stage, 3)]),
                               height: CGFloat([0, 20, 50, 70][min(stage, 3)]))
                }
                .animation(.easeInOut(duration: 0.4), value: stage)
            }

            Button("Next step") { stage = min(stage + 1, 3) }
                .accentColor(Color.compatIndigo)

            SoftShadowCard(padding: 18) {
                VStack(alignment: .leading, spacing: 8) {
                    Label("A bump that breaks free", systemImage: "circle.grid.3x3")
                        .font(.title2.bold())
                    Text("Yeast and hydra reproduce by budding. A small outgrowth forms on the parent, grows bigger, then detaches as a complete new organism — a clone of the parent.")
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
