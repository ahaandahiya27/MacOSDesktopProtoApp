import XCTest
@testable import desktopAhaan

/// Ratchets the per-chapter density of the nine enrichment surfaces
/// (`glossary`, `mnemonics`, `misconceptions`, `realWorldExamples`,
/// `ncertQA`, `whatIfs`, `miniProjects`, `scientists`, `conceptMap`)
/// across the three subject packs. ChapterDetailView's section views
/// read these structured fields directly — when any chapter falls
/// below the floor, that chapter's surface goes dark on the
/// chapters tab, so this test fails loud rather than letting a
/// silent regression ship.
///
/// Floors are pinned at the values authored on 2026-05-29 after the
/// Sanskrit enrichment backfill. Growth (chapter exceeds the floor)
/// is fine; shrinkage is what this test catches.
///
/// Per-pack scopes:
///   • science_class7  — every `ch*` chapter ratcheted.
///   • maths_class7    — every `ch*` chapter ratcheted (whatIfs /
///                       scientists currently absent across the pack;
///                       floor stays at 0 until that ships).
///   • sanskrit_class7 — every `sch*` chapter ratcheted. The legacy
///                       `ch01` vocab deck (`Class 7 Sanskrit
///                       Vocabulary`) is intentionally exempt — it's
///                       a flashcard surface, not a NEP chapter.
@MainActor
final class CrossSubjectEnrichmentParityTests: XCTestCase {

    private struct Floors {
        let glossary: Int
        let mnemonics: Int
        let misconceptions: Int
        let realWorldExamples: Int
        let ncertQA: Int
        let whatIfs: Int
        let miniProjects: Int
        let scientists: Int
        let conceptMapNodes: Int
    }

    private let scienceFloors = Floors(
        glossary: 10, mnemonics: 3, misconceptions: 5,
        realWorldExamples: 5, ncertQA: 8, whatIfs: 3,
        miniProjects: 2, scientists: 1, conceptMapNodes: 8
    )

    private let mathsFloors = Floors(
        glossary: 10, mnemonics: 3, misconceptions: 5,
        realWorldExamples: 3, ncertQA: 8, whatIfs: 0,
        miniProjects: 1, scientists: 0, conceptMapNodes: 5
    )

    private let sanskritSchFloors = Floors(
        glossary: 7, mnemonics: 3, misconceptions: 5,
        realWorldExamples: 3, ncertQA: 5, whatIfs: 3,
        miniProjects: 1, scientists: 1, conceptMapNodes: 6
    )

    func testSciencePackMeetsEnrichmentFloors() async throws {
        try await assertFloorsHold(packId: "science_class7",
                                   includes: { _ in true },
                                   floors: scienceFloors)
    }

    func testMathsPackMeetsEnrichmentFloors() async throws {
        try await assertFloorsHold(packId: "maths_class7",
                                   includes: { _ in true },
                                   floors: mathsFloors)
    }

    func testSanskritNEPChaptersMeetEnrichmentFloors() async throws {
        try await assertFloorsHold(packId: "sanskrit_class7",
                                   includes: { $0.id.hasPrefix("sch") },
                                   floors: sanskritSchFloors)
    }

    func testSanskritLegacyVocabDeckRemainsIsolated() async throws {
        let pack = try await loadPack("sanskrit_class7")
        let legacy = pack.chapters.first { $0.id == "ch01" }
        XCTAssertNotNil(legacy,
            "Sanskrit ch01 vocab deck must remain present.")
        XCTAssertEqual(legacy?.title, "Class 7 Sanskrit Vocabulary",
            "Sanskrit ch01 must keep its vocab-deck title — if it " +
            "morphs into an NEP chapter, drop it from the exemption.")
    }

    // MARK: - Helpers

    private func assertFloorsHold(packId: String,
                                  includes: (Chapter) -> Bool,
                                  floors: Floors) async throws {
        let pack = try await loadPack(packId)
        let scoped = pack.chapters.filter(includes)
        XCTAssertFalse(scoped.isEmpty,
            "[\(packId)] expected at least one chapter to ratchet.")

        var breaches: [String] = []
        for ch in scoped {
            check(ch, "glossary",          ch.glossary?.count ?? 0,         floors.glossary,         &breaches, packId)
            check(ch, "mnemonics",         ch.mnemonics?.count ?? 0,        floors.mnemonics,        &breaches, packId)
            check(ch, "misconceptions",    ch.misconceptions?.count ?? 0,   floors.misconceptions,   &breaches, packId)
            check(ch, "realWorldExamples", ch.realWorldExamples?.count ?? 0, floors.realWorldExamples, &breaches, packId)
            check(ch, "ncertQA",           ch.ncertQA?.count ?? 0,          floors.ncertQA,          &breaches, packId)
            check(ch, "whatIfs",           ch.whatIfs?.count ?? 0,          floors.whatIfs,          &breaches, packId)
            check(ch, "miniProjects",      ch.miniProjects?.count ?? 0,     floors.miniProjects,     &breaches, packId)
            check(ch, "scientists",        ch.scientists?.count ?? 0,       floors.scientists,       &breaches, packId)
            check(ch, "conceptMap.nodes",  ch.conceptMap?.nodes.count ?? 0, floors.conceptMapNodes,  &breaches, packId)
        }

        XCTAssertTrue(breaches.isEmpty,
            "Enrichment floor breaches (chapter detail surfaces go dark below floor):\n  " +
            breaches.joined(separator: "\n  ")
        )
    }

    private func check(_ ch: Chapter,
                       _ field: String,
                       _ actual: Int,
                       _ floor: Int,
                       _ breaches: inout [String],
                       _ packId: String) {
        if actual < floor {
            breaches.append("[\(packId)] \(ch.id).\(field) = \(actual) < floor \(floor)")
        }
    }

    private func loadPack(_ id: String) async throws -> SubjectPack {
        let registry = SubjectRegistry()
        for _ in 0..<50 {
            if !registry.isLoading && !registry.packs.isEmpty { break }
            try? await Task.sleep(nanoseconds: 50_000_000)
        }
        guard let pack = registry.packs.first(where: { $0.id == id }) else {
            XCTFail("Pack \(id) failed to load in 2.5 s.")
            throw NSError(domain: "CrossSubjectEnrichmentParityTests", code: 1)
        }
        return pack
    }
}
