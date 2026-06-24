import XCTest
@testable import desktopAhaan

/// Pins the CC7 cancellation invariant: when the user dismisses the
/// translator sheet while a translation call is in-flight, the
/// `TranslatorViewModel` must end up in a consistent state — no stuck
/// spinner, no leaked observer, no crash. The original CC7 row note
/// said "user can dismiss the translator screen while network call is
/// in-flight; cancellation correctness not formally verified." This
/// file IS the formal verification.
///
/// Why XCTest and not XCUITest: the UI-driven sheet-dismiss path needs
/// an AX grant (only the iMac runner has one). The invariant CC7
/// actually cares about — "the ViewModel survives a mid-call dismiss
/// cleanly" — is a ViewModel-level contract; driving the View through
/// XCUITest would test SwiftUI itself, not our code. The three tests
/// below pin the ViewModel contract directly and are dev-Mac
/// authoritative.
@MainActor
final class TranslatorCancellationTests: XCTestCase {

    /// Baseline shape: empty input must error out cleanly with
    /// `errorMessage` set and `isTranslating` left at `false`. A spinner
    /// stuck at `true` would mean the body never reached its bottom
    /// `isTranslating = false` line — the most basic CC7 contract.
    func testEmptyInputErrorsCleanlyAndUnsetsSpinner() async {
        let vm = TranslatorViewModel()
        vm.inputText = ""
        await vm.translate(dataStore: DataStore.shared, isOnline: false)
        XCTAssertFalse(vm.isTranslating,
            "Spinner should never be stuck at true after translate() returns.")
        XCTAssertNotNil(vm.errorMessage,
            "Empty input should set a user-facing error message.")
    }

    /// CC7 core: the user dismisses the sheet mid-call. Simulated by
    /// starting `translate(...)` in a Task and then cancelling that
    /// Task immediately. Whether the inner await responds to cancellation
    /// or runs to completion, the ViewModel must end with the spinner
    /// off — because the function body unconditionally sets
    /// `isTranslating = false` at its end.
    func testTaskCancellationDoesNotLeaveStuckSpinner() async {
        let vm = TranslatorViewModel()
        vm.inputText = "नमस्ते"
        let task = Task {
            await vm.translate(dataStore: DataStore.shared, isOnline: false)
        }
        task.cancel()
        await task.value
        XCTAssertFalse(vm.isTranslating,
            "Spinner stuck at true after Task cancellation — CC7 invariant violated.")
    }

    /// Leak invariant: after the in-flight translate Task completes (by
    /// normal completion or cancellation), the `TranslatorViewModel`
    /// must deallocate cleanly when its last strong reference drops.
    /// A leak here would mean a retain-cycle in the cancellables /
    /// SpeechManager / TTSManager wiring that the dismiss can't unwind.
    func testTaskCompletionAllowsViewModelDeallocation() async {
        weak var weakVM: TranslatorViewModel?
        do {
            let vm = TranslatorViewModel()
            weakVM = vm
            vm.inputText = "नमस्ते"
            // Hold strong only via the Task; once Task completes, the
            // Task's captured `vm` is released alongside the local one.
            let task = Task {
                await vm.translate(dataStore: DataStore.shared, isOnline: false)
            }
            await task.value
        }
        // Yield to give the runtime a chance to drain the autorelease
        // pool / Combine subscription cleanup that ARC schedules after
        // the strong refs drop. Two yields are belt-and-suspenders;
        // a single yield is usually enough but the Combine .sink
        // teardown sometimes uses an extra hop.
        await Task.yield()
        await Task.yield()
        XCTAssertNil(weakVM,
            "TranslatorViewModel leaked after the in-flight Task completed — CC7 leak invariant violated.")
    }

    /// Sheet dismiss-and-relaunch pattern: user opens translator, types,
    /// dismisses mid-call, then opens it again. Each open is a fresh
    /// ViewModel (SwiftUI @StateObject is per-presentation). The first
    /// ViewModel's still-running Task must NOT interfere with the
    /// second ViewModel's translate call (no shared mutable state
    /// outside DataStore).
    func testTwoSequentialViewModelsDoNotInterfere() async {
        // First open + dismiss-mid-call simulation.
        let vmA = TranslatorViewModel()
        vmA.inputText = "नमस्ते"
        let taskA = Task {
            await vmA.translate(dataStore: DataStore.shared, isOnline: false)
        }

        // Second open while the first is still in flight.
        let vmB = TranslatorViewModel()
        vmB.inputText = "धन्यवादः"
        await vmB.translate(dataStore: DataStore.shared, isOnline: false)

        // Reap the first Task so the test isn't leaving structured
        // concurrency state behind.
        await taskA.value

        // Both ViewModels must be in a final state — no in-flight
        // spinner survives across the dismiss-and-relaunch.
        XCTAssertFalse(vmA.isTranslating,
            "vmA spinner stuck after sheet-dismiss; CC7 cancellation invariant.")
        XCTAssertFalse(vmB.isTranslating,
            "vmB spinner stuck after parallel translate; CC7 isolation invariant.")
    }
}
