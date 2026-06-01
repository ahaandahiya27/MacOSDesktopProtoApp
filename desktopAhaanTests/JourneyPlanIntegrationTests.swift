import XCTest
@testable import desktopAhaan

// MARK: - JourneyPlanIntegrationTests
//
// v6 Learning Journey · Phase 3. Drives the live `SubjectRegistry` through the
// `@MainActor buildWholeJourneyPlan` + `currentDailyPlan` mode-switch paths on
// an ISOLATED temp store (so it never touches the real SRS / plan file). Seeds
// due reviews across subjects to prove the cross-subject round-robin spread,
// the collision-safe Discover sourcing, and the read-only-over-SRS contract.
@MainActor
final class JourneyPlanIntegrationTests: XCTestCase {

    private var utc: Calendar {
        var c = Calendar(identifier: .gregorian)
        c.timeZone = TimeZone(identifier: "UTC")!
        return c
    }

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
            .appendingPathComponent("jp-\(UUID().uuidString)")
        return DataStore(streakCalendar: nil, storeDir: dir, autoLoad: false)
    }

    private func reviewDue(_ id: String, packId: String, at: Date) -> QuestionReview {
        QuestionReview(questionId: id, bucket: 1, ease: 2.5, intervalDays: 1,
                       lastReviewedAt: at, nextDueAt: at,
                       totalReviews: 1, lapses: 0, packId: packId)
    }

    /// Up to `count` real topic-question ids from a pack, in authored order.
    private func reviewableIds(in pack: SubjectPack, count: Int) -> [String] {
        var out: [String] = []
        for chapter in pack.chapters {
            for topic in chapter.topics {
                for q in topic.questions {
                    out.append(q.id)
                    if out.count >= count { return out }
                }
            }
        }
        return out
    }

    /// A read-only signature of the SRS so we can assert the build never
    /// mutated it (without relying on QuestionReview Equatable).
    private func srsSignature(_ reviews: [String: QuestionReview]) -> [String: String] {
        reviews.mapValues { "\($0.totalReviews)|\($0.lapses)|\($0.nextDueAt.timeIntervalSince1970)" }
    }

    func testWholeJourneyPlanSpreadsReviewsAcrossSubjectsAndIsReadOnly() async throws {
        let registry = try await loadedRegistry()
        let store = tempStore()
        let now = Date()
        let past = now.addingTimeInterval(-3600)

        var reviews: [String: QuestionReview] = [:]
        var seeded: [String] = []
        for pid in ["science_class7", "sanskrit_class7", "socialscience_class7"] {
            guard let pack = registry.pack(withId: pid) else { continue }
            // packId is set on each review so a colliding bare `chNN_tNN_qNN`
            // id resolves to the intended subject, not Maths (which sorts first
            // in the global index). Dedup against ids already seeded by another
            // subject — the Sanskrit legacy `ch01` deck shares the `ch01_*` id
            // space with Science, so first-chapter ids can collide.
            let fresh = reviewableIds(in: pack, count: 16)
                .filter { reviews[$0] == nil }.prefix(2)
            guard fresh.count == 2 else { continue }
            seeded.append(pid)
            for id in fresh { reviews[id] = reviewDue(id, packId: pid, at: past) }
        }
        try XCTSkipUnless(seeded.count >= 2, "Need ≥2 subjects with topic questions.")
        store.questionReviews = reviews
        let before = srsSignature(store.questionReviews)

        let plan = store.buildWholeJourneyPlan(registry: registry, now: now)

        XCTAssertEqual(plan.mode, .wholeJourney, "Plan must be tagged Whole Journey.")

        let reviewItems = plan.items.filter { $0.kind == .review }
        XCTAssertGreaterThan(reviewItems.count, 0, "Seeded due reviews must surface.")
        XCTAssertLessThanOrEqual(reviewItems.count, 3, "Reviews are capped at 3.")

        // Cross-subject spread: a weak subject's due review is never starved by
        // another monopolising all slots. With ≥2 subjects due, the (≤3) review
        // items span ≥ min(3, seeded) distinct packs.
        let reviewPacks = Set(reviewItems.map { $0.packId })
        XCTAssertGreaterThanOrEqual(reviewPacks.count, min(3, seeded.count),
            "Reviews must spread across subjects, not monopolise one.")

        // At most one concept + one Discover slot, ≤5 items total.
        XCTAssertLessThanOrEqual(plan.items.filter { $0.kind == .concept }.count, 1)
        XCTAssertLessThanOrEqual(plan.items.filter { $0.kind == .discover }.count, 1)
        XCTAssertLessThanOrEqual(plan.items.count, 5)

        // Item ids are unique (the persistence + reconcile keys must not clash).
        XCTAssertEqual(Set(plan.items.map { $0.id }).count, plan.items.count,
            "Plan item ids must be unique.")

        // Discover sourcing is collision-safe: never a Maths chapter.
        for item in plan.items where item.kind == .discover {
            XCTAssertNotEqual(item.packId, "maths_class7",
                "Whole Journey must not offer a Maths Discover item (chNN id collision).")
            XCTAssertTrue(DataStore.journeyDiscoverPackIds.contains(item.packId),
                "Discover items must come from a collision-safe pack.")
        }

        // Read-only over the SRS — the build mutated nothing.
        XCTAssertEqual(srsSignature(store.questionReviews), before,
            "buildWholeJourneyPlan must not mutate questionReviews.")
    }

    func testCurrentDailyPlanRebuildsOnModeSwitch() async throws {
        let registry = try await loadedRegistry()
        let store = tempStore()
        let now = Date()

        // Save/restore the shared mode key so the suite leaves no residue.
        let d = UserDefaults.standard
        let savedMode = d.object(forKey: JourneyPlannerStorage.modeKey)
        defer {
            if let v = savedMode { d.set(v, forKey: JourneyPlannerStorage.modeKey) }
            else { d.removeObject(forKey: JourneyPlannerStorage.modeKey) }
        }

        JourneyPlannerStorage.setMode(.today, d)
        let today = store.currentDailyPlan(registry: registry, now: now, calendar: utc)
        XCTAssertEqual(today.mode, .today)

        // Same day, new mode → must REBUILD in the new mode (not reuse the
        // stored .today plan), and persist the rebuilt plan.
        JourneyPlannerStorage.setMode(.wholeJourney, d)
        let journey = store.currentDailyPlan(registry: registry, now: now, calendar: utc)
        XCTAssertEqual(journey.mode, .wholeJourney,
            "Switching mode within the same day rebuilds the plan in the new mode.")
        store.flushSavesBeforeQuit()   // saveDailyPlan is coalesced/async
        XCTAssertEqual(store.loadDailyPlan()?.mode, .wholeJourney,
            "The rebuilt Whole Journey plan must be persisted.")

        // Switching back reuses neither — rebuilds .today again.
        JourneyPlannerStorage.setMode(.today, d)
        let backToToday = store.currentDailyPlan(registry: registry, now: now, calendar: utc)
        XCTAssertEqual(backToToday.mode, .today)
    }
}
