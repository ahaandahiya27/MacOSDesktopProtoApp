import SwiftUI

// MARK: - CrossChapterRefsFooter
//
// "Connected ideas" footer on the chapter detail page. Lists the
// chapter's `crossChapterRefs[]` as tappable rows; tapping pushes the
// referenced chapter onto the navigation stack so the kid can jump
// straight in.
//
// Auto-hides when the chapter has no cross-refs authored.

struct CrossChapterRefsFooter: View {
    let pack: SubjectPack
    let chapter: Chapter

    @EnvironmentObject private var nav: TutorNavigationState

    private var refs: [CrossChapterRef] { chapter.crossChapterRefsList }

    var body: some View {
        if !refs.isEmpty {
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: DesignTokens.Spacing.sm) {
                    Image(systemName: SFSymbolCompat.name("link.circle.fill"))
                        .font(.title3)
                        .foregroundColor(Color.compatTeal)
                        .accessibilityHidden(true)
                    Text("Connected ideas")
                        .font(.headline)
                        .accessibilityAddTraits(.isHeader)
                    Spacer()
                }
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                    ForEach(refs) { ref in
                        CrossChapterRefRow(ref: ref, onJump: {
                            // Defer nav.push to the next runloop tick —
                            // same dismantle-order pattern as the other
                            // ChapterDetail navigation push sites.
                            let packId = pack.id
                            let toId = ref.toChapterId
                            DispatchQueue.main.async {
                                nav.push(.chapter(packId: packId, chapterId: toId))
                            }
                        })
                    }
                }
            }
            .padding(DesignTokens.Spacing.lg)
            .background(
                RoundedRectangle(cornerRadius: DesignTokens.Radius.card)
                    .fill(Color.compatTeal.opacity(0.06))
            )
        }
    }
}

// MARK: - CrossChapterRefRow

private struct CrossChapterRefRow: View {
    let ref: CrossChapterRef
    let onJump: () -> Void

    var body: some View {
        Button(action: onJump) {
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: SFSymbolCompat.name("arrowshape.right.fill"))
                    .font(.body)
                    .foregroundColor(Color.compatTeal)
                    .frame(width: 22, alignment: .center)
                    .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: 3) {
                    Text(ref.topic)
                        .font(.callout.weight(.semibold))
                        .foregroundColor(.primary)
                    Text(ref.pointer)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer(minLength: 0)
                Image(systemName: "chevron.right")
                    .font(.caption.weight(.bold))
                    .foregroundColor(.secondary)
                    .accessibilityHidden(true)
            }
            .padding(10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
                    .fill(Color.gray.opacity(0.08))
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .pointingCursor()
        .accessibilityLabel("\(ref.topic). \(ref.pointer)")
        .accessibilityHint("Jumps to the linked chapter.")
        .accessibilityIdentifier("cross-chapter-ref-row-\(ref.id)")
    }
}
