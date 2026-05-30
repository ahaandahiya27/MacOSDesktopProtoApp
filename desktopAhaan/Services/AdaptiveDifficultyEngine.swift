import Foundation
import Combine

// MARK: - AdaptiveDifficultyEngine
//
// Performance-aware question selection. Tracks the kid's rolling 5-question
// correct/incorrect window per chapter (`PracticeWindow`) and ranks candidate
// questions so that a hot streak surfaces harder questions and a cold run
// surfaces easier ones to rebuild confidence (see `PracticeWindow.band` for
// the exact table).
//
// Three design choices keep this strictly additive and Big-Sur-safe:
//
//   • READ-ONLY w.r.t. SRS. Outcomes are captured by OBSERVING
//     `DataStore.questionReviews` deltas — a review whose `lapses` increased
//     since we last looked was answered `.forgot` (incorrect); any other
//     `totalReviews` bump was a correct answer. The SRS scheduler itself is
//     never touched. `recordOutcome(...)` stays public so tests (and any
//     future explicit call site) can drive the window directly.
//
//   • Persistence reuses `DataStore.readFile` + `performAtomicWrite` (both
//     `nonisolated static`) so the coalesced-atomic-write contract is shared
//     rather than re-implemented. State lives in `adaptive_difficulty.json`.
//
//   • Ranking is a PURE static function (`rank(...)`) of the candidate list,
//     the target band, and an ease lookup — unit-testable with no FS / app.
//
// Big Sur compatible: Foundation + Combine only, no macOS 12+ APIs.

@MainActor
final class AdaptiveDifficultyEngine: ObservableObject {
    static let shared = AdaptiveDifficultyEngine()

    private static let filename = "adaptive_difficulty.json"
    private static let debounceSeconds: TimeInterval = 0.3

    private let storeDir: URL
    private var state: AdaptivePracticeState
    private var saveTimer: Timer?

    /// Live refs, captured at `configure(...)`. Weak so the engine never
    /// keeps the app's store/registry alive past their scene.
    private weak var registry: SubjectRegistry?
    private weak var dataStore: DataStore?

    private var cancellables = Set<AnyCancellable>()
    private var configured = false

    /// Last-seen `(totalReviews, lapses, packId)` per questionId — the
    /// baseline the observer diffs against to detect answered questions.
    private var reviewBaseline: [String: (total: Int, lapses: Int, packId: String?)] = [:]

    /// init is accessible (not private) so tests can build an isolated engine
    /// against a temp store without disturbing the shared singleton.
    init(storeDir: URL? = nil, autoLoad: Bool = true) {
        if let storeDir = storeDir {
            self.storeDir = storeDir
        } else {
            let appSupport = FileManager.default.urls(
                for: .applicationSupportDirectory, in: .userDomainMask
            ).first ?? FileManager.default.temporaryDirectory
            self.storeDir = appSupport
                .appendingPathComponent("com.emoha.desktopAhaan")
                .appendingPathComponent("data")
        }
        try? FileManager.default.createDirectory(
            at: self.storeDir, withIntermediateDirectories: true)

        if autoLoad {
            let loaded = DataStore.readFile(
                AdaptivePracticeState.self, from: Self.filename, in: self.storeDir)
            self.state = loaded.items.first ?? AdaptivePracticeState()
        } else {
            self.state = AdaptivePracticeState()
        }
    }

    // MARK: - Lifecycle

    /// Wire the engine to the live store + registry and begin observing
    /// review deltas. Idempotent — a re-rendered `onAppear` can't
    /// double-subscribe.
    func configure(registry: SubjectRegistry, dataStore: DataStore) {
        guard !configured else { return }
        configured = true
        self.registry = registry
        self.dataStore = dataStore

        // Seed the baseline so the first observed change diffs against the
        // store as it is NOW — pre-existing review history is not replayed as
        // a burst of outcomes (a silent backfill, like AchievementEngine).
        captureBaseline(from: dataStore.questionReviews)

        dataStore.objectWillChange
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] _ in self?.ingestReviewDeltas() }
            .store(in: &cancellables)
    }

    // MARK: - Public API

    /// Record one practice outcome into the chapter's rolling window.
    func recordOutcome(questionId: String, correct: Bool,
                              chapterId: String, packId: String) {
        let key = AdaptivePracticeState.windowKey(packId: packId, chapterId: chapterId)
        var window = state.windows[key] ?? PracticeWindow()
        window.record(correct)
        state.windows[key] = window
        scheduleSave()
    }

    /// The chapter's current recommended band (neutral `.core` for a chapter
    /// the kid hasn't practised yet).
    func currentBand(forChapter chapterId: String, packId: String) -> DifficultyBand {
        let key = AdaptivePracticeState.windowKey(packId: packId, chapterId: chapterId)
        return (state.windows[key] ?? PracticeWindow()).band
    }

    /// Up to `k` questions from the chapter, ranked so band-appropriate
    /// questions come first. Requires `configure(...)` (returns `[]` if the
    /// pack/chapter can't be resolved). When the engine is disabled the
    /// target band collapses to `.core` (intrinsic-difficulty order only).
    func recommendedNextQuestions(for chapterId: String, packId: String, k: Int) -> [Question] {
        guard k > 0,
              let registry = registry,
              let pack = registry.pack(withId: packId),
              let chapter = pack.chapters.first(where: { $0.id == chapterId })
        else { return [] }

        let questions = chapter.topics.flatMap { $0.questions }
        let band = AdaptiveDifficultyStorage.isEngineEnabled()
            ? currentBand(forChapter: chapterId, packId: packId)
            : .core
        let reviews = dataStore?.questionReviews ?? [:]
        return Self.rank(questions: questions, targetBand: band,
                         easeFor: { reviews[$0]?.ease }, k: k)
    }

    /// Read-only Daily-Plan adapter: reorder a set of ALREADY-DUE question ids
    /// so band-appropriate items surface first, without touching SRS state.
    /// When the engine is off, returns `dueIds` unchanged (pass-through).
    func prioritizedDueQuestionIds(
        _ dueIds: [String], registry: SubjectRegistry, dataStore: DataStore
    ) -> [String] {
        guard AdaptiveDifficultyStorage.isEngineEnabled() else { return dueIds }
        let reviews = dataStore.questionReviews
        let scored = dueIds.enumerated().map { (i, id) -> (id: String, dist: Int, i: Int) in
            guard let loc = registry.location(
                forQuestionId: id, preferredPackId: reviews[id]?.packId) else {
                // Unresolved (e.g. an ephemeral boss id) → neutral distance so
                // it neither jumps to the front nor sinks; original due order
                // is preserved among equals via the stable index tiebreak.
                return (id, 1, i)
            }
            let target = currentBand(forChapter: loc.chapter.id, packId: loc.pack.id)
            let dist = abs(loc.question.intrinsicBand.rawValue - target.rawValue)
            return (id, dist, i)
        }
        return scored
            .sorted { a, b in a.dist != b.dist ? a.dist < b.dist : a.i < b.i }
            .map { $0.id }
    }

    // MARK: - Pure ranking core

    /// Order `questions` by closeness to `targetBand`; break ties by SRS ease
    /// ascending (a lower ease = the kid struggles more with it → surface it
    /// sooner), then by original order for stability. Returns the first `k`.
    static func rank(
        questions: [Question], targetBand: DifficultyBand,
        easeFor: (String) -> Double?, k: Int
    ) -> [Question] {
        guard k > 0 else { return [] }
        let scored = questions.enumerated().map {
            (i, q) -> (q: Question, dist: Int, ease: Double, i: Int) in
            let dist = abs(q.intrinsicBand.rawValue - targetBand.rawValue)
            let ease = easeFor(q.id) ?? 2.5   // SM-2 default for an unseen item
            return (q, dist, ease, i)
        }
        return scored.sorted { a, b in
            if a.dist != b.dist { return a.dist < b.dist }
            if a.ease != b.ease { return a.ease < b.ease }
            return a.i < b.i
        }
        .prefix(k)
        .map { $0.q }
    }

    // MARK: - Review-delta ingestion (read-only SRS observation)

    private func captureBaseline(from reviews: [String: QuestionReview]) {
        reviewBaseline = reviews.mapValues { ($0.totalReviews, $0.lapses, $0.packId) }
    }

    /// Diff the live reviews against the baseline; for every review that
    /// gained a `totalReviews` since last seen, record a correct/incorrect
    /// outcome (incorrect iff `lapses` also increased — i.e. it was answered
    /// `.forgot`). Then refresh the baseline.
    private func ingestReviewDeltas() {
        guard let dataStore = dataStore, let registry = registry else { return }
        let reviews = dataStore.questionReviews
        for (id, review) in reviews {
            let prior = reviewBaseline[id]
            let priorTotal = prior?.total ?? 0
            guard review.totalReviews > priorTotal else { continue }
            let priorLapses = prior?.lapses ?? 0
            let correct = review.lapses <= priorLapses
            guard let loc = registry.location(
                forQuestionId: id, preferredPackId: review.packId ?? prior?.packId) else { continue }
            recordOutcome(questionId: id, correct: correct,
                          chapterId: loc.chapter.id, packId: loc.pack.id)
        }
        captureBaseline(from: reviews)
    }

    // MARK: - Persistence (coalesced 300ms debounce, atomic write)

    private func scheduleSave() {
        saveTimer?.invalidate()
        saveTimer = Timer.scheduledTimer(
            withTimeInterval: Self.debounceSeconds, repeats: false
        ) { [weak self] _ in
            Task { @MainActor [weak self] in self?.flushSave() }
        }
    }

    /// Encode-on-main, atomic-write-off-main via the shared DataStore helper.
    func flushSave() {
        saveTimer?.invalidate()
        saveTimer = nil
        let url = storeDir.appendingPathComponent(Self.filename)
        let encoded: Data
        do {
            encoded = try JSONEncoder().encode([state])
        } catch {
            return   // encode failure is rare + non-fatal; window stays in memory
        }
        DataStore.performAtomicWrite(data: encoded, to: url, filename: Self.filename) { _ in }
    }

    // MARK: - Test seams

    /// Synchronous round-trip helper for persistence tests: flush now and
    /// reload from disk into a fresh state.
    func flushSaveAndReloadForTesting() {
        // Encode + write synchronously so the test can read immediately.
        let url = storeDir.appendingPathComponent(Self.filename)
        if let encoded = try? JSONEncoder().encode([state]) {
            try? encoded.write(to: url, options: .atomic)
        }
        let loaded = DataStore.readFile(
            AdaptivePracticeState.self, from: Self.filename, in: storeDir)
        state = loaded.items.first ?? AdaptivePracticeState()
    }
}

// MARK: - Question → intrinsic band

extension Question {
    /// The question's intrinsic difficulty band. Honours the authored
    /// `difficulty` (1 = recall … 5 = evaluate/create) when it's in range;
    /// otherwise infers from prompt length + option count (a longer prompt
    /// with more options reads as harder). Big-Sur-safe pure mapping.
    var intrinsicBand: DifficultyBand {
        switch difficulty {
        case 1:        return .easy
        case 2, 3:     return .core
        case 4:        return .stretch
        case 5...:     return .challenge
        default:       return Self.inferBand(promptLength: prompt.count,
                                             optionCount: options?.count ?? 0)
        }
    }

    /// Fallback band inference when `difficulty` is absent / out of range.
    static func inferBand(promptLength: Int, optionCount: Int) -> DifficultyBand {
        // Combine a length signal (short recall vs long applied) and the
        // option count (more distractors = harder discrimination).
        let lengthScore = promptLength >= 160 ? 2 : (promptLength >= 80 ? 1 : 0)
        let optionScore = optionCount >= 5 ? 1 : 0
        switch lengthScore + optionScore {
        case 0:  return .easy
        case 1:  return .core
        case 2:  return .stretch
        default: return .challenge
        }
    }
}
