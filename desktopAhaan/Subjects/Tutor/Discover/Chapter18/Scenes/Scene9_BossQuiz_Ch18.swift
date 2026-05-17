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
    ]

    @State private var i = 0
    @State private var picked: String? = nil
    @State private var revealed = false
    @State private var score = 0
    @State private var done = false
    @State private var shuffled: [String] = []

    var body: some View {
        VStack(spacing: 14) {
            Text("Boss Quiz").font(.largeTitle.bold()).foregroundColor(ChapterTheme.accent(for: chapter.id)).padding(.top, 18)
            ProgressView(value: Double(i), total: Double(qs.count)).frame(maxWidth: 520)

            if !done {
                let q = qs[i]
                Text("Question \(i + 1) of \(qs.count)").font(.subheadline).foregroundColor(.secondary)
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
                            if opt == q.answer { score += 1 }
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
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.08)))
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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear { if shuffled.isEmpty { shuffled = qs[i].options.shuffled() } }
        .onChange(of: i) { newI in shuffled = qs[newI].options.shuffled() }
    }
}
