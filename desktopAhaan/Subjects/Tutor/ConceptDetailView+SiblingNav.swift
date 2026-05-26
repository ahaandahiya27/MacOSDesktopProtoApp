import Foundation

/// Static helper that finds the previous / next sibling concept
/// within the same topic. Used by `ConceptDetailView`'s toolbar
/// prev/next buttons (added 2026-05-26) so the kid can step
/// through a topic without bouncing back to the chapter list.
///
/// Sibling ordering is taken straight from the JSON pack —
/// `chapter.topics[i].concepts` is authored in pedagogical order,
/// so "next" means "next in the curriculum", not alphabetical.
///
/// `ConceptDetailView` already has a `location` walker that finds
/// the owning chapter+topic for a concept; this helper layers on
/// the index-finding without re-walking the entire pack.
enum ConceptSiblings {

    /// Result of resolving siblings — exposes the prev/next ids
    /// (nil at edges) plus the index for telemetry / accessibility
    /// hints ("Concept 3 of 5").
    struct Resolved {
        let prevId: String?
        let nextId: String?
        let index: Int      // 0-based
        let total: Int
    }

    /// Resolves the siblings for `conceptId` within `pack`. Returns
    /// nil if the concept isn't found in any topic.
    static func resolve(conceptId: String, in pack: SubjectPack) -> Resolved? {
        for chapter in pack.chapters {
            for topic in chapter.topics {
                guard let idx = topic.concepts.firstIndex(where: { $0.id == conceptId }) else {
                    continue
                }
                let prev = idx > 0 ? topic.concepts[idx - 1].id : nil
                let next = idx + 1 < topic.concepts.count ? topic.concepts[idx + 1].id : nil
                return Resolved(prevId: prev,
                                nextId: next,
                                index: idx,
                                total: topic.concepts.count)
            }
        }
        return nil
    }
}
