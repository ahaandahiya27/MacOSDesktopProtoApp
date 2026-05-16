import SwiftUI

/// Chapter-specific dispatch for "Discover Mode" — the illustrated, interactive
/// alternative to plain text concept cards. Today, only Chapter 1 of the
/// Class 7 Science pack has a hand-built Discover experience. Other chapters
/// fall through to a friendly "coming soon" placeholder so the architecture
/// scales without crashing.
enum DiscoverMode {

    /// Chapter ids for which we have a hand-built 9-scene experience. Adding
    /// a new chapter only requires inserting its id here AND adding a case
    /// branch in `view(for:chapter:)` below.
    private static let supportedChapterIds: Set<String> = [
        "ch01",   // Nutrition in Plants
        "ch02",   // Nutrition in Animals
        "ch03",   // Fibre to Fabric
        "ch04",   // Heat
        "ch05",   // Acids, Bases and Salts
        "ch06",   // Physical and Chemical Changes
        "ch07",   // Weather, Climate and Adaptations
        "ch19"    // Earth, Moon and the Sun
    ]

    /// Returns true if Discover Mode has hand-built scenes for this chapter.
    /// Used by `ChapterDetailView` to decide whether to show the entry button.
    static func hasExperience(for pack: SubjectPack, chapter: Chapter) -> Bool {
        return pack.id == "science_class7" && supportedChapterIds.contains(chapter.id)
    }

    @ViewBuilder
    static func view(for pack: SubjectPack, chapter: Chapter) -> some View {
        if pack.id == "science_class7" {
            switch chapter.id {
            case "ch01":
                DiscoverChapter1View(pack: pack, chapter: chapter)
            case "ch02":
                DiscoverChapter2View(pack: pack, chapter: chapter)
            case "ch03":
                DiscoverChapter3View(pack: pack, chapter: chapter)
            case "ch04":
                DiscoverChapter4View(pack: pack, chapter: chapter)
            case "ch05":
                DiscoverChapter5View(pack: pack, chapter: chapter)
            case "ch06":
                DiscoverChapter6View(pack: pack, chapter: chapter)
            case "ch07":
                DiscoverChapter7View(pack: pack, chapter: chapter)
            case "ch19":
                DiscoverChapter19View(pack: pack, chapter: chapter)
            default:
                ComingSoonView(chapterTitle: chapter.title)
            }
        } else {
            ComingSoonView(chapterTitle: chapter.title)
        }
    }
}

/// Per-scene fallback shown on Big Sur (macOS 11) when a specific Discover
/// scene relies on APIs that aren't available before macOS 12 (Canvas,
/// TimelineView). The chapter shell, navigation, and progress dots still
/// work — only the interactive scene body is replaced.
struct SceneRequiresMacOS12View: View {
    let sceneTitle: String

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "sparkles")
                .font(.system(size: 36))
                .foregroundColor(.secondary)
            Text(sceneTitle)
                .font(.title3.bold())
            Text("This interactive scene needs macOS 12 or later to render.")
                .font(.callout)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            Text("You can still browse the rest of this chapter from the regular chapter view.")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.top, 4)
        }
        .padding(28)
        .frame(maxWidth: 460)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.gray.opacity(0.08))
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private struct ComingSoonView: View {
    let chapterTitle: String

    var body: some View {
        ZStack {
            DiscoverBackground()
            VStack(spacing: 16) {
                Text("✨")
                    .font(.system(size: 64))
                Text("Discover Mode is coming soon for")
                    .font(.title3)
                    .foregroundColor(.secondary)
                Text(chapterTitle)
                    .font(.largeTitle.bold())
                    .multilineTextAlignment(.center)
                Text("Until then, the regular chapter view has all the content.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .padding(.top, 8)
            }
            .padding(40)
        }
        .navigationTitle("Discover Mode")
    }
}
