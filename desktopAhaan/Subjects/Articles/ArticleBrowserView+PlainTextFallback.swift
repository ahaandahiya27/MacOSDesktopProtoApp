import SwiftUI
import AppKit

// MARK: - PlainTextArticleFallback
//
// Shown when WKWebView's WebContent process crashes (common on Big Sur
// with legacy AMD GPUs — the IconRendering Metal shader cache fails).
// Reads the same HTML file, strips tags with a minimal parser, and shows
// the result in a ScrollView so the kid can still read the article even
// when WebKit can't render it. Also offers an "Open in Safari" recovery.

struct PlainTextArticleFallback: View {
    let url: URL?
    let errorMessage: String?
    @State private var bodyText: String = ""
    @State private var loadError: String? = nil

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                HStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.orange)
                    Text("Showing simplified view")
                        .font(.callout.weight(.semibold))
                    Spacer()
                    if let url = url, url.isFileURL,
                       url.path.hasPrefix(Bundle.main.bundlePath) {
                        Button("Open in Safari") {
                            if !NSWorkspace.shared.open(url) {
                                CrashReporter.shared.logDataIssue(
                                    "NSWorkspace.open returned false for fallback article URL: \(url.lastPathComponent)"
                                )
                            }
                        }
                        .controlSize(.small)
                    }
                }
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.orange.opacity(0.12))
                )

                if let err = errorMessage ?? loadError {
                    Text(err)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                if bodyText.isEmpty && loadError == nil {
                    Text("Loading…")
                        .foregroundColor(.secondary)
                } else {
                    // Note: textSelection requires macOS 12 — omit on Big Sur.
                    Text(bodyText)
                        .font(.body)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(20)
        }
        .background(Color(NSColor.windowBackgroundColor))
        .onAppear { load() }
    }

    private func load() {
        guard let url = url else {
            loadError = "Article location is unknown."
            return
        }
        // The fallback runs after WebKit has already crashed, so the kid is
        // staring at a half-broken window. Reading + stripping the HTML on
        // main worked in practice (most articles are 30–200 KB) but blocked
        // the run loop for 50–200ms — enough to spin the wheel on the iMac.
        // Hand off to a detached task; the @MainActor hop on completion
        // keeps @State mutations on the right actor.
        Task.detached(priority: .userInitiated) {
            do {
                let raw = try String(contentsOf: url, encoding: .utf8)
                let stripped = Self.stripHTML(raw)
                await MainActor.run {
                    bodyText = stripped
                }
            } catch {
                let message = error.localizedDescription
                await MainActor.run {
                    loadError = message
                }
            }
        }
    }

    /// Cheap HTML→text reducer. Not a real parser — just enough to make a
    /// concept article readable when WebKit is dead. Newlines after block
    /// tags, two newlines after headings/paragraphs/list items.
    ///
    /// `nonisolated` so the off-main `ArticleCoordinator.readParseAndExtractTitle`
    /// can call it from a `Task.detached` body. `PlainTextArticleFallback`
    /// conforms to `View` (which is `@MainActor`-isolated), and without
    /// this annotation Swift 6 would refuse the cross-actor call.
    nonisolated static func stripHTML(_ html: String) -> String {
        var s = html
        let blockBreaks = ["</p>", "</h1>", "</h2>", "</h3>", "</h4>",
                           "</h5>", "</h6>", "</li>", "</div>", "</section>",
                           "</article>", "<br>", "<br/>", "<br />"]
        for tag in blockBreaks {
            s = s.replacingOccurrences(of: tag, with: "\n\n", options: .caseInsensitive)
        }
        // Strip all remaining tags.
        s = s.replacingOccurrences(of: "<[^>]+>", with: "",
                                   options: .regularExpression)
        s = decodeEntities(s)
        // Collapse runs of 3+ newlines down to exactly 2.
        s = s.replacingOccurrences(of: "\n{3,}", with: "\n\n",
                                   options: .regularExpression)
        return s.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// Decode HTML character references — both **named** (`&rsquo;`,
    /// `&copy;`, …) and **numeric** (decimal `&#39;`, hex `&#x27;` /
    /// `&#X2014;`). The authored articles emit a mix of all three, and
    /// the previous 9-entry table missed every numeric reference, so
    /// apostrophes appeared as the literal `&#x27;` across the
    /// Beyond-the-Book / Story / Scientists / What-If / Plant-of-the-Day
    /// / Glossary / Self-Check / NCERT-Q&A / Mistakes / Bridge /
    /// Mini-project / Infographic articles of every chapter.
    ///
    /// **Ordering rule** (must not change without updating tests):
    ///   1. Named entities first (except `&amp;`)
    ///   2. Numeric refs second
    ///   3. `&amp;` last
    /// Decoding `&amp;` early would turn an *escaped* numeric ref
    /// `&amp;#x27;` (the literal text "&#x27;" in the source) into
    /// `&#x27;`, which the numeric sweep would then incorrectly decode
    /// to an apostrophe. The test `testAmpersandDecodedLast` pins this.
    ///
    /// Invalid numeric refs (`&#xZZZZ;`, `&#x110000;` which is above the
    /// Unicode max) are left as literals — the decoder never crashes
    /// and never silently produces a `\u{FFFD}` substitute for hostile
    /// input.
    nonisolated static func decodeEntities(_ input: String) -> String {
        var s = input
        // (1) Extended named-entity table. Includes the canonical XML
        // subset plus the typographic glyphs we've seen in authored
        // articles (curly quotes, mathematical operators, common
        // copyright / trademark / currency marks).
        let namedEntities: [(String, String)] = [
            // XML subset minus &amp; (handled last):
            ("&lt;", "<"), ("&gt;", ">"),
            ("&quot;", "\""), ("&apos;", "'"), ("&nbsp;", " "),
            // Typographic — quotation marks + dashes + ellipsis:
            ("&mdash;", "—"), ("&ndash;", "–"), ("&hellip;", "…"),
            ("&lsquo;", "\u{2018}"), ("&rsquo;", "\u{2019}"),
            ("&ldquo;", "\u{201C}"), ("&rdquo;", "\u{201D}"),
            ("&laquo;", "\u{00AB}"), ("&raquo;", "\u{00BB}"),
            ("&prime;", "\u{2032}"), ("&Prime;", "\u{2033}"),
            ("&bull;", "\u{2022}"), ("&middot;", "·"),
            // Legal / commercial:
            ("&copy;", "©"), ("&reg;", "®"), ("&trade;", "™"),
            // Math / measurement:
            ("&deg;", "°"), ("&times;", "×"), ("&divide;", "÷"),
            ("&plusmn;", "±"), ("&permil;", "‰"),
            // Currency:
            ("&euro;", "€"), ("&pound;", "£"), ("&yen;", "¥"),
            // Paragraph / section marks:
            ("&para;", "¶"), ("&sect;", "§")
        ]
        for (entity, replacement) in namedEntities {
            s = s.replacingOccurrences(of: entity, with: replacement)
        }
        // (2) Numeric character references — decimal `&#39;` + hex
        // `&#x27;` / `&#X2014;`. NSRegularExpression sweep so we
        // process every match in one pass; per-match decode honours
        // the validity cap.
        s = decodeNumericEntities(s)
        // (3) `&amp;` last — see ordering rule above.
        s = s.replacingOccurrences(of: "&amp;", with: "&")
        return s
    }

    /// Sub-step of `decodeEntities` — extracted so the numeric-ref
    /// branch is testable in isolation and the surrounding decode
    /// flow stays readable.
    nonisolated private static func decodeNumericEntities(_ input: String) -> String {
        // Pattern matches `&#x2A;`, `&#X2A;`, `&#42;`. Capture groups:
        //   1: optional hex marker ("x" or "X")
        //   2: the digits
        let pattern = "&#(x|X)?([0-9A-Fa-f]+);"
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return input
        }
        let nsInput = input as NSString
        let fullRange = NSRange(location: 0, length: nsInput.length)
        let matches = regex.matches(in: input, range: fullRange)
        // Walk matches in reverse so prior replacements don't shift
        // subsequent ranges.
        var output = input
        for match in matches.reversed() {
            guard match.range.location != NSNotFound else { continue }
            let hexRange = match.range(at: 1)
            let digitsRange = match.range(at: 2)
            guard digitsRange.location != NSNotFound else { continue }
            let isHex = hexRange.location != NSNotFound
            let digits = nsInput.substring(with: digitsRange)
            guard let codePoint = UInt32(digits, radix: isHex ? 16 : 10),
                  codePoint <= 0x10FFFF,
                  let scalar = Unicode.Scalar(codePoint) else {
                // Invalid numeric ref — leave the literal in place so
                // the kid can still see something diagnosable. Never
                // crash, never substitute `\u{FFFD}`.
                continue
            }
            let replacement = String(scalar)
            let fullMatchRange = match.range
            if let swiftRange = Range(fullMatchRange, in: output) {
                output.replaceSubrange(swiftRange, with: replacement)
            }
        }
        return output
    }
}

// MARK: - NativeArticleRepresentable
//
// The native NSTextView article renderer. Lives in this sister file (rather
// than ArticleBrowserView.swift) to keep that file under the 600-LOC Big Sur
// type-checker ceiling; it is `internal` so ArticleBrowserView can embed it.

struct NativeArticleRepresentable: NSViewRepresentable {
    let coordinator: ArticleCoordinator

    func makeNSView(context: Context) -> NSScrollView {
        let textView = NSTextView()
        textView.backgroundColor = NSColor.textBackgroundColor
        textView.drawsBackground = true
        textView.isEditable = false
        textView.isSelectable = true
        textView.allowsUndo = false
        textView.textContainerInset = NSSize(width: 28, height: 24)
        textView.textContainer?.widthTracksTextView = true
        textView.textContainer?.containerSize = NSSize(
            width: CGFloat.greatestFiniteMagnitude,
            height: CGFloat.greatestFiniteMagnitude
        )
        let scrollView = NSScrollView()
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = false
        scrollView.autohidesScrollers = true
        scrollView.documentView = textView
        scrollView.backgroundColor = NSColor.textBackgroundColor
        coordinator.attachNativeTextView(textView)
        return scrollView
    }

    func updateNSView(_ nsView: NSScrollView, context: Context) {
        coordinator.updateNativeTextView()
    }

    // Dismantle ordering — the SwiftUI ↔ AppKit pinch-point on Big Sur.
    //
    // When the sheet hosting ArticleBrowserView dismisses (⌘W) and the
    // user immediately clicks a CTA on the parent ChapterDetailView
    // (Try Discover Mode), the sheet-dismount commit and the next render
    // commit can interleave: SwiftUI tears this NSScrollView down, AppKit
    // can still send one final NSTextViewDelegate / NSLayoutManager
    // callback into a freed instance, and the parent commit pump trips on
    // the resulting over-release as objc_release.
    //
    // Defensive ordering, applied synchronously here before the NSScrollView
    // is released by SwiftUI's commit:
    //   1. nil any NSTextView delegate first so AppKit cannot route another
    //      callback (no-op in this build — we never assign one — but cheap
    //      insurance against future code adding a delegate without thinking
    //      about teardown).
    //   2. detach documentView so the NSTextView's retain count drops in a
    //      deterministic order before the SwiftUI commit unwinds.
    static func dismantleNSView(_ nsView: NSScrollView, coordinator: ()) {
        (nsView.documentView as? NSTextView)?.delegate = nil
        nsView.documentView = nil
    }
}
