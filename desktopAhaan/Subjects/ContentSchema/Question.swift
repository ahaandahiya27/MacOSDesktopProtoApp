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

/// One left-right pair for a Match-the-following question. The user has
/// to associate every `left` with its `right`.
struct MatchPair: Codable, Hashable, Identifiable {
    var id: String { left }
    let left: String
    let right: String
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
    /// Left/right pairs for `.matchTheFollowing` questions. Optional so old
    /// pack JSON files without this field continue to decode unchanged.
    let matchPairs: [MatchPair]?

    private enum CodingKeys: String, CodingKey {
        case id, prompt, questionType, options, answer, solutionSteps,
             commonMistakes, variations, difficulty, pageRefs, needsHumanReview,
             matchPairs
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(String.self, forKey: .id)
        prompt = try c.decode(String.self, forKey: .prompt)
        questionType = try c.decode(QuestionType.self, forKey: .questionType)
        options = try c.decodeIfPresent([String].self, forKey: .options)
        answer = try c.decode(String.self, forKey: .answer)
        solutionSteps = try c.decode([String].self, forKey: .solutionSteps)
        commonMistakes = try c.decode([String].self, forKey: .commonMistakes)
        variations = try c.decode([QuestionVariation].self, forKey: .variations)
        difficulty = try c.decode(Int.self, forKey: .difficulty)
        pageRefs = try c.decode([Int].self, forKey: .pageRefs)
        needsHumanReview = try c.decode(Bool.self, forKey: .needsHumanReview)
        matchPairs = try c.decodeIfPresent([MatchPair].self, forKey: .matchPairs)
    }

    /// Memberwise init for any in-code synthesis (e.g. tests, defaults).
    init(id: String, prompt: String, questionType: QuestionType,
         options: [String]?, answer: String, solutionSteps: [String],
         commonMistakes: [String], variations: [QuestionVariation],
         difficulty: Int, pageRefs: [Int], needsHumanReview: Bool,
         matchPairs: [MatchPair]? = nil) {
        self.id = id
        self.prompt = prompt
        self.questionType = questionType
        self.options = options
        self.answer = answer
        self.solutionSteps = solutionSteps
        self.commonMistakes = commonMistakes
        self.variations = variations
        self.difficulty = difficulty
        self.pageRefs = pageRefs
        self.needsHumanReview = needsHumanReview
        self.matchPairs = matchPairs
    }
}
