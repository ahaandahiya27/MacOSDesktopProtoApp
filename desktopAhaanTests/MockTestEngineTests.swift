import XCTest
@testable import desktopAhaan

// MARK: - MockTestEngineTests
//
// v9 Exam Simulation · Phase 1. Pure unit tests over the FS-free, DataStore-free
// `MockTestEngine`: the topic-balanced gap-first ordering and the marking-scheme
// grading. No registry, no DataStore — fully deterministic.
final class MockTestEngineTests: XCTestCase {

    // MARK: - Builders

    private func cand(_ id: String, topic: String, rank: Int = 0,
                      ease: Double = 2.5, seq: Int) -> MockTestEngine.Candidate {
        MockTestEngine.Candidate(questionId: id, topicKey: topic,
                                 masteryRank: rank, ease: ease, seq: seq)
    }

    private func question(_ id: String, answer: String, options: [String],
                          difficulty: Int = 2) -> Question {
        Question(id: id, prompt: "Prompt \(id)", questionType: .mcq,
                 options: options, answer: answer, solutionSteps: ["Step for \(id)"],
                 commonMistakes: [], variations: [], difficulty: difficulty,
                 pageRefs: [], needsHumanReview: false)
    }

    private func mq(pack: String, subject: String, chapter: String,
                    topicKey: String, topicTitle: String,
                    _ q: Question, bank: MockTestBank = .topic) -> MockTestQuestion {
        MockTestQuestion(packId: pack, subjectTitle: subject, chapterId: chapter,
                         chapterTitle: "Ch \(chapter)", topicKey: topicKey,
                         topicTitle: topicTitle, bank: bank, question: q)
    }

    // MARK: - topicBalancedOrder

    func testTopicBalancedOrderRoundRobinsAcrossTopics() {
        // Three topics, three questions each, all equal strength. The order must
        // round-robin (one per topic per cycle), not drain a topic at a time.
        var cands: [MockTestEngine.Candidate] = []
        var seq = 0
        for t in ["A", "B", "C"] {
            for i in 1...3 { seq += 1; cands.append(cand("\(t)\(i)", topic: t, seq: seq)) }
        }
        let order = MockTestEngine.topicBalancedOrder(cands)
        XCTAssertEqual(order.count, 9)
        // First three picks must be one from each distinct topic.
        let firstThreeTopics = Set(order.prefix(3).map { String($0.prefix(1)) })
        XCTAssertEqual(firstThreeTopics, ["A", "B", "C"],
            "First cycle draws one question from each topic.")
        // A prefix(3) truncation therefore covers all three topics.
        XCTAssertEqual(Set(order.prefix(3)), ["A1", "B1", "C1"])
    }

    func testTopicBalancedOrderLeadsWithWeakestTopic() {
        // Topic LOW has a learning-rank head; topic HIGH is fully mastered. The
        // weakest topic must lead.
        let cands = [
            cand("h1", topic: "HIGH", rank: 3, ease: 2.5, seq: 1),
            cand("h2", topic: "HIGH", rank: 3, ease: 2.5, seq: 2),
            cand("l1", topic: "LOW", rank: 0, ease: 1.4, seq: 3),
            cand("l2", topic: "LOW", rank: 0, ease: 1.4, seq: 4)
        ]
        let order = MockTestEngine.topicBalancedOrder(cands)
        XCTAssertEqual(order.first, "l1", "Weakest topic's weakest item leads.")
        XCTAssertEqual(order, ["l1", "h1", "l2", "h2"], "Round-robin, weak topic first.")
    }

    func testTopicBalancedOrderSortsWithinTopicWeakestFirst() {
        // Same topic, varied strength → masteryRank asc, then ease asc, then seq.
        let cands = [
            cand("c", topic: "T", rank: 2, ease: 2.0, seq: 1),
            cand("a", topic: "T", rank: 0, ease: 1.5, seq: 2),
            cand("b", topic: "T", rank: 0, ease: 2.0, seq: 3)
        ]
        let order = MockTestEngine.topicBalancedOrder(cands)
        XCTAssertEqual(order, ["a", "b", "c"],
            "rank 0/ease 1.5, then rank 0/ease 2.0, then rank 2.")
    }

    func testTopicBalancedOrderIsDeterministic() {
        let cands = [
            cand("x", topic: "B", rank: 1, ease: 2.0, seq: 5),
            cand("y", topic: "A", rank: 1, ease: 2.0, seq: 2),
            cand("z", topic: "A", rank: 0, ease: 2.0, seq: 9)
        ]
        let first = MockTestEngine.topicBalancedOrder(cands)
        let second = MockTestEngine.topicBalancedOrder(cands)
        XCTAssertEqual(first, second, "Same input → same order, every time.")
        XCTAssertEqual(first.first, "z", "Topic A leads (its head is rank 0).")
    }

    func testTopicBalancedOrderHandlesEmptyAndSingle() {
        XCTAssertTrue(MockTestEngine.topicBalancedOrder([]).isEmpty)
        XCTAssertEqual(
            MockTestEngine.topicBalancedOrder([cand("solo", topic: "T", seq: 1)]),
            ["solo"])
    }

    // MARK: - grade · marking scheme

    private func paper(_ qs: [MockTestQuestion],
                       marking: MockTestMarkingScheme = .standard,
                       band: MockTestDifficultyBand = .balanced,
                       selection: MockTestSubjectSelection = .mixed) -> MockTestPaper {
        let config = MockTestConfig(selection: selection, band: band,
                                    questionCount: qs.count, timeLimitSeconds: 600,
                                    marking: marking)
        return MockTestPaper(questions: qs, config: config, generatedAt: Date(timeIntervalSince1970: 0))
    }

    func testGradeAppliesPlusFourMinusOneScheme() {
        let qA = question("qA", answer: "right", options: ["right", "wrong"])
        let qB = question("qB", answer: "right", options: ["right", "wrong"])
        let qC = question("qC", answer: "right", options: ["right", "wrong"])
        let p = paper([
            mq(pack: "p", subject: "S", chapter: "1", topicKey: "t1", topicTitle: "T1", qA),
            mq(pack: "p", subject: "S", chapter: "1", topicKey: "t1", topicTitle: "T1", qB),
            mq(pack: "p", subject: "S", chapter: "1", topicKey: "t1", topicTitle: "T1", qC)
        ])
        // qA correct (+4), qB wrong (−1), qC unanswered (0).
        let answers = ["p::qA": "right", "p::qB": "wrong"]
        let r = MockTestEngine.grade(paper: p, answers: answers,
                                     secondsByPaperId: [:],
                                     now: Date(timeIntervalSince1970: 100), autoSubmitted: false)
        XCTAssertEqual(r.correctCount, 1)
        XCTAssertEqual(r.wrongCount, 1)
        XCTAssertEqual(r.unansweredCount, 1)
        XCTAssertEqual(r.totalMarks, 3, "+4 − 1 + 0 = 3.")
        XCTAssertEqual(r.maxMarks, 12, "3 questions × 4.")
        XCTAssertEqual(r.totalQuestions, 3)
        XCTAssertFalse(r.autoSubmitted)
    }

    func testGradeGentleSchemeHasNoPenalty() {
        let qA = question("qA", answer: "right", options: ["right", "wrong"])
        let qB = question("qB", answer: "right", options: ["right", "wrong"])
        let p = paper([
            mq(pack: "p", subject: "S", chapter: "1", topicKey: "t1", topicTitle: "T1", qA),
            mq(pack: "p", subject: "S", chapter: "1", topicKey: "t1", topicTitle: "T1", qB)
        ], marking: .gentle)
        let r = MockTestEngine.grade(paper: p, answers: ["p::qA": "right", "p::qB": "wrong"],
                                     secondsByPaperId: [:], now: Date(), autoSubmitted: true)
        XCTAssertEqual(r.totalMarks, 1, "+1 correct, 0 for wrong (no penalty).")
        XCTAssertEqual(r.maxMarks, 2)
        XCTAssertTrue(r.autoSubmitted)
    }

    func testGradeMarksFractionClampsNonNegative() {
        // All wrong under negative marking → negative raw marks, clamped to 0.
        let qA = question("qA", answer: "right", options: ["right", "wrong"])
        let p = paper([mq(pack: "p", subject: "S", chapter: "1", topicKey: "t1", topicTitle: "T1", qA)])
        let r = MockTestEngine.grade(paper: p, answers: ["p::qA": "wrong"],
                                     secondsByPaperId: [:], now: Date(), autoSubmitted: false)
        XCTAssertEqual(r.totalMarks, -1)
        XCTAssertEqual(r.marksFraction, 0, "Negative marks never render an inverted bar.")
        XCTAssertEqual(r.accuracyFraction, 0)
    }

    // MARK: - grade · breakdowns + timing

    func testGradeBuildsPerSubjectAndPerTopicBreakdown() {
        let s1 = question("s1", answer: "a", options: ["a", "b"])
        let s2 = question("s2", answer: "a", options: ["a", "b"])
        let m1 = question("m1", answer: "a", options: ["a", "b"])
        let p = paper([
            mq(pack: "sci", subject: "Science", chapter: "1", topicKey: "sci_t1", topicTitle: "Heat", s1),
            mq(pack: "sci", subject: "Science", chapter: "1", topicKey: "sci_t2", topicTitle: "Light", s2),
            mq(pack: "mat", subject: "Maths", chapter: "1", topicKey: "mat_t1", topicTitle: "Ratios", m1)
        ])
        let r = MockTestEngine.grade(
            paper: p,
            answers: ["sci::s1": "a", "sci::s2": "b", "mat::m1": "a"],
            secondsByPaperId: ["sci::s1": 30, "sci::s2": 45, "mat::m1": 20],
            now: Date(), autoSubmitted: false)

        XCTAssertEqual(r.perSubject.count, 2)
        let sci = r.perSubject.first { $0.packId == "sci" }
        XCTAssertEqual(sci?.correct, 1)
        XCTAssertEqual(sci?.wrong, 1)
        XCTAssertEqual(sci?.total, 2)
        let mat = r.perSubject.first { $0.packId == "mat" }
        XCTAssertEqual(mat?.correct, 1)
        XCTAssertEqual(mat?.fraction, 1.0)

        XCTAssertEqual(r.perTopic.count, 3, "Three distinct topics across the paper.")
        let heat = r.perTopic.first { $0.topicTitle == "Heat" }
        XCTAssertEqual(heat?.fraction, 1.0)
        let light = r.perTopic.first { $0.topicTitle == "Light" }
        XCTAssertEqual(light?.fraction, 0.0)

        XCTAssertEqual(r.totalSecondsSpent, 95)
        XCTAssertEqual(r.averageSecondsPerQuestion, 95.0 / 3.0, accuracy: 0.001)
    }

    func testWeakTopicsAreSortedWeakestFirstAndThresholded() {
        // Build a paper across three topics with differing accuracy.
        func twoQ(pack: String, topic: String, title: String) -> [MockTestQuestion] {
            [mq(pack: pack, subject: "S", chapter: "1", topicKey: topic, topicTitle: title,
                question("\(topic)1", answer: "a", options: ["a", "b"])),
             mq(pack: pack, subject: "S", chapter: "1", topicKey: topic, topicTitle: title,
                question("\(topic)2", answer: "a", options: ["a", "b"]))]
        }
        var qs: [MockTestQuestion] = []
        qs += twoQ(pack: "p", topic: "good", title: "Good")   // both right
        qs += twoQ(pack: "p", topic: "bad", title: "Bad")     // both wrong
        qs += twoQ(pack: "p", topic: "half", title: "Half")   // one right
        let p = paper(qs)
        let answers = [
            "p::good1": "a", "p::good2": "a",
            "p::bad1": "b", "p::bad2": "b",
            "p::half1": "a", "p::half2": "b"
        ]
        let r = MockTestEngine.grade(paper: p, answers: answers,
                                     secondsByPaperId: [:], now: Date(), autoSubmitted: false)
        let weak = r.weakTopics()
        XCTAssertEqual(weak.map { $0.topicTitle }, ["Bad", "Half"],
            "Below-60% topics, weakest first; 'Good' (100%) is excluded.")
    }

    func testGradeEmptyPaper() {
        let r = MockTestEngine.grade(paper: paper([]), answers: [:],
                                     secondsByPaperId: [:], now: Date(), autoSubmitted: false)
        XCTAssertEqual(r.totalQuestions, 0)
        XCTAssertEqual(r.accuracyFraction, 0)
        XCTAssertEqual(r.marksFraction, 0)
        XCTAssertTrue(r.perSubject.isEmpty)
        XCTAssertTrue(r.weakTopics().isEmpty)
    }
}
