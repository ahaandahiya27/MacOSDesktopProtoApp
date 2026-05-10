import SwiftUI

/// Scene 4 — The Wool Pipeline.
///
/// 6 hexagonal nodes connected by arrows: Shearing → Scouring → Sorting → Carding → Spinning → Weaving.
/// Each node is tappable; tapping shows a step description. After all 6 are tapped, a sweater ✅ appears.
struct Scene4_TheWoolPipeline: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var tappedSteps: Set<Int> = []
    @State private var selectedStep: Int? = nil
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let steps = [
        PipelineStep(emoji: "✂️", label: "Shearing", desc: "Fleece is carefully cut from the sheep using clippers."),
        PipelineStep(emoji: "🛁", label: "Scouring", desc: "The fleece is washed in warm water to remove dirt and grease."),
        PipelineStep(emoji: "🧺", label: "Sorting", desc: "Clean wool is sorted by quality, length, and color."),
        PipelineStep(emoji: "🪮", label: "Carding", desc: "Fibres are combed with fine-toothed rollers to align them."),
        PipelineStep(emoji: "🌀", label: "Spinning", desc: "Aligned fibres are twisted together to create strong yarn."),
        PipelineStep(emoji: "🧶", label: "Weaving", desc: "Yarn is woven on a loom to create the final fabric.")
    ]

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("The Wool Pipeline")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.indigo)
                Spacer()
                if tappedSteps.count == 6 {
                    Label("Complete!", systemImage: "checkmark.circle.fill")
                        .font(.caption)
                        .foregroundStyle(.green)
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 20)

            // Pipeline visualization
            VStack(spacing: 24) {
                // Row 1
                HStack(spacing: 20) {
                    ForEach(0..<3, id: \.self) { i in
                        pipelineNode(steps[i], index: i)
                    }
                }

                // Arrows down
                HStack(spacing: 20) {
                    ForEach(0..<3, id: \.self) { _ in
                        VStack(spacing: 4) {
                            Image(systemName: "arrow.down")
                                .font(.body.weight(.semibold))
                                .foregroundStyle(.gray.opacity(0.5))
                        }
                        .frame(maxWidth: .infinity)
                    }
                }

                // Row 2
                HStack(spacing: 20) {
                    ForEach(3..<6, id: \.self) { i in
                        pipelineNode(steps[i], index: i)
                    }
                }
            }
            .padding(24)
            .background(.white.opacity(0.5))
            .cornerRadius(12)
            .padding(.horizontal, 24)

            // Description panel
            if let selected = selectedStep {
                SoftShadowCard(padding: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(steps[selected].emoji)
                                .font(.system(size: 32))
                            VStack(alignment: .leading) {
                                Text(steps[selected].label)
                                    .font(.headline)
                                    .foregroundStyle(.indigo)
                                Text("Step \(selected + 1) of 6")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        Divider()
                        Text(steps[selected].desc)
                            .font(.body)
                            .foregroundStyle(.primary)
                    }
                }
                .frame(maxWidth: 600)
                .padding(.horizontal, 24)
                .transition(.opacity.combined(with: .scale))
            }

            Spacer()

            GotItButton {
                onComplete()
            }
            .padding(.bottom, 20)
        }
    }

    @ViewBuilder
    private func pipelineNode(_ step: PipelineStep, index: Int) -> some View {
        let isTapped = tappedSteps.contains(index)
        VStack {
            Button {
                withAnimation(reduceMotion ? .none : .spring(response: 0.3, dampingFraction: 0.6)) {
                    tappedSteps.insert(index)
                    selectedStep = index
                }
            } label: {
                VStack(spacing: 8) {
                    Text(step.emoji)
                        .font(.system(size: 40))
                    Text(step.label)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.primary)
                }
                .frame(maxWidth: .infinity)
                .padding(16)
                .background(isTapped ? Color.indigo.opacity(0.15) : Color.gray.opacity(0.05))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(isTapped ? Color.indigo : Color.clear, lineWidth: 2)
                )
            }
            .buttonStyle(.plain)
            .accessibilityLabel(step.label)
        }
    }
}

private struct PipelineStep {
    let emoji: String
    let label: String
    let desc: String
}
