import XCTest
@testable import desktopAhaan

// MARK: - MasteryEngineTests
//
// v6 Learning Journey · Phase 2. Pins the pure, registry-free cores of the
// cross-subject `MasteryEngine`: the level-banding function and the overall
// rollup (coverage vs mastery, weighted aggregation, weakest-subject
// selection). The `@MainActor snapshot(registry:dataStore:)` path is exercised
// by the live app + the Mastery Map UI tests; here we lock the maths that the
// whole Map and the Phase-3 planner depend on, using fabricated summaries so
// no registry or DataStore is needed.
final class MasteryEngineTests: XCTestCase {

    // MARK: - Helpers to fabricate summaries

    /// A chapter summary with a given level→count distribution.
    private func chapter(_ packId: String,
                         _ chapterId: String,
                         _ number: Int,
                         _ counts: [MasteryLevel: Int]) -> ChapterMasterySummary {
        ChapterMasterySummary(
            subjectPackId: packId,
            chapterId: chapterId,
            chapterNumber: number,
            chapterTitle: "Chapter \(number)",
            counts: counts,
            topicSummaries: []
        )
    }

    private func summary(_ packId: String,
                         _ chapters: [ChapterMasterySummary],
                         due: Int = 0) -> MasterySummary {
        let total = chapters.reduce(0) { $0 + $1.totalReviewed }
        return MasterySummary(subjectPackId: packId,
                              chapters: chapters,
                              dueCount: due,
                              totalReviewed: total)
    }

    private func subject(_ packId: String,
                         title: String,
                         _ chapters: [ChapterMasterySummary],
                         reviewable: Int,
                         due: Int = 0) -> SubjectMasterySnapshot {
        SubjectMasterySnapshot(
            packId: packId,
            subjectTitle: title,
            summary: summary(packId, chapters, due: due),
            totalReviewableQuestions: reviewable,
            dueCount: due
        )
    }

    // MARK: - level(forFraction:)

    func testLevelBandingBoundaries() {
        XCTAssertEqual(MasteryEngine.level(forFraction: 0.0), .learning)
        XCTAssertEqual(MasteryEngine.level(forFraction: 0.19), .learning)
        XCTAssertEqual(MasteryEngine.level(forFraction: 0.20), .familiar)
        XCTAssertEqual(MasteryEngine.level(forFraction: 0.49), .familiar)
        XCTAssertEqual(MasteryEngine.level(forFraction: 0.50), .confident)
        XCTAssertEqual(MasteryEngine.level(forFraction: 0.79), .confident)
        XCTAssertEqual(MasteryEngine.level(forFraction: 0.80), .mastered)
        XCTAssertEqual(MasteryEngine.level(forFraction: 1.00), .mastered)
    }

    func testLevelBandingClampsOutOfRange() {
        XCTAssertEqual(MasteryEngine.level(forFraction: -5.0), .learning,
            "Negative fractions clamp to Learning, never crash.")
        XCTAssertEqual(MasteryEngine.level(forFraction: 9.0), .mastered,
            "Fractions above 1 clamp to Mastered.")
    }

    // MARK: - SubjectMasterySnapshot

    func testCoverageIsReviewedOverReviewable() {
        // 10 reviewed (all mastered), 40 reviewable → 25% coverage, 100% mastery.
        let s = subject("p", title: "P",
                        [chapter("p", "c1", 1, [.mastered: 10])],
                        reviewable: 40)
        XCTAssertEqual(s.reviewedQuestions, 10)
        XCTAssertEqual(s.coverageFraction, 0.25, accuracy: 0.0001)
        XCTAssertEqual(s.masteryFraction, 1.0, accuracy: 0.0001)
        XCTAssertEqual(s.level, .mastered)
        XCTAssertTrue(s.hasStarted)
    }

    func testCoverageClampsAndHandlesZeroDenominator() {
        // reviewed exceeds reviewable (domain mismatch) → clamp to 1.0.
        let clamped = subject("p", title: "P",
                              [chapter("p", "c1", 1, [.confident: 50])],
                              reviewable: 10)
        XCTAssertEqual(clamped.coverageFraction, 1.0, accuracy: 0.0001)

        // zero reviewable → coverage 0, never NaN/inf.
        let zero = subject("p", title: "P", [], reviewable: 0)
        XCTAssertEqual(zero.coverageFraction, 0.0)
        XCTAssertFalse(zero.hasStarted)
        XCTAssertEqual(zero.level, .learning)
    }

    func testMasteryFractionIsReviewedWeightedAcrossChapters() {
        // c1: 10 mastered (1.0). c2: 10 learning (0.0). Even split → 0.5.
        let s = subject("p", title: "P",
                        [chapter("p", "c1", 1, [.mastered: 10]),
                         chapter("p", "c2", 2, [.learning: 10])],
                        reviewable: 100)
        XCTAssertEqual(s.masteryFraction, 0.5, accuracy: 0.0001)
        XCTAssertEqual(s.level, .confident)   // 0.5 is the Confident floor
    }

    // MARK: - OverallMasterySnapshot

    func testOverallRollupWeightsByReviewedCount() {
        // Subject A: 100 reviewed @ mastery 0.9. Subject B: 10 reviewed @ 0.1.
        // Weighted mean = (0.9*100 + 0.1*10) / 110 = 91/110 ≈ 0.827.
        let a = subject("a", title: "A",
                        [chapter("a", "c1", 1, [.mastered: 90, .learning: 10])], // 0.9
                        reviewable: 200, due: 3)
        let b = subject("b", title: "B",
                        [chapter("b", "c1", 1, [.mastered: 1, .learning: 9])],   // 0.1
                        reviewable: 50, due: 2)
        let overall = MasteryEngine.overall(from: [a, b])

        XCTAssertEqual(overall.totalReviewed, 110)
        XCTAssertEqual(overall.totalReviewable, 250)
        XCTAssertEqual(overall.totalDue, 5)
        XCTAssertEqual(overall.overallCoverageFraction, 110.0 / 250.0, accuracy: 0.0001)
        XCTAssertEqual(overall.overallMasteryFraction, 91.0 / 110.0, accuracy: 0.001)
        XCTAssertEqual(overall.overallLevel, .mastered)   // ≈0.827 ≥ 0.80
        XCTAssertFalse(overall.isEmpty)
    }

    func testEmptyOverallIsZeroAndNotNaN() {
        let empty = MasteryEngine.overall(from: [])
        XCTAssertTrue(empty.isEmpty)
        XCTAssertEqual(empty.overallMasteryFraction, 0.0)
        XCTAssertEqual(empty.overallCoverageFraction, 0.0)
        XCTAssertEqual(empty.overallLevel, .learning)
        XCTAssertNil(empty.weakestStartedSubject)
        XCTAssertTrue(empty.startedSubjects.isEmpty)

        // Subjects that exist but have zero reviews are still "empty overall".
        let unstarted = MasteryEngine.overall(from: [
            subject("a", title: "A", [], reviewable: 100)
        ])
        XCTAssertTrue(unstarted.isEmpty)
        XCTAssertNil(unstarted.weakestStartedSubject)
    }

    func testWeakestStartedSubjectIgnoresUnstartedAndPicksLowestMastery() {
        let strong = subject("strong", title: "Strong",
                             [chapter("strong", "c1", 1, [.mastered: 20])], // 1.0
                             reviewable: 50)
        let weak = subject("weak", title: "Weak",
                           [chapter("weak", "c1", 1, [.learning: 8, .familiar: 2])], // 0.066
                           reviewable: 50)
        let unstarted = subject("zzz", title: "Z", [], reviewable: 100)   // no reviews

        let overall = MasteryEngine.overall(from: [strong, unstarted, weak])
        XCTAssertEqual(overall.startedSubjects.count, 2,
            "Unstarted subjects are excluded from the started set.")
        XCTAssertEqual(overall.weakestStartedSubject?.packId, "weak",
            "The lowest-mastery STARTED subject must be flagged for focus.")
    }

    func testWeakestSubjectTieBreaksOnCoverageThenOrder() {
        // Two subjects with identical mastery (both 0.0 → all learning);
        // the one with LOWER coverage should win the tie.
        let lowCoverage = subject("low", title: "Low",
                                  [chapter("low", "c1", 1, [.learning: 5])],
                                  reviewable: 100)   // 5% coverage
        let highCoverage = subject("high", title: "High",
                                   [chapter("high", "c1", 1, [.learning: 50])],
                                   reviewable: 100)  // 50% coverage
        let overall = MasteryEngine.overall(from: [highCoverage, lowCoverage])
        XCTAssertEqual(overall.weakestStartedSubject?.packId, "low",
            "On equal mastery, the thinner-coverage subject is the weaker one.")
    }
}
