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

    // MARK: - 2026-06-13 audit-D additions
    //
    // These ratchets extend ProductionReadinessRatchetTests with the
    // gaps surfaced by the deep audit. All four are source-level
    // (read project files via #filePath relative paths) so they don't
    // need a subprocess or a network — they fail loudly on any future
    // regression without flaking on macOS version differences.

    /// Resolve a path inside the repo root from this test file.
    /// `#filePath` is `.../desktopAhaanTests/ProductionReadinessRatchetTests.swift`;
    /// the repo root is two parents up.
    private func repoRootURL(_ relativePath: String) -> URL {
        let here = URL(fileURLWithPath: #filePath)
        let repoRoot = here.deletingLastPathComponent().deletingLastPathComponent()
        return repoRoot.appendingPathComponent(relativePath)
    }

    /// HardwareTier exposes plausibly-bounded particle / FPS budgets on the
    /// current host. On the dev Mac (modern) we expect the modern branch;
    /// the legacy branch (Big-Sur iMac, AMD R9 M290X) ships smaller values.
    /// Either way both fall in a sane range — a future "particleBudget = 0"
    /// or "= 10_000" regression would silently change UX/perf and this
    /// catches it.
    func testHardwareTierBudgetsAreReasonable() {
        XCTAssertGreaterThanOrEqual(HardwareTier.particleBudget, 20,
            "particleBudget too small — even legacy iMac should support ≥20 particles.")
        XCTAssertLessThanOrEqual(HardwareTier.particleBudget, 200,
            "particleBudget too large — would tank the AMD R9 M290X on legacy.")
        XCTAssertGreaterThanOrEqual(HardwareTier.animationFPS, 15,
            "animationFPS too low — below-15 fps is visibly stuttery.")
        XCTAssertLessThanOrEqual(HardwareTier.animationFPS, 60,
            "animationFPS too high — above-60 wastes battery without visible benefit on macOS.")
    }

    /// `DataStore.swift` is required to use `options: .atomic` on every
    /// disk write — a partial / interrupted write to the persistent
    /// Application Support directory could orphan the JSON and crash
    /// decode on next launch. CLAUDE.md / `check_atomic_writes.py` enforce
    /// this; this test adds a redundant source-level pin so a future split
    /// of DataStore can't accidentally drop the option.
    func testDataStoreEveryWriteUsesAtomicOption() throws {
        let url = repoRootURL("desktopAhaan/Services/Persistence/DataStore.swift")
        let src = try String(contentsOf: url, encoding: .utf8)
        // Match `Data(...).write(to:` and `try data.write(to:` and similar.
        // We allow the call when `.atomic` (or `options: .atomic`) appears
        // anywhere on the same line OR up to 80 chars after the `write(to:`
        // anchor (the option lives in the next param of the same call).
        let pattern = #"\.write\(to:"#
        let regex = try NSRegularExpression(pattern: pattern, options: [])
        let nsSrc = src as NSString
        let range = NSRange(location: 0, length: nsSrc.length)
        var offenders: [String] = []
        regex.enumerateMatches(in: src, options: [], range: range) { match, _, _ in
            guard let r = match?.range else { return }
            // Take 240 chars of context starting at the `.write(to:` call
            // so we capture the multi-line argument list.
            let end = min(r.location + 240, nsSrc.length)
            let snippet = nsSrc.substring(with: NSRange(location: r.location, length: end - r.location))
            if !snippet.contains(".atomic") {
                // Find line number for the diagnostic.
                let prefix = nsSrc.substring(to: r.location)
                let line = prefix.components(separatedBy: "\n").count
                offenders.append("DataStore.swift:\(line) — `.write(to:` without `.atomic` within 240 chars")
            }
        }
        XCTAssertTrue(offenders.isEmpty,
            "DataStore must use options: .atomic on every disk write. Offenders:\n  " +
            offenders.joined(separator: "\n  "))
    }

    /// `SFSymbolCompat.name(_:)` ships a Big-Sur fallback table. If the table
    /// shrinks dramatically (e.g., someone refactors and accidentally drops
    /// 90% of the rows), every SF Symbols 3+/4+ name in the codebase
    /// renders as a blank glyph on the deploy iMac.
    ///
    /// Pin a floor of 40 cases (current is 51 as of 2026-06-13). A
    /// regression here would be invisible on the dev Mac (modern macOS
    /// passes the name through unchanged) but break the iMac UI.
    func testSFSymbolCompatTableMeetsCoverageFloor() throws {
        let url = repoRootURL("desktopAhaan/Extensions/Extensions.swift")
        let src = try String(contentsOf: url, encoding: .utf8)
        // Find the SFSymbolCompat enum body.
        guard let enumStart = src.range(of: "enum SFSymbolCompat") else {
            XCTFail("SFSymbolCompat enum not found in Extensions.swift")
            return
        }
        // Take 6000 chars after the enum opens — covers ~80 case rows comfortably.
        let after = src[enumStart.lowerBound...]
        let bodyEnd = after.index(after.startIndex, offsetBy: min(6000, after.count))
        let body = String(after[after.startIndex..<bodyEnd])
        // Each fallback row is shaped: `case "<modern>": return "<fallback>"`
        let pattern = #"case\s*"[^"]+"\s*:\s*return\s*"[^"]+""#
        let regex = try NSRegularExpression(pattern: pattern, options: [])
        let matchCount = regex.numberOfMatches(in: body, options: [],
            range: NSRange(location: 0, length: (body as NSString).length))
        XCTAssertGreaterThanOrEqual(matchCount, 40,
            "SFSymbolCompat fallback table dropped below 40 entries (found \(matchCount)). " +
            "Big-Sur SF Symbols 2 needs the fallback map; do not prune without verifying " +
            "every modern name in the codebase has either a fallback row or a Big-Sur-2 baseline name.")
    }

    // Note: a11y label coverage is enforced by check_a11y_labels.py at the
    // commit/push gate (floor bumped 90 → 99 on 2026-06-13, current state
    // 706/706 exact). A Swift-side test that re-implements the lint's
    // heuristic would be brittle — heuristics drift, and the Python
    // implementation has the canonical rules (custom-view suffix credit
    // for *Card/*Row/*Chip, Button("literal") head match, etc.). Trust
    // the lint; this file holds only ratchets where the Swift-side check
    // adds something distinct.
}
