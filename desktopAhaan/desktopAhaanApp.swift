import SwiftUI
import os.log

// Crash capture: see App/CrashReporter.swift. It writes uncaught
// NSExceptions, POSIX fatal signals (SIGABRT, SIGSEGV, SIGBUS, SIGILL,
// SIGFPE, SIGPIPE), AND non-fatal data-quality issues (e.g. duplicate
// IDs caught by SubjectPack) to one append-only file per UTC day under
// ~/Library/Application Support/desktopAhaan/crashlogs/.

private let appLogger = Logger(subsystem: "com.emoha.desktopAhaan", category: "App")

@MainActor
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
        // would silently drop the latest mutation. AppKit guarantees this
        // delegate method runs on the main thread and AppDelegate is now
        // @MainActor-isolated, so we can call DataStore directly.
        //
        // History: an earlier version used `Task { @MainActor in ... }`
        // plus a `DispatchSemaphore.wait(timeout: 1.0)` as a watchdog.
        // That pattern *deadlocked* — the Task scheduled work onto the
        // main actor's queue, but the main thread was blocked on the
        // semaphore, so the Task body never ran and the timeout fired on
        // every quit (silently logging a spurious "flushSavesBeforeQuit
        // timeout" DATA entry). Direct call is the simpler + correct
        // version. The flush itself is bounded (one atomic write per
        // pending file).
        DataStore.shared.flushSavesBeforeQuit()
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
    // MUST be the shared singleton: Boss-Quiz / quick-check scenes and
    // `applicationWillTerminate` use `DataStore.shared`, while views read the
    // injected `@EnvironmentObject`. A separate `DataStore()` here created a
    // SECOND instance that autoloaded and atomic-wrote the SAME JSON files
    // from a different in-memory dict — so a topic-question review (env) and a
    // boss-quiz review (.shared) clobbered each other's reviews.json, and
    // ⌘Q's flushSavesBeforeQuit drained the wrong (near-empty) instance.
    @StateObject private var dataStore = DataStore.shared

    /// Drives the first-launch onboarding sheet. Decided once in `init()`
    /// (before any view appears) so the legacy welcome-tour auto-present is
    /// reliably suppressed on a fresh install — see the gate in `init`.
    @State private var showOnboarding: Bool = false

    /// First-launch window ideal size. Design target is 2200×1380 (tuned
    /// for the 5K iMac at 2560×1440 logical, where `visibleFrame.height`
    /// runs ~1417pt after the menu bar). On a 13" MBP at 1440×900 with
    /// `visibleFrame.height` ~841pt, the unclamped 1380 ideal opened the
    /// window at ~95% of screen height — uncomfortably close to the edge.
    /// `clampWindowIdeal` returns the design size unchanged when both
    /// dimensions fit; otherwise it scales to ~85% of the visible area
    /// so the window opens with breathing room.
    static let firstLaunchFrame: CGSize = clampWindowIdeal(
        design: CGSize(width: 2200, height: 1380),
        visible: NSScreen.main?.visibleFrame.size
    )

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

        // ── First-launch onboarding gate ──────────────────────────────────
        // Decided HERE, before any view body or `.onAppear`, because the
        // ordering between this App's onAppear and ContentView's own onAppear
        // is unspecified. Resolving the flags up front guarantees the legacy
        // 3-panel welcome tour (auto-presented by ContentView when
        // `!hasSeenWelcomeTour`) stays suppressed on a fresh install — the kid
        // gets exactly ONE onboarding, the new 4-page FirstLaunchTourView.
        //
        // ContentView is owned by another surface this run and is not touched;
        // suppression is achieved purely by pre-setting the UserDefaults keys
        // it reads via @AppStorage.
        let defaults = UserDefaults.standard
        let seenOnboarding = defaults.bool(forKey: OnboardingState.hasSeenOnboardingKey)
        let seenLegacyTour = defaults.bool(forKey: AppStorageKeys.hasSeenWelcomeTour)
        var present = false
        if !seenOnboarding {
            if seenLegacyTour {
                // Existing user upgrading from a build that only had the
                // legacy tour — they already onboarded. Migrate the flag
                // forward silently; do not re-onboard them.
                defaults.set(true, forKey: OnboardingState.hasSeenOnboardingKey)
            } else {
                // Genuinely fresh install. Suppress BOTH of ContentView's
                // first-launch auto-presents (welcome tour + What's New) so
                // they don't stack behind / after the new tour, then present
                // the new tour. `hasSeenOnboarding` flips when the tour
                // completes or is skipped (see the sheet callbacks).
                defaults.set(true, forKey: AppStorageKeys.hasSeenWelcomeTour)
                defaults.set(WhatsNewSheet.currentVersion,
                             forKey: AppStorageKeys.whatsNewLastSeenVersion)
                present = true
            }
        }
        _showOnboarding = State(initialValue: present)
    }

    var body: some Scene {
        let frame = Self.firstLaunchFrame
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .environmentObject(subjectRegistry)
                .environmentObject(dataStore)
                // Min 1024×640 honours macOS's split-screen tile half-width
                // on the deploy iMac's 5K @1×.
                //
                // Ideal sized via `firstLaunchFrame` below — clamps to ~85%
                // of `NSScreen.main.visibleFrame` on smaller displays so the
                // window doesn't open at ~95% of screen height on a 13" MBP
                // (where the auto-clip from the 2200×1380 design landed
                // before this guard).
                .frame(
                    minWidth: 1024, idealWidth: frame.width,
                    minHeight: 640, idealHeight: frame.height
                )
                // First-launch onboarding. Presented from the App level
                // (not inside ContentView, which is owned elsewhere this
                // run) and gated by `showOnboarding`, resolved in `init()`.
                // On a fresh install ContentView's own first-launch sheet is
                // suppressed (see the init gate), so only this sheet is ever
                // active here — no Big Sur sheet-stacking conflict.
                .sheet(isPresented: $showOnboarding) {
                    FirstLaunchTourView(
                        onClose: {
                            OnboardingState.shared.markSeen()
                            showOnboarding = false
                        },
                        onGetStarted: {
                            OnboardingState.shared.markSeen()
                            appState.sidebarSelection =
                                .subject(OnboardingStep.getStartedPackId)
                            showOnboarding = false
                        }
                    )
                }
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

                Divider()

                // Discoverability layer (2026-05-23 polish session).
                // Each posts a notification that ContentView listens
                // for and routes through its single-sheet dispatcher.
                Button("Show Welcome Tour") {
                    NotificationCenter.default.post(name: .showWelcomeTour, object: nil)
                }

                Button("What's New") {
                    NotificationCenter.default.post(name: .showWhatsNew, object: nil)
                }

                Button("About Daily Practice") {
                    NotificationCenter.default.post(name: .showAboutDailyPractice, object: nil)
                }

                Button("About Deep Dive Mode") {
                    NotificationCenter.default.post(name: .showAboutDeepDive, object: nil)
                }

                Button("About Audio Narration") {
                    NotificationCenter.default.post(name: .showAboutAudio, object: nil)
                }

                Divider()

                // Parent / Weekly Progress dashboard. Opens in its own
                // window (see WeeklyProgressWindow.swift) — no ContentView
                // sheet routing needed. ⌘⇧W is unused by AppKit defaults
                // (⌘W closes the window; the Shift variant is free).
                Button("Weekly Progress") {
                    WeeklyProgressWindowPresenter.shared.present(
                        dataStore: dataStore, registry: subjectRegistry
                    )
                }
                .keyboardShortcut("w", modifiers: [.command, .shift])
            }
        }
    }
}

// MARK: - First-launch window clamp
//
// Pure function so the policy is unit-testable without spinning up an
// NSScreen / app target. `visible` is `NSScreen.main?.visibleFrame.size`
// at call time; pass nil to model the "no screen attached" path (e.g.
// during headless test runs). Returns the design size unchanged when
// both dimensions fit; otherwise scales to `comfortableFraction` of the
// visible area so the window has off-edge breathing room.
//
// `comfortableFraction = 0.85` per the POLISH_TODOS guidance — at 0.95
// the window opened uncomfortably close to the screen edges on a 13"
// MBP; at 0.85 it lands with ~7.5% margin on each side.
func clampWindowIdeal(
    design: CGSize,
    visible: CGSize?,
    comfortableFraction: CGFloat = 0.85
) -> CGSize {
    guard let visible = visible else { return design }
    let fits = design.width <= visible.width && design.height <= visible.height
    if fits { return design }
    return CGSize(
        width: visible.width * comfortableFraction,
        height: visible.height * comfortableFraction
    )
}

extension Notification.Name {
    static let openInAppHelp = Notification.Name("desktopAhaan.openInAppHelp")
    /// Help → Show Welcome Tour (the 3-panel WelcomeTourSheet).
    static let showWelcomeTour = Notification.Name("desktopAhaan.showWelcomeTour")
    /// Help → What's New (WhatsNewSheet).
    static let showWhatsNew = Notification.Name("desktopAhaan.showWhatsNew")
    /// Help → About Deep Dive Mode (FeatureExplainerSheet.aboutDeepDive).
    static let showAboutDeepDive = Notification.Name("desktopAhaan.showAboutDeepDive")
    /// Help → About Audio Narration (FeatureExplainerSheet.aboutAudio).
    static let showAboutAudio = Notification.Name("desktopAhaan.showAboutAudio")
    /// Help → About Daily Practice (FeatureExplainerSheet.aboutDailyPractice).
    static let showAboutDailyPractice = Notification.Name("desktopAhaan.showAboutDailyPractice")
}
