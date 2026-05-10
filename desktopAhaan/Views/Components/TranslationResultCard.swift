import SwiftUI
import AppKit

struct TranslationResultCard: View {
    let response: TranslationResponse
    let onSpeak: () -> Void
    let isSpeaking: Bool
    let onFavorite: () -> Void
    var isFavorited: Bool = false

    @State private var isExpanded = false
    @State private var showCopied = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header: Translated text
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    DifficultyBadge(level: response.difficulty)
                    Spacer()
                    HStack(spacing: 12) {
                        // TTS button
                        Button(action: onSpeak) {
                            Image(systemName: isSpeaking ? "speaker.wave.3.fill" : "speaker.wave.2")
                                .foregroundStyle(.indigo)
                                .symbolEffect(.pulse, isActive: isSpeaking)
                        }
                        .disabled(isSpeaking)
                        .accessibilityLabel("Play audio pronunciation")
                        .accessibilityHint("Hear the translated text spoken aloud")

                        // Favorite button
                        Button(action: onFavorite) {
                            Image(systemName: isFavorited ? "heart.fill" : "heart")
                                .foregroundStyle(.pink)
                        }
                        .accessibilityLabel(isFavorited ? "Remove from favorites" : "Add to favorites")
                        .accessibilityHint("Save or remove this translation from your favorites")

                        // Copy button
                        Button(action: {
                            NSPasteboard.general.clearContents()
                            NSPasteboard.general.setString(response.translatedText, forType: .string)
                            showCopied = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                showCopied = false
                            }
                        }) {
                            Image(systemName: showCopied ? "checkmark" : "doc.on.doc")
                                .foregroundStyle(showCopied ? .green : .secondary)
                        }
                        .accessibilityLabel(showCopied ? "Copied to clipboard" : "Copy translation")
                        .accessibilityHint("Copy the translated text to your clipboard")
                    }
                    .font(.title3)
                }

                Text(response.translatedText)
                    .font(.title2.weight(.semibold))
                    .textSelection(.enabled)

                if let translit = response.transliteration, !translit.isEmpty {
                    Text(translit)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .italic()
                        .textSelection(.enabled)
                }
            }

            Divider()

            // Expandable details
            DisclosureGroup("Learn More", isExpanded: $isExpanded) {
                VStack(alignment: .leading, spacing: 14) {
                    // Word-by-word
                    if let words = response.wordByWord, !words.isEmpty {
                        DetailSection(title: "Word by Word", icon: "text.word.spacing") {
                            ForEach(Array(words.enumerated()), id: \.offset) { index, word in
                                HStack(alignment: .top) {
                                    Text(word.source)
                                        .font(.subheadline.weight(.medium))
                                        .frame(width: 80, alignment: .leading)
                                    Image(systemName: "arrow.right")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                    VStack(alignment: .leading) {
                                        Text(word.target)
                                            .font(.subheadline)
                                        if let note = word.note, !note.isEmpty {
                                            Text(note)
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                        }
                                    }
                                }
                            }
                        }
                    }

                    // Grammar note
                    if let grammar = response.grammarNote, !grammar.isEmpty {
                        DetailSection(title: "Grammar", icon: "text.book.closed") {
                            Text(grammar)
                                .font(.subheadline)
                        }
                    }

                    // Learning tip
                    if let tip = response.learningTip, !tip.isEmpty {
                        DetailSection(title: "Learning Tip", icon: "lightbulb") {
                            Text(tip)
                                .font(.subheadline)
                                .foregroundStyle(.indigo)
                        }
                    }

                    // Alternatives
                    if let alts = response.alternatives, !alts.isEmpty {
                        DetailSection(title: "Alternatives", icon: "arrow.triangle.branch") {
                            ForEach(Array(alts.enumerated()), id: \.offset) { _, alt in
                                Text("- \(alt)")
                                    .font(.subheadline)
                            }
                        }
                    }

                    // Confidence note
                    if let conf = response.confidenceNote, !conf.isEmpty {
                        HStack(alignment: .top, spacing: 6) {
                            Image(systemName: "info.circle")
                                .foregroundStyle(.orange)
                            Text(conf)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .padding(.top, 8)
            }
            .tint(.indigo)
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.06), radius: 10, y: 3)
        .padding(.horizontal)
        .animation(.easeInOut(duration: 0.2), value: isFavorited)
    }
}

struct DetailSection<Content: View>: View {
    let title: String
    let icon: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Label(title, systemImage: icon)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
            content
        }
    }
}

struct DifficultyBadge: View {
    let level: DifficultyLevel

    var body: some View {
        Text(level.rawValue)
            .font(.caption2.weight(.bold))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(backgroundColor)
            .foregroundStyle(foregroundColor)
            .clipShape(Capsule())
    }

    private var backgroundColor: Color {
        switch level {
        case .easy: return .green.opacity(0.15)
        case .medium: return .orange.opacity(0.15)
        case .hard: return .red.opacity(0.15)
        }
    }

    private var foregroundColor: Color {
        switch level {
        case .easy: return .green
        case .medium: return .orange
        case .hard: return .red
        }
    }
}
