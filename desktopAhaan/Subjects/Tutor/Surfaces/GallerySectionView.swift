import SwiftUI
import AppKit

// MARK: - GallerySectionView
//
// Surfaces `chapter.gallery: [GalleryItem]?` on the chapter detail
// page as a "Gallery" disclosure. Each item is a small card with an
// asset (resolved from `assetHint`), a caption, and a one-paragraph
// detail.
//
// Asset routing:
//   - "sfsymbol:<name>"  → Image(systemName: SFSymbolCompat.name(name))
//   - "asset:<name>"     → Image(nsImage: NSImage(named: name)) with
//                          fallback to a neutral placeholder when the
//                          asset catalog doesn't carry the image yet.
//   - "shape:<id>"       → ShapeDiagramRegistry lookup (registry is
//                          empty today; falls back to a placeholder).
//   - nil                → caption + detail only, no imagery.
//
// Auto-hides when `chapter.gallery` is nil/empty. Uses
// `CollapsibleContentSection` so the visual language matches the
// other chapter-detail surfaces.

struct GallerySectionView: View {
    let chapter: Chapter

    private var items: [GalleryItem] { chapter.galleryList }

    var body: some View {
        if !items.isEmpty {
            CollapsibleContentSection(
                title: "Gallery",
                icon: "rectangle.stack.fill",
                badgeCount: items.count,
                tint: .compatMint,
                storageKey: "\(chapter.id).gallery"
            ) {
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
                    ForEach(items) { item in
                        GalleryItemCard(item: item)
                    }
                }
            }
        }
    }
}

// MARK: - GalleryItemCard

private struct GalleryItemCard: View {
    let item: GalleryItem

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            assetView
                .frame(width: 56, height: 56)
                .background(
                    RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
                        .fill(Color.compatMint.opacity(0.12))
                )
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                Text(item.caption)
                    .font(.callout.weight(.semibold))
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)
                Text(item.detail)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineSpacing(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer(minLength: 0)
        }
        .padding(DesignTokens.Spacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
                .stroke(Color.secondary.opacity(0.25), lineWidth: 1)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(item.caption). \(item.detail)")
    }

    /// Resolves `assetHint` to a small leading image. SF Symbol case
    /// is the common one in the live pack (`"sfsymbol:leaf"` etc.).
    @ViewBuilder
    private var assetView: some View {
        if let hint = item.assetHint, let resolved = parseHint(hint) {
            switch resolved.kind {
            case .sfsymbol:
                Image(systemName: SFSymbolCompat.name(resolved.value))
                    .font(.system(size: 28))
                    .foregroundColor(Color.compatMint)
            case .asset:
                if let nsImage = NSImage(named: NSImage.Name(resolved.value)) {
                    Image(nsImage: nsImage)
                        .resizable()
                        .scaledToFit()
                        .padding(DesignTokens.Spacing.sm)
                } else {
                    placeholderGlyph
                }
            case .shape:
                if let factory = ShapeDiagramRegistry.factory(for: resolved.value) {
                    factory()
                } else {
                    placeholderGlyph
                }
            }
        } else {
            placeholderGlyph
        }
    }

    private var placeholderGlyph: some View {
        Image(systemName: SFSymbolCompat.name("photo"))
            .font(.system(size: 24))
            .foregroundColor(.secondary)
    }

    private enum HintKind { case sfsymbol, asset, shape }
    private struct ParsedHint {
        let kind: HintKind
        let value: String
    }

    private func parseHint(_ hint: String) -> ParsedHint? {
        if let after = stripPrefix(hint, "sfsymbol:") { return ParsedHint(kind: .sfsymbol, value: after) }
        if let after = stripPrefix(hint, "asset:")    { return ParsedHint(kind: .asset,    value: after) }
        if let after = stripPrefix(hint, "shape:")    { return ParsedHint(kind: .shape,    value: after) }
        return nil
    }

    private func stripPrefix(_ s: String, _ prefix: String) -> String? {
        guard s.hasPrefix(prefix) else { return nil }
        return String(s.dropFirst(prefix.count))
    }
}
