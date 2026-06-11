import SwiftUI

/// Scene 2 — Pulse Counter. 15-second tap-count → BPM estimate.
struct Scene2_PulseCounter: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var counting = false
    @State private var taps = 0
    @State private var secondsLeft = 15
    @State private var bpm: Int? = nil
    @State private var runID: UUID = UUID()

    var body: some View {
        // Wrapped in ScrollView so the scene scrolls on
        // shorter windows and overflowing content remains accessible.
        ScrollView {
            LazyVStack(alignment: .center, spacing: 14) {
                Text("Pulse Counter").font(.largeTitle.bold()).foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                Text("Press Start. Tap the heart with every pulse for 15 seconds.")
                    .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary).multilineTextAlignment(.center)

                if counting {
                    Text("\(secondsLeft)s")
                        .font(.system(size: 48, weight: .bold, design: .monospaced))
                        .foregroundColor(Color.compatIndigo)
                } else if let bpm = bpm {
                    Text("Your pulse: \(bpm) BPM")
                        .font(.title2.bold())
                        .foregroundColor(.green)
                }

                Text("❤️")
                    .font(.system(size: 96))
                    .onTapGesture { if counting { taps += 1 } }
                    .accessibilityLabel("Tap with every pulse")

                Text(counting ? "Taps so far: \(taps)" : " ")
                    .font(.headline.monospacedDigit())
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)

                HStack(spacing: DesignTokens.Spacing.lg) {
                    Button(counting ? "Counting…" : "Start 15s") {
                        counting = true
                        taps = 0
                        secondsLeft = 15
                        bpm = nil
                        let token = UUID()
                        runID = token
                        tick(token: token)
                    }
                    .accentColor(Color.compatIndigo)
                    .disabled(counting)

                    Button("Reset") {
                        counting = false
                        runID = UUID()         // invalidate any pending tick
                        taps = 0
                        bpm = nil
                        secondsLeft = 15
                    }
                }

                SoftShadowCard(padding: 14) {
                    Text("Resting pulse for kids is usually 70–100 BPM. After exercise it climbs above 120. Athletes can dip below 60 because their hearts pump more blood per beat.")
                        .font(.callout).lineSpacing(4)
                }
                .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, DesignTokens.Spacing.xl)

                TryAtHomeCallout(
                    title: "Find your real pulse",
                    detail: "Press two fingers (not the thumb) on the inside of your wrist, below the base of the thumb. Count the beats for 15 seconds. Multiply by 4 to get your beats-per-minute."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, DesignTokens.Spacing.xl)

                GotItButton { onComplete() }.padding(.bottom, DesignTokens.Spacing.md)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, DesignTokens.Spacing.md)
        }

        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onDisappear { runID = UUID() }
    }

    /// `token` is captured at start of run. On each tick we compare to the
    /// current `runID`: if the user hit Reset or left the scene, the token
    /// no longer matches and we bail out without re-arming.
    private func tick(token: UUID) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            guard token == runID, counting else { return }
            secondsLeft -= 1
            if secondsLeft <= 0 {
                counting = false
                bpm = taps * 4
            } else {
                tick(token: token)
            }
        }
    }
}
