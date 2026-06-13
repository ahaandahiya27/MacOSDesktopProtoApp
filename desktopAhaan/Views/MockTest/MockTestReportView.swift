import SwiftUI
import AppKit

// MARK: - MockTestReportView
//
// v9 Exam Simulation · Phase 2/3. The graded report shown after submit: the
// marking-scheme score, the correct / wrong / skipped + timing summary, a
// per-subject breakdown, the weakest topics to revisit, and a collapsible
// per-question review. Retake builds a fresh paper; Done closes the window.
//
// Pure presentation over a finished `MockTestResult` — it computes nothing about
// the SRS. (Persisting the result + recording reviews happens in the coordinator
// before this view is shown; see `MockTestView`.)
//
// Big Sur safe: DesignTokens, SF-Symbol-free glyphs, static bars (no particles),
// `withAnimationRespectingReduceMotion`, explicit a11y. No macOS 12+ APIs.
@MainActor
struct MockTestReportView: View {
    let result: MockTestResult
    let onRetake: () -> Void
    let onDone: () -> Void

    @State private var showAllAnswers = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.lg) {
                header
                scoreCard
                statsRow
                subjectSection
                weakAreasSection
                reviewSection
                actions
            }
            .padding(DesignTokens.Spacing.xl)
            .frame(maxWidth: 680, alignment: .leading)
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .background(Color(NSColor.windowBackgroundColor))
    }

    // MARK: - Header

    private var header: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xxs) {
            HStack(spacing: DesignTokens.Spacing.sm) {
                Text(resultEmoji).font(.system(size: 34)).accessibilityHidden(true)
                Text("Your results")
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
            }
            if result.autoSubmitted {
                Text("⏱ Time ran out — the paper was submitted automatically.")
                    .font(.caption)
                    .foregroundColor(DesignTokens.BrandColor.warning)
                    .accessibilityLabel("Time ran out. The paper was submitted automatically.")
            }
        }
    }

    // MARK: - Score

    private var scoreCard: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
            HStack(alignment: .firstTextBaseline, spacing: DesignTokens.Spacing.xs) {
                Text("\(result.totalMarks)")
                    .font(.system(size: 44, weight: .bold))
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                Text("/ \(result.maxMarks) marks")
                    .font(.title3.weight(.semibold))
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                Spacer(minLength: 0)
            }
            ProgressBar(fraction: result.marksFraction, tint: DesignTokens.BrandColor.primaryAction)
            Text(scoreMessage)
                .font(.callout)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(DesignTokens.Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: DesignTokens.Radius.card)
                .fill(DesignTokens.BrandColor.primaryAction.opacity(0.08)))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Score: \(result.totalMarks) out of \(result.maxMarks) marks. \(scoreMessage)")
    }

    // MARK: - Stats

    private var statsRow: some View {
        HStack(spacing: DesignTokens.Spacing.sm) {
            statTile("\(result.correctCount)", "Correct", DesignTokens.BrandColor.success)
            statTile("\(result.wrongCount)", "Wrong", DesignTokens.BrandColor.danger)
            statTile("\(result.unansweredCount)", "Skipped", DesignTokens.BrandColor.canvasTextSecondary)
            statTile(timeUsedText, "Time used", DesignTokens.BrandColor.primaryAction)
        }
    }

    private func statTile(_ value: String, _ label: String, _ tint: Color) -> some View {
        VStack(spacing: DesignTokens.Spacing.xxs) {
            Text(value).font(.title3.weight(.bold).monospacedDigit()).foregroundColor(tint)
            Text(label).font(.caption2).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, DesignTokens.Spacing.md)
        .background(RoundedRectangle(cornerRadius: DesignTokens.Radius.md).fill(Color.gray.opacity(0.06)))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(value) \(label)")
    }

    // MARK: - Per-subject

    @ViewBuilder
    private var subjectSection: some View {
        if result.perSubject.count > 1 {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                Text("By subject")
                    .font(.headline)
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                ForEach(result.perSubject) { row in
                    subjectRow(row)
                }
            }
        }
    }

    private func subjectRow(_ row: MockTestSubjectScore) -> some View {
        HStack(spacing: DesignTokens.Spacing.sm) {
            Text(row.subjectTitle)
                .font(.callout.weight(.semibold))
                .foregroundColor(DesignTokens.BrandColor.canvasText)
                .lineLimit(1).minimumScaleFactor(0.8)
            Spacer(minLength: 0)
            Text("\(row.correct)/\(row.total) · \(row.marks) marks")
                .font(.callout.monospacedDigit())
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
        }
        .padding(.horizontal, DesignTokens.Spacing.md)
        .padding(.vertical, DesignTokens.Spacing.sm)
        .background(RoundedRectangle(cornerRadius: DesignTokens.Radius.md).fill(Color.gray.opacity(0.05)))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(row.subjectTitle): \(row.correct) of \(row.total) correct, \(row.marks) marks.")
    }

    // MARK: - Weak areas

    @ViewBuilder
    private var weakAreasSection: some View {
        let weak = result.weakTopics()
        if !weak.isEmpty {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                Text("Topics to revisit")
                    .font(.headline)
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                ForEach(weak) { topic in
                    weakRow(topic)
                }
            }
        }
    }

    private func weakRow(_ topic: MockTestTopicScore) -> some View {
        HStack(spacing: DesignTokens.Spacing.sm) {
            Text("🎯").accessibilityHidden(true)
            Text(topic.topicTitle)
                .font(.callout)
                .foregroundColor(DesignTokens.BrandColor.canvasText)
                .fixedSize(horizontal: false, vertical: true)
            Spacer(minLength: 0)
            Text("\(topic.correct)/\(topic.total)")
                .font(.callout.monospacedDigit())
                .foregroundColor(DesignTokens.BrandColor.danger)
        }
        .padding(.horizontal, DesignTokens.Spacing.md)
        .padding(.vertical, DesignTokens.Spacing.sm)
        .background(RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
            .fill(DesignTokens.BrandColor.danger.opacity(0.06)))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(topic.topicTitle): \(topic.correct) of \(topic.total) correct — worth another look.")
    }

    // MARK: - Per-question review (collapsible)

    private var reviewSection: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
            Button(action: { withAnimationRespectingReduceMotion(.easeInOut(duration: 0.2)) { showAllAnswers.toggle() } }) {
                HStack {
                    Text(showAllAnswers ? "Hide answer review" : "Review every answer")
                        .font(.headline)
                        .foregroundColor(DesignTokens.BrandColor.primaryAction)
                    Spacer(minLength: 0)
                    Text(showAllAnswers ? "▲" : "▼")
                        .font(.caption).foregroundColor(DesignTokens.BrandColor.primaryAction)
                        .accessibilityHidden(true)
                }
                .frame(minHeight: 44)
            }
            .buttonStyle(.plain)
            .accessibilityLabel(showAllAnswers ? "Hide answer review" : "Review every answer")
            .accessibilityHint("Shows each question with your answer and the correct one")
            .accessibilityIdentifier("mocktest-review-toggle")

            if showAllAnswers {
                ForEach(result.outcomes) { outcome in
                    answerRow(outcome)
                }
            }
        }
    }

    private func answerRow(_ outcome: MockTestQuestionOutcome) -> some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xxs) {
            Text(outcome.prompt)
                .font(.callout.weight(.semibold))
                .foregroundColor(DesignTokens.BrandColor.canvasText)
                .fixedSize(horizontal: false, vertical: true)
            Text(answerLine(outcome))
                .font(.caption)
                .foregroundColor(outcome.isCorrect
                                 ? DesignTokens.BrandColor.success
                                 : DesignTokens.BrandColor.danger)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(DesignTokens.Spacing.md)
        .background(RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
            .fill((outcome.isCorrect ? DesignTokens.BrandColor.success : DesignTokens.BrandColor.danger).opacity(0.06)))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(outcome.prompt). \(answerLine(outcome))")
    }

    private func answerLine(_ outcome: MockTestQuestionOutcome) -> String {
        if !outcome.isAnswered {
            return "⊘ Skipped — the answer was “\(outcome.correctAnswer)”."
        }
        if outcome.isCorrect {
            return "✅ Correct: “\(outcome.correctAnswer)”."
        }
        return "❌ You chose “\(outcome.selectedAnswer ?? "")” — the answer was “\(outcome.correctAnswer)”."
    }

    // MARK: - Actions

    private var actions: some View {
        HStack(spacing: DesignTokens.Spacing.md) {
            Button(action: onRetake) {
                Text("New test")
                    .font(.headline).foregroundColor(.white)
                    .padding(.horizontal, DesignTokens.Spacing.lg)
                    .padding(.vertical, DesignTokens.Spacing.sm)
                    .frame(minHeight: 44)
                    .background(Capsule().fill(DesignTokens.BrandColor.primaryAction))
            }
            .buttonStyle(.plain)
            .accessibilityLabel("New test")
            .accessibilityHint("Returns to setup to build a fresh paper")
            .accessibilityIdentifier("mocktest-new")

            Button(action: onDone) {
                Text("Done")
                    .font(.headline).foregroundColor(DesignTokens.BrandColor.primaryAction)
                    .padding(.horizontal, DesignTokens.Spacing.lg)
                    .padding(.vertical, DesignTokens.Spacing.sm)
                    .frame(minHeight: 44)
                    .background(Capsule().stroke(DesignTokens.BrandColor.primaryAction, lineWidth: 1.5))
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Done")
            .accessibilityIdentifier("mocktest-done")
            Spacer(minLength: 0)
        }
    }

    // MARK: - Copy helpers

    private var resultEmoji: String {
        let f = result.accuracyFraction
        if f >= 0.8 { return "🌟" }
        if f >= 0.5 { return "👍" }
        return "💪"
    }

    private var scoreMessage: String {
        let f = result.accuracyFraction
        let pct = Int((f * 100).rounded())
        if f >= 0.8 { return "Outstanding — \(pct)% correct. You're exam-ready on this." }
        if f >= 0.5 { return "Good effort — \(pct)% correct. Revisit the topics below and you'll climb fast." }
        return "\(pct)% correct. The topics below are where the next practice pays off most."
    }

    private var timeUsedText: String {
        MockTestRunState.format(result.totalSecondsSpent)
    }
}

// MARK: - ProgressBar
//
// A static horizontal bar (muted track + tinted fill sized to `fraction`). No
// animation — width is set directly, so it costs the legacy GPU nothing and is
// unaffected by Reduce Motion. Accessibility-hidden; the score card speaks it.
private struct ProgressBar: View {
    let fraction: Double
    let tint: Color

    var body: some View {
        GeometryReader { geo in
            let clamped: CGFloat = CGFloat(max(0, min(1, fraction)))
            let fillW: CGFloat = clamped * geo.size.width
            ZStack(alignment: .leading) {
                Capsule().fill(DesignTokens.BrandColor.mutedSurface.opacity(0.5))
                Capsule().fill(tint).frame(width: fillW)
            }
        }
        .frame(height: 12)
        .accessibilityHidden(true)
    }
}
