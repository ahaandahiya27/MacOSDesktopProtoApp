import SwiftUI
import WebKit
import AppKit
import Combine

struct ArticleBrowserView: View {
    let initialFile: String
    let chapterFolder: String
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @StateObject private var coordinator: WebViewCoordinator
    @ObservedObject private var speech = SpeechReader.shared

    init(initialFile: String, chapterFolder: String) {
        self.initialFile = initialFile
        self.chapterFolder = chapterFolder
        _coordinator = StateObject(wrappedValue: WebViewCoordinator())
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Toolbar with controls
                HStack(spacing: 12) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title3)
                    }
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

                    Spacer()

                    Text(coordinator.pageTitle)
                        .font(.body)
                        .lineLimit(1)
                        .frame(maxWidth: 300)

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
                .background(Color(nsColor: .controlBackgroundColor))
                .border(Color(nsColor: .separatorColor), width: 0.5)

                // Web view
                WebViewRepresentable(coordinator: coordinator)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .navigationTitle("")
        }
        .onAppear {
            loadInitialURL()
        }
        .onDisappear {
            speech.stop(owner: "article")
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

    private func loadInitialURL() {
        guard let url = Bundle.main.url(
            forResource: initialFile.replacingOccurrences(of: ".html", with: ""),
            withExtension: "html",
            subdirectory: chapterFolder
        ) else {
            if let flatUrl = Bundle.main.url(
                forResource: initialFile.replacingOccurrences(of: ".html", with: ""),
                withExtension: "html"
            ) {
                coordinator.load(fileURL: flatUrl, inFolder: chapterFolder)
            }
            return
        }
        coordinator.load(fileURL: url, inFolder: chapterFolder)
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
    private var currentFolder: String?
    private var observers: [NSKeyValueObservation] = []

    override init() {
        super.init()
        setupObservers()
    }

    func setupWebView() {
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true

        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = preferences
        config.mediaTypesRequiringUserActionForPlayback = []

        if webView.navigationDelegate == nil {
            webView.navigationDelegate = self
            webView.uiDelegate = self
        }
    }

    func load(fileURL: URL, inFolder: String) {
        currentFolder = inFolder
        webView.loadFileURL(fileURL, allowingReadAccessTo: fileURL.deletingLastPathComponent())
    }

    func setupObservers() {
        let backObserver = webView.observe(
            \.canGoBack,
            options: [.new],
            changeHandler: { [weak self] _, _ in
                Task { @MainActor [weak self] in
                    self?.canGoBack = self?.webView.canGoBack ?? false
                }
            }
        )
        let forwardObserver = webView.observe(
            \.canGoForward,
            options: [.new],
            changeHandler: { [weak self] _, _ in
                Task { @MainActor [weak self] in
                    self?.canGoForward = self?.webView.canGoForward ?? false
                }
            }
        )
        let titleObserver = webView.observe(
            \.title,
            options: [.new],
            changeHandler: { [weak self] _, _ in
                Task { @MainActor [weak self] in
                    self?.pageTitle = self?.webView.title ?? ""
                }
            }
        )
        observers = [backObserver, forwardObserver, titleObserver]
    }

    func cleanup() {
        observers.removeAll()
        webView.navigationDelegate = nil
        webView.uiDelegate = nil
    }

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
                // Non-trivial file navigation: stop reading
                SpeechReader.shared.stop(owner: "article")
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

    private func isURLSafe(_ url: URL) -> Bool {
        guard let resourcePath = Bundle.main.resourcePath else { return true }
        let canonicalUrl = (url.path as NSString).expandingTildeInPath
        let canonicalResources = (resourcePath as NSString).expandingTildeInPath

        // Files may live in a subdirectory or flat in the bundle root.
        // Allow any file inside the app's Resources directory.
        return canonicalUrl.hasPrefix(canonicalResources)
    }
}
