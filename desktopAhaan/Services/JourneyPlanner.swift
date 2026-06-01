import Foundation

// MARK: - JourneyPlanner
//
// v6 Learning Journey · Phase 3. A READ-ONLY, cross-subject "Whole Journey"
// planner that EXTENDS — never replaces — the Daily Plan. It reuses the
// `DailyPlanItem` / `DailyPlan` model, the existing persistence + reconcile +
// streak plumbing (`DataStore+DailyPlan`), and the `AdaptiveDifficultyEngine`
// due-ordering. The one thing it adds is the brief's Phase-3 promise: it
// SAMPLES BY MASTERY GAPS (`MasteryEngine`) so the weakest *started* subject is
// served first and SRS reviews spread across subjects, instead of front-loading
// whichever pack the registry happens to list first.
//
// Two pieces, split so the interesting logic is testable without the app:
//   • this file — a PURE planning core (the weak-first subject focus order from
//     a `MasteryEngine` snapshot; a weak-first round-robin over per-subject due
//     queues). FS-free, no DataStore, no singletons.
//   • `DataStore+JourneyPlan.swift` — a `@MainActor` builder that gathers the
//     DataStore-coupled candidates (due ids, next unmastered concept, next open
//     Discover chapter) and assembles them through this core.
//
// Strict invariant — READ-ONLY over the SRS: the planner never mutates
// `questionReviews`, never schedules a review, never writes the SRS. It only
// reads the mastery snapshot + the immutable packs. Mirrors `MasteryEngine`.
//
// Big Sur compatible: Foundation-only value types, no macOS 12+ APIs.

/// Which lens the Daily Plan window is showing. Persisted (raw value) so a
/// chosen mode survives relaunches; defaults to `.today` so existing users see
/// no behavioural change until they opt into the journey view.
enum JourneyMode: String, Codable, CaseIterable, Hashable {
    /// The classic registry-order "today's 5 things" (3 due reviews, 1
    /// unmastered concept, 1 open Discover scene — Science-sourced).
    case today
    /// Cross-subject, mastery-gap-weighted: reviews spread weak-subject-first
    /// across all subjects; the concept + Discover slots are drawn from the
    /// weakest started subject, falling through the gap order.
    case wholeJourney

    /// Short kid-facing label for the mode picker.
    var title: String {
        switch self {
        case .today:        return "Today"
        case .wholeJourney: return "Whole Journey"
        }
    }

    /// One-line description shown under the picker.
    var subtitle: String {
        switch self {
        case .today:
            return "Your 5 things for today — due reviews, a new idea, and a Discover scene."
        case .wholeJourney:
            return "Balanced across every subject, focused on what needs the most attention."
        }
    }
}

/// `UserDefaults` keys for the Whole Journey feature. Kept here (not in the
/// shared `AppStorageKeys`) so the whole feature stays inside this run's files —
/// same precedent as `DailyPlanStorage` / `AdaptiveDifficultyStorage`.
enum JourneyPlannerStorage {
    /// Persisted `JourneyMode.rawValue`. Absent → `.today` (no eager write).
    static let modeKey = "journeyPlannerMode"

    static func currentMode(_ defaults: UserDefaults = .standard) -> JourneyMode {
        guard let raw = defaults.string(forKey: modeKey),
              let mode = JourneyMode(rawValue: raw) else { return .today }
        return mode
    }

    static func setMode(_ mode: JourneyMode, _ defaults: UserDefaults = .standard) {
        defaults.set(mode.rawValue, forKey: modeKey)
    }
}

enum JourneyPlanner {

    // MARK: - Pure subject focus order

    /// The order subjects should be served in, weakest first. *Started*
    /// subjects (≥1 review) come first, sorted by ascending mastery — ties
    /// broken by ascending coverage, then registry order — exactly the
    /// comparator `OverallMasterySnapshot.weakestStartedSubject` uses, here
    /// generalised to a full ordering. *Unstarted* subjects follow, in registry
    /// order, so a day-one journey still has a deterministic place to begin
    /// (the concept/Discover fallbacks walk this list).
    ///
    /// Returns pack ids. Pure — no FS, no DataStore.
    static func subjectFocusOrder(_ snapshot: OverallMasterySnapshot) -> [String] {
        let indexed = snapshot.subjects.enumerated()
            .map { (offset: $0.offset, subject: $0.element) }
        let started = indexed.filter { $0.subject.hasStarted }
        let unstarted = indexed.filter { !$0.subject.hasStarted }
        let sortedStarted = started.sorted { a, b in
            if a.subject.masteryFraction != b.subject.masteryFraction {
                return a.subject.masteryFraction < b.subject.masteryFraction
            }
            if a.subject.coverageFraction != b.subject.coverageFraction {
                return a.subject.coverageFraction < b.subject.coverageFraction
            }
            return a.offset < b.offset
        }
        return sortedStarted.map { $0.subject.packId } + unstarted.map { $0.subject.packId }
    }

    /// `packId → position` in the focus order (0 = weakest / served first).
    /// Pure convenience over `subjectFocusOrder`.
    static func focusRank(_ snapshot: OverallMasterySnapshot) -> [String: Int] {
        var rank: [String: Int] = [:]
        for (i, packId) in subjectFocusOrder(snapshot).enumerated() { rank[packId] = i }
        return rank
    }

    // MARK: - Pure weak-first review round-robin

    /// Pick up to `max` due reviews, spread weak-subject-first across subjects.
    ///
    /// `dueByPack` is the already-adaptive-ordered due question ids grouped by
    /// owning pack (each subject's internal order is preserved). `order` is the
    /// `subjectFocusOrder`. The algorithm takes one review from each subject in
    /// focus order (weakest first), then loops for a second from each, and so
    /// on until `max` is reached or every queue is drained.
    ///
    /// This GUARANTEES cross-subject spread — a weak subject's due review can
    /// never be starved by a strong subject monopolising all the slots — while
    /// keeping each subject's internal adaptive order intact. A pack present in
    /// `dueByPack` but absent from `order` (defensive: a due id whose subject
    /// isn't in the snapshot) is appended deterministically by sorted pack id,
    /// so nothing due is silently dropped. Pure — no FS, no DataStore.
    static func roundRobinReviews(
        dueByPack: [String: [String]], order: [String], max: Int
    ) -> [(packId: String, questionId: String)] {
        guard max > 0 else { return [] }

        var packs = order.filter { !($0.isEmpty) && (dueByPack[$0]?.isEmpty == false) }
        let extra = dueByPack.keys.filter { !order.contains($0) }.sorted()
        packs += extra.filter { dueByPack[$0]?.isEmpty == false }

        var cursor: [String: Int] = [:]
        var result: [(packId: String, questionId: String)] = []
        var progressed = true
        while result.count < max && progressed {
            progressed = false
            for packId in packs {
                guard result.count < max else { break }
                let i = cursor[packId] ?? 0
                guard let queue = dueByPack[packId], i < queue.count else { continue }
                result.append((packId: packId, questionId: queue[i]))
                cursor[packId] = i + 1
                progressed = true
            }
        }
        return result
    }
}
