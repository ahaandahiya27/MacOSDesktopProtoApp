import SwiftUI

/// Scene 9 — Boss Quiz Ch16. Five MCQs on water.
struct Scene9_BossQuiz_Ch16: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: (Int) -> Void

    struct Q { let prompt: String; let options: [String]; let answer: String; let explain: String }

    private let qs: [Q] = [
        Q(prompt: "Most of Earth's water is:",
          options: ["Frozen as ice", "In rivers", "In oceans (salty)", "Underground"],
          answer: "In oceans (salty)",
          explain: "About 97% of Earth's water is in the salty oceans."),
        Q(prompt: "The water table is:",
          options: ["The roof of a tank", "Level of underground water", "A type of well", "A river"],
          answer: "Level of underground water",
          explain: "Above the table the soil has air; below it the soil is saturated."),
        Q(prompt: "Which irrigation method wastes the least water?",
          options: ["Drip", "Sprinkler", "Flood", "Canal"],
          answer: "Drip",
          explain: "Drip places water right at the roots — almost no evaporation."),
        Q(prompt: "Rainwater harvesting helps by:",
          options: ["Cooling roofs", "Recharging groundwater", "Stopping rain", "Making oceans"],
          answer: "Recharging groundwater",
          explain: "Collected rain can be stored or sent into the soil to refill aquifers."),
        Q(prompt: "An aquifer is:",
          options: ["A type of glass", "A water-saturated rock layer", "A fish", "A canal"],
          answer: "A water-saturated rock layer",
          explain: "Wells tap aquifers; aquifers refill when rain seeps through the soil above."),
        Q(prompt: "World Water Day is observed every year on:",
          options: ["22 March", "5 June", "2 October", "1 January"],
          answer: "22 March",
          explain: "The UN marks World Water Day each March 22 to remind us how precious fresh water is."),
        Q(prompt: "The three forms of water on Earth are:",
          options: ["Salty, fresh and frozen", "Ice (solid), water (liquid) and vapour (gas)", "River, lake and ocean", "Acid, base and neutral"],
          answer: "Ice (solid), water (liquid) and vapour (gas)",
          explain: "Water is the only common substance found in all three states naturally on Earth."),
        Q(prompt: "The 3 R's for water (and the environment) are:",
          options: ["Reduce, Reuse, Recycle", "Run, Rest, Repeat", "Rain, River, Reservoir", "Roots, Rocks, Rivers"],
          answer: "Reduce, Reuse, Recycle",
          explain: "Reduce first (use less), then reuse, then recycle what's left."),
        Q(prompt: "Stepwells (baoris/bawris) are a traditional rainwater harvesting feature of:",
          options: ["Kerala", "Rajasthan", "Assam", "Kashmir"],
          answer: "Rajasthan",
          explain: "In dry Rajasthan, stepwells stored monsoon water so villages had water through the dry season."),
        Q(prompt: "Groundwater is naturally replenished by:",
          options: ["Cooling of clouds", "Percolation of rainwater into the soil", "Sea waves", "Roots of trees"],
          answer: "Percolation of rainwater into the soil",
          explain: "Rain soaks down through soil pores and rock cracks until it reaches the saturated layer."),
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
