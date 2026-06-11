import SwiftUI
import AppKit

/// Revision-tier enrichment card that opens the chapter's
/// "Common Mistakes" article. Same shape as BeyondTheBookCard but
/// uses an orange/red theme so the two cards are visually
/// distinguished when they sit side-by-side in the HStack.
///
/// Lifted out of ChapterDetailView.swift on 2026-05-26 to keep that
/// file under the 600-LOC Big Sur ceiling. The card was originally
/// added inline; splitting cards into sister files matches the
/// existing pattern used for ChapterDetailView+HomeExperiments.swift
/// and ChapterDetailView+PropagatedCTAs.swift.
///
/// Access level: file-internal (default). The cross-file consumer is
/// `ChapterDetailView` in `ChapterDetailView.swift`, which references
/// `CommonMistakesCard` directly — `private` would block the cross-
/// file reference.
struct CommonMistakesCard: View {
    let entry: ArticleEntry
    let onTap: () -> Void
    @State private var isHovered = false

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: DesignTokens.Spacing.sm) {
                    Text("⚠️")
                        .font(.system(size: 26))
                    Text("Common Mistakes")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                Text(entry.title)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.92))
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                Text("≈ \(entry.estimatedMinutes) min read · revision-tier")
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.85))
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: DesignTokens.Radius.card, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                // Warm orange → red, distinct from
                                // BeyondTheBookCard's indigo gradient.
                                Color(red: 0.88, green: 0.45, blue: 0.30),
                                Color(red: 0.78, green: 0.30, blue: 0.35)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
            )
            .scaleEffect(isHovered ? 1.01 : 1.0)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        // Hover gated on Reduce Motion — matches BeyondTheBookCard's
        // accessibility behaviour.
        .onHover { hovering in
            isHovered = hovering && !NSWorkspace.shared.accessibilityDisplayShouldReduceMotion
        }
        .accessibilityIdentifier("common-mistakes")
        .accessibilityLabel("Common Mistakes")
        .accessibilityHint("Opens a revision article covering wrong answers Class 7 students commonly give.")
    }
}
