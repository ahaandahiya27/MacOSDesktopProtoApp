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

    // MARK: - Helpers

    private func loadPack(_ resource: String) throws -> SubjectPack {
        guard let url = Bundle.main.url(forResource: resource, withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            throw XCTSkip("\(resource).json missing from test bundle.")
        }
        return try JSONDecoder().decode(SubjectPack.self, from: data)
    }
}
