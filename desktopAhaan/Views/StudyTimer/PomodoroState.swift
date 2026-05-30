import Foundation
import Combine
import AppKit

// MARK: - Pomodoro state machine
//
// The focus-timer engine behind `StudyTimerView`. A `@MainActor`
// `ObservableObject` driving a classic Pomodoro cycle:
//
//   Focus (25:00) → Short Break (5:00) → Focus → … and every 4th focus
//   phase is followed by a Long Break (15:00) instead of a short one.
//
// State (current phase + remaining seconds + completed-focus count) persists
// in `UserDefaults` so closing the window doesn't lose the session. The
// phase-transition rule is a PURE static function so it's unit-testable
// without a running timer.
//
// Big Sur compatible: a plain `Timer.scheduledTimer` (NOT `Task.sleep(for:)`
// or `TimelineView`), Combine `@Published`, AppKit `NSSound`. No macOS 12+
// APIs.

/// The three phases of the cycle. Raw values are the persistence contract.
enum PomodoroPhase: String, Codable, Hashable {
    case focus
    case shortBreak
    case longBreak

    var displayName: String {
        switch self {
        case .focus:      return "Focus"
        case .shortBreak: return "Short Break"
        case .longBreak:  return "Long Break"
        }
    }

    /// Default phase length in seconds.
    var defaultDuration: Int {
        switch self {
        case .focus:      return 25 * 60
        case .shortBreak: return 5 * 60
        case .longBreak:  return 15 * 60
        }
    }
}

@MainActor
final class PomodoroState: ObservableObject {

    /// Long break after this many completed focus phases.
    static let longBreakEvery = 4

    @Published private(set) var phase: PomodoroPhase
    @Published private(set) var remainingSeconds: Int
    @Published private(set) var isRunning: Bool
    /// Total focus phases completed (drives the long-break cadence + a
    /// "🍅 × N" readout).
    @Published private(set) var completedFocusSessions: Int

    /// Play a short sound on phase transitions. Gated additionally on Reduce
    /// Motion at play time (a calmer experience covers audio too).
    @Published var soundEnabled: Bool {
        didSet { PomodoroStorage.setSoundEnabled(soundEnabled, defaults) }
    }

    private var timer: Timer?
    private let defaults: UserDefaults
    /// Suppresses real `NSSound` + `Timer` under tests.
    private let playsSound: Bool
    private let schedulesTimer: Bool

    /// Designated init. Production uses the no-arg defaults; tests pass a
    /// scratch `UserDefaults` suite and disable the side-effecting timer/sound.
    init(defaults: UserDefaults = .standard,
         schedulesTimer: Bool = true,
         playsSound: Bool = true) {
        self.defaults = defaults
        self.schedulesTimer = schedulesTimer
        self.playsSound = playsSound
        let restored = PomodoroStorage.restore(defaults)
        self.phase = restored.phase
        self.remainingSeconds = restored.remaining
        self.completedFocusSessions = restored.completedFocus
        self.soundEnabled = PomodoroStorage.soundEnabled(defaults)
        // Never auto-start on restore — reopening the window shouldn't
        // surprise the kid with a running clock.
        self.isRunning = false
    }

    // MARK: - Controls

    func start() {
        guard !isRunning else { return }
        if remainingSeconds <= 0 { remainingSeconds = phase.defaultDuration }
        isRunning = true
        scheduleTick()
    }

    func pause() {
        isRunning = false
        timer?.invalidate()
        timer = nil
        persist()
    }

    /// Reset the WHOLE cycle back to a fresh 25:00 focus phase.
    func reset() {
        timer?.invalidate()
        timer = nil
        isRunning = false
        phase = .focus
        remainingSeconds = PomodoroPhase.focus.defaultDuration
        completedFocusSessions = 0
        persist()
    }

    // MARK: - Tick (also callable directly by tests)

    /// Advance the clock one second. When it hits zero, chime (if enabled)
    /// and roll to the next phase. Public so tests drive it deterministically
    /// without waiting on a real `Timer`.
    func tick() {
        guard isRunning else { return }
        if remainingSeconds > 1 {
            remainingSeconds -= 1
            persist()
            return
        }
        // Phase just elapsed.
        chimeIfAppropriate()
        advancePhase()
    }

    /// Roll to the next phase per `phaseAfter`, refill the clock, and keep
    /// running so the cycle continues hands-free.
    func advancePhase() {
        let result = Self.phaseAfter(phase, completedFocusSessions: completedFocusSessions)
        phase = result.next
        completedFocusSessions = result.completedFocus
        remainingSeconds = result.next.defaultDuration
        persist()
    }

    // MARK: - Pure transition rule

    /// The next phase after `phase`, plus the updated completed-focus count.
    /// A completed focus phase increments the count; every `longBreakEvery`-th
    /// completion is followed by a long break, otherwise a short break. A
    /// break is always followed by a focus phase.
    static func phaseAfter(_ phase: PomodoroPhase, completedFocusSessions: Int)
        -> (next: PomodoroPhase, completedFocus: Int) {
        switch phase {
        case .focus:
            let completed = completedFocusSessions + 1
            let next: PomodoroPhase = (completed % longBreakEvery == 0) ? .longBreak : .shortBreak
            return (next, completed)
        case .shortBreak, .longBreak:
            return (.focus, completedFocusSessions)
        }
    }

    /// `mm:ss` for the current remaining time.
    var formattedRemaining: String { Self.format(remainingSeconds) }

    static func format(_ seconds: Int) -> String {
        let s = max(0, seconds)
        return String(format: "%02d:%02d", s / 60, s % 60)
    }

    // MARK: - Side effects

    private func scheduleTick() {
        guard schedulesTimer else { return }
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in self?.tick() }
        }
    }

    private func chimeIfAppropriate() {
        guard playsSound, soundEnabled,
              !NSWorkspace.shared.accessibilityDisplayShouldReduceMotion else { return }
        NSSound(named: NSSound.Name("Glass"))?.play()
    }

    private func persist() {
        PomodoroStorage.save(phase: phase, remaining: remainingSeconds,
                             completedFocus: completedFocusSessions, defaults)
    }
}

// MARK: - Storage

/// Feature-local `UserDefaults` persistence for the Pomodoro state (kept out
/// of the shared `AppStorageKeys`, per the `DailyPlanStorage` precedent).
enum PomodoroStorage {
    static let phaseKey = "pomodoroPhase"
    static let remainingKey = "pomodoroRemainingSeconds"
    static let completedFocusKey = "pomodoroCompletedFocus"
    static let soundEnabledKey = "pomodoroSoundEnabled"

    static func restore(_ defaults: UserDefaults = .standard)
        -> (phase: PomodoroPhase, remaining: Int, completedFocus: Int) {
        let phase = (defaults.string(forKey: phaseKey)).flatMap(PomodoroPhase.init(rawValue:)) ?? .focus
        let storedRemaining = defaults.integer(forKey: remainingKey)
        let remaining = storedRemaining > 0 ? storedRemaining : phase.defaultDuration
        let completed = max(0, defaults.integer(forKey: completedFocusKey))
        return (phase, remaining, completed)
    }

    static func save(phase: PomodoroPhase, remaining: Int, completedFocus: Int,
                     _ defaults: UserDefaults = .standard) {
        defaults.set(phase.rawValue, forKey: phaseKey)
        defaults.set(remaining, forKey: remainingKey)
        defaults.set(completedFocus, forKey: completedFocusKey)
    }

    static func soundEnabled(_ defaults: UserDefaults = .standard) -> Bool {
        if defaults.object(forKey: soundEnabledKey) == nil { return true }
        return defaults.bool(forKey: soundEnabledKey)
    }

    static func setSoundEnabled(_ on: Bool, _ defaults: UserDefaults = .standard) {
        defaults.set(on, forKey: soundEnabledKey)
    }
}
