import XCTest
@testable import desktopAhaan

// MARK: - LearningJourneyReadOnlyTests
//
// v6 Learning Journey · Phase 6 (Integrate). A capstone test that runs every v6
// read-only surface — the MasteryEngine snapshot, the Whole Journey plan, the
// Milestone Assessment sampler, and the Expert Challenge Ladder — over the live
// registry on one seeded, ISOLATED store, and asserts that NONE of them mutate
// the SRS (`questionReviews`). This is the single guarantee the whole journey
// layer rests on: it reads mastery + the immutable packs, never writing reviews.
@MainActor
final class LearningJourneyReadOnlyTests: XCTestCase {

    private func loadedRegistry() async throws -> SubjectRegistry {
        let registry = SubjectRegistry()
        for _ in 0..<50 {
            if !registry.isLoading && !registry.packs.isEmpty { break }
            try? await Task.sleep(nanoseconds: 50_000_000)
        }
        guard !registry.packs.isEmpty else { throw XCTSkip("No packs loaded in 2.5 s.") }
        return registry
    }

    private func tempStore() -> DataStore {
        let dir = FileManager.default.temporaryDirectory
            .appendingPathComponent("lj-\(UUID().uuidString)")
        return DataStore(streakCalendar: nil, storeDir: dir, autoLoad: false)
    }

    private func srsSignature(_ reviews: [String: QuestionReview]) -> [String: String] {
        reviews.mapValues {
            "\($0.totalReviews)|\($0.lapses)|\($0.bucket)|\($0.ease)|\($0.intervalDays)|\($0.nextDueAt.timeIntervalSince1970)"
        }
    }

    func testEveryV6SurfaceIsReadOnlyOverSRS() async throws {
        let registry = try await loadedRegistry()
        let store = tempStore()
        let now = Date()
        let past = now.addingTimeInterval(-3600)

        // Seed a spread of reviews across subjects at varied mastery so every
        // surface has real signal to chew on.
        var reviews: [String: QuestionReview] = [:]
        var seen = Set<String>()
        for (i, pid) in ["science_class7", "maths_class7", "sanskrit_class7",
                         "socialscience_class7"].enumerated() {
            guard let pack = registry.pack(withId: pid) else { continue }
            var taken = 0
            for chapter in pack.chapters {
                for topic in chapter.topics {
                    for q in topic.questions where seen.insert(q.id).inserted {
                        // Vary bucket by subject so mastery fractions differ.
                        let bucket = (i + taken) % 6
                        reviews[q.id] = QuestionReview(
                            questionId: q.id, bucket: bucket, ease: 2.3,
                            intervalDays: bucket >= 5 ? 30 : bucket,
                            lastReviewedAt: past,
                            nextDueAt: bucket == 0 ? past : past.addingTimeInterval(Double(bucket) * 86_400),
                            totalReviews: bucket + 1, lapses: 0, packId: pid)
                        taken += 1
                        if taken >= 8 { break }
                    }
                    if taken >= 8 { break }
                }
                if taken >= 8 { break }
            }
        }
        try XCTSkipUnless(reviews.count >= 8, "Need seeded reviews to exercise the surfaces.")
        store.questionReviews = reviews
        let before = srsSignature(store.questionReviews)

        // Run every v6 read-only surface.
        let snapshot = MasteryEngine.snapshot(registry: registry, dataStore: store, now: now)
        XCTAssertFalse(snapshot.isEmpty, "Seeded reviews → a non-empty mastery snapshot.")

        let journey = store.buildWholeJourneyPlan(registry: registry, now: now)
        XCTAssertEqual(journey.mode, .wholeJourney)

        let assessment = store.buildMilestoneAssessment(registry: registry, now: now)
        XCTAssertGreaterThanOrEqual(assessment.count, 0)

        let ladder = store.buildExpertChallengeLadder(registry: registry, now: now)
        XCTAssertEqual(ladder.subjects.count, registry.packs.count)

        // The one guarantee: not one of them touched the SRS.
        XCTAssertEqual(srsSignature(store.questionReviews), before,
            "No v6 read-only surface may mutate questionReviews.")
    }

    /// v8 capstone: the longitudinal Insights surfaces — progress-history
    /// capture, the trend series, the week-over-week delta — must also be
    /// strictly read-only over the SRS. Capture writes ONLY
    /// `progress_history.json`; it never mutates `questionReviews`.
    func testEveryV8InsightsSurfaceIsReadOnlyOverSRS() async throws {
        let registry = try await loadedRegistry()
        let store = tempStore()
        let now = Date()
        let past = now.addingTimeInterval(-3600)

        var reviews: [String: QuestionReview] = [:]
        var seen = Set<String>()
        for (i, pid) in ["science_class7", "maths_class7", "sanskrit_class7",
                         "socialscience_class7"].enumerated() {
            guard let pack = registry.pack(withId: pid) else { continue }
            var taken = 0
            for chapter in pack.chapters {
                for topic in chapter.topics {
                    for q in topic.questions where seen.insert(q.id).inserted {
                        let bucket = (i + taken) % 6
                        reviews[q.id] = QuestionReview(
                            questionId: q.id, bucket: bucket, ease: 2.3,
                            intervalDays: bucket >= 5 ? 30 : bucket,
                            lastReviewedAt: past,
                            nextDueAt: bucket == 0 ? past : past.addingTimeInterval(Double(bucket) * 86_400),
                            totalReviews: bucket + 1, lapses: 0, packId: pid)
                        taken += 1
                        if taken >= 8 { break }
                    }
                    if taken >= 8 { break }
                }
                if taken >= 8 { break }
            }
        }
        try XCTSkipUnless(reviews.count >= 8, "Need seeded reviews to exercise the surfaces.")
        store.questionReviews = reviews
        let before = srsSignature(store.questionReviews)

        // Exercise every v8 longitudinal surface's data path. Capture across a
        // few distinct days so the series + week-over-week have real signal.
        let cal = Calendar(identifier: .gregorian)
        for offset in [14, 7, 0] {
            if let day = cal.date(byAdding: .day, value: -offset, to: now) {
                store.captureProgressSnapshot(registry: registry, now: day, calendar: cal)
            }
        }
        XCTAssertGreaterThanOrEqual(store.progressHistorySorted().count, 2)
        _ = store.overallProgressSeries()
        for pid in ["science_class7", "maths_class7", "sanskrit_class7", "socialscience_class7"] {
            _ = store.progressSeries(forPackId: pid)
        }
        XCTAssertNotNil(store.progressWeekOverWeek(now: now, calendar: cal),
            "Three snapshots a week apart should yield a week-over-week delta.")

        // The capstone guarantee: not one v8 surface touched the SRS.
        XCTAssertEqual(srsSignature(store.questionReviews), before,
            "No v8 Insights surface may mutate questionReviews.")
    }
}
