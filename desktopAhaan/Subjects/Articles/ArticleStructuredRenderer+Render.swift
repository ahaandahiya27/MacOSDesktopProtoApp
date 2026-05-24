import Foundation
import AppKit

// MARK: - ArticleStructuredRenderer · NSAttributedString assembler
//
// Splits the assembler out of `ArticleStructuredRenderer.swift` so the
// parser side stays under the 600-LOC ceiling. All entry points here
// are `@MainActor` — they materialise NSFont / NSColor / NSAttributed-
// String values, which are AppKit-actor-owned on Big Sur.

extension ArticleStructuredRenderer {

    /// Build a typographically rich `NSAttributedString` from a
    /// `[ArticleBlock]`. Must be called on the main actor — uses
    /// AppKit NSFont/NSColor types.
    @MainActor
    static func makeRichAttributedString(
        from blocks: [ArticleBlock]
    ) -> NSAttributedString {
        let out = NSMutableAttributedString()
        let bodySize = NSFont.systemFontSize
        let textColor = NSColor.labelColor

        for (idx, block) in blocks.enumerated() {
            let needsLeadingNewline = idx > 0 && out.length > 0
            switch block {
            case .heading(let level, let runs):
                if needsLeadingNewline { out.append(NSAttributedString(string: "\n\n")) }
                let font: NSFont
                let topGap: CGFloat
                switch level {
                case 1: font = NSFont.boldSystemFont(ofSize: bodySize + 8); topGap = 6
                case 2: font = NSFont.boldSystemFont(ofSize: bodySize + 4); topGap = 14
                default: font = NSFont.boldSystemFont(ofSize: bodySize + 2); topGap = 10
                }
                appendRuns(
                    runs,
                    to: out,
                    baseFont: font,
                    color: textColor,
                    paragraphStyle: paragraphStyle(spacingBefore: topGap)
                )
            case .paragraph(let runs):
                if needsLeadingNewline { out.append(NSAttributedString(string: "\n\n")) }
                appendRuns(
                    runs,
                    to: out,
                    baseFont: NSFont.systemFont(ofSize: bodySize),
                    color: textColor,
                    paragraphStyle: paragraphStyle(lineSpacing: 3)
                )
            case .bulletList(let items):
                if needsLeadingNewline { out.append(NSAttributedString(string: "\n\n")) }
                let style = paragraphStyle(
                    firstLineHeadIndent: 18,
                    headIndent: 36
                )
                for (i, runs) in items.enumerated() {
                    if i > 0 { out.append(NSAttributedString(string: "\n")) }
                    let bullet = NSAttributedString(
                        string: "•  ",
                        attributes: [
                            .font: NSFont.systemFont(ofSize: bodySize),
                            .foregroundColor: textColor,
                            .paragraphStyle: style
                        ]
                    )
                    out.append(bullet)
                    appendRuns(
                        runs,
                        to: out,
                        baseFont: NSFont.systemFont(ofSize: bodySize),
                        color: textColor,
                        paragraphStyle: style
                    )
                }
            case .calloutBox(let title, let body):
                if needsLeadingNewline { out.append(NSAttributedString(string: "\n\n")) }
                // Background highlight + bold title + body. NSText-
                // View renders `.backgroundColor` as a continuous
                // run-length highlight; combined with paragraph head
                // indent it reads as a card.
                let style = paragraphStyle(
                    spacingBefore: 6,
                    firstLineHeadIndent: 12,
                    headIndent: 12,
                    tailIndent: -12,
                    lineSpacing: 3
                )
                let calloutBG = NSColor.systemYellow
                    .blended(withFraction: 0.85, of: .windowBackgroundColor)
                    ?? .windowBackgroundColor
                if !title.isEmpty {
                    let titleAttr: [NSAttributedString.Key: Any] = [
                        .font: NSFont.boldSystemFont(ofSize: bodySize),
                        .foregroundColor: textColor,
                        .backgroundColor: calloutBG,
                        .paragraphStyle: style
                    ]
                    out.append(NSAttributedString(string: title + "\n",
                                                  attributes: titleAttr))
                }
                appendRuns(
                    body,
                    to: out,
                    baseFont: NSFont.systemFont(ofSize: bodySize),
                    color: textColor,
                    paragraphStyle: style,
                    backgroundColor: calloutBG
                )
            case .linkCard(let emoji, let title, let blurb, let href):
                if needsLeadingNewline { out.append(NSAttributedString(string: "\n\n")) }
                let style = paragraphStyle(
                    spacingBefore: 8,
                    firstLineHeadIndent: 12,
                    headIndent: 12,
                    tailIndent: -12,
                    lineSpacing: 2
                )
                let cardBG = NSColor.controlBackgroundColor
                let titleColor = NSColor.linkColor
                let titleText = (emoji.map { "\($0)  " } ?? "") + title
                var titleAttr: [NSAttributedString.Key: Any] = [
                    .font: NSFont.boldSystemFont(ofSize: bodySize),
                    .foregroundColor: titleColor,
                    .backgroundColor: cardBG,
                    .paragraphStyle: style
                ]
                if let href = href, let url = URL(string: href) {
                    titleAttr[.link] = url
                } else if let href = href {
                    // Relative href that doesn't form a URL on its
                    // own; encode it as a custom attribute the
                    // NSTextView delegate can resolve.
                    titleAttr[.link] = href
                }
                out.append(NSAttributedString(string: titleText + "\n",
                                              attributes: titleAttr))
                if !blurb.isEmpty {
                    let blurbAttr: [NSAttributedString.Key: Any] = [
                        .font: NSFont.systemFont(ofSize: bodySize - 1),
                        .foregroundColor: NSColor.secondaryLabelColor,
                        .backgroundColor: cardBG,
                        .paragraphStyle: style
                    ]
                    out.append(NSAttributedString(string: blurb,
                                                  attributes: blurbAttr))
                }
            case .divider:
                if needsLeadingNewline { out.append(NSAttributedString(string: "\n\n")) }
                let style = paragraphStyle()
                let divider = NSAttributedString(
                    string: "\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}",
                    attributes: [
                        .font: NSFont.systemFont(ofSize: bodySize),
                        .foregroundColor: NSColor.tertiaryLabelColor,
                        .paragraphStyle: style
                    ]
                )
                out.append(divider)
            }
        }

        return out
    }

    @MainActor
    fileprivate static func appendRuns(
        _ runs: [ArticleRun],
        to out: NSMutableAttributedString,
        baseFont: NSFont,
        color: NSColor,
        paragraphStyle: NSParagraphStyle,
        backgroundColor: NSColor? = nil
    ) {
        for run in runs {
            var fontTraits: NSFontDescriptor.SymbolicTraits = []
            if run.isBold { fontTraits.insert(.bold) }
            if run.isItalic { fontTraits.insert(.italic) }
            let font: NSFont
            if !fontTraits.isEmpty {
                let descriptor = baseFont.fontDescriptor.withSymbolicTraits(fontTraits)
                font = NSFont(descriptor: descriptor, size: baseFont.pointSize) ?? baseFont
            } else {
                font = baseFont
            }
            var attrs: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: run.isBold ? NSColor.labelColor : color,
                .paragraphStyle: paragraphStyle
            ]
            if let bg = backgroundColor { attrs[.backgroundColor] = bg }
            if let href = run.href {
                if let url = URL(string: href) {
                    attrs[.link] = url
                } else {
                    attrs[.link] = href
                }
                attrs[.foregroundColor] = NSColor.linkColor
                attrs[.underlineStyle] = NSUnderlineStyle.single.rawValue
            }
            out.append(NSAttributedString(string: run.text, attributes: attrs))
        }
    }

    @MainActor
    fileprivate static func paragraphStyle(
        spacingBefore: CGFloat = 0,
        firstLineHeadIndent: CGFloat = 0,
        headIndent: CGFloat = 0,
        tailIndent: CGFloat = 0,
        lineSpacing: CGFloat = 0
    ) -> NSParagraphStyle {
        let style = NSMutableParagraphStyle()
        style.paragraphSpacingBefore = spacingBefore
        style.firstLineHeadIndent = firstLineHeadIndent
        style.headIndent = headIndent
        style.tailIndent = tailIndent
        style.lineSpacing = lineSpacing
        return style
    }
}
