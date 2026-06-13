import SwiftUI

// Discover Mode — Class 7 Social Science (`socialscience_class7`), one generic
// view for all 20 chapters (2026-05-31 build-out; gated interactive added v8,
// 2026-06-11). Unlike Science (a hand-built scene file per chapter), every
// Social Science chapter ships the same faithful 9-scene shape, with the
// content pulled live from the pack:
//   scene 1     — Big Picture (chapter summary)
//   scenes 2–4  — three key concepts (kid-friendly + textbook + a real use)
//   scene 5     — bespoke GATED interactive (v8): a chronology-ordering
//                 challenge for History chapters (over the authored timeline),
//                 a key-word ↔ meaning match for every other chapter (over the
//                 glossary). This brings the SS Discover flow to parity with
//                 Sanskrit (word-match scene 4) and Science/Maths (sandboxes).
//   scenes 6–8  — three quick-checks (the pack's `scenecheck_ssch*` MCQs)
//   scene 9     — Boss Quiz (the pack's `bossquiz_ssch*` MCQs)
// SRS is recorded inside the quick-check + boss components (see
// SocialScienceDiscoverComponents.swift). Scene cursor uses discoverScene(300+number)
// so it never collides with Science (1–19) or Maths (101–115). Progress is keyed
// on `chapter.id` directly — Social Science ids (`sschNN`) are globally unique,
// so no "m"-style prefix is needed.

struct DiscoverChapterSocialScienceView: View {
    let pack: SubjectPack
    let chapter: Chapter

    @EnvironmentObject private var dataStore: DataStore
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @AppStorage private var currentScene: Int

    init(pack: SubjectPack, chapter: Chapter) {
        self.pack = pack
        self.chapter = chapter
        _currentScene = AppStorage(wrappedValue: 0, AppStorageKeys.discoverScene(300 + chapter.number))
    }

    // MARK: - Scene model

    private enum SSScene {
        case info(title: String, paragraphs: [String])
        case match(title: String, intro: String, pairs: [SSDiscoverMatchPair])
        case chronology(title: String, intro: String, steps: [TimelineStep])
        case quick(title: String, intro: String, question: Question)
        case boss(title: String, questions: [Question])

        var title: String {
            switch self {
            case .info(let t, _): return t
            case .match(let t, _, _): return t
            case .chronology(let t, _, _): return t
            case .quick(let t, _, _): return t
            case .boss(let t, _): return t
            }
        }
    }

    /// History chapters whose authored timeline is a date-ordered sequence of
    /// events — they get the "tap the events earliest → latest" chronology
    /// challenge in their Discover flow. Mirrors `socialScienceChronologyChapterIds`
    /// in ChapterDetailView+PropagatedCTAs (the detail-surface sibling), kept here
    /// so the Discover gate is self-contained and unit-testable.
    private static let chronologyChapterIds: Set<String> = [
        "ssch04", "ssch05", "ssch06", "ssch07", "ssch15", "ssch16"
    ]

    private var scenes: [SSScene] {
        var out: [SSScene] = []
        let boss = bossMCQs
        // Scene 1 — Big Picture.
        let overview = "This chapter has \(conceptPool.count) big ideas to explore and a \(boss.count)-question Boss Quiz at the end. Tap through each scene, then test yourself!"
        out.append(.info(title: "Big Picture", paragraphs: [chapter.summary, overview]))
        // Scenes 2–4 — three spread-out key concepts.
        for c in pickedConcepts(3) {
            out.append(.info(title: c.title, paragraphs: conceptParagraphs(c)))
        }
        // Scene 5 — the bespoke GATED interactive (the piece Social Science's
        // Discover flow used to lack). History chapters get a chronology-ordering
        // challenge over their authored timeline; everyone else gets a key-term
        // match over the chapter glossary. Auto-falls-back to one more concept
        // scene if a chapter somehow lacks the data (keeps the flow intact).
        if let gated = gatedScene {
            out.append(gated)
        } else if let extra = pickedConcepts(4).dropFirst(3).first {
            out.append(.info(title: extra.title, paragraphs: conceptParagraphs(extra)))
        }
        // Scenes 6–8 — three quick-checks. Drawn from a deduped MCQ pool that
        // prefers the chapter's `scenecheck` MCQs, then topic-question MCQs,
        // then spare boss MCQs — so even chapters whose quick-check array is
        // mostly non-MCQ (match/short/long) still get three tappable scenes.
        let checks = quickCheckPicks
        for (n, q) in checks.enumerated() {
            out.append(.quick(title: "Quick Check \(n + 1)", intro: "Let's see what stuck. Pick the best answer.", question: q))
        }
        // Guarantee 8 learning scenes even if the MCQ pool is unusually thin:
        // backfill with additional concept scenes from the pool.
        if out.count < 8 {
            let extra = pickedConcepts(8 - out.count + 4).dropFirst(4)
            for c in extra where out.count < 8 {
                out.append(.info(title: c.title, paragraphs: conceptParagraphs(c)))
            }
        }
        // Scene 9 — Boss Quiz (MCQ boss questions only — the tap-an-option
        // format can't render match/long/short items, which still surface in
        // the normal chapter Q&A and articles).
        out.append(.boss(title: "\(chapter.title) — Boss Quiz", questions: boss))
        return out
    }

    /// The bespoke gated interactive scene for this chapter, or `nil` if the
    /// chapter lacks the data to build one. History chapters → chronology
    /// (needs a timeline with ≥3 steps); all others → glossary word-match
    /// (needs ≥3 usable pairs). Every authored SS chapter satisfies one of
    /// these, but the `nil` path keeps the flow safe if content is ever thin.
    private var gatedScene: SSScene? {
        if Self.chronologyChapterIds.contains(chapter.id),
           let tl = chapter.timelinesList.first, tl.steps.count >= 3 {
            let steps = Array(tl.steps.prefix(5))
            return .chronology(
                title: "Put History in Order",
                intro: "Tap the events from earliest to latest. Place all \(steps.count) to continue. (\(tl.title))",
                steps: steps
            )
        }
        let pairs = matchPairs
        if pairs.count >= 3 {
            return .match(
                title: "Match the Key Words",
                intro: "Tap a key word, then tap its meaning. Match all \(pairs.count) to continue.",
                pairs: pairs
            )
        }
        return nil
    }

    /// Up to five term↔meaning pairs spread across the chapter glossary so the
    /// learner meets entries from start, middle, and end. Only entries with a
    /// non-empty term AND definition are eligible.
    private var matchPairs: [SSDiscoverMatchPair] {
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
        return picked.map { SSDiscoverMatchPair(id: $0.id, term: $0.term, meaning: $0.definition) }
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

    /// Three distinct MCQs for the quick-check scenes, preferring the
    /// `scenecheck` items so their SRS records under that id, then topic
    /// questions, then boss MCQs as a last resort.
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
            return AnyView(SSDiscoverInfoScene(title: title, paragraphs: paragraphs,
                                               onComplete: { self.markComplete(index) }))
        case .match(let title, let intro, let pairs):
            return AnyView(SSDiscoverWordMatchScene(title: title, intro: intro, pairs: pairs,
                                                    onComplete: { self.markComplete(index) }))
        case .chronology(let title, let intro, let steps):
            return AnyView(SSDiscoverChronologyScene(title: title, intro: intro, steps: steps,
                                                     onComplete: { self.markComplete(index) }))
        case .quick(_, let intro, let question):
            return AnyView(SSDiscoverQuickCheckScene(intro: intro, question: question, packId: pack.id,
                                                     onComplete: { s in self.markComplete(index, score: s, max: 1) }))
        case .boss(let title, let questions):
            return AnyView(SSDiscoverBossQuizScene(title: title, questions: questions, packId: pack.id,
                                                   onComplete: { s in self.markComplete(index, score: s, max: questions.count) }))
        }
    }

    // MARK: - Completion

    private func markComplete(_ index: Int, score: Int? = nil, max: Int? = nil) {
        dataStore.markSceneComplete(chapterId: chapter.id, sceneId: "scene\(index + 1)", score: score, maxScore: max)
        if index < sceneTitles.count - 1 {
            Task { @MainActor in
                try? await Task.sleep(nanoseconds: DiscoverTiming.settleDelayNs)
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
