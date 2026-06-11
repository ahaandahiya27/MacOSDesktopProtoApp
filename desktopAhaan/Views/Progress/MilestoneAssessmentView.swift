import SwiftUI
import AppKit

/// v6 Learning Journey · Phase 4. The **Milestone Checkpoint** — a short,
/// mixed, multiple-choice quiz sampled by mastery gaps (see
/// `DataStore.buildMilestoneAssessment` + `MilestoneAssessmentPlanner`). It runs
/// a tiny three-phase flow entirely in local `@State`:
///   intro → one question at a time (tap an option, Check, see the answer) →
///   a result screen with a per-subject breakdown.
///
/// Deliberately a CHECK-IN, not a teaching surface: scoring is local
/// (`AnswerValidator.matches`) and it NEVER writes the SRS, so retaking it can't
/// distort the kid's review schedule — the same read-only stance as the
/// MasteryEngine the sampler is built on.
///
/// Presented in its own AppKit window via Help → Milestone Checkpoint (see
/// `MilestoneAssessmentWindow.swift` + `desktopAhaanApp.swift`). `@MainActor`
/// because it reads `DataStore` (main-actor-isolated) synchronously in
/// `onAppear`. Static bars only — no particles — so it costs the legacy AMD GPU
/// nothing, and the only transitions go through
/// `withAnimationRespectingReduceMotion`.
@MainActor
struct MilestoneAssessmentView: View {
    @EnvironmentObject var dataStore: DataStore
    @EnvironmentObject var registry: SubjectRegistry

    private enum Phase: Equatable { case intro, answering, result }

    @State private var assessment: MilestoneAssessment?
    @State private var phase: Phase = .intro
    @State private var index = 0
    @State private var selected: String?
    @State private var revealed = false
    /// questionId → was it answered correctly. Drives the score + breakdown.
    @State private var correctById: [String: Bool] = [:]
    /// The finished + persisted result, built once when the quiz completes.
    @State private var result: MilestoneCheckpointResult?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                header
                content
            }
            .padding(20)
            .frame(maxWidth: 680, alignment: .leading)
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .background(Color(NSColor.windowBackgroundColor))
        .onAppear { buildIfNeeded() }
        .navigationTitle("Milestone Checkpoint")
    }

    // MARK: - Phase routing

    @ViewBuilder
    private var content: some View {
        if let assessment = assessment {
            if assessment.isEmpty {
                emptyState
            } else {
                switch phase {
                case .intro:     introCard(assessment)
                case .answering: answeringSection(assessment)
                case .result:    resultSection(assessment)
                }
            }
        } else {
            ProgressView("Preparing your checkpoint…")
                .padding(.vertical, 40)
                .frame(maxWidth: .infinity)
        }
    }

    // MARK: - Build / flow control

    private func buildIfNeeded() {
        guard assessment == nil else { return }
        assessment = dataStore.buildMilestoneAssessment(registry: registry)
    }

    private func begin() {
        index = 0
        selected = nil
        revealed = false
        correctById = [:]
        result = nil
        withAnimationRespectingReduceMotion(.easeInOut(duration: 0.2)) { phase = .answering }
    }

    private func check() {
        guard let q = currentQuestion, let sel = selected, !revealed else { return }
        correctById[q.id] = AnswerValidator.matches(userInput: sel, truth: q.question.answer)
        withAnimationRespectingReduceMotion(.easeInOut(duration: 0.2)) { revealed = true }
    }

    private func advance(in assessment: MilestoneAssessment) {
        if index + 1 < assessment.count {
            index += 1
            selected = nil
            revealed = false
        } else {
            // Quiz complete: build the result once, persist it (new app state,
            // never the SRS), and show it.
            let finished = MilestoneCheckpointResult.from(
                assessment: assessment, correctById: correctById, takenAt: Date())
            result = finished
            dataStore.recordCheckpointResult(finished)
            withAnimationRespectingReduceMotion(.easeInOut(duration: 0.2)) { phase = .result }
        }
    }

    private func retake() {
        assessment = dataStore.buildMilestoneAssessment(registry: registry)
        index = 0
        selected = nil
        revealed = false
        correctById = [:]
        result = nil
        withAnimationRespectingReduceMotion(.easeInOut(duration: 0.2)) { phase = .intro }
    }

    private var currentQuestion: AssessmentQuestion? {
        guard let assessment = assessment,
              index >= 0, index < assessment.questions.count else { return nil }
        return assessment.questions[index]
    }

    // MARK: - Header

    private var header: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
            HStack(spacing: 10) {
                Text("🏁").font(.system(size: 34)).accessibilityHidden(true)
                Text("Milestone Checkpoint")
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
            }
            Text("A quick mixed quiz to check in on your whole journey.")
                .font(.subheadline)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Milestone Checkpoint. A quick mixed quiz to check in on your whole journey.")
    }

    // MARK: - Intro

    private func introCard(_ assessment: MilestoneAssessment) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Ready for a checkpoint?")
                .font(.title2.weight(.bold))
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            Text("\(assessment.count) multiple-choice question\(assessment.count == 1 ? "" : "s"), mixed across \(subjectList(assessment)). It leans into the subjects that need the most attention right now.")
                .font(.callout)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                .fixedSize(horizontal: false, vertical: true)
            Text("This is just a check-in — your answers here won't change your review schedule.")
                .font(.caption)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                .fixedSize(horizontal: false, vertical: true)
            Button(action: { begin() }) {
                Text("Begin checkpoint")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 10)
                    .frame(minHeight: 44)
                    .background(Capsule().fill(DesignTokens.BrandColor.primaryAction))
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Begin checkpoint")
        }
        .padding(DesignTokens.Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: DesignTokens.Radius.card)
                .fill(DesignTokens.BrandColor.primaryAction.opacity(0.07))
        )
    }

    private func subjectList(_ assessment: MilestoneAssessment) -> String {
        let titles = assessment.subjectTitles
        switch titles.count {
        case 0:  return "your subjects"
        case 1:  return titles[0]
        case 2:  return "\(titles[0]) and \(titles[1])"
        default: return titles.dropLast().joined(separator: ", ") + ", and " + (titles.last ?? "")
        }
    }

    // MARK: - Answering

    private func answeringSection(_ assessment: MilestoneAssessment) -> some View {
        Group {
            if let q = currentQuestion {
                VStack(alignment: .leading, spacing: 14) {
                    questionMeta(q, total: assessment.count)
                    Text(q.question.prompt)
                        .font(.title3.weight(.semibold))
                        .foregroundColor(DesignTokens.BrandColor.canvasText)
                        .fixedSize(horizontal: false, vertical: true)
                    optionsList(q)
                    if revealed { feedbackBlock(q) }
                    actionRow(assessment, question: q)
                }
                .padding(DesignTokens.Spacing.lg)
                .background(
                    RoundedRectangle(cornerRadius: DesignTokens.Radius.card)
                        .fill(DesignTokens.BrandColor.primaryAction.opacity(0.05))
                )
            } else {
                // Defensive: an out-of-range index can't normally happen, but if
                // it did we route to the result rather than show a blank card.
                Color.clear.frame(height: 1).onAppear { phase = .result }
            }
        }
    }

    private func questionMeta(_ q: AssessmentQuestion, total: Int) -> some View {
        HStack(spacing: DesignTokens.Spacing.sm) {
            Text(emoji(for: q.packId)).font(.system(size: 18)).accessibilityHidden(true)
            Text("\(q.subjectTitle) · \(q.chapterTitle)")
                .font(.caption.weight(.semibold))
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            Spacer(minLength: 0)
            Text("Question \(index + 1) of \(total)")
                .font(.caption.monospacedDigit())
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Question \(index + 1) of \(total). \(q.subjectTitle), \(q.chapterTitle).")
    }

    private func optionsList(_ q: AssessmentQuestion) -> some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
            // Index-keyed identity: `ForEach(Array(x.enumerated()), id: \.offset)`
            // rebuilds the (offset, element) tuple every render → unstable view
            // identity on Swift 5.5 / Big Sur → EXC_BAD_ACCESS in objc_release
            // on teardown. Subscript a stable array via its indices instead.
            let options = q.question.options ?? []
            ForEach(options.indices, id: \.self) { idx in
                optionRow(options[idx], question: q)
            }
        }
    }

    private func optionRow(_ option: String, question: AssessmentQuestion) -> some View {
        let isAnswer = AnswerValidator.matches(userInput: option, truth: question.question.answer)
        return MCQOptionRow(
            option: option, isAnswer: isAnswer, isSelected: selected == option,
            revealed: revealed, onTap: { if !revealed { selected = option } })
    }

    private func feedbackBlock(_ q: AssessmentQuestion) -> some View {
        MCQFeedbackBlock(
            wasCorrect: correctById[q.id] ?? false,
            answer: q.question.answer,
            firstStep: q.question.solutionSteps.first)
    }

    private func actionRow(_ assessment: MilestoneAssessment, question: AssessmentQuestion) -> some View {
        HStack {
            Spacer(minLength: 0)
            if revealed {
                primaryButton(index + 1 < assessment.count ? "Next question" : "See results") {
                    advance(in: assessment)
                }
            } else {
                primaryButton("Check answer", enabled: selected != nil) { check() }
            }
        }
    }

    // MARK: - Result

    private func resultSection(_ assessment: MilestoneAssessment) -> some View {
        // `result` is set when the quiz completes; the fallback keeps the body
        // total in the (defensive) case it's reached without one.
        let r = result ?? MilestoneCheckpointResult.from(
            assessment: assessment, correctById: correctById, takenAt: Date())
        return VStack(alignment: .leading, spacing: DesignTokens.Spacing.lg) {
            scoreCard(r)
            breakdownSection(r)
            resultActions()
        }
    }

    private func scoreCard(_ r: MilestoneCheckpointResult) -> some View {
        let fraction = r.scoreFraction
        return VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
            HStack(spacing: DesignTokens.Spacing.md) {
                Text(resultEmoji(fraction)).font(.system(size: 34)).accessibilityHidden(true)
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.xxs) {
                    Text("You got \(r.correctCount) of \(r.totalQuestions)")
                        .font(.title2.weight(.bold))
                        .foregroundColor(DesignTokens.BrandColor.canvasText)
                    Text(resultMessage(fraction))
                        .font(.callout)
                        .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer(minLength: 0)
            }
            ScoreBar(fraction: fraction, tint: DesignTokens.BrandColor.primaryAction)
        }
        .padding(DesignTokens.Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: DesignTokens.Radius.card)
                .fill(DesignTokens.BrandColor.primaryAction.opacity(0.08))
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("You got \(r.correctCount) of \(r.totalQuestions). \(resultMessage(fraction))")
    }

    private func breakdownSection(_ r: MilestoneCheckpointResult) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("By subject")
                .font(.headline)
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            ForEach(r.perSubject, id: \.packId) { row in
                breakdownRow(row)
            }
        }
    }

    private func breakdownRow(_ row: MilestoneSubjectScore) -> some View {
        HStack(spacing: DesignTokens.Spacing.sm) {
            Text(emoji(for: row.packId)).font(.system(size: 20)).accessibilityHidden(true)
            Text(row.subjectTitle)
                .font(.callout.weight(.semibold))
                .foregroundColor(DesignTokens.BrandColor.canvasText)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            Spacer(minLength: 0)
            Text("\(row.correct) / \(row.total)")
                .font(.callout.monospacedDigit())
                .foregroundColor(row.correct == row.total
                                 ? DesignTokens.BrandColor.success
                                 : DesignTokens.BrandColor.canvasText)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
                .fill(Color.gray.opacity(0.05))
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(row.subjectTitle): \(row.correct) of \(row.total) correct.")
    }

    private func resultActions() -> some View {
        HStack(spacing: DesignTokens.Spacing.md) {
            primaryButton("Take another") { retake() }
            secondaryButton("Done") { NSApp.keyWindow?.performClose(nil) }
            Spacer(minLength: 0)
        }
    }

    // MARK: - Empty state

    private var emptyState: some View {
        VStack(spacing: DesignTokens.Spacing.md) {
            Text("🌱").font(.system(size: 48)).accessibilityHidden(true)
            Text("A little practice first")
                .font(.title2.weight(.bold))
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            Text("Answer some multiple-choice questions in any subject, then come back — your checkpoint is built from what you've practised, focused on what needs the most attention.")
                .font(.callout)
                .multilineTextAlignment(.center)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .padding(.horizontal, 20)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("A little practice first. Answer some multiple-choice questions in any subject, then come back for your checkpoint.")
    }

    // MARK: - Reusable buttons

    private func primaryButton(_ title: String, enabled: Bool = true, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal, 18)
                .padding(.vertical, 10)
                .frame(minHeight: 44)
                .background(Capsule().fill(
                    enabled ? DesignTokens.BrandColor.primaryAction
                            : DesignTokens.BrandColor.mutedSurface))
        }
        .buttonStyle(.plain)
        .disabled(!enabled)
        .accessibilityLabel(title)
    }

    private func secondaryButton(_ title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(DesignTokens.BrandColor.primaryAction)
                .padding(.horizontal, 18)
                .padding(.vertical, 10)
                .frame(minHeight: 44)
                .background(
                    Capsule().stroke(DesignTokens.BrandColor.primaryAction, lineWidth: 1.5))
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
    }

    // MARK: - Result helpers

    private func resultEmoji(_ fraction: Double) -> String {
        if fraction >= 0.8 { return "🌟" }
        if fraction >= 0.5 { return "👍" }
        return "💪"
    }

    private func resultMessage(_ fraction: Double) -> String {
        if fraction >= 0.8 { return "Brilliant — you've got a strong grip on this. Keep it up!" }
        if fraction >= 0.5 { return "Solid work. A little more practice on the misses and you'll be flying." }
        return "Every checkpoint shows you where to aim next — let's practise the tricky ones together."
    }

    private func emoji(for packId: String) -> String {
        registry.pack(withId: packId)?.coverEmoji ?? "•"
    }
}

// MARK: - ScoreBar
//
// A static horizontal bar (muted track + tinted fill sized to `fraction`). No
// animation — width is set directly, costing the legacy GPU nothing and
// unaffected by Reduce Motion. Accessibility-hidden; the score card speaks it.
private struct ScoreBar: View {
    let fraction: Double
    let tint: Color

    var body: some View {
        GeometryReader { geo in
            let clampedFraction: CGFloat = max(0, min(1, fraction))
            let fillW: CGFloat = clampedFraction * geo.size.width
            ZStack(alignment: .leading) {
                Capsule().fill(DesignTokens.BrandColor.mutedSurface.opacity(0.5))
                Capsule().fill(tint)
                    .frame(width: fillW)
            }
        }
        .frame(height: 12)
        .accessibilityHidden(true)
    }
}
