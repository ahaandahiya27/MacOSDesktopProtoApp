import Foundation

// MARK: - MilestoneAssessmentPlanner
//
// v6 Learning Journey · Phase 4. The PURE sampling core for a Milestone
// Assessment — the mixed, cross-subject quiz weighted by mastery gaps. It owns
// two decisions, both FS-free and DataStore-free so they're unit-testable
// without the app:
//
//   • how many of the assessment's slots each subject earns (`allocateSlots`),
//     weighting weaker subjects more heavily; and
//   • the final question order (`compose`), which truncates each subject's
//     gap-ordered pool to its allocation and then interleaves the picks
//     weak-subject-first — reusing `JourneyPlanner.roundRobinReviews` so the
//     two journey planners share one spread guarantee rather than re-deriving
//     it.
//
// The `@MainActor` half — gathering each subject's gap-ordered pool of reviewed
// topic questions from the live DataStore — lives in
// `DataStore+MilestoneAssessment.swift`. Mirrors the JourneyPlanner split.
//
// READ-ONLY over the SRS: nothing here mutates reviews or schedules anything.
//
// Big Sur compatible: Foundation-only value math, no macOS 12+ APIs.

enum MilestoneAssessmentPlanner {

    /// Floor weight so a fully-mastered (gap ≈ 0) but still-eligible subject
    /// can claim a slot when stronger-gap subjects are exhausted, rather than
    /// being frozen out by a literal-zero weight in the highest-averages math.
    static let minWeight = 0.0001

    // MARK: - Slot apportionment

    /// Apportion `total` question slots across `subjects`, weighting a subject's
    /// share by its mastery gap (`weight` — bigger gap ⇒ more slots), capped at
    /// each subject's `available` pool size.
    ///
    /// Uses the highest-averages (D'Hondt) divisor method: repeatedly hand the
    /// next slot to the subject with the largest `weight / (assigned + 1)` that
    /// still has capacity. This is proportional, deterministic, and:
    ///   • sums to exactly `min(total, Σ available)` — no over/under-fill;
    ///   • respects each `available` cap (a thin subject never over-contributes);
    ///   • on the first round every subject divides by 1, so the largest-gap
    ///     subjects are served first — the brief's "sample by mastery gaps".
    ///
    /// Ties (equal quotients) break by input order, so callers that pass
    /// subjects in weakest-first focus order get weakest-first tie resolution.
    /// `weight` is floored at `minWeight`; a non-positive `available` makes a
    /// subject ineligible. Pure — no FS, no DataStore.
    static func allocateSlots(
        _ subjects: [(packId: String, weight: Double, available: Int)],
        total: Int
    ) -> [String: Int] {
        guard total > 0 else { return [:] }
        let eligible = subjects.enumerated().compactMap {
            (offset, s) -> (offset: Int, packId: String, weight: Double, cap: Int)? in
            guard s.available > 0 else { return nil }
            return (offset, s.packId, max(s.weight, minWeight), s.available)
        }
        guard !eligible.isEmpty else { return [:] }

        let capacity = eligible.reduce(0) { $0 + $1.cap }
        let target = min(total, capacity)

        var counts: [String: Int] = [:]
        for _ in 0..<target {
            // Pick the open subject with the largest weight/(assigned+1).
            var best: (offset: Int, packId: String, quotient: Double)?
            for s in eligible {
                let assigned = counts[s.packId] ?? 0
                guard assigned < s.cap else { continue }
                let quotient = s.weight / Double(assigned + 1)
                if let b = best {
                    // Strictly greater wins; equal quotient → earlier input
                    // order (lower offset) wins, for determinism.
                    if quotient > b.quotient
                        || (quotient == b.quotient && s.offset < b.offset) {
                        best = (s.offset, s.packId, quotient)
                    }
                } else {
                    best = (s.offset, s.packId, quotient)
                }
            }
            guard let winner = best else { break }
            counts[winner.packId, default: 0] += 1
        }
        return counts
    }

    // MARK: - Full compose (allocate → truncate → interleave)

    /// Build the assessment's ordered `(packId, questionId)` sequence.
    ///
    /// `poolsByPack` is each subject's candidate question ids ALREADY ordered
    /// gap-first (weakest reviewed item first) by the builder. `weightByPack`
    /// is the per-subject mastery-gap weight. `order` is the weakest-first
    /// `JourneyPlanner.subjectFocusOrder`. `total` is the target question count.
    ///
    /// Steps: allocate `total` slots by gap weight (capped at each pool's size),
    /// take that many ids from the front of each gap-ordered pool, then
    /// interleave the picks weak-subject-first via
    /// `JourneyPlanner.roundRobinReviews` so the quiz alternates subjects
    /// instead of running one subject to exhaustion. Pure — no FS, no DataStore.
    static func compose(
        poolsByPack: [String: [String]],
        weightByPack: [String: Double],
        order: [String],
        total: Int
    ) -> [(packId: String, questionId: String)] {
        guard total > 0 else { return [] }

        // Walk subjects in focus order so allocation ties resolve weakest-first;
        // a pool whose pack isn't in `order` (defensive) is appended by sorted
        // id so nothing is silently dropped.
        let ordered = order.filter { (poolsByPack[$0]?.isEmpty == false) }
        let extra = poolsByPack.keys
            .filter { !order.contains($0) && (poolsByPack[$0]?.isEmpty == false) }
            .sorted()
        let packs = ordered + extra

        let slotInputs = packs.map {
            (packId: $0, weight: weightByPack[$0] ?? 0, available: poolsByPack[$0]?.count ?? 0)
        }
        let allocation = allocateSlots(slotInputs, total: total)

        var pickedByPack: [String: [String]] = [:]
        for packId in packs {
            let n = allocation[packId] ?? 0
            guard n > 0, let pool = poolsByPack[packId] else { continue }
            pickedByPack[packId] = Array(pool.prefix(n))
        }

        // Reuse the JourneyPlanner spread guarantee for the final order — the
        // picked counts already sum to ≤ total, so every pick is returned, just
        // interleaved weakest-first.
        return JourneyPlanner.roundRobinReviews(
            dueByPack: pickedByPack, order: packs, max: total)
    }
}
