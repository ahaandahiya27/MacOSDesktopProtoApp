import SwiftUI

@available(macOS 12, *)
struct DiscoverChapter2View: View {
    let pack: SubjectPack
    let chapter: Chapter

    @EnvironmentObject private var dataStore: DataStore
    @AppStorage("discover_scene_ch02") private var currentScene: Int = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let totalScenes = 9

    private var completedSceneIds: Set<String> {
        Set(dataStore.discoverRows(for: chapter.id).map { $0.sceneId })
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
                    .id(currentScene)
                Divider().opacity(0.3)
                footer
            }
        }
        .navigationTitle("Discover · Ch. 2 — Nutrition in Animals")
        .onArrowKeys(left: { goPrev() }, right: { goNext() })
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

    // MARK: - Scene content

    @ViewBuilder
    private var sceneContent: some View {
        switch currentScene {
        case 0: Scene1_TheMouthLab(pack: pack, chapter: chapter, onComplete: { markComplete(0) })
        case 1: Scene2_TheSwallowWave(pack: pack, chapter: chapter, onComplete: { markComplete(1) })
        case 2: Scene3_TheStomachBath(pack: pack, chapter: chapter, onComplete: { markComplete(2) })
        case 3: Scene4_IntestineVillus(pack: pack, chapter: chapter, onComplete: { markComplete(3) })
        case 4: Scene5_LiverPancreasBile(pack: pack, chapter: chapter, onComplete: { markComplete(4) })
        case 5: Scene6_FourStomachsOfACow(pack: pack, chapter: chapter, onComplete: { markComplete(5) })
        case 6: Scene7_AmoebaPseudopodHunt(pack: pack, chapter: chapter, onComplete: { markComplete(6) })
        case 7: Scene8_TasteAndFlavour(pack: pack, chapter: chapter, onComplete: { markComplete(7) })
        case 8: Scene9_BossQuiz_Ch2(pack: pack, chapter: chapter, onComplete: { score in markComplete(8, score: score, max: 5) })
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
            
            .disabled(currentScene == 0)

            Spacer()

            Text(sceneTitle(at: currentScene))
                .font(.headline)
                .foregroundColor(Color.compatIndigo)

            Spacer()

            Button {
                goNext()
            } label: {
                Label("Next", systemImage: "chevron.right")
                    .labelStyle(.titleAndIcon)
            }
            
            .accentColor(Color.compatIndigo)
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
        ["The Mouth Lab",
         "The Swallow Wave",
         "The Stomach Bath",
         "The Intestine Villus Tour",
         "Liver, Pancreas & Bile",
         "The Four-Stomach Cow Tour",
         "Amoeba Pseudopod Hunt",
         "Taste & Flavour",
         "Boss Quiz"][index]
    }

    private func markComplete(_ index: Int, score: Int? = nil, max: Int? = nil) {
        let id = sceneId(at: index)
        dataStore.markSceneComplete(chapterId: chapter.id, sceneId: id, score: score, maxScore: max)
        if index < totalScenes - 1 {
            Task { @MainActor in
                try? await Task.sleep(nanoseconds: 400_000_000)
                goNext()
            }
        }
    }
}
