import SwiftUI

// Discover Mode — Class 7 Sanskrit (`sanskrit_class7`), one generic view for
// all 15 NEP chapters (`sch01`–`sch15`, P1-E build-out, v6 Learning Journey).
// The legacy `ch01` vocabulary deck is the documented carve-out and has NO
// Discover experience (gated out in DiscoverMode). Like Social Science, every
// NEP chapter ships the same faithful 9-scene shape, content pulled live from
// the pack — but with a Sanskrit-specific GATED interactive (the शब्द–अर्थ
// word-match game) the other subjects don't have:
//   scene 1     — Big Picture (chapter summary)
//   scenes 2–3  — two key concepts (kid-friendly + textbook + a real use)
//   scene 4     — Word Match (bespoke gated interactive, from `glossary`)
//   scene 5     — a third key concept
//   scenes 6–8  — three quick-checks (chapter MCQs, record SRS)
//   scene 9     — Boss Quiz (the chapter's `bossquiz_sch*` MCQs)
// SRS is recorded inside the quick-check + boss components. Scene cursor uses
// discoverScene(400 + number) so it never collides with Science (1–19),
// Maths (101–115), or Social Science (300+). Progress keys on `chapter.id`
// directly — the NEP `schNN` ids are globally unique.

struct DiscoverChapterSanskritView: View {
    let pack: SubjectPack
    let chapter: Chapter

    @EnvironmentObject private var dataStore: DataStore
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @AppStorage private var currentScene: Int

    init(pack: SubjectPack, chapter: Chapter) {
        self.pack = pack
        self.chapter = chapter
        _currentScene = AppStorage(wrappedValue: 0, AppStorageKeys.discoverScene(400 + chapter.number))
    }

    // MARK: - Scene model

    private enum SanskritScene {
        case info(title: String, paragraphs: [String])
        case match(title: String, intro: String, pairs: [SanskritMatchPair])
        case quick(title: String, intro: String, question: Question)
        case boss(title: String, questions: [Question])

        var title: String {
            switch self {
            case .info(let t, _): return t
            case .match(let t, _, _): return t
            case .quick(let t, _, _): return t
            case .boss(let t, _): return t
            }
        }
    }

    private var scenes: [SanskritScene] {
        var out: [SanskritScene] = []
        let boss = bossMCQs
        let concepts = pickedConcepts(3)
        // Scene 1 — Big Picture.
        let overview = "This chapter has \(conceptPool.count) ideas to explore, a word-match game, and a \(boss.count)-question Boss Quiz at the end. Tap through each scene, then test yourself!"
        out.append(.info(title: "Big Picture", paragraphs: [chapter.summary, overview]))
        // Scenes 2–3 — first two key concepts.
        for c in concepts.prefix(2) {
            out.append(.info(title: c.title, paragraphs: conceptParagraphs(c)))
        }
        // Scene 4 — the gated शब्द–अर्थ word-match interactive.
        let pairs = matchPairs
        if pairs.count >= 3 {
            out.append(.match(
                title: "शब्द–अर्थ — Match the Words",
                intro: "Tap a Sanskrit word, then tap its meaning. Match all \(pairs.count) to continue.",
                pairs: pairs
            ))
        }
        // Scene 5 — a third concept (if available).
        if concepts.count >= 3 {
            out.append(.info(title: concepts[2].title, paragraphs: conceptParagraphs(concepts[2])))
        }
        // Scenes 6–8 — three quick-checks from the chapter's MCQ pool.
        let checks = quickCheckPicks
        for (n, q) in checks.enumerated() {
            out.append(.quick(title: "Quick Check \(n + 1)", intro: "Let's see what stuck. Pick the best answer.", question: q))
        }
        // Scene 9 — Boss Quiz (MCQ boss questions only).
        out.append(.boss(title: "\(chapter.title) — Boss Quiz", questions: boss))
        return out
    }

    /// True for a boss/quick-check question the Discover MCQ surfaces can
    /// render: a real multiple-choice item whose answer is among its options.
    private func isRenderableMCQ(_ q: Question) -> Bool {
        guard q.questionType == .mcq else { return false }
        let opts = q.options ?? []
        return !opts.isEmpty && opts.contains(q.answer)
    }

    /// MCQ boss questions for the Boss Quiz scene.
    private var bossMCQs: [Question] { chapter.bossQuestionsList.filter(isRenderableMCQ) }

    /// Three distinct MCQs for the quick-check scenes, preferring the chapter's
    /// own topic questions (so their SRS records under the canonical id), then
    /// boss MCQs as a last resort.
    private var quickCheckPicks: [Question] {
        let ordered = chapter.quickCheckQuestionsList.filter(isRenderableMCQ)
            + chapter.topics.flatMap { $0.questions }.filter(isRenderableMCQ)
            + bossMCQs
        var seen = Set<String>()
        var out: [Question] = []
        for q in ordered {
            if out.count == 3 { break }
            if seen.insert(q.id).inserted { out.append(q) }
        }
        return out
    }

    /// Up to five term↔meaning pairs for the match game, spread across the
    /// chapter glossary so the learner meets entries from start, middle, and
    /// end. Only entries with a non-empty term AND definition are eligible.
    private var matchPairs: [SanskritMatchPair] {
        let eligible = chapter.glossaryList.filter {
            !$0.term.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                && !$0.definition.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
        guard !eligible.isEmpty else { return [] }
        let n = min(5, eligible.count)
        var picked: [GlossaryTerm] = []
        if eligible.count <= n {
            picked = eligible
        } else {
            for k in 0..<n {
                picked.append(eligible[(k * eligible.count) / n])
            }
        }
        return picked.map { SanskritMatchPair(id: $0.id, term: $0.term, meaning: $0.definition) }
    }

    private var sceneTitles: [String] { scenes.map { $0.title } }

    // MARK: - Body

    var body: some View {
        DiscoverShell(
            pack: pack, chapter: chapter,
            navigationTitle: "Discover · \(chapter.title)",
            sceneTitles: sceneTitles, currentScene: $currentScene, scene: sceneBody
        )
        .onAppear {
            let maxIndex = sceneTitles.count - 1
            if currentScene < 0 || currentScene > maxIndex { currentScene = max(0, min(currentScene, maxIndex)) }
        }
    }

    private func sceneBody(_ index: Int) -> AnyView {
        let all = scenes
        guard index >= 0 && index < all.count else { return AnyView(EmptyView()) }
        switch all[index] {
        case .info(let title, let paragraphs):
            return AnyView(SanskritDiscoverInfoScene(title: title, paragraphs: paragraphs,
                                                     onComplete: { self.markComplete(index) }))
        case .match(let title, let intro, let pairs):
            return AnyView(SanskritWordMatchScene(title: title, intro: intro, pairs: pairs,
                                                  onComplete: { self.markComplete(index) }))
        case .quick(_, let intro, let question):
            return AnyView(SanskritDiscoverQuickCheckScene(intro: intro, question: question, packId: pack.id,
                                                           onComplete: { s in self.markComplete(index, score: s, max: 1) }))
        case .boss(let title, let questions):
            return AnyView(SanskritDiscoverBossQuizScene(title: title, questions: questions, packId: pack.id,
                                                         onComplete: { s in self.markComplete(index, score: s, max: questions.count) }))
        }
    }

    // MARK: - Completion

    private func markComplete(_ index: Int, score: Int? = nil, max: Int? = nil) {
        dataStore.markSceneComplete(chapterId: chapter.id, sceneId: "scene\(index + 1)", score: score, maxScore: max)
        if index < sceneTitles.count - 1 {
            Task { @MainActor in
                try? await Task.sleep(nanoseconds: 400_000_000)
                advanceDiscoverScene($currentScene, total: sceneTitles.count, reduceMotion: reduceMotion)
            }
        }
    }

    // MARK: - Content helpers

    private var conceptPool: [Concept] { chapter.topics.flatMap { $0.concepts } }

    /// Pick `n` concepts spread evenly across the chapter so a learner meets
    /// ideas from the start, middle, and end — not just the first topic.
    private func pickedConcepts(_ n: Int) -> [Concept] {
        let pool = conceptPool
        guard !pool.isEmpty, n > 0 else { return [] }
        if pool.count <= n { return pool }
        var out: [Concept] = []
        for k in 0..<n {
            let idx = (k * pool.count) / n
            out.append(pool[idx])
        }
        return out
    }

    private func conceptParagraphs(_ c: Concept) -> [String] {
        var paras = [c.explanation(at: .kidFriendly), c.explanation(at: .textbook)]
        if let uc = c.useCases.first {
            paras.append("Where you see it — \(uc.title): \(uc.description)")
        }
        return paras
    }
}
