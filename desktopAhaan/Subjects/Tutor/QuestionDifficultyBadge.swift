import SwiftUI

/// A difficulty badge that shows a friendly word (Easy / Medium / Hard)
/// alongside the 5-pip visual (●●●○○). Green at 1–2 (Easy), yellow at 3
/// (Medium), orange at 4–5 (Hard). The label is the load-bearing element —
/// a 12-year-old shouldn't need to decode pip counts at a glance.
struct QuestionDifficultyBadge: View {
    let level: Int
    /// Callers can hide the word and keep just the pips when space is tight.
    var showLabel: Bool = true

    var body: some View {
        HStack(spacing: DesignTokens.Spacing.xs) {
            if showLabel {
                Text(label)
                    .font(.caption2.weight(.semibold))
                    .foregroundColor(color)
            }
            HStack(spacing: DesignTokens.Spacing.xxs) {
                ForEach(1...5, id: \.self) { i in
                    Image(systemName: i <= level ? "circle.fill" : "circle")
                        .font(.system(size: 6))
                        .foregroundColor(i <= level ? color : .secondary.opacity(0.4))
                }
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Difficulty: \(label), \(level) of 5")
    }

    private var label: String {
        switch level {
        case 1...2: return "Easy"
        case 3:     return "Medium"
        default:    return "Hard"
        }
    }

    private var color: Color {
        switch level {
        case 1...2: return .green
        case 3:     return .yellow
        default:    return .orange
        }
    }
}
