import SwiftUI
import AppKit

/// Help → "Recent Crash Reports…" (⌘⇧X). Renders the crash-log summary that
/// `scripts/analyze_crashlogs.py` deposits in the app's container (see
/// `CrashLogReader` for why we read the cached JSON rather than scan the
/// sandboxed-off DiagnosticReports folder directly).
///
/// Big Sur-safe: SF Symbols 2 glyph names, no macOS 12+ modifiers, every
/// `@ViewBuilder` closure ≤ 10 direct children.
struct CrashLogSummaryView: View {
    @StateObject private var reader = CrashLogReader()
    @State private var copied = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            header
            Divider()
            content
            Divider()
            footer
        }
        .padding(20)
        .frame(minWidth: 560, minHeight: 460)
        .onAppear { reader.reload() }
    }

    // MARK: Header

    private var header: some View {
        HStack(spacing: 12) {
            Image(systemName: "stethoscope")
                .font(.system(size: 28))
                .foregroundColor(.accentColor)
            VStack(alignment: .leading, spacing: 2) {
                Text("Recent Crash Reports")
                    .font(.title2).bold()
                Text("Did the app ever crash? Here's the plain-English answer.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
    }

    // MARK: Content (state machine)

    @ViewBuilder
    private var content: some View {
        switch reader.state {
        case .loading:
            centered { ProgressView() }
        case .noSummary:
            noSummaryState
        case .unreadable(let name):
            centered {
                messageBlock(
                    symbol: "exclamationmark.triangle",
                    title: "Couldn't read \(name)",
                    detail: "The crash summary file exists but couldn't be parsed. "
                          + "Re-run the analyzer to regenerate it.")
            }
        case .loaded:
            if reader.entries.isEmpty {
                centered {
                    messageBlock(
                        symbol: "checkmark.seal",
                        title: "No crashes recorded — perfect!",
                        detail: "The analyzer ran and found no desktopAhaan crash reports.")
                }
            } else {
                crashList
            }
        }
    }

    private var noSummaryState: some View {
        centered {
            messageBlock(
                symbol: "checkmark.seal",
                title: "No crashes recorded — perfect!",
                detail: "No crash summary is on file yet. If the app ever does crash, "
                      + "run scripts/analyze_crashlogs.py (or use Reveal in Finder "
                      + "below) to inspect the raw reports.")
        }
    }

    private var crashList: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                ForEach(reader.entries) { entry in
                    CrashRow(entry: entry)
                }
            }
            .padding(.vertical, 2)
        }
    }

    // MARK: Footer actions

    private var footer: some View {
        HStack(spacing: 12) {
            Button {
                reader.revealReportsInFinder()
            } label: {
                Label("Reveal Crash Logs in Finder", systemImage: "folder")
            }
            .accessibilityHint("Opens the macOS DiagnosticReports folder in Finder.")

            Button {
                copyDiagnostics()
            } label: {
                Label(copied ? "Copied!" : "Copy Diagnostics", systemImage: "doc.on.doc")
            }
            .accessibilityHint("Copies the crash summary JSON to the clipboard.")

            Spacer()

            Button {
                reader.reload()
            } label: {
                Label("Refresh", systemImage: "arrow.clockwise")
            }
        }
    }

    // MARK: Helpers

    private func copyDiagnostics() {
        let pb = NSPasteboard.general
        pb.clearContents()
        pb.setString(reader.clipboardJSON(), forType: .string)
        copied = true
    }

    private func centered<Content: View>(@ViewBuilder _ inner: () -> Content) -> some View {
        VStack {
            Spacer(minLength: 0)
            inner()
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func messageBlock(symbol: String, title: String, detail: String) -> some View {
        VStack(spacing: 10) {
            Image(systemName: symbol)
                .font(.system(size: 40))
                .foregroundColor(.secondary)
            Text(title)
                .font(.headline)
                .multilineTextAlignment(.center)
            Text(detail)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 420)
        }
    }
}

/// One crash row: summary line + when/version/os metadata + top frame.
private struct CrashRow: View {
    let entry: CrashLogEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.orange)
                Text(entry.summary)
                    .font(.callout).bold()
                    .fixedSize(horizontal: false, vertical: true)
            }
            Text(metaLine)
                .font(.caption)
                .foregroundColor(.secondary)
            if !entry.topFrame.isEmpty {
                Text(entry.topFrame)
                    .font(.system(.caption2, design: .monospaced))
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                    .truncationMode(.middle)
            }
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(NSColor.controlBackgroundColor))
        )
    }

    private var metaLine: String {
        var parts: [String] = []
        if !entry.date.isEmpty { parts.append(entry.date) }
        if !entry.appVersion.isEmpty { parts.append("v\(entry.appVersion)") }
        if !entry.osVersion.isEmpty { parts.append(entry.osVersion) }
        return parts.joined(separator: "  •  ")
    }
}

/// Opens `CrashLogSummaryView` in its own AppKit window (same standalone-window
/// pattern as `AchievementGalleryWindowPresenter` / `WeeklyProgressWindow-
/// Presenter` — multi-window scene APIs are macOS 13+, and a sheet would mean
/// editing `ContentView`, owned by another surface this run).
///
/// Singleton so re-triggering ⌘⇧X focuses the existing window instead of
/// stacking duplicates.
@MainActor
final class CrashLogSummaryWindowPresenter: NSObject, NSWindowDelegate {
    static let shared = CrashLogSummaryWindowPresenter()
    private var window: NSWindow?

    func present() {
        if let existing = window {
            existing.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
            return
        }
        let hosting = NSHostingController(rootView: CrashLogSummaryView())
        let win = NSWindow(contentViewController: hosting)
        win.title = "Recent Crash Reports"
        win.setContentSize(NSSize(width: 640, height: 540))
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
