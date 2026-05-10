import Foundation
import SwiftData

/// Persistent record of a translation saved in SwiftData
@Model
final class TranslationRecord {
    var id: UUID
    var sourceLanguage: String
    var targetLanguage: String
    var originalText: String
    var translatedText: String
    var transliteration: String?
    var wordByWordJSON: Data?
    var grammarNote: String?
    var learningTip: String?
    var difficulty: String
    var alternativesJSON: Data?
    var confidenceNote: String?
    var isFavorite: Bool
    var createdAt: Date

    init(
        from response: TranslationResponse,
        isFavorite: Bool = false
    ) {
        self.id = UUID()
        self.sourceLanguage = response.sourceLanguage
        self.targetLanguage = response.targetLanguage
        self.originalText = response.originalText
        self.translatedText = response.translatedText
        self.transliteration = response.transliteration
        self.wordByWordJSON = try? JSONEncoder().encode(response.wordByWord)
        self.grammarNote = response.grammarNote
        self.learningTip = response.learningTip
        self.difficulty = response.difficulty.rawValue
        self.alternativesJSON = try? JSONEncoder().encode(response.alternatives)
        self.confidenceNote = response.confidenceNote
        self.isFavorite = isFavorite
        self.createdAt = Date()
    }

    /// Convert back to a TranslationResponse for display
    var asResponse: TranslationResponse {
        let words: [WordMeaning]? = wordByWordJSON.flatMap {
            try? JSONDecoder().decode([WordMeaning].self, from: $0)
        }
        let alts: [String]? = alternativesJSON.flatMap {
            try? JSONDecoder().decode([String].self, from: $0)
        }
        return TranslationResponse(
            sourceLanguage: sourceLanguage,
            targetLanguage: targetLanguage,
            originalText: originalText,
            translatedText: translatedText,
            transliteration: transliteration,
            wordByWord: words,
            grammarNote: grammarNote,
            learningTip: learningTip,
            difficulty: DifficultyLevel(rawValue: difficulty) ?? .medium,
            alternatives: alts,
            confidenceNote: confidenceNote
        )
    }
}
