import XCTest
@testable import desktopAhaan

/// Coverage for the HTML→text reducer that drives every article
/// surface in the app. The authored HTML uses a mix of named and
/// numeric character references; before the 2026-05-24 fix only the
/// 9-entry named subset was decoded, so every apostrophe in every
/// Beyond-the-Book / Story / Scientists / What-If / Plant-of-the-Day
/// / Glossary / Self-Check / NCERT-Q&A / Mistakes / Bridge / Mini-
/// project / Infographic article showed as the literal `&#x27;`.
///
/// These tests pin the decoder's ordering rules (named → numeric →
/// `&amp;` last) so a future "let's simplify the loop" PR can't
/// silently regress the most-visible content bug in the app.
final class ArticlePlainTextFallbackTests: XCTestCase {

    private func decode(_ input: String) -> String {
        // `stripHTML` does block-break inserts + tag stripping + entity
        // decode + newline collapse. For entity-decode-only assertions
        // we route through `decodeEntities` directly so the test isn't
        // sensitive to surrounding whitespace transforms.
        return PlainTextArticleFallback.decodeEntities(input)
    }

    // MARK: - E1: numeric character references

    func testNumericHexEntityDecodes() {
        XCTAssertEqual(decode("don&#x27;t"), "don't")
        XCTAssertEqual(decode("an&#x2014;then"), "an\u{2014}then")
    }

    func testNumericHexEntityUppercaseXDecodes() {
        // The HTML spec allows both `&#x` and `&#X`.
        XCTAssertEqual(decode("&#X2018;hi&#X2019;"), "\u{2018}hi\u{2019}")
    }

    func testNumericDecimalEntityDecodes() {
        XCTAssertEqual(decode("don&#39;t"), "don't")
        XCTAssertEqual(decode("&#8217;"), "\u{2019}")
    }

    // MARK: - E2: extended named entities

    func testNamedEntityDecodesIncludingRsquo() {
        XCTAssertEqual(decode("don&rsquo;t"), "don\u{2019}t")
        XCTAssertEqual(decode("&ldquo;hello&rdquo;"), "\u{201C}hello\u{201D}")
    }

    func testNamedEntityDecodesCommercialAndMath() {
        XCTAssertEqual(decode("&copy; 2026"), "© 2026")
        XCTAssertEqual(decode("3 &times; 4 = 12"), "3 × 4 = 12")
        XCTAssertEqual(decode("&plusmn;5&deg;C"), "±5°C")
    }

    func testRetainedXMLBaselineStillDecodes() {
        // The pre-fix table covered these; verify they still work
        // after the rewrite so the change is purely additive.
        XCTAssertEqual(decode("&lt;tag&gt;"), "<tag>")
        XCTAssertEqual(decode("&quot;hi&quot;"), "\"hi\"")
        XCTAssertEqual(decode("space&nbsp;here"), "space here")
        XCTAssertEqual(decode("a&mdash;b"), "a—b")
    }

    // MARK: - E3: ordering rule — &amp; last

    func testAmpersandDecodedLast() {
        // The literal sequence "&amp;#x27;" appears in source when the
        // author intentionally escaped a numeric ref. If `&amp;`
        // decoded first, that becomes "&#x27;", and the numeric sweep
        // then incorrectly produces "'". With the rule "named → numeric
        // → &amp; last", the numeric sweep sees no real numeric ref to
        // match, and `&amp;` decodes alone — leaving the literal
        // `&#x27;` for the reader to see.
        XCTAssertEqual(decode("&amp;#x27;"), "&#x27;")
    }

    func testAmpersandAloneDecodes() {
        // Sanity — a plain `&amp;` still becomes `&`.
        XCTAssertEqual(decode("A&amp;B"), "A&B")
        XCTAssertEqual(decode("Q&amp;A"), "Q&A")
    }

    // MARK: - Robustness — invalid numeric refs

    func testInvalidNumericHexLeftAsLiteral() {
        XCTAssertEqual(decode("&#xZZZZ;"), "&#xZZZZ;")
    }

    func testNumericRefAboveUnicodeMaxLeftAsLiteral() {
        // 0x110000 is one past the last Unicode scalar.
        XCTAssertEqual(decode("&#x110000;"), "&#x110000;")
    }

    func testNumericRefAtUnicodeMaxDecodes() {
        // 0x10FFFF is the largest legal scalar.
        XCTAssertEqual(decode("&#x10FFFF;"), String(Unicode.Scalar(0x10FFFF)!))
    }

    // MARK: - End-to-end through stripHTML (block breaks + entities)

    func testStripHTMLEndToEndKeepsParagraphBoundariesAndDecodesEntities() {
        // Real-world shape from `Resources/Articles/Chapter1/ch01_beyond.html`:
        // the authored HTML mixes hex numeric refs (`&#x27;`) with typographic
        // named entities (`&ldquo;`, `&rdquo;`, `&times;`, `&deg;`) inside
        // ordinary `<p>` blocks.
        let html = """
        <p>It&#x27;s the tree&rsquo;s &ldquo;ring&rdquo; pattern.</p>
        <p>3 &times; 4 = 12&deg;.</p>
        """
        let out = PlainTextArticleFallback.stripHTML(html)
        XCTAssertTrue(out.contains("It's the tree\u{2019}s \u{201C}ring\u{201D} pattern."),
                      "first paragraph mis-decoded: \(out)")
        XCTAssertTrue(out.contains("3 × 4 = 12°."),
                      "second paragraph mis-decoded: \(out)")
        XCTAssertTrue(out.contains("\n\n"),
                      "block boundary missing — paragraphs got run together")
    }

    func testEmptyInputReturnsEmpty() {
        XCTAssertEqual(decode(""), "")
    }

    func testInputWithoutEntitiesReturnedVerbatim() {
        XCTAssertEqual(decode("plain text — no refs here"),
                       "plain text — no refs here")
    }
}
