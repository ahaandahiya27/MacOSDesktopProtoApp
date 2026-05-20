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
        // Start the main-thread hang watchdog after the run-loop is fully
        // up (avoids false positives during the launch cascade). DEBUG-only;
        // release builds no-op.
        CrashReporter.shared.startHangDetection()
    }

    /// Belt-and-suspenders at ⌘Q. Every `DataStore` mutation already calls
    /// `try data.write(to:options:.atomic)` synchronously on the main actor
    /// so there is no in-memory queue waiting to drain. We still:
    ///   - force a `UserDefaults` synchronize (a no-op on modern macOS but
    ///     harmless and makes intent explicit).
    ///   - log the clean-quit so a future "did the app quit or did it
    ///     crash?" investigation is unambiguous against the crash log.
    func applicationWillTerminate(_ notification: Notification) {
        // Drain any in-flight coalesced DataStore writes BEFORE marking a
        // clean exit — otherwise a ⌘Q during the 250ms debounce window
        // would silently drop the latest mutation. flushSavesBeforeQuit
        // is synchronous on the main actor; AppKit guarantees this
        // delegate method runs on main so the await completes inline.
        let flushSema = DispatchSemaphore(value: 0)
        Task { @MainActor in
            DataStore.shared.flushSavesBeforeQuit()
            flushSema.signal()
        }
        // Bounded wait: 1 second is generous — each pending write is one
        // small JSON atomic-replace. If we somehow can't finish in 1s
        // we proceed anyway rather than blocking a shutdown forever.
        _ = flushSema.wait(timeout: .now() + 1.0)
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
        // JSON. Bumped from .utility to .userInitiated so it competes
        // for cores against the UI thread instead of waiting behind
        // other background work — the dictionary is on the user's hot
        // path within seconds of launch, so the brief priority bump is
        // appropriate. After completion, `SanskritDictionary.isReady`
        // reads true on any thread (atomic).
        Task.detached(priority: .userInitiated) {
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
                // on the deploy iMac's 5K @1×.
                //
                // Ideal size bumped to 2200×1380 so the first-launch window
                // fills more of the iMac 5K display (2560×1440 logical) —
                // previously the 1500pt ideal left ~1060pt of desktop
                // visible on the right, which read as "half-screen" /
                // "distorted" rendering. Smaller-screen Macs will still
                // clip to the available area automatically.
                .frame(
                    minWidth: 1024, idealWidth: 2200,
                    minHeight: 640, idealHeight: 1380
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

                Button("Show Bookmarks") {
                    appState.sidebarSelection = .tool(.bookmarks)
                }
                .keyboardShortcut("b", modifiers: .command)

                Button("Show Daily Practice") {
                    appState.sidebarSelection = .tool(.dailyPractice)
                }
                .keyboardShortcut("p", modifiers: [.command, .shift])

                Button("Show Discover Progress") {
                    appState.sidebarSelection = .tool(.discover)
                }
                .keyboardShortcut("d", modifiers: [.command, .shift])

                Button("Show Settings") {
                    appState.sidebarSelection = .tool(.settings)
                }
                .keyboardShortcut(",", modifiers: [.command, .shift])
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
