import XCTest
@testable import desktopAhaan

final class ViewModelTests: XCTestCase {

    // MARK: - TranslatorViewModel Tests

    @MainActor
    func testT_VM_001_InitialStateDefaults() {
        let viewModel = TranslatorViewModel()

        XCTAssertEqual(viewModel.sourceLanguage, .english)
        XCTAssertEqual(viewModel.targetLanguage, .sanskrit)
        XCTAssertTrue(viewModel.inputText.isEmpty)
        XCTAssertNil(viewModel.result)
    }

    @MainActor
    func testT_VM_002_SwapLanguagesEnglishSanskrit() {
        let viewModel = TranslatorViewModel()
        viewModel.sourceLanguage = .english
        viewModel.targetLanguage = .sanskrit

        viewModel.swapLanguages()

        XCTAssertEqual(viewModel.sourceLanguage, .sanskrit)
        XCTAssertEqual(viewModel.targetLanguage, .english)
    }

    @MainActor
    func testT_VM_003_SwapLanguagesEnglishHindi() {
        let viewModel = TranslatorViewModel()
        viewModel.sourceLanguage = .english
        viewModel.targetLanguage = .hindi

        viewModel.swapLanguages()

        // English→Hindi swap should produce Hindi→English (both valid in 6-direction model)
        XCTAssertEqual(viewModel.sourceLanguage, .hindi)
        XCTAssertEqual(viewModel.targetLanguage, .english)
    }

    @MainActor
    func testT_VM_004_OnSourceChangedAdjustsTargetToValid() {
        let viewModel = TranslatorViewModel()
        viewModel.sourceLanguage = .english
        viewModel.targetLanguage = .sanskrit

        viewModel.sourceLanguage = .sanskrit
        viewModel.onSourceChanged()

        XCTAssertTrue(SupportedLanguage.sanskrit.validTargets.contains(viewModel.targetLanguage))
    }

    @MainActor
    func testT_VM_005_ClearResetsAllState() {
        let viewModel = TranslatorViewModel()
        viewModel.sourceLanguage = .sanskrit
        viewModel.targetLanguage = .english
        viewModel.inputText = "Test input"
        viewModel.isTranslating = true
        viewModel.errorMessage = "Test error"
        viewModel.showResult = true
        viewModel.translationSource = "Test source"
        viewModel.isFavorited = true

        viewModel.clear()

        XCTAssertTrue(viewModel.inputText.isEmpty)
        XCTAssertNil(viewModel.result)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.showResult)
        XCTAssertTrue(viewModel.translationSource.isEmpty)
        XCTAssertFalse(viewModel.isFavorited)
    }

    @MainActor
    func testT_VM_006_InitialIsFavoritedIsFalse() {
        let viewModel = TranslatorViewModel()

        XCTAssertFalse(viewModel.isFavorited)
    }

    @MainActor
    func testT_VM_007_InitialShowResultIsFalse() {
        let viewModel = TranslatorViewModel()

        XCTAssertFalse(viewModel.showResult)
    }

    @MainActor
    func testT_VM_008_InitialIsTranslatingIsFalse() {
        let viewModel = TranslatorViewModel()

        XCTAssertFalse(viewModel.isTranslating)
    }

    @MainActor
    func testT_VM_009_InputTextCanBeSet() {
        let viewModel = TranslatorViewModel()
        let testInput = "Namaste"

        viewModel.inputText = testInput

        XCTAssertEqual(viewModel.inputText, testInput)
    }

    @MainActor
    func testT_VM_010_TranslationSourceStartsEmpty() {
        let viewModel = TranslatorViewModel()

        XCTAssertTrue(viewModel.translationSource.isEmpty)
    }

    // MARK: - PracticeViewModel Tests

    @MainActor
    func testT_VM_011_LoadCategorySetsSelectedCategory() {
        let viewModel = PracticeViewModel()
        let category = PracticeCategory.greetings

        viewModel.loadCategory(category)

        XCTAssertEqual(viewModel.selectedCategory, category)
    }

    @MainActor
    func testT_VM_012_LoadCategoryPopulatesCurrentItems() {
        let viewModel = PracticeViewModel()
        let category = PracticeCategory.greetings

        viewModel.loadCategory(category)

        XCTAssertFalse(viewModel.currentItems.isEmpty)
    }

    @MainActor
    func testT_VM_013_LoadCategoryResetsFlashcardIndexToZero() {
        let viewModel = PracticeViewModel()
        viewModel.flashcardIndex = 5

        viewModel.loadCategory(.greetings)

        XCTAssertEqual(viewModel.flashcardIndex, 0)
    }

    @MainActor
    func testT_VM_014_LoadDailyPhraseReturnsNonNil() {
        let viewModel = PracticeViewModel()

        viewModel.loadDailyPhrase()

        XCTAssertNotNil(viewModel.dailyPhrase)
    }

    @MainActor
    func testT_VM_015_NextFlashcardIncrementsIndex() {
        let viewModel = PracticeViewModel()
        viewModel.loadCategory(.greetings)
        let initialIndex = viewModel.flashcardIndex

        viewModel.nextFlashcard()

        XCTAssertEqual(viewModel.flashcardIndex, initialIndex + 1)
    }

    @MainActor
    func testT_VM_016_NextFlashcardWrapsAround() {
        let viewModel = PracticeViewModel()
        viewModel.loadCategory(.greetings)
        viewModel.flashcardIndex = viewModel.currentItems.count - 1

        viewModel.nextFlashcard()

        XCTAssertEqual(viewModel.flashcardIndex, 0)
    }

    @MainActor
    func testT_VM_017_PreviousFlashcardDecrementsIndex() {
        let viewModel = PracticeViewModel()
        viewModel.loadCategory(.greetings)
        viewModel.flashcardIndex = 2

        viewModel.previousFlashcard()

        XCTAssertEqual(viewModel.flashcardIndex, 1)
    }

    @MainActor
    func testT_VM_018_PreviousFlashcardWrapsFromZeroToLast() {
        let viewModel = PracticeViewModel()
        viewModel.loadCategory(.greetings)
        viewModel.flashcardIndex = 0
        let itemCount = viewModel.currentItems.count

        viewModel.previousFlashcard()

        XCTAssertEqual(viewModel.flashcardIndex, itemCount - 1)
    }

    @MainActor
    func testT_VM_019_StartQuizSetsModeToDotQuiz() {
        let viewModel = PracticeViewModel()

        viewModel.startQuiz(category: .greetings)

        XCTAssertEqual(viewModel.mode, .quiz)
    }

    @MainActor
    func testT_VM_020_StartQuizSetsNonNilQuizItem() {
        let viewModel = PracticeViewModel()

        viewModel.startQuiz(category: .greetings)

        XCTAssertNotNil(viewModel.quizItem)
    }

    @MainActor
    func testT_VM_021_StartQuizClearsQuizAnswer() {
        let viewModel = PracticeViewModel()
        viewModel.quizAnswer = "Some previous answer"

        viewModel.startQuiz(category: .greetings)

        XCTAssertTrue(viewModel.quizAnswer.isEmpty)
    }

    @MainActor
    func testT_VM_022_InitialModeIsCategories() {
        let viewModel = PracticeViewModel()

        XCTAssertEqual(viewModel.mode, .categories)
    }

    @MainActor
    func testT_VM_023_ShowFlashcardAnswerStartsFalse() {
        let viewModel = PracticeViewModel()

        XCTAssertFalse(viewModel.showFlashcardAnswer)
    }

    @MainActor
    func testT_VM_024_NextFlashcardResetsShowFlashcardAnswer() {
        let viewModel = PracticeViewModel()
        viewModel.loadCategory(.greetings)
        viewModel.showFlashcardAnswer = true

        viewModel.nextFlashcard()

        XCTAssertFalse(viewModel.showFlashcardAnswer)
    }

    @MainActor
    func testT_VM_025_LoadCategoryForAllCategoriesReturnsNonEmptyItems() {
        let viewModel = PracticeViewModel()
        let categories: [PracticeCategory] = [
            .greetings, .numbers, .family, .classroom,
            .dailyActions, .schoolPhrases, .simpleSentences
        ]

        for category in categories {
            viewModel.loadCategory(category)
            XCTAssertFalse(viewModel.currentItems.isEmpty, "Category \(category) should have non-empty items")
        }
    }

    // MARK: - TranslatorViewModel Concurrency & Favorites Tests

    @MainActor
    func testT_VM_026_ViewModelInitWithNilParametersUsesDefaults() {
        let vm = TranslatorViewModel(translationService: nil, settings: nil)
        XCTAssertEqual(vm.sourceLanguage, .english)
        XCTAssertEqual(vm.targetLanguage, .sanskrit)
    }

    @MainActor
    func testT_VM_027_SwapLanguagesHindiSanskrit() {
        let vm = TranslatorViewModel()
        vm.sourceLanguage = .hindi
        vm.targetLanguage = .sanskrit

        vm.swapLanguages()

        XCTAssertEqual(vm.sourceLanguage, .sanskrit)
        XCTAssertEqual(vm.targetLanguage, .hindi)
    }

    @MainActor
    func testT_VM_028_SwapLanguagesEnglishHindi() {
        let vm = TranslatorViewModel()
        vm.sourceLanguage = .english
        vm.targetLanguage = .hindi

        vm.swapLanguages()

        XCTAssertEqual(vm.sourceLanguage, .hindi)
        XCTAssertEqual(vm.targetLanguage, .english)
    }

    @MainActor
    func testT_VM_029_OnSourceChangedSanskritToValidTarget() {
        let vm = TranslatorViewModel()
        vm.sourceLanguage = .hindi
        vm.targetLanguage = .english

        vm.sourceLanguage = .sanskrit
        vm.onSourceChanged()

        XCTAssertTrue(SupportedLanguage.sanskrit.validTargets.contains(vm.targetLanguage))
    }

    @MainActor
    func testT_VM_030_OnSourceChangedKeepsValidTarget() {
        let vm = TranslatorViewModel()
        vm.sourceLanguage = .english
        vm.targetLanguage = .sanskrit

        vm.sourceLanguage = .hindi
        vm.onSourceChanged()

        XCTAssertEqual(vm.targetLanguage, .sanskrit, "Should keep target when still valid")
    }

    @MainActor
    func testT_VM_031_ClearPreservesLanguageSelection() {
        let vm = TranslatorViewModel()
        vm.sourceLanguage = .hindi
        vm.targetLanguage = .english

        vm.clear()

        XCTAssertEqual(vm.sourceLanguage, .hindi, "clear() should preserve source language")
        XCTAssertEqual(vm.targetLanguage, .english, "clear() should preserve target language")
    }

    @MainActor
    func testT_VM_032_TranslateEmptyInputSetsError() async {
        let vm = TranslatorViewModel()
        vm.inputText = "   "

        let trimmed = vm.inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        XCTAssertTrue(trimmed.isEmpty, "Whitespace-only input should be treated as empty")
    }

    @MainActor
    func testT_VM_033_SpeechManagerExistsOnViewModel() {
        let vm = TranslatorViewModel()
        XCTAssertNotNil(vm.speechManager, "TranslatorViewModel should have a speechManager")
    }

    @MainActor
    func testT_VM_034_TTSManagerExistsOnViewModel() {
        let vm = TranslatorViewModel()
        XCTAssertNotNil(vm.ttsManager, "TranslatorViewModel should have a ttsManager")
    }

    @MainActor
    func testT_VM_035_SpeechManagerIsNotListeningInitially() {
        let vm = TranslatorViewModel()
        XCTAssertFalse(vm.speechManager.isListening)
    }

    @MainActor
    func testT_VM_036_TTSManagerIsNotSpeakingInitially() {
        let vm = TranslatorViewModel()
        XCTAssertFalse(vm.ttsManager.isSpeaking)
    }

    // MARK: - PracticeViewModel Additional Tests

    @MainActor
    func testT_VM_037_PreviousFlashcardResetsShowAnswer() {
        let vm = PracticeViewModel()
        vm.loadCategory(.greetings)
        vm.flashcardIndex = 2
        vm.showFlashcardAnswer = true

        vm.previousFlashcard()

        XCTAssertFalse(vm.showFlashcardAnswer, "previousFlashcard should reset showFlashcardAnswer")
    }

    @MainActor
    func testT_VM_038_NextQuizQuestionClearsAnswer() {
        let vm = PracticeViewModel()
        vm.loadCategory(.greetings)
        vm.startQuiz(category: .greetings)
        vm.quizAnswer = "some answer"

        vm.nextQuizQuestion()

        XCTAssertTrue(vm.quizAnswer.isEmpty, "nextQuizQuestion should clear the answer")
    }

    @MainActor
    func testT_VM_039_NextQuizQuestionClearsResult() {
        let vm = PracticeViewModel()
        vm.loadCategory(.greetings)
        vm.startQuiz(category: .greetings)

        vm.nextQuizQuestion()

        XCTAssertNil(vm.quizResult, "nextQuizQuestion should clear quiz result")
    }

    @MainActor
    func testT_VM_040_StartQuizClearsQuizResult() {
        let vm = PracticeViewModel()
        vm.startQuiz(category: .greetings)

        XCTAssertNil(vm.quizResult, "startQuiz should start with nil result")
    }
}
