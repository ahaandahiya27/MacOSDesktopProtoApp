import SwiftUI

// MARK: - ChapterStuckHereStrip
//
// Surfaces three chapter-scoped learning signals at the top of
// `ChapterDetailView`:
//
//   ⚠️ Tough           — questions the kid flagged "review later"
//   ❌ Recently missed — questions whose SRS bucket has dropped to ≤ 1
//   🔖 Bookmarked      — concepts the kid bookmarked
//
// The widget auto-hides when all three rows are empty so a fresh-
// install kid sees nothing. The derivation is a `nonisolated static`
// function so the unit tests can pin behaviour without spinning up an
// EnvironmentObject (same pattern as `RelatedChaptersStrip` from
// commit 011cfac).

/// Per-chapter signal payload. The view renders each non-empty row;
/// an entirely-empty payload yields `EmptyView()` and the strip
/// disappears.
struct StuckSignals: Equatable, Hashable {
    let toughQuestionIds: [String]
    let recentlyMissedQuestionIds: [String]
    let bookmarkedConceptIds: [String]

    var isEmpty: Bool {
        toughQuestionIds.isEmpty
            && recentlyMissedQuestionIds.isEmpty
            && bookmarkedConceptIds.isEmpty
    }
}

struct ChapterStuckHereStrip: View {
    let pack: SubjectPack
    let chapter: Chapter
    let signals: StuckSignals
    /// Tap handler so the parent (`ChapterDetailView`) routes the
    /// chip click through its `tutorNavigation` push API. Keeps the
    /// strip free of EnvironmentObject coupling — easier to test +
    /// reuse.
    let onTapQuestion: (String) -> Void
    let onTapConcept: (String) -> Void

    var body: some View {
        if signals.isEmpty {
            EmptyView()
        } else {
            VStack(alignment: .leading, spacing: 10) {
                Text("Stuck here?")
                    .font(.headline)
                if !signals.toughQuestionIds.isEmpty {
                    chipRow(
                        emoji: "⚠️",
                        label: "Tough",
                        ids: signals.toughQuestionIds,
                        kind: .question
                    )
                }
                if !signals.recentlyMissedQuestionIds.isEmpty {
                    chipRow(
                        emoji: "❌",
                        label: "Recently missed",
                        ids: signals.recentlyMissedQuestionIds,
                        kind: .question
                    )
                }
                if !signals.bookmarkedConceptIds.isEmpty {
                    chipRow(
                        emoji: "🔖",
                        label: "Bookmarked",
                        ids: signals.bookmarkedConceptIds,
                        kind: .concept
                    )
                }
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(DesignTokens.BrandColor.tryAtHome.opacity(0.08))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(
                        DesignTokens.BrandColor.tryAtHome.opacity(0.30),
                        lineWidth: 1
                    )
            )
            .accessibilityElement(children: .contain)
            .accessibilityLabel(a11yLabel())
        }
    }

    // MARK: - Per-row chip strip

    private enum ChipKind { case question, concept }

    @ViewBuilder
    private func chipRow(
        emoji: String,
        label: String,
        ids: [String],
        kind: ChipKind
    ) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 6) {
                Text(emoji).accessibilityHidden(true)
                Text(label)
                    .font(.caption.weight(.semibold))
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                Spacer(minLength: 0)
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(ids, id: \.self) { id in
                        Button {
                            switch kind {
                            case .question: onTapQuestion(id)
                            case .concept: onTapConcept(id)
                            }
                        } label: {
                            Text(chipLabel(for: id, kind: kind))
                                .font(.callout)
                                .foregroundColor(DesignTokens.BrandColor.canvasText)
                                .lineLimit(1)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(
                                    Capsule().fill(Color.white)
                                )
                                .overlay(
                                    Capsule().strokeBorder(
                                        Color.gray.opacity(0.30),
                                        lineWidth: 1
                                    )
                                )
                        }
                        .buttonStyle(.plain)
                        .pointingCursor()
                        .accessibilityLabel("\(label): \(chipLabel(for: id, kind: kind))")
                    }
                }
                .padding(.horizontal, 1)
            }
        }
    }

    /// Lookup prompt / title from the loaded pack. Falls back to the
    /// raw id if the registry doesn't know it (e.g. ephemeral
    /// boss-quiz ids in the recently-missed row).
    private func chipLabel(for id: String, kind: ChipKind) -> String {
        switch kind {
        case .question:
            // First-match lookup across this chapter's questions.
            for topic in chapter.topics {
                if let q = topic.questions.first(where: { $0.id == id }) {
                    return q.prompt
                }
            }
            return id
        case .concept:
            for topic in chapter.topics {
                if let c = topic.concepts.first(where: { $0.id == id }) {
                    return c.title
                }
            }
            return id
        }
    }

    private func a11yLabel() -> String {
        var parts: [String] = []
        if !signals.toughQuestionIds.isEmpty {
            parts.append("\(signals.toughQuestionIds.count) flagged tough")
        }
        if !signals.recentlyMissedQuestionIds.isEmpty {
            parts.append("\(signals.recentlyMissedQuestionIds.count) recently missed")
        }
        if !signals.bookmarkedConceptIds.isEmpty {
            parts.append("\(signals.bookmarkedConceptIds.count) bookmarked concept\(signals.bookmarkedConceptIds.count == 1 ? "" : "s")")
        }
        return "Stuck here panel: " + parts.joined(separator: ", ")
    }
}

// MARK: - Derivation (pure, testable)

extension ChapterStuckHereStrip {

    /// Compute the chapter-scoped intersections from the three
    /// global signal sets. Pure function — no EnvironmentObject, no
    /// DataStore reach — so the unit tests can pass synthetic Sets
    /// and assert the output.
    ///
    /// Each output array preserves the order of the matching ids
    /// against the chapter's own id sequence (`allQuestionIds` /
    /// `allConceptIds`). That keeps the chip-row visual stable
    /// across re-renders when the global signal set shifts.
    static func signals(
        chapter: Chapter,
        toughQuestionIds: Set<String>,
        recentlyMissedIds: [String],
        bookmarkedConceptIds: Set<String>
    ) -> StuckSignals {
        let chapterQIds = Set(chapter.allQuestionIds)
        let chapterCIds = Set(chapter.allConceptIds)

        let tough = chapter.allQuestionIds.filter { toughQuestionIds.contains($0) }

        // Recently-missed is already ordered most-recent-first by
        // the aggregator; preserve that order here too. Filter to
        // chapter scope.
        let recent = recentlyMissedIds.filter { chapterQIds.contains($0) }

        let bookmarked = chapter.allConceptIds.filter { bookmarkedConceptIds.contains($0) }
        // Defensive — drop concepts that weren't in the chapter.
        _ = chapterCIds  // silence the unused warning when filter logic above changes

        return StuckSignals(
            toughQuestionIds: tough,
            recentlyMissedQuestionIds: recent,
            bookmarkedConceptIds: bookmarked
        )
    }
}
