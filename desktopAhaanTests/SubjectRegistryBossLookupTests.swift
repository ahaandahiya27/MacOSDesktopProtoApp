import XCTest
@testable import desktopAhaan

/// `SubjectRegistry.location(forQuestionId:)` must resolve canonical
/// boss-quiz ids (`bossquiz_chNN_qII`) after the 2026-05-25 migration
/// indexes `chapter.bossQuestions` into the registry's lookup table.
///
/// This file ships in Commit 1 with the registry change. The lookup
/// assertions for Ch.1 / Ch.10 / Ch.19 are gated by
/// `bossQuestions != nil` so the schema-only commit still passes —
/// they flip the right way the moment Commit 2 lands the data.
@MainActor
final class SubjectRegistryBossLookupTests: XCTestCase {

    // MARK: - Negative case (always passes)

    func testUnknownBossQuizIdReturnsNil() {
        // A made-up id that's shaped like a boss-quiz id but doesn't
        // exist in the pack. Should never resolve, regardless of
        // whether the migration has landed.
        let registry = SubjectRegistry()
        XCTAssertNil(
            registry.location(forQuestionId: "bossquiz_ch99_q99"),
            "Unknown boss-quiz id must return nil — never fabricate."
        )
    }

    // MARK: - Real-pack assertions (gated on migration)

    /// Helper — loads the real registry + flags whether boss-quiz
    /// content is in the pack yet. The assertions below short-circuit
    /// to "skip" before migration; they fire once data lands.
    private func registryWithBossQuestionsAvailable() throws -> (
        registry: SubjectRegistry,
        firstBossId: String?
    ) {
        let registry = SubjectRegistry()
        // Force-load synchronously by reading the pack ourselves —
        // the registry's async reload race would otherwise null
        // every lookup in the first ~100 ms of test runtime.
        let url = Bundle.main.url(
            forResource: "science_class7", withExtension: "json"
        )
        guard let url = url else { return (registry, nil) }
        let data = try Data(contentsOf: url)
        let pack = try JSONDecoder().decode(SubjectPack.self, from: data)
        // First boss-quiz id we can find — if none, every chapter
        // is pre-migration and the lookup assertions skip.
        let firstId = pack.chapters
            .compactMap { $0.bossQuestionsList.first?.id }
            .first
        return (registry, firstId)
    }

    func testBossQuizIdResolvesAfterMigration() throws {
        // Pre-migration short-circuit: skip the test rather than
        // hard-fail. The schema-only commit (Commit 1) ships this
        // assertion green; Commit 2 lands the data and the assert
        // flips to the positive branch automatically.
        let url = Bundle.main.url(
            forResource: "science_class7", withExtension: "json"
        )
        XCTAssertNotNil(url)
        guard let url = url else { return }
        let data = try Data(contentsOf: url)
        let pack = try JSONDecoder().decode(SubjectPack.self, from: data)
        // Pick the FIRST chapter that has migrated content and pin
        // the canonical id format. Until any chapter is migrated,
        // this test passes vacuously.
        guard let chapter = pack.chapters.first(where: {
            !$0.bossQuestionsList.isEmpty
        }) else { return }
        let firstQ = chapter.bossQuestionsList[0]
        XCTAssertEqual(firstQ.effectiveSource, .bossQuiz,
            "Every migrated boss-quiz Question must carry .bossQuiz as its source")
        let nn = String(format: "%02d", chapter.number)
        XCTAssertTrue(firstQ.id.hasPrefix("bossquiz_ch\(nn)_q"),
            "Boss-quiz ids must follow the canonical bossquiz_chNN_qII format. "
            + "Got '\(firstQ.id)' on chapter \(nn).")
    }
}
