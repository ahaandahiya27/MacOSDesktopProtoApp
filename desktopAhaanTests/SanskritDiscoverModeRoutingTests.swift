import XCTest
@testable import desktopAhaan

// MARK: - SanskritDiscoverModeRoutingTests
//
// Pins the Discover Mode wiring for the Sanskrit pack (`sanskrit_class7`,
// P1-E build-out of the v6 Learning Journey):
//   • each of the 15 NEP chapters (`sch01`–`sch15`) has a Discover experience;
//   • the legacy `ch01` vocabulary deck (the documented carve-out) does NOT;
//   • the subject gate is exactly the NEP chapter ids — no leak to/from
//     Science, Maths, or Social Science (whose chNN/sschNN ids would collide
//     if the gate were pack-blind);
//   • the pack carries the content shape the generic 9-scene view depends on
//     (≥3 concepts + ≥3 glossary pairs for the word-match + a real MCQ boss
//     quiz + ≥3 distinct quick-check MCQs);
//   • Sanskrit boss ids are REAL pack rows (`bossquiz_sch*`) that resolve via
//     the SubjectRegistry — NOT synthetic ephemeral ids — so recording works
//     through the canonical review path.
@MainActor
final class SanskritDiscoverModeRoutingTests: XCTestCase {

    private let packId = "sanskrit_class7"

    /// The 15 NEP chapters have Discover; the legacy `ch01` deck does not.
    func testEveryNEPChapterHasDiscoverAndLegacyDeckDoesNot() throws {
        let pack = try loadPack(packId)
        XCTAssertEqual(pack.chapters.count, 16, "Expected legacy ch01 + 15 NEP chapters.")
        for ch in pack.chapters {
            if ch.id == "ch01" {
                XCTAssertFalse(DiscoverMode.hasExperience(for: pack, chapter: ch),
                    "Legacy Sanskrit vocabulary deck (ch01) must NOT have a Discover experience.")
            } else {
                XCTAssertTrue(DiscoverMode.hasExperience(for: pack, chapter: ch),
                    "Sanskrit \(ch.id) should have a Discover experience.")
                XCTAssertTrue(DiscoverMode.sanskritSupportedChapterIds.contains(ch.id),
                    "\(ch.id) missing from sanskritSupportedChapterIds.")
            }
        }
    }

    /// Subject gate: the Sanskrit Discover set is exactly the 15 NEP ids, and
    /// the Science / Maths / Social Science gates never claim an `sch*` id
    /// (and vice-versa).
    func testSanskritDiscoverIsGatedToItsOwnChapters() throws {
        let pack = try loadPack(packId)
        let nepIds = Set(pack.chapters.map { $0.id }).subtracting(["ch01"])
        XCTAssertEqual(DiscoverMode.sanskritSupportedChapterIds, nepIds,
            "Sanskrit Discover set must equal exactly the 15 NEP chapter ids.")
        XCTAssertEqual(DiscoverMode.sanskritSupportedChapterIds.count, 15)
        XCTAssertFalse(DiscoverMode.sanskritSupportedChapterIds.contains("ch01"),
            "Sanskrit Discover gate must not claim the legacy ch01 deck.")
        // Leak-gate: the Sanskrit ids must not be claimed by the other subjects.
        for id in nepIds {
            XCTAssertFalse(DiscoverMode.supportedChapterIds.contains(id),
                "Science gate must not claim Sanskrit chapter \(id).")
            XCTAssertFalse(DiscoverMode.mathsSupportedChapterIds.contains(id),
                "Maths gate must not claim Sanskrit chapter \(id).")
            XCTAssertFalse(DiscoverMode.socialScienceSupportedChapterIds.contains(id),
                "Social Science gate must not claim Sanskrit chapter \(id).")
        }
        // And the Sanskrit gate must not claim other subjects' ids.
        for id in ["ch15", "ch19", "ssch01", "ssch20"] {
            XCTAssertFalse(DiscoverMode.sanskritSupportedChapterIds.contains(id),
                "Sanskrit gate must not claim non-Sanskrit chapter \(id).")
        }
    }

    /// The generic Sanskrit Discover view derives a fixed 9-scene shape from
    /// the pack (Big Picture + 3 concepts + word-match + 3 quick-checks + Boss
    /// Quiz). Pin the per-chapter invariants the view relies on so a future
    /// content edit can't silently degrade a chapter's experience.
    func testEveryNEPChapterCanFillTheSceneShape() throws {
        let pack = try loadPack(packId)
        func isRenderableMCQ(_ q: Question) -> Bool {
            guard q.questionType == .mcq else { return false }
            let opts = q.options ?? []
            return !opts.isEmpty && opts.contains(q.answer)
        }
        for ch in pack.chapters where ch.id != "ch01" {
            let conceptCount = ch.topics.reduce(0) { $0 + $1.concepts.count }
            XCTAssertGreaterThanOrEqual(conceptCount, 3,
                "\(ch.id) needs ≥3 concepts for the concept scenes.")

            // Word-match: ≥3 glossary entries with non-empty term + definition.
            let eligible = ch.glossaryList.filter {
                !$0.term.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                    && !$0.definition.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            }
            XCTAssertGreaterThanOrEqual(eligible.count, 3,
                "\(ch.id) needs ≥3 usable glossary entries for the word-match game.")

            // Boss Quiz draws from MCQ boss questions only.
            let bossMCQs = ch.bossQuestionsList.filter(isRenderableMCQ)
            XCTAssertGreaterThanOrEqual(bossMCQs.count, 5,
                "\(ch.id) needs ≥5 MCQ boss questions for the Boss Quiz.")

            // Quick-checks draw from quickCheck + topic + boss MCQs (deduped),
            // and must reach 3 distinct items.
            let pool = ch.quickCheckQuestionsList.filter(isRenderableMCQ)
                + ch.topics.flatMap { $0.questions }.filter(isRenderableMCQ)
                + bossMCQs
            let distinct = Set(pool.map { $0.id })
            XCTAssertGreaterThanOrEqual(distinct.count, 3,
                "\(ch.id) needs ≥3 distinct MCQs for the quick-check scenes.")
        }
    }

    /// Sanskrit boss questions are real pack rows (`bossquiz_sch*`), resolved
    /// through the SubjectRegistry — NOT synthetic ephemeral ids. This pins the
    /// design decision (and guards the `bossquiz_sch` vs `bossquiz_ch` prefix
    /// boundary that keeps Sanskrit review state distinct from Science).
    func testSanskritBossIdsAreCanonicalNotEphemeral() throws {
        let pack = try loadPack(packId)
        var checked = false
        for ch in pack.chapters where ch.id != "ch01" {
            for q in ch.bossQuestionsList {
                XCTAssertTrue(q.id.hasPrefix("bossquiz_sch"),
                    "Boss id \(q.id) must use the bossquiz_sch prefix.")
                XCTAssertFalse(DataStore.isEphemeralReviewId(q.id),
                    "\(q.id) must NOT be treated as ephemeral — it is a real pack row resolved via the registry.")
                checked = true
            }
        }
        XCTAssertTrue(checked, "Expected NEP boss questions to exist.")
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
