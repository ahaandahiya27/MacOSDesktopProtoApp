import XCTest
@testable import desktopAhaan

// MARK: - ExpertChallengeOlympiadContentTests
//
// Phase-5 capstone for the Olympiad-content authoring run. The Expert Challenge
// ladder's top "Olympiad" tier is fed exclusively by the authored
// `deepDive.bonusQuestions` across the four packs (a `deepDive` bonus question is
// always classified Olympiad — see `ExpertTier.classify(band:isDeepDive:)`).
//
// Before this run those arrays were `null`/absent, so the Olympiad tier was
// empty for every subject. These tests pin two things so it can never silently
// regress:
//   1. CONTENT — every `deepDive.bonusQuestions` entry in every pack is a
//      gradable MCQ (a real `options` set, the `answer` present in it) with at
//      least two variations and a beyond-grade difficulty (4 or 5). A wrong key
//      or a non-MCQ would make the ladder un-gradable.
//   2. WIRING — building the live Expert Challenge ladder yields a NON-EMPTY
//      Olympiad tier for every subject pack, proving the authored content
//      actually reaches the tier the UI shows.
//
// Read-only over the SRS: the ladder is built on a fresh, unseeded temp store,
// exactly like `LearningJourneyReadOnlyTests`.

final class ExpertChallengeOlympiadContentTests: XCTestCase {

    /// Spin up a SubjectRegistry and wait briefly for the bundled packs to load.
    @MainActor
    private func loadedRegistry() async throws -> SubjectRegistry {
        let registry = SubjectRegistry()
        for _ in 0..<25 {
            if !registry.isLoading && !registry.packs.isEmpty { break }
            try await Task.sleep(nanoseconds: 100_000_000) // 0.1 s
        }
        guard !registry.packs.isEmpty else { throw XCTSkip("No packs loaded in 2.5 s.") }
        return registry
    }

    @MainActor
    private func tempStore() -> DataStore {
        let dir = FileManager.default.temporaryDirectory
            .appendingPathComponent("olympiad-content-tests-\(UUID().uuidString)", isDirectory: true)
        return DataStore(streakCalendar: nil, storeDir: dir, autoLoad: false)
    }

    // MARK: - 1. Content: every authored bonus question is a gradable, beyond-grade MCQ

    @MainActor
    func testEveryDeepDiveBonusQuestionIsAGradableBeyondGradeMCQ() async throws {
        let registry = try await loadedRegistry()
        var totalBonus = 0
        var seenIds = Set<String>()

        for pack in registry.packs {
            for chapter in pack.chapters {
                for topic in chapter.deepDiveList {
                    for q in (topic.bonusQuestions ?? []) {
                        totalBonus += 1
                        XCTAssertTrue(seenIds.insert(q.id).inserted,
                                      "Duplicate bonus-question id \(q.id) in \(pack.id).")
                        XCTAssertEqual(q.questionType, .mcq,
                                       "Olympiad bonus \(q.id) must be .mcq so the ladder can grade it by one tap.")
                        let options = q.options ?? []
                        XCTAssertGreaterThanOrEqual(options.count, 2,
                                       "Olympiad bonus \(q.id) needs real MCQ options.")
                        XCTAssertTrue(options.contains(q.answer),
                                       "Olympiad bonus \(q.id) answer must be one of its options.")
                        XCTAssertGreaterThanOrEqual(q.variations.count, 2,
                                       "Olympiad bonus \(q.id) needs >= 2 variations (pack-schema rule).")
                        XCTAssertTrue(q.difficulty == 4 || q.difficulty == 5,
                                       "Olympiad bonus \(q.id) should be beyond-grade (difficulty 4 or 5), got \(q.difficulty).")
                        XCTAssertTrue(DataStore.isAssessableMCQ(q),
                                       "Olympiad bonus \(q.id) must be an assessable MCQ to reach the ladder.")
                    }
                }
            }
        }
        // The run authored Science 114 + Maths 90 + Sanskrit 90 + Social Science 240.
        XCTAssertGreaterThanOrEqual(totalBonus, 500,
            "Expected the full authored set of Olympiad bonus questions; found \(totalBonus).")
    }

    // MARK: - 2. Wiring: the live ladder's Olympiad tier is non-empty for every subject

    @MainActor
    func testEverySubjectYieldsANonEmptyOlympiadTier() async throws {
        let registry = try await loadedRegistry()
        let store = tempStore()
        let now = Date(timeIntervalSince1970: 1_700_000_000)

        let ladder = store.buildExpertChallengeLadder(registry: registry, now: now)
        XCTAssertEqual(ladder.subjects.count, registry.packs.count,
                       "Every pack should appear in the ladder.")

        for subject in ladder.subjects {
            guard let olympiad = subject.tiers.first(where: { $0.tier == .olympiad }) else {
                XCTFail("\(subject.packId) has no Olympiad tier set.")
                continue
            }
            XCTAssertGreaterThan(olympiad.questions.count, 0,
                "\(subject.packId) Olympiad tier is empty — authored deepDive.bonusQuestions are not reaching it.")
        }
    }
}
