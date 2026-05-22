import XCTest

final class Crash_BeyondThenDiscover: XCTestCase {
    func testBeyondTheBookThenDiscoverMode() throws {
        let app = XCUIApplication()
        app.launch()

        dismissWelcomeIfNeeded(in: app)

        let scienceRow = app.staticTexts.matching(
            NSPredicate(format: "label CONTAINS %@", "Science")
        ).firstMatch
        XCTAssertTrue(scienceRow.waitForExistence(timeout: 3))
        scienceRow.click()

        let chapterTitle = app.staticTexts["Nutrition in Plants"]
        XCTAssertTrue(chapterTitle.waitForExistence(timeout: 3))
        chapterTitle.click()

        let beyondTheBook = app.buttons["Beyond the Book"]
        XCTAssertTrue(beyondTheBook.waitForExistence(timeout: 3))
        beyondTheBook.click()

        sleep(1)

        let closeArticle = app.buttons["Close article"]
        XCTAssertTrue(closeArticle.waitForExistence(timeout: 3))
        closeArticle.click()

        usleep(200_000)

        let discoverButton = app.buttons["Try Discover Mode"]
        XCTAssertTrue(discoverButton.waitForExistence(timeout: 3))
        discoverButton.click()

        let discoverTitle = app.staticTexts.matching(
            NSPredicate(format: "label CONTAINS %@", "Discover")
        ).matching(
            NSPredicate(format: "label CONTAINS %@", "Nutrition in Plants")
        ).firstMatch
        XCTAssertTrue(discoverTitle.waitForExistence(timeout: 3))
    }

    private func dismissWelcomeIfNeeded(in app: XCUIApplication) {
        let letsGo = app.buttons["Let's go"]
        if letsGo.waitForExistence(timeout: 1) {
            letsGo.click()
        }
    }
}
