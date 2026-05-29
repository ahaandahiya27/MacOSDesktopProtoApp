import SwiftUI
import AppKit

/// Opens `DailyPlanView` in its own AppKit window from the ⌘⇧D command /
/// Help → Today's Plan menu item. Mirrors `WeeklyProgressWindowPresenter`:
/// a standalone NSHostingController-backed window (the modern multi-window
/// scene APIs are macOS 13+, and routing a sheet would require editing
/// `ContentView`, owned by another surface this run).
///
/// A singleton so re-triggering ⌘⇧D focuses the existing window rather than
/// stacking duplicates. Tapping a plan row routes the MAIN window via
/// `AppState` and then closes this window (`onNavigate`) so the kid lands on
/// the destination.
///
/// `@MainActor` because it builds `DailyPlanView` (main-actor-isolated) and
/// drives AppKit window APIs.
@MainActor
final class DailyPlanWindowPresenter: NSObject, NSWindowDelegate {
    static let shared = DailyPlanWindowPresenter()
    private var window: NSWindow?

    func present(dataStore: DataStore, registry: SubjectRegistry, appState: AppState) {
        if let existing = window {
            existing.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
            return
        }
        let root = DailyPlanView(onNavigate: { [weak self] in self?.closeAndFocusMain() })
            .environmentObject(dataStore)
            .environmentObject(registry)
            .environmentObject(appState)
            .frame(minWidth: 520, minHeight: 460)
        let hosting = NSHostingController(rootView: root)
        let win = NSWindow(contentViewController: hosting)
        win.title = "Today's Plan"
        win.setContentSize(NSSize(width: 600, height: 640))
        win.styleMask = [.titled, .closable, .resizable, .miniaturizable]
        win.isReleasedWhenClosed = false
        win.center()
        win.delegate = self
        window = win
        win.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    /// Close the plan window and bring the main app window forward so the
    /// routed destination is visible.
    private func closeAndFocusMain() {
        window?.orderOut(nil)
        window = nil
        // The main WindowGroup window is the first non-panel titled window.
        if let main = NSApp.windows.first(where: {
            $0.isVisible && !($0 is NSPanel) && $0.title != "Today's Plan"
        }) {
            main.makeKeyAndOrderFront(nil)
        }
        NSApp.activate(ignoringOtherApps: true)
    }

    nonisolated func windowWillClose(_ notification: Notification) {
        Task { @MainActor in self.window = nil }
    }
}
