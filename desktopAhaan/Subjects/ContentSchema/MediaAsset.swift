import Foundation

/// What kind of media this asset is — drives which backend renders it
/// inside `MediaAssetView`.
enum MediaAssetKind: String, Codable, CaseIterable {
    /// Bundled PNG / PDF in the asset catalog.
    case illustration
    /// SwiftUI Shape / Path / Canvas composition registered with
    /// `ShapeDiagramRegistry`. The `resource` is the registry key.
    case shapeDiagram
    /// Reference (by id) to an existing Discover scene that already
    /// animates this concept — the concept card surfaces a CTA that opens it.
    case animatedSceneRef
    /// Bundled MP4 in `Resources/Videos/Chapter{NN}/`. Cap: 20 s, 2 MB.
    case bundledVideo
    /// Flag that the parent text is TTS-eligible. The "resource" is nil;
    /// the resource IS the parent text the existing `TextToSpeechManager`
    /// reads aloud.
    case narratedWalkthrough
}

/// A single media asset attached to a chapter. Backward-compatible: existing
/// pack JSON without a `mediaAssets` array continues to decode unchanged.
struct MediaAsset: Codable, Identifiable, Hashable {
    let id: String
    let kind: MediaAssetKind
    /// For `.illustration`: asset-catalog name.
    /// For `.bundledVideo`: file path inside the bundle.
    /// For `.animatedSceneRef`: scene id (matches a file under `Discover/Chapter{NN}/Scenes/`).
    /// For `.shapeDiagram`: the registered view-factory id.
    /// For `.narratedWalkthrough`: nil (the parent text is the resource).
    let resource: String?
    /// One-line caption shown beneath the asset.
    let caption: String
    /// Required alt text for VoiceOver / screen reader users. Hard a11y gate:
    /// `ChapterContentTests.testMediaAssetAltTextNonTrivial` rejects entries
    /// shorter than 10 characters.
    let altText: String
    /// Optional: which concept this asset illustrates (cross-link inside the chapter).
    let parentConceptId: String?
    /// For `.bundledVideo` only — seconds. Hard cap 20.
    let durationSeconds: Double?
}
