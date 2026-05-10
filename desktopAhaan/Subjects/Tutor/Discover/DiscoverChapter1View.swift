import SwiftUI
import SwiftData

/// The 9-scene driver for Chapter 1 — Nutrition in Plants.
///
/// Architecturally simple: a horizontal `TabView` with `.page` style on macOS
/// behaves as a swipeable pager, but `.page` requires iOS. On macOS we get the
/// same effect by binding `selection` to an `Int` and letting arrow keys plus
/// the on-screen progress dots / next-prev buttons drive the index.
///
/// Each scene exposes a `markComplete()` callback that writes into SwiftData
/// via the parent's `ModelContext`. Progress dots fill in green as the kid
/// completes scenes. The kid can revisit any scene by tapping its dot.
struct DiscoverChapter1View: View {
    let pack: SubjectPack
    let chapter: Chapter

    @Environment(\.modelContext) private var modelContext
    @Query private var progressRows: [DiscoverProgress]
    @AppStorage("discover_scene_ch01") private var currentScene: Int = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let totalScenes = 9

    init(pack: SubjectPack, chapter: Chapter) {
        self.pack = pack
        self.chapter = chapter
        let chId = chapter.id
        _progressRows = Query(
            filter: #Predicate<DiscoverProgress> { $0.chapterId == chId },
            sort: [SortDescriptor(\.completedAt)]
        )
    }

    private var completedSceneIds: Set<String> {
        Set(progressRows.map { $0.sceneId })
    }

    var body: some View {
        ZStack {
            DiscoverBackground()
            VStack(spacing: 0) {
                header
                Divider().opacity(0.3)
                sceneContent
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
                    .id(currentScene)   // forces a re-render so transition runs
                Divider().opacity(0.3)
                footer
            }
        }
        .navigationTitle("✨ Discover · Ch. 1 — Nutrition in Plants")
        .focusable()
        .onKeyPress(.leftArrow)  { goPrev();  return .handled }
        .onKeyPress(.rightArrow) { goNext();  return .handled }
    }

    // MARK: - Header (progress dots)

    private var header: some View {
        HStack(spacing: 8) {
            ForEach(0..<totalScenes, id: \.self) { i in
                let id = sceneId(at: i)
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
                                .strokeBorder(currentScene == i ? .indigo : .clear, lineWidth: 2.5)
                        )
                        .frame(width: 14, height: 14)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Scene \(i + 1) of \(totalScenes), \(done ? "completed" : "not yet completed")")
            }
            Spacer()
            Text("\(completedSceneIds.count) / \(totalScenes) done")
                .font(.caption.weight(.medium))
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
    }

    // MARK: - Scene content

    @ViewBuilder
    private var sceneContent: some View {
        switch currentScene {
        case 0: Scene1_PlantKitchen(pack: pack, chapter: chapter, onComplete: { markComplete(0) })
        case 1: Scene2_PhotosynthesisLab(pack: pack, chapter: chapter, onComplete: { markComplete(1) })
        case 2: Scene3_InsideALeaf(pack: pack, chapter: chapter, onComplete: { markComplete(2) })
        case 3: Scene4_ColorTheChlorophyll(pack: pack, chapter: chapter, onComplete: { markComplete(3) })
        case 4: Scene5_AutotrophHeterotroph(pack: pack, chapter: chapter, onComplete: { score in markComplete(4, score: score, max: 12) })
        case 5: Scene6_MeetTheSpecialPlants(pack: pack, chapter: chapter, onComplete: { markComplete(5) })
        case 6: Scene7_PitcherPlantTrap(pack: pack, chapter: chapter, onComplete: { markComplete(6) })
        case 7: Scene8_NitrogenCycle(pack: pack, chapter: chapter, onComplete: { markComplete(7) })
        case 8: Scene9_BossQuiz(pack: pack, chapter: chapter, onComplete: { score in markComplete(8, score: score, max: 5) })
        default: EmptyView()
        }
    }

    // MARK: - Footer (prev / next)

    private var footer: some View {
        HStack {
            Button {
                goPrev()
            } label: {
                Label("Previous", systemImage: "chevron.left")
            }
            .buttonStyle(.bordered)
            .disabled(currentScene == 0)

            Spacer()

            Text(sceneTitle(at: currentScene))
                .font(.headline)
                .foregroundStyle(.indigo)

            Spacer()

            Button {
                goNext()
            } label: {
                Label("Next", systemImage: "chevron.right")
                    .labelStyle(.titleAndIcon)
            }
            .buttonStyle(.borderedProminent)
            .tint(.indigo)
            .disabled(currentScene == totalScenes - 1)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
    }

    // MARK: - Helpers

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

    private func sceneId(at index: Int) -> String { "scene\(index + 1)" }

    private func sceneTitle(at index: Int) -> String {
        ["Plant Kitchen",
         "Photosynthesis Lab",
         "Inside a Leaf",
         "Why Are Leaves Green?",
         "Autotroph or Heterotroph?",
         "Meet the Special Plants",
         "The Pitcher Plant Trap",
         "The Nitrogen Cycle",
         "Boss Quiz"][index]
    }

    private func markComplete(_ index: Int, score: Int? = nil, max: Int? = nil) {
        let id = sceneId(at: index)
        // Don't double-write if already complete and no new score.
        if let existing = progressRows.first(where: { $0.sceneId == id }) {
            if let s = score { existing.score = s }
            if let m = max   { existing.maxScore = m }
            existing.completedAt = Date()
        } else {
            let row = DiscoverProgress(
                chapterId: chapter.id,
                sceneId: id,
                score: score,
                maxScore: max
            )
            modelContext.insert(row)
        }
        modelContext.safeSave()
        // Auto-advance when not on last scene.
        if index < totalScenes - 1 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                goNext()
            }
        }
    }
}
