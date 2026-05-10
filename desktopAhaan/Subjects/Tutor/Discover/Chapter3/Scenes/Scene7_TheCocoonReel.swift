import SwiftUI

/// Scene 7 — The Cocoon Reel.
///
/// Cocoon in centre. "Pull thread!" button unwinds filament onto a reel to the right.
/// Counter: "Filament unwound: X m / 1200 m". When full, cocoon shrinks and finished thread shown.
/// Includes ethics disclosure: "Why is the pupa killed?"
struct Scene7_TheCocoonReel: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var metersUnwound: Double = 0
    @State private var cocoonScale: CGFloat = 1.0
    @State private var showFinished = false
    @State private var showEthicsDisclosure = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let maxMeters = 1200.0

    var body: some View {
        VStack(spacing: 18) {
            HStack {
                Text("The Cocoon Reel")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.indigo)
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Text("Progress")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                    ProgressView(value: metersUnwound, total: maxMeters)
                        .frame(width: 120)
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 20)

            // Visualization
            ZStack {
                HStack(spacing: 40) {
                    // Cocoon
                    VStack {
                        Text("🛏")
                            .font(.system(size: 64))
                            .scaleEffect(cocoonScale)
                        Text("Cocoon")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)

                    // Reel with wrapped thread
                    VStack {
                        Canvas { context, _ in
                            // Reel body
                            context.fill(
                                Path(ellipseIn: CGRect(x: 140, y: 60, width: 60, height: 60)),
                                with: .color(.gray.opacity(0.3))
                            )
                            context.stroke(
                                Path(ellipseIn: CGRect(x: 140, y: 60, width: 60, height: 60)),
                                with: .color(.gray),
                                lineWidth: 2
                            )

                            // Wrapped thread visualization
                            let wraps = Int(metersUnwound / 100)
                            for i in 0..<wraps {
                                let angle = CGFloat(i) * 0.2
                                context.stroke(
                                    Path { p in
                                        p.addArc(
                                            center: CGPoint(x: 170, y: 90),
                                            radius: 15 + CGFloat(i) * 2,
                                            startAngle: .degrees(0),
                                            endAngle: .degrees(Double(angle) * 57.3),
                                            clockwise: false
                                        )
                                    },
                                    with: .color(.yellow.opacity(0.7)),
                                    lineWidth: 2
                                )
                            }
                        }
                        .frame(width: 300, height: 150)

                        Text("Reel")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 24)
            }
            .frame(height: 180)

            // Counter
            VStack(spacing: 4) {
                Text("Filament Unwound")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                Text("\(Int(metersUnwound)) m / \(Int(maxMeters)) m")
                    .font(.title2.weight(.bold))
                    .foregroundStyle(.indigo)
            }

            // Pull thread button
            Button {
                pullThread()
            } label: {
                Label(metersUnwound >= maxMeters ? "Complete!" : "Pull Thread!", systemImage: "arrow.right.to.line")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.indigo)
            .disabled(metersUnwound >= maxMeters)
            .padding(.horizontal, 24)

            // Ethics disclosure
            DisclosureGroup("Why is the pupa killed?") {
                SoftShadowCard(padding: 12) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Traditional silk production kills the pupa inside the cocoon before reeling so the cocoon remains whole and the fibre unbroken.")
                            .font(.caption)
                            .foregroundStyle(.primary)
                        Divider()
                        Text("Some believe this is ethically questionable. Peace silk lets the moth emerge first, but yields shorter, lower-grade fibre. You can choose based on your values.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(12)
            .background(.white.opacity(0.5))
            .cornerRadius(8)

            Spacer()

            GotItButton {
                onComplete()
            }
            .padding(.bottom, 20)
        }
    }

    private func pullThread() {
        let pullAmount = 80.0 + Double.random(in: -20...20)
        withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.5)) {
            metersUnwound = min(metersUnwound + pullAmount, maxMeters)
            if metersUnwound >= maxMeters {
                cocoonScale = 0.2
            } else {
                cocoonScale = 1.0 - (metersUnwound / maxMeters) * 0.7
            }
        }
    }
}
