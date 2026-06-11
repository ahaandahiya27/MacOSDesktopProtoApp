import SwiftUI

/// Scene 2 — The Swallow Wave.
///
/// A vertical tube (oesophagus) drawn with rounded rectangles. Tap "Swallow!"
/// and a food bolus animates downward in a peristaltic squeeze pattern. Speed
/// slider 0.5× to 2×. Caption from ch02_t01_c07.
/// Big Sur (macOS 11) compatible — OesophagusView and the bolus marker
/// now use stacked RoundedRectangle shapes instead of two Canvas blocks.
struct Scene2_TheSwallowWave: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var isBolus = false
    @State private var bolusPosition: CGFloat = 0
    @State private var speed: Double = 1.0
    @State private var squeeze: CGFloat = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var swallowExplanation: String {
        pack.conceptIndex["ch02_t01_c07"]?.explanation(at: .kidFriendly)
            ?? "When you swallow, muscles in your oesophagus squeeze in waves to push food down to your stomach."
    }

    var body: some View {

        ScrollView {

            VStack(spacing: 14) {
                Text("The Swallow Wave")
                    .font(.title.bold())
                    .foregroundColor(Color.compatIndigo)

                ZStack {
                    OesophagusView(bolusPosition: bolusPosition, squeeze: squeeze)
                        .frame(width: 100, height: 300)

                    if isBolus {
                        // Brown food bolus marker (was Canvas) — positioned by
                        // bolusPosition (0...1) inside the 100x300 oesophagus.
                        let bolusY: CGFloat = 50 + bolusPosition * 200
                        RoundedRectangle(cornerRadius: DesignTokens.Radius.sm)
                            .fill(Color.compatBrown.opacity(0.8))
                            .frame(width: 40, height: 30)
                            .position(x: 50, y: bolusY)
                            .frame(width: 100, height: 300, alignment: .topLeading)
                    }
                }

                HStack(spacing: DesignTokens.Spacing.lg) {
                    Button(action: { swallow() }) {
                        Label("Swallow!", systemImage: SFSymbolCompat.name("arrowshape.down.fill"))
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                    }
                    
                    .accentColor(.green)
                    .disabled(isBolus)

                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                        HStack {
                            Text("Speed: \(String(format: "%.1f", speed))×")
                                .font(.caption)

                        }
                        Slider(value: $speed, in: 0.5...2.0, step: 0.1)
                    }
                    .frame(maxWidth: 150)
                }
                .padding(.horizontal, DesignTokens.Spacing.xl)

                SoftShadowCard(padding: 18) {
                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                        Label("The Swallow Wave", systemImage: "arrow.down.circle.fill")
                            .font(.title2.bold())
                            .foregroundColor(.green)
                        Text(swallowExplanation)
                            .font(.body)
                            .foregroundColor(DesignTokens.BrandColor.canvasText)
                            .lineSpacing(4)
                    }
                }
                .frame(maxWidth: DesignTokens.contentMaxWidth)

                LookingAheadCallout(
                    title: "Class 11 Biology → NEET",
                    detail: "Peristalsis is smooth-muscle physiology. The circular and longitudinal muscle layers of the oesophagus tighten and relax in turn to push food along. NEET loves one question: why can astronauts swallow upside-down in zero gravity? Because peristalsis does not need gravity. It pushes food along mechanically, whichever way you face."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, DesignTokens.Spacing.xl)

                TryAtHomeCallout(
                    title: "Swallow while hanging upside down",
                    detail: "(With supervision!) Hang your head off the edge of a bed so it's lower than your feet. Take a small sip of water and swallow. It still reaches your stomach — peristalsis works against gravity. Same trick gives giraffes their absurd neck and astronauts their lunch in space."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, DesignTokens.Spacing.xl)

                GotItButton { onComplete() }
                    .padding(.bottom, DesignTokens.Spacing.md)
            

            }

            .frame(maxWidth: .infinity)

            .padding(.bottom, DesignTokens.Spacing.md)

        }
    }

    private func swallow() {
        isBolus = true
        bolusPosition = 0
        squeeze = 0

        let duration = 2.0 / speed
        withAnimation(reduceMotion ? .none : .easeInOut(duration: duration)) {
            bolusPosition = 1.0
        }

        // Squeeze wave
        if !reduceMotion {
            Task { @MainActor in
                for i in 0..<5 {
                    try? await Task.sleep(nanoseconds: 150_000_000)
                    withAnimation(.easeInOut(duration: 0.3)) {
                        squeeze = CGFloat(i) * 0.2
                    }
                }
            }
        }

        Task { @MainActor in
            try? await Task.sleep(nanoseconds: UInt64((duration + 0.3) * 1_000_000_000))
            isBolus = false
            bolusPosition = 0
            squeeze = 0
        }
    }
}

// MARK: - Oesophagus View

/// Oesophagus rendered as 10 stacked RoundedRectangle segments. The
/// `squeeze` parameter (0...1) defines where the peristaltic wave is —
/// segments near that position narrow to simulate the muscle squeeze.
/// Geometry identical to the old Canvas implementation.
struct OesophagusView: View {
    let bolusPosition: CGFloat
    let squeeze: CGFloat

    private let tubeX: CGFloat = 25
    private let tubeWidth: CGFloat = 50
    private let tubeHeight: CGFloat = 300
    private let segmentCount = 10

    var body: some View {
        ZStack(alignment: .topLeading) {
            ForEach(0..<segmentCount, id: \.self) { i in
                let y: CGFloat = CGFloat(i) * (tubeHeight / CGFloat(segmentCount))
                let segH: CGFloat = tubeHeight / CGFloat(segmentCount)
                let squeezePos: CGFloat = squeeze * CGFloat(segmentCount)
                let dist: CGFloat = abs(CGFloat(i) - squeezePos)
                let squeezeAt: CGFloat = dist < 2 ? max(0, 1 - dist / 2) * 8 : 0
                let w: CGFloat = max(20, tubeWidth - squeezeAt)
                let segX: CGFloat = tubeX + tubeWidth / 2
                let segY: CGFloat = y + segH / 2
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 2)
                    .frame(width: w, height: segH)
                    .position(x: segX, y: segY)
            }
        }
    }
}
