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

    // MARK: - Computed metrics — used by Settings to show pack size at a glance

    var conceptCount: Int {
        chapters.reduce(0) { $0 + $1.topics.reduce(0) { $0 + $1.concepts.count } }
    }

    var questionCount: Int {
        chapters.reduce(0) { $0 + $1.topics.reduce(0) { $0 + $1.questions.count } }
    }

    var topicCount: Int {
        chapters.reduce(0) { $0 + $1.topics.count }
    }

    /// All concepts flattened — convenient for global search.
    var allConcepts: [Concept] {
        chapters.flatMap { $0.topics.flatMap { $0.concepts } }
    }

    /// All questions flattened.
    var allQuestions: [Question] {
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

    fileprivate func buildNeedsHumanReviewIds() -> Set<String> {
        Set(allQuestions.lazy.filter { $0.needsHumanReview }.map { $0.id })
    }

    /// Builds the underlying concept dictionary. Only called by the cache
    /// on first access for a given pack.id.
    fileprivate func buildConceptIndex() -> [String: Concept] {
        Dictionary(allConcepts.map { ($0.id, $0) },
                   uniquingKeysWith: { first, _ in
            CrashReporter.shared.logDataIssue(
                "duplicate Concept.id '\(first.id)' in pack '\(self.id)'"
            )
            return first
        })
    }

    /// Builds the underlying question dictionary. Only called by the cache
    /// on first access for a given pack.id.
    fileprivate func buildQuestionIndex() -> [String: Question] {
        Dictionary(allQuestions.map { ($0.id, $0) },
                   uniquingKeysWith: { first, _ in
            CrashReporter.shared.logDataIssue(
                "duplicate Question.id '\(first.id)' in pack '\(self.id)'"
            )
            return first
        })
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

    /// Drops any cached indices. Called by `SubjectRegistry.reload()` so
    /// post-reload pack content isn't read through a stale dictionary.
    func invalidateAll() {
        lock.lock(); defer { lock.unlock() }
        conceptIndices.removeAll()
        questionIndices.removeAll()
        needsHumanReviewIdSets.removeAll()
    }
}
