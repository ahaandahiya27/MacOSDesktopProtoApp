import Foundation

// MARK: - Milestone checkpoint persistence
//
// v6 Learning Journey · Phase 4 M3. Stores a capped, chronological history of
// completed Milestone Checkpoints in `milestone_checkpoints.json`, reusing the
// shared `readFile` / `save` plumbing (atomic writes). This is NEW app state in
// its own file — it never reads or writes the SRS (`questionReviews`).
//
// Big Sur compatible: value types, no macOS 12+ APIs.

extension DataStore {

    static let milestoneCheckpointFilename = "milestone_checkpoints.json"

    /// Keep the most recent N checkpoints so the file can't grow without bound;
    /// the report card only needs the latest, and a short trend at most.
    static let milestoneCheckpointHistoryCap = 50

    /// Hydrate `milestoneCheckpoints` from disk at most once per process. The
    /// in-memory copy is the source of truth thereafter, so an append-then-save
    /// never races the asynchronous write the way a read-back-from-disk would.
    func hydrateMilestoneCheckpointsIfNeeded() {
        guard !didHydrateMilestoneCheckpoints else { return }
        didHydrateMilestoneCheckpoints = true
        milestoneCheckpoints = Self.readFile(
            MilestoneCheckpointResult.self,
            from: Self.milestoneCheckpointFilename, in: storeDir)
            .items
            .sorted { $0.takenAt < $1.takenAt }
    }

    /// All stored checkpoint results, oldest → newest. Empty if none taken yet.
    func loadCheckpointResults() -> [MilestoneCheckpointResult] {
        hydrateMilestoneCheckpointsIfNeeded()
        return milestoneCheckpoints
    }

    /// The most recently taken checkpoint, or nil if none exist.
    func latestCheckpointResult() -> MilestoneCheckpointResult? {
        loadCheckpointResults().last
    }

    /// Append a completed checkpoint to the in-memory history and persist
    /// (atomic), capped to the most recent `milestoneCheckpointHistoryCap`.
    /// Returns the saved history. READ-ONLY over the SRS.
    @discardableResult
    func recordCheckpointResult(_ result: MilestoneCheckpointResult)
        -> [MilestoneCheckpointResult] {
        hydrateMilestoneCheckpointsIfNeeded()
        milestoneCheckpoints.append(result)
        milestoneCheckpoints.sort { $0.takenAt < $1.takenAt }
        if milestoneCheckpoints.count > Self.milestoneCheckpointHistoryCap {
            milestoneCheckpoints = Array(
                milestoneCheckpoints.suffix(Self.milestoneCheckpointHistoryCap))
        }
        save(milestoneCheckpoints, to: Self.milestoneCheckpointFilename)
        return milestoneCheckpoints
    }
}
