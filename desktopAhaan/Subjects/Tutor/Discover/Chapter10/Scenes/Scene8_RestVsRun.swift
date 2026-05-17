import SwiftUI

/// Scene 8 — Rest vs Run. Slider for activity level → breaths per minute.
struct Scene8_RestVsRun: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var activity: Double = 0   // 0=sleep, 1=sit, 2=walk, 3=run, 4=sprint

    private var bpm: Int {
        let table = [12, 16, 22, 35, 55]
        return table[Int(activity)]
    }
    private var label: String {
        let table = ["💤 Sleeping", "🪑 Sitting", "🚶 Walking", "🏃 Running", "⚡ Sprinting"]
        return table[Int(activity)]
    }

    var body: some View {
        VStack(spacing: 14) {
            Text("Rest vs Run").font(.largeTitle.bold()).foregroundColor(ChapterTheme.accent(for: chapter.id)).padding(.top, 18)
            Text("Slide the activity level. Watch breathing speed up.")
                .font(.callout).foregroundColor(.secondary)

            ZStack {
                Circle().strokeBorder(Color.compatIndigo.opacity(0.5), lineWidth: 6)
                    .frame(width: 200, height: 200)
                VStack {
                    Text(label).font(.title3.bold())
                    Text("\(bpm)").font(.system(size: 48, weight: .bold, design: .monospaced))
                        .foregroundColor(Color.compatIndigo)
                    Text("breaths / min").font(.caption).foregroundColor(.secondary)
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
                    Label("More activity, more oxygen", systemImage: "figure.run")
                        .font(.title2.bold())
                    Text("Running muscles burn glucose faster, so they demand more oxygen. Your brain tells the lungs to pump quicker and deeper. After exercise, deep breaths repay the oxygen debt that built up.")
                        .font(.body).lineSpacing(4)
                }
            }
            .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, 24)

            LookingAheadCallout(
                title: "Class 11 Bio → NEET",
                detail: "Class 11 'Breathing' covers rate of breathing (12-16/min rest, up to 60/min exercise), tidal volume, vital capacity, residual volume. NEET asks lung-volume capacity questions every year. Class 12 adds asthma, emphysema, oxygen debt physiology."
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            GotItButton { onComplete() }.padding(.bottom, 12)
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
