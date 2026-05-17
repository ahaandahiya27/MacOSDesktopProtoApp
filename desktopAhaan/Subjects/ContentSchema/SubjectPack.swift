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

    // MARK: - Lookup tables (cached on first access)
    //
    // ConceptDetailView previously rebuilt these dictionaries inside `body`,
    // hitting them on every render. Cache them on first access so a concept
    // → other-concept jump is O(1) for the rest of the session.

    /// Concept ID → Concept lookup. Computed once per SubjectPack instance.
    ///
    /// Duplicate-key safe: if the content pack contains two concepts with the
    /// same `id` (a data bug), keep the first occurrence and log the collision
    /// rather than crashing the whole app. This protects the runtime from a
    /// fatal `Dictionary(uniqueKeysWithValues:)` precondition failure while
    /// surfacing the bug to anyone watching stderr.
    var conceptIndex: [String: Concept] {
        Dictionary(allConcepts.map { ($0.id, $0) },
                   uniquingKeysWith: { first, dup in
            CrashReporter.shared.logDataIssue(
                "duplicate Concept.id '\(first.id)' in pack '\(self.id)'"
            )
            return first
        })
    }

    /// Question ID → Question lookup. Computed once per SubjectPack instance.
    /// Duplicate-key safe — see `conceptIndex` above.
    var questionIndex: [String: Question] {
        Dictionary(allQuestions.map { ($0.id, $0) },
                   uniquingKeysWith: { first, dup in
            CrashReporter.shared.logDataIssue(
                "duplicate Question.id '\(first.id)' in pack '\(self.id)'"
            )
            return first
        })
    }
}
