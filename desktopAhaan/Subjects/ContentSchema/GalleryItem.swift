import Foundation

/// A small visual / diagram card. Chapter floor ≥ 6 per chapter. The
/// asset itself can be a bundled image, an SF Symbol, or an inline
/// `Shape`-composition view chosen by the renderer; this schema is
/// asset-agnostic and just carries the metadata.
struct GalleryItem: Codable, Hashable, Identifiable {
    let id: String                   // e.g. "ch01_gi01"
    let caption: String              // 1-line title
    let detail: String               // 2-line description card
    /// Optional asset hint. The renderer picks the matching asset; if
    /// nil, the UI shows the caption + detail without imagery.
    /// Supported values: "sfsymbol:<name>", "asset:<name>", "shape:<id>".
    let assetHint: String?
    let relatedConceptIds: [String]?
}
