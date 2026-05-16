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
        if #available(macOS 12, *) {
            discoverContent(for: pack, chapter: chapter)
        } else {
            RequiresMacOS12View(chapterTitle: chapter.title)
        }
    }

    @available(macOS 12, *)
    @ViewBuilder
    private static func discoverContent(for pack: SubjectPack, chapter: Chapter) -> some View {
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

private struct RequiresMacOS12View: View {
    let chapterTitle: String

    var body: some View {
        ZStack {
            Color(NSColor.windowBackgroundColor)
            VStack(spacing: 16) {
                Image(systemName: "sparkles")
                    .font(.system(size: 48))
                    .foregroundColor(.secondary)
                Text("Discover Mode")
                    .font(.title2.bold())
                Text("Interactive Discover scenes for \"\(chapterTitle)\" require macOS 12 or later.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                Text("All chapter content is still available in the regular view.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(40)
        }
        .navigationTitle("Discover Mode")
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
