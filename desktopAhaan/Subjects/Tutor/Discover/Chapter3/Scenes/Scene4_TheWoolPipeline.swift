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
                    .foregroundColor(Color.compatIndigo)
                Spacer()
                if tappedSteps.count == 6 {
                    Label("Complete!", systemImage: "checkmark.circle.fill")
                        .font(.caption)
                        .foregroundColor(.green)
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
                                .foregroundColor(.gray.opacity(0.5))
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
            .background(Color(NSColor.controlBackgroundColor).opacity(0.5))
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
                                    .foregroundColor(Color.compatIndigo)
                                Text("Step \(selected + 1) of 6")
                                    .font(.caption)
                                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                            }
                        }
                        Divider()
                        Text(steps[selected].desc)
                            .font(.body)
                            .foregroundColor(DesignTokens.BrandColor.canvasText)
                    }
                }
                .frame(maxWidth: 600)
                .padding(.horizontal, 24)
                .transition(.opacity.combined(with: .scale))
            }

            LookingAheadCallout(
                title: "Class 11 Chemistry → JEE (Industrial Chemistry)",
                detail: "The wool pipeline you just walked is one example of unit operations — scouring, sorting, dyeing, spinning, weaving. JEE Chem teaches the same operations for industrial fibres: PET bottles ground → polymer chips → extruded as polyester thread → woven into fabric. Different chemistry, same pipeline shape."
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            TryAtHomeCallout(
                title: "Trace a t-shirt's journey",
                detail: "Pick any cotton t-shirt. Read the label: cotton from (country), made in (country), sold in (your city). That's 3-4 stops of the same pipeline. A typical t-shirt has travelled 15,000+ km from seed to your dresser. Map it on Google Earth for one shirt — it's a lesson in global supply chains."
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

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
                        .foregroundColor(DesignTokens.BrandColor.canvasText)
                }
                .frame(maxWidth: .infinity)
                .padding(16)
                .background(isTapped ? Color.compatIndigo.opacity(0.15) : Color.white.opacity(0.95))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(isTapped ? Color.compatIndigo : Color.clear, lineWidth: 2)
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
