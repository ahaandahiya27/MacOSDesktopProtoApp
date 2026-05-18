import SwiftUI

/// Scene 7 — Soil pH and the Farmer.
/// Interactive: acidic soil + lime raises pH, basic soil + organic matter lowers pH.

struct Scene7_SoilpHAndFarmer: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var soilPH: Double = 4.5
    @State private var scenario: Int = 0  // 0 = acidic, 1 = basic, 2 = done
    @State private var limeAdded: Int = 0
    @State private var organicAdded: Int = 0

    private var soilColor: Color {
        switch soilPH {
        case ..<5:   return Color(red: 0.6, green: 0.3, blue: 0.15)  // reddish-brown (acidic)
        case ..<6.5: return Color(red: 0.5, green: 0.4, blue: 0.2)
        case ..<7.5: return Color(red: 0.35, green: 0.5, blue: 0.2)  // healthy green-brown
        case ..<9:   return Color(red: 0.4, green: 0.45, blue: 0.35)
        default:     return Color(red: 0.55, green: 0.55, blue: 0.5)  // pale (too basic)
        }
    }

    private var plantHealth: String {
        switch soilPH {
        case 6.0...7.5: return "\u{1F331}"  // healthy seedling
        case 5.0..<6.0, 7.5..<9.0: return "\u{1F33F}"  // herb, ok
        default: return "\u{1F342}"  // fallen leaf, poor
        }
    }

    var body: some View {
        GeometryReader { _ in
            ZStack {
                VStack(spacing: 16) {
                    Text("Soil pH and the Farmer")
                        .font(.title2.bold())
                        .padding(.top, 18)

                    // pH meter display
                    HStack(spacing: 20) {
                        // Soil visual
                        VStack(spacing: 8) {
                            Text(plantHealth)
                                .font(.system(size: 56))

                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(soilColor)
                                .frame(width: 160, height: 80)
                                .overlay(
                                    Text("Soil")
                                        .font(.caption.bold())
                                        .foregroundColor(.white)
                                )
                                .animation(reduceMotion ? .none : .easeInOut(duration: 0.4))
                        }

                        // pH meter
                        VStack(spacing: 6) {
                            Text("pH Meter")
                                .font(.caption.weight(.medium))
                                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                            Text("\(soilPH, specifier: "%.1f")")
                                .font(.system(size: 48, weight: .bold, design: .rounded).monospacedDigit())
                                .foregroundColor(meterColor)
                            Text(pHDescription)
                                .font(.subheadline.weight(.medium))
                                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                        }
                        .frame(width: 160)
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .fill(Color.white)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .strokeBorder(.gray.opacity(0.25), lineWidth: 1.5)
                        )
                    }

                    // Action buttons
                    if scenario == 0 {
                        VStack(spacing: 8) {
                            Text("The soil is too acidic! Add lime to raise the pH.")
                                .font(.body)
                                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                            Button {
                                addLime()
                            } label: {
                                Label("Add Lime (CaO)", systemImage: "plus.circle.fill")
                                    .font(.headline)
                            }
                            
                            .accentColor(.orange)
                            .disabled(soilPH >= 6.8)
                        }
                    } else if scenario == 1 {
                        VStack(spacing: 8) {
                            Text("Now the soil is too basic! Add organic matter to lower the pH.")
                                .font(.body)
                                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                            Button {
                                addOrganic()
                            } label: {
                                Label("Add Organic Matter", systemImage: "leaf.fill")
                                    .font(.headline)
                            }
                            
                            .accentColor(.green)
                            .disabled(soilPH <= 7.2)
                        }
                    }

                    Spacer(minLength: 0)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                VStack(spacing: 14) {
                    Spacer()
                    SoftShadowCard(padding: 18) {
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Why Farmers Test Soil", systemImage: SFSymbolCompat.name("leaf.arrow.circlepath"))
                                .font(.title2.bold())
                            if scenario == 2 {
                                Text("Plants grow best in soil with pH near 7 (neutral). If soil is too acidic, farmers add lime (a base). If too basic, they add organic matter (which is slightly acidic). This is neutralisation at work on the farm!")
                                    .font(.body)
                                    .lineSpacing(4)
                            } else {
                                Text("Farmers test soil pH to help their crops grow well. Tap the button to adjust the soil!")
                                    .font(.body)
                                    .lineSpacing(4)
                            }
                        }
                    }
                    .frame(maxWidth: DesignTokens.contentMaxWidth)

                    LookingAheadCallout(
                        title: "Class 12 Biology / Chemistry → NEET / Agriculture",
                        detail: "Most crops grow best between pH 6 and pH 7.5. Tea (pH 4.5-5.5), blueberries (4.5), and rhododendrons love acidic soil. Cotton (6-6.5) and most cereals (6.5-7.5) like near-neutral. Beyond that range, plants can't absorb essential ions — iron locks up in alkaline soil; aluminium becomes toxic in acidic. JEE Geography meets NEET Botany in one beaker."
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)

                    TryAtHomeCallout(
                        title: "Test your home soil pH",
                        detail: "Take a teaspoon of soil from a flowerpot or garden bed. Add it to a glass of distilled water (or boiled-then-cooled tap water). Stir. Dip pH paper. Most home soil hits 6.5-7.5 — perfectly normal. If yours reads below 5.5 or above 8, that explains why some plants struggle to grow there. You've just done agricultural chemistry."
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)

                    if scenario == 2 {
                        GotItButton { onComplete() }
                            .padding(.bottom, 12)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .padding(.horizontal, 24)
            }
        }
    }

    // MARK: - Helpers

    private var meterColor: Color {
        switch soilPH {
        case ..<5:   return .red
        case ..<6.5: return .orange
        case ..<7.5: return .green
        case ..<9:   return .blue
        default:     return .purple
        }
    }

    private var pHDescription: String {
        switch soilPH {
        case ..<5:   return "Very Acidic"
        case ..<6.5: return "Acidic"
        case ..<7.5: return "Neutral \u{2014} Ideal!"
        case ..<9:   return "Basic"
        default:     return "Very Basic"
        }
    }

    private func addLime() {
        limeAdded += 1
        withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.5)) {
            soilPH = min(soilPH + 0.8, 7.0)
        }
        if soilPH >= 6.8 {
            // Switch to scenario 1: basic soil
            Task { @MainActor in
                try? await Task.sleep(nanoseconds: 800_000_000)
                withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.5)) {
                    soilPH = 9.5
                    scenario = 1
                }
            }
        }
    }

    private func addOrganic() {
        organicAdded += 1
        withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.5)) {
            soilPH = max(soilPH - 0.8, 7.0)
        }
        if soilPH <= 7.2 {
            Task { @MainActor in
                try? await Task.sleep(nanoseconds: 600_000_000)
                withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.3)) {
                    scenario = 2
                }
            }
        }
    }
}
