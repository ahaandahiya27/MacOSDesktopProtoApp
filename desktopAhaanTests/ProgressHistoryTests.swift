import XCTest
@testable import desktopAhaan

// MARK: - ProgressHistoryTests
//
// v8 Longitudinal Insights · Phase 1. Covers the progress-history foundation:
//   • the pure analysis helpers (delta / series / weekOverWeek) on fabricated
//     rows, no @MainActor / registry / DataStore;
//   • the live capture path: idempotent per calendar day, rolling cap, atomic
//     persistence round-trip, and READ-ONLY over the SRS.

final class ProgressHistoryPureTests: XCTestCase {

    private func day(_ offsetDays: Int) -> Date {
        // A fixed reference day so tests don't depend on `Date()`.
        let base = Date(timeIntervalSince1970: 1_700_000_000) // 2023-11-14 UTC
        return Calendar(identifier: .gregorian)
            .startOfDay(for: base.addingTimeInterval(Double(offsetDays) * 86_400))
    }

    private func snap(_ offsetDays: Int,
                      overallMastery: Double,
                      overallCoverage: Double = 0.5,
                      subjects: [(String, Double)] = []) -> ProgressSnapshot {
        ProgressSnapshot(
            date: day(offsetDays),
            subjects: subjects.map {
                SubjectProgressPoint(packId: $0.0, masteryFraction: $0.1,
                                     coverageFraction: 0.4, reviewedQuestions: 10, dueCount: 1)
            },
            overallMasteryFraction: overallMastery,
            overallCoverageFraction: overallCoverage
        )
    }

    func testDeltaIsSignedAndPerSubjectOnlyForSharedSubjects() {
        let from = snap(0, overallMastery: 0.30, overallCoverage: 0.40,
                        subjects: [("science_class7", 0.5), ("maths_class7", 0.2)])
        let to = snap(7, overallMastery: 0.45, overallCoverage: 0.55,
                      subjects: [("science_class7", 0.6), ("sanskrit_class7", 0.1)])
        let d = ProgressHistory.delta(from: from, to: to)
        XCTAssertEqual(d.overallMasteryDelta, 0.15, accuracy: 1e-9)
        XCTAssertEqual(d.overallCoverageDelta, 0.15, accuracy: 1e-9)
        // Only science is in BOTH snapshots → only it gets a per-subject delta.
        XCTAssertEqual(d.perSubjectMasteryDelta.count, 1)
        XCTAssertEqual(d.perSubjectMasteryDelta["science_class7"] ?? -99, 0.10, accuracy: 1e-9)
        XCTAssertNil(d.perSubjectMasteryDelta["maths_class7"])     // absent from `to`
        XCTAssertNil(d.perSubjectMasteryDelta["sanskrit_class7"])  // absent from `from`
    }

    func testDeltaCanBeNegative() {
        let d = ProgressHistory.delta(from: snap(0, overallMastery: 0.6),
                                      to: snap(7, overallMastery: 0.4))
        XCTAssertEqual(d.overallMasteryDelta, -0.2, accuracy: 1e-9)
    }

    func testSeriesSortsAndSkipsMissingSubject() {
        let history = [
            snap(2, overallMastery: 0.3, subjects: [("science_class7", 0.3)]),
            snap(0, overallMastery: 0.1, subjects: [("science_class7", 0.1)]),
            snap(1, overallMastery: 0.2, subjects: [("maths_class7", 0.9)]), // no science
        ]
        let s = ProgressHistory.series(history, forPackId: "science_class7")
        XCTAssertEqual(s.map(\.masteryFraction), [0.1, 0.3]) // sorted, day1 skipped
        XCTAssertTrue(s[0].date < s[1].date)
    }

    func testOverallSeriesSorted() {
        let history = [snap(5, overallMastery: 0.5), snap(1, overallMastery: 0.1)]
        let s = ProgressHistory.overallSeries(history)
        XCTAssertEqual(s.map(\.masteryFraction), [0.1, 0.5])
    }

    func testWeekOverWeekPicksRoughlySevenDaysAgo() {
        let history = [
            snap(0, overallMastery: 0.10),
            snap(7, overallMastery: 0.25),  // exactly the 7-days-ago target vs day14
            snap(10, overallMastery: 0.30),
            snap(14, overallMastery: 0.40), // latest
        ]
        let cal = Calendar(identifier: .gregorian)
        let wow = ProgressHistory.weekOverWeek(history, now: day(14), calendar: cal)
        XCTAssertNotNil(wow)
        // latest (day14, 0.40) vs the newest snapshot on/before day7 → day7 (0.25).
        XCTAssertEqual(wow?.overallMasteryDelta ?? -99, 0.15, accuracy: 1e-9)
        XCTAssertEqual(wow?.fromDate, day(7))
        XCTAssertEqual(wow?.toDate, day(14))
    }

    func testWeekOverWeekNilWithoutPriorPoint() {
        XCTAssertNil(ProgressHistory.weekOverWeek([], now: day(0)))
        // One day only → no prior.
        XCTAssertNil(ProgressHistory.weekOverWeek([snap(0, overallMastery: 0.2)], now: day(0)))
        // Two days but the older one is < 7 days back → no point at/before target.
        let recent = [snap(0, overallMastery: 0.2), snap(3, overallMastery: 0.4)]
        XCTAssertNil(ProgressHistory.weekOverWeek(recent, now: day(3),
                                                  calendar: Calendar(identifier: .gregorian)))
    }
}

@MainActor
final class ProgressHistoryCaptureTests: XCTestCase {

    private func loadedRegistry() async throws -> SubjectRegistry {
        let registry = SubjectRegistry()
        for _ in 0..<50 {
            if !registry.isLoading && !registry.packs.isEmpty { break }
            try? await Task.sleep(nanoseconds: 50_000_000)
        }
        guard !registry.packs.isEmpty else { throw XCTSkip("No packs loaded in 2.5 s.") }
        return registry
    }

    private func tempStore() -> DataStore {
        let dir = FileManager.default.temporaryDirectory
            .appendingPathComponent("ph-\(UUID().uuidString)")
        return DataStore(streakCalendar: nil, storeDir: dir, autoLoad: false)
    }

    private func srsSignature(_ reviews: [String: QuestionReview]) -> [String: String] {
        reviews.mapValues {
            "\($0.totalReviews)|\($0.lapses)|\($0.bucket)|\($0.ease)|\($0.intervalDays)|\($0.nextDueAt.timeIntervalSince1970)"
        }
    }

    /// Seed a handful of reviews so the captured snapshot has real signal.
    private func seed(_ store: DataStore, registry: SubjectRegistry, at when: Date) {
        var reviews: [String: QuestionReview] = [:]
        for pid in ["science_class7", "maths_class7"] {
            guard let pack = registry.pack(withId: pid) else { continue }
            var taken = 0
            outer: for chapter in pack.chapters {
                for topic in chapter.topics {
                    for q in topic.questions {
                        reviews[q.id] = QuestionReview(
                            questionId: q.id, bucket: 3, ease: 2.3, intervalDays: 3,
                            lastReviewedAt: when, nextDueAt: when.addingTimeInterval(3 * 86_400),
                            totalReviews: 4, lapses: 0, packId: pid)
                        taken += 1
                        if taken >= 6 { break outer }
                    }
                }
            }
        }
        store.questionReviews = reviews
    }

    func testCaptureIsIdempotentPerCalendarDay() async throws {
        let registry = try await loadedRegistry()
        let store = tempStore()
        let cal = Calendar(identifier: .gregorian)
        let noon = cal.startOfDay(for: Date()).addingTimeInterval(12 * 3600)
        seed(store, registry: registry, at: noon.addingTimeInterval(-3600))

        let first = try XCTUnwrap(store.captureProgressSnapshot(registry: registry, now: noon, calendar: cal))
        XCTAssertEqual(store.progressHistory.count, 1)

        // Add more reviews, capture again the SAME calendar day (a few hours later).
        seed(store, registry: registry, at: noon)
        let again = try XCTUnwrap(store.captureProgressSnapshot(
            registry: registry, now: noon.addingTimeInterval(4 * 3600), calendar: cal))

        // Still one row for the day — overwrite, never append.
        XCTAssertEqual(store.progressHistory.count, 1)
        XCTAssertEqual(first.date, again.date)
        // The row reflects the latest capture (same key, refreshed value).
        XCTAssertEqual(store.progressHistory[first.date]?.subjects.count, again.subjects.count)
    }

    func testCaptureAppendsDistinctDaysAndCapsToWindow() async throws {
        let registry = try await loadedRegistry()
        let store = tempStore()
        let cal = Calendar(identifier: .gregorian)
        seed(store, registry: registry, at: Date().addingTimeInterval(-86_400))

        let base = cal.startOfDay(for: Date())
        let cap = DataStore.maxProgressHistoryDays
        // Capture cap + 5 distinct days going back in time.
        for offset in 0..<(cap + 5) {
            guard let d = cal.date(byAdding: .day, value: -offset, to: base) else { continue }
            store.captureProgressSnapshot(registry: registry,
                                          now: d.addingTimeInterval(3600), calendar: cal)
        }
        XCTAssertEqual(store.progressHistory.count, cap, "Rolling cap should hold at \(cap).")
        // The 5 oldest days must have been dropped; newest day must survive.
        XCTAssertNotNil(store.progressHistory[base])
        if let oldest = cal.date(byAdding: .day, value: -(cap + 4), to: base) {
            XCTAssertNil(store.progressHistory[oldest])
        }
    }

    func testCapturePersistsAndRehydrates() async throws {
        let registry = try await loadedRegistry()
        let dir = FileManager.default.temporaryDirectory
            .appendingPathComponent("ph-persist-\(UUID().uuidString)")
        let store = DataStore(streakCalendar: nil, storeDir: dir, autoLoad: false)
        let cal = Calendar(identifier: .gregorian)
        seed(store, registry: registry, at: Date().addingTimeInterval(-3600))

        store.captureProgressSnapshot(registry: registry, now: Date(), calendar: cal)
        // Drain the coalesced write synchronously (the atomic write runs on a
        // background queue; `flushSavesBeforeQuit` dispatches + blocks until it
        // lands, unlike `flushPendingSave` which returns before the write).
        store.flushSavesBeforeQuit()

        let file = dir.appendingPathComponent("progress_history.json")
        XCTAssertTrue(FileManager.default.fileExists(atPath: file.path),
                      "Capture must persist progress_history.json.")

        // A fresh store over the same dir rehydrates the same single day.
        let reborn = DataStore(streakCalendar: nil, storeDir: dir, autoLoad: false)
        reborn.hydrateProgressHistoryIfNeeded()
        XCTAssertEqual(reborn.progressHistory.count, store.progressHistory.count)
        XCTAssertEqual(reborn.progressHistory.keys.first, store.progressHistory.keys.first)
    }

    func testCaptureIsReadOnlyOverSRS() async throws {
        let registry = try await loadedRegistry()
        let store = tempStore()
        seed(store, registry: registry, at: Date().addingTimeInterval(-3600))
        try XCTSkipUnless(store.questionReviews.count >= 4, "Need seeded reviews.")
        let before = srsSignature(store.questionReviews)

        store.captureProgressSnapshot(registry: registry, now: Date())
        _ = store.progressWeekOverWeek()
        _ = store.overallProgressSeries()

        XCTAssertEqual(srsSignature(store.questionReviews), before,
            "Capturing / reading progress history must never mutate the SRS.")
    }
}
