import SwiftUI

/// One row of a question's "Now try these variations" section. Tappable to
/// expand and show the variation's answer + worked solution steps.
struct QuestionVariationCard: View {
    let variation: QuestionVariation
    @State private var expanded = false

    var body: some View {
        ExpandableCard(
            isExpanded: $expanded,
            systemImage: SFSymbolCompat.name("arrow.triangle.branch"),
            title: variation.prompt,
            tint: Color.compatIndigo
        ) {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                Text(variation.answer)
                    .font(.body.bold())
                    .padding(DesignTokens.Spacing.sm)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(RoundedRectangle(cornerRadius: 6).fill(Color.green.opacity(0.12)))
                ForEach(variation.solutionSteps.indices, id: \.self) { idx in let step = variation.solutionSteps[idx];
                    HStack(alignment: .top, spacing: DesignTokens.Spacing.sm) {
                        Text("\(idx + 1).").font(.callout.bold()).foregroundColor(Color.compatIndigo)
                        Text(step).font(.callout).lineSpacing(3)
                    }
                }
            }
        }
    }
}
