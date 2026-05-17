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
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    DifficultyBadge(level: response.difficulty)
                    Spacer()
                    HStack(spacing: 12) {
                        Button(action: onSpeak) {
                            Image(systemName: isSpeaking ? "speaker.wave.3.fill" : "speaker.wave.2")
                                .foregroundColor(Color.compatIndigo)
                        }
                        .disabled(isSpeaking)
                        .pointingCursor()
                        .help("Play pronunciation")
                        .accessibilityLabel("Play audio pronunciation")
                        .accessibilityHint("Hear the translated text spoken aloud")

                        Button(action: onFavorite) {
                            Image(systemName: isFavorited ? "heart.fill" : "heart")
                                .foregroundColor(.pink)
                        }
                        .pointingCursor()
                        .help(isFavorited ? "Remove from favorites" : "Add to favorites")
                        .accessibilityLabel(isFavorited ? "Remove from favorites" : "Add to favorites")
                        .accessibilityHint("Save or remove this translation from your favorites")

                        Button(action: {
                            NSPasteboard.general.clearContents()
                            NSPasteboard.general.setString(response.translatedText, forType: .string)
                            showCopied = true
                            Task { @MainActor in
                                try? await Task.sleep(nanoseconds: 1_500_000_000)
                                showCopied = false
                            }
                        }) {
                            Image(systemName: showCopied ? "checkmark" : "doc.on.doc")
                                .foregroundColor(showCopied ? .green : .secondary)
                        }
                        .pointingCursor()
                        .help(showCopied ? "Copied!" : "Copy translation")
                        .accessibilityLabel(showCopied ? "Copied to clipboard" : "Copy translation")
                        .accessibilityHint("Copy the translated text to your clipboard")
                    }
                    .font(.title3)
                }

                Text(response.translatedText)
                    .font(.title2.weight(.semibold))

                if let translit = response.transliteration, !translit.isEmpty {
                    Text(translit)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .italic()
                }
            }

            Divider()

            ExpandableCard(
                isExpanded: $isExpanded,
                systemImage: "book.fill",
                title: "Learn More",
                tint: Color.compatIndigo
            ) {
                VStack(alignment: .leading, spacing: 14) {
                    if let words = response.wordByWord, !words.isEmpty {
                        DetailSection(title: "Word by Word", icon: "text.word.spacing") {
                            ForEach(Array(words.enumerated()), id: \.offset) { _, word in
                                HStack(alignment: .top) {
                                    Text(word.source)
                                        .font(.subheadline.weight(.medium))
                                        .frame(width: 80, alignment: .leading)
                                    Image(systemName: "arrow.right")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    VStack(alignment: .leading) {
                                        Text(word.target)
                                            .font(.subheadline)
                                        if let note = word.note, !note.isEmpty {
                                            Text(note)
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                }
                            }
                        }
                    }

                    if let grammar = response.grammarNote, !grammar.isEmpty {
                        DetailSection(title: "Grammar", icon: "text.book.closed") {
                            Text(grammar)
                                .font(.subheadline)
                        }
                    }

                    if let tip = response.learningTip, !tip.isEmpty {
                        DetailSection(title: "Learning Tip", icon: "lightbulb") {
                            Text(tip)
                                .font(.subheadline)
                                .foregroundColor(Color.compatIndigo)
                        }
                    }

                    if let alts = response.alternatives, !alts.isEmpty {
                        DetailSection(title: "Alternatives", icon: "arrow.triangle.branch") {
                            ForEach(Array(alts.enumerated()), id: \.offset) { _, alt in
                                Text("- \(alt)")
                                    .font(.subheadline)
                            }
                        }
                    }

                    if let conf = response.confidenceNote, !conf.isEmpty {
                        HStack(alignment: .top, spacing: 6) {
                            Image(systemName: "info.circle")
                                .foregroundColor(.orange)
                            Text(conf)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.06), radius: 10, y: 3)
        .padding(.horizontal)
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
                .foregroundColor(.secondary)
            content
        }
    }
}

struct DifficultyBadge: View {
    let level: DifficultyLevel

    private var iconName: String {
        switch level {
        case .easy: return "circle.fill"
        case .medium: return "diamond.fill"
        case .hard: return "exclamationmark.triangle.fill"
        }
    }

    var body: some View {
        Label {
            Text(level.rawValue)
                .font(.caption2.weight(.bold))
        } icon: {
            Image(systemName: iconName)
                .font(.system(size: 6))
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(backgroundColor)
        .foregroundColor(foregroundColor)
        .clipShape(Capsule())
        .accessibilityLabel("Difficulty: \(level.rawValue)")
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
