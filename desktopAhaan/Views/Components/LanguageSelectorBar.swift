import SwiftUI

struct LanguageSelectorBar: View {
    @Binding var source: SupportedLanguage
    @Binding var target: SupportedLanguage
    var onSwap: () -> Void
    var onSourceChanged: () -> Void

    var body: some View {
        HStack(spacing: 12) {
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

            // Swap button
            Button(action: onSwap) {
                Image(systemName: "arrow.left.arrow.right.circle.fill")
                    .font(.title2)
                    .foregroundStyle(.indigo)
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
        }
        .padding(.horizontal)
    }
}

struct LanguagePill: View {
    let language: SupportedLanguage
    let label: String

    var body: some View {
        VStack(spacing: 4) {
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
            Text(language.nativeLabel)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.primary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
