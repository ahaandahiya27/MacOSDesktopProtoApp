import SwiftUI
import os.log

/// Logs uncaught Objective-C exceptions and POSIX signal crashes to a file
/// in Application Support and to the unified log. Doesn't *prevent* crashes,
/// but ensures the next launch can read the trail without relying on the
/// Console app — useful on the older iMac where Crashpad reports are sparse.
private enum CrashLogger {
    static let logger = Logger(subsystem: "com.emoha.desktopAhaan", category: "Crash")

    static func install() {
        NSSetUncaughtExceptionHandler { exception in
            let name = exception.name.rawValue
            let reason = exception.reason ?? "(no reason)"
            let stack = exception.callStackSymbols.joined(separator: "\n")
            let payload = """
            [Uncaught NSException] \(name)
            Reason: \(reason)
            Stack:
            \(stack)
            """
            CrashLogger.logger.error("\(payload, privacy: .public)")
            CrashLogger.writeToFile(payload)
        }

        // POSIX signals that commonly crash an AppKit/SwiftUI app on Big Sur:
        // SIGABRT (assertions), SIGSEGV (bad memory), SIGBUS (alignment),
        // SIGILL (illegal instruction). Default handlers run after ours.
        for sig in [SIGABRT, SIGSEGV, SIGBUS, SIGILL] {
            signal(sig) { signalNumber in
                let payload = "[Signal] caught \(signalNumber)"
                // Logger may not be safe inside a signal handler, but
                // os_log is async-signal-safe enough for our purposes.
                CrashLogger.logger.error("\(payload, privacy: .public)")
                // Re-raise with the default handler so the process actually
                // terminates with the right signal code instead of hanging.
                signal(signalNumber, SIG_DFL)
                raise(signalNumber)
            }
        }
    }

    private static func writeToFile(_ text: String) {
        let fm = FileManager.default
        guard let supportDir = fm.urls(for: .applicationSupportDirectory,
                                       in: .userDomainMask).first else { return }
        let dir = supportDir
            .appendingPathComponent("com.emoha.desktopAhaan")
            .appendingPathComponent("crashes")
        try? fm.createDirectory(at: dir, withIntermediateDirectories: true)
        let stamp = ISO8601DateFormatter().string(from: Date())
            .replacingOccurrences(of: ":", with: "-")
        let url = dir.appendingPathComponent("crash-\(stamp).log")
        try? text.data(using: .utf8)?.write(to: url, options: .atomic)
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationWillFinishLaunching(_ notification: Notification) {
        // Install the crash logger before any UI runs so we capture
        // setup-time exceptions too.
        CrashLogger.install()
        UserDefaults.standard.set(false, forKey: "NSQuitAlwaysKeepsWindows")
        NSWindow.allowsAutomaticWindowTabbing = false
        ensureMetalCacheDirectory()
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
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
        Task(priority: .utility) {
            _ = SanskritDictionary.shared.entries.count
            print("[App] SanskritDictionary pre-warmed.")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .environmentObject(subjectRegistry)
                .environmentObject(dataStore)
                .frame(
                    minWidth: 1280, idealWidth: 1500,
                    minHeight: 800, idealHeight: 950
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
        }
    }
}
