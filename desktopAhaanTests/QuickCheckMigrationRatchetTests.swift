import XCTest
@testable import desktopAhaan

// MARK: - QuickCheckMigrationRatchetTests
//
// Frozen 2026-05-27 with the scene-quick-check content migration
// (`scripts/migrate_quick_checks_to_pack.py`). Locks the per-chapter
// item count plus the canonical stable-id format
// (`scenecheck_chNN_qII`).
//
// Why a ratchet:
//
//   1. Anyone deleting an item from `chapters[N].quickCheckQuestions`
//      tips a chapter below the prior baseline — Daily Practice
//      "Recently Missed" loses material. Test fails so the
//      change is intentional and the baseline gets re-anchored.
//
//   2. Anyone changing the id format breaks on-disk SM-2 review
//      state. Test fails.
//
// If the change is intentional (a new inline MCQ adds a 5th item to
// Ch.5, say), update `expectedCounts` + `totalExpected` in the same
// commit.

final class QuickCheckMigrationRatchetTests: XCTestCase {

    func testQuickCheckCountPerChapterMatchesBaseline() throws {
        let pack = try loadSciencePack()

        for chapter in pack.chapters {
            let n = chapter.number
            let want = Self.expectedCounts[n] ?? 0
            let got = chapter.quickCheckQuestionsList.count
            XCTAssertEqual(
                got, want,
                "Chapter \(n) quick-check count drifted from baseline " +
                "(expected \(want), got \(got)). " +
                "If the content change is intentional, update " +
                "`QuickCheckMigrationRatchetTests.expectedCounts`."
            )
        }
    }

    func testQuickCheckTotalMatchesBaseline() throws {
        let pack = try loadSciencePack()
        let total = pack.chapters.reduce(0) { $0 + $1.quickCheckQuestionsList.count }
        XCTAssertEqual(
            total, Self.totalExpected,
            "Total quick-check count drifted from baseline " +
            "(expected \(Self.totalExpected), got \(total))."
        )
    }

    func testQuickCheckIdsFollowCanonicalFormat() throws {
        let pack = try loadSciencePack()
        let regex = try NSRegularExpression(
            pattern: #"^scenecheck_ch\d{2}_q\d{2}$"#,
            options: []
        )
        for chapter in pack.chapters {
            for q in chapter.quickCheckQuestionsList {
                let range = NSRange(q.id.startIndex..., in: q.id)
                XCTAssertNotNil(
                    regex.firstMatch(in: q.id, options: [], range: range),
                    "Quick-check id '\(q.id)' on chapter \(chapter.number) " +
                    "doesn't match canonical `scenecheck_chNN_qII` format. " +
                    "This prefix is whitelisted in " +
                    "`DataStore.ephemeralIdPrefixes` — changing it orphans " +
                    "any in-flight SM-2 review state."
                )
            }
        }
    }

    func testQuickCheckIdsAreUniqueAcrossPack() throws {
        let pack = try loadSciencePack()
        var seen: Set<String> = []
        for chapter in pack.chapters {
            for q in chapter.quickCheckQuestionsList {
                XCTAssertFalse(
                    seen.contains(q.id),
                    "Duplicate quick-check id across chapters: \(q.id)."
                )
                seen.insert(q.id)
            }
        }
    }

    /// Quick-checks must not collide with boss-quiz ids — the prefix
    /// is different (`scenecheck_` vs `bossquiz_`) so this is a safety
    /// net rather than a real risk, but cheap to pin.
    func testQuickCheckIdsDoNotCollideWithBossQuizIds() throws {
        let pack = try loadSciencePack()
        var bossIds: Set<String> = []
        for chapter in pack.chapters {
            for q in chapter.bossQuestionsList { bossIds.insert(q.id) }
        }
        for chapter in pack.chapters {
            for q in chapter.quickCheckQuestionsList {
                XCTAssertFalse(
                    bossIds.contains(q.id),
                    "Quick-check id \(q.id) collides with a boss-quiz id. " +
                    "The two id namespaces must stay disjoint."
                )
            }
        }
    }

    func testQuickCheckQuestionsAreMcqWithValidOptions() throws {
        let pack = try loadSciencePack()
        for chapter in pack.chapters {
            for q in chapter.quickCheckQuestionsList {
                XCTAssertEqual(
                    q.questionType, .mcq,
                    "Quick-check \(q.id) is not MCQ — scenes expect MCQs."
                )
                XCTAssertGreaterThanOrEqual(
                    q.options?.count ?? 0, 2,
                    "Quick-check \(q.id) needs at least 2 options."
                )
                XCTAssertTrue(
                    q.options?.contains(q.answer) ?? false,
                    "Quick-check \(q.id) answer '\(q.answer)' isn't in its options."
                )
                XCTAssertEqual(
                    q.effectiveSource, .sceneQuickCheck,
                    "Every quick-check must carry .sceneQuickCheck as its source"
                )
            }
        }
    }

    // MARK: - Helpers

    private func loadSciencePack() throws -> SubjectPack {
        guard let url = Bundle.main.url(forResource: "science_class7", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            throw XCTSkip("science_class7.json missing from test bundle resources.")
        }
        return try JSONDecoder().decode(SubjectPack.self, from: data)
    }

    // MARK: - Baseline (frozen 2026-05-27 by migrate_quick_checks_to_pack.py)
    //
    // Chapters 1, 2, 6 have no migratable MCQ-shape Q literals (their
    // dispatcher inline scenes are sorting / matching tasks). The 16
    // applicable chapters carry 4 items each, except Ch.13 which has
    // two MCQ scenes (Speed Limits + General Recap, 4 + 4 = 8).

    private static let expectedCounts: [Int: Int] = [
         3: 4,  4: 4,  5: 4,  7: 4,  8: 4,  9: 4, 10: 4,
        11: 4, 12: 4, 13: 8, 14: 4, 15: 4, 16: 4, 17: 4,
        18: 4, 19: 4,
    ]

    private static let totalExpected: Int = 68
}
