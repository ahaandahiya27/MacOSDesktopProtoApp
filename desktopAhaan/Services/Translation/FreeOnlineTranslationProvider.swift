import Foundation

/// Free online translation using MyMemory API.
/// No API key, no registration, no cost.
/// Free tier: 1000 words/day (plenty for a student).
/// Supports Sanskrit (sa), Hindi (hi), English (en).
final class FreeOnlineTranslationProvider: TranslationProvider {
    let name = "Online Translation"
    let requiresAPIKey = false
    let isAvailableOffline = false

    private let dictionary = SanskritDictionary.shared

    /// MyMemory language codes
    private func langCode(_ lang: SupportedLanguage) -> String {
        switch lang {
        case .english: return "en"
        case .hindi: return "hi"
        case .sanskrit: return "sa"
        }
    }

    func translate(
        text: String,
        from source: SupportedLanguage,
        to target: SupportedLanguage
    ) async throws -> TranslationResponse {

        let fromCode = langCode(source)
        let toCode = langCode(target)
        // Build via URLComponents so the query text is encoded correctly.
        // `.urlQueryAllowed` does NOT escape `&`/`=`, so a phrase containing
        // them previously corrupted the `langpair` param (wrong results /
        // param injection). queryItems percent-encodes each value properly.
        var components = URLComponents(string: "https://api.mymemory.translated.net/get")
        components?.queryItems = [
            URLQueryItem(name: "q", value: text),
            URLQueryItem(name: "langpair", value: "\(fromCode)|\(toCode)")
        ]

        guard let url = components?.url else {
            throw TranslationError.invalidResponse
        }

        var request = URLRequest(url: url)
        request.timeoutInterval = 15

        let (data, response): (Data, URLResponse)
        if #available(macOS 12.0, *) {
            (data, response) = try await URLSession.shared.data(for: request)
        } else {
            (data, response) = try await withCheckedThrowingContinuation { continuation in
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else if let data = data, let response = response {
                        continuation.resume(returning: (data, response))
                    } else {
                        continuation.resume(throwing: TranslationError.invalidResponse)
                    }
                }
                task.resume()
            }
        }

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw TranslationError.providerError("Online translation service is unavailable right now.")
        }

        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let responseData = json["responseData"] as? [String: Any],
              let translatedText = responseData["translatedText"] as? String,
              !translatedText.isEmpty else {
            throw TranslationError.invalidResponse
        }

        // Build a rich response by combining online translation with dictionary data
        let transliteration = buildTransliteration(translatedText, target: target)
        let wordByWord = buildWordByWord(text: text, source: source, target: target)
        let grammarNote = buildGrammarNote(text: text, source: source, target: target)

        // Check dictionary for alternatives
        let dictMatch = dictionary.translate(text: text, from: source, to: target)
        var alternatives: [String]? = nil
        if let dict = dictMatch, dict.translatedText != translatedText {
            alternatives = ["\(dict.translatedText)" + (target == .sanskrit ? " (\(dict.transliteration ?? ""))" : "")]
        }

        return TranslationResponse(
            sourceLanguage: source.rawValue,
            targetLanguage: target.rawValue,
            originalText: text,
            translatedText: translatedText,
            transliteration: transliteration,
            wordByWord: wordByWord,
            grammarNote: grammarNote ?? dictMatch?.grammarNote,
            learningTip: dictMatch?.learningTip ?? "Try breaking this into smaller words and look them up in Practice mode!",
            difficulty: dictMatch?.difficulty ?? .medium,
            alternatives: alternatives,
            confidenceNote: "Translated online. Sanskrit translations may vary — more than one correct form can exist."
        )
    }

    /// Attempt basic transliteration for Sanskrit output
    private func buildTransliteration(_ text: String, target: SupportedLanguage) -> String? {
        guard target == .sanskrit else { return nil }

        // Check if dictionary has it
        let matches = dictionary.lookup(text: text, from: .sanskrit)
        if let match = matches.first {
            return match.transliteration
        }

        // Basic Devanagari → Latin transliteration map for common characters
        let map: [Character: String] = [
            "अ": "a", "आ": "ā", "इ": "i", "ई": "ī", "उ": "u", "ऊ": "ū",
            "ए": "e", "ऐ": "ai", "ओ": "o", "औ": "au",
            "क": "ka", "ख": "kha", "ग": "ga", "घ": "gha", "ङ": "ṅa",
            "च": "ca", "छ": "cha", "ज": "ja", "झ": "jha", "ञ": "ña",
            "ट": "ṭa", "ठ": "ṭha", "ड": "ḍa", "ढ": "ḍha", "ण": "ṇa",
            "त": "ta", "थ": "tha", "द": "da", "ध": "dha", "न": "na",
            "प": "pa", "फ": "pha", "ब": "ba", "भ": "bha", "म": "ma",
            "य": "ya", "र": "ra", "ल": "la", "व": "va",
            "श": "śa", "ष": "ṣa", "स": "sa", "ह": "ha",
            "ं": "ṁ", "ः": "ḥ", "्": "",
            "ा": "ā", "ि": "i", "ी": "ī", "ु": "u", "ू": "ū",
            "े": "e", "ै": "ai", "ो": "o", "ौ": "au",
            " ": " ",
        ]

        var result = ""
        for char in text {
            if let mapped = map[char] {
                result += mapped
            } else if char.isWhitespace || char.isPunctuation {
                result += String(char)
            } else {
                result += String(char) // Keep unknown characters as-is
            }
        }
        return result.isEmpty ? nil : result
    }

    /// Try to build word-by-word from dictionary
    private func buildWordByWord(text: String, source: SupportedLanguage, target: SupportedLanguage) -> [WordMeaning]? {
        let words = text.components(separatedBy: .whitespaces).filter { !$0.isEmpty }
        guard words.count >= 1 else { return nil }

        var result: [WordMeaning] = []
        for word in words {
            let matches = dictionary.lookup(text: word, from: source)
            if let match = matches.first {
                let targetWord: String
                switch target {
                case .english: targetWord = match.english
                case .hindi: targetWord = match.hindi
                case .sanskrit: targetWord = "\(match.sanskrit) (\(match.transliteration))"
                }
                result.append(WordMeaning(source: word, target: targetWord, note: match.grammarNote))
            }
        }
        return result.isEmpty ? nil : result
    }

    private func buildGrammarNote(text: String, source: SupportedLanguage, target: SupportedLanguage) -> String? {
        let matches = dictionary.lookup(text: text, from: source)
        return matches.first?.grammarNote
    }
}
