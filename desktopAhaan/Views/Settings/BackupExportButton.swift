import SwiftUI
import AppKit
import os.log

/// Settings affordance that exports the kid's progress
/// (`~/Library/Application Support/com.emoha.desktopAhaan/data/`) as a
/// single JSON envelope the parent can email, AirDrop, or restore on
/// another machine.
///
/// The envelope wraps every persisted JSON file under the data
/// directory with a top-level `version` + `createdAt`. No telemetry
/// is sent anywhere — this is a pure user-controlled save.
///
/// Big Sur 11.7 compatible: uses `NSSavePanel.allowedFileTypes`
/// (deprecated in macOS 12 in favour of `allowedContentTypes`, but
/// still functional on 11.x where we deploy).
struct BackupExportButton: View {
    @State private var lastStatus: String?
    @State private var lastStatusIsError: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Button {
                presentSavePanelAndExport()
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: SFSymbolCompat.name("square.and.arrow.up"))
                    Text("Back up my progress…")
                }
            }
            .accessibilityLabel("Back up progress — saves all your data to a single JSON file you can keep or restore on another Mac")
            .accessibilityHint("Opens a save dialog to export your progress as a backup file")

            if let status = lastStatus {
                Text(status)
                    .font(.caption)
                    .foregroundColor(lastStatusIsError ? .red : .secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    // MARK: - Action

    private func presentSavePanelAndExport() {
        let panel = NSSavePanel()
        let timestamp = isoTimestamp(Date())
        panel.nameFieldStringValue = "desktopAhaan-backup-\(timestamp).json"
        panel.allowedFileTypes = ["json"]
        panel.message = "Save a backup of your practice progress, " +
            "favorites, and history. You can keep this file or move " +
            "it to another Mac to restore your data."

        guard panel.runModal() == .OK, let destination = panel.url else {
            return
        }
        switch BackupExportButton.exportBundle(to: destination) {
        case .success(let count):
            lastStatus = "Saved \(count) data file\(count == 1 ? "" : "s") to \(destination.lastPathComponent)."
            lastStatusIsError = false
        case .failure(let error):
            lastStatus = "Backup failed: \(error.localizedDescription)"
            lastStatusIsError = true
        }
    }

    // MARK: - Bundle builder (testable)

    /// Reads every JSON file under the canonical data dir, wraps
    /// them in a versioned envelope, and writes atomically to
    /// `destination`. Returns the count of bundled files on success.
    /// Exposed `static` so tests can call it without driving NSSavePanel.
    static func exportBundle(
        to destination: URL,
        dataDir: URL? = nil,
        now: Date = Date()
    ) -> Result<Int, Error> {
        let resolved = dataDir ?? defaultDataDir()
        let fm = FileManager.default
        let files: [URL]
        do {
            files = try fm.contentsOfDirectory(
                at: resolved, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles]
            )
        } catch {
            return .failure(error)
        }

        var envelope: [String: Any] = [
            "version": 1,
            "createdAt": isoTimestamp(now),
            "schema": "desktopAhaan-backup-v1",
            "files": [String: Any]()
        ]
        var bundled: [String: Any] = [:]
        for fileURL in files where fileURL.pathExtension.lowercased() == "json" {
            do {
                let data = try Data(contentsOf: fileURL)
                let parsed = try JSONSerialization.jsonObject(with: data, options: [])
                bundled[fileURL.lastPathComponent] = parsed
            } catch {
                // Skip files that aren't valid JSON; they don't belong
                // in the envelope, and a partial backup is better than
                // a refused one.
                Logger(subsystem: "in.emoha.desktopAhaan", category: "backup")
                    .error("Skipped \(fileURL.lastPathComponent, privacy: .public): \(error.localizedDescription, privacy: .public)")
            }
        }
        envelope["files"] = bundled

        do {
            let out = try JSONSerialization.data(
                withJSONObject: envelope, options: [.prettyPrinted, .sortedKeys]
            )
            try out.write(to: destination, options: .atomic)
            return .success(bundled.count)
        } catch {
            return .failure(error)
        }
    }

    // MARK: - Helpers

    static func defaultDataDir() -> URL {
        let fm = FileManager.default
        let base = fm.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
            ?? fm.temporaryDirectory
        return base
            .appendingPathComponent("com.emoha.desktopAhaan")
            .appendingPathComponent("data")
    }

    private static func isoTimestamp(_ date: Date) -> String {
        // Compact, filename-safe ISO8601 (no colons, no fractional secs).
        let fmt = DateFormatter()
        fmt.locale = Locale(identifier: "en_US_POSIX")
        fmt.timeZone = TimeZone(identifier: "UTC")
        fmt.dateFormat = "yyyyMMdd-HHmmss"
        return fmt.string(from: date) + "Z"
    }

    private func isoTimestamp(_ date: Date) -> String {
        return BackupExportButton.isoTimestamp(date)
    }
}
