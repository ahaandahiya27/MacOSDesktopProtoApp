import Foundation

// MARK: - Milestone Assessment builder (cross-subject, mastery-gap-weighted)
//
// v6 Learning Journey · Phase 4. The `@MainActor` half of the
// MilestoneAssessmentPlanner: it gathers each subject's pool of reviewed topic
// questions, ordered weakest-first, then hands the pools to the pure planner to
// apportion slots by mastery gap and interleave the picks across subjects.
//
// What "sampled by mastery gaps" means here, concretely:
//   • SUBJECT level — a subject's share of the quiz is weighted by its gap
//     (`1 − masteryFraction`), so a weaker subject is tested more (planner).
//   • QUESTION level — within a subject, questions are ordered weakest-first:
//     lowest `MasteryLevel` (`learning < familiar < confident < mastered`),
//     then lowest SM-2 ease (the ones the kid keeps slipping on), then authored
//     order. The subject's weakest reviewed items are drawn first.
//
// Scope choices, deliberately principled:
//   • Only STARTED subjects (≥1 reviewed topic question) contribute — a
//     milestone assessment re-tests studied material; it never quizzes a
//     subject the kid has never opened.
//   • Only REVIEWED, SINGLE-TAP-GRADABLE topic questions are eligible — a
//     multiple-choice question whose options include its canonical answer
//     (`isAssessableMCQ`). Free-text / match-the-following items are out of
//     scope for the checkpoint quiz: a milestone assessment is a multiple-choice
//     test, scored unambiguously without lenient phrase matching. Unseen content
//     and the scene-embedded boss / quick-check ids are likewise excluded. The
//     pool is resolved against the pack's own question objects, so a colliding
//     bare id is credited only to the subject the kid answered it in (matches
//     MasteryEngine's locator contract).
//   • A thin profile yields a SHORTER assessment rather than filler.
//
// READ-ONLY over the SRS: reads `questionReviews` + the immutable packs only —
// no mutation, no scheduling, no disk write. Mirrors MasteryEngine /
// JourneyPlanner.
//
// Big Sur compatible: value types, no macOS 12+ APIs.

extension DataStore {

    /// Default number of questions in a milestone assessment. Clamped down to
    /// the eligible pool size, so a young profile simply gets a shorter quiz.
    static let milestoneAssessmentDefaultCount = 10

    /// A question is eligible for a milestone assessment only if it can be
    /// scored unambiguously by a single tap: a multiple-choice question whose
    /// options include its canonical answer. Everything else (free-text,
    /// numerical, match-the-following) routes through the normal practice
    /// surfaces, which keep their richer answer + grading UX.
    static func isAssessableMCQ(_ question: Question) -> Bool {
        guard question.questionType == .mcq,
              let options = question.options, !options.isEmpty else { return false }
        return options.contains {
            AnswerValidator.matches(userInput: $0, truth: question.answer)
        }
    }

    /// Build a fresh mixed, cross-subject milestone assessment weighted toward
    /// the kid's mastery gaps. Returns an empty assessment when no started
    /// subject has any reviewed topic question yet.
    func buildMilestoneAssessment(
        registry: SubjectRegistry?,
        targetCount: Int = DataStore.milestoneAssessmentDefaultCount,
        now: Date = Date()
    ) -> MilestoneAssessment {
        guard let registry = registry, targetCount > 0 else {
            return MilestoneAssessment(questions: [], generatedAt: now, subjectCounts: [:])
        }

        let snapshot = MasteryEngine.snapshot(registry: registry, dataStore: self, now: now)
        let order = JourneyPlanner.subjectFocusOrder(snapshot)
        let reviews = questionReviews

        // Gather each subject's weakest-first pool of reviewed topic questions,
        // plus a per-pack gap weight and an id → resolved-question map.
        var poolsByPack: [String: [String]] = [:]
        var weightByPack: [String: Double] = [:]
        var resolved: [String: AssessmentQuestion] = [:]

        for subject in snapshot.startedSubjects {
            guard let pack = registry.pack(withId: subject.packId) else { continue }
            var candidates: [(id: String, rank: Int, ease: Double, seq: Int)] = []
            var seq = 0
            for chapter in pack.chapters {
                for topic in chapter.topics {
                    for question in topic.questions {
                        seq += 1
                        guard Self.isAssessableMCQ(question),
                              let review = reviews[question.id],
                              review.packId == nil || review.packId == pack.id
                        else { continue }
                        let level = MasteryLevel.from(review: review)
                        candidates.append(
                            (question.id, level.rawValue, review.ease, seq))
                        // Last writer wins is fine — ids are unique within a
                        // pack, so this records each question exactly once.
                        resolved[question.id] = AssessmentQuestion(
                            packId: pack.id,
                            subjectTitle: pack.title,
                            chapterTitle: chapter.title,
                            question: question)
                    }
                }
            }
            guard !candidates.isEmpty else { continue }
            // Weakest first: lower mastery rank, then lower ease, then authored
            // order — a fully-deterministic total order.
            candidates.sort { a, b in
                if a.rank != b.rank { return a.rank < b.rank }
                if a.ease != b.ease { return a.ease < b.ease }
                return a.seq < b.seq
            }
            poolsByPack[pack.id] = candidates.map { $0.id }
            // Gap weight: a weaker subject earns a larger share of the quiz.
            weightByPack[pack.id] = max(0, 1.0 - subject.masteryFraction)
        }

        guard !poolsByPack.isEmpty else {
            return MilestoneAssessment(questions: [], generatedAt: now, subjectCounts: [:])
        }

        let picks = MilestoneAssessmentPlanner.compose(
            poolsByPack: poolsByPack,
            weightByPack: weightByPack,
            order: order,
            total: targetCount)

        var questions: [AssessmentQuestion] = []
        var subjectCounts: [String: Int] = [:]
        for pick in picks {
            guard let aq = resolved[pick.questionId] else { continue }
            questions.append(aq)
            subjectCounts[aq.packId, default: 0] += 1
        }

        return MilestoneAssessment(
            questions: questions, generatedAt: now, subjectCounts: subjectCounts)
    }
}
