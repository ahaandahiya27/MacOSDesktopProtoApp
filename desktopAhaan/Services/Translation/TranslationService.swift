import Foundation
import Combine

/// Manages translation with offline-first strategy:
/// 1. Try built-in dictionary first (instant, free, offline)
/// 2. If not found and online, try free online API
/// 3. If both fail, show a helpful message
@MainActor
final class TranslationService: ObservableObject {
    static let shared = TranslationService()

    @Published var activeProviderName: String = "Built-in Dictionary"
    @Published var lastUsedProvider: String = ""

    private let localProvider = LocalTranslationProvider()
    private let onlineProvider = FreeOnlineTranslationProvider()

    func translate(
        text: String,
        from source: SupportedLanguage,
        to target: SupportedLanguage,
        preferOffline: Bool = false,
        isOnline: Bool = true
    ) async throws -> TranslationResponse {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            throw TranslationError.emptyInput
        }

        guard TranslationPair(source: source, target: target).isValid else {
            throw TranslationError.unsupportedPair(source, target)
        }

        // Step 1: Try local dictionary (always available)
        do {
            let result = try await localProvider.translate(text: trimmed, from: source, to: target)
            lastUsedProvider = "Built-in Dictionary"
            activeProviderName = lastUsedProvider
            return result
        } catch {
            // Dictionary didn't have it — continue to online
        }

        // Step 2: If online and not forced offline, try free online API
        if isOnline && !preferOffline {
            do {
                let result = try await onlineProvider.translate(text: trimmed, from: source, to: target)
                lastUsedProvider = "Online Translation"
                activeProviderName = lastUsedProvider
                return result
            } catch {
                // Online also failed — fall through to error
            }
        }

        // Step 3: Nothing worked
        if !isOnline || preferOffline {
            throw TranslationError.notInDictionary(trimmed)
        } else {
            throw TranslationError.providerError(
                "Could not translate '\(trimmed)'. Try simpler words, or check the Practice section for vocabulary."
            )
        }
    }
}
