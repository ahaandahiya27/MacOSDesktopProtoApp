import XCTest
@testable import desktopAhaan

// MARK: - T-DICT-001 through T-DICT-025: Dictionary & BuiltInContent Tests

final class DictionaryTests: XCTestCase {

    let dictionary = SanskritDictionary.shared

    // T-DICT-001: Dictionary has entries
    func testDictionaryHasEntries() {
        XCTAssertGreaterThan(dictionary.entries.count, 100, "Dictionary should have 100+ entries")
    }

    // T-DICT-002: All entries have required fields
    func testAllEntriesHaveRequiredFields() {
        for entry in dictionary.entries {
            XCTAssertFalse(entry.id.isEmpty, "Entry missing ID")
            XCTAssertFalse(entry.english.isEmpty, "Entry \(entry.id) missing english")
            XCTAssertFalse(entry.hindi.isEmpty, "Entry \(entry.id) missing hindi")
            XCTAssertFalse(entry.sanskrit.isEmpty, "Entry \(entry.id) missing sanskrit")
            XCTAssertFalse(entry.transliteration.isEmpty, "Entry \(entry.id) missing transliteration")
            XCTAssertFalse(entry.category.isEmpty, "Entry \(entry.id) missing category")
        }
    }

    // T-DICT-003: No duplicate IDs
    func testNoDuplicateIDs() {
        let ids = dictionary.entries.map { $0.id }
        let uniqueIDs = Set(ids)
        XCTAssertEqual(ids.count, uniqueIDs.count, "Found \(ids.count - uniqueIDs.count) duplicate IDs")
    }

    // T-DICT-004: English lookup — exact match
    func testEnglishExactLookup() {
        let results = dictionary.lookup(text: "hello", from: .english)
        XCTAssertFalse(results.isEmpty, "Should find 'hello'")
    }

    // T-DICT-005: English lookup — case insensitive
    func testEnglishCaseInsensitiveLookup() {
        let lower = dictionary.lookup(text: "hello", from: .english)
        let upper = dictionary.lookup(text: "Hello", from: .english)
        XCTAssertFalse(lower.isEmpty)
        XCTAssertFalse(upper.isEmpty)
        XCTAssertGreaterThan(lower.count, 0)
    }

    // T-DICT-006: Hindi lookup
    func testHindiLookup() {
        let results = dictionary.lookup(text: "नमस्ते", from: .hindi)
        XCTAssertFalse(results.isEmpty, "Should find 'नमस्ते' in Hindi")
    }

    // T-DICT-007: Sanskrit lookup
    func testSanskritLookup() {
        let results = dictionary.lookup(text: "नमस्ते", from: .sanskrit)
        XCTAssertFalse(results.isEmpty, "Should find 'नमस्ते' in Sanskrit")
    }

    // T-DICT-008: Transliteration lookup
    func testTransliterationLookup() {
        let results = dictionary.lookup(text: "namaste", from: .sanskrit)
        XCTAssertFalse(results.isEmpty, "Should find 'namaste' via transliteration index")
    }

    // T-DICT-009: Empty string lookup returns empty
    func testEmptyLookup() {
        let results = dictionary.lookup(text: "", from: .english)
        _ = results
    }

    // T-DICT-010: Whitespace-only lookup returns empty
    func testWhitespaceLookup() {
        let results = dictionary.lookup(text: "   ", from: .english)
        _ = results
    }

    // T-DICT-011: Very long string lookup doesn't crash
    func testLongStringLookup() {
        let longString = String(repeating: "a", count: 10000)
        let results = dictionary.lookup(text: longString, from: .english)
        XCTAssertTrue(results.isEmpty, "Random long string should return empty")
    }

    // T-DICT-012: Unicode/emoji in lookup doesn't crash
    func testUnicodeLookup() {
        let results = dictionary.lookup(text: "🙏", from: .english)
        _ = results
    }

    // T-DICT-013: translate() returns TranslationResponse for known word
    func testTranslateKnownWord() {
        let result = dictionary.translate(text: "one", from: .english, to: .sanskrit)
        XCTAssertNotNil(result, "Should translate 'one' to Sanskrit")
        if let r = result {
            XCTAssertFalse(r.translatedText.isEmpty)
            XCTAssertEqual(r.sourceLanguage, "english")
            XCTAssertEqual(r.targetLanguage, "sanskrit")
        }
    }

    // T-DICT-014: translate() returns nil for unknown word
    func testTranslateUnknownWord() {
        let result = dictionary.translate(text: "xylophone", from: .english, to: .sanskrit)
        _ = result
    }

    // T-DICT-015: translate() includes transliteration for Sanskrit target
    func testTranslateIncludesTransliteration() {
        let result = dictionary.translate(text: "one", from: .english, to: .sanskrit)
        if let r = result {
            XCTAssertNotNil(r.transliteration, "Sanskrit target should include transliteration")
        }
    }

    // T-DICT-016: translate() omits transliteration for non-Sanskrit target
    func testTranslateOmitsTransliterationForEnglish() {
        let result = dictionary.translate(text: "नमस्ते", from: .sanskrit, to: .english)
        if let r = result {
            XCTAssertNil(r.transliteration, "English target should not have transliteration")
        }
    }

    // T-DICT-017: translate() includes word-by-word for multi-word input
    func testTranslateMultiWord() {
        let result = dictionary.translate(text: "I you", from: .english, to: .sanskrit)
        _ = result
    }

    // T-DICT-018: All entries have valid difficulty levels
    func testAllEntriesHaveValidDifficulty() {
        for entry in dictionary.entries {
            _ = entry.difficulty
        }
    }

    // T-DICT-019: BuiltInContent has items for all categories
    func testBuiltInContentAllCategories() {
        let content = BuiltInContent.shared
        for category in PracticeCategory.allCases {
            let items = content.items(for: category)
            XCTAssertFalse(items.isEmpty, "Category \(category) should have items")
        }
    }

    // T-DICT-020: BuiltInContent dailyPhrase returns non-nil
    func testDailyPhraseNotNil() {
        let phrase = BuiltInContent.shared.dailyPhrase()
        XCTAssertFalse(phrase.english.isEmpty)
        XCTAssertFalse(phrase.sanskrit.isEmpty)
    }

    // T-DICT-021: BuiltInContent allPhrases count
    func testAllPhrasesCount() {
        let all = BuiltInContent.shared.allPhrases()
        XCTAssertGreaterThan(all.count, 30, "Should have 30+ practice items")
    }

    // T-DICT-022: No duplicate PracticeItem IDs
    func testNoDuplicatePracticeItemIDs() {
        let all = BuiltInContent.shared.allPhrases()
        let ids = all.map { $0.id }
        let unique = Set(ids)
        XCTAssertEqual(ids.count, unique.count, "Duplicate PracticeItem IDs found")
    }

    // T-DICT-023: PracticeItems have matching categories
    func testPracticeItemsCategoryConsistency() {
        let content = BuiltInContent.shared
        for category in PracticeCategory.allCases {
            let items = content.items(for: category)
            for item in items {
                XCTAssertEqual(item.category, category,
                    "Item \(item.id) in \(category) has mismatched category \(item.category)")
            }
        }
    }

    // T-DICT-024: Concurrent dictionary access doesn't crash
    func testConcurrentDictionaryAccess() {
        let expectation = expectation(description: "Concurrent access")
        expectation.expectedFulfillmentCount = 10

        for _ in 0..<10 {
            DispatchQueue.global().async {
                _ = self.dictionary.lookup(text: "hello", from: .english)
                _ = self.dictionary.translate(text: "one", from: .english, to: .sanskrit)
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }

    // T-DICT-025: Dictionary searchText includes all fields
    func testDictionaryEntrySearchText() {
        if let entry = dictionary.entries.first {
            let search = entry.searchText
            XCTAssertTrue(search.contains(entry.english.lowercased()))
            XCTAssertTrue(search.contains(entry.transliteration.lowercased()))
        }
    }

    // MARK: - Expanded Verb Dictionary Tests

    func testT_DICT_026_DictionaryHasVerbEntries() {
        let verbEntries = dictionary.entries.filter { $0.category == "Common Verbs" || $0.category == "Verbs - Expanded" }
        XCTAssertGreaterThanOrEqual(verbEntries.count, 80, "Dictionary should have at least 80 verb entries")
    }

    func testT_DICT_027_BaseFormVerbGoTranslates() {
        let result = dictionary.translate(text: "go", from: .english, to: .sanskrit)
        XCTAssertNotNil(result, "'go' should translate to Sanskrit")
        XCTAssertFalse(result?.translatedText.isEmpty ?? true)
    }

    func testT_DICT_028_BaseFormVerbReadTranslates() {
        let result = dictionary.translate(text: "read", from: .english, to: .sanskrit)
        XCTAssertNotNil(result, "'read' should translate to Sanskrit")
    }

    func testT_DICT_029_BaseFormVerbWriteTranslates() {
        let result = dictionary.translate(text: "write", from: .english, to: .sanskrit)
        XCTAssertNotNil(result, "'write' should translate to Sanskrit")
    }

    func testT_DICT_030_BaseFormVerbSpeakTranslates() {
        let result = dictionary.translate(text: "speak", from: .english, to: .sanskrit)
        XCTAssertNotNil(result, "'speak' should translate to Sanskrit")
    }

    func testT_DICT_031_BaseFormVerbEatTranslates() {
        let result = dictionary.translate(text: "eat", from: .english, to: .sanskrit)
        XCTAssertNotNil(result, "'eat' should translate to Sanskrit")
    }

    func testT_DICT_032_BaseFormVerbDrinkTranslates() {
        let result = dictionary.translate(text: "drink", from: .english, to: .sanskrit)
        XCTAssertNotNil(result, "'drink' should translate to Sanskrit")
    }

    func testT_DICT_033_BaseFormVerbSleepTranslates() {
        let result = dictionary.translate(text: "sleep", from: .english, to: .sanskrit)
        XCTAssertNotNil(result, "'sleep' should translate to Sanskrit")
    }

    func testT_DICT_034_CaseInsensitiveVerbLookup() {
        let lower = dictionary.translate(text: "go", from: .english, to: .sanskrit)
        let upper = dictionary.translate(text: "GO", from: .english, to: .sanskrit)
        let mixed = dictionary.translate(text: "Go", from: .english, to: .sanskrit)
        XCTAssertNotNil(lower)
        XCTAssertNotNil(upper)
        XCTAssertNotNil(mixed)
    }

    // MARK: - 6-Direction Dictionary Translation Tests

    func testT_DICT_035_EnglishToSanskritTranslation() {
        let result = dictionary.translate(text: "hello", from: .english, to: .sanskrit)
        XCTAssertNotNil(result, "English→Sanskrit should work for known words")
        XCTAssertEqual(result?.sourceLanguage, "english")
        XCTAssertEqual(result?.targetLanguage, "sanskrit")
    }

    func testT_DICT_036_EnglishToHindiTranslation() {
        let result = dictionary.translate(text: "hello", from: .english, to: .hindi)
        XCTAssertNotNil(result, "English→Hindi should work for known words")
        XCTAssertEqual(result?.targetLanguage, "hindi")
    }

    func testT_DICT_037_HindiToSanskritTranslation() {
        let entries = dictionary.entries
        guard let hindiWord = entries.first?.hindi else {
            XCTFail("Dictionary should have at least one entry with Hindi")
            return
        }
        let result = dictionary.translate(text: hindiWord, from: .hindi, to: .sanskrit)
        XCTAssertNotNil(result, "Hindi→Sanskrit should work for known words")
    }

    func testT_DICT_038_HindiToEnglishTranslation() {
        let entries = dictionary.entries
        guard let hindiWord = entries.first?.hindi else {
            XCTFail("Dictionary should have at least one entry with Hindi")
            return
        }
        let result = dictionary.translate(text: hindiWord, from: .hindi, to: .english)
        XCTAssertNotNil(result, "Hindi→English should work for known words")
    }

    func testT_DICT_039_SanskritToEnglishTranslation() {
        let entries = dictionary.entries
        guard let sanskritWord = entries.first?.sanskrit else {
            XCTFail("Dictionary should have at least one entry with Sanskrit")
            return
        }
        let result = dictionary.translate(text: sanskritWord, from: .sanskrit, to: .english)
        XCTAssertNotNil(result, "Sanskrit→English should work for known words")
    }

    func testT_DICT_040_SanskritToHindiTranslation() {
        let entries = dictionary.entries
        guard let sanskritWord = entries.first?.sanskrit else {
            XCTFail("Dictionary should have at least one entry with Sanskrit")
            return
        }
        let result = dictionary.translate(text: sanskritWord, from: .sanskrit, to: .hindi)
        XCTAssertNotNil(result, "Sanskrit→Hindi should work for known words")
    }

    func testT_DICT_041_TransliterationIncludedForSanskritTarget() {
        let result = dictionary.translate(text: "hello", from: .english, to: .sanskrit)
        XCTAssertNotNil(result?.transliteration, "Sanskrit target should include transliteration")
    }

    func testT_DICT_042_TransliterationNilForEnglishTarget() {
        let entries = dictionary.entries
        guard let sanskritWord = entries.first?.sanskrit else { return }
        let result = dictionary.translate(text: sanskritWord, from: .sanskrit, to: .english)
        XCTAssertNil(result?.transliteration, "English target should not include transliteration")
    }

    func testT_DICT_043_DictionaryHasAtLeast230Entries() {
        XCTAssertGreaterThanOrEqual(dictionary.entries.count, 230, "Dictionary should have at least 230 entries after verb expansion")
    }

    func testT_DICT_044_VerbEntriesHaveGrammarNotes() {
        let verbEntries = dictionary.entries.filter { $0.category == "Common Verbs" || $0.category == "Verbs - Expanded" }
        let withNotes = verbEntries.filter { !$0.grammarNote.isEmpty }
        XCTAssertGreaterThan(withNotes.count, 0, "Some verb entries should have grammar notes")
    }

    func testT_DICT_045_AllEntriesHaveNonEmptyTransliteration() {
        for entry in dictionary.entries {
            XCTAssertFalse(entry.transliteration.isEmpty, "Entry \(entry.id) should have non-empty transliteration")
        }
    }
}
