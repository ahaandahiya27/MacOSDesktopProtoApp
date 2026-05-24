import Foundation
import AppKit

// MARK: - ArticleStructuredRenderer
//
// Parses authored article HTML into a sequence of typed
// `ArticleBlock` values, then assembles those blocks into a
// typographically rich `NSAttributedString` for display in the
// existing `NSTextView` rendering surface.
//
// Why a typed intermediate rather than HTML→NSAttributedString
// directly:
//   1. Sendable hop. The parser runs on a detached task (the HTML
//      file read already pays that cost; piggybacking parse work
//      on the same off-main hop avoids blocking the UI). The
//      assembler needs NSFont / NSColor which are AppKit types —
//      keeping them on the main actor. A `[ArticleBlock]` carrier
//      of `Sendable` value types crosses the hop cleanly.
//   2. Testability. The parser is a pure `nonisolated static` Swift
//      function with no NSAttributedString output — it returns
//      Sendable structs the tests can XCTAssertEqual against.
//   3. Future render-target swap. A SwiftUI `ForEach` over
//      `ArticleBlock` is a drop-in replacement for the NSTextView
//      path if we ever want per-block buttons (e.g. the link-card
//      grid). The parser doesn't change.
//
// Inline marks supported in the parser:
//   - `<strong>` / `<b>` → bold run
//   - `<em>` / `<i>`     → italic run
//   - `<a href="...">`   → link run (href captured for later
//                          NSTextView click routing)
//
// Block-level structures supported:
//   - `<h1>` `<h2>` `<h3>`     → .heading(level:text:)
//   - `<p>`                    → .paragraph(runs:)
//   - `<ul><li>…</li></ul>`    → .bulletList(items:)
//   - `<aside class="fact-box">` → .calloutBox(title:body:)
//   - `<a class="next-card">`    → .linkCard(…) [authored articles
//                                   currently use plain `<a>` wrapping
//                                   a `<strong>` + `<p>`; we detect
//                                   that pattern too — see parser]
//
// Anything outside the above set falls through to `.paragraph` with
// the inner text — that's the conservative default. The renderer
// degrades gracefully on novel markup.
//
// Big Sur 11.5 compatible: pure Foundation + AppKit. No
// `AttributedString` (macOS 12+ only — verified by
// `check_macos12_apis.py`). No `@Observable`. No third-party deps.

/// One run of attributed text. The carrier is `Sendable` so a
/// parsed `[ArticleBlock]` can cross an actor hop without
/// `@unchecked` lies.
struct ArticleRun: Hashable, Sendable {
    let text: String
    let isBold: Bool
    let isItalic: Bool
    /// Hyperlink target. Relative hrefs (e.g. "ch01_scientists.html")
    /// are preserved as written — the NSTextView click handler
    /// resolves them against the current article's directory.
    let href: String?

    static func plain(_ text: String) -> ArticleRun {
        ArticleRun(text: text, isBold: false, isItalic: false, href: nil)
    }
}

/// One structural block in the article body. Discriminated so the
/// assembler can pick a font / spacing / fill per kind without
/// re-parsing the underlying text.
enum ArticleBlock: Hashable, Sendable {
    case heading(level: Int, runs: [ArticleRun])
    case paragraph(runs: [ArticleRun])
    case bulletList(items: [[ArticleRun]])
    case calloutBox(title: String, body: [ArticleRun])
    case linkCard(emoji: String?, title: String, blurb: String, href: String?)
    case divider
}

enum ArticleStructuredRenderer {

    // MARK: - Parser

    /// Walk the authored HTML and emit a list of structural blocks.
    /// Tolerant by design — the input is our own authored HTML (not
    /// arbitrary web content), so we scan for the tag set we
    /// actually use and treat anything unrecognised as a paragraph.
    ///
    /// `nonisolated static` so the off-main detached read hop can
    /// call it without crossing actor boundaries.
    nonisolated static func parseBlocks(_ html: String) -> [ArticleBlock] {
        // 1. Strip <head>…</head> so the title / stylesheet / meta
        //    never leak into the body.
        var working = html
        working = stripRegion(in: working,
                              open: "<head", close: "</head>")
        // 2. Strip <script>…</script> and <style>…</style>.
        working = stripRegion(in: working,
                              open: "<script", close: "</script>")
        working = stripRegion(in: working,
                              open: "<style", close: "</style>")

        var blocks: [ArticleBlock] = []
        var cursor = working.startIndex
        while cursor < working.endIndex {
            // Skip whitespace between blocks.
            while cursor < working.endIndex,
                  working[cursor].isWhitespace || working[cursor].isNewline {
                cursor = working.index(after: cursor)
            }
            guard cursor < working.endIndex else { break }

            // Next opening tag.
            if let openLT = working[cursor...].firstIndex(of: "<"),
               let closeGT = working[openLT...].firstIndex(of: ">") {
                let tag = String(working[openLT...closeGT])
                let tagName = tagName(of: tag)

                // Process recognised block tags. Each branch
                // advances `cursor` past the matched region.
                if let next = tryParseBlock(
                    in: working,
                    startingAt: openLT,
                    openTag: tag,
                    tagName: tagName,
                    blocks: &blocks
                ) {
                    cursor = next
                    continue
                }
                // Unrecognised top-level tag — skip past it but keep
                // its inner content as a paragraph if it has any.
                cursor = working.index(after: closeGT)
            } else {
                // No more tags; remainder is raw text.
                let rest = String(working[cursor...])
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                if !rest.isEmpty {
                    let decoded = PlainTextArticleFallback.decodeEntities(rest)
                    blocks.append(.paragraph(runs: [.plain(decoded)]))
                }
                break
            }
        }
        return blocks
    }

    /// Try to recognise the block starting at `start` and append it
    /// to `blocks`. Returns the cursor position after the consumed
    /// region, or nil if the block isn't recognised.
    nonisolated private static func tryParseBlock(
        in source: String,
        startingAt start: String.Index,
        openTag: String,
        tagName: String,
        blocks: inout [ArticleBlock]
    ) -> String.Index? {
        switch tagName {
        case "h1", "h2", "h3":
            return parseHeading(in: source, startingAt: start,
                                tagName: tagName, blocks: &blocks)
        case "p":
            return parseParagraph(in: source, startingAt: start,
                                  blocks: &blocks)
        case "ul":
            return parseBulletList(in: source, startingAt: start,
                                   blocks: &blocks)
        case "aside":
            // Only fact-box class is recognised explicitly; other
            // asides fall through to a paragraph.
            if openTag.contains("fact-box") {
                return parseCalloutBox(in: source, startingAt: start,
                                       blocks: &blocks)
            }
            return nil
        case "a":
            // Block-level `<a>` wrapping a `<strong>` + `<p>` is the
            // "More Ways to Explore" anchor-card pattern used in the
            // beyond articles.
            return parseLinkCard(in: source, startingAt: start,
                                 blocks: &blocks)
        case "hr":
            blocks.append(.divider)
            guard let close = source[start...].firstIndex(of: ">") else {
                return source.endIndex
            }
            return source.index(after: close)
        case "section", "article", "header", "footer", "div":
            // Transparent container — emit nothing for the open tag
            // and let the recursive parse pick up its children. We
            // achieve that by advancing past just the open tag.
            guard let close = source[start...].firstIndex(of: ">") else {
                return source.endIndex
            }
            return source.index(after: close)
        case "/section", "/article", "/header", "/footer", "/div":
            // Closing wrapper tag — skip.
            guard let close = source[start...].firstIndex(of: ">") else {
                return source.endIndex
            }
            return source.index(after: close)
        default:
            return nil
        }
    }

    nonisolated private static func parseHeading(
        in source: String,
        startingAt start: String.Index,
        tagName: String,
        blocks: inout [ArticleBlock]
    ) -> String.Index? {
        let closeTag = "</\(tagName)>"
        guard let openClose = source[start...].firstIndex(of: ">"),
              let closeRange = source[openClose...].range(of: closeTag) else {
            return nil
        }
        let innerStart = source.index(after: openClose)
        let innerEnd = closeRange.lowerBound
        let inner = String(source[innerStart..<innerEnd])
        let level = Int(String(tagName.dropFirst())) ?? 1
        blocks.append(.heading(level: level, runs: parseInlineRuns(inner)))
        return closeRange.upperBound
    }

    nonisolated private static func parseParagraph(
        in source: String,
        startingAt start: String.Index,
        blocks: inout [ArticleBlock]
    ) -> String.Index? {
        guard let openClose = source[start...].firstIndex(of: ">"),
              let closeRange = source[openClose...].range(of: "</p>") else {
            return nil
        }
        let innerStart = source.index(after: openClose)
        let inner = String(source[innerStart..<closeRange.lowerBound])
        let runs = parseInlineRuns(inner)
        // Drop entirely-empty paragraphs (whitespace-only) — they
        // produce ugly gaps in the rendered article.
        let nonEmpty = runs.contains { !$0.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
        if nonEmpty {
            blocks.append(.paragraph(runs: runs))
        }
        return closeRange.upperBound
    }

    nonisolated private static func parseBulletList(
        in source: String,
        startingAt start: String.Index,
        blocks: inout [ArticleBlock]
    ) -> String.Index? {
        guard let openClose = source[start...].firstIndex(of: ">"),
              let closeRange = source[openClose...].range(of: "</ul>") else {
            return nil
        }
        let innerStart = source.index(after: openClose)
        let inner = String(source[innerStart..<closeRange.lowerBound])
        var items: [[ArticleRun]] = []
        // Pull each <li>…</li> block.
        var liCursor = inner.startIndex
        while let liOpen = inner[liCursor...].range(of: "<li", options: .caseInsensitive),
              let liOpenClose = inner[liOpen.upperBound...].firstIndex(of: ">"),
              let liClose = inner[liOpenClose...].range(of: "</li>", options: .caseInsensitive) {
            let itemStart = inner.index(after: liOpenClose)
            let item = String(inner[itemStart..<liClose.lowerBound])
            items.append(parseInlineRuns(item))
            liCursor = liClose.upperBound
        }
        if !items.isEmpty {
            blocks.append(.bulletList(items: items))
        }
        return closeRange.upperBound
    }

    nonisolated private static func parseCalloutBox(
        in source: String,
        startingAt start: String.Index,
        blocks: inout [ArticleBlock]
    ) -> String.Index? {
        guard let openClose = source[start...].firstIndex(of: ">"),
              let closeRange = source[openClose...].range(of: "</aside>") else {
            return nil
        }
        let innerStart = source.index(after: openClose)
        let inner = String(source[innerStart..<closeRange.lowerBound])
        // Pull the title from the first <h3>…</h3>, the body from
        // the concatenated <p> contents.
        var title = ""
        if let h3Open = inner.range(of: "<h3", options: .caseInsensitive),
           let h3OpenClose = inner[h3Open.upperBound...].firstIndex(of: ">"),
           let h3Close = inner[h3OpenClose...].range(of: "</h3>", options: .caseInsensitive) {
            let h3InnerStart = inner.index(after: h3OpenClose)
            let raw = String(inner[h3InnerStart..<h3Close.lowerBound])
            title = stripInlineTags(raw)
        }
        var bodyRuns: [ArticleRun] = []
        var pCursor = inner.startIndex
        while let pOpen = inner[pCursor...].range(of: "<p", options: .caseInsensitive),
              let pOpenClose = inner[pOpen.upperBound...].firstIndex(of: ">"),
              let pClose = inner[pOpenClose...].range(of: "</p>", options: .caseInsensitive) {
            let pInnerStart = inner.index(after: pOpenClose)
            let raw = String(inner[pInnerStart..<pClose.lowerBound])
            if !bodyRuns.isEmpty {
                bodyRuns.append(.plain("\n"))
            }
            bodyRuns.append(contentsOf: parseInlineRuns(raw))
            pCursor = pClose.upperBound
        }
        blocks.append(.calloutBox(title: title, body: bodyRuns))
        return closeRange.upperBound
    }

    nonisolated private static func parseLinkCard(
        in source: String,
        startingAt start: String.Index,
        blocks: inout [ArticleBlock]
    ) -> String.Index? {
        guard let openClose = source[start...].firstIndex(of: ">"),
              let closeRange = source[openClose...].range(of: "</a>", options: .caseInsensitive) else {
            return nil
        }
        let openTag = String(source[start...openClose])
        let href = extractAttribute("href", from: openTag)
        let innerStart = source.index(after: openClose)
        let inner = String(source[innerStart..<closeRange.lowerBound])

        // If this anchor wraps a <strong> + <p> pair (the "More Ways
        // to Explore" pattern), capture as a link card. Otherwise
        // fall back to an inline-style paragraph holding a single
        // link run — preserves the text + href for the click router.
        if let strongRange = inner.range(of: "<strong", options: .caseInsensitive),
           let strongOpenClose = inner[strongRange.upperBound...].firstIndex(of: ">"),
           let strongClose = inner[strongOpenClose...].range(of: "</strong>", options: .caseInsensitive) {
            let titleRaw = String(inner[inner.index(after: strongOpenClose)..<strongClose.lowerBound])
            let title = stripInlineTags(titleRaw)
            let (emoji, remainingTitle) = splitLeadingEmoji(from: title)

            var blurb = ""
            if let pRange = inner.range(of: "<p", options: .caseInsensitive,
                                        range: strongClose.upperBound..<inner.endIndex),
               let pOpenClose = inner[pRange.upperBound...].firstIndex(of: ">"),
               let pClose = inner[pOpenClose...].range(of: "</p>", options: .caseInsensitive) {
                let raw = String(inner[inner.index(after: pOpenClose)..<pClose.lowerBound])
                blurb = stripInlineTags(raw)
                    .trimmingCharacters(in: .whitespacesAndNewlines)
            }
            blocks.append(.linkCard(emoji: emoji,
                                    title: remainingTitle,
                                    blurb: blurb,
                                    href: href))
            return closeRange.upperBound
        }
        // Plain anchor — emit as a paragraph with a link run.
        let text = stripInlineTags(inner).trimmingCharacters(in: .whitespacesAndNewlines)
        if !text.isEmpty {
            let run = ArticleRun(text: text, isBold: false, isItalic: false, href: href)
            blocks.append(.paragraph(runs: [run]))
        }
        return closeRange.upperBound
    }

    // MARK: - Inline-run parser

    /// Walk an inline-content string (text + `<strong>` / `<em>` /
    /// `<a>` / `<code>`) into a list of `ArticleRun` segments.
    /// Unknown inline tags are stripped — their inner text survives
    /// at the surrounding run's style.
    nonisolated static func parseInlineRuns(_ html: String) -> [ArticleRun] {
        var runs: [ArticleRun] = []
        var pending = ""
        var isBold = false
        var isItalic = false
        var href: String? = nil

        func flushPending() {
            guard !pending.isEmpty else { return }
            let decoded = PlainTextArticleFallback.decodeEntities(pending)
            runs.append(ArticleRun(text: decoded,
                                   isBold: isBold,
                                   isItalic: isItalic,
                                   href: href))
            pending = ""
        }

        var cursor = html.startIndex
        while cursor < html.endIndex {
            if html[cursor] == "<",
               let closeIdx = html[cursor...].firstIndex(of: ">") {
                let tag = String(html[cursor...closeIdx])
                let name = tagName(of: tag)
                flushPending()
                switch name {
                case "strong", "b": isBold = true
                case "/strong", "/b": isBold = false
                case "em", "i": isItalic = true
                case "/em", "/i": isItalic = false
                case "a":
                    href = extractAttribute("href", from: tag)
                case "/a":
                    href = nil
                case "code", "/code":
                    // No special font for code in this pass — kid-
                    // friendly articles rarely use it; defer monospace
                    // styling to a future iteration.
                    break
                case "br", "br/":
                    pending.append("\n")
                default:
                    break
                }
                cursor = html.index(after: closeIdx)
            } else {
                pending.append(html[cursor])
                cursor = html.index(after: cursor)
            }
        }
        flushPending()
        return runs
    }

    // MARK: - Lightweight helpers

    nonisolated private static func tagName(of tag: String) -> String {
        // Strip `<` and `>` then take everything up to the first
        // space or `/`. e.g. `<a href="...">` → `a`,
        // `<br/>` → `br/`, `</strong>` → `/strong`.
        let stripped = tag.dropFirst().dropLast()
        var name = ""
        for ch in stripped {
            if ch == " " { break }
            name.append(ch)
        }
        return name.lowercased()
    }

    nonisolated private static func extractAttribute(
        _ attribute: String,
        from tag: String
    ) -> String? {
        // Match `attribute = "value"` or `attribute = 'value'` —
        // tolerant of whitespace either side of the `=`. Returns
        // nil on no match.
        let pattern = "\(attribute)\\s*=\\s*[\"']([^\"']*)[\"']"
        guard let regex = try? NSRegularExpression(
            pattern: pattern, options: .caseInsensitive
        ) else { return nil }
        let nsTag = tag as NSString
        let range = NSRange(location: 0, length: nsTag.length)
        guard let match = regex.firstMatch(in: tag, range: range),
              match.numberOfRanges >= 2 else { return nil }
        let valueRange = match.range(at: 1)
        guard valueRange.location != NSNotFound else { return nil }
        return nsTag.substring(with: valueRange)
    }

    nonisolated private static func stripInlineTags(_ html: String) -> String {
        // Strip just inline-level tags + decode entities. Used for
        // the title / blurb fields of a link card, where we don't
        // need to preserve sub-styling.
        let stripped = html.replacingOccurrences(
            of: "<[^>]+>",
            with: "",
            options: .regularExpression
        )
        return PlainTextArticleFallback.decodeEntities(stripped)
    }

    nonisolated private static func splitLeadingEmoji(
        from title: String
    ) -> (emoji: String?, remainder: String) {
        // Treat the first character cluster as a candidate emoji if
        // it isn't a letter. Authored link-card titles open with one
        // of: 👨‍🔬 🌿 🤔 📖 🌺 🌱 ✅ 🎓 ⚠️ 📝 🗺️ — all
        // ExtendedGraphemeCluster matches with non-letter base.
        guard let first = title.first else { return (nil, title) }
        if first.unicodeScalars.contains(where: {
            !$0.properties.isAlphabetic
                && !$0.properties.isMath
                && ($0.properties.isEmoji
                    || $0.properties.generalCategory == .otherSymbol)
        }) {
            // Sniff: drop the cluster + leading whitespace.
            let remainder = title.dropFirst()
                .trimmingCharacters(in: .whitespacesAndNewlines)
            return (String(first), remainder)
        }
        return (nil, title)
    }

    nonisolated private static func stripRegion(
        in input: String,
        open: String,
        close: String
    ) -> String {
        var output = input
        while let openRange = output.range(of: open, options: .caseInsensitive),
              let closeRange = output.range(
                of: close,
                options: .caseInsensitive,
                range: openRange.upperBound..<output.endIndex
              ) {
            output.removeSubrange(openRange.lowerBound..<closeRange.upperBound)
        }
        return output
    }

    // MARK: - Hero-title de-duplication (E4)

    /// Drop the first `.heading(level: 1, …)` block from `blocks`
    /// **only if** its text equals `chromeTitle` after a case- and
    /// whitespace-insensitive compare. Returns the (possibly
    /// shortened) block list. Never strips silently.
    nonisolated static func deduplicateHeroHeading(
        _ blocks: [ArticleBlock],
        matching chromeTitle: String
    ) -> [ArticleBlock] {
        let normalizedChrome = chromeTitle
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
        guard !normalizedChrome.isEmpty else { return blocks }
        guard let firstHeadingIdx = blocks.firstIndex(where: {
            if case .heading(let level, _) = $0, level == 1 { return true }
            return false
        }) else { return blocks }
        if case .heading(_, let runs) = blocks[firstHeadingIdx] {
            let headingText = runs.map(\.text).joined()
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .lowercased()
            if headingText == normalizedChrome {
                var trimmed = blocks
                trimmed.remove(at: firstHeadingIdx)
                return trimmed
            }
        }
        return blocks
    }

    // NSAttributedString assembler — see ArticleStructuredRenderer+Render.swift
}
