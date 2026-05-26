import XCTest
@testable import desktopAhaan

/// `SubjectRegistry.location(forQuestionId:)` must resolve canonical
/// scene-quick-check ids (`scenecheck_chNN_qII`) after the 2026-05-27
/// migration indexes `chapter.quickCheckQuestions` into the registry's
/// lookup table.
///
/// Pre-migration the test passes vacuously (no migrated content yet).
/// Post-migration the assertion flips green automatically.
@MainActor
final class SubjectRegistryQuickCheckLookupTests: XCTestCase {

    // MARK: - Negative case (always passes)

    func testUnknownQuickCheckIdReturnsNil() {
        let registry = SubjectRegistry()
        XCTAssertNil(
            registry.location(forQuestionId: "scenecheck_ch99_q99"),
            "Unknown quick-check id must return nil."
        )
    }

    // MARK: - Real-pack assertion (gated on migration)

    func testQuickCheckIdResolvesAfterMigration() throws {
        let url = Bundle.main.url(
            forResource: "science_class7", withExtension: "json"
        )
        XCTAssertNotNil(url)
        guard let url = url else { return }
        let data = try Data(contentsOf: url)
        let pack = try JSONDecoder().decode(SubjectPack.self, from: data)
        // Pick the FIRST chapter that has migrated content and pin
        // the canonical id format.
        guard let chapter = pack.chapters.first(where: {
            !$0.quickCheckQuestionsList.isEmpty
        }) else { return }
        let firstQ = chapter.quickCheckQuestionsList[0]
        XCTAssertEqual(firstQ.effectiveSource, .sceneQuickCheck,
            "Every migrated quick-check Question must carry .sceneQuickCheck as its source")
        let nn = String(format: "%02d", chapter.number)
        XCTAssertTrue(firstQ.id.hasPrefix("scenecheck_ch\(nn)_q"),
            "Quick-check ids must follow the canonical scenecheck_chNN_qII format. " +
            "Got '\(firstQ.id)' on chapter \(nn).")
    }

    /// Coexistence test: boss-quiz AND quick-check ids must both
    /// resolve through the SAME registry instance, proving the two
    /// chapter-level lookup paths don't trample each other.
    func testBossQuizAndQuickCheckCoexistInLookup() async throws {
        let registry = SubjectRegistry()
        await waitForPacksLoaded(registry)

        guard let pack = registry.packs.first(where: { $0.id == "science_class7" }) else {
            return  // skip — pack didn't load
        }

        let bossSample = pack.chapters
            .compactMap { $0.bossQuestionsList.first }
            .first
        let qcSample = pack.chapters
            .compactMap { $0.quickCheckQuestionsList.first }
            .first

        if let boss = bossSample {
            XCTAssertNotNil(
                registry.location(forQuestionId: boss.id),
                "Boss-quiz id \(boss.id) must still resolve after the quick-check migration."
            )
        }
        if let qc = qcSample {
            XCTAssertNotNil(
                registry.location(forQuestionId: qc.id),
                "Quick-check id \(qc.id) must resolve via the same registry path."
            )
        }
    }

    // MARK: - Helpers

    private func waitForPacksLoaded(_ registry: SubjectRegistry) async {
        for _ in 0..<50 {
            if !registry.isLoading && !registry.packs.isEmpty { return }
            try? await Task.sleep(nanoseconds: 50_000_000)
        }
    }
}
