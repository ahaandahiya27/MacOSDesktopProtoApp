import SwiftUI
import AppKit

// MARK: - GlossarySheet
//
// Per-chapter glossary surfaced from a small "Glossary" button on the
// chapter detail page (and a Help-menu entry "Show Glossary for
// Current Chapter"). Sheet shows alphabetical terms with one-line
// definitions; tap a term to expand it to the optional example +
// optional Hindi translation.

struct GlossarySheet: View {
    let chapter: Chapter
    var onDismiss: () -> Void

    private var sortedTerms: [GlossaryTerm] {
        chapter.glossaryList.sorted { $0.term.localizedCaseInsensitiveCompare($1.term) == .orderedAscending }
    }

    @State private var expandedTermId: String?

    var body: some View {
        VStack(spacing: 0) {
            header
            Divider()
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    if sortedTerms.isEmpty {
                        emptyState
                    } else {
                        ForEach(sortedTerms) { term in
                            GlossaryTermRow(
                                term: term,
                                isExpanded: expandedTermId == term.id,
                                onToggle: { toggle(term.id) }
                            )
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 18)
                .frame(maxWidth: 700, alignment: .leading)
                .frame(maxWidth: .infinity, alignment: .center)
            }
            Divider()
            footer
        }
        .frame(minWidth: 520, idealWidth: 640, maxWidth: 760,
               minHeight: 420, idealHeight: 560, maxHeight: 740)
        .background(Color(NSColor.windowBackgroundColor))
        .background(
            Button("Dismiss", action: onDismiss)
                .keyboardShortcut(.cancelAction)
                .opacity(0)
                .frame(width: 0, height: 0)
                .accessibilityHidden(true)
        )
    }

    private var header: some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: SFSymbolCompat.name("character.book.closed"))
                .font(.title2)
                .foregroundColor(Color.compatIndigo)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 3) {
                Text("Glossary")
                    .font(.title2.bold())
                Text("Ch. \(chapter.number) — \(chapter.title)")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.secondary)
            }
            Spacer(minLength: 0)
            Button(action: onDismiss) {
                Image(systemName: "xmark.circle.fill")
                    .font(.title3)
                    .foregroundColor(.secondary)
            }
            .buttonStyle(.plain)
            .pointingCursor()
            .accessibilityLabel("Close glossary")
        }
        .padding(.horizontal, 24)
        .padding(.top, 20)
        .padding(.bottom, 14)
    }

    private var footer: some View {
        HStack {
            Text(sortedTerms.isEmpty ? "" : "\(sortedTerms.count) term\(sortedTerms.count == 1 ? "" : "s")")
                .font(.caption)
                .foregroundColor(.secondary)
            Spacer()
            Button("Done", action: onDismiss)
                .keyboardShortcut(.defaultAction)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
    }

    private var emptyState: some View {
        VStack(spacing: 8) {
            Image(systemName: "book.closed")
                .font(.system(size: 36))
                .foregroundColor(.secondary)
                .accessibilityHidden(true)
            Text("No glossary terms authored for this chapter yet.")
                .font(.callout)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }

    private func toggle(_ id: String) {
        withAnimationRespectingReduceMotion(.easeOut(duration: 0.18)) {
            expandedTermId = (expandedTermId == id) ? nil : id
        }
    }
}

// MARK: - GlossaryTermRow

private struct GlossaryTermRow: View {
    let term: GlossaryTerm
    let isExpanded: Bool
    let onToggle: () -> Void

    var body: some View {
        Button(action: onToggle) {
            VStack(alignment: .leading, spacing: 6) {
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Text(term.term)
                        .font(.headline)
                        .foregroundColor(Color.compatIndigo)
                    if let hindi = term.hindiTerm, !hindi.isEmpty {
                        Text("(\(hindi))")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    Spacer(minLength: 0)
                    Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                        .font(.caption.weight(.bold))
                        .foregroundColor(.secondary)
                }
                Text(term.definition)
                    .font(.callout)
                    .foregroundColor(.primary)
                    .lineLimit(isExpanded ? nil : 2)
                    .fixedSize(horizontal: false, vertical: true)
                if isExpanded, let example = term.example, !example.isEmpty {
                    HStack(alignment: .top, spacing: 6) {
                        Text("Example:")
                            .font(.caption.weight(.semibold))
                            .foregroundColor(.secondary)
                        Text(example)
                            .font(.callout)
                            .foregroundColor(.secondary)
                            .italic()
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.top, 2)
                }
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(isExpanded ? Color.compatIndigo.opacity(0.08) : Color.gray.opacity(0.08))
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .pointingCursor()
        .accessibilityLabel("\(term.term): \(term.definition)")
        .accessibilityHint(isExpanded ? "Tap to collapse this term." : "Tap to see an example.")
    }
}
