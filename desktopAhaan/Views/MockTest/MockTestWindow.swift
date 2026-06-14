import SwiftUI
import AppKit

// MARK: - MockTestView (coordinator)
//
// v9 Exam Simulation · Phase 2. The top-level flow for the Mock Test window:
//
//   setup → (build paper) → running → (submit) → report → retake → setup
//
// It owns the value-type flow state and the built paper / graded result. The
// runner owns the live clock (`MockTestRunState` as its own `@StateObject`), so
// this coordinator only re-renders at phase boundaries — the clock never resets
// on an incidental redraw.
//
// `@MainActor` because it reads `DataStore` (main-actor-isolated) synchronously
// to build the paper. Persisting the result + recording reviews is wired in
// Phase 3.
@MainActor
struct MockTestView: View {
    @EnvironmentObject var dataStore: DataStore
    @EnvironmentObject var registry: SubjectRegistry

    // `building` was added 2026-06-14 after the iMac reported the Start CTA
    // appearing dead: tapping Start synchronously called `buildMockTest`,
    // which walks ~3,500 questions across 4 packs + runs MasteryEngine.snapshot
    // + JourneyPlanner.compose, all on @MainActor. On the AMD R9 M290X iMac
    // that takes ~1–3 seconds — the UI froze from tap to phase change.
    // The fix flips an immediate `building` flag, lets the runloop draw the
    // loading view via Task.yield(), THEN runs the heavy build. UI shows
    // "Building your paper…" right away so the user knows the click landed.
    private enum Phase: Equatable { case setup, building, notEnough, running, report }

    @State private var phase: Phase = .setup
    @State private var paper: MockTestPaper?
    @State private var result: MockTestResult?

    var body: some View {
        content
            .frame(minWidth: 560, minHeight: 600)
    }

    @ViewBuilder
    private var content: some View {
        switch phase {
        case .setup:
            MockTestSetupView(onStart: { handleStart($0) })
        case .building:
            buildingState
        case .notEnough:
            notEnoughState
        case .running:
            if let paper = paper {
                MockTestRunnerView(paper: paper, onFinish: { handleFinish($0) })
            } else {
                MockTestSetupView(onStart: { handleStart($0) })
            }
        case .report:
            if let result = result {
                MockTestReportView(result: result, onRetake: { retake() }, onDone: { done() })
            } else {
                MockTestSetupView(onStart: { handleStart($0) })
            }
        }
    }

    // MARK: - Flow

    private func handleStart(_ config: MockTestConfig) {
        // Immediate visual feedback BEFORE the heavy build. Setting phase
        // synchronously then yielding to the runloop in the Task body
        // guarantees SwiftUI gets one paint cycle for the "Building…"
        // view before MainActor blocks on the build. Otherwise tap →
        // build → phase change all happen in one frame and the user
        // sees nothing for the duration of the build.
        phase = .building
        Task { @MainActor in
            // One frame ≈ 16ms on a 60Hz display; legacy iMac runs at
            // 60Hz so 30ms gives the loading view two frames of headroom.
            try? await Task.sleep(nanoseconds: 30_000_000)
            let built = dataStore.buildMockTest(registry: registry, config: config)
            if built.isEmpty {
                paper = nil
                withAnimationRespectingReduceMotion(.easeInOut(duration: 0.2)) { phase = .notEnough }
            } else {
                paper = built
                result = nil
                withAnimationRespectingReduceMotion(.easeInOut(duration: 0.2)) { phase = .running }
            }
        }
    }

    private func handleFinish(_ finished: MockTestResult) {
        // Persist the result (NEW app state — folds into the parent Report Card)
        // and record each answered question through the sanctioned ephemeral
        // review path so the test reflects into the Mastery Map. Both are
        // idempotent for one completion; the runner finishes exactly once.
        dataStore.recordMockTestResult(finished)
        dataStore.recordMockTestReviews(finished)
        result = finished
        withAnimationRespectingReduceMotion(.easeInOut(duration: 0.2)) { phase = .report }
    }

    private func retake() {
        paper = nil
        result = nil
        withAnimationRespectingReduceMotion(.easeInOut(duration: 0.2)) { phase = .setup }
    }

    private func done() {
        NSApp.keyWindow?.performClose(nil)
    }

    // MARK: - Building state

    /// Loading view rendered between tap-Start and the paper being ready.
    /// Without this state the UI froze for the duration of `buildMockTest`
    /// (~1–3s on the AMD R9 M290X iMac) and the tap looked unresponsive.
    private var buildingState: some View {
        VStack(spacing: DesignTokens.Spacing.md) {
            ProgressView().controlSize(.large)
            Text("Building your paper…")
                .font(.headline)
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            Text("Picking questions across subjects and matching your mastery gaps. This takes a second or two.")
                .font(.callout)
                .multilineTextAlignment(.center)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: 380)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(DesignTokens.Spacing.xl)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Building your mock test paper. This takes a second or two.")
    }

    // MARK: - Empty state

    private var notEnoughState: some View {
        VStack(spacing: DesignTokens.Spacing.md) {
            Text("🌱").font(.system(size: 48)).accessibilityHidden(true)
            Text("Not enough questions yet")
                .font(.title2.weight(.bold))
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            Text("There aren't enough questions in that subject and difficulty to build a paper. Try the Balanced difficulty, the Mixed subject option, or a shorter length.")
                .font(.callout)
                .multilineTextAlignment(.center)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                .fixedSize(horizontal: false, vertical: true)
            Button(action: { withAnimationRespectingReduceMotion(.easeInOut(duration: 0.2)) { phase = .setup } }) {
                Text("Back to setup")
                    .font(.headline).foregroundColor(.white)
                    .padding(.horizontal, DesignTokens.Spacing.lg)
                    .padding(.vertical, DesignTokens.Spacing.sm)
                    .frame(minHeight: 44)
                    .background(Capsule().fill(DesignTokens.BrandColor.primaryAction))
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Back to setup")
            .accessibilityIdentifier("mocktest-back-to-setup")
        }
        .frame(maxWidth: 460)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(DesignTokens.Spacing.xl)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Not enough questions yet. Try Balanced difficulty, the Mixed subject option, or a shorter length.")
    }
}

// MARK: - Window presenter
//
// Opens `MockTestView` in its own AppKit window from Help → "Mock Test" / ⌘⌥M.
// Same standalone-window pattern as `MilestoneAssessmentWindowPresenter` /
// `MasteryMapWindowPresenter`: the multi-window scene APIs are macOS 13+, so an
// `NSHostingController`-backed window keeps the feature self-contained.
//
// Singleton — re-triggering the command focuses the existing window. On close it
// drops its reference so the next open rebuilds the controller and starts a
// fresh setup screen.
@MainActor
final class MockTestWindowPresenter: NSObject, NSWindowDelegate {
    static let shared = MockTestWindowPresenter()
    private var window: NSWindow?

    func present(dataStore: DataStore, registry: SubjectRegistry) {
        if let existing = window {
            existing.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
            return
        }
        let root = MockTestView()
            .environmentObject(dataStore)
            .environmentObject(registry)
            .frame(minWidth: 560, minHeight: 600)
        let hosting = NSHostingController(rootView: root)
        let win = NSWindow(contentViewController: hosting)
        win.title = "Mock Test"
        win.setContentSize(NSSize(width: 720, height: 780))
        win.styleMask = [.titled, .closable, .resizable, .miniaturizable]
        win.isReleasedWhenClosed = false
        win.center()
        win.delegate = self
        window = win
        win.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    nonisolated func windowWillClose(_ notification: Notification) {
        Task { @MainActor in self.window = nil }
    }
}
