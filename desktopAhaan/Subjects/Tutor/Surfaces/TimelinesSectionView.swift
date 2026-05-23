import SwiftUI
import AppKit

// MARK: - TimelinesSectionView
//
// Surfaces `chapter.timelines: [ContentTimeline]?` on the chapter
// detail page for process-sequence chapters (photosynthesis, water
// cycle, digestion, mitosis). Each timeline renders as a horizontally
// scrolling row of numbered step cards.
//
// Auto-hides when the chapter has no timelines authored. Single-row
// layout — bigger timeline content would warrant a separate sheet.

struct TimelinesSectionView: View {
    let chapter: Chapter

    private var timelines: [ContentTimeline] { chapter.timelinesList }

    var body: some View {
        if !timelines.isEmpty {
            VStack(alignment: .leading, spacing: 14) {
                ForEach(timelines) { timeline in
                    TimelineRow(timeline: timeline)
                }
            }
        }
    }
}

// MARK: - TimelineRow

private struct TimelineRow: View {
    let timeline: ContentTimeline

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: SFSymbolCompat.name("arrow.triangle.branch"))
                    .font(.title3)
                    .foregroundColor(Color.compatCyan)
                    .accessibilityHidden(true)
                Text(timeline.title)
                    .font(.headline)
                    .accessibilityAddTraits(.isHeader)
                Spacer()
            }
            if let intro = timeline.intro, !intro.isEmpty {
                Text(intro)
                    .font(.callout)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 14) {
                    // Big Sur SwiftUI fragility: `Array(x.enumerated())`
                    // with a tuple-keypath id rebuilds on every render.
                    // Index into `timeline.steps` directly instead.
                    ForEach(timeline.steps.indices, id: \.self) { idx in
                        TimelineStepCard(index: idx + 1, step: timeline.steps[idx])
                    }
                }
                .padding(.vertical, 6)
                .padding(.horizontal, 2)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.compatCyan.opacity(0.06))
        )
        .accessibilityElement(children: .contain)
        .accessibilityLabel("\(timeline.title), \(timeline.steps.count) steps")
    }
}

// MARK: - TimelineStepCard

private struct TimelineStepCard: View {
    let index: Int
    let step: TimelineStep

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                ZStack {
                    Circle()
                        .fill(Color.compatCyan)
                        .frame(width: 22, height: 22)
                    Text("\(index)")
                        .font(.caption.weight(.bold))
                        .foregroundColor(.white)
                }
                .accessibilityHidden(true)
                Text(step.label)
                    .font(.callout.weight(.semibold))
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            stepCaption
        }
        .frame(width: 180, alignment: .leading)
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(NSColor.controlBackgroundColor))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(Color.compatCyan.opacity(0.3), lineWidth: 1)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Step \(index): \(step.label). \(step.body)")
    }

    @ViewBuilder
    private var stepCaption: some View {
        if !step.body.isEmpty {
            Text(step.body)
                .font(.caption)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
