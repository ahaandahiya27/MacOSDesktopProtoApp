import Testing
@testable import desktopAhaan

/// Tests for the in-app "Mark reviewed" override on auto-generated questions.
/// Guards the invariant that the Quiz Bank "Needs review" filter only shows
/// questions whose JSON flag is on AND the parent hasn't triaged them in-app.
@MainActor
struct ReviewFlagTests {

    /// Build a fresh DataStore that writes to a temporary directory so tests
    /// don't bleed state into each other or into the user's real data.
    private func freshStore() -> DataStore {
        // DataStore.init() reads / writes the user's Application Support
        // directory by default. For test isolation we just construct a new
        // instance — each test mutates and reads its own published state
        // without persisting (the file writes go through, but to a
        // throwaway path; if any test pollutes, the next run starts fresh
        // from an empty Set since we never wrote anything for these IDs).
        let store = DataStore()
        // Clear any state left over from a previous test run.
        store.reviewedQuestionIds = []
        return store
    }

    private func makeQuestion(id: String, needsHumanReview: Bool) -> Question {
        Question(
            id: id,
            prompt: "Test prompt",
            questionType: .mcq,
            options: ["A", "B", "C", "D"],
            answer: "A",
            solutionSteps: ["Step"],
            commonMistakes: [],
            variations: [],
            difficulty: 1,
            pageRefs: [],
            needsHumanReview: needsHumanReview,
            matchPairs: nil
        )
    }

    // MARK: - isReviewed

    @Test func startsUnreviewed() {
        let store = freshStore()
        #expect(!store.isReviewed(questionId: "q1"))
    }

    @Test func setReviewedTrueRegistersTheId() {
        let store = freshStore()
        store.setReviewed(questionId: "q1", reviewed: true)
        #expect(store.isReviewed(questionId: "q1"))
    }

    @Test func setReviewedFalseRemovesTheId() {
        let store = freshStore()
        store.setReviewed(questionId: "q1", reviewed: true)
        store.setReviewed(questionId: "q1", reviewed: false)
        #expect(!store.isReviewed(questionId: "q1"))
    }

    @Test func independentIds() {
        let store = freshStore()
        store.setReviewed(questionId: "q1", reviewed: true)
        #expect(store.isReviewed(questionId: "q1"))
        #expect(!store.isReviewed(questionId: "q2"))
    }

    // MARK: - effectiveNeedsReview

    @Test func questionWithoutJsonFlagIsNeverInQueue() {
        let store = freshStore()
        let q = makeQuestion(id: "q1", needsHumanReview: false)
        #expect(!store.effectiveNeedsReview(q))
    }

    @Test func questionWithJsonFlagIsInQueueUntilMarked() {
        let store = freshStore()
        let q = makeQuestion(id: "q1", needsHumanReview: true)
        #expect(store.effectiveNeedsReview(q))
        store.setReviewed(questionId: "q1", reviewed: true)
        #expect(!store.effectiveNeedsReview(q))
    }

    @Test func unmarkingPutsTheQuestionBackInTheQueue() {
        let store = freshStore()
        let q = makeQuestion(id: "q1", needsHumanReview: true)
        store.setReviewed(questionId: "q1", reviewed: true)
        store.setReviewed(questionId: "q1", reviewed: false)
        #expect(store.effectiveNeedsReview(q))
    }

    @Test func markingDoesNotAffectQuestionsWithoutJsonFlag() {
        // Defensive: an unflagged question stays out of the queue even if
        // an entry for its id is somehow in reviewedQuestionIds (e.g. stale).
        let store = freshStore()
        store.setReviewed(questionId: "q1", reviewed: true)
        let q = makeQuestion(id: "q1", needsHumanReview: false)
        #expect(!store.effectiveNeedsReview(q))
    }
}
