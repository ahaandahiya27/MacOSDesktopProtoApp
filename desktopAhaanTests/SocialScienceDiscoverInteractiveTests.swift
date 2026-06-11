import XCTest
@testable import desktopAhaan

// MARK: - SocialScienceDiscoverInteractiveTests
//
// Pins the v8 bespoke GATED interactive added to the Social Science Discover
// flow (2026-06-11) — the piece that brought SS to parity with the other three
// subjects' Discover experiences:
//   • History chapters get `SSDiscoverChronologyScene` (tap events earliest →
//     latest), so each must ship a timeline with ≥3 steps;
//   • every other chapter gets `SSDiscoverWordMatchScene`, so each must ship
//     ≥3 usable glossary pairs (non-empty term AND definition);
//   • the deterministic scramble must always be a valid permutation that is
//     NEVER the trivial identity order (which would make the game a no-op).
@MainActor
final class SocialScienceDiscoverInteractiveTests: XCTestCase {

    private let packId = "socialscience_class7"

    /// MUST stay in sync with `DiscoverChapterSocialScienceView.chronologyChapterIds`
    /// (which is `private`). The dispatch test below pins the content each branch
    /// of that gate relies on, so a divergence surfaces here as a content failure.
    private let chronologyChapterIds: Set<String> = [
        "ssch04", "ssch05", "ssch06", "ssch07", "ssch15", "ssch16"
    ]

    func testEveryChapterCanBuildItsGatedInteractive() throws {
        let pack = try loadPack(packId)
        for ch in pack.chapters {
            if chronologyChapterIds.contains(ch.id) {
                guard let tl = ch.timelinesList.first else {
                    return XCTFail("\(ch.id) is a chronology chapter but has no timeline.")
                }
                XCTAssertGreaterThanOrEqual(tl.steps.count, 3,
                    "\(ch.id) chronology needs a timeline with ≥3 steps; got \(tl.steps.count).")
            } else {
                let pairs = ch.glossaryList.filter {
                    !$0.term.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                        && !$0.definition.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                }
                XCTAssertGreaterThanOrEqual(pairs.count, 3,
                    "\(ch.id) word-match needs ≥3 usable glossary pairs; got \(pairs.count).")
            }
        }
    }

    func testScrambleIsAValidNonIdentityPermutation() {
        for count in 2...12 {
            let order = SSDiscoverChronologyScene.scramble(count: count)
            XCTAssertEqual(order.count, count, "scramble(\(count)) must return \(count) indices.")
            XCTAssertEqual(Set(order), Set(0..<count),
                "scramble(\(count)) must be a permutation of 0..<\(count); got \(order).")
            XCTAssertNotEqual(order, Array(0..<count),
                "scramble(\(count)) must NOT be the identity order — that would make the timeline game trivial.")
        }
    }

    func testScrambleIsDeterministic() {
        // Stable across calls (no RNG) so the scene doesn't reshuffle on redraw.
        for count in [2, 5, 8] {
            XCTAssertEqual(SSDiscoverChronologyScene.scramble(count: count),
                           SSDiscoverChronologyScene.scramble(count: count),
                           "scramble(\(count)) must be deterministic.")
        }
    }

    func testScrambleHandlesDegenerateCounts() {
        XCTAssertEqual(SSDiscoverChronologyScene.scramble(count: 0), [])
        XCTAssertEqual(SSDiscoverChronologyScene.scramble(count: 1), [0])
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
