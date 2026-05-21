import SwiftUI

/// Scene 1 — Hot Air Rises. Tap a flame under a balloon; the balloon rises
/// as the air inside heats and expands (becomes less dense).
struct Scene1_HotAirRises: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var flameOn = false
    @State private var balloonY: CGFloat = 0
    @State private var deltaT: Double = 30          // free-play: balloon-air vs outside-air ΔT in °C
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        // Wrapped in ScrollView so the scene scrolls on
        // shorter windows and overflowing content remains accessible.
        ScrollView {
    LazyVStack(alignment: .center, spacing: 14) {
                Text("Hot Air Rises").font(.largeTitle.bold()).foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                Text("Tap the flame to heat the air inside the balloon.")
                    .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)

                ZStack {
                    RoundedRectangle(cornerRadius: 18)
                        .fill(Color.blue.opacity(0.08))
                        .frame(width: 320, height: 320)

                    Text("🎈")
                        .font(.system(size: 96))
                        .offset(y: balloonY)
                        .animation(reduceMotion ? .none : .easeOut(duration: 1.2))
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

                // Grouped to stay within Swift 5.5's 10-child ViewBuilder limit
                // (Big Sur / Xcode 13.2.1 target).
                Group {
                    LookingAheadCallout(
                        title: "Class 11 Physics → JEE",
                        detail: "Class 11 covers density (ρ = m/V) and Archimedes' principle — the same physics that lifts a hot-air balloon also makes ships float. JEE Physics asks buoyancy and pressure problems using ρgh on fluids every year."
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                    .padding(.horizontal, 24)

                    TryAtHomeCallout(
                        title: "Hold paper above a candle",
                        detail: "Cut a paper spiral, balance it on a pencil tip, and hold it well ABOVE a candle flame (not in it). The rising hot air spins the spiral. Do this with an adult present."
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                    .padding(.horizontal, 24)

                    RelatedConceptsCallout(
                        title: "Related: Ch 4 (Heat), Ch 6 (Phys/Chem Changes)",
                        detail: "The reason hot air rises — thermal expansion — is part of the bigger heat-transfer story in Ch 4 (conduction, convection, radiation). And Ch 6 covers how heat drives state changes (ice → water → steam) using the same physics."
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                    .padding(.horizontal, 24)
                }

                DiscoveryWidget(
                    title: "Discovery — how hot to lift the balloon?",
                    subtitle: "Hot-air balloons fly when the air inside is hotter than the air outside. Drag the temperature difference.",
                    value: $deltaT,
                    range: 0...100,
                    step: 5,
                    valueLabel: { v in String(format: "ΔT: %.0f °C", v) },
                    output: balloonLiftExplanation
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

    private func balloonLiftExplanation(_ dT: Double) -> String {
        // Lift ∝ ΔT for gas expansion at constant pressure (ideal-gas approx).
        // Reference: ~100°C ΔT lifts a real hot-air balloon.
        switch dT {
        case ..<10:
            return "Almost no lift. Balloon stays on the ground. Hot-air ballooning needs much bigger temperature gaps."
        case ..<35:
            return "Small lift. A paper bag warmed by a candle floats up briefly — same idea, tiny scale."
        case ..<70:
            return "Real hot-air balloon territory. Modern balloons fly with their inside air ~50–60°C above ambient."
        default:
            return "Maximum lift. Push much hotter and you risk damaging the balloon fabric (rip-stop nylon melts beyond ~120°C)."
        }
    }
}
