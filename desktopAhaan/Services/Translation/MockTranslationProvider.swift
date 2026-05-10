import Foundation

/// A mock provider for testing and offline demo purposes
final class MockTranslationProvider: TranslationProvider {
    let name = "Mock (Testing)"
    let requiresAPIKey = false
    let isAvailableOffline = true

    func translate(
        text: String,
        from source: SupportedLanguage,
        to target: SupportedLanguage
    ) async throws -> TranslationResponse {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 500_000_000)

        // Return a sample structured response
        if target == .sanskrit {
            return TranslationResponse(
                sourceLanguage: source.rawValue,
                targetLanguage: target.rawValue,
                originalText: text,
                translatedText: "नमस्ते",
                transliteration: "namaste",
                wordByWord: [
                    WordMeaning(source: text, target: "नमस्ते", note: "A common greeting")
                ],
                grammarNote: "This is a basic greeting. In Sanskrit, 'namaste' comes from 'namah' (bow) + 'te' (to you).",
                learningTip: "Start every Sanskrit conversation with 'namaste' — it shows respect!",
                difficulty: .easy,
                alternatives: ["नमस्कारः (namaskāraḥ)"],
                confidenceNote: "This is a demo translation. Connect an API key for accurate results."
            )
        } else {
            return TranslationResponse(
                sourceLanguage: source.rawValue,
                targetLanguage: target.rawValue,
                originalText: text,
                translatedText: target == .hindi ? "नमस्ते (हिंदी अनुवाद)" : "Hello (English translation)",
                transliteration: nil,
                wordByWord: [
                    WordMeaning(source: text, target: "Hello", note: "Basic greeting")
                ],
                grammarNote: "A simple greeting expression.",
                learningTip: "Practice translating common greetings first!",
                difficulty: .easy,
                alternatives: [],
                confidenceNote: "This is a demo translation. Connect an API key for accurate results."
            )
        }
    }
}
