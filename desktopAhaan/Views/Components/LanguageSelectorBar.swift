import SwiftUI

struct LanguageSelectorBar: View {
    @Binding var source: SupportedLanguage
    @Binding var target: SupportedLanguage
    var onSwap: () -> Void
    var onSourceChanged: () -> Void

    var body: some View {
        HStack(spacing: DesignTokens.Spacing.md) {
            // Source picker
            Menu {
                ForEach(SupportedLanguage.allCases) { lang in
                    Button(lang.displayName) {
                        source = lang
                        onSourceChanged()
                    }
                }
            } label: {
                LanguagePill(language: source, label: "From")
            }
            .accessibilityLabel("Source language: \(source.displayName)")
            .accessibilityHint("Double tap to change the source language")

            // Swap button
            Button(action: onSwap) {
                Image(systemName: "arrow.left.arrow.right.circle.fill")
                    .font(.title2)
                    .foregroundColor(Color.compatIndigo)
            }
            .disabled(!TranslationPair(source: target, target: source).isValid)
            .accessibilityLabel("Swap language direction")

            // Target picker
            Menu {
                ForEach(source.validTargets) { lang in
                    Button(lang.displayName) {
                        target = lang
                    }
                }
            } label: {
                LanguagePill(language: target, label: "To")
            }
            .accessibilityLabel("Target language: \(target.displayName)")
            .accessibilityHint("Double tap to change the target language")
        }
        .padding(.horizontal)
    }
}

struct LanguagePill: View {
    let language: SupportedLanguage
    let label: String

    var body: some View {
        VStack(spacing: DesignTokens.Spacing.xs) {
            Text(label)
                .font(.caption2)
                .foregroundColor(.secondary)
            Text(language.nativeLabel)
                .font(.subheadline.weight(.semibold))
                .foregroundColor(.primary)
        }
        .padding(.horizontal, DesignTokens.Spacing.lg)
        .padding(.vertical, 10)
        .background(Color.gray.opacity(0.15))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
