import SwiftUI

/// Scene 4 — Speedometer & Odometer. Slider for speed, odometer ticks up.
struct Scene4_SpeedometerOdometer: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var speed: Double = 0
    @State private var odometer: Double = 12345
    @State private var tick: TimeInterval = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        // Wrapped in ScrollView so the scene scrolls on
        // shorter windows and overflowing content remains accessible.
        ScrollView {
            LazyVStack(alignment: .center, spacing: 14) {
                Text("Speedometer & Odometer").font(.largeTitle.bold()).foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                Text("Speedometer = current speed. Odometer = total distance.")
                    .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)

                HStack(spacing: 30) {
                    VStack {
                        ZStack {
                            Circle().strokeBorder(Color.compatIndigo, lineWidth: 4).frame(width: 160, height: 160)
                            Text("\(Int(speed))")
                                .font(.system(size: 48, weight: .bold, design: .monospaced))
                                .foregroundColor(Color.compatIndigo)
                        }
                        Text("km/h").font(.caption)
                    }
                    VStack {
                        Text(String(format: "%07.0f", odometer))
                            .font(.system(size: 32, weight: .bold, design: .monospaced))
                            .padding(DesignTokens.Spacing.sm)
                            .background(RoundedRectangle(cornerRadius: DesignTokens.Radius.sm).fill(Color.black))
                            .foregroundColor(.green)
                        Text("km").font(.caption)
                    }
                }
                .onChange(of: tick) { _ in
                    guard !reduceMotion else { return }
                    odometer += speed / 60.0 / 60.0
                }
                .timedScene(idealFPS: 30, tick: $tick)

                Slider(value: $speed, in: 0...160, step: 1).frame(maxWidth: 460).padding(.horizontal, DesignTokens.Spacing.xl)

                SoftShadowCard(padding: 18) {
                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                        Label("Two instruments, two stories", systemImage: "speedometer")
                            .font(.title2.bold())
                        Text("The speedometer tells you how fast you're going right now. The odometer is a counter that adds up every km you've ever driven. Same gearbox, different jobs.")
                            .font(.body).lineSpacing(4)
                    }
                }
                .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, DesignTokens.Spacing.xl)

                TryAtHomeCallout(
                    title: "Read a real odometer",
                    detail: "Next car ride, look at the odometer before you start and again when you reach your destination. Subtract → that's the distance covered. Divide by the time taken → that's your average speed. The needle on the speedometer was showing instantaneous speed."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, DesignTokens.Spacing.xl)

                LookingAheadCallout(
                    title: "Class 11 Physics → JEE",
                    detail: "In Class 11 'Motion in a Straight Line' you sharpen average vs instantaneous speed. The speedometer reads instantaneous speed; the odometer divided by time gives the average. JEE Kinematics adds calculus: instantaneous speed = ds/dt."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, DesignTokens.Spacing.xl)

                GotItButton { onComplete() }.padding(.bottom, DesignTokens.Spacing.md)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, DesignTokens.Spacing.md)
        }
    }
}
