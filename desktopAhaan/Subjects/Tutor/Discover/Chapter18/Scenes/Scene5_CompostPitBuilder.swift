import SwiftUI

/// Scene 5 — Compost Pit Builder. Add layers, watch waste turn into compost.
struct Scene5_CompostPitBuilder: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var greens = false
    @State private var browns = false
    @State private var moisture = false
    @State private var weeks: Double = 0

    private var ready: Bool { greens && browns && moisture && weeks >= 6 }

    var body: some View {
        // Wrapped in ScrollView so the scene scrolls on
        // shorter windows and overflowing content remains accessible.
        ScrollView {
    LazyVStack(alignment: .center, spacing: 14) {
                Text("Compost Pit Builder").font(.largeTitle.bold()).foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                Text("Add greens, browns, moisture — then wait 6+ weeks.")
                    .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)

                ZStack {
                    RoundedRectangle(cornerRadius: 16).fill(Color.compatBrown.opacity(0.3))
                        .frame(width: 240, height: 180)
                    VStack(spacing: 4) {
                        if greens   { Text("🥬").font(.system(size: 30)) }
                        if browns   { Text("🍂").font(.system(size: 30)) }
                        if moisture { Text("💧").font(.system(size: 30)) }
                        if ready    { Text("🟫 Compost ready!").font(.headline).foregroundColor(.green) }
                    }
                }

                VStack(spacing: 8) {
                    Toggle("Add kitchen greens", isOn: $greens)
                    Toggle("Add dry browns (leaves)", isOn: $browns)
                    Toggle("Add a sprinkle of water", isOn: $moisture)
                    HStack { Text("Time: \(Int(weeks)) weeks"); Spacer(); Slider(value: $weeks, in: 0...12, step: 1).frame(width: 200) }
                }
                .frame(maxWidth: 460).padding(.horizontal, 24)

                SoftShadowCard(padding: 14) {
                    Text("Half of household waste is organic. Composting at home (or in a community pit) turns kitchen scraps into rich, dark soil — no truck or treatment plant needed.")
                        .font(.callout).lineSpacing(4)
                }
                .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, 24)

                LookingAheadCallout(
                    title: "Class 12 Bio → NEET",
                    detail: "Class 12 'Microbes in Human Welfare' covers vermicompost (Eisenia foetida earthworm), biogas plants (methanogen bacteria), and sewage treatment using BOD-reducing microbes. NEET asks microbe-application questions every year."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)

                TryAtHomeCallout(
                    title: "Apartment composter",
                    detail: "Get a clean small bucket with a lid. Layer: 5 cm dry brown leaves, 5 cm fresh kitchen peels, sprinkle of garden soil. Repeat. Stir weekly. In 6-8 weeks the smell goes away and you have dark, crumbly compost — free fertiliser for plants."
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
