import Foundation

/// A "what would happen if…?" speculative card. 1-line question + 3–5
/// sentence guided answer. Chapter floor ≥ 3 per chapter. Encourages
/// the kid to think through a counterfactual before reading the answer.
struct WhatIfScenario: Codable, Hashable, Identifiable {
    let id: String                   // e.g. "ch01_wi01"
    let question: String             // "What if plants couldn't photosynthesise?"
    let answer: String               // 3–5 sentence guided answer
    let relatedConceptIds: [String]?
}
