import SwiftUI

/// Scene 8 — Reforestation Plan. Toggle actions; counter shows trees planted.
struct Scene8_ReforestationPlan: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var actions: [Bool] = Array(repeating: false, count: 5)
    private let texts = [
        "Plant 5 saplings in our locality",
        "Adopt a tree at school",
        "Avoid single-use paper products",
        "Compost kitchen waste at home",
        "Take part in a Van Mahotsav drive",
    ]
    private var trees: Int { actions.enumerated().reduce(0) { $0 + (actions[$1.offset] ? [5, 1, 2, 1, 10][$1.offset] : 0) } }

    var body: some View {
        VStack(spacing: 14) {
            Text("Reforestation Plan").font(.largeTitle.bold()).foregroundColor(ChapterTheme.accent(for: chapter.id)).padding(.top, 18)
            Text("Pick actions you'll commit to. We'll count the trees you help.")
                .font(.callout).foregroundColor(.secondary).multilineTextAlignment(.center)

            VStack(spacing: 8) {
                ForEach(0..<actions.count, id: \.self) { i in
                    Toggle(texts[i], isOn: $actions[i])
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.06)))
                }
            }
            .frame(maxWidth: 560)

            Text("Trees helped: \(trees) 🌳")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.green)

            SoftShadowCard(padding: 14) {
                Text("Van Mahotsav (July first week) is India's annual tree-planting festival. Started in 1950 by Dr K M Munshi, it has planted millions of trees.")
                    .font(.callout).lineSpacing(4)
            }
            .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, 24)

            GotItButton { onComplete() }.padding(.bottom, 12)
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
