import SwiftUI
import AppKit

struct ChapterListView: View {
    let pack: SubjectPack
    @EnvironmentObject private var nav: TutorNavigationState
    @EnvironmentObject private var dataStore: DataStore

    /// Most-recently-completed Discover scene across the pack, used to power
    /// the "Continue where you left off" card. Nil if the kid hasn't touched
    /// Discover Mode yet.
    private var mostRecent: (Chapter, DiscoverProgress)? {
        let rows = dataStore.discoverProgress
            .filter { row in pack.chapters.contains(where: { $0.id == row.chapterId }) }
            .sorted { $0.completedAt > $1.completedAt }
        guard let top = rows.first,
              let chapter = pack.chapters.first(where: { $0.id == top.chapterId })
        else { return nil }
        return (chapter, top)
    }

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
                List {
                    if let (chapter, _) = mostRecent {
                        Section {
                            Button {
                                nav.push(.discover(packId: pack.id, chapterId: chapter.id))
                            } label: {
                                ContinueCard(chapter: chapter)
                                    .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)
                            .pointingCursor()
                        }
                        .listRowBackground(Color.clear)
                    }

                    Section(header: mostRecent != nil ? Text("All chapters") : nil) {
                        ForEach(pack.chapters) { chapter in
                            Button {
                                nav.push(.chapter(packId: pack.id, chapterId: chapter.id))
                            } label: {
                                ChapterRow(chapter: chapter)
                                    .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)
                            .pointingCursor()
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
                          systemImage: "questionmark.circle")
                }
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.top, 2)
            }
        }
        .padding(.vertical, 4)
    }
}

/// Highlights the most recently completed Discover chapter so the kid can
/// jump straight back in without scrolling the chapter list.
private struct ContinueCard: View {
    let chapter: Chapter

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(LinearGradient(
                        colors: [Color.compatIndigo.opacity(0.85), Color.compatTeal.opacity(0.85)],
                        startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 56, height: 56)
                Image(systemName: "play.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(.white)
                    .accessibilityHidden(true)
            }
            VStack(alignment: .leading, spacing: 3) {
                Text("Continue where you left off")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)
                Text("Ch. \(chapter.number) — \(chapter.title)")
                    .font(.headline)
                    .lineLimit(2)
            }
            Spacer(minLength: 0)
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
                .accessibilityHidden(true)
        }
        .padding(.vertical, 6)
        .accessibilityElement(children: .combine)
        .accessibilityHint("Returns to Discover Mode for this chapter.")
    }
}
