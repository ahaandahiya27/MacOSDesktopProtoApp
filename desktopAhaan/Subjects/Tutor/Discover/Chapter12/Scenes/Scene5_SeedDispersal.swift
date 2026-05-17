import SwiftUI

/// Scene 5 — Seed Dispersal. Match 4 seeds to dispersal methods.
struct Scene5_SeedDispersal: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: (Int) -> Void

    struct Pair: Identifiable { let id = UUID(); let seed: String; let method: String }
    private let pairs: [Pair] = [
        Pair(seed: "🪶 Dandelion — fluffy tuft",                method: "Wind"),
        Pair(seed: "🥥 Coconut — buoyant, floats in the sea",   method: "Water"),
        Pair(seed: "🍒 Cherry — bright fruit, animals eat & drop", method: "Animal"),
        Pair(seed: "💥 Castor — pod bursts open when dry",      method: "Explosion"),
    ]
    private let options = ["Wind", "Water", "Animal", "Explosion"]
    @State private var picks: [UUID: String] = [:]

    private var done: Bool { picks.count == pairs.count }
    private var score: Int { pairs.reduce(0) { $0 + ((picks[$1.id] == $1.method) ? 1 : 0) } }

    var body: some View {
        VStack(spacing: 12) {
            Text("Seed Dispersal").font(.largeTitle.bold()).foregroundColor(ChapterTheme.accent(for: chapter.id)).padding(.top, 18)
            Text("How does each seed travel away from its parent?").font(.callout).foregroundColor(.secondary)

            VStack(spacing: 10) {
                ForEach(pairs) { p in
                    HStack {
                        Text(p.seed).frame(maxWidth: .infinity, alignment: .leading)
                        Picker("", selection: Binding(
                            get: { picks[p.id] ?? "" }, set: { picks[p.id] = $0 }
                        )) {
                            Text("— pick —").tag("")
                            ForEach(options, id: \.self) { Text($0).tag($0) }
                        }.pickerStyle(.menu).frame(width: 150)
                        if let v = picks[p.id], !v.isEmpty {
                            Image(systemName: v == p.method ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .foregroundColor(v == p.method ? .green : .red)
                        }
                    }
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.06)))
                }
            }
            .frame(maxWidth: 640).padding(.horizontal, 24)

            if done {
                Text("Score: \(score) / \(pairs.count)").font(.title3.bold()).foregroundColor(Color.compatIndigo)
            }

            SoftShadowCard(padding: 14) {
                Text("If seeds fell straight down they'd compete with the parent. Dispersal spreads them out — the shape of the seed gives away the method.")
                    .font(.callout).lineSpacing(4)
            }
            .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, 24)

            LookingAheadCallout(
                title: "Class 12 Bio → NEET",
                detail: "Class 12 'Reproduction in Organisms' formalises dispersal mechanisms as evolved adaptations — anemochory (wind), hydrochory (water), zoochory (animals), autochory (self/explosive). Connects to Class 12 Ecology — seed-dispersal limitations explain species distributions."
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            TryAtHomeCallout(
                title: "Seed sort",
                detail: "Collect 10 different seeds from a 5-minute walk — dry pods on the ground, fluffy parachutes, fruit-eaten droppings, sticky burrs on socks. Sort them by dispersal method: wind / water / animal / explosion."
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            RelatedConceptsCallout(
                title: "Related: Ch 17 (Forests), Ch 8 (Winds)",
                detail: "Seed dispersal is how forests regrow (Ch 17). Wind-dispersed seeds (dandelion, pine) ride the same air currents that drive cyclones and breezes (Ch 8). The atmosphere is part of how life spreads."
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            if done { GotItButton { onComplete(score) }.padding(.bottom, 12) }
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
