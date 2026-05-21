import SwiftUI

/// Vertical step-by-step process visualisation (G12 in the issue
/// taxonomy / M9 module type). Renders an ordered list of stages with
/// numbered dots, a connecting line down the left edge, and per-step
/// title + one-line caption.
///
/// Pattern:
///
///     ProcessTimeline(
///         title: "How a seed becomes a plant",
///         steps: [
///             .init(title: "Seed soaked",
///                   detail: "Water swells the seed coat. Enzymes wake up."),
///             .init(title: "Radicle emerges",
///                   detail: "The first root pushes down, anchoring the seedling."),
///             .init(title: "Shoot breaks ground",
///                   detail: "The stem rises toward light; cotyledons spread."),
///             .init(title: "True leaves form",
///                   detail: "Photosynthesis starts; the plant feeds itself.")
///         ]
///     )
///
/// Designed for digestion, water cycles, life cycles, electric-current
/// flow — anywhere a kid benefits from "step → step → step" rather than
/// a paragraph.
///
/// macOS 11 (Big Sur) compatible — Path + ZStack only, no Canvas, no
/// macOS 12 APIs. Each ViewBuilder closure ≤10 children honoured by
/// extracting the per-row layout into `StepRow`.
struct ProcessTimeline: View {
    let title: String
    let steps: [Step]
    /// Accent colour for the connecting line + numbered dots. Defaults
    /// to the global indigo brand colour; individual scenes can pass
    /// their chapter theme via `ChapterTheme.accent(for:)`.
    let accent: Color

    struct Step {
        let title: String
        let detail: String
    }

    init(title: String, steps: [Step], accent: Color = .compatIndigo) {
        self.title = title
        self.steps = steps
        self.accent = accent
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            header
            stepsList
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(accent.opacity(0.06))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(accent.opacity(0.30), lineWidth: 1)
        )
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Process timeline: \(title), \(steps.count) steps.")
    }

    private var header: some View {
        HStack(spacing: 8) {
            Image(systemName: "arrow.down.circle.fill")
                .font(.title3)
                .foregroundColor(accent)
                .accessibilityHidden(true)
            Text(title)
                .font(.headline)
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            Spacer(minLength: 0)
        }
    }

    private var stepsList: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(steps.indices, id: \.self) { index in let step = steps[index];
                StepRow(
                    index: index,
                    total: steps.count,
                    step: step,
                    accent: accent
                )
            }
        }
        .padding(.leading, 2)
    }
}

/// Per-step row. Number bubble + vertical connector + title + detail.
/// Extracted out of `ProcessTimeline.body` to keep that ViewBuilder
/// closure within Swift 5.5's 10-child limit.
private struct StepRow: View {
    let index: Int
    let total: Int
    let step: ProcessTimeline.Step
    let accent: Color

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            bubbleColumn
            VStack(alignment: .leading, spacing: 3) {
                Text(step.title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                Text(step.detail)
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    .lineSpacing(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.bottom, isLast ? 0 : 10)
            Spacer(minLength: 0)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Step \(index + 1) of \(total). \(step.title). \(step.detail)")
    }

    private var isLast: Bool { index == total - 1 }

    private var bubbleColumn: some View {
        VStack(spacing: 0) {
            ZStack {
                Circle()
                    .fill(accent)
                    .frame(width: 22, height: 22)
                Text("\(index + 1)")
                    .font(.caption2.weight(.bold))
                    .foregroundColor(.white)
            }
            if !isLast {
                Rectangle()
                    .fill(accent.opacity(0.30))
                    .frame(width: 2)
                    .frame(maxHeight: .infinity)
                    .padding(.vertical, 2)
            }
        }
        .frame(width: 22)
    }
}
