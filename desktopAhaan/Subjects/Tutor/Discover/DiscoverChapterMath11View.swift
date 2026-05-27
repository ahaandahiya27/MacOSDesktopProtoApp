import SwiftUI

// Discover Mode — Maths Ch.11 "Finding Common Ground". Built on
// MathDiscoverComponents (2026-05-27 build-out). Scene cursor
// discoverScene(111); markSceneComplete "m\(chapter.id)" so progress
// stays separate from any Science chapter sharing the chNN id.

struct DiscoverChapterMath11View: View {
    let pack: SubjectPack
    let chapter: Chapter

    @EnvironmentObject private var dataStore: DataStore
    @AppStorage(AppStorageKeys.discoverScene(111)) private var currentScene: Int = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let sceneTitles = ["Common Ground", "Highest Common Factor", "Least Common Multiple", "Co-prime Numbers", "HCF & LCM Boss Quiz"]

    var body: some View {
        DiscoverShell(
            pack: pack, chapter: chapter,
            navigationTitle: "Discover · Maths Ch. 11 — Finding Common Ground",
            sceneTitles: sceneTitles, currentScene: $currentScene, scene: sceneBody
        )
        .onAppear {
            let maxIndex = sceneTitles.count - 1
            if currentScene < 0 || currentScene > maxIndex { currentScene = max(0, min(currentScene, maxIndex)) }
        }
    }

    private func sceneBody(_ index: Int) -> AnyView {
        guard index >= 0 && index < sceneBuilders.count else { return AnyView(EmptyView()) }
        return sceneBuilders[index]()
    }

    private var sceneBuilders: [() -> AnyView] {
        [
            { AnyView(MathDiscoverInfoScene(title: "Common Ground", paragraphs: ["The HCF (highest common factor) is the biggest number that divides two numbers exactly. The LCM (least common multiple) is the smallest number both divide into.", "Prime factorisation reveals both, and for any two numbers HCF × LCM equals the product of the numbers themselves."], onComplete: { self.markComplete(0) })) },
            { AnyView(MathDiscoverQuickScene(title: "Highest Common Factor", intro: "The largest number dividing both. 12 = 2×2×3, 18 = 2×3×3, shared = 2×3 = 6.", prompt: "HCF of 12 and 18?", options: ["6", "3", "36", "2"], correctIndex: 0, onComplete: { s in self.markComplete(1, score: s, max: 1) })) },
            { AnyView(MathDiscoverQuickScene(title: "Least Common Multiple", intro: "The smallest number both divide into.", prompt: "LCM of 4 and 6?", options: ["12", "24", "2", "10"], correctIndex: 0, onComplete: { s in self.markComplete(2, score: s, max: 1) })) },
            { AnyView(MathDiscoverQuickScene(title: "Co-prime Numbers", intro: "Numbers sharing no factor but 1.", prompt: "Two numbers whose HCF is 1 are called?", options: ["Co-prime", "Twin primes", "Composite", "Multiples"], correctIndex: 0, onComplete: { s in self.markComplete(3, score: s, max: 1) })) },
            { AnyView(MathDiscoverBossQuizScene(title: "HCF & LCM Boss Quiz", questions: [MathDiscoverBossQA(prompt: "HCF of 8 and 12?", options: ["4", "2", "24", "8"], correct: 0), MathDiscoverBossQA(prompt: "LCM of 3 and 5?", options: ["15", "8", "30", "1"], correct: 0), MathDiscoverBossQA(prompt: "The HCF of two co-prime numbers is?", options: ["1", "0", "Their product", "2"], correct: 0), MathDiscoverBossQA(prompt: "For two numbers, HCF × LCM = ?", options: ["The product of the numbers", "The sum of the numbers", "Always 1", "The difference"], correct: 0), MathDiscoverBossQA(prompt: "LCM of 6 and 9?", options: ["18", "54", "3", "15"], correct: 0)], onComplete: { s in self.markComplete(4, score: s, max: 5) })) }
        ]
    }

    private func markComplete(_ index: Int, score: Int? = nil, max: Int? = nil) {
        dataStore.markSceneComplete(chapterId: "m\(chapter.id)", sceneId: "scene\(index + 1)", score: score, maxScore: max)
        if index < sceneTitles.count - 1 {
            Task { @MainActor in
                try? await Task.sleep(nanoseconds: 400_000_000)
                advanceDiscoverScene($currentScene, total: sceneTitles.count, reduceMotion: reduceMotion)
            }
        }
    }
}
