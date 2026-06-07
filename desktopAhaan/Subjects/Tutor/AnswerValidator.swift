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
    ///
    /// 2026-06-07: rules widened to accept the Class-7 Indian-numeric forms
    /// the practice screens were rejecting (`1000` vs `1,000 presses`;
    /// `31000` vs `31,000`; `100000, 99999` vs `1,00,000 and 99,999`):
    ///   • All digit-grouping commas (Indian 1,00,000 or international 100,000)
    ///     are stripped before any compare, so "1,000" and "1000" are equal.
    ///   • If the user input is a single numeric token AND the truth STARTS
    ///     with that same number (followed by a non-digit), accept. The kid
    ///     typing "1000" for "1,000 presses; …" passes.
    static func matches(userInput: String, truth: String) -> Bool {
        let u = normalize(userInput)
        let t = normalize(truth)
        if u.isEmpty || t.isEmpty { return false }
        if u == t { return true }
        if let un = Double(u), let tn = Double(t), un == tn { return true }
        let uTokens = tokenize(u)
        let tTokens = tokenize(t)
        if !uTokens.isEmpty && uTokens == tTokens { return true }
        // Leading-number rule. If the user gave a single numeric token and
        // the truth STARTS with that same number followed by a non-digit
        // AND the truth is a SENTENCE (has a period somewhere OR has many
        // tokens), accept. The sentence-check is crucial: it lets
        // "1000" match the worked-solution prose "1,000 presses; one
        // thousand hundreds make a lakh." while still REJECTING "8" vs
        // the short-fact truth "8 teeth" (the kid must give the unit
        // when the truth is short — the existing
        // partialTokenMatchFails fixture pins that contract).
        //
        // Heuristic: truth is treated as a sentence if it contains "." or
        // ";" OR has ≥5 tokens. "8 teeth" has 2 tokens and no
        // punctuation → still strict. "1000 presses; one thousand
        // hundreds make a lakh." has many tokens + period → leading-
        // number rule fires.
        if uTokens.count == 1, let first = uTokens.first,
           Double(first) != nil,
           leadsWithNumber(t, number: first),
           truthLooksLikeSentence(t, tokenCount: tTokens.count) {
            return true
        }
        return false
    }

    /// `true` if the truth is shaped like a sentence — long enough or
    /// punctuated enough that the kid shouldn't be expected to type it
    /// verbatim. Used to gate the leading-number rule so short-fact
    /// truths like "8 teeth" still require the kid to type the unit.
    private static func truthLooksLikeSentence(_ s: String, tokenCount: Int) -> Bool {
        if tokenCount >= 5 { return true }
        if s.contains(".") || s.contains(";") { return true }
        return false
    }

    /// True if `s` starts with `number` and the next char (if any) isn't
    /// a digit — so "1000" matches "1000 presses" but not "10000 something".
    private static func leadsWithNumber(_ s: String, number: String) -> Bool {
        guard s.hasPrefix(number) else { return false }
        let after = s.index(s.startIndex, offsetBy: number.count)
        if after == s.endIndex { return true }
        return !s[after].isNumber
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
        // Trim + lowercase + strip digit-grouping commas. The comma-strip
        // uses a regex so it only fires BETWEEN digits — preserving the
        // English-list comma in "apple, orange" while collapsing the
        // Indian / international digit groupings:
        //   "1,000"            → "1000"
        //   "1,00,000"         → "100000"
        //   "100,000"          → "100000"
        //   "1,00,000 and 99,999" → "100000 and 99999"
        //   "apple, orange"    → "apple, orange"        (no change)
        let trimmed = s.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard let re = try? NSRegularExpression(pattern: "(?<=\\d),(?=\\d)") else {
            return trimmed
        }
        let range = NSRange(trimmed.startIndex..<trimmed.endIndex, in: trimmed)
        return re.stringByReplacingMatches(in: trimmed, range: range, withTemplate: "")
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
