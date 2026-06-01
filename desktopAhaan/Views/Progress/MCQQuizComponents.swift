import SwiftUI

// MARK: - Shared MCQ quiz components
//
// v6 Learning Journey · Phase 5 M2. The stateless, reusable pieces of a
// single-tap multiple-choice quiz, shared by the Milestone Checkpoint and the
// Expert Challenge ladder so both render an option / its feedback identically.
// Pure presentation — the owning view holds the quiz state and decides
// correctness (via `AnswerValidator`); these just draw.
//
// Big Sur safe: DesignTokens colours, emoji/glyph marks (SF-Symbol-free), no
// macOS 12+ APIs, ≥44pt tap targets, explicit a11y labels.

/// One tappable answer option. `isAnswer` marks the correct option; `revealed`
/// switches from selection styling to graded styling. Disabled once revealed.
struct MCQOptionRow: View {
    let option: String
    let isAnswer: Bool
    let isSelected: Bool
    let revealed: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 10) {
                Text(option)
                    .font(.body)
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.leading)
                Spacer(minLength: 0)
                mark
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 11)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(minHeight: 44)
            .background(
                RoundedRectangle(cornerRadius: DesignTokens.cornerRadiusMedium)
                    .fill(fill)
            )
            .overlay(
                RoundedRectangle(cornerRadius: DesignTokens.cornerRadiusMedium)
                    .stroke(stroke, lineWidth: 1.5)
            )
        }
        .buttonStyle(.plain)
        .disabled(revealed)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    @ViewBuilder
    private var mark: some View {
        if revealed && isAnswer {
            Text("✓").font(.headline.weight(.bold))
                .foregroundColor(DesignTokens.BrandColor.success).accessibilityHidden(true)
        } else if revealed && isSelected {
            Text("✗").font(.headline.weight(.bold))
                .foregroundColor(DesignTokens.BrandColor.danger).accessibilityHidden(true)
        } else if isSelected {
            Text("●").font(.headline)
                .foregroundColor(DesignTokens.BrandColor.primaryAction).accessibilityHidden(true)
        } else {
            Text("○").font(.headline)
                .foregroundColor(DesignTokens.BrandColor.mutedSurface).accessibilityHidden(true)
        }
    }

    private var fill: Color {
        if revealed && isAnswer { return DesignTokens.BrandColor.success.opacity(0.14) }
        if revealed && isSelected { return DesignTokens.BrandColor.danger.opacity(0.12) }
        if isSelected { return DesignTokens.BrandColor.primaryAction.opacity(0.10) }
        return Color.gray.opacity(0.05)
    }

    private var stroke: Color {
        if revealed && isAnswer { return DesignTokens.BrandColor.success }
        if revealed && isSelected { return DesignTokens.BrandColor.danger }
        if isSelected { return DesignTokens.BrandColor.primaryAction }
        return DesignTokens.BrandColor.dividerLine
    }

    private var accessibilityLabel: String {
        var label = option
        if revealed && isAnswer { label += ", correct answer" }
        else if revealed && isSelected { label += ", your answer, incorrect" }
        else if isSelected { label += ", selected" }
        return label
    }
}

/// The post-answer feedback: correct/incorrect headline + the first solution
/// step when available. `answer` is shown only when the kid got it wrong.
struct MCQFeedbackBlock: View {
    let wasCorrect: Bool
    let answer: String
    let firstStep: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(wasCorrect ? "✅ Correct!" : "❌ Not quite — the answer is “\(answer)”.")
                .font(.callout.weight(.semibold))
                .foregroundColor(wasCorrect ? DesignTokens.BrandColor.success : DesignTokens.BrandColor.danger)
                .fixedSize(horizontal: false, vertical: true)
            if let step = firstStep, !step.isEmpty {
                Text(step)
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: DesignTokens.cornerRadiusMedium)
                .fill((wasCorrect ? DesignTokens.BrandColor.success : DesignTokens.BrandColor.danger).opacity(0.08))
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel(wasCorrect
            ? "Correct. \(firstStep ?? "")"
            : "Not quite. The answer is \(answer). \(firstStep ?? "")")
    }
}
