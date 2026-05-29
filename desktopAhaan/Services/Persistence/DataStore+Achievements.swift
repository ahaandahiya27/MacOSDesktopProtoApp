import Foundation

// MARK: - Achievement persistence + snapshot
//
// Two responsibilities, both kept off `DataStore.swift` (which is at its
// grandfathered LOC ceiling) and out of the engine (which shouldn't know
// the on-disk format):
//
//   1. Load / save the unlock map (`achievements.json`). DataStore can't
//      gain a stored property in an extension, so the live `unlocks` dict
//      lives on `AchievementEngine`; these helpers just (de)serialise it
//      using the same `Self.readFile` + atomic-`save` plumbing every other
//      persisted surface uses.
//
//   2. Build an `AchievementSnapshot` from the live store + registry. This
//      is where every metric the 24 criteria read is computed once, so the
//      criteria themselves stay pure and the engine stays thin. Computed on
//      the main actor — it's a pass over a few hundred rows at this scale.
//
// Big Sur compatible: value types, no macOS 12+ APIs.

/// One persisted unlock row. Array of these is what lands in
/// `achievements.json`; the engine rebuilds its `[String: Date]` map from
/// them on load (last-write-wins on a duplicate id, logged not crashed).
struct AchievementUnlock: Codable, Hashable {
    let id: String
    let unlockedAt: Date
}

extension DataStore {

    // MARK: - Persistence

    /// Read `achievements.json` into an `id → unlockedAt` map. Returns an
    /// empty map on a fresh install. Corrupt-file rescue is handled by
    /// `readFile` (it preserves a `.corrupt.*.json` backup + flags
    /// `lastSaveError`).
    func loadAchievementUnlocks() -> [String: Date] {
        let result = Self.readFile(AchievementUnlock.self,
                                   from: "achievements.json", in: storeDir)
        if result.didRescueCorruptFile {
            lastSaveError = "Saved data couldn't be read — a backup copy was preserved next to your data. Continuing with a fresh file."
        }
        var dict: [String: Date] = [:]
        for row in result.items {
            if let existing = dict[row.id], existing >= row.unlockedAt { continue }
            dict[row.id] = row.unlockedAt
        }
        return dict
    }

    /// Persist the unlock map. Coalesced — a single kid action can unlock
    /// more than one badge at once (e.g. a streak day that also crosses a
    /// concept count), and each lands as one rewrite of the small file.
    func saveAchievementUnlocks(_ unlocks: [String: Date]) {
        let rows = unlocks.map { AchievementUnlock(id: $0.key, unlockedAt: $0.value) }
        saveCoalesced(rows, to: "achievements.json")
    }

    // MARK: - Snapshot

    /// Build the metric snapshot the 24 criteria evaluate against.
    ///
    /// `registry` is optional: streak / concept-count / discover / article /
    /// quiz metrics are derivable from `DataStore` state + id conventions
    /// alone, so passing `nil` (as the engine does before packs finish
    /// loading, and as unit tests do) still yields a useful snapshot —
    /// only the chapter/subject "fully understood" counts need the pack
    /// concept lists and read as 0 without a registry.
    func achievementSnapshot(
        registry: SubjectRegistry? = nil,
        now: Date = Date(),
        calendar: Calendar = .current
    ) -> AchievementSnapshot {
        var snap = AchievementSnapshot()
        let defaults = UserDefaults.standard

        // Streak — all-time best (a lapsed streak keeps its badge).
        let best = defaults.integer(forKey: AppStorageKeys.reviewStreakBest)
        let current = defaults.integer(forKey: AppStorageKeys.reviewStreakDays)
        snap.bestStreakDays = max(best, current)

        // Mastery — explicit "I understand this" set.
        snap.conceptsMastered = understoodConceptIds.count
        if let registry = registry {
            let packs = registry.packs.map { pack in
                PackConceptIds(chapters: pack.chapters.map { $0.allConceptIds })
            }
            let counts = Self.masteryCounts(packs: packs, understood: understoodConceptIds)
            snap.chaptersFullyMastered = counts.chapters
            snap.subjectsFullyMastered = counts.subjects
        }

        // Discover — scene completions + per-chapter completion (Science
        // scene-count table). Derived from `chapterId` ("chNN") directly so
        // no registry is needed.
        snap.discoverScenesCompleted = discoverProgress.count
        snap.discoverChaptersComplete = Self.completedDiscoverChapterCount(in: discoverProgress)

        // Articles — total read + distinct Science chapters whose
        // Beyond-the-Book article (`chNN_beyond`) is read.
        snap.articlesRead = readArticleIds.count
        snap.beyondTheBookChaptersRead = Self.beyondTheBookChapterCount(in: readArticleIds)

        // Quiz — Boss-Quiz engagement + the two "perfect" flags.
        snap.bossQuizzesPassed = Self.bossQuizChapterCount(in: questionReviews)
        snap.quickCheckPerfectDay = Self.hasQuickCheckPerfectDay(
            in: questionReviews, now: now, calendar: calendar)
        snap.dailyPracticePerfectWeek =
            defaults.integer(forKey: DailyPlanStorage.streakKey) >= 7

        return snap
    }

    // MARK: - Pure metric helpers (static, testable in isolation)

    /// Per-pack concept-id layout: one inner `[String]` per chapter. Lets
    /// `masteryCounts` be tested without standing up a `SubjectRegistry`.
    struct PackConceptIds: Hashable {
        let chapters: [[String]]
    }

    /// Count of (a) chapters whose every concept id is in `understood`,
    /// and (b) packs whose every concept id (across all chapters) is in
    /// `understood`. Chapters / packs with no concepts are skipped so an
    /// empty scope can't read as "fully mastered".
    static func masteryCounts(
        packs: [PackConceptIds], understood: Set<String>
    ) -> (chapters: Int, subjects: Int) {
        var chapterHits = 0
        var subjectHits = 0
        for pack in packs {
            var packTotal = 0
            var packUnderstood = 0
            for ids in pack.chapters {
                guard !ids.isEmpty else { continue }
                let hit = ids.filter { understood.contains($0) }.count
                if hit == ids.count { chapterHits += 1 }
                packTotal += ids.count
                packUnderstood += hit
            }
            if packTotal > 0 && packUnderstood == packTotal { subjectHits += 1 }
        }
        return (chapterHits, subjectHits)
    }

    /// Number of chapters whose completed Discover-scene count has reached
    /// that chapter's authored scene total. Only chapters whose id parses
    /// as "ch<NN>" with a known science scene-count are considered, so the
    /// Maths Discover pilot (which shares bare `chNN` ids) can't inflate
    /// the count past its own — admittedly approximate — share.
    static func completedDiscoverChapterCount(in rows: [DiscoverProgress]) -> Int {
        var perChapter: [String: Int] = [:]
        for row in rows { perChapter[row.chapterId, default: 0] += 1 }
        var complete = 0
        for (chapterId, count) in perChapter {
            guard let number = chapterNumber(fromChapterId: chapterId),
                  let expected = discoverSceneCounts[number], expected > 0 else { continue }
            if count >= expected { complete += 1 }
        }
        return complete
    }

    /// Distinct Science chapters (1…19) whose `chNN_beyond` article is read.
    static func beyondTheBookChapterCount(in readArticleIds: Set<String>) -> Int {
        var chapters: Set<Int> = []
        for n in 1...19 {
            if readArticleIds.contains(String(format: "ch%02d_beyond", n)) {
                chapters.insert(n)
            }
        }
        return chapters.count
    }

    /// Distinct chapters with at least one Boss-Quiz review on record.
    /// "Passed" here means *engaged* — the review map doesn't keep a
    /// per-attempt pass/fail history, so a recorded Boss-Quiz answer is the
    /// strongest durable signal of taking the quiz. Documented on the badge.
    static func bossQuizChapterCount(in reviews: [String: QuestionReview]) -> Int {
        var chapters: Set<Int> = []
        for id in reviews.keys where id.hasPrefix("bossquiz_ch") {
            if let n = chapterNumber(fromPrefixedId: id, prefix: "bossquiz_") {
                chapters.insert(n)
            }
        }
        return chapters.count
    }

    /// True when, on `now`'s calendar day, at least 3 scene quick-checks
    /// were reviewed and none of them are currently sitting at bucket 0
    /// (which is the state a `.forgot` answer leaves them in). An
    /// approximation of "perfect day" built from the durable review state
    /// (the map keeps only the latest state per question, not a day log).
    static func hasQuickCheckPerfectDay(
        in reviews: [String: QuestionReview], now: Date, calendar: Calendar
    ) -> Bool {
        var todays: [QuestionReview] = []
        for (id, review) in reviews where id.hasPrefix("scenecheck_ch") {
            if calendar.isDate(review.lastReviewedAt, inSameDayAs: now) {
                todays.append(review)
            }
        }
        guard todays.count >= 3 else { return false }
        return todays.allSatisfy { $0.bucket >= 1 }
    }

    /// Parse "ch<NN>" → NN. Tolerates a trailing suffix ("ch07_t01" → 7).
    static func chapterNumber(fromChapterId id: String) -> Int? {
        guard id.hasPrefix("ch") else { return nil }
        let digits = id.dropFirst(2).prefix { $0.isNumber }
        return Int(digits)
    }

    /// Parse "<prefix>ch<NN>_..." → NN (e.g. "bossquiz_ch07_q03" → 7).
    static func chapterNumber(fromPrefixedId id: String, prefix: String) -> Int? {
        guard id.hasPrefix(prefix) else { return nil }
        return chapterNumber(fromChapterId: String(id.dropFirst(prefix.count)))
    }
}
