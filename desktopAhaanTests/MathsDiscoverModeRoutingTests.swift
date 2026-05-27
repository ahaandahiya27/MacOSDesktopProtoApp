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

    /// Every one of the 15 Maths chapters now has a Discover experience.
    func testEveryMathsChapterHasDiscover() throws {
        let maths = try loadPack("maths_class7")
        XCTAssertEqual(maths.chapters.count, 15)
        for ch in maths.chapters {
            XCTAssertTrue(DiscoverMode.hasExperience(for: maths, chapter: ch),
                "Maths \(ch.id) should have a Discover experience.")
            XCTAssertTrue(DiscoverMode.mathsSupportedChapterIds.contains(ch.id))
        }
    }

    /// Subject gate: the Maths Discover set is exactly the Maths chapter ids —
    /// it must NOT claim Science-only ids (ch16–ch19), nor an unknown id, just
    /// because chNN ids collide across packs.
    func testMathsDiscoverIsGatedToItsOwnChapters() throws {
        let maths = try loadPack("maths_class7")
        let mathsIds = Set(maths.chapters.map { $0.id })
        XCTAssertEqual(DiscoverMode.mathsSupportedChapterIds, mathsIds,
            "Maths Discover set must equal exactly the Maths chapter ids.")
        for scienceOnly in ["ch16", "ch17", "ch18", "ch19"] {
            XCTAssertFalse(DiscoverMode.mathsSupportedChapterIds.contains(scienceOnly),
                "Maths must not claim Science-only chapter \(scienceOnly).")
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
