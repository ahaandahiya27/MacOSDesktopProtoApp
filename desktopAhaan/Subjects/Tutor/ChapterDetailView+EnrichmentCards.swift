import SwiftUI
import AppKit

// MARK: - ChapterDetailView enrichment cards
//
// BeyondTheBookCard + TryAtHomeCard, lifted out of ChapterDetailView.swift to
// keep the parent under the 600-LOC Big Sur (Swift 5.5) type-checker ceiling —
// same pattern as ChapterDetailView+CommonMistakesCard.swift and
// ChapterDetailView+HomeExperiments.swift. Both are self-contained
// closure-driven cards (no coupling to ChapterDetailView's private state), so
// the move is behaviour-preserving. They drop `private` to `internal` so the
// parent file can still reference them.
//
// Big Sur compat: plain Button + LinearGradient + RoundedRectangle; the 1%
// hover scale is Reduce-Motion-gated.

// MARK: - Beyond the Book card

struct BeyondTheBookCard: View {
    let entry: ArticleEntry
    let onTap: () -> Void
    @State private var isHovered = false

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: DesignTokens.Spacing.sm) {
                    Text("📖")
                        .font(.system(size: 26))
                    Text("Beyond the Book")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                Text(entry.title)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.92))
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                Text("≈ \(entry.estimatedMinutes) min read")
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.85))
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.45, green: 0.30, blue: 0.65),
                                Color(red: 0.25, green: 0.40, blue: 0.70)
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
        // Hover scale is a motion cue — gate it on Reduce Motion so
        // accessibility users don't get the 1% pulse on every chapter
        // detail card. The opacity-only TopicCard hover stays unchanged.
        .onHover { hovering in
            isHovered = hovering && !NSWorkspace.shared.accessibilityDisplayShouldReduceMotion
        }
        .accessibilityIdentifier("beyond-the-book")
        .accessibilityLabel("Beyond the Book")
        .accessibilityHint("Opens a long-form enrichment article for this chapter.")
    }
}

// MARK: - Try at Home card

struct TryAtHomeCard: View {
    /// Per-chapter copy derived from HomeExperimentLibrary (not hardcoded).
    var subtitle: String = "Hands-on experiments you can do this weekend."
    var count: Int = 5
    let onTap: () -> Void
    @State private var isHovered = false

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: DesignTokens.Spacing.sm) {
                    Text("🧪")
                        .font(.system(size: 26))
                    Text("Try at Home")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.92))
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                Text("\(count) experiment\(count == 1 ? "" : "s")")
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.85))
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.85, green: 0.45, blue: 0.25),
                                Color(red: 0.65, green: 0.30, blue: 0.50)
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
        // Hover scale is a motion cue — gate it on Reduce Motion so
        // accessibility users don't get the 1% pulse on every chapter
        // detail card. The opacity-only TopicCard hover stays unchanged.
        .onHover { hovering in
            isHovered = hovering && !NSWorkspace.shared.accessibilityDisplayShouldReduceMotion
        }
        .accessibilityLabel("Try at Home")
        .accessibilityHint("Opens hands-on home experiments for this chapter.")
    }
}
