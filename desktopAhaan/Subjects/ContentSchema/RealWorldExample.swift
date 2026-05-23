import Foundation

/// A concrete real-world example tied to a chapter — a single moment
/// or scene that grounds the abstract concept in the kid's lived
/// experience (the dabba, the monsoon, the mixer-grinder). 60–100 words
/// of body text. Optionally references the concept it illustrates so
/// the UI can link back to the concept card.
struct RealWorldExample: Codable, Hashable, Identifiable {
    let id: String                   // e.g. "ch01_rw01"
    let title: String                // 1-line scene title
    let body: String                 // 60–100 words
    let relatedConceptIds: [String]? // optional cross-link
}
