import SwiftUI

/// Scene 1 — The Plant Kitchen.
///
/// The kid sees a glowing leaf at the centre. Sunlight rays fall, water drops
/// rise, CO₂ wisps drift in. Tap the leaf — it pulses, a glucose hexagon
/// emerges, and a speech bubble pops up.
@available(macOS 12, *)
struct Scene1_PlantKitchen: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var pulse: CGFloat = 0
    @State private var showGlucose = false
    @State private var showBubble = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var kidFriendlyExplanation: String {
        pack.conceptIndex["ch01_t01_c01"]?.explanation(at: .kidFriendly)
            ?? "Plants make their own food using sunlight, water and air. Their kitchen is the leaf."
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Background ambient animation
                if !reduceMotion {
                    TimelineView(.animation(minimumInterval: 1.0 / 30)) { ctx in
                        let t = ctx.date.timeIntervalSince1970
                        ZStack {
                            sunRays(t: t, in: geo.size)
                            waterDrops(t: t, in: geo.size)
                            co2Wisps(t: t, in: geo.size)
                        }
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
            let phase = (t + Double(i) * 0.4).truncatingRemainder(dividingBy: 3) / 3
            let x = size.width * (0.15 + Double(i) * 0.18)
            let y = size.height * 0.05 + size.height * 0.4 * phase
            let opacity = 1 - phase
            Image(systemName: "sun.max.fill")
                .font(.system(size: 22))
                .foregroundColor(.yellow.opacity(opacity * 0.9))
                .position(x: x, y: y)
        }
    }

    @ViewBuilder
    private func waterDrops(t: TimeInterval, in size: CGSize) -> some View {
        ForEach(0..<5, id: \.self) { i in
            let phase = (t + Double(i) * 0.3).truncatingRemainder(dividingBy: 3) / 3
            let x = size.width * (0.25 + Double(i) * 0.13)
            let y = size.height * 0.95 - size.height * 0.4 * phase
            let opacity = 1 - phase
            Image(systemName: "drop.fill")
                .font(.system(size: 16))
                .foregroundColor(.blue.opacity(opacity * 0.85))
                .position(x: x, y: y)
        }
    }

    @ViewBuilder
    private func co2Wisps(t: TimeInterval, in size: CGSize) -> some View {
        ForEach(0..<3, id: \.self) { i in
            let phase = (t + Double(i) * 0.7).truncatingRemainder(dividingBy: 4) / 4
            let x = size.width * 0.05 + size.width * 0.4 * phase
            let y = size.height * (0.30 + Double(i) * 0.18)
            let opacity = sin(phase * .pi)
            Text("CO₂")
                .font(.system(size: 18, weight: .medium, design: .rounded))
                .foregroundColor(.gray.opacity(opacity * 0.7))
                .position(x: x, y: y)
        }
    }
}

// MARK: - Helper subviews

@available(macOS 12, *)
private struct GlucoseHex: View {
    var body: some View {
        ZStack {
            HexagonShape()
                .fill(
                    LinearGradient(
                        colors: [.purple.opacity(0.85), .pink.opacity(0.85)],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    )
                )
                .shadow(color: .purple.opacity(0.5), radius: 10)
            Text("C₆H₁₂O₆")
                .font(.caption2.weight(.heavy))
                .foregroundColor(.white)
        }
    }
}

@available(macOS 12, *)
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
                        .fill(.white)
                    Path { p in
                        p.move(to: CGPoint(x: 18, y: 20))
                        p.addLine(to: CGPoint(x: 6, y: 38))
                        p.addLine(to: CGPoint(x: 36, y: 22))
                        p.closeSubpath()
                    }
                    .fill(.white)
                    .offset(y: 12)
                }
            )
            .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 4)
    }
}
