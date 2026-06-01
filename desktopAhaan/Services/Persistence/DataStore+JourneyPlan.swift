import Foundation

// MARK: - Whole Journey plan builder (cross-subject, mastery-gap-weighted)
//
// v6 Learning Journey · Phase 3. The `@MainActor` half of the JourneyPlanner:
// gathers the DataStore-coupled candidates (due reviews, the next unmastered
// concept, the next open Discover chapter) and assembles them through the pure
// `JourneyPlanner` core so the weakest *started* subject is served first and
// reviews spread across subjects.
//
// Built ON TOP of the existing Daily Plan: it returns a plain `DailyPlan`
// (tagged `.wholeJourney`), so persistence, reconcile, auto-Done and the
// completion streak all flow through the unchanged `DataStore+DailyPlan` code.
//
// READ-ONLY over the SRS: reads `MasteryEngine.snapshot` + the immutable packs
// + the existing review/visit/Discover signals. It never mutates
// `questionReviews`, never schedules a review, never writes the SRS.
//
// Big Sur compatible: value types, no macOS 12+ APIs.

extension DataStore {

    /// Discover slots are sourced only from these packs in Whole Journey mode.
    /// Maths is deliberately excluded: `DiscoverProgress` carries no `packId`
    /// and Maths shares the bare `chNN` chapter-id space with Science, so a
    /// Maths Discover row can't be distinguished from a Science one — offering
    /// a Maths Discover item would make auto-Done reconciliation ambiguous.
    /// Maths engagement is routed through its reviews + concept slots instead.
    /// (Sanskrit `sch*` / Social Science `ssch*` ids are unique, so they're
    /// safe to credit.)
    static let journeyDiscoverPackIds: Set<String> = [
        "science_class7", "sanskrit_class7", "socialscience_class7"
    ]

    // MARK: - Build

    /// Construct a fresh cross-subject plan: up to 3 due reviews spread
    /// weak-subject-first across subjects, 1 unmastered concept from the
    /// weakest started subject (falling through the gap order), and 1 open
    /// Discover chapter from the gap order over collision-safe packs. Each
    /// section degrades gracefully — a thin profile simply yields a shorter
    /// plan rather than filler.
    func buildWholeJourneyPlan(
        registry: SubjectRegistry?,
        now: Date = Date(),
        calendar: Calendar = .current
    ) -> DailyPlan {
        hydrateConceptVisitsIfNeeded()

        // No registry → cross-subject mastery is unavailable. Reuse the
        // classic review-only path and re-stamp the mode so the stored plan
        // still matches the kid's selected mode (no rebuild churn).
        guard let registry = registry else {
            var base = buildDailyPlan(registry: nil, now: now, calendar: calendar)
            base.planMode = .wholeJourney
            return base
        }

        let snapshot = MasteryEngine.snapshot(registry: registry, dataStore: self, now: now)
        let order = JourneyPlanner.subjectFocusOrder(snapshot)
        var items: [DailyPlanItem] = []

        // 1. Reviews — weak-first round-robin across subjects (max 3). Resolve
        //    each due id once (preferring its recorded packId so a colliding
        //    bare `chNN_tNN_qNN` id lands in the subject the kid answered it
        //    in), group by pack, then let the pure core interleave them.
        let dueIds = AdaptiveDifficultyEngine.shared.prioritizedDueQuestionIds(
            dueQuestionIds(at: now), registry: registry, dataStore: self)
        var meta: [String: (packId: String, title: String, subtitle: String)] = [:]
        var dueByPack: [String: [String]] = [:]
        for qid in dueIds where meta[qid] == nil {
            let loc = registry.location(
                forQuestionId: qid, preferredPackId: questionReviews[qid]?.packId)
            let packId = loc?.pack.id ?? Self.inferredPackId(forQuestionId: qid)
            let title = loc?.question.prompt ?? "Review a question"
            let subtitle = loc.map { "\($0.pack.title) · \($0.chapter.title)" }
                ?? "Spaced-repetition review"
            meta[qid] = (packId, Self.trimmed(title), subtitle)
            dueByPack[packId, default: []].append(qid)
        }
        let picks = JourneyPlanner.roundRobinReviews(
            dueByPack: dueByPack, order: order, max: 3)
        for pick in picks {
            guard let m = meta[pick.questionId] else { continue }
            items.append(DailyPlanItem(
                kind: .review, packId: m.packId, targetId: pick.questionId,
                title: m.title, subtitle: m.subtitle))
        }

        // 2. One unmastered concept from the weakest started subject, falling
        //    through the gap order (so a day-one journey still finds the first
        //    concept of the first subject).
        for packId in order {
            if let concept = nextUnmasteredConcept(
                inPackId: packId, registry: registry, now: now, calendar: calendar) {
                items.append(concept)
                break
            }
        }

        // 3. One open Discover chapter from the gap order, over collision-safe
        //    packs only (see `journeyDiscoverPackIds`).
        for packId in order where Self.journeyDiscoverPackIds.contains(packId) {
            if let discover = nextOpenDiscoverItem(inPackId: packId, registry: registry) {
                items.append(discover)
                break
            }
        }

        return DailyPlan(
            planDay: DailyPlan.planDay(for: now, calendar: calendar),
            items: items, planMode: .wholeJourney)
    }

    // MARK: - Cross-subject candidate resolvers

    /// First concept in ONE pack (walking chapters → topics → concepts in
    /// authored order) that is neither understood nor visited within today's
    /// plan-day. Concept ids are globally unique across packs (the cross-pack
    /// id invariant), so the understood/visited checks are unambiguous.
    private func nextUnmasteredConcept(
        inPackId packId: String, registry: SubjectRegistry,
        now: Date, calendar: Calendar
    ) -> DailyPlanItem? {
        guard let pack = registry.pack(withId: packId) else { return nil }
        let planDay = DailyPlan.planDay(for: now, calendar: calendar)
        let visitedToday = Set(conceptVisitHistory.values
            .filter { DailyPlan.planDay(for: $0.visitedAt, calendar: calendar) == planDay }
            .map { $0.conceptId })
        for chapter in pack.chapters {
            for topic in chapter.topics {
                for concept in topic.concepts {
                    if understoodConceptIds.contains(concept.id) { continue }
                    if visitedToday.contains(concept.id) { continue }
                    return DailyPlanItem(
                        kind: .concept, packId: pack.id, targetId: concept.id,
                        title: Self.trimmed(concept.title),
                        subtitle: "\(pack.title) · \(chapter.title)")
                }
            }
        }
        return nil
    }

    /// First Discover-host chapter in ONE pack whose completed-scene count is
    /// below its authored total, with a baseline so reconcile can detect a
    /// freshly-finished scene. Science's per-chapter scene count varies
    /// (`discoverSceneCounts`); the generic Sanskrit / Social Science views
    /// each ship `DiscoverMode.scenesPerChapter`.
    private func nextOpenDiscoverItem(
        inPackId packId: String, registry: SubjectRegistry
    ) -> DailyPlanItem? {
        guard let pack = registry.pack(withId: packId) else { return nil }
        let completedByChapter = Self.discoverCompletedByChapter(in: discoverProgress)
        for chapter in pack.chapters {
            guard DiscoverMode.hasExperience(for: pack, chapter: chapter) else { continue }
            let expected = (pack.id == "science_class7")
                ? (Self.discoverSceneCounts[chapter.number] ?? DiscoverMode.scenesPerChapter)
                : DiscoverMode.scenesPerChapter
            guard expected > 0 else { continue }
            let done = completedByChapter[chapter.id] ?? 0
            if done < expected {
                return DailyPlanItem(
                    kind: .discover, packId: pack.id, targetId: chapter.id,
                    title: "Discover: \(Self.trimmed(chapter.title))",
                    subtitle: "\(done) of \(expected) scenes done",
                    discoverBaselineScenes: done)
            }
        }
        return nil
    }
}
