import SwiftUI
import AppKit

struct ChapterDetailView: View {
    let pack: SubjectPack
    let chapter: Chapter

    @EnvironmentObject private var nav: TutorNavigationState

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(chapter.summary)
                    .font(.callout)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 4)

                if DiscoverMode.hasExperience(for: pack, chapter: chapter) {
                    Button {
                        nav.push(.discover(packId: pack.id, chapterId: chapter.id))
                    } label: {
                        DiscoverEntryBanner()
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }

                ForEach(chapter.topics) { topic in
                    Button {
                        nav.push(.topic(packId: pack.id, topicId: topic.id))
                    } label: {
                        TopicCard(topic: topic)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .contextMenu {
                        Button("Open") { nav.push(.topic(packId: pack.id, topicId: topic.id)) }
                        Button("Copy title") {
                            NSPasteboard.general.clearContents()
                            NSPasteboard.general.setString(topic.title, forType: .string)
                        }
                    }
                }
            }
            .padding(20)
            .frame(maxWidth: 820, alignment: .leading)
        }
        .background(Color(NSColor.windowBackgroundColor))
        .navigationTitle("Ch. \(chapter.number) — \(chapter.title)")
    }

}

private struct DiscoverEntryBanner: View {
    @State private var isHovered = false

    var body: some View {
        HStack(alignment: .center, spacing: 14) {
            Text("✨")
                .font(.system(size: 38))
            VStack(alignment: .leading, spacing: 4) {
                Text("Try Discover Mode")
                    .font(.title3.bold())
                    .foregroundColor(.white)
                Text("9 interactive scenes — animations, mini-games, and a final boss quiz.")
                    .font(.callout)
                    .foregroundColor(.white.opacity(0.92))
            }
            Spacer()
            Image(systemName: "arrow.right.circle.fill")
                .font(.title)
                .foregroundColor(.white.opacity(0.95))
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.30, green: 0.65, blue: 0.45),
                            Color(red: 0.20, green: 0.45, blue: 0.75)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: .black.opacity(0.18), radius: 12, x: 0, y: 6)
        )
        .scaleEffect(isHovered ? 1.01 : 1.0)
        .onHover { hovering in isHovered = hovering }
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isButton)
        .accessibilityHint("Opens an illustrated, interactive learning experience for this chapter.")
    }
}

private struct TopicCard: View {
    let topic: Topic
    @State private var isHovered = false

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            VStack(alignment: .leading, spacing: 6) {
                Text(topic.title)
                    .font(.title3.bold())
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                Text(topic.summary)
                    .font(.callout)
                    .foregroundColor(.secondary)
                    .lineSpacing(3)
                HStack(spacing: 12) {
                    Label("\(topic.concepts.count) concepts", systemImage: "lightbulb")
                    Label("\(topic.questions.count) questions", systemImage: "questionmark.app")
                }
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.top, 4)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(isHovered ? Color.gray.opacity(0.18) : Color.gray.opacity(0.1))
        )
        .onHover { hovering in isHovered = hovering }
    }
}
