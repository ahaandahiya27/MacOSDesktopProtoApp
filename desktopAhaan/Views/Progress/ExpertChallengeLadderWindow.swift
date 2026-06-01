import SwiftUI
import AppKit

/// Opens `ExpertChallengeLadderView` in its own AppKit window from Help → Expert
/// Challenges (⌘⇧E). Same standalone-window pattern as the other dashboards
/// (`MilestoneAssessmentWindowPresenter` etc.): an NSHostingController-backed
/// window keeps the whole feature inside this directory + the App's command
/// block.
///
/// Singleton so re-triggering the command focuses the existing window; on close
/// it drops its reference (`isReleasedWhenClosed = false` + nil-out) so the next
/// open rebuilds the hosting controller and `ExpertChallengeLadderView.onAppear`
/// recomputes a fresh ladder from the latest mastery.
///
/// `@MainActor` because it constructs the (main-actor-isolated) view and drives
/// AppKit window APIs; every entry point already runs on the main thread.
@MainActor
final class ExpertChallengeLadderWindowPresenter: NSObject, NSWindowDelegate {
    static let shared = ExpertChallengeLadderWindowPresenter()
    private var window: NSWindow?

    func present(dataStore: DataStore, registry: SubjectRegistry) {
        if let existing = window {
            existing.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
            return
        }
        let root = ExpertChallengeLadderView()
            .environmentObject(dataStore)
            .environmentObject(registry)
            .frame(minWidth: 520, minHeight: 560)
        let hosting = NSHostingController(rootView: root)
        let win = NSWindow(contentViewController: hosting)
        win.title = "Expert Challenges"
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
        Task { @MainActor in self.window = nil }
    }
}
