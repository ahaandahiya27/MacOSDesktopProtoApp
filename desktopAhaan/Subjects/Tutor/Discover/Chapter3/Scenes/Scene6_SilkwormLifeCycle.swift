import SwiftUI

/// Scene 6 — Silkworm Life Cycle.
///
/// 4 stages in a circular cycle: Egg → Larva → Pupa → Moth → back to egg.
/// Tap each stage to advance. Timer next to each shows duration.
@available(macOS 12, *)
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
        VStack(spacing: 20) {
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

                // Arrows between stages
                Canvas { context, _ in
                    let center = CGPoint(x: 200, y: 150)
                    let radius = 100.0
                    for i in 0..<4 {
                        let angle1 = CGFloat(i) * (.pi * 2 / 4) - .pi / 2
                        let angle2 = CGFloat((i + 1) % 4) * (.pi * 2 / 4) - .pi / 2

                        let start = CGPoint(
                            x: center.x + radius * cos(angle1) * 0.85,
                            y: center.y + radius * sin(angle1) * 0.85
                        )
                        let end = CGPoint(
                            x: center.x + radius * cos(angle2) * 0.85,
                            y: center.y + radius * sin(angle2) * 0.85
                        )

                        context.stroke(
                            Path { p in
                                p.move(to: start)
                                p.addLine(to: end)
                            },
                            with: .color(.gray.opacity(0.4)),
                            lineWidth: 1.5
                        )
                    }
                }

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
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(16)
            .background(.white.opacity(0.5))
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

            Spacer()

            GotItButton {
                onComplete()
            }
            .padding(.bottom, 20)
        }
    }

    @ViewBuilder
    private func stageNode(_ stage: LifeStage, index: Int) -> some View {
        let angle = CGFloat(index) * (.pi * 2 / 4) - .pi / 2
        let center = CGPoint(x: 200, y: 150)
        let radius = 100.0
        let position = CGPoint(
            x: center.x + radius * cos(angle),
            y: center.y + radius * sin(angle)
        )

        Button {
            withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.3)) {
                currentStage = index
            }
        } label: {
            VStack(spacing: 6) {
                Text(stage.emoji)
                    .font(.system(size: 36))
                Text(stage.name)
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.primary)
            }
            .frame(width: 70, height: 70)
            .background(currentStage == index ? Color.compatIndigo.opacity(0.15) : Color.gray.opacity(0.05))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(currentStage == index ? Color.compatIndigo : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
        .position(position)
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
