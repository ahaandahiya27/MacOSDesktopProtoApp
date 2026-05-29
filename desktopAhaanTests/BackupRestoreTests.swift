import XCTest
@testable import desktopAhaan

/// Pins the parse + apply contract of `BackupRestoreButton`. The
/// flow is destructive (overwrites data dir files), so the test
/// matrix covers happy path + every refusal path so the kid's
/// progress is never silently corrupted by a wrong file.
final class BackupRestoreTests: XCTestCase {

    private var tempDir: URL!
    private var dataDir: URL!
    private var envelopeURL: URL!

    override func setUpWithError() throws {
        try super.setUpWithError()
        tempDir = FileManager.default.temporaryDirectory
            .appendingPathComponent("backup-restore-tests-\(UUID().uuidString)")
        dataDir = tempDir.appendingPathComponent("data")
        envelopeURL = tempDir.appendingPathComponent("envelope.json")
        try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)
    }

    override func tearDownWithError() throws {
        if let tempDir = tempDir {
            try? FileManager.default.removeItem(at: tempDir)
        }
        try super.tearDownWithError()
    }

    // MARK: - Parse

    func testParseV1EnvelopeReturnsSerializedFiles() throws {
        let envelope: [String: Any] = [
            "version": 1,
            "schema": "desktopAhaan-backup-v1",
            "createdAt": "20260529-120000Z",
            "files": [
                "attempts.json": ["lastReview": ["timestamp": 1_700_000_000]],
                "bookmarks.json": ["chapterIds": ["ch01", "ch07"]],
            ]
        ]
        try writeEnvelope(envelope)
        guard case .success(let parsed) = BackupRestoreButton.parseEnvelope(at: envelopeURL) else {
            XCTFail("parseEnvelope must succeed for a well-formed v1 envelope")
            return
        }
        XCTAssertEqual(parsed.files.count, 2)
        XCTAssertNotNil(parsed.files["attempts.json"])
        XCTAssertNotNil(parsed.files["bookmarks.json"])
        XCTAssertEqual(parsed.createdAt, "20260529-120000Z")
    }

    func testParseRefusesWrongSchema() throws {
        try writeEnvelope([
            "version": 1,
            "schema": "other-app-backup-v1",
            "files": [:]
        ])
        guard case .failure(let err) = BackupRestoreButton.parseEnvelope(at: envelopeURL) else {
            XCTFail("parseEnvelope must refuse wrong schema")
            return
        }
        XCTAssertTrue(
            (err.localizedDescription).contains("schema"),
            "Error must call out the schema mismatch: \(err.localizedDescription)"
        )
    }

    func testParseRefusesWrongVersion() throws {
        try writeEnvelope([
            "version": 2,
            "schema": "desktopAhaan-backup-v1",
            "files": [:]
        ])
        guard case .failure(let err) = BackupRestoreButton.parseEnvelope(at: envelopeURL) else {
            XCTFail("parseEnvelope must refuse non-v1 versions")
            return
        }
        XCTAssertTrue((err.localizedDescription).contains("version"),
                      "Error must call out the version mismatch.")
    }

    func testParseRefusesMissingFilesDict() throws {
        try writeEnvelope([
            "version": 1,
            "schema": "desktopAhaan-backup-v1",
            // intentionally no "files"
        ])
        if case .success = BackupRestoreButton.parseEnvelope(at: envelopeURL) {
            XCTFail("parseEnvelope must refuse envelopes missing `files`")
        }
    }

    func testParseRefusesNonJSONInput() throws {
        try "not valid {{ json".write(to: envelopeURL, atomically: true, encoding: .utf8)
        if case .success = BackupRestoreButton.parseEnvelope(at: envelopeURL) {
            XCTFail("parseEnvelope must refuse non-JSON input")
        }
    }

    // MARK: - Apply

    func testApplyEnvelopeWritesEveryFileAtomically() throws {
        try FileManager.default.createDirectory(at: dataDir, withIntermediateDirectories: true)
        let envelope = BackupRestoreButton.ParsedEnvelope(
            createdAt: "test",
            files: [
                "streak.json": try JSONSerialization.data(withJSONObject: ["current": 5, "best": 12], options: []),
                "favorites.json": try JSONSerialization.data(withJSONObject: ["ids": ["a", "b"]], options: []),
            ]
        )
        guard case .success(let count) = BackupRestoreButton.applyEnvelope(envelope, dataDir: dataDir) else {
            XCTFail("applyEnvelope must succeed when dataDir is writable")
            return
        }
        XCTAssertEqual(count, 2)
        XCTAssertTrue(FileManager.default.fileExists(atPath:
            dataDir.appendingPathComponent("streak.json").path))
        XCTAssertTrue(FileManager.default.fileExists(atPath:
            dataDir.appendingPathComponent("favorites.json").path))
    }

    func testApplyEnvelopeOverwritesExistingFiles() throws {
        try FileManager.default.createDirectory(at: dataDir, withIntermediateDirectories: true)
        let target = dataDir.appendingPathComponent("streak.json")
        try Data("OLD".utf8).write(to: target, options: .atomic)
        let envelope = BackupRestoreButton.ParsedEnvelope(
            createdAt: "test",
            files: ["streak.json": try JSONSerialization.data(withJSONObject: ["current": 99], options: [])]
        )
        guard case .success = BackupRestoreButton.applyEnvelope(envelope, dataDir: dataDir) else {
            XCTFail("applyEnvelope must overwrite existing files cleanly")
            return
        }
        let written = try Data(contentsOf: target)
        XCTAssertNotEqual(written, Data("OLD".utf8),
                          "Existing file content must be replaced by the envelope content.")
    }

    func testApplyEnvelopeCreatesDataDirIfMissing() throws {
        // dataDir intentionally not pre-created
        let envelope = BackupRestoreButton.ParsedEnvelope(
            createdAt: "test",
            files: ["a.json": try JSONSerialization.data(withJSONObject: ["x": 1], options: [])]
        )
        guard case .success(let count) = BackupRestoreButton.applyEnvelope(envelope, dataDir: dataDir) else {
            XCTFail("applyEnvelope must create missing dataDir before writing")
            return
        }
        XCTAssertEqual(count, 1)
        XCTAssertTrue(FileManager.default.fileExists(atPath: dataDir.path))
    }

    // MARK: - Round trip via BackupExportButton

    func testExportThenRestoreRoundTripsThePayload() throws {
        // Seed source dataDir with a known file
        let sourceDir = tempDir.appendingPathComponent("source-data")
        try FileManager.default.createDirectory(at: sourceDir, withIntermediateDirectories: true)
        let seed: [String: Any] = ["current": 7, "best": 14]
        try JSONSerialization.data(withJSONObject: seed, options: [])
            .write(to: sourceDir.appendingPathComponent("streak.json"), options: .atomic)

        // Export to envelope
        let envelopeOut = tempDir.appendingPathComponent("roundtrip.json")
        guard case .success = BackupExportButton.exportBundle(to: envelopeOut, dataDir: sourceDir) else {
            XCTFail("exportBundle must succeed when source data dir is writable")
            return
        }
        XCTAssertTrue(FileManager.default.fileExists(atPath: envelopeOut.path))

        // Parse the envelope back
        guard case .success(let parsed) = BackupRestoreButton.parseEnvelope(at: envelopeOut) else {
            XCTFail("parseEnvelope must accept the envelope just written by exportBundle")
            return
        }
        XCTAssertEqual(parsed.files.count, 1)

        // Apply into a fresh dataDir
        guard case .success(let n) = BackupRestoreButton.applyEnvelope(parsed, dataDir: dataDir) else {
            XCTFail("applyEnvelope must restore the round-tripped file")
            return
        }
        XCTAssertEqual(n, 1)
        let restored = try JSONSerialization.jsonObject(
            with: Data(contentsOf: dataDir.appendingPathComponent("streak.json"))
        ) as? [String: Int]
        XCTAssertEqual(restored?["current"], 7)
        XCTAssertEqual(restored?["best"], 14)
    }

    // MARK: - Helpers

    private func writeEnvelope(_ object: [String: Any]) throws {
        let data = try JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted])
        try data.write(to: envelopeURL, options: .atomic)
    }
}
