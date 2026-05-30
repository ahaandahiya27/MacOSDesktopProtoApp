import XCTest
@testable import desktopAhaan

/// Round-trips engine state through `adaptive_difficulty.json` on a temp
/// store and verifies `recordOutcome` drives `currentBand`. Deterministic:
/// isolated temp dir per test, no shared singleton, no live DataStore.
@MainActor
final class AdaptiveDifficultyPersistenceTests: XCTestCase {

    private func tempDir() -> URL {
        let dir = FileManager.default.temporaryDirectory
            .appendingPathComponent("adaptive-\(UUID().uuidString)")
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir
    }

    // MARK: - recordOutcome → band

    func testRecordOutcomeDrivesBand() {
        let engine = AdaptiveDifficultyEngine(storeDir: tempDir(), autoLoad: false)
        // Fresh chapter is neutral.
        XCTAssertEqual(engine.currentBand(forChapter: "ch01", packId: "science_class7"), .core)
        // Five correct → stretch.
        for _ in 0..<5 {
            engine.recordOutcome(questionId: "ch01_t01_q01", correct: true,
                                 chapterId: "ch01", packId: "science_class7")
        }
        XCTAssertEqual(engine.currentBand(forChapter: "ch01", packId: "science_class7"), .stretch)
    }

    func testWindowsAreScopedByPackAndChapter() {
        let engine = AdaptiveDifficultyEngine(storeDir: tempDir(), autoLoad: false)
        for _ in 0..<5 {
            engine.recordOutcome(questionId: "ch01_t01_q01", correct: true,
                                 chapterId: "ch01", packId: "science_class7")
        }
        // Same bare chapter id, different pack → independent window.
        XCTAssertEqual(engine.currentBand(forChapter: "ch01", packId: "maths_class7"), .core)
        XCTAssertEqual(engine.currentBand(forChapter: "ch01", packId: "science_class7"), .stretch)
    }

    // MARK: - Persistence round-trip

    func testStatePersistsAcrossReload() {
        let dir = tempDir()
        let engine = AdaptiveDifficultyEngine(storeDir: dir, autoLoad: false)
        for _ in 0..<5 {
            engine.recordOutcome(questionId: "ch02_t01_q01", correct: true,
                                 chapterId: "ch02", packId: "science_class7")
        }
        engine.flushSaveAndReloadForTesting()
        XCTAssertEqual(engine.currentBand(forChapter: "ch02", packId: "science_class7"), .stretch,
                       "Window survives a flush + reload from disk.")

        // A brand-new engine pointed at the same dir auto-loads the file.
        let reopened = AdaptiveDifficultyEngine(storeDir: dir, autoLoad: true)
        XCTAssertEqual(reopened.currentBand(forChapter: "ch02", packId: "science_class7"), .stretch,
                       "A fresh engine auto-loads the persisted window.")
    }

    func testFreshEngineWithNoFileIsAllCore() {
        let reopened = AdaptiveDifficultyEngine(storeDir: tempDir(), autoLoad: true)
        XCTAssertEqual(reopened.currentBand(forChapter: "ch09", packId: "science_class7"), .core)
    }

    // MARK: - State model round-trip (Codable)

    func testStateCodableRoundTrip() throws {
        var state = AdaptivePracticeState()
        state.windows[AdaptivePracticeState.windowKey(packId: "p", chapterId: "ch01")] =
            PracticeWindow(outcomes: [true, false, true])
        let data = try JSONEncoder().encode([state])
        let decoded = try JSONDecoder().decode([AdaptivePracticeState].self, from: data)
        XCTAssertEqual(decoded.first, state)
    }
}
