import SwiftUI

/// Green-tinted "Discovery Mode" sandbox card. Used to inject free-play
/// interactivity into any scene — drag a slider, watch the computed
/// output update — without rebuilding scene UI from scratch.
///
/// Pattern:
///   DiscoveryWidget(
///       title: "Try a different tilt",
///       subtitle: "Drag to see how seasons change.",
///       value: $tilt,
///       range: 0...45,
///       step: 1,
///       valueLabel: { v in "Tilt: \(Int(v))°" },
///       output: { v in
///           if v < 5 { return "Almost no seasons." }
///           else if v < 25 { return "Mild seasons — like Earth today." }
///           else { return "Extreme seasons." }
///       }
///   )
///
/// Visually distinct from `LookingAheadCallout` (purple, future-prep) and
/// `TryAtHomeCallout` (orange, physical experiment) so kids recognise
/// "this is where I play with the variable" at a glance.
///
/// macOS 11 (Big Sur) / Swift 5.5 compatible:
///  - Slider + Text + RoundedRectangle + Image(systemName:) only.
///  - SF Symbol "slider.horizontal.3" exists in SF Symbols 2.
///  - No `.foregroundStyle`, no `.symbolEffect`, no Layout protocol.
///  - ≤10 direct children in every @ViewBuilder closure.
struct DiscoveryWidget: View {
    let title: String
    let subtitle: String
    @Binding var value: Double
    let range: ClosedRange<Double>
    let step: Double
    let valueLabel: (Double) -> String
    let output: (Double) -> String

    init(title: String,
         subtitle: String,
         value: Binding<Double>,
         range: ClosedRange<Double>,
         step: Double = 1,
         valueLabel: @escaping (Double) -> String,
         output: @escaping (Double) -> String) {
        self.title = title
        self.subtitle = subtitle
        self._value = value
        self.range = range
        self.step = step
        self.valueLabel = valueLabel
        self.output = output
    }

    /// Darker, readable variant of `.green` for body text on the pale
    /// green-tinted chip. Pure `.green` was too low-contrast against the
    /// `Color.green.opacity(0.08)` fill on the iMac.
    private static let darkGreen: Color = Color(red: 0.10, green: 0.45, blue: 0.20)

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            header
            Text(subtitle)
                .font(.callout)
                .foregroundColor(DesignTokens.BrandColor.canvasText)
                .lineSpacing(2)
                .fixedSize(horizontal: false, vertical: true)
            sliderRow
            Text(output(value))
                .font(.callout.weight(.medium))
                .foregroundColor(DesignTokens.BrandColor.canvasText)
                .lineSpacing(2)
                .padding(.top, 2)
                .fixedSize(horizontal: false, vertical: true)
                .accessibilityLabel("Result: \(output(value))")
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.green.opacity(0.08))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(Color.green.opacity(0.35), lineWidth: 1)
        )
        .accessibilityElement(children: .contain)
    }

    private var header: some View {
        HStack(spacing: 10) {
            Image(systemName: "slider.horizontal.3")
                .font(.title3)
                .foregroundColor(Self.darkGreen)
                .accessibilityHidden(true)
            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundColor(Self.darkGreen)
            Spacer(minLength: 0)
            Text(valueLabel(value))
                .font(.caption.weight(.medium).monospacedDigit())
                .foregroundColor(Self.darkGreen)
        }
    }

    private var sliderRow: some View {
        Slider(value: $value, in: range, step: step)
            .accentColor(.green)
            .accessibilityValue(valueLabel(value))
    }
}
