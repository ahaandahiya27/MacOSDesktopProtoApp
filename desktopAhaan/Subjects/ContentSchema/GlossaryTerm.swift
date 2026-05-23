import Foundation

/// A chapter glossary entry: 1-sentence definition + optional 1-line
/// example. Chapter floor ≥ 10 per chapter.
struct GlossaryTerm: Codable, Hashable, Identifiable {
    let id: String                   // e.g. "ch01_gl01"
    let term: String                 // "Photosynthesis"
    let definition: String           // 1-sentence definition
    /// Optional 1-line concrete example or analogy.
    let example: String?
    /// Optional Hindi / Devanagari translation so a multilingual kid
    /// can recognise the term in either script.
    let hindiTerm: String?
    let relatedConceptIds: [String]?
}
