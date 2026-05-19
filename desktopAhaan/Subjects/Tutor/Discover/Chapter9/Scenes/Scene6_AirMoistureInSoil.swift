import SwiftUI

/// Scene 6 — Air & Moisture in Soil. Drop dry soil into a glass of water,
/// bubbles rise. Heat moist soil, droplets form on the cooler glass.
struct Scene6_AirMoistureInSoil: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    enum Demo: String, CaseIterable, Identifiable {
        case air = "Air in soil"
        case water = "Water in soil"
        var id: String { rawValue }
    }
    @State private var demo: Demo = .air

    var body: some View {
        // Wrapped in ScrollView so the scene scrolls on
        // shorter windows and overflowing content remains accessible.
        ScrollView {
    LazyVStack(alignment: .center, spacing: 14) {
                Text("Air & Moisture in Soil").font(.largeTitle.bold()).foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                Text("Two simple home experiments prove soil has both air and water.")
                    .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)

                Picker("", selection: $demo) {
                    ForEach(Demo.allCases) { Text($0.rawValue).tag($0) }
                }.pickerStyle(.segmented).discoverControlChrome().frame(maxWidth: 320)

                ZStack {
                    RoundedRectangle(cornerRadius: 18).fill(Color.compatCyan.opacity(0.12))
                        .frame(width: 320, height: 260)
                    VStack(spacing: 8) {
                        Text(demo == .air ? "🧪💧" : "🔥🧪")
                            .font(.system(size: 72))
                        Text(demo == .air ? "Bubbles rise from soil → soil contained air!"
                                           : "Droplets form on cool glass → soil had water!")
                            .multilineTextAlignment(.center)
                            .font(.callout)
                            .padding(.horizontal, 16)
                    }
                }

                SoftShadowCard(padding: 18) {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Soil is not just solid", systemImage: SFSymbolCompat.name("bubbles.and.sparkles"))
                            .font(.title2.bold())
                        Text("Pour dry soil into water → tiny bubbles escape. Heat moist soil in a test tube → water vapour condenses on the cool top. Soil is a mix of solids, water, and air — that's why roots can breathe through it.")
                            .font(.body).lineSpacing(4)
                    }
                }
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)

                LookingAheadCallout(
                    title: "Class 11 Bio → NEET",
                    detail: "Class 11 'Mineral Nutrition' covers soil as a chemical reservoir — how plants absorb 17 essential elements through root hairs. NEET asks soil-microbiome questions (nitrogen-fixing Rhizobium, mycorrhizae) every cycle."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)

                TryAtHomeCallout(
                    title: "Bubbles from soil",
                    detail: "Drop a fistful of dry garden soil into a glass of water. Watch the bubbles rise — that's air that was hiding between the soil grains."
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
