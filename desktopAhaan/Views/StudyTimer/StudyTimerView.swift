import SwiftUI
import AppKit

/// A small focused-practice companion: a Pomodoro countdown with ▶ / ⏸ / ↺
/// controls, a phase indicator, and an optional chime on phase change. Opened
/// from Help → "Study Timer" / ⌘⇧T via `StudyTimerWindowPresenter` (its own
/// AppKit window). The `PomodoroState` lives on the presenter so the clock
/// survives a window close.
///
/// `@MainActor` — drives `PomodoroState` (main-actor) and AppKit.
@MainActor
struct StudyTimerView: View {
    @ObservedObject var pomodoro: PomodoroState
    var onClose: (() -> Void)?

    /// Big monospaced-digit countdown font (AppKit-backed — SwiftUI's
    /// `.monospacedDigit()` Font modifier is macOS 12+).
    private static let clockFont = Font(
        NSFont.monospacedDigitSystemFont(ofSize: 72, weight: .bold))

    var body: some View {
        VStack(spacing: 22) {
            phaseHeader
            clock
            tomatoRow
            controls
            Divider()
            soundToggle
        }
        .padding(28)
        .frame(minWidth: 360, minHeight: 380)
    }

    // MARK: - Pieces

    private var phaseHeader: some View {
        Text(pomodoro.phase.displayName)
            .font(.title2.weight(.semibold))
            .foregroundColor(phaseTint)
            .respectReduceMotion(animation: .easeInOut(duration: 0.25))
            .accessibilityLabel("Phase: \(pomodoro.phase.displayName)")
    }

    private var clock: some View {
        Text(pomodoro.formattedRemaining)
            .font(Self.clockFont)
            .foregroundColor(DesignTokens.BrandColor.canvasText)
            .accessibilityLabel("\(pomodoro.formattedRemaining) remaining")
    }

    private var tomatoRow: some View {
        Text("🍅 × \(pomodoro.completedFocusSessions)")
            .font(.headline)
            .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
            .accessibilityLabel("\(pomodoro.completedFocusSessions) focus sessions completed")
    }

    private var controls: some View {
        HStack(spacing: 18) {
            Button(action: { toggleRun() }) {
                Image(systemName: SFSymbolCompat.name(
                    pomodoro.isRunning ? "pause.fill" : "play.fill"))
                    .font(.system(size: 28))
            }
            .buttonStyle(.borderless)
            .help(pomodoro.isRunning ? "Pause" : "Start")
            .accessibilityLabel(pomodoro.isRunning ? "Pause" : "Start")
            .accessibilityHint(pomodoro.isRunning ? "Pauses the focus timer" : "Starts the focus timer counting down")
            .accessibilityIdentifier("study-timer-toggle")

            Button(action: { pomodoro.reset() }) {
                Image(systemName: SFSymbolCompat.name("arrow.counterclockwise"))
                    .font(.system(size: 24))
            }
            .buttonStyle(.borderless)
            .help("Reset")
            .accessibilityLabel("Reset")
            .accessibilityHint("Resets the timer back to a fresh focus phase")
            .accessibilityIdentifier("study-timer-reset")
        }
    }

    private var soundToggle: some View {
        Toggle(isOn: $pomodoro.soundEnabled) {
            Text("Chime when a phase ends")
                .font(.subheadline)
                .foregroundColor(DesignTokens.BrandColor.canvasText)
        }
        .toggleStyle(.switch)
        .accessibilityIdentifier("study-timer-sound-toggle")
    }

    private var phaseTint: Color {
        switch pomodoro.phase {
        case .focus:      return DesignTokens.BrandColor.primaryAction
        case .shortBreak: return DesignTokens.BrandColor.relatedConcepts
        case .longBreak:  return Color.compatIndigo
        }
    }

    private func toggleRun() {
        if pomodoro.isRunning { pomodoro.pause() } else { pomodoro.start() }
    }
}

// MARK: - Window presenter

/// Opens `StudyTimerView` in its own AppKit window from ⌘⇧T / Help → "Study
/// Timer". Owns the `PomodoroState` so the clock keeps running across a window
/// close. Singleton — mirrors `DailyPlanWindowPresenter`.
@MainActor
final class StudyTimerWindowPresenter: NSObject, NSWindowDelegate {
    static let shared = StudyTimerWindowPresenter()
    private var window: NSWindow?
    private let pomodoro = PomodoroState()

    func present() {
        if let existing = window {
            existing.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
            return
        }
        let root = StudyTimerView(pomodoro: pomodoro,
                                  onClose: { [weak self] in self?.close() })
        let hosting = NSHostingController(rootView: root)
        let win = NSWindow(contentViewController: hosting)
        win.title = "Study Timer"
        win.setContentSize(NSSize(width: 380, height: 420))
        win.styleMask = [.titled, .closable, .miniaturizable]
        win.isReleasedWhenClosed = false
        win.center()
        win.delegate = self
        window = win
        win.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    private func close() {
        window?.orderOut(nil)
        window = nil
    }

    nonisolated func windowWillClose(_ notification: Notification) {
        Task { @MainActor in self.window = nil }
    }
}

// MARK: - Adaptive Practice Settings (Help → "Adaptive Practice Settings")

/// A compact settings panel for the three practice features this run shipped:
/// the adaptive-difficulty engine on/off, the study-timer chime, and the
/// worksheet default question count. Kept here (rather than editing the main
/// SettingsScreen, owned by another surface) so the whole adaptive-practice
/// surface stays in this run's files.
@MainActor
struct PracticeSettingsView: View {
    var onClose: (() -> Void)?

    @State private var adaptiveOn: Bool = AdaptiveDifficultyStorage.isEngineEnabled()
    @State private var timerChime: Bool = PomodoroStorage.soundEnabled()
    @State private var worksheetCount: Int = WorksheetStorage.defaultCount()

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("Adaptive Practice")
                .font(.largeTitle.weight(.bold))
                .foregroundColor(DesignTokens.BrandColor.canvasText)

            Toggle(isOn: $adaptiveOn) {
                settingLabel("Adapt question difficulty",
                             "Surfaces harder questions after a hot streak and easier ones to rebuild confidence.")
            }
            .toggleStyle(.switch)
            .onChange(of: adaptiveOn) { AdaptiveDifficultyStorage.setEngineEnabled($0) }
            .accessibilityIdentifier("practice-settings-adaptive-toggle")

            Toggle(isOn: $timerChime) {
                settingLabel("Study-timer chime",
                             "Play a short sound when a focus or break phase ends.")
            }
            .toggleStyle(.switch)
            .onChange(of: timerChime) { PomodoroStorage.setSoundEnabled($0) }
            .accessibilityIdentifier("practice-settings-chime-toggle")

            VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                settingLabel("Default worksheet length",
                             "How many questions a new printable worksheet starts with.")
                Picker("Default worksheet length", selection: $worksheetCount) {
                    ForEach(WorksheetSampler.countChoices, id: \.self) { n in
                        Text("\(n)").tag(n)
                    }
                }
                .pickerStyle(.segmented)
                .labelsHidden()
                .onChange(of: worksheetCount) { WorksheetStorage.setDefaultCount($0) }
                .accessibilityIdentifier("practice-settings-worksheet-count")
            }

            Spacer(minLength: DesignTokens.Spacing.xs)
            HStack {
                Spacer()
                Button("Done") { onClose?() }
                    .keyboardShortcut(.defaultAction)
                    .accessibilityIdentifier("practice-settings-done")
            }
        }
        .padding(DesignTokens.Spacing.xl)
        .frame(minWidth: 420, minHeight: 320)
    }

    private func settingLabel(_ title: String, _ detail: String) -> some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xxs) {
            Text(title)
                .font(.headline)
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            Text(detail)
                .font(.caption)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
        }
    }
}

/// Window presenter for `PracticeSettingsView` (⌘ no-shortcut; Help only).
@MainActor
final class PracticeSettingsWindowPresenter: NSObject, NSWindowDelegate {
    static let shared = PracticeSettingsWindowPresenter()
    private var window: NSWindow?

    func present() {
        if let existing = window {
            existing.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
            return
        }
        let root = PracticeSettingsView(onClose: { [weak self] in self?.close() })
        let hosting = NSHostingController(rootView: root)
        let win = NSWindow(contentViewController: hosting)
        win.title = "Adaptive Practice Settings"
        win.setContentSize(NSSize(width: 460, height: 360))
        win.styleMask = [.titled, .closable, .miniaturizable]
        win.isReleasedWhenClosed = false
        win.center()
        win.delegate = self
        window = win
        win.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    private func close() {
        window?.orderOut(nil)
        window = nil
    }

    nonisolated func windowWillClose(_ notification: Notification) {
        Task { @MainActor in self.window = nil }
    }
}
