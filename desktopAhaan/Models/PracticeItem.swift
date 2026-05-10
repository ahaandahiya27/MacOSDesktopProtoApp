import Foundation

/// A built-in vocabulary/phrase item for practice mode
struct PracticeItem: Identifiable, Codable {
    let id: String
    let category: PracticeCategory
    let english: String
    let hindi: String
    let sanskrit: String
    let transliteration: String
    let grammarNote: String?
    let difficulty: DifficultyLevel
}

enum PracticeCategory: String, Codable, CaseIterable, Identifiable {
    case greetings = "Greetings"
    case numbers = "Numbers"
    case family = "Family"
    case classroom = "Classroom"
    case dailyActions = "Daily Actions"
    case schoolPhrases = "School Phrases"
    case simpleSentences = "Simple Sentences"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .greetings: return "hand.wave.fill"
        case .numbers: return "number.circle.fill"
        case .family: return "figure.2.and.child.holdinghands"
        case .classroom: return "book.fill"
        case .dailyActions: return "sun.max.fill"
        case .schoolPhrases: return "pencil.and.ruler.fill"
        case .simpleSentences: return "text.bubble.fill"
        }
    }
}
