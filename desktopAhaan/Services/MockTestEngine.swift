import Foundation

// MARK: - MockTestEngine
//
// v9 Exam Simulation. The PURE, FS-free, DataStore-free core of the Mock Test
// feature. It owns exactly two responsibilities, both unit-testable without the
// app:
//
//   1. ASSEMBLY ordering helpers — turning a subject's gathered candidates into
//      a topic-balanced, mastery-gap-first pool. Subject apportionment and the
//      weak-subject-first interleave are REUSED from
//      `MilestoneAssessmentPlanner.compose` (which itself reuses
//      `JourneyPlanner.roundRobinReviews`) — this engine does NOT re-derive that
//      math; it only adds the topic-balancing layer the milestone sampler lacks.
//
//   2. GRADING — applying a marking scheme to a finished paper + the kid's
//      answers + per-question timings, producing the per-subject / per-topic
//      breakdowns, marks, and timing the report and the report-card need.
//
// READ-ONLY over the SRS by construction: nothing here reads or writes
// `questionReviews`. The live gathering + the (deliberate, separate) SRS
// recording live in `DataStore+MockTest.swift`.
//
// Big Sur compatible: Foundation-only value math, no macOS 12+ APIs.

enum MockTestEngine {

    // MARK: - Candidate (assembly input)

    /// One eligible question as the live gatherer hands it to the engine: the
    /// id plus the sort keys that define mastery-gap-first order, and the topic
    /// key used to balance the paper across a subject's topics.
    ///
    /// `masteryRank` is the kid-facing `MasteryLevel.rawValue` (0 = learning …
    /// 3 = mastered) for a reviewed question, or `0` for an unseen one — so the
    /// weakest / never-attempted material sorts first (the biggest gaps). `ease`
    /// is the SM-2 ease (lower = slipped on more often); `seq` is authored order
    /// — together a fully-deterministic total order with no clock or RNG.
    struct Candidate: Hashable {
        let questionId: String
        let topicKey: String
        let masteryRank: Int
        let ease: Double
        let seq: Int

        init(questionId: String, topicKey: String,
             masteryRank: Int, ease: Double, seq: Int) {
            self.questionId = questionId
            self.topicKey = topicKey
            self.masteryRank = masteryRank
            self.ease = ease
            self.seq = seq
        }
    }

    // MARK: - Topic-balanced ordering (the one NEW pure step)

    /// Order one subject's candidates so the paper spreads across the subject's
    /// TOPICS rather than draining one chapter, while still leading with the
    /// kid's weakest material.
    ///
    /// Algorithm: bucket by `topicKey`; sort each bucket weakest-first
    /// (`masteryRank` asc, then `ease` asc, then `seq` asc); order the buckets by
    /// their own weakest head (same comparator, then `topicKey` for a stable
    /// tie-break); then round-robin one question from each bucket in that order,
    /// looping until every bucket is drained. The result is a single id list
    /// that is BOTH topic-balanced and gap-front-loaded — so a downstream
    /// `prefix(n)` truncation (as `MilestoneAssessmentPlanner.compose` does)
    /// keeps both properties. Pure — no FS, no DataStore, no clock, no RNG.
    static func topicBalancedOrder(_ candidates: [Candidate]) -> [String] {
        guard !candidates.isEmpty else { return [] }

        // Stable weakest-first comparator shared by within-bucket sort and the
        // bucket ordering.
        func weaker(_ a: Candidate, _ b: Candidate) -> Bool {
            if a.masteryRank != b.masteryRank { return a.masteryRank < b.masteryRank }
            if a.ease != b.ease { return a.ease < b.ease }
            return a.seq < b.seq
        }

        // Bucket by topic, preserving first-seen order so the grouping itself is
        // deterministic before we re-order by strength.
        var order: [String] = []
        var buckets: [String: [Candidate]] = [:]
        for c in candidates {
            if buckets[c.topicKey] == nil { order.append(c.topicKey) }
            buckets[c.topicKey, default: []].append(c)
        }
        for key in order {
            buckets[key]?.sort(by: weaker)
        }

        // Order the topics by their weakest head, then topicKey for stability.
        let topicOrder = order.sorted { lhs, rhs in
            guard let a = buckets[lhs]?.first, let b = buckets[rhs]?.first else {
                return lhs < rhs
            }
            if a.masteryRank != b.masteryRank { return a.masteryRank < b.masteryRank }
            if a.ease != b.ease { return a.ease < b.ease }
            if a.seq != b.seq { return a.seq < b.seq }
            return lhs < rhs
        }

        // Round-robin one from each topic, in topic order, until all drained.
        var cursor: [String: Int] = [:]
        var result: [String] = []
        var progressed = true
        while progressed {
            progressed = false
            for key in topicOrder {
                guard let bucket = buckets[key] else { continue }
                let i = cursor[key] ?? 0
                guard i < bucket.count else { continue }
                result.append(bucket[i].questionId)
                cursor[key] = i + 1
                progressed = true
            }
        }
        return result
    }

    // MARK: - Grading (pure)

    /// Grade a finished paper.
    ///
    /// `answers` maps a question's PAPER id (`packId::questionId`) to the option
    /// the kid selected; an absent key means unanswered. `secondsByPaperId` maps
    /// the same paper id to the seconds spent on it (absent ⇒ 0). `now` is the
    /// completion timestamp (the engine never reads the clock itself).
    /// `autoSubmitted` records whether the clock forced the submit.
    ///
    /// Correctness is decided by `AnswerValidator.matches` against the question's
    /// canonical answer — the same single-tap MCQ grading the Milestone
    /// Checkpoint uses. Pure — no FS, no DataStore, no SRS.
    static func grade(paper: MockTestPaper,
                      answers: [String: String],
                      secondsByPaperId: [String: Int],
                      now: Date,
                      autoSubmitted: Bool) -> MockTestResult {
        let scheme = paper.config.marking
        var outcomes: [MockTestQuestionOutcome] = []

        // Per-subject + per-topic accumulators, keeping first-seen order so the
        // breakdown rows follow the paper's order deterministically.
        var subjectOrder: [String] = []
        var subjectTitle: [String: String] = [:]
        var subjCorrect: [String: Int] = [:]
        var subjWrong: [String: Int] = [:]
        var subjUnanswered: [String: Int] = [:]
        var subjMarks: [String: Int] = [:]
        var subjMax: [String: Int] = [:]

        var topicOrder: [String] = []
        var topicMeta: [String: (title: String, packId: String, subject: String)] = [:]
        var topicCorrect: [String: Int] = [:]
        var topicTotal: [String: Int] = [:]

        var totalMarks = 0
        var maxMarks = 0
        var correctCount = 0
        var wrongCount = 0
        var unansweredCount = 0
        var totalSeconds = 0

        for q in paper.questions {
            let selected = answers[q.id]
            let answered = selected != nil
            let isCorrect = answered
                && AnswerValidator.matches(userInput: selected ?? "", truth: q.question.answer)
            let seconds = max(0, secondsByPaperId[q.id] ?? 0)
            let marks = scheme.marks(correct: isCorrect, answered: answered)

            outcomes.append(MockTestQuestionOutcome(
                paperId: q.id, packId: q.packId, questionId: q.question.id,
                subjectTitle: q.subjectTitle, chapterTitle: q.chapterTitle,
                topicKey: q.topicKey, topicTitle: q.topicTitle, bank: q.bank,
                prompt: q.question.prompt, correctAnswer: q.question.answer,
                selectedAnswer: selected, isCorrect: isCorrect,
                secondsSpent: seconds, marksAwarded: marks))

            // Roll up.
            totalMarks += marks
            maxMarks += scheme.marksPerCorrect
            totalSeconds += seconds
            if !answered { unansweredCount += 1 }
            else if isCorrect { correctCount += 1 }
            else { wrongCount += 1 }

            if subjectTitle[q.packId] == nil {
                subjectOrder.append(q.packId)
                subjectTitle[q.packId] = q.subjectTitle
            }
            subjMax[q.packId, default: 0] += scheme.marksPerCorrect
            subjMarks[q.packId, default: 0] += marks
            if !answered { subjUnanswered[q.packId, default: 0] += 1 }
            else if isCorrect { subjCorrect[q.packId, default: 0] += 1 }
            else { subjWrong[q.packId, default: 0] += 1 }

            let tKey = "\(q.packId)::\(q.topicKey)"
            if topicMeta[tKey] == nil {
                topicOrder.append(tKey)
                topicMeta[tKey] = (q.topicTitle, q.packId, q.subjectTitle)
            }
            topicTotal[tKey, default: 0] += 1
            if isCorrect { topicCorrect[tKey, default: 0] += 1 }
        }

        // Build the breakdowns with explicit loops + typed locals rather than
        // map-closures-of-initializers: the Swift 5.5 / Big Sur type-checker
        // chokes on a struct init with this many inferred dictionary subscripts
        // inside a closure ("unable to type-check in reasonable time").
        var perSubject: [MockTestSubjectScore] = []
        for pid in subjectOrder {
            let title: String = subjectTitle[pid] ?? pid
            let c: Int = subjCorrect[pid] ?? 0
            let w: Int = subjWrong[pid] ?? 0
            let u: Int = subjUnanswered[pid] ?? 0
            let m: Int = subjMarks[pid] ?? 0
            let mx: Int = subjMax[pid] ?? 0
            perSubject.append(MockTestSubjectScore(
                packId: pid, subjectTitle: title, correct: c, wrong: w,
                unanswered: u, marks: m, maxMarks: mx))
        }

        var perTopic: [MockTestTopicScore] = []
        for key in topicOrder {
            guard let meta = topicMeta[key] else { continue }
            let c: Int = topicCorrect[key] ?? 0
            let t: Int = topicTotal[key] ?? 0
            perTopic.append(MockTestTopicScore(
                topicKey: key, topicTitle: meta.title, packId: meta.packId,
                subjectTitle: meta.subject, correct: c, total: t))
        }

        return MockTestResult(
            takenAt: now, band: paper.config.band,
            isMixed: paper.config.selection.isMixed,
            timeLimitSeconds: paper.config.timeLimitSeconds,
            autoSubmitted: autoSubmitted,
            totalQuestions: paper.count, correctCount: correctCount,
            wrongCount: wrongCount, unansweredCount: unansweredCount,
            totalMarks: totalMarks, maxMarks: maxMarks,
            totalSecondsSpent: totalSeconds,
            perSubject: perSubject, perTopic: perTopic, outcomes: outcomes)
    }
}
