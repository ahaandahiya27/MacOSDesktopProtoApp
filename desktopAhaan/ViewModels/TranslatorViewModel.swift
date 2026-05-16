import SwiftUI
import Combine

@MainActor
final class TranslatorViewModel: ObservableObject {
    @Published var sourceLanguage: SupportedLanguage = .english
    @Published var targetLanguage: SupportedLanguage = .sanskrit
    @Published var inputText: String = ""
    @Published var result: TranslationResponse?
    @Published var isTranslating: Bool = false
    @Published var errorMessage: String?
    @Published var showResult: Bool = false
    @Published var translationSource: String = ""
    @Published var isFavorited: Bool = false

    let speechManager = SpeechRecognitionManager()
    let ttsManager = TextToSpeechManager()

    private let translationService: TranslationService
    private let settings: SettingsManager
    private var cancellables = Set<AnyCancellable>()

    init(translationService: TranslationService? = nil, settings: SettingsManager? = nil) {
        self.translationService = translationService ?? TranslationService.shared
        self.settings = settings ?? SettingsManager.shared

        speechManager.$recognizedText
            .receive(on: RunLoop.main)
            .sink { [weak self] text in
                guard let self = self, self.speechManager.isListening, !text.isEmpty else { return }
                self.inputText = text
            }
            .store(in: &cancellables)

        speechManager.requestPermissions()
    }

    func swapLanguages() {
        let newSource = targetLanguage
        let newTarget = sourceLanguage
        if TranslationPair(source: newSource, target: newTarget).isValid {
            sourceLanguage = newSource
            targetLanguage = newTarget
        }
    }

    func onSourceChanged() {
        if !sourceLanguage.validTargets.contains(targetLanguage) {
            targetLanguage = sourceLanguage.validTargets.first ?? .sanskrit
        }
    }

    func translate(dataStore: DataStore, isOnline: Bool) async {
        let trimmed = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            errorMessage = "Please type something to translate."
            return
        }

        isTranslating = true
        errorMessage = nil
        result = nil
        showResult = false
        isFavorited = false

        do {
            let response = try await translationService.translate(
                text: trimmed,
                from: sourceLanguage,
                to: targetLanguage,
                preferOffline: settings.preferOffline,
                isOnline: isOnline
            )
            result = response
            showResult = true
            translationSource = translationService.lastUsedProvider

            let record = TranslationRecord(from: response)
            dataStore.insert(record)

            checkFavoriteStatus(for: response, dataStore: dataStore)
        } catch {
            errorMessage = error.localizedDescription
        }

        isTranslating = false
    }

    func clear() {
        inputText = ""
        result = nil
        errorMessage = nil
        showResult = false
        translationSource = ""
        isFavorited = false
    }

    func toggleFavorite(for response: TranslationResponse, dataStore: DataStore) {
        if let record = dataStore.findRecord(
            original: response.originalText,
            translated: response.translatedText,
            srcLang: response.sourceLanguage,
            tgtLang: response.targetLanguage
        ) {
            record.isFavorite.toggle()
            isFavorited = record.isFavorite
            dataStore.saveTranslations()
        }
    }

    private func checkFavoriteStatus(for response: TranslationResponse, dataStore: DataStore) {
        if let record = dataStore.findRecord(
            original: response.originalText,
            translated: response.translatedText,
            srcLang: response.sourceLanguage,
            tgtLang: response.targetLanguage
        ) {
            isFavorited = record.isFavorite
        }
    }

    func startVoiceInput() {
        if speechManager.isListening {
            speechManager.stopListening()
        } else {
            speechManager.startListening(language: sourceLanguage)
        }
    }

    func speakResult() {
        guard let result = result else { return }
        let lang = SupportedLanguage(rawValue: result.targetLanguage) ?? .sanskrit
        ttsManager.speak(text: result.translatedText, language: lang, transliteration: result.transliteration)
    }
}
