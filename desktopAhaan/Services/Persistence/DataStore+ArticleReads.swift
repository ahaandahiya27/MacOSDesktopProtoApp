import Foundation

/// Mark-as-read tracking for `ArticleIndex` entries. Surfaced as a
/// checkmark badge on `ExtraReadingRow` chips and the primary
/// `ArticleEntryButton` so the kid sees at a glance which articles
/// have already been finished.
///
/// Sister file rather than inline on `DataStore` because the four
/// mutator methods + read helper are pure article-specific logic;
/// keeping them here matches the +Loading / +Saving split pattern.
extension DataStore {
    /// True when the kid has marked the article entry as read.
    /// Returns false for unknown ids (defensive — the chip simply
    /// renders without a checkmark).
    func isArticleRead(_ articleId: String) -> Bool {
        readArticleIds.contains(articleId)
    }

    /// Toggles the read flag for an article id. The set publishes
    /// (via @Published) so any view bound to `dataStore` re-renders
    /// the chip immediately. Save is coalesced — multiple toggles
    /// in quick succession produce one disk write.
    func toggleArticleRead(_ articleId: String) {
        if readArticleIds.contains(articleId) {
            readArticleIds.remove(articleId)
        } else {
            readArticleIds.insert(articleId)
        }
        scheduleReadArticleIdsSave()
    }

    /// Inserts (doesn't toggle) — used by an auto-mark gesture
    /// like dismissing the article view after the kid scrolled
    /// to the end. Currently only the explicit footer button
    /// calls this, but the method is here for the future
    /// "auto-mark on full-scroll" feature.
    func markArticleRead(_ articleId: String) {
        guard !readArticleIds.contains(articleId) else { return }
        readArticleIds.insert(articleId)
        scheduleReadArticleIdsSave()
    }

    /// Persist immediately. Matches the explicit save pattern used
    /// for `toughQuestionIds` in DataStore.swift — atomic write,
    /// no coalescing because the volume is tiny (max ~200 ids).
    private func scheduleReadArticleIdsSave() {
        save(Array(readArticleIds), to: "readArticleIds.json")
    }
}
