import XCTest
@testable import desktopAhaan

// MARK: - MathsDiscoverModeRoutingTests
//
// Pins the SUBJECT gate on Discover Mode after wiring Maths Ch.1
// (DiscoverChapterMath1View). Maths chapter ids (chNN) collide with Science's,
// so DiscoverMode.hasExperience MUST discriminate by pack.id — the same
// chapter id resolves differently per subject:
//   - Maths Discover set is {ch01, ch10}; everything else → no Discover.
//   - Science Discover set is all 19 chapters.
// The decisive assertion is ch02: Science ch02 HAS Discover, Maths ch02 does
// NOT — so a pack-blind gate (the old chapter.id-only bug class) would fail here.
@MainActor
final class MathsDiscoverModeRoutingTests: XCTestCase {

    func testMathsDiscoverChaptersHaveExperience() throws {
        let maths = try loadPack("maths_class7")
        for id in ["ch01", "ch08", "ch10"] {
            XCTAssertTrue(DiscoverMode.hasExperience(for: maths, chapter: chapter(maths, id)),
                "Maths \(id) should have a Discover experience.")
            XCTAssertTrue(DiscoverMode.mathsSupportedChapterIds.contains(id))
        }
    }

    /// Subject gate: a chapter id that has Discover in SCIENCE must NOT light up
    /// in MATHS just because the ids collide.
    func testMathsDiscoverIsGatedToItsOwnChapters() throws {
        let maths = try loadPack("maths_class7")
        let science = try loadPack("science_class7")

        XCTAssertFalse(DiscoverMode.hasExperience(for: maths, chapter: chapter(maths, "ch02")),
            "Maths Ch.2 has no Discover experience — must not inherit Science Ch.2's.")
        XCTAssertTrue(DiscoverMode.hasExperience(for: science, chapter: chapter(science, "ch02")),
            "Science Ch.2 does have Discover — confirms the gate discriminates by pack, not chapter id.")
    }

    // MARK: - Helpers

    private func chapter(_ pack: SubjectPack, _ id: String) -> Chapter {
        // Force-unwrap is fine in a test: the pack is bundled and the id is known.
        pack.chapters.first { $0.id == id }!
    }

    private func loadPack(_ resource: String) throws -> SubjectPack {
        guard let url = Bundle.main.url(forResource: resource, withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            throw XCTSkip("\(resource).json missing from test bundle.")
        }
        return try JSONDecoder().decode(SubjectPack.self, from: data)
    }
}
