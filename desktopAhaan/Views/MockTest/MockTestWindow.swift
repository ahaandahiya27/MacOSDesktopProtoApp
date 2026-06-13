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

    private enum Phase: Equatable { case setup, notEnough, running, report }

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

    private func handleFinish(_ finished: MockTestResult) {
        // Phase 3 wires persistence (`recordMockTestResult`) + the deliberate SRS
        // recording (`recordMockTestReviews`) here. Phase 2 shows the report.
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
