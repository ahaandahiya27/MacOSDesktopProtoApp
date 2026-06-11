import SwiftUI
import AppKit

struct ArticleBrowserView: View {
    let initialFile: String
    let chapterFolder: String
    /// Short label for the article (typically `ArticleEntry.title`) —
    /// used to enrich the Read-Aloud button's VoiceOver label so it
    /// announces "Read Photosynthesis aloud" instead of the generic
    /// "Read article aloud". Optional so old call sites stay clean.
    let articleTitle: String?
    @Environment(\.presentationMode) private var presentationMode
    @StateObject private var coordinator: ArticleCoordinator
    @ObservedObject private var speech = SpeechReader.shared

    init(initialFile: String, chapterFolder: String, articleTitle: String? = nil) {
        self.initialFile = initialFile
        self.chapterFolder = chapterFolder
        self.articleTitle = articleTitle
        _coordinator = StateObject(wrappedValue: ArticleCoordinator())
    }

    var body: some View {
        VStack(spacing: 0) {
                HStack(spacing: DesignTokens.Spacing.md) {
                    // Group keeps the outer HStack ≤10 direct children (Swift 5.5 @ViewBuilder cap; CLAUDE.md).
                    Group {
                        Button(action: { presentationMode.wrappedValue.dismiss() }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title3)
                        }
                        .keyboardShortcut("w", modifiers: .command)
                        .accessibilityLabel("Close article")
                        .help("Close article")

                        Button(action: { coordinator.goBack() }) {
                            Image(systemName: "chevron.left")
                                .font(.body)
                        }
                        .disabled(!coordinator.canGoBack)
                        .accessibilityLabel("Back")
                        .help("Back")

                        Button(action: { coordinator.goForward() }) {
                            Image(systemName: "chevron.right")
                                .font(.body)
                        }
                        .disabled(!coordinator.canGoForward)
                        .accessibilityLabel("Forward")
                        .help("Forward")

                        Button(action: { coordinator.reload() }) {
                            Image(systemName: "arrow.clockwise")
                                .font(.body)
                        }
                        .accessibilityLabel("Reload")
                        .help("Reload")

                        Button(action: { coordinator.openCurrentURL() }) {
                            Image(systemName: "safari")
                                .font(.body)
                        }
                        .accessibilityLabel("Open in Safari")
                        .help("Open in Safari")
                    }
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
                    VStack(spacing: DesignTokens.Spacing.md) {
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
                        // Surface narration progress as a VoiceOver
                        // value on the article host. While narration is
                        // active the rotor announces "Reading paragraph
                        // 3 of 14" without the user having to navigate
                        // to the toolbar's `¶ N / M` indicator.
                        .accessibilityElement(children: .contain)
                        .accessibilityLabel(articleTitle.map { "Article: \($0)" } ?? "Article")
                        .accessibilityValue(
                            speech.isParagraphMode
                                ? "Reading paragraph \(speech.paragraphIndex + 1) of \(speech.paragraphCount)"
                                : ""
                        )
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
        // Visual sync: highlight the paragraph currently being read aloud
        // and scroll it into view. Driven by SpeechReader.paragraphIndex
        // (which advances per-utterance via the didFinish delegate).
        .onChange(of: speech.paragraphIndex) { newIndex in
            guard speech.isParagraphMode else { return }
            coordinator.highlightParagraph(at: newIndex)
        }
        // When paragraph mode ends (stop, last paragraph finished, or
        // article changed mid-narration) drop the highlight.
        .onChange(of: speech.isParagraphMode) { isActive in
            if isActive {
                // Mode just started — highlight the starting paragraph
                // (usually 0) so the first utterance has visual sync
                // from frame one, not after the first didFinish.
                coordinator.highlightParagraph(at: speech.paragraphIndex)
            } else {
                coordinator.clearHighlight()
            }
        }
    }

    private var readAloudButton: some View {
        // Build a chapter-aware label so VoiceOver users hear the
        // article context instead of the generic "Read article aloud".
        let readAloudLabel: String = {
            if let t = articleTitle, !t.isEmpty {
                return "Read \(t) aloud"
            }
            return "Read article aloud"
        }()
        return Button(action: { handleReadAloudTapped() }) {
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
        .accessibilityLabel(speech.isSpeaking ? "Pause reading" : (speech.isPaused ? "Resume reading" : readAloudLabel))
        .accessibilityHint(
            speech.isSpeaking
                ? "Pauses narration mid-paragraph."
                : (speech.isPaused
                    ? "Resumes narration from where it was paused."
                    : "Starts reading paragraph-by-paragraph. Use the previous and next buttons to step.")
        )
        .help(speech.isSpeaking ? "Pause reading" : (speech.isPaused ? "Resume reading" : readAloudLabel))
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

// MARK: - ArticleCoordinator

@MainActor
class ArticleCoordinator: NSObject, ObservableObject, NSTextViewDelegate {
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

    /// NSRanges of the current article body's paragraphs in the same
    /// order — and with the same empty-paragraph filter — as
    /// `readArticleParagraphs`. Used by `highlightParagraph(at:)` to
    /// sync the visual highlight with `SpeechReader.paragraphIndex`.
    /// Rebuilt on every successful load.
    private var paragraphRanges: [NSRange] = []
    /// Index of the currently-highlighted paragraph, or nil if no
    /// highlight is on screen. Tracked so the next highlight call can
    /// remove the previous one without re-scanning the whole storage.
    private var currentHighlightedParagraphIndex: Int?

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
        // Bundled article files only — defense-in-depth vs. exfiltrating a remote URL.
        guard let url = currentURL, url.isFileURL, url.path.hasPrefix(Bundle.main.bundlePath) else { return }
        // NSWorkspace.open returns false when Launch Services can't resolve
        // the URL (corrupt bundle, missing default browser, sandbox path
        // denial). Log the failure so it appears in the parent-facing
        // crashlog rather than silently disappearing. The 2026-06-05 audit
        // caught this swallow.
        if !NSWorkspace.shared.open(url) {
            CrashReporter.shared.logDataIssue(
                "NSWorkspace.open returned false for bundled article URL: \(url.lastPathComponent)"
            )
        }
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
        // Relative-href routing — see +LinkRouting.swift.
        textView.delegate = self
        updateNativeTextView()
    }

    func updateNativeTextView() {
        guard let textView = nativeTextView,
              !textView.attributedString().isEqual(to: nativeArticle) else {
            return
        }

        textView.textStorage?.setAttributedString(nativeArticle)
        // After the storage is replaced the previous highlight (if any)
        // is gone with it; reset the tracked index so the next
        // highlightParagraph call doesn't try to clear a stale range.
        currentHighlightedParagraphIndex = nil
    }

    /// Recompute `paragraphRanges` from the current `nativeArticle`.
    /// Must match the same split + filter as `readArticleParagraphs`
    /// so SpeechReader's `paragraphIndex` (which indexes into the
    /// filtered list) lines up with these NSRanges 1:1.
    private func recomputeParagraphRanges() {
        var ranges: [NSRange] = []
        let full = nativeArticle.string as NSString
        let separator = "\n\n"
        var searchStart = 0
        let total = full.length
        while searchStart <= total {
            let remaining = NSRange(location: searchStart, length: total - searchStart)
            let sepRange = full.range(of: separator, options: [], range: remaining)
            let paragraphEnd = sepRange.location == NSNotFound ? total : sepRange.location
            let paragraphRange = NSRange(location: searchStart, length: paragraphEnd - searchStart)
            let candidate = full.substring(with: paragraphRange)
                .trimmingCharacters(in: .whitespacesAndNewlines)
            if !candidate.isEmpty {
                ranges.append(paragraphRange)
            }
            if sepRange.location == NSNotFound {
                break
            }
            searchStart = sepRange.location + sepRange.length
        }
        paragraphRanges = ranges
    }

    /// Highlight paragraph `idx` with a yellow tint and scroll it
    /// into view. Called by the parent `ArticleBrowserView` from
    /// `.onChange(of: speech.paragraphIndex)` so the visual sync is
    /// driven by SpeechReader's playback state.
    func highlightParagraph(at idx: Int) {
        guard idx >= 0, idx < paragraphRanges.count,
              let textView = nativeTextView,
              let storage = textView.textStorage else {
            return
        }
        storage.beginEditing()
        if let prev = currentHighlightedParagraphIndex,
           prev >= 0, prev < paragraphRanges.count {
            storage.removeAttribute(.backgroundColor, range: paragraphRanges[prev])
        }
        let range = paragraphRanges[idx]
        storage.addAttribute(
            .backgroundColor,
            value: NSColor.systemYellow.withAlphaComponent(0.25),
            range: range
        )
        storage.endEditing()
        currentHighlightedParagraphIndex = idx
        // scrollRangeToVisible is instantaneous on NSTextView (not an
        // animated scroll) so no Reduce-Motion concern.
        textView.scrollRangeToVisible(range)
    }

    /// Remove any active highlight. Called when speech stops or
    /// paragraph mode ends.
    func clearHighlight() {
        guard let textView = nativeTextView,
              let storage = textView.textStorage else { return }
        if let prev = currentHighlightedParagraphIndex,
           prev >= 0, prev < paragraphRanges.count {
            storage.beginEditing()
            storage.removeAttribute(.backgroundColor, range: paragraphRanges[prev])
            storage.endEditing()
        }
        currentHighlightedParagraphIndex = nil
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
            case .success(_, let title, let blocks):
                // E4 — drop the body's first <h1> only if it matches
                // the chrome title (case + whitespace insensitive).
                let trimmed = ArticleStructuredRenderer
                    .deduplicateHeroHeading(blocks, matching: title)
                self.nativeArticle = ArticleStructuredRenderer
                    .makeRichAttributedString(from: trimmed)
                self.currentURL = url
                self.pageTitle = title
                self.recordNativeHistory(for: url, shouldRecord: recordingHistory)
                self.updateNativeNavigationState()
                self.updateNativeTextView()
                self.recomputeParagraphRanges()
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
                self.paragraphRanges = []
            }
        }
    }

    /// Off-main file read + HTML strip + structured-block parse +
    /// title extraction. Returns a Sendable carrier (String body +
    /// String title + `[ArticleBlock]` value-type list) so the value
    /// crosses the actor hop without `@unchecked Sendable` lies.
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
                let blocks = ArticleStructuredRenderer.parseBlocks(html)
                return .success(body: body, title: title, blocks: blocks)
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

/// Sendable carrier for the off-main article load. Strings + an
/// `[ArticleBlock]` value-type tree — keeps NSError + AppKit types
/// out of the actor-hop value.
private enum ArticleLoadOutcome: Sendable {
    case success(body: String, title: String, blocks: [ArticleBlock])
    case failure(message: String)
}
// PlainTextArticleFallback lives in ArticleBrowserView+PlainTextFallback.swift
