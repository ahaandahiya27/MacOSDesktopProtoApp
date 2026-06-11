import SwiftUI

/// Reusable mid-Discover-scene MCQ surface, shared by all dispatcher
/// inline quick-check scenes (e.g. CycloneSurvivalQuizScene in Ch.8,
/// SpeedLimitsQuizScene + MotionQuizScene in Ch.13, etc.).
///
/// Before 2026-05-27, each of 16 dispatcher files carried its own
/// near-identical private `QuizScene` struct: same VStack header,
/// same per-question card render, same `picks` state, same
/// `recordReview`-shaped onTap. The 2026-05-27 quick-check migration
/// landed the underlying Question content into
/// `Chapter.quickCheckQuestions` and let us collapse the 16
/// duplicates here.
///
/// Behavioural notes:
///   - UX is byte-identical to the pre-migration inline scenes —
///     three-option tap targets, tint-flips-on-pick, score row when
///     all questions answered, GotItButton on the bottom.
///   - Each answer fires `DataStore.shared.recordReview` with the
///     pack-canonical id (`scenecheck_chNN_qII`). Wrong answers
///     surface in DailyPracticeView "Recently Missed" on next
///     launch — that's the whole point of the migration.
///   - Caller passes a `questions` slice (typically four items)
///     plus the human-readable scene title. The chapter dispatcher
///     does the slicing from `chapter.quickCheckQuestionsList`.
///
/// Struct-level `@MainActor` mirrors the BossQuiz Scene9 wiring —
/// `DataStore.shared.recordReview` is a `@MainActor` call, and
/// `check_view_mainactor.py` rejects sync DataStore access from a
/// non-MainActor View. The annotation propagates to instance
/// methods so the qCard helper and the score reducer both stay
/// isolated.
@MainActor
struct QuickCheckQuizScene: View {
    let title: String
    let questions: [Question]
    let onComplete: (Int) -> Void

    @State private var picks: [String: Int] = [:]

    private var score: Int {
        questions.reduce(0) { acc, q in
            guard let i = picks[q.id],
                  let opts = q.options,
                  i >= 0, i < opts.count else { return acc }
            return acc + (opts[i] == q.answer ? 1 : 0)
        }
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text(title)
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .padding(.top, 18)
                ForEach(questions) { q in qCard(q) }
                if picks.count == questions.count && !questions.isEmpty {
                    Text("Score: \(score) / \(questions.count)")
                        .font(.headline)
                        .foregroundColor(DesignTokens.BrandColor.canvasText)
                }
                GotItButton(action: { onComplete(score) }).padding(.bottom, DesignTokens.Spacing.md)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, DesignTokens.Spacing.md)
        }
    }

    @ViewBuilder
    private func qCard(_ q: Question) -> some View {
        let pick = picks[q.id]
        let opts = q.options ?? []
        let correctIndex = opts.firstIndex(of: q.answer)
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
            Text(q.prompt)
                .font(.callout)
                .foregroundColor(DesignTokens.BrandColor.canvasText)
                .fixedSize(horizontal: false, vertical: true)
            ForEach(opts.indices, id: \.self) { i in
                let isPicked = pick == i
                let isCorrectSlot = correctIndex == i
                let tint: Color = pick == nil
                    ? Color.compatIndigo
                    : (isPicked
                        ? (isCorrectSlot
                            ? DesignTokens.BrandColor.primaryAction
                            : DesignTokens.BrandColor.danger)
                        : Color.gray)
                Button {
                    if picks[q.id] == nil {
                        picks[q.id] = i
                        let isCorrect = (opts[i] == q.answer)
                        DataStore.shared.recordReview(
                            questionId: q.id,
                            quality: isCorrect ? .good : .forgot
                        )
                    }
                } label: {
                    Text(opts[i])
                        .font(.caption.weight(.semibold))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Capsule().fill(tint.opacity(isPicked ? 0.22 : 0.10)))
                        .overlay(Capsule().strokeBorder(tint.opacity(0.5), lineWidth: 1))
                        .foregroundColor(tint)
                }
                .buttonStyle(.plain)
                .pointingCursor()
                .disabled(pick != nil)
            }
        }
        .padding(DesignTokens.Spacing.md)
        .frame(maxWidth: DesignTokens.contentMaxWidth, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.85)))
        .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Color.gray.opacity(0.18), lineWidth: 1))
        .padding(.horizontal, DesignTokens.Spacing.xl)
    }
}
