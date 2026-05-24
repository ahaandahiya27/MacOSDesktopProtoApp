import XCTest
@testable import desktopAhaan

/// Parser-side coverage for `ArticleStructuredRenderer`. The
/// assembler (NSAttributedString output) lives behind a `@MainActor`
/// requirement and is exercised by the manual walk noted in
/// REMEDIATION_LOG; these tests pin the pure parser behaviour the
/// brief's tests R7..R10 + a handful of robustness checks.
final class ArticleStructuredRendererTests: XCTestCase {

    // MARK: - R7 — Hero title de-duplication

    func testHeroTitleDeduplicationWhenH1MatchesChromeTitle() {
        let html = """
        <html><head><title>Beyond the Book — Chapter 1 · Nutrition in Plants</title></head>
        <body><article>
          <header class="hero">
            <h1>Beyond the Book — Chapter 1 · Nutrition in Plants</h1>
            <p>Ten ideas about plants&#x2026;</p>
          </header>
        </article></body></html>
        """
        let blocks = ArticleStructuredRenderer.parseBlocks(html)
        let chromeTitle = "Beyond the Book — Chapter 1 · Nutrition in Plants"
        let trimmed = ArticleStructuredRenderer.deduplicateHeroHeading(
            blocks, matching: chromeTitle
        )
        // Original had a heading + a paragraph; after dedup only the
        // paragraph remains as the first block.
        XCTAssertEqual(trimmed.count, blocks.count - 1)
        if case .paragraph(let runs) = trimmed.first {
            XCTAssertTrue(runs.map(\.text).joined().contains("Ten ideas about plants"))
        } else {
            XCTFail("expected first block to be a paragraph after hero dedup, got \(String(describing: trimmed.first))")
        }
    }

    func testHeroTitleDedupCaseAndWhitespaceInsensitive() {
        let html = """
        <article>
          <h1>  beyond the book — chapter 1  </h1>
          <p>lede</p>
        </article>
        """
        let blocks = ArticleStructuredRenderer.parseBlocks(html)
        let trimmed = ArticleStructuredRenderer.deduplicateHeroHeading(
            blocks, matching: "Beyond the Book — Chapter 1"
        )
        XCTAssertEqual(trimmed.count, blocks.count - 1)
    }

    func testHeroTitleNotDeduplicatedWhenMismatched() {
        let html = """
        <article>
          <h1>A different heading</h1>
          <p>lede</p>
        </article>
        """
        let blocks = ArticleStructuredRenderer.parseBlocks(html)
        let trimmed = ArticleStructuredRenderer.deduplicateHeroHeading(
            blocks, matching: "Beyond the Book"
        )
        XCTAssertEqual(trimmed.count, blocks.count,
                       "Heading must NOT be dropped when it doesn't match the chrome title")
    }

    // MARK: - R8 — Bullet list parsing

    func testBulletListParse() {
        let html = """
        <article>
          <p>Lead-in.</p>
          <ul><li>a</li><li>b</li></ul>
        </article>
        """
        let blocks = ArticleStructuredRenderer.parseBlocks(html)
        // First block should be the paragraph; second the bullet list.
        XCTAssertEqual(blocks.count, 2)
        if case .bulletList(let items) = blocks[1] {
            XCTAssertEqual(items.count, 2)
            XCTAssertEqual(items[0].map(\.text).joined(), "a")
            XCTAssertEqual(items[1].map(\.text).joined(), "b")
        } else {
            XCTFail("expected blocks[1] to be a bulletList; got \(blocks[1])")
        }
    }

    func testBulletListPreservesInlineStrongMarkup() {
        let html = """
        <article>
          <ul>
            <li>Chlorophyll: <strong>magnesium (Mg)</strong> at the centre.</li>
            <li>Haemoglobin: <strong>iron (Fe)</strong> at the centre.</li>
          </ul>
        </article>
        """
        let blocks = ArticleStructuredRenderer.parseBlocks(html)
        XCTAssertEqual(blocks.count, 1)
        if case .bulletList(let items) = blocks[0] {
            XCTAssertEqual(items.count, 2)
            let firstBold = items[0].first(where: { $0.isBold })?.text
            XCTAssertEqual(firstBold, "magnesium (Mg)")
        } else {
            XCTFail("expected a single bulletList block")
        }
    }

    // MARK: - R9 — Callout box (fact-box)

    func testFactBoxCalloutParse() {
        let html = """
        <article>
          <aside class="fact-box">
            <h3>💡 Try this</h3>
            <p>Weigh a plant today.</p>
          </aside>
        </article>
        """
        let blocks = ArticleStructuredRenderer.parseBlocks(html)
        XCTAssertEqual(blocks.count, 1)
        if case .calloutBox(let title, let body) = blocks[0] {
            XCTAssertEqual(title, "💡 Try this")
            XCTAssertEqual(body.map(\.text).joined(), "Weigh a plant today.")
        } else {
            XCTFail("expected a calloutBox block; got \(blocks[0])")
        }
    }

    // MARK: - R10 — Link card

    func testLinkCardParse() {
        let html = """
        <article>
          <a href="ch01_scientists.html">
            <div>
              <strong>👨‍🔬 Famous Plant Scientists</strong>
              <p>Van Helmont, Priestley, Ingenhousz, J.C. Bose.</p>
            </div>
          </a>
        </article>
        """
        let blocks = ArticleStructuredRenderer.parseBlocks(html)
        XCTAssertEqual(blocks.count, 1)
        if case .linkCard(let emoji, let title, let blurb, let href) = blocks[0] {
            XCTAssertEqual(emoji, "👨‍🔬")
            XCTAssertEqual(title, "Famous Plant Scientists")
            XCTAssertEqual(href, "ch01_scientists.html")
            XCTAssertTrue(blurb.contains("Van Helmont"))
        } else {
            XCTFail("expected a linkCard block; got \(blocks[0])")
        }
    }

    func testLinkCardEmojiAbsentWhenTitleIsAllText() {
        let html = """
        <article>
          <a href="ch01_overview.html">
            <div>
              <strong>Back to chapter</strong>
              <p>Returns to the chapter detail page.</p>
            </div>
          </a>
        </article>
        """
        let blocks = ArticleStructuredRenderer.parseBlocks(html)
        XCTAssertEqual(blocks.count, 1)
        if case .linkCard(let emoji, let title, _, _) = blocks[0] {
            XCTAssertNil(emoji)
            XCTAssertEqual(title, "Back to chapter")
        } else {
            XCTFail("expected a linkCard; got \(blocks[0])")
        }
    }

    // MARK: - Inline marks

    func testParagraphInlineStrongAndEm() {
        let runs = ArticleStructuredRenderer.parseInlineRuns(
            "In <strong>1600s</strong> a Belgian scientist named <em>Van Helmont</em> ran an experiment."
        )
        let bold = runs.first(where: { $0.isBold })
        let italic = runs.first(where: { $0.isItalic })
        XCTAssertEqual(bold?.text, "1600s")
        XCTAssertEqual(italic?.text, "Van Helmont")
    }

    func testNumericEntityDecodedInsideRuns() {
        // E1 ordering — numeric refs inside paragraph runs decode.
        let runs = ArticleStructuredRenderer.parseInlineRuns(
            "tree&#x27;s weight"
        )
        XCTAssertEqual(runs.map(\.text).joined(), "tree's weight")
    }

    // MARK: - Head / script / style stripping

    func testHeadAndStyleAndScriptStripped() {
        let html = """
        <html>
        <head>
          <title>X</title>
          <style>body{font-size:14px;}</style>
        </head>
        <body>
          <script>alert('hi')</script>
          <p>visible</p>
        </body>
        </html>
        """
        let blocks = ArticleStructuredRenderer.parseBlocks(html)
        XCTAssertEqual(blocks.count, 1)
        if case .paragraph(let runs) = blocks[0] {
            XCTAssertEqual(runs.map(\.text).joined(), "visible")
        } else {
            XCTFail("expected single paragraph after stripping head/script/style")
        }
    }

    // MARK: - Heading levels

    func testH1H2H3LevelsCaptured() {
        let html = """
        <article>
          <h1>Top</h1><h2>Sub</h2><h3>Smaller</h3>
        </article>
        """
        let blocks = ArticleStructuredRenderer.parseBlocks(html)
        let levels: [Int] = blocks.compactMap {
            if case .heading(let level, _) = $0 { return level }
            return nil
        }
        XCTAssertEqual(levels, [1, 2, 3])
    }
}
