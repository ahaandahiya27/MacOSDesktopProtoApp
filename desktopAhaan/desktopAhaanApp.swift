import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationWillFinishLaunching(_ notification: Notification) {
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
