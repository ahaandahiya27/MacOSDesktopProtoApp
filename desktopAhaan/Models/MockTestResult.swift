import Foundation

// MARK: - MockTestResult
//
// v9 Exam Simulation. The durable record of one completed (or auto-submitted)
// mock test — the marking-scheme score plus per-subject + per-topic breakdowns,
// timing, and a per-question outcome list for the review screen. Persisted in
// its own file (`mock_test_results.json`) so it folds into the parent report
// card and a history accumulates; writing one is NEW app state, separate from
// the SRS.
//
// Big Sur compatible: Foundation-only Codable value types, no macOS 12+ APIs.

/// One answered/unanswered question's outcome.
struct MockTestQuestionOutcome: Codable, Hashable, Identifiable {
    /// Composite `packId::questionId` paper identity.
    let paperId: String
    let packId: String
    let questionId: String
    let subjectTitle: String
    let chapterTitle: String
    let topicKey: String
    let topicTitle: String
    let bank: MockTestBank
    let prompt: String
    let correctAnswer: String
    /// The option the kid picked, or nil if left unanswered.
    let selectedAnswer: String?
    let isCorrect: Bool
    let secondsSpent: Int
    let marksAwarded: Int

    var id: String { paperId }
    var isAnswered: Bool { selectedAnswer != nil }
}

/// One subject's tally within a result.
struct MockTestSubjectScore: Codable, Hashable, Identifiable {
    let packId: String
    let subjectTitle: String
    let correct: Int
    let wrong: Int
    let unanswered: Int
    let marks: Int
    let maxMarks: Int

    var id: String { packId }
    var total: Int { correct + wrong + unanswered }

    /// 0…1 fraction of this subject's questions answered correctly.
    var fraction: Double {
        guard total > 0 else { return 0 }
        return Double(correct) / Double(total)
    }
}

/// One topic/strand's tally within a result — the granularity weak areas are
/// reported at.
struct MockTestTopicScore: Codable, Hashable, Identifiable {
    let topicKey: String
    let topicTitle: String
    let packId: String
    let subjectTitle: String
    let correct: Int
    let total: Int

    var id: String { "\(packId)::\(topicKey)" }

    /// 0…1 fraction correct for this topic.
    var fraction: Double {
        guard total > 0 else { return 0 }
        return Double(correct) / Double(total)
    }
}

/// A completed mock test: scoring summary, breakdowns, timing, and outcomes.
struct MockTestResult: Codable, Hashable, Identifiable {
    let takenAt: Date
    /// Difficulty band the paper was built at.
    let band: MockTestDifficultyBand
    /// `true` for a cross-subject (Mixed) paper.
    let isMixed: Bool
    /// Requested time limit (seconds) — for the report's "time used" line.
    let timeLimitSeconds: Int
    /// `true` when the paper was force-submitted because the clock ran out.
    let autoSubmitted: Bool

    let totalQuestions: Int
    let correctCount: Int
    let wrongCount: Int
    let unansweredCount: Int

    let totalMarks: Int
    let maxMarks: Int
    /// Total seconds the kid spent across all questions (sum of per-question).
    let totalSecondsSpent: Int

    let perSubject: [MockTestSubjectScore]
    let perTopic: [MockTestTopicScore]
    let outcomes: [MockTestQuestionOutcome]

    /// Timestamp doubles as stable identity (one result per completion).
    var id: Date { takenAt }

    /// 0…1 overall fraction of questions answered correctly.
    var accuracyFraction: Double {
        guard totalQuestions > 0 else { return 0 }
        return Double(correctCount) / Double(totalQuestions)
    }

    /// 0…1 marks earned vs the maximum possible (negative marking can push the
    /// numerator below zero; clamped to 0 so a bar never renders inverted).
    var marksFraction: Double {
        guard maxMarks > 0 else { return 0 }
        return max(0, Double(totalMarks) / Double(maxMarks))
    }

    /// Average seconds per question (0 when the paper was empty).
    var averageSecondsPerQuestion: Double {
        guard totalQuestions > 0 else { return 0 }
        return Double(totalSecondsSpent) / Double(totalQuestions)
    }

    /// Topics most in need of attention: those with at least one question and
    /// below-60% accuracy, weakest first (ties broken by more questions, then
    /// topic title for determinism). Caps the list so the report stays compact.
    func weakTopics(limit: Int = 5, threshold: Double = 0.6) -> [MockTestTopicScore] {
        perTopic
            .filter { $0.total > 0 && $0.fraction < threshold }
            .sorted { a, b in
                if a.fraction != b.fraction { return a.fraction < b.fraction }
                if a.total != b.total { return a.total > b.total }
                return a.topicTitle < b.topicTitle
            }
            .prefix(limit)
            .map { $0 }
    }
}
