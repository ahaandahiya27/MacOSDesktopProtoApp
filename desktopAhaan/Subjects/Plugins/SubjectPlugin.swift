import SwiftUI

// MARK: - SubjectPlugin
//
// First step (S1) of the SCALE_PLAN: a single protocol every subject
// (current: Sanskrit Kosh + Science Class 7; future: Math, Hindi,
// English, History) implements. The app's sidebar, search, daily
// practice, and discover-progress views will read from a registry of
// `SubjectPlugin`s rather than hard-coding `subject.id == "science_class7"`
// switches.
//
// This file is **pure addition**. No existing call site is touched.
// The protocol is unimplemented at the moment; S5 of the scale plan
// wraps the existing `SubjectPack` flow in plugins one subject at a
// time, with snapshot-ratchet gating to guarantee pixel-identical
// behaviour before/after.
//
// Design notes:
//
//   - `id` matches the JSON pack's id ("science_class7", "sanskrit_class7")
//     so persistence keys (`DataStore.discoverProgress[subjectId]`) line
//     up trivially. Never rename existing ids — that would break student
//     progress for free.
//   - `displayName` and `icon` drive the sidebar row. Kept light so a
//     subject can ship without art.
//   - `packURL` points at the JSON pack the subject loads from. Loading
//     itself stays in `SubjectRegistry` — the plugin only provides the
//     URL, not the load semantics.
//   - `chapter(at:)` lets the registry enumerate without exposing the
//     concrete `ChapterPlugin` array. A nil return means "the chapter
//     exists in JSON but has no Swift-side plugin" — `GenericChapterView`
//     handles those (S7 of the scale plan).
//   - `chapterCount` is separate from `chapter(at:)` so the sidebar can
//     render its row count before lazily resolving each chapter plugin.
//
// Big Sur target: this file uses only protocol + `URL` + `Image` (both
// macOS 11). No `@Observable`, no `Image.swiftui-only modifiers`, no
// macOS 12+ APIs. Lint should stay green.

/// A subject (Sanskrit Kosh, Science Class 7, future Math, Hindi, etc.)
/// declared as a swappable plugin. The app's chapter and topic surfaces
/// read from a list of these instead of hard-coded `switch subject.id`
/// branches.
///
/// Implementation order — see `SCALE_PLAN.md`:
///   1. Define this protocol (S1, this file).
///   2. Define `ChapterPlugin` (S2, sibling file).
///   3. Define `ChapterManifest` (S3, sibling file).
///   4. Build `SubjectsRegistry` and register Sanskrit + Science (S4).
///   5. Wrap each existing chapter in an adapter (S5).
///   6. Replace hard-coded `Chapter{N}View` references with iteration
///      over the registry (S6).
///   7. Implement `GenericChapterView` for JSON-only chapters (S7).
protocol SubjectPlugin {
    /// Stable identifier — matches the JSON pack's `id` field and the
    /// persistence-key namespace in `DataStore`. NEVER renamed without a
    /// `runSchemaMigrationsIfNeeded()` step in the same commit.
    var id: String { get }

    /// Human-readable name shown in the sidebar (e.g. "Sanskrit Kosh",
    /// "Science — Class 7").
    var displayName: String { get }

    /// Subtitle / publisher tag shown under the displayName. Optional —
    /// return `nil` to hide the second line.
    var subtitle: String? { get }

    /// URL of the JSON pack the subject loads from. The registry's
    /// loader (not the plugin) is responsible for decoding.
    var packURL: URL { get }

    /// SF Symbol name used as the sidebar icon. Routed through
    /// `SFSymbolCompat.name(_:)` to keep Big Sur happy with the SF
    /// Symbols 2 baseline.
    var iconSymbolName: String { get }

    /// Number of chapters the subject ships with. Read from the JSON
    /// pack's chapter list count, NOT from a count of registered
    /// `ChapterPlugin` instances — a chapter can exist in JSON without a
    /// Swift plugin (handled by `GenericChapterView` per S7).
    var chapterCount: Int { get }

    /// Returns the `ChapterPlugin` for the given 0-based chapter index,
    /// or nil if the chapter exists in JSON but has no Swift plugin.
    /// The caller falls back to `GenericChapterView` on nil.
    func chapter(at index: Int) -> ChapterPlugin?
}
