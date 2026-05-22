import SwiftUI

// MARK: - ChapterPlugin
//
// S2 of the SCALE_PLAN. A chapter declared as a swappable plugin.
// Pure addition — no existing call site is touched yet. S5 wraps the
// existing per-chapter view files in adapters that conform to this.
//
// Each `ChapterPlugin` declares:
//   - which subject it belongs to (so the registry can enumerate
//     `subject.chapters` cleanly),
//   - its chapter number + title,
//   - its `ChapterManifest` — declaring which of the 22 module types
//     from the parity prompt §C this chapter implements,
//   - SwiftUI factory closures for each module type the manifest
//     declares ✅.
//
// Factory closures return `AnyView` to keep the protocol untyped at
// the call site. The chapter detail UI iterates the manifest and
// invokes only the factories whose module is declared present, so the
// type erasure is invoked at most ~22 times per chapter view — well
// inside the SwiftUI rendering budget.
//
// Big Sur target: only protocol + `AnyView` (macOS 10.15+). No
// `@Observable`, no `Layout` (macOS 13+), no `NavigationStack`.

protocol ChapterPlugin {
    /// Matches the parent subject's `id`. Lets the registry sanity-check
    /// "chapter belongs to declared subject" at registration time.
    var subjectId: String { get }

    /// 1-based chapter number (Ch.1, Ch.2, ..., Ch.19). Stable across
    /// JSON edits — never renumber without a `runSchemaMigrationsIfNeeded()`
    /// step.
    var chapterNumber: Int { get }

    /// Human-readable chapter title — used as the navigation title and
    /// the chapter-detail header. Sourced from JSON if the plugin
    /// doesn't override.
    var title: String { get }

    /// Declares which of the 22 module types (per parity prompt §C)
    /// this chapter implements. The chapter detail UI iterates this
    /// manifest to decide which CTAs to show.
    var manifest: ChapterManifest { get }

    // MARK: - Module factories
    //
    // Each factory is optional (returns nil when not implemented). The
    // chapter detail UI checks `manifest.has(module)` AND `factory()
    // != nil` before rendering — the dual gate keeps a stale manifest
    // (says yes, factory returns nil) from crashing the UI.

    /// Returns the Discover Mode dispatcher view (DiscoverChapter{N}View
    /// for chapters with custom scenes; nil to use GenericDiscoverView).
    func discoverView() -> AnyView?

    /// Returns the chapter's Boss Quiz view (Scene9_BossQuiz_Ch{NN}).
    func bossQuizView() -> AnyView?

    /// Returns the chapter's long-form article browser entry view, or
    /// nil to fall back to the GenericArticleListView.
    func articleEntryView() -> AnyView?
}
