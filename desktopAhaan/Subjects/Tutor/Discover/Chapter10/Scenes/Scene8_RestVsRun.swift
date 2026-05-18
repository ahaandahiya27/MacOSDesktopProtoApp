import SwiftUI

/// Scene 8 — Rest vs Run. Slider for activity level → breaths per minute.
struct Scene8_RestVsRun: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var activity: Double = 0   // 0=sleep, 1=sit, 2=walk, 3=run, 4=sprint
    @State private var runSpeedKMH: Double = 6   // free-play: a different angle — heart rate vs running speed

    private var bpm: Int {
        let table = [12, 16, 22, 35, 55]
        return table[Int(activity)]
    }
    private var label: String {
        let table = ["💤 Sleeping", "🪑 Sitting", "🚶 Walking", "🏃 Running", "⚡ Sprinting"]
        return table[Int(activity)]
    }

    var body: some View {
        // Wrapped in ScrollView so the scene scrolls on
        // shorter windows and overflowing content remains accessible.
        ScrollView {
    VStack(spacing: 14) {
                Text("Rest vs Run").font(.largeTitle.bold()).foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                Text("Slide the activity level. Watch breathing speed up.")
                    .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)

                ZStack {
                    Circle().strokeBorder(Color.compatIndigo.opacity(0.5), lineWidth: 6)
                        .frame(width: 200, height: 200)
                    VStack {
                        Text(label).font(.title3.bold())
                        Text("\(bpm)").font(.system(size: 48, weight: .bold, design: .monospaced))
                            .foregroundColor(Color.compatIndigo)
                        Text("breaths / min").font(.caption).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    }
                }

                Slider(value: $activity, in: 0...4, step: 1).frame(maxWidth: 460).padding(.horizontal, 24)
                HStack {
                    Text("💤").font(.title3); Spacer(); Text("🪑").font(.title3); Spacer()
                    Text("🚶").font(.title3); Spacer(); Text("🏃").font(.title3); Spacer(); Text("⚡").font(.title3)
                }
                .frame(maxWidth: 460).padding(.horizontal, 24)

                SoftShadowCard(padding: 18) {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("More activity, more oxygen", systemImage: SFSymbolCompat.name("figure.run"))
                            .font(.title2.bold())
                        Text("Running muscles burn glucose faster, so they demand more oxygen. Your brain tells the lungs to pump quicker and deeper. After exercise, deep breaths repay the oxygen debt that built up.")
                            .font(.body).lineSpacing(4)
                    }
                }
                .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, 24)

                // Grouped to stay within Swift 5.5's 10-child ViewBuilder limit.
                Group {
                    LookingAheadCallout(
                        title: "Class 11 Bio → NEET",
                        detail: "Class 11 'Breathing' covers rate of breathing (12-16/min rest, up to 60/min exercise), tidal volume, vital capacity, residual volume. NEET asks lung-volume capacity questions every year. Class 12 adds asthma, emphysema, oxygen debt physiology."
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                    .padding(.horizontal, 24)

                    TryAtHomeCallout(
                        title: "Rest vs stair run",
                        detail: "Count breaths/min sitting still. Then run up and down a flight of stairs 3 times. Count again immediately. The rate doubles or triples — your muscles demanded more oxygen."
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                    .padding(.horizontal, 24)
                }

                DiscoveryWidget(
                    title: "Discovery — heart rate vs running speed",
                    subtitle: "A normal child's resting heart rate is ~80 bpm. Drag the speed to see how fast the heart works at each pace.",
                    value: $runSpeedKMH,
                    range: 0...20,
                    step: 0.5,
                    valueLabel: { v in String(format: "Speed: %.1f km/h", v) },
                    output: runningHeartRateExplanation
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)

                GotItButton { onComplete() }.padding(.bottom, 12)
                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
        }

        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func runningHeartRateExplanation(_ kmh: Double) -> String {
        // Rough model: 80 bpm resting + ~6 bpm per km/h above zero.
        let hr = Int(80 + kmh * 6)
        let label: String
        switch kmh {
        case ..<1:
            label = "Standing still — your heart ticks along at baseline."
        case ..<5:
            label = "Casual walk. Heart rate barely lifts."
        case ..<9:
            label = "Brisk walk / light jog — comfortable warm-up pace."
        case ..<14:
            label = "Steady running. Sustainable for several minutes if trained."
        default:
            label = "Near-sprint! Heart and lungs at near-maximum — not sustainable for more than a minute or two."
        }
        return "Estimated heart rate ≈ \(hr) bpm. \(label)"
    }
}
