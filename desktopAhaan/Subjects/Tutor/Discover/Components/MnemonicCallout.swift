import SwiftUI

/// Yellow-tinted memory-hook callout (G10 in the issue taxonomy / M7
/// module type). Pairs a short, sticky mnemonic with the unpacked
/// meaning of each letter so kids can carry the rule out of the screen.
///
/// Pattern:
///
///     MnemonicCallout(
///         hook: "ROYGBIV",
///         meaning: "The seven rainbow colours, in order.",
///         expansion: [
///             ("R", "Red"),
///             ("O", "Orange"),
///             ("Y", "Yellow"),
///             ("G", "Green"),
///             ("B", "Blue"),
///             ("I", "Indigo"),
///             ("V", "Violet")
///         ]
///     )
///
/// Visually distinct from LookingAheadCallout (purple / graduation cap)
/// and TryAtHomeCallout (orange / raised hand) so kids learn at a glance:
///   yellow lightbulb = remember this with this trick.
///
/// macOS 11 (Big Sur) compatible — SF Symbols 2 (`lightbulb.fill`),
/// Color.yellow.opacity only. Honours the ≤10 child ViewBuilder
/// limit by collapsing the expansion rows into a single ForEach.
struct MnemonicCallout: View {
    /// The mnemonic itself — short, sticky, easy to repeat aloud.
    let hook: String
    /// One-line plain-English explanation of what the hook unlocks.
    let meaning: String
    /// Optional letter-by-letter expansion. Empty array = pure hook +
    /// meaning, no expansion rows rendered.
    let expansion: [(letter: String, word: String)]

    init(hook: String, meaning: String, expansion: [(letter: String, word: String)] = []) {
        self.hook = hook
        self.meaning = meaning
        self.expansion = expansion
    }

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "lightbulb.fill")
                .font(.title3)
                .foregroundColor(DesignTokens.BrandColor.mnemonic)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 8) {
                Text("Memory hook")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(DesignTokens.BrandColor.mnemonicAccent)
                    .textCase(.uppercase)
                Text(hook)
                    // `.monospaced()` on Font requires macOS 12+. Use
                    // `Font.system(_:design:)` which has shipped since
                    // macOS 11 to get the same monospaced rendering.
                    .font(.system(.title2, design: .monospaced).weight(.bold))
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .fixedSize(horizontal: false, vertical: true)
                Text(meaning)
                    .font(.callout)
                    .lineSpacing(3)
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                if !expansion.isEmpty {
                    expansionList
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Spacer(minLength: 0)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.yellow.opacity(0.18))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(Color.orange.opacity(0.50), lineWidth: 1)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityText)
    }

    private var expansionList: some View {
        VStack(alignment: .leading, spacing: 4) {
            ForEach(expansion, id: \.letter) { row in
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Text(row.letter)
                        .font(.system(.callout, design: .monospaced).weight(.bold))
                        .foregroundColor(DesignTokens.BrandColor.mnemonicAccent)
                        .frame(width: 18, alignment: .leading)
                    Text(row.word)
                        .font(.callout)
                        .foregroundColor(DesignTokens.BrandColor.canvasText)
                }
            }
        }
        .padding(.top, 2)
    }

    private var accessibilityText: String {
        if expansion.isEmpty {
            return "Memory hook: \(hook). \(meaning)"
        }
        let exp = expansion.map { "\($0.letter) for \($0.word)" }.joined(separator: ", ")
        return "Memory hook: \(hook). \(meaning). \(exp)."
    }
}
