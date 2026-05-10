import Foundation

/// Supported languages for translation
enum SupportedLanguage: String, Codable, CaseIterable, Identifiable {
    case english = "english"
    case hindi = "hindi"
    case sanskrit = "sanskrit"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .english: return "English"
        case .hindi: return "हिन्दी (Hindi)"
        case .sanskrit: return "संस्कृतम् (Sanskrit)"
        }
    }

    var shortName: String {
        switch self {
        case .english: return "EN"
        case .hindi: return "HI"
        case .sanskrit: return "SA"
        }
    }

    var nativeLabel: String {
        switch self {
        case .english: return "English"
        case .hindi: return "हिन्दी"
        case .sanskrit: return "संस्कृतम्"
        }
    }

    /// BCP-47 locale for speech recognition
    var speechLocale: String {
        switch self {
        case .english: return "en-IN"
        case .hindi: return "hi-IN"
        case .sanskrit: return "sa-IN"
        }
    }

    /// BCP-47 locale for text-to-speech
    var ttsLocale: String {
        switch self {
        case .english: return "en-IN"
        case .hindi: return "hi-IN"
        case .sanskrit: return "hi-IN" // fallback: Hindi voice for Sanskrit
        }
    }

    /// Valid target languages for this source
    var validTargets: [SupportedLanguage] {
        switch self {
        case .english: return [.sanskrit, .hindi]
        case .hindi: return [.sanskrit, .english]
        case .sanskrit: return [.english, .hindi]
        }
    }
}

/// Represents a translation direction pair
struct TranslationPair: Equatable {
    let source: SupportedLanguage
    let target: SupportedLanguage

    var isValid: Bool {
        source.validTargets.contains(target)
    }

    var displayString: String {
        "\(source.shortName) → \(target.shortName)"
    }
}
