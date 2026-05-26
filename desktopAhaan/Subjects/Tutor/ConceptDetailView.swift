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
    @EnvironmentObject var appState: AppState

    // MARK: - Inquiry-first mode (Ch.1 pilot)
    @AppStorage(AppStorageKeys.inquiryFirstMode) private var inquiryFirstMode: Bool = false
    /// Per-concept reveal flag (not persisted — the predict-first
    /// experience is per-visit, intentionally low-stakes).
    @State private var predictRevealed: Bool = false
    @State private var predictGuess: String = ""

    private var conceptIndex: [String: Concept] { pack.conceptIndex }
    private var questionIndex: [String: Question] { pack.questionIndex }

    private var isBookmarked: Bool {
        dataStore.isBookmarked(subjectPackId: pack.id, conceptId: concept.id)
    }

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    breadcrumb
                    header
                    depthPicker
                    articleButton
                    if let loc = location {
                        ChapterGlossaryCTA(chapter: loc.chapter)
                    }
                    explanationGroup
                    followOnGroup
                }
                .padding(20)
                // Center the bounded-width column inside the full-width
                // detail pane. See QuestionDetailView.swift for the same
                // pattern + the Big-Sur centering rationale.
                .frame(maxWidth: DesignTokens.contentMaxWidth, alignment: .leading)
                .frame(maxWidth: .infinity, alignment: .center)
                .id("__top__")
            }
            .onAppear {
                DispatchQueue.main.async {
                    proxy.scrollTo("__top__", anchor: .top)
                }
                recordRecent()
            }
            .onChange(of: concept.id) { _ in
                withAnimationRespectingReduceMotion(.easeOut(duration: 0.2)) {
                    proxy.scrollTo("__top__", anchor: .top)
                }
                recordRecent()
                // Reset the predict-first state when the kid navigates
                // to a different concept — each concept gets its own
                // fresh hypothesise-first experience.
                predictRevealed = false
                predictGuess = ""
            }
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
            ToolbarItem(placement: .automatic) {
                Button {
                    if let prevId = siblings?.prevId {
                        nav.push(.concept(packId: pack.id, conceptId: prevId))
                    }
                } label: {
                    Label("Previous concept", systemImage: "arrow.left")
                }
                .disabled(siblings?.prevId == nil)
                .keyboardShortcut("[", modifiers: .command)
                .help(siblingHelpText(direction: "Previous"))
            }
            ToolbarItem(placement: .automatic) {
                Button {
                    if let nextId = siblings?.nextId {
                        nav.push(.concept(packId: pack.id, conceptId: nextId))
                    }
                } label: {
                    Label("Next concept", systemImage: "arrow.right")
                }
                .disabled(siblings?.nextId == nil)
                .keyboardShortcut("]", modifiers: .command)
                .help(siblingHelpText(direction: "Next"))
            }
        }
        .onDisappear {
            speech.stop(owner: "concept_\(concept.id)")
        }
    }

    // MARK: - Body subgroups
    //
    // Swift 5.5 / Xcode 13 (Big Sur) caps SwiftUI @ViewBuilder closures at
    // 10 direct children. The body VStack was sitting exactly at 10 — one
    // future addition would trigger "Extra argument in call" on the iMac.
    // Group adjacent sections so there's headroom.

    @ViewBuilder
    private var explanationGroup: some View {
        if shouldGateForInquiry {
            inquiryGate
        } else {
            postInquiryRibbon
            explanationCard
            reasoningCard
            whyChainPill
            useCasesSection
        }
    }

    /// True when the Settings toggle is on AND this concept has a
    /// non-nil predictQuestion AND the user hasn't tapped "Show me the
    /// answer" yet on this visit. When true the explanationCard / etc.
    /// stay hidden behind the inquiryGate.
    private var shouldGateForInquiry: Bool {
        inquiryFirstMode && !predictRevealed && (concept.predictQuestion?.isEmpty == false)
    }

    /// The predict-before-reveal prompt + guess field + reveal button.
    @ViewBuilder
    private var inquiryGate: some View {
        if let question = concept.predictQuestion {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 8) {
                    Image(systemName: SFSymbolCompat.name("lightbulb.fill"))
                        .font(.body)
                        .foregroundColor(Color.compatIndigo)
                        .accessibilityHidden(true)
                    Text("Predict first")
                        .font(.caption.weight(.bold))
                        .foregroundColor(Color.compatIndigo)
                        .textCase(.uppercase)
                        .accessibilityAddTraits(.isHeader)
                    Spacer(minLength: 0)
                }
                Text(question)
                    .font(.body)
                    .lineSpacing(3)
                    .fixedSize(horizontal: false, vertical: true)
                // Single-line TextField on Big Sur — the multi-line
                // `axis: .vertical` parameter and `lineLimit(_, reservesSpace:)`
                // overload are macOS 13+. A 60-char input is plenty for a
                // one-thought guess.
                TextField("Your best guess…", text: $predictGuess)
                    .textFieldStyle(.roundedBorder)
                    .accessibilityHint("Type your guess. It isn't graded or saved; just thinking it through.")
                HStack {
                    Spacer()
                    Button("Show me the answer") {
                        withAnimationRespectingReduceMotion(.easeOut(duration: 0.22)) {
                            predictRevealed = true
                        }
                    }
                    .keyboardShortcut(.defaultAction)
                    .accessibilityHint("Reveals the concept explanation alongside a brief comparison to your guess.")
                }
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.compatIndigo.opacity(0.10))
            )
            .accessibilityElement(children: .contain)
            .accessibilityLabel("Predict-first prompt")
        }
    }

    /// Small ribbon shown after the kid has revealed the explanation.
    /// Echoes their guess back so they can compare to the textbook
    /// answer. Skipped when inquiry-first is off or no guess was typed.
    @ViewBuilder
    private var postInquiryRibbon: some View {
        if inquiryFirstMode,
           predictRevealed,
           let guess = nonEmpty(predictGuess) {
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: SFSymbolCompat.name("quote.bubble.fill"))
                    .font(.caption)
                    .foregroundColor(Color.compatIndigo)
                    .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Your guess")
                        .font(.caption2.weight(.bold))
                        .foregroundColor(Color.compatIndigo)
                        .textCase(.uppercase)
                    Text(guess)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .italic()
                        .fixedSize(horizontal: false, vertical: true)
                    Text("Here's the actual idea. Notice where it overlaps with what you guessed.")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .padding(.top, 2)
                }
                Spacer(minLength: 0)
            }
            .padding(10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.compatIndigo.opacity(0.06))
            )
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Your guess: \(guess). The actual idea follows below.")
        }
    }

    private func nonEmpty(_ s: String) -> String? {
        let t = s.trimmingCharacters(in: .whitespacesAndNewlines)
        return t.isEmpty ? nil : t
    }

    /// Three-layer Socratic drill (Ch.1 pilot). Auto-hides when the
    /// concept has no authored whyChain. Once propagated to ch.2..19,
    /// every concept with a non-nil whyChain shows the pill — no further
    /// wiring needed in this file.
    @ViewBuilder
    private var whyChainPill: some View {
        WhyChainView(conceptId: concept.id, chain: concept.whyChain)
    }

    @ViewBuilder
    private var followOnGroup: some View {
        beyondTheBookCard
        askFollowUpButton
        relatedSection
    }

    // MARK: - Sections

    /// Cached sibling resolution for the toolbar prev/next buttons.
    /// Returns nil for orphan concepts (shouldn't happen in shipped
    /// content but the toolbar gracefully disables both buttons).
    private var siblings: ConceptSiblings.Resolved? {
        ConceptSiblings.resolve(conceptId: concept.id, in: pack)
    }

    private func siblingHelpText(direction: String) -> String {
        guard let s = siblings else { return "\(direction) concept" }
        return "\(direction) concept (concept \(s.index + 1) of \(s.total) in this topic)"
    }

    /// Walks the pack to find which chapter+topic owns this concept.
    private var location: (chapter: Chapter, topic: Topic)? {
        for chapter in pack.chapters {
            for topic in chapter.topics where topic.concepts.contains(where: { $0.id == concept.id }) {
                return (chapter, topic)
            }
        }
        return nil
    }

    @ViewBuilder
    private var breadcrumb: some View {
        if let loc = location {
            HStack(spacing: 4) {
                Text(pack.coverEmoji)
                Text(pack.title).font(.caption.weight(.medium))
                Text("›").foregroundColor(.secondary)
                Text("Ch. \(loc.chapter.number)").font(.caption)
                Text("›").foregroundColor(.secondary)
                Text(loc.topic.title).font(.caption).lineLimit(1).truncationMode(.tail)
                Spacer(minLength: 0)
            }
            .foregroundColor(.secondary)
            .accessibilityElement(children: .combine)
            .accessibilityLabel("\(pack.title), Chapter \(loc.chapter.number), \(loc.topic.title)")
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(concept.title)
                .font(.largeTitle).bold()
                .devanagariAwareLocale(packId: pack.id)
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
        .pointingCursor()
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

    @ViewBuilder
    private var explanationCard: some View {
        let text = concept.explanation(at: depth)
                          .trimmingCharacters(in: .whitespacesAndNewlines)
        if text.isEmpty {
            // No explanation at this depth — common for the auto-generated
            // Sanskrit vocabulary entries. Show a friendly fallback rather
            // than a blank panel.
            VStack(alignment: .leading, spacing: 6) {
                Label("Glossary entry", systemImage: "book.closed.fill")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.secondary)
                Text("\(concept.title) — no \(depth.displayName.lowercased()) explanation has been written for this entry yet. Use the Translate tab to look up usage, or pick a different depth above.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .lineSpacing(4)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.gray.opacity(0.07))
            )
        } else {
            VStack(alignment: .leading, spacing: 8) {
                Text(depth.displayName)
                    .font(.caption).foregroundColor(.secondary).textCase(.uppercase)
                Text(text)
                    .font(.body)
                    .lineSpacing(4)
                    .devanagariAwareLocale(packId: pack.id)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.gray.opacity(0.1))
            )
        }
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
        .pointingCursor()
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
                        .pointingCursor()
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
                                Image(systemName: "questionmark.circle")
                                    .foregroundColor(.orange)
                                Text(q.prompt).font(.body).lineLimit(2)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.secondary)
                            }
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        .pointingCursor()
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

    private func recordRecent() {
        let chapterLabel = location.map { "Ch. \($0.chapter.number) — \($0.chapter.title)" }
            ?? pack.title
        appState.recordRecent(RecentItem(
            packId: pack.id,
            kind: .concept,
            routeId: concept.id,
            title: concept.title,
            subtitle: chapterLabel
        ))
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
