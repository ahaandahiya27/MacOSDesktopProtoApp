import SwiftUI
import AppKit

/// v6 Learning Journey · Phase 5. The **Expert Challenges** ladder — per subject,
/// escalating tiers (Stretch → Challenge → Olympiad) of the hardest questions,
/// each UNLOCKED once the subject reaches a mastery threshold (see
/// `ExpertChallengeLadder` / `DataStore.buildExpertChallengeLadder`). Tapping a
/// playable tier runs a short multiple-choice challenge using the shared
/// `MCQOptionRow` / `MCQFeedbackBlock` (same UX as the Milestone Checkpoint).
///
/// A practice surface: scoring is local (`AnswerValidator`) and it NEVER writes
/// the SRS — the same read-only stance as the ladder it reads. Only tiers that
/// actually have authored questions are shown, so the (currently unauthored)
/// Olympiad tier simply doesn't appear until its deepDive content lands.
///
/// Presented in its own AppKit window via Help → Expert Challenges (⌘⇧E).
/// `@MainActor` because it reads `DataStore` synchronously in `onAppear`. Static
/// styling only — costs the legacy GPU nothing; transitions go through
/// `withAnimationRespectingReduceMotion`.
@MainActor
struct ExpertChallengeLadderView: View {
    @EnvironmentObject var dataStore: DataStore
    @EnvironmentObject var registry: SubjectRegistry

    private enum Phase: Equatable { case ladder, playing, result }

    @State private var ladder: ExpertChallengeLadder?
    @State private var phase: Phase = .ladder
    @State private var activeQuestions: [AssessmentQuestion] = []
    @State private var activeTitle = ""
    @State private var index = 0
    @State private var selected: String?
    @State private var revealed = false
    @State private var correctById: [String: Bool] = [:]

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
        .navigationTitle("Expert Challenges")
    }

    // MARK: - Phase routing

    @ViewBuilder
    private var content: some View {
        if let ladder = ladder {
            switch phase {
            case .ladder:  ladderContent(ladder)
            case .playing: playingSection()
            case .result:  resultSection()
            }
        } else {
            ProgressView("Loading challenges…")
                .padding(.vertical, 40)
                .frame(maxWidth: .infinity)
        }
    }

    private func buildIfNeeded() {
        guard ladder == nil else { return }
        ladder = dataStore.buildExpertChallengeLadder(registry: registry)
    }

    // MARK: - Header

    private var header: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
            HStack(spacing: 10) {
                Text("🏆").font(.system(size: 34)).accessibilityHidden(true)
                Text("Expert Challenges")
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
            }
            Text("Climb each subject's ladder — tougher tiers unlock as you master it.")
                .font(.subheadline)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Expert Challenges. Climb each subject's ladder — tougher tiers unlock as you master it.")
    }

    // MARK: - Ladder

    @ViewBuilder
    private func ladderContent(_ ladder: ExpertChallengeLadder) -> some View {
        if ladder.subjectsWithContent.isEmpty {
            emptyState
        } else {
            ForEach(ladder.subjectsWithContent) { subject in
                subjectCard(subject)
            }
        }
    }

    private func subjectCard(_ subject: SubjectChallengeLadder) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: DesignTokens.Spacing.sm) {
                Text(emoji(for: subject.packId)).font(.system(size: 22)).accessibilityHidden(true)
                Text(subject.subjectTitle)
                    .font(.headline)
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .lineLimit(1).minimumScaleFactor(0.8)
                Spacer(minLength: 0)
                levelChip(MasteryEngine.level(forFraction: subject.masteryFraction))
            }
            // Only tiers that actually have authored questions are shown.
            ForEach(subject.tiers.filter { $0.count > 0 }, id: \.tier) { set in
                tierRow(set, subjectTitle: subject.subjectTitle)
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: DesignTokens.Radius.card)
                .fill(DesignTokens.BrandColor.primaryAction.opacity(0.05))
        )
    }

    private func tierRow(_ set: ExpertTierSet, subjectTitle: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Text(set.isUnlocked ? "⭐️" : "🔒").font(.system(size: 18)).accessibilityHidden(true)
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.xxs) {
                Text("\(set.tier.title) · \(set.count) question\(set.count == 1 ? "" : "s")")
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                Text(set.isUnlocked ? set.tier.blurb
                                    : "Reach \(set.tier.unlockLevelName) in this subject to unlock.")
                    .font(.caption)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer(minLength: 0)
            if set.isPlayable {
                startButton(set, subjectTitle: subjectTitle)
            }
        }
        .padding(.horizontal, DesignTokens.Spacing.md)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
                .fill(set.isUnlocked ? DesignTokens.BrandColor.success.opacity(0.06)
                                     : Color.gray.opacity(0.05))
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel(tierAccessibilityLabel(set))
    }

    private func tierAccessibilityLabel(_ set: ExpertTierSet) -> String {
        if set.isUnlocked {
            return "\(set.tier.title), \(set.count) questions, unlocked. \(set.tier.blurb)"
        }
        return "\(set.tier.title), \(set.count) questions, locked. Reach \(set.tier.unlockLevelName) to unlock."
    }

    private func startButton(_ set: ExpertTierSet, subjectTitle: String) -> some View {
        Button(action: { begin(set, subjectTitle: subjectTitle) }) {
            Text("Start")
                .font(.subheadline.weight(.semibold))
                .foregroundColor(.white)
                .padding(.horizontal, DesignTokens.Spacing.lg)
                .padding(.vertical, DesignTokens.Spacing.sm)
                .frame(minHeight: 44)
                .background(Capsule().fill(DesignTokens.BrandColor.primaryAction))
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Start the \(set.tier.title) challenge for \(subjectTitle)")
        .accessibilityHint("Begins this expert challenge tier with multiple choice questions")
    }

    // MARK: - Flow control

    private func begin(_ set: ExpertTierSet, subjectTitle: String) {
        activeQuestions = set.questions
        activeTitle = "\(subjectTitle) · \(set.tier.title)"
        index = 0; selected = nil; revealed = false; correctById = [:]
        withAnimationRespectingReduceMotion(.easeInOut(duration: 0.2)) { phase = .playing }
    }

    private func check() {
        guard let q = currentQuestion, let sel = selected, !revealed else { return }
        correctById[q.id] = AnswerValidator.matches(userInput: sel, truth: q.question.answer)
        withAnimationRespectingReduceMotion(.easeInOut(duration: 0.2)) { revealed = true }
    }

    private func advance() {
        if index + 1 < activeQuestions.count {
            index += 1; selected = nil; revealed = false
        } else {
            withAnimationRespectingReduceMotion(.easeInOut(duration: 0.2)) { phase = .result }
        }
    }

    private func backToLadder() {
        withAnimationRespectingReduceMotion(.easeInOut(duration: 0.2)) { phase = .ladder }
    }

    private func retry() {
        index = 0; selected = nil; revealed = false; correctById = [:]
        withAnimationRespectingReduceMotion(.easeInOut(duration: 0.2)) { phase = .playing }
    }

    private var currentQuestion: AssessmentQuestion? {
        guard index >= 0, index < activeQuestions.count else { return nil }
        return activeQuestions[index]
    }

    private var score: Int { correctById.values.filter { $0 }.count }

    // MARK: - Playing

    @ViewBuilder
    private func playingSection() -> some View {
        if let q = currentQuestion {
            VStack(alignment: .leading, spacing: 14) {
                HStack(spacing: DesignTokens.Spacing.sm) {
                    Text(activeTitle)
                        .font(.caption.weight(.semibold))
                        .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                        .lineLimit(1).minimumScaleFactor(0.8)
                    Spacer(minLength: 0)
                    Text("Question \(index + 1) of \(activeQuestions.count)")
                        .font(.caption.monospacedDigit())
                        .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel("\(activeTitle). Question \(index + 1) of \(activeQuestions.count).")

                Text(q.question.prompt)
                    .font(.title3.weight(.semibold))
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .fixedSize(horizontal: false, vertical: true)

                // Index-keyed identity: `ForEach(Array(x.enumerated()), id: \.offset)`
                // rebuilds the (offset, element) tuple every render → unstable view
                // identity on Swift 5.5 / Big Sur → EXC_BAD_ACCESS in objc_release
                // on teardown. Subscript a stable array via its indices instead.
                let options = q.question.options ?? []
                ForEach(options.indices, id: \.self) { idx in
                    let option = options[idx]
                    MCQOptionRow(
                        option: option,
                        isAnswer: AnswerValidator.matches(userInput: option, truth: q.question.answer),
                        isSelected: selected == option, revealed: revealed,
                        onTap: { if !revealed { selected = option } })
                }

                if revealed {
                    MCQFeedbackBlock(wasCorrect: correctById[q.id] ?? false,
                                     answer: q.question.answer,
                                     firstStep: q.question.solutionSteps.first)
                }

                HStack {
                    Spacer(minLength: 0)
                    if revealed {
                        pillButton(index + 1 < activeQuestions.count ? "Next question" : "See results",
                                   filled: true) { advance() }
                    } else {
                        pillButton("Check answer", filled: true, enabled: selected != nil) { check() }
                    }
                }
            }
            .padding(DesignTokens.Spacing.lg)
            .background(
                RoundedRectangle(cornerRadius: DesignTokens.Radius.card)
                    .fill(DesignTokens.BrandColor.primaryAction.opacity(0.05))
            )
        } else {
            Color.clear.frame(height: 1).onAppear { phase = .result }
        }
    }

    // MARK: - Result

    private func resultSection() -> some View {
        let total = activeQuestions.count
        let fraction = total > 0 ? Double(score) / Double(total) : 0
        return VStack(alignment: .leading, spacing: DesignTokens.Spacing.lg) {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
                HStack(spacing: DesignTokens.Spacing.md) {
                    Text(resultEmoji(fraction)).font(.system(size: 34)).accessibilityHidden(true)
                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.xxs) {
                        Text("You got \(score) of \(total)")
                            .font(.title2.weight(.bold))
                            .foregroundColor(DesignTokens.BrandColor.canvasText)
                        Text(activeTitle)
                            .font(.callout)
                            .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    }
                    Spacer(minLength: 0)
                }
                Text(resultMessage(fraction))
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(DesignTokens.Spacing.lg)
            .background(
                RoundedRectangle(cornerRadius: DesignTokens.Radius.card)
                    .fill(DesignTokens.BrandColor.primaryAction.opacity(0.08))
            )
            .accessibilityElement(children: .combine)
            .accessibilityLabel("You got \(score) of \(total) on \(activeTitle). \(resultMessage(fraction))")

            HStack(spacing: DesignTokens.Spacing.md) {
                pillButton("Try again", filled: true) { retry() }
                pillButton("Back to challenges", filled: false) { backToLadder() }
                Spacer(minLength: 0)
            }
        }
    }

    // MARK: - Empty state

    private var emptyState: some View {
        VStack(spacing: DesignTokens.Spacing.md) {
            Text("🧗").font(.system(size: 48)).accessibilityHidden(true)
            Text("Challenges are warming up")
                .font(.title2.weight(.bold))
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            Text("Keep practising — expert tiers unlock as you grow more confident in each subject, and the toughest challenges appear here.")
                .font(.callout)
                .multilineTextAlignment(.center)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .padding(.horizontal, 20)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Challenges are warming up. Expert tiers unlock as you grow more confident in each subject.")
    }

    // MARK: - Reusable pieces

    private func pillButton(_ title: String, filled: Bool, enabled: Bool = true,
                            action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(filled ? .white : DesignTokens.BrandColor.primaryAction)
                .padding(.horizontal, 18)
                .padding(.vertical, 10)
                .frame(minHeight: 44)
                .background(pillBackground(filled: filled, enabled: enabled))
        }
        .buttonStyle(.plain)
        .disabled(!enabled)
        .accessibilityLabel(title)
    }

    @ViewBuilder
    private func pillBackground(filled: Bool, enabled: Bool) -> some View {
        if filled {
            Capsule().fill(enabled ? DesignTokens.BrandColor.primaryAction
                                   : DesignTokens.BrandColor.mutedSurface)
        } else {
            Capsule().stroke(DesignTokens.BrandColor.primaryAction, lineWidth: 1.5)
        }
    }

    private func levelChip(_ level: MasteryLevel) -> some View {
        Text(level.displayName)
            .font(.caption.weight(.bold))
            .foregroundColor(.white)
            .padding(.horizontal, 9)
            .padding(.vertical, 3)
            .background(Capsule().fill(level.tint))
            .accessibilityHidden(true)
    }

    private func resultEmoji(_ fraction: Double) -> String {
        if fraction >= 0.8 { return "🏆" }
        if fraction >= 0.5 { return "👍" }
        return "💪"
    }

    private func resultMessage(_ fraction: Double) -> String {
        if fraction >= 0.8 { return "Outstanding — that's expert-level work!" }
        if fraction >= 0.5 { return "Strong effort on a tough tier. Review the misses and try again." }
        return "These are the hard ones — every attempt makes the next one easier."
    }

    private func emoji(for packId: String) -> String {
        registry.pack(withId: packId)?.coverEmoji ?? "•"
    }
}
