import SwiftUI
import AppKit

// MARK: - MisconceptionsSectionView
//
// Surfaces `chapter.misconceptions: [Misconception]?` on the chapter
// detail page. Pre-empts the common-mistakes a Class-7 student is most
// likely to make — "kids often think X / actually Y" pairs.
//
// Mounted by `ChapterDetailView` below the NCERT Q&A panel and above
// the topic-cards block. Auto-hides when `chapter.misconceptions` is
// nil/empty. Uses `CollapsibleContentSection` for the disclosure.

struct MisconceptionsSectionView: View {
    let chapter: Chapter

    private var entries: [Misconception] { chapter.misconceptionsList }

    var body: some View {
        if !entries.isEmpty {
            CollapsibleContentSection(
                title: "Common mistakes",
                icon: "exclamationmark.bubble.fill",
                badgeCount: entries.count,
                tint: .compatBrown,
                storageKey: "\(chapter.id).misconceptions"
            ) {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(entries) { entry in
                        MisconceptionCard(entry: entry)
                    }
                }
            }
        }
    }
}

// MARK: - MisconceptionCard

private struct MisconceptionCard: View {
    let entry: Misconception

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // "Kids often think:" line — the wrong belief, marked
            // with a strikethrough hint via secondary color.
            HStack(alignment: .top, spacing: 8) {
                Text("Kids often think:")
                    .font(.caption.weight(.bold))
                    .foregroundColor(Color.compatBrown)
                    .textCase(.uppercase)
                Spacer(minLength: 0)
            }
            Text(entry.kidsThink)
                .font(.callout)
                .foregroundColor(.secondary)
                .italic()
                .fixedSize(horizontal: false, vertical: true)

            Divider()
                .padding(.vertical, 2)

            // "Actually:" line — the correction.
            HStack(alignment: .top, spacing: 8) {
                Text("Actually:")
                    .font(.caption.weight(.bold))
                    .foregroundColor(Color.compatTeal)
                    .textCase(.uppercase)
                Spacer(minLength: 0)
            }
            Text(entry.actually)
                .font(.callout)
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.secondary.opacity(0.25), lineWidth: 1)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Common mistake. Kids often think: \(entry.kidsThink). Actually: \(entry.actually)")
    }
}
