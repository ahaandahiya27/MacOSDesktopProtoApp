import XCTest
@testable import desktopAhaan

/// Schema + content-quality ratchet for the Sanskrit pack's `deepDive`
/// (`[StretchTopic]`) arrays, added in v6 "Learning Journey" milestone P1-B
/// (2026-06-01). The Sanskrit pack shipped with zero deepDive entries — the
/// last subject blocking the Olympiad ladder (Phase 5) and capping Phase 3's
/// adaptive difficulty ceiling.
///
/// Mirrors the Maths `MathsDeepDiveTests` / Science `ChapterContentTests`
/// deep-dive contract, scoped to the 15 NEP chapters `sch01`–`sch15`. The
/// legacy `ch01` vocabulary deck is the documented carve-out (CLAUDE.md) and is
/// intentionally exempt from the per-chapter floor here, exactly as it is exempt
/// from the NEP cross-subject parity ratchets.
///
/// Contract enforced:
///   * every NEP chapter has ≥ 3 stretch topics,
///   * every `parentConceptId` resolves to a same-chapter concept,
///   * every stretch-topic id is globally unique within the pack,
///   * every body is ≥ 120 words,
///   * every stretch topic carries a prerequisite and a next-step hint.
///
/// If a deliberate content change moves the total, update `expectedTotal` here
/// in the same commit.
final class SanskritDeepDiveTests: XCTestCase {

    /// The legacy vocabulary deck — exempt from NEP parity ratchets per CLAUDE.md.
    private static let legacyChapterId = "ch01"
    private static let minDeepDivePerChapter = 3
    private static let minBodyWords = 120
    private static let expectedTotal = 45

    private func loadSanskritPack() throws -> SubjectPack {
        guard let url = Bundle.main.url(forResource: "sanskrit_class7", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            throw XCTSkip("sanskrit_class7.json missing from test bundle resources.")
        }
        return try JSONDecoder().decode(SubjectPack.self, from: data)
    }

    private func nepChapters(_ pack: SubjectPack) -> [Chapter] {
        pack.chapters.filter { $0.id != Self.legacyChapterId }
    }

    func testEveryNEPChapterHasDeepDiveFloor() throws {
        let pack = try loadSanskritPack()
        var thin: [String] = []
        for ch in nepChapters(pack) where ch.deepDiveList.count < Self.minDeepDivePerChapter {
            thin.append("\(ch.id)=\(ch.deepDiveList.count)")
        }
        XCTAssertTrue(
            thin.isEmpty,
            "Sanskrit NEP chapters below the \(Self.minDeepDivePerChapter)-deepDive floor: " +
            thin.joined(separator: ", ")
        )
    }

    func testDeepDiveTotalMatchesAuthoredCount() throws {
        let pack = try loadSanskritPack()
        let total = nepChapters(pack).reduce(0) { $0 + $1.deepDiveList.count }
        XCTAssertGreaterThanOrEqual(
            total, Self.expectedTotal,
            "Sanskrit deepDive total dropped below the authored \(Self.expectedTotal) (\(total)). " +
            "A deliberate addition should bump expectedTotal in the same commit."
        )
    }

    func testDeepDiveParentConceptIdsResolveWithinChapter() throws {
        let pack = try loadSanskritPack()
        var offenders: [String] = []
        for chapter in pack.chapters {
            let chapterConceptIds = Set(chapter.topics.flatMap { $0.concepts.map { $0.id } })
            for stretch in chapter.deepDiveList where !chapterConceptIds.contains(stretch.parentConceptId) {
                offenders.append("\(stretch.id) → \(stretch.parentConceptId) (not in \(chapter.id))")
            }
        }
        XCTAssertTrue(
            offenders.isEmpty,
            "Sanskrit stretch topics whose parentConceptId doesn't resolve to a same-chapter concept: " +
            offenders.prefix(5).joined(separator: ", ")
        )
    }

    func testDeepDiveIdsAreGloballyUnique() throws {
        let pack = try loadSanskritPack()
        var seen: Set<String> = []
        var dupes: [String] = []
        for chapter in pack.chapters {
            for stretch in chapter.deepDiveList where !seen.insert(stretch.id).inserted {
                dupes.append(stretch.id)
            }
        }
        XCTAssertTrue(dupes.isEmpty, "Duplicate Sanskrit stretch-topic ids: \(dupes.prefix(5).joined(separator: ", "))")
    }

    func testDeepDiveBodiesMeetWordFloor() throws {
        let pack = try loadSanskritPack()
        var thin: [(String, Int)] = []
        for chapter in pack.chapters {
            for stretch in chapter.deepDiveList {
                let wc = stretch.body.split { $0.isWhitespace }.count
                if wc < Self.minBodyWords { thin.append((stretch.id, wc)) }
            }
        }
        XCTAssertTrue(
            thin.isEmpty,
            "Sanskrit stretch bodies under \(Self.minBodyWords) words: " +
            thin.prefix(5).map { "\($0.0)=\($0.1)" }.joined(separator: ", ")
        )
    }

    func testEveryDeepDiveHasPrerequisiteAndNextStep() throws {
        let pack = try loadSanskritPack()
        var missing: [String] = []
        for chapter in pack.chapters {
            for s in chapter.deepDiveList {
                let pre = (s.prerequisite ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
                let nxt = (s.nextStepHint ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
                if pre.isEmpty || nxt.isEmpty { missing.append(s.id) }
            }
        }
        XCTAssertTrue(
            missing.isEmpty,
            "Sanskrit stretch topics missing prerequisite or nextStepHint: " +
            missing.prefix(5).joined(separator: ", ")
        )
    }
}
