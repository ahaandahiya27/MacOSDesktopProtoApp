import SwiftUI

/// Home view for any non-Sanskrit subject. Wraps the chapter/topic/concept/
/// question drill-down in a NavigationStack so back-navigation works.
///
/// Sanskrit is special — it has its own home view (SanskritSubjectHomeView)
/// that wraps the existing translator/scan/practice/history/favorites screens.
struct SubjectHomeView: View {
    let pack: SubjectPack
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            ChapterListView(pack: pack)
                .navigationDestination(for: TutorRoute.self) { route in
                    destination(for: route)
                }
        }
    }

    @ViewBuilder
    private func destination(for route: TutorRoute) -> some View {
        switch route {
        case .chapter(_, let chapterId):
            if let chapter = pack.chapters.first(where: { $0.id == chapterId }) {
                ChapterDetailView(pack: pack, chapter: chapter)
            } else {
                missing(label: "Chapter \(chapterId) not found")
            }
        case .topic(_, let topicId):
            if let topic = pack.chapters.flatMap({ $0.topics }).first(where: { $0.id == topicId }) {
                TopicDetailView(pack: pack, topic: topic)
            } else {
                missing(label: "Topic \(topicId) not found")
            }
        case .concept(_, let conceptId):
            if let concept = pack.allConcepts.first(where: { $0.id == conceptId }) {
                ConceptDetailView(pack: pack, concept: concept)
            } else {
                missing(label: "Concept \(conceptId) not found")
            }
        case .question(_, let questionId):
            if let question = pack.allQuestions.first(where: { $0.id == questionId }) {
                QuestionDetailView(pack: pack, question: question)
            } else {
                missing(label: "Question \(questionId) not found")
            }
        case .discover(_, let chapterId):
            if let chapter = pack.chapters.first(where: { $0.id == chapterId }) {
                DiscoverMode.view(for: pack, chapter: chapter)
            } else {
                missing(label: "Chapter \(chapterId) not found for Discover Mode")
            }
        }
    }

    private func missing(label: String) -> some View {
        ContentUnavailableView(label, systemImage: "questionmark.folder")
    }
}
