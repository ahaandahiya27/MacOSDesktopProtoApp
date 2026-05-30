import Foundation
import AppKit

/// Read-only loader for the crash-log summary that
/// `scripts/analyze_crashlogs.py` writes into the app's own Application
/// Support container.
///
/// Why read the cached JSON rather than scan `~/Library/Logs/
/// DiagnosticReports` directly: this app is **sandboxed** (the entitlements
/// snapshot pins a temp-exception scope of exactly `/Documents/`), so it
/// cannot read the system DiagnosticReports folder from inside the
/// container — and a `Process`-spawned `python3` would inherit the same
/// sandbox and fail with `errno 1` (operation not permitted). What the app
/// *can* read freely is its own container, where the analyzer deposits
/// `Diagnostics/crashlog_summary_YYYY-MM-DD.json`. So the flow is:
///
///   1. A parent (or a future scheduled task) runs `analyze_crashlogs.py`
///      from a terminal — that process is unsandboxed and parses the raw
///      reports, writing the summary JSON into this container.
///   2. This reader loads that JSON and `CrashLogSummaryView` renders it.
///   3. "Reveal Crash Logs in Finder" works regardless: it sends an Apple
///      event to Finder (cross-process), which the sandbox permits, so the
///      parent can always get to the raw `.ips` / `.crash` files.
///
/// When no summary exists yet, `entries` is empty and `state` is `.noSummary`
/// — the view shows a friendly "run the analyzer to refresh" hint plus the
/// Reveal button, never a scary error.
///
/// `@MainActor` — drives `@Published` UI state and AppKit reveal APIs.
@MainActor
final class CrashLogReader: ObservableObject {

    enum State: Equatable {
        case loading
        case loaded(generated: String)   // ISO timestamp the summary was made
        case noSummary
        case unreadable(String)           // a summary exists but couldn't be parsed
    }

    @Published private(set) var entries: [CrashLogEntry] = []
    @Published private(set) var state: State = .loading

    /// The app's own Diagnostics container — sandbox-readable.
    let diagnosticsDir: URL
    /// The system DiagnosticReports folder — for the Reveal-in-Finder action
    /// only (we never read it from inside the sandbox).
    let systemReportsDir: URL

    init(diagnosticsDir: URL? = nil, systemReportsDir: URL? = nil) {
        let fm = FileManager.default
        if let dir = diagnosticsDir {
            self.diagnosticsDir = dir
        } else {
            let base = (try? fm.url(for: .applicationSupportDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil, create: true))
                ?? URL(fileURLWithPath: NSHomeDirectory())
                    .appendingPathComponent("Library/Application Support")
            self.diagnosticsDir = base
                .appendingPathComponent("desktopAhaan", isDirectory: true)
                .appendingPathComponent("Diagnostics", isDirectory: true)
        }
        self.systemReportsDir = systemReportsDir
            ?? URL(fileURLWithPath: NSHomeDirectory())
                .appendingPathComponent("Library/Logs/DiagnosticReports",
                                        isDirectory: true)
    }

    /// Load the newest `crashlog_summary_*.json` from the container.
    func reload() {
        state = .loading
        guard let url = newestSummaryURL() else {
            entries = []
            state = .noSummary
            return
        }
        guard let data = try? Data(contentsOf: url),
              let obj = try? JSONSerialization.jsonObject(with: data),
              let dict = obj as? [String: Any] else {
            entries = []
            state = .unreadable(url.lastPathComponent)
            return
        }
        let raw = (dict["crashes"] as? [[String: Any]]) ?? []
        entries = raw.map(CrashLogEntry.init(json:))
        let generated = (dict["generated"] as? String) ?? ""
        state = .loaded(generated: generated)
    }

    /// Newest summary file by filename (the date is encoded in the name, so a
    /// lexical max is also the chronological max).
    private func newestSummaryURL() -> URL? {
        let fm = FileManager.default
        guard let items = try? fm.contentsOfDirectory(
            at: diagnosticsDir, includingPropertiesForKeys: nil) else { return nil }
        let summaries = items
            .filter { $0.lastPathComponent.hasPrefix("crashlog_summary_") }
            .filter { $0.pathExtension == "json" }
            .sorted { $0.lastPathComponent > $1.lastPathComponent }
        return summaries.first
    }

    /// Open `~/Library/Logs/DiagnosticReports` in Finder. Uses an Apple event
    /// to Finder (cross-process), which the sandbox allows — so this works
    /// even though the app can't *read* that folder itself. If the folder
    /// doesn't exist (a Mac that never crashed), reveal its parent.
    func revealReportsInFinder() {
        let fm = FileManager.default
        if fm.fileExists(atPath: systemReportsDir.path) {
            NSWorkspace.shared.activateFileViewerSelecting([systemReportsDir])
        } else {
            NSWorkspace.shared.activateFileViewerSelecting(
                [systemReportsDir.deletingLastPathComponent()])
        }
    }

    /// The raw summary JSON (pretty-printed) for the "Copy diagnostics" action.
    /// Returns a friendly placeholder when there's no summary to copy.
    func clipboardJSON() -> String {
        guard let url = newestSummaryURL(),
              let data = try? Data(contentsOf: url),
              let text = String(data: data, encoding: .utf8) else {
            return "{\n  \"crash_count\": 0,\n  \"note\": \"No crash summary on file — run scripts/analyze_crashlogs.py to generate one.\"\n}\n"
        }
        return text
    }
}

/// One crash, projected from the analyzer's JSON for display.
struct CrashLogEntry: Identifiable {
    let id = UUID()
    let date: String
    let appVersion: String
    let osVersion: String
    let signal: String
    let summary: String
    let topFrame: String

    init(json: [String: Any]) {
        self.date = (json["date"] as? String) ?? ""
        var version = (json["app_version"] as? String) ?? ""
        if let build = json["build"] as? String, !build.isEmpty {
            version = version.isEmpty ? "(\(build))" : "\(version) (\(build))"
        }
        self.appVersion = version
        self.osVersion = (json["os_version"] as? String) ?? ""
        self.signal = (json["signal"] as? String) ?? ""
        self.summary = (json["summary"] as? String) ?? "Crash recorded"
        let frames = (json["top_frames"] as? [String]) ?? []
        self.topFrame = frames.first ?? ""
    }
}
