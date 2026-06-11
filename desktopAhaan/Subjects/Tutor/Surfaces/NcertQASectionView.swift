import SwiftUI
import AppKit

// MARK: - NcertQASectionView
//
// Surfaces `chapter.ncertQA: [NcertQAEntry]?` on the chapter detail
// page. These are the canonical NCERT textbook questions with model
// answers — highest pedagogical user-value of the previously
// unrendered content types.
//
// Mounted by `ChapterDetailView` between the enrichment row and the
// topic-cards block. Auto-hides when `chapter.ncertQA` is nil/empty.
//
// Each entry renders as a tappable row: question line, "Show answer"
// reveal that swaps in the modelAnswer + optional textbook page
// reference. Uses `CollapsibleContentSection` for the outer disclosure.

struct NcertQASectionView: View {
    let chapter: Chapter

    private var entries: [NcertQAEntry] { chapter.ncertQA ?? [] }

    var body: some View {
        if !entries.isEmpty {
            CollapsibleContentSection(
                title: "NCERT textbook questions",
                icon: "text.book.closed.fill",
                badgeCount: entries.count,
                tint: .compatCyan,
                storageKey: "\(chapter.id).ncertQA"
            ) {
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
                    ForEach(entries) { entry in
                        NcertQARow(entry: entry)
                    }
                }
            }
        }
    }
}

// MARK: - NcertQARow

private struct NcertQARow: View {
    let entry: NcertQAEntry
    @State private var isShowingAnswer = false

    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
            HStack(alignment: .top, spacing: DesignTokens.Spacing.sm) {
                Text("Q.")
                    .font(.callout.weight(.bold))
                    .foregroundColor(Color.compatCyan)
                Text(entry.question)
                    .font(.callout.weight(.semibold))
                    .fixedSize(horizontal: false, vertical: true)
                Spacer(minLength: 0)
            }
            answerSection
        }
        .padding(DesignTokens.Spacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
                .stroke(Color.secondary.opacity(0.25), lineWidth: 1)
        )
        .accessibilityElement(children: .contain)
        .accessibilityLabel("NCERT question: \(entry.question)")
        .accessibilityHint(isShowingAnswer
            ? "Tap the toggle to hide the model answer."
            : "Tap 'Show model answer' to reveal the textbook answer.")
    }

    @ViewBuilder
    private var answerSection: some View {
        if isShowingAnswer {
            VStack(alignment: .leading, spacing: 6) {
                HStack(alignment: .top, spacing: DesignTokens.Spacing.sm) {
                    Text("A.")
                        .font(.callout.weight(.bold))
                        .foregroundColor(Color.compatCyan)
                    Text(entry.modelAnswer)
                        .font(.callout)
                        .fixedSize(horizontal: false, vertical: true)
                }
                if let page = entry.textbookPage {
                    HStack(spacing: DesignTokens.Spacing.xs) {
                        Image(systemName: SFSymbolCompat.name("book.closed"))
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        Text("NCERT textbook page \(page)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.leading, 18)
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Textbook page \(page)")
                }
                Button("Hide answer") {
                    withAnimationRespectingReduceMotion(.easeOut(duration: 0.18)) {
                        isShowingAnswer = false
                    }
                }
                .buttonStyle(.borderless)
                .accentColor(Color.compatCyan)
                .accessibilityHint("Collapses the model answer.")
            }
            .padding(.leading, DesignTokens.Spacing.xs)
            .transition(.opacity)
        } else {
            Button("Show model answer") {
                withAnimationRespectingReduceMotion(.easeOut(duration: 0.18)) {
                    isShowingAnswer = true
                }
            }
            .buttonStyle(.bordered)
            .accentColor(Color.compatCyan)
            .accessibilityHint("Reveals the NCERT textbook's model answer for this question.")
        }
    }
}
