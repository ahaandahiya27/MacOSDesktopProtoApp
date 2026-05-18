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
            Text("Aerobic vs Anaerobic").font(.largeTitle.bold()).foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            Text("Tap whether each happens WITH or WITHOUT oxygen.").font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)

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
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.95)))
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

            TryAtHomeCallout(
                title: "Yogurt = bacterial respiration",
                detail: "Mix a spoon of fresh dahi (curd) into warm milk in a covered bowl. Leave it overnight in a warm spot. The Lactobacillus bacteria respire anaerobically on milk sugars, producing lactic acid that curdles the milk — that's yogurt."
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            LookingAheadCallout(
                title: "Class 11 Bio → NEET",
                detail: "In Class 11 Biology you'll meet glycolysis, the Krebs (citric acid) cycle, and the electron transport chain — the actual chemical steps that produce ATP from glucose. NEET asks aerobic vs anaerobic energy yields (38 ATP vs 2 ATP per glucose) every year."
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            if done { GotItButton { onComplete(score) }.padding(.bottom, 12) }
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
