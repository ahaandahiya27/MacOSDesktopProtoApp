import SwiftUI
import AppKit

// MARK: - DeepDiveDetailSheet
//
// Presented from `DeepDiveSection` when the kid taps a stretch topic.
// Renders the topic's full body, prerequisite, optional bonus questions
// and the next-step hint, plus a "Back to chapter" close button.
//
// Big Sur compat:
//   - ScrollView + VStack only, no Layout / @Observable / new APIs.
//   - Sheet frame is bounded so it doesn't overflow the deploy iMac's
//     5K window.
//   - `Color.compat*` tokens only.
//   - `.respectReduceMotion` on the open transition (the sheet itself
//     animates via SwiftUI's default sheet present, which honors the
//     OS-level Reduce Motion preference automatically).

struct DeepDiveDetailSheet: View {
    let chapter: Chapter
    let topic: StretchTopic
    let onDismiss: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            header
            Divider()
            ScrollView {
                contentBody
                    .padding(.horizontal, DesignTokens.Spacing.xl)
                    .padding(.vertical, 18)
                    .frame(maxWidth: 720, alignment: .leading)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            Divider()
            footerBar
        }
        .frame(minWidth: 540, idealWidth: 720, maxWidth: 920,
               minHeight: 420, idealHeight: 560, maxHeight: 760)
        .background(Color(NSColor.windowBackgroundColor))
        // Esc / ⌘W close — keep the dismiss path consistent with the
        // other sheets in the app.
        .background(
            Button("Dismiss", action: onDismiss)
                .keyboardShortcut(.cancelAction)
                .opacity(0)
                .frame(width: 0, height: 0)
                .accessibilityHidden(true)
        )
    }

    /// Top bar: chapter context, title, grade badge, and a small close
    /// button on the right. Kept as a horizontal flow so it stays
    /// readable at the sheet's min width (540pt).
    private var header: some View {
        HStack(alignment: .top, spacing: 14) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Ch.\(chapter.number) · Go deeper")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)
                Text(topic.title)
                    .font(.title2.bold())
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)
                HStack(spacing: DesignTokens.Spacing.sm) {
                    GradeBadge(level: topic.gradeLevel)
                    if let prereq = topic.prerequisite, !prereq.isEmpty {
                        Text(prereq)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            Spacer(minLength: 0)
            Button(action: onDismiss) {
                Image(systemName: "xmark.circle.fill")
                    .font(.title2)
                    .foregroundColor(.secondary)
            }
            .buttonStyle(.plain)
            .pointingCursor()
            .accessibilityLabel("Close stretch topic")
            .accessibilityHint("Returns to the chapter detail page.")
        }
        .padding(.horizontal, DesignTokens.Spacing.xl)
        .padding(.top, 20)
        .padding(.bottom, 14)
    }

    /// Main body: the topic.body text (120–250 words per schema),
    /// followed by optional bonus questions and the next-step hint.
    private var contentBody: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text(topic.body)
                .font(.body)
                .lineSpacing(5)
                .fixedSize(horizontal: false, vertical: true)
            bonusQuestionsBlock
            nextStepBlock
        }
    }

    /// Optional bonus questions — folded into a small section with a
    /// heading so it reads as a quiz card group, not as prose.
    @ViewBuilder
    private var bonusQuestionsBlock: some View {
        let questions = topic.bonusQuestions ?? []
        if !questions.isEmpty {
            VStack(alignment: .leading, spacing: 10) {
                Text("Bonus questions (\(questions.count))")
                    .font(.headline)
                    .accessibilityAddTraits(.isHeader)
                ForEach(questions) { q in
                    BonusQuestionCard(question: q)
                }
            }
            .padding(.top, DesignTokens.Spacing.xs)
        }
    }

    /// Optional 1–2 sentence "where this goes next" footer.
    @ViewBuilder
    private var nextStepBlock: some View {
        if let hint = topic.nextStepHint, !hint.isEmpty {
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: "arrow.forward.circle.fill")
                    .font(.body)
                    .foregroundColor(Color.compatIndigo)
                    .accessibilityHidden(true)
                Text(hint)
                    .font(.callout)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(DesignTokens.Spacing.md)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.compatIndigo.opacity(0.08))
            )
            .padding(.top, DesignTokens.Spacing.xs)
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Where this goes next: \(hint)")
        }
    }

    /// Footer bar with the primary close button. ⌘W / Esc still close
    /// via the invisible background button on the root view.
    private var footerBar: some View {
        HStack {
            Spacer()
            Button("Back to chapter", action: onDismiss)
                .keyboardShortcut(.defaultAction)
                .accessibilityIdentifier("deep-dive-detail-close")
                .accessibilityLabel("Back to chapter")
                .accessibilityHint("Closes the stretch topic and returns to the chapter detail page.")
        }
        .padding(.horizontal, DesignTokens.Spacing.xl)
        .padding(.vertical, DesignTokens.Spacing.md)
    }
}

// MARK: - BonusQuestionCard

/// Static read-only card for a `Question` attached to a `StretchTopic`.
/// Unlike `QuestionDetailView`, this card just shows prompt + worked
/// explanation — the stretch topic is reading material, not a quiz
/// flow. (The kid can still hit any "real" question via the standard
/// Quiz Bank.)
private struct BonusQuestionCard: View {
    let question: Question

    @State private var showAnswer = false

    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
            Text(question.prompt)
                .font(.body.weight(.semibold))
                .fixedSize(horizontal: false, vertical: true)
            answerSection
        }
        .padding(DesignTokens.Spacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.secondary.opacity(0.25), lineWidth: 1)
        )
    }

    @ViewBuilder
    private var answerSection: some View {
        if showAnswer {
            VStack(alignment: .leading, spacing: 6) {
                Text(question.answer)
                    .font(.callout)
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)
                if !question.solutionSteps.isEmpty {
                    Text(question.solutionSteps.joined(separator: "\n"))
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding(.top, DesignTokens.Spacing.xxs)
            .transition(.opacity)
        } else {
            Button("Show answer") {
                withAnimationRespectingReduceMotion(.easeOut(duration: 0.18)) {
                    showAnswer = true
                }
            }
            .buttonStyle(.bordered)
            .accessibilityLabel("Show answer")
            .accessibilityHint("Reveals the worked answer for this bonus question.")
        }
    }
}
