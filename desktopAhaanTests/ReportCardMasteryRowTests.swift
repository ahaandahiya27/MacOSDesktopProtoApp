import XCTest
@testable import desktopAhaan

// MARK: - ReportCardMasteryRowTests
//
// v6 Learning Journey · Phase 4 M3b. Pins the pure mapping from a cross-subject
// `OverallMasterySnapshot` to the report card's flat mastery rows: order
// preserved, coverage/mastery/started carried through, level named.
final class ReportCardMasteryRowTests: XCTestCase {

    private func subject(_ packId: String, title: String,
                         reviewed: Int, reviewable: Int) -> SubjectMasterySnapshot {
        SubjectMasterySnapshot(
            packId: packId, subjectTitle: title,
            summary: MasterySummary(subjectPackId: packId, chapters: [],
                                    dueCount: 0, totalReviewed: reviewed),
            totalReviewableQuestions: reviewable, dueCount: 0)
    }

    func testRowsPreserveOrderAndCarryFields() {
        let started = subject("p1", title: "One", reviewed: 5, reviewable: 10)
        let unstarted = subject("p2", title: "Two", reviewed: 0, reviewable: 8)
        let snapshot = MasteryEngine.overall(from: [started, unstarted])

        let rows = ReportCardMasteryRow.rows(from: snapshot)

        XCTAssertEqual(rows.count, 2)
        XCTAssertEqual(rows.map { $0.subjectTitle }, ["One", "Two"],
            "Row order matches the snapshot's subject order.")

        XCTAssertTrue(rows[0].hasStarted)
        XCTAssertEqual(rows[0].coverageFraction, 0.5, accuracy: 1e-9,
            "5 reviewed of 10 reviewable → 0.5 coverage.")
        XCTAssertEqual(rows[0].masteryFraction, 0, accuracy: 1e-9,
            "No chapter buckets → 0 mastery.")
        XCTAssertEqual(rows[0].levelName, MasteryLevel.learning.displayName)

        XCTAssertFalse(rows[1].hasStarted, "A subject with no reviews is not started.")
        XCTAssertEqual(rows[1].coverageFraction, 0, accuracy: 1e-9)
    }

    func testRowsEmptyWhenNoSubjects() {
        let rows = ReportCardMasteryRow.rows(from: MasteryEngine.overall(from: []))
        XCTAssertTrue(rows.isEmpty)
    }
}
