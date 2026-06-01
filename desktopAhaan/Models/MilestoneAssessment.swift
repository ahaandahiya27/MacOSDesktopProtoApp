import Foundation

// MARK: - MilestoneAssessment
//
// v6 Learning Journey · Phase 4. The value model for a "Milestone Assessment":
// a short, mixed, cross-subject quiz sampled by MASTERY GAPS so that weaker
// subjects (and, within a subject, the kid's weakest reviewed questions) are
// tested more heavily. The sampling logic is the pure `MilestoneAssessmentPlanner`;
// the live gathering is `DataStore.buildMilestoneAssessment(...)`.
//
// Strictly READ-ONLY over the SRS — assembling or storing an assessment never
// schedules a review. (Answering its questions later flows through the normal
// QuestionDetailView path, which is the existing, unchanged SRS write site.)
//
// Big Sur compatible: Foundation-only value types, no macOS 12+ APIs.

/// One sampled question with the subject context the assessment UI needs, so
/// it never has to re-resolve the id against the registry. The resolved
/// `Question` is carried verbatim from the immutable pack.
struct AssessmentQuestion: Hashable, Identifiable {
    /// Owning pack id (`science_class7`, `maths_class7`, …) — also the
    /// `preferredPackId` to record any later answer against, so a colliding
    /// bare id lands in the right subject.
    let packId: String
    /// Human subject title, taken from the pack (`Maths — Class 7`).
    let subjectTitle: String
    /// Human chapter title the question lives in (for the result breakdown).
    let chapterTitle: String
    /// The question itself, copied from the pack.
    let question: Question

    /// Question ids are unique within a pack; the assessment never mixes two
    /// questions of the same id, so the question id is a stable identity.
    var id: String { question.id }
}

/// A generated milestone assessment: an ordered, mixed-subject question set
/// plus the bookkeeping a result screen / report card needs. Value type — the
/// whole thing is produced in one pass and never mutated after.
struct MilestoneAssessment: Hashable {
    /// The questions in presentation order (weak-subject-first round-robin).
    let questions: [AssessmentQuestion]
    /// When the assessment was generated (passed in by the builder; the pure
    /// planner never reads the clock).
    let generatedAt: Date
    /// How many questions came from each pack id — drives the result breakdown
    /// and the parent report card's per-subject line.
    let subjectCounts: [String: Int]

    /// `true` when nothing could be sampled (no started subject has reviewed
    /// topic questions yet) — the UI shows a "study a little first" state.
    var isEmpty: Bool { questions.isEmpty }

    /// Total number of questions in the assessment.
    var count: Int { questions.count }

    /// The distinct subject titles represented, in first-appearance order —
    /// a compact "this quiz covers …" line for the intro screen.
    var subjectTitles: [String] {
        var seen = Set<String>()
        var titles: [String] = []
        for q in questions where !seen.contains(q.subjectTitle) {
            seen.insert(q.subjectTitle)
            titles.append(q.subjectTitle)
        }
        return titles
    }
}
