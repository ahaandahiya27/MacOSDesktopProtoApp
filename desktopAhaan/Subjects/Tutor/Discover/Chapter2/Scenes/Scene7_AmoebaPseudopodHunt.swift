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
        GeometryReader { geo in
            VStack(spacing: 16) {
                Text("Amoeba Pseudopod Hunt")
                    .font(.title.bold())
                    .foregroundStyle(.cyan)

                ZStack {
                    // Amoeba body
                    AmoebaBlobShape(pseudopodiaExtend: pseudopodiaExtend)
                        .fill(Color.cyan.opacity(0.5))
                        .stroke(Color.cyan.opacity(0.8), lineWidth: 2)
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
                        Label("Hunt Food", systemImage: "fork.knife")
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.cyan)
                    .disabled(animating)

                    Spacer()
                }
                .padding(.horizontal, 24)

                Spacer()

                SoftShadowCard(padding: 18) {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Amoeba Pseudopod Hunt", systemImage: "bubble.left.fill")
                            .font(.title2.bold())
                            .foregroundStyle(.cyan)
                        Text(amoebExplanation)
                            .font(.body)
                            .foregroundStyle(.primary)
                            .lineSpacing(4)
                    }
                }
                .frame(maxWidth: 640)

                GotItButton { onComplete() }
                    .padding(.bottom, 12)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
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

        // Phase 2: Engulf food (1 second after phase 1)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            withAnimation(reduceMotion ? .none : .easeInOut(duration: 1.0)) {
                foodEngulfed = 1.0
            }
        }

        // Reset after 3 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
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
