import SwiftUI

/// Scene 3 — Sort Contaminants. Classify 5 items into Organic / Inorganic / Pathogen.
struct Scene3_SortContaminants: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: (Int) -> Void

    struct Item: Identifiable { let id = UUID(); let text: String; let kind: String }
    private let items: [Item] = [
        Item(text: "Vegetable peels",    kind: "Organic"),
        Item(text: "Cooking oil grease", kind: "Organic"),
        Item(text: "Detergent suds",     kind: "Inorganic"),
        Item(text: "Metal fragments",     kind: "Inorganic"),
        Item(text: "Cholera bacteria",   kind: "Pathogen"),
    ]
    private let options = ["Organic", "Inorganic", "Pathogen"]
    @State private var picks: [UUID: String] = [:]

    private var done: Bool { picks.count == items.count }
    private var score: Int { items.reduce(0) { $0 + ((picks[$1.id] == $1.kind) ? 1 : 0) } }

    var body: some View {
        VStack(spacing: 12) {
            Text("Sort the Contaminants").font(.largeTitle.bold()).foregroundColor(ChapterTheme.accent(for: chapter.id)).padding(.top, 18)
            Text("Classify each pollutant.").font(.callout).foregroundColor(.secondary)

            VStack(spacing: 10) {
                ForEach(items) { item in
                    HStack {
                        Text(item.text).frame(maxWidth: .infinity, alignment: .leading)
                        HStack(spacing: 6) {
                            ForEach(options, id: \.self) { opt in
                                Button(opt) { picks[item.id] = opt }
                                    .accentColor(picks[item.id] == opt ? Color.compatIndigo : .gray)
                            }
                        }
                        if let p = picks[item.id] {
                            Image(systemName: p == item.kind ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .foregroundColor(p == item.kind ? .green : .red)
                        }
                    }
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.06)))
                }
            }
            .frame(maxWidth: 720).padding(.horizontal, 24)

            if done {
                Text("Score: \(score) / \(items.count)").font(.title3.bold()).foregroundColor(Color.compatIndigo)
            }

            SoftShadowCard(padding: 14) {
                Text("Organic = once living (food, hair, paper). Inorganic = chemicals, metals, detergents. Pathogens = disease-causing microbes. Each needs a different treatment step.")
                    .font(.callout).lineSpacing(4)
            }
            .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, 24)

            if done { GotItButton { onComplete(score) }.padding(.bottom, 12) }
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
