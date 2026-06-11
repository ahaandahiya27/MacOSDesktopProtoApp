import SwiftUI

/// Green-tinted "Discovery Mode" A/B comparison card. The variant of
/// DiscoveryWidget for problems that have no continuous variable — only
/// a binary either/or. Drag-free, single-tap interaction.
///
/// Pattern:
///   DiscoveryToggle(
///       title: "Compare two states",
///       subtitle: "What's the difference?",
///       optionA: "🌳 With forest",
///       optionB: "🪓 Cleared land",
///       selectionIsA: $hasForest,
///       outputA: "Slow soak. Aquifer recharges.",
///       outputB: "Fast runoff. Flash floods and erosion."
///   )
///
/// Visually matches DiscoveryWidget (same green palette + slider.horizontal.3
/// header icon) so kids learn the colour = "play with me" association
/// regardless of which variant of input the widget happens to use.
///
/// macOS 11 (Big Sur) / Swift 5.5 compatible:
///  - Picker(segmented) + Text + RoundedRectangle only.
///  - Each @ViewBuilder closure ≤ 10 direct children.
struct DiscoveryToggle: View {
    let title: String
    let subtitle: String
    let optionA: String
    let optionB: String
    @Binding var selectionIsA: Bool
    let outputA: String
    let outputB: String

    private static let darkGreen: Color = Color(red: 0.10, green: 0.45, blue: 0.20)

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            header
            Text(subtitle)
                .font(.callout)
                .foregroundColor(DesignTokens.BrandColor.canvasText)
                .lineSpacing(2)
                .fixedSize(horizontal: false, vertical: true)
            picker
            Text(selectionIsA ? outputA : outputB)
                .font(.callout.weight(.medium))
                .foregroundColor(DesignTokens.BrandColor.canvasText)
                .lineSpacing(2)
                .padding(.top, DesignTokens.Spacing.xxs)
                .fixedSize(horizontal: false, vertical: true)
                .accessibilityLabel("Result: \(selectionIsA ? outputA : outputB)")
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
        }
    }

    private var picker: some View {
        Picker("", selection: $selectionIsA) {
            Text(optionA).tag(true)
            Text(optionB).tag(false)
        }
        .pickerStyle(.segmented).discoverControlChrome()
        .accentColor(.green)
        .accessibilityValue(selectionIsA ? optionA : optionB)
    }
}
