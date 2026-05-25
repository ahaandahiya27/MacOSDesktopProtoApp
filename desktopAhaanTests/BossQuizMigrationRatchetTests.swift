import XCTest
@testable import desktopAhaan

// MARK: - BossQuizMigrationRatchetTests
//
// Frozen 2026-05-25 with the boss-quiz content migration
// (`scripts/migrate_boss_quiz_to_pack.py`). Locks the per-chapter
// boss-quiz item count plus the canonical stable-id format
// (`bossquiz_chNN_qII`).
//
// Why a ratchet:
//
//   1. Anyone deleting an item from `chapters[N].bossQuestions`
//      tips a chapter below the prior baseline — Daily Practice
//      "Recently Missed" loses material. Test fails so the
//      change is intentional and the baseline gets re-anchored.
//
//   2. Anyone changing the id format breaks on-disk SM-2 review
//      state — the ephemeral `bossquiz_chNN_qII` ids that the
//      pre-migration `recordEphemeralReview` calls used must
//      survive verbatim, otherwise everyone's review history is
//      orphaned on first launch after the migration. Test fails.
//
// If the change is intentional (a hand-written content fix
// adds a 16th item to Ch.5, say), update `expectedCounts`
// and `totalExpected` in the same commit.

final class BossQuizMigrationRatchetTests: XCTestCase {

    func testBossQuizCountPerChapterMatchesBaseline() throws {
        let pack = try loadSciencePack()

        for chapter in pack.chapters {
            let n = chapter.number
            let want = Self.expectedCounts[n] ?? 0
            let got = chapter.bossQuestionsList.count
            XCTAssertEqual(
                got, want,
                "Chapter \(n) boss-quiz count drifted from baseline " +
                "(expected \(want), got \(got)). " +
                "If the content change is intentional, update " +
                "`BossQuizMigrationRatchetTests.expectedCounts`."
            )
        }
    }

    func testBossQuizTotalMatchesBaseline() throws {
        let pack = try loadSciencePack()
        let total = pack.chapters.reduce(0) { $0 + $1.bossQuestionsList.count }
        XCTAssertEqual(
            total, Self.totalExpected,
            "Total boss-quiz item count drifted from baseline " +
            "(expected \(Self.totalExpected), got \(total))."
        )
    }

    func testBossQuizIdsFollowCanonicalFormat() throws {
        let pack = try loadSciencePack()
        let regex = try NSRegularExpression(
            pattern: #"^bossquiz_ch\d{2}_q\d{2}$"#,
            options: []
        )
        for chapter in pack.chapters {
            for q in chapter.bossQuestionsList {
                let range = NSRange(q.id.startIndex..., in: q.id)
                XCTAssertNotNil(
                    regex.firstMatch(in: q.id, options: [], range: range),
                    "Boss-quiz id '\(q.id)' on chapter \(chapter.number) " +
                    "doesn't match canonical `bossquiz_chNN_qII` format. " +
                    "Changing this format orphans pre-migration ephemeral " +
                    "SM-2 review history — DO NOT break the id contract " +
                    "without a data migration plan."
                )
            }
        }
    }

    func testBossQuizIdsAreUniqueAcrossPack() throws {
        let pack = try loadSciencePack()
        var seen: Set<String> = []
        for chapter in pack.chapters {
            for q in chapter.bossQuestionsList {
                XCTAssertFalse(
                    seen.contains(q.id),
                    "Duplicate boss-quiz id across chapters: \(q.id)."
                )
                seen.insert(q.id)
            }
        }
    }

    func testBossQuizQuestionsAreMcqWithFourOptions() throws {
        let pack = try loadSciencePack()
        for chapter in pack.chapters {
            for q in chapter.bossQuestionsList {
                XCTAssertEqual(
                    q.questionType, .mcq,
                    "Boss-quiz \(q.id) is not MCQ — Scene9 expects MCQs."
                )
                XCTAssertEqual(
                    q.options?.count, 4,
                    "Boss-quiz \(q.id) doesn't have 4 options — Scene9 " +
                    "renders a 4-button picker; other arities break the UI."
                )
                XCTAssertTrue(
                    q.options?.contains(q.answer) ?? false,
                    "Boss-quiz \(q.id) answer '\(q.answer)' isn't in its options."
                )
            }
        }
    }

    /// Page-reference floor (added 2026-05-25 enrichment session):
    /// every boss-quiz item MUST ship with at least one entry in
    /// `pageRefs`. QuestionDetailView's "📖 p.N" chip renders blank
    /// when the array is empty — the kid loses the textbook
    /// breadcrumb that points them at the relevant page to read.
    func testEveryBossQuizHasPageRefs() throws {
        let pack = try loadSciencePack()
        var emptyIds: [String] = []
        for chapter in pack.chapters {
            for q in chapter.bossQuestionsList {
                if q.pageRefs.isEmpty {
                    emptyIds.append(q.id)
                }
            }
        }
        XCTAssertTrue(
            emptyIds.isEmpty,
            "These boss-quiz items ship with empty pageRefs:\n" +
            emptyIds.map { "  - \($0)" }.joined(separator: "\n") +
            "\nEvery boss Q must carry ≥ 1 pageRef so the 📖 p.N " +
            "chip in QuestionDetailView points at a real textbook page."
        )
    }

    /// Pedagogical-content floor (added 2026-05-25 enrichment session):
    /// every boss-quiz item MUST ship with at least one entry in
    /// `commonMistakes`. If a future content edit empties the array
    /// for any boss Q, the kid who lands on it from Daily Practice
    /// would see the misconception card render blank — and we'd
    /// silently lose the corrective payload the migration was for.
    func testEveryBossQuizHasCommonMistakes() throws {
        let pack = try loadSciencePack()
        var emptyIds: [String] = []
        for chapter in pack.chapters {
            for q in chapter.bossQuestionsList {
                if q.commonMistakes.isEmpty {
                    emptyIds.append(q.id)
                }
            }
        }
        XCTAssertTrue(
            emptyIds.isEmpty,
            "These boss-quiz items ship with empty commonMistakes:\n" +
            emptyIds.map { "  - \($0)" }.joined(separator: "\n") +
            "\nEvery boss Q must carry ≥ 1 commonMistake so the post-answer " +
            "card has something to teach the kid who got it wrong."
        )
    }

    // MARK: - Helpers

    private func loadSciencePack() throws -> SubjectPack {
        guard let url = Bundle.main.url(forResource: "science_class7", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            throw XCTSkip("science_class7.json missing from test bundle resources.")
        }
        return try JSONDecoder().decode(SubjectPack.self, from: data)
    }

    // MARK: - Baseline (frozen 2026-05-25 by migrate_boss_quiz_to_pack.py)

    private static let expectedCounts: [Int: Int] = [
        1: 15, 2: 15, 3: 10, 4: 10, 5: 10, 6: 10, 7: 10, 8: 10,
        9: 10, 10: 10, 11: 10, 12: 10, 13: 10, 14: 10, 15: 10,
        16: 10, 17: 10, 18: 10, 19: 10,
    ]

    private static let totalExpected: Int = 200
}
