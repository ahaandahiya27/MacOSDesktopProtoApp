import SwiftUI

/// Scene 4 — Uneven Heating Builds Wind. Slide the equator-vs-pole temperature
/// gap; bigger gap = stronger global winds.
struct Scene4_UnevenHeating: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var gap: Double = 30

    private var windStrength: String {
        switch gap {
        case ..<15: return "Light breeze"
        case ..<30: return "Steady wind"
        case ..<45: return "Strong wind"
        default:    return "Gale"
        }
    }

    var body: some View {
        VStack(spacing: 14) {
            Text("Uneven Heating Builds Wind").font(.largeTitle.bold()).foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            Text("The Sun heats the equator more than the poles. The bigger the gap, the stronger the wind.")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary).multilineTextAlignment(.center)

            ZStack {
                RoundedRectangle(cornerRadius: 18)
                    .fill(LinearGradient(colors: [.blue.opacity(0.4), .orange.opacity(0.6), .blue.opacity(0.4)], startPoint: .top, endPoint: .bottom))
                    .frame(width: 320, height: 320)
                VStack(spacing: 60) {
                    Text("❄️ Pole").font(.title3)
                    Text("☀️ Equator").font(.title2.bold())
                    Text("❄️ Pole").font(.title3)
                }
            }

            Text("Temperature gap: \(Int(gap))°C → \(windStrength)")
                .font(.title3.weight(.semibold))
                .foregroundColor(Color.compatIndigo)

            Slider(value: $gap, in: 5...60, step: 1)
                .frame(maxWidth: 460)
                .padding(.horizontal, 24)

            SoftShadowCard(padding: 18) {
                VStack(alignment: .leading, spacing: 8) {
                    Label("Wind = Earth balancing temperature", systemImage: "globe")
                        .font(.title2.bold())
                    Text("Warm air at the equator rises and moves towards the poles. Cold polar air sinks and moves towards the equator. These huge air movements are what create monsoons, trade winds and storms.")
                        .font(.body).lineSpacing(4)
                }
            }
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            LookingAheadCallout(
                title: "Class 11 Physics → JEE",
                detail: "Class 11 Thermal Physics introduces heat transfer in three modes — conduction, convection, radiation. Wind is large-scale convection. JEE asks the Stefan-Boltzmann law (radiation: E = σT⁴) and Newton's law of cooling regularly."
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            TryAtHomeCallout(
                title: "Sun vs shade thermometer",
                detail: "Place a kitchen thermometer first in direct sunlight on the ground, then under a shaded leaf canopy. After 5 minutes you'll see a 10-15°C difference. That gap is what drives wind."
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            GotItButton { onComplete() }.padding(.bottom, 12)
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
