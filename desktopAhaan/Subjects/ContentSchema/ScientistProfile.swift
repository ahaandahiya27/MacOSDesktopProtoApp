import Foundation

/// Story-mode mini-biography of a scientist relevant to the chapter.
/// 120–200 words narrative. Chapter floor ≥ 1 per chapter. India-
/// context profiles (J. C. Bose, C. V. Raman, Salim Ali, etc.) are
/// preferred where they fit.
struct ScientistProfile: Codable, Hashable, Identifiable {
    let id: String                   // e.g. "ch01_sci01"
    let name: String                 // "Jagadish Chandra Bose"
    let lifespan: String?            // "1858–1937"
    let nationality: String?         // "Indian"
    /// The single sentence or claim this scientist is being remembered
    /// for in this chapter's context. UI uses it as a card subtitle.
    let oneLineLegacy: String
    /// 120–200 word story-mode narrative.
    let narrative: String
    let relatedConceptIds: [String]?
}
