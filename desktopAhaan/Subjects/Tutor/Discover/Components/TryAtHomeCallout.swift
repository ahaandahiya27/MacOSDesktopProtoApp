import SwiftUI

/// Small callout box used inside Discover Mode scenes to suggest a quick
/// real-world experiment the kid can do at home with everyday materials.
///
/// Visually distinct from the `SoftShadowCard` insight panel — orange tint,
/// outlined raised-hand icon — so kids learn to recognise "this is something
/// I can actually do" at a glance.
///
/// macOS 11 (Big Sur) compatible — uses SF Symbols 2 (`hand.raised.fill`)
/// only, no `.foregroundStyle`, no `.symbolEffect`, no `Color.orange`-only
/// system colours that vary across versions.
struct TryAtHomeCallout: View {
    let title: String
    let detail: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "hand.raised.fill")
                .font(.title3)
                .foregroundColor(.orange)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.orange)
                Text(detail)
                    .font(.callout)
                    .lineSpacing(3)
                    .foregroundColor(.primary)
            }
            Spacer(minLength: 0)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.orange.opacity(0.14))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(Color.orange.opacity(0.45), lineWidth: 1)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Try this at home. \(title). \(detail)")
    }
}
