import Foundation
import Combine

// MARK: - MockTestRunState
//
// v9 Exam Simulation · Phase 2. The live state machine behind the timed runner:
// the current question index, the kid's selections, the mark-for-review flags,
// a per-question time accumulator, and the countdown clock that auto-submits at
// zero. Drives `MockTestRunnerView`.
//
// Modelled on `PomodoroState`: a plain `Timer.scheduledTimer` (NOT
// `Task.sleep(for:)` / `TimelineView` — those are macOS 12+), Combine
// `@Published`, and a PURE `tick()` the tests can drive deterministically
// without waiting on a real clock (pass `schedulesTimer: false`). Grading is
// delegated to the pure `MockTestEngine.grade`, so this object is itself
// READ-ONLY over the SRS — the deliberate SRS write happens later, in the
// coordinator, after submit.
//
// Big Sur compatible: Timer + Combine + AppKit-free value math. No macOS 12+ APIs.
@MainActor
final class MockTestRunState: ObservableObject {

    let paper: MockTestPaper

    /// Index of the question on screen.
    @Published private(set) var index: Int = 0
    /// Seconds left on the clock.
    @Published private(set) var remainingSeconds: Int
    /// paperId → the option the kid currently has selected.
    @Published private(set) var selections: [String: String] = [:]
    /// paperIds flagged "review me before submitting".
    @Published private(set) var markedForReview: Set<String> = []
    /// `true` once the paper is submitted (manually or by the clock).
    @Published private(set) var isFinished: Bool = false

    /// paperId → accumulated seconds the kid spent with that question on screen.
    private(set) var secondsByPaperId: [String: Int] = [:]
    /// The graded result, set exactly once at submit.
    private(set) var result: MockTestResult?
    /// `true` when the clock — not the kid — triggered the submit.
    private(set) var didAutoSubmit = false

    private var timer: Timer?
    private let schedulesTimer: Bool
    private let clock: () -> Date

    /// Designated init. Production uses the live clock + a real timer; tests pass
    /// `schedulesTimer: false` and a fixed clock, then call `tick()` directly.
    init(paper: MockTestPaper,
         schedulesTimer: Bool = true,
         clock: @escaping () -> Date = { Date() }) {
        self.paper = paper
        self.remainingSeconds = paper.config.timeLimitSeconds
        self.schedulesTimer = schedulesTimer
        self.clock = clock
    }

    // MARK: - Derived

    /// The question currently on screen, or nil for an empty paper.
    var current: MockTestQuestion? {
        guard paper.questions.indices.contains(index) else { return nil }
        return paper.questions[index]
    }

    /// How many questions the kid has answered so far.
    var answeredCount: Int { selections.count }

    /// How many questions are flagged for review.
    var markedCount: Int { markedForReview.count }

    /// `mm:ss` for the clock.
    var formattedRemaining: String { Self.format(remainingSeconds) }

    /// `true` in the last minute, so the runner can tint the clock.
    var isLowTime: Bool { remainingSeconds <= 60 }

    /// 0…1 fraction of the paper answered — drives a thin progress bar.
    var answeredFraction: Double {
        guard paper.count > 0 else { return 0 }
        return Double(answeredCount) / Double(paper.count)
    }

    func selection(forPaperId id: String) -> String? { selections[id] }
    func isAnswered(_ id: String) -> Bool { selections[id] != nil }
    func isMarked(_ id: String) -> Bool { markedForReview.contains(id) }

    /// Per-question status for the grid dot.
    enum SlotStatus { case current, markedAnswered, marked, answered, untouched }

    func status(forIndex i: Int) -> SlotStatus {
        guard paper.questions.indices.contains(i) else { return .untouched }
        let id = paper.questions[i].id
        if i == index { return .current }
        let marked = markedForReview.contains(id)
        let answered = selections[id] != nil
        if marked && answered { return .markedAnswered }
        if marked { return .marked }
        if answered { return .answered }
        return .untouched
    }

    // MARK: - Clock

    /// Begin counting down. Idempotent; a no-op once finished or under tests
    /// (which drive `tick()` by hand).
    func start() {
        guard schedulesTimer, timer == nil, !isFinished else { return }
        scheduleTick()
    }

    /// Stop the clock without submitting (called when the window closes mid-run).
    func stop() {
        timer?.invalidate()
        timer = nil
    }

    /// Advance the clock one second: charge the second to the on-screen question,
    /// then decrement — auto-submitting when it would hit zero. Public so tests
    /// drive it deterministically. No-op once finished.
    func tick() {
        guard !isFinished else { return }
        if let id = current?.id {
            secondsByPaperId[id, default: 0] += 1
        }
        if remainingSeconds <= 1 {
            remainingSeconds = 0
            submit(auto: true)
        } else {
            remainingSeconds -= 1
        }
    }

    // MARK: - Answering + navigation

    func select(_ option: String) {
        guard !isFinished, let id = current?.id else { return }
        selections[id] = option
    }

    func toggleMarkForReview() {
        guard let id = current?.id else { return }
        if markedForReview.contains(id) { markedForReview.remove(id) }
        else { markedForReview.insert(id) }
    }

    func goNext() { go(to: index + 1) }
    func goPrevious() { go(to: index - 1) }

    func go(to newIndex: Int) {
        guard !isFinished else { return }
        let clamped = max(0, min(paper.questions.count - 1, newIndex))
        if clamped != index { index = clamped }
    }

    var canGoNext: Bool { index + 1 < paper.questions.count }
    var canGoPrevious: Bool { index > 0 }

    // MARK: - Submit

    /// Grade and finish. Idempotent — a second call (e.g. clock fires the same
    /// instant the kid taps Submit) is ignored. `auto` records whether the clock
    /// forced it. Grading is the pure `MockTestEngine.grade`; this never writes
    /// the SRS.
    func submit(auto: Bool = false) {
        guard !isFinished else { return }
        stop()
        didAutoSubmit = auto
        result = MockTestEngine.grade(
            paper: paper, answers: selections,
            secondsByPaperId: secondsByPaperId,
            now: clock(), autoSubmitted: auto)
        isFinished = true
    }

    // MARK: - Helpers

    private func scheduleTick() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in self?.tick() }
        }
    }

    /// `mm:ss`, with minutes allowed to exceed 59 for a long paper (e.g. `45:00`).
    static func format(_ seconds: Int) -> String {
        let s = max(0, seconds)
        return String(format: "%02d:%02d", s / 60, s % 60)
    }
}
