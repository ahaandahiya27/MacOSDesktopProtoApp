import SwiftUI
import Network
import Combine

/// Central observable state for the app.
///
/// Two parallel selection axes coexist after the multi-subject expansion:
///
/// 1. `sidebarSelection` — what the user clicked in the new top-level sidebar
///    (a Subject pack id, a Tool, or nil).
/// 2. `selectedTab` — Sanskrit-only internal tab navigation (translate / scan
///    / practice / history / favorites / settings). Preserved verbatim so the
///    existing menu-bar shortcuts and Sanskrit screens keep working.
@MainActor
final class AppState: ObservableObject {
    @Published var isOnline: Bool = true

    /// The new top-level sidebar selection. `.subject("sanskrit_class7")`
    /// shows the Sanskrit translator wrapped in a SubjectHomeView; other
    /// subjects show the Tutor UI.
    ///
    /// Persisted across launches via UserDefaults so the kid returns to the
    /// same subject they were last working on.
    @Published var sidebarSelection: SidebarSelection {
        didSet { Self.persist(sidebarSelection) }
    }

    /// Sanskrit-only internal tab. Existing screens and menu commands read /
    /// write this. Don't remove.
    @Published var selectedTab: AppTab = .translate

    /// One-shot pending TutorNavigation route. Set by the ⌘K command palette
    /// (or any future caller) AFTER flipping `sidebarSelection` to the
    /// container that should host the route. The next TutorNavigationContainer
    /// to mount (or the current one, via .onChange) consumes it once and
    /// clears the slot. Deterministic alternative to NotificationCenter
    /// timing tricks.
    @Published var pendingRoute: PendingRoute? = nil

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")

    private static let sidebarSelectionKey = "sidebarSelection"

    private static func persist(_ selection: SidebarSelection) {
        UserDefaults.standard.set(selection.persistedString,
                                  forKey: sidebarSelectionKey)
    }

    private static func restored() -> SidebarSelection {
        guard let raw = UserDefaults.standard.string(forKey: sidebarSelectionKey),
              let restored = SidebarSelection(persistedString: raw)
        else { return .subject("sanskrit_class7") }
        return restored
    }

    init() {
        // Restore last sidebar selection BEFORE the first publish so the
        // app boots into the user's last context, not the default.
        sidebarSelection = Self.restored()
        monitor.pathUpdateHandler = { [weak self] path in
            let satisfied = path.status == .satisfied
            DispatchQueue.main.async { [weak self] in
                self?.isOnline = satisfied
            }
        }
        monitor.start(queue: queue)
    }

    deinit {
        monitor.cancel()
    }

    /// Convenience for menu commands that historically only set `selectedTab`.
    /// They now also need to ensure the Sanskrit subject is selected so the
    /// tab change is visible.
    func selectSanskritTab(_ tab: AppTab) {
        sidebarSelection = .subject("sanskrit_class7")
        selectedTab = tab
    }
}

// MARK: - PendingRoute

/// A route to push (with optional sibling list for Prev/Next) that arrives
/// from outside any TutorNavigationContainer — e.g. the ⌘K palette posting
/// a destination after switching the sidebar.
struct PendingRoute: Equatable {
    let route: TutorRoute
    /// Sibling questions for Prev/Next walking. Empty means no siblings.
    let siblings: [QuestionRef]

    init(route: TutorRoute, siblings: [QuestionRef] = []) {
        self.route = route
        self.siblings = siblings
    }
}

// MARK: - SidebarSelection

/// The new top-level sidebar selection. Replaces the old single-axis
/// AppTab-as-sidebar model.
enum SidebarSelection: Hashable {
    case subject(String)        // packId
    case quizBank
    case tool(SidebarTool)

    /// Stable string form for UserDefaults persistence.
    var persistedString: String {
        switch self {
        case .subject(let id):  return "subject:\(id)"
        case .quizBank:         return "quizBank"
        case .tool(let t):      return "tool:\(t.rawValue)"
        }
    }

    init?(persistedString: String) {
        if persistedString == "quizBank" {
            self = .quizBank
        } else if persistedString.hasPrefix("subject:") {
            self = .subject(String(persistedString.dropFirst("subject:".count)))
        } else if persistedString.hasPrefix("tool:") {
            let raw = String(persistedString.dropFirst("tool:".count))
            guard let t = SidebarTool(rawValue: raw) else { return nil }
            self = .tool(t)
        } else {
            return nil
        }
    }
}

enum SidebarTool: String, Hashable, CaseIterable, Identifiable {
    case search
    case bookmarks
    case settings

    var id: String { rawValue }

    var title: String {
        switch self {
        case .search:    return "Search"
        case .bookmarks: return "Bookmarks"
        case .settings:  return "Settings"
        }
    }

    var systemImage: String {
        switch self {
        case .search:    return "magnifyingglass"
        case .bookmarks: return "bookmark.fill"
        case .settings:  return "gearshape.fill"
        }
    }
}

// MARK: - AppTab (legacy, Sanskrit-internal)

enum AppTab: String, Hashable, CaseIterable, Identifiable {
    case translate
    case history
    case favorites
    case practice
    case scan
    case settings

    var id: String { rawValue }

    var title: String {
        switch self {
        case .translate: return "Translate"
        case .history:   return "History"
        case .favorites: return "Favorites"
        case .practice:  return "Practice"
        case .scan:      return "Scan"
        case .settings:  return "Settings"
        }
    }

    var systemImage: String {
        switch self {
        case .translate: return "character.book.closed"
        case .history:   return "clock.arrow.circlepath"
        case .favorites: return "heart.fill"
        case .practice:  return "graduationcap.fill"
        case .scan:      return "doc.text.viewfinder"
        case .settings:  return "gearshape.fill"
        }
    }
}
