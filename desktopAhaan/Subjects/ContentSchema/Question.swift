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

    /// Where this Question originated. Optional so the existing 732
    /// textbook questions in `science_class7.json` decode unchanged
    /// (nil → `.bookEnd` semantically). Boss-quiz and scene-quick-check
    /// items synthesised in Swift literals pass `.bossQuiz` /
    /// `.sceneQuickCheck` via the memberwise init.
    let source: QuestionSource?

    /// Optional progressive hints. When nil, the hint ladder UI in
    /// `QuestionDetailView` derives hints from `solutionSteps.prefix(2)`
    /// so authored content keeps working without a per-question hints
    /// authoring pass. Existing pack JSON omits this field — the
    /// `decodeIfPresent` call below keeps that path clean.
    let hints: [String]?

    /// Resolved source — never nil. Use this everywhere the view code
    /// needs a concrete case; falls back to the schema-level default
    /// when the JSON field was absent.
    var effectiveSource: QuestionSource { source ?? QuestionSource.default }

    /// Up to 2 progressive hints for the hint ladder (D5). Uses the
    /// authored `hints` if present; otherwise derives from the first
    /// 2 entries of `solutionSteps`. Shorter than 2 when the
    /// question has fewer solution steps. Returned in display order
    /// (first hint first).
    ///
    /// The view code reads this and renders Tier 1 / Tier 2 buttons;
    /// Tier 3 is always "Show full solution" (answer + every step).
    var derivedHints: [String] {
        if let hints = hints, !hints.isEmpty {
            return Array(hints.prefix(2))
        }
        return Array(solutionSteps.prefix(2))
    }

    /// Map the highest revealed hint tier (0 = none, 1 = first hint,
    /// 2 = second hint, 3 = full solution) to a default SRS quality
    /// for a correct answer. The kid still chooses; this is the
    /// pre-selected default so a hint-using kid doesn't have to
    /// re-grade themselves on every question. Tunable in one place.
    ///
    ///   tier 0 (no hint)        → .good   (vanilla correct)
    ///   tier 1 (first hint)     → .good   (a nudge isn't a fail)
    ///   tier 2 (second clue)    → .hard
    ///   tier 3 (full solution)  → .forgot
    static func defaultQualityForHintTier(_ tier: Int) -> ReviewQuality {
        switch tier {
        case 0, 1: return .good
        case 2:    return .hard
        default:   return .forgot
        }
    }

    private enum CodingKeys: String, CodingKey {
        case id, prompt, questionType, options, answer, solutionSteps,
             commonMistakes, variations, difficulty, pageRefs, needsHumanReview,
             matchPairs, source, hints
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
        source = try c.decodeIfPresent(QuestionSource.self, forKey: .source)
        hints = try c.decodeIfPresent([String].self, forKey: .hints)
    }

    /// Memberwise init for any in-code synthesis (e.g. tests, defaults).
    init(id: String, prompt: String, questionType: QuestionType,
         options: [String]?, answer: String, solutionSteps: [String],
         commonMistakes: [String], variations: [QuestionVariation],
         difficulty: Int, pageRefs: [Int], needsHumanReview: Bool,
         matchPairs: [MatchPair]? = nil,
         source: QuestionSource? = nil,
         hints: [String]? = nil) {
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
        self.source = source
        self.hints = hints
    }
}
