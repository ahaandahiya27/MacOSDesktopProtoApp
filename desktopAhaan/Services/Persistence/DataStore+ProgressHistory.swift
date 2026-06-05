import Foundation

// MARK: - Longitudinal progress-history persistence (v8 · lazy-hydrated)
//
// v8 Longitudinal Insights · Phase 1. Persists a compact daily time series
// (`progress_history.json`) derived READ-ONLY from `MasteryEngine.snapshot(...)`.
// This is the missing foundation for week-over-week deltas, the trend chart and
// the Insights window — everything the parent saw before was a single-week
// snapshot with no history.
//
// Design, mirroring the `conceptVisits.json` idiom in
// `DataStore+WeeklyActivity.swift`:
//
//  • Lazy hydrate: `progressHistory` is read from disk at most once per process
//    on first access/write, so a kid who never opens an Insights/dashboard
//    surface never pays the (tiny) read.
//
//  • One row per calendar day, keyed by start-of-day. Re-capturing the same
//    day OVERWRITES that day's row (idempotent) so the row always reflects the
//    latest standing for today — never a duplicate, never an append.
//
//  • Rolling cap: at most `maxHistoryDays` days are retained; the oldest are
//    dropped on capture. 180 days keeps a half-year trend in a file that stays
//    a few KB.
//
//  • READ-ONLY over the SRS. Capture reads `questionReviews` (via the
//    `MasteryEngine` snapshot) and the immutable packs; it writes ONLY
//    `progress_history.json`. It never mutates / schedules / writes a
//    `QuestionReview`. Pinned by `ProgressHistoryReadOnlyTests`.
//
//  • Capture is cheap (one O(R + Σ pack questions) pass) and triggered only off
//    hot paths — at app launch and when an Insights/dashboard surface opens —
//    never per-review, never blocking a render.

extension DataStore {

    /// Rolling retention window for `progress_history.json` (days).
    static let maxProgressHistoryDays = 180

    // MARK: - Lazy hydrate

    /// Read `progress_history.json` into `progressHistory` at most once per
    /// process. Safe to call repeatedly. Main-actor; the file is a few KB.
    func hydrateProgressHistoryIfNeeded() {
        guard !didHydrateProgressHistory else { return }
        didHydrateProgressHistory = true
        let result = Self.readFile(ProgressSnapshot.self,
                                   from: "progress_history.json", in: storeDir)
        if result.didRescueCorruptFile {
            lastSaveError = "Saved data couldn't be read — a backup copy was preserved next to your data. Continuing with a fresh file."
        }
        // Latest-per-day wins if the file somehow carries two rows for one day.
        // `result.items` reflects file insertion order (we append on every
        // capture), so the LAST row for a given date is the most recent one.
        // The 2026-06-05 audit caught a stale guard here that compared
        // `existing.date >= snap.date` — since the dict key IS `snap.date`,
        // both sides were identical and the FIRST row read always won (the
        // opposite of the intended behaviour). Replaced with explicit
        // last-wins coalescer; `Dictionary(_:uniquingKeysWith:)` is the safe
        // form (no dup-key trap; the comment in ConceptMapView documents the
        // same convention).
        progressHistory = Dictionary(
            result.items.map { ($0.date, $0) },
            uniquingKeysWith: { _, new in new }
        )
    }

    // MARK: - Capture (READ-ONLY over SRS)

    /// Capture (or refresh) today's progress snapshot from the live registry +
    /// SRS, then persist. Idempotent per calendar day: re-capturing today
    /// overwrites today's row. Caps history to `maxProgressHistoryDays`.
    ///
    /// READ-ONLY over the SRS — derives from `MasteryEngine.snapshot(...)` and
    /// writes only `progress_history.json`.
    ///
    /// Returns `nil` (a no-op) when the registry hasn't loaded its packs yet —
    /// so this is safe to fire from the app-launch hook before the off-thread
    /// pack decode finishes; a snapshot with zero subjects would otherwise
    /// pollute the history with a meaningless row.
    @discardableResult
    @MainActor
    func captureProgressSnapshot(registry: SubjectRegistry,
                                 now: Date = Date(),
                                 calendar: Calendar = .current) -> ProgressSnapshot? {
        guard !registry.packs.isEmpty else { return nil }
        hydrateProgressHistoryIfNeeded()

        let overall = MasteryEngine.snapshot(registry: registry, dataStore: self, now: now)
        let dayStart = calendar.startOfDay(for: now)
        let points = overall.subjects.map { subject in
            SubjectProgressPoint(
                packId: subject.packId,
                masteryFraction: subject.masteryFraction,
                coverageFraction: subject.coverageFraction,
                reviewedQuestions: subject.reviewedQuestions,
                dueCount: subject.dueCount
            )
        }
        let snapshot = ProgressSnapshot(
            date: dayStart,
            subjects: points,
            overallMasteryFraction: overall.overallMasteryFraction,
            overallCoverageFraction: overall.overallCoverageFraction
        )

        progressHistory[dayStart] = snapshot

        // Rolling cap: keep only the most-recent `maxProgressHistoryDays` days.
        if progressHistory.count > Self.maxProgressHistoryDays {
            let keepDates = progressHistory.keys
                .sorted(by: >)
                .prefix(Self.maxProgressHistoryDays)
            let keepSet = Set(keepDates)
            progressHistory = progressHistory.filter { keepSet.contains($0.key) }
        }

        saveCoalesced(Array(progressHistory.values), to: "progress_history.json")
        return snapshot
    }

    // MARK: - Read accessors (pure helpers wrapped for the live store)

    /// The full history, oldest → newest. Hydrates on first call.
    func progressHistorySorted() -> [ProgressSnapshot] {
        hydrateProgressHistoryIfNeeded()
        return progressHistory.values.sorted { $0.date < $1.date }
    }

    /// Mastery/coverage series for one subject, oldest → newest.
    func progressSeries(forPackId packId: String) -> [ProgressSeriesPoint] {
        ProgressHistory.series(progressHistorySorted(), forPackId: packId)
    }

    /// Overall mastery/coverage series, oldest → newest.
    func overallProgressSeries() -> [ProgressSeriesPoint] {
        ProgressHistory.overallSeries(progressHistorySorted())
    }

    /// Week-over-week delta (latest vs ≈7 days ago), or nil if not enough data.
    func progressWeekOverWeek(now: Date = Date(),
                              calendar: Calendar = .current) -> ProgressDelta? {
        ProgressHistory.weekOverWeek(progressHistorySorted(), now: now, calendar: calendar)
    }
}
