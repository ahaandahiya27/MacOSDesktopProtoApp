import XCTest
@testable import desktopAhaan

// MARK: - T-MOD-001 through T-MOD-020: Language & Model Layer Tests

@available(macOS 13, *)
final class LanguageModelTests: XCTestCase {

    // T-MOD-001: All languages have valid display names
    func testAllLanguagesHaveDisplayNames() {
        for lang in SupportedLanguage.allCases {
            XCTAssertFalse(lang.displayName.isEmpty, "\(lang) missing displayName")
            XCTAssertFalse(lang.nativeLabel.isEmpty, "\(lang) missing nativeLabel")
            XCTAssertFalse(lang.shortName.isEmpty, "\(lang) missing shortName")
        }
    }

    // T-MOD-002: Valid translation pairs (6-direction model)
    func testValidTranslationPairs() {
        XCTAssertTrue(TranslationPair(source: .english, target: .sanskrit).isValid)
        XCTAssertTrue(TranslationPair(source: .hindi, target: .sanskrit).isValid)
        XCTAssertTrue(TranslationPair(source: .sanskrit, target: .english).isValid)
        XCTAssertTrue(TranslationPair(source: .sanskrit, target: .hindi).isValid)
        XCTAssertTrue(TranslationPair(source: .english, target: .hindi).isValid)
        XCTAssertTrue(TranslationPair(source: .hindi, target: .english).isValid)
    }

    // T-MOD-003: Same-language pairs are invalid
    func testSameLanguagePairsInvalid() {
        XCTAssertFalse(TranslationPair(source: .english, target: .english).isValid)
        XCTAssertFalse(TranslationPair(source: .sanskrit, target: .sanskrit).isValid)
        XCTAssertFalse(TranslationPair(source: .hindi, target: .hindi).isValid)
    }

    // T-MOD-004: Each language has at least one valid target
    func testAllLanguagesHaveValidTargets() {
        for lang in SupportedLanguage.allCases {
            XCTAssertFalse(lang.validTargets.isEmpty, "\(lang) has no valid targets")
        }
    }

    // T-MOD-005: Speech and TTS locales are valid BCP-47
    func testLocalesAreValidBCP47() {
        for lang in SupportedLanguage.allCases {
            let speechLocale = Locale(identifier: lang.speechLocale)
            XCTAssertNotNil(speechLocale.language.languageCode, "\(lang) speechLocale invalid")
            let ttsLocale = Locale(identifier: lang.ttsLocale)
            XCTAssertNotNil(ttsLocale.language.languageCode, "\(lang) ttsLocale invalid")
        }
    }

    // T-MOD-006: TranslationPair displayString format
    func testTranslationPairDisplayString() {
        let pair = TranslationPair(source: .english, target: .sanskrit)
        XCTAssertEqual(pair.displayString, "EN → SA")
    }

    // T-MOD-007: DifficultyLevel raw values
    func testDifficultyLevelRawValues() {
        XCTAssertEqual(DifficultyLevel.easy.rawValue, "Easy")
        XCTAssertEqual(DifficultyLevel.medium.rawValue, "Medium")
        XCTAssertEqual(DifficultyLevel.hard.rawValue, "Hard")
    }

    // T-MOD-008: DifficultyLevel Codable round-trip
    func testDifficultyLevelCodable() throws {
        let original = DifficultyLevel.hard
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(DifficultyLevel.self, from: data)
        XCTAssertEqual(original, decoded)
    }

    // T-MOD-009: TranslationResponse Codable round-trip
    func testTranslationResponseCodable() throws {
        let response = TranslationResponse(
            sourceLanguage: "english",
            targetLanguage: "sanskrit",
            originalText: "hello",
            translatedText: "नमस्ते",
            transliteration: "namaste",
            wordByWord: [WordMeaning(source: "hello", target: "नमस्ते", note: "greeting")],
            grammarNote: "Simple greeting",
            learningTip: "Most common greeting",
            difficulty: .easy,
            alternatives: ["नमः"],
            confidenceNote: "High confidence"
        )
        let data = try JSONEncoder().encode(response)
        let decoded = try JSONDecoder().decode(TranslationResponse.self, from: data)
        XCTAssertEqual(response, decoded)
    }

    // T-MOD-010: WordMeaning ID uniqueness for different entries
    func testWordMeaningIDUniqueness() {
        let w1 = WordMeaning(source: "hello", target: "नमस्ते", note: "greeting")
        let w2 = WordMeaning(source: "hello", target: "नमस्ते", note: "salutation")
        let w3 = WordMeaning(source: "hello", target: "स्वागतम्", note: "greeting")
        XCTAssertNotEqual(w1.id, w2.id, "Different notes should produce different IDs")
        XCTAssertNotEqual(w1.id, w3.id, "Different targets should produce different IDs")
    }

    // T-MOD-011: WordMeaning ID collision with nil notes
    func testWordMeaningIDWithNilNotes() {
        let w1 = WordMeaning(source: "a", target: "b", note: nil)
        let w2 = WordMeaning(source: "a", target: "b", note: nil)
        XCTAssertEqual(w1.id, w2.id, "Same inputs produce same ID (known limitation)")
    }

    // T-MOD-012: PracticeCategory has all expected cases
    func testPracticeCategoryCoverage() {
        let categories = PracticeCategory.allCases
        XCTAssertEqual(categories.count, 7)
        XCTAssertTrue(categories.contains(.greetings))
        XCTAssertTrue(categories.contains(.numbers))
        XCTAssertTrue(categories.contains(.family))
        XCTAssertTrue(categories.contains(.classroom))
        XCTAssertTrue(categories.contains(.dailyActions))
        XCTAssertTrue(categories.contains(.schoolPhrases))
        XCTAssertTrue(categories.contains(.simpleSentences))
    }

    // T-MOD-013: PracticeCategory icons are valid SF Symbols
    func testPracticeCategoryIcons() {
        for category in PracticeCategory.allCases {
            XCTAssertFalse(category.icon.isEmpty, "\(category) missing icon")
            XCTAssertFalse(category.icon.contains(" "), "\(category) icon contains space")
        }
    }

    // T-MOD-014: PracticeItem is Identifiable
    func testPracticeItemIdentifiable() {
        let item = PracticeItem(
            id: "test1", category: .greetings,
            english: "Hello", hindi: "नमस्ते", sanskrit: "नमस्ते",
            transliteration: "namaste", grammarNote: nil, difficulty: .easy
        )
        XCTAssertEqual(item.id, "test1")
    }

    // T-MOD-015: PracticeProgress accuracy calculation
    func testPracticeProgressAccuracy() {
        let progress = PracticeProgress(phraseID: "test")
        XCTAssertEqual(progress.accuracy, 0.0, "Zero attempts = 0 accuracy")

        progress.timesAttempted = 10
        progress.timesCorrect = 8
        XCTAssertEqual(progress.accuracy, 0.8, accuracy: 0.001)

        progress.timesCorrect = 0
        XCTAssertEqual(progress.accuracy, 0.0)

        progress.timesCorrect = 10
        XCTAssertEqual(progress.accuracy, 1.0)
    }

    // T-MOD-016: PracticeProgress mastery threshold
    func testPracticeProgressMastery() {
        let progress = PracticeProgress(phraseID: "test")
        progress.timesAttempted = 3
        progress.timesCorrect = 3
        XCTAssertFalse(progress.isMastered, "Not auto-mastered; must be set")
    }

    // T-MOD-017: TranslationError localized descriptions exist
    func testTranslationErrorDescriptions() {
        let errors: [TranslationError] = [
            .networkUnavailable,
            .invalidResponse,
            .providerError("test"),
            .unsupportedPair(.english, .hindi),
            .emptyInput,
            .notInDictionary("test")
        ]
        for error in errors {
            XCTAssertNotNil(error.errorDescription, "\(error) missing description")
            XCTAssertFalse(error.errorDescription!.isEmpty)
        }
    }

    // T-MOD-018: TranslationError contains user-friendly text
    func testTranslationErrorUserFriendly() {
        let error = TranslationError.notInDictionary("xyz")
        XCTAssertTrue(error.errorDescription!.contains("xyz"), "Should include the searched term")
    }

    // T-MOD-019: Swap from valid pair remains valid
    func testSwapLanguagePair() {
        let pair = TranslationPair(source: .english, target: .sanskrit)
        let swapped = TranslationPair(source: pair.target, target: pair.source)
        XCTAssertTrue(swapped.isValid)
    }

    // T-MOD-020: Same language pair is never valid
    func testSameLanguagePairInvalid() {
        for lang in SupportedLanguage.allCases {
            let pair = TranslationPair(source: lang, target: lang)
            XCTAssertFalse(pair.isValid, "\(lang) → \(lang) should be invalid")
        }
    }

    // MARK: - 6-Direction Language Matrix Tests

    func testT_MOD_021_EnglishToSanskritIsValid() {
        XCTAssertTrue(TranslationPair(source: .english, target: .sanskrit).isValid)
    }

    func testT_MOD_022_EnglishToHindiIsValid() {
        XCTAssertTrue(TranslationPair(source: .english, target: .hindi).isValid)
    }

    func testT_MOD_023_HindiToSanskritIsValid() {
        XCTAssertTrue(TranslationPair(source: .hindi, target: .sanskrit).isValid)
    }

    func testT_MOD_024_HindiToEnglishIsValid() {
        XCTAssertTrue(TranslationPair(source: .hindi, target: .english).isValid)
    }

    func testT_MOD_025_SanskritToEnglishIsValid() {
        XCTAssertTrue(TranslationPair(source: .sanskrit, target: .english).isValid)
    }

    func testT_MOD_026_SanskritToHindiIsValid() {
        XCTAssertTrue(TranslationPair(source: .sanskrit, target: .hindi).isValid)
    }

    func testT_MOD_027_AllSixDirectionsAreValid() {
        let directions: [(SupportedLanguage, SupportedLanguage)] = [
            (.english, .sanskrit), (.english, .hindi),
            (.hindi, .sanskrit), (.hindi, .english),
            (.sanskrit, .english), (.sanskrit, .hindi)
        ]
        for (src, tgt) in directions {
            let pair = TranslationPair(source: src, target: tgt)
            XCTAssertTrue(pair.isValid, "\(src.shortName) → \(tgt.shortName) should be valid")
        }
    }

    func testT_MOD_028_EachLanguageHasExactlyTwoValidTargets() {
        for lang in SupportedLanguage.allCases {
            XCTAssertEqual(lang.validTargets.count, 2, "\(lang.displayName) should have exactly 2 valid targets")
        }
    }

    func testT_MOD_029_NoLanguageTargetsItself() {
        for lang in SupportedLanguage.allCases {
            XCTAssertFalse(lang.validTargets.contains(lang), "\(lang.displayName) should not target itself")
        }
    }

    func testT_MOD_030_TranslationPairDisplayStringFormat() {
        let pair = TranslationPair(source: .sanskrit, target: .english)
        XCTAssertEqual(pair.displayString, "SA → EN")
    }

    // MARK: - Speech & TTS Locale Tests

    func testT_MOD_031_AllLanguagesHaveSpeechLocale() {
        for lang in SupportedLanguage.allCases {
            XCTAssertFalse(lang.speechLocale.isEmpty, "\(lang.displayName) should have a speech locale")
        }
    }

    func testT_MOD_032_AllLanguagesHaveTTSLocale() {
        for lang in SupportedLanguage.allCases {
            XCTAssertFalse(lang.ttsLocale.isEmpty, "\(lang.displayName) should have a TTS locale")
        }
    }

    func testT_MOD_033_SanskritSpeechLocaleFallsBackToSaIN() {
        XCTAssertEqual(SupportedLanguage.sanskrit.speechLocale, "sa-IN")
    }

    func testT_MOD_034_SanskritTTSLocaleFallsBackToHindi() {
        XCTAssertEqual(SupportedLanguage.sanskrit.ttsLocale, "hi-IN")
    }

    func testT_MOD_035_WordMeaningIDIncludesNote() {
        let wm1 = WordMeaning(source: "go", target: "गच्छ", note: "verb root")
        let wm2 = WordMeaning(source: "go", target: "गच्छ", note: nil)
        XCTAssertNotEqual(wm1.id, wm2.id, "WordMeaning IDs should differ when notes differ")
    }
}
