import XCTest
@testable import desktopAhaan

// MARK: - SocialScienceDiscoverModeRoutingTests
//
// Pins the Discover Mode wiring for the Social Science pack
// (`socialscience_class7`, DISCOVER stage 2026-05-31):
//   • every one of the 20 chapters has a Discover experience;
//   • the subject gate is exactly the SS chapter ids (no leak to/from
//     Science or Maths, whose chNN ids would collide if the gate were
//     pack-blind);
//   • the pack carries the content shape the generic 9-scene view depends on
//     (≥4 concepts + exactly 3 quick-checks + a non-empty boss quiz);
//   • the boss-quiz / scene-quick-check ids are recognised as ephemeral SRS
//     ids so Daily Practice "Retry" routes them back to the Discover scene.
@MainActor
final class SocialScienceDiscoverModeRoutingTests: XCTestCase {

    private let packId = "socialscience_class7"

    func testEverySocialScienceChapterHasDiscover() throws {
        let pack = try loadPack(packId)
        XCTAssertEqual(pack.chapters.count, 20)
        for ch in pack.chapters {
            XCTAssertTrue(DiscoverMode.hasExperience(for: pack, chapter: ch),
                "Social Science \(ch.id) should have a Discover experience.")
            XCTAssertTrue(DiscoverMode.socialScienceSupportedChapterIds.contains(ch.id),
                "\(ch.id) missing from socialScienceSupportedChapterIds.")
        }
    }

    /// Subject gate: the SS Discover set is exactly the SS chapter ids, and the
    /// Science/Maths gates never claim an `ssch*` id (and vice-versa).
    func testSocialScienceDiscoverIsGatedToItsOwnChapters() throws {
        let pack = try loadPack(packId)
        let ssIds = Set(pack.chapters.map { $0.id })
        XCTAssertEqual(DiscoverMode.socialScienceSupportedChapterIds, ssIds,
            "SS Discover set must equal exactly the SS chapter ids.")
        // Leak-gate: SS ids must not be claimed by the Science or Maths sets.
        for id in ssIds {
            XCTAssertFalse(DiscoverMode.supportedChapterIds.contains(id),
                "Science gate must not claim SS chapter \(id).")
            XCTAssertFalse(DiscoverMode.mathsSupportedChapterIds.contains(id),
                "Maths gate must not claim SS chapter \(id).")
        }
        // And the SS gate must not claim Science/Maths ids.
        for id in ["ch01", "ch02", "ch15", "ch19"] {
            XCTAssertFalse(DiscoverMode.socialScienceSupportedChapterIds.contains(id),
                "SS gate must not claim non-SS chapter \(id).")
        }
    }

    /// The generic SS Discover view derives a fixed 9-scene shape (Big Picture
    /// + 4 concepts + 3 quick-checks + Boss Quiz) from the pack. Pin the pack
    /// invariants the view's MCQ-aware selection relies on, so a future content
    /// edit can't silently degrade a chapter's Discover experience.
    func testEveryChapterCanFillTheNineSceneShape() throws {
        let pack = try loadPack(packId)
        func isRenderableMCQ(_ q: Question) -> Bool {
            guard q.questionType == .mcq else { return false }
            let opts = q.options ?? []
            return !opts.isEmpty && opts.contains(q.answer)
        }
        for ch in pack.chapters {
            let conceptCount = ch.topics.reduce(0) { $0 + $1.concepts.count }
            XCTAssertGreaterThanOrEqual(conceptCount, 4,
                "\(ch.id) needs ≥4 concepts for the 4 concept scenes.")

            // Boss Quiz draws from MCQ boss questions only — need enough to
            // feel like a quiz.
            let bossMCQs = ch.bossQuestionsList.filter(isRenderableMCQ)
            XCTAssertGreaterThanOrEqual(bossMCQs.count, 5,
                "\(ch.id) needs ≥5 MCQ boss questions for the Boss Quiz.")

            // Quick-checks draw from scenecheck + topic + boss MCQs (deduped),
            // and must be able to reach 3 distinct items.
            let pool = ch.quickCheckQuestionsList.filter(isRenderableMCQ)
                + ch.topics.flatMap { $0.questions }.filter(isRenderableMCQ)
                + bossMCQs
            let distinct = Set(pool.map { $0.id })
            XCTAssertGreaterThanOrEqual(distinct.count, 3,
                "\(ch.id) needs ≥3 distinct MCQs for the quick-check scenes.")
        }
    }

    /// SRS prefix recognition: the SS boss-quiz / scene-quick-check ids are
    /// authored into the pack and must be recognised as ephemeral so the
    /// Retry router treats them correctly.
    func testSocialScienceEphemeralIdsAreRecognised() throws {
        let pack = try loadPack(packId)
        XCTAssertTrue(DataStore.ephemeralIdPrefixes.contains("bossquiz_ssch"))
        XCTAssertTrue(DataStore.ephemeralIdPrefixes.contains("scenecheck_ssch"))
        var checkedBoss = false
        var checkedScene = false
        for ch in pack.chapters {
            for q in ch.bossQuestionsList {
                XCTAssertTrue(q.id.hasPrefix("bossquiz_ssch"),
                    "Boss id \(q.id) must use the bossquiz_ssch prefix.")
                XCTAssertTrue(DataStore.isEphemeralReviewId(q.id),
                    "\(q.id) should be recognised as ephemeral.")
                checkedBoss = true
            }
            for q in ch.quickCheckQuestionsList {
                XCTAssertTrue(q.id.hasPrefix("scenecheck_ssch"),
                    "Quick-check id \(q.id) must use the scenecheck_ssch prefix.")
                XCTAssertTrue(DataStore.isEphemeralReviewId(q.id),
                    "\(q.id) should be recognised as ephemeral.")
                checkedScene = true
            }
        }
        XCTAssertTrue(checkedBoss && checkedScene, "Expected boss + scene ids to exist.")
    }

    // MARK: - Helpers

    private func loadPack(_ resource: String) throws -> SubjectPack {
        guard let url = Bundle.main.url(forResource: resource, withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            throw XCTSkip("\(resource).json missing from test bundle.")
        }
        return try JSONDecoder().decode(SubjectPack.self, from: data)
    }
}
