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

// MARK: - DiscoverShell — shared chrome for every chapter's Discover view

/// The header (progress dots), footer (prev/next), background, divider, scene
/// transitions, and arrow-key navigation that every DiscoverChapterNView used
/// to inline ~80 lines of boilerplate to produce. Now each chapter dispatcher
/// only owns the scene-switch and the chapter-specific markComplete logic.
///
/// Usage:
/// ```
/// DiscoverShell(
///     pack: pack, chapter: chapter,
///     navigationTitle: "Discover · Ch. 1 — Nutrition in Plants",
///     sceneTitles: ["Plant Kitchen", "Photosynthesis Lab", ...],
///     currentScene: $currentScene
/// ) { i in
///     switch i {
///     case 0: Scene1_PlantKitchen(pack: pack, chapter: chapter, onComplete: { markComplete(0) })
///     ...
///     }
/// }
/// ```
struct DiscoverShell<SceneBody: View>: View {
    let pack: SubjectPack
    let chapter: Chapter
    let navigationTitle: String
    let sceneTitles: [String]
    @Binding var currentScene: Int
    @ViewBuilder let scene: (Int) -> SceneBody

    @EnvironmentObject private var dataStore: DataStore
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var totalScenes: Int { sceneTitles.count }

    private var completedSceneIds: Set<String> {
        Set(dataStore.discoverRows(for: chapter.id).map { $0.sceneId })
    }

    var body: some View {
        ZStack {
            DiscoverBackground()
            VStack(spacing: 0) {
                header
                Divider().opacity(0.3)
                scene(currentScene)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
                    .id(currentScene)
                Divider().opacity(0.3)
                footer
            }
        }
        .navigationTitle(navigationTitle)
        .onArrowKeys(left: { goPrev() }, right: { goNext() })
        .background(sceneJumpShortcuts)
    }

    /// ⌘1..⌘9 jump straight to scene N. Invisible Buttons under the chrome
    /// so the shortcuts work regardless of focus.
    private var sceneJumpShortcuts: some View {
        ZStack {
            ForEach(0..<min(totalScenes, 9), id: \.self) { i in
                Button {
                    jumpToScene(i)
                } label: { EmptyView() }
                .keyboardShortcut(
                    KeyEquivalent(Character("\(i + 1)")),
                    modifiers: .command
                )
            }
        }
        .frame(width: 0, height: 0)
        .opacity(0)
    }

    private func jumpToScene(_ index: Int) {
        guard sceneTitles.indices.contains(index) else { return }
        withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.25)) {
            currentScene = index
        }
    }

    private var header: some View {
        HStack(spacing: 8) {
            ForEach(0..<totalScenes, id: \.self) { i in
                let id = "scene\(i + 1)"
                let done = completedSceneIds.contains(id)
                Button {
                    withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.25)) {
                        currentScene = i
                    }
                } label: {
                    Circle()
                        .fill(done ? Color.green : Color.gray.opacity(0.25))
                        .overlay(
                            Circle()
                                .strokeBorder(currentScene == i ? Color.compatIndigo : .clear, lineWidth: 2.5)
                        )
                        .frame(width: 22, height: 22)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Scene \(i + 1) of \(totalScenes), \(done ? "completed" : "not yet completed")")
            }
            Spacer()
            Text("\(completedSceneIds.count) / \(totalScenes) done")
                .font(.caption.weight(.medium))
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
    }

    private var footer: some View {
        HStack {
            Button { goPrev() } label: { Label("Previous", systemImage: "chevron.left") }
                .disabled(currentScene == 0)

            Spacer()

            Text(sceneTitles[currentScene])
                .font(.headline)
                .foregroundColor(Color.compatIndigo)

            Spacer()

            Button { goNext() } label: { Label("Next", systemImage: "chevron.right") }
                .accentColor(Color.compatIndigo)
                .disabled(currentScene == totalScenes - 1)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
    }

    private func goNext() {
        guard currentScene < totalScenes - 1 else { return }
        withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.3)) {
            currentScene += 1
        }
    }

    private func goPrev() {
        guard currentScene > 0 else { return }
        withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.3)) {
            currentScene -= 1
        }
    }
}

/// Helper used inside `markComplete` to advance the scene cursor with the
/// same animation curve as the prev/next buttons. Each chapter dispatcher
/// owns the data-store write but shares this advance. Takes a Binding so it
/// works correctly with the @AppStorage-backed scene cursor.
@MainActor
func advanceDiscoverScene(_ currentScene: Binding<Int>,
                          total: Int,
                          reduceMotion: Bool) {
    guard currentScene.wrappedValue < total - 1 else { return }
    withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.3)) {
        currentScene.wrappedValue += 1
    }
}
