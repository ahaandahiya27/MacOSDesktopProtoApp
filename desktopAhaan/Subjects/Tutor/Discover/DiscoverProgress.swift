import Foundation
import SwiftData

/// Tracks scene-level completion of the chapter-specific Discover Mode
/// experience. One row per (chapterId, sceneId). The compound id makes
/// look-ups O(1) and prevents duplicate rows.
///
/// The model is intentionally subject-agnostic (no FK to SubjectPack) — the
/// chapterId already namespaces things, and packs are identified by their
/// stable string id, not by any database row.
@Model
final class DiscoverProgress {
    /// Compound key: "<chapterId>::<sceneId>" — e.g. "ch01::scene3".
    @Attribute(.unique) var id: String
    var chapterId: String
    var sceneId: String
    var completedAt: Date
    /// Optional score for game-style scenes. nil for non-scored scenes.
    var score: Int?
    /// Optional max possible score (the denominator).
    var maxScore: Int?

    init(chapterId: String, sceneId: String, score: Int? = nil, maxScore: Int? = nil) {
        self.id = "\(chapterId)::\(sceneId)"
        self.chapterId = chapterId
        self.sceneId = sceneId
        self.completedAt = Date()
        self.score = score
        self.maxScore = maxScore
    }
}
