import XCTest
@testable import desktopAhaan

/// Locks the boss-quiz SRS wiring across all 19 chapters. The Boss
/// Quiz is the kid's most-played answer surface in Science; every
/// chapter ships a `Scene9_BossQuiz*` view that — as of the
/// 2026-05-24 learning-loop session — writes through to the SRS
/// scheduler via `DataStore.recordEphemeralReview`. This test pins
/// two contracts:
///
///   1. **Manifest** — exactly 19 boss-quiz files exist (one per
///      chapter); each one carries the `recordEphemeralReview`
///      call site. If a new chapter ships without the wiring, this
///      test fails so the omission can't slip past code review.
///   2. **Id shape** — every wired site emits a stable id of the
///      form `bossquiz_ch%02d_q%02d`. The Daily Practice resolver
///      and the recently-missed router both branch on this prefix
///      via `DataStore.isEphemeralReviewId(_:)`; pinning the
///      format here means a careless rename in any one chapter is
///      caught by this test rather than by a kid's empty review
///      queue.
final class BossQuizSRSWiringTests: XCTestCase {

    /// Scan every `Scene9_BossQuiz*.swift` source under the repo
    /// and assert two invariants:
    ///   - File count == 19
    ///   - Each file contains a `recordEphemeralReview` call site
    ///   - Each file's call site uses the canonical id format
    ///
    /// The scan looks at the project tree rather than the running
    /// bundle so a brand-new chapter's wiring is caught at compile
    /// time of the test, not at the first kid who plays it.
    func testEvery19ChaptersHasBossQuizSRSWiring() throws {
        let bossQuizFiles = try Self.discoverBossQuizFiles()
        XCTAssertEqual(
            bossQuizFiles.count, 19,
            "Expected exactly 19 Scene9_BossQuiz*.swift files (one per chapter). Found:\n" +
                bossQuizFiles.map { "  - \($0.lastPathComponent)" }.joined(separator: "\n")
        )

        var missing: [String] = []
        var badFormat: [(String, String)] = []
        let idPattern = #"bossquiz_ch%02d_q%02d"#

        for file in bossQuizFiles {
            let body = try String(contentsOf: file, encoding: .utf8)
            guard body.contains("recordEphemeralReview") else {
                missing.append(file.lastPathComponent)
                continue
            }
            if !body.contains(idPattern) {
                badFormat.append((file.lastPathComponent, body))
            }
        }

        XCTAssertTrue(missing.isEmpty,
            "These boss-quiz files don't call recordEphemeralReview:\n" +
            missing.map { "  - \($0)" }.joined(separator: "\n")
        )
        XCTAssertTrue(badFormat.isEmpty,
            "These boss-quiz files emit a non-canonical ephemeral id format:\n" +
            badFormat.map { "  - \($0.0)" }.joined(separator: "\n") +
            "\nExpected substring: \(idPattern)"
        )
    }

    // MARK: - File discovery

    /// Walk the source tree from this test file's location, looking
    /// for any `Scene9_BossQuiz*.swift`. The walk starts from the
    /// repo root (resolved from the build product's path), so it
    /// works whether the test runs from Xcode or a `xcodebuild test`
    /// command line.
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

    /// Best-effort repo-root finder for use from a test runner.
    /// Walks up from the test bundle until it finds a directory
    /// containing both `desktopAhaan.xcodeproj` and `scripts/`.
    private static func locateRepoRoot() -> URL {
        var url = Bundle(for: BossQuizSRSWiringTests.self).bundleURL
        for _ in 0..<8 {
            let probe = url.appendingPathComponent("desktopAhaan.xcodeproj")
            if FileManager.default.fileExists(atPath: probe.path) {
                return url
            }
            url.deleteLastPathComponent()
        }
        // Hardcoded fallback for the dev mac; the iMac path is the
        // other half of the cross-machine workflow and resolves
        // through the dev-mac path during CI.
        return URL(fileURLWithPath: "/Users/mac/Documents/Claude/Projects/DesktopAhaan/DesktopAhaan/desktopAhaan")
    }
}
