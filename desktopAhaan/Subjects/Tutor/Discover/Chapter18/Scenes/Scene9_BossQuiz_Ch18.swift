import SwiftUI

/// Scene 9 — Boss Quiz Ch18. Five MCQs on wastewater.
struct Scene9_BossQuiz_Ch18: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: (Int) -> Void

    struct Q { let prompt: String; let options: [String]; let answer: String; let explain: String }

    private let qs: [Q] = [
        Q(prompt: "Wastewater is also called:",
          options: ["Drinking water", "Sewage", "Rainwater", "Glacial water"],
          answer: "Sewage",
          explain: "Sewage = used water from homes and industries, plus its contaminants."),
        Q(prompt: "In a treatment plant, the bar screen removes:",
          options: ["Bacteria", "Dissolved salts", "Large solids like rags & plastics", "Dissolved oxygen"],
          answer: "Large solids like rags & plastics",
          explain: "Bars catch big items before pumps get clogged."),
        Q(prompt: "Aerator tanks help by:",
          options: ["Cooling sewage", "Adding chlorine", "Feeding microbes with oxygen", "Removing colour"],
          answer: "Feeding microbes with oxygen",
          explain: "Aerobic bacteria eat dissolved organic waste — they need oxygen to work."),
        Q(prompt: "Open drains are a problem because they:",
          options: ["Cool the streets", "Breed mosquitoes & spread disease", "Save water", "Make houses clean"],
          answer: "Breed mosquitoes & spread disease",
          explain: "Stagnant sewage = perfect breeding ground for malaria and cholera vectors."),
        Q(prompt: "Composting kitchen waste at home:",
          options: ["Wastes water", "Reduces load on sewers and produces fertiliser", "Spreads disease", "Is illegal"],
          answer: "Reduces load on sewers and produces fertiliser",
          explain: "Half of household waste is organic. Composting keeps it out of pipes and turns it into soil."),
        Q(prompt: "The sludge left over after treating wastewater is often used to:",
          options: ["Make biogas or manure", "Make plastic bags", "Make drinking water", "Build houses"],
          answer: "Make biogas or manure",
          explain: "Bacteria break down dried sludge into useful manure or biogas — nothing is wasted."),
        Q(prompt: "A septic tank is most useful in:",
          options: ["Crowded cities with sewers", "Areas without a sewer network", "Inside a pond", "On a rooftop"],
          answer: "Areas without a sewer network",
          explain: "Septic tanks hold and partly treat household sewage on the spot — good for villages and rural homes."),
        Q(prompt: "Cholera spreads mainly through:",
          options: ["Touching pets", "Eating fruit", "Contaminated water", "Breathing dust"],
          answer: "Contaminated water",
          explain: "Drinking water mixed with sewage carries cholera bacteria into the gut."),
        Q(prompt: "A sewer is:",
          options: ["An overflow tank", "An underground pipe that carries sewage", "A rooftop water tank", "A storm cloud"],
          answer: "An underground pipe that carries sewage",
          explain: "Many small sewers feed into bigger ones and finally reach a treatment plant."),
        Q(prompt: "Treated wastewater is most commonly reused for:",
          options: ["Drinking", "Irrigation and cleaning", "Cooking", "Bottling and selling"],
          answer: "Irrigation and cleaning",
          explain: "Treated water is good enough to water plants and wash streets but not always to drink."),
    ]

    @State private var i = 0
    @State private var picked: String? = nil
    @State private var revealed = false
    @State private var score = 0
    @State private var done = false
    @State private var celebrate = false
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
                            else { done = true; celebrate = true }
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
        .overlay(
            Group {
                if celebrate {
                    ParticleEmitter(isActive: true, particleCount: 100, duration: 3.0)
                        .allowsHitTesting(false)
                }
            }
        )
        .onAppear { if shuffled.isEmpty { shuffled = qs[i].options.shuffled() } }
        .onChange(of: i) { newI in shuffled = qs[newI].options.shuffled() }
    }
}
