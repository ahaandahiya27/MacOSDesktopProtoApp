import XCTest
@testable import desktopAhaan

/// Schema + content-quality ratchet for the Sanskrit pack's chapter-level
/// `bossQuestions` arrays, added in v6 "Learning Journey" milestone P1-D
/// (2026-06-01). The Sanskrit pack shipped with zero bossQuestions, which capped
/// the adaptive journey's difficulty ceiling (Phase 3) for Sanskrit and starved
/// the Olympiad ladder (Phase 5) of a Sanskrit high-difficulty pool.
///
/// Mirrors the Maths `MathsBossQuestionsTests` contract, scoped to the 15 NEP
/// chapters `sch01`–`sch15`. The legacy `ch01` vocabulary deck is the documented
/// carve-out (CLAUDE.md): it is exempt from the per-chapter floor AND must carry
/// NO boss questions, because a `bossquiz_ch01_*` id would collide with Science's
/// `ch01` boss ids and orphan SM-2 review state across packs.
///
/// Pins the boss-tier guarantees that make these usable as the adaptive ceiling:
///   * every NEP chapter has ≥ 6 boss questions,
///   * the legacy ch01 deck has none,
///   * every boss id is the canonical collision-free shape `bossquiz_schNN_qII`,
///   * every boss id is globally unique within the pack,
///   * every boss question is boss-tier difficulty (3 … 5),
///   * every `.mcq` boss question has its answer among its options,
///   * every boss question carries worked solutionSteps, ≥ 1 commonMistakes note
///     and ≥ 1 variation,
///   * every boss question is tagged `.bossQuiz`.
///
/// If a deliberate content change moves the total, update `minBossPerChapter`
/// or `expectedTotal` here in the same commit.
final class SanskritBossQuestionsTests: XCTestCase {

    /// The legacy vocabulary deck — exempt from NEP parity ratchets per CLAUDE.md.
    private static let legacyChapterId = "ch01"
    private static let minBossPerChapter = 6
    private static let expectedTotal = 90

    // bossquiz_<ns>NN_qII with ns == sch for the Sanskrit NEP pack.
    private static let idPattern =
        try! NSRegularExpression(pattern: "^bossquiz_sch\\d{2}_q\\d{2}$")

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

    private static func matches(_ regex: NSRegularExpression, _ s: String) -> Bool {
        let range = NSRange(s.startIndex..<s.endIndex, in: s)
        return regex.firstMatch(in: s, range: range) != nil
    }

    func testEveryNepChapterHasBossFloor() throws {
        let pack = try loadSanskritPack()
        var thin: [String] = []
        for ch in nepChapters(pack) where ch.bossQuestionsList.count < Self.minBossPerChapter {
            thin.append("\(ch.id)=\(ch.bossQuestionsList.count)")
        }
        XCTAssertTrue(
            thin.isEmpty,
            "Sanskrit NEP chapters below the \(Self.minBossPerChapter)-bossQuestion floor: " +
            thin.joined(separator: ", ")
        )
    }

    /// The legacy ch01 deck must stay free of boss questions — a bossquiz_ch01_*
    /// id would collide with Science's ch01 boss ids.
    func testLegacyDeckHasNoBossQuestions() throws {
        let pack = try loadSanskritPack()
        guard let legacy = pack.chapters.first(where: { $0.id == Self.legacyChapterId }) else {
            return  // no legacy deck present → nothing to guard
        }
        XCTAssertTrue(
            legacy.bossQuestionsList.isEmpty,
            "The legacy ch01 vocabulary deck must carry no bossQuestions " +
            "(bossquiz_ch01_* would collide with Science), got \(legacy.bossQuestionsList.count)."
        )
    }

    func testBossTotalMatchesAuthoredCount() throws {
        let pack = try loadSanskritPack()
        let total = nepChapters(pack).reduce(0) { $0 + $1.bossQuestionsList.count }
        XCTAssertGreaterThanOrEqual(
            total, Self.expectedTotal,
            "Sanskrit bossQuestions total dropped below the authored \(Self.expectedTotal) (\(total)). " +
            "A deliberate addition should bump expectedTotal in the same commit."
        )
    }

    func testBossIdsAreCanonicalAndGloballyUnique() throws {
        let pack = try loadSanskritPack()
        var seen: Set<String> = []
        var dupes: [String] = []
        var malformed: [String] = []
        for chapter in nepChapters(pack) {
            for q in chapter.bossQuestionsList {
                if !Self.matches(Self.idPattern, q.id) { malformed.append(q.id) }
                if !seen.insert(q.id).inserted { dupes.append(q.id) }
            }
        }
        XCTAssertTrue(
            malformed.isEmpty,
            "Sanskrit boss ids not matching bossquiz_schNN_qII: " +
            malformed.prefix(5).joined(separator: ", ")
        )
        XCTAssertTrue(dupes.isEmpty, "Duplicate Sanskrit boss ids: \(dupes.prefix(5).joined(separator: ", "))")
    }

    func testBossDifficultyIsBossTier() throws {
        let pack = try loadSanskritPack()
        var offenders: [String] = []
        for chapter in nepChapters(pack) {
            for q in chapter.bossQuestionsList where !(3...5).contains(q.difficulty) {
                offenders.append("\(q.id)=\(q.difficulty)")
            }
        }
        XCTAssertTrue(
            offenders.isEmpty,
            "Sanskrit boss questions outside difficulty 3…5: " +
            offenders.prefix(5).joined(separator: ", ")
        )
    }

    func testMcqBossAnswerIsAmongOptions() throws {
        let pack = try loadSanskritPack()
        var offenders: [String] = []
        for chapter in nepChapters(pack) {
            for q in chapter.bossQuestionsList where q.questionType == .mcq {
                let opts = q.options ?? []
                if opts.isEmpty || !opts.contains(q.answer) { offenders.append(q.id) }
            }
        }
        XCTAssertTrue(
            offenders.isEmpty,
            "Sanskrit mcq boss questions whose answer isn't among options: " +
            offenders.prefix(5).joined(separator: ", ")
        )
    }

    func testEveryBossHasStepsMistakesAndVariation() throws {
        let pack = try loadSanskritPack()
        var thin: [String] = []
        for chapter in nepChapters(pack) {
            for q in chapter.bossQuestionsList {
                if q.solutionSteps.isEmpty || q.commonMistakes.isEmpty || q.variations.isEmpty {
                    thin.append(q.id)
                }
            }
        }
        XCTAssertTrue(
            thin.isEmpty,
            "Sanskrit boss questions missing steps/mistakes/variation: " +
            thin.prefix(5).joined(separator: ", ")
        )
    }

    func testEveryBossIsTaggedBossQuizSource() throws {
        let pack = try loadSanskritPack()
        var offenders: [String] = []
        for chapter in nepChapters(pack) {
            for q in chapter.bossQuestionsList where q.effectiveSource != .bossQuiz {
                offenders.append("\(q.id)=\(q.effectiveSource.rawValue)")
            }
        }
        XCTAssertTrue(
            offenders.isEmpty,
            "Sanskrit boss questions not tagged boss_quiz: " +
            offenders.prefix(5).joined(separator: ", ")
        )
    }
}
