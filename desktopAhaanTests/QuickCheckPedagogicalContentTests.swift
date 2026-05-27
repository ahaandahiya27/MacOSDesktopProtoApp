import XCTest
@testable import desktopAhaan

// MARK: - QuickCheckPedagogicalContentTests
//
// Frozen 2026-05-27 with the scene-quick-check pedagogical enrichment
// (`scripts/enrich_quick_checks.py`). Floors the corrective-payload
// contract for the 68 migrated quick-checks:
//
//   1. Every quick-check must carry ≥ 1 commonMistake, otherwise
//      QuestionDetailView's commonMistakesCard renders blank when the
//      kid lands on it from Daily Practice or the D4 "Stuck here?" strip.
//
//   2. Every quick-check must carry ≥ 1 solutionStep, otherwise the hint
//      ladder (Question.derivedHints → solutionSteps.prefix(2)) has
//      nothing to reveal and "Show full solution" only echoes the answer.
//
//   3. No commonMistake shorter than 30 chars — catches "TBD" / "fix me"
//      / "test" placeholders that would technically satisfy (1) but teach
//      nothing.
//
// Mirrors `BossQuizMigrationRatchetTests.testEveryBossQuizHasCommonMistakes`,
// scoped to the `scenecheck_` content.

final class QuickCheckPedagogicalContentTests: XCTestCase {

    private static let commonMistakeMinChars = 30

    func testEveryQuickCheckHasCommonMistakes() throws {
        let pack = try loadSciencePack()
        var emptyIds: [String] = []
        for chapter in pack.chapters {
            for q in chapter.quickCheckQuestionsList where q.commonMistakes.isEmpty {
                emptyIds.append(q.id)
            }
        }
        XCTAssertTrue(
            emptyIds.isEmpty,
            "These quick-checks ship with empty commonMistakes:\n" +
            emptyIds.map { "  - \($0)" }.joined(separator: "\n") +
            "\nEvery quick-check must carry ≥ 1 commonMistake so the " +
            "commonMistakesCard has something to teach. Run " +
            "`scripts/enrich_quick_checks.py --write`."
        )
    }

    func testEveryQuickCheckHasSolutionSteps() throws {
        let pack = try loadSciencePack()
        var emptyIds: [String] = []
        for chapter in pack.chapters {
            for q in chapter.quickCheckQuestionsList where q.solutionSteps.isEmpty {
                emptyIds.append(q.id)
            }
        }
        XCTAssertTrue(
            emptyIds.isEmpty,
            "These quick-checks ship with empty solutionSteps:\n" +
            emptyIds.map { "  - \($0)" }.joined(separator: "\n") +
            "\nEvery quick-check must carry ≥ 1 solutionStep so the hint " +
            "ladder (derivedHints → solutionSteps.prefix(2)) can reveal " +
            "content. Run `scripts/enrich_quick_checks.py --write`."
        )
    }

    func testCommonMistakesNotPlaceholders() throws {
        let pack = try loadSciencePack()
        var shortEntries: [(id: String, count: Int, text: String)] = []
        for chapter in pack.chapters {
            for q in chapter.quickCheckQuestionsList {
                for cm in q.commonMistakes where cm.count < Self.commonMistakeMinChars {
                    shortEntries.append((q.id, cm.count, cm))
                }
            }
        }
        XCTAssertTrue(
            shortEntries.isEmpty,
            "Quick-checks with too-short commonMistakes (likely placeholders):\n" +
            shortEntries.map { "  - \($0.id) (\($0.count) chars): '\($0.text)'" }
                .joined(separator: "\n") +
            "\nEach commonMistake must be ≥ \(Self.commonMistakeMinChars) chars."
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
}
