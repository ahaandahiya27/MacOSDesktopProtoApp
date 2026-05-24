import XCTest
@testable import desktopAhaan

/// Routing-decision coverage for the NSTextView click handler that
/// resolves relative anchor hrefs (`ch01_scientists.html`,
/// `← Back to chapter` → `ch01_overview.html`, etc.) emitted by
/// `ArticleStructuredRenderer`. The pure
/// `ArticleCoordinator.linkAction(...)` helper is the testable seam
/// — the delegate method just acts on what it returns.
final class ArticleLinkRoutingTests: XCTestCase {

    private let chapterDir = URL(fileURLWithPath: "/private/tmp/ch1-fixture")
    private var currentURL: URL { chapterDir.appendingPathComponent("ch01_beyond.html") }

    // MARK: - Internal navigation (relative href, file exists)

    func testRelativeHrefStringResolvesToInternalLoad() {
        let target = chapterDir.appendingPathComponent("ch01_scientists.html")
        let action = ArticleCoordinator.linkAction(
            for: "ch01_scientists.html",
            relativeTo: currentURL,
            fileExists: { $0.standardizedFileURL == target.standardizedFileURL }
        )
        XCTAssertEqual(action, .openInternally(target.standardizedFileURL))
    }

    func testRelativeHrefURLResolvesToInternalLoad() {
        // When the href was a parseable URL with no scheme,
        // NSTextView wraps it as a URL value. `relativeString`
        // captures the original "ch01_scientists.html" form.
        let target = chapterDir.appendingPathComponent("ch01_overview.html")
        let relativeURL = URL(string: "ch01_overview.html")!
        let action = ArticleCoordinator.linkAction(
            for: relativeURL,
            relativeTo: currentURL,
            fileExists: { $0.standardizedFileURL == target.standardizedFileURL }
        )
        XCTAssertEqual(action, .openInternally(target.standardizedFileURL))
    }

    func testFileURLPassedThroughDirectly() {
        // Absolute file URL — no relative resolution needed.
        let target = chapterDir.appendingPathComponent("ch01_storymode.html")
        let action = ArticleCoordinator.linkAction(
            for: target,
            relativeTo: currentURL,
            fileExists: { _ in true }
        )
        XCTAssertEqual(action, .openInternally(target.standardizedFileURL))
    }

    // MARK: - External navigation (http / https)

    func testHttpStringRoutesExternally() {
        let action = ArticleCoordinator.linkAction(
            for: "http://example.com",
            relativeTo: currentURL,
            fileExists: { _ in false }
        )
        XCTAssertEqual(action, .openExternally)
    }

    func testHttpsStringRoutesExternally() {
        let action = ArticleCoordinator.linkAction(
            for: "https://example.com/path",
            relativeTo: currentURL,
            fileExists: { _ in false }
        )
        XCTAssertEqual(action, .openExternally)
    }

    func testHttpsURLRoutesExternally() {
        let action = ArticleCoordinator.linkAction(
            for: URL(string: "https://en.wikipedia.org/wiki/Photosynthesis")!,
            relativeTo: currentURL,
            fileExists: { _ in false }
        )
        XCTAssertEqual(action, .openExternally)
    }

    func testHttpsCaseInsensitiveRoutesExternally() {
        let action = ArticleCoordinator.linkAction(
            for: "HTTPS://example.com",
            relativeTo: currentURL,
            fileExists: { _ in false }
        )
        XCTAssertEqual(action, .openExternally)
    }

    // MARK: - Swallow cases

    func testRelativeHrefToMissingFileSwallows() {
        let action = ArticleCoordinator.linkAction(
            for: "ch01_ghost.html",
            relativeTo: currentURL,
            fileExists: { _ in false }
        )
        XCTAssertEqual(action, .swallow)
    }

    func testMissingCurrentURLSwallows() {
        // No current article means there's no base directory to
        // resolve against — swallow rather than guess.
        let action = ArticleCoordinator.linkAction(
            for: "ch01_scientists.html",
            relativeTo: nil,
            fileExists: { _ in true }
        )
        XCTAssertEqual(action, .swallow)
    }

    func testUnknownLinkTypeSwallows() {
        // NSTextView's `clickedOnLink` documents Any; the real
        // values are String or URL. Anything else → swallow.
        let action = ArticleCoordinator.linkAction(
            for: 42 as Int,
            relativeTo: currentURL,
            fileExists: { _ in true }
        )
        XCTAssertEqual(action, .swallow)
    }

    func testWhitespaceTrimmedBeforeRouting() {
        let target = chapterDir.appendingPathComponent("ch01_glossary.html")
        let action = ArticleCoordinator.linkAction(
            for: "  ch01_glossary.html  ",
            relativeTo: currentURL,
            fileExists: { $0.standardizedFileURL == target.standardizedFileURL }
        )
        XCTAssertEqual(action, .openInternally(target.standardizedFileURL))
    }

    // MARK: - File-exists closure threading

    func testFileExistsClosureIsAskedForResolvedPath() {
        var observed: URL?
        _ = ArticleCoordinator.linkAction(
            for: "ch01_mistakes.html",
            relativeTo: currentURL,
            fileExists: { url in
                observed = url
                return false
            }
        )
        XCTAssertEqual(
            observed?.standardizedFileURL,
            chapterDir.appendingPathComponent("ch01_mistakes.html").standardizedFileURL
        )
    }
}
