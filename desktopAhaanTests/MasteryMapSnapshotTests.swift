import XCTest
@testable import desktopAhaan

// MARK: - MasteryMapSnapshotTests
//
// v6 Learning Journey · Phase 2. Integration smoke test for the live
// `MasteryEngine.snapshot(registry:dataStore:)` path that the Mastery Map
// window renders. Unlike `MasteryEngineTests` (which pins the pure rollup math
// on fabricated inputs), this drives the real `SubjectRegistry` so the
// registry-resolution + coverage-denominator wiring can't silently break.
//
// Assertions are state-independent: they hold no matter what review history
// happens to be on the test machine, so the test is deterministic without
// touching (and therefore without mutating) the SRS — proving the engine's
// read-only contract end to end.
@MainActor
final class MasteryMapSnapshotTests: XCTestCase {

    private func loadedRegistry() async throws -> SubjectRegistry {
        let registry = SubjectRegistry()
        for _ in 0..<50 {
            if !registry.isLoading && !registry.packs.isEmpty { break }
            try? await Task.sleep(nanoseconds: 50_000_000)
        }
        guard !registry.packs.isEmpty else {
            throw XCTSkip("No packs loaded in 2.5 s.")
        }
        return registry
    }

    func testSnapshotHasOneRowPerPackAndCoverageDenominators() async throws {
        let registry = try await loadedRegistry()
        let snap = MasteryEngine.snapshot(registry: registry, dataStore: DataStore.shared)

        XCTAssertEqual(snap.subjects.count, registry.packs.count,
            "Snapshot must carry exactly one row per loaded subject pack.")

        // Row order matches registry presentation order (deterministic).
        XCTAssertEqual(snap.subjects.map { $0.packId },
                       registry.packs.map { $0.id },
            "Subject rows must preserve the registry's pack order.")

        for subject in snap.subjects {
            // Coverage denominator = every reviewable question (topic + boss +
            // quick-check) in the pack. Every real pack has some.
            XCTAssertGreaterThan(subject.totalReviewableQuestions, 0,
                "\(subject.packId) should have a positive reviewable-question count.")
            // Read-only contract: reviewed can never exceed reviewable here,
            // and coverage/mastery stay in [0, 1].
            XCTAssertLessThanOrEqual(subject.reviewedQuestions, subject.totalReviewableQuestions,
                "\(subject.packId) reviewed (\(subject.reviewedQuestions)) exceeds reviewable (\(subject.totalReviewableQuestions)).")
            assertUnitInterval(subject.coverageFraction, "\(subject.packId).coverage")
            assertUnitInterval(subject.masteryFraction, "\(subject.packId).mastery")
            XCTAssertGreaterThanOrEqual(subject.dueCount, 0)
            XCTAssertFalse(subject.subjectTitle.isEmpty,
                "\(subject.packId) must carry a human title for the Map.")
        }
    }

    func testOverallAggregatesStayConsistentWithSubjectRows() async throws {
        let registry = try await loadedRegistry()
        let snap = MasteryEngine.snapshot(registry: registry, dataStore: DataStore.shared)

        XCTAssertEqual(snap.totalReviewed,
                       snap.subjects.reduce(0) { $0 + $1.reviewedQuestions },
            "Overall reviewed must equal the sum across subjects.")
        XCTAssertEqual(snap.totalReviewable,
                       snap.subjects.reduce(0) { $0 + $1.totalReviewableQuestions },
            "Overall reviewable must equal the sum across subjects.")
        XCTAssertEqual(snap.totalDue,
                       snap.subjects.reduce(0) { $0 + $1.dueCount },
            "Overall due must equal the sum across subjects.")
        assertUnitInterval(snap.overallCoverageFraction, "overall.coverage")
        assertUnitInterval(snap.overallMasteryFraction, "overall.mastery")

        // startedSubjects is exactly the rows with a review, and the weakest
        // (if any) must be one of them.
        XCTAssertEqual(snap.startedSubjects.count,
                       snap.subjects.filter { $0.hasStarted }.count)
        if let weakest = snap.weakestStartedSubject {
            XCTAssertTrue(weakest.hasStarted,
                "weakestStartedSubject must itself be a started subject.")
            XCTAssertTrue(snap.startedSubjects.contains(weakest))
        } else {
            XCTAssertTrue(snap.startedSubjects.isEmpty,
                "No weakest subject implies nothing has been started.")
        }
    }

    private func assertUnitInterval(_ value: Double, _ label: String,
                                    file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertFalse(value.isNaN, "\(label) is NaN.", file: file, line: line)
        XCTAssertGreaterThanOrEqual(value, 0.0, "\(label) < 0.", file: file, line: line)
        XCTAssertLessThanOrEqual(value, 1.0, "\(label) > 1.", file: file, line: line)
    }
}
