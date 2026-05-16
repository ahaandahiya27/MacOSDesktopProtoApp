import SwiftUI

struct InputCard: View {
    @Binding var text: String
    let sourceLanguage: SupportedLanguage
    let isListening: Bool
    let onMicTap: () -> Void

    private let maxCharacters = 500

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Type in \(sourceLanguage.displayName)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Text("\(text.count)/\(maxCharacters)")
                    .font(.caption2)
                    .foregroundColor(text.count > maxCharacters ? .red : .secondary)
            }

            TextEditor(text: $text)
                .frame(minHeight: 100, maxHeight: 200)
                .font(.body)
                .padding(8)
                .background(Color.gray.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .onChange(of: text) { newValue in
                    if newValue.count > maxCharacters {
                        text = String(newValue.prefix(maxCharacters))
                    }
                }
                .accessibilityLabel("Text input for translation")

            HStack {
                Spacer()

                Button(action: onMicTap) {
                    HStack(spacing: 6) {
                        Image(systemName: isListening ? "mic.fill" : "mic")
                        Text(isListening ? "Listening..." : "Speak")
                            .font(.caption)
                    }
                    .foregroundColor(isListening ? .red : Color.compatIndigo)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(isListening ? Color.red.opacity(0.1) : Color.compatIndigo.opacity(0.1))
                    .clipShape(Capsule())
                }
                .accessibilityLabel(isListening ? "Stop listening" : "Speak to translate")
            }
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 8, y: 2)
        .padding(.horizontal)
    }
}
