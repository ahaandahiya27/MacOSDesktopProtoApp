import Foundation

/// An ordered timeline (or step diagram) for a multi-step process —
/// digestion, photosynthesis, water cycle, life cycle. Chapter floor
/// ≥ 1 per chapter where applicable.
///
/// Named `ContentTimeline` rather than `ProcessTimeline` to avoid
/// colliding with the existing top-level View `ProcessTimeline` at
/// `desktopAhaan/Subjects/Tutor/Discover/Components/ProcessTimeline.swift`
/// (which renders timeline-style UI in Discover scenes). This Codable
/// is the data side; the View is the rendering side.
struct ContentTimeline: Codable, Hashable, Identifiable {
    let id: String                   // e.g. "ch01_tl01"
    let title: String                // "The photosynthesis pipeline"
    let intro: String?               // optional 1–2 sentence preface
    let steps: [TimelineStep]
    let relatedConceptIds: [String]?
}

/// One step in a `ContentTimeline`. 1–2 sentences per step per the
/// §C.4 style guide.
struct TimelineStep: Codable, Hashable, Identifiable {
    let id: String                   // e.g. "ch01_tl01_s01"
    let label: String                // short title shown above the body
    let body: String                 // 1–2 sentences
    /// Optional asset hint matching the same shape as GalleryItem.
    let assetHint: String?
}
