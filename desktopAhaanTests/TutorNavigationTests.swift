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

    @Test func pushIsIdempotentForSameRouteOnTop() {
        // Regression: on the Late-2014 iMac, a fast double-click on a Quiz
        // Bank row appended the same route twice during a single SwiftUI
        // transition, corrupting the Attribute Graph and crashing in
        // AG::Graph::remove_removed_output. The push() guard now drops a
        // duplicate when the same route is already on top. This contract
        // protects every caller (BookmarksView, ChapterListView, etc.).
        let nav = TutorNavigationState()
        nav.push(.question(packId: "p", questionId: "q1"))
        nav.push(.question(packId: "p", questionId: "q1"))
        #expect(nav.path.count == 1)
        #expect(nav.currentRoute == .question(packId: "p", questionId: "q1"))
    }

    @Test func pushDistinguishesRoutesEvenAcrossSameCase() {
        // Idempotency must NOT collapse a sibling-swap that happens to use
        // the same case (e.g., .question → .question with a different id).
        // Such a sequence is legitimate (Prev/Next walks siblings) and the
        // path should grow normally.
        let nav = TutorNavigationState()
        nav.push(.question(packId: "p", questionId: "q1"))
        nav.push(.question(packId: "p", questionId: "q2"))
        #expect(nav.path.count == 2)
        #expect(nav.currentRoute == .question(packId: "p", questionId: "q2"))
    }

    @Test func popPushPopPushRapidSequenceStaysCorrect() {
        // The Late-2014 iMac crash class isn't just double-pushes — rapid
        // pop+push sequences during the SwiftUI transition window can also
        // corrupt the path. Verify the navigation stack stays consistent
        // through an interleaved sequence.
        let nav = TutorNavigationState()
        nav.push(.chapter(packId: "p", chapterId: "ch01"))
        nav.push(.topic(packId: "p", topicId: "t1"))
        nav.pop()
        nav.push(.topic(packId: "p", topicId: "t2"))
        nav.pop()
        nav.push(.topic(packId: "p", topicId: "t3"))
        #expect(nav.path.count == 2)
        #expect(nav.currentRoute == .topic(packId: "p", topicId: "t3"))
    }

    @Test func popToRootResetsQuestionSiblingsConsumerExpectsClean() {
        // popToRoot returns to the chapter list. QuestionDetailView's
        // sibling list belongs to the previous Quiz Bank visit; if we
        // navigate to a completely different route, the stale sibling
        // list shouldn't influence anything. Verify popToRoot clears the
        // path; siblings are conceptually independent state (the consumer
        // sets them on each push).
        let nav = TutorNavigationState()
        nav.questionSiblings = [
            QuestionRef(packId: "p", questionId: "q1"),
            QuestionRef(packId: "p", questionId: "q2"),
        ]
        nav.push(.question(packId: "p", questionId: "q1"))
        nav.popToRoot()
        #expect(nav.path.isEmpty)
        // questionSiblings deliberately NOT cleared by popToRoot — that's
        // the consumer's job. Documenting this invariant: nav owns the
        // stack; the caller owns the siblings snapshot.
        #expect(nav.questionSiblings.count == 2)
    }

    @Test func replaceTopOnEmptyPathPushesThenAdditionalPushesGrow() {
        // Edge: replaceTop falls back to push when path is empty (already
        // covered). Verify that AFTER such a fallback, normal push() on
        // the now-non-empty stack works as expected.
        let nav = TutorNavigationState()
        nav.replaceTop(.chapter(packId: "p", chapterId: "ch01"))
        nav.push(.topic(packId: "p", topicId: "t1"))
        nav.push(.concept(packId: "p", conceptId: "c1"))
        #expect(nav.path.count == 3)
        #expect(nav.currentRoute == .concept(packId: "p", conceptId: "c1"))
    }
}
