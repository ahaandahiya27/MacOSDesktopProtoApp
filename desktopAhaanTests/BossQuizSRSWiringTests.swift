import XCTest
@testable import desktopAhaan

/// Locks the boss-quiz SRS wiring across all 19 chapters. As of the
/// 2026-05-25 content migration, each `Scene9_BossQuiz*` view loads
/// its MCQ items from `chapter.bossQuestions` in the pack and writes
/// the answer through to the SRS scheduler via
/// `DataStore.recordReview(questionId:quality:)` using the canonical
/// pack id. This test pins three contracts:
///
///   1. **Manifest** — exactly 19 boss-quiz files exist (one per
///      chapter).
///   2. **Wiring** — each file contains a `recordReview` call site.
///      A new chapter that forgets the wiring fails this test rather
///      than silently dropping wrong answers from "Recently Missed".
///   3. **No legacy `recordEphemeralReview`** — the pre-migration
///      ephemeral path is gone; any chapter still calling the old
///      API is using an id that won't resolve through
///      `SubjectRegistry.location(forQuestionId:)`. (The legacy
///      `DataStore.recordEphemeralReview` API itself is still kept
///      for the hint-ladder path in QuestionDetailView; this test
///      only forbids it inside `Scene9_BossQuiz*` files.)
final class BossQuizSRSWiringTests: XCTestCase {

    func testEvery19ChaptersHasBossQuizSRSWiring() throws {
        let bossQuizFiles = try Self.discoverBossQuizFiles()
        XCTAssertEqual(
            bossQuizFiles.count, 19,
            "Expected exactly 19 Scene9_BossQuiz*.swift files (one per chapter). Found:\n" +
                bossQuizFiles.map { "  - \($0.lastPathComponent)" }.joined(separator: "\n")
        )

        var missingRecordReview: [String] = []
        var carriesLegacyEphemeral: [String] = []
        var carriesLegacyFormatString: [String] = []

        for file in bossQuizFiles {
            let body = try String(contentsOf: file, encoding: .utf8)
            if !body.contains("DataStore.shared.recordReview(") {
                missingRecordReview.append(file.lastPathComponent)
            }
            if body.contains("recordEphemeralReview") {
                carriesLegacyEphemeral.append(file.lastPathComponent)
            }
            if body.contains("bossquiz_ch%02d_q%02d") {
                carriesLegacyFormatString.append(file.lastPathComponent)
            }
        }

        XCTAssertTrue(missingRecordReview.isEmpty,
            "These boss-quiz files don't call DataStore.shared.recordReview(...):\n" +
            missingRecordReview.map { "  - \($0)" }.joined(separator: "\n")
        )
        XCTAssertTrue(carriesLegacyEphemeral.isEmpty,
            "These boss-quiz files still use the pre-migration recordEphemeralReview API:\n" +
            carriesLegacyEphemeral.map { "  - \($0)" }.joined(separator: "\n") +
            "\nSwitch to DataStore.shared.recordReview(questionId:quality:) using the pack Question.id."
        )
        XCTAssertTrue(carriesLegacyFormatString.isEmpty,
            "These boss-quiz files still build the id via String(format: \"bossquiz_ch%02d_q%02d\", ...):\n" +
            carriesLegacyFormatString.map { "  - \($0)" }.joined(separator: "\n") +
            "\nPass the pack Question.id directly — the JSON-authored id IS the canonical id."
        )
    }

    // MARK: - File discovery

    private static func discoverBossQuizFiles() throws -> [URL] {
        let repoRoot = locateRepoRoot()
        let discoverRoot = repoRoot
            .appendingPathComponent("desktopAhaan")
            .appendingPathComponent("Subjects")
            .appendingPathComponent("Tutor")
            .appendingPathComponent("Discover")

        var found: [URL] = []
        guard let enumerator = FileManager.default.enumerator(
            at: discoverRoot,
            includingPropertiesForKeys: [.isRegularFileKey],
            options: [.skipsHiddenFiles]
        ) else {
            throw NSError(domain: "BossQuizSRSWiringTests", code: 1)
        }
        for case let url as URL in enumerator {
            let name = url.lastPathComponent
            guard name.hasPrefix("Scene9_BossQuiz") && name.hasSuffix(".swift") else { continue }
            found.append(url)
        }
        return found.sorted { $0.lastPathComponent < $1.lastPathComponent }
    }

    private static func locateRepoRoot() -> URL {
        var url = Bundle(for: BossQuizSRSWiringTests.self).bundleURL
        for _ in 0..<8 {
            let probe = url.appendingPathComponent("desktopAhaan.xcodeproj")
            if FileManager.default.fileExists(atPath: probe.path) {
                return url
            }
            url.deleteLastPathComponent()
        }
        return URL(fileURLWithPath: "/Users/mac/Documents/Claude/Projects/DesktopAhaan/DesktopAhaan/desktopAhaan")
    }
}
