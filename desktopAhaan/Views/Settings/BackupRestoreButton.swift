import SwiftUI
import AppKit
import os.log

/// Settings affordance that restores a previously-exported backup
/// envelope (produced by `BackupExportButton`) into
/// `~/Library/Application Support/com.emoha.desktopAhaan/data/`.
///
/// The flow:
///   1. Tap → `NSOpenPanel` for the user to pick a `.json` envelope.
///   2. Parse + validate the envelope (`schema == "desktopAhaan-backup-v1"`,
///      `version == 1`, `files` is a dict of JSON values).
///   3. Two-step confirmation alert — destructive overwrite.
///   4. Write each bundled file atomically into the data dir,
///      overwriting any existing file with the same name.
///
/// Conservative on validation; refuses anything that doesn't look
/// exactly like a v1 envelope. A failed restore leaves the existing
/// data dir untouched (each write is atomic and we abort on the
/// first error).
///
/// Big Sur 11.7 compatible: uses `NSOpenPanel.allowedFileTypes`
/// (deprecated in macOS 12 but still functional on 11.x).
struct BackupRestoreButton: View {
    @State private var lastStatus: String?
    @State private var lastStatusIsError: Bool = false
    @State private var showOverwriteConfirm: Bool = false
    @State private var pendingEnvelope: ParsedEnvelope?

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Button {
                presentOpenPanelAndStage()
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: SFSymbolCompat.name("square.and.arrow.down"))
                    Text("Restore from backup…")
                }
            }
            .accessibilityLabel("Restore from backup — replace current progress with a previously-saved JSON backup file")

            if let status = lastStatus {
                Text(status)
                    .font(.caption)
                    .foregroundColor(lastStatusIsError ? .red : .secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .alert(isPresented: $showOverwriteConfirm) {
            Alert(
                title: Text("Restore from backup?"),
                message: Text("This will replace your current practice progress, history, and favorites with the contents of the backup file. This can't be undone."),
                primaryButton: .destructive(Text("Restore")) {
                    commitPendingRestore()
                },
                secondaryButton: .cancel { pendingEnvelope = nil }
            )
        }
    }

    // MARK: - UI flow

    private func presentOpenPanelAndStage() {
        let panel = NSOpenPanel()
        panel.allowedFileTypes = ["json"]
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.message = "Pick a desktopAhaan-backup-…json file to restore."
        guard panel.runModal() == .OK, let source = panel.url else {
            return
        }
        switch BackupRestoreButton.parseEnvelope(at: source) {
        case .success(let envelope):
            pendingEnvelope = envelope
            showOverwriteConfirm = true
        case .failure(let error):
            lastStatus = "Couldn't read backup: \(error.localizedDescription)"
            lastStatusIsError = true
        }
    }

    private func commitPendingRestore() {
        guard let envelope = pendingEnvelope else { return }
        pendingEnvelope = nil
        switch BackupRestoreButton.applyEnvelope(envelope) {
        case .success(let count):
            lastStatus = "Restored \(count) data file\(count == 1 ? "" : "s")."
            lastStatusIsError = false
        case .failure(let error):
            lastStatus = "Restore failed: \(error.localizedDescription)"
            lastStatusIsError = true
        }
    }

    // MARK: - Envelope parsing + apply (testable)

    /// Parsed shape of the v1 envelope after validation. Only
    /// JSON-decodable files survive the parse — anything else fails
    /// loud before we touch the data dir.
    struct ParsedEnvelope {
        let createdAt: String
        let files: [String: Data]
    }

    enum RestoreError: LocalizedError {
        case notJSON
        case wrongShape
        case wrongSchema(String)
        case wrongVersion(Int)
        case filesNotADict
        case fileBodyNotJSON(String)
        case writeFailed(String, Error)

        var errorDescription: String? {
            switch self {
            case .notJSON: return "The picked file isn't valid JSON."
            case .wrongShape: return "The picked file isn't a desktopAhaan backup envelope (top level must be an object)."
            case .wrongSchema(let s): return "Wrong schema (\(s)); expected `desktopAhaan-backup-v1`."
            case .wrongVersion(let v): return "Wrong version (\(v)); only v1 backups can be restored."
            case .filesNotADict: return "The backup's `files` entry isn't an object — file can't be restored safely."
            case .fileBodyNotJSON(let name): return "The bundled `\(name)` isn't valid JSON; refusing partial restore."
            case .writeFailed(let name, let underlying):
                return "Couldn't write `\(name)`: \(underlying.localizedDescription)"
            }
        }
    }

    /// Validates the file at `url` is a well-formed v1 backup envelope
    /// and returns the (filename → JSON bytes) map ready to write.
    /// Exposed `static` for testing without driving NSOpenPanel.
    static func parseEnvelope(at url: URL) -> Result<ParsedEnvelope, Error> {
        do {
            let data = try Data(contentsOf: url)
            guard let top = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                return .failure(RestoreError.wrongShape)
            }
            if let schema = top["schema"] as? String {
                if schema != "desktopAhaan-backup-v1" {
                    return .failure(RestoreError.wrongSchema(schema))
                }
            } else {
                return .failure(RestoreError.wrongSchema("<missing>"))
            }
            if let v = top["version"] as? Int, v != 1 {
                return .failure(RestoreError.wrongVersion(v))
            }
            guard let files = top["files"] as? [String: Any] else {
                return .failure(RestoreError.filesNotADict)
            }
            var serialized: [String: Data] = [:]
            for (name, value) in files {
                do {
                    let bytes = try JSONSerialization.data(
                        withJSONObject: value, options: [.prettyPrinted, .sortedKeys]
                    )
                    serialized[name] = bytes
                } catch {
                    return .failure(RestoreError.fileBodyNotJSON(name))
                }
            }
            let createdAt = (top["createdAt"] as? String) ?? "<unknown>"
            return .success(ParsedEnvelope(createdAt: createdAt, files: serialized))
        } catch {
            return .failure(RestoreError.notJSON)
        }
    }

    /// Writes each file in the envelope into the data dir atomically.
    /// Overwrites existing files. Returns count written. Exposed
    /// `static` for testing.
    static func applyEnvelope(
        _ envelope: ParsedEnvelope,
        dataDir: URL? = nil
    ) -> Result<Int, Error> {
        let resolved = dataDir ?? BackupExportButton.defaultDataDir()
        let fm = FileManager.default
        do {
            try fm.createDirectory(at: resolved, withIntermediateDirectories: true)
        } catch {
            return .failure(error)
        }
        for (name, bytes) in envelope.files {
            let target = resolved.appendingPathComponent(name)
            do {
                try bytes.write(to: target, options: .atomic)
            } catch {
                return .failure(RestoreError.writeFailed(name, error))
            }
        }
        return .success(envelope.files.count)
    }
}
