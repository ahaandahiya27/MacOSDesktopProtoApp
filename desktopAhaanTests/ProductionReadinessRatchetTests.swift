import XCTest
@testable import desktopAhaan

/// Cross-cutting ratchet for the production-readiness criteria that
/// ship with the 2026-05-29 prod-polish sweep. Most criteria already
/// have their own dedicated test class (perf budgets, content quality,
/// concept-map edges, Dynamic Type, a11y label coverage); this file
/// pins the *remaining* invariants that don't have a natural home:
///
///   1. CrashReporter writes to the canonical Application Support
///      sub-path (not the Documents tree, not the Caches tree). The
///      Help menu's "Reveal Crash Logs in Finder" depends on this
///      path matching what the parent will eventually browse to.
///   2. BackupExportButton.defaultDataDir() resolves to the
///      `com.emoha.desktopAhaan/data` namespace under Application
///      Support — the same path DataStore uses to write its
///      persisted JSON. A backup that pointed at the wrong dir would
///      silently produce empty bundles.
///   3. All three subject packs are bundled and decodable. This is
///      the absolute floor — if any pack fails to decode, every
///      surface that reads pack data is dead on launch.
final class ProductionReadinessRatchetTests: XCTestCase {

    func testCrashReporterWritesToCanonicalPath() {
        let url = CrashReporter.shared.logDirectoryURL
        XCTAssertTrue(url.path.contains("Application Support"),
            "Crash logs must live under Application Support — got \(url.path)")
        XCTAssertTrue(url.path.contains("desktopAhaan/crashlogs") ||
                      url.path.contains("desktopAhaan%2Fcrashlogs"),
            "Crash log directory must end in desktopAhaan/crashlogs — got \(url.path)")
    }

    func testBackupExportDefaultDirIsBundleIdNamespaced() {
        let url = BackupExportButton.defaultDataDir()
        XCTAssertTrue(url.path.contains("Application Support"),
            "Backup default data dir must live under Application Support — got \(url.path)")
        XCTAssertTrue(url.path.contains("com.emoha.desktopAhaan/data") ||
                      url.path.contains("com.emoha.desktopAhaan%2Fdata"),
            "Backup default data dir must end in com.emoha.desktopAhaan/data " +
            "(the namespace DataStore writes to) — got \(url.path)")
    }

    func testAllThreeSubjectPacksAreBundledAndDecodable() throws {
        for packId in ["science_class7", "maths_class7", "sanskrit_class7"] {
            guard let url = Bundle.main.url(forResource: packId, withExtension: "json") else {
                XCTFail("[\(packId)] not bundled — every release must ship all 3 packs.")
                continue
            }
            let data = try Data(contentsOf: url)
            do {
                _ = try JSONDecoder().decode(SubjectPack.self, from: data)
            } catch {
                XCTFail("[\(packId)] failed to decode: \(error)")
            }
        }
    }
}
