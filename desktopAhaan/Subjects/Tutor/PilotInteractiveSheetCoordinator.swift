import SwiftUI

// MARK: - PilotInteractiveSheetCoordinator
//
// Owns the `presented: SheetKind?` state that ChapterDetailView
// previously held as `@State`. Extracting this lets the pilot CTAs
// (insideTheLeafTourCTA, conceptMapCTA, insideTheWireTourCTA, etc.)
// live in a sister file — they need to assign to `presented` to open
// their sheet, but private @State can't be touched from another
// file. An ObservableObject wraps the same job in an injectable
// container.
//
// Why a coordinator and not just `internal var`?
//   - `internal` would expose the state to the entire module, not
//     just the sister file. The CTAs are scoped to a single view's
//     concern; an injected coordinator preserves that scoping.
//   - SwiftUI's `.sheet(item:)` modifier needs an `Identifiable`
//     binding. Wrapping the state in a class with @Published gives
//     us a clean `$sheetCoordinator.presented` Binding, and the
//     coordinator instance can be threaded through child views as
//     a plain parameter (avoiding the `EnvironmentObject`-through-
//     `.sheet`-content trap that surfaces on Big Sur).
//
// Lineage:
//   - 2026-05-22 ish — ChapterDetailView shipped with
//     `@State private var presentedSheet: SheetKind?` and a private
//     enum.
//   - 2026-05-24 — Surface 2/3 propagation added 6 new SheetKind
//     cases and 6 new inline CTA blocks, growing the file from
//     ~600 to ~786 LOC (allowlisted with rationale).
//   - Today (later 2026-05-24) — coordinator refactor; the file
//     comes back under 600 LOC and off the allowlist.
//
// Big Sur compat:
//   - `ObservableObject` + `@Published` are macOS 10.15+ baseline.
//   - `@StateObject` (used by the view) is macOS 11+ baseline.
//   - Nothing else; pure SwiftUI state machinery.

@MainActor
final class PilotInteractiveSheetCoordinator: ObservableObject {
    /// Which enrichment sheet (if any) is currently presented on
    /// ChapterDetailView. nil → nothing presented; assigning a new
    /// value opens the corresponding sheet via `.sheet(item:)`.
    ///
    /// `@MainActor` annotation added 2026-06-05 — the class is owned
    /// by SwiftUI views (which always call modifiers on main) but
    /// nothing previously enforced the contract. A future caller
    /// that hopped off-main (Combine sink without `.receive(on:)`,
    /// background `URLSession` callback) would publish from non-main
    /// and trigger the purple "Modifying state during view update"
    /// runtime warning. Compile-time isolation now prevents that.
    @Published var presented: SheetKind?

    /// Convenience setter that defers assignment to the next runloop
    /// tick — the dismantle-order pattern documented in
    /// ChapterDetailView (around line 213 in the old layout). The
    /// commit history rationale: "SwiftUI's 'Entangling fence
    /// requested after pre-commit' warning fires when one render
    /// commit hasn't finished before the next one starts." Deferring
    /// to .main.async lets the current pre-commit finish.
    func presentDeferred(_ kind: SheetKind) {
        DispatchQueue.main.async { [weak self] in
            self?.presented = kind
        }
    }

    func dismiss() {
        presented = nil
    }
}

// MARK: - SheetKind
//
// Promoted from ChapterDetailView's private nested enum so the
// sister-file CTAs can reference it. Behaviour and case set are
// unchanged from the pre-refactor enum.
//
// SwiftUI on macOS Big Sur (11) silently drops all-but-the-last
// `.sheet(isPresented:)` modifier on a given view, so we route
// every sheet through one `.sheet(item:)`. Identifiable conformance
// is required so the .sheet(item:) modifier can key the
// re-presentation.
enum SheetKind: Identifiable {
    case homeExperiments
    case notebook
    case article(ArticleEntry)
    case glossary
    case insideTheLeafTour       // Ch.1 pilot — Phase 2B
    case conceptMap              // All-chapter generalisation (2026-05-24)
    case insideTheWireTour       // Ch.14 propagation (2026-05-24)
    case insideTheLensTour       // Ch.15 propagation (2026-05-24)
    case insideTheAlveolusTour   // Ch.10 propagation (2026-05-24)
    case insideTheXylemTour      // Ch.11 propagation (2026-05-24)
    case insideTheDigestiveTour  // Ch.2 propagation (2026-05-24)

    var id: String {
        switch self {
        case .homeExperiments:
            return "homeExperiments"
        case .notebook:
            return "notebook"
        case .article(let entry):
            return "article-\(entry.id)"
        case .glossary:
            return "glossary"
        case .insideTheLeafTour:
            return "insideTheLeafTour"
        case .conceptMap:
            return "conceptMap"
        case .insideTheWireTour:
            return "insideTheWireTour"
        case .insideTheLensTour:
            return "insideTheLensTour"
        case .insideTheAlveolusTour:
            return "insideTheAlveolusTour"
        case .insideTheXylemTour:
            return "insideTheXylemTour"
        case .insideTheDigestiveTour:
            return "insideTheDigestiveTour"
        }
    }
}
