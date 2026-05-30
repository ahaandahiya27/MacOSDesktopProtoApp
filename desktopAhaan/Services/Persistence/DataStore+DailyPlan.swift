import Foundation

// MARK: - Daily Plan rollup + persistence
//
// Builds and persists the adaptive "today's 5 things" plan, reconciles its
// auto-Done state against live DataStore signals, and credits the
// plan-completion streak. Kept off `DataStore.swift` (at its LOC ceiling)
// and out of the views.
//
// The plan file (`dailyplan.json`) stores the current plan as a
// single-element array (so the shared `readFile`/`saveCoalesced` array
// plumbing applies unchanged). The plan-completion streak lives in
// `UserDefaults` under `DailyPlanStorage` so `AchievementEngine` can read it
// cheaply.
//
// Big Sur compatible: value types, no macOS 12+ APIs.

extension DataStore {

    // MARK: - Persistence

    /// Read the persisted plan, or nil on a fresh install / corrupt file.
    func loadDailyPlan() -> DailyPlan? {
        let result = Self.readFile(DailyPlan.self, from: "dailyplan.json", in: storeDir)
        if result.didRescueCorruptFile {
            lastSaveError = "Saved data couldn't be read — a backup copy was preserved next to your data. Continuing with a fresh file."
        }
        return result.items.first
    }

    /// Persist the plan (coalesced — Skip/Done taps come in bursts).
    func saveDailyPlan(_ plan: DailyPlan) {
        saveCoalesced([plan], to: "dailyplan.json")
    }

    // MARK: - Entry point

    /// The plan to show now. Loads the persisted plan if it still covers
    /// `now` (reconciling its auto-Done state against live signals and
    /// crediting the streak if it just completed); otherwise builds a fresh
    /// plan for today, persists it, and returns it.
    @discardableResult
    func currentDailyPlan(
        registry: SubjectRegistry?,
        now: Date = Date(),
        calendar: Calendar = .current
    ) -> DailyPlan {
        if let stored = loadDailyPlan(), stored.covers(now, calendar: calendar) {
            let reconciled = reconcileDailyPlan(stored, now: now, calendar: calendar)
            if reconciled != stored { saveDailyPlan(reconciled) }
            creditDailyPlanStreakIfComplete(reconciled, calendar: calendar)
            return reconciled
        }
        let fresh = buildDailyPlan(registry: registry, now: now, calendar: calendar)
        saveDailyPlan(fresh)
        return fresh
    }

    // MARK: - Build

    /// Construct a fresh plan: up to 3 due reviews, 1 unmastered concept, 1
    /// Discover scene. Each section degrades gracefully — a kid with no due
    /// reviews simply gets a shorter plan rather than a crash or filler.
    func buildDailyPlan(
        registry: SubjectRegistry?,
        now: Date = Date(),
        calendar: Calendar = .current
    ) -> DailyPlan {
        hydrateConceptVisitsIfNeeded()
        var items: [DailyPlanItem] = []

        // 1. Up to 3 SRS reviews due now. `dueQuestionIds` sorts oldest-due
        //    first; the AdaptiveDifficultyEngine then re-orders the due set so
        //    band-appropriate questions surface first (a hot streak in a
        //    chapter promotes its harder due question). This is a READ-ONLY
        //    adapter — the SRS scheduler is untouched. With no registry, or
        //    when the engine is disabled, the raw due order is preserved.
        let dueIds: [String]
        if let registry = registry {
            dueIds = AdaptiveDifficultyEngine.shared.prioritizedDueQuestionIds(
                dueQuestionIds(at: now), registry: registry, dataStore: self)
        } else {
            dueIds = dueQuestionIds(at: now)
        }
        for qid in dueIds.prefix(3) {
            let loc = registry?.location(forQuestionId: qid, preferredPackId: nil)
            let packId = loc?.pack.id ?? Self.inferredPackId(forQuestionId: qid)
            let title = loc?.question.prompt ?? "Review a question"
            let subtitle = loc.map { "\($0.pack.title) · \($0.chapter.title)" }
                ?? "Spaced-repetition review"
            items.append(DailyPlanItem(
                kind: .review, packId: packId, targetId: qid,
                title: Self.trimmed(title), subtitle: subtitle))
        }

        // 2. One unmastered concept the kid hasn't opened today.
        if let concept = nextUnmasteredConcept(registry: registry, now: now, calendar: calendar) {
            items.append(concept)
        }

        // 3. One Discover scene from a chapter with open scenes.
        if let discover = nextOpenDiscoverItem(registry: registry) {
            items.append(discover)
        }

        return DailyPlan(planDay: DailyPlan.planDay(for: now, calendar: calendar), items: items)
    }

    /// First concept (walking packs → chapters → topics in authored order)
    /// that is neither marked understood nor visited within today's plan-day.
    private func nextUnmasteredConcept(
        registry: SubjectRegistry?, now: Date, calendar: Calendar
    ) -> DailyPlanItem? {
        guard let registry = registry else { return nil }
        let planDay = DailyPlan.planDay(for: now, calendar: calendar)
        let visitedToday = Set(conceptVisitHistory.values
            .filter { DailyPlan.planDay(for: $0.visitedAt, calendar: calendar) == planDay }
            .map { $0.conceptId })
        for pack in registry.packs {
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
        }
        return nil
    }

    /// First Discover-host chapter (Science) whose completed-scene count is
    /// below its authored total, captured with a baseline so reconciliation
    /// can detect a freshly-finished scene.
    private func nextOpenDiscoverItem(registry: SubjectRegistry?) -> DailyPlanItem? {
        guard let pack = registry?.pack(withId: DiscoverMode.hostPackId) else { return nil }
        let completedByChapter = Self.discoverCompletedByChapter(in: discoverProgress)
        for chapter in pack.chapters {
            guard let expected = Self.discoverSceneCounts[chapter.number], expected > 0 else { continue }
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

    // MARK: - Reconcile (auto-Done)

    /// Mark items the kid has since completed through normal use:
    ///   • review  → its question was reviewed within today's plan-day
    ///   • concept → it's now understood, or was opened today
    ///   • discover → its chapter finished a new scene since plan build
    /// Already-Done / already-Skipped items are left untouched.
    func reconcileDailyPlan(
        _ plan: DailyPlan, now: Date = Date(), calendar: Calendar = .current
    ) -> DailyPlan {
        hydrateConceptVisitsIfNeeded()
        let planDay = DailyPlan.planDay(for: now, calendar: calendar)
        let reviewedToday = Set(questionReviews.values
            .filter { DailyPlan.planDay(for: $0.lastReviewedAt, calendar: calendar) == planDay }
            .map { $0.questionId })
        let visitedToday = Set(conceptVisitHistory.values
            .filter { DailyPlan.planDay(for: $0.visitedAt, calendar: calendar) == planDay }
            .map { $0.conceptId })
        let completedByChapter = Self.discoverCompletedByChapter(in: discoverProgress)

        return Self.reconciled(
            plan: plan,
            understood: understoodConceptIds,
            reviewedTodayQuestionIds: reviewedToday,
            visitedTodayConceptIds: visitedToday,
            discoverScenesByChapter: completedByChapter)
    }

    // MARK: - Mutations

    /// Mark one item Done (kid tapped ✓ or completed it). Persists + credits.
    func markDailyPlanItemDone(_ itemId: String, registry: SubjectRegistry?, now: Date = Date()) {
        mutateDailyPlan(itemId, registry: registry, now: now) { $0.isDone = true; $0.isSkipped = false }
    }

    /// Skip one item — removes it from the kid's attention without crediting.
    func skipDailyPlanItem(_ itemId: String, registry: SubjectRegistry?, now: Date = Date()) {
        mutateDailyPlan(itemId, registry: registry, now: now) { $0.isSkipped = true; $0.isDone = false }
    }

    private func mutateDailyPlan(
        _ itemId: String, registry: SubjectRegistry?, now: Date,
        _ change: (inout DailyPlanItem) -> Void
    ) {
        var plan = currentDailyPlan(registry: registry, now: now)
        guard let idx = plan.items.firstIndex(where: { $0.id == itemId }) else { return }
        change(&plan.items[idx])
        saveDailyPlan(plan)
        creditDailyPlanStreakIfComplete(plan)
    }

    // MARK: - Streak crediting

    /// If the plan is complete, credit today's plan-day to the streak (once).
    /// Consecutive plan-days bump the streak; a gap resets it to 1.
    func creditDailyPlanStreakIfComplete(_ plan: DailyPlan, calendar: Calendar = .current) {
        guard plan.isComplete else { return }
        let defaults = UserDefaults.standard
        let todayKey = Self.dayKey(plan.planDay, calendar: calendar)
        if defaults.string(forKey: DailyPlanStorage.streakLastDayKey) == todayKey { return }

        let yesterday = calendar.date(byAdding: .day, value: -1, to: plan.planDay)
            .map { Self.dayKey($0, calendar: calendar) }
        let lastDay = defaults.string(forKey: DailyPlanStorage.streakLastDayKey)
        let prior = defaults.integer(forKey: DailyPlanStorage.streakKey)
        let next = (lastDay != nil && lastDay == yesterday) ? prior + 1 : 1

        defaults.set(next, forKey: DailyPlanStorage.streakKey)
        defaults.set(todayKey, forKey: DailyPlanStorage.streakLastDayKey)
        let best = defaults.integer(forKey: DailyPlanStorage.streakBestKey)
        if next > best { defaults.set(next, forKey: DailyPlanStorage.streakBestKey) }
    }

    /// Current plan-completion streak (consecutive completed plan-days).
    var dailyPlanStreak: Int {
        UserDefaults.standard.integer(forKey: DailyPlanStorage.streakKey)
    }

    // MARK: - Pure helpers (static, testable in isolation)

    /// Reconcile a plan against frozen signals. Pure — no FS, no DataStore.
    static func reconciled(
        plan: DailyPlan,
        understood: Set<String>,
        reviewedTodayQuestionIds: Set<String>,
        visitedTodayConceptIds: Set<String>,
        discoverScenesByChapter: [String: Int]
    ) -> DailyPlan {
        var next = plan
        for i in next.items.indices {
            guard next.items[i].isActionable else { continue }
            let item = next.items[i]
            switch item.kind {
            case .review:
                if reviewedTodayQuestionIds.contains(item.targetId) { next.items[i].isDone = true }
            case .concept:
                if understood.contains(item.targetId)
                    || visitedTodayConceptIds.contains(item.targetId) {
                    next.items[i].isDone = true
                }
            case .discover:
                let nowScenes = discoverScenesByChapter[item.targetId] ?? 0
                if nowScenes > (item.discoverBaselineScenes ?? 0) { next.items[i].isDone = true }
            }
        }
        return next
    }

    /// completed Discover scenes per chapterId.
    static func discoverCompletedByChapter(in rows: [DiscoverProgress]) -> [String: Int] {
        var byChapter: [String: Int] = [:]
        for row in rows { byChapter[row.chapterId, default: 0] += 1 }
        return byChapter
    }

    /// Stable yyyy-MM-dd-ish key for a plan-day Date (uses calendar
    /// components, not a locale-dependent DateFormatter, so it's stable
    /// across regions + test machines).
    static func dayKey(_ date: Date, calendar: Calendar = .current) -> String {
        let c = calendar.dateComponents([.year, .month, .day], from: date)
        return String(format: "%04d-%02d-%02d", c.year ?? 0, c.month ?? 0, c.day ?? 0)
    }

    /// Best-effort pack id from a question id when the registry hasn't
    /// resolved a location (e.g. an ephemeral boss/scene id). Mirrors the
    /// pack-prefix convention (Science `ch*`, Maths `mch*`, Sanskrit `sch*`).
    static func inferredPackId(forQuestionId id: String) -> String {
        if id.contains("mch") || id.hasPrefix("mch") { return "maths_class7" }
        if id.contains("sch") || id.hasPrefix("sch") { return "sanskrit_class7" }
        return "science_class7"
    }

    /// Trim a long prompt/title to a single tidy line for a plan row.
    static func trimmed(_ s: String, max: Int = 90) -> String {
        let flat = s.replacingOccurrences(of: "\n", with: " ")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        if flat.count <= max { return flat }
        return String(flat.prefix(max - 1)).trimmingCharacters(in: .whitespaces) + "…"
    }
}
