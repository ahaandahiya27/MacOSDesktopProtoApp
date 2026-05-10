import SwiftUI

struct ArticleEntryButton: View {
    let entry: ArticleEntry?
    @State private var showSheet = false

    var body: some View {
        if let e = entry {
            Button {
                showSheet = true
            } label: {
                HStack(spacing: 12) {
                    Image(systemName: "book.closed.fill")
                        .font(.title3)
                        .symbolRenderingMode(.hierarchical)

                    VStack(alignment: .leading, spacing: 3) {
                        Text("Read the full article")
                            .font(.headline)
                        Text("≈ \(e.estimatedMinutes) min · \(e.title)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }

                    Spacer()
                }
                .padding(14)
                .frame(maxWidth: 560)
                .foregroundStyle(.white)
            }
            .buttonStyle(.borderedProminent)
            .tint(.indigo)
            .sheet(isPresented: $showSheet) {
                ArticleBrowserView(
                    initialFile: e.filename,
                    chapterFolder: e.chapterFolder
                )
                .frame(minWidth: 820, idealWidth: 1000, minHeight: 650, idealHeight: 800)
            }
        }
    }
}
