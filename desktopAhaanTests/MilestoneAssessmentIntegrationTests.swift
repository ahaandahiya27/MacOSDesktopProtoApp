import XCTest
@testable import desktopAhaan

// MARK: - MilestoneAssessmentIntegrationTests
//
// v6 Learning Journey · Phase 4. Drives the live `SubjectRegistry` through the
// `@MainActor buildMilestoneAssessment(...)` builder on an ISOLATED temp store
// (never touches the real SRS). Proves the cross-subject sampling, the
// gap-weighting (a weaker subject is tested more), the resolved-question
// integrity, and the read-only-over-SRS contract.
@MainActor
final class MilestoneAssessmentIntegrationTests: XCTestCase {

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
            .appendingPathComponent("ma-\(UUID().uuidString)")
        return DataStore(streakCalendar: nil, storeDir: dir, autoLoad: false)
    }

    /// A learning-level (weak) review: never escaped bucket 0.
    private func weakReview(_ id: String, packId: String, at: Date) -> QuestionReview {
        QuestionReview(questionId: id, bucket: 0, ease: 1.8, intervalDays: 0,
                       lastReviewedAt: at, nextDueAt: at,
                       totalReviews: 2, lapses: 1, packId: packId)
    }

    /// A mastered (strong) review: bucket 5, 21-day interval.
    private func strongReview(_ id: String, packId: String, at: Date) -> QuestionReview {
        QuestionReview(questionId: id, bucket: 5, ease: 2.6, intervalDays: 30,
                       lastReviewedAt: at, nextDueAt: at.addingTimeInterval(30 * 86_400),
                       totalReviews: 6, lapses: 0, packId: packId)
    }

    /// Up to `count` assessable-MCQ ids (single-tap gradable) from a pack, in
    /// authored order — matching the builder's eligibility filter.
    private func assessableMCQIds(in pack: SubjectPack, count: Int) -> [String] {
        var out: [String] = []
        for chapter in pack.chapters {
            for topic in chapter.topics {
                for q in topic.questions where DataStore.isAssessableMCQ(q) {
                    out.append(q.id)
                    if out.count >= count { return out }
                }
            }
        }
        return out
    }

    private func srsSignature(_ reviews: [String: QuestionReview]) -> [String: String] {
        reviews.mapValues { "\($0.totalReviews)|\($0.lapses)|\($0.bucket)|\($0.nextDueAt.timeIntervalSince1970)" }
    }

    // MARK: - Tests

    func testEmptyWhenNothingReviewed() async throws {
        let registry = try await loadedRegistry()
        let store = tempStore()
        let assessment = store.buildMilestoneAssessment(registry: registry)
        XCTAssertTrue(assessment.isEmpty, "No reviews → no milestone assessment.")
        XCTAssertEqual(assessment.count, 0)
        XCTAssertTrue(assessment.subjectCounts.isEmpty)
    }

    func testSamplesAcrossSubjectsResolvesQuestionsAndIsReadOnly() async throws {
        let registry = try await loadedRegistry()
        let store = tempStore()
        let now = Date()
        let past = now.addingTimeInterval(-3600)

        // Seed reviewed topic questions in up to three collision-free subjects.
        var reviews: [String: QuestionReview] = [:]
        var seeded: [String] = []
        for pid in ["science_class7", "maths_class7", "sanskrit_class7"] {
            guard let pack = registry.pack(withId: pid) else { continue }
            let fresh = assessableMCQIds(in: pack, count: 20)
                .filter { reviews[$0] == nil }.prefix(5)
            guard fresh.count == 5 else { continue }
            seeded.append(pid)
            for id in fresh { reviews[id] = weakReview(id, packId: pid, at: past) }
        }
        try XCTSkipUnless(seeded.count >= 2, "Need ≥2 subjects with topic questions.")
        store.questionReviews = reviews
        let before = srsSignature(store.questionReviews)

        let assessment = store.buildMilestoneAssessment(
            registry: registry, targetCount: 8, now: now)

        XCTAssertFalse(assessment.isEmpty)
        XCTAssertLessThanOrEqual(assessment.count, 8, "Capped at the target count.")
        XCTAssertGreaterThan(assessment.count, 0)

        // Spread: with ≥2 started subjects the quiz draws from ≥2 of them.
        let packs = Set(assessment.questions.map { $0.packId })
        XCTAssertGreaterThanOrEqual(packs.count, 2,
            "A mixed assessment must span multiple subjects.")
        XCTAssertTrue(packs.isSubset(of: Set(seeded)),
            "Only started (reviewed) subjects contribute.")

        // Unique ids; subjectCounts is consistent with the question list.
        XCTAssertEqual(Set(assessment.questions.map { $0.id }).count, assessment.count,
            "No duplicate questions in the assessment.")
        XCTAssertEqual(assessment.subjectCounts.values.reduce(0, +), assessment.count,
            "subjectCounts must tally exactly to the question list.")

        // Every resolved question genuinely lives in the pack it's credited to
        // (collision-safe), and carries non-empty display context.
        for q in assessment.questions {
            let pack = registry.pack(withId: q.packId)
            XCTAssertNotNil(pack, "Credited pack must exist.")
            let ids = pack.map { p in Set(p.chapters.flatMap { $0.topics.flatMap { $0.questions.map(\.id) } }) } ?? []
            XCTAssertTrue(ids.contains(q.question.id),
                "\(q.question.id) must belong to its credited pack \(q.packId).")
            XCTAssertFalse(q.subjectTitle.isEmpty)
            XCTAssertFalse(q.chapterTitle.isEmpty)
        }

        // Read-only over the SRS — building the assessment mutated nothing.
        XCTAssertEqual(srsSignature(store.questionReviews), before,
            "buildMilestoneAssessment must not mutate questionReviews.")
    }

    func testGapWeightingTestsTheWeakerSubjectMore() async throws {
        let registry = try await loadedRegistry()
        guard let weak = registry.pack(withId: "science_class7"),
              let strong = registry.pack(withId: "socialscience_class7") else {
            throw XCTSkip("Science + Social Science packs required.")
        }
        let store = tempStore()
        let now = Date()
        let past = now.addingTimeInterval(-3600)

        // Science (`chNN_…`) and Social Science (`sschNN_…`) have disjoint id
        // prefixes, so their MCQ pools never collide; a global `seen` set keeps
        // the two seed sets disjoint defensively, and each review's `packId`
        // credits it to exactly the intended subject.
        var seen = Set<String>()
        let weakIds = assessableMCQIds(in: weak, count: 40)
            .filter { seen.insert($0).inserted }.prefix(6)
        let strongIds = assessableMCQIds(in: strong, count: 40)
            .filter { seen.insert($0).inserted }.prefix(6)
        try XCTSkipUnless(weakIds.count == 6 && strongIds.count == 6,
            "Need 6 assessable MCQs in each of Science and Social Science.")

        var reviews: [String: QuestionReview] = [:]
        for id in weakIds { reviews[id] = weakReview(id, packId: weak.id, at: past) }
        for id in strongIds { reviews[id] = strongReview(id, packId: strong.id, at: past) }
        store.questionReviews = reviews

        // total (8) < capacity (12), so gap weighting actually bites.
        let assessment = store.buildMilestoneAssessment(
            registry: registry, targetCount: 8, now: now)

        let weakCount = assessment.subjectCounts[weak.id] ?? 0
        let strongCount = assessment.subjectCounts[strong.id] ?? 0
        XCTAssertGreaterThan(weakCount, strongCount,
            "The weaker subject (Science, all 'learning') must be tested more than the mastered one (Social Science).")
        XCTAssertEqual(assessment.count, 8)
        // The quiz leads with the weakest subject (weak-first round-robin).
        XCTAssertEqual(assessment.questions.first?.packId, weak.id,
            "The weakest subject leads the assessment order.")
    }
}
