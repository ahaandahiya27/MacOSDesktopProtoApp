import Foundation

// MARK: - Mastery aggregation
//
// Reads the existing `questionReviews` map and produces the
// per-chapter + per-level counts the MasteryDashboard renders. No
// new storage — derives from `QuestionReview` state and the
// `SubjectRegistry` resolver. Lives in this partial so the math is
// next to the storage but the main `DataStore.swift` stays focused
// on its existing mutators.

/// Per-topic mastery counts inside a chapter. D6 drill-down on
/// the mastery dashboard renders one row per topic — same
/// segmented-bar shape as the chapter card. Topics with zero
/// reviewed questions are omitted (the dashboard auto-hides the
/// expanded section when the topicSummaries list is empty).
struct TopicMasterySummary: Hashable, Identifiable {
    let chapterId: String
    let topicId: String
    let topicTitle: String
    /// Stable display order inside the chapter — derived from the
    /// chapter's `topics` array index. Lets the dashboard render
    /// topics in the textbook's authored order regardless of how
    /// the kid first answered.
    let displayOrder: Int
    let counts: [MasteryLevel: Int]

    var id: String { "\(chapterId)::\(topicId)" }

    var totalReviewed: Int {
        counts.values.reduce(0, +)
    }

    var masteryFraction: Double {
        guard totalReviewed > 0 else { return 0 }
        let weighted =
            Double(counts[.mastered]  ?? 0) * 1.00 +
            Double(counts[.confident] ?? 0) * 0.66 +
            Double(counts[.familiar]  ?? 0) * 0.33 +
            Double(counts[.learning]  ?? 0) * 0.00
        return weighted / Double(totalReviewed)
    }
}

/// Per-chapter mastery counts. One row per chapter that has at least
/// one reviewed question; chapters without any review history are
/// omitted (the dashboard renders an empty-state cell for them via
/// the SubjectPack chapter list).
struct ChapterMasterySummary: Hashable, Identifiable {
    let subjectPackId: String
    let chapterId: String
    let chapterNumber: Int
    let chapterTitle: String
    /// MasteryLevel → count of reviewed questions in that level.
    /// Missing keys read as 0; the dashboard treats the dict as
    /// dense for layout.
    let counts: [MasteryLevel: Int]
    /// Per-topic drill-down (D6). Empty when the aggregator wasn't
    /// given a topic locator — backwards-compat with pre-D6
    /// callers / tests. Sorted by `displayOrder`.
    let topicSummaries: [TopicMasterySummary]

    var id: String { "\(subjectPackId)::\(chapterId)" }

    /// Total reviewed questions in this chapter — sum across levels.
    var totalReviewed: Int {
        counts.values.reduce(0, +)
    }

    /// 0.0..1.0 mastery fraction. Mastered counts at 1.0, Confident
    /// 0.66, Familiar 0.33, Learning 0.0 — gives the dashboard a
    /// single number for chapter-level sorting / progress bars while
    /// the underlying bucket counts stay visible.
    var masteryFraction: Double {
        guard totalReviewed > 0 else { return 0 }
        let weighted =
            Double(counts[.mastered]  ?? 0) * 1.00 +
            Double(counts[.confident] ?? 0) * 0.66 +
            Double(counts[.familiar]  ?? 0) * 0.33 +
            Double(counts[.learning]  ?? 0) * 0.00
        return weighted / Double(totalReviewed)
    }
}

/// Whole-subject snapshot — chapters sorted by `chapterNumber` so the
/// dashboard renders them in textbook order regardless of dictionary
/// iteration semantics.
struct MasterySummary: Hashable {
    let subjectPackId: String
    let chapters: [ChapterMasterySummary]
    let dueCount: Int
    let totalReviewed: Int

    var isEmpty: Bool { chapters.isEmpty }

    /// Aggregate mastery fraction across the whole subject —
    /// reviewed-question-weighted, so a chapter with 30 reviews
    /// counts more than one with 2. Drives the subject-level
    /// progress strip at the top of the dashboard.
    var overallMasteryFraction: Double {
        guard totalReviewed > 0 else { return 0 }
        let totals: [MasteryLevel: Int] = chapters.reduce(
            into: [.learning: 0, .familiar: 0, .confident: 0, .mastered: 0]
        ) { acc, ch in
            for (level, count) in ch.counts {
                acc[level, default: 0] += count
            }
        }
        let weighted =
            Double(totals[.mastered]  ?? 0) * 1.00 +
            Double(totals[.confident] ?? 0) * 0.66 +
            Double(totals[.familiar]  ?? 0) * 0.33 +
            Double(totals[.learning]  ?? 0) * 0.00
        return weighted / Double(totalReviewed)
    }
}

extension DataStore {

    /// Build a `MasterySummary` for the given pack. Walks
    /// `questionReviews`, resolves each `questionId` to its owning
    /// chapter via the supplied `SubjectRegistry`, buckets the
    /// reviews by chapter × MasteryLevel.
    ///
    /// O(R) where R = number of reviewed questions; the
    /// `SubjectRegistry.location(forQuestionId:)` lookup is O(1)
    /// against the pre-computed index. Safe to call inside a
    /// dashboard body — the published `questionReviews` change
    /// triggers a re-render and the math reruns.
    ///
    /// Decoupled from `SubjectRegistry` via a closure injection so
    /// this is unit-testable without spinning up a registry — pass
    /// `{ id in fakeIndex[id] }` in tests.
    func masterySummary(
        forPackId packId: String,
        chapters: [Chapter],
        locator: (String) -> (chapterId: String, chapterTitle: String, chapterNumber: Int)?,
        topicLocator: ((String) -> TopicLocation?)? = nil,
        now: Date = Date()
    ) -> MasterySummary {
        // chapterId → (numeric ordering, title, MasteryLevel → count,
        //               topicId → (topicTitle, displayOrder, counts))
        var byChapter: [String: (
            number: Int,
            title: String,
            counts: [MasteryLevel: Int],
            topics: [String: TopicAggregate]
        )] = [:]
        var totalReviewed = 0

        for (questionId, review) in questionReviews {
            guard let loc = locator(questionId) else { continue }
            let level = MasteryLevel.from(review: review)
            var entry = byChapter[loc.chapterId]
                ?? (number: loc.chapterNumber, title: loc.chapterTitle,
                    counts: [:], topics: [:])
            entry.counts[level, default: 0] += 1
            // Per-topic bucketing — only when the caller supplied a
            // topic locator. Skipping leaves topicSummaries empty,
            // which is the pre-D6 behaviour.
            if let topicLoc = topicLocator?(questionId) {
                var topicAgg = entry.topics[topicLoc.topicId]
                    ?? TopicAggregate(
                        title: topicLoc.topicTitle,
                        displayOrder: topicLoc.displayOrder,
                        counts: [:]
                    )
                topicAgg.counts[level, default: 0] += 1
                entry.topics[topicLoc.topicId] = topicAgg
            }
            byChapter[loc.chapterId] = entry
            totalReviewed += 1
        }

        let chapterRows: [ChapterMasterySummary] = byChapter
            .map { (chapterId, entry) in
                let topicRows = entry.topics
                    .map { (topicId, agg) in
                        TopicMasterySummary(
                            chapterId: chapterId,
                            topicId: topicId,
                            topicTitle: agg.title,
                            displayOrder: agg.displayOrder,
                            counts: agg.counts
                        )
                    }
                    .sorted { $0.displayOrder < $1.displayOrder }
                return ChapterMasterySummary(
                    subjectPackId: packId,
                    chapterId: chapterId,
                    chapterNumber: entry.number,
                    chapterTitle: entry.title,
                    counts: entry.counts,
                    topicSummaries: topicRows
                )
            }
            .sorted { $0.chapterNumber < $1.chapterNumber }

        let due = dueQuestionCount(at: now)

        return MasterySummary(
            subjectPackId: packId,
            chapters: chapterRows,
            dueCount: due,
            totalReviewed: totalReviewed
        )
    }
}

// MARK: - Topic locator support

/// Carrier for `topicLocator` callers — same role as the existing
/// inline-tuple `locator`, but a struct so the call site documents
/// the parameter order.
struct TopicLocation: Hashable {
    let topicId: String
    let topicTitle: String
    /// Index in the chapter's `topics` array, used to keep the
    /// dashboard row order stable across re-renders.
    let displayOrder: Int
}

/// Internal aggregator state — value-type so `byChapter[...]` reads
/// `Optional<TopicAggregate>` consistently.
private struct TopicAggregate {
    let title: String
    let displayOrder: Int
    var counts: [MasteryLevel: Int]
}
