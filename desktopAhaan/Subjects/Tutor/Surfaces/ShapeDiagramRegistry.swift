import SwiftUI
import AppKit

// MARK: - ShapeDiagramRegistry
//
// Lookup table mapping a `MediaAsset.resource` string (used when the
// asset's `kind == .shapeDiagram`) to a SwiftUI view factory that
// renders the diagram.
//
// State today (2026-05-23): the registry is intentionally EMPTY —
// authoring 76 chapter-specific shape diagrams was out of scope for
// the surface-the-content session. `MediaAssetView` falls back to a
// placeholder card for unregistered keys, so packs ship cleanly even
// without entries here.
//
// Adding a new diagram:
//   1. Build the view (e.g. a SwiftUI Shape composition) — typically
//      a few dozen lines.
//   2. Register it under its `resource` key by adding an entry to
//      `Self.registrations`.
//   3. Re-build; the chapter's MediaAssetGallery picks it up
//      automatically.

enum ShapeDiagramRegistry {
    typealias Factory = () -> AnyView

    /// Returns the factory for `key`, or nil if no diagram has been
    /// registered for that resource id. `MediaAssetView` shows a
    /// placeholder when nil.
    static func factory(for key: String) -> Factory? {
        return registrations[key]
    }

    /// Map of registered diagrams. Populated one chapter-slice at a time
    /// (v7 Phase 3). Keys follow `chNN_<short_name>`, matching the JSON
    /// `resource` values of each `shapeDiagram` MediaAsset. Unregistered
    /// keys still render the placeholder card cleanly.
    private static let registrations: [String: Factory] = [
        // ch01 — Nutrition in Plants
        "ch01_chloroplast": { AnyView(ChloroplastDiagram()) },
        "ch01_stomata": { AnyView(StomataDiagram()) },
        "ch01_photosynthesis_equation": { AnyView(PhotosynthesisEquationDiagram()) },
        "ch01_leaf_anatomy": { AnyView(LeafAnatomyDiagram()) },
        // ch02 — Nutrition in Animals
        "ch02_digestive_system": { AnyView(DigestiveSystemDiagram()) },
        "ch02_villi": { AnyView(VilliDiagram()) },
        "ch02_tooth_types": { AnyView(ToothTypesDiagram()) },
        "ch02_rumen": { AnyView(RumenDiagram()) },
        // ch03 — Fibre to Fabric (wool & silk)
        "ch03_wool_process": { AnyView(WoolProcessDiagram()) },
        "ch03_silkworm_lifecycle": { AnyView(SilkwormLifecycleDiagram()) },
        "ch03_polymer_chain": { AnyView(PolymerChainDiagram()) },
        "ch03_fibre_compare": { AnyView(FibreCompareDiagram()) },
        // ch04 — Heat
        "ch04_thermometer": { AnyView(ThermometerDiagram()) },
        "ch04_three_modes": { AnyView(ThreeModesDiagram()) },
        "ch04_thermos_flask": { AnyView(ThermosFlaskDiagram()) },
        "ch04_sea_breeze": { AnyView(SeaBreezeDiagram()) },
        // ch05 — Acids, Bases and Salts
        "ch05_ph_scale": { AnyView(PHScaleDiagram()) },
        "ch05_neutralisation": { AnyView(NeutralisationDiagram()) },
        "ch05_indicators": { AnyView(IndicatorsDiagram()) },
        "ch05_tooth_decay": { AnyView(ToothDecayDiagram()) }
    ]

    /// Resource keys with a registered diagram (sorted). Exposed so a test
    /// can assert the covered set without reflecting over the private map.
    static var registeredKeys: [String] { registrations.keys.sorted() }
}
