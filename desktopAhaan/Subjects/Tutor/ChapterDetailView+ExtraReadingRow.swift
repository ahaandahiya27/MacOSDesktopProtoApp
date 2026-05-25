import SwiftUI
import AppKit

/// "Extra reading" surface — one chip per templated enrichment
/// article shipped 2026-05-26 for every chapter (Vocabulary Deck,
/// NCERT Q&A, Scientist Spotlight, What If?). Each chip auto-hides
/// when its article isn't bundled for the chapter, so the row
/// shrinks naturally on chapters that haven't shipped a given
/// article yet.
///
/// Lives in a sister file so `ChapterDetailView.swift` stays under
/// the 600-LOC Big Sur ceiling. Matches the pattern used by
/// `ChapterDetailView+CommonMistakesCard.swift` and
/// `ChapterDetailView+PropagatedCTAs.swift`.
///
/// Layout: a vertical-ish stack of chips, each tappable, each
/// linking through the parent's existing sheetCoordinator via
/// the `onTap` closure (so the sheet opens through the same
/// `.article(entry)` path the Beyond + CommonMistakes cards
/// already use). Big-Sur-safe — no .keyboardShortcut(_:?)
/// optional overload, no macOS 12+ Layout API.
struct ExtraReadingRow: View {
    let chapter: Chapter
    /// Called when the kid taps a chip. The parent
    /// `ChapterDetailView` wires this to
    /// `sheetCoordinator.presented = .article(entry)` so the
    /// sheet opens through the same path Beyond + CommonMistakes
    /// already use.
    let onTap: (ArticleEntry) -> Void

    // 7 article-surface suffixes shipped through 2026-05-26 with the
    // enrichment-consistency arc. Listed in display order — the 4
    // original templated surfaces (glossary, ncert_qa, scientists,
    // whatif) followed by the 3 added 2026-05-26 in Blocks 3-5
    // (miniproject, selfcheck, storymode).
    private var rows: [(label: String, suffix: String, systemImage: String, accentColor: Color, hint: String)] {
        return [
            (label: "Vocabulary Deck",
             suffix: "_glossary",
             systemImage: SFSymbolCompat.name("character.book.closed"),
             accentColor: Color.compatIndigo,
             hint: "Read-mode dictionary of chapter terms."),
            (label: "NCERT Q&A",
             suffix: "_ncert_qa",
             systemImage: SFSymbolCompat.name("doc.text.fill"),
             accentColor: Color.compatTeal,
             hint: "Worked model answers for revision before a chapter test."),
            (label: "Scientist Spotlight",
             suffix: "_scientists",
             systemImage: SFSymbolCompat.name("person.crop.circle.fill"),
             // No Color.compatOrange in Extensions.swift; .orange is a
             // macOS 10.15 semantic color (Big Sur native) so it's safe.
             accentColor: .orange,
             hint: "One-page biography tied to this chapter."),
            (label: "What If?",
             suffix: "_whatif",
             systemImage: SFSymbolCompat.name("lightbulb.fill"),
             accentColor: Color.compatPurple,
             hint: "Thought-experiment questions with discussion paths."),
            (label: "Mini Project",
             suffix: "_miniproject",
             systemImage: SFSymbolCompat.name("wrench.and.screwdriver.fill"),
             accentColor: Color.compatTeal,
             hint: "Hands-on activity with materials, steps, and a follow-up question."),
            (label: "Quick Self-Check",
             suffix: "_selfcheck",
             systemImage: SFSymbolCompat.name("checkmark.circle.fill"),
             accentColor: Color.compatIndigo,
             hint: "Five questions sampled from the chapter to test understanding."),
            (label: "Story Mode",
             suffix: "_storymode",
             systemImage: SFSymbolCompat.name("book.fill"),
             accentColor: Color.compatPurple,
             hint: "Real-world scenarios woven into a short narrative."),
        ]
    }

    var body: some View {
        let resolved = rows.compactMap { row -> (ArticleEntry, String, String, Color, String)? in
            guard let entry = resolvedEntry(forKey: "\(chapter.id)\(row.suffix)") else {
                return nil
            }
            return (entry, row.label, row.systemImage, row.accentColor, row.hint)
        }
        if !resolved.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                Text("Extra reading")
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.secondary)
                    .accessibilityAddTraits(.isHeader)
                VStack(spacing: 6) {
                    ForEach(0..<resolved.count, id: \.self) { idx in
                        let row = resolved[idx]
                        chipButton(entry: row.0,
                                   label: row.1,
                                   systemImage: row.2,
                                   accent: row.3,
                                   hint: row.4)
                    }
                }
            }
            .padding(.top, 4)
        }
    }

    /// One chip — compact, tappable, opens its article via onTap.
    private func chipButton(entry: ArticleEntry,
                            label: String,
                            systemImage: String,
                            accent: Color,
                            hint: String) -> some View {
        Button {
            DispatchQueue.main.async { onTap(entry) }
        } label: {
            HStack(spacing: 10) {
                Image(systemName: systemImage)
                    .font(.body)
                    .foregroundColor(accent)
                    .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: 2) {
                    Text(label)
                        .font(.callout.weight(.semibold))
                        .foregroundColor(DesignTokens.BrandColor.canvasText)
                    Text("≈ \(entry.estimatedMinutes) min · \(hint)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
                Spacer(minLength: 0)
                Image(systemName: SFSymbolCompat.name("chevron.right"))
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.secondary.opacity(0.6))
                    .accessibilityHidden(true)
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 12)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color(NSColor.controlBackgroundColor))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .strokeBorder(accent.opacity(0.25), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .pointingCursor()
        .accessibilityLabel(label)
        .accessibilityHint(hint)
    }

    /// Bundle-file gate — same shape as
    /// `ChapterDetailView.resolvedArticleEntry(forKey:)` but
    /// reimplemented here so this sister file stays self-contained.
    /// Subdirectory lookup with flat-bundle fallback.
    private func resolvedEntry(forKey key: String) -> ArticleEntry? {
        guard let entry = ArticleIndex.entries[key] else { return nil }
        let name = entry.filename.replacingOccurrences(of: ".html", with: "")
        let resolved = Bundle.main.url(forResource: name, withExtension: "html",
                                       subdirectory: entry.chapterFolder)
            ?? Bundle.main.url(forResource: name, withExtension: "html")
        return resolved != nil ? entry : nil
    }
}
