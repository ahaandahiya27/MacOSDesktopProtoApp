import SwiftUI

/// A 5-pip difficulty badge (●●●○○) used wherever a `Question.difficulty`
/// integer is displayed. Green at 1–2, yellow at 3, orange at 4–5.
struct QuestionDifficultyBadge: View {
    let level: Int
    var body: some View {
        HStack(spacing: 2) {
            ForEach(1...5, id: \.self) { i in
                Image(systemName: i <= level ? "circle.fill" : "circle")
                    .font(.caption2)
                    .foregroundColor(i <= level ? color : .secondary.opacity(0.4))
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Difficulty \(level) of 5")
    }
    private var color: Color {
        switch level {
        case 1...2: return .green
        case 3:     return .yellow
        default:    return .orange
        }
    }
}
