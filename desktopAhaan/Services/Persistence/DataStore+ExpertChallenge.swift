import Foundation

// MARK: - Expert Challenge Ladder builder
//
// v6 Learning Journey · Phase 5. The `@MainActor` half of the
// ExpertChallengePlanner: gathers each subject's expert-grade, single-tap-
// gradable MCQs from the live packs and classifies them into tiers, then hands
// the per-tier groups + the subject's mastery fraction to the pure planner.
//
// Two question sources, both READ-ONLY over the immutable packs:
//   • the hardest topic questions — intrinsic `DifficultyBand` `.stretch`
//     (difficulty 4) → Stretch tier, `.challenge` (difficulty 5) → Challenge
//     tier; and
//   • the authored beyond-grade `deepDive` bonus questions → Olympiad tier.
// Only `isAssessableMCQ` questions qualify (scored by a single tap, like the
// Milestone Checkpoint). Each tier is capped + ordered deterministically.
//
// READ-ONLY over the SRS: reads `MasteryEngine.snapshot` + the immutable packs
// only — no mutation, no scheduling, no disk write.
//
// Big Sur compatible: value types, no macOS 12+ APIs.

extension DataStore {

    /// Max questions kept per tier — enough for a meaty challenge run without an
    /// unwieldy list; ordered hardest-first then by id so the cap is stable.
    static let expertChallengeTierCap = 25

    /// Build the cross-subject Expert Challenge Ladder. For every registry
    /// subject it collects expert MCQs, classifies them into tiers, and marks
    /// each tier unlocked per the subject's mastery fraction. READ-ONLY.
    func buildExpertChallengeLadder(
        registry: SubjectRegistry?,
        now: Date = Date()
    ) -> ExpertChallengeLadder {
        guard let registry = registry else {
            return ExpertChallengeLadder(subjects: [])
        }
        let snapshot = MasteryEngine.snapshot(registry: registry, dataStore: self, now: now)
        let masteryByPack = Dictionary(
            snapshot.subjects.map { ($0.packId, $0) }, uniquingKeysWith: { a, _ in a })

        let subjects: [SubjectChallengeLadder] = registry.packs.map { pack in
            // Collect expert questions tagged by tier, deduped by question id.
            var byTier: [ExpertTier: [(q: AssessmentQuestion, difficulty: Int)]] = [:]
            var seen = Set<String>()

            for chapter in pack.chapters {
                for question in chapter.topics.flatMap({ $0.questions }) {
                    guard !seen.contains(question.id),
                          let entry = expertEntry(question, in: pack,
                                                  chapterTitle: chapter.title,
                                                  isDeepDive: false) else { continue }
                    seen.insert(question.id)
                    byTier[entry.tier, default: []].append((entry.aq, question.difficulty))
                }
                for question in chapter.deepDiveList.flatMap({ $0.bonusQuestions ?? [] }) {
                    guard !seen.contains(question.id),
                          let entry = expertEntry(question, in: pack,
                                                  chapterTitle: chapter.title,
                                                  isDeepDive: true) else { continue }
                    seen.insert(question.id)
                    byTier[entry.tier, default: []].append((entry.aq, question.difficulty))
                }
            }

            // Order each tier hardest-first (then by id for stability) and cap.
            var questionsByTier: [ExpertTier: [AssessmentQuestion]] = [:]
            for (tier, items) in byTier {
                let ordered = items.sorted { a, b in
                    if a.difficulty != b.difficulty { return a.difficulty > b.difficulty }
                    return a.q.id < b.q.id
                }
                questionsByTier[tier] = Array(
                    ordered.prefix(Self.expertChallengeTierCap)).map { $0.q }
            }

            let subjectSnapshot = masteryByPack[pack.id]
            let tiers = ExpertChallengePlanner.tierSets(
                questionsByTier: questionsByTier,
                masteryFraction: subjectSnapshot?.masteryFraction ?? 0)

            return SubjectChallengeLadder(
                packId: pack.id,
                subjectTitle: pack.title,
                masteryFraction: subjectSnapshot?.masteryFraction ?? 0,
                hasStarted: subjectSnapshot?.hasStarted ?? false,
                tiers: tiers)
        }

        return ExpertChallengeLadder(subjects: subjects)
    }

    /// Classify one candidate into a tier + wrap it as an `AssessmentQuestion`,
    /// or `nil` if it isn't an expert-grade gradable MCQ. A method (not a nested
    /// function) so it stays `@MainActor`-isolated and can call the main-actor
    /// `isAssessableMCQ` under Swift 5.5.
    private func expertEntry(
        _ question: Question, in pack: SubjectPack,
        chapterTitle: String, isDeepDive: Bool
    ) -> (tier: ExpertTier, aq: AssessmentQuestion)? {
        guard Self.isAssessableMCQ(question),
              let tier = ExpertTier.classify(
                band: question.intrinsicBand, isDeepDive: isDeepDive)
        else { return nil }
        let aq = AssessmentQuestion(
            packId: pack.id, subjectTitle: pack.title,
            chapterTitle: chapterTitle, question: question)
        return (tier, aq)
    }
}
