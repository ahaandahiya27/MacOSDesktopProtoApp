import SwiftUI

/// Scene 9 — Boss Quiz Ch14. Five MCQs on electric current.
@MainActor
struct Scene9_BossQuiz_Ch14: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: (Int) -> Void

    /// Boss-quiz MCQs sourced from the science pack
    /// (`chapter.bossQuestions`). Authored in `science_class7.json`
    /// and loaded via SubjectRegistry. Daily Practice "Recently
    /// Missed" picks up wrong-answer ids from the same SM-2 store
    /// once `recordReview(questionId:quality:)` fires below.
    private var quiz: [Question] { chapter.bossQuestionsList }

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
                ProgressView(value: Double(i), total: Double(quiz.count)).frame(maxWidth: 520)

                if !done {
                    let q = quiz[i]
                    Text("Question \(i + 1) of \(quiz.count)").font(.subheadline).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
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
                                DataStore.shared.recordReview(
                                    questionId: q.id,
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
                                .padding(DesignTokens.Spacing.md)
                                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.95)))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .frame(maxWidth: 600)

                    if revealed {
                        SoftShadowCard(padding: 12) {
                            Label(q.bossExplanation, systemImage: "lightbulb.fill").font(.callout)
                        }
                        .frame(maxWidth: 600)
                        Button(i + 1 < quiz.count ? "Next question" : "See score") {
                            if i + 1 < quiz.count { i += 1; picked = nil; revealed = false }
                            else { done = true; celebrate = true }
                        }
                        .accentColor(Color.compatIndigo)
                    }
                } else {
                    VStack(spacing: DesignTokens.Spacing.md) {
                        if score >= 4 {
                            Image(systemName: "checkmark.seal.fill")
                                .font(.system(size: 56))
                                .foregroundColor(.green)
                                .accessibilityHidden(true)
                            Text("Great job!").font(.title2.bold()).foregroundColor(.green)
                        }
                        Text("Score: \(score) / \(quiz.count)").font(.system(size: 36, weight: .bold))
                        GotItButton(label: "Finish chapter") { onComplete(score) }
                    }
                    .padding(.top, DesignTokens.Spacing.sm)
                }
                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, DesignTokens.Spacing.md)
        }
        .overlay(
            Group {
                if celebrate {
                    ParticleEmitter(isActive: true, particleCount: HardwareTier.particleBudget, duration: 3.0)
                        .allowsHitTesting(false)
                        .ignoresSafeArea()
                }
            }
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear { if shuffled.isEmpty { shuffled = (quiz[i].options ?? []).shuffled() } }
        .onChange(of: i) { newI in shuffled = (quiz[newI].options ?? []).shuffled() }
    }
}
