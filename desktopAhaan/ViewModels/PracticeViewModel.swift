import SwiftUI
import Combine

@MainActor
final class PracticeViewModel: ObservableObject {
    @Published var selectedCategory: PracticeCategory?
    @Published var currentItems: [PracticeItem] = []
    @Published var quizItem: PracticeItem?
    @Published var quizAnswer: String = ""
    @Published var quizResult: QuizResult?
    @Published var flashcardIndex: Int = 0
    @Published var showFlashcardAnswer: Bool = false
    @Published var dailyPhrase: PracticeItem?
    @Published var mode: PracticeMode = .categories

    let ttsManager = TextToSpeechManager()

    enum PracticeMode {
        case categories
        case flashcards
        case quiz
    }

    enum QuizResult {
        case correct
        case incorrect(correctAnswer: String)
    }

    func loadCategory(_ category: PracticeCategory) {
        selectedCategory = category
        currentItems = BuiltInContent.shared.items(for: category)
        flashcardIndex = 0
        showFlashcardAnswer = false
    }

    func loadDailyPhrase() {
        dailyPhrase = BuiltInContent.shared.dailyPhrase()
    }

    func nextFlashcard() {
        guard !currentItems.isEmpty else { return }
        showFlashcardAnswer = false
        flashcardIndex = (flashcardIndex + 1) % currentItems.count
    }

    func previousFlashcard() {
        guard !currentItems.isEmpty else { return }
        showFlashcardAnswer = false
        flashcardIndex = flashcardIndex > 0 ? flashcardIndex - 1 : currentItems.count - 1
    }

    func startQuiz(category: PracticeCategory) {
        let items = BuiltInContent.shared.items(for: category)
        quizItem = items.randomElement()
        quizAnswer = ""
        quizResult = nil
        mode = .quiz
    }

    func checkAnswer(dataStore: DataStore) {
        guard let item = quizItem else { return }

        let normalized = quizAnswer.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let correct = item.sanskrit.lowercased()
        let translitCorrect = item.transliteration.lowercased()
        let normalizedFolded = normalized.folding(options: .diacriticInsensitive, locale: .current)
        let translitFolded = translitCorrect.folding(options: .diacriticInsensitive, locale: .current)

        if normalized == correct || normalized == translitCorrect || normalizedFolded == translitFolded {
            quizResult = .correct
            updateProgress(phraseID: item.id, correct: true, dataStore: dataStore)
        } else {
            quizResult = .incorrect(correctAnswer: "\(item.sanskrit) (\(item.transliteration))")
            updateProgress(phraseID: item.id, correct: false, dataStore: dataStore)
        }
    }

    func nextQuizQuestion() {
        guard let category = selectedCategory else { return }
        let items = BuiltInContent.shared.items(for: category)
        quizItem = items.randomElement()
        quizAnswer = ""
        quizResult = nil
    }

    private func updateProgress(phraseID: String, correct: Bool, dataStore: DataStore) {
        let progress: PracticeProgress
        if let existing = dataStore.findProgress(phraseID: phraseID) {
            progress = existing
        } else {
            progress = PracticeProgress(phraseID: phraseID)
        }

        progress.timesAttempted += 1
        if correct { progress.timesCorrect += 1 }
        progress.lastPracticed = Date()
        if progress.accuracy >= 0.8 && progress.timesAttempted >= 3 {
            progress.isMastered = true
        }

        dataStore.upsertProgress(progress)
    }

    func speak(text: String, language: SupportedLanguage, transliteration: String? = nil) {
        ttsManager.speak(text: text, language: language, transliteration: transliteration)
    }
}
