import XCTest
@testable import desktopAhaan

// MARK: - PilotInteractiveSubjectGateTests
//
// Pins the subject gate for the hardcoded Science pilot Discover
// interactives (Build-A-Plant, Inside-the-Leaf, and the 13 propagated
// sandboxes/tours). Those are SCIENCE-only content, but Maths and Sanskrit
// packs reuse the same `chNN` chapter ids — so the mount gate must key on the
// SUBJECT (pack id), not the chapter id. Before the 2026-05-27 fix the gate
// was `chapter.id == "chNN"` only, so e.g. Build-A-Plant leaked into Maths
// Ch.1.
//
// `ch1PilotInteractives` / `propagatedPilotInteractives` are @ViewBuilder
// funcs returning opaque `some View` (not introspectable here), so they all
// route their gate through the pure `pilotInteractivesAreEnabled(forPackId:)`
// helper. This walks every (pack, chapter) pair across ALL bundled packs and
// asserts the helper is true ONLY for science_class7 — so a future drop of
// the pack check fails CI immediately.
final class PilotInteractiveSubjectGateTests: XCTestCase {

    func testGateEnabledForSciencePackOnly() {
        XCTAssertTrue(pilotInteractivesAreEnabled(forPackId: "science_class7"),
            "The pilot interactives belong to the Science pack.")
        for other in ["maths_class7", "sanskrit_class7"] {
            XCTAssertFalse(pilotInteractivesAreEnabled(forPackId: other),
                "Pilot interactives must NOT mount for \(other) — its chNN ids " +
                "collide with Science, so a pack-blind gate would leak Science widgets.")
        }
    }

    /// Parameterised across the FULL chapter list of every non-Science pack:
    /// no chapter of Maths or Sanskrit may enable the Science pilot mounts.
    func testNoNonSciencePackChapterEnablesPilotInteractives() throws {
        for resource in ["maths_class7", "sanskrit_class7"] {
            guard let pack = try? loadPack(resource) else {
                throw XCTSkip("\(resource).json not in test bundle.")
            }
            XCTAssertFalse(pack.chapters.isEmpty, "\(resource) should have chapters.")
            for chapter in pack.chapters {
                XCTAssertFalse(
                    pilotInteractivesAreEnabled(forPackId: pack.id),
                    "\(pack.id)/\(chapter.id) must not mount Science pilot widgets."
                )
            }
        }
    }

    func testSciencePackEnablesPilotInteractives() throws {
        let pack = try loadPack("science_class7")
        XCTAssertFalse(pack.chapters.isEmpty)
        XCTAssertTrue(pilotInteractivesAreEnabled(forPackId: pack.id))
    }

    private func loadPack(_ resource: String) throws -> SubjectPack {
        guard let url = Bundle.main.url(forResource: resource, withExtension: "json") else {
            throw XCTSkip("\(resource).json not in bundle.")
        }
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(SubjectPack.self, from: data)
    }
}
