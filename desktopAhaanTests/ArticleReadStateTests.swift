import XCTest
@testable import desktopAhaan

/// Pins the `Mark as read` flow shipped 2026-05-26 — the
/// `DataStore.readArticleIds` published set + the three helpers
/// in `DataStore+ArticleReads.swift` (`isArticleRead`,
/// `toggleArticleRead`, `markArticleRead`).
///
/// Uses the `storeDir:` + `autoLoad: false` init parameters added
/// 2026-05-26 to isolate each test from both the user's real
/// Application Support directory AND the off-thread load that
/// would otherwise race `setUp()`. Without those parameters, the
/// async `loadAllOffThread` would race the test's state setup
/// and contaminate assertions with whatever was on disk.
@MainActor
final class ArticleReadStateTests: XCTestCase {

    private var tmp: URL!
    private var store: DataStore!

    override func setUp() async throws {
        try await super.setUp()
        tmp = URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent("desktopAhaan-readstate-\(UUID().uuidString)")
        try FileManager.default.createDirectory(at: tmp,
                                                withIntermediateDirectories: true)
        // autoLoad: false skips the off-thread JSON read, so the
        // store starts with empty @Published state — no race.
        store = DataStore(streakCalendar: nil, storeDir: tmp, autoLoad: false)
    }

    override func tearDown() async throws {
        try? FileManager.default.removeItem(at: tmp)
        store = nil
        tmp = nil
        try await super.tearDown()
    }

    func testToggleArticleReadInsertsAndRemoves() {
        let id = "ch01_glossary"
        XCTAssertFalse(store.isArticleRead(id),
            "Fresh store should not have any article marked.")
        store.toggleArticleRead(id)
        XCTAssertTrue(store.isArticleRead(id),
            "First toggle should mark the article as read.")
        store.toggleArticleRead(id)
        XCTAssertFalse(store.isArticleRead(id),
            "Second toggle should unmark the article.")
    }

    func testMarkArticleReadIsIdempotent() {
        let id = "ch07_scientists"
        store.markArticleRead(id)
        XCTAssertEqual(store.readArticleIds.count, 1)
        store.markArticleRead(id)
        XCTAssertEqual(store.readArticleIds.count, 1,
            "markArticleRead must not insert a duplicate.")
    }

    func testIsArticleReadFalseForUnknownId() {
        XCTAssertFalse(store.isArticleRead("ch99_does_not_exist"),
            "Unknown id must return false, not crash.")
    }

    func testMultipleArticlesTrackedIndependently() {
        store.markArticleRead("ch01_glossary")
        store.markArticleRead("ch05_whatif")
        XCTAssertEqual(store.readArticleIds.count, 2)
        XCTAssertTrue(store.isArticleRead("ch01_glossary"))
        XCTAssertTrue(store.isArticleRead("ch05_whatif"))
        XCTAssertFalse(store.isArticleRead("ch01_beyond"))
    }
}
