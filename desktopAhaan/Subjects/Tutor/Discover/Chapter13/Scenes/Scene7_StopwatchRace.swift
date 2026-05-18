import SwiftUI

/// Scene 7 — Stopwatch Race. Tap Start, then Stop. Estimate vs actual.
/// Uses wall-clock `Date()` for accurate elapsed time instead of accumulating
/// tick deltas (which drift).
struct Scene7_StopwatchRace: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var running = false
    @State private var startedAt: Date? = nil
    @State private var elapsed: Double = 0
    @State private var tick: TimeInterval = 0
    @State private var lastResult: Double? = nil
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        VStack(spacing: 14) {
            Text("Stopwatch Race").font(.largeTitle.bold()).foregroundColor(ChapterTheme.accent(for: chapter.id)).padding(.top, 18)
            Text("Can you stop the watch at exactly 5.00 seconds?")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)

            Text(String(format: "%.2f s", elapsed))
                .font(.system(size: 56, weight: .bold, design: .monospaced))
                .foregroundColor(running ? Color.compatIndigo : .secondary)

            HStack(spacing: 16) {
                Button(running ? "Stop" : "Start") {
                    if running {
                        running = false
                        if let s = startedAt {
                            elapsed = Date().timeIntervalSince(s)
                        }
                        lastResult = elapsed
                        startedAt = nil
                    } else {
                        elapsed = 0
                        startedAt = Date()
                        running = true
                    }
                }
                .accentColor(Color.compatIndigo)
                Button("Reset") {
                    running = false
                    elapsed = 0
                    lastResult = nil
                    startedAt = nil
                }
            }
            .onChange(of: tick) { _ in
                guard running, let s = startedAt else { return }
                elapsed = Date().timeIntervalSince(s)
            }
            .timedScene(idealFPS: 30, tick: $tick)

            if let r = lastResult {
                let diff = abs(r - 5.0)
                Text(String(format: "Off by %.2f s — %@", diff, diff < 0.2 ? "great!" : (diff < 0.6 ? "close" : "try again")))
                    .font(.headline)
                    .foregroundColor(diff < 0.6 ? .green : .orange)
            }

            SoftShadowCard(padding: 14) {
                Text("A stopwatch measures very short time intervals — useful for races, science experiments, and reaction-time tests. Digital stopwatches today resolve milliseconds.")
                    .font(.callout).lineSpacing(4)
            }
            .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, 24)

            LookingAheadCallout(
                title: "Class 11 Physics → JEE",
                detail: "Class 11 'Units and Measurements' introduces measurement precision and significant figures. JEE Physics expects sig-fig discipline in numerical answers, and Class 12 Modern Physics uses the atomic clock as the definition of one second (9,192,631,770 cycles of Cs-133)."
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            TryAtHomeCallout(
                title: "Reaction-time game",
                detail: "Have a friend hold a ruler vertically with the 0-mark down. Place your fingers just below the 0 mark, ready to catch. They drop the ruler without warning. Note where you catch it. Use t = √(2d/g) → d in cm gives reaction time in seconds (≈ 0.1-0.2 s)."
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            GotItButton { onComplete() }.padding(.bottom, 12)
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
