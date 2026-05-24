import SwiftUI

/// Scene 9 — Boss Quiz Ch17. Five MCQs on forests.
struct Scene9_BossQuiz_Ch17: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: (Int) -> Void

    struct Q { let prompt: String; let options: [String]; let answer: String; let explain: String }

    private let qs: [Q] = [
        Q(prompt: "The top layer of a forest is called the:",
          options: ["Floor", "Shrub", "Canopy", "Soil"],
          answer: "Canopy",
          explain: "Tall trees form the canopy — most sunlight is captured here."),
        Q(prompt: "Decomposers like fungi help by:",
          options: ["Eating animals", "Producing oxygen", "Breaking down dead matter", "Carrying seeds"],
          answer: "Breaking down dead matter",
          explain: "They turn dead leaves and wood into humus — nutrients for new plants."),
        Q(prompt: "Forests absorb _____ and release _____.",
          options: ["O₂ / CO₂", "CO₂ / O₂", "N₂ / O₂", "Water / Oxygen"],
          answer: "CO₂ / O₂",
          explain: "Photosynthesis uses CO₂ + water + sunlight to make food + O₂."),
        Q(prompt: "Cutting down forests is called:",
          options: ["Afforestation", "Photosynthesis", "Deforestation", "Conservation"],
          answer: "Deforestation",
          explain: "Deforestation triggers erosion, floods and biodiversity loss."),
        Q(prompt: "Van Mahotsav is celebrated to:",
          options: ["Eat vegetables", "Plant trees", "Climb mountains", "Cut wood"],
          answer: "Plant trees",
          explain: "India's annual tree-planting festival, every July first week."),
        Q(prompt: "In a forest food chain, the producers are:",
          options: ["Tigers", "Mushrooms", "Green plants", "Snakes"],
          answer: "Green plants",
          explain: "Producers make their own food by photosynthesis. Every animal in the forest eats them directly or indirectly."),
        Q(prompt: "A typical tropical deciduous forest in India is the:",
          options: ["Sundarbans mangrove", "Sal and teak forest", "Pine forest of Himalayas", "Thar shrubs"],
          answer: "Sal and teak forest",
          explain: "Central India has large sal and teak forests that shed leaves during the dry season."),
        Q(prompt: "Bamboo grows fastest in:",
          options: ["Dark cave floors", "Sunlit gaps in the forest", "Rocks with no soil", "Salty water"],
          answer: "Sunlit gaps in the forest",
          explain: "Bamboos shoot up wherever a tree falls and lets sunlight reach the forest floor."),
        Q(prompt: "The leafy crowns of the tallest trees together form the:",
          options: ["Litter", "Understorey", "Canopy", "Root zone"],
          answer: "Canopy",
          explain: "The canopy catches most of the sunlight. Below it are smaller layers down to the leaf-litter floor."),
        Q(prompt: "Forests are called the lungs of the planet because they:",
          options: ["Make noise like wind", "Take in CO₂ and release O₂", "Filter saltwater", "Generate electricity"],
          answer: "Take in CO₂ and release O₂",
          explain: "Through photosynthesis, forest plants pull CO₂ from the air and release the oxygen we breathe."),
    ]

    @State private var i = 0
    @State private var picked: String? = nil
    @State private var revealed = false
    @State private var score = 0
    @State private var done = false
    @State private var shuffled: [String] = []

    var body: some View {
        // Wrapped in ScrollView so the scene scrolls on
        // shorter windows and overflowing content remains accessible.
        ScrollView {
    LazyVStack(alignment: .center, spacing: 14) {
                Text("Boss Quiz").font(.largeTitle.bold()).foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                ProgressView(value: Double(i), total: Double(qs.count)).frame(maxWidth: 520)

                if !done {
                    let q = qs[i]
                    Text("Question \(i + 1) of \(qs.count)").font(.subheadline).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    SoftShadowCard(padding: 18) {
                        Text(q.prompt).font(.title3.bold()).frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(maxWidth: 600)

                    VStack(spacing: 10) {
                        ForEach(shuffled, id: \.self) { opt in
                            Button {
                                guard !revealed else { return }
                                picked = opt
                                revealed = true
                                let isCorrect = opt == q.answer
                                DataStore.shared.recordEphemeralReview(
                                    ephemeralId: String(format: "bossquiz_ch%02d_q%02d", chapter.number, i),
                                    quality: isCorrect ? .good : .forgot
                                )
                                if isCorrect { score += 1 }
                            } label: {
                                HStack {
                                    Text(opt).frame(maxWidth: .infinity, alignment: .leading)
                                    if revealed && opt == q.answer {
                                        Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
                                    } else if revealed && opt == picked {
                                        Image(systemName: "xmark.circle.fill").foregroundColor(.red)
                                    }
                                }
                                .padding(12)
                                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.95)))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .frame(maxWidth: 600)

                    if revealed {
                        SoftShadowCard(padding: 12) {
                            Label(q.explain, systemImage: "lightbulb.fill").font(.callout)
                        }
                        .frame(maxWidth: 600)
                        Button(i + 1 < qs.count ? "Next question" : "See score") {
                            if i + 1 < qs.count { i += 1; picked = nil; revealed = false }
                            else { done = true }
                        }
                        .accentColor(Color.compatIndigo)
                    }
                } else {
                    VStack(spacing: 12) {
                        if score >= 4 {
                            Image(systemName: "checkmark.seal.fill")
                                .font(.system(size: 56))
                                .foregroundColor(.green)
                                .accessibilityHidden(true)
                            Text("Great job!").font(.title2.bold()).foregroundColor(.green)
                        }
                        Text("Score: \(score) / \(qs.count)").font(.system(size: 36, weight: .bold))
                        GotItButton(label: "Finish chapter") { onComplete(score) }
                    }
                    .padding(.top, 8)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
        }
        .onAppear { if shuffled.isEmpty { shuffled = qs[i].options.shuffled() } }
        .onChange(of: i) { newI in shuffled = qs[newI].options.shuffled() }
    }
}
