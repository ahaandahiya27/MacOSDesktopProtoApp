import SwiftUI

struct ArticleEntryButton: View {
    let entry: ArticleEntry?
    @State private var presentedArticle: ArticleEntry?

    var body: some View {
        if let e = entry {
            Button {
                DispatchQueue.main.async {
                    presentedArticle = e
                }
            } label: {
                HStack(spacing: DesignTokens.Spacing.md) {
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
            .accessibilityHint("Opens the full article in the reader")
            .sheet(item: $presentedArticle) { article in
                // P7: pass the article title through so the read-aloud
                // button's a11y label says "Read <Title> aloud" instead
                // of the generic "Read article aloud".
                ArticleBrowserView(
                    initialFile: article.filename,
                    chapterFolder: article.chapterFolder,
                    articleTitle: article.title
                )
                .frame(minWidth: 720, idealWidth: 920,
                       minHeight: 540, idealHeight: 680)
            }
        }
    }
}
