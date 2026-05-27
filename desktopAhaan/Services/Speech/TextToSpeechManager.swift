import Foundation
import Combine
import AVFoundation

/// Manages text-to-speech for all supported languages
@MainActor
final class TextToSpeechManager: ObservableObject {
    @Published var isSpeaking = false

    private let synthesizer = AVSpeechSynthesizer()
    private var delegate: TTSDelegate?

    /// True after a Sanskrit utterance had to be voiced with a non-Devanagari
    /// (e.g. English) voice because no Hindi / Devanagari voice is installed.
    /// Surfaces the otherwise-silent fallback so callers can decide whether to
    /// warn; reset to `false` whenever a suitable voice is found.
    @Published private(set) var sanskritVoiceUnavailable = false

    /// Guards the once-per-process diagnostic log for a missing Devanagari voice.
    private var loggedMissingSanskritVoice = false

    init() {
        delegate = TTSDelegate { [weak self] in
            Task { @MainActor [weak self] in
                self?.isSpeaking = false
            }
        }
        synthesizer.delegate = delegate
    }

    /// Speak text in the given language
    func speak(text: String, language: SupportedLanguage, transliteration: String? = nil) {
        stop()

        let textToSpeak: String
        let resolvedVoice: AVSpeechSynthesisVoice?

        if language == .sanskrit {
            // Sanskrit has no dedicated voice. Prefer a Hindi / Devanagari voice;
            // if a Roman transliteration exists, an English-India voice reads it
            // more naturally. Resolve deliberately and signal an honest fallback
            // when no Devanagari-capable voice is installed.
            if let translit = transliteration, !translit.isEmpty {
                textToSpeak = translit
                // Transliteration is Roman text: en-IN reads it well; fall back
                // through the deliberate chain rather than silently to en-US.
                resolvedVoice = Self.bestVoice(for: ["en-IN", "en-GB", "en-US"])
                // Roman text in an English voice is the intended path, not a
                // degraded one — do not raise the Sanskrit-unavailable signal.
                sanskritVoiceUnavailable = false
            } else {
                textToSpeak = text
                let hindiVoice = Self.bestVoice(for: ["hi-IN"])
                if let voice = hindiVoice {
                    resolvedVoice = voice
                    sanskritVoiceUnavailable = false
                } else {
                    // No Hindi / Devanagari voice installed. Devanagari text in an
                    // English voice is gibberish, so make the gap visible instead
                    // of pretending it worked.
                    resolvedVoice = Self.bestVoice(for: ["en-IN", "en-US"])
                    sanskritVoiceUnavailable = true
                    if !loggedMissingSanskritVoice {
                        loggedMissingSanskritVoice = true
                        CrashReporter.shared.logDataIssue(
                            "No Hindi/Devanagari (hi-IN) TTS voice installed; Sanskrit Devanagari will be read with a non-Devanagari voice. Install a Hindi voice in System Preferences > Accessibility > Spoken Content."
                        )
                    }
                }
            }
        } else {
            textToSpeak = text
            // Preferred locale first, then a generic English voice as a last resort.
            resolvedVoice = Self.bestVoice(for: [language.ttsLocale, "en-US"])
        }

        guard !textToSpeak.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }

        let utterance = AVSpeechUtterance(string: textToSpeak)
        utterance.voice = resolvedVoice
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate * 0.85 // Slightly slower for learning
        utterance.pitchMultiplier = 1.0
        utterance.preUtteranceDelay = 0.1 // Small delay to let audio settle

        isSpeaking = true
        synthesizer.speak(utterance)
    }

    /// Returns the first available voice for the given ordered list of BCP-47
    /// locale identifiers, or `nil` if none resolve. Matching tries an exact
    /// locale first, then any installed voice whose language shares the same
    /// two-letter prefix (e.g. any `hi-*` for `hi-IN`).
    private static func bestVoice(for preferredLocales: [String]) -> AVSpeechSynthesisVoice? {
        let installed = AVSpeechSynthesisVoice.speechVoices()
        for locale in preferredLocales {
            if let exact = AVSpeechSynthesisVoice(language: locale) {
                return exact
            }
            let prefix = String(locale.prefix(2))
            if let match = installed.first(where: { $0.language.hasPrefix(prefix) }) {
                return match
            }
        }
        return nil
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
