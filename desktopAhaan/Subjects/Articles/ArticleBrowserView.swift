import SwiftUI
import AppKit

struct ArticleBrowserView: View {
    let initialFile: String
    let chapterFolder: String
    @Environment(\.presentationMode) private var presentationMode
    @StateObject private var coordinator: ArticleCoordinator
    @ObservedObject private var speech = SpeechReader.shared

    init(initialFile: String, chapterFolder: String) {
        self.initialFile = initialFile
        self.chapterFolder = chapterFolder
        _coordinator = StateObject(wrappedValue: ArticleCoordinator())
    }

    var body: some View {
        VStack(spacing: 0) {
                // Toolbar with controls
                HStack(spacing: 12) {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title3)
                    }
                    .keyboardShortcut("w", modifiers: .command)
                    .accessibilityLabel("Close article")
                    .help("Close article")

                    Button(action: coordinator.goBack) {
                        Image(systemName: "chevron.left")
                            .font(.body)
                    }
                    .disabled(!coordinator.canGoBack)
                    .accessibilityLabel("Back")
                    .help("Back")

                    Button(action: coordinator.goForward) {
                        Image(systemName: "chevron.right")
                            .font(.body)
                    }
                    .disabled(!coordinator.canGoForward)
                    .accessibilityLabel("Forward")
                    .help("Forward")

                    Button(action: coordinator.reload) {
                        Image(systemName: "arrow.clockwise")
                            .font(.body)
                    }
                    .accessibilityLabel("Reload")
                    .help("Reload")

                    Button(action: coordinator.openCurrentURL) {
                        Image(systemName: "safari")
                            .font(.body)
                    }
                    .accessibilityLabel("Open in Safari")
                    .help("Open in Safari")

                    Spacer()

                    Text(coordinator.pageTitle)
                        .font(.body)
                        .lineLimit(2)
                        .truncationMode(.tail)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 360)

                    Spacer()

                    // Per-paragraph stepping (shown only in paragraph mode)
                    if speech.isParagraphMode {
                        Button(action: { speech.skipParagraph(forward: false) }) {
                            Image(systemName: "backward.fill")
                                .font(.body)
                        }
                        .disabled(speech.paragraphIndex == 0)
                        .accessibilityLabel("Previous paragraph")
                        .accessibilityHint("Restarts reading from the previous paragraph.")
                        .help("Previous paragraph")

                        Button(action: { speech.skipParagraph(forward: true) }) {
                            Image(systemName: "forward.fill")
                                .font(.body)
                        }
                        .disabled(speech.paragraphIndex >= speech.paragraphCount - 1)
                        .accessibilityLabel("Next paragraph")
                        .accessibilityHint("Skips ahead to the next paragraph.")
                        .help("Next paragraph")

                        Text("¶ \(speech.paragraphIndex + 1) / \(speech.paragraphCount)")
                            .font(.caption.monospacedDigit())
                            .foregroundColor(.secondary)
                            .accessibilityLabel(
                                "Paragraph \(speech.paragraphIndex + 1) of \(speech.paragraphCount)"
                            )
                    }

                    // Read aloud button (toggles play / pause / resume)
                    readAloudButton

                    // Stop button (shown only when speaking/paused)
                    if speech.isSpeaking || speech.isPaused {
                        Button(action: { speech.stop(owner: "article") }) {
                            Image(systemName: "stop.fill")
                                .font(.body)
                        }
                        .accessibilityLabel("Stop reading")
                        .accessibilityHint("Stops narration and returns the article to the start.")
                        .help("Stop reading")
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(Color(NSColor.controlBackgroundColor))
                .border(Color(NSColor.separatorColor), width: 0.5)

                // Article renderer
                if articleNotFound {
                    VStack(spacing: 12) {
                        Image(systemName: "doc.text.magnifyingglass")
                            .font(.system(size: 48))
                            .foregroundColor(.secondary)
                        Text("Article not found")
                            .font(.title3.weight(.semibold))
                        Text("The file \"\(initialFile)\" could not be located.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    NativeArticleRepresentable(coordinator: coordinator)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .navigationTitle("")
        .onAppear {
            loadInitialURL()
        }
        .onDisappear {
            speech.stop(owner: "article")
            coordinator.cleanup()
        }
    }

    private var readAloudButton: some View {
        Button(action: handleReadAloudTapped) {
            if speech.isSpeaking {
                Image(systemName: "pause.fill")
                    .font(.body)
            } else if speech.isPaused {
                Image(systemName: "play.fill")
                    .font(.body)
            } else {
                Image(systemName: "speaker.wave.2.fill")
                    .font(.body)
            }
        }
        .accessibilityLabel(speech.isSpeaking ? "Pause reading" : (speech.isPaused ? "Resume reading" : "Read article aloud"))
        .accessibilityHint(
            speech.isSpeaking
                ? "Pauses narration mid-paragraph."
                : (speech.isPaused
                    ? "Resumes narration from where it was paused."
                    : "Starts reading the article paragraph-by-paragraph. Use the previous and next buttons to step.")
        )
        .help(speech.isSpeaking ? "Pause reading" : (speech.isPaused ? "Resume reading" : "Read article aloud"))
    }

    private func handleReadAloudTapped() {
        if speech.isSpeaking {
            speech.pause()
        } else if speech.isPaused {
            speech.resume()
        } else {
            coordinator.readArticleParagraphs { paragraphs in
                guard !paragraphs.isEmpty else { return }
                speech.speakParagraphs(paragraphs, owner: "article")
            }
        }
    }

    @State private var articleNotFound = false

    private func loadInitialURL() {
        let name = initialFile.replacingOccurrences(of: ".html", with: "")
        if let url = Bundle.main.url(forResource: name, withExtension: "html", subdirectory: chapterFolder) {
            coordinator.load(fileURL: url, inFolder: chapterFolder)
        } else if let flatUrl = Bundle.main.url(forResource: name, withExtension: "html") {
            coordinator.load(fileURL: flatUrl, inFolder: chapterFolder)
        } else {
            articleNotFound = true
        }
    }
}

// MARK: - NativeArticleRepresentable

private struct NativeArticleRepresentable: NSViewRepresentable {
    let coordinator: ArticleCoordinator

    func makeNSView(context: Context) -> NSScrollView {
        let textView = NSTextView()
        textView.backgroundColor = NSColor.textBackgroundColor
        textView.drawsBackground = true
        textView.isEditable = false
        textView.isSelectable = true
        textView.allowsUndo = false
        textView.textContainerInset = NSSize(width: 28, height: 24)
        textView.textContainer?.widthTracksTextView = true
        textView.textContainer?.containerSize = NSSize(
            width: CGFloat.greatestFiniteMagnitude,
            height: CGFloat.greatestFiniteMagnitude
        )
        let scrollView = NSScrollView()
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = false
        scrollView.autohidesScrollers = true
        scrollView.documentView = textView
        scrollView.backgroundColor = NSColor.textBackgroundColor
        coordinator.attachNativeTextView(textView)
        return scrollView
    }

    func updateNSView(_ nsView: NSScrollView, context: Context) {
        coordinator.updateNativeTextView()
    }

    // Dismantle ordering — the SwiftUI ↔ AppKit pinch-point on Big Sur.
    //
    // When the sheet hosting ArticleBrowserView dismisses (⌘W) and the
    // user immediately clicks a CTA on the parent ChapterDetailView
    // (Try Discover Mode), the sheet-dismount commit and the next render
    // commit can interleave: SwiftUI tears this NSScrollView down, AppKit
    // can still send one final NSTextViewDelegate / NSLayoutManager
    // callback into a freed instance, and the parent commit pump trips on
    // the resulting over-release as objc_release.
    //
    // Defensive ordering, applied synchronously here before the NSScrollView
    // is released by SwiftUI's commit:
    //   1. nil any NSTextView delegate first so AppKit cannot route another
    //      callback (no-op in this build — we never assign one — but cheap
    //      insurance against future code adding a delegate without thinking
    //      about teardown).
    //   2. detach documentView so the NSTextView's retain count drops in a
    //      deterministic order before the SwiftUI commit unwinds.
    static func dismantleNSView(_ nsView: NSScrollView, coordinator: ()) {
        (nsView.documentView as? NSTextView)?.delegate = nil
        nsView.documentView = nil
    }
}

// MARK: - ArticleCoordinator

@MainActor
private class ArticleCoordinator: NSObject, ObservableObject
{
    @Published var canGoBack = false
    @Published var canGoForward = false
    @Published var pageTitle = ""
    @Published var currentURL: URL? = nil
    @Published private var nativeArticle = NSAttributedString(
        string: "Loading...",
        attributes: [.font: NSFont.systemFont(ofSize: NSFont.systemFontSize)]
    )
    private weak var nativeTextView: NSTextView?
    private var nativeHistory: [URL] = []
    private var nativeHistoryIndex: Int?
    /// Monotone counter so a stale background load can't overwrite a
    /// newer one. Each call to `loadNativeArticle` bumps it and captures
    /// the value; the completion only applies its result if the captured
    /// value still matches. Pre-roll: a kid mashes Forward/Back fast and
    /// the older read happens to finish last — without this gate, the
    /// older article overwrites the newer view.
    private var loadGeneration: UInt64 = 0

    func load(fileURL: URL, inFolder: String) {
        currentURL = fileURL
        loadNativeArticle(fileURL, recordingHistory: true)
    }

    func goBack() {
        guard let currentIndex = nativeHistoryIndex, currentIndex > 0 else { return }
        let previousIndex = currentIndex - 1
        nativeHistoryIndex = previousIndex
        loadNativeArticle(nativeHistory[previousIndex], recordingHistory: false)
    }

    func goForward() {
        guard let currentIndex = nativeHistoryIndex,
              currentIndex + 1 < nativeHistory.count else { return }
        let nextIndex = currentIndex + 1
        nativeHistoryIndex = nextIndex
        loadNativeArticle(nativeHistory[nextIndex], recordingHistory: false)
    }

    func reload() {
        guard let currentURL = currentURL else { return }
        loadNativeArticle(currentURL, recordingHistory: false)
    }

    func openCurrentURL() {
        guard let url = currentURL else { return }
        NSWorkspace.shared.open(url)
    }

    func readArticleText(completion: @escaping (String) -> Void) {
        completion(nativeArticle.string)
    }

    /// Split the rendered article body into paragraphs for the
    /// per-paragraph read-aloud flow. The HTML→text reducer in
    /// `PlainTextArticleFallback.stripHTML` inserts `\n\n` between
    /// block tags (headings, paragraphs, list items), so a simple
    /// double-newline split is the natural paragraph boundary.
    /// Blank/whitespace-only paragraphs are filtered out so the
    /// "¶ N / M" counter matches what the user actually hears.
    func readArticleParagraphs(completion: @escaping ([String]) -> Void) {
        let paragraphs = nativeArticle.string
            .components(separatedBy: "\n\n")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        completion(paragraphs)
    }

    func cleanup() {
        nativeTextView?.delegate = nil
        nativeTextView = nil
    }

    func attachNativeTextView(_ textView: NSTextView) {
        nativeTextView = textView
        updateNativeTextView()
    }

    func updateNativeTextView() {
        guard let textView = nativeTextView,
              !textView.attributedString().isEqual(to: nativeArticle) else {
            return
        }

        textView.textStorage?.setAttributedString(nativeArticle)
    }

    /// Loads `url` off the main thread. The synchronous version of this
    /// method blocked `@MainActor` for the duration of `String(contentsOf:)`
    /// + HTML strip; for a 50–100 KB article on the Big Sur iMac's spinning
    /// disk path that's tens to hundreds of milliseconds of jank when the
    /// Beyond-the-Book sheet opens. We now read + strip in a detached
    /// task and post the parsed result back to the main actor.
    ///
    /// Race protection: `loadGeneration` guards against the race where a
    /// fast Forward→Back→Forward cascade has three reads in flight and the
    /// oldest happens to finish last. Each call captures its generation;
    /// the apply step early-returns if a newer load has been kicked off.
    private func loadNativeArticle(_ url: URL, recordingHistory: Bool) {
        loadGeneration &+= 1
        let myGeneration = loadGeneration
        Task { [weak self] in
            let result = await Self.readParseAndExtractTitle(url: url)
            guard let self = self else { return }
            // Stale completion — a newer load() superseded this one.
            guard self.loadGeneration == myGeneration else { return }
            switch result {
            case .success(let body, let title):
                self.nativeArticle = NSAttributedString(
                    string: body,
                    attributes: [
                        .font: NSFont.systemFont(ofSize: NSFont.systemFontSize),
                        .foregroundColor: NSColor.labelColor
                    ]
                )
                self.currentURL = url
                self.pageTitle = title
                self.recordNativeHistory(for: url, shouldRecord: recordingHistory)
                self.updateNativeNavigationState()
                self.updateNativeTextView()
            case .failure(let message):
                self.pageTitle = url.deletingPathExtension().lastPathComponent
                self.nativeArticle = NSAttributedString(
                    string: "Article could not be rendered.\n\n\(message)",
                    attributes: [
                        .font: NSFont.systemFont(ofSize: NSFont.systemFontSize),
                        .foregroundColor: NSColor.labelColor
                    ]
                )
                self.updateNativeTextView()
            }
        }
    }

    /// Off-main file read + HTML strip + title extraction. Returns a
    /// Sendable result (Strings only, no NSError refs) so the value can
    /// cross the actor hop without `@unchecked Sendable` lies.
    private nonisolated static func readParseAndExtractTitle(
        url: URL
    ) async -> ArticleLoadOutcome {
        await Task.detached(priority: .userInitiated) {
            do {
                // Do not use NSAttributedString's HTML importer on Big Sur.
                // It still goes through WebKit internally and launches the
                // same WebContent subprocess this renderer exists to avoid.
                let html = try String(contentsOf: url, encoding: .utf8)
                let body = PlainTextArticleFallback.stripHTML(html)
                let title = Self.titleFromHTML(html, body: body, fallbackURL: url)
                return .success(body: body, title: title)
            } catch {
                return .failure(message: error.localizedDescription)
            }
        }.value
    }

    private func recordNativeHistory(for url: URL, shouldRecord: Bool) {
        guard shouldRecord else { return }
        if let currentIndex = nativeHistoryIndex,
           currentIndex + 1 < nativeHistory.count {
            nativeHistory.removeSubrange((currentIndex + 1)..<nativeHistory.count)
        }
        if nativeHistory.last != url {
            nativeHistory.append(url)
        }
        nativeHistoryIndex = max(nativeHistory.count - 1, 0)
    }

    private func updateNativeNavigationState() {
        let index = nativeHistoryIndex ?? 0
        canGoBack = index > 0
        canGoForward = index + 1 < nativeHistory.count
    }

    /// Pure (no instance state, no actor requirements) so it can run on
    /// the detached read hop. Promoted from instance method to `nonisolated
    /// static` as part of the off-main load refactor.
    nonisolated static func titleFromHTML(
        _ html: String,
        body: String,
        fallbackURL: URL
    ) -> String {
        if let titleRange = html.range(
            of: "<title[^>]*>(.*?)</title>",
            options: [.caseInsensitive, .regularExpression]
        ) {
            let title = PlainTextArticleFallback.stripHTML(String(html[titleRange]))
            if !title.isEmpty {
                return title
            }
        }

        let firstLine = body
            .split(separator: "\n")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .first { !$0.isEmpty }
        return firstLine.map { String($0) }
            ?? fallbackURL.deletingPathExtension().lastPathComponent
    }
}

/// Sendable carrier for the off-main article load. String payloads only —
/// keeps NSError out of the actor-hop value.
private enum ArticleLoadOutcome: Sendable {
    case success(body: String, title: String)
    case failure(message: String)
}

// MARK: - PlainTextArticleFallback
//
// Shown when WKWebView's WebContent process crashes (common on Big Sur
// with legacy AMD GPUs — the IconRendering Metal shader cache fails).
// Reads the same HTML file, strips tags with a minimal parser, and shows
// the result in a ScrollView so the kid can still read the article even
// when WebKit can't render it. Also offers an "Open in Safari" recovery.

private struct PlainTextArticleFallback: View {
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
        do {
            let raw = try String(contentsOf: url, encoding: .utf8)
            bodyText = Self.stripHTML(raw)
        } catch {
            loadError = error.localizedDescription
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
