import Foundation

// MARK: - ConceptMap
//
// Per-chapter node-and-edge graph describing how the chapter's
// concepts connect — and how they reach across to other chapters.
// Rendered by `ConceptMapView` (chapter-agnostic Component, promoted
// from the Ch.1 pilot's `Ch1ConceptMap` once all 19 chapters had
// authored conceptMap data).
//
// Backwards-compatible: `Chapter.conceptMap` is Optional and defaults
// to nil. When absent, the concept-map surface auto-hides and a
// future-session UI can fall back to deriving edges from
// `concept.relatedConceptIds`.
//
// Added 2026-05-23 as part of the Ch.1 pilot.

struct ConceptMap: Codable, Hashable {
    let nodes: [ConceptMapNode]
    let edges: [ConceptMapEdge]
}

struct ConceptMapNode: Codable, Hashable, Identifiable {
    /// Concept id within the chapter, OR a cross-chapter pointer in
    /// `chXX:concept_id` form (e.g. "ch10:ch10_t01_c01") OR a "pivot"
    /// node id like "ch01_pivot_photosynthesis" for synthesised nodes
    /// that don't map 1:1 to a concept.
    let id: String
    /// Short label shown inside the node. Kept ≤ 28 chars so a 96×40
    /// node renders cleanly.
    let label: String
    let kind: NodeKind
    /// Normalised 0..1 coordinates inside the canvas. The renderer
    /// multiplies by the canvas size at layout time, so the pack
    /// stays display-independent.
    let x: Double
    let y: Double
}

struct ConceptMapEdge: Codable, Hashable, Identifiable {
    let id: String
    let from: String                // node id
    let to: String                  // node id
    /// Optional one- or two-word relation: "needs", "produces",
    /// "feeds", "is opposite of". nil → unlabeled connector line.
    let label: String?
}

enum NodeKind: String, Codable, Hashable {
    /// A real concept in this chapter — tap to open the concept detail.
    case concept
    /// A concept in another chapter (id has the `chXX:` prefix) —
    /// rendered with a dashed border + tap navigates to that chapter.
    case crossChapter
    /// A synthesised "pivot" node (e.g. a category that's bigger than
    /// any single concept) — rendered with a tint to signal it's a
    /// grouping rather than a tap-target.
    case pivot
}
