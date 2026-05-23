import Foundation

/// One stretch ("Deep Dive") topic — a grade-tagged extension of a Class-7
/// concept aimed at a fast learner. Anchored to a specific Class-7 concept
/// in the SAME chapter via `parentConceptId`; the anchor rule is enforced
/// by `ChapterContentTests.testDeepDiveParentConceptIdsResolve`.
struct StretchTopic: Codable, Identifiable, Hashable {
    let id: String
    let title: String
    let gradeLevel: GradeLevel
    /// MUST resolve to a concept id inside this chapter — that's what keeps
    /// a Deep Dive anchored to a Class-7 base, not a random Class-11 dump.
    let parentConceptId: String
    /// 120–250 words. Class-7-fast-learner audience.
    let body: String
    /// One sentence: "Tackle this after you're comfortable with X."
    let prerequisite: String?
    /// Optional 2–3 questions at this grade level, with worked explanations.
    let bonusQuestions: [Question]?
    /// 1–2 sentences: where this concept goes after this depth.
    let nextStepHint: String?
}
