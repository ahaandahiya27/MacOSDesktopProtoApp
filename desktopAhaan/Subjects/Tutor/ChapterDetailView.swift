import SwiftUI

/// Shows a chapter's topics in two columns. Tapping a topic drills into a
/// TopicDetailView listing concepts and questions.
struct ChapterDetailView: View {
    let pack: SubjectPack
    let chapter: Chapter

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(chapter.summary)
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 4)

                // Show the Discover Mode entry banner only on chapters that
                // have a hand-built illustrated experience.
                if DiscoverMode.hasExperience(for: pack, chapter: chapter) {
                    NavigationLink(value: TutorRoute.discover(packId: pack.id, chapterId: chapter.id)) {
                        DiscoverEntryBanner()
                    }
                    .buttonStyle(.plain)
                }

                ForEach(chapter.topics) { topic in
                    NavigationLink(value: TutorRoute.topic(packId: pack.id, topicId: topic.id)) {
                        TopicCard(topic: topic)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(20)
            .frame(maxWidth: 820, alignment: .leading)
        }
        .navigationTitle("Ch. \(chapter.number) — \(chapter.title)")
    }
}

/// Eye-catching banner that introduces Discover Mode. Shows up only on
/// chapters where `DiscoverMode.hasExperience(...)` returns true.
private struct DiscoverEntryBanner: View {
    var body: some View {
        HStack(alignment: .center, spacing: 14) {
            Text("✨")
                .font(.system(size: 38))
            VStack(alignment: .leading, spacing: 4) {
                Text("Try Discover Mode")
                    .font(.title3.bold())
                    .foregroundStyle(.white)
                Text("9 interactive scenes — animations, mini-games, and a final boss quiz.")
                    .font(.callout)
                    .foregroundStyle(.white.opacity(0.92))
            }
            Spacer()
            Image(systemName: "arrow.right.circle.fill")
                .font(.title)
                .foregroundStyle(.white.opacity(0.95))
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
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isButton)
        .accessibilityHint("Opens an illustrated, interactive learning experience for this chapter.")
    }
}

private struct TopicCard: View {
    let topic: Topic

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            VStack(alignment: .leading, spacing: 6) {
                Text(topic.title)
                    .font(.title3.bold())
                Text(topic.summary)
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .lineSpacing(3)
                HStack(spacing: 12) {
                    Label("\(topic.concepts.count) concepts", systemImage: "lightbulb")
                    Label("\(topic.questions.count) questions", systemImage: "questionmark.app")
                }
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.top, 4)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(.secondary)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.background.secondary, in: RoundedRectangle(cornerRadius: 14))
    }
}
