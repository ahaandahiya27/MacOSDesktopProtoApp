import XCTest
@testable import desktopAhaan

/// Pins the entitlement surface so a future commit can't silently
/// expand the app's permissions. Closes Family H.7 of
/// `BUG_FREE_CERTIFICATION_REPORT.md`.
///
/// The set below is the **exhaustive** set of entitlements
/// `desktopAhaan.entitlements` ships today. Every key is justified
/// in the file's leading XML comment block; if a feature requires
/// a new permission, add the key here in the same commit that
/// updates the .entitlements file, with a one-line note in the
/// comment block explaining the use case.
final class EntitlementsSnapshotTest: XCTestCase {

    /// Locked entitlement set. Order is alphabetical for stable diffs.
    ///
    /// 2026-06-06: `files.user-selected.read-only` → `read-write` because
    /// the new Olympiad "Save PDF" NSSavePanel needs the read-write
    /// variant. The read-only variant alone hard-crashes the panel
    /// construction with EXC_BREAKPOINT and "your app has the User
    /// Selected File Read entitlement but it lacks User Selected File
    /// Read/Write to display save panels". The OCR Open Image use
    /// case still works under read-write (it's a superset).
    private let expectedKeys: Set<String> = [
        "com.apple.security.app-sandbox",
        "com.apple.security.device.audio-input",
        "com.apple.security.files.user-selected.read-write",
        "com.apple.security.network.client",
        "com.apple.security.temporary-exception.files.home-relative-path.read-write",
    ]

    func testEntitlementsFileContainsOnlyExpectedKeys() throws {
        let url = try locateEntitlementsFile()
        let data = try Data(contentsOf: url)
        guard let plist = try PropertyListSerialization.propertyList(
            from: data, options: [], format: nil
        ) as? [String: Any] else {
            XCTFail("entitlements file is not a top-level dict plist")
            return
        }
        let actualKeys = Set(plist.keys)

        let unexpected = actualKeys.subtracting(expectedKeys)
        XCTAssertTrue(unexpected.isEmpty,
            "Entitlements file declares permission(s) not on the pinned " +
            "set: \(unexpected.sorted()). Either remove the key or, if " +
            "a new feature requires it, add it to expectedKeys in this " +
            "test along with a justification in the .entitlements " +
            "comment block.")

        let missing = expectedKeys.subtracting(actualKeys)
        XCTAssertTrue(missing.isEmpty,
            "Entitlements file is MISSING expected key(s): \(missing.sorted()). " +
            "If a key was intentionally removed (e.g. a feature retired), " +
            "delete it from expectedKeys in this test in the same commit.")
    }

    func testTemporaryExceptionDocumentsScopeIsLockedRoot() throws {
        // The temp-exception entitlement was the TCC popup fix. It should
        // be scoped to exactly ["/Documents/"] — broadening that array
        // (e.g. to "/Documents/Private/" or "/" itself) would be a real
        // permissions expansion that wants explicit review.
        let url = try locateEntitlementsFile()
        let data = try Data(contentsOf: url)
        guard let plist = try PropertyListSerialization.propertyList(
            from: data, options: [], format: nil
        ) as? [String: Any] else {
            XCTFail("entitlements not parseable")
            return
        }
        let key = "com.apple.security.temporary-exception.files.home-relative-path.read-write"
        guard let paths = plist[key] as? [String] else {
            XCTFail("temp-exception key must be an array of strings; got \(String(describing: plist[key]))")
            return
        }
        XCTAssertEqual(paths, ["/Documents/"],
            "Temp-exception scope must remain exactly [\"/Documents/\"]. " +
            "Broadening it is a real permissions expansion — update this " +
            "test deliberately if the change is intended.")
    }

    // MARK: - Helpers

    private func locateEntitlementsFile() throws -> URL {
        // Walk up from the test bundle to the repo root (same pattern
        // as BossQuizSRSWiringTests.locateRepoRoot).
        var url = Bundle(for: type(of: self)).bundleURL
        for _ in 0..<8 {
            let candidate = url
                .appendingPathComponent("desktopAhaan")
                .appendingPathComponent("desktopAhaan.entitlements")
            if FileManager.default.fileExists(atPath: candidate.path) {
                return candidate
            }
            url.deleteLastPathComponent()
        }
        // Hardcoded fallback for the dev Mac layout.
        let hard = URL(fileURLWithPath:
            "/Users/mac/Documents/Claude/Projects/DesktopAhaan/DesktopAhaan/desktopAhaan/desktopAhaan/desktopAhaan.entitlements")
        if FileManager.default.fileExists(atPath: hard.path) {
            return hard
        }
        throw NSError(domain: "EntitlementsSnapshotTest", code: 1,
            userInfo: [NSLocalizedDescriptionKey: "could not locate desktopAhaan.entitlements"])
    }
}
