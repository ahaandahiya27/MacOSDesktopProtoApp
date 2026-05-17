import SwiftUI

/// Global ⌘K command palette. Indexes every chapter, topic, concept, and
/// question across all loaded subject packs and lets the user jump anywhere
/// in 2–3 keystrokes.
///
/// Navigation strategy: when the user picks a result, we
///   1. dismiss the palette,
///   2. switch the sidebar to Quiz Bank (the universal browser that knows
///      how to render any subject's TutorNavigationContainer),
///   3. fire the .openTutorRoute notification so the new container pushes
///      the chosen route at depth 1.
struct CommandPalette: View {
    var onDismiss: () -> Void

    @EnvironmentObject private var subjectRegistry: SubjectRegistry
    @EnvironmentObject private var appState: AppState
    @State private var query: String = ""
    @State private var selectedIndex: Int = 0

    // MARK: - Entry types

    enum Kind: String { case chapter, topic, concept, question }

    struct Entry: Identifiable {
        let id: String
        let pack: SubjectPack
        let kind: Kind
        let title: String
        let subtitle: String?
        let route: TutorRoute
    }

    // MARK: - Index

    /// Built once per palette open. Cheap: a few thousand entries at most.
    private var allEntries: [Entry] {
        var out: [Entry] = []
        for pack in subjectRegistry.packs {
            for chapter in pack.chapters {
                out.append(Entry(
                    id: "\(pack.id)::\(chapter.id)",
                    pack: pack, kind: .chapter,
                    title: "Ch. \(chapter.number) — \(chapter.title)",
                    subtitle: pack.title,
                    route: .chapter(packId: pack.id, chapterId: chapter.id)
                ))
                for topic in chapter.topics {
                    out.append(Entry(
                        id: "\(pack.id)::\(topic.id)",
                        pack: pack, kind: .topic,
                        title: topic.title,
                        subtitle: "\(pack.title) · Ch. \(chapter.number)",
                        route: .topic(packId: pack.id, topicId: topic.id)
                    ))
                    for concept in topic.concepts {
                        out.append(Entry(
                            id: "\(pack.id)::\(concept.id)",
                            pack: pack, kind: .concept,
                            title: concept.title,
                            subtitle: "\(pack.title) · Ch. \(chapter.number) · \(topic.title)",
                            route: .concept(packId: pack.id, conceptId: concept.id)
                        ))
                    }
                    for question in topic.questions {
                        out.append(Entry(
                            id: "\(pack.id)::\(question.id)",
                            pack: pack, kind: .question,
                            title: question.prompt,
                            subtitle: "\(pack.title) · Ch. \(chapter.number) · \(topic.title)",
                            route: .question(packId: pack.id, questionId: question.id)
                        ))
                    }
                }
            }
        }
        return out
    }

    private var filtered: [Entry] {
        let q = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !q.isEmpty else {
            // Empty query: show a small mix (top of each pack) so the
            // palette isn't blank on first open.
            return Array(allEntries.prefix(40))
        }
        // Score by simple "contains" priority: title prefix > title contains > subtitle contains.
        let scored: [(Entry, Int)] = allEntries.compactMap { e in
            let t = e.title.lowercased()
            let s = e.subtitle?.lowercased() ?? ""
            if t.hasPrefix(q) { return (e, 0) }
            if t.contains(q)  { return (e, 1) }
            if s.contains(q)  { return (e, 2) }
            return nil
        }
        return scored.sorted { $0.1 < $1.1 }.map(\.0).prefix(60).map { $0 }
    }

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            queryField
            Divider()
            if filtered.isEmpty {
                emptyResults
            } else {
                resultsList
            }
            Divider()
            footerHints
        }
        .frame(minWidth: 580, idealWidth: 680, maxWidth: 820,
               minHeight: 440, idealHeight: 560, maxHeight: 720)
        .background(keyboardSink)
    }

    private var queryField: some View {
        HStack(spacing: 10) {
            Image(systemName: "command")
                .font(.title3)
                .foregroundColor(.secondary)
                .accessibilityHidden(true)
            TextField("Type to search across every chapter, topic, concept, and question…",
                      text: $query)
                .textFieldStyle(.plain)
                .font(.title3)
                .onChange(of: query) { _ in selectedIndex = 0 }
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
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
    }

    private var resultsList: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 0) {
                    ForEach(Array(filtered.enumerated()), id: \.element.id) { idx, entry in
                        row(for: entry, isSelected: idx == selectedIndex)
                            .id(idx)
                            .onTapGesture { open(entry) }
                            .pointingCursor()
                    }
                }
                .padding(.vertical, 6)
            }
            .onChange(of: selectedIndex) { idx in
                withAnimation(.easeOut(duration: 0.12)) {
                    proxy.scrollTo(idx, anchor: .center)
                }
            }
        }
    }

    private func row(for entry: Entry, isSelected: Bool) -> some View {
        HStack(spacing: 12) {
            Text(kindEmoji(entry.kind))
                .font(.title3)
                .frame(width: 28)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 2) {
                Text(entry.title)
                    .font(.body)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .foregroundColor(isSelected ? .white : .primary)
                    .devanagariAwareLocale(packId: entry.pack.id)
                if let s = entry.subtitle {
                    Text(s)
                        .font(.caption)
                        .foregroundColor(isSelected ? Color.white.opacity(0.85) : .secondary)
                        .lineLimit(1)
                }
            }
            Spacer(minLength: 8)
            Text(entry.pack.coverEmoji)
                .accessibilityHidden(true)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(isSelected ? Color.compatIndigo : Color.clear)
        .contentShape(Rectangle())
    }

    private var emptyResults: some View {
        VStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 36))
                .foregroundColor(.secondary)
                .accessibilityHidden(true)
            Text("No results")
                .font(.headline)
            Text("Try a single word, or part of a chapter title.")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var footerHints: some View {
        HStack(spacing: 14) {
            Label("↑ ↓ navigate", systemImage: "arrow.up.arrow.down")
                .font(.caption2)
            Label("↩ open", systemImage: "return")
                .font(.caption2)
            Label("Esc close", systemImage: "escape")
                .font(.caption2)
            Spacer()
            Text("\(filtered.count) result\(filtered.count == 1 ? "" : "s")")
                .font(.caption2.monospacedDigit())
                .foregroundColor(.secondary)
        }
        .foregroundColor(.secondary)
        .padding(.horizontal, 18)
        .padding(.vertical, 8)
    }

    // MARK: - Keyboard

    /// Invisible Buttons that drive arrow / return / escape shortcuts.
    private var keyboardSink: some View {
        ZStack {
            Button(action: moveDown) { EmptyView() }
                .keyboardShortcut(.downArrow, modifiers: [])
            Button(action: moveUp)   { EmptyView() }
                .keyboardShortcut(.upArrow, modifiers: [])
            Button(action: openSelected) { EmptyView() }
                .keyboardShortcut(.return, modifiers: [])
                .disabled(filtered.isEmpty)
            Button(action: onDismiss) { EmptyView() }
                .keyboardShortcut(.cancelAction)
        }
        .frame(width: 0, height: 0)
        .opacity(0)
    }

    private func moveDown() {
        guard !filtered.isEmpty else { return }
        selectedIndex = min(selectedIndex + 1, filtered.count - 1)
    }
    private func moveUp() {
        guard !filtered.isEmpty else { return }
        selectedIndex = max(selectedIndex - 1, 0)
    }
    private func openSelected() {
        guard filtered.indices.contains(selectedIndex) else { return }
        open(filtered[selectedIndex])
    }

    private func open(_ entry: Entry) {
        onDismiss()
        // For a question, populate Prev/Next siblings = every other question
        // in the same topic, so ⌘← / ⌘→ work after the palette lands the
        // user. Non-question routes get an empty sibling list.
        let siblings = siblingRefs(for: entry)
        // Stage the route in AppState first, THEN flip the sidebar. The
        // TutorNavigationContainer that mounts (or is already mounted) reads
        // pendingRoute on appear AND on change — no notification timing race.
        appState.pendingRoute = PendingRoute(route: entry.route, siblings: siblings)
        appState.sidebarSelection = .quizBank
    }

    private func siblingRefs(for entry: Entry) -> [QuestionRef] {
        guard case .question(_, let qid) = entry.route else { return [] }
        for chapter in entry.pack.chapters {
            for topic in chapter.topics where topic.questions.contains(where: { $0.id == qid }) {
                return topic.questions.map {
                    QuestionRef(packId: entry.pack.id, questionId: $0.id)
                }
            }
        }
        return []
    }

    private func kindEmoji(_ kind: Kind) -> String {
        switch kind {
        case .chapter:  return "📚"
        case .topic:    return "📑"
        case .concept:  return "💡"
        case .question: return "❓"
        }
    }
}
