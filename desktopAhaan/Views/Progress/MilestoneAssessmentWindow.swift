import SwiftUI
import AppKit

/// Opens `MilestoneAssessmentView` in its own AppKit window from Help →
/// Milestone Checkpoint (⌘⇧K). Same standalone-window pattern as
/// `MasteryMapWindowPresenter` / `WeeklyProgressWindowPresenter`: the modern
/// multi-window scene APIs are macOS 13+, so an NSHostingController-backed
/// window keeps the whole feature inside this directory + the App's command
/// block.
///
/// Singleton so re-triggering the command focuses the existing window rather
/// than stacking duplicates. On close it drops its reference
/// (`isReleasedWhenClosed = false` + nil-out) so the next open rebuilds the
/// hosting controller and `MilestoneAssessmentView.onAppear` samples a fresh
/// checkpoint from the latest reviews.
///
/// `@MainActor` because it constructs `MilestoneAssessmentView`
/// (main-actor-isolated) and drives AppKit window APIs; every entry point
/// already runs on the main thread.
@MainActor
final class MilestoneAssessmentWindowPresenter: NSObject, NSWindowDelegate {
    static let shared = MilestoneAssessmentWindowPresenter()
    private var window: NSWindow?

    func present(dataStore: DataStore, registry: SubjectRegistry) {
        if let existing = window {
            existing.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
            return
        }
        let root = MilestoneAssessmentView()
            .environmentObject(dataStore)
            .environmentObject(registry)
            .frame(minWidth: 520, minHeight: 560)
        let hosting = NSHostingController(rootView: root)
        let win = NSWindow(contentViewController: hosting)
        win.title = "Milestone Checkpoint"
        win.setContentSize(NSSize(width: 680, height: 740))
        win.styleMask = [.titled, .closable, .resizable, .miniaturizable]
        win.isReleasedWhenClosed = false
        win.center()
        win.delegate = self
        window = win
        win.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    nonisolated func windowWillClose(_ notification: Notification) {
        // AppKit calls this on the main thread; hop onto the main actor to drop
        // the reference so the next open rebuilds with a fresh checkpoint.
        Task { @MainActor in self.window = nil }
    }
}
