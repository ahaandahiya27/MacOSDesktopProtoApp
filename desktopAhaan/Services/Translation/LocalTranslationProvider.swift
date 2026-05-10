import Foundation

/// Offline translation provider using the built-in Sanskrit dictionary.
/// Works completely without internet — perfect for practice and common phrases.
final class LocalTranslationProvider: TranslationProvider {
    let name = "Built-in Dictionary"
    let requiresAPIKey = false
    let isAvailableOffline = true

    private let dictionary = SanskritDictionary.shared

    func translate(
        text: String,
        from source: SupportedLanguage,
        to target: SupportedLanguage
    ) async throws -> TranslationResponse {

        // First try the full phrase
        if let result = dictionary.translate(text: text, from: source, to: target) {
            return result
        }

        // Try word-by-word translation for multi-word input
        let words = text.components(separatedBy: .whitespaces).filter { !$0.isEmpty }
        if words.count > 1 {
            var translatedParts: [String] = []
            var wordByWord: [WordMeaning] = []

            for word in words {
                let matches = dictionary.lookup(text: word, from: source)
                if let match = matches.first {
                    let translated: String
                    switch target {
                    case .english: translated = match.english
                    case .hindi: translated = match.hindi
                    case .sanskrit: translated = match.sanskrit
                    }
                    translatedParts.append(translated)
                    wordByWord.append(WordMeaning(
                        source: word,
                        target: translated,
                        note: match.grammarNote
                    ))
                } else {
                    translatedParts.append(word)
                    wordByWord.append(WordMeaning(
                        source: word,
                        target: "(not found)",
                        note: "This word is not in the built-in dictionary"
                    ))
                }
            }

            let combined = translatedParts.joined(separator: " ")
            let hasTranslit = target == .sanskrit

            return TranslationResponse(
                sourceLanguage: source.rawValue,
                targetLanguage: target.rawValue,
                originalText: text,
                translatedText: combined,
                transliteration: hasTranslit ? wordByWord.map { $0.target }.joined(separator: " ") : nil,
                wordByWord: wordByWord,
                grammarNote: "Word-by-word translation from the built-in dictionary. Sentence structure may differ in Sanskrit.",
                learningTip: "Sanskrit word order is usually: Subject + Object + Verb. Try rearranging!",
                difficulty: .medium,
                alternatives: nil,
                confidenceNote: "This is a word-by-word translation. For full sentences, try the online mode or use simpler phrases."
            )
        }

        // Nothing found
        throw TranslationError.notInDictionary(text)
    }
}
