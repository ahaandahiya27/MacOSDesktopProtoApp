import SwiftUI

/// One row of a question's "Now try these variations" section. Tappable to
/// expand and show the variation's answer + worked solution steps.
struct QuestionVariationCard: View {
    let variation: QuestionVariation
    @State private var expanded = false

    var body: some View {
        ExpandableCard(
            isExpanded: $expanded,
            systemImage: "arrow.triangle.branch",
            title: variation.prompt,
            tint: Color.compatIndigo
        ) {
            VStack(alignment: .leading, spacing: 8) {
                Text(variation.answer)
                    .font(.body.bold())
                    .padding(8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(RoundedRectangle(cornerRadius: 6).fill(Color.green.opacity(0.12)))
                ForEach(Array(variation.solutionSteps.enumerated()), id: \.offset) { idx, step in
                    HStack(alignment: .top, spacing: 8) {
                        Text("\(idx + 1).").font(.callout.bold()).foregroundColor(Color.compatIndigo)
                        Text(step).font(.callout).lineSpacing(3)
                    }
                }
            }
        }
    }
}
