import Foundation

/// "I understand this" tracking per concept. The kid toggles it
/// from `ConceptDetailView`'s toolbar; `ChapterRow` shows the
/// per-chapter count ("5/8 understood") so progress is visible
/// from the chapter list without drilling into Mastery.
///
/// Distinct from:
///   - `studyBookmarks` — "save for later", not progress.
///   - `questionReviews` (SM-2) — what's *due*, computed from
///     spaced-repetition timestamps.
///   - `readArticleIds` — article-finished, not concept-understood.
///
/// Sister file to keep DataStore.swift from growing further past
/// the grandfathered ceiling. Mirrors the `+ArticleReads` pattern
/// (commit 173f9e7).
extension DataStore {
    func isConceptUnderstood(_ conceptId: String) -> Bool {
        understoodConceptIds.contains(conceptId)
    }

    /// Toggles the understood flag. The @Published set publishes on
    /// mutation so any view bound to `dataStore` re-renders the
    /// affected indicator. Save is explicit + atomic — same as
    /// `toggleArticleRead` (no coalescing needed at this volume).
    func toggleConceptUnderstood(_ conceptId: String) {
        if understoodConceptIds.contains(conceptId) {
            understoodConceptIds.remove(conceptId)
        } else {
            understoodConceptIds.insert(conceptId)
        }
        scheduleUnderstoodSave()
    }

    /// Insert-only — used when something else wants to mark a
    /// concept understood without checking the prior state (e.g.
    /// a future "Mark all in topic" gesture). Idempotent.
    func markConceptUnderstood(_ conceptId: String) {
        guard !understoodConceptIds.contains(conceptId) else { return }
        understoodConceptIds.insert(conceptId)
        scheduleUnderstoodSave()
    }

    /// Count of understood concepts within a specific chapter — the
    /// fast accessor that `ChapterRow` uses. Filters by the chapter
    /// prefix in the concept id (the pack convention is
    /// `chXX_tYY_cZZ`).
    func understoodCount(forChapterId chapterId: String) -> Int {
        let prefix = "\(chapterId)_"
        return understoodConceptIds.lazy.filter { $0.hasPrefix(prefix) }.count
    }

    private func scheduleUnderstoodSave() {
        save(Array(understoodConceptIds), to: "understoodConceptIds.json")
    }
}
