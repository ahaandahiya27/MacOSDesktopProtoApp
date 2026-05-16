import SwiftUI

/// Scene 1 — From Fluff to Fibre.
///
/// Three glowing icons (🐑 sheep, 🐛 silkworm, 🌿 cotton) drift in from the edges.
/// Tapping each makes a thread emerge and weave into a small piece of fabric on the right.
/// Caption explains these sources give us most fabrics.
@available(macOS 12, *)
struct Scene1_FluffToFibre: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var showSheep = false
    @State private var showSilkworm = false
    @State private var showCotton = false
    @State private var threadsWoven = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var kidFriendlyExplanation: String {
        pack.conceptIndex["ch03_t01_c01"]?.explanation(at: .kidFriendly)
            ?? "These three living things give us most of the world's fabrics."
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Drifting icons
                if !reduceMotion {
                    TimelineView(.animation(minimumInterval: 1.0 / 30)) { ctx in
                        let t = ctx.date.timeIntervalSince1970
                        ZStack {
                            driftingIcon("🐑", x: 0.15, y: 0.3, phase: t, in: geo.size)
                            driftingIcon("🐛", x: 0.15, y: 0.5, phase: t + 1.0, in: geo.size)
                            driftingIcon("🌿", x: 0.15, y: 0.7, phase: t + 2.0, in: geo.size)
                        }
                    }
                } else {
                    driftingIcon("🐑", x: 0.15, y: 0.3, phase: 0, in: geo.size)
                    driftingIcon("🐛", x: 0.15, y: 0.5, phase: 0, in: geo.size)
                    driftingIcon("🌿", x: 0.15, y: 0.7, phase: 0, in: geo.size)
                }

                // Fabric weaving on the right
                fabricPanel(geoSize: geo.size)

                // Caption + button
                VStack(spacing: 14) {
                    Spacer()
                    SoftShadowCard(padding: 18) {
                        VStack(alignment: .leading, spacing: 8) {
                            Label("From Fluff to Fibre", systemImage: "sparkles")
                                .font(.title2.bold())
                                .foregroundColor(Color.compatIndigo)
                            Text(kidFriendlyExplanation)
                                .font(.body)
                                .foregroundColor(.primary)
                                .lineSpacing(4)
                        }
                    }
                    .frame(maxWidth: 640)

                    GotItButton {
                        onComplete()
                    }
                    .padding(.bottom, 12)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .padding(.horizontal, 24)
            }
        }
    }

    @ViewBuilder
    private func driftingIcon(_ emoji: String, x: CGFloat, y: CGFloat, phase: TimeInterval, in size: CGSize) -> some View {
        let bobPhase = sin(phase * 1.5) * 0.1
        Text(emoji)
            .font(.system(size: 64))
            .position(x: size.width * x, y: size.height * (y + bobPhase))
            .onTapGesture {
                tapIcon(emoji)
            }
            .accessibilityAddTraits(.isButton)
            .accessibilityLabel("Tap \(emoji) to weave a fibre")
    }

    @ViewBuilder
    private func fabricPanel(geoSize: CGSize) -> some View {
        VStack {
            Text("Fabric Woven")
                .font(.caption.weight(.semibold))
                .foregroundColor(.secondary)

            Canvas { context, _ in
                let fabricRect = CGRect(x: 20, y: 40, width: 140, height: 100)
                context.fill(
                    Path(roundedRect: fabricRect, cornerRadius: 8),
                    with: .color(.gray.opacity(0.1))
                )
                context.stroke(
                    Path(roundedRect: fabricRect, cornerRadius: 8),
                    with: .color(.gray.opacity(0.3)),
                    lineWidth: 1.5
                )

                // Draw woven threads
                let threadSpacing = 10.0
                for i in stride(from: 0, through: threadsWoven, by: 1) {
                    let x = fabricRect.minX + 20 + CGFloat(i) * threadSpacing
                    if x <= fabricRect.maxX - 20 {
                        context.stroke(
                            Path { p in
                                p.move(to: CGPoint(x: x, y: fabricRect.minY + 15))
                                p.addLine(to: CGPoint(x: x, y: fabricRect.maxY - 15))
                            },
                            with: .color(Color.compatIndigo.opacity(0.7)),
                            lineWidth: 2
                        )
                    }
                }
            }
            .frame(width: 180, height: 150)
        }
        .padding(16)
        .background(.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        .position(x: geoSize.width * 0.8, y: geoSize.height * 0.35)
    }

    private func tapIcon(_ emoji: String) {
        withAnimation(reduceMotion ? .none : .spring(response: 0.4, dampingFraction: 0.6)) {
            switch emoji {
            case "🐑": showSheep = true
            case "🐛": showSilkworm = true
            case "🌿": showCotton = true
            default: break
            }
            if threadsWoven < 12 {
                threadsWoven += 1
            }
        }
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 600_000_000)
            withAnimation(.easeOut(duration: 0.4)) {
                switch emoji {
                case "🐑": showSheep = false
                case "🐛": showSilkworm = false
                case "🌿": showCotton = false
                default: break
                }
            }
        }
    }
}
