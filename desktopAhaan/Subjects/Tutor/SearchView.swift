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
                    .accessibilityLabel("Clear search")
                }
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.1))
            )
            .padding(16)

            Divider()

            if query.trimmingCharacters(in: .whitespaces).isEmpty {
                VStack(spacing: 12) {
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
    }

    @ViewBuilder
    private var resultsList: some View {
        let trimmed = debouncedQuery.trimmingCharacters(in: .whitespaces)
        let matches = subjectRegistry.packs.compactMap { pack -> (SubjectPack, [Concept], [Question])? in
            // Score each concept/question by match quality, then sort
            // descending. Title/prompt prefix > title contains > body
            // contains. Stable for ties via the original collection order.
            let scoredConcepts: [(Concept, Int)] = pack.allConcepts
                .compactMap { c in
                    let s = scoreConcept(c, trimmed)
                    return s > 0 ? (c, s) : nil
                }
                .sorted { $0.1 > $1.1 }
            let scoredQuestions: [(Question, Int)] = pack.allQuestions
                .compactMap { q in
                    let s = scoreQuestion(q, trimmed)
                    return s > 0 ? (q, s) : nil
                }
                .sorted { $0.1 > $1.1 }
            let cs = scoredConcepts.map { $0.0 }
            let qs = scoredQuestions.map { $0.0 }
            if cs.isEmpty && qs.isEmpty { return nil }
            return (pack, cs, qs)
        }

        if matches.isEmpty {
            VStack(spacing: 12) {
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
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(c.title).font(.headline)
                                    Text(c.explanation(at: .oneLine))
                                        .font(.caption).foregroundColor(.secondary).lineLimit(2)
                                }
                            }
                            .padding(.vertical, 4)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
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
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(q.prompt).font(.body).lineLimit(2)
                                    Text("Answer: \(q.answer)")
                                        .font(.caption).foregroundColor(.secondary).lineLimit(2)
                                }
                            }
                            .padding(.vertical, 4)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        .contextMenu {
                            Button("Open") { nav.push(.question(packId: pack.id, questionId: q.id)) }
                        }
                    }
                }
            }
        }
        .listStyle(.inset)
    }

    /// 0 = no match, higher = better match.
    ///   100  title starts with query   (best)
    ///    50  title contains query
    ///    10  any explanation contains query
    private func scoreConcept(_ c: Concept, _ q: String) -> Int {
        let opts: String.CompareOptions = [.caseInsensitive, .diacriticInsensitive]
        if let r = c.title.range(of: q, options: opts) {
            return r.lowerBound == c.title.startIndex ? 100 : 50
        }
        for v in c.explanations.values {
            if v.range(of: q, options: opts) != nil { return 10 }
        }
        return 0
    }

    /// 0 = no match, higher = better match.
    ///   100  prompt starts with query
    ///    50  prompt contains query
    ///    20  answer contains query   (answer matches rank below prompt
    ///         matches because answers are short — "true" matches too much)
    private func scoreQuestion(_ qn: Question, _ q: String) -> Int {
        let opts: String.CompareOptions = [.caseInsensitive, .diacriticInsensitive]
        if let r = qn.prompt.range(of: q, options: opts) {
            return r.lowerBound == qn.prompt.startIndex ? 100 : 50
        }
        if qn.answer.range(of: q, options: opts) != nil { return 20 }
        return 0
    }
}
