import SwiftUI
import SwiftData

@main
struct SanskritKoshApp: App {
    @StateObject private var appState = AppState()
    @StateObject private var subjectRegistry = SubjectRegistry()

    init() {
        // Pre-warm the Sanskrit dictionary on a background task so the
        // 80 KB JSON read happens off the main thread before the user
        // opens the translator. If the user is faster than the warm-up,
        // the worst case is identical to the previous behaviour: a sync
        // load on first access.
        Task(priority: .utility) {
            _ = SanskritDictionary.shared.entries.count
            print("[App] SanskritDictionary pre-warmed.")
        }
    }

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            TranslationRecord.self,
            PracticeProgress.self,
            StudyBookmark.self,
            QuestionAttempt.self,
            StudySession.self,
            DiscoverProgress.self
        ])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [config])
        } catch {
            // If the persistent store is corrupted, try in-memory as fallback
            // This prevents a crash on launch
            let fallbackConfig = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
            do {
                return try ModelContainer(for: schema, configurations: [fallbackConfig])
            } catch {
                fatalError("Could not create ModelContainer: \(error)")
            }
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .environmentObject(subjectRegistry)
                .modelContainer(sharedModelContainer)
                .frame(minWidth: 980, minHeight: 640)
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
                // ⌘⇧C avoids clashing with the system Edit > Copy (⌘C),
                // which is the standard shortcut in any text field.
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
        }
    }
}
