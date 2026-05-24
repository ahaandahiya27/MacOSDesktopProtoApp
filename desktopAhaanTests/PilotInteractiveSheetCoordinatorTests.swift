import XCTest
import Combine
@testable import desktopAhaan

/// Smoke tests for `PilotInteractiveSheetCoordinator`. The class
/// itself is tiny (~15 LOC of real logic on top of @Published);
/// these tests pin the contract that ChapterDetailView depends on:
///   - default state is nil
///   - assigning a non-nil value publishes a change
///   - presentDeferred(_:) defers the assignment to the next runloop
///     tick (the documented dismantle-order pattern)
///   - dismiss() clears the state
final class PilotInteractiveSheetCoordinatorTests: XCTestCase {

    func testDefaultStateIsNil() {
        let coord = PilotInteractiveSheetCoordinator()
        XCTAssertNil(coord.presented,
                     "A freshly-created coordinator must not have a sheet presented.")
    }

    func testDirectAssignmentPublishesChange() {
        let coord = PilotInteractiveSheetCoordinator()
        let exp = expectation(description: "objectWillChange fires on assignment")
        let cancellable = coord.objectWillChange.sink { _ in exp.fulfill() }

        coord.presented = .glossary

        wait(for: [exp], timeout: 0.5)
        XCTAssertEqual(coord.presented?.id, "glossary",
                       "Direct assignment must update `presented`.")
        cancellable.cancel()
    }

    func testPresentDeferredDefersAssignmentToNextRunloopTick() {
        let coord = PilotInteractiveSheetCoordinator()
        coord.presentDeferred(.insideTheLeafTour)

        // Synchronous check — the deferred assignment hasn't run yet.
        XCTAssertNil(coord.presented,
                     "presentDeferred(_:) must NOT assign synchronously — that's the entire point of the runloop defer.")

        let exp = expectation(description: "deferred assignment lands")
        DispatchQueue.main.async {
            XCTAssertEqual(coord.presented?.id, "insideTheLeafTour",
                           "After one runloop tick, the deferred sheet must be presented.")
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.5)
    }

    func testDismissClearsState() {
        let coord = PilotInteractiveSheetCoordinator()
        coord.presented = .conceptMap
        XCTAssertNotNil(coord.presented)

        coord.dismiss()

        XCTAssertNil(coord.presented,
                     "dismiss() must clear the presented sheet.")
    }

    func testSheetKindIdsAreStableForKnownCases() {
        XCTAssertEqual(SheetKind.glossary.id, "glossary")
        XCTAssertEqual(SheetKind.conceptMap.id, "conceptMap")
        XCTAssertEqual(SheetKind.insideTheLeafTour.id, "insideTheLeafTour")
        XCTAssertEqual(SheetKind.insideTheWireTour.id, "insideTheWireTour")
        XCTAssertEqual(SheetKind.insideTheLensTour.id, "insideTheLensTour")
        XCTAssertEqual(SheetKind.insideTheAlveolusTour.id, "insideTheAlveolusTour")
        XCTAssertEqual(SheetKind.insideTheXylemTour.id, "insideTheXylemTour")
        XCTAssertEqual(SheetKind.insideTheDigestiveTour.id, "insideTheDigestiveTour")
        XCTAssertEqual(SheetKind.homeExperiments.id, "homeExperiments")
        XCTAssertEqual(SheetKind.notebook.id, "notebook")
        // Article ids include the entry's id — pin the format prefix.
        let entry = ArticleEntry(
            id: "test_entry",
            filename: "test.html",
            title: "Test",
            chapterFolder: "Articles/Chapter1",
            estimatedMinutes: 1
        )
        XCTAssertTrue(SheetKind.article(entry).id.hasPrefix("article-"),
                      "Article SheetKind ids must be prefixed `article-` so .sheet(item:) can key on them.")
    }
}
