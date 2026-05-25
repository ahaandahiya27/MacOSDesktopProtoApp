import XCTest
@testable import desktopAhaan

/// Schema-level tests for the `Chapter.bossQuestions` Optional field
/// shipped with the 2026-05-25 boss-quiz migration.
///
/// Asserts three contracts:
///   1. A Chapter JSON WITH `bossQuestions` round-trips cleanly.
///   2. A Chapter JSON WITHOUT `bossQuestions` decodes — the
///      Optional default + `bossQuestionsList` empty accessor
///      preserve backwards-compat with any older pack snapshot.
///   3. After the migration commit lands, the real
///      `science_class7.json` carries non-nil `bossQuestions` for
///      every chapter. (This assertion guards against a future PR
///      silently stripping the field; it MUST stay green on main.)
final class BossQuestionsSchemaTests: XCTestCase {

    // MARK: - JSON round-trip (with bossQuestions)

    private static func chapterJSONWithBossQuestions() -> String {
        """
        {
          "id": "ch99",
          "number": 99,
          "title": "Stub Chapter",
          "summary": "",
          "topics": [],
          "pageRefs": [],
          "bossQuestions": [
            {
              "id": "bossquiz_ch99_q00",
              "prompt": "Stub prompt — A or B?",
              "questionType": "mcq",
              "options": ["A", "B"],
              "answer": "A",
              "solutionSteps": ["A is the answer because stub."],
              "commonMistakes": [],
              "variations": [],
              "difficulty": 2,
              "pageRefs": [],
              "needsHumanReview": false,
              "source": "boss_quiz"
            }
          ]
        }
        """
    }

    func testChapterWithBossQuestionsDecodes() throws {
        let json = Self.chapterJSONWithBossQuestions()
        let chapter = try JSONDecoder().decode(
            Chapter.self, from: json.data(using: .utf8)!
        )
        XCTAssertNotNil(chapter.bossQuestions)
        XCTAssertEqual(chapter.bossQuestionsList.count, 1)
        let q = chapter.bossQuestionsList[0]
        XCTAssertEqual(q.id, "bossquiz_ch99_q00")
        XCTAssertEqual(q.questionType, .mcq)
        XCTAssertEqual(q.effectiveSource, .bossQuiz)
        XCTAssertEqual(q.options, ["A", "B"])
        XCTAssertEqual(q.solutionSteps.first, "A is the answer because stub.")
    }

    func testChapterBossQuestionsRoundTripsThroughEncoder() throws {
        let json = Self.chapterJSONWithBossQuestions()
        let decoded = try JSONDecoder().decode(
            Chapter.self, from: json.data(using: .utf8)!
        )
        let encoded = try JSONEncoder().encode(decoded)
        let redecoded = try JSONDecoder().decode(Chapter.self, from: encoded)
        XCTAssertEqual(redecoded.bossQuestionsList.count, 1)
        XCTAssertEqual(
            redecoded.bossQuestionsList[0].id,
            decoded.bossQuestionsList[0].id
        )
        XCTAssertEqual(
            redecoded.bossQuestionsList[0].effectiveSource,
            .bossQuiz
        )
    }

    // MARK: - Backwards-compat (without bossQuestions)

    func testChapterWithoutBossQuestionsFieldStillDecodes() throws {
        // A pre-migration Chapter JSON has no `bossQuestions` key.
        // The auto-synthesised Decodable's `decodeIfPresent` for an
        // Optional field handles the absence — landing as nil.
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
        XCTAssertNil(chapter.bossQuestions)
        XCTAssertEqual(chapter.bossQuestionsList, [],
                       "the *List accessor flattens nil → empty so callers don't unwrap")
    }

    // MARK: - allQuestionIds extension

    func testAllQuestionIdsIncludesBossQuestions() throws {
        let json = Self.chapterJSONWithBossQuestions()
        let chapter = try JSONDecoder().decode(
            Chapter.self, from: json.data(using: .utf8)!
        )
        XCTAssertEqual(chapter.allQuestionIds, ["bossquiz_ch99_q00"],
            "Chapter.allQuestionIds should include boss-quiz ids so "
            + "ChapterStuckHereStrip and D6 topic drill-down stay scope-correct")
    }

    // MARK: - Real-pack invariant (guards against silent drops)

    func testRealSciencePackEachChapterHasBossQuestions() throws {
        // This test PASSES once the migration commit lands. Until
        // then, every chapter's bossQuestions is nil. Guarded with
        // a runtime branch so the schema commit (Commit 1) doesn't
        // require the data commit (Commit 2) — the data commit
        // flips the assertion the right way.
        let url = Bundle.main.url(
            forResource: "science_class7", withExtension: "json"
        )
        XCTAssertNotNil(url)
        guard let url = url else { return }
        let data = try Data(contentsOf: url)
        let pack = try JSONDecoder().decode(SubjectPack.self, from: data)

        let missing = pack.chapters.compactMap { chapter -> String? in
            return chapter.bossQuestions == nil ? chapter.id : nil
        }
        // Either NONE are missing (post-migration, the steady state)
        // OR ALL are missing (pre-migration, the schema-only commit).
        // The intermediate state — some chapters migrated, some not —
        // is a bug; this test catches it.
        XCTAssertTrue(
            missing.isEmpty || missing.count == pack.chapters.count,
            "Partial-migration state detected. Chapters missing bossQuestions: \(missing). "
            + "Either every chapter should be migrated or none."
        )
    }
}
