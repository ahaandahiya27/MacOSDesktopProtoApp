import SwiftUI

/// Scene 3 — Heating Effect. Slider for current; nichrome wire glows red.
struct Scene3_HeatingEffect: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var current: Double = 0

    private var glowColor: Color {
        if current < 2 { return Color.gray.opacity(0.5) }
        if current < 5 { return Color.orange }
        return Color.red
    }
    private var glowLabel: String {
        if current < 2 { return "Cool" }
        if current < 5 { return "Warm" }
        if current < 8 { return "Hot — orange glow" }
        return "Very hot — red glow"
    }

    var body: some View {
        // Wrapped in ScrollView so the scene scrolls on
        // shorter windows and overflowing content remains accessible.
        ScrollView {
            LazyVStack(alignment: .center, spacing: 14) {
                Text("Heating Effect").font(.largeTitle.bold()).foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                Text("Current flowing through a wire heats it up.").font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)

                ZStack {
                    Capsule().fill(glowColor.opacity(0.3))
                        .frame(width: 280, height: 12)
                    Capsule().fill(glowColor)
                        .frame(width: 280, height: 6)
                }
                .shadow(color: glowColor.opacity(current / 10), radius: CGFloat(current * 2))

                Text("Current: \(String(format: "%.1f", current)) A — \(glowLabel)")
                    .font(.headline).foregroundColor(glowColor)

                Slider(value: $current, in: 0...10, step: 0.1).frame(maxWidth: 460).padding(.horizontal, 24)

                SoftShadowCard(padding: 18) {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Why electric heaters work", systemImage: "flame.fill")
                            .font(.title2.bold())
                        Text("Resistance turns electrical energy into heat. Nichrome wire has high resistance — perfect for heaters, toasters, irons and fuses. The more current that flows, the hotter it gets.")
                            .font(.body).lineSpacing(4)
                    }
                }
                .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, 24)

                TryAtHomeCallout(
                    title: "Feel the kettle and the bulb",
                    detail: "Carefully feel an electric kettle while it's running — but only the body, never the steaming spout. Then turn on an old incandescent bulb (not LED) for a minute and feel the glass with the back of your hand from a safe distance. Both convert electrical energy into heat — the kettle is designed to do it, the bulb does it as a waste product."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)

                LookingAheadCallout(
                    title: "Class 10 → JEE",
                    detail: "Class 10 introduces Joule's heating law: heat produced H = I²Rt. That's why a kettle uses a thick wire (low R) but very high current, while the same wire material in a thin nichrome heater coil (high R) gets red-hot. JEE Physics asks tricky H = I²Rt problems on series vs parallel power dissipation every year."
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
}
