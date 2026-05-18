import SwiftUI
import os.log

// Crash capture: see App/CrashReporter.swift. It writes uncaught
// NSExceptions, POSIX fatal signals (SIGABRT, SIGSEGV, SIGBUS, SIGILL,
// SIGFPE, SIGPIPE), AND non-fatal data-quality issues (e.g. duplicate
// IDs caught by SubjectPack) to one append-only file per UTC day under
// ~/Library/Application Support/desktopAhaan/crashlogs/.

private let appLogger = Logger(subsystem: "com.emoha.desktopAhaan", category: "App")

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationWillFinishLaunching(_ notification: Notification) {
        // Install crash capture before any UI runs so we catch even
        // setup-time exceptions.
        CrashReporter.shared.install()
        // NSQuitAlwaysKeepsWindows is left at its system default (true) so
        // macOS restores the window's last position and size at the next
        // launch. The actual app state (sidebar selection, recent items,
        // settings) is restored independently via @AppStorage in AppState,
        // so window-frame restoration is purely about not making the kid
        // re-place the window every morning.
        NSWindow.allowsAutomaticWindowTabbing = false
        ensureMetalCacheDirectory()
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
    }

    /// Belt-and-suspenders at ⌘Q. Every `DataStore` mutation already calls
    /// `try data.write(to:options:.atomic)` synchronously on the main actor
    /// so there is no in-memory queue waiting to drain. We still:
    ///   - force a `UserDefaults` synchronize (a no-op on modern macOS but
    ///     harmless and makes intent explicit).
    ///   - log the clean-quit so a future "did the app quit or did it
    ///     crash?" investigation is unambiguous against the crash log.
    func applicationWillTerminate(_ notification: Notification) {
        CrashReporter.shared.markCleanExit()
        UserDefaults.standard.synchronize()
        appLogger.info("applicationWillTerminate — clean quit.")
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }

    private func ensureMetalCacheDirectory() {
        let fm = FileManager.default
        guard let cacheBase = fm.urls(for: .cachesDirectory, in: .userDomainMask).first else { return }
        let bundleId = Bundle.main.bundleIdentifier ?? "com.emoha.desktopAhaan"
        let metalDir = cacheBase
            .appendingPathComponent(bundleId)
            .appendingPathComponent("com.apple.metal")
        try? fm.createDirectory(at: metalDir, withIntermediateDirectories: true)
    }
}

@main
struct SanskritKoshApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var appState = AppState()
    @StateObject private var subjectRegistry = SubjectRegistry()
    @StateObject private var dataStore = DataStore()

    init() {
        // Pre-warm the Sanskrit dictionary off the main thread so the
        // first translator open doesn't hit cold-decode of the bundled
        // JSON. Wrapped defensively in case `SanskritDictionary.shared`
        // ever fails to init — we don't want a swallow-no-warning silent
        // miss, but we also don't want a single warming Task to crash the
        // App's launch scene.
        Task.detached(priority: .utility) {
            let n = SanskritDictionary.shared.entries.count
            appLogger.info("SanskritDictionary pre-warmed (\(n, privacy: .public) entries).")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .environmentObject(subjectRegistry)
                .environmentObject(dataStore)
                // Min 1024×640 honours macOS's split-screen tile half-width
                // on the deploy iMac's 5K @1×; ideal sized for full-screen
                // use on the same display. Sidebar (≥220) + detailPane
                // (≥420) totals 640 of internal content min, leaving room
                // for the standard window chrome inside 1024.
                .frame(
                    minWidth: 1024, idealWidth: 1500,
                    minHeight: 640, idealHeight: 950
                )
        }
        .commands {
            CommandGroup(after: .newItem) {
                Button("Open Image…") {
                    appState.selectSanskritTab(.scan)
                    NotificationCenter.default.post(name: .openImageCommand, object: nil)
                }
                .keyboardShortcut("o", modifiers: .command)
            }

            CommandGroup(after: .pasteboard) {
                Button("Copy Translation") {
                    NotificationCenter.default.post(name: .copyTranslationCommand, object: nil)
                }
                .keyboardShortcut("c", modifiers: [.command, .shift])
            }

            SidebarCommands()

            CommandMenu("Speech") {
                Button("Speak Result") {
                    NotificationCenter.default.post(name: .speakResultCommand, object: nil)
                }
                .keyboardShortcut("s", modifiers: [.command, .shift])
            }

            CommandMenu("Translate") {
                Button("Translate Now") {
                    NotificationCenter.default.post(name: .translateCommand, object: nil)
                }
                .keyboardShortcut(.return, modifiers: .command)
            }

            CommandGroup(after: .textEditing) {
                Button("Find in Subjects…") {
                    appState.sidebarSelection = .tool(.search)
                }
                .keyboardShortcut("f", modifiers: .command)

                Button("Go Back") {
                    NotificationCenter.default.post(name: .navigateBackCommand, object: nil)
                }
                .keyboardShortcut("[", modifiers: .command)
            }

            // Help menu additions:
            //   desktopAhaan Help          — opens KeyboardShortcutsSheet
            //                                (our only in-app help today)
            //   Reveal Crash Logs in Finder — one-click access to the folder
            //   Clear Crash Logs           — wipe everything after a fix lands
            CommandGroup(replacing: .help) {
                Button("desktopAhaan Help") {
                    NotificationCenter.default.post(name: .openInAppHelp, object: nil)
                }
                .keyboardShortcut("?", modifiers: .command)

                Divider()

                Button("Reveal Crash Logs in Finder") {
                    let url = CrashReporter.shared.logDirectoryURL
                    NSWorkspace.shared.activateFileViewerSelecting([url])
                }

                Button("Clear Crash Logs") {
                    let n = CrashReporter.shared.clearAllLogs()
                    let alert = NSAlert()
                    alert.messageText = "Cleared \(n) crash log file(s)."
                    alert.informativeText = "New crashes will produce a fresh log file."
                    alert.alertStyle = .informational
                    alert.addButton(withTitle: "OK")
                    alert.runModal()
                }
            }
        }
    }
}

extension Notification.Name {
    static let openInAppHelp = Notification.Name("desktopAhaan.openInAppHelp")
}
