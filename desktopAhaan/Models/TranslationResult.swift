import Foundation

/// The structured response from a translation operation
struct TranslationResponse: Codable, Equatable {
    let sourceLanguage: String
    let targetLanguage: String
    let originalText: String
    let translatedText: String
    let transliteration: String?
    let wordByWord: [WordMeaning]?
    let grammarNote: String?
    let learningTip: String?
    let difficulty: DifficultyLevel
    let alternatives: [String]?
    let confidenceNote: String?
}

struct WordMeaning: Codable, Equatable, Identifiable {
    var id: String { "\(source)→\(target):\(note ?? "")" }
    let source: String
    let target: String
    let note: String?
}

enum DifficultyLevel: String, Codable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"

    var color: String {
        switch self {
        case .easy: return "green"
        case .medium: return "orange"
        case .hard: return "red"
        }
    }

    var emoji: String {
        switch self {
        case .easy: return "🟢"
        case .medium: return "🟡"
        case .hard: return "🔴"
        }
    }
}
