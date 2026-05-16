import SwiftUI

/// Confetti / sparkle emitter. Each particle is a colored circle that falls
/// under simulated gravity with a horizontal drift. Reused by Scene 5
/// (right-answer reward), Scene 7 (sinking-fly indicator), and Scene 9
/// (final celebration), plus many Boss Quiz scenes.
///
/// Set `isActive = true` to start. After `duration` seconds each particle
/// fades out; existing ones continue to fall until off-screen.
///
/// Big Sur (macOS 11) compatible — previously rendered the particles via a
/// SwiftUI `Canvas` inside a `TimelineView` (both macOS 12+). Now uses a
/// 30 fps `Timer.publish` writing into a `@State tick` plus a `ForEach` of
/// `ParticleDot` views, so the visuals work on macOS 11 as well as modern
/// macOS.
struct ParticleEmitter: View {
    var isActive: Bool
    var particleCount: Int = 80
    var duration: Double = 2.5
    var palette: [Color] = [.red, .orange, .yellow, .green, .blue, .purple, .pink]
    /// Reduce-motion respects this and short-circuits the emitter entirely.
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var particles: [Particle] = []
    @State private var startTime = Date()
    @State private var tick: TimeInterval = 0
    @State private var animationTimer: Timer? = nil

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .topLeading) {
                if !reduceMotion {
                    ForEach(particles) { p in
                        ParticleDot(particle: p, elapsed: tick, size: geo.size, duration: duration)
                    }
                }
            }
        }
        .allowsHitTesting(false)
        .onChange(of: isActive) { newValue in
            if newValue { kickOff() } else { stop() }
        }
        .onAppear {
            if isActive { kickOff() }
        }
        .onDisappear {
            stop()
        }
    }

    private func kickOff() {
        guard !reduceMotion else { return }
        startTime = Date()
        tick = 0
        particles = (0..<particleCount).map { i in
            Particle(
                id: i,
                startX: CGFloat.random(in: 0.05...0.95),
                driftX: CGFloat.random(in: -1.2...1.2),
                driftY: CGFloat.random(in: -0.6...0.2),
                size: CGFloat.random(in: 6...14),
                color: palette.randomElement() ?? .yellow,
                spawnDelay: Double.random(in: 0...0.8)
            )
        }
        animationTimer?.invalidate()
        animationTimer = Timer.scheduledTimer(withTimeInterval: 1.0 / 30, repeats: true) { _ in
            tick = Date().timeIntervalSince(startTime)
        }
    }

    private func stop() {
        animationTimer?.invalidate()
        animationTimer = nil
    }

    fileprivate struct Particle: Identifiable {
        let id: Int
        let startX: CGFloat
        let driftX: CGFloat
        let driftY: CGFloat
        let size: CGFloat
        let color: Color
        let spawnDelay: Double
    }
}

/// One falling confetti dot. Pulled into its own View so the per-particle
/// physics expressions are type-checked locally — keeps Big Sur's Swift 5.5
/// type-checker happy (otherwise the long inline `let x = ...` chain inside
/// a ForEach closure can time out).
private struct ParticleDot: View {
    let particle: ParticleEmitter.Particle
    let elapsed: TimeInterval
    let size: CGSize
    let duration: Double

    var body: some View {
        let life: Double = elapsed - particle.spawnDelay
        if life >= 0 {
            let lifeCG: CGFloat = CGFloat(life)
            let x: CGFloat = particle.startX * size.width + particle.driftX * lifeCG * 60
            let y: CGFloat = -20 + 0.5 * 980 * lifeCG * lifeCG * 0.4 + particle.driftY * lifeCG * 60
            if y <= size.height + 40 {
                let opacity: Double = max(0, 1 - life / duration)
                Circle()
                    .fill(particle.color)
                    .frame(width: particle.size, height: particle.size)
                    .opacity(opacity)
                    .position(x: x, y: y)
            }
        }
    }
}
