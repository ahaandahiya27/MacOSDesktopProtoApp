import Foundation
import SwiftData

/// Per-user study state. Lives alongside the existing TranslationRecord and
/// PracticeProgress models. Keep these models lightweight — they store IDs
/// pointing back into the (immutable, bundled) SubjectPack content.

@Model
final class StudyBookmark {
    /// Stable composite id: "<subjectPackId>::<conceptId>".
    /// Lets us upsert by id and prevent duplicate bookmarks.
    @Attribute(.unique) var id: String
    var subjectPackId: String
    var conceptId: String
    var conceptTitle: String
    var addedAt: Date

    init(subjectPackId: String, conceptId: String, conceptTitle: String, addedAt: Date = .now) {
        self.id = "\(subjectPackId)::\(conceptId)"
        self.subjectPackId = subjectPackId
        self.conceptId = conceptId
        self.conceptTitle = conceptTitle
        self.addedAt = addedAt
    }
}

@Model
final class QuestionAttempt {
    var id: UUID
    var subjectPackId: String
    var questionId: String
    var userAnswer: String
    var isCorrect: Bool
    var attemptedAt: Date

    init(subjectPackId: String, questionId: String, userAnswer: String, isCorrect: Bool, attemptedAt: Date = .now) {
        self.id = UUID()
        self.subjectPackId = subjectPackId
        self.questionId = questionId
        self.userAnswer = userAnswer
        self.isCorrect = isCorrect
        self.attemptedAt = attemptedAt
    }
}

@Model
final class StudySession {
    var id: UUID
    /// Stored as the day this session started (00:00 local time) so we can
    /// query "did the user study today?" with a simple equality check.
    var date: Date
    var minutesSpent: Int
    var conceptsViewed: Int
    var questionsAttempted: Int

    init(date: Date = .now, minutesSpent: Int = 0, conceptsViewed: Int = 0, questionsAttempted: Int = 0) {
        self.id = UUID()
        self.date = Calendar.current.startOfDay(for: date)
        self.minutesSpent = minutesSpent
        self.conceptsViewed = conceptsViewed
        self.questionsAttempted = questionsAttempted
    }
}
