import SwiftUI

/// Scene 9 — Boss Quiz Ch13. Five MCQs on motion & time.
struct Scene9_BossQuiz_Ch13: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: (Int) -> Void

    struct Q { let prompt: String; let options: [String]; let answer: String; let explain: String }

    private let qs: [Q] = [
        Q(prompt: "Speed = ?",
          options: ["Distance × Time", "Distance ÷ Time", "Time ÷ Distance", "Distance + Time"],
          answer: "Distance ÷ Time",
          explain: "If a car covers 80 km in 1 hour, its speed is 80 km/h."),
        Q(prompt: "On a distance–time graph, a straight slanted line means:",
          options: ["At rest", "Uniform speed", "Slowing down", "Speeding up"],
          answer: "Uniform speed",
          explain: "Equal distance covered in equal time — that's uniform motion."),
        Q(prompt: "Time for one swing of a pendulum depends on:",
          options: ["Mass", "Amplitude", "Length", "Colour"],
          answer: "Length",
          explain: "Longer string → slower swing. Galileo's classic discovery."),
        Q(prompt: "Which instrument measures total distance travelled?",
          options: ["Speedometer", "Odometer", "Stopwatch", "Sundial"],
          answer: "Odometer",
          explain: "Speedometer = current speed; odometer = running total of distance."),
        Q(prompt: "1 hour = how many seconds?",
          options: ["60", "600", "3,600", "60,000"],
          answer: "3,600",
          explain: "60 minutes × 60 seconds = 3,600 seconds in an hour."),
        Q(prompt: "The SI unit of time is the:",
          options: ["Minute", "Hour", "Second", "Day"],
          answer: "Second",
          explain: "All other time units are defined in terms of seconds in the SI system."),
        Q(prompt: "Average speed is calculated as:",
          options: ["Total time × total distance", "Total distance ÷ total time", "Total distance + total time", "Total distance − total time"],
          answer: "Total distance ÷ total time",
          explain: "Average speed smooths out faster and slower bits of a journey into one number."),
        Q(prompt: "One complete to-and-fro swing of a pendulum is called:",
          options: ["A vibration", "An oscillation", "A revolution", "A rotation"],
          answer: "An oscillation",
          explain: "From the mean position out to one side, back through, out to the other side, and back — that's one oscillation."),
        Q(prompt: "A motorbike travels at 60 km/h for 2 hours. The distance covered is:",
          options: ["30 km", "60 km", "90 km", "120 km"],
          answer: "120 km",
          explain: "Distance = speed × time = 60 × 2 = 120 km."),
        Q(prompt: "A sundial tells time using the position of:",
          options: ["The Moon", "Sound waves", "A shadow", "Water"],
          answer: "A shadow",
          explain: "The Sun moves across the sky and the gnomon's shadow points to different hour marks."),
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
