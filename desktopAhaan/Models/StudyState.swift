import Foundation

final class StudyBookmark: Identifiable, Codable {
    var id: String
    var subjectPackId: String
    var conceptId: String
    var conceptTitle: String
    var addedAt: Date

    init(subjectPackId: String, conceptId: String, conceptTitle: String, addedAt: Date = Date()) {
        self.id = "\(subjectPackId)::\(conceptId)"
        self.subjectPackId = subjectPackId
        self.conceptId = conceptId
        self.conceptTitle = conceptTitle
        self.addedAt = addedAt
    }
}

final class QuestionAttempt: Identifiable, Codable {
    var id: UUID
    var subjectPackId: String
    var questionId: String
    var userAnswer: String
    var isCorrect: Bool
    var attemptedAt: Date

    init(subjectPackId: String, questionId: String, userAnswer: String, isCorrect: Bool, attemptedAt: Date = Date()) {
        self.id = UUID()
        self.subjectPackId = subjectPackId
        self.questionId = questionId
        self.userAnswer = userAnswer
        self.isCorrect = isCorrect
        self.attemptedAt = attemptedAt
    }
}

final class StudySession: Identifiable, Codable {
    var id: UUID
    var date: Date
    var minutesSpent: Int
    var conceptsViewed: Int
    var questionsAttempted: Int

    init(date: Date = Date(), minutesSpent: Int = 0, conceptsViewed: Int = 0, questionsAttempted: Int = 0) {
        self.id = UUID()
        self.date = Calendar.current.startOfDay(for: date)
        self.minutesSpent = minutesSpent
        self.conceptsViewed = conceptsViewed
        self.questionsAttempted = questionsAttempted
    }
}
