import XCTest
import SwiftUI
import AppKit
@testable import desktopAhaan

/// Render smoke tests for the Daily Plan UI. SwiftUI bodies aren't
/// introspectable in XCTest, so these render through an `NSHostingView` and
/// force layout to catch any crash in `body` / `onAppear`. Notifications
/// no-op under XCTest (see `DailyPlanNotifications.isTestRun`), so onAppear
/// is side-effect-free here.
@MainActor
final class DailyPlanViewTests: XCTestCase {

    private var tmp: URL!
    private var store: DataStore!
    private var registry: SubjectRegistry!
    private var appState: AppState!

    override func setUp() async throws {
        try await super.setUp()
        tmp = URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent("desktopAhaan-dpview-\(UUID().uuidString)")
        try FileManager.default.createDirectory(at: tmp, withIntermediateDirectories: true)
        store = DataStore(streakCalendar: nil, storeDir: tmp, autoLoad: false)
        registry = SubjectRegistry()
        appState = AppState()
    }

    override func tearDown() async throws {
        try? FileManager.default.removeItem(at: tmp)
        store = nil; registry = nil; appState = nil; tmp = nil
        try await super.tearDown()
    }

    private func render<V: View>(_ view: V, height: CGFloat = 600) {
        let host = NSHostingView(rootView: view)
        host.frame = NSRect(x: 0, y: 0, width: 560, height: height)
        host.layoutSubtreeIfNeeded()
        XCTAssertGreaterThanOrEqual(host.fittingSize.height, 0)
    }

    func testDailyPlanViewRendersEmpty() {
        render(DailyPlanView()
            .environmentObject(store!)
            .environmentObject(registry!)
            .environmentObject(appState!))
    }

    func testDailyPlanViewRendersWithDueReviews() {
        let past = Date(timeIntervalSince1970: 1_700_000_000)
        for i in 1...4 {
            let id = String(format: "ch01_t01_q%02d", i)
            store.questionReviews[id] = QuestionReview(
                questionId: id, bucket: 1, ease: 2.5, intervalDays: 1,
                lastReviewedAt: past, nextDueAt: past, totalReviews: 1, lapses: 0)
        }
        render(DailyPlanView()
            .environmentObject(store!)
            .environmentObject(registry!)
            .environmentObject(appState!))
    }

    func testDailyPlanViewRendersInWholeJourneyMode() {
        // Persist Whole Journey, render the picker + plan body, then restore.
        let d = UserDefaults.standard
        let saved = d.object(forKey: JourneyPlannerStorage.modeKey)
        defer {
            if let v = saved { d.set(v, forKey: JourneyPlannerStorage.modeKey) }
            else { d.removeObject(forKey: JourneyPlannerStorage.modeKey) }
        }
        JourneyPlannerStorage.setMode(.wholeJourney)
        XCTAssertEqual(JourneyPlannerStorage.currentMode(), .wholeJourney)

        let past = Date(timeIntervalSince1970: 1_700_000_000)
        for i in 1...4 {
            let id = String(format: "ch01_t01_q%02d", i)
            store.questionReviews[id] = QuestionReview(
                questionId: id, bucket: 1, ease: 2.5, intervalDays: 1,
                lastReviewedAt: past, nextDueAt: past, totalReviews: 1, lapses: 0,
                packId: "science_class7")
        }
        render(DailyPlanView()
            .environmentObject(store!)
            .environmentObject(registry!)
            .environmentObject(appState!))
    }

    func testDailyPlanRowRendersAllStates() {
        let base = DailyPlanItem(kind: .review, packId: "science_class7",
                                 targetId: "ch01_t01_q01",
                                 title: "What is photosynthesis?",
                                 subtitle: "Science · Nutrition in Plants")
        // Actionable, done, skipped — three visual paths.
        render(DailyPlanRow(item: base, onOpen: {}, onDone: {}, onSkip: {}), height: 90)

        var done = base; done.isDone = true
        render(DailyPlanRow(item: done, onOpen: {}, onDone: {}, onSkip: {}), height: 90)

        var skipped = base; skipped.isSkipped = true
        render(DailyPlanRow(item: skipped, onOpen: {}, onDone: {}, onSkip: {}), height: 90)
    }
}
