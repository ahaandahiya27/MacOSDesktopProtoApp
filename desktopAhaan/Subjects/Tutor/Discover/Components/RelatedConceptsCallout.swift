import SwiftUI

/// Teal-tinted sidebar that names other chapters in the same pack where
/// the same idea reappears. Builds the "knowledge graph" layer that's
/// otherwise invisible — Class 7 NCERT's chapters quietly interlink
/// (photosynthesis ↔ transpiration ↔ forests; respiration ↔ circulation;
/// electric current ↔ light via the EM spectrum), and this callout makes
/// those connections explicit at the scene level.
///
/// Visually distinct from `SoftShadowCard` (neutral insight), `TryAtHomeCallout`
/// (orange — do-it experiment), and `LookingAheadCallout` (purple — Class 10/12/
/// JEE/NEET future). Teal means "same idea, different chapter".
///
/// macOS 11 (Big Sur) compatible — pure SwiftUI `Color` + SF Symbols 2
/// (`link.circle.fill`). No `.foregroundStyle`, no `.symbolEffect`.
struct RelatedConceptsCallout: View {
    let title: String
    let detail: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "link.circle.fill")
                .font(.title3)
                .foregroundColor(Color.compatTeal)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(Color.compatTeal)
                    .fixedSize(horizontal: false, vertical: true)
                Text(detail)
                    .font(.callout)
                    .lineSpacing(3)
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Spacer(minLength: 0)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.compatTeal.opacity(0.14))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(Color.compatTeal.opacity(0.45), lineWidth: 1)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Related concepts. \(title). \(detail)")
    }
}
