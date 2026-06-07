import XCTest
@testable import desktopAhaan

/// Exercises the persistence + read-accessor contract for the
/// Olympiad attempt store. Each test gets a unique temp `storeDir`
/// so writes are isolated. `autoLoad: false` skips the cold-launch
/// off-thread read that would race the test setup.
@MainActor
final class OlympiadAttemptStoreTests: XCTestCase {

    private func tempStore() -> DataStore {
        let dir = FileManager.default.temporaryDirectory
            .appendingPathComponent("oly-attempts-\(UUID().uuidString)")
        return DataStore(streakCalendar: nil, storeDir: dir, autoLoad: false)
    }

    private func attempt(
        paperId: String = "olympiad_science_ch13",
        percentage: Int = 70,
        at date: Date = Date(),
        correct: Int = 42,
        wrong: Int = 12,
        skipped: Int = 6
    ) -> OlympiadAttempt {
        OlympiadAttempt(
            id: UUID(),
            paperId: paperId,
            attemptedAt: date,
            correct: correct,
            wrong: wrong,
            skipped: skipped,
            scoreOutOfMax: correct * 4 - wrong,
            maxMarks: 240,
            percentage: percentage
        )
    }

    // MARK: - Basic record + recall

    func testRecordingMakesAttemptVisibleToReader() {
        let store = tempStore()
        let a = attempt()
        store.recordOlympiadAttempt(a)
        XCTAssertEqual(store.olympiadAttempts(forPaperId: a.paperId).count, 1)
        XCTAssertEqual(store.olympiadAttempts(forPaperId: a.paperId).first?.id, a.id)
    }

    func testUnknownPaperReturnsEmptyList() {
        let store = tempStore()
        store.recordOlympiadAttempt(attempt(paperId: "olympiad_science_ch13"))
        XCTAssertTrue(store.olympiadAttempts(forPaperId: "olympiad_maths_ch01").isEmpty)
    }

    // MARK: - Multiple attempts per paper

    func testBestReturnsHighestPercentage() {
        let store = tempStore()
        store.recordOlympiadAttempt(attempt(percentage: 42))
        store.recordOlympiadAttempt(attempt(percentage: 86))
        store.recordOlympiadAttempt(attempt(percentage: 65))
        let best = store.bestOlympiadAttempt(forPaperId: "olympiad_science_ch13")
        XCTAssertEqual(best?.percentage, 86)
    }

    func testMostRecentReturnsLatestAttempt() {
        let store = tempStore()
        let day1 = Date(timeIntervalSince1970: 1_700_000_000)
        let day2 = day1.addingTimeInterval(86_400)
        let day3 = day1.addingTimeInterval(172_800)
        store.recordOlympiadAttempt(attempt(at: day1, correct: 30))
        store.recordOlympiadAttempt(attempt(at: day3, correct: 50))
        store.recordOlympiadAttempt(attempt(at: day2, correct: 40))
        let recent = store.mostRecentOlympiadAttempt(forPaperId: "olympiad_science_ch13")
        XCTAssertEqual(recent?.attemptedAt, day3)
        XCTAssertEqual(recent?.correct, 50)
    }

    func testAttemptsForPaperReturnsNewestFirst() {
        let store = tempStore()
        let day1 = Date(timeIntervalSince1970: 1_700_000_000)
        let day2 = day1.addingTimeInterval(86_400)
        let day3 = day1.addingTimeInterval(172_800)
        store.recordOlympiadAttempt(attempt(at: day2))
        store.recordOlympiadAttempt(attempt(at: day1))
        store.recordOlympiadAttempt(attempt(at: day3))
        let list = store.olympiadAttempts(forPaperId: "olympiad_science_ch13")
        XCTAssertEqual(list.map { $0.attemptedAt }, [day3, day2, day1])
    }

    // MARK: - Idempotency

    func testRecordingSameAttemptTwiceIsNoOp() {
        let store = tempStore()
        let a = attempt()
        store.recordOlympiadAttempt(a)
        store.recordOlympiadAttempt(a)   // SwiftUI onAppear-firing-twice case
        XCTAssertEqual(store.olympiadAttempts(forPaperId: a.paperId).count, 1)
    }

    // MARK: - Persistence round-trip

    func testAttemptSurvivesStoreReload() {
        let dir = FileManager.default.temporaryDirectory
            .appendingPathComponent("oly-attempts-rt-\(UUID().uuidString)")
        let s1 = DataStore(streakCalendar: nil, storeDir: dir, autoLoad: false)
        let a = attempt(percentage: 91)
        s1.recordOlympiadAttempt(a)
        s1.flushSavesBeforeQuit()   // force the coalesced write to land NOW

        let s2 = DataStore(streakCalendar: nil, storeDir: dir, autoLoad: false)
        // s2 has didHydrateOlympiadAttempts=false; the lazy hydrate fires
        // on the first read accessor call.
        XCTAssertEqual(s2.olympiadAttempts(forPaperId: a.paperId).count, 1)
        XCTAssertEqual(s2.bestOlympiadAttempt(forPaperId: a.paperId)?.percentage, 91)
    }

    // MARK: - Subject scoping

    func testAttemptsForOneSubjectDontLeakIntoAnother() {
        let store = tempStore()
        store.recordOlympiadAttempt(attempt(paperId: "olympiad_science_ch13", percentage: 95))
        store.recordOlympiadAttempt(attempt(paperId: "olympiad_maths_ch15", percentage: 40))
        XCTAssertEqual(store.bestOlympiadAttempt(forPaperId: "olympiad_science_ch13")?.percentage, 95)
        XCTAssertEqual(store.bestOlympiadAttempt(forPaperId: "olympiad_maths_ch15")?.percentage, 40)
    }
}
