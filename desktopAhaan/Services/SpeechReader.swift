import AVFoundation
import Combine

/// A singleton service for reading aloud article text and concept explanations.
/// Independent from TextToSpeechManager; used by ArticleBrowserView and ConceptDetailView.
@MainActor
final class SpeechReader: NSObject, ObservableObject {
    static let shared = SpeechReader()

    @Published private(set) var isSpeaking: Bool = false
    @Published private(set) var isPaused: Bool = false

    private let synthesizer = AVSpeechSynthesizer()
    private var currentUtterance: AVSpeechUtterance?
    /// The identifier of the view that owns the current utterance.
    private(set) var currentOwner: String?

    override init() {
        super.init()
        synthesizer.delegate = self
    }

    /// Speak the given text aloud.
    /// Stops any current speech before starting new speech.
    func speak(_ text: String, owner: String? = nil, rate: Float? = nil, lang: String? = nil) {
        let settings = SettingsManager.shared
        let effectiveRate = rate ?? (AVSpeechUtteranceDefaultSpeechRate * settings.speechRate)
        let effectiveLang = lang ?? settings.speechLanguage
        stop()
        currentOwner = owner

        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }

        let utterance = AVSpeechUtterance(string: text)

        if let voice = AVSpeechSynthesisVoice(language: effectiveLang) {
            utterance.voice = voice
        } else if let fallback = AVSpeechSynthesisVoice(language: "en-US") {
            utterance.voice = fallback
        }

        utterance.rate = effectiveRate
        utterance.pitchMultiplier = 1.0

        currentUtterance = utterance
        isSpeaking = true
        isPaused = false
        synthesizer.speak(utterance)
    }

    /// Pause the current speech.
    func pause() {
        guard isSpeaking && !isPaused else { return }
        synthesizer.pauseSpeaking(at: .word)
        isPaused = true
        isSpeaking = false
    }

    /// Resume paused speech.
    func resume() {
        guard isPaused else { return }
        synthesizer.continueSpeaking()
        isPaused = false
        isSpeaking = true
    }

    /// Stop the current speech entirely.
    /// When `owner` is provided, only stops if the current utterance belongs to that owner.
    func stop(owner: String? = nil) {
        if let owner = owner, let currentOwner = currentOwner, owner != currentOwner { return }
        if isSpeaking || isPaused {
            let synth = synthesizer
            DispatchQueue.global(qos: .userInitiated).async {
                synth.stopSpeaking(at: .immediate)
            }
        }
        isSpeaking = false
        isPaused = false
        currentUtterance = nil
        currentOwner = nil
    }
}

// MARK: - AVSpeechSynthesizerDelegate

extension SpeechReader: AVSpeechSynthesizerDelegate {
    nonisolated func speechSynthesizer(
        _ synthesizer: AVSpeechSynthesizer,
        didStart utterance: AVSpeechUtterance
    ) {
        Task { @MainActor in
            self.isSpeaking = true
            self.isPaused = false
        }
    }

    nonisolated func speechSynthesizer(
        _ synthesizer: AVSpeechSynthesizer,
        didFinish utterance: AVSpeechUtterance
    ) {
        Task { @MainActor in
            self.isSpeaking = false
            self.isPaused = false
        }
    }

    nonisolated func speechSynthesizer(
        _ synthesizer: AVSpeechSynthesizer,
        didCancel utterance: AVSpeechUtterance
    ) {
        Task { @MainActor in
            self.isSpeaking = false
            self.isPaused = false
        }
    }

    nonisolated func speechSynthesizer(
        _ synthesizer: AVSpeechSynthesizer,
        didPause utterance: AVSpeechUtterance
    ) {
        Task { @MainActor in
            self.isSpeaking = false
            self.isPaused = true
        }
    }

    nonisolated func speechSynthesizer(
        _ synthesizer: AVSpeechSynthesizer,
        didContinue utterance: AVSpeechUtterance
    ) {
        Task { @MainActor in
            self.isSpeaking = true
            self.isPaused = false
        }
    }
}
