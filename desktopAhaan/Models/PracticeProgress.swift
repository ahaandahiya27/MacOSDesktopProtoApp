import Foundation
import SwiftData

/// Tracks practice/quiz progress for a vocabulary item
@Model
final class PracticeProgress {
    var id: UUID
    var phraseID: String
    var timesCorrect: Int
    var timesAttempted: Int
    var lastPracticed: Date?
    var isMastered: Bool

    init(phraseID: String) {
        self.id = UUID()
        self.phraseID = phraseID
        self.timesCorrect = 0
        self.timesAttempted = 0
        self.lastPracticed = nil
        self.isMastered = false
    }

    var accuracy: Double {
        guard timesAttempted > 0 else { return 0 }
        return Double(timesCorrect) / Double(timesAttempted)
    }
}
