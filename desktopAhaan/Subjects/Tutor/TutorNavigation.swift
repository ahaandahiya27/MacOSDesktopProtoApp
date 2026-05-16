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
    let root: Root

    init(@ViewBuilder root: () -> Root) {
        self.root = root()
    }

    var body: some View {
        VStack(spacing: 0) {
            if nav.canGoBack {
                HStack(spacing: 12) {
                    Button { nav.pop() } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                    }
                    .keyboardShortcut("[", modifiers: .command)
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

            Group {
                if let route = nav.currentRoute {
                    routeView(for: route)
                } else {
                    root
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .id(nav.currentRoute)
        }
        .environmentObject(nav)
        .onReceive(NotificationCenter.default.publisher(for: .navigateBackCommand)) { _ in
            nav.pop()
        }
        .onReceive(NotificationCenter.default.publisher(for: .openTutorRoute)) { note in
            guard let route = note.object as? TutorRoute else { return }
            // Pop to the root of this container first so the new route sits
            // at depth 1, not piled on top of where the user was.
            nav.popToRoot()
            nav.push(route)
        }
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
           let chapter = pack.chapters.first(where: { $0.id == chapterId }) {
            ChapterDetailView(pack: pack, chapter: chapter)
        }
    }

    @ViewBuilder
    private func topicDetail(packId: String, topicId: String) -> some View {
        if let pack = subjectRegistry.pack(withId: packId),
           let topic = pack.chapters.flatMap(\.topics).first(where: { $0.id == topicId }) {
            TopicDetailView(pack: pack, topic: topic)
        }
    }

    @ViewBuilder
    private func conceptDetail(packId: String, conceptId: String) -> some View {
        if let pack = subjectRegistry.pack(withId: packId),
           let concept = pack.conceptIndex[conceptId] {
            ConceptDetailView(pack: pack, concept: concept)
        }
    }

    @ViewBuilder
    private func questionDetail(packId: String, questionId: String) -> some View {
        if let pack = subjectRegistry.pack(withId: packId),
           let question = pack.questionIndex[questionId] {
            QuestionDetailView(pack: pack, question: question)
        }
    }

    @ViewBuilder
    private func discoverDetail(packId: String, chapterId: String) -> some View {
        if let pack = subjectRegistry.pack(withId: packId),
           let chapter = pack.chapters.first(where: { $0.id == chapterId }) {
            DiscoverMode.view(for: pack, chapter: chapter)
        }
    }
}
