import Foundation

/// A hands-on experiment a kid can run at home. Chapter floor ≥ 2 per
/// chapter. The schema mirrors `HomeExperiment` (used inside
/// `ChapterDetailView+HomeExperiments.swift`) so both can coexist; this
/// version is the JSON-pack-backed companion that lets new mini-
/// projects ship without code edits.
struct MiniProject: Codable, Hashable, Identifiable {
    let id: String                   // e.g. "ch01_mp01"
    let emoji: String                // single-emoji "icon"
    let title: String
    let needs: [String]              // materials list
    let steps: [String]              // 5–8 numbered steps
    let expectedObservation: String  // 1–2 sentence "what you'll see"
    let whyItWorks: String           // 2–4 sentence explanation
    let estimatedMinutes: Int
    let relatedConceptIds: [String]?
}
