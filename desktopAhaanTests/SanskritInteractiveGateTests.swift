import XCTest
@testable import desktopAhaan

// MARK: - SanskritInteractiveGateTests
//
// Pins the leak-gate for the Sanskrit (`sanskrit_class7`) bespoke interactive
// (the शब्द–अर्थ word↔meaning match, v7 Phase 2). The Sanskrit interactive
// mounts through the pure `sanskritInteractivesAreEnabled(forPackId:)` helper,
// kept SEPARATE from the Science `pilotInteractivesAreEnabled` and Social
// Science `socialScienceInteractivesAreEnabled` gates. This test asserts the
// three gates never overlap, so:
//   • the Sanskrit interactive never appears under Science/Maths/Social Science;
//   • the Science sandboxes/tours and SS explorers never appear under Sanskrit;
//   • the legacy `ch01` vocabulary deck (NEP carve-out) gets no interactive.
final class SanskritInteractiveGateTests: XCTestCase {

    func testSanskritGateEnabledForSanskritPackOnly() {
        XCTAssertTrue(sanskritInteractivesAreEnabled(forPackId: "sanskrit_class7"),
            "Sanskrit interactive belongs to the Sanskrit pack.")
        for other in ["science_class7", "maths_class7", "socialscience_class7"] {
            XCTAssertFalse(sanskritInteractivesAreEnabled(forPackId: other),
                "Sanskrit interactive must NOT mount for \(other).")
        }
    }

    /// The three subject gates are mutually exclusive: no pack may enable more
    /// than one, so no widget can leak across subjects.
    func testSubjectGatesAreMutuallyExclusive() throws {
        for resource in ["science_class7", "maths_class7", "sanskrit_class7", "socialscience_class7"] {
            guard let pack = try? loadPack(resource) else {
                throw XCTSkip("\(resource).json not in test bundle.")
            }
            let science = pilotInteractivesAreEnabled(forPackId: pack.id)
            let ss = socialScienceInteractivesAreEnabled(forPackId: pack.id)
            let sanskrit = sanskritInteractivesAreEnabled(forPackId: pack.id)
            let enabledCount = [science, ss, sanskrit].filter { $0 }.count
            XCTAssertLessThanOrEqual(enabledCount, 1,
                "\(pack.id) enables \(enabledCount) subject gates — that would leak widgets across subjects.")
        }
    }

    /// The Sanskrit pack must NOT enable the Science pilot or the SS gate (the
    /// reverse leaks). And every chapter should carry a `ch`/`sch` id.
    func testSanskritPackDoesNotEnableOtherGates() throws {
        let pack = try loadPack("sanskrit_class7")
        XCTAssertFalse(pilotInteractivesAreEnabled(forPackId: pack.id),
            "Science pilot interactives must NOT mount on Sanskrit chapters.")
        XCTAssertFalse(socialScienceInteractivesAreEnabled(forPackId: pack.id),
            "Social Science explorers must NOT mount on Sanskrit chapters.")
    }

    /// Coverage: every NEP Sanskrit chapter (`sch01`–`sch15`) must resolve to a
    /// renderable interactive — i.e. carry a glossary with ≥2 terms, the mount
    /// condition in `sanskritInteractives(pack:chapter:)`. The legacy `ch01`
    /// deck is intentionally EXCLUDED (it has no `sch` prefix), matching the
    /// NEP carve-out documented in CLAUDE.md.
    func testEveryNEPChapterResolvesToTheInteractive() throws {
        let pack = try loadPack("sanskrit_class7")
        var nepCount = 0
        for ch in pack.chapters {
            if ch.id.hasPrefix("sch") {
                nepCount += 1
                XCTAssertGreaterThanOrEqual(ch.glossaryList.count, 2,
                    "\(ch.id) is a NEP chapter but lacks a ≥2-term glossary for the शब्द–अर्थ match.")
            } else {
                // Legacy carve-out: the bare `ch01` vocabulary deck gets no
                // bespoke interactive (its id has no `sch` prefix).
                XCTAssertEqual(ch.id, "ch01",
                    "Unexpected non-NEP Sanskrit chapter id \(ch.id).")
            }
        }
        XCTAssertEqual(nepCount, 15,
            "Expected 15 NEP Sanskrit chapters (sch01–sch15); found \(nepCount).")
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
