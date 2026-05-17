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

    private let logDirectoryURL: URL
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
        logger.info("CrashReporter installed; logs go to \(self.logDirectoryURL.path, privacy: .public)")
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
    private func appendToCurrentLog(_ entry: String) {
        let url = currentLogFileURL
        let data = entry.data(using: .utf8) ?? Data()
        let fm = FileManager.default
        if !fm.fileExists(atPath: url.path) {
            try? data.write(to: url, options: .atomic)
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
}
