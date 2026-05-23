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

    /// Map of registered diagrams. Today empty by design; future
    /// content sessions will populate per-chapter entries (keys
    /// follow `chNN_<short_name>`, matching JSON `resource` values).
    private static let registrations: [String: Factory] = [:]
}
