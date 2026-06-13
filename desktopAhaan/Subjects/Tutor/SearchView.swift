import SwiftUI

struct SearchView: View {
    var body: some View {
        TutorNavigationContainer {
            SearchContent()
        }
    }
}

private struct SearchContent: View {
    @EnvironmentObject var subjectRegistry: SubjectRegistry
    @EnvironmentObject private var nav: TutorNavigationState
    @State private var query: String = ""
    @State private var debouncedQuery: String = ""
    @State private var debounceWork: DispatchWorkItem?
    /// Subject-scope filter. `nil` means "all subjects". Mirrors the
    /// pack picker added to QuizBank (E3) so the kid can ask "find this
    /// in Science but not Sanskrit" or vice versa.
    @State private var packFilter: String? = nil
    /// Cached scan result. Recomputed only when `debouncedQuery` or
    /// `packFilter` changes — NOT on every keystroke / unrelated re-render.
    @State private var matches: [(SubjectPack, [Concept], [Question])] = []

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                TextField("Search across all subjects", text: $query)
                    .textFieldStyle(.plain)
                    .font(.title3)
                if !query.isEmpty {
                    Button {
                        query = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                    .buttonStyle(.plain)
                    .pointingCursor()
                    .help("Clear search")
                    .accessibilityLabel("Clear search")
                    .accessibilityHint("Empties the search field")
                    .accessibilityIdentifier("search-clear")
                }
            }
            .padding(DesignTokens.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
                    .fill(Color.gray.opacity(0.1))
            )
            .padding(.horizontal, DesignTokens.Spacing.lg)
            .padding(.top, DesignTokens.Spacing.lg)

            if subjectRegistry.packs.count > 1 {
                subjectScopeFilter
                    .padding(.horizontal, DesignTokens.Spacing.lg)
                    .padding(.top, DesignTokens.Spacing.sm)
            }

            Divider()
                .padding(.top, DesignTokens.Spacing.md)

            if query.trimmingCharacters(in: .whitespaces).isEmpty {
                VStack(spacing: DesignTokens.Spacing.md) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 48))
                        .foregroundColor(.secondary)
                        .accessibilityHidden(true)
                    Text("Search across all subjects")
                        .font(.title2.weight(.semibold))
                    Text("Type any phrase to find concepts and questions across every loaded pack.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                resultsList
            }
        }
        .background(Color(NSColor.windowBackgroundColor))
        .navigationTitle("Search")
        .onChange(of: query) { newValue in
            debounceWork?.cancel()
            let work = DispatchWorkItem { debouncedQuery = newValue }
            debounceWork = work
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: work)
        }
        // Recompute the cached scan only when its inputs change.
        .onChange(of: debouncedQuery) { _ in matches = computeMatches() }
        .onChange(of: packFilter) { _ in matches = computeMatches() }
        .onAppear {
            // Restore results when returning with a query already typed
            // (query/debouncedQuery persist across navigations via C1).
            if matches.isEmpty && !debouncedQuery.trimmingCharacters(in: .whitespaces).isEmpty {
                matches = computeMatches()
            }
        }
        // Cancel any pending debounce work on view disappear so the work
        // doesn't fire after the kid has navigated away and surprise-touch
        // `debouncedQuery` (the @State persists across navigations via the
        // C1 fix, but the work item itself should still drop cleanly).
        .onDisappear {
            debounceWork?.cancel()
            debounceWork = nil
        }
    }

    /// Pack-scope filter pills. Mirrors the QuizBank pattern (E3): a
    /// segmented "All / Science / Sanskrit" row that scopes the search
    /// to a single subject. Hidden when only one pack is loaded.
    private var subjectScopeFilter: some View {
        HStack(spacing: 6) {
            Text("Subject:")
                .font(.caption)
                .foregroundColor(.secondary)
            Button {
                packFilter = nil
            } label: {
                Text("All")
                    .font(.caption.weight(packFilter == nil ? .semibold : .regular))
                    .padding(.horizontal, 10)
                    .padding(.vertical, DesignTokens.Spacing.xs)
                    .background(
                        Capsule().fill(packFilter == nil
                                       ? Color.compatIndigo.opacity(0.18)
                                       : Color.gray.opacity(0.08))
                    )
            }
            .buttonStyle(.plain)
            .accessibilityHint("Searches across every subject pack")
            .accessibilityIdentifier("search-filter-all")
            ForEach(subjectRegistry.packs, id: \.id) { pack in
                Button {
                    packFilter = pack.id
                } label: {
                    Text(pack.title)
                        .font(.caption.weight(packFilter == pack.id ? .semibold : .regular))
                        .padding(.horizontal, 10)
                        .padding(.vertical, DesignTokens.Spacing.xs)
                        .background(
                            Capsule().fill(packFilter == pack.id
                                           ? Color.compatIndigo.opacity(0.18)
                                           : Color.gray.opacity(0.08))
                        )
                }
                .buttonStyle(.plain)
                .accessibilityHint("Limits search to the \(pack.title) pack")
                .accessibilityIdentifier("search-filter-\(pack.id)")
            }
            Spacer()
        }
    }

    /// Tokenize a multi-word query on whitespace, drop empties, lower-case.
    /// "leaves of a plant" → ["leaves", "of", "a", "plant"]. The matcher
    /// then requires EVERY token to match (AND-of-substrings) so the kid
    /// can narrow results with extra words without losing recall on a
    /// single-word query.
    private func tokenize(_ q: String) -> [String] {
        q.split(whereSeparator: { $0.isWhitespace })
            .map { $0.lowercased() }
            .filter { !$0.isEmpty }
    }

    /// Full corpus scan — scores + sorts every concept/question in scope.
    /// Returned for caching in `matches` (see body's onChange wiring) so
    /// that per-keystroke body re-renders, which only move `query` (not the
    /// debounced value), don't re-pay this O(corpus) cost on the weak iMac.
    private func computeMatches() -> [(SubjectPack, [Concept], [Question])] {
        let tokens = tokenize(debouncedQuery.trimmingCharacters(in: .whitespaces))
        guard !tokens.isEmpty else { return [] }
        let scopedPacks: [SubjectPack] = {
            guard let id = packFilter else { return subjectRegistry.packs }
            return subjectRegistry.packs.filter { $0.id == id }
        }()
        return scopedPacks.compactMap { pack -> (SubjectPack, [Concept], [Question])? in
            // Score each concept/question by match quality, then sort
            // descending. Title/prompt prefix > title contains > body
            // contains. Stable for ties via the original collection order.
            let scoredConcepts: [(Concept, Int)] = pack.allConcepts
                .compactMap { c in
                    let s = scoreConcept(c, tokens)
                    return s > 0 ? (c, s) : nil
                }
                .sorted { $0.1 > $1.1 }
            let scoredQuestions: [(Question, Int)] = pack.allQuestions
                .compactMap { q in
                    let s = scoreQuestion(q, tokens)
                    return s > 0 ? (q, s) : nil
                }
                .sorted { $0.1 > $1.1 }
            let cs = scoredConcepts.map { $0.0 }
            let qs = scoredQuestions.map { $0.0 }
            if cs.isEmpty && qs.isEmpty { return nil }
            return (pack, cs, qs)
        }
    }

    @ViewBuilder
    private var resultsList: some View {
        let trimmed = debouncedQuery.trimmingCharacters(in: .whitespaces)
        if matches.isEmpty {
            VStack(spacing: DesignTokens.Spacing.md) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 48))
                    .foregroundColor(.secondary)
                    .accessibilityHidden(true)
                Text("No results for \u{201C}\(trimmed)\u{201D}")
                    .font(.title3.weight(.semibold))
                Text("Try a single word, or check the spelling.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            matchesList(matches)
        }
    }

    private func matchesList(_ matches: [(SubjectPack, [Concept], [Question])]) -> some View {
        List {
            ForEach(matches, id: \.0.id) { pack, concepts, questions in
                Section(header: Text(pack.title)) {
                    ForEach(concepts) { c in
                        Button {
                            nav.push(.concept(packId: pack.id, conceptId: c.id))
                        } label: {
                            HStack(alignment: .top, spacing: 10) {
                                Image(systemName: "lightbulb.fill")
                                    .foregroundColor(Color.compatIndigo)
                                VStack(alignment: .leading, spacing: DesignTokens.Spacing.xxs) {
                                    Text(c.title).font(.headline)
                                    Text(c.explanation(at: .oneLine))
                                        .font(.caption).foregroundColor(.secondary).lineLimit(2)
                                }
                            }
                            .padding(.vertical, DesignTokens.Spacing.xs)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        .accessibilityHint("Opens this concept")
                        .accessibilityIdentifier("search-concept-row-\(c.id)")
                        .contextMenu {
                            Button("Open") { nav.push(.concept(packId: pack.id, conceptId: c.id)) }
                        }
                    }
                    ForEach(questions) { q in
                        Button {
                            nav.push(.question(packId: pack.id, questionId: q.id))
                        } label: {
                            HStack(alignment: .top, spacing: 10) {
                                Image(systemName: "questionmark.circle.fill")
                                    .foregroundColor(.orange)
                                VStack(alignment: .leading, spacing: DesignTokens.Spacing.xxs) {
                                    Text(q.prompt).font(.body).lineLimit(2)
                                    Text("Answer: \(q.answer)")
                                        .font(.caption).foregroundColor(.secondary).lineLimit(2)
                                }
                            }
                            .padding(.vertical, DesignTokens.Spacing.xs)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        .accessibilityHint("Opens this practice question")
                        .accessibilityIdentifier("search-question-row-\(q.id)")
                        .contextMenu {
                            Button("Open") { nav.push(.question(packId: pack.id, questionId: q.id)) }
                        }
                    }
                }
            }
        }
        .listStyle(.inset)
    }

    /// Multi-token scoring. EVERY token must match somewhere (title,
    /// explanations) — return 0 if any token is missing. The returned
    /// score is the SUM of per-token scores so that matching the same
    /// token in title (50) and explanation (10) doesn't double-count
    /// the better signal — we keep per-token max.
    ///
    /// Per-token score:
    ///   100  title prefix
    ///    50  title contains
    ///    10  any explanation contains
    private func scoreConcept(_ c: Concept, _ tokens: [String]) -> Int {
        guard !tokens.isEmpty else { return 0 }
        let opts: String.CompareOptions = [.caseInsensitive, .diacriticInsensitive]
        var total = 0
        for t in tokens {
            var per = 0
            if let r = c.title.range(of: t, options: opts) {
                per = (r.lowerBound == c.title.startIndex) ? 100 : 50
            } else {
                for v in c.explanations.values {
                    if v.range(of: t, options: opts) != nil { per = 10; break }
                }
            }
            if per == 0 { return 0 }  // AND-of-tokens
            total += per
        }
        return total
    }

    /// Multi-token scoring for questions.
    ///   100  prompt prefix
    ///    50  prompt contains
    ///    20  answer contains   (below prompt — answers are short, "true"
    ///         would otherwise dominate)
    private func scoreQuestion(_ qn: Question, _ tokens: [String]) -> Int {
        guard !tokens.isEmpty else { return 0 }
        let opts: String.CompareOptions = [.caseInsensitive, .diacriticInsensitive]
        var total = 0
        for t in tokens {
            var per = 0
            if let r = qn.prompt.range(of: t, options: opts) {
                per = (r.lowerBound == qn.prompt.startIndex) ? 100 : 50
            } else if qn.answer.range(of: t, options: opts) != nil {
                per = 20
            }
            if per == 0 { return 0 }
            total += per
        }
        return total
    }
}
