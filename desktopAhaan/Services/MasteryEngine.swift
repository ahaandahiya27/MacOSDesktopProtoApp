import Foundation

// MARK: - MasteryEngine
//
// v6 Learning Journey · Phase 2. A READ-ONLY aggregation layer that rolls the
// existing per-subject `MasterySummary` (see `DataStore+Mastery.swift`) up into
// a single cross-subject picture: concept/topic → chapter → subject → overall.
//
// Strict invariants:
//   • READ-ONLY over the SRS. This engine never mutates `questionReviews`,
//     never schedules a review, never writes to disk. It only reads
//     `DataStore.questionReviews` and the immutable `SubjectRegistry` packs.
//   • Built ON TOP of the existing mastery infrastructure — it reuses
//     `DataStore.masterySummary(forPackId:…)` and `MasteryLevel.from(review:)`
//     rather than re-deriving bucket math, so the Mastery Map and the
//     single-subject MasteryDashboard can never drift apart.
//   • Pure where it can be: `level(forFraction:)` and the
//     `OverallMasterySnapshot` / `SubjectMasterySnapshot` rollups are plain
//     value math, unit-testable with fabricated summaries and no live
//     registry/DataStore. Only `snapshot(registry:dataStore:now:)` touches the
//     live singletons, and it is `@MainActor` because `DataStore` is.
//
// Coverage vs mastery — two distinct axes the Mastery Map shows side by side:
//   • coverageFraction = how MUCH of the subject the kid has even attempted
//     (distinct reviewed questions ÷ all reviewable questions). Answers "have
//     we been here yet?".
//   • masteryFraction  = how WELL the attempted material is known
//     (reviewed-question-weighted MasteryLevel, reused from MasterySummary).
//     Answers "how solid is it?".
// A subject can be 100 % mastered on the 5 % it has seen — the Map must show
// both so a parent isn't misled by a high mastery bar over thin coverage.

/// One subject's rollup for the cross-subject Mastery Map.
struct SubjectMasterySnapshot: Hashable, Identifiable {
    /// Owning pack id (`science_class7`, `maths_class7`, …).
    let packId: String
    /// Human subject title, taken from the pack (`Maths — Class 7`).
    let subjectTitle: String
    /// The existing per-subject summary (chapters + topic drill-down +
    /// reviewed-weighted mastery). Reused verbatim, never recomputed.
    let summary: MasterySummary
    /// Coverage denominator: every reviewable question in the subject —
    /// topic questions + boss-quiz + scene quick-checks (`Chapter.allQuestionIds`).
    let totalReviewableQuestions: Int
    /// Questions due for review in THIS subject right now (per-subject, unlike
    /// `summary.dueCount`, which is the global figure).
    let dueCount: Int

    var id: String { packId }

    /// Distinct questions reviewed at least once in this subject.
    var reviewedQuestions: Int { summary.totalReviewed }

    /// 0…1 — how well the attempted material is known.
    var masteryFraction: Double { summary.overallMasteryFraction }

    /// 0…1 — how much of the subject has been attempted. Clamped to 1.0 so a
    /// denominator/numerator domain mismatch can never report > 100 %.
    var coverageFraction: Double {
        guard totalReviewableQuestions > 0 else { return 0 }
        return min(1.0, Double(reviewedQuestions) / Double(totalReviewableQuestions))
    }

    /// The kid-facing mastery band for the subject as a whole.
    var level: MasteryLevel { MasteryEngine.level(forFraction: masteryFraction) }

    /// `true` when the kid has never reviewed anything in this subject — the
    /// Map renders these as an explicit "not started" empty state rather than
    /// a misleading 0 % bar.
    var hasStarted: Bool { reviewedQuestions > 0 }
}

/// The whole-journey rollup across every loaded subject.
struct OverallMasterySnapshot: Hashable {
    /// One row per subject, in the order the registry presents its packs
    /// (deterministic — see `SubjectRegistry`).
    let subjects: [SubjectMasterySnapshot]

    /// Distinct reviewed questions across all subjects.
    var totalReviewed: Int { subjects.reduce(0) { $0 + $1.reviewedQuestions } }

    /// All reviewable questions across all subjects (coverage denominator).
    var totalReviewable: Int { subjects.reduce(0) { $0 + $1.totalReviewableQuestions } }

    /// Questions due for review across all subjects right now.
    var totalDue: Int { subjects.reduce(0) { $0 + $1.dueCount } }

    /// 0…1 — overall fraction of the journey attempted.
    var overallCoverageFraction: Double {
        guard totalReviewable > 0 else { return 0 }
        return min(1.0, Double(totalReviewed) / Double(totalReviewable))
    }

    /// 0…1 — overall mastery, weighted by each subject's reviewed-question
    /// count so a subject with 200 reviews counts more than one with 3. Equals
    /// the reviewed-weighted mean of the per-subject mastery fractions.
    var overallMasteryFraction: Double {
        let reviewed = totalReviewed
        guard reviewed > 0 else { return 0 }
        let weighted = subjects.reduce(0.0) {
            $0 + $1.masteryFraction * Double($1.reviewedQuestions)
        }
        return weighted / Double(reviewed)
    }

    /// Kid-facing band for the journey as a whole.
    var overallLevel: MasteryLevel { MasteryEngine.level(forFraction: overallMasteryFraction) }

    /// `true` when nothing has been reviewed anywhere — the Map shows a
    /// welcoming "start your journey" state instead of empty bars.
    var isEmpty: Bool { totalReviewed == 0 }

    /// Subjects that have at least one review, in presentation order — the
    /// rows the Map actually draws progress bars for.
    var startedSubjects: [SubjectMasterySnapshot] { subjects.filter { $0.hasStarted } }

    /// The single subject most in need of attention: the started subject with
    /// the LOWEST mastery fraction (ties broken by lower coverage, then by
    /// presentation order for determinism). Drives the Map's "focus next"
    /// nudge and feeds the Phase-3 JourneyPlanner. `nil` until something is
    /// started.
    var weakestStartedSubject: SubjectMasterySnapshot? {
        startedSubjects.enumerated().min { a, b in
            if a.element.masteryFraction != b.element.masteryFraction {
                return a.element.masteryFraction < b.element.masteryFraction
            }
            if a.element.coverageFraction != b.element.coverageFraction {
                return a.element.coverageFraction < b.element.coverageFraction
            }
            return a.offset < b.offset
        }?.element
    }
}

enum MasteryEngine {

    // MARK: - Pure level bucketing

    /// Map a 0…1 mastery fraction to a kid-facing `MasteryLevel`. Tunable, and
    /// kept in one place so the Map, the dashboard and any future surface band
    /// the same number identically. Mirrors the intent of
    /// `MasteryLevel.from(review:)` but operates on an aggregate fraction
    /// rather than a single review's bucket.
    ///
    ///   < 0.20            → Learning   (barely begun, or mostly forgotten)
    ///   0.20 ..< 0.50     → Familiar   (settling in)
    ///   0.50 ..< 0.80     → Confident  (solid on most of it)
    ///   ≥ 0.80            → Mastered   (long-interval stable across the board)
    static func level(forFraction fraction: Double) -> MasteryLevel {
        let f = max(0.0, min(1.0, fraction))
        switch f {
        case ..<0.20: return .learning
        case ..<0.50: return .familiar
        case ..<0.80: return .confident
        default:      return .mastered
        }
    }

    // MARK: - Pure aggregation

    /// Roll an array of per-subject snapshots into the overall picture. Pure —
    /// fully unit-testable with fabricated subjects, no live singletons.
    static func overall(from subjects: [SubjectMasterySnapshot]) -> OverallMasterySnapshot {
        OverallMasterySnapshot(subjects: subjects)
    }

    // MARK: - Live snapshot (READ-ONLY over SRS)

    /// Build the whole-journey snapshot from the live registry + DataStore.
    /// READ-ONLY: reads `questionReviews` and the immutable packs only — no
    /// mutation, no scheduling, no disk write.
    ///
    /// O(R + Σ pack questions): one pass over reviews to tally per-pack due
    /// counts, then the existing `masterySummary` per pack (each O(R)).
    @MainActor
    static func snapshot(registry: SubjectRegistry,
                         dataStore: DataStore,
                         now: Date = Date()) -> OverallMasterySnapshot {
        let reviews = dataStore.questionReviews

        // One pass: attribute each due review to its owning pack. Prefer the
        // recorded `packId`; fall back to resolving via the registry so a
        // review written before packId tagging still lands in the right
        // subject. A review whose pack can't be resolved is skipped (it can't
        // be shown under any subject anyway).
        var duePerPack: [String: Int] = [:]
        for (questionId, review) in reviews where review.nextDueAt <= now {
            let resolvedPackId = review.packId
                ?? registry.location(forQuestionId: questionId)?.pack.id
            if let pid = resolvedPackId {
                duePerPack[pid, default: 0] += 1
            }
        }

        let subjects: [SubjectMasterySnapshot] = registry.packs.map { pack in
            let summary = dataStore.masterySummary(
                forPackId: pack.id,
                chapters: pack.chapters,
                locator: { id in
                    guard let loc = registry.location(
                            forQuestionId: id,
                            preferredPackId: reviews[id]?.packId),
                          loc.pack.id == pack.id else { return nil }
                    return (chapterId: loc.chapter.id,
                            chapterTitle: loc.chapter.title,
                            chapterNumber: loc.chapter.number)
                },
                topicLocator: { id in
                    guard let loc = registry.location(
                            forQuestionId: id,
                            preferredPackId: reviews[id]?.packId),
                          loc.pack.id == pack.id else { return nil }
                    for (idx, topic) in loc.chapter.topics.enumerated()
                    where topic.questions.contains(where: { $0.id == id }) {
                        return TopicLocation(topicId: topic.id,
                                             topicTitle: topic.title,
                                             displayOrder: idx)
                    }
                    return nil
                },
                now: now
            )
            let totalReviewable = pack.chapters.reduce(0) { $0 + $1.allQuestionIds.count }
            return SubjectMasterySnapshot(
                packId: pack.id,
                subjectTitle: pack.title,
                summary: summary,
                totalReviewableQuestions: totalReviewable,
                dueCount: duePerPack[pack.id] ?? 0
            )
        }

        return overall(from: subjects)
    }
}
