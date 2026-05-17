import SwiftUI

/// Scene 1 — Hot Air Rises. Tap a flame under a balloon; the balloon rises
/// as the air inside heats and expands (becomes less dense).
struct Scene1_HotAirRises: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var flameOn = false
    @State private var balloonY: CGFloat = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        VStack(spacing: 14) {
            Text("Hot Air Rises").font(.largeTitle.bold()).foregroundColor(ChapterTheme.accent(for: chapter.id)).padding(.top, 18)
            Text("Tap the flame to heat the air inside the balloon.")
                .font(.callout).foregroundColor(.secondary)

            ZStack {
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color.blue.opacity(0.08))
                    .frame(width: 320, height: 320)

                Text("🎈")
                    .font(.system(size: 96))
                    .offset(y: balloonY)
                    .animation(reduceMotion ? .none : .easeOut(duration: 1.2), value: balloonY)
                    .accessibilityLabel(flameOn ? "Hot-air balloon rising" : "Hot-air balloon at rest")

                VStack {
                    Spacer()
                    Text(flameOn ? "🔥" : "🪵")
                        .font(.system(size: 44))
                        .padding(.bottom, 18)
                }
                .frame(width: 320, height: 320)
            }
            .onTapGesture {
                flameOn.toggle()
                balloonY = flameOn ? -110 : 0
            }
            .accessibilityLabel(flameOn ? "Flame on, balloon rising" : "Flame off")

            Button(flameOn ? "Turn flame off" : "Light the flame") {
                flameOn.toggle()
                balloonY = flameOn ? -110 : 0
            }
            .accentColor(Color.compatIndigo)

            SoftShadowCard(padding: 18) {
                VStack(alignment: .leading, spacing: 8) {
                    Label("Less dense = floats up", systemImage: "flame.fill")
                        .font(.title2.bold())
                    Text("Heating makes air molecules spread out. Warmer air is lighter than the cool air around it, so it rises. Cooler air rushes in to take its place — that movement is wind.")
                        .font(.body).lineSpacing(4)
                }
            }
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            LookingAheadCallout(
                title: "Class 11 Physics → JEE",
                detail: "Class 11 covers density (ρ = m/V) and Archimedes' principle — the same physics that lifts a hot-air balloon also makes ships float. JEE Physics asks buoyancy and pressure problems using ρgh on fluids every year."
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            GotItButton { onComplete() }.padding(.bottom, 12)
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
