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

    /// Recently viewed concepts and questions, newest first. Capped so the
    /// sidebar section stays compact and the UserDefaults blob stays small.
    @Published var recentItems: [RecentItem] = [] {
        didSet { Self.persistRecents(recentItems) }
    }

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")

    private static let sidebarSelectionKey = "sidebarSelection"
    private static let recentItemsKey = "recentItems"
    private static let recentItemsLimit = 8

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

    private static func persistRecents(_ items: [RecentItem]) {
        if let data = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(data, forKey: recentItemsKey)
        }
    }

    private static func restoredRecents() -> [RecentItem] {
        guard let data = UserDefaults.standard.data(forKey: recentItemsKey),
              let items = try? JSONDecoder().decode([RecentItem].self, from: data)
        else { return [] }
        return items
    }

    init() {
        // Restore last sidebar selection BEFORE the first publish so the
        // app boots into the user's last context, not the default.
        sidebarSelection = Self.restored()
        recentItems = Self.restoredRecents()
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

    // MARK: - Recents

    /// Append (or dedupe-and-promote) a recently viewed concept/question.
    /// Keeps the newest at the front and trims to `recentItemsLimit`.
    func recordRecent(_ item: RecentItem) {
        var next = recentItems.filter { $0.id != item.id }
        next.insert(item, at: 0)
        if next.count > Self.recentItemsLimit {
            next = Array(next.prefix(Self.recentItemsLimit))
        }
        recentItems = next
    }

    /// Jump to a recent item — flip the sidebar to its host subject and
    /// hand the route off to TutorNavigationContainer via pendingRoute.
    func openRecent(_ item: RecentItem) {
        sidebarSelection = .subject(item.packId)
        pendingRoute = PendingRoute(route: item.tutorRoute, siblings: [])
    }

    func clearRecents() {
        recentItems = []
    }
}

// MARK: - RecentItem

/// A lightweight pointer to a concept or question the user opened recently.
/// Persists primitives (not the TutorRoute directly) so we don't have to
/// make the route enum Codable across modules.
struct RecentItem: Identifiable, Codable, Hashable {
    enum Kind: String, Codable { case concept, question }

    let id: String
    let packId: String
    let kind: Kind
    /// conceptId or questionId, depending on `kind`.
    let routeId: String
    let title: String
    let subtitle: String
    let timestamp: Date

    init(packId: String, kind: Kind, routeId: String,
         title: String, subtitle: String,
         timestamp: Date = Date()) {
        self.id = "\(packId)::\(kind.rawValue)::\(routeId)"
        self.packId = packId
        self.kind = kind
        self.routeId = routeId
        self.title = title
        self.subtitle = subtitle
        self.timestamp = timestamp
    }

    var tutorRoute: TutorRoute {
        switch kind {
        case .concept:  return .concept(packId: packId, conceptId: routeId)
        case .question: return .question(packId: packId, questionId: routeId)
        }
    }

    var systemImage: String {
        switch kind {
        case .concept:  return "lightbulb"
        case .question: return "questionmark.circle"
        }
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
    case dailyPractice
    case mastery
    case discover
    case settings

    var id: String { rawValue }

    var title: String {
        switch self {
        case .search:        return "Search"
        case .bookmarks:     return "Bookmarks"
        case .dailyPractice: return "Daily Practice"
        case .mastery:       return "My Progress"
        case .discover:      return "Discover Progress"
        case .settings:      return "Settings"
        }
    }

    var systemImage: String {
        switch self {
        case .search:        return "magnifyingglass"
        case .bookmarks:     return "bookmark.fill"
        case .dailyPractice: return "flame.fill"
        case .mastery:       return SFSymbolCompat.name("chart.bar.xaxis")
        case .discover:      return "sparkles"
        case .settings:      return "gearshape.fill"
        }
    }

    /// Pretty-printed keyboard shortcut shown as a trailing badge in the
    /// sidebar row. Each shortcut here MUST have a matching
    /// `Button { … }.keyboardShortcut(…)` declared in `desktopAhaanApp.swift`'s
    /// `CommandGroup(after: .textEditing)` block — the sidebar badge is
    /// just the visible affordance; the actual binding lives in the menu.
    var keyboardShortcut: String? {
        switch self {
        case .search:        return "\u{2318}F"          // ⌘F
        case .bookmarks:     return "\u{2318}B"          // ⌘B
        case .dailyPractice: return "\u{2318}\u{21E7}P"  // ⌘⇧P
        case .mastery:       return "\u{2318}\u{21E7}M"  // ⌘⇧M
        case .discover:      return "\u{2318}\u{21E7}D"  // ⌘⇧D
        case .settings:      return "\u{2318}\u{21E7},"  // ⌘⇧,
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
    case chapters
    case settings

    var id: String { rawValue }

    var title: String {
        switch self {
        case .translate: return "Translate"
        case .history:   return "History"
        case .favorites: return "Favorites"
        case .practice:  return "Practice"
        case .scan:      return "Scan"
        case .chapters:  return "Chapters"
        case .settings:  return "Settings"
        }
    }

    var systemImage: String {
        switch self {
        case .translate: return SFSymbolCompat.name("character.book.closed")
        case .history:   return "clock.arrow.circlepath"
        case .favorites: return "heart.fill"
        case .practice:  return "graduationcap.fill"
        case .scan:      return "doc.text.viewfinder"
        case .chapters:  return "books.vertical.fill"
        case .settings:  return "gearshape.fill"
        }
    }
}
