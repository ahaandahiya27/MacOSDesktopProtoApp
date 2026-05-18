import SwiftUI

/// Scene 7 — Amoeba Pseudopod Hunt.
///
/// A blob-shaped Amoeba drawn with Path. A small green food particle floats nearby.
/// Animation: pseudopodia extend toward food, surround it, fuse, and engulf it into
/// a food vacuole that shrinks and digests. Reduce-motion respected. Tap food to
/// restart. Caption from ch02_t02_c02.

struct Scene7_AmoebaPseudopodHunt: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var animating = false
    @State private var pseudopodiaExtend: CGFloat = 0
    @State private var foodEngulfed: CGFloat = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var amoebExplanation: String {
        pack.conceptIndex["ch02_t02_c02"]?.explanation(at: .kidFriendly)
            ?? "An amoeba is a single-celled creature that eats by extending fake feet called pseudopodia to surround and engulf food."
    }

    var body: some View {

        ScrollView {

            VStack(spacing: 14) {
                Text("Amoeba Pseudopod Hunt")
                    .font(.title.bold())
                    .foregroundColor(Color.compatCyan)

                ZStack {
                    // Amoeba body
                    ZStack {
                        AmoebaBlobShape(pseudopodiaExtend: pseudopodiaExtend)
                            .foregroundColor(Color.compatCyan.opacity(0.5))
                        AmoebaBlobShape(pseudopodiaExtend: pseudopodiaExtend)
                            .stroke(lineWidth: 2)
                            .foregroundColor(Color.compatCyan.opacity(0.8))
                    }
                        .frame(width: 100, height: 100)
                        .position(x: 150, y: 120)

                    // Nucleus (simple circle inside amoeba)
                    Circle()
                        .fill(Color.purple.opacity(0.6))
                        .frame(width: 20, height: 20)
                        .position(x: 150, y: 120)

                    // Food particle (if not engulfed)
                    if foodEngulfed < 1.0 {
                        VStack(spacing: 0) {
                            Text("🟢")
                                .font(.system(size: 20))
                        }
                        .position(x: 280, y: 100)
                        .onTapGesture { hunt() }
                    } else {
                        // Food vacuole inside amoeba (shrinking)
                        let vacuoleScale = 1.0 - (foodEngulfed * 0.6)
                        Circle()
                            .fill(Color.green.opacity(0.4))
                            .frame(width: 16 * vacuoleScale, height: 16 * vacuoleScale)
                            .position(x: 150, y: 120)
                    }
                }
                .frame(height: 240)
                .padding(.horizontal, 24)

                HStack {
                    Button(action: { hunt() }) {
                        Label("Hunt Food", systemImage: SFSymbolCompat.name("fork.knife"))
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                    }
                    
                    .accentColor(Color.compatCyan)
                    .disabled(animating)

                }
                .padding(.horizontal, 24)

                SoftShadowCard(padding: 18) {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Amoeba Pseudopod Hunt", systemImage: "bubble.left.fill")
                            .font(.title2.bold())
                            .foregroundColor(Color.compatCyan)
                        Text(amoebExplanation)
                            .font(.body)
                            .foregroundColor(DesignTokens.BrandColor.canvasText)
                            .lineSpacing(4)
                    }
                }
                .frame(maxWidth: DesignTokens.contentMaxWidth)

                LookingAheadCallout(
                    title: "Class 11 Biology → NEET",
                    detail: "Amoeba shows you the SIMPLEST eukaryotic life — one cell that does everything humans do with 37 trillion. NEET asks 'how does Amoeba excrete?' (contractile vacuole pumps water out — osmoregulation) and 'how does it reproduce?' (binary fission). Engulfing food by pseudopods is called *phagocytosis* — the same mechanism your white blood cells use to swallow bacteria. One organism, one trick, two scales."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)

                TryAtHomeCallout(
                    title: "Watch Amoeba on YouTube — slow it down",
                    detail: "Search 'Amoeba feeding microscope' — pick a 4K video and slow playback to 0.25×. Watch the cytoplasm flow into a pseudopod, surround the food, then pinch off into a food vacuole. The Amoeba has no brain, no nerves, no muscles — yet it hunts. It's chemistry organising itself into behaviour."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)

                GotItButton { onComplete() }
                    .padding(.bottom, 12)
            

            }

            .frame(maxWidth: .infinity)

            .padding(.bottom, 12)

        }
    }

    private func hunt() {
        animating = true
        pseudopodiaExtend = 0
        foodEngulfed = 0

        // Phase 1: Extend pseudopodia (1 second)
        withAnimation(reduceMotion ? .none : .easeInOut(duration: 1.2)) {
            pseudopodiaExtend = 1.0
        }

        // Phase 2: Engulf food (1 second after phase 1), then reset
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 1_200_000_000)
            withAnimation(reduceMotion ? .none : .easeInOut(duration: 1.0)) {
                foodEngulfed = 1.0
            }
            try? await Task.sleep(nanoseconds: 1_800_000_000)
            animating = false
        }
    }
}

// MARK: - Amoeba Blob Shape

struct AmoebaBlobShape: Shape {
    let pseudopodiaExtend: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = rect.width / 2

        // Base circular body
        path.addEllipse(in: CGRect(
            x: center.x - radius,
            y: center.y - radius,
            width: radius * 2,
            height: radius * 2
        ))

        // Pseudopodia (extending bumps)
        if pseudopodiaExtend > 0 {
            let protrusion = radius * 0.4 * pseudopodiaExtend
            let angles: [CGFloat] = [0, 1.2, 2.4, 3.6, 4.8]

            for angle in angles {
                let x = center.x + (radius + protrusion) * cos(angle)
                let y = center.y + (radius + protrusion) * sin(angle)
                let bumps = CGRect(
                    x: x - radius * 0.2,
                    y: y - radius * 0.2,
                    width: radius * 0.4,
                    height: radius * 0.4
                )
                path.addEllipse(in: bumps)
            }
        }

        return path
    }
}
