import XCTest
@testable import desktopAhaan

/// Tests for the pure-function derivation behind the chapter-scoped
/// "Stuck here?" strip. The view itself sits behind a
/// `@MainActor`/SwiftUI surface; these tests pin the math.
final class ChapterStuckSignalsTests: XCTestCase {

    // MARK: - Fixtures

    /// Synthesise a chapter through the JSON decoder so every
    /// Codable invariant (Concept's four-explanation contract,
    /// Question's full field set, Topic's `concepts`+`questions`
    /// shape) is honoured without requiring brittle memberwise
    /// inits in test code.
    private func makeChapter(
        id: String = "ch01",
        number: Int = 1,
        topics: [(tid: String, conceptIds: [String], questionIds: [String])]
    ) -> Chapter {
        let topicsJSON = topics.map { topic in
            let conceptsJSON = topic.conceptIds.map {
                Self.conceptJSON(id: $0, title: "Concept \($0)")
            }.joined(separator: ",")
            let questionsJSON = topic.questionIds.map {
                Self.questionJSON(id: $0, prompt: "Question \($0)")
            }.joined(separator: ",")
            return """
            {
              "id": "\(topic.tid)",
              "title": "Topic \(topic.tid)",
              "summary": "",
              "concepts": [\(conceptsJSON)],
              "questions": [\(questionsJSON)]
            }
            """
        }.joined(separator: ",")
        let json = """
        {
          "id": "\(id)",
          "number": \(number),
          "title": "Test Chapter \(id)",
          "summary": "Stub",
          "topics": [\(topicsJSON)],
          "pageRefs": []
        }
        """
        return try! JSONDecoder().decode(Chapter.self, from: json.data(using: .utf8)!)
    }

    private static func conceptJSON(id: String, title: String) -> String {
        """
        {
          "id": "\(id)",
          "title": "\(title)",
          "explanations": {"oneLine": "X"},
          "reasoning": "X",
          "useCases": [],
          "beyondTheBook": "X",
          "relatedConceptIds": [],
          "relatedQuestionIds": [],
          "pageRefs": [],
          "needsHumanReview": false
        }
        """
    }

    private static func questionJSON(id: String, prompt: String) -> String {
        """
        {
          "id": "\(id)",
          "prompt": "\(prompt)",
          "questionType": "shortAnswer",
          "answer": "X",
          "solutionSteps": ["step"],
          "commonMistakes": [],
          "variations": [],
          "difficulty": 1,
          "pageRefs": [],
          "needsHumanReview": false
        }
        """
    }

    private func fixtureChapter() -> Chapter {
        makeChapter(topics: [
            (tid: "ch_t1",
             conceptIds: ["ch_t1_c1"],
             questionIds: ["ch_t1_q1", "ch_t1_q2"]),
            (tid: "ch_t2",
             conceptIds: ["ch_t2_c1"],
             questionIds: ["ch_t2_q1", "ch_t2_q2"])
        ])
    }

    // MARK: - All three rows populated

    func testAllSignalsScopedToChapter() {
        let chapter = fixtureChapter()
        let signals = ChapterStuckHereStrip.signals(
            chapter: chapter,
            toughQuestionIds: Set(["ch_t1_q1", "other_q1"]),
            recentlyMissedIds: ["ch_t2_q1", "other_q1", "ch_t1_q2"],
            bookmarkedConceptIds: Set(["ch_t1_c1", "other_c1"])
        )
        XCTAssertEqual(signals.toughQuestionIds, ["ch_t1_q1"],
                       "tough should keep only this chapter's question ids")
        XCTAssertEqual(signals.recentlyMissedQuestionIds, ["ch_t2_q1", "ch_t1_q2"],
                       "recently-missed should keep original most-recent-first ordering AND filter to this chapter")
        XCTAssertEqual(signals.bookmarkedConceptIds, ["ch_t1_c1"],
                       "bookmarked concepts should be chapter-scoped")
        XCTAssertFalse(signals.isEmpty)
    }

    // MARK: - Empty cases

    func testEmptyWhenNoSignalsIntersectChapter() {
        let chapter = fixtureChapter()
        let signals = ChapterStuckHereStrip.signals(
            chapter: chapter,
            toughQuestionIds: Set(["foreign_q"]),
            recentlyMissedIds: ["another_foreign"],
            bookmarkedConceptIds: Set(["distant_c"])
        )
        XCTAssertTrue(signals.isEmpty,
            "view should auto-hide when no signal intersects this chapter")
    }

    func testEmptyWhenAllSignalSetsAreEmpty() {
        let chapter = fixtureChapter()
        let signals = ChapterStuckHereStrip.signals(
            chapter: chapter,
            toughQuestionIds: [],
            recentlyMissedIds: [],
            bookmarkedConceptIds: []
        )
        XCTAssertTrue(signals.isEmpty)
    }

    // MARK: - Ordering

    func testRecentlyMissedPreservesAggregatorOrder() {
        let chapter = fixtureChapter()
        let signals = ChapterStuckHereStrip.signals(
            chapter: chapter,
            toughQuestionIds: [],
            recentlyMissedIds: ["ch_t2_q2", "ch_t1_q1", "ch_t2_q1"],
            bookmarkedConceptIds: []
        )
        XCTAssertEqual(signals.recentlyMissedQuestionIds,
                       ["ch_t2_q2", "ch_t1_q1", "ch_t2_q1"])
    }

    func testToughOrderFollowsChapterTopicOrder() {
        // Tough ids come from a Set (no order); to keep the chip
        // strip stable across re-renders, the derivation follows
        // the chapter's allQuestionIds sequence.
        let chapter = fixtureChapter()
        let signals = ChapterStuckHereStrip.signals(
            chapter: chapter,
            toughQuestionIds: Set(["ch_t2_q2", "ch_t1_q1", "ch_t1_q2"]),
            recentlyMissedIds: [],
            bookmarkedConceptIds: []
        )
        XCTAssertEqual(signals.toughQuestionIds,
                       ["ch_t1_q1", "ch_t1_q2", "ch_t2_q2"],
                       "tough chips must follow chapter.allQuestionIds order")
    }

    // MARK: - Chapter.allQuestionIds / allConceptIds

    func testChapterAllQuestionIdsTraversesAllTopics() {
        let chapter = fixtureChapter()
        XCTAssertEqual(chapter.allQuestionIds,
                       ["ch_t1_q1", "ch_t1_q2", "ch_t2_q1", "ch_t2_q2"])
    }

    func testChapterAllConceptIdsTraversesAllTopics() {
        let chapter = fixtureChapter()
        XCTAssertEqual(chapter.allConceptIds, ["ch_t1_c1", "ch_t2_c1"])
    }
}
