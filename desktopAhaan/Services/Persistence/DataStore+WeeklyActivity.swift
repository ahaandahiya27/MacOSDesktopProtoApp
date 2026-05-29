import Foundation

// MARK: - Weekly Progress rollup + concept-visit persistence
//
// Aggregates the data already captured by other surfaces — SM-2
// question reviews, concept visits, discover-scene completions, mastery
// levels, and the streak counters — into the 7-day `WeeklyActivity`
// rollup the Parent Dashboard renders. All work happens on the calling
// (main) thread; it's a cheap pass over a few hundred rows at the
// typical single-kid scale.
//
// Two design notes worth knowing before changing this file:
//
//  • Concept visits persist here (not in the cold-launch loader): the
//    in-memory `conceptVisitHistory` is hydrated lazily from
//    `conceptVisits.json` on first access, so opening a concept or the
//    dashboard pays the (tiny) read once, and a kid who never touches
//    either never pays it at all.
//
//  • Discover-scene completions are attributed to the host pack
//    (`DiscoverMode.hostPackId` = science). `DiscoverProgress` only
//    stores `chapterId`, and Science + the Maths Discover pilot share
//    bare chapter ids (`ch01`…), so we can't split them without adding
//    a `packId` to the discover schema (deliberately out of scope this
//    run; see POLISH_TODOS). The day/week discover totals are exact;
//    only the per-subject split folds Maths-pilot scenes under Science.

/// Pack id bucket for reviews written before `QuestionReview.packId`
/// existed (legacy rows decode it as nil). Kept distinct so the totals
/// stay honest; the dashboard only renders pills for resolvable packs.
private let kUnattributedPackId = "unattributed"

extension DataStore {

    // MARK: - Concept-visit persistence (lazy-hydrated)

    /// Read `conceptVisits.json` into `conceptVisitHistory` at most once
    /// per process. Safe to call repeatedly. Runs on the main actor —
    /// the file is kilobytes at this scale.
    func hydrateConceptVisitsIfNeeded() {
        guard !didHydrateConceptVisits else { return }
        didHydrateConceptVisits = true
        let result = Self.readFile(ConceptVisit.self, from: "conceptVisits.json", in: storeDir)
        if result.didRescueCorruptFile {
            lastSaveError = "Saved data couldn't be read — a backup copy was preserved next to your data. Continuing with a fresh file."
        }
        // Last-visit-wins if the file somehow carries duplicate concept ids.
        var dict: [String: ConceptVisit] = [:]
        for visit in result.items {
            if let existing = dict[visit.conceptId], existing.visitedAt >= visit.visitedAt {
                continue
            }
            dict[visit.conceptId] = visit
        }
        conceptVisitHistory = dict
    }

    /// Record (or refresh) the last-visit timestamp for a concept.
    /// Called from `ConceptDetailView.onAppear`. Coalesced-write so
    /// flipping quickly through sibling concepts lands as one disk write.
    func recordConceptVisit(id conceptId: String, packId: String, at date: Date = Date()) {
        hydrateConceptVisitsIfNeeded()
        conceptVisitHistory[conceptId] = ConceptVisit(
            conceptId: conceptId, packId: packId, visitedAt: date
        )
        saveCoalesced(Array(conceptVisitHistory.values), to: "conceptVisits.json")
    }

    // MARK: - Weekly rollup

    /// Build a 7-day rollup ending at `endDate` (default: now). The
    /// window is the trailing 7 calendar days: `days[0]` is the
    /// start-of-day six days before `endDate`'s start-of-day, `days[6]`
    /// is `endDate`'s start-of-day. An event is in-window when its
    /// timestamp is `>= days[0]` start-of-day AND `<= endDate` (so an
    /// event at exactly `endDate` counts; one a moment later does not).
    ///
    /// `chapterLocator` (optional) resolves an id (question or concept)
    /// + its pack to a chapter id, for the per-subject "top chapter"
    /// hint. The view passes a `SubjectRegistry`-backed closure; tests
    /// omit it (top chapter then comes only from discover rows, which
    /// carry `chapterId` directly).
    func weeklyActivity(
        endingAt endDate: Date = Date(),
        calendar: Calendar = .current,
        chapterLocator: ((_ id: String, _ packId: String?) -> String?)? = nil
    ) -> WeeklyActivity {
        hydrateConceptVisitsIfNeeded()

        // 1. Seven start-of-day boundaries, oldest → newest.
        let endStart = calendar.startOfDay(for: endDate)
        var dayStarts: [Date] = []
        for offset in stride(from: 6, through: 0, by: -1) {
            if let day = calendar.date(byAdding: .day, value: -offset, to: endStart) {
                dayStarts.append(day)
            }
        }
        // Defensive: a pathological calendar could under-fill; pad so
        // `days` is always exactly 7 and indexing below is safe.
        while dayStarts.count < 7, let first = dayStarts.first {
            dayStarts.insert(first, at: 0)
        }
        let windowStart = dayStarts.first ?? endStart
        let windowEnd = endDate

        // Map a timestamp to its day index in `dayStarts`, or nil if it
        // falls outside the inclusive window.
        func dayIndex(for date: Date) -> Int? {
            guard date >= windowStart, date <= windowEnd else { return nil }
            let dayStart = calendar.startOfDay(for: date)
            return dayStarts.firstIndex(of: dayStart)
        }

        // 2. Per-day, per-pack accumulator.
        struct Acc {
            var reviews = 0
            var concepts = 0
            var discover = 0
            var chapterTally: [String: Int] = [:]
        }
        var perDay: [[String: Acc]] = Array(repeating: [:], count: 7)

        // Reviews — grouped by last-reviewed day and owning pack.
        for (questionId, review) in questionReviews {
            guard let dayIdx = dayIndex(for: review.lastReviewedAt) else { continue }
            let packId = review.packId ?? kUnattributedPackId
            var acc = perDay[dayIdx][packId] ?? Acc()
            acc.reviews += 1
            if let chapterId = chapterLocator?(questionId, review.packId) {
                acc.chapterTally[chapterId, default: 0] += 1
            }
            perDay[dayIdx][packId] = acc
        }

        // Concept visits — `conceptVisitHistory` is already last-visit-
        // per-concept, so each counts once toward the day it was last seen.
        for (_, visit) in conceptVisitHistory {
            guard let dayIdx = dayIndex(for: visit.visitedAt) else { continue }
            var acc = perDay[dayIdx][visit.packId] ?? Acc()
            acc.concepts += 1
            if let chapterId = chapterLocator?(visit.conceptId, visit.packId) {
                acc.chapterTally[chapterId, default: 0] += 1
            }
            perDay[dayIdx][visit.packId] = acc
        }

        // Discover scenes — attributed to the host pack (see file header).
        for row in discoverProgress {
            guard let dayIdx = dayIndex(for: row.completedAt) else { continue }
            let packId = DiscoverMode.hostPackId
            var acc = perDay[dayIdx][packId] ?? Acc()
            acc.discover += 1
            acc.chapterTally[row.chapterId, default: 0] += 1
            perDay[dayIdx][packId] = acc
        }

        // 3. Materialise DayActivity rows.
        var days: [DayActivity] = []
        for index in 0..<7 {
            var subjects: [String: SubjectActivity] = [:]
            var rawMinutes = 0.0
            for (packId, acc) in perDay[index] {
                let topChapter = acc.chapterTally.max { lhs, rhs in
                    // Tie-break on chapter id so the result is stable
                    // (dictionary iteration order isn't).
                    lhs.value != rhs.value ? lhs.value < rhs.value : lhs.key > rhs.key
                }?.key
                subjects[packId] = SubjectActivity(
                    packId: packId,
                    reviews: acc.reviews,
                    conceptsVisited: acc.concepts,
                    discoverScenesCompleted: acc.discover,
                    topChapter: topChapter
                )
                rawMinutes += Double(acc.reviews) * 0.5
                    + Double(acc.concepts) * 2.0
                    + Double(acc.discover) * 3.0
            }
            days.append(DayActivity(
                date: dayStarts[index],
                perSubject: subjects,
                totalMinutesEstimate: Int(rawMinutes.rounded())
            ))
        }

        // 4. Week totals (sum across the 7 day rows).
        let totalReviews = days.reduce(0) { $0 + $1.totalReviews }
        let totalConcepts = days.reduce(0) { $0 + $1.totalConcepts }
        let totalDiscover = days.reduce(0) { $0 + $1.totalDiscoverScenes }

        // 5. Mastery delta — questions whose last review landed in the
        //    window, bucketed by current level. ".learning" is excluded
        //    (it isn't a gain to celebrate). See `MasteryDelta` doc for
        //    the precise semantics this approximates.
        var familiar = 0, confident = 0, mastered = 0
        for (_, review) in questionReviews {
            guard dayIndex(for: review.lastReviewedAt) != nil else { continue }
            switch MasteryLevel.from(review: review) {
            case .familiar:  familiar += 1
            case .confident: confident += 1
            case .mastered:  mastered += 1
            case .learning:  break
            }
        }
        let delta = MasteryDelta(
            newFamiliar: familiar, newConfident: confident, newMastered: mastered
        )

        // 6. Streak — read straight from the @AppStorage-backed defaults.
        let defaults = UserDefaults.standard
        let streakDays = defaults.integer(forKey: AppStorageKeys.reviewStreakDays)
        let streakBest = defaults.integer(forKey: AppStorageKeys.reviewStreakBest)

        return WeeklyActivity(
            weekStart: windowStart,
            days: days,
            totalReviews: totalReviews,
            totalConcepts: totalConcepts,
            totalDiscoverScenes: totalDiscover,
            masteryDelta: delta,
            streakDays: streakDays,
            streakBest: max(streakBest, streakDays)
        )
    }
}
