import AVFoundation
import Combine

/// A singleton service for reading aloud article text and concept explanations.
/// Independent from TextToSpeechManager; used by ArticleBrowserView and ConceptDetailView.
@MainActor
final class SpeechReader: NSObject, ObservableObject {
    static let shared = SpeechReader()

    @Published private(set) var isSpeaking: Bool = false
    @Published private(set) var isPaused: Bool = false

    /// Paragraph-mode state. Set by `speakParagraphs(_:owner:startingAt:)`.
    /// `paragraphIndex` advances on each utterance's `didFinish`; the UI
    /// uses `paragraphCount` + `paragraphIndex` to render "¶ N / M" and
    /// to enable/disable the prev/next-paragraph buttons.
    @Published private(set) var isParagraphMode: Bool = false
    @Published private(set) var paragraphIndex: Int = 0
    @Published private(set) var paragraphCount: Int = 0

    private let synthesizer = AVSpeechSynthesizer()
    private var currentUtterance: AVSpeechUtterance?
    /// The identifier of the view that owns the current utterance.
    private(set) var currentOwner: String?

    /// Original paragraph text array. Held so `skipParagraph(forward:)`
    /// can re-queue from any earlier index after stopping the current
    /// queue. Cleared on `stop()` and when the natural end of the queue
    /// is reached.
    private var paragraphs: [String] = []

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

    /// Speak the given paragraphs sequentially. Each non-empty paragraph
    /// becomes its own AVSpeechUtterance, queued in order on the
    /// synthesizer. The auto-advance is handled by the synth itself —
    /// when one utterance finishes, the next plays — so pause/resume
    /// crosses paragraph boundaries cleanly.
    ///
    /// Enters "paragraph mode" so the UI can show "¶ N / M" and enable
    /// the prev/next-paragraph buttons. The mode exits on `stop()` or
    /// when the natural end of the queue is reached (see `didFinish`
    /// delegate).
    func speakParagraphs(_ list: [String], owner: String? = nil, startingAt: Int = 0) {
        let settings = SettingsManager.shared
        let effectiveRate = AVSpeechUtteranceDefaultSpeechRate * settings.speechRate
        let effectiveLang = settings.speechLanguage

        // Compact away empty/whitespace-only paragraphs (the stripHTML
        // reducer can produce them at section boundaries).
        let nonEmpty = list.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        guard !nonEmpty.isEmpty else { return }
        let start = max(0, min(startingAt, nonEmpty.count - 1))

        stop()
        currentOwner = owner
        paragraphs = nonEmpty
        paragraphCount = nonEmpty.count
        paragraphIndex = start
        isParagraphMode = true

        for paragraph in nonEmpty[start..<nonEmpty.count] {
            let utterance = AVSpeechUtterance(string: paragraph)
            if let voice = AVSpeechSynthesisVoice(language: effectiveLang) {
                utterance.voice = voice
            } else if let fallback = AVSpeechSynthesisVoice(language: "en-US") {
                utterance.voice = fallback
            }
            utterance.rate = effectiveRate
            utterance.pitchMultiplier = 1.0
            synthesizer.speak(utterance)
        }
        currentUtterance = nil  // queue spans multiple — no single "current"
        isSpeaking = true
        isPaused = false
    }

    /// Skip to the previous or next paragraph in paragraph mode. No-op
    /// outside paragraph mode or at the queue boundary. Cancels the
    /// current synth queue and re-queues from the target index. The
    /// `didCancel` delegate will fire async; its handler is paragraph-
    /// mode-aware so it doesn't wipe the new queue's `isSpeaking` state.
    func skipParagraph(forward: Bool) {
        guard isParagraphMode else { return }
        let next = forward ? paragraphIndex + 1 : paragraphIndex - 1
        guard next >= 0, next < paragraphCount else { return }

        // Re-queue from `next`. `speakParagraphs` calls `stop()` which
        // resets paragraph state, but we restore via the captured array.
        let savedOwner = currentOwner
        let savedParagraphs = paragraphs
        speakParagraphs(savedParagraphs, owner: savedOwner, startingAt: next)
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
            // Called on MainActor (whole class is @MainActor). AVSpeechSynthesizer
            // is not Sendable, so we can't capture it in a @Sendable DispatchQueue
            // closure on Big Sur's Swift 5.5. stopSpeaking is fast enough to call
            // synchronously here.
            synthesizer.stopSpeaking(at: .immediate)
        }
        isSpeaking = false
        isPaused = false
        currentUtterance = nil
        currentOwner = nil
        paragraphs = []
        paragraphCount = 0
        paragraphIndex = 0
        isParagraphMode = false
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
            // In paragraph mode, didFinish fires per-paragraph as the
            // synth advances through the queue. Increment `paragraphIndex`
            // until we hit the end, then reset to idle. Outside paragraph
            // mode it's a one-shot — just reset.
            if self.isParagraphMode {
                if self.paragraphIndex + 1 >= self.paragraphCount {
                    self.isSpeaking = false
                    self.isPaused = false
                    self.paragraphs = []
                    self.paragraphCount = 0
                    self.paragraphIndex = 0
                    self.isParagraphMode = false
                } else {
                    self.paragraphIndex += 1
                    // isSpeaking stays true — next utterance is already
                    // queued and will start automatically.
                }
            } else {
                self.isSpeaking = false
                self.isPaused = false
            }
        }
    }

    nonisolated func speechSynthesizer(
        _ synthesizer: AVSpeechSynthesizer,
        didCancel utterance: AVSpeechUtterance
    ) {
        Task { @MainActor in
            // Cancel fires for each queued utterance when stopSpeaking is
            // called. If a fresh queue has already been kicked off (e.g.
            // via skipParagraph re-queueing), `synthesizer.isSpeaking` is
            // true and we must NOT wipe `isSpeaking` — otherwise we'd
            // flicker the UI between cancel and the next didStart.
            if !synthesizer.isSpeaking {
                self.isSpeaking = false
                self.isPaused = false
            }
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
