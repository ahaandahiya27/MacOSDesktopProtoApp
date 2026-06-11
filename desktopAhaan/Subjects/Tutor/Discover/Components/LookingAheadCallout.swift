import SwiftUI

/// Purple-tinted sidebar that previews how a Class 7 concept extends into
/// Class 10, Class 11/12, and JEE / NEET prep. Used to give early learners
/// a sense of academic continuity — "the pendulum you played with becomes
/// Simple Harmonic Motion later" — so the chapter doesn't feel like a
/// dead-end.
///
/// Visually distinct from `TryAtHomeCallout` (orange / raised hand) and from
/// `SoftShadowCard` (the neutral insight panel) so kids learn to recognise
/// "this is where the concept goes next" at a glance.
///
/// macOS 11 (Big Sur) compatible — SF Symbols 2 (`graduationcap.fill`),
/// `Color.purple.opacity(…)` only. No `.foregroundStyle`, no `.symbolEffect`.
struct LookingAheadCallout: View {
    let title: String
    let detail: String

    var body: some View {
        HStack(alignment: .top, spacing: DesignTokens.Spacing.md) {
            Image(systemName: "graduationcap.fill")
                .font(.title3)
                .foregroundColor(.purple)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.purple)
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
        .padding(DesignTokens.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.purple.opacity(0.14))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(Color.purple.opacity(0.45), lineWidth: 1)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Looking ahead. \(title). \(detail)")
    }
}
