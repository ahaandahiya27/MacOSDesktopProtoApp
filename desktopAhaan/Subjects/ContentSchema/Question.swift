import Foundation

enum QuestionType: String, Codable, Hashable {
    case mcq
    case fillInBlank
    case shortAnswer
    case longAnswer
    case numerical
    case matchTheFollowing
    case trueFalse

    var displayName: String {
        switch self {
        case .mcq:                return "Multiple choice"
        case .fillInBlank:        return "Fill in the blank"
        case .shortAnswer:        return "Short answer"
        case .longAnswer:         return "Long answer"
        case .numerical:          return "Numerical"
        case .matchTheFollowing:  return "Match the following"
        case .trueFalse:          return "True / False"
        }
    }
}

/// A twisted version of a question — same concept, different numbers or
/// scenario. The pipeline requires at least two per question so the kid can
/// drill the same idea more than once.
struct QuestionVariation: Codable, Hashable, Identifiable {
    var id: String { prompt }

    let prompt: String
    let answer: String
    let solutionSteps: [String]
}

/// A question from the textbook, with a worked solution, common-mistake notes,
/// and 2+ variations.
struct Question: Codable, Hashable, Identifiable {
    let id: String                  // e.g. "ch01_t02_q07"
    let prompt: String
    let questionType: QuestionType
    let options: [String]?          // non-nil for `.mcq`
    let answer: String
    let solutionSteps: [String]
    let commonMistakes: [String]
    let variations: [QuestionVariation]
    let difficulty: Int             // 1 = recall, 5 = evaluate/create
    let pageRefs: [Int]
    let needsHumanReview: Bool
}
