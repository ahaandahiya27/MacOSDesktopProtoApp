import SwiftUI

/// Scene 9 — Boss Quiz Ch14. Five MCQs on electric current.
struct Scene9_BossQuiz_Ch14: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: (Int) -> Void

    struct Q { let prompt: String; let options: [String]; let answer: String; let explain: String }

    private let qs: [Q] = [
        Q(prompt: "An electric current can flow only when the circuit is:",
          options: ["Open", "Closed", "Hot", "Cold"],
          answer: "Closed",
          explain: "Current needs an unbroken loop from + terminal back to − terminal."),
        Q(prompt: "In a series circuit, if one bulb fuses, the others will:",
          options: ["Stay lit", "Get brighter", "Go off", "Spark"],
          answer: "Go off",
          explain: "One break stops all current. That's why house wiring is parallel, not series."),
        Q(prompt: "An electric bell uses which effect of current?",
          options: ["Heating", "Magnetic", "Chemical", "Light"],
          answer: "Magnetic",
          explain: "An electromagnet pulls the hammer; spring brings it back; it strikes the bell."),
        Q(prompt: "A fuse is made of a:",
          options: ["Thick copper wire", "Thin wire that melts easily", "Glass tube", "Plastic strip"],
          answer: "Thin wire that melts easily",
          explain: "When too much current flows, the thin wire heats up and melts — breaking the circuit safely."),
        Q(prompt: "Wrapping more turns of wire around a nail makes the electromagnet:",
          options: ["Weaker", "Stronger", "Hotter only", "Smaller"],
          answer: "Stronger",
          explain: "Each loop adds to the magnetic field. More turns = bigger pull."),
    ]

    @State private var i = 0
    @State private var picked: String? = nil
    @State private var revealed = false
    @State private var score = 0
    @State private var done = false
    @State private var shuffled: [String] = []

    var body: some View {
        VStack(spacing: 14) {
            Text("Boss Quiz").font(.largeTitle.bold()).padding(.top, 18)
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
