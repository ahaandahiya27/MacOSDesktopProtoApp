import XCTest
@testable import desktopAhaan

/// Pins the format of the backup envelope written by
/// `BackupExportButton.exportBundle(to:dataDir:now:)`. Future schema
/// changes that break the v1 contract fail this test before they
/// ship — the parent might be holding an old backup file we still
/// need to be able to restore.
final class BackupExportTests: XCTestCase {

    private var tempDir: URL!
    private var dataDir: URL!
    private var destination: URL!

    override func setUpWithError() throws {
        try super.setUpWithError()
        tempDir = FileManager.default.temporaryDirectory
            .appendingPathComponent("backup-export-tests-\(UUID().uuidString)")
        dataDir = tempDir.appendingPathComponent("data")
        try FileManager.default.createDirectory(at: dataDir,
                                                withIntermediateDirectories: true)
        destination = tempDir.appendingPathComponent("backup.json")
    }

    override func tearDownWithError() throws {
        if let tempDir = tempDir {
            try? FileManager.default.removeItem(at: tempDir)
        }
        try super.tearDownWithError()
    }

    func testExportBundleWrapsEveryJSONFileInTheDataDir() throws {
        try seed("attempts.json", json: ["lastReview": ["timestamp": 1_700_000_000]])
        try seed("bookmarks.json", json: ["chapterIds": ["ch01", "ch07"]])
        try seed("streak.json", json: ["current": 4, "best": 7])

        let result = BackupExportButton.exportBundle(
            to: destination, dataDir: dataDir, now: Date(timeIntervalSince1970: 0)
        )
        guard case .success(let count) = result else {
            XCTFail("exportBundle failed: \(result)")
            return
        }
        XCTAssertEqual(count, 3, "expected all 3 seeded files bundled")
        XCTAssertTrue(FileManager.default.fileExists(atPath: destination.path),
                      "destination file must be written")

        let payload = try JSONSerialization.jsonObject(with: Data(contentsOf: destination)) as? [String: Any]
        XCTAssertNotNil(payload, "destination must be valid JSON")
        XCTAssertEqual(payload?["version"] as? Int, 1)
        XCTAssertEqual(payload?["schema"] as? String, "desktopAhaan-backup-v1")
        XCTAssertNotNil(payload?["createdAt"] as? String)
        let files = payload?["files"] as? [String: Any]
        XCTAssertNotNil(files)
        XCTAssertNotNil(files?["attempts.json"])
        XCTAssertNotNil(files?["bookmarks.json"])
        XCTAssertNotNil(files?["streak.json"])
    }

    func testExportBundleSkipsCorruptJSONButStillSucceeds() throws {
        try seed("good.json", json: ["k": "v"])
        try "not valid {{ json".write(to: dataDir.appendingPathComponent("bad.json"),
                                       atomically: true, encoding: .utf8)
        let result = BackupExportButton.exportBundle(
            to: destination, dataDir: dataDir
        )
        guard case .success(let count) = result else {
            XCTFail("exportBundle failed: \(result)")
            return
        }
        XCTAssertEqual(count, 1, "valid file bundled; corrupt file skipped")
        let payload = try JSONSerialization.jsonObject(with: Data(contentsOf: destination)) as? [String: Any]
        let files = payload?["files"] as? [String: Any]
        XCTAssertNotNil(files?["good.json"])
        XCTAssertNil(files?["bad.json"], "corrupt file must NOT appear in the envelope")
    }

    func testExportBundleFailsCleanlyWhenDataDirIsMissing() throws {
        let missingDir = tempDir.appendingPathComponent("does-not-exist")
        let result = BackupExportButton.exportBundle(
            to: destination, dataDir: missingDir
        )
        if case .success = result {
            XCTFail("expected failure when dataDir is missing, got success")
        }
    }

    func testDefaultDataDirPointsAtCanonicalLocation() {
        let url = BackupExportButton.defaultDataDir()
        XCTAssertTrue(url.path.contains("com.emoha.desktopAhaan/data"),
                      "default data dir must live under the bundle id namespace: \(url.path)")
    }

    // MARK: - Helpers

    private func seed(_ name: String, json: Any) throws {
        let data = try JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted])
        try data.write(to: dataDir.appendingPathComponent(name), options: .atomic)
    }
}
