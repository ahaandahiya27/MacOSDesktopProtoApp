import SwiftUI
import AppKit

/// Opens `MasteryMapView` in its own AppKit window from Help → Mastery Map
/// (⌘⇧M). Same standalone-window pattern as `WeeklyProgressWindowPresenter` /
/// `DailyPlanWindowPresenter`: the modern multi-window scene APIs (`Window`,
/// `openWindow`) are macOS 13+, and routing a sheet would require editing
/// `ContentView` (owned by another surface), so an NSHostingController-backed
/// window keeps the whole feature inside this directory + the App's command
/// block.
///
/// Singleton so re-triggering the command focuses the existing window rather
/// than stacking duplicates. On close it drops its reference
/// (`isReleasedWhenClosed = false` + nil-out) so the next open rebuilds the
/// hosting controller and `MasteryMapView.onAppear` recomputes a fresh
/// snapshot from the latest reviews.
///
/// `@MainActor` because it constructs `MasteryMapView` (main-actor-isolated)
/// and drives AppKit window APIs; every entry point already runs on the main
/// thread.
@MainActor
final class MasteryMapWindowPresenter: NSObject, NSWindowDelegate {
    static let shared = MasteryMapWindowPresenter()
    private var window: NSWindow?

    func present(dataStore: DataStore, registry: SubjectRegistry) {
        if let existing = window {
            existing.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
            return
        }
        let root = MasteryMapView()
            .environmentObject(dataStore)
            .environmentObject(registry)
            .frame(minWidth: 560, minHeight: 600)
        let hosting = NSHostingController(rootView: root)
        let win = NSWindow(contentViewController: hosting)
        win.title = "Mastery Map"
        win.setContentSize(NSSize(width: 760, height: 800))
        win.styleMask = [.titled, .closable, .resizable, .miniaturizable]
        win.isReleasedWhenClosed = false
        win.center()
        win.delegate = self
        window = win
        win.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    nonisolated func windowWillClose(_ notification: Notification) {
        // AppKit calls this on the main thread; hop onto the main actor to
        // drop the reference so the next open rebuilds with a fresh snapshot.
        Task { @MainActor in self.window = nil }
    }
}
