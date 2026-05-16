import Testing
@testable import desktopAhaan

/// Tests for TutorNavigationState's push/pop/replaceTop invariants. Protects
/// the navigation stack from regressions that would otherwise be caught only
/// by clicking through the UI.
@MainActor
struct TutorNavigationTests {

    @Test func startsEmpty() {
        let nav = TutorNavigationState()
        #expect(nav.path.isEmpty)
        #expect(nav.currentRoute == nil)
        #expect(nav.canGoBack == false)
    }

    @Test func pushAppendsToPath() {
        let nav = TutorNavigationState()
        nav.push(.chapter(packId: "p", chapterId: "ch01"))
        #expect(nav.path.count == 1)
        #expect(nav.canGoBack)
        #expect(nav.currentRoute == .chapter(packId: "p", chapterId: "ch01"))
    }

    @Test func pushMultipleStacks() {
        let nav = TutorNavigationState()
        nav.push(.chapter(packId: "p", chapterId: "ch01"))
        nav.push(.topic(packId: "p", topicId: "t1"))
        nav.push(.concept(packId: "p", conceptId: "c1"))
        #expect(nav.path.count == 3)
        #expect(nav.currentRoute == .concept(packId: "p", conceptId: "c1"))
    }

    @Test func popRemovesTop() {
        let nav = TutorNavigationState()
        nav.push(.chapter(packId: "p", chapterId: "ch01"))
        nav.push(.topic(packId: "p", topicId: "t1"))
        nav.pop()
        #expect(nav.path.count == 1)
        #expect(nav.currentRoute == .chapter(packId: "p", chapterId: "ch01"))
    }

    @Test func popOnEmptyPathIsNoop() {
        let nav = TutorNavigationState()
        nav.pop()  // must not crash
        #expect(nav.path.isEmpty)
    }

    @Test func popToRootClearsAll() {
        let nav = TutorNavigationState()
        nav.push(.chapter(packId: "p", chapterId: "ch01"))
        nav.push(.topic(packId: "p", topicId: "t1"))
        nav.push(.question(packId: "p", questionId: "q1"))
        nav.popToRoot()
        #expect(nav.path.isEmpty)
        #expect(nav.canGoBack == false)
    }

    @Test func replaceTopSwapsCurrentWithoutGrowingPath() {
        // Mirrors QuestionDetailView's Prev/Next behavior: the user moves
        // sideways between questions but the back button still returns to
        // the parent QuizBank rather than unwinding through every question.
        let nav = TutorNavigationState()
        nav.push(.chapter(packId: "p", chapterId: "ch01"))
        nav.push(.question(packId: "p", questionId: "q1"))
        #expect(nav.path.count == 2)
        nav.replaceTop(.question(packId: "p", questionId: "q2"))
        #expect(nav.path.count == 2)
        #expect(nav.currentRoute == .question(packId: "p", questionId: "q2"))
        nav.pop()
        #expect(nav.currentRoute == .chapter(packId: "p", chapterId: "ch01"))
    }

    @Test func replaceTopOnEmptyPathPushesInstead() {
        let nav = TutorNavigationState()
        nav.replaceTop(.chapter(packId: "p", chapterId: "ch01"))
        #expect(nav.path.count == 1)
        #expect(nav.currentRoute == .chapter(packId: "p", chapterId: "ch01"))
    }

    @Test func questionSiblingsStartEmpty() {
        let nav = TutorNavigationState()
        #expect(nav.questionSiblings.isEmpty)
    }

    @Test func questionSiblingsAreSettable() {
        let nav = TutorNavigationState()
        nav.questionSiblings = [
            QuestionRef(packId: "p", questionId: "q1"),
            QuestionRef(packId: "p", questionId: "q2"),
            QuestionRef(packId: "p", questionId: "q3"),
        ]
        #expect(nav.questionSiblings.count == 3)
        #expect(nav.questionSiblings[1].questionId == "q2")
    }
}
