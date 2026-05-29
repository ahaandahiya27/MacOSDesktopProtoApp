import SwiftUI
import AppKit

/// Opens `AchievementGalleryView` in its own AppKit window from the ⌘⇧A
/// command / Help → Achievements menu item. Same standalone-window pattern
/// as `WeeklyProgressWindowPresenter` (the modern multi-window scene APIs are
/// macOS 13+, and a sheet would require editing `ContentView`, owned by
/// another surface this run).
///
/// Singleton so re-triggering ⌘⇧A focuses the existing window rather than
/// stacking duplicates.
///
/// `@MainActor` — builds `AchievementGalleryView` (main-actor-isolated) and
/// drives AppKit window APIs.
@MainActor
final class AchievementGalleryWindowPresenter: NSObject, NSWindowDelegate {
    static let shared = AchievementGalleryWindowPresenter()
    private var window: NSWindow?

    func present(dataStore: DataStore, registry: SubjectRegistry) {
        if let existing = window {
            existing.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
            return
        }
        let root = AchievementGalleryView()
            .environmentObject(dataStore)
            .environmentObject(registry)
            .frame(minWidth: 620, minHeight: 520)
        let hosting = NSHostingController(rootView: root)
        let win = NSWindow(contentViewController: hosting)
        win.title = "Achievements"
        win.setContentSize(NSSize(width: 760, height: 720))
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
