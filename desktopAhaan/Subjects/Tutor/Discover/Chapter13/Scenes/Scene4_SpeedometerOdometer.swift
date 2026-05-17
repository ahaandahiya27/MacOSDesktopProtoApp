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
        VStack(spacing: 14) {
            Text("Speedometer & Odometer").font(.largeTitle.bold()).padding(.top, 18)
            Text("Speedometer = current speed. Odometer = total distance.")
                .font(.callout).foregroundColor(.secondary)

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
                        .padding(8)
                        .background(RoundedRectangle(cornerRadius: 8).fill(Color.black))
                        .foregroundColor(.green)
                    Text("km").font(.caption)
                }
            }
            .onChange(of: tick) { _ in
                guard !reduceMotion else { return }
                odometer += speed / 60.0 / 60.0
            }
            .timedScene(idealFPS: 30, tick: $tick)

            Slider(value: $speed, in: 0...160, step: 1).frame(maxWidth: 460).padding(.horizontal, 24)

            SoftShadowCard(padding: 18) {
                VStack(alignment: .leading, spacing: 8) {
                    Label("Two instruments, two stories", systemImage: "speedometer")
                        .font(.title2.bold())
                    Text("The speedometer tells you how fast you're going right now. The odometer is a counter that adds up every km you've ever driven. Same gearbox, different jobs.")
                        .font(.body).lineSpacing(4)
                }
            }
            .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, 24)

            GotItButton { onComplete() }.padding(.bottom, 12)
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
