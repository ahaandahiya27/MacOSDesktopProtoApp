import Foundation

// MARK: - MilestoneCheckpointResult
//
// v6 Learning Journey · Phase 4 M3. The durable record of one completed
// Milestone Checkpoint — score plus a per-subject breakdown — persisted so the
// parent report card can fold in "the latest checkpoint" and so a history of
// checkpoints accumulates over time. Writing one is NEW app state in its own
// file (`milestone_checkpoints.json`); it never touches the SRS.
//
// Big Sur compatible: Foundation-only Codable value types, no macOS 12+ APIs.

/// One subject's correct/total tally within a checkpoint.
struct MilestoneSubjectScore: Codable, Hashable {
    let packId: String
    let subjectTitle: String
    let correct: Int
    let total: Int

    /// 0…1 fraction correct for this subject (0 when the subject had no
    /// questions in the checkpoint, which shouldn't occur but is handled).
    var fraction: Double {
        guard total > 0 else { return 0 }
        return Double(correct) / Double(total)
    }
}

/// A completed checkpoint: when it was taken, the overall score, and the
/// per-subject breakdown in the order the subjects appeared in the quiz.
struct MilestoneCheckpointResult: Codable, Hashable, Identifiable {
    let takenAt: Date
    let correctCount: Int
    let totalQuestions: Int
    let perSubject: [MilestoneSubjectScore]

    /// The timestamp doubles as a stable identity (one result per completion).
    var id: Date { takenAt }

    /// 0…1 overall fraction correct.
    var scoreFraction: Double {
        guard totalQuestions > 0 else { return 0 }
        return Double(correctCount) / Double(totalQuestions)
    }

    /// Build a result from a finished assessment and the per-question outcomes.
    /// Pure — no FS, no clock read (the caller passes `takenAt`). Preserves the
    /// quiz's subject order in `perSubject`.
    static func from(assessment: MilestoneAssessment,
                     correctById: [String: Bool],
                     takenAt: Date) -> MilestoneCheckpointResult {
        var order: [String] = []
        var titleByPack: [String: String] = [:]
        var totalByPack: [String: Int] = [:]
        var correctByPack: [String: Int] = [:]
        for q in assessment.questions {
            if titleByPack[q.packId] == nil {
                order.append(q.packId)
                titleByPack[q.packId] = q.subjectTitle
            }
            totalByPack[q.packId, default: 0] += 1
            if correctById[q.id] == true { correctByPack[q.packId, default: 0] += 1 }
        }
        let perSubject = order.map {
            MilestoneSubjectScore(packId: $0, subjectTitle: titleByPack[$0] ?? $0,
                                  correct: correctByPack[$0] ?? 0, total: totalByPack[$0] ?? 0)
        }
        let correctCount = correctById.values.filter { $0 }.count
        return MilestoneCheckpointResult(
            takenAt: takenAt, correctCount: correctCount,
            totalQuestions: assessment.count, perSubject: perSubject)
    }
}
