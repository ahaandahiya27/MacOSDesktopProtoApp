import SwiftUI
import AppKit

struct ChapterListView: View {
    let pack: SubjectPack
    @EnvironmentObject private var nav: TutorNavigationState

    var body: some View {
        Group {
            if pack.chapters.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "book.closed")
                        .font(.system(size: 48))
                        .foregroundColor(.secondary)
                    Text("No chapters available")
                        .font(.title2.weight(.semibold))
                    Text("This subject pack doesn't have any chapters yet.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(pack.chapters) { chapter in
                    Button {
                        nav.push(.chapter(packId: pack.id, chapterId: chapter.id))
                    } label: {
                        ChapterRow(chapter: chapter)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .contextMenu {
                        Button("Open") { nav.push(.chapter(packId: pack.id, chapterId: chapter.id)) }
                        Button("Copy title") {
                            NSPasteboard.general.clearContents()
                            NSPasteboard.general.setString(chapter.title, forType: .string)
                        }
                        if DiscoverMode.hasExperience(for: pack, chapter: chapter) {
                            Divider()
                            Button("Start Discover Mode") {
                                nav.push(.discover(packId: pack.id, chapterId: chapter.id))
                            }
                        }
                    }
                }
                .listStyle(.inset)
            }
        }
        .background(Color(NSColor.windowBackgroundColor))
        .navigationTitle(pack.title)
    }
}

private struct ChapterRow: View {
    let chapter: Chapter

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            ZStack {
                Circle()
                    .fill(Color.compatIndigo.opacity(0.15))
                    .frame(width: 44, height: 44)
                Text("\(chapter.number)")
                    .font(.headline)
                    .foregroundColor(Color.compatIndigo)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(chapter.title)
                    .font(.headline)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                Text(chapter.summary)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                HStack(spacing: 12) {
                    Label("\(chapter.topics.count) topics", systemImage: "list.bullet")
                    Label("\(chapter.topics.reduce(0) { $0 + $1.concepts.count }) concepts",
                          systemImage: "lightbulb")
                    Label("\(chapter.topics.reduce(0) { $0 + $1.questions.count }) questions",
                          systemImage: "questionmark.app")
                }
                .font(.caption2)
                .foregroundColor(.secondary)
                .padding(.top, 2)
            }
        }
        .padding(.vertical, 4)
    }
}
