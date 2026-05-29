import SwiftUI
import AppKit

/// Opens `WeeklyProgressView` in its own AppKit window from the ⌘⇧W
/// command / Help → Weekly Progress menu item. A standalone window (not
/// a SwiftUI sheet) is used deliberately: the modern multi-window scene
/// APIs (`Window`, `openWindow`) are macOS 13+, and routing a sheet
/// would require editing `ContentView` (owned by another surface this
/// run). An NSHostingController-backed window keeps the whole feature
/// inside this directory + the App's command block.
///
/// The presenter is a singleton so re-triggering the command focuses the
/// existing window rather than stacking duplicates. On close it drops its
/// reference (`isReleasedWhenClosed = false` + nil-out), so the next open
/// rebuilds the hosting controller and `WeeklyProgressView.onAppear`
/// refires with a fresh rollup.
///
/// `@MainActor` because it constructs `WeeklyProgressView` (itself
/// main-actor-isolated) and drives AppKit window APIs; every entry point
/// (menu action, window-delegate callback) already runs on the main
/// thread. The class being main-actor-isolated also makes it `Sendable`,
/// so the delegate-callback hop below can capture `self` safely.
@MainActor
final class WeeklyProgressWindowPresenter: NSObject, NSWindowDelegate {
    static let shared = WeeklyProgressWindowPresenter()
    private var window: NSWindow?

    func present(dataStore: DataStore, registry: SubjectRegistry) {
        if let existing = window {
            existing.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
            return
        }
        let root = WeeklyProgressView()
            .environmentObject(dataStore)
            .environmentObject(registry)
            .frame(minWidth: 560, minHeight: 620)
        let hosting = NSHostingController(rootView: root)
        let win = NSWindow(contentViewController: hosting)
        win.title = "Weekly Progress"
        win.setContentSize(NSSize(width: 760, height: 780))
        win.styleMask = [.titled, .closable, .resizable, .miniaturizable]
        win.isReleasedWhenClosed = false
        win.center()
        win.delegate = self
        window = win
        win.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    nonisolated func windowWillClose(_ notification: Notification) {
        // AppKit calls this on the main thread; hop onto the main actor
        // to drop the reference so the next open rebuilds with fresh data.
        Task { @MainActor in self.window = nil }
    }
}
