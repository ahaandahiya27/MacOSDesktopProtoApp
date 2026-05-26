import XCTest
@testable import desktopAhaan

/// Pins the "I understand this" concept-tracking flow shipped
/// 2026-05-26 — `DataStore.understoodConceptIds` + the four
/// helpers in `DataStore+ConceptUnderstood.swift`:
/// `isConceptUnderstood`, `toggleConceptUnderstood`,
/// `markConceptUnderstood`, `understoodCount(forChapterId:)`.
///
/// Uses the `storeDir:` + `autoLoad: false` init parameters
/// added 2026-05-26 (commit cef9a50) for test isolation.
@MainActor
final class ConceptUnderstoodTests: XCTestCase {

    private var tmp: URL!
    private var store: DataStore!

    override func setUp() async throws {
        try await super.setUp()
        tmp = URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent("desktopAhaan-understood-\(UUID().uuidString)")
        try FileManager.default.createDirectory(at: tmp,
                                                withIntermediateDirectories: true)
        store = DataStore(streakCalendar: nil, storeDir: tmp, autoLoad: false)
    }

    override func tearDown() async throws {
        try? FileManager.default.removeItem(at: tmp)
        store = nil
        tmp = nil
        try await super.tearDown()
    }

    func testToggleConceptUnderstoodInsertsAndRemoves() {
        let id = "ch01_t01_c01"
        XCTAssertFalse(store.isConceptUnderstood(id))
        store.toggleConceptUnderstood(id)
        XCTAssertTrue(store.isConceptUnderstood(id))
        store.toggleConceptUnderstood(id)
        XCTAssertFalse(store.isConceptUnderstood(id))
    }

    func testMarkConceptUnderstoodIsIdempotent() {
        store.markConceptUnderstood("ch01_t01_c01")
        XCTAssertEqual(store.understoodConceptIds.count, 1)
        store.markConceptUnderstood("ch01_t01_c01")
        XCTAssertEqual(store.understoodConceptIds.count, 1,
            "markConceptUnderstood must not duplicate.")
    }

    func testUnderstoodCountFiltersByChapterPrefix() {
        // Sprinkle understood marks across 3 chapters
        store.markConceptUnderstood("ch01_t01_c01")
        store.markConceptUnderstood("ch01_t01_c02")
        store.markConceptUnderstood("ch01_t02_c01")
        store.markConceptUnderstood("ch05_t01_c01")
        store.markConceptUnderstood("ch19_t01_c03")

        XCTAssertEqual(store.understoodCount(forChapterId: "ch01"), 3,
            "Ch.1 should count exactly the three ch01_* concept ids.")
        XCTAssertEqual(store.understoodCount(forChapterId: "ch05"), 1)
        XCTAssertEqual(store.understoodCount(forChapterId: "ch19"), 1)
        XCTAssertEqual(store.understoodCount(forChapterId: "ch02"), 0,
            "Chapter with no understood concepts should return 0, not crash.")
    }

    func testUnderstoodCountDoesntMatchOverlappingPrefix() {
        // ch01 prefix shouldn't accidentally match ch10/ch11/etc.
        store.markConceptUnderstood("ch01_t01_c01")
        store.markConceptUnderstood("ch10_t01_c01")
        store.markConceptUnderstood("ch11_t01_c01")
        XCTAssertEqual(store.understoodCount(forChapterId: "ch01"), 1,
            "ch01_ prefix must not match ch10_/ch11_ (underscore guard).")
        XCTAssertEqual(store.understoodCount(forChapterId: "ch10"), 1)
        XCTAssertEqual(store.understoodCount(forChapterId: "ch11"), 1)
    }

    func testIsConceptUnderstoodFalseForUnknownId() {
        XCTAssertFalse(store.isConceptUnderstood("ch99_t99_c99"))
    }
}
