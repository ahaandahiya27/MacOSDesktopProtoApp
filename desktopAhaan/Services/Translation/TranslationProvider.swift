import Foundation

/// Protocol that all translation providers must conform to.
protocol TranslationProvider {
    var name: String { get }
    var requiresAPIKey: Bool { get }
    var isAvailableOffline: Bool { get }

    func translate(
        text: String,
        from source: SupportedLanguage,
        to target: SupportedLanguage
    ) async throws -> TranslationResponse
}

/// Errors specific to translation
enum TranslationError: LocalizedError {
    case networkUnavailable
    case invalidResponse
    case providerError(String)
    case unsupportedPair(SupportedLanguage, SupportedLanguage)
    case emptyInput
    case notInDictionary(String)

    var errorDescription: String? {
        switch self {
        case .networkUnavailable:
            return "You're offline right now. The built-in dictionary is available, but for new phrases connect to the internet."
        case .invalidResponse:
            return "The translation didn't come back properly. Please try again."
        case .providerError(let msg):
            return msg
        case .unsupportedPair(let s, let t):
            return "\(s.displayName) to \(t.displayName) is not supported."
        case .emptyInput:
            return "Please type something to translate."
        case .notInDictionary(let text):
            return "'\(text)' was not found in the built-in dictionary. Try connecting to the internet for online translation, or use simpler words."
        }
    }
}
