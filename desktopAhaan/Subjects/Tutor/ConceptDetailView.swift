import SwiftUI

struct ConceptDetailView: View {
    let pack: SubjectPack
    let concept: Concept

    @State private var depth: ExplanationDepth = .kidFriendly
    @State private var showAskFollowUp = false
    @State private var reasoningExpanded = false
    @State private var beyondExpanded = false
    @EnvironmentObject private var nav: TutorNavigationState
    @ObservedObject private var speech = SpeechReader.shared
    @EnvironmentObject var dataStore: DataStore

    private var conceptIndex: [String: Concept] { pack.conceptIndex }
    private var questionIndex: [String: Question] { pack.questionIndex }

    private var isBookmarked: Bool {
        dataStore.isBookmarked(subjectPackId: pack.id, conceptId: concept.id)
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
            .frame(maxWidth: DesignTokens.contentMaxWidth, alignment: .leading)
        }
        .background(Color(NSColor.windowBackgroundColor))
        .navigationTitle(concept.title)
        .sheet(isPresented: $showAskFollowUp) {
            AskFollowUpView(pack: pack, concept: concept)
        }
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button(action: toggleBookmark) {
                    Label(
                        isBookmarked ? "Bookmarked" : "Bookmark",
                        systemImage: isBookmarked ? "bookmark.fill" : "bookmark"
                    )
                }
                .keyboardShortcut("b", modifiers: .command)
                .help(isBookmarked ? "Remove bookmark" : "Bookmark this concept")
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
                    .foregroundColor(.secondary)
            }
            if concept.needsHumanReview {
                Label("This section was flagged for human review.", systemImage: "exclamationmark.triangle.fill")
                    .font(.caption)
                    .foregroundColor(.orange)
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
        .onChange(of: depth) { _ in
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
        .keyboardShortcut("r", modifiers: .command)
        .help(speech.isSpeaking ? "Pause reading" : (speech.isPaused ? "Resume reading" : "Read aloud"))
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
                .font(.caption).foregroundColor(.secondary).textCase(.uppercase)
            Text(concept.explanation(at: depth))
                .font(.body)
                .lineSpacing(4)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.gray.opacity(0.1))
        )
    }

    private var reasoningCard: some View {
        ExpandableCard(
            isExpanded: $reasoningExpanded,
            systemImage: "questionmark.circle.fill",
            title: "Why is this true?"
        ) {
            Text(concept.reasoning)
                .font(.body)
                .lineSpacing(4)
        }
    }

    private var useCasesSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Label("See it in real life", systemImage: "globe")
                    .font(.headline)
                Spacer()
                if concept.useCases.count > 1 {
                    Text("Scroll for more →")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            ScrollView(.horizontal, showsIndicators: true) {
                HStack(alignment: .top, spacing: 12) {
                    ForEach(concept.useCases) { useCase in
                        UseCaseCard(useCase: useCase)
                    }
                }
                .padding(.bottom, 4)
            }
            .accessibilityLabel("Real-life examples, \(concept.useCases.count) items")
        }
    }

    private var beyondTheBookCard: some View {
        ExpandableCard(
            isExpanded: $beyondExpanded,
            systemImage: "graduationcap.fill",
            title: "Beyond the book",
            tint: Color.compatIndigo,
            background: Color.compatIndigo.opacity(0.10)
        ) {
            Text(concept.beyondTheBook)
                .font(.body)
                .lineSpacing(4)
        }
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
                        .foregroundColor(.secondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
            .padding(16)
            .frame(maxWidth: .infinity)
            .background(RoundedRectangle(cornerRadius: 14).fill(Color.purple.opacity(0.10)))
            .contentShape(Rectangle())
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
                        Button { nav.push(.concept(packId: pack.id, conceptId: c.id)) } label: {
                            HStack {
                                Image(systemName: "lightbulb")
                                    .foregroundColor(Color.compatIndigo)
                                Text(c.title).font(.body)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.secondary)
                            }
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        .contextMenu {
                            Button("Open") { nav.push(.concept(packId: pack.id, conceptId: c.id)) }
                            Button("Bookmark") {
                                dataStore.toggleBookmark(subjectPackId: pack.id, conceptId: c.id, conceptTitle: c.title)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                if !relatedQuestions.isEmpty {
                    ForEach(relatedQuestions) { q in
                        Button { nav.push(.question(packId: pack.id, questionId: q.id)) } label: {
                            HStack {
                                Image(systemName: "questionmark.app")
                                    .foregroundColor(.orange)
                                Text(q.prompt).font(.body).lineLimit(2)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.secondary)
                            }
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        .padding(.vertical, 4)
                    }
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.gray.opacity(0.1))
            )
        }
    }

    // MARK: - Actions

    private func toggleBookmark() {
        dataStore.toggleBookmark(
            subjectPackId: pack.id,
            conceptId: concept.id,
            conceptTitle: concept.title
        )
    }
}

// MARK: - UseCaseCard

private struct UseCaseCard: View {
    let useCase: UseCase

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(useCase.domain.uppercased())
                .font(.caption2).bold()
                .foregroundColor(.secondary)
            Text(useCase.title)
                .font(.subheadline).bold()
            Text(useCase.description)
                .font(.callout)
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(DesignTokens.cornerRadiusCard)
        .frame(width: 280, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: DesignTokens.cornerRadiusCard)
                .fill(Color.gray.opacity(0.1))
        )
        .overlay(
            RoundedRectangle(cornerRadius: DesignTokens.cornerRadiusCard)
                .strokeBorder(Color.compatIndigo.opacity(0.25), lineWidth: 1)
        )
    }
}

// MARK: - Routing

enum TutorRoute: Hashable {
    case chapter(packId: String, chapterId: String)
    case topic(packId: String, topicId: String)
    case concept(packId: String, conceptId: String)
    case question(packId: String, questionId: String)
    case discover(packId: String, chapterId: String)
}
