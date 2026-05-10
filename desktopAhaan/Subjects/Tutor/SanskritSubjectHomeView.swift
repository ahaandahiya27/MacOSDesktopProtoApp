import SwiftUI

/// Wraps the existing Sanskrit screens behind a top-of-detail-pane segmented
/// control, so the user picks Translate / Scan / Practice / History /
/// Favorites within the Sanskrit subject. Settings is reachable via the
/// "Tools" section in the top-level sidebar — not from here.
///
/// This view does NOT touch the existing screens. It just renders one of
/// them based on `appState.selectedTab`. All existing keyboard shortcuts
/// (⌘O, ⌘↩, ⌘⇧S, ⌘C) continue to work because the screens themselves still
/// listen to the same NotificationCenter notifications.
struct SanskritSubjectHomeView: View {
    @EnvironmentObject var appState: AppState

    /// Tabs visible inside Sanskrit. Settings is intentionally excluded — it
    /// belongs in the top-level Tools section.
    private static let visibleTabs: [AppTab] = [.translate, .scan, .practice, .history, .favorites]

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("Sanskrit section", selection: $appState.selectedTab) {
                    ForEach(Self.visibleTabs) { tab in
                        Label(tab.title, systemImage: tab.systemImage).tag(tab)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(.regularMaterial)

                Divider()

                // Render the selected screen. Each screen sets its own
                // navigationTitle and pulls EnvironmentObjects / @Environment
                // it needs (modelContext, appState).
                Group {
                    switch appState.selectedTab {
                    case .translate: TranslatorScreen()
                    case .scan:      OCRTranslationScreen()
                    case .practice:  PracticeScreen()
                    case .history:   HistoryScreen()
                    case .favorites: FavoritesScreen()
                    case .settings:  SettingsScreen()  // unreachable in normal flow
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                // Identity-key the inner Group only, NOT the whole NavigationStack.
                // This resets the inner screen's local @State on tab change
                // without nuking the surrounding NavigationStack's history,
                // preserving translator typed text across navigation depth.
                .id(appState.selectedTab)
            }
        }
        .onAppear {
            // If somehow the Sanskrit section is showing but `selectedTab`
            // is `.settings` (orphan from old code), bounce back to translate.
            if appState.selectedTab == .settings {
                appState.selectedTab = .translate
            }
        }
    }
}
