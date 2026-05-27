import XCTest
@testable import desktopAhaan

/// Covers the chapter-notebook "last edited" timestamp (drives the NotebookCard
/// recency badge) and the per-note preservation fix: setChapterNote previously
/// stamped EVERY note row with a fresh Date() on each save, so editing one
/// chapter's note reset every other chapter's last-edited time. Now each note
/// keeps its own timestamp.
///
/// Uses storeDir: + autoLoad: false (mirrors ArticleReadStateTests) so the
/// store starts empty and assertions aren't contaminated by on-disk data.
@MainActor
final class NotebookEditedAtTests: XCTestCase {

    private var tmp: URL!
    private var store: DataStore!

    override func setUp() async throws {
        try await super.setUp()
        tmp = URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent("desktopAhaan-notebook-\(UUID().uuidString)")
        try FileManager.default.createDirectory(at: tmp, withIntermediateDirectories: true)
        store = DataStore(streakCalendar: nil, storeDir: tmp, autoLoad: false)
    }

    override func tearDown() async throws {
        try? FileManager.default.removeItem(at: tmp)
        store = nil
        tmp = nil
        try await super.tearDown()
    }

    func testSettingANoteRecordsAnEditedAtTimestamp() {
        XCTAssertNil(store.chapterNoteEditedAt["ch01"])
        store.setChapterNote("photosynthesis recap", forChapterId: "ch01")
        XCTAssertNotNil(store.chapterNoteEditedAt["ch01"],
            "Saving a note must record a last-edited timestamp.")
    }

    func testClearingANoteRemovesItsTimestamp() {
        store.setChapterNote("temp", forChapterId: "ch01")
        store.setChapterNote("   ", forChapterId: "ch01")   // whitespace == clear
        XCTAssertNil(store.chapterNotes["ch01"])
        XCTAssertNil(store.chapterNoteEditedAt["ch01"],
            "Clearing a note must also drop its last-edited timestamp.")
    }

    /// The regression guard: editing chapter B must NOT bump chapter A's
    /// last-edited time.
    func testEditingOneNoteDoesNotResetAnothersTimestamp() {
        store.setChapterNote("A", forChapterId: "ch01")
        let aEditedFirst = store.chapterNoteEditedAt["ch01"]
        XCTAssertNotNil(aEditedFirst)

        // A later edit to a DIFFERENT chapter must leave ch01's stamp intact.
        store.setChapterNote("B", forChapterId: "ch02")
        XCTAssertEqual(store.chapterNoteEditedAt["ch01"], aEditedFirst,
            "Editing ch02 must not reset ch01's last-edited timestamp.")
        XCTAssertNotNil(store.chapterNoteEditedAt["ch02"])
    }
}
