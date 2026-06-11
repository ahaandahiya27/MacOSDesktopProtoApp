import SwiftUI
import AppKit

// MARK: - DeepDiveSection
//
// "Go deeper" disclosure on the chapter detail page. Surfaces the
// chapter's grade-tagged stretch topics (`Chapter.deepDive`) to fast
// learners.
//
// Why this view exists:
//   - The schema (`StretchTopic`, `Chapter.deepDive: [StretchTopic]?`)
//     and the JSON authoring shipped in earlier sessions, but no view
//     consumed the data. The kid never saw it. This is the smallest
//     useful surface that closes that gap.
//
// Big Sur compatibility notes:
//   - `DisclosureGroup` is macOS 10.15+ ✅
//   - All colors go through `Color.compat*` (incl. the new compatBlue/
//     compatPurple needed by `GradeLevel.badgeTint`).
//   - The expand/collapse uses `respectReduceMotion(animation:)` so
//     users with Reduce Motion on get an instant disclosure.
//   - `@ViewBuilder` direct-child count kept ≤ 10 by grouping rows
//     inside a single `ForEach` block.
//
// Wiring: `ChapterDetailView.body` appends `DeepDiveSection(chapter:)`
// at the bottom of its main VStack (after the topic cards) when the
// chapter has ≥ 1 `StretchTopic`. Hidden when empty.

struct DeepDiveSection: View {
    let chapter: Chapter

    /// Persistent across chapter switches so the kid's last open/closed
    /// preference survives navigation. One global preference (not
    /// per-chapter) — Rohan tested with two kids and per-chapter felt
    /// like noise.
    @AppStorage(AppStorageKeys.deepDiveDisclosureExpanded) private var isExpanded: Bool = false

    /// "NEW!" badge counter — the badge shows until the kid has opened
    /// a chapter 3 times AFTER this feature shipped. After that, the
    /// disclosure stands on its own.
    @AppStorage(AppStorageKeys.goDeeperNewBadgeShownCount) private var newBadgeCount: Int = 0

    @State private var presentedTopic: StretchTopic?

    /// The kid's chapter has at least one stretch topic if and only if
    /// JSON authoring shipped one. Hide the whole section if not.
    private var stretchTopics: [StretchTopic] { chapter.deepDiveList }

    /// Show the "NEW!" pill until the kid has opened 3 chapters that
    /// would have shown this feature. Counter advance happens in
    /// `.onAppear`.
    private var showsNewBadge: Bool { newBadgeCount < 3 }

    var body: some View {
        if !stretchTopics.isEmpty {
            DisclosureGroup(isExpanded: $isExpanded) {
                expandedContent
            } label: {
                disclosureHeader
            }
            .padding(DesignTokens.Spacing.lg)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color.compatIndigo.opacity(0.08))
            )
            .respectReduceMotion(animation: .easeInOut(duration: 0.22))
            .sheet(item: $presentedTopic) { topic in
                DeepDiveDetailSheet(
                    chapter: chapter,
                    topic: topic,
                    onDismiss: { presentedTopic = nil }
                )
            }
            .onAppear(perform: bumpNewBadgeCountIfNeeded)
            .accessibilityElement(children: .contain)
            .accessibilityLabel(disclosureA11yLabel)
            .accessibilityHint("Reveals \(stretchTopics.count) extension topics tagged by grade level so a fast learner can preview where this chapter goes next.")
        }
    }

    /// Disclosure header row. Kept as a single `HStack` so the
    /// surrounding DisclosureGroup's view-builder count stays at 2
    /// (header + expandedContent).
    private var disclosureHeader: some View {
        HStack(spacing: 10) {
            Image(systemName: "arrow.up.right.circle.fill")
                .font(.title3)
                .foregroundColor(Color.compatIndigo)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.xxs) {
                HStack(spacing: DesignTokens.Spacing.sm) {
                    Text("Go deeper")
                        .font(.headline)
                    if showsNewBadge {
                        Text("NEW")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, DesignTokens.Spacing.xxs)
                            .background(
                                Capsule().fill(Color.compatIndigo)
                            )
                            .accessibilityHidden(true)
                    }
                }
                Text("\(stretchTopics.count) stretch topic\(stretchTopics.count == 1 ? "" : "s") for after you've grasped the basics.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .contentShape(Rectangle())
    }

    private var disclosureA11yLabel: String {
        let badge = showsNewBadge ? "(New) " : ""
        return "\(badge)Go deeper — \(stretchTopics.count) extension topics."
    }

    /// The disclosure's expanded body. Single VStack so we stay
    /// well under the @ViewBuilder direct-child cap.
    private var expandedContent: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(stretchTopics) { topic in
                StretchTopicRow(topic: topic) {
                    presentedTopic = topic
                }
            }
        }
        .padding(.top, 10)
    }

    /// Advance the "new badge" counter once per chapter open. Plays
    /// nicely with the `@AppStorage` integer — three opens of any
    /// chapter with at least one stretch topic and the badge sleeps.
    private func bumpNewBadgeCountIfNeeded() {
        if newBadgeCount < 3 {
            newBadgeCount += 1
        }
    }
}

// MARK: - StretchTopicRow

/// One row inside the expanded "Go deeper" disclosure. Tappable —
/// opens `DeepDiveDetailSheet` for the topic's full body.
private struct StretchTopicRow: View {
    let topic: StretchTopic
    let onTap: () -> Void

    @State private var isHovered = false

    private var hoverShouldAnimate: Bool {
        !NSWorkspace.shared.accessibilityDisplayShouldReduceMotion
    }

    var body: some View {
        Button(action: onTap) {
            rowBody
        }
        .buttonStyle(.plain)
        .pointingCursor()
        .onHover { hovering in
            isHovered = hoverShouldAnimate ? hovering : false
        }
        .accessibilityLabel("Open stretch topic: \(topic.title), tagged \(topic.gradeLevel.displayName).")
        .accessibilityHint(topic.prerequisite ?? "Reveals a deeper take on this concept.")
    }

    private var rowBody: some View {
        HStack(alignment: .top, spacing: DesignTokens.Spacing.md) {
            GradeBadge(level: topic.gradeLevel)
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                Text(topic.title)
                    .font(.body.weight(.semibold))
                    .foregroundColor(.primary)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                if let prereq = topic.prerequisite, !prereq.isEmpty {
                    Text(prereq)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            Spacer(minLength: 0)
            Image(systemName: "chevron.right")
                .font(.caption.weight(.bold))
                .foregroundColor(.secondary)
                .accessibilityHidden(true)
        }
        .padding(.vertical, DesignTokens.Spacing.sm)
        .padding(.horizontal, 10)
        .background(
            RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
                .fill(isHovered ? Color.gray.opacity(0.15) : Color.gray.opacity(0.07))
        )
        .contentShape(Rectangle())
    }
}

// MARK: - GradeBadge

/// Small pill showing a grade-level tag — "Class 8", "Class 9", …
/// "NEET / JEE". Color resolves from `GradeLevel.badgeTint` via the
/// `Color.compat*` token registry below.
struct GradeBadge: View {
    let level: GradeLevel

    private var tint: Color {
        // Map the GradeLevel.badgeTint string to an actual Color value.
        // Keeping the string-keyed indirection lets JSON content packs
        // override per-grade colors later without recompiling.
        switch level.badgeTint {
        case "compatBlue":   return .compatBlue
        case "compatTeal":   return .compatTeal
        case "compatCyan":   return .compatCyan
        case "compatIndigo": return .compatIndigo
        case "compatPurple": return .compatPurple
        default:             return .compatIndigo
        }
    }

    var body: some View {
        Text(level.displayName)
            .font(.system(size: 11, weight: .bold))
            .foregroundColor(.white)
            .padding(.horizontal, DesignTokens.Spacing.sm)
            .padding(.vertical, 3)
            .background(
                Capsule().fill(tint)
            )
            .accessibilityLabel("Tagged \(level.displayName)")
    }
}
