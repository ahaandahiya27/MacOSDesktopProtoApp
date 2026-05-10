import SwiftUI

/// Confetti / sparkle emitter rendered with `Canvas` — no image assets, no
/// CALayers. Each particle is a colored circle that falls under simulated
/// gravity with a horizontal drift. Reused by Scene 5 (right-answer reward),
/// Scene 7 (sinking-fly indicator), and Scene 9 (final celebration).
///
/// Set `isActive = true` to start. After `duration` seconds the emitter stops
/// spawning new particles; existing ones continue to fall until off-screen.
struct ParticleEmitter: View {
    var isActive: Bool
    var particleCount: Int = 80
    var duration: Double = 2.5
    var palette: [Color] = [.red, .orange, .yellow, .green, .blue, .purple, .pink]
    /// Reduce-motion respects this and short-circuits the canvas.
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var particles: [Particle] = []
    @State private var startTime = Date()

    var body: some View {
        TimelineView(.animation) { context in
            Canvas { ctx, size in
                guard !reduceMotion else { return }
                let elapsed = context.date.timeIntervalSince(startTime)
                for p in particles {
                    let life = elapsed - p.spawnDelay
                    guard life >= 0 else { continue }
                    // Position with simple ballistic motion.
                    let x = p.startX * size.width + p.driftX * CGFloat(life) * 60
                    let y = -20 + 0.5 * 980 * CGFloat(life * life) * 0.4 + p.driftY * CGFloat(life) * 60
                    if y > size.height + 40 { continue }
                    let rect = CGRect(x: x - p.size / 2, y: y - p.size / 2, width: p.size, height: p.size)
                    ctx.opacity = max(0, 1 - life / duration)
                    ctx.fill(Path(ellipseIn: rect), with: .color(p.color))
                }
            }
        }
        .allowsHitTesting(false)
        .onChange(of: isActive) { _, newValue in
            if newValue { kickOff() }
        }
        .onAppear {
            if isActive { kickOff() }
        }
    }

    private func kickOff() {
        startTime = Date()
        particles = (0..<particleCount).map { _ in
            Particle(
                startX: CGFloat.random(in: 0.05...0.95),
                driftX: CGFloat.random(in: -1.2...1.2),
                driftY: CGFloat.random(in: -0.6...0.2),
                size: CGFloat.random(in: 6...14),
                color: palette.randomElement() ?? .yellow,
                spawnDelay: Double.random(in: 0...0.8)
            )
        }
    }

    private struct Particle {
        let startX: CGFloat
        let driftX: CGFloat
        let driftY: CGFloat
        let size: CGFloat
        let color: Color
        let spawnDelay: Double
    }
}
