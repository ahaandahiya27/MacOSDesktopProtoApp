import SwiftUI
import Combine
import SwiftData
import Combine

/// ViewModel for the main translator screen
@MainActor
final class TranslatorViewModel: ObservableObject {
    @Published var sourceLanguage: SupportedLanguage = .english
    @Published var targetLanguage: SupportedLanguage = .sanskrit
    @Published var inputText: String = ""
    @Published var result: TranslationResponse?
    @Published var isTranslating: Bool = false
    @Published var errorMessage: String?
    @Published var showResult: Bool = false
    @Published var translationSource: String = "" // "Built-in Dictionary" or "Online Translation"
    @Published var isFavorited: Bool = false

    let speechManager = SpeechRecognitionManager()
    let ttsManager = TextToSpeechManager()

    private let translationService: TranslationService
    private let settings: SettingsManager
    private var cancellables = Set<AnyCancellable>()

    init(translationService: TranslationService? = nil, settings: SettingsManager? = nil) {
        self.translationService = translationService ?? TranslationService.shared
        self.settings = settings ?? SettingsManager.shared

        // Observe speech recognition text and sync to input field automatically
        speechManager.$recognizedText
            .receive(on: RunLoop.main)
            .sink { [weak self] text in
                guard let self = self, self.speechManager.isListening, !text.isEmpty else { return }
                self.inputText = text
            }
            .store(in: &cancellables)

        // Request mic/speech permissions early so first tap works
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

    /// Perform translation — tries dictionary first, then online if available
    func translate(modelContext: ModelContext, isOnline: Bool) async {
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

            // Save to history
            let record = TranslationRecord(from: response)
            modelContext.insert(record)
            modelContext.safeSave()

            // Check if already favorited (from a previous identical translation)
            checkFavoriteStatus(for: response, modelContext: modelContext)
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

    func toggleFavorite(for response: TranslationResponse, modelContext: ModelContext) {
        let original = response.originalText
        let translated = response.translatedText
        let srcLang = response.sourceLanguage
        let tgtLang = response.targetLanguage
        let descriptor = FetchDescriptor<TranslationRecord>(
            predicate: #Predicate { $0.originalText == original && $0.translatedText == translated && $0.sourceLanguage == srcLang && $0.targetLanguage == tgtLang },
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        if let records = try? modelContext.fetch(descriptor),
           let record = records.first {
            record.isFavorite.toggle()
            isFavorited = record.isFavorite
            modelContext.safeSave()
        }
    }

    private func checkFavoriteStatus(for response: TranslationResponse, modelContext: ModelContext) {
        let original = response.originalText
        let translated = response.translatedText
        let srcLang = response.sourceLanguage
        let tgtLang = response.targetLanguage
        let descriptor = FetchDescriptor<TranslationRecord>(
            predicate: #Predicate { $0.originalText == original && $0.translatedText == translated && $0.sourceLanguage == srcLang && $0.targetLanguage == tgtLang },
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        if let records = try? modelContext.fetch(descriptor),
           let record = records.first {
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
