import SwiftUI

/// Scene 9 — Boss Quiz Ch9. Five MCQs on soil.
struct Scene9_BossQuiz_Ch9: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: (Int) -> Void

    struct Q { let prompt: String; let options: [String]; let answer: String; let explain: String }

    private let qs: [Q] = [
        Q(prompt: "The topmost layer of soil, rich in humus, is called:",
          options: ["Bedrock", "Subsoil", "Topsoil", "Weathered rock"],
          answer: "Topsoil",
          explain: "Topsoil (A horizon) is dark, soft and where most plant roots grow."),
        Q(prompt: "Paddy grows best in which soil?",
          options: ["Sandy", "Loamy", "Clayey", "Black"],
          answer: "Clayey",
          explain: "Paddy needs standing water; clay holds water → perfect for rice."),
        Q(prompt: "Soil erosion is mainly caused by:",
          options: ["Earthworms", "Removal of plants", "Sunlight", "Cool wind"],
          answer: "Removal of plants",
          explain: "When roots are gone, rain and wind carry away the loose topsoil."),
        Q(prompt: "Which soil drains water fastest?",
          options: ["Sandy", "Loamy", "Clayey", "Black"],
          answer: "Sandy",
          explain: "Sand grains are large → water slips through easily."),
        Q(prompt: "Earthworms help soil by:",
          options: ["Eating plants", "Making tunnels and castings", "Drinking all the water", "Cooling it"],
          answer: "Making tunnels and castings",
          explain: "Their tunnels aerate soil and their castings add nutrients — they're called nature's ploughs."),
        Q(prompt: "In a soil profile, the layer just below topsoil is called:",
          options: ["Bedrock", "Subsoil (B-horizon)", "Humus", "Litter"],
          answer: "Subsoil (B-horizon)",
          explain: "A is topsoil, B is subsoil (less humus, more minerals), C is weathered rock above bedrock."),
        Q(prompt: "A tube well draws water from:",
          options: ["Rivers", "Lakes", "Groundwater under the soil", "Rainwater on the surface"],
          answer: "Groundwater under the soil",
          explain: "A pipe goes deep enough to reach the saturated layer below the water table."),
        Q(prompt: "Loamy soil is ideal for most crops because it:",
          options: ["Holds water but also drains well", "Is pure sand", "Is pure clay", "Has no nutrients"],
          answer: "Holds water but also drains well",
          explain: "Loam is a balanced mix of sand, silt and clay — wheat, gram and many vegetables grow well in it."),
        Q(prompt: "Which of these causes soil pollution?",
          options: ["Earthworm burrows", "Plastic and pesticides", "Falling leaves", "Rainwater"],
          answer: "Plastic and pesticides",
          explain: "Synthetic chemicals and plastics don't break down naturally and they harm soil life."),
        Q(prompt: "Clayey soil drains water:",
          options: ["Very fast", "Slowly", "Instantly", "Never holds it"],
          answer: "Slowly",
          explain: "Clay particles are tiny and pack tightly, leaving very small gaps — water seeps through slowly."),
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
                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
        }

        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear { if shuffled.isEmpty { shuffled = qs[i].options.shuffled() } }
        .onChange(of: i) { newI in shuffled = qs[newI].options.shuffled() }
    }
}
