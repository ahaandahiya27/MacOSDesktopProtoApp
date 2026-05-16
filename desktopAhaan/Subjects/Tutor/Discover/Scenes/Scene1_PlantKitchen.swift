import SwiftUI

/// Scene 1 — The Plant Kitchen.
///
/// The kid sees a glowing leaf at the centre. Sunlight rays fall, water drops
/// rise, CO₂ wisps drift in. Tap the leaf — it pulses, a glucose hexagon
/// emerges, and a speech bubble pops up.
///
/// Big Sur (macOS 11) compatible — the ambient animation that used to be
/// driven by `TimelineView(.animation(minimumInterval:))` (macOS 12+) is now
/// driven by a 30 fps `Timer.publish` feeding a single `@State` tick value.
/// The ambient sub-views read the same tick to recompute their positions,
/// preserving the visual behaviour on both macOS 11 and modern macOS.
struct Scene1_PlantKitchen: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var pulse: CGFloat = 0
    @State private var showGlucose = false
    @State private var showBubble = false
    /// Continuously-updated animation clock — replaces TimelineView's
    /// `ctx.date.timeIntervalSince1970`. Started in onAppear, stopped in
    /// onDisappear so the scene doesn't keep the CPU busy when hidden.
    @State private var tick: TimeInterval = 0
    @State private var animationTimer: Timer? = nil
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var kidFriendlyExplanation: String {
        pack.conceptIndex["ch01_t01_c01"]?.explanation(at: .kidFriendly)
            ?? "Plants make their own food using sunlight, water and air. Their kitchen is the leaf."
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Ambient animation (sunlight rays, water drops, CO₂ wisps)
                if !reduceMotion {
                    ZStack {
                        sunRays(t: tick, in: geo.size)
                        waterDrops(t: tick, in: geo.size)
                        co2Wisps(t: tick, in: geo.size)
                    }
                }

                // The central leaf
                ZStack {
                    DrawnLeaf(pulse: pulse)
                        .frame(width: 220, height: 280)
                        .onTapGesture { tappedLeaf() }
                        .accessibilityAddTraits(.isButton)
                        .accessibilityLabel("Tap the leaf to make it cook food.")

                    // Glucose molecule that emerges on tap
                    if showGlucose {
                        GlucoseHex()
                            .frame(width: 80, height: 80)
                            .offset(x: 140, y: -100)
                            .transition(.opacity.combined(with: .scale))
                    }
                }
                .position(x: geo.size.width / 2, y: geo.size.height / 2 - 30)

                // Speech bubble
                if showBubble {
                    SpeechBubble(text: "I just made my own food!")
                        .position(x: geo.size.width / 2 + 160, y: geo.size.height / 2 - 170)
                        .transition(.scale.combined(with: .opacity))
                }

                // Caption + got-it button
                VStack(spacing: 14) {
                    Spacer()
                    SoftShadowCard(padding: 18) {
                        VStack(alignment: .leading, spacing: 8) {
                            Label("The Plant Kitchen", systemImage: "leaf.circle.fill")
                                .font(.title2.bold())
                                .foregroundColor(.green)
                            Text(kidFriendlyExplanation)
                                .font(.body)
                                .foregroundColor(.primary)
                                .lineSpacing(4)
                        }
                    }
                    .frame(maxWidth: DesignTokens.contentMaxWidth)

                    GotItButton {
                        onComplete()
                    }
                    .padding(.bottom, 12)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .padding(.horizontal, 24)
            }
        }
        .onAppear(perform: startAnimationLoop)
        .onDisappear(perform: stopAnimationLoop)
    }

    // MARK: - Animation loop

    private func startAnimationLoop() {
        guard !reduceMotion, animationTimer == nil else { return }
        let start = Date().timeIntervalSince1970
        // 30 fps matches the old TimelineView(.animation(minimumInterval: 1/30))
        animationTimer = Timer.scheduledTimer(withTimeInterval: 1.0 / 30, repeats: true) { _ in
            tick = Date().timeIntervalSince1970 - start
        }
    }

    private func stopAnimationLoop() {
        animationTimer?.invalidate()
        animationTimer = nil
    }

    // MARK: - Tap handling

    private func tappedLeaf() {
        withAnimation(reduceMotion ? .none : .spring(response: 0.45, dampingFraction: 0.55)) {
            pulse = 1
            showGlucose = true
            showBubble = true
        }
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 1_200_000_000)
            withAnimation(.easeOut(duration: 0.6)) {
                pulse = 0
            }
        }
    }

    // MARK: - Ambient sub-views

    @ViewBuilder
    private func sunRays(t: TimeInterval, in size: CGSize) -> some View {
        ForEach(0..<5, id: \.self) { i in
            SunRayDot(index: i, t: t, size: size)
        }
    }

    @ViewBuilder
    private func waterDrops(t: TimeInterval, in size: CGSize) -> some View {
        ForEach(0..<5, id: \.self) { i in
            WaterDrop(index: i, t: t, size: size)
        }
    }

    @ViewBuilder
    private func co2Wisps(t: TimeInterval, in size: CGSize) -> some View {
        ForEach(0..<3, id: \.self) { i in
            CO2Wisp(index: i, t: t, size: size)
        }
    }
}

// MARK: - Ambient particle subviews
//
// These are split into their own structs so the per-particle position /
// opacity math is type-checked locally. The Big Sur Swift 5.5 compiler
// times out trying to infer the long chained expression inside a
// @ViewBuilder ForEach. Wrapping each particle in a small View keeps the
// per-expression complexity bounded.

private struct SunRayDot: View {
    let index: Int
    let t: TimeInterval
    let size: CGSize
    var body: some View {
        let phase: Double = ((t + Double(index) * 0.4).truncatingRemainder(dividingBy: 3.0)) / 3.0
        let x: Double = Double(size.width) * (0.15 + Double(index) * 0.18)
        let y: Double = Double(size.height) * 0.05 + Double(size.height) * 0.4 * phase
        let opacity: Double = 1.0 - phase
        Image(systemName: "sun.max.fill")
            .font(.system(size: 22))
            .foregroundColor(Color.yellow.opacity(opacity * 0.9))
            .position(x: CGFloat(x), y: CGFloat(y))
    }
}

private struct WaterDrop: View {
    let index: Int
    let t: TimeInterval
    let size: CGSize
    var body: some View {
        let phase: Double = ((t + Double(index) * 0.3).truncatingRemainder(dividingBy: 3.0)) / 3.0
        let x: Double = Double(size.width) * (0.25 + Double(index) * 0.13)
        let y: Double = Double(size.height) * 0.95 - Double(size.height) * 0.4 * phase
        let opacity: Double = 1.0 - phase
        Image(systemName: "drop.fill")
            .font(.system(size: 16))
            .foregroundColor(Color.blue.opacity(opacity * 0.85))
            .position(x: CGFloat(x), y: CGFloat(y))
    }
}

private struct CO2Wisp: View {
    let index: Int
    let t: TimeInterval
    let size: CGSize
    var body: some View {
        let phase: Double = ((t + Double(index) * 0.7).truncatingRemainder(dividingBy: 4.0)) / 4.0
        let x: Double = Double(size.width) * 0.05 + Double(size.width) * 0.4 * phase
        let y: Double = Double(size.height) * (0.30 + Double(index) * 0.18)
        let opacity: Double = sin(Double(phase) * Double.pi)
        Text("CO₂")
            .font(.system(size: 18, weight: .medium, design: .rounded))
            .foregroundColor(Color.gray.opacity(opacity * 0.7))
            .position(x: CGFloat(x), y: CGFloat(y))
    }
}

// MARK: - Helper subviews

private struct GlucoseHex: View {
    var body: some View {
        ZStack {
            HexagonShape()
                .fill(
                    LinearGradient(
                        colors: [Color.purple.opacity(0.85), Color.pink.opacity(0.85)],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    )
                )
                .shadow(color: Color.purple.opacity(0.5), radius: 10)
            Text("C₆H₁₂O₆")
                .font(.caption2.weight(.heavy))
                .foregroundColor(.white)
        }
    }
}

private struct SpeechBubble: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.title3.weight(.semibold))
            .foregroundColor(.primary)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                ZStack(alignment: .bottomLeading) {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Color.white)
                    Path { p in
                        p.move(to: CGPoint(x: 18, y: 20))
                        p.addLine(to: CGPoint(x: 6, y: 38))
                        p.addLine(to: CGPoint(x: 36, y: 22))
                        p.closeSubpath()
                    }
                    .fill(Color.white)
                    .offset(y: 12)
                }
            )
            .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 4)
    }
}
