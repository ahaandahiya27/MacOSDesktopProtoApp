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
final class AppState: ObservableObject {
    @Published var isOnline: Bool = true

    /// The new top-level sidebar selection. `.subject("sanskrit_class7")`
    /// shows the Sanskrit translator wrapped in a SubjectHomeView; other
    /// subjects show the Tutor UI.
    @Published var sidebarSelection: SidebarSelection = .subject("sanskrit_class7")

    /// Sanskrit-only internal tab. Existing screens and menu commands read /
    /// write this. Don't remove.
    @Published var selectedTab: AppTab = .translate

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")

    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isOnline = path.status == .satisfied
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

// MARK: - SidebarSelection

/// The new top-level sidebar selection. Replaces the old single-axis
/// AppTab-as-sidebar model.
enum SidebarSelection: Hashable {
    case subject(String)        // packId
    case quizBank
    case tool(SidebarTool)
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
