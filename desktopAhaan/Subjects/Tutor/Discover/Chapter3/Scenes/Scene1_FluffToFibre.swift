import SwiftUI

/// Scene 1 — From Fluff to Fibre.
///
/// Three glowing icons (🐑 sheep, 🐛 silkworm, 🌿 cotton) drift in from the edges.
/// Tapping each makes a thread emerge and weave into a small piece of fabric on the right.
/// Caption explains these sources give us most fabrics.
///
/// Big Sur (macOS 11) compatible — the drifting-icon TimelineView is
/// replaced with a Timer.publish + a small DriftingIcon view per icon;
/// the fabric Canvas becomes a Shape (FabricWeaveShape) drawn behind the
/// fabric panel.
struct Scene1_FluffToFibre: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var showSheep = false
    @State private var showSilkworm = false
    @State private var showCotton = false
    @State private var threadsWoven = 0
    @State private var tick: TimeInterval = 0
    @State private var animationTimer: Timer? = nil
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var kidFriendlyExplanation: String {
        pack.conceptIndex["ch03_t01_c01"]?.explanation(at: .kidFriendly)
            ?? "These three living things give us most of the world's fabrics."
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Drifting icons
                DriftingIcon(emoji: "🐑", baseX: 0.15, baseY: 0.3,
                             phaseOffset: 0.0, t: tick, size: geo.size,
                             onTap: { tapIcon("🐑") })
                DriftingIcon(emoji: "🐛", baseX: 0.15, baseY: 0.5,
                             phaseOffset: 1.0, t: tick, size: geo.size,
                             onTap: { tapIcon("🐛") })
                DriftingIcon(emoji: "🌿", baseX: 0.15, baseY: 0.7,
                             phaseOffset: 2.0, t: tick, size: geo.size,
                             onTap: { tapIcon("🌿") })

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
        .onAppear(perform: startAnimation)
        .onDisappear(perform: stopAnimation)
    }

    private func startAnimation() {
        guard !reduceMotion, animationTimer == nil else { return }
        let start = Date().timeIntervalSince1970
        animationTimer = Timer.scheduledTimer(withTimeInterval: 1.0 / 30, repeats: true) { _ in
            tick = Date().timeIntervalSince1970 - start
        }
    }
    private func stopAnimation() {
        animationTimer?.invalidate()
        animationTimer = nil
    }

    @ViewBuilder
    private func fabricPanel(geoSize: CGSize) -> some View {
        VStack {
            Text("Fabric Woven")
                .font(.caption.weight(.semibold))
                .foregroundColor(.secondary)

            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.1))
                    .frame(width: 140, height: 100)
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1.5)
                    .frame(width: 140, height: 100)
                FabricWeaveShape(threads: threadsWoven)
                    .stroke(Color.compatIndigo.opacity(0.7), lineWidth: 2)
                    .frame(width: 140, height: 100)
            }
            .frame(width: 180, height: 150)
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
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

/// One emoji icon that gently bobs up and down using a sine wave fed by
/// the parent's tick. Extracted so the position math doesn't appear inline
/// inside a @ViewBuilder.
private struct DriftingIcon: View {
    let emoji: String
    let baseX: CGFloat
    let baseY: CGFloat
    let phaseOffset: TimeInterval
    let t: TimeInterval
    let size: CGSize
    let onTap: () -> Void

    var body: some View {
        let bob: Double = sin(Double(t + phaseOffset) * 1.5) * 0.1
        let y: CGFloat = size.height * (baseY + CGFloat(bob))
        Text(emoji)
            .font(.system(size: 64))
            .position(x: size.width * baseX, y: y)
            .onTapGesture { onTap() }
            .accessibilityAddTraits(.isButton)
            .accessibilityLabel("Tap \(emoji) to weave a fibre")
    }
}

/// The fabric's vertical thread pattern. `threads` controls how many of
/// the available 12 thread positions are drawn. Used to be a Canvas loop
/// inside the fabric panel; rebuilt as a Shape so it renders on macOS 11.
private struct FabricWeaveShape: Shape {
    let threads: Int

    func path(in rect: CGRect) -> Path {
        var p = Path()
        // Position threads inside an inner rectangle, matching the old
        // Canvas geometry: 20-pt inset horizontally, 15-pt inset vertically,
        // 10-pt thread spacing.
        let innerX0 = rect.minX + 20
        let innerY0 = rect.minY + 15
        let innerY1 = rect.maxY - 15
        let maxX = rect.maxX - 20
        let spacing: CGFloat = 10
        for i in 0...threads {
            let x = innerX0 + CGFloat(i) * spacing
            if x > maxX { break }
            p.move(to: CGPoint(x: x, y: innerY0))
            p.addLine(to: CGPoint(x: x, y: innerY1))
        }
        return p
    }
}
