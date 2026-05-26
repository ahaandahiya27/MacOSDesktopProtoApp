import XCTest
@testable import desktopAhaan

/// Schema-level tests for the `Chapter.quickCheckQuestions` Optional
/// field shipped with the 2026-05-27 scene-quick-check migration.
///
/// Mirrors `BossQuestionsSchemaTests` exactly — same three contracts,
/// scoped to the new field:
///   1. A Chapter JSON WITH `quickCheckQuestions` round-trips cleanly.
///   2. A Chapter JSON WITHOUT `quickCheckQuestions` decodes — the
///      Optional default + `quickCheckQuestionsList` empty accessor
///      preserve backwards-compat with any older pack snapshot.
///   3. After the migration commit lands, the real `science_class7.json`
///      carries non-nil `quickCheckQuestions` for every applicable
///      chapter (Ch.1, 2, 6 have no migratable MCQs and stay nil).
final class QuickCheckSchemaTests: XCTestCase {

    // MARK: - JSON round-trip

    private static func chapterJSONWithQuickCheckQuestions() -> String {
        """
        {
          "id": "ch99",
          "number": 99,
          "title": "Stub Chapter",
          "summary": "",
          "topics": [],
          "pageRefs": [],
          "quickCheckQuestions": [
            {
              "id": "scenecheck_ch99_q00",
              "prompt": "Stub prompt — A or B?",
              "questionType": "mcq",
              "options": ["A", "B"],
              "answer": "A",
              "solutionSteps": [],
              "commonMistakes": [],
              "variations": [],
              "difficulty": 1,
              "pageRefs": [],
              "needsHumanReview": false,
              "source": "scene_quick_check"
            }
          ]
        }
        """
    }

    func testChapterWithQuickCheckQuestionsDecodes() throws {
        let json = Self.chapterJSONWithQuickCheckQuestions()
        let chapter = try JSONDecoder().decode(
            Chapter.self, from: json.data(using: .utf8)!
        )
        XCTAssertNotNil(chapter.quickCheckQuestions)
        XCTAssertEqual(chapter.quickCheckQuestionsList.count, 1)
        let q = chapter.quickCheckQuestionsList[0]
        XCTAssertEqual(q.id, "scenecheck_ch99_q00")
        XCTAssertEqual(q.questionType, .mcq)
        XCTAssertEqual(q.effectiveSource, .sceneQuickCheck)
        XCTAssertEqual(q.options, ["A", "B"])
    }

    func testChapterQuickCheckQuestionsRoundTripsThroughEncoder() throws {
        let json = Self.chapterJSONWithQuickCheckQuestions()
        let decoded = try JSONDecoder().decode(
            Chapter.self, from: json.data(using: .utf8)!
        )
        let encoded = try JSONEncoder().encode(decoded)
        let redecoded = try JSONDecoder().decode(Chapter.self, from: encoded)
        XCTAssertEqual(redecoded.quickCheckQuestionsList.count, 1)
        XCTAssertEqual(
            redecoded.quickCheckQuestionsList[0].id,
            decoded.quickCheckQuestionsList[0].id
        )
        XCTAssertEqual(
            redecoded.quickCheckQuestionsList[0].effectiveSource,
            .sceneQuickCheck
        )
    }

    // MARK: - Backwards-compat

    func testChapterWithoutQuickCheckQuestionsFieldStillDecodes() throws {
        // A pre-migration Chapter JSON has no `quickCheckQuestions` key.
        let json = """
        {
          "id": "ch98",
          "number": 98,
          "title": "Pre-migration chapter",
          "summary": "",
          "topics": [],
          "pageRefs": []
        }
        """
        let chapter = try JSONDecoder().decode(
            Chapter.self, from: json.data(using: .utf8)!
        )
        XCTAssertNil(chapter.quickCheckQuestions)
        XCTAssertEqual(chapter.quickCheckQuestionsList, [],
                       "the *List accessor flattens nil → empty so callers don't unwrap")
    }

    // MARK: - allQuestionIds extension

    func testAllQuestionIdsIncludesQuickCheckQuestions() throws {
        let json = Self.chapterJSONWithQuickCheckQuestions()
        let chapter = try JSONDecoder().decode(
            Chapter.self, from: json.data(using: .utf8)!
        )
        XCTAssertEqual(chapter.allQuestionIds, ["scenecheck_ch99_q00"],
            "Chapter.allQuestionIds should include scene-quick-check ids " +
            "so ChapterStuckHereStrip and D6 topic drill-down stay " +
            "scope-correct alongside topic and boss-quiz ids.")
    }

    // MARK: - Real-pack invariant

    /// After the migration commit lands, the real `science_class7.json`
    /// must carry `quickCheckQuestions` for the 16 chapters with
    /// migratable inline MCQ scenes (Ch.3..5, Ch.7..19). Ch.1, 2, and
    /// 6 have no MCQ-shape Q literals in their dispatchers and stay
    /// nil. The intermediate state — some applicable chapters migrated,
    /// others not — is a bug; this test catches it.
    func testRealSciencePackQuickCheckMigrationConsistent() throws {
        let url = Bundle.main.url(
            forResource: "science_class7", withExtension: "json"
        )
        XCTAssertNotNil(url)
        guard let url = url else { return }
        let data = try Data(contentsOf: url)
        let pack = try JSONDecoder().decode(SubjectPack.self, from: data)

        let applicableChapterNumbers: Set<Int> = [
            3, 4, 5, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19
        ]
        let migrated = pack.chapters
            .filter { $0.quickCheckQuestions != nil }
            .map { $0.number }
        let nonApplicableMigrated = Set(migrated).subtracting(applicableChapterNumbers)
        let applicableMissing = applicableChapterNumbers.subtracting(Set(migrated))

        XCTAssertTrue(
            nonApplicableMigrated.isEmpty,
            "Chapters with no migratable MCQs (Ch.1, 2, 6) should not carry " +
            "quickCheckQuestions. Found unexpected migrations: \(nonApplicableMigrated)."
        )
        // Pre-migration state: no chapters carry the field. Post-migration:
        // all 16 applicable chapters do. Anything else is a partial state.
        XCTAssertTrue(
            applicableMissing.isEmpty || applicableMissing == applicableChapterNumbers,
            "Partial migration detected. Applicable chapters missing " +
            "quickCheckQuestions: \(applicableMissing.sorted())."
        )
    }
}
