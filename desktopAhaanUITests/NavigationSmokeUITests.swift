import XCTest

// MARK: - NavigationSmokeUITests
//
// End-to-end smoke walk of the primary navigation flow — the single
// path the kid uses most:
//
//     launch → dismiss welcome → Science Ch.1 → first topic →
//     first concept (assert concept detail) → first related question
//     (assert question detail).
//
// This covers the T3 row in `docs/ISSUE_CATEGORIES.md` ("Smoke test
// for navigation"). It deliberately picks the most-likely-regression
// path: every refactor that touches `TutorNavigationState.push(_:)`,
// the chapter-detail TopicCard, the TopicDetailView ConceptRow /
// QuestionRow buttons, or ConceptDetailView's Related-questions
// section can break this walk silently — and 269 unit tests cannot
// see it. One assertion per hop catches a regression at the exact
// boundary it lands.
//
// Accessibility grant required to run. Without it the click() calls
// silently no-op and assertions fail by timeout (the correct
// failure mode — no false-confidence pass). First-time setup on the
// runner machine:
//
//   System Settings → Privacy & Security → Accessibility →
//   desktopAhaanUITests-Runner.app  (enable the toggle)
//
// Big Sur (iMac late-2014 / 11.7.11) compat: every query uses
// `app.buttons[<id-or-label>]` + `waitForExistence(timeout:)`. No
// `accessibilityLabel(_:)` query method (macOS 13+), no async/await
// waiters, no SwiftUI Charts or other macOS 12+ APIs. Sleeps use
// `usleep()` (microseconds), matching the rest of the UITest suite.

final class NavigationSmokeUITests: XCTestCase {

    private func launchedApp() -> XCUIApplication {
        let app = XCUIApplication(bundleIdentifier: "com.emoha.desktopAhaan")
        app.launch()
        AXHelpers.dismissWelcomeUI(in: app)
        return app
    }

    /// Walk home → subject → chapter → topic → concept → question
    /// in one shot, asserting visibility at every hop. If any push
    /// silently breaks, the next assertion fails by timeout and
    /// points at the exact boundary that regressed.
    func test_homeToQuestionDetail_endToEnd() throws {
        let app = launchedApp()

        // Hop 1 — sidebar Science row → Ch.1 chapter detail. AXHelpers
        // proxies "did we land" via the Try Discover Mode banner, which
        // ships on every Science chapter detail page.
        XCTAssertTrue(AXHelpers.openChapter(1, in: app),
                      "Ch.1 chapter detail did not render — sidebar / chapter row navigation broken before the walk could start.")

        // Hop 2 — first TopicCard on Ch.1. The button's
        // accessibilityLabel is set to the topic title in
        // ChapterDetailView.swift (.accessibilityLabel(topic.title)).
        // Ch.1's first topic is "How green plants make their own food";
        // if a content edit re-orders or renames topics, this query
        // updates with the JSON.
        let firstTopicBtn = app.buttons["How green plants make their own food"].firstMatch
        XCTAssertTrue(firstTopicBtn.waitForExistence(timeout: 3),
                      "First topic card missing on Ch.1 — ChapterDetailView topic list mount may have regressed, or Ch.1's first topic was renamed.")
        firstTopicBtn.click()
        usleep(300_000) // 0.3s — let nav.push commit + TopicDetailView mount.

        // Hop 3 — assert TopicDetailView is up by waiting for the
        // first ConceptRow's button. The row is a Button whose label
        // contains the concept title (TopicDetailView.swift L46-52);
        // SwiftUI surfaces that title as the button's AX label by
        // default. Ch.1's first concept is "Autotrophs and heterotrophs".
        let firstConceptBtn = app.buttons["Autotrophs and heterotrophs"].firstMatch
        XCTAssertTrue(firstConceptBtn.waitForExistence(timeout: 3),
                      "First concept row missing on Ch.1 topic 1 — TopicDetailView Concepts section mount may have regressed.")
        firstConceptBtn.click()
        usleep(300_000) // 0.3s — let nav.push commit + ConceptDetailView mount.

        // Hop 4 — assert ConceptDetailView is up. The toolbar
        // Bookmark button (ConceptDetailView.swift L77-86) has a
        // stable Label("Bookmark", systemImage:) — only present on
        // the concept detail page, so its presence is a reliable
        // proxy for "concept detail mounted." We accept either
        // "Bookmark" (new) or "Bookmarked" (already-bookmarked) so
        // a previous run on the same machine doesn't break the walk.
        let bookmarkBtn = app.buttons["Bookmark"].firstMatch
        let bookmarkedBtn = app.buttons["Bookmarked"].firstMatch
        let conceptDetailMounted = bookmarkBtn.waitForExistence(timeout: 3)
            || bookmarkedBtn.waitForExistence(timeout: 1)
        XCTAssertTrue(conceptDetailMounted,
                      "ConceptDetailView did not mount within 3s — nav.push(.concept(...)) path may have regressed.")

        // Hop 5 — tap the first related question. The Related
        // section on ConceptDetailView (relatedSection at L504+)
        // renders one Button per relatedQuestionId, with the
        // question prompt as the button's label. Ch.1's first
        // concept lists `ch01_t01_q01` as its first relatedQuestionId
        // — that question's prompt is the one below. If content
        // edits the prompt or drops the relation, this fails fast
        // and explicitly.
        let firstQuestionBtn = app.buttons["Who serves as the ultimate source of energy to all the living organisms?"].firstMatch
        XCTAssertTrue(firstQuestionBtn.waitForExistence(timeout: 3),
                      "First related-question row missing on the Autotrophs concept — relatedQuestionIds on ch01_t01_c01 may have changed, or ConceptDetailView relatedSection mount regressed.")
        firstQuestionBtn.click()
        usleep(300_000) // 0.3s — let nav.push commit + QuestionDetailView mount.

        // Hop 6 — assert QuestionDetailView is up. The "Previous
        // question" and "Next question" buttons (QuestionDetailView.swift
        // L234/251 — .accessibilityLabel("Previous question") /
        // "Next question") are only mounted on the question detail
        // page, so they are a stable proxy. Either one suffices —
        // a first-or-last question hides one of the two, but the
        // other is always present.
        let prevQBtn = app.buttons["Previous question"].firstMatch
        let nextQBtn = app.buttons["Next question"].firstMatch
        let questionDetailMounted = prevQBtn.waitForExistence(timeout: 3)
            || nextQBtn.waitForExistence(timeout: 1)
        XCTAssertTrue(questionDetailMounted,
                      "QuestionDetailView did not mount within 3s — nav.push(.question(...)) path may have regressed. End-to-end navigation walk failed at the last hop.")
    }
}
