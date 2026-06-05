import Foundation

// MARK: - ProgressSnapshot — the longitudinal history row (v8)
//
// v8 Longitudinal Insights · Phase 1. One immutable snapshot per CALENDAR
// DAY of where the learning journey stood, derived READ-ONLY from
// `MasteryEngine.snapshot(...)`. The history of these rows
// (`progress_history.json`) is the foundation the trend chart, the
// week-over-week delta and the Insights window all read.
//
// Strict invariant: a `ProgressSnapshot` is a *projection* of the SRS, never
// a source of truth for it. Capturing one reads `questionReviews` + the
// immutable packs and writes ONLY `progress_history.json`; it never mutates,
// schedules, or writes a `QuestionReview`. See `DataStore+ProgressHistory.swift`
// for the capture path and `ProgressHistoryReadOnlyTests` for the pin.
//
// The pure analysis helpers (`ProgressHistory.delta/series/weekOverWeek`) live
// here so they're unit-testable with fabricated rows and no `@MainActor`, no
// live registry, no DataStore — same split as `MasteryEngine`'s pure layer.

/// One subject's standing on a given day. Mirrors the four fields the
/// dashboard cares about from `SubjectMasterySnapshot`, frozen as plain
/// `Codable` values so the history file never depends on the live registry.
///
/// **Schema-evolution invariant** (2026-06-05 audit): every NEW field added
/// here MUST be Optional (or carry a `= defaultValue` default), so a
/// year-old `progress_history.json` written before the field's introduction
/// still decodes. The whole file goes through `DataStore.readFile`, which
/// quarantines on any decode error and surfaces a non-fatal banner — but
/// the kid still loses their trend chart for that session. Optionality is
/// the cheaper fix.
struct SubjectProgressPoint: Codable, Hashable {
    let packId: String
    let masteryFraction: Double
    let coverageFraction: Double
    let reviewedQuestions: Int
    let dueCount: Int
}

/// The whole journey on one calendar day. `date` is a start-of-day boundary
/// (day-granular) so re-capturing the same day is idempotent. Identified by
/// that day boundary.
///
/// **Schema-evolution invariant** (2026-06-05 audit): same as
/// `SubjectProgressPoint` — any new field MUST be Optional or default-
/// valued, so older on-disk history files keep decoding cleanly.
struct ProgressSnapshot: Codable, Hashable, Identifiable {
    /// Start-of-day boundary this row represents.
    let date: Date
    /// Per-subject standing, in the registry's presentation order at capture.
    let subjects: [SubjectProgressPoint]
    /// Reviewed-weighted overall mastery, 0…1 (mirrors `OverallMasterySnapshot`).
    let overallMasteryFraction: Double
    /// Overall coverage, 0…1.
    let overallCoverageFraction: Double

    var id: Date { date }

    /// The point for one subject on this day, or nil if the subject didn't
    /// exist / wasn't captured that day.
    func point(forPackId packId: String) -> SubjectProgressPoint? {
        subjects.first { $0.packId == packId }
    }
}

// MARK: - Pure analysis

/// A signed change between two snapshots (`to` minus `from`). Deltas can be
/// negative — forgetting is real and the dashboard shows it honestly.
struct ProgressDelta: Hashable {
    let fromDate: Date
    let toDate: Date
    /// `to.overallMasteryFraction - from.overallMasteryFraction` (−1…1).
    let overallMasteryDelta: Double
    /// `to.overallCoverageFraction - from.overallCoverageFraction` (−1…1).
    let overallCoverageDelta: Double
    /// packId → mastery-fraction delta, only for subjects present in BOTH
    /// snapshots (a subject absent from `from` has no baseline to diff).
    let perSubjectMasteryDelta: [String: Double]
}

/// One plotted point in a per-subject (or overall) time series.
struct ProgressSeriesPoint: Hashable, Identifiable {
    let date: Date
    /// Mastery fraction on that day, 0…1.
    let masteryFraction: Double
    /// Coverage fraction on that day, 0…1.
    let coverageFraction: Double
    var id: Date { date }
}

/// Pure, `@MainActor`-free analysis over a history array. Every function sorts
/// defensively by date so callers may pass `Dictionary.values` in any order.
enum ProgressHistory {

    /// Signed change `to − from`, per overall axis and per shared subject.
    static func delta(from: ProgressSnapshot, to: ProgressSnapshot) -> ProgressDelta {
        var perSubject: [String: Double] = [:]
        let fromByPack = Dictionary(from.subjects.map { ($0.packId, $0) },
                                    uniquingKeysWith: { a, _ in a })
        for toPoint in to.subjects {
            if let fromPoint = fromByPack[toPoint.packId] {
                perSubject[toPoint.packId] =
                    toPoint.masteryFraction - fromPoint.masteryFraction
            }
        }
        return ProgressDelta(
            fromDate: from.date,
            toDate: to.date,
            overallMasteryDelta: to.overallMasteryFraction - from.overallMasteryFraction,
            overallCoverageDelta: to.overallCoverageFraction - from.overallCoverageFraction,
            perSubjectMasteryDelta: perSubject
        )
    }

    /// Mastery/coverage series for one subject, oldest → newest. Days where the
    /// subject wasn't captured are simply absent (the chart connects the dots).
    static func series(_ history: [ProgressSnapshot], forPackId packId: String) -> [ProgressSeriesPoint] {
        history
            .sorted { $0.date < $1.date }
            .compactMap { snap in
                guard let p = snap.point(forPackId: packId) else { return nil }
                return ProgressSeriesPoint(date: snap.date,
                                           masteryFraction: p.masteryFraction,
                                           coverageFraction: p.coverageFraction)
            }
    }

    /// Overall mastery/coverage series, oldest → newest.
    static func overallSeries(_ history: [ProgressSnapshot]) -> [ProgressSeriesPoint] {
        history
            .sorted { $0.date < $1.date }
            .map { ProgressSeriesPoint(date: $0.date,
                                       masteryFraction: $0.overallMasteryFraction,
                                       coverageFraction: $0.overallCoverageFraction) }
    }

    /// Week-over-week delta: the latest snapshot vs the snapshot whose day is
    /// closest to (latest − 7 days) WITHOUT being newer than that target (so we
    /// compare against roughly a week ago, never a same-day baseline). Returns
    /// nil when there's no usable prior point (fewer than two distinct days, or
    /// no snapshot at/before the 7-days-ago mark).
    static func weekOverWeek(_ history: [ProgressSnapshot],
                             now: Date = Date(),
                             calendar: Calendar = .current) -> ProgressDelta? {
        let sorted = history.sorted { $0.date < $1.date }
        guard let latest = sorted.last else { return nil }
        guard let target = calendar.date(byAdding: .day, value: -7, to: latest.date)
        else { return nil }
        // Prior = the newest snapshot on or before the 7-days-ago target that
        // is also strictly older than `latest` (never diff a day against itself).
        let prior = sorted.last { $0.date <= target && $0.date < latest.date }
        guard let from = prior else { return nil }
        return delta(from: from, to: latest)
    }
}
