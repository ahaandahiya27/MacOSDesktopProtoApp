import SwiftUI
import WebKit
import AppKit
import Combine

struct ArticleBrowserView: View {
    let initialFile: String
    let chapterFolder: String
    let isWindow: Bool
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.colorScheme) private var colorScheme
    @StateObject private var coordinator: WebViewCoordinator
    @ObservedObject private var speech = SpeechReader.shared

    init(initialFile: String, chapterFolder: String, isWindow: Bool = false) {
        self.initialFile = initialFile
        self.chapterFolder = chapterFolder
        self.isWindow = isWindow
        _coordinator = StateObject(wrappedValue: WebViewCoordinator())
    }

    var body: some View {
        VStack(spacing: 0) {
                // Toolbar with controls
                HStack(spacing: 12) {
                    Button(action: {
                        if isWindow { NSApp.keyWindow?.close() }
                        else { presentationMode.wrappedValue.dismiss() }
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title3)
                    }
                    .keyboardShortcut("w", modifiers: .command)
                    .accessibilityLabel("Close article")
                    .help("Close article")

                    Button(action: { coordinator.webView.goBack() }) {
                        Image(systemName: "chevron.left")
                            .font(.body)
                    }
                    .disabled(!coordinator.canGoBack)
                    .accessibilityLabel("Back")
                    .help("Back")

                    Button(action: { coordinator.webView.goForward() }) {
                        Image(systemName: "chevron.right")
                            .font(.body)
                    }
                    .disabled(!coordinator.canGoForward)
                    .accessibilityLabel("Forward")
                    .help("Forward")

                    Button(action: { coordinator.webView.reload() }) {
                        Image(systemName: "arrow.clockwise")
                            .font(.body)
                    }
                    .accessibilityLabel("Reload")
                    .help("Reload")

                    Button(action: {
                        if let url = coordinator.webView.url {
                            NSWorkspace.shared.open(url)
                        }
                    }) {
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

                    // Read aloud button
                    readAloudButton

                    // Stop button (shown only when speaking/paused)
                    if speech.isSpeaking || speech.isPaused {
                        Button(action: { speech.stop(owner: "article") }) {
                            Image(systemName: "stop.fill")
                                .font(.body)
                        }
                        .accessibilityLabel("Stop reading")
                        .help("Stop reading")
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(Color(NSColor.controlBackgroundColor))
                .border(Color(NSColor.separatorColor), width: 0.5)

                // Web view
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
                } else if coordinator.loadFailed {
                    PlainTextArticleFallback(
                        url: coordinator.currentURL,
                        errorMessage: coordinator.lastError
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    WebViewRepresentable(coordinator: coordinator)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .navigationTitle("")
        .onAppear {
            loadInitialURL()
        }
        .onDisappear {
            speech.stop(owner: "article")
            // Defensive: stop any in-flight WKWebView load and clear
            // delegates BEFORE the SwiftUI @StateObject tears down the
            // coordinator. Without this, a pending WebContent-subprocess
            // callback (Big Sur AMD GPU is famously flaky here) can fire
            // into a half-released coordinator → EXC_BAD_ACCESS in
            // objc_release. cleanup() is idempotent.
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
        .help(speech.isSpeaking ? "Pause reading" : (speech.isPaused ? "Resume reading" : "Read article aloud"))
    }

    private func handleReadAloudTapped() {
        if speech.isSpeaking {
            speech.pause()
        } else if speech.isPaused {
            speech.resume()
        } else {
            // Extract article text from web view
            coordinator.webView.evaluateJavaScript(
                "document.querySelector('article')?.innerText || document.body.innerText"
            ) { result, _ in
                if let text = result as? String {
                    speech.speak(text, owner: "article")
                }
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

// MARK: - WebViewRepresentable

private struct WebViewRepresentable: NSViewRepresentable {
    typealias NSViewType = WKWebView
    let coordinator: WebViewCoordinator

    func makeNSView(context: Context) -> WKWebView {
        let webView = coordinator.webView
        coordinator.setupWebView()
        return webView
    }

    func updateNSView(_ nsView: WKWebView, context: Context) {}
}

// MARK: - WebViewCoordinator

@MainActor
private class WebViewCoordinator: NSObject, ObservableObject, WKNavigationDelegate,
    WKUIDelegate
{
    let webView = WKWebView()
    @Published var canGoBack = false
    @Published var canGoForward = false
    @Published var pageTitle = ""
    /// Flips to true when the WKWebView WebContent process terminates or a
    /// navigation fails. On older Macs (Big Sur + legacy GPU) the WebContent
    /// process can crash while loading local file://, leaving us with a
    /// blank, non-recoverable view. Parent view swaps to a plain-text
    /// fallback when this is true.
    @Published var loadFailed: Bool = false
    @Published var lastError: String? = nil
    /// The currently-loading file URL, snapshotted so the fallback view
    /// can render the same article without going through WKWebView.
    @Published var currentURL: URL? = nil
    private var currentFolder: String?
    private var observers: [NSKeyValueObservation] = []

    nonisolated override init() {
        super.init()
        Task { @MainActor [weak self] in
            self?.setupObservers()
        }
    }

    func setupWebView() {
        // Apply legacy-API JS disable. The per-navigation
        // `decidePolicyFor:preferences:` delegate below also enforces this,
        // so even on macOS versions where the legacy key is ignored we
        // still keep in-page JavaScript off.
        webView.configuration.preferences.javaScriptCanOpenWindowsAutomatically = false

        if webView.navigationDelegate == nil {
            webView.navigationDelegate = self
            webView.uiDelegate = self
        }
    }

    func load(fileURL: URL, inFolder: String) {
        currentFolder = inFolder
        currentURL = fileURL
        // Clear any previous error state when starting a new load.
        loadFailed = false
        lastError = nil
        let accessURL = Bundle.main.resourceURL ?? fileURL.deletingLastPathComponent()
        webView.loadFileURL(fileURL, allowingReadAccessTo: accessURL)
    }

    // MARK: - Failure handlers

    /// WKWebView's WebContent subprocess died (Metal/IconRendering shader
    /// issues on Big Sur AMD R9 M290X, sandbox lookup failures, etc).
    /// SwiftUI keeps the WKWebView alive but it'll never render again, so
    /// flip the fallback flag.
    nonisolated func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        Task { @MainActor [weak self] in
            self?.loadFailed = true
            self?.lastError = "Web renderer terminated unexpectedly."
        }
    }

    nonisolated func webView(_ webView: WKWebView,
                             didFail navigation: WKNavigation!,
                             withError error: Error) {
        let msg = error.localizedDescription
        Task { @MainActor [weak self] in
            self?.loadFailed = true
            self?.lastError = msg
        }
    }

    nonisolated func webView(_ webView: WKWebView,
                             didFailProvisionalNavigation navigation: WKNavigation!,
                             withError error: Error) {
        let msg = error.localizedDescription
        Task { @MainActor [weak self] in
            self?.loadFailed = true
            self?.lastError = msg
        }
    }

    func setupObservers() {
        let backObserver = webView.observe(
            \.canGoBack,
            options: [.new],
            changeHandler: { [weak self] _, change in
                let newValue = change.newValue ?? false
                DispatchQueue.main.async { [weak self] in
                    self?.canGoBack = newValue
                }
            }
        )
        let forwardObserver = webView.observe(
            \.canGoForward,
            options: [.new],
            changeHandler: { [weak self] _, change in
                let newValue = change.newValue ?? false
                DispatchQueue.main.async { [weak self] in
                    self?.canGoForward = newValue
                }
            }
        )
        let titleObserver = webView.observe(
            \.title,
            options: [.new],
            changeHandler: { [weak self] _, change in
                let newValue = (change.newValue ?? nil) ?? ""
                DispatchQueue.main.async { [weak self] in
                    self?.pageTitle = newValue
                }
            }
        )
        observers = [backObserver, forwardObserver, titleObserver]
    }

    func cleanup() {
        // Order matters: stop loading FIRST so no new KVO callbacks queue,
        // THEN invalidate each observer (NSKeyValueObservation.invalidate()
        // synchronously removes the observation — safer than relying on the
        // array dealloc), THEN clear delegates so any already-in-flight
        // delegate callbacks find a nil target and no-op.
        webView.stopLoading()
        for obs in observers { obs.invalidate() }
        observers.removeAll()
        webView.navigationDelegate = nil
        webView.uiDelegate = nil
    }

    // No explicit deinit: WebViewCoordinator is @MainActor, which makes
    // deinit nonisolated, which means we can't safely touch the
    // @MainActor-isolated webView from here on Swift 5.5 (no
    // MainActor.assumeIsolated until 5.10). cleanup() in .onDisappear
    // is the cleanup path; releasing the WKWebView naturally kills
    // its WebContent subprocess.

    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        guard let url = navigationAction.request.url else {
            decisionHandler(.allow)
            return
        }

        if url.scheme == "file" {
            if isURLSafe(url) {
                let newFolder = url.deletingLastPathComponent().path
                if newFolder != currentFolder {
                    SpeechReader.shared.stop(owner: "article")
                }
                decisionHandler(.allow)
                return
            } else {
                decisionHandler(.cancel)
                return
            }
        }

        if url.scheme == "http" || url.scheme == "https" {
            decisionHandler(.cancel)
            NSWorkspace.shared.open(url)
            return
        }

        decisionHandler(.allow)
    }

    /// Per-navigation preferences hook. Disables in-page JavaScript for
    /// every load. The host app's `evaluateJavaScript` calls (used by Read
    /// Aloud to extract article text) are unaffected — that gate is for
    /// JS authored INSIDE the bundled HTML, which we never need. Bundled
    /// articles are hand-authored, so this is purely defence in depth in
    /// case a future content pack ever ships an inline `<script>`.
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        preferences: WKWebpagePreferences,
        decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void
    ) {
        preferences.allowsContentJavaScript = false

        guard let url = navigationAction.request.url else {
            decisionHandler(.allow, preferences)
            return
        }
        if url.scheme == "file" {
            if isURLSafe(url) {
                let newFolder = url.deletingLastPathComponent().path
                if newFolder != currentFolder {
                    SpeechReader.shared.stop(owner: "article")
                }
                decisionHandler(.allow, preferences)
            } else {
                decisionHandler(.cancel, preferences)
            }
            return
        }
        if url.scheme == "http" || url.scheme == "https" {
            decisionHandler(.cancel, preferences)
            NSWorkspace.shared.open(url)
            return
        }
        decisionHandler(.allow, preferences)
    }

    private func isURLSafe(_ url: URL) -> Bool {
        guard let resourcePath = Bundle.main.resourcePath else { return true }
        let canonicalUrl = (url.path as NSString).expandingTildeInPath
        let canonicalResources = (resourcePath as NSString).expandingTildeInPath

        // Files may live in a subdirectory or flat in the bundle root.
        // Allow any file inside the app's Resources directory.
        return canonicalUrl.hasPrefix(canonicalResources)
    }
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
    static func stripHTML(_ html: String) -> String {
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
