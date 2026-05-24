import SwiftUI

/// Scene 6 — Animal Niche Match. 4 animals to their forest layer.
struct Scene6_AnimalNicheMatch: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: (Int) -> Void

    struct Pair: Identifiable { let id = UUID(); let animal: String; let layer: String }
    private let pairs: [Pair] = [
        Pair(animal: "🦅 Eagle",        layer: "Canopy"),
        Pair(animal: "🐒 Langur",       layer: "Understory"),
        Pair(animal: "🦌 Deer",          layer: "Shrub"),
        Pair(animal: "🐍 Cobra",        layer: "Forest floor"),
    ]
    private let options = ["Canopy", "Understory", "Shrub", "Forest floor"]
    @State private var picks: [UUID: String] = [:]

    private var done: Bool { picks.count == pairs.count }
    private var score: Int { pairs.reduce(0) { $0 + ((picks[$1.id] == $1.layer) ? 1 : 0) } }

    var body: some View {
        // Wrapped in ScrollView so the scene scrolls on
        // shorter windows and overflowing content remains accessible.
        ScrollView {
    LazyVStack(alignment: .center, spacing: 12) {
                Text("Animal Niche Match").font(.largeTitle.bold()).foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                Text("Each animal calls a particular layer home.").font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)

                VStack(spacing: 10) {
                    ForEach(pairs) { p in
                        HStack {
                            Text(p.animal).font(.headline)
                                .lineLimit(2)
                                .minimumScaleFactor(0.8)
                                .frame(width: 140, alignment: .leading)
                            Picker("", selection: Binding(
                                get: { picks[p.id] ?? "" }, set: { picks[p.id] = $0 }
                            )) {
                                Text("— pick —").tag("")
                                ForEach(options, id: \.self) { Text($0).tag($0) }
                            }.pickerStyle(.menu).frame(width: 180)
                            if let v = picks[p.id], !v.isEmpty {
                                Image(systemName: v == p.layer ? "checkmark.circle.fill" : "xmark.circle.fill")
                                    .foregroundColor(v == p.layer ? .green : .red)
                            }
                        }
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.95)))
                    }
                }
                .frame(maxWidth: 540).padding(.horizontal, 24)

                if done {
                    Text("Score: \(score) / \(pairs.count)").font(.title3.bold()).foregroundColor(Color.compatIndigo)
                }

                LookingAheadCallout(
                    title: "Class 12 Bio → NEET",
                    detail: "Class 12 'Organisms and Populations' formalises niche as the role + range an organism occupies. Two species cannot occupy the same niche indefinitely (Gause's competitive exclusion principle). NEET asks niche-vs-habitat distinction questions every cycle."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)

                TryAtHomeCallout(
                    title: "Sparrow vs crow",
                    detail: "Notice how sparrows hop on the ground hunting seeds while crows eat fruits and garbage from above. They share the same neighborhood but never compete — different niches. Try spotting 3 species and figure out each one's niche."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)

                if done { GotItButton { onComplete(score) }.padding(.bottom, 12) }
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
        }
    }
}
