import SwiftUI
import SwiftData

/// The centerpiece. Renders a single concept with a four-depth segmented
/// switcher, the "why is this true?" reasoning card, real-world use cases,
/// and the "beyond the book" extension.
struct ConceptDetailView: View {
    let pack: SubjectPack
    let concept: Concept

    @State private var depth: ExplanationDepth = .kidFriendly
    @State private var showAskFollowUp = false
    @ObservedObject private var speech = SpeechReader.shared
    @Environment(\.modelContext) private var modelContext
    @Query(sort: [SortDescriptor(\StudyBookmark.addedAt, order: .reverse)])
    private var bookmarks: [StudyBookmark]

    /// Lookup tables come from the pack itself, computed lazily.
    private var conceptIndex: [String: Concept] { pack.conceptIndex }
    private var questionIndex: [String: Question] { pack.questionIndex }

    private var bookmarkRecord: StudyBookmark? {
        let key = "\(pack.id)::\(concept.id)"
        return bookmarks.first { $0.id == key }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                header
                depthPicker
                articleButton
                explanationCard
                reasoningCard
                useCasesSection
                beyondTheBookCard
                askFollowUpButton
                relatedSection
            }
            .padding(20)
            .frame(maxWidth: 820, alignment: .leading)
        }
        .navigationTitle(concept.title)
        .sheet(isPresented: $showAskFollowUp) {
            AskFollowUpView(pack: pack, concept: concept)
        }
        .toolbar {
            ToolbarItem(placement: .secondaryAction) {
                Button(action: toggleBookmark) {
                    Label(
                        bookmarkRecord == nil ? "Bookmark" : "Bookmarked",
                        systemImage: bookmarkRecord == nil ? "bookmark" : "bookmark.fill"
                    )
                }
            }
        }
        .onDisappear {
            speech.stop(owner: "concept_\(concept.id)")
        }
    }

    // MARK: - Sections

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(concept.title)
                .font(.largeTitle).bold()
            if !concept.pageRefs.isEmpty {
                Text("Pages \(concept.pageRefs.map(String.init).joined(separator: ", "))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            if concept.needsHumanReview {
                Label("This section was flagged for human review.", systemImage: "exclamationmark.triangle.fill")
                    .font(.caption)
                    .foregroundStyle(.orange)
            }
        }
    }

    private var depthPicker: some View {
        HStack(spacing: 12) {
            Picker("Explanation depth", selection: $depth) {
                ForEach(ExplanationDepth.allCases) { d in
                    Label(d.shortLabel, systemImage: d.systemImage).tag(d)
                }
            }
            .pickerStyle(.segmented)

            readAloudButton
                .help("Read aloud")
        }
        .onChange(of: depth) { _, _ in
            // If speech is active (speaking or paused), restart with new depth
            if speech.isSpeaking || speech.isPaused {
                speech.speak(concept.explanation(at: depth), owner: "concept_\(concept.id)")
            }
        }
    }

    private var readAloudButton: some View {
        Button(action: handleReadAloudTapped) {
            if speech.isSpeaking {
                Image(systemName: "pause.fill")
                    .font(.body)
            } else if speech.isPaused {
                Image(systemName: "play.fill")
                    .font(.body)
            } else {
                Image(systemName: "speaker.wave.2")
                    .font(.body)
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(speech.isSpeaking ? "Pause reading" : (speech.isPaused ? "Resume reading" : "Read aloud"))
        .accessibilityHint("Reads the current explanation aloud.")
        .accessibilityValue(speech.isSpeaking ? "Currently speaking" : (speech.isPaused ? "Currently paused" : "Idle"))
    }

    private func handleReadAloudTapped() {
        if speech.isSpeaking {
            speech.pause()
        } else if speech.isPaused {
            speech.resume()
        } else {
            speech.speak(concept.explanation(at: depth), owner: "concept_\(concept.id)")
        }
    }

    private var articleButton: some View {
        ArticleEntryButton(entry: ArticleIndex.entry(forConceptId: concept.id))
            .padding(.top, 8)
    }

    private var explanationCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(depth.displayName)
                .font(.caption).foregroundStyle(.secondary).textCase(.uppercase)
            Text(concept.explanation(at: depth))
                .font(.body)
                .lineSpacing(4)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.background.secondary, in: RoundedRectangle(cornerRadius: 14))
    }

    private var reasoningCard: some View {
        DisclosureGroup {
            Text(concept.reasoning)
                .font(.body)
                .lineSpacing(4)
                .padding(.top, 4)
        } label: {
            Label("Why is this true?", systemImage: "questionmark.circle.fill")
                .font(.headline)
        }
        .padding(16)
        .background(.background.secondary, in: RoundedRectangle(cornerRadius: 14))
    }

    private var useCasesSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("See it in real life", systemImage: "globe")
                .font(.headline)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 12) {
                    ForEach(concept.useCases) { useCase in
                        UseCaseCard(useCase: useCase)
                    }
                }
                .padding(.bottom, 4)
            }
            // VoiceOver: announce as a single section so users don't get
            // confused by horizontal navigation.
            .accessibilityLabel("Real-life examples, \(concept.useCases.count) items")
        }
    }

    private var beyondTheBookCard: some View {
        DisclosureGroup {
            Text(concept.beyondTheBook)
                .font(.body)
                .lineSpacing(4)
                .padding(.top, 4)
        } label: {
            Label("Beyond the book", systemImage: "graduationcap.fill")
                .font(.headline)
        }
        .padding(16)
        .background(.indigo.opacity(0.10), in: RoundedRectangle(cornerRadius: 14))
    }

    private var askFollowUpButton: some View {
        Button {
            showAskFollowUp = true
        } label: {
            HStack(spacing: 10) {
                Image(systemName: "sparkles")
                VStack(alignment: .leading, spacing: 2) {
                    Text("Ask a follow-up question")
                        .font(.headline)
                    Text("Have a doubt about this concept? The on-device tutor can help.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(.secondary)
            }
            .padding(16)
            .frame(maxWidth: .infinity)
            .background(.purple.opacity(0.10), in: RoundedRectangle(cornerRadius: 14))
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private var relatedSection: some View {
        let relatedConcepts = concept.relatedConceptIds.compactMap { conceptIndex[$0] }
        let relatedQuestions = concept.relatedQuestionIds.compactMap { questionIndex[$0] }
        if !relatedConcepts.isEmpty || !relatedQuestions.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                Label("Related", systemImage: "link")
                    .font(.headline)
                if !relatedConcepts.isEmpty {
                    ForEach(relatedConcepts) { c in
                        NavigationLink(value: TutorRoute.concept(packId: pack.id, conceptId: c.id)) {
                            HStack {
                                Image(systemName: "lightbulb")
                                    .foregroundStyle(.indigo)
                                Text(c.title).font(.body)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .buttonStyle(.plain)
                        .padding(.vertical, 4)
                    }
                }
                if !relatedQuestions.isEmpty {
                    ForEach(relatedQuestions) { q in
                        NavigationLink(value: TutorRoute.question(packId: pack.id, questionId: q.id)) {
                            HStack {
                                Image(systemName: "questionmark.app")
                                    .foregroundStyle(.orange)
                                Text(q.prompt).font(.body).lineLimit(2)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .buttonStyle(.plain)
                        .padding(.vertical, 4)
                    }
                }
            }
            .padding(16)
            .background(.background.secondary, in: RoundedRectangle(cornerRadius: 14))
        }
    }

    // MARK: - Actions

    private func toggleBookmark() {
        if let existing = bookmarkRecord {
            modelContext.delete(existing)
        } else {
            modelContext.insert(StudyBookmark(
                subjectPackId: pack.id,
                conceptId: concept.id,
                conceptTitle: concept.title
            ))
        }
        do { try modelContext.save() }
        catch { print("[ConceptDetailView] bookmark save failed: \(error)") }
    }
}

// MARK: - UseCaseCard

private struct UseCaseCard: View {
    let useCase: UseCase

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(useCase.domain.uppercased())
                .font(.caption2).bold()
                .foregroundStyle(.secondary)
            Text(useCase.title)
                .font(.subheadline).bold()
            Text(useCase.description)
                .font(.callout)
                .foregroundStyle(.primary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(14)
        .frame(width: 280, alignment: .leading)
        .background(.background.secondary, in: RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(.indigo.opacity(0.25), lineWidth: 1)
        )
    }
}

// MARK: - Routing

/// Hashable navigation values used by NavigationStack inside the Science
/// subject's home view.
enum TutorRoute: Hashable {
    case chapter(packId: String, chapterId: String)
    case topic(packId: String, topicId: String)
    case concept(packId: String, conceptId: String)
    case question(packId: String, questionId: String)
    /// The illustrated, interactive Discover Mode experience for a chapter.
    case discover(packId: String, chapterId: String)
}
