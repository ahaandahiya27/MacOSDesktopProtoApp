import XCTest
@testable import desktopAhaan

/// Schema + content-quality ratchet for the Maths pack's `deepDive`
/// (`[StretchTopic]`) arrays, added in v6 "Learning Journey" milestone P1-A
/// (2026-06-01). The Maths pack shipped with zero deepDive entries, which
/// blocked the Olympiad ladder (Phase 5) and capped the adaptive journey's
/// difficulty ceiling (Phase 3) for Maths.
///
/// Mirrors the Science `ChapterContentTests` deep-dive contract, scoped to
/// Maths, and adds a per-chapter floor so a future accidental deletion fails
/// loudly:
///   * every chapter has ≥ 3 stretch topics,
///   * every `parentConceptId` resolves to a same-chapter concept (keeps each
///     Deep Dive anchored to a Class-7 base, not a free-floating Class-11 dump),
///   * every stretch-topic id is globally unique within the pack,
///   * every body is ≥ 120 words (Science floor is 100; Maths authored richer),
///   * every stretch topic carries a prerequisite and a next-step hint.
///
/// The grade tag is guaranteed to be a forward extension (class_8 … neet_jee)
/// by `GradeLevel`'s own decode — an out-of-range value fails JSON decoding.
///
/// If a deliberate content change moves the total, update `minDeepDivePerChapter`
/// or `expectedTotal` here in the same commit.
final class MathsDeepDiveTests: XCTestCase {

    private static let minDeepDivePerChapter = 3
    private static let minBodyWords = 120
    private static let expectedTotal = 45

    private func loadMathsPack() throws -> SubjectPack {
        guard let url = Bundle.main.url(forResource: "maths_class7", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            throw XCTSkip("maths_class7.json missing from test bundle resources.")
        }
        return try JSONDecoder().decode(SubjectPack.self, from: data)
    }

    func testEveryChapterHasDeepDiveFloor() throws {
        let pack = try loadMathsPack()
        var thin: [String] = []
        for ch in pack.chapters where ch.deepDiveList.count < Self.minDeepDivePerChapter {
            thin.append("\(ch.id)=\(ch.deepDiveList.count)")
        }
        XCTAssertTrue(
            thin.isEmpty,
            "Maths chapters below the \(Self.minDeepDivePerChapter)-deepDive floor: " +
            thin.joined(separator: ", ")
        )
    }

    func testDeepDiveTotalMatchesAuthoredCount() throws {
        let pack = try loadMathsPack()
        let total = pack.chapters.reduce(0) { $0 + $1.deepDiveList.count }
        XCTAssertGreaterThanOrEqual(
            total, Self.expectedTotal,
            "Maths deepDive total dropped below the authored \(Self.expectedTotal) (\(total)). " +
            "A deliberate addition should bump expectedTotal in the same commit."
        )
    }

    func testDeepDiveParentConceptIdsResolveWithinChapter() throws {
        let pack = try loadMathsPack()
        var offenders: [String] = []
        for chapter in pack.chapters {
            let chapterConceptIds = Set(chapter.topics.flatMap { $0.concepts.map { $0.id } })
            for stretch in chapter.deepDiveList where !chapterConceptIds.contains(stretch.parentConceptId) {
                offenders.append("\(stretch.id) → \(stretch.parentConceptId) (not in \(chapter.id))")
            }
        }
        XCTAssertTrue(
            offenders.isEmpty,
            "Maths stretch topics whose parentConceptId doesn't resolve to a same-chapter concept: " +
            offenders.prefix(5).joined(separator: ", ")
        )
    }

    func testDeepDiveIdsAreGloballyUnique() throws {
        let pack = try loadMathsPack()
        var seen: Set<String> = []
        var dupes: [String] = []
        for chapter in pack.chapters {
            for stretch in chapter.deepDiveList where !seen.insert(stretch.id).inserted {
                dupes.append(stretch.id)
            }
        }
        XCTAssertTrue(dupes.isEmpty, "Duplicate Maths stretch-topic ids: \(dupes.prefix(5).joined(separator: ", "))")
    }

    func testDeepDiveBodiesMeetWordFloor() throws {
        let pack = try loadMathsPack()
        var thin: [(String, Int)] = []
        for chapter in pack.chapters {
            for stretch in chapter.deepDiveList {
                let wc = stretch.body.split { $0.isWhitespace }.count
                if wc < Self.minBodyWords { thin.append((stretch.id, wc)) }
            }
        }
        XCTAssertTrue(
            thin.isEmpty,
            "Maths stretch bodies under \(Self.minBodyWords) words: " +
            thin.prefix(5).map { "\($0.0)=\($0.1)" }.joined(separator: ", ")
        )
    }

    /// Every Deep Dive must carry a prerequisite and a next-step hint — those
    /// two fields are what make it a guided stretch rather than a content dump.
    func testEveryDeepDiveHasPrerequisiteAndNextStep() throws {
        let pack = try loadMathsPack()
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
            "Maths stretch topics missing prerequisite or nextStepHint: " +
            missing.prefix(5).joined(separator: ", ")
        )
    }
}
