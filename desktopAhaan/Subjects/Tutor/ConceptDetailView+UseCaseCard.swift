import SwiftUI

/// Card surface used by `ConceptDetailView`'s "Where you'll see
/// this" section — one card per `UseCase` showing the domain,
/// title, and description. Lifted to a sister file 2026-05-26
/// to keep the parent under the 600-LOC Big Sur ceiling after
/// the sibling-nav toolbar additions.
struct UseCaseCard: View {
    let useCase: UseCase

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(useCase.domain.uppercased())
                .font(.caption).bold()
                .foregroundColor(.secondary)
            Text(useCase.title)
                .font(.subheadline).bold()
            Text(useCase.description)
                .font(.callout)
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(DesignTokens.cornerRadiusCard)
        .frame(width: 280, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: DesignTokens.cornerRadiusCard)
                .fill(Color.gray.opacity(0.1))
        )
        .overlay(
            RoundedRectangle(cornerRadius: DesignTokens.cornerRadiusCard)
                .strokeBorder(Color.compatIndigo.opacity(0.25), lineWidth: 1)
        )
    }
}
