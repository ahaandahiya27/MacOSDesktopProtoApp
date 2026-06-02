import SwiftUI
import AppKit

/// Opens `InsightsView` in its own AppKit window from the ⌘⇧I command /
/// Help → Insights menu item. Same standalone-window approach as
/// `WeeklyProgressWindow` (the modern multi-window scene APIs are macOS 13+,
/// and a sheet would require editing `ContentView`): an
/// `NSHostingController`-backed window keeps the whole feature inside this
/// directory + the App's command block.
///
/// The presenter is a singleton so re-triggering the command focuses the
/// existing window rather than stacking duplicates. On close it drops its
/// reference (`isReleasedWhenClosed = false` + nil-out), so the next open
/// rebuilds the hosting controller and `InsightsView.onAppear` refires with a
/// fresh snapshot + series.
///
/// `@MainActor` because it constructs `InsightsView` (main-actor-isolated) and
/// drives AppKit window APIs; every entry point already runs on the main thread.
@MainActor
final class InsightsWindowPresenter: NSObject, NSWindowDelegate {
    static let shared = InsightsWindowPresenter()
    private var window: NSWindow?

    func present(dataStore: DataStore, registry: SubjectRegistry) {
        if let existing = window {
            existing.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
            return
        }
        let root = InsightsView()
            .environmentObject(dataStore)
            .environmentObject(registry)
            .frame(minWidth: 520, minHeight: 560)
        let hosting = NSHostingController(rootView: root)
        let win = NSWindow(contentViewController: hosting)
        win.title = "Insights"
        win.setContentSize(NSSize(width: 720, height: 720))
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
        // the reference so the next open rebuilds with fresh data.
        Task { @MainActor in self.window = nil }
    }
}
