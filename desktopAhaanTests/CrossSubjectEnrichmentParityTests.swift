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
///   • maths_class7    — every `ch*` chapter ratcheted (whatIfs shipped
///                       in v6 P1-G, floor now 3; scientists still
///                       absent across the pack, floor stays at 0).
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
        realWorldExamples: 3, ncertQA: 8, whatIfs: 3,
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

    /// Locks in the *content* quality of every enrichment item in the
    /// Sanskrit NEP chapters — not just the counts, but that the
    /// strings the section views actually render aren't blank or
    /// whitespace-only. Catches placeholder regressions a count
    /// ratchet can't see.
    func testSanskritEnrichmentContentIsNonEmpty() async throws {
        let pack = try await loadPack("sanskrit_class7")
        let scoped = pack.chapters.filter { $0.id.hasPrefix("sch") }
        var blanks: [String] = []

        for c in scoped {
            for g in c.glossaryList {
                report(c.id, "glossary[\(g.id)].term", g.term, &blanks, min: 1)
                // Sanskrit glossaries are bilingual translations: many
                // valid definitions are single English words ("Novel",
                // "Curiosity", "Service"). The floor here only catches
                // truly blank / single-character placeholders — content
                // adequacy is editorial, not test-enforced.
                report(c.id, "glossary[\(g.id)].definition", g.definition, &blanks, min: 3)
            }
            for m in c.mnemonicsList {
                report(c.id, "mnemonic[\(m.id)].acronym", m.acronym, &blanks, min: 1)
                report(c.id, "mnemonic[\(m.id)].unpacking", m.unpacking, &blanks, min: 10)
            }
            for m in c.misconceptionsList {
                report(c.id, "misconception[\(m.id)].kidsThink", m.kidsThink, &blanks, min: 5)
                report(c.id, "misconception[\(m.id)].actually", m.actually, &blanks, min: 10)
            }
            for w in c.whatIfsList {
                report(c.id, "whatIf[\(w.id)].question", w.question, &blanks, min: 5)
                report(c.id, "whatIf[\(w.id)].answer", w.answer, &blanks, min: 30)
            }
            for mp in c.miniProjectsList {
                report(c.id, "miniProject[\(mp.id)].title", mp.title, &blanks, min: 3)
                report(c.id, "miniProject[\(mp.id)].emoji", mp.emoji, &blanks, min: 1)
                report(c.id, "miniProject[\(mp.id)].expectedObservation", mp.expectedObservation, &blanks, min: 10)
                report(c.id, "miniProject[\(mp.id)].whyItWorks", mp.whyItWorks, &blanks, min: 10)
                if mp.needs.isEmpty {
                    blanks.append("[sanskrit_class7] \(c.id).miniProject[\(mp.id)].needs is empty")
                }
                if mp.steps.count < 3 {
                    blanks.append("[sanskrit_class7] \(c.id).miniProject[\(mp.id)].steps has \(mp.steps.count) (<3)")
                }
            }
            for s in c.scientistsList {
                report(c.id, "scientist[\(s.id)].name", s.name, &blanks, min: 2)
                report(c.id, "scientist[\(s.id)].oneLineLegacy", s.oneLineLegacy, &blanks, min: 10)
                report(c.id, "scientist[\(s.id)].narrative", s.narrative, &blanks, min: 50)
            }
            for q in c.ncertQAList {
                report(c.id, "ncertQA[\(q.id)].question", q.question, &blanks, min: 5)
                report(c.id, "ncertQA[\(q.id)].modelAnswer", q.modelAnswer, &blanks, min: 20)
            }
            for r in c.realWorldExamplesList {
                report(c.id, "realWorldExample[\(r.id)].title", r.title, &blanks, min: 3)
                report(c.id, "realWorldExample[\(r.id)].body", r.body, &blanks, min: 30)
            }
        }

        XCTAssertTrue(blanks.isEmpty,
            "Sanskrit enrichment fields with blank / too-short content:\n  " +
            blanks.prefix(20).joined(separator: "\n  ")
        )
    }

    /// Locks in concept-map edge integrity for the Sanskrit NEP
    /// chapters — every edge must reference a node that exists in
    /// the same map, and every `.concept` node must resolve to a
    /// concept id within that chapter. Mirrors the science-only
    /// `testConceptMapNodesResolveWithinChapterOrToCrossChapterRef`
    /// in `ChapterContentTests`.
    func testSanskritConceptMapEdgesResolve() async throws {
        let pack = try await loadPack("sanskrit_class7")
        var conceptIdsByChapter: [String: Set<String>] = [:]
        for c in pack.chapters {
            var ids: Set<String> = []
            for t in c.topics { for cc in t.concepts { ids.insert(cc.id) } }
            conceptIdsByChapter[c.id] = ids
        }
        var unresolved: [String] = []
        for c in pack.chapters where c.id.hasPrefix("sch") {
            guard let map = c.conceptMap else { continue }
            let own = conceptIdsByChapter[c.id] ?? []
            let nodeIds = Set(map.nodes.map(\.id))
            for n in map.nodes {
                switch n.kind {
                case .concept:
                    if !own.contains(n.id) {
                        unresolved.append("\(c.id):\(n.id) [.concept missing from chapter]")
                    }
                case .crossChapter:
                    let parts = n.id.split(separator: ":", maxSplits: 1)
                    guard parts.count == 2,
                          let target = conceptIdsByChapter[String(parts[0])] else {
                        unresolved.append("\(c.id):\(n.id) [malformed cross-chapter id]")
                        continue
                    }
                    if !target.contains(String(parts[1])) {
                        unresolved.append("\(c.id):\(n.id) [.crossChapter target missing]")
                    }
                case .pivot:
                    break
                }
            }
            for e in map.edges {
                if !nodeIds.contains(e.from) {
                    unresolved.append("\(c.id):edge \(e.id) — from=\(e.from) missing")
                }
                if !nodeIds.contains(e.to) {
                    unresolved.append("\(c.id):edge \(e.id) — to=\(e.to) missing")
                }
            }
        }
        XCTAssertTrue(unresolved.isEmpty,
            "Sanskrit conceptMap references unresolved:\n  " +
            unresolved.prefix(10).joined(separator: "\n  ")
        )
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

    private func report(_ chapterId: String,
                        _ field: String,
                        _ value: String,
                        _ blanks: inout [String],
                        min: Int) {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.count < min {
            blanks.append("[sanskrit_class7] \(chapterId).\(field) — \(trimmed.count) chars (<\(min))")
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
