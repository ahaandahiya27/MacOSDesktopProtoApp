import SwiftUI
import AppKit
import os.log

final class ArticleWindowManager: NSObject, NSWindowDelegate {
    static let shared = ArticleWindowManager()
    private var windows: [NSWindow] = []

    /// Cap on the simultaneously-open article windows. Picked so that
    /// even an enthusiastic student opening every Beyond-the-Book entry
    /// across multiple chapters can't grow the array without bound.
    /// State restoration after a crash could otherwise replay every
    /// previously-open window and pile up indefinitely.
    private static let maxOpenWindows = 8

    /// Logger used for FIFO-eviction telemetry. Survives across launches
    /// in Console.app under subsystem "com.emoha.desktopAhaan".
    private static let logger = Logger(subsystem: "com.emoha.desktopAhaan",
                                       category: "ArticleWindowManager")

    func openArticle(filename: String, chapterFolder: String) {
        // FIFO eviction: if at cap, close the oldest window first. We
        // call close() rather than just removing from the array so the
        // NSHostingView → @StateObject coordinator chain ALSO releases
        // (cleanup() runs in onDisappear inside ArticleBrowserView), not
        // just our reference to the NSWindow. Without the close() call
        // the window stays on-screen but unreferenced — visible ghost.
        if windows.count >= Self.maxOpenWindows, let oldest = windows.first {
            Self.logger.info("FIFO eviction at cap=\(Self.maxOpenWindows, privacy: .public): closing oldest article window")
            oldest.close()  // delegate fires windowWillClose → removes from array
        }

        let browserView = ArticleBrowserView(
            initialFile: filename,
            chapterFolder: chapterFolder,
            isWindow: true
        )
        let hostingView = NSHostingView(rootView: browserView)

        let screen = NSScreen.main?.visibleFrame
            ?? NSRect(x: 0, y: 0, width: 1440, height: 900)
        let targetW = max(820, screen.width * 0.8)
        let targetH = max(640, screen.height * 0.8)
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: targetW, height: targetH),
            styleMask: [.titled, .closable, .resizable, .miniaturizable],
            backing: .buffered,
            defer: false
        )
        window.contentView = hostingView
        window.title = "Article"
        window.minSize = NSSize(width: 720, height: 540)
        window.center()
        window.delegate = self

        windows.append(window)
        window.makeKeyAndOrderFront(nil)
    }

    func windowWillClose(_ notification: Notification) {
        guard let window = notification.object as? NSWindow else { return }
        // Force the NSHostingView to release its rootView NOW, not on the
        // next runloop. The Big Sur WKWebView WebContent subprocess often
        // dies with XPC_ERROR_CONNECTION_INVALID (Metal/IconRendering
        // shader-archive load fails on AMD R9 M290X) → its parent
        // ArticleBrowserView still holds a coordinator pointing at a
        // zombie WKWebView. If we just remove the NSWindow from our
        // array, the SwiftUI .onDisappear (which calls
        // `coordinator.cleanup()`) doesn't fire until the next render
        // tick — and during that tick, ANY subsequent SwiftUI work on
        // the parent (e.g. the user clicks Try Discover Mode) inherits
        // a stale subscription graph → "Entangling fence requested
        // after pre-commit" → EXC_BAD_ACCESS in objc_release.
        //
        // Setting `contentView = nil` triggers NSHostingView dealloc
        // synchronously, which runs the SwiftUI .onDisappear chain
        // before this delegate method returns. The coordinator's
        // cleanup() (stopLoading + invalidate observers + clear
        // delegates) runs before the WKWebView's WebContent subprocess
        // can fire any more callbacks. Net effect: no zombie residue
        // on the next render.
        window.contentView = nil
        // window.delegate = nil — prevents AppKit from sending a second
        // round of delegate callbacks during teardown.
        window.delegate = nil
        windows.removeAll { $0 === window }
    }
}

struct ArticleEntryButton: View {
    let entry: ArticleEntry?

    var body: some View {
        if let e = entry {
            Button {
                ArticleWindowManager.shared.openArticle(
                    filename: e.filename,
                    chapterFolder: e.chapterFolder
                )
            } label: {
                HStack(spacing: 12) {
                    Image(systemName: "book.closed.fill")
                        .font(.title3)

                    VStack(alignment: .leading, spacing: 3) {
                        Text("Read the full article")
                            .font(.headline)
                        Text("≈ \(e.estimatedMinutes) min · \(e.title)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }

                    Spacer()
                }
                .padding(14)
                .frame(maxWidth: 560)
                .foregroundColor(.white)
            }
            .accentColor(Color.compatIndigo)
        }
    }
}
