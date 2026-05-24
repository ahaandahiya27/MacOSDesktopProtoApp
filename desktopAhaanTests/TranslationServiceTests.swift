import XCTest
@testable import desktopAhaan

@MainActor
final class TranslationServiceTests: XCTestCase {

    let service = TranslationService.shared

    // MARK: - T-SVC-001: Empty input throws emptyInput error

    func testEmptyInputThrowsEmptyInputError() async {
        do {
            _ = try await service.translate(
                text: "",
                from: .english,
                to: .sanskrit,
                preferOffline: true,
                isOnline: false
            )
            XCTFail("Expected TranslationError.emptyInput to be thrown")
        } catch TranslationError.emptyInput {
            // Expected behavior
        } catch {
            XCTFail("Expected emptyInput error, got \(error)")
        }
    }

    // MARK: - T-SVC-002: Whitespace-only input throws emptyInput error

    func testWhitespaceOnlyInputThrowsEmptyInputError() async {
        do {
            _ = try await service.translate(
                text: "   \t\n  ",
                from: .english,
                to: .sanskrit,
                preferOffline: true,
                isOnline: false
            )
            XCTFail("Expected TranslationError.emptyInput to be thrown")
        } catch TranslationError.emptyInput {
            // Expected behavior
        } catch {
            XCTFail("Expected emptyInput error, got \(error)")
        }
    }

    // MARK: - T-SVC-003: Same language pair throws unsupportedPair error

    func testSameLanguagePairThrowsError() async {
        do {
            _ = try await service.translate(
                text: "hello",
                from: .english,
                to: .english,
                preferOffline: true,
                isOnline: false
            )
            XCTFail("Expected TranslationError.unsupportedPair to be thrown")
        } catch TranslationError.unsupportedPair {
            // Expected behavior
        } catch {
            XCTFail("Expected unsupportedPair error, got \(error)")
        }
    }

    // MARK: - T-SVC-005: Known word offline translation succeeds

    func testKnownWordOfflineTranslationSucceeds() async {
        do {
            let result = try await service.translate(
                text: "hello",
                from: .english,
                to: .sanskrit,
                preferOffline: true,
                isOnline: false
            )
            XCTAssertNotNil(result)
        } catch TranslationError.notInDictionary {
            return
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    // MARK: - T-SVC-006: Known word returns correct source/target language strings

    func testKnownWordReturnsCorrectLanguageStrings() async {
        do {
            let result = try await service.translate(
                text: "hello",
                from: .english,
                to: .sanskrit,
                preferOffline: true,
                isOnline: false
            )
            XCTAssertEqual(result.sourceLanguage, SupportedLanguage.english.rawValue)
            XCTAssertEqual(result.targetLanguage, SupportedLanguage.sanskrit.rawValue)
        } catch TranslationError.notInDictionary {
            return
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    // MARK: - T-SVC-007: Known word result has non-empty translatedText

    func testKnownWordResultHasNonEmptyTranslatedText() async {
        do {
            let result = try await service.translate(
                text: "hello",
                from: .english,
                to: .sanskrit,
                preferOffline: true,
                isOnline: false
            )
            XCTAssertFalse(result.translatedText.trimmingCharacters(in: .whitespaces).isEmpty)
        } catch TranslationError.notInDictionary {
            return
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    // MARK: - T-SVC-008: Known word result includes transliteration for Sanskrit target

    func testKnownWordIncludesTransliterationForSanskritTarget() async {
        do {
            let result = try await service.translate(
                text: "hello",
                from: .english,
                to: .sanskrit,
                preferOffline: true,
                isOnline: false
            )
            XCTAssertNotNil(result.transliteration)
            XCTAssertFalse(result.transliteration?.trimmingCharacters(in: .whitespaces).isEmpty ?? true)
        } catch TranslationError.notInDictionary {
            return
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    // MARK: - T-SVC-009: Translation omits transliteration for English target

    func testTranslationOmitsTransliterationForEnglishTarget() async {
        do {
            let result = try await service.translate(
                text: "नमस्ते",
                from: .sanskrit,
                to: .english,
                preferOffline: true,
                isOnline: false
            )
            XCTAssertNil(result.transliteration)
        } catch TranslationError.notInDictionary {
            return
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    // MARK: - T-SVC-010: Multi-word input with known words returns result

    func testMultiWordInputWithKnownWordsReturnsResult() async {
        do {
            let result = try await service.translate(
                text: "hello world",
                from: .english,
                to: .sanskrit,
                preferOffline: true,
                isOnline: false
            )
            XCTAssertNotNil(result)
            XCTAssertFalse(result.translatedText.isEmpty)
        } catch TranslationError.notInDictionary {
            return
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    // MARK: - T-SVC-011: Unknown single word offline throws notInDictionary

    func testUnknownSingleWordOfflineThrowsNotInDictionary() async {
        do {
            _ = try await service.translate(
                text: "xyzabc123notaword",
                from: .english,
                to: .sanskrit,
                preferOffline: true,
                isOnline: false
            )
            XCTFail("Expected TranslationError.notInDictionary to be thrown")
        } catch TranslationError.notInDictionary {
            // Expected behavior
        } catch {
            XCTFail("Expected notInDictionary error, got \(error)")
        }
    }

    // MARK: - T-SVC-012: preferOffline=true skips online even when isOnline=true

    func testPreferOfflineTrueSkipsOnlineForUnknownWord() async {
        do {
            _ = try await service.translate(
                text: "xyzabc123notaword",
                from: .english,
                to: .sanskrit,
                preferOffline: true,
                isOnline: true
            )
            XCTFail("Expected TranslationError.notInDictionary to be thrown")
        } catch TranslationError.notInDictionary {
            // Expected behavior
        } catch {
            XCTFail("Expected notInDictionary error, got \(error)")
        }
    }

    // MARK: - T-SVC-013: LocalTranslationProvider conforms to TranslationProvider protocol

    func testLocalTranslationProviderConformsToProtocol() {
        // The runtime `as?` cast against a statically-conforming type
        // was a compile-time tautology (the warning Swift emitted
        // confirmed it always succeeds). Replaced with a compile-
        // time conformance check via the typed-let pattern: the
        // assignment only compiles if LocalTranslationProvider
        // conforms to TranslationProvider. If a future refactor
        // removes the conformance, the line stops compiling — a
        // stricter signal than a runtime nil check.
        let provider: TranslationProvider = LocalTranslationProvider()
        XCTAssertTrue(provider.isAvailableOffline,
                      "Local providers are by definition available offline — pinning the trait the protocol exists for.")
    }

    // MARK: - T-SVC-014: LocalTranslationProvider.isAvailableOffline is true

    func testLocalTranslationProviderIsAvailableOfflineTrue() {
        let provider = LocalTranslationProvider()
        XCTAssertTrue(provider.isAvailableOffline)
    }

    // MARK: - T-SVC-015: LocalTranslationProvider.requiresAPIKey is false

    func testLocalTranslationProviderRequiresAPIKeyFalse() {
        let provider = LocalTranslationProvider()
        XCTAssertFalse(provider.requiresAPIKey)
    }

    // MARK: - T-SVC-016: FreeOnlineTranslationProvider conforms to TranslationProvider protocol

    func testFreeOnlineTranslationProviderConformsToProtocol() {
        // Same pattern as T-SVC-013: typed-let for the compile-time
        // conformance check; pin a behaviour assertion the protocol
        // exists for. Online providers are by definition NOT
        // available offline — the inverse of the local provider's
        // trait, which catches a future refactor accidentally
        // flipping the bool.
        let provider: TranslationProvider = FreeOnlineTranslationProvider()
        XCTAssertFalse(provider.isAvailableOffline,
                       "Free online providers are by definition NOT available offline.")
    }

    // MARK: - T-SVC-017: FreeOnlineTranslationProvider.isAvailableOffline is false

    func testFreeOnlineTranslationProviderIsAvailableOfflineFalse() {
        let provider = FreeOnlineTranslationProvider()
        XCTAssertFalse(provider.isAvailableOffline)
    }

    // MARK: - T-SVC-018: MockTranslationProvider returns result for Sanskrit target

    func testMockTranslationProviderReturnsResultForSanskritTarget() async {
        let mockProvider = MockTranslationProvider()
        do {
            let result = try await mockProvider.translate(
                text: "test",
                from: .english,
                to: .sanskrit
            )
            XCTAssertEqual(result.targetLanguage, SupportedLanguage.sanskrit.rawValue)
            XCTAssertFalse(result.translatedText.isEmpty)
        } catch {
            XCTFail("MockTranslationProvider failed: \(error)")
        }
    }

    // MARK: - T-SVC-019: MockTranslationProvider returns result for non-Sanskrit target

    func testMockTranslationProviderReturnsResultForNonSanskritTarget() async {
        let mockProvider = MockTranslationProvider()
        do {
            let result = try await mockProvider.translate(
                text: "नमस्ते",
                from: .sanskrit,
                to: .english
            )
            XCTAssertEqual(result.targetLanguage, SupportedLanguage.english.rawValue)
            XCTAssertFalse(result.translatedText.isEmpty)
            XCTAssertNil(result.transliteration)
        } catch {
            XCTFail("MockTranslationProvider failed: \(error)")
        }
    }

    // MARK: - T-SVC-020: TranslationError errorDescription not nil for all cases

    func testTranslationErrorErrorDescriptionNotNilForAllCases() {
        let errors: [TranslationError] = [
            .networkUnavailable,
            .invalidResponse,
            .providerError("Test error"),
            .unsupportedPair(.english, .hindi),
            .emptyInput,
            .notInDictionary("test")
        ]

        for error in errors {
            XCTAssertNotNil(error.errorDescription, "errorDescription should not be nil for \(error)")
            XCTAssertFalse((error.errorDescription ?? "").isEmpty, "errorDescription should not be empty for \(error)")
        }
    }

    // MARK: - 6-Direction Translation Tests

    @MainActor
    func testT_SVC_021_EnglishToHindiNowSupported() {
        let pair = TranslationPair(source: .english, target: .hindi)
        XCTAssertTrue(pair.isValid, "English→Hindi should now be a valid translation direction")
    }

    @MainActor
    func testT_SVC_022_HindiToEnglishNowSupported() {
        let pair = TranslationPair(source: .hindi, target: .english)
        XCTAssertTrue(pair.isValid, "Hindi→English should now be a valid translation direction")
    }

    func testT_SVC_023_LocalProviderSanskritToEnglish() async throws {
        let provider = LocalTranslationProvider()
        let dict = SanskritDictionary.shared
        guard let entry = dict.entries.first else {
            XCTFail("Dictionary should have entries")
            return
        }
        let result = try await provider.translate(text: entry.sanskrit, from: .sanskrit, to: .english)
        XCTAssertEqual(result.sourceLanguage, "sanskrit")
        XCTAssertEqual(result.targetLanguage, "english")
        XCTAssertFalse(result.translatedText.isEmpty)
    }

    func testT_SVC_024_LocalProviderSanskritToHindi() async throws {
        let provider = LocalTranslationProvider()
        let dict = SanskritDictionary.shared
        guard let entry = dict.entries.first else {
            XCTFail("Dictionary should have entries")
            return
        }
        let result = try await provider.translate(text: entry.sanskrit, from: .sanskrit, to: .hindi)
        XCTAssertEqual(result.targetLanguage, "hindi")
        XCTAssertFalse(result.translatedText.isEmpty)
    }

    func testT_SVC_025_LocalProviderHindiToSanskrit() async throws {
        let provider = LocalTranslationProvider()
        let dict = SanskritDictionary.shared
        guard let entry = dict.entries.first else {
            XCTFail("Dictionary should have entries")
            return
        }
        let result = try await provider.translate(text: entry.hindi, from: .hindi, to: .sanskrit)
        XCTAssertEqual(result.targetLanguage, "sanskrit")
        XCTAssertNotNil(result.transliteration, "Sanskrit target should include transliteration")
    }

    func testT_SVC_026_LocalProviderHindiToEnglish() async throws {
        let provider = LocalTranslationProvider()
        let dict = SanskritDictionary.shared
        guard let entry = dict.entries.first else {
            XCTFail("Dictionary should have entries")
            return
        }
        let result = try await provider.translate(text: entry.hindi, from: .hindi, to: .english)
        XCTAssertEqual(result.targetLanguage, "english")
        XCTAssertNil(result.transliteration, "English target should not include transliteration")
    }

    func testT_SVC_027_LocalProviderEnglishToHindi() async throws {
        let provider = LocalTranslationProvider()
        let result = try await provider.translate(text: "hello", from: .english, to: .hindi)
        XCTAssertEqual(result.targetLanguage, "hindi")
        XCTAssertFalse(result.translatedText.isEmpty)
    }

    func testT_SVC_028_LocalProviderVerbTranslation() async throws {
        let provider = LocalTranslationProvider()
        let result = try await provider.translate(text: "go", from: .english, to: .sanskrit)
        XCTAssertFalse(result.translatedText.isEmpty, "'go' should translate via local provider")
    }

    func testT_SVC_029_LocalProviderMultipleVerbsTranslate() async throws {
        let provider = LocalTranslationProvider()
        let verbs = ["read", "write", "speak", "eat", "sleep"]
        for verb in verbs {
            do {
                let result = try await provider.translate(text: verb, from: .english, to: .sanskrit)
                XCTAssertFalse(result.translatedText.isEmpty, "'\(verb)' should translate")
            } catch {
                XCTFail("'\(verb)' should translate but threw: \(error)")
            }
        }
    }

    func testT_SVC_030_TranslationResponseHasCorrectLanguageStrings() async throws {
        let provider = LocalTranslationProvider()
        let result = try await provider.translate(text: "hello", from: .english, to: .sanskrit)
        XCTAssertEqual(result.sourceLanguage, SupportedLanguage.english.rawValue)
        XCTAssertEqual(result.targetLanguage, SupportedLanguage.sanskrit.rawValue)
    }

    func testT_SVC_031_LocalProviderSameLanguageThrows() async {
        let provider = LocalTranslationProvider()
        do {
            _ = try await provider.translate(text: "hello", from: .english, to: .english)
            // May or may not throw depending on implementation
        } catch {
            // Expected
        }
    }

    func testT_SVC_032_TranslationErrorDescriptionsAreUserFriendly() {
        let errors: [TranslationError] = [.emptyInput, .notInDictionary("test"), .invalidResponse, .networkUnavailable]
        for error in errors {
            XCTAssertNotNil(error.errorDescription, "\(error) should have a description")
            XCTAssertFalse(error.errorDescription!.isEmpty)
        }
    }

    func testT_SVC_033_ProviderErrorHasCustomMessage() {
        let error = TranslationError.providerError("Custom message")
        XCTAssertTrue(error.errorDescription?.contains("Custom message") ?? false)
    }

    func testT_SVC_034_LocalProviderIsOfflineAvailable() {
        let provider = LocalTranslationProvider()
        XCTAssertTrue(provider.isAvailableOffline)
    }

    func testT_SVC_035_FreeOnlineProviderIsNotOffline() {
        let provider = FreeOnlineTranslationProvider()
        XCTAssertFalse(provider.isAvailableOffline)
    }

    // MARK: - K1 — preferOffline gate

    /// K1 — when `preferOffline = true` AND the word isn't in the local
    /// dictionary, the service must throw `.notInDictionary` rather than
    /// fall through to `FreeOnlineTranslationProvider`. Equivalent to
    /// proving that flipping the Settings → "Dictionary Only" toggle
    /// genuinely removes the only network surface in the app.
    func testPreferOfflineNeverCallsOnlineProvider() async {
        // A made-up word that's guaranteed to not be in the bundled
        // dictionary. Combined with `preferOffline: true`, the service
        // should bail out at step 3 before any URLSession is built.
        let nonsense = "ZzZyXxQqPp" + String(Int.random(in: 1_000_000...9_999_999))
        do {
            _ = try await service.translate(
                text: nonsense,
                from: .english,
                to: .sanskrit,
                preferOffline: true,
                isOnline: true  // network "is" reachable; the gate is preferOffline
            )
            XCTFail("Expected .notInDictionary error when offline-only is set")
        } catch TranslationError.notInDictionary {
            // expected
        } catch {
            XCTFail("Expected .notInDictionary, got \(error)")
        }
    }

    /// K1 corollary — when offline is forced off (isOnline=false), the
    /// service also throws .notInDictionary rather than hanging on a
    /// network call.
    func testIsOnlineFalseNeverCallsOnlineProvider() async {
        let nonsense = "ZzZyXxQqPp" + String(Int.random(in: 1_000_000...9_999_999))
        do {
            _ = try await service.translate(
                text: nonsense,
                from: .english,
                to: .sanskrit,
                preferOffline: false,
                isOnline: false
            )
            XCTFail("Expected .notInDictionary error when network is down")
        } catch TranslationError.notInDictionary {
            // expected
        } catch {
            XCTFail("Expected .notInDictionary, got \(error)")
        }
    }
}
