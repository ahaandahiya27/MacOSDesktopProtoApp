import SwiftUI
import AppKit

// MARK: - PlainTextArticleFallback
//
// Shown when WKWebView's WebContent process crashes (common on Big Sur
// with legacy AMD GPUs — the IconRendering Metal shader cache fails).
// Reads the same HTML file, strips tags with a minimal parser, and shows
// the result in a ScrollView so the kid can still read the article even
// when WebKit can't render it. Also offers an "Open in Safari" recovery.

struct PlainTextArticleFallback: View {
    let url: URL?
    let errorMessage: String?
    @State private var bodyText: String = ""
    @State private var loadError: String? = nil

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                HStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.orange)
                    Text("Showing simplified view")
                        .font(.callout.weight(.semibold))
                    Spacer()
                    if let url = url {
                        Button("Open in Safari") {
                            NSWorkspace.shared.open(url)
                        }
                        .controlSize(.small)
                    }
                }
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.orange.opacity(0.12))
                )

                if let err = errorMessage ?? loadError {
                    Text(err)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                if bodyText.isEmpty && loadError == nil {
                    Text("Loading…")
                        .foregroundColor(.secondary)
                } else {
                    // Note: textSelection requires macOS 12 — omit on Big Sur.
                    Text(bodyText)
                        .font(.body)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(20)
        }
        .background(Color(NSColor.windowBackgroundColor))
        .onAppear(perform: load)
    }

    private func load() {
        guard let url = url else {
            loadError = "Article location is unknown."
            return
        }
        // The fallback runs after WebKit has already crashed, so the kid is
        // staring at a half-broken window. Reading + stripping the HTML on
        // main worked in practice (most articles are 30–200 KB) but blocked
        // the run loop for 50–200ms — enough to spin the wheel on the iMac.
        // Hand off to a detached task; the @MainActor hop on completion
        // keeps @State mutations on the right actor.
        Task.detached(priority: .userInitiated) {
            do {
                let raw = try String(contentsOf: url, encoding: .utf8)
                let stripped = Self.stripHTML(raw)
                await MainActor.run {
                    bodyText = stripped
                }
            } catch {
                let message = error.localizedDescription
                await MainActor.run {
                    loadError = message
                }
            }
        }
    }

    /// Cheap HTML→text reducer. Not a real parser — just enough to make a
    /// concept article readable when WebKit is dead. Newlines after block
    /// tags, two newlines after headings/paragraphs/list items.
    ///
    /// `nonisolated` so the off-main `ArticleCoordinator.readParseAndExtractTitle`
    /// can call it from a `Task.detached` body. `PlainTextArticleFallback`
    /// conforms to `View` (which is `@MainActor`-isolated), and without
    /// this annotation Swift 6 would refuse the cross-actor call.
    nonisolated static func stripHTML(_ html: String) -> String {
        var s = html
        let blockBreaks = ["</p>", "</h1>", "</h2>", "</h3>", "</h4>",
                           "</h5>", "</h6>", "</li>", "</div>", "</section>",
                           "</article>", "<br>", "<br/>", "<br />"]
        for tag in blockBreaks {
            s = s.replacingOccurrences(of: tag, with: "\n\n", options: .caseInsensitive)
        }
        // Strip all remaining tags.
        s = s.replacingOccurrences(of: "<[^>]+>", with: "",
                                   options: .regularExpression)
        // Decode the few entities we expect from authored HTML.
        let entities: [(String, String)] = [
            ("&amp;", "&"), ("&lt;", "<"), ("&gt;", ">"),
            ("&quot;", "\""), ("&apos;", "'"), ("&nbsp;", " "),
            ("&mdash;", "—"), ("&ndash;", "–"), ("&hellip;", "…")
        ]
        for (e, r) in entities {
            s = s.replacingOccurrences(of: e, with: r)
        }
        // Collapse runs of 3+ newlines down to exactly 2.
        s = s.replacingOccurrences(of: "\n{3,}", with: "\n\n",
                                   options: .regularExpression)
        return s.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
