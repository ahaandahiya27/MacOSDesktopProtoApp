import SwiftUI
import Combine

/// A pointer into a list of questions, used to enable Prev/Next navigation
/// inside QuestionDetailView. The QuizBank populates this when pushing a
/// question; other callers can leave it empty and Prev/Next stays disabled.
struct QuestionRef: Hashable {
    let packId: String
    let questionId: String
}

@MainActor
final class TutorNavigationState: ObservableObject {
    @Published var path: [TutorRoute] = []
    /// Ordered question siblings that QuestionDetailView's Prev/Next walk
    /// through. Set by the screen that pushed the question (e.g. QuizBank).
    @Published var questionSiblings: [QuestionRef] = []

    func push(_ route: TutorRoute) {
        withAnimation(.easeInOut(duration: 0.2)) {
            path.append(route)
        }
    }

    func pop() {
        withAnimation(.easeInOut(duration: 0.2)) {
            guard !path.isEmpty else { return }
            path.removeLast()
        }
    }

    func popToRoot() {
        withAnimation(.easeInOut(duration: 0.2)) {
            path.removeAll()
        }
    }

    /// Replace the topmost route without pushing a new entry. Used by
    /// QuestionDetailView's Prev/Next so the back-button still returns to
    /// the parent list instead of unwinding through every visited question.
    func replaceTop(_ route: TutorRoute) {
        guard !path.isEmpty else {
            push(route)
            return
        }
        path[path.count - 1] = route
    }

    var currentRoute: TutorRoute? { path.last }
    var canGoBack: Bool { !path.isEmpty }
}

struct TutorNavigationContainer<Root: View>: View {
    @StateObject private var nav = TutorNavigationState()
    @EnvironmentObject var subjectRegistry: SubjectRegistry
    @EnvironmentObject var appState: AppState
    let root: Root

    init(@ViewBuilder root: () -> Root) {
        self.root = root()
    }

    var body: some View {
        VStack(spacing: 0) {
            if nav.canGoBack {
                HStack(spacing: 12) {
                    // No local `.keyboardShortcut("[")` here — the
                    // app-level Edit menu's "Go Back" already owns ⌘[
                    // and posts `navigateBackCommand`, which this view
                    // observes via .onReceive below. Wiring it on both
                    // levels would double-pop the stack (in-view button
                    // fires AND the notification handler fires).
                    Button { nav.pop() } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                    }
                    .help("Back (⌘[)")

                    if nav.path.count > 1 {
                        Button { nav.popToRoot() } label: {
                            HStack(spacing: 4) {
                                Image(systemName: "house")
                                Text("Subject home")
                            }
                        }
                        .keyboardShortcut("[", modifiers: [.command, .shift])
                        .help("Back to subject home (⌘⇧[)")
                    }

                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color(NSColor.controlBackgroundColor))
                Divider()
            }

            // BUG fix: previously `.id(nav.currentRoute)` was applied to the
            // whole Group, so every push/pop changed the Group's identity and
            // SwiftUI tore down `root` (search box text, filter pickers,
            // scroll position) along with it. Result: pop-back showed a
            // fresh root with empty state — the "list is compromised on
            // back" symptom.
            //
            // Now the .id() is on the routeView only, so route detail views
            // still get a fresh identity per route (preventing state bleed
            // between, say, question q1 and question q2) but `root` keeps a
            // stable identity and its @State survives across navigation.
            Group {
                if let route = nav.currentRoute {
                    routeView(for: route)
                        .id(route)
                } else {
                    root
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .environmentObject(nav)
        .onReceive(NotificationCenter.default.publisher(for: .navigateBackCommand)) { _ in
            nav.pop()
        }
        .onAppear { consumePendingRouteIfAny() }
        .onChange(of: appState.pendingRoute) { _ in consumePendingRouteIfAny() }
    }

    /// Pull the one-shot pending route out of AppState, apply it to this
    /// container's nav, and clear the slot so it can't be consumed twice.
    /// Runs on mount AND whenever a fresh pending route appears.
    private func consumePendingRouteIfAny() {
        guard let req = appState.pendingRoute else { return }
        nav.popToRoot()
        nav.push(req.route)
        nav.questionSiblings = req.siblings
        appState.pendingRoute = nil
    }

    @ViewBuilder
    private func routeView(for route: TutorRoute) -> some View {
        switch route {
        case .chapter(let packId, let chapterId):
            chapterDetail(packId: packId, chapterId: chapterId)
        case .topic(let packId, let topicId):
            topicDetail(packId: packId, topicId: topicId)
        case .concept(let packId, let conceptId):
            conceptDetail(packId: packId, conceptId: conceptId)
        case .question(let packId, let questionId):
            questionDetail(packId: packId, questionId: questionId)
        case .discover(let packId, let chapterId):
            discoverDetail(packId: packId, chapterId: chapterId)
        }
    }

    @ViewBuilder
    private func chapterDetail(packId: String, chapterId: String) -> some View {
        if let pack = subjectRegistry.pack(withId: packId),
           let chapter = pack.chapterIndex[chapterId] {
            ChapterDetailView(pack: pack, chapter: chapter)
        } else {
            RouteNotFoundView(kind: "chapter", packId: packId,
                              itemId: chapterId, onBack: { nav.pop() })
        }
    }

    @ViewBuilder
    private func topicDetail(packId: String, topicId: String) -> some View {
        if let pack = subjectRegistry.pack(withId: packId),
           let topic = pack.chapters.flatMap(\.topics).first(where: { $0.id == topicId }) {
            TopicDetailView(pack: pack, topic: topic)
        } else {
            RouteNotFoundView(kind: "topic", packId: packId,
                              itemId: topicId, onBack: { nav.pop() })
        }
    }

    @ViewBuilder
    private func conceptDetail(packId: String, conceptId: String) -> some View {
        if let pack = subjectRegistry.pack(withId: packId),
           let concept = pack.conceptIndex[conceptId] {
            ConceptDetailView(pack: pack, concept: concept)
        } else {
            RouteNotFoundView(kind: "concept", packId: packId,
                              itemId: conceptId, onBack: { nav.pop() })
        }
    }

    @ViewBuilder
    private func questionDetail(packId: String, questionId: String) -> some View {
        if let pack = subjectRegistry.pack(withId: packId),
           let question = pack.questionIndex[questionId] {
            QuestionDetailView(pack: pack, question: question)
        } else {
            RouteNotFoundView(kind: "question", packId: packId,
                              itemId: questionId, onBack: { nav.pop() })
        }
    }

    @ViewBuilder
    private func discoverDetail(packId: String, chapterId: String) -> some View {
        if let pack = subjectRegistry.pack(withId: packId),
           let chapter = pack.chapterIndex[chapterId] {
            DiscoverMode.view(for: pack, chapter: chapter)
        } else {
            RouteNotFoundView(kind: "discover-chapter", packId: packId,
                              itemId: chapterId, onBack: { nav.pop() })
        }
    }
}

/// Fallback shown when a route refers to an id that no longer exists
/// in the loaded pack (stale link, corrupt data, bookmarked-then-renamed).
/// Replaces the silent blank screen with a recoverable error + a logged
/// data issue that surfaces in the crash log for later diagnosis.
///
/// Big Sur compatible: pure SwiftUI, SF Symbols 1 icon, ≤10 children.
private struct RouteNotFoundView: View {
    let kind: String
    let packId: String
    let itemId: String
    let onBack: () -> Void

    var body: some View {
        VStack(spacing: 14) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 48))
                .foregroundColor(.orange)
                .accessibilityHidden(true)
            Text("Couldn't open this \(kind)")
                .font(.title2.weight(.semibold))
            Text("ID '\(itemId)' wasn't found in pack '\(packId)'.\nThe link may be from an older content version.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            Button("Go back") { onBack() }
                .keyboardShortcut(.defaultAction)
                .accessibilityHint("Returns to the previous screen")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(24)
        .onAppear {
            CrashReporter.shared.logDataIssue(
                "route lookup failed: \(kind) '\(itemId)' in pack '\(packId)'"
            )
        }
    }
}
