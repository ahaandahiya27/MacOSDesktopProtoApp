import XCTest
@testable import desktopAhaan

/// Pins the contract of `DataStore.toggleToughQuestion(_:)` and
/// the read-back via `isToughQuestion(_:)`. Closes Family E.6 of
/// `BUG_FREE_CERTIFICATION_REPORT.md` — the toggle-symmetry
/// invariant didn't have a dedicated test before.
///
/// Properties asserted:
///
/// 1. **Read-back symmetry.** After `toggleToughQuestion(qid)`,
///    `isToughQuestion(qid)` returns the new flagged state.
/// 2. **Toggle round-trip is identity.** Toggling twice from a
///    given state returns to that state.
/// 3. **Flagging seeds an SM-2 review row** if none exists. This
///    is the documented side effect that solves the chicken-and-
///    egg problem of an empty Daily Practice queue (see
///    `DataStore.toggleToughQuestion` comment).
/// 4. **Unflagging does NOT remove the review row.** If the kid
///    re-flags later, their SM-2 state should pick up where it
///    left off rather than starting from scratch.
@MainActor
final class ToughFlagSymmetryTests: XCTestCase {

    /// Use a stable test id that doesn't collide with any pack.
    private let testQid = "tough-flag-symmetry-test-qid"

    override func setUp() async throws {
        try await super.setUp()
        // Reset just this test's id; preserve other state so we don't
        // wreck a parallel test that's mid-flight.
        DataStore.shared.toughQuestionIds.remove(testQid)
        DataStore.shared.questionReviews[testQid] = nil
    }

    override func tearDown() async throws {
        DataStore.shared.toughQuestionIds.remove(testQid)
        DataStore.shared.questionReviews[testQid] = nil
        try await super.tearDown()
    }

    func testToggleReadBackSymmetry() {
        let ds = DataStore.shared
        XCTAssertFalse(ds.isToughQuestion(testQid),
            "Precondition: id must start unflagged.")
        ds.toggleToughQuestion(testQid)
        XCTAssertTrue(ds.isToughQuestion(testQid),
            "After first toggle, id must read as flagged.")
        ds.toggleToughQuestion(testQid)
        XCTAssertFalse(ds.isToughQuestion(testQid),
            "After second toggle, id must read as unflagged.")
    }

    func testToggleRoundTripIsIdentity() {
        let ds = DataStore.shared
        let initiallyTough = ds.isToughQuestion(testQid)
        ds.toggleToughQuestion(testQid)
        ds.toggleToughQuestion(testQid)
        XCTAssertEqual(ds.isToughQuestion(testQid), initiallyTough,
            "Two toggles must return to the original flagged state " +
            "regardless of starting position.")
    }

    func testFlaggingSeedsSM2ReviewWhenNoneExists() {
        let ds = DataStore.shared
        XCTAssertNil(ds.questionReviews[testQid],
            "Precondition: id must start without an SM-2 review row.")
        ds.toggleToughQuestion(testQid)
        XCTAssertNotNil(ds.questionReviews[testQid],
            "Flagging tough must seed an SM-2 review so Daily " +
            "Practice can find the item without waiting for a " +
            "first answer (chicken-and-egg fix per " +
            "DataStore.toggleToughQuestion docs).")
    }

    func testUnflaggingPreservesSM2ReviewState() {
        let ds = DataStore.shared
        ds.toggleToughQuestion(testQid)   // flag + seed review
        guard let seeded = ds.questionReviews[testQid] else {
            XCTFail("Seed step did not record a review row.")
            return
        }
        ds.toggleToughQuestion(testQid)   // unflag
        XCTAssertNotNil(ds.questionReviews[testQid],
            "Unflagging must NOT remove the SM-2 review row — the " +
            "kid may re-flag later and should resume from the same " +
            "SM-2 state.")
        XCTAssertEqual(ds.questionReviews[testQid]?.questionId,
                       seeded.questionId,
            "The same review row must survive across the toggle.")
    }
}
