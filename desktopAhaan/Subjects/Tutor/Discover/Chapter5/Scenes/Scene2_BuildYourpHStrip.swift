import SwiftUI

/// Scene 2 — Build Your pH Strip.
/// Interactive pH scale 0-14 with draggable marker, color changes, and substance pins.

struct Scene2_BuildYourpHStrip: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var pH: Double = 7.0

    private struct SubstancePin: Identifiable {
        let id = UUID()
        let name: String
        let pH: Double
        let emoji: String
    }

    private let substances: [SubstancePin] = [
        SubstancePin(name: "Battery acid", pH: 1, emoji: "\u{1F50B}"),
        SubstancePin(name: "Lemon juice", pH: 2, emoji: "\u{1F34B}"),
        SubstancePin(name: "Vinegar", pH: 3, emoji: "\u{1FAD9}"),
        SubstancePin(name: "Tomato", pH: 4, emoji: "\u{1F345}"),
        SubstancePin(name: "Coffee", pH: 5, emoji: "\u{2615}"),
        SubstancePin(name: "Milk", pH: 6, emoji: "\u{1F95B}"),
        SubstancePin(name: "Pure water", pH: 7, emoji: "\u{1F4A7}"),
        SubstancePin(name: "Baking soda", pH: 9, emoji: "\u{1F9C2}"),
        SubstancePin(name: "Soap", pH: 10, emoji: "\u{1F9FC}"),
        SubstancePin(name: "Ammonia", pH: 11, emoji: "\u{1F9F4}"),
        SubstancePin(name: "Bleach", pH: 13, emoji: "\u{1FAE7}"),
    ]

    private var pHLabel: String {
        switch pH {
        case ..<2:   return "Strong Acid"
        case ..<6:   return "Weak Acid"
        case ..<8:   return "Neutral"
        case ..<11:  return "Weak Base"
        default:     return "Strong Base"
        }
    }

    var body: some View {
        // ScrollView + LazyVStack: GeometryReader-collapse bug fixed by
        // removing the unused outer GeometryReader; interactive content
        // now flows naturally and the pHStrip's own GeometryReader has a
        // real bounded canvas via its fixed-height frame.
        ScrollView {
            LazyVStack(alignment: .center, spacing: 14) {
                VStack(spacing: 18) {
                    Text("Build Your pH Strip")
                        .font(.title2.bold())
                        .padding(.top, 18)

                    // Current pH display
                    VStack(spacing: 4) {
                        Text("pH \(pH, specifier: "%.1f")")
                            .font(.system(size: 48, weight: .bold, design: .rounded).monospacedDigit())
                            .foregroundColor(colorForPH(pH))
                        Text(pHLabel)
                            .font(.title3.weight(.semibold))
                            .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    }

                    // Color strip
                    pHStrip
                        .frame(maxWidth: 640, maxHeight: 60)
                        .padding(.horizontal, 24)

                    // Slider
                    Slider(value: $pH, in: 0...14, step: 0.5)
                        .accentColor(colorForPH(pH))
                        .frame(maxWidth: DesignTokens.contentMaxWidth)
                        .padding(.horizontal, 24)
                        .accessibilityLabel("pH slider, current value \(pH, specifier: "%.1f")")

                    // Substance pins
                    substancePinView
                        .frame(maxWidth: 700)
                        .padding(.horizontal, 24)
                }
                .frame(maxWidth: .infinity)

                Group {
                    SoftShadowCard(padding: 18) {
                        VStack(alignment: .leading, spacing: 8) {
                            Label("The pH Scale", systemImage: "chart.bar.fill")
                                .font(.title2.bold())
                            Text("pH measures how acidic or basic a substance is. pH 0\u{2013}6 is acidic, pH 7 is neutral, and pH 8\u{2013}14 is basic. Drag the slider to explore!")
                                .font(.body)
                                .lineSpacing(4)
                        }
                    }
                    .frame(maxWidth: DesignTokens.contentMaxWidth)

                    LookingAheadCallout(
                        title: "Class 11 Chemistry → JEE",
                        detail: "pH is logarithmic: pH = -log₁₀[H⁺]. JEE asks: 'A solution of pH 3 is how many times more acidic than pH 6?' Answer: 1000× (because 10⁻³ ÷ 10⁻⁶). The numbers 0-14 look gentle but every step is a 10× concentration change. Stomach acid (pH 1.5) is 10 million times more acidic than blood (pH 7.4)."
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)

                    TryAtHomeCallout(
                        title: "pH-strip the kitchen",
                        detail: "Buy a roll of universal pH paper (₹40 at any chemistry supplier or pharmacy). Test: tap water, lemon juice, vinegar, baking soda solution, toothpaste, shampoo, milk, coffee. Make a colour-coded chart on graph paper. Notice which everyday items cluster around neutral (most foods), which are deeply acidic (citrus), which basic (cleaning products)."
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)

                    GotItButton { onComplete() }
                        .padding(.bottom, 12)
                

                }

                .padding(.horizontal, 24)
            

            }

            .frame(maxWidth: .infinity)

            .padding(.bottom, 12)

        }
    }

    // MARK: - pH color strip

    private var pHStrip: some View {
        GeometryReader { geo in
            let centerY: CGFloat = geo.size.height * 0.5
            let markerH: CGFloat = geo.size.height + 8
            let xPos: CGFloat = geo.size.width * CGFloat(pH / 14.0)
            ZStack(alignment: .leading) {
                // Gradient bar
                LinearGradient(
                    colors: (0...14).map { colorForPH(Double($0)) },
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))

                // pH labels along the bar
                ForEach([0, 7, 14], id: \.self) { val in
                    let labelX: CGFloat = geo.size.width * CGFloat(val) / 14.0
                    Text("\(val)")
                        .font(.caption2.bold())
                        .foregroundColor(.white)
                        .shadow(radius: 2)
                        .position(
                            x: labelX,
                            y: centerY
                        )
                }

                // Marker
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color(NSColor.controlBackgroundColor))
                    .frame(width: 4, height: markerH)
                    .shadow(radius: 2)
                    .position(x: xPos, y: centerY)
            }
        }
    }

    // MARK: - Substance pins

    private var substancePinView: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 80), spacing: 6)], spacing: 8) {
            ForEach(substances) { sub in
                let isNear = abs(sub.pH - pH) < 1.0
                VStack(spacing: 2) {
                    Text(sub.emoji)
                        .font(.title3)
                    Text(sub.name)
                        .font(.caption2.weight(.medium))
                        .multilineTextAlignment(.center)
                    Text("pH \(Int(sub.pH))")
                        .font(.caption2)
                        .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                }
                .frame(width: 82, height: 64)
                .background(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(isNear ? colorForPH(sub.pH).opacity(0.15) : Color.white)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .strokeBorder(isNear ? colorForPH(sub.pH) : .clear, lineWidth: 2)
                )
                .scaleEffect(isNear ? 1.08 : 1.0)
                .animation(reduceMotion ? .none : .easeInOut(duration: 0.2))
            }
        }
    }

    // MARK: - Color mapping

    private func colorForPH(_ value: Double) -> Color {
        switch value {
        case ..<1:   return .red
        case ..<3:   return Color(red: 1, green: 0.3, blue: 0)
        case ..<5:   return .orange
        case ..<6:   return .yellow
        case ..<8:   return .green
        case ..<10:  return Color(red: 0.2, green: 0.6, blue: 1)
        case ..<12:  return .blue
        default:     return .purple
        }
    }
}
