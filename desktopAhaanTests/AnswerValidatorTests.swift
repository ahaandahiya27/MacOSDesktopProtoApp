import Testing
@testable import desktopAhaan

/// Tests for `AnswerValidator.matches(userInput:truth:)`. This validator is
/// load-bearing — it grades every free-text answer in the Quiz Bank — so
/// every behavior is covered explicitly here.
struct AnswerValidatorTests {

    // MARK: - Exact match

    @Test func exactMatchPasses() {
        #expect(AnswerValidator.matches(userInput: "Photosynthesis", truth: "Photosynthesis"))
    }

    @Test func caseFoldingPasses() {
        #expect(AnswerValidator.matches(userInput: "photosynthesis", truth: "PHOTOSYNTHESIS"))
    }

    @Test func leadingTrailingWhitespacePasses() {
        #expect(AnswerValidator.matches(userInput: "   the sun   ", truth: "the sun"))
    }

    // MARK: - Empty / nil-ish

    @Test func emptyUserInputFails() {
        #expect(!AnswerValidator.matches(userInput: "", truth: "The Sun"))
    }

    @Test func whitespaceOnlyUserInputFails() {
        #expect(!AnswerValidator.matches(userInput: "    ", truth: "The Sun"))
    }

    @Test func emptyTruthFails() {
        // A truth of "" must NOT match anything — guards against the old
        // substring-match bug where empty string matched every input.
        #expect(!AnswerValidator.matches(userInput: "anything", truth: ""))
    }

    // MARK: - Numeric equivalence

    @Test func numericIntsMatch() {
        #expect(AnswerValidator.matches(userInput: "8", truth: "8"))
    }

    @Test func numericIntAndDoubleMatch() {
        #expect(AnswerValidator.matches(userInput: "8", truth: "8.0"))
    }

    @Test func numericWithLeadingZero() {
        #expect(AnswerValidator.matches(userInput: "08", truth: "8"))
    }

    @Test func numericNegativeMatches() {
        #expect(AnswerValidator.matches(userInput: "-273", truth: "-273.0"))
    }

    @Test func nonNumericPlausibleStringsDontFalseMatch() {
        // "8 teeth" vs "8" must NOT pass via the numeric branch — only
        // pure numbers should compare numerically.
        #expect(!AnswerValidator.matches(userInput: "8 teeth", truth: "8"))
    }

    // MARK: - Token-set match

    @Test func tokenOrderIndependent() {
        #expect(AnswerValidator.matches(userInput: "teeth 8", truth: "8 teeth"))
    }

    @Test func tokenIgnoresStopWords() {
        // "the sun" tokenises to {"sun"}, same as "sun" alone.
        #expect(AnswerValidator.matches(userInput: "the sun", truth: "sun"))
    }

    @Test func tokenStripsPunctuation() {
        #expect(AnswerValidator.matches(userInput: "8, teeth!", truth: "8 teeth"))
    }

    @Test func tokenSetMismatchFails() {
        #expect(!AnswerValidator.matches(userInput: "abcd", truth: "8 teeth"))
    }

    @Test func partialTokenMatchFails() {
        // "8" alone shouldn't pass for "8 teeth" via token set — the user
        // is missing the noun.
        #expect(!AnswerValidator.matches(userInput: "8", truth: "8 teeth"))
    }

    // MARK: - No substring matching (guards against past false positives)

    @Test func substringDoesNotPass() {
        // "abc" is contained inside "abcd" but must NOT match.
        #expect(!AnswerValidator.matches(userInput: "abc", truth: "abcd"))
    }

    @Test func emptyStringDoesNotMatchAnyTruth() {
        #expect(!AnswerValidator.matches(userInput: "", truth: "anything"))
        #expect(!AnswerValidator.matches(userInput: "", truth: ""))
        #expect(!AnswerValidator.matches(userInput: "", truth: "  "))
    }
}
