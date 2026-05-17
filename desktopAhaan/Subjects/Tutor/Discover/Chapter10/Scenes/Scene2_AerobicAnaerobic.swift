import SwiftUI

/// Scene 2 — Aerobic vs Anaerobic. Sort 4 organisms/processes.
struct Scene2_AerobicAnaerobic: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: (Int) -> Void

    struct Item: Identifiable { let id = UUID(); let text: String; let isAerobic: Bool }
    private let items: [Item] = [
        Item(text: "🌳 Tree breathing in the day",         isAerobic: true),
        Item(text: "🧫 Yeast fermenting sugar without air", isAerobic: false),
        Item(text: "🏃 You during exercise",                isAerobic: true),
        Item(text: "💪 Muscles cramping after a sprint",    isAerobic: false),
    ]
    @State private var picks: [UUID: Bool] = [:]

    private var done: Bool { picks.count == items.count }
    private var score: Int { items.reduce(0) { $0 + ((picks[$1.id] == $1.isAerobic) ? 1 : 0) } }

    var body: some View {
        VStack(spacing: 12) {
            Text("Aerobic vs Anaerobic").font(.largeTitle.bold()).foregroundColor(ChapterTheme.accent(for: chapter.id)).padding(.top, 18)
            Text("Tap whether each happens WITH or WITHOUT oxygen.").font(.callout).foregroundColor(.secondary)

            VStack(spacing: 10) {
                ForEach(items) { item in
                    HStack {
                        Text(item.text).frame(maxWidth: .infinity, alignment: .leading)
                        Button("Aerobic")   { picks[item.id] = true  }.accentColor(picks[item.id] == true ? .green : .gray)
                        Button("Anaerobic") { picks[item.id] = false }.accentColor(picks[item.id] == false ? .orange : .gray)
                        if let p = picks[item.id] {
                            Image(systemName: p == item.isAerobic ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .foregroundColor(p == item.isAerobic ? .green : .red)
                        }
                    }
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.06)))
                }
            }
            .frame(maxWidth: 640).padding(.horizontal, 24)

            if done {
                Text("Score: \(score) / \(items.count)").font(.title3.bold()).foregroundColor(Color.compatIndigo)
            }

            SoftShadowCard(padding: 14) {
                Text("Aerobic respiration uses oxygen to fully release energy from glucose (CO₂ + water + lots of ATP). Anaerobic skips oxygen and produces less energy plus lactic acid (in muscles) or alcohol & CO₂ (in yeast).")
                    .font(.callout).lineSpacing(4)
            }
            .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, 24)

            if done { GotItButton { onComplete(score) }.padding(.bottom, 12) }
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
