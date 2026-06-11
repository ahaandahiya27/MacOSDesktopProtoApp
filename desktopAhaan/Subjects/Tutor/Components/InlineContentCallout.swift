import SwiftUI
import AppKit

// MARK: - InlineContentCallout
//
// Small framed callout placed inline within a parent view. Used by:
//
//   • Exam connections — sits next to a question card, shows
//     "ICSE 2024 Q12 asked this same idea — 4-marker."
//   • Curriculum bridge chip — sits near the DeepDive disclosure,
//     surfaces the Class 8 / Class 11 preview.
//
// Distinct from `CollapsibleContentSection` (which is a top-level
// section) and `ContentChipStrip` (which is a horizontal row of small
// pills). This is a single boxed paragraph that ALWAYS shows its body
// inline — no expand/collapse, no tap-to-detail by default.
//
// Big Sur compat: pure macOS 10.15+. `Color.compat*` tokens. Static
// (no animations to gate for Reduce Motion).

struct InlineContentCallout: View {
    let title: String
    let message: String
    let symbol: String
    let tint: Color
    /// Optional small button shown beneath the body. nil → no button.
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: SFSymbolCompat.name(symbol))
                    .font(.body)
                    .foregroundColor(tint)
                    .frame(width: 22, alignment: .center)
                    .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                    Text(title)
                        .font(.caption.weight(.bold))
                        .foregroundColor(tint)
                        .textCase(.uppercase)
                    Text(message)
                        .font(.callout)
                        .foregroundColor(.primary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer(minLength: 0)
            }
            if let actionTitle = actionTitle, let action = action {
                Button(actionTitle) { action() }
                    .buttonStyle(.borderless)
                    .accentColor(tint)
                    .accessibilityHint("Performs the callout's follow-up action.")
            }
        }
        .padding(DesignTokens.Spacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
                .fill(tint.opacity(0.08))
        )
        .overlay(
            RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
                .strokeBorder(tint.opacity(0.25), lineWidth: 1)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title): \(message)")
    }
}
