import Foundation

// MARK: - Weekly Progress rollup model
//
// Value types the Parent / Weekly Progress dashboard renders. These are
// pure aggregates derived from existing persisted state (question
// reviews, concept visits, discover-scene completions, mastery levels,
// streak) by `DataStore.weeklyActivity(endingAt:)` in
// `DataStore+WeeklyActivity.swift`. No new SRS schema; nothing here is
// persisted on its own (the one new persisted thing is `ConceptVisit`,
// below, which feeds the `conceptsVisited` counts).
//
// Big Sur compatible: plain Hashable/Codable value types, no Combine,
// no macOS 12+ APIs.

/// One persisted concept-visit row. Written at `ConceptDetailView`
/// `onAppear` via `DataStore.recordConceptVisit(id:packId:at:)`. Keyed
/// in memory by `conceptId` so re-opening the same concept overwrites
/// the timestamp (last-visit semantics — we don't keep a full history,
/// matching the small-footprint design in the sweep brief). Persisted
/// to `conceptVisits.json` as an array of these rows.
struct ConceptVisit: Codable, Hashable {
    let conceptId: String
    /// Owning subject pack id, captured at visit time so the weekly
    /// rollup can attribute the visit to a subject without a registry
    /// lookup (concept ids are allowed to collide across packs).
    let packId: String
    var visitedAt: Date
}

/// How many of each mastery level the kid moved questions into during
/// the week. Computed from the activity window (questions whose last
/// review landed inside the 7 days), bucketed by current `MasteryLevel`.
/// `.learning` is intentionally omitted — the card celebrates progress,
/// and "still learning" isn't a gain to surface.
struct MasteryDelta: Hashable {
    let newFamiliar: Int
    let newConfident: Int
    let newMastered: Int

    static let zero = MasteryDelta(newFamiliar: 0, newConfident: 0, newMastered: 0)

    /// True when nothing crossed into Familiar/Confident/Mastered this
    /// week — the dashboard hides the celebration card in that case.
    var isEmpty: Bool {
        newFamiliar == 0 && newConfident == 0 && newMastered == 0
    }
}

/// Per-subject activity inside one day. Keyed in `DayActivity.perSubject`
/// by the owning pack id (`science_class7` / `maths_class7` /
/// `sanskrit_class7`). Counts are derived, not stored.
struct SubjectActivity: Hashable {
    let packId: String
    let reviews: Int
    /// Unique concepts whose last visit landed on this day for this pack.
    let conceptsVisited: Int
    let discoverScenesCompleted: Int
    /// Chapter id where the most activity happened this day for this
    /// pack, when resolvable; nil when no locator was supplied or the
    /// activity can't be attributed to a chapter.
    let topChapter: String?

    /// Total countable interactions — drives "did anything happen" tests
    /// and the empty-day check.
    var total: Int { reviews + conceptsVisited + discoverScenesCompleted }
}

/// One calendar day in the trailing-7 window. `perSubject` is empty for
/// a day with no activity (the grid renders those as a muted "—").
struct DayActivity: Hashable {
    let date: Date
    let perSubject: [String: SubjectActivity]
    /// Rough minutes-on-task estimate for the day. Derived (NOT measured):
    /// `reviews × 0.5 + conceptsVisited × 2 + discoverScenes × 3`, rounded.
    /// Documented as an estimate everywhere it surfaces.
    let totalMinutesEstimate: Int

    var isEmpty: Bool { perSubject.isEmpty }

    var totalReviews: Int {
        perSubject.values.reduce(0) { $0 + $1.reviews }
    }
    var totalConcepts: Int {
        perSubject.values.reduce(0) { $0 + $1.conceptsVisited }
    }
    var totalDiscoverScenes: Int {
        perSubject.values.reduce(0) { $0 + $1.discoverScenesCompleted }
    }
}

/// The whole 7-day rollup the dashboard + PDF export render. `days` is
/// always exactly 7, oldest → newest, each at `calendar.startOfDay`.
struct WeeklyActivity: Hashable {
    /// Start-of-day of the oldest day in the window (6 days before the
    /// end date's start-of-day).
    let weekStart: Date
    /// Exactly 7 entries, oldest first.
    let days: [DayActivity]
    let totalReviews: Int
    let totalConcepts: Int
    let totalDiscoverScenes: Int
    let masteryDelta: MasteryDelta
    let streakDays: Int
    let streakBest: Int

    /// True when the kid did anything at all in the window — gates the
    /// dashboard's empty-state copy.
    var hasAnyActivity: Bool {
        totalReviews + totalConcepts + totalDiscoverScenes > 0
    }

    /// Sum of the per-day minute estimates. Rough — see
    /// `DayActivity.totalMinutesEstimate`.
    var totalMinutesEstimate: Int {
        days.reduce(0) { $0 + $1.totalMinutesEstimate }
    }
}
