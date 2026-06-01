import XCTest
@testable import desktopAhaan

// MARK: - SocialScienceInteractiveGateTests
//
// Pins the leak-gate for the Social Science (`socialscience_class7`) bespoke
// interactives (INTERACTIVE stage, 2026-05-31). The SS interactives mount
// through the pure `socialScienceInteractivesAreEnabled(forPackId:)` helper,
// kept SEPARATE from the Science `pilotInteractivesAreEnabled` gate. This test
// asserts the two gates never overlap, so:
//   • Social Science interactives never appear under Science/Maths/Sanskrit;
//   • the hardcoded Science sandboxes/tours never appear under Social Science.
final class SocialScienceInteractiveGateTests: XCTestCase {

    func testSocialScienceGateEnabledForSSPackOnly() {
        XCTAssertTrue(socialScienceInteractivesAreEnabled(forPackId: "socialscience_class7"),
            "SS interactives belong to the Social Science pack.")
        for other in ["science_class7", "maths_class7", "sanskrit_class7"] {
            XCTAssertFalse(socialScienceInteractivesAreEnabled(forPackId: other),
                "SS interactives must NOT mount for \(other).")
        }
    }

    /// The two gates are mutually exclusive: no pack may enable BOTH the
    /// Science pilot mounts and the Social Science mounts.
    func testScienceAndSocialScienceGatesAreMutuallyExclusive() throws {
        for resource in ["science_class7", "maths_class7", "sanskrit_class7", "socialscience_class7"] {
            guard let pack = try? loadPack(resource) else {
                throw XCTSkip("\(resource).json not in test bundle.")
            }
            let science = pilotInteractivesAreEnabled(forPackId: pack.id)
            let ss = socialScienceInteractivesAreEnabled(forPackId: pack.id)
            XCTAssertFalse(science && ss,
                "\(pack.id) must not enable both gates — that would leak widgets across subjects.")
        }
    }

    /// The Social Science pack must NOT enable the Science pilot gate (the
    /// reverse leak — Build-A-Plant et al. into Social Science chapters).
    func testSocialSciencePackDoesNotEnableSciencePilot() throws {
        let pack = try loadPack("socialscience_class7")
        XCTAssertFalse(pilotInteractivesAreEnabled(forPackId: pack.id),
            "Science pilot interactives must NOT mount on Social Science chapters.")
        for chapter in pack.chapters {
            XCTAssertTrue(chapter.id.hasPrefix("ssch"),
                "Sanity: SS chapter \(chapter.id) should carry the ssch prefix.")
        }
    }

    /// Every chapter wired to the chronology challenge must actually carry a
    /// timeline with ≥2 steps, else the interactive silently hides. Authored
    /// timelines are also expected to be chronological (the puzzle's premise).
    func testChronologyChaptersHaveUsableTimelines() throws {
        let pack = try loadPack("socialscience_class7")
        let byId = Dictionary(uniqueKeysWithValues: pack.chapters.map { ($0.id, $0) })
        for id in socialScienceChronologyChapterIds {
            guard let ch = byId[id] else {
                XCTFail("Chronology chapter \(id) not found in pack."); continue
            }
            guard let tl = ch.timelinesList.first else {
                XCTFail("\(id) is wired to the chronology challenge but has no timeline."); continue
            }
            XCTAssertGreaterThanOrEqual(tl.steps.count, 2,
                "\(id) timeline needs ≥2 steps for an ordering challenge.")
        }
    }

    /// Coverage: EVERY Social Science chapter must resolve to a renderable
    /// interactive — it is ssch01 (relief), ssch10 (Preamble explorer),
    /// ssch11 (barter), ssch12 (market price balance), ssch18 (three-organs
    /// sorter), ssch20 (compounding growth), a chronology chapter with a usable
    /// timeline, OR a chapter with a usable glossary (the default match
    /// challenge). No chapter may fall through to nothing.
    func testEveryChapterResolvesToAnInteractive() throws {
        let pack = try loadPack("socialscience_class7")
        for ch in pack.chapters {
            let bespoke = ch.id == "ssch01" || ch.id == "ssch11"
                || ch.id == "ssch10" || ch.id == "ssch12"
                || ch.id == "ssch18" || ch.id == "ssch20"
            let chronology = socialScienceChronologyChapterIds.contains(ch.id)
                && (ch.timelinesList.first?.steps.count ?? 0) >= 2
            let glossary = ch.glossaryList.count >= 2
            XCTAssertTrue(bespoke || chronology || glossary,
                "\(ch.id) has no renderable interactive (no bespoke widget, no usable timeline, no glossary).")
        }
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
