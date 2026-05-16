import SwiftUI

struct SanskritSubjectHomeView: View {
    @EnvironmentObject var appState: AppState

    private static let visibleTabs: [AppTab] = [.translate, .scan, .practice, .history, .favorites]

    var body: some View {
        VStack(spacing: 0) {
            Picker("Sanskrit section", selection: $appState.selectedTab) {
                ForEach(Self.visibleTabs) { tab in
                    Label(tab.title, systemImage: tab.systemImage).tag(tab)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.gray.opacity(0.15))

            Divider()

            Group {
                switch appState.selectedTab {
                case .translate: TranslatorScreen()
                case .scan:      OCRTranslationScreen()
                case .practice:  PracticeScreen()
                case .history:   HistoryScreen()
                case .favorites: FavoritesScreen()
                case .settings:  SettingsScreen()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .id(appState.selectedTab)
        }
        .onAppear {
            if appState.selectedTab == .settings {
                appState.selectedTab = .translate
            }
        }
    }
}
