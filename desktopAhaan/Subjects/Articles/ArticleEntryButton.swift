import SwiftUI
import AppKit

final class ArticleWindowManager: NSObject, NSWindowDelegate {
    static let shared = ArticleWindowManager()
    private var windows: [NSWindow] = []

    func openArticle(filename: String, chapterFolder: String) {
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
        if let window = notification.object as? NSWindow {
            windows.removeAll { $0 === window }
        }
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
