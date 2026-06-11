import SwiftUI

/// Compact secondary CTA on `ConceptDetailView` that opens the
/// owning chapter's long-form vocabulary deck article. Shown in
/// addition to the primary `articleButton` (which routes to the
/// per-concept article when one exists). Together they give the
/// kid two read paths:
///
///   - `articleButton` ── per-concept article (e.g. `ch01_t01_c01`)
///   - this CTA       ── chapter-wide glossary article (e.g. `ch01_glossary`)
///
/// Auto-hides when the chapter's `_glossary` article isn't bundled
/// (defensive — every chapter does have one as of 2026-05-26, but
/// the gate keeps the row from showing a broken button if a future
/// content prune drops one).
///
/// Sister file so `ConceptDetailView.swift` stays well under the
/// 600-LOC Big Sur ceiling. Matches the pattern used by
/// `ChapterDetailView+ExtraReadingRow.swift` and
/// `ChapterDetailView+CommonMistakesCard.swift`.
struct ChapterGlossaryCTA: View {
    let pack: SubjectPack
    let chapter: Chapter
    @State private var presented: ArticleEntry?

    private var entry: ArticleEntry? {
        // Maths article keys are `mch01_…`; Science reuses `ch01_…`; Sanskrit's NEW NEP
        // chapters use `sch01_…`. Without the pack-aware prefix a Maths chapter's CTA
        // would open the SCIENCE glossary (shared `chNN` ids).
        // The Sanskrit pack ALSO has the legacy `ch01` vocab-deck whose id collides with
        // Science's `ch01` — we gate it off so it cannot accidentally surface Science's
        // ch01_glossary. Mirrors ChapterDetailView.resolvedArticleEntry.
        guard ["science_class7", "maths_class7", "sanskrit_class7"].contains(pack.id) else { return nil }
        let baseKey = "\(chapter.id)_glossary"
        let key: String
        switch pack.id {
        case "maths_class7":    key = "m" + baseKey
        case "sanskrit_class7":
            guard chapter.id.hasPrefix("sch") else { return nil }
            key = baseKey
        default:                key = baseKey   // science_class7
        }
        guard let candidate = ArticleIndex.entries[key] else { return nil }
        // Bundle-existence gate — same shape as ExtraReadingRow's
        // resolvedEntry helper. Catches a chapter whose article
        // entry was authored but whose HTML file shipped missing.
        let name = candidate.filename.replacingOccurrences(of: ".html", with: "")
        let url = Bundle.main.url(forResource: name, withExtension: "html",
                                  subdirectory: candidate.chapterFolder)
            ?? Bundle.main.url(forResource: name, withExtension: "html")
        return url != nil ? candidate : nil
    }

    var body: some View {
        if let e = entry {
            Button {
                DispatchQueue.main.async { presented = e }
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: SFSymbolCompat.name("character.book.closed"))
                        .font(.body)
                        .foregroundColor(Color.compatIndigo)
                        .accessibilityHidden(true)
                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.xxs) {
                        Text("Look up vocabulary for Ch. \(chapter.number)")
                            .font(.callout.weight(.semibold))
                            .foregroundColor(DesignTokens.BrandColor.canvasText)
                        Text("≈ \(e.estimatedMinutes) min · full chapter vocabulary deck")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                    Spacer(minLength: 0)
                    Image(systemName: SFSymbolCompat.name("chevron.right"))
                        .font(.caption.weight(.semibold))
                        .foregroundColor(.secondary.opacity(0.6))
                        .accessibilityHidden(true)
                }
                .padding(.vertical, 10)
                .padding(.horizontal, DesignTokens.Spacing.md)
                .background(
                    RoundedRectangle(cornerRadius: DesignTokens.Radius.md, style: .continuous)
                        .fill(Color(NSColor.controlBackgroundColor))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: DesignTokens.Radius.md, style: .continuous)
                        .strokeBorder(Color.compatIndigo.opacity(0.25), lineWidth: 1)
                )
            }
            .buttonStyle(.plain)
            .pointingCursor()
            .accessibilityLabel("Look up vocabulary for Chapter \(chapter.number)")
            .accessibilityHint("Opens the chapter's full vocabulary deck article.")
            .sheet(item: $presented) { article in
                ArticleBrowserView(
                    initialFile: article.filename,
                    chapterFolder: article.chapterFolder,
                    articleTitle: article.title
                )
                .frame(minWidth: 720, idealWidth: 920,
                       minHeight: 540, idealHeight: 680)
            }
        }
    }
}
