import XCTest
@testable import desktopAhaan

/// Schema + content-quality ratchet for the Maths pack's chapter-level
/// `bossQuestions` arrays, added in v6 "Learning Journey" milestone P1-C
/// (2026-06-01). The Maths pack shipped with zero bossQuestions, which capped
/// the adaptive journey's difficulty ceiling (Phase 3) for Maths — the engine
/// could only escalate into the `ncertQA`/topic sets — and starved the Olympiad
/// ladder (Phase 5) of a Maths high-difficulty pool.
///
/// Mirrors the Science `BossQuizMigrationRatchetTests` contract, scoped to
/// Maths, and pins the boss-tier guarantees that make these usable as the
/// adaptive ceiling:
///   * every chapter has ≥ 6 boss questions,
///   * every boss id is the canonical collision-free shape `bossquiz_mchNN_qII`
///     (namespace token `mch` keeps Maths ids distinct from Science's
///     `bossquiz_chNN_qII`, so SM-2 review state never orphans across packs),
///   * every boss id is globally unique within the pack,
///   * every boss question is boss-tier difficulty (3 … 5),
///   * every `.mcq` boss question has its answer among its options,
///   * every boss question carries worked solutionSteps, ≥ 1 commonMistakes
///     note and ≥ 1 variation (so the kid can re-drill the same idea).
///
/// If a deliberate content change moves the total, update `minBossPerChapter`
/// or `expectedTotal` here in the same commit.
final class MathsBossQuestionsTests: XCTestCase {

    private static let minBossPerChapter = 6
    private static let expectedTotal = 90

    // bossquiz_<ns>NN_qII with ns == mch for the Maths pack.
    private static let idPattern =
        try! NSRegularExpression(pattern: "^bossquiz_mch\\d{2}_q\\d{2}$")

    private func loadMathsPack() throws -> SubjectPack {
        guard let url = Bundle.main.url(forResource: "maths_class7", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            throw XCTSkip("maths_class7.json missing from test bundle resources.")
        }
        return try JSONDecoder().decode(SubjectPack.self, from: data)
    }

    private static func matches(_ regex: NSRegularExpression, _ s: String) -> Bool {
        let range = NSRange(s.startIndex..<s.endIndex, in: s)
        return regex.firstMatch(in: s, range: range) != nil
    }

    func testEveryChapterHasBossFloor() throws {
        let pack = try loadMathsPack()
        var thin: [String] = []
        for ch in pack.chapters where ch.bossQuestionsList.count < Self.minBossPerChapter {
            thin.append("\(ch.id)=\(ch.bossQuestionsList.count)")
        }
        XCTAssertTrue(
            thin.isEmpty,
            "Maths chapters below the \(Self.minBossPerChapter)-bossQuestion floor: " +
            thin.joined(separator: ", ")
        )
    }

    func testBossTotalMatchesAuthoredCount() throws {
        let pack = try loadMathsPack()
        let total = pack.chapters.reduce(0) { $0 + $1.bossQuestionsList.count }
        XCTAssertGreaterThanOrEqual(
            total, Self.expectedTotal,
            "Maths bossQuestions total dropped below the authored \(Self.expectedTotal) (\(total)). " +
            "A deliberate addition should bump expectedTotal in the same commit."
        )
    }

    func testBossIdsAreCanonicalAndGloballyUnique() throws {
        let pack = try loadMathsPack()
        var seen: Set<String> = []
        var dupes: [String] = []
        var malformed: [String] = []
        for chapter in pack.chapters {
            for q in chapter.bossQuestionsList {
                if !Self.matches(Self.idPattern, q.id) { malformed.append(q.id) }
                if !seen.insert(q.id).inserted { dupes.append(q.id) }
            }
        }
        XCTAssertTrue(
            malformed.isEmpty,
            "Maths boss ids not matching bossquiz_mchNN_qII: " +
            malformed.prefix(5).joined(separator: ", ")
        )
        XCTAssertTrue(dupes.isEmpty, "Duplicate Maths boss ids: \(dupes.prefix(5).joined(separator: ", "))")
    }

    func testBossDifficultyIsBossTier() throws {
        let pack = try loadMathsPack()
        var offenders: [String] = []
        for chapter in pack.chapters {
            for q in chapter.bossQuestionsList where !(3...5).contains(q.difficulty) {
                offenders.append("\(q.id)=\(q.difficulty)")
            }
        }
        XCTAssertTrue(
            offenders.isEmpty,
            "Maths boss questions outside difficulty 3…5: " +
            offenders.prefix(5).joined(separator: ", ")
        )
    }

    func testMcqBossAnswerIsAmongOptions() throws {
        let pack = try loadMathsPack()
        var offenders: [String] = []
        for chapter in pack.chapters {
            for q in chapter.bossQuestionsList where q.questionType == .mcq {
                let opts = q.options ?? []
                if opts.isEmpty || !opts.contains(q.answer) { offenders.append(q.id) }
            }
        }
        XCTAssertTrue(
            offenders.isEmpty,
            "Maths mcq boss questions whose answer isn't among options: " +
            offenders.prefix(5).joined(separator: ", ")
        )
    }

    /// A boss question must be a re-drillable, self-explaining item: worked
    /// steps, at least one common-mistake note, and at least one variation.
    func testEveryBossHasStepsMistakesAndVariation() throws {
        let pack = try loadMathsPack()
        var thin: [String] = []
        for chapter in pack.chapters {
            for q in chapter.bossQuestionsList {
                if q.solutionSteps.isEmpty || q.commonMistakes.isEmpty || q.variations.isEmpty {
                    thin.append(q.id)
                }
            }
        }
        XCTAssertTrue(
            thin.isEmpty,
            "Maths boss questions missing steps/mistakes/variation: " +
            thin.prefix(5).joined(separator: ", ")
        )
    }

    /// Boss questions are synthesised content, so every one must carry the
    /// `.bossQuiz` source — that tag is what routes a missed answer to Daily
    /// Practice's Recently-Missed row via the ephemeral-id resolution.
    func testEveryBossIsTaggedBossQuizSource() throws {
        let pack = try loadMathsPack()
        var offenders: [String] = []
        for chapter in pack.chapters {
            for q in chapter.bossQuestionsList where q.effectiveSource != .bossQuiz {
                offenders.append("\(q.id)=\(q.effectiveSource.rawValue)")
            }
        }
        XCTAssertTrue(
            offenders.isEmpty,
            "Maths boss questions not tagged boss_quiz: " +
            offenders.prefix(5).joined(separator: ", ")
        )
    }
}
