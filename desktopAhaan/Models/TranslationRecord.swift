import Foundation
import os.log

private let recordLogger = Logger(subsystem: "com.emoha.desktopAhaan", category: "TranslationRecord")

final class TranslationRecord: Identifiable, Codable {
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
        do {
            self.wordByWordJSON = try JSONEncoder().encode(response.wordByWord)
        } catch {
            recordLogger.error("wordByWord encoding failed: \(error.localizedDescription, privacy: .public)")
            self.wordByWordJSON = nil
        }
        self.grammarNote = response.grammarNote
        self.learningTip = response.learningTip
        self.difficulty = response.difficulty.rawValue
        do {
            self.alternativesJSON = try JSONEncoder().encode(response.alternatives)
        } catch {
            recordLogger.error("alternatives encoding failed: \(error.localizedDescription, privacy: .public)")
            self.alternativesJSON = nil
        }
        self.confidenceNote = response.confidenceNote
        self.isFavorite = isFavorite
        self.createdAt = Date()
    }

    var asResponse: TranslationResponse {
        let words: [WordMeaning]? = wordByWordJSON.flatMap { data in
            do { return try JSONDecoder().decode([WordMeaning].self, from: data) }
            catch {
                recordLogger.error("wordByWord decode failed: \(error.localizedDescription, privacy: .public)")
                return nil
            }
        }
        let alts: [String]? = alternativesJSON.flatMap { data in
            do { return try JSONDecoder().decode([String].self, from: data) }
            catch {
                recordLogger.error("alternatives decode failed: \(error.localizedDescription, privacy: .public)")
                return nil
            }
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
