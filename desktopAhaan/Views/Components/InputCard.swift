import SwiftUI

struct InputCard: View {
    @Binding var text: String
    let sourceLanguage: SupportedLanguage
    let isListening: Bool
    var isFocused: FocusState<Bool>.Binding
    let onMicTap: () -> Void

    private let maxCharacters = 500

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Type in \(sourceLanguage.displayName)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
                Text("\(text.count)/\(maxCharacters)")
                    .font(.caption2)
                    .foregroundStyle(text.count > maxCharacters ? .red : .secondary)
            }

            TextEditor(text: $text)
                .focused(isFocused)
                .frame(minHeight: 100, maxHeight: 200)
                .scrollContentBackground(.hidden)
                .font(.body)
                .padding(8)
                .background(Color.gray.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .onChange(of: text) { _, newValue in
                    // Enforce character limit
                    if newValue.count > maxCharacters {
                        text = String(newValue.prefix(maxCharacters))
                    }
                }
                .accessibilityLabel("Text input for translation")

            HStack {
                // Done button to dismiss keyboard
                if isFocused.wrappedValue {
                    Button(action: { isFocused.wrappedValue = false }) {
                        HStack(spacing: 4) {
                            Image(systemName: "keyboard.chevron.compact.down")
                            Text("Done")
                                .font(.caption)
                        }
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.gray.opacity(0.2))
                        .clipShape(Capsule())
                    }
                }

                Spacer()

                // Mic button
                Button(action: onMicTap) {
                    HStack(spacing: 6) {
                        Image(systemName: isListening ? "mic.fill" : "mic")
                            .symbolEffect(.pulse, isActive: isListening)
                        Text(isListening ? "Listening..." : "Speak")
                            .font(.caption)
                    }
                    .foregroundStyle(isListening ? .red : .indigo)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(isListening ? Color.red.opacity(0.1) : Color.indigo.opacity(0.1))
                    .clipShape(Capsule())
                }
                .accessibilityLabel(isListening ? "Stop listening" : "Speak to translate")
            }
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 8, y: 2)
        .padding(.horizontal)
    }
}
