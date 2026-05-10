import SwiftUI

/// Cross-subject full-text search. Matches against:
///   • Concept titles and all four explanation depths
///   • Question prompts and answers
/// Results are grouped by subject pack.
struct SearchView: View {
    @EnvironmentObject var subjectRegistry: SubjectRegistry
    @State private var query: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                TextField("Search across all subjects", text: $query)
                    .textFieldStyle(.plain)
                    .font(.title3)
                if !query.isEmpty {
                    Button {
                        query = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Clear search")
                }
            }
            .padding(12)
            .background(.background.secondary, in: RoundedRectangle(cornerRadius: 10))
            .padding(16)

            Divider()

            if query.trimmingCharacters(in: .whitespaces).isEmpty {
                ContentUnavailableView(
                    "Search across all subjects",
                    systemImage: "magnifyingglass",
                    description: Text("Type any phrase to find concepts and questions across every loaded pack.")
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                resultsList
            }
        }
        .navigationTitle("Search")
    }

    private var resultsList: some View {
        let trimmed = query.trimmingCharacters(in: .whitespaces)
        let matches = subjectRegistry.packs.compactMap { pack -> (SubjectPack, [Concept], [Question])? in
            let cs = pack.allConcepts.filter { matchesConcept($0, trimmed) }
            let qs = pack.allQuestions.filter { matchesQuestion($0, trimmed) }
            if cs.isEmpty && qs.isEmpty { return nil }
            return (pack, cs, qs)
        }

        return List {
            ForEach(matches, id: \.0.id) { pack, concepts, questions in
                Section(pack.title) {
                    ForEach(concepts) { c in
                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: "lightbulb.fill")
                                .foregroundStyle(.indigo)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(c.title).font(.headline)
                                Text(c.explanation(at: .oneLine))
                                    .font(.caption).foregroundStyle(.secondary).lineLimit(2)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    ForEach(questions) { q in
                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: "questionmark.app.fill")
                                .foregroundStyle(.orange)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(q.prompt).font(.body).lineLimit(2)
                                Text("Answer: \(q.answer)")
                                    .font(.caption).foregroundStyle(.secondary).lineLimit(1)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            if matches.isEmpty {
                Text("No matches.").foregroundStyle(.secondary)
            }
        }
        .listStyle(.inset)
    }

    // MARK: - Matching

    private func matchesConcept(_ c: Concept, _ q: String) -> Bool {
        if c.title.range(of: q, options: [.caseInsensitive, .diacriticInsensitive]) != nil { return true }
        for v in c.explanations.values {
            if v.range(of: q, options: [.caseInsensitive, .diacriticInsensitive]) != nil { return true }
        }
        return false
    }

    private func matchesQuestion(_ qn: Question, _ q: String) -> Bool {
        if qn.prompt.range(of: q, options: [.caseInsensitive, .diacriticInsensitive]) != nil { return true }
        if qn.answer.range(of: q, options: [.caseInsensitive, .diacriticInsensitive]) != nil { return true }
        return false
    }
}
