import Foundation

/// A loaded study pack — one subject (Sanskrit, Science, Math, …) for one
/// grade. The app's `SubjectRegistry` discovers and decodes one of these from
/// every JSON file in `Subjects/Packs/`.
struct SubjectPack: Codable, Hashable, Identifiable {
    /// Stable id (e.g. "science_class7"). Becomes the JSON filename and the
    /// SwiftData key for per-pack user state.
    let id: String

    let title: String
    let subtitle: String
    let language: String
    let grade: Int
    /// A single emoji used on the sidebar tile, e.g. "🔬".
    let coverEmoji: String
    /// Semver string. Bumped by the content pipeline on every regeneration.
    let version: String
    /// ISO-8601 timestamp from the pipeline.
    let generatedAt: String
    let chapters: [Chapter]

    // MARK: - Computed metrics — used by Settings AND the sidebar tile
    //
    // Previously these did a nested `chapters.reduce { topics.reduce { ... } }`
    // on every access. The sidebar's pack row re-renders on every DataStore
    // publish (translation insert, quiz attempt, bookmark toggle), so on the
    // legacy iMac with 19 chapters × ~3 topics × 250+ concepts this was ~5 ms
    // of pointless work per render, per pack. Now: route through the
    // already-cached `allConcepts` / `allQuestions` arrays, so first access
    // is O(n) and every subsequent access is O(1).

    var conceptCount: Int { allConcepts.count }

    var questionCount: Int { allQuestions.count }

    var topicCount: Int {
        chapters.reduce(0) { $0 + $1.topics.count }
    }

    /// All concepts flattened — convenient for global search. Cached via
    /// `SubjectPackIndexCache` so SearchView's debounced query path doesn't
    /// rebuild the flat array on every keystroke (and so internal cache
    /// builders like `conceptIndex` / `needsHumanReviewIds` reuse it).
    var allConcepts: [Concept] {
        SubjectPackIndexCache.shared.allConcepts(for: self)
    }

    /// All questions flattened. Cached — see `allConcepts`.
    var allQuestions: [Question] {
        SubjectPackIndexCache.shared.allQuestions(for: self)
    }

    fileprivate func buildAllConcepts() -> [Concept] {
        chapters.flatMap { $0.topics.flatMap { $0.concepts } }
    }

    fileprivate func buildAllQuestions() -> [Question] {
        chapters.flatMap { $0.topics.flatMap { $0.questions } }
    }

    // MARK: - Lookup tables (process-wide cached by pack.id)
    //
    // **Performance**: Previously these computed properties did a full
    // `chapters.flatMap { ... }` + `Dictionary(uniquingKeysWith:)` build on
    // EVERY access — and the call-sites (ConceptDetailView, BookmarksView
    // row resolution, QuizBank filter, RelatedConcepts lookup) hit them
    // many times per body render. On a ~250-concept / ~640-question
    // Science pack this was ~5–10 ms of main-thread work per render on the
    // 1.4 GHz iMac, which the user observed as CTA-tap freezes.
    //
    // Now cached process-wide by `pack.id`. Packs are immutable after
    // SubjectRegistry decode; on reload (rare, only at app launch or
    // explicit Retry), the registry calls `invalidateIndexCaches(for:)`.
    // Cache access is serialised via a NSLock so the rare cross-thread
    // call (Task.detached decode → MainActor publish) doesn't race.

    /// Concept ID → Concept lookup. Built once per `pack.id` per process.
    ///
    /// Duplicate-key safe: if the content pack contains two concepts with the
    /// same `id` (a data bug), keep the first occurrence and log the collision
    /// rather than crashing the whole app.
    var conceptIndex: [String: Concept] {
        SubjectPackIndexCache.shared.conceptIndex(for: self)
    }

    /// Question ID → Question lookup. Built once per `pack.id` per process.
    /// Duplicate-key safe — see `conceptIndex` above.
    var questionIndex: [String: Question] {
        SubjectPackIndexCache.shared.questionIndex(for: self)
    }

    /// Set of question IDs flagged `needsHumanReview` in the JSON pack.
    /// Cached so the sidebar's "needs review" count can be
    /// `needsHumanReviewIds.subtracting(reviewedQuestionIds).count` —
    /// O(needs-review-set-size) instead of walking every chapter / topic /
    /// question per sidebar render. (~640 questions × 2 packs = 1280 calls
    /// removed from the main thread on every dataStore publish.)
    var needsHumanReviewIds: Set<String> {
        SubjectPackIndexCache.shared.needsHumanReviewIds(for: self)
    }

    /// Chapter ID → Chapter lookup. Replaces `pack.chapters.first(where:)`
    /// scans in TutorNavigation, ChapterListView, DiscoverProgressDashboard,
    /// etc. — was O(chapters.count) per call.
    var chapterIndex: [String: Chapter] {
        SubjectPackIndexCache.shared.chapterIndex(for: self)
    }

    fileprivate func buildChapterIndex() -> [String: Chapter] {
        // uniquingKeysWith over uniqueKeysWithValues — a duplicate chapter
        // id in a hand-edited pack would fatally crash here otherwise.
        // Test coverage exists (`testNoDuplicateChapterIdsInPack`), but the
        // runtime path should be soft so a typo in content never wipes
        // the morning's session.
        let packId = id
        return Dictionary(chapters.map { ($0.id, $0) }, uniquingKeysWith: { first, _ in
            CrashReporter.shared.logDataIssue("Duplicate chapter id in pack \(packId): \(first.id) — keeping first")
            return first
        })
    }

    // The three build functions below intentionally iterate `chapters`
    // directly rather than going through `allConcepts` / `allQuestions`.
    // **Why:** these are invoked by `SubjectPackIndexCache` from INSIDE a
    // held NSLock. Re-entering the cache from inside the lock (which is
    // what `allConcepts` / `allQuestions` do via the cache shim) deadlocks
    // immediately on Big Sur — NSLock is non-recursive, so a same-thread
    // re-acquisition blocks forever. This was the cause of the iMac
    // launch-time freeze (Thread 1 stuck in `allQuestions(for:)` called
    // from `buildAllNeedsHumanReviewIds`). DO NOT replace these with
    // `allConcepts` / `allQuestions` calls — keep them self-contained.

    fileprivate func buildNeedsHumanReviewIds() -> Set<String> {
        var ids: Set<String> = []
        for chapter in chapters {
            for topic in chapter.topics {
                for question in topic.questions where question.needsHumanReview {
                    ids.insert(question.id)
                }
            }
        }
        return ids
    }

    /// Builds the underlying concept dictionary. Only called by the cache
    /// on first access for a given pack.id.
    fileprivate func buildConceptIndex() -> [String: Concept] {
        var index: [String: Concept] = [:]
        for chapter in chapters {
            for topic in chapter.topics {
                for concept in topic.concepts {
                    if index[concept.id] != nil {
                        CrashReporter.shared.logDataIssue(
                            "duplicate Concept.id '\(concept.id)' in pack '\(self.id)'"
                        )
                        continue
                    }
                    index[concept.id] = concept
                }
            }
        }
        return index
    }

    /// Builds the underlying question dictionary. Only called by the cache
    /// on first access for a given pack.id.
    fileprivate func buildQuestionIndex() -> [String: Question] {
        var index: [String: Question] = [:]
        for chapter in chapters {
            for topic in chapter.topics {
                for question in topic.questions {
                    if index[question.id] != nil {
                        CrashReporter.shared.logDataIssue(
                            "duplicate Question.id '\(question.id)' in pack '\(self.id)'"
                        )
                        continue
                    }
                    index[question.id] = question
                }
            }
        }
        return index
    }

    /// Walk every concept's `relatedConceptIds` and `relatedQuestionIds`
    /// and log any reference that doesn't resolve in this pack. Called
    /// once by SubjectRegistry after successful decode; orphans are
    /// silently dropped by `compactMap` in the UI, so this is the only
    /// way they surface anywhere visible.
    func validateRelatedRefs() {
        let conceptIds = Set(allConcepts.map { $0.id })
        let questionIds = Set(allQuestions.map { $0.id })
        var orphanConcepts = 0
        var orphanQuestions = 0
        for concept in allConcepts {
            for rid in concept.relatedConceptIds where !conceptIds.contains(rid) {
                orphanConcepts += 1
            }
            for rid in concept.relatedQuestionIds where !questionIds.contains(rid) {
                orphanQuestions += 1
            }
        }
        if orphanConcepts > 0 || orphanQuestions > 0 {
            CrashReporter.shared.logDataIssue(
                "SubjectPack '\(id)' has \(orphanConcepts) orphan concept refs and \(orphanQuestions) orphan question refs in relatedConceptIds/relatedQuestionIds"
            )
        }
    }
}

// MARK: - Process-wide pack-index cache

/// Holds `pack.id → [String: Concept]` and `pack.id → [String: Question]`
/// lookups so SwiftUI body recomputes don't rebuild the dictionaries on
/// every render. Thread-safe via NSLock — packs are immutable after
/// SubjectRegistry decode, so concurrent reads from main thread + the
/// detached decode task are safe with a single shared lock.
///
/// Invalidated explicitly by `SubjectRegistry.reload()` so a future
/// content reload picks up fresh data.
final class SubjectPackIndexCache {
    static let shared = SubjectPackIndexCache()

    private let lock = NSLock()
    private var conceptIndices: [String: [String: Concept]] = [:]
    private var questionIndices: [String: [String: Question]] = [:]
    private var needsHumanReviewIdSets: [String: Set<String>] = [:]
    private var chapterIndices: [String: [String: Chapter]] = [:]
    private var allConceptsCache: [String: [Concept]] = [:]
    private var allQuestionsCache: [String: [Question]] = [:]

    func conceptIndex(for pack: SubjectPack) -> [String: Concept] {
        lock.lock(); defer { lock.unlock() }
        if let cached = conceptIndices[pack.id] {
            return cached
        }
        let built = pack.buildConceptIndex()
        conceptIndices[pack.id] = built
        return built
    }

    func questionIndex(for pack: SubjectPack) -> [String: Question] {
        lock.lock(); defer { lock.unlock() }
        if let cached = questionIndices[pack.id] {
            return cached
        }
        let built = pack.buildQuestionIndex()
        questionIndices[pack.id] = built
        return built
    }

    func needsHumanReviewIds(for pack: SubjectPack) -> Set<String> {
        lock.lock(); defer { lock.unlock() }
        if let cached = needsHumanReviewIdSets[pack.id] {
            return cached
        }
        let built = pack.buildNeedsHumanReviewIds()
        needsHumanReviewIdSets[pack.id] = built
        return built
    }

    func chapterIndex(for pack: SubjectPack) -> [String: Chapter] {
        lock.lock(); defer { lock.unlock() }
        if let cached = chapterIndices[pack.id] {
            return cached
        }
        let built = pack.buildChapterIndex()
        chapterIndices[pack.id] = built
        return built
    }

    func allConcepts(for pack: SubjectPack) -> [Concept] {
        lock.lock(); defer { lock.unlock() }
        if let cached = allConceptsCache[pack.id] {
            return cached
        }
        let built = pack.buildAllConcepts()
        allConceptsCache[pack.id] = built
        return built
    }

    func allQuestions(for pack: SubjectPack) -> [Question] {
        lock.lock(); defer { lock.unlock() }
        if let cached = allQuestionsCache[pack.id] {
            return cached
        }
        let built = pack.buildAllQuestions()
        allQuestionsCache[pack.id] = built
        return built
    }

    /// Drops any cached indices. Called by `SubjectRegistry.reload()` so
    /// post-reload pack content isn't read through a stale dictionary.
    func invalidateAll() {
        lock.lock(); defer { lock.unlock() }
        conceptIndices.removeAll()
        questionIndices.removeAll()
        needsHumanReviewIdSets.removeAll()
        chapterIndices.removeAll()
        allConceptsCache.removeAll()
        allQuestionsCache.removeAll()
    }
}
