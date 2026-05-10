import SwiftUI

/// Lists every chapter in a SubjectPack.
struct ChapterListView: View {
    let pack: SubjectPack

    var body: some View {
        List(pack.chapters) { chapter in
            NavigationLink(value: TutorRoute.chapter(packId: pack.id, chapterId: chapter.id)) {
                ChapterRow(chapter: chapter)
            }
        }
        .listStyle(.inset)
        .navigationTitle(pack.title)
    }
}

private struct ChapterRow: View {
    let chapter: Chapter

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            ZStack {
                Circle()
                    .fill(.indigo.opacity(0.15))
                    .frame(width: 44, height: 44)
                Text("\(chapter.number)")
                    .font(.headline)
                    .foregroundStyle(.indigo)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(chapter.title)
                    .font(.headline)
                Text(chapter.summary)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                HStack(spacing: 12) {
                    Label("\(chapter.topics.count) topics", systemImage: "list.bullet")
                    Label("\(chapter.topics.reduce(0) { $0 + $1.concepts.count }) concepts",
                          systemImage: "lightbulb")
                    Label("\(chapter.topics.reduce(0) { $0 + $1.questions.count }) questions",
                          systemImage: "questionmark.app")
                }
                .font(.caption2)
                .foregroundStyle(.secondary)
                .padding(.top, 2)
            }
        }
        .padding(.vertical, 4)
    }
}
