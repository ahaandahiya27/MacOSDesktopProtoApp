import XCTest
@testable import desktopAhaan

/// Exercises the `PomodoroState` transition rule + clock, deterministically:
/// a scratch `UserDefaults` suite, no real `Timer`, no sound.
@MainActor
final class StudyTimerPhaseTransitionTests: XCTestCase {

    private func scratchDefaults() -> UserDefaults {
        let name = "pomodoro-test-\(UUID().uuidString)"
        let d = UserDefaults(suiteName: name)!
        d.removePersistentDomain(forName: name)
        return d
    }

    private func state(_ defaults: UserDefaults) -> PomodoroState {
        PomodoroState(defaults: defaults, schedulesTimer: false, playsSound: false)
    }

    // MARK: - Pure transition rule

    func testFocusGoesToShortBreak() {
        let r = PomodoroState.phaseAfter(.focus, completedFocusSessions: 0)
        XCTAssertEqual(r.next, .shortBreak)
        XCTAssertEqual(r.completedFocus, 1)
    }

    func testFourthFocusGoesToLongBreak() {
        // Completing the 4th focus session (count goes 3 -> 4) → long break.
        let r = PomodoroState.phaseAfter(.focus, completedFocusSessions: 3)
        XCTAssertEqual(r.next, .longBreak)
        XCTAssertEqual(r.completedFocus, 4)
    }

    func testBreaksReturnToFocus() {
        XCTAssertEqual(PomodoroState.phaseAfter(.shortBreak, completedFocusSessions: 2).next, .focus)
        XCTAssertEqual(PomodoroState.phaseAfter(.longBreak, completedFocusSessions: 4).next, .focus)
        // A break doesn't change the completed-focus count.
        XCTAssertEqual(PomodoroState.phaseAfter(.shortBreak, completedFocusSessions: 2).completedFocus, 2)
    }

    func testFullCycleReachesLongBreakOnFourthFocus() {
        var phase: PomodoroPhase = .focus
        var completed = 0
        var focusCount = 0
        var sawLongBreak = false
        // Walk: focus, break, focus, break, … until we hit the first long break.
        for _ in 0..<20 {
            let r = PomodoroState.phaseAfter(phase, completedFocusSessions: completed)
            if phase == .focus { focusCount += 1 }
            if r.next == .longBreak { sawLongBreak = true; break }
            phase = r.next
            completed = r.completedFocus
        }
        XCTAssertTrue(sawLongBreak)
        XCTAssertEqual(focusCount, 4, "Long break arrives after the 4th focus phase.")
    }

    // MARK: - Phase durations

    func testDefaultDurations() {
        XCTAssertEqual(PomodoroPhase.focus.defaultDuration, 25 * 60)
        XCTAssertEqual(PomodoroPhase.shortBreak.defaultDuration, 5 * 60)
        XCTAssertEqual(PomodoroPhase.longBreak.defaultDuration, 15 * 60)
    }

    func testFormatMMSS() {
        XCTAssertEqual(PomodoroState.format(25 * 60), "25:00")
        XCTAssertEqual(PomodoroState.format(65), "01:05")
        XCTAssertEqual(PomodoroState.format(0), "00:00")
        XCTAssertEqual(PomodoroState.format(-5), "00:00")
    }

    // MARK: - Tick + advance

    func testTickDecrementsWhileRunning() {
        let s = state(scratchDefaults())
        s.start()
        XCTAssertEqual(s.remainingSeconds, 25 * 60)
        s.tick()
        XCTAssertEqual(s.remainingSeconds, 25 * 60 - 1)
    }

    func testTickAtZeroAdvancesToShortBreak() {
        let d = scratchDefaults()
        let s = state(d)
        s.start()
        // Drain the clock to its last second, then tick the boundary.
        for _ in 0..<(25 * 60 - 1) { s.tick() }
        XCTAssertEqual(s.remainingSeconds, 1)
        s.tick()   // boundary
        XCTAssertEqual(s.phase, .shortBreak)
        XCTAssertEqual(s.remainingSeconds, 5 * 60)
        XCTAssertEqual(s.completedFocusSessions, 1)
    }

    func testResetReturnsToFreshFocus() {
        let s = state(scratchDefaults())
        s.start(); s.tick(); s.advancePhase()
        s.reset()
        XCTAssertEqual(s.phase, .focus)
        XCTAssertEqual(s.remainingSeconds, 25 * 60)
        XCTAssertEqual(s.completedFocusSessions, 0)
        XCTAssertFalse(s.isRunning)
    }

    // MARK: - Persistence (close-and-reopen)

    func testStatePersistsAcrossReopen() {
        let d = scratchDefaults()
        let s = state(d)
        s.start()
        s.tick(); s.tick()   // 25:00 -> 24:58
        s.pause()
        let remembered = s.remainingSeconds

        // A fresh state on the same defaults restores phase + remaining, paused.
        let reopened = state(d)
        XCTAssertEqual(reopened.phase, .focus)
        XCTAssertEqual(reopened.remainingSeconds, remembered)
        XCTAssertFalse(reopened.isRunning, "Reopening never auto-starts the clock.")
    }
}
