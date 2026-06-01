import XCTest
@testable import desktopAhaan

// MARK: - ExpertChallengeIntegrationTests
//
// v6 Learning Journey · Phase 5. Drives the live `SubjectRegistry` through
// `@MainActor buildExpertChallengeLadder` on an ISOLATED temp store. Proves the
// tier structure, the band-based classification, the per-tier cap, mastery
// unlocking, and the read-only-over-SRS contract.
@MainActor
final class ExpertChallengeIntegrationTests: XCTestCase {

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
            .appendingPathComponent("ecl-\(UUID().uuidString)")
        return DataStore(streakCalendar: nil, storeDir: dir, autoLoad: false)
    }

    private func masteredReview(_ id: String, packId: String, at: Date) -> QuestionReview {
        QuestionReview(questionId: id, bucket: 5, ease: 2.6, intervalDays: 30,
                       lastReviewedAt: at, nextDueAt: at.addingTimeInterval(30 * 86_400),
                       totalReviews: 6, lapses: 0, packId: packId)
    }

    private func srsSignature(_ reviews: [String: QuestionReview]) -> [String: String] {
        reviews.mapValues { "\($0.totalReviews)|\($0.bucket)|\($0.nextDueAt.timeIntervalSince1970)" }
    }

    private func anyTopicIds(in pack: SubjectPack, count: Int) -> [String] {
        var out: [String] = []
        for chapter in pack.chapters {
            for topic in chapter.topics {
                for q in topic.questions { out.append(q.id); if out.count >= count { return out } }
            }
        }
        return out
    }

    // MARK: - Structure + classification + read-only

    func testLadderStructureClassificationAndReadOnly() async throws {
        let registry = try await loadedRegistry()
        let store = tempStore()
        let before = srsSignature(store.questionReviews)

        let ladder = store.buildExpertChallengeLadder(registry: registry)

        XCTAssertEqual(ladder.subjects.count, registry.packs.count,
            "One ladder row per registry subject.")

        for subject in ladder.subjects {
            // Always exactly the three tiers, in escalating order.
            XCTAssertEqual(subject.tiers.map { $0.tier }, [.stretch, .challenge, .olympiad])
            // Empty store → mastery 0 → every tier locked.
            XCTAssertTrue(subject.tiers.allSatisfy { !$0.isUnlocked },
                "With no reviews, every tier is locked.")

            var seenInSubject = Set<String>()
            for set in subject.tiers {
                XCTAssertLessThanOrEqual(set.count, DataStore.expertChallengeTierCap,
                    "Each tier is capped.")
                for q in set.questions {
                    XCTAssertTrue(DataStore.isAssessableMCQ(q.question),
                        "Every ladder question is a gradable MCQ.")
                    XCTAssertTrue(seenInSubject.insert(q.id).inserted,
                        "No question appears twice within a subject's ladder.")
                }
                // Band-classified tiers must match their band.
                if set.tier == .stretch {
                    XCTAssertTrue(set.questions.allSatisfy { $0.question.intrinsicBand == .stretch })
                } else if set.tier == .challenge {
                    XCTAssertTrue(set.questions.allSatisfy { $0.question.intrinsicBand == .challenge })
                }
            }
        }

        // There ARE difficulty 4/5 questions in the bank, so the ladder isn't empty.
        XCTAssertFalse(ladder.isEmpty, "Expert-grade questions exist in the content.")

        // Read-only over the SRS.
        XCTAssertEqual(srsSignature(store.questionReviews), before,
            "buildExpertChallengeLadder must not mutate questionReviews.")
    }

    // MARK: - Unlock tracks mastery

    func testTiersUnlockWithSubjectMastery() async throws {
        let registry = try await loadedRegistry()
        guard let science = registry.pack(withId: "science_class7") else {
            throw XCTSkip("Science pack required.")
        }
        let store = tempStore()
        let now = Date()

        // Seed Science fully mastered (fraction ≈ 1.0) → all of its tiers unlock.
        let ids = anyTopicIds(in: science, count: 6)
        try XCTSkipUnless(ids.count >= 4, "Need a few Science topic questions.")
        var reviews: [String: QuestionReview] = [:]
        for id in ids { reviews[id] = masteredReview(id, packId: science.id, at: now) }
        store.questionReviews = reviews

        let ladder = store.buildExpertChallengeLadder(registry: registry, now: now)
        guard let sci = ladder.subjects.first(where: { $0.packId == science.id }) else {
            return XCTFail("Science must appear in the ladder.")
        }
        XCTAssertGreaterThanOrEqual(sci.masteryFraction, 0.80,
            "All-mastered reviews give a high mastery fraction.")
        XCTAssertTrue(sci.tiers.allSatisfy { $0.isUnlocked },
            "A mastered subject unlocks every tier.")
        XCTAssertTrue(sci.hasPlayableTier,
            "With unlocked tiers holding questions, Science has a playable challenge.")

        // An untouched subject stays fully locked.
        if let other = ladder.subjects.first(where: { !$0.hasStarted }) {
            XCTAssertTrue(other.tiers.allSatisfy { !$0.isUnlocked },
                "An unstarted subject's tiers are all locked.")
        }
    }
}
