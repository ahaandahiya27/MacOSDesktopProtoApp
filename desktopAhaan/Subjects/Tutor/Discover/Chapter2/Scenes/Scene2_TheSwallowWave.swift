import SwiftUI

/// Scene 2 — The Swallow Wave.
///
/// A vertical tube (oesophagus) drawn with rounded rectangles. Tap "Swallow!"
/// and a food bolus animates downward in a peristaltic squeeze pattern. Speed
/// slider 0.5× to 2×. Caption from ch02_t01_c07.
@available(macOS 12, *)
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
        GeometryReader { geo in
            VStack(spacing: 20) {
                Text("The Swallow Wave")
                    .font(.title.bold())
                    .foregroundColor(Color.compatIndigo)

                ZStack {
                    OesophagusView(bolusPosition: bolusPosition, squeeze: squeeze)
                        .frame(width: 100, height: 300)

                    if isBolus {
                        Canvas { context, _ in
                            let centerX = 50.0
                            let y = 50 + bolusPosition * 200
                            let rect = CGRect(x: centerX - 20, y: y - 15, width: 40, height: 30)
                            context.fill(
                                Path(roundedRect: rect, cornerRadius: 8),
                                with: .color(.brown.opacity(0.8))
                            )
                        }
                        .frame(width: 100, height: 300)
                    }
                }

                HStack(spacing: 16) {
                    Button(action: { swallow() }) {
                        Label("Swallow!", systemImage: "arrowshape.down.fill")
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                    }
                    
                    .accentColor(.green)
                    .disabled(isBolus)

                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("Speed: \(String(format: "%.1f", speed))×")
                                .font(.caption)
                            Spacer()
                        }
                        Slider(value: $speed, in: 0.5...2.0, step: 0.1)
                    }
                    .frame(maxWidth: 150)
                }
                .padding(.horizontal, 24)

                Spacer()

                SoftShadowCard(padding: 18) {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("The Swallow Wave", systemImage: "arrow.down.circle.fill")
                            .font(.title2.bold())
                            .foregroundColor(.green)
                        Text(swallowExplanation)
                            .font(.body)
                            .foregroundColor(.primary)
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

@available(macOS 12, *)
struct OesophagusView: View {
    let bolusPosition: CGFloat
    let squeeze: CGFloat

    var body: some View {
        Canvas { context, _ in
            let tubeX = 25.0
            let tubeWidth = 50.0
            let tubeHeight = 300.0

            // Draw segments of the tube with squeeze effect
            for i in 0..<10 {
                let y = CGFloat(i) * (tubeHeight / 10)
                let segmentHeight = tubeHeight / 10

                // Calculate squeeze at this segment
                let squeezeAtSegment: CGFloat
                let squeezePos = squeeze * 10
                let dist = abs(CGFloat(i) - squeezePos)
                if dist < 2 {
                    squeezeAtSegment = max(0, 1 - dist / 2) * 8
                } else {
                    squeezeAtSegment = 0
                }

                let width = max(20, tubeWidth - squeezeAtSegment)
                let rect = CGRect(
                    x: tubeX + (tubeWidth - width) / 2,
                    y: y,
                    width: width,
                    height: segmentHeight
                )
                context.stroke(
                    Path(roundedRect: rect, cornerRadius: 4),
                    with: .color(.gray.opacity(0.5)),
                    lineWidth: 2
                )
            }
        }
    }
}
