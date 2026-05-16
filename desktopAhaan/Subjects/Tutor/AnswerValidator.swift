import Foundation

// MARK: - AnswerValidator

/// Free-text answer matcher tuned for short, single-fact answers
/// (numbers, single nouns, short phrases). Used by both QuestionDetailView
/// and any future quiz UI.
///
/// Rules, evaluated in order:
///   1. Whitespace-trimmed, case-folded exact match.
///   2. If both sides parse as numbers (Int or Double), compare numerically
///      so "8" == "8.0" == " 8 ".
///   3. Token-set match for multi-word answers — order-independent equality
///      of the meaningful tokens (drops punctuation and stop-ish words),
///      so "8 teeth" matches "teeth 8" but NOT "abcd".
/// Substring matching is deliberately NOT used; it produced false positives
/// (e.g. the empty string matched every truth).
enum AnswerValidator {
    /// Strict match — required for `.fillInBlank` and `.numerical` where the
    /// truth is short and exactness matters.
    static func matches(userInput: String, truth: String) -> Bool {
        let u = normalize(userInput)
        let t = normalize(truth)
        if u.isEmpty || t.isEmpty { return false }
        if u == t { return true }
        if let un = Double(u), let tn = Double(t), un == tn { return true }
        let uTokens = tokenize(u)
        let tTokens = tokenize(t)
        if !uTokens.isEmpty && uTokens == tTokens { return true }
        return false
    }

    /// Lenient match for `.shortAnswer` / `.longAnswer` where the truth is a
    /// full sentence and the kid may answer with a correct *phrase*. Counts
    /// the user's content tokens that also appear in the truth and considers
    /// a match if (a) at least `minMatched` overlap AND (b) at least
    /// `coverageThreshold` of the user's tokens are in the truth. Falls back
    /// to strict match first so exact-phrase answers keep passing.
    static func matchesLenient(userInput: String,
                               truth: String,
                               coverageThreshold: Double = 0.6,
                               minMatched: Int = 2) -> Bool {
        if matches(userInput: userInput, truth: truth) { return true }
        let uTokens = tokenize(normalize(userInput))
        let tTokens = Set(tokenize(normalize(truth)))
        guard !uTokens.isEmpty, !tTokens.isEmpty else { return false }
        let matched = uTokens.filter { tTokens.contains($0) }.count
        guard matched >= minMatched else { return false }
        let coverage = Double(matched) / Double(uTokens.count)
        return coverage >= coverageThreshold
    }

    private static func normalize(_ s: String) -> String {
        s.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }

    /// Sorted set of meaningful tokens. Strips punctuation and a tiny set of
    /// English filler words so "the sun" and "sun" are considered equal.
    private static let stopWords: Set<String> = ["the", "a", "an", "is", "are"]
    private static func tokenize(_ s: String) -> [String] {
        let cleaned = s.unicodeScalars
            .map { CharacterSet.alphanumerics.contains($0) ? Character($0) : " " }
        return String(cleaned)
            .split(separator: " ")
            .map(String.init)
            .filter { !$0.isEmpty && !stopWords.contains($0) }
            .sorted()
    }
}
