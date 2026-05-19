import SwiftUI

/// Scene 6 — Sundial. Slider for time of day → shadow rotates.
struct Scene6_Sundial: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var hour: Double = 12   // 6...18

    private var shadowAngle: Double { (hour - 6) * 15 - 90 }  // -90 sunrise → +90 sunset

    var body: some View {
        // Wrapped in ScrollView so the scene scrolls on
        // shorter windows and overflowing content remains accessible.
        ScrollView {
    LazyVStack(alignment: .center, spacing: 14) {
                Text("Sundial").font(.largeTitle.bold()).foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                Text("Slide through the day. Watch the shadow swing.")
                    .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)

                ZStack {
                    Circle().strokeBorder(Color.compatIndigo.opacity(0.4), lineWidth: 3)
                        .frame(width: 220, height: 220)
                    Rectangle().fill(Color.black.opacity(0.6))
                        .frame(width: 4, height: 100)
                        .offset(y: -50)
                        .rotationEffect(.degrees(shadowAngle))
                        .accessibilityLabel("Sundial shadow at \(Int(hour)) o'clock")
                    ForEach(6..<19, id: \.self) { h in
                        Text("\(h)")
                            .font(.caption)
                            .offset(y: -120)
                            .rotationEffect(.degrees(Double(h - 6) * 15 - 90))
                    }
                    Text("☀️").font(.system(size: 30)).offset(y: 110)
                }

                Text("Time: \(Int(hour)):00").font(.title3.bold()).foregroundColor(Color.compatIndigo)
                Slider(value: $hour, in: 6...18, step: 1).frame(maxWidth: 460).padding(.horizontal, 24)

                SoftShadowCard(padding: 18) {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Earth's spin is the clock", systemImage: "sun.max.fill")
                            .font(.title2.bold())
                        Text("As Earth rotates, the Sun appears to move across the sky. A stick (the gnomon) casts a shadow that sweeps in a circle. Mark hours on the circle and you have a clock. Used for over 4,000 years.")
                            .font(.body).lineSpacing(4)
                    }
                }
                .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, 24)

                LookingAheadCallout(
                    title: "Class 11 Physics + Astronomy",
                    detail: "Class 11 covers Earth's rotation, equation of time, and how a sundial's hour markings actually need adjustment by season (the analemma). JEE Astronomy questions are rare but the Earth-Sun geometry shows up in Ray Optics (apparent solar position) and time-zone problems."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)

                TryAtHomeCallout(
                    title: "Stick-shadow sundial",
                    detail: "On a sunny day, push a 30 cm straight stick vertically into a flat patch of ground. Mark the shadow's tip with a stone every hour from 9 am to 5 pm. The marks form a fan — your home-made sundial."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)

                GotItButton { onComplete() }.padding(.bottom, 12)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
        }
    }
}
