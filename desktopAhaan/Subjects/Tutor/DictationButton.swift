import SwiftUI

/// Microphone button that uses the on-device SFSpeechRecognizer (via
/// SpeechRecognitionManager) to transcribe the user's speech into a bound
/// String. Designed for the kid's free-text answer field — voice in, text out,
/// zero network calls.
///
/// Tap to start listening, tap again to stop. The recognizer auto-stops after
/// 30 seconds. Partial results are pushed into `transcript` as they come in.
struct DictationButton: View {
    @Binding var transcript: String

    @StateObject private var speech = SpeechRecognitionManager()
    @State private var lastTranscriptSeed: String = ""

    var body: some View {
        Button(action: toggle) {
            Image(systemName: speech.isListening ? "mic.fill" : "mic")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(speech.isListening ? .red : Color.compatIndigo)
                .frame(width: 28, height: 24)
                .background(
                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                        .fill((speech.isListening ? Color.red : Color.compatIndigo).opacity(0.12))
                )
        }
        .buttonStyle(.plain)
        .help(speech.isListening ? "Stop dictation" : "Speak your answer — runs on this Mac, no internet needed")
        .accessibilityLabel(speech.isListening ? "Stop dictation" : "Start dictation")
        .onAppear { speech.requestPermissions() }
        .onChange(of: speech.recognizedText) { newValue in
            // Only overwrite the field if the recognizer is actively
            // producing text. Append on top of whatever was already typed
            // when the user started dictating.
            guard !newValue.isEmpty else { return }
            transcript = lastTranscriptSeed.isEmpty
                ? newValue
                : "\(lastTranscriptSeed) \(newValue)"
        }
    }

    private func toggle() {
        if speech.isListening {
            speech.stopListening()
        } else {
            lastTranscriptSeed = transcript.trimmingCharacters(in: .whitespacesAndNewlines)
            speech.startListening(language: .english)
        }
    }
}
