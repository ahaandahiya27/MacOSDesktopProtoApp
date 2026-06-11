import SwiftUI
import AppKit

// MARK: - RelatedChaptersStrip
//
// Surface 4 — auto-derived from the per-chapter `conceptMap` graph
// shipped during the 2026-05-24 content propagation. Reads
// `chapter.conceptMap.nodes` for `.crossChapter` entries, groups
// them by target chapter, and renders one pill per target. Tap →
// pushes to that chapter via TutorNavigationState.
//
// Zero new authoring cost. The cross-chapter pointers were authored
// chapter-by-chapter into JSON; this surface just makes them
// discoverable from the chapter detail page itself, not only from
// inside the ConceptMapView sheet.
//
// Auto-hides when:
//   - the chapter has no `conceptMap` (Optional, defaults to nil)
//   - the conceptMap has no `.crossChapter` nodes
//   - no cross-chapter target resolves in the current pack
//
// Big Sur compat:
//   - HStack + horizontal ScrollView (macOS 10.15+ baseline).
//   - No .scrollPosition (that's macOS 14+).
//   - No `Color.brown/.indigo/.mint/.teal/.cyan` — routes through
//     `Color.compatIndigo`.
//   - ForEach uses `\.targetId` as id (a String, stable across
//     re-renders).

struct RelatedChaptersStrip: View {
    let pack: SubjectPack
    let chapter: Chapter

    @EnvironmentObject private var nav: TutorNavigationState

    /// Cross-chapter targets grouped by chapter id, with pointer
    /// counts. Pure-data derivation; exposed as a static method so
    /// `RelatedChaptersStripTests` can exercise the algorithm without
    /// constructing full `Chapter` / `SubjectPack` instances.
    ///
    /// Skips self-references (defensive — authoring shouldn't produce
    /// them, but a future editing mistake shouldn't break the UI) and
    /// unresolved targets (so the kid never taps a chip that goes
    /// nowhere). Sorted by target id for stable rendering order.
    static func targetCounts(
        in conceptMap: ConceptMap?,
        hostChapterId: String,
        validTargetIds: Set<String>
    ) -> [(targetId: String, count: Int)] {
        guard let map = conceptMap else { return [] }
        var counts: [String: Int] = [:]
        for node in map.nodes where node.kind == .crossChapter {
            let parts = node.id.split(separator: ":", maxSplits: 1)
            guard parts.count == 2 else { continue }
            let targetId = String(parts[0])
            guard targetId != hostChapterId else { continue }
            guard validTargetIds.contains(targetId) else { continue }
            counts[targetId, default: 0] += 1
        }
        return counts
            .sorted { $0.key < $1.key }
            .map { (targetId: $0.key, count: $0.value) }
    }

    private var groupedTargets: [(targetId: String, count: Int)] {
        let validIds = Set(pack.chapters.map { $0.id })
        return Self.targetCounts(
            in: chapter.conceptMap,
            hostChapterId: chapter.id,
            validTargetIds: validIds
        )
    }

    private func chapterTitle(for id: String) -> String {
        pack.chapters.first(where: { $0.id == id })?.title ?? "Chapter"
    }

    private func chapterNumber(for id: String) -> Int {
        pack.chapters.first(where: { $0.id == id })?.number ?? 0
    }

    var body: some View {
        let targets = groupedTargets
        if !targets.isEmpty {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                Text("Related chapters")
                    .font(.caption.weight(.bold))
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)
                    .accessibilityAddTraits(.isHeader)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: DesignTokens.Spacing.sm) {
                        ForEach(targets, id: \.targetId) { target in
                            chip(for: target.targetId, count: target.count)
                        }
                    }
                    .padding(.horizontal, 1)
                }
            }
            .accessibilityElement(children: .contain)
            .accessibilityLabel("Related chapters — \(targets.count) chapter\(targets.count == 1 ? "" : "s") linked via concept map")
        }
    }

    private func chip(for targetId: String, count: Int) -> some View {
        let number = chapterNumber(for: targetId)
        let title  = chapterTitle(for: targetId)
        return Button {
            let packId = pack.id
            // Defer nav.push so SwiftUI's render commit finishes before
            // navigation — same dismantle-order pattern as the other
            // ChapterDetailView nav.push call sites and ConceptMapView's
            // handleNodeTap.
            DispatchQueue.main.async {
                nav.push(.chapter(packId: packId, chapterId: targetId))
            }
        } label: {
            RelatedChapterChip(number: number, title: title, count: count)
        }
        .buttonStyle(.plain)
        .pointingCursor()
        .accessibilityLabel("Open Chapter \(number): \(title) — \(count) concept link\(count == 1 ? "" : "s")")
        .accessibilityHint("Navigates to the related chapter.")
    }
}

// MARK: - RelatedChapterChip

private struct RelatedChapterChip: View {
    let number: Int
    let title: String
    let count: Int

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: SFSymbolCompat.name("arrow.right"))
                .font(.caption2.weight(.bold))
                .foregroundColor(Color.compatIndigo)
                .accessibilityHidden(true)
            Text("Ch.\(number)")
                .font(.caption.weight(.bold))
                .foregroundColor(Color.compatIndigo)
            Text(title)
                .font(.caption.weight(.semibold))
                .foregroundColor(.primary)
                .lineLimit(1)
            if count > 1 {
                Text("·\(count)")
                    .font(.caption2.monospacedDigit())
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(Color.compatIndigo.opacity(0.10))
        )
        .overlay(
            Capsule()
                .stroke(Color.compatIndigo.opacity(0.35), lineWidth: 1)
        )
        .contentShape(Capsule())
    }
}
