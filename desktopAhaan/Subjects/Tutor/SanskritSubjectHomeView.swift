import SwiftUI

struct SanskritSubjectHomeView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var subjectRegistry: SubjectRegistry

    // 2026-05-28: added `.chapters` so the 15 NEP chapters in
    // sanskrit_class7.json (sch01–sch15) surface in the app. The new tab
    // mounts the standard SubjectHomeView (which wraps ChapterListView in
    // TutorNavigationContainer) for the sanskrit pack — exactly the same
    // plumbing Science/Maths use from the sidebar.
    private static let visibleTabs: [AppTab] = [.translate, .scan, .practice, .chapters, .history, .favorites]

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
                case .chapters:  chaptersTab
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

    /// The Chapters tab body — mounts the standard `SubjectHomeView` for the
    /// sanskrit pack. Pulled out of the tab `switch` so the @ViewBuilder
    /// closure there stays small and the pack-resolution logic is testable.
    @ViewBuilder
    private var chaptersTab: some View {
        if let pack = subjectRegistry.pack(withId: "sanskrit_class7") {
            SubjectHomeView(pack: pack)
        } else {
            VStack(spacing: 12) {
                Image(systemName: SFSymbolCompat.name("books.vertical"))
                    .font(.system(size: 48))
                    .foregroundColor(.secondary)
                Text("Sanskrit pack not loaded.")
                    .font(.headline)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
