import Foundation
import Combine
import AVFoundation

/// Manages text-to-speech for all supported languages
@MainActor
final class TextToSpeechManager: ObservableObject {
    @Published var isSpeaking = false

    private let synthesizer = AVSpeechSynthesizer()
    private var delegate: TTSDelegate?

    init() {
        delegate = TTSDelegate { [weak self] in
            Task { @MainActor in
                self?.isSpeaking = false
                #if os(iOS) && !targetEnvironment(simulator)
                // Deactivate audio session when done (real device only)
                try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
                #endif
            }
        }
        synthesizer.delegate = delegate
    }

    /// Speak text in the given language
    func speak(text: String, language: SupportedLanguage, transliteration: String? = nil) {
        stop()

        // Ensure audio session is configured for playback (not recording)
        // On Simulator, audio session setup can log warnings but TTS still works
        #if os(iOS) && !targetEnvironment(simulator)
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .default, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            // Non-fatal but TTS may not work
        }
        #endif

        // For Sanskrit output, prefer transliteration with Hindi voice if Devanagari voice unavailable
        let textToSpeak: String
        let voiceLocale: String

        if language == .sanskrit {
            // Try Hindi voice with transliteration for better pronunciation
            if let translit = transliteration, !translit.isEmpty {
                textToSpeak = translit
                voiceLocale = "en-IN" // English-India voice reads transliteration well
            } else {
                textToSpeak = text
                voiceLocale = "hi-IN" // Hindi voice as closest fallback for Devanagari
            }
        } else {
            textToSpeak = text
            voiceLocale = language.ttsLocale
        }

        guard !textToSpeak.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }

        let utterance = AVSpeechUtterance(string: textToSpeak)
        utterance.voice = AVSpeechSynthesisVoice(language: voiceLocale)
        // Fallback to any available voice if preferred locale isn't available
        if utterance.voice == nil {
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        }
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate * 0.85 // Slightly slower for learning
        utterance.pitchMultiplier = 1.0
        utterance.preUtteranceDelay = 0.1 // Small delay to let audio session activate

        isSpeaking = true
        synthesizer.speak(utterance)
    }

    func stop() {
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
        isSpeaking = false
    }

    /// Check if a voice is available for the language
    static func isVoiceAvailable(for language: SupportedLanguage) -> Bool {
        let locale = language.ttsLocale
        let voices = AVSpeechSynthesisVoice.speechVoices()
        return voices.contains { $0.language.hasPrefix(String(locale.prefix(2))) }
    }
}

/// Simple delegate to track speech completion
private class TTSDelegate: NSObject, AVSpeechSynthesizerDelegate {
    let onFinish: () -> Void

    init(onFinish: @escaping () -> Void) {
        self.onFinish = onFinish
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        onFinish()
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        onFinish()
    }
}
