import Foundation
import AppKit

// MARK: - ArticleCoordinator · link click routing
//
// Resolves clicks on `.link` attributes in the rendered NSTextView.
// `ArticleStructuredRenderer` emits anchor cards and footer
// "← Back to chapter" links with hrefs that are usually *relative*
// to the current article's directory (e.g. `ch01_scientists.html`
// from inside `ch01_beyond.html`). NSTextView's default click
// handler treats the href as a URL, sees it doesn't have a scheme,
// and either does nothing or hands it to NSWorkspace which then
// fails to open it. The kid clicks the card and nothing happens.
//
// This file's `textView(_:clickedOnLink:at:)` returns a routing
// decision derived purely from the link value + the current
// article's URL. The decision logic is exposed as a static helper
// (`linkAction(for:relativeTo:fileExists:)`) so it's unit-testable
// without an NSTextView or a real file system.

/// Routing decision produced by `ArticleCoordinator.linkAction(...)`.
/// Pure value type so the unit tests don't have to spin up a real
/// NSTextView or touch the file system.
enum ArticleLinkAction: Equatable {
    /// Resolved to an existing file under the current article's
    /// directory. The receiver should call
    /// `coordinator.load(fileURL:inFolder:)` with this URL so the
    /// click stays inside the same browser.
    case openInternally(URL)
    /// http(s) URL — return false from the delegate so AppKit /
    /// NSWorkspace opens the link externally (default behaviour).
    case openExternally
    /// Unresolvable / file missing. The delegate should return
    /// true to *swallow* the click — preventing NSTextView from
    /// falling through to its broken default for relative hrefs.
    case swallow
}

extension ArticleCoordinator {

    /// NSTextViewDelegate hook. Routes the click via
    /// `linkAction(for:relativeTo:fileExists:)` and acts on the
    /// returned `ArticleLinkAction`.
    ///
    /// Returning true tells NSTextView the click was handled;
    /// returning false lets the system default handler take over.
    func textView(
        _ textView: NSTextView,
        clickedOnLink link: Any,
        at charIndex: Int
    ) -> Bool {
        let action = Self.linkAction(
            for: link,
            relativeTo: currentURL,
            fileExists: { FileManager.default.fileExists(atPath: $0.path) }
        )
        switch action {
        case .openInternally(let url):
            let folder = url.deletingLastPathComponent().lastPathComponent
            load(fileURL: url, inFolder: folder)
            return true
        case .openExternally:
            // Hand back to NSTextView's default URL handler, which
            // forwards to NSWorkspace.shared.open(_:).
            return false
        case .swallow:
            return true
        }
    }

    /// Pure routing decision. Extracted as a `nonisolated static`
    /// function with a `fileExists` closure injection so unit tests
    /// can pass a fake existence map and assert the action without
    /// touching disk OR hopping onto the main actor.
    nonisolated static func linkAction(
        for link: Any,
        relativeTo currentURL: URL?,
        fileExists: (URL) -> Bool
    ) -> ArticleLinkAction {
        // Normalise the link value. NSTextView passes either:
        //   - String (when the .link attribute value was a String)
        //   - URL    (when the .link attribute value was a URL)
        // Anything else → swallow defensively rather than crash.
        let trimmedString: String?
        let url: URL?
        if let s = link as? String {
            trimmedString = s.trimmingCharacters(in: .whitespacesAndNewlines)
            url = nil
        } else if let u = link as? URL {
            trimmedString = nil
            url = u
        } else {
            return .swallow
        }

        // http / https → external open. NSTextView's default
        // handler routes through NSWorkspace which opens the user's
        // browser — that's exactly the behaviour we want for
        // off-app links.
        if let s = trimmedString,
           s.lowercased().hasPrefix("http://") || s.lowercased().hasPrefix("https://") {
            return .openExternally
        }
        if let u = url,
           let scheme = u.scheme?.lowercased(),
           scheme == "http" || scheme == "https" {
            return .openExternally
        }

        // Resolve a candidate file URL.
        guard let baseURL = currentURL else { return .swallow }
        let baseDir = baseURL.deletingLastPathComponent()
        let candidate: URL?
        if let s = trimmedString, !s.isEmpty {
            // String form — treat as a relative path.
            candidate = baseDir.appendingPathComponent(s)
        } else if let u = url {
            if u.isFileURL {
                candidate = u
            } else {
                // Relative URL form (no scheme). Resolve against
                // baseDir's absolute string.
                candidate = URL(string: u.relativeString, relativeTo: baseDir)
            }
        } else {
            candidate = nil
        }

        guard let resolved = candidate?.standardizedFileURL else {
            return .swallow
        }
        return fileExists(resolved) ? .openInternally(resolved) : .swallow
    }
}
