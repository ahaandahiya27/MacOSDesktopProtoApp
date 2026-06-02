import SwiftUI

/// Scene 8 — Anemometer Reader. Spin rate (slider) maps to a wind-speed reading.
struct Scene8_AnemometerReader: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var rpm: Double = 30
    @State private var rotation: Double = 0
    @State private var tick: TimeInterval = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var kmh: Double { rpm * 0.5 }

    var body: some View {
        // Wrapped in ScrollView so the scene scrolls on
        // shorter windows and overflowing content remains accessible.
        ScrollView {
            LazyVStack(alignment: .center, spacing: 14) {
                Text("Anemometer Reader").font(.largeTitle.bold()).foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                Text("Slide to spin the cups. Faster spin = stronger wind.")
                    .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)

                ZStack {
                    Circle().fill(Color.white.opacity(0.95)).frame(width: 240, height: 240)
                    ForEach(0..<3, id: \.self) { i in
                        Text("🥣")
                            .font(.system(size: 36))
                            .offset(x: 90)
                            .rotationEffect(.degrees(Double(i) * 120))
                    }
                    Circle().fill(Color.compatIndigo).frame(width: 14, height: 14)
                }
                .rotationEffect(.degrees(rotation))
                .onChange(of: tick) { _ in
                    guard !reduceMotion else { return }
                    rotation = (rotation + rpm * 0.3).truncatingRemainder(dividingBy: 360)
                }
                .timedScene(idealFPS: 30, tick: $tick)

                Text("\(Int(rpm)) rpm  ≈  \(Int(kmh)) km/h")
                    .font(.system(size: 30, weight: .bold, design: .monospaced))
                    .foregroundColor(Color.compatIndigo)

                Slider(value: $rpm, in: 0...200, step: 1)
                    .frame(maxWidth: 460)
                    .padding(.horizontal, 24)

                SoftShadowCard(padding: 18) {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Cups catch the wind", systemImage: SFSymbolCompat.name("gauge.medium"))
                            .font(.title2.bold())
                        Text("An anemometer measures wind speed. Three or four cups catch the breeze and rotate. The rotation rate is converted to km/h. Weather stations report this every few minutes.")
                            .font(.body).lineSpacing(4)
                    }
                }
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)

                LookingAheadCallout(
                    title: "Class 11 Physics → JEE",
                    detail: "Class 11 Physics covers angular speed, ω = v/r, and how rpm links to SI units. JEE sets rotational problems on spinning bodies — centripetal force and angular momentum — using just this kind of cup-and-radius setup."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)

                TryAtHomeCallout(
                    title: "Paper-cup anemometer",
                    detail: "Tape 4 small paper cups onto cross-shaped sticks pinned at the centre to a pencil. Mark one cup red. Hold it outside on a windy day and count rotations of the red cup in 30 seconds. That's your wind speed in 'cups per half-minute'."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)

                GotItButton { onComplete() }.padding(.bottom, 12)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
