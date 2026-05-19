import SwiftUI

/// Scene 6 — Silkworm Life Cycle.
///
/// 4 stages in a circular cycle: Egg → Larva → Pupa → Moth → back to egg.
/// Tap each stage to advance. Timer next to each shows duration.
/// Big Sur (macOS 11) compatible — Canvas-based arrow ring replaced with
/// a SilkwormCycleArrowsShape so the scene renders on macOS 11.
struct Scene6_SilkwormLifeCycle: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var currentStage: Int = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let stages = [
        LifeStage(emoji: "🥚", name: "Egg", duration: "10 days", desc: "Tiny eggs, stored on cloth"),
        LifeStage(emoji: "🐛", name: "Larva", duration: "25 days", desc: "Silkworm eats mulberry leaves"),
        LifeStage(emoji: "🛏", name: "Pupa", duration: "12 days", desc: "Inside the cocoon, transforming"),
        LifeStage(emoji: "🦋", name: "Moth", duration: "5-7 days", desc: "Adult moth lays eggs, then dies")
    ]

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                HStack {
                    Text("Silkworm Life Cycle")
                        .font(.largeTitle.bold())
                        .foregroundColor(Color.compatIndigo)
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)

                // Circular cycle
                ZStack {
                    Circle()
                        .stroke(Color.compatIndigo.opacity(0.2), lineWidth: 2)
                        .padding(40)

                    // Arrows between stages (Shape, was Canvas)
                    SilkwormCycleArrowsShape()
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1.5)

                    // Stage nodes
                    ForEach(0..<4, id: \.self) { i in
                        stageNode(stages[i], index: i)
                    }
                }
                .frame(height: 320)
                .padding(.horizontal, 24)

                // Detail panel
                VStack(spacing: 12) {
                    HStack(spacing: 12) {
                        Text(stages[currentStage].emoji)
                            .font(.system(size: 48))
                        VStack(alignment: .leading, spacing: 4) {
                            Text(stages[currentStage].name)
                                .font(.headline)
                                .foregroundColor(Color.compatIndigo)
                            Text(stages[currentStage].duration)
                                .font(.caption.weight(.semibold))
                                .foregroundColor(.green)
                        }
                    }
                    Divider()
                    Text(stages[currentStage].desc)
                        .font(.body)
                        .foregroundColor(DesignTokens.BrandColor.canvasText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(16)
                .background(Color(NSColor.controlBackgroundColor).opacity(0.5))
                .cornerRadius(12)
                .padding(.horizontal, 24)

                HStack(spacing: 12) {
                    Button {
                        advanceStage()
                    } label: {
                        Label("Next Stage", systemImage: "arrow.right.circle")
                    }

                    .accentColor(Color.compatIndigo)

                    if currentStage > 0 {
                        Button {
                            previousStage()
                        } label: {
                            Label("Previous", systemImage: "arrow.left.circle")
                        }

                    }
                }
                .padding(.horizontal, 24)

                LookingAheadCallout(
                    title: "Class 11 Biology → NEET (Holometabola)",
                    detail: "Complete metamorphosis (egg → larva → pupa → adult) is called *holometaboly*. NEET asks 'why do butterflies and beetles develop this way?' — because larva and adult eat different food sources (caterpillar eats leaves, butterfly drinks nectar), so they don't compete. Same trick: silkworm caterpillar eats mulberry; the moth doesn't eat at all — it lives just to mate."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)

                TryAtHomeCallout(
                    title: "Find a real silkworm",
                    detail: "If you're in southern India or West Bengal, sericulture farms (Karnataka in particular) sell raw silkworm cocoons. Or visit a Khadi shop — they often display caterpillars, cocoons, and reeled silk side-by-side. Watching one cocoon unwind into 1,000+ metres of single continuous thread is a wow moment."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)

                GotItButton {
                    onComplete()
                }
                .padding(.bottom, 12)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
        }
    }

    private func stageNodePosition(index: Int) -> CGPoint {
        let angle: Double = Double(index) * (.pi * 2.0 / 4.0) - .pi / 2.0
        let centerX: Double = 200.0
        let centerY: Double = 150.0
        let radius: Double = 100.0
        let x = centerX + radius * cos(angle)
        let y = centerY + radius * sin(angle)
        return CGPoint(x: x, y: y)
    }

    @ViewBuilder
    private func stageNodeLabel(_ stage: LifeStage, index: Int) -> some View {
        let bgColor: Color = (currentStage == index)
            ? Color.compatIndigo.opacity(0.15)
            : Color.white.opacity(0.95)
        let borderColor: Color = (currentStage == index) ? Color.compatIndigo : Color.clear
        VStack(spacing: 6) {
            Text(stage.emoji)
                .font(.system(size: 36))
            Text(stage.name)
                .font(.caption.weight(.semibold))
                .foregroundColor(DesignTokens.BrandColor.canvasText)
        }
        .frame(width: 70, height: 70)
        .background(bgColor)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(borderColor, lineWidth: 2)
        )
    }

    @ViewBuilder
    private func stageNode(_ stage: LifeStage, index: Int) -> some View {
        Button {
            withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.3)) {
                currentStage = index
            }
        } label: {
            stageNodeLabel(stage, index: index)
        }
        .buttonStyle(.plain)
        .position(stageNodePosition(index: index))
        .accessibilityLabel(stage.name)
    }

    private func advanceStage() {
        withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.4)) {
            currentStage = (currentStage + 1) % 4
        }
    }

    private func previousStage() {
        withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.4)) {
            currentStage = (currentStage - 1 + 4) % 4
        }
    }
}

private struct LifeStage {
    let emoji: String
    let name: String
    let duration: String
    let desc: String
}

/// The four arrows connecting stage nodes around the cycle.
/// Same geometry the old Canvas code used.
struct SilkwormCycleArrowsShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let center = CGPoint(x: 200, y: 150)
        let radius: Double = 100.0
        for i in 0..<4 {
            let angle1 = Double(i) * (.pi * 2 / 4) - .pi / 2
            let angle2 = Double((i + 1) % 4) * (.pi * 2 / 4) - .pi / 2
            let start = CGPoint(
                x: center.x + radius * cos(angle1) * 0.85,
                y: center.y + radius * sin(angle1) * 0.85
            )
            let end = CGPoint(
                x: center.x + radius * cos(angle2) * 0.85,
                y: center.y + radius * sin(angle2) * 0.85
            )
            p.move(to: start)
            p.addLine(to: end)
        }
        return p
    }
}
