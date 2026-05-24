import Foundation

/// Where a `Question` came from in the kid's learning surface.
///
/// Added 2026-05-24 as part of the learning-loop session — the SRS
/// scheduler now captures answers from three places, and the dashboard
/// + recently-missed surfaces sometimes need to know which one when
/// resolving the source row for "Retry":
///
///   - `.bookEnd` — the textbook-canonical Practice Question. This is
///     the default for any decoded `Question` whose JSON omits the
///     `source` field, so the existing 732 questions in
///     `science_class7.json` continue to decode untouched.
///   - `.bossQuiz` — a hand-authored Boss Quiz MCQ from one of the 19
///     `Scene9_BossQuiz*` views. Ephemeral — these aren't in the pack
///     JSON yet; the SRS layer references them by a stable synthetic
///     id (`bossquiz_chNN_qII`).
///   - `.sceneQuickCheck` — a quick-check MCQ embedded inside a
///     Discover scene. Same ephemeral pattern as boss quizzes; not
///     yet wired this session but the case lands for future
///     instrumentation.
///
/// The enum is `String`-backed for stable JSON round-tripping; raw
/// values stay lowercase + underscore-separated to match the authoring
/// style used by the rest of the pack (`questionType`, `gradeLevel`,
/// `mediaAssetKind`).
enum QuestionSource: String, Codable, Hashable, CaseIterable {
    case bookEnd          = "book_end"
    case bossQuiz         = "boss_quiz"
    case sceneQuickCheck  = "scene_quick_check"

    /// Default for backwards compatibility — questions decoded from
    /// the existing science_class7.json have no `source` field, so
    /// `Question.init(from:)` defaults to this value when the key is
    /// absent. Don't change the raw value without a schema migration.
    static let `default`: QuestionSource = .bookEnd
}
