import XCTest
@testable import desktopAhaan

final class PersistenceTests: XCTestCase {

    // MARK: - TranslationRecord Tests

    /// T-PERS-001: Create record from response preserves all fields
    func testCreateRecordFromResponsePreservesAllFields() {
        let wordByWord = [
            WordMeaning(source: "नमः", target: "salutation", note: "honorific"),
            WordMeaning(source: "ते", target: "to you", note: nil)
        ]
        let alternatives = ["Hello", "Greetings"]

        let response = TranslationResponse(
            sourceLanguage: "Sanskrit",
            targetLanguage: "English",
            originalText: "नमस्ते",
            translatedText: "Hello",
            transliteration: "namaste",
            wordByWord: wordByWord,
            grammarNote: "Nominative dual form",
            learningTip: "Common greeting",
            difficulty: .easy,
            alternatives: alternatives,
            confidenceNote: "High confidence"
        )

        let record = TranslationRecord(from: response, isFavorite: true)

        XCTAssertEqual(record.sourceLanguage, "Sanskrit")
        XCTAssertEqual(record.targetLanguage, "English")
        XCTAssertEqual(record.originalText, "नमस्ते")
        XCTAssertEqual(record.translatedText, "Hello")
        XCTAssertEqual(record.transliteration, "namaste")
        XCTAssertEqual(record.difficulty, "Easy")
        XCTAssertEqual(record.grammarNote, "Nominative dual form")
        XCTAssertEqual(record.learningTip, "Common greeting")
        XCTAssertEqual(record.confidenceNote, "High confidence")
        XCTAssertTrue(record.isFavorite)
        XCTAssertNotNil(record.wordByWordJSON)
        XCTAssertNotNil(record.alternativesJSON)
    }

    /// T-PERS-002: asResponse round-trip preserves sourceLanguage
    func testAsResponseRoundTripPreservesSourceLanguage() {
        let response = TranslationResponse(
            sourceLanguage: "Sanskrit",
            targetLanguage: "English",
            originalText: "धन्यवादः",
            translatedText: "Thank you",
            transliteration: "dhanyavaadah",
            wordByWord: nil,
            grammarNote: nil,
            learningTip: nil,
            difficulty: .medium,
            alternatives: nil,
            confidenceNote: nil
        )

        let record = TranslationRecord(from: response)
        let roundTrip = record.asResponse

        XCTAssertEqual(roundTrip.sourceLanguage, "Sanskrit")
    }

    /// T-PERS-003: asResponse round-trip preserves targetLanguage
    func testAsResponseRoundTripPreservesTargetLanguage() {
        let response = TranslationResponse(
            sourceLanguage: "Sanskrit",
            targetLanguage: "Hindi",
            originalText: "अग्निः",
            translatedText: "आग",
            transliteration: "agnih",
            wordByWord: nil,
            grammarNote: nil,
            learningTip: nil,
            difficulty: .easy,
            alternatives: nil,
            confidenceNote: nil
        )

        let record = TranslationRecord(from: response)
        let roundTrip = record.asResponse

        XCTAssertEqual(roundTrip.targetLanguage, "Hindi")
    }

    /// T-PERS-004: asResponse round-trip preserves originalText
    func testAsResponseRoundTripPreservesOriginalText() {
        let originalText = "सूर्यः"
        let response = TranslationResponse(
            sourceLanguage: "Sanskrit",
            targetLanguage: "English",
            originalText: originalText,
            translatedText: "Sun",
            transliteration: "suryah",
            wordByWord: nil,
            grammarNote: nil,
            learningTip: nil,
            difficulty: .easy,
            alternatives: nil,
            confidenceNote: nil
        )

        let record = TranslationRecord(from: response)
        let roundTrip = record.asResponse

        XCTAssertEqual(roundTrip.originalText, originalText)
    }

    /// T-PERS-005: asResponse round-trip preserves translatedText
    func testAsResponseRoundTripPreservesTranslatedText() {
        let translatedText = "Moon"
        let response = TranslationResponse(
            sourceLanguage: "Sanskrit",
            targetLanguage: "English",
            originalText: "चन्द्रः",
            translatedText: translatedText,
            transliteration: "chandrah",
            wordByWord: nil,
            grammarNote: nil,
            learningTip: nil,
            difficulty: .easy,
            alternatives: nil,
            confidenceNote: nil
        )

        let record = TranslationRecord(from: response)
        let roundTrip = record.asResponse

        XCTAssertEqual(roundTrip.translatedText, translatedText)
    }

    /// T-PERS-006: asResponse round-trip preserves transliteration
    func testAsResponseRoundTripPreservesTransliteration() {
        let transliteration = "vayu"
        let response = TranslationResponse(
            sourceLanguage: "Sanskrit",
            targetLanguage: "English",
            originalText: "वायुः",
            translatedText: "Wind",
            transliteration: transliteration,
            wordByWord: nil,
            grammarNote: nil,
            learningTip: nil,
            difficulty: .easy,
            alternatives: nil,
            confidenceNote: nil
        )

        let record = TranslationRecord(from: response)
        let roundTrip = record.asResponse

        XCTAssertEqual(roundTrip.transliteration, transliteration)
    }

    /// T-PERS-007: asResponse round-trip preserves difficulty
    func testAsResponseRoundTripPreservesDifficulty() {
        let response = TranslationResponse(
            sourceLanguage: "Sanskrit",
            targetLanguage: "English",
            originalText: "महत्त्वपूर्णः",
            translatedText: "Important",
            transliteration: "mahattvaapurnah",
            wordByWord: nil,
            grammarNote: nil,
            learningTip: nil,
            difficulty: .hard,
            alternatives: nil,
            confidenceNote: nil
        )

        let record = TranslationRecord(from: response)
        let roundTrip = record.asResponse

        XCTAssertEqual(roundTrip.difficulty, .hard)
    }

    /// T-PERS-008: asResponse round-trip preserves grammarNote
    func testAsResponseRoundTripPreservesGrammarNote() {
        let grammarNote = "Masculine nominative singular"
        let response = TranslationResponse(
            sourceLanguage: "Sanskrit",
            targetLanguage: "English",
            originalText: "नरः",
            translatedText: "Man",
            transliteration: "narah",
            wordByWord: nil,
            grammarNote: grammarNote,
            learningTip: nil,
            difficulty: .easy,
            alternatives: nil,
            confidenceNote: nil
        )

        let record = TranslationRecord(from: response)
        let roundTrip = record.asResponse

        XCTAssertEqual(roundTrip.grammarNote, grammarNote)
    }

    /// T-PERS-009: wordByWord JSON encode/decode round-trip
    func testWordByWordJSONEncodeDecodeRoundTrip() {
        let wordByWord = [
            WordMeaning(source: "भ", target: "be", note: "root"),
            WordMeaning(source: "अति", target: "beyond", note: nil),
            WordMeaning(source: "इ", target: "go", note: "suffix")
        ]

        let response = TranslationResponse(
            sourceLanguage: "Sanskrit",
            targetLanguage: "English",
            originalText: "भवति",
            translatedText: "He becomes",
            transliteration: "bhavati",
            wordByWord: wordByWord,
            grammarNote: nil,
            learningTip: nil,
            difficulty: .medium,
            alternatives: nil,
            confidenceNote: nil
        )

        let record = TranslationRecord(from: response)
        let roundTrip = record.asResponse

        XCTAssertEqual(roundTrip.wordByWord?.count, 3)
        XCTAssertEqual(roundTrip.wordByWord?[0].source, "भ")
        XCTAssertEqual(roundTrip.wordByWord?[0].target, "be")
        XCTAssertEqual(roundTrip.wordByWord?[0].note, "root")
        XCTAssertEqual(roundTrip.wordByWord?[1].source, "अति")
        // Entry at index 2 has note: "suffix" — assertion was wrong
        // in the original test (claimed nil for a value that was clearly
        // initialised non-nil on line 209).
        XCTAssertEqual(roundTrip.wordByWord?[2].note, "suffix")
    }

    /// T-PERS-010: alternatives JSON encode/decode round-trip
    func testAlternativesJSONEncodeDecodeRoundTrip() {
        let alternatives = ["Thanks", "Thank you very much", "Much obliged"]

        let response = TranslationResponse(
            sourceLanguage: "Sanskrit",
            targetLanguage: "English",
            originalText: "धन्यवादः",
            translatedText: "Thank you",
            transliteration: "dhanyavaadah",
            wordByWord: nil,
            grammarNote: nil,
            learningTip: nil,
            difficulty: .easy,
            alternatives: alternatives,
            confidenceNote: nil
        )

        let record = TranslationRecord(from: response)
        let roundTrip = record.asResponse

        XCTAssertEqual(roundTrip.alternatives?.count, 3)
        XCTAssertEqual(roundTrip.alternatives, alternatives)
    }

    /// T-PERS-011: isFavorite defaults to false
    func testIsFavoriteDefaultsToFalse() {
        let response = TranslationResponse(
            sourceLanguage: "Sanskrit",
            targetLanguage: "English",
            originalText: "पुस्तकम्",
            translatedText: "Book",
            transliteration: "pustakam",
            wordByWord: nil,
            grammarNote: nil,
            learningTip: nil,
            difficulty: .easy,
            alternatives: nil,
            confidenceNote: nil
        )

        let record = TranslationRecord(from: response)

        XCTAssertFalse(record.isFavorite)
    }

    /// T-PERS-012: createdAt is set on init
    func testCreatedAtIsSetOnInit() {
        let response = TranslationResponse(
            sourceLanguage: "Sanskrit",
            targetLanguage: "English",
            originalText: "विद्या",
            translatedText: "Knowledge",
            transliteration: "vidya",
            wordByWord: nil,
            grammarNote: nil,
            learningTip: nil,
            difficulty: .medium,
            alternatives: nil,
            confidenceNote: nil
        )

        let beforeCreation = Date()
        let record = TranslationRecord(from: response)
        let afterCreation = Date()

        XCTAssertGreaterThanOrEqual(record.createdAt, beforeCreation)
        XCTAssertLessThanOrEqual(record.createdAt, afterCreation)
    }

    /// T-PERS-013: nil wordByWord encodes to nil data
    func testNilWordByWordEncodesToNilData() {
        let response = TranslationResponse(
            sourceLanguage: "Sanskrit",
            targetLanguage: "English",
            originalText: "नमस्ते",
            translatedText: "Hello",
            transliteration: "namaste",
            wordByWord: nil,
            grammarNote: nil,
            learningTip: nil,
            difficulty: .easy,
            alternatives: nil,
            confidenceNote: nil
        )

        let record = TranslationRecord(from: response)

        XCTAssertNil(record.wordByWordJSON)
    }

    /// T-PERS-014: nil alternatives encodes to nil data
    func testNilAlternativesEncodesToNilData() {
        let response = TranslationResponse(
            sourceLanguage: "Sanskrit",
            targetLanguage: "English",
            originalText: "अलं",
            translatedText: "Enough",
            transliteration: "alam",
            wordByWord: nil,
            grammarNote: nil,
            learningTip: nil,
            difficulty: .easy,
            alternatives: nil,
            confidenceNote: nil
        )

        let record = TranslationRecord(from: response)

        XCTAssertNil(record.alternativesJSON)
    }

    /// T-PERS-015: asResponse with nil wordByWordJSON returns nil wordByWord
    func testAsResponseWithNilWordByWordJSONReturnsNilWordByWord() {
        let response = TranslationResponse(
            sourceLanguage: "Sanskrit",
            targetLanguage: "English",
            originalText: "कम्",
            translatedText: "Who",
            transliteration: "kam",
            wordByWord: nil,
            grammarNote: nil,
            learningTip: nil,
            difficulty: .easy,
            alternatives: nil,
            confidenceNote: nil
        )

        let record = TranslationRecord(from: response)
        let roundTrip = record.asResponse

        XCTAssertNil(roundTrip.wordByWord)
    }

    // MARK: - PracticeProgress Tests

    /// T-PERS-016: Init sets correct defaults
    func testPracticeProgressInitSetsCorrectDefaults() {
        let phraseID = "phrase-123"
        let progress = PracticeProgress(phraseID: phraseID)

        XCTAssertEqual(progress.phraseID, phraseID)
        XCTAssertEqual(progress.timesCorrect, 0)
        XCTAssertEqual(progress.timesAttempted, 0)
        XCTAssertNil(progress.lastPracticed)
        XCTAssertFalse(progress.isMastered)
    }

    /// T-PERS-017: accuracy with 0 attempts returns 0
    func testAccuracyWith0AttemptsReturns0() {
        let progress = PracticeProgress(phraseID: "phrase-456")

        XCTAssertEqual(progress.accuracy, 0.0)
    }

    /// T-PERS-018: accuracy calculation is correct
    func testAccuracyCalculationIsCorrect() {
        let progress = PracticeProgress(phraseID: "phrase-789")
        progress.timesCorrect = 3
        progress.timesAttempted = 5

        let expectedAccuracy = 3.0 / 5.0
        XCTAssertEqual(progress.accuracy, expectedAccuracy)
    }

    /// T-PERS-019: isMastered defaults to false
    func testIsMasteredDefaultsToFalse() {
        let progress = PracticeProgress(phraseID: "phrase-101")

        XCTAssertFalse(progress.isMastered)
    }

    // MARK: - SettingsManager Tests

    /// T-PERS-020: preferOffline is a Bool
    @MainActor
    func testPreferOfflineIsABool() {
        // `preferOffline` is typed `Bool` at the property level, so
        // the `is Bool` test the original version of this test ran
        // was a compile-time tautology (the warning Swift emitted
        // confirms this). Replaced with a behaviour assertion: the
        // property reads stably within a single test process — same
        // value on two consecutive reads with no writes in between.
        // If a future refactor switches `preferOffline` to compute
        // its value lazily from a clock or a network state, this
        // test will start failing and catch the regression.
        let settingsManager = SettingsManager.shared
        let firstRead = settingsManager.preferOffline
        let secondRead = settingsManager.preferOffline
        XCTAssertEqual(firstRead, secondRead,
                       "preferOffline must be stable across reads without intervening writes.")
    }

    // MARK: - L1 — atomic-write invariants
    //
    // We don't try to simulate a real mid-write crash here (would need a
    // forked child + SIGKILL). Instead: write a file via the same Data
    // .atomic option DataStore uses and assert the post-state matches
    // exactly. A regression where someone drops the .atomic option would
    // still pass this test, but it stops the case where the write API
    // itself silently changes shape.

    func testAtomicWriteRoundTrip() throws {
        let tmpDir = FileManager.default.temporaryDirectory
            .appendingPathComponent("desktopAhaan-tests-\(UUID().uuidString)",
                                    isDirectory: true)
        try FileManager.default.createDirectory(at: tmpDir,
                                                withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: tmpDir) }

        let target = tmpDir.appendingPathComponent("payload.json")
        // First write — file doesn't exist yet. .atomic = write to .tmp +
        // rename so the destination is always either old-or-new, never half.
        let v1 = #"{"version":1,"items":[]}"#
        try v1.data(using: .utf8)!.write(to: target, options: .atomic)
        let readback1 = try String(contentsOf: target, encoding: .utf8)
        XCTAssertEqual(readback1, v1)

        // Second write — file exists. .atomic still produces a clean
        // replace, no partial state.
        let v2 = #"{"version":2,"items":["a","b"]}"#
        try v2.data(using: .utf8)!.write(to: target, options: .atomic)
        let readback2 = try String(contentsOf: target, encoding: .utf8)
        XCTAssertEqual(readback2, v2)
        XCTAssertNotEqual(readback2, v1, "Second write should overwrite first.")
    }
}
