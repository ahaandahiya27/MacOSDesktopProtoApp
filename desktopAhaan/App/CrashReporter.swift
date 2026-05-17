import Foundation
import os.log

/// Captures uncaught Objective-C exceptions and Unix fatal signals
/// (SIGABRT/SIGILL/SIGBUS/SIGSEGV/SIGFPE/SIGPIPE) to a plain-text log
/// file in the user's Application Support directory:
///
///   ~/Library/Application Support/desktopAhaan/crashlogs/
///       crashlog-YYYY-MM-DD.txt
///
/// Each entry includes timestamp, kind (exception/signal/data-issue),
/// message, and the current call stack symbols. The file is append-only
/// per day so repeated launches collect every crash without overwriting.
///
/// The workflow Rohan wants:
///   1. App captures crashes here on the iMac.
///   2. He commits the crashlog file (or pastes it back to Claude).
///   3. Claude reads the log next session and fixes the root cause.
///   4. After the fix lands, he calls `CrashReporter.shared.clearAllLogs()`
///      (e.g., from a hidden Debug menu, or by deleting the folder
///      manually) and the cycle starts fresh.
///
/// Big Sur (macOS 11) / Swift 5.5 compatible:
///  - Pure Foundation + os.Logger. No async/await escapes the actor;
///    file writes are synchronous via FileHandle so a crash mid-write
///    still flushes what we have.
///  - `signal()` and `NSSetUncaughtExceptionHandler()` exist on every
///    Apple platform since 10.x.
final class CrashReporter {
    static let shared = CrashReporter()

    /// Folder where crash logs are written (one append-only file per UTC day).
    /// Exposed so the Help menu's "Reveal Crash Logs in Finder" can locate it.
    let logDirectoryURL: URL
    private let logger = Logger(subsystem: "in.emoha.desktopAhaan", category: "crash")
    private let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.dateFormat = "yyyy-MM-dd"
        f.timeZone = TimeZone(identifier: "UTC")
        return f
    }()
    private let timestampFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS ZZZZZ"
        return f
    }()

    /// Hard cap on how many daily crashlog files to keep. Older files are
    /// pruned on `install()` and on each rotate check. 30 keeps roughly a
    /// month of context, plenty for diagnosing patterns but bounded so a
    /// long-running install never grows unbounded under the child's home
    /// directory.
    private let maxLogFiles: Int = 30
    /// Hard cap on a single daily file's size in bytes. A runaway loop
    /// hitting a data-issue every frame could otherwise write megabytes
    /// per minute. When today's file exceeds this, it gets rotated to a
    /// `.bak` and a fresh file starts; pruning then enforces `maxLogFiles`.
    private let maxLogFileSizeBytes: Int = 1_048_576  // 1 MB

    private init() {
        // Resolve ~/Library/Application Support/desktopAhaan/crashlogs/
        let fm = FileManager.default
        let base = (try? fm.url(for: .applicationSupportDirectory,
                                in: .userDomainMask,
                                appropriateFor: nil,
                                create: true)) ?? URL(fileURLWithPath: NSHomeDirectory())
            .appendingPathComponent("Library/Application Support")
        let appDir = base.appendingPathComponent("desktopAhaan", isDirectory: true)
        self.logDirectoryURL = appDir.appendingPathComponent("crashlogs", isDirectory: true)
        try? fm.createDirectory(at: self.logDirectoryURL,
                                withIntermediateDirectories: true,
                                attributes: nil)
    }

    /// Wires Objective-C exception handler + Unix signal handlers.
    /// Idempotent — calling twice replaces with the same handler.
    func install() {
        NSSetUncaughtExceptionHandler { exception in
            CrashReporter.shared.recordException(exception)
        }
        for sig in [SIGABRT, SIGILL, SIGBUS, SIGSEGV, SIGFPE, SIGPIPE] {
            signal(sig) { signo in
                CrashReporter.shared.recordSignal(signo)
                // Reset to default and re-raise so the OS still gets the
                // crash and produces its own .crash report in Console.
                signal(signo, SIG_DFL)
                raise(signo)
            }
        }
        // Prune now so a long-idle install doesn't carry months of files
        // forward across launches.
        pruneOldLogs()
        logger.info("CrashReporter installed; logs go to \(self.logDirectoryURL.path, privacy: .public)")
    }

    /// Enforce `maxLogFiles` by deleting the oldest files first. Called
    /// on install + after every rotation. Non-fatal — failures are logged
    /// but never throw out of the crash handler.
    private func pruneOldLogs() {
        let files = allLogFiles()
        guard files.count > maxLogFiles else { return }
        let excess = files.count - maxLogFiles
        let fm = FileManager.default
        for url in files.prefix(excess) {
            try? fm.removeItem(at: url)
        }
        logger.info("CrashReporter: pruned \(excess, privacy: .public) old log file(s)")
    }

    /// Path of the log file for today (one file per UTC day, append-only).
    var currentLogFileURL: URL {
        let day = dateFormatter.string(from: Date())
        return logDirectoryURL.appendingPathComponent("crashlog-\(day).txt")
    }

    /// Quick listing of every crashlog file present, oldest first.
    func allLogFiles() -> [URL] {
        let fm = FileManager.default
        guard let urls = try? fm.contentsOfDirectory(at: logDirectoryURL,
                                                    includingPropertiesForKeys: [.contentModificationDateKey],
                                                    options: [.skipsHiddenFiles]) else {
            return []
        }
        return urls
            .filter { $0.lastPathComponent.hasPrefix("crashlog-") }
            .sorted { ($0.lastPathComponent) < ($1.lastPathComponent) }
    }

    /// Delete all log files. Call this AFTER you've committed/handed the
    /// crash logs off to Claude for analysis and the fix has landed.
    @discardableResult
    func clearAllLogs() -> Int {
        let fm = FileManager.default
        var removed = 0
        for url in allLogFiles() {
            if (try? fm.removeItem(at: url)) != nil {
                removed += 1
            }
        }
        logger.info("CrashReporter: cleared \(removed) log file(s)")
        return removed
    }

    // MARK: - Public entry points used by the rest of the app

    /// Record a non-fatal data-quality issue (e.g., duplicate IDs in JSON).
    /// Does NOT terminate. Writes one line to today's log.
    func logDataIssue(_ message: String,
                      file: String = #file,
                      line: Int = #line) {
        let entry = formatEntry(kind: "DATA",
                                message: message,
                                origin: "\((file as NSString).lastPathComponent):\(line)",
                                stack: [])
        appendToCurrentLog(entry)
        logger.error("data-issue: \(message, privacy: .public)")
    }

    // MARK: - Internals

    private func recordException(_ exception: NSException) {
        let stack = exception.callStackSymbols
        let msg = "\(exception.name.rawValue): \(exception.reason ?? "no reason")"
        let entry = formatEntry(kind: "EXCEPTION",
                                message: msg,
                                origin: "NSUncaughtExceptionHandler",
                                stack: stack)
        appendToCurrentLog(entry)
    }

    private func recordSignal(_ signo: Int32) {
        let name: String
        switch signo {
        case SIGABRT: name = "SIGABRT (e.g. Swift fatalError / precondition / abort)"
        case SIGILL: name = "SIGILL (illegal instruction)"
        case SIGBUS: name = "SIGBUS (bus error / unaligned access)"
        case SIGSEGV: name = "SIGSEGV (bad pointer dereference)"
        case SIGFPE: name = "SIGFPE (arithmetic — divide by zero etc.)"
        case SIGPIPE: name = "SIGPIPE (write to closed pipe)"
        default: name = "signal \(signo)"
        }
        let stack = Thread.callStackSymbols
        let entry = formatEntry(kind: "SIGNAL",
                                message: name,
                                origin: "POSIX signal handler",
                                stack: stack)
        appendToCurrentLog(entry)
    }

    private func formatEntry(kind: String,
                             message: String,
                             origin: String,
                             stack: [String]) -> String {
        let timestamp = timestampFormatter.string(from: Date())
        var out = ""
        out += "═══════════════════════════════════════════════════════════\n"
        out += "[\(kind)] \(timestamp)\n"
        out += "origin : \(origin)\n"
        out += "message: \(message)\n"
        if !stack.isEmpty {
            out += "stack  :\n"
            for line in stack {
                out += "    \(line)\n"
            }
        }
        out += "═══════════════════════════════════════════════════════════\n\n"
        return out
    }

    /// Synchronous append so we still flush if the next instruction crashes.
    /// Rotates today's file off to `.bak` and starts a fresh one when it
    /// exceeds `maxLogFileSizeBytes`, so a runaway data-issue loop can't
    /// fill the disk.
    private func appendToCurrentLog(_ entry: String) {
        let url = currentLogFileURL
        let data = entry.data(using: .utf8) ?? Data()
        let fm = FileManager.default

        rotateIfNeeded(url: url, incomingBytes: data.count)

        if !fm.fileExists(atPath: url.path) {
            try? data.write(to: url, options: .atomic)
            pruneOldLogs()
            return
        }
        if let handle = try? FileHandle(forWritingTo: url) {
            do {
                try handle.seekToEnd()
                try handle.write(contentsOf: data)
                try handle.close()
            } catch {
                // Last resort — at least don't crash inside the crash handler.
                try? data.write(to: url, options: .atomic)
            }
        }
    }

    /// If appending would push today's file past `maxLogFileSizeBytes`,
    /// rename it to `<name>.bak-<timestamp>` and let the next write create
    /// a fresh file. Then enforce `maxLogFiles` so we don't accumulate.
    private func rotateIfNeeded(url: URL, incomingBytes: Int) {
        let fm = FileManager.default
        guard let attrs = try? fm.attributesOfItem(atPath: url.path),
              let size = attrs[.size] as? Int else { return }
        if size + incomingBytes <= maxLogFileSizeBytes { return }

        let stamp = ISO8601DateFormatter().string(from: Date())
            .replacingOccurrences(of: ":", with: "-")
        let backup = url.deletingPathExtension()
            .appendingPathExtension("bak-\(stamp).txt")
        try? fm.moveItem(at: url, to: backup)
        logger.info("CrashReporter: rotated oversize log to \(backup.lastPathComponent, privacy: .public)")
        pruneOldLogs()
    }
}
