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
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var kidFriendlyExplanation: String {
        pack.conceptIndex["ch01_t01_c01"]?.explanation(at: .kidFriendly)
            ?? "Plants make their own food using sunlight, water and air. Their kitchen is the leaf."
    }

    var body: some View {
        // 2026-05-22 fix: replaced inner `GeometryReader` with a fixed
        // 600×420 canvas. The previous ScrollView { LazyVStack {
        // GeometryReader { … } } } nesting triggered AppKit's
        // `_NSDetectedLayoutRecursion` on Big Sur — GeometryReader's
        // indeterminate width inside a vertical-scrolling container
        // made SwiftUI's layout iteratively re-converge, occasionally
        // landing in objc_release with EXC_BAD_ACCESS on the AMD R9
        // M290X. Hardcoded canvas dimensions eliminate the layout
        // ambiguity. Sizes chosen so leaf (220×280, centered) and
        // speech bubble (right of leaf, ~75pt from top) both fit.
        // Also lightened combined `.scale + .opacity` transitions to
        // plain `.opacity` — combined transitions are the second-most
        // common Big Sur render-loop trigger after the layout one.
        ScrollView {
            LazyVStack(alignment: .center, spacing: 14) {
                ZStack {
                    // Ambient animation (sunlight rays, water drops, CO₂ wisps)
                    if !reduceMotion {
                        ZStack {
                            sunRays(t: tick, in: CGSize(width: 600, height: 420))
                            waterDrops(t: tick, in: CGSize(width: 600, height: 420))
                            co2Wisps(t: tick, in: CGSize(width: 600, height: 420))
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
                                .transition(.opacity)
                        }
                    }
                    .position(x: 300, y: 231)

                    // Speech bubble — placed above the leaf.
                    if showBubble {
                        SpeechBubble(text: "I just made my own food!")
                            .position(x: 460, y: 76)
                            .transition(.opacity)
                    }
                }
                .frame(width: 600, height: 420)

                Group {
                    SoftShadowCard(padding: 18) {
                        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                            Label("The Plant Kitchen", systemImage: "leaf.circle.fill")
                                .font(.title2.bold())
                                .foregroundColor(.green)
                            Text(kidFriendlyExplanation)
                                .font(.body)
                                .foregroundColor(DesignTokens.BrandColor.canvasText)
                                .lineSpacing(4)
                        }
                    }
                    .frame(maxWidth: DesignTokens.contentMaxWidth)

                    RelatedConceptsCallout(
                        title: "Related: Ch 11 (Transportation), Ch 17 (Forests)",
                        detail: "Plants need water reaching their leaves to do photosynthesis — Ch 11 explains the xylem pipeline that gets it there. And the global O₂ cycle this powers is covered in Ch 17."
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)

                    MnemonicCallout(
                        hook: "SLAW",
                        meaning: "The four things a plant needs to cook its food.",
                        expansion: [
                            ("S", "Sunlight — the energy source"),
                            ("L", "Leaf — the kitchen (chlorophyll)"),
                            ("A", "Air — carbon dioxide from the atmosphere"),
                            ("W", "Water — pulled up from the roots")
                        ]
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)

                    LookingAheadCallout(
                        title: "Class 11 Biology → NEET",
                        detail: "This whole chapter compresses into one equation in Class 11: 6CO₂ + 6H₂O + light → C₆H₁₂O₆ + 6O₂. NEET tests the two stages separately — Light reactions (in thylakoids, produces ATP + NADPH) and the Calvin cycle (in stroma, fixes carbon). Knowing SLAW now makes those two stages feel obvious in five years."
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)

                    TryAtHomeCallout(
                        title: "Sun-test with a leaf",
                        detail: "Pick one healthy leaf on a houseplant. Cover half of it with kitchen foil (a small square) and leave the plant in sunlight for 3 days. Pluck the leaf, dip it in boiling water (ask a grown-up) to soften, then drop iodine on it. The UNCOVERED half turns blue-black (starch made from photosynthesis); the covered half stays brown (no sunlight = no food made). Real proof, in your kitchen."
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)

                    GotItButton {
                        onComplete()
                    }
                    .padding(.bottom, DesignTokens.Spacing.md)
                }
                .padding(.horizontal, DesignTokens.Spacing.xl)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, DesignTokens.Spacing.md)
        }
        .timedScene(idealFPS: 30, tick: $tick)
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
        let tintAlpha: Double = opacity * 0.9
        Image(systemName: "sun.max.fill")
            .font(.system(size: 22))
            .foregroundColor(Color.yellow.opacity(tintAlpha))
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
        let tintAlpha: Double = opacity * 0.85
        Image(systemName: "drop.fill")
            .font(.system(size: 16))
            .foregroundColor(Color.blue.opacity(tintAlpha))
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
        let tintAlpha: Double = opacity * 0.7
        Text("CO₂")
            .font(.system(size: 18, weight: .medium, design: .rounded))
            .foregroundColor(Color.gray.opacity(tintAlpha))
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
            .foregroundColor(DesignTokens.BrandColor.canvasText)
            .padding(.horizontal, DesignTokens.Spacing.lg)
            .padding(.vertical, 10)
            .background(
                ZStack(alignment: .bottomLeading) {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Color(NSColor.controlBackgroundColor))
                    Path { p in
                        p.move(to: CGPoint(x: 18, y: 20))
                        p.addLine(to: CGPoint(x: 6, y: 38))
                        p.addLine(to: CGPoint(x: 36, y: 22))
                        p.closeSubpath()
                    }
                    .fill(Color(NSColor.controlBackgroundColor))
                    .offset(y: 12)
                }
            )
            .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 4)
    }
}
