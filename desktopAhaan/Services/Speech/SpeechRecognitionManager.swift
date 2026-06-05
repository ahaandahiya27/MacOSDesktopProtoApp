import Foundation
import Combine
import Speech
import AVFoundation

/// Manages microphone input and speech-to-text
@MainActor
final class SpeechRecognitionManager: ObservableObject {
    @Published var isListening = false
    @Published var recognizedText = ""
    @Published var errorMessage: String?
    // Default to .notDetermined. The cached system value is read lazily
    // inside requestPermissions() to avoid spinning up Speech.framework
    // at every SpeechRecognitionManager() construction site — TranslatorScreen,
    // OCRTranslationScreen, and each DictationButton each create one, so
    // an eager read pegged ~500ms onto cold launch on Big Sur.
    @Published var authorizationStatus: SFSpeechRecognizerAuthorizationStatus = .notDetermined
    @Published var permissionsReady = false

    private var speechRecognizer: SFSpeechRecognizer?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?

    // Audio engine is created lazily to avoid triggering hardware init on
    // Simulator. Re-written to avoid `unsafelyUnwrapped` (which sets the
    // wrong tone even on a thread we control — every force-unwrap should
    // make a reader ask "what if?"). Class is `@MainActor`-isolated so
    // the if-let/assign sequence is race-free.
    private var _audioEngine: AVAudioEngine?
    private var audioEngine: AVAudioEngine {
        if let existing = _audioEngine { return existing }
        let engine = AVAudioEngine()
        _audioEngine = engine
        return engine
    }

    private var hasTapInstalled = false
    private var errorDismissTask: Task<Void, Never>?
    /// 30-second listening watchdog. Stored so a stop-then-start within the
    /// window can cancel the previous timer and avoid two stops racing.
    private var autoStopTask: Task<Void, Never>?

    /// Whether real audio hardware is available (false on Simulator)
    private var isAudioHardwareAvailable: Bool {
        #if targetEnvironment(simulator)
        return false
        #else
        return true
        #endif
    }

    /// Request permissions for speech recognition and microphone — call once early.
    /// Safe to call from multiple sites: if the system has already recorded an
    /// answer (authorized / denied / restricted) we early-return without hitting
    /// the OS API, so the user never sees the dialog more than once per install.
    func requestPermissions() {
        // Never fire the OS prompt under XCTest. ViewModelTests instantiates
        // TranslatorViewModel ~20 times in fast succession; without this guard
        // a fresh test run on a machine that hasn't yet answered the Speech
        // Recognition prompt will throw a blocking dialog mid-test-run.
        if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil {
            return
        }
        let cached = SFSpeechRecognizer.authorizationStatus()
        guard cached == .notDetermined else {
            // System already has an answer — mirror it and stop.
            if authorizationStatus != cached {
                authorizationStatus = cached
            }
            return
        }
        SFSpeechRecognizer.requestAuthorization { [weak self] status in
            Task { @MainActor [weak self] in
                self?.authorizationStatus = status
                if status == .authorized {
                    #if os(iOS) && !targetEnvironment(simulator)
                    // Only request mic permission on real device
                    if #available(iOS 17.0, *) {
                        let micGranted = await AVAudioApplication.requestRecordPermission()
                        self?.permissionsReady = micGranted
                    } else {
                        AVAudioSession.sharedInstance().requestRecordPermission { granted in
                            Task { @MainActor [weak self] in
                                self?.permissionsReady = granted
                            }
                        }
                    }
                    #endif
                }
            }
        }
    }

    /// Start listening in the given language
    func startListening(language: SupportedLanguage) {
        // Stop any existing session first
        stopListening()
        clearError()
        recognizedText = ""

        #if os(iOS) && targetEnvironment(simulator)
        showTemporaryError("Voice input is not available in the Simulator. Please type your text, or test on a real iPhone.")
        return
        #elseif os(iOS)
        startListeningOniOS(language: language)
        #elseif os(macOS)
        startListeningOnMac(language: language)
        #else
        showTemporaryError("Voice input is not supported on this platform.")
        #endif
    }

    #if os(iOS) && !targetEnvironment(simulator)
    /// Actual mic recording logic — only runs on real device hardware
    private func startListeningOniOS(language: SupportedLanguage) {
        // Check speech authorization
        guard authorizationStatus == .authorized else {
            if authorizationStatus == .notDetermined {
                requestPermissions()
                showTemporaryError("Microphone permission is needed. Please tap the mic button again after allowing access.")
            } else if authorizationStatus == .denied {
                showTemporaryError("Speech recognition is turned off. Go to Settings > Privacy > Speech Recognition to enable it.")
            } else {
                showTemporaryError("Speech recognition is not available. Please type your text instead.")
            }
            return
        }

        // Check microphone permission
        let audioSession = AVAudioSession.sharedInstance()
        guard audioSession.recordPermission == .granted else {
            showTemporaryError("Microphone access is needed. Go to Settings > Privacy > Microphone to enable it.")
            return
        }

        // Find a working speech recognizer
        var recognizerToUse: SFSpeechRecognizer?
        let locale = Locale(identifier: language.speechLocale)
        let primaryRecognizer = SFSpeechRecognizer(locale: locale)

        if primaryRecognizer?.isAvailable == true {
            recognizerToUse = primaryRecognizer
        } else if language == .sanskrit {
            // Sanskrit is rarely supported — try Hindi as fallback
            let hindiRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "hi-IN"))
            if hindiRecognizer?.isAvailable == true {
                recognizerToUse = hindiRecognizer
                showTemporaryError("Using Hindi voice mode for Sanskrit. Speak clearly in Devanagari.")
            }
        }

        // Try default locale as last resort
        if recognizerToUse == nil {
            let defaultRecognizer = SFSpeechRecognizer()
            if defaultRecognizer?.isAvailable == true {
                recognizerToUse = defaultRecognizer
                if language != .english {
                    showTemporaryError("Voice input for \(language.displayName) is not available. Using default language.")
                }
            }
        }

        guard let finalRecognizer = recognizerToUse else {
            showTemporaryError("Voice input is not available on this device right now. Please type your text instead.")
            return
        }

        speechRecognizer = finalRecognizer

        // Set up audio session for recording
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            showTemporaryError("Could not set up the microphone. Please close other apps using it and try again.")
            return
        }

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else {
            deactivateAudioSession()
            return
        }

        recognitionRequest.shouldReportPartialResults = true

        // Access the audio input node — this is safe on real device but we wrap it anyway
        let inputNode: AVAudioInputNode
        let recordingFormat: AVAudioFormat
        do {
            inputNode = audioEngine.inputNode
            recordingFormat = inputNode.outputFormat(forBus: 0)

            // Validate format is usable
            guard recordingFormat.sampleRate > 0, recordingFormat.channelCount > 0 else {
                showTemporaryError("Microphone returned invalid audio format. Please restart the app and try again.")
                deactivateAudioSession()
                return
            }
        } catch {
            showTemporaryError("Could not access the microphone. Please try again.")
            deactivateAudioSession()
            return
        }

        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            recognitionRequest.append(buffer)
        }
        hasTapInstalled = true

        recognitionTask = finalRecognizer.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            Task { @MainActor [weak self] in
                guard let self = self else { return }

                if let result = result {
                    self.recognizedText = result.bestTranscription.formattedString
                }

                if let error = error {
                    // Don't show cancellation errors (normal when user stops)
                    let nsError = error as NSError
                    if nsError.domain != "kAFAssistantErrorDomain" || nsError.code != 216 {
                        if self.recognizedText.isEmpty {
                            self.showTemporaryError("Could not understand speech. Please try again or type your text.")
                        }
                    }
                    self.stopListening()
                } else if result?.isFinal == true {
                    self.stopListening()
                }
            }
        }

        audioEngine.prepare()
        do {
            try audioEngine.start()
            isListening = true

            // Auto-stop after 30 seconds to prevent indefinite recording.
            // Stored + cancelled in stopListening so a quick restart within
            // the window doesn't race two stops.
            autoStopTask?.cancel()
            autoStopTask = Task { [weak self] in
                try? await Task.sleep(nanoseconds: 30_000_000_000)
                if Task.isCancelled { return }
                await MainActor.run { [weak self] in
                    if let self = self, self.isListening {
                        self.stopListening()
                    }
                }
            }
        } catch {
            showTemporaryError("Could not start listening. Please try again.")
            stopListening()
        }
    }
    #endif

    #if os(macOS)
    private func startListeningOnMac(language: SupportedLanguage) {
        guard authorizationStatus == .authorized else {
            if authorizationStatus == .notDetermined {
                requestPermissions()
                showTemporaryError("Microphone permission is needed. Please tap the mic button again after allowing access.")
            } else if authorizationStatus == .denied {
                showTemporaryError("Speech recognition is turned off. Enable Speech Recognition and Microphone access in System Settings.")
            } else {
                showTemporaryError("Speech recognition is not available. Please type your text instead.")
            }
            return
        }

        let locale = Locale(identifier: language.speechLocale)
        let recognizer = SFSpeechRecognizer(locale: locale) ?? SFSpeechRecognizer()
        guard let finalRecognizer = recognizer, finalRecognizer.isAvailable else {
            showTemporaryError("Voice input is not available right now. Please type your text instead.")
            return
        }
        speechRecognizer = finalRecognizer

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { return }
        recognitionRequest.shouldReportPartialResults = true
        // Prefer on-device transcription so nothing leaves the iMac. macOS 10.15+
        // honors this; falls back transparently if the locale lacks a local model.
        if finalRecognizer.supportsOnDeviceRecognition {
            recognitionRequest.requiresOnDeviceRecognition = true
        }

        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)

        guard recordingFormat.sampleRate > 0, recordingFormat.channelCount > 0 else {
            showTemporaryError("Microphone returned invalid audio format. Please check System Settings > Sound and try again.")
            return
        }

        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            recognitionRequest.append(buffer)
        }
        hasTapInstalled = true

        recognitionTask = finalRecognizer.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            Task { @MainActor [weak self] in
                guard let self = self else { return }
                if let result = result {
                    self.recognizedText = result.bestTranscription.formattedString
                }
                if error != nil || result?.isFinal == true {
                    self.stopListening()
                }
            }
        }

        audioEngine.prepare()
        do {
            try audioEngine.start()
            isListening = true

            autoStopTask?.cancel()
            autoStopTask = Task { [weak self] in
                try? await Task.sleep(nanoseconds: 30_000_000_000)
                if Task.isCancelled { return }
                await MainActor.run { [weak self] in
                    if let self = self, self.isListening {
                        self.stopListening()
                    }
                }
            }
        } catch {
            showTemporaryError("Could not start listening. Please try again.")
            stopListening()
        }
    }
    #endif

    /// Stop listening and clean up all resources
    func stopListening() {
        autoStopTask?.cancel()
        autoStopTask = nil
        if let engine = _audioEngine {
            if engine.isRunning {
                engine.stop()
            }
            if hasTapInstalled {
                engine.inputNode.removeTap(onBus: 0)
                hasTapInstalled = false
            }
        }

        recognitionRequest?.endAudio()
        recognitionRequest = nil
        recognitionTask?.cancel()
        recognitionTask = nil

        deactivateAudioSession()

        isListening = false
    }

    /// Dismiss the current error
    func clearError() {
        errorDismissTask?.cancel()
        errorMessage = nil
    }

    /// Show an error that auto-dismisses after a few seconds
    private func showTemporaryError(_ message: String) {
        errorMessage = message
        errorDismissTask?.cancel()
        errorDismissTask = Task { @MainActor [weak self] in
            try? await Task.sleep(nanoseconds: 10_000_000_000)
            if !Task.isCancelled {
                self?.errorMessage = nil
            }
        }
    }

    /// Safely deactivate the audio session so TTS and other audio can work
    private func deactivateAudioSession() {
        #if os(iOS) && !targetEnvironment(simulator)
        do {
            try AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        } catch {
            // Non-fatal
        }
        #endif
    }
}
