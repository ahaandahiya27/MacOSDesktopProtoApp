import Foundation
import Combine
import os.log

private let translationLogger = Logger(subsystem: "com.emoha.desktopAhaan", category: "Translation")

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
            // Dictionary miss is the COMMON case — the bundled dictionary
            // is Class-7-scoped; anything outside it falls through to the
            // online provider. Don't log to CrashReporter (would spam every
            // out-of-vocab lookup), but log to os.Logger for dev inspection.
            translationLogger.debug("local provider miss for '\(trimmed, privacy: .public)' — falling through to online")
        }

        // Step 2: If online and not forced offline, try free online API
        if isOnline && !preferOffline {
            do {
                let result = try await onlineProvider.translate(text: trimmed, from: source, to: target)
                lastUsedProvider = "Online Translation"
                activeProviderName = lastUsedProvider
                return result
            } catch {
                // Online failure IS worth recording — a recurring failure
                // signature in the crashlog tells the parent the online
                // provider is degraded (5xx, parse fail, rate limit) vs.
                // the kid just typing words outside the dictionary. The
                // 2026-06-05 audit caught both failures collapsed into
                // the same generic banner.
                translationLogger.debug("online provider failed for '\(trimmed, privacy: .public)': \(error.localizedDescription, privacy: .public)")
                CrashReporter.shared.logDataIssue(
                    "TranslationService online provider failed: \(error.localizedDescription)"
                )
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
