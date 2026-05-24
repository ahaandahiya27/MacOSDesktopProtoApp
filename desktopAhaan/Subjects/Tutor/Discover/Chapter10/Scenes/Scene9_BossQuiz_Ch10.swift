import SwiftUI

/// Scene 9 — Boss Quiz Ch10. Five MCQs on respiration.
struct Scene9_BossQuiz_Ch10: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: (Int) -> Void

    struct Q { let prompt: String; let options: [String]; let answer: String; let explain: String }

    private let qs: [Q] = [
        Q(prompt: "We exhale mostly:",
          options: ["Oxygen", "Carbon dioxide", "Nitrogen", "Hydrogen"],
          answer: "Carbon dioxide",
          explain: "Exhaled breath has about 4% CO₂ (vs 0.04% inhaled). That's why limewater turns milky."),
        Q(prompt: "Respiration without oxygen is called:",
          options: ["Aerobic", "Anaerobic", "Atmospheric", "Aerial"],
          answer: "Anaerobic",
          explain: "Yeast and tired muscle cells use anaerobic respiration when oxygen runs low."),
        Q(prompt: "Fish breathe through:",
          options: ["Lungs", "Skin", "Gills", "Stomata"],
          answer: "Gills",
          explain: "Gills extract dissolved oxygen from water as it flows over them."),
        Q(prompt: "Plants release O₂ and absorb CO₂ at tiny pores called:",
          options: ["Spiracles", "Stomata", "Tracheae", "Pores"],
          answer: "Stomata",
          explain: "Stomata on the underside of leaves regulate gas exchange."),
        Q(prompt: "Cramps after a hard run are because muscles produced:",
          options: ["Glucose", "Lactic acid", "Oxygen", "Water"],
          answer: "Lactic acid",
          explain: "Muscles ran low on oxygen and switched to anaerobic respiration → lactic acid → cramps."),
        Q(prompt: "When we inhale, the diaphragm:",
          options: ["Moves up and curls", "Moves down and flattens", "Stays still", "Becomes the lungs"],
          answer: "Moves down and flattens",
          explain: "The diaphragm pulls down to enlarge the chest cavity, so air rushes into the lungs."),
        Q(prompt: "Cockroaches breathe through tiny holes called:",
          options: ["Pores", "Spiracles", "Stomata", "Gills"],
          answer: "Spiracles",
          explain: "Air enters through spiracles on the body sides and travels through tracheal tubes to cells."),
        Q(prompt: "An earthworm breathes through its:",
          options: ["Lungs", "Mouth", "Moist skin", "Gills"],
          answer: "Moist skin",
          explain: "Oxygen dissolves in the thin film of moisture on the earthworm's skin and diffuses inwards."),
        Q(prompt: "Yeast carries out anaerobic respiration to give:",
          options: ["Carbon dioxide + water", "Carbon dioxide + alcohol", "Oxygen + glucose", "Just oxygen"],
          answer: "Carbon dioxide + alcohol",
          explain: "Bakers use the CO₂ to make bread rise; brewers use the alcohol."),
        Q(prompt: "The energy released in cells during respiration is stored as:",
          options: ["Glucose", "Oxygen", "ATP", "Carbon dioxide"],
          answer: "ATP",
          explain: "ATP is the energy currency of cells — broken down whenever cells need power."),
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
