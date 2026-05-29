import XCTest
import SwiftUI
import AppKit
@testable import desktopAhaan

/// Smoke tests for `WeeklyProgressView` (Parent Dashboard, 2026-05-29).
/// SwiftUI body internals aren't introspectable in XCTest, so these
/// render the view through an `NSHostingView` and force layout to catch
/// any crash in the body — on both empty and seeded data — plus pin the
/// pure label/short-name helpers the view and PDF export share.
@MainActor
final class WeeklyProgressViewTests: XCTestCase {

    private var tmp: URL!
    private var store: DataStore!
    private var registry: SubjectRegistry!

    private var cal: Calendar = {
        var c = Calendar(identifier: .gregorian)
        c.timeZone = TimeZone(identifier: "UTC")!
        return c
    }()

    override func setUp() async throws {
        try await super.setUp()
        tmp = URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent("desktopAhaan-weeklyview-\(UUID().uuidString)")
        try FileManager.default.createDirectory(at: tmp, withIntermediateDirectories: true)
        store = DataStore(streakCalendar: nil, storeDir: tmp, autoLoad: false)
        registry = SubjectRegistry()
    }

    override func tearDown() async throws {
        try? FileManager.default.removeItem(at: tmp)
        store = nil; registry = nil; tmp = nil
        try await super.tearDown()
    }

    /// Render the view into an off-screen hosting view and force a layout
    /// pass — exercises `body` + `onAppear`'s rollup call.
    private func renderSmoke() {
        let view = WeeklyProgressView()
            .environmentObject(store!)
            .environmentObject(registry!)
        let host = NSHostingView(rootView: view)
        host.frame = NSRect(x: 0, y: 0, width: 760, height: 780)
        host.layoutSubtreeIfNeeded()
        XCTAssertGreaterThan(host.fittingSize.height, 0,
            "Hosting view should lay out a non-empty body.")
    }

    func testRendersWithEmptyData() {
        renderSmoke()
    }

    func testRendersWithSeededData() {
        let endDate = Date()
        let when = cal.date(byAdding: .day, value: -1, to: endDate)!
        store.questionReviews["q1"] = QuestionReview(
            questionId: "q1", bucket: 3, ease: 2.5, intervalDays: 5,
            lastReviewedAt: when, nextDueAt: when, totalReviews: 3,
            lapses: 0, packId: "science_class7")
        store.recordConceptVisit(id: "c1", packId: "maths_class7", at: when)
        renderSmoke()
    }

    func testShortLabelMapping() {
        XCTAssertEqual(WeeklyReportPDFExporter.shortLabel(for: "science_class7"), "Sci")
        XCTAssertEqual(WeeklyReportPDFExporter.shortLabel(for: "maths_class7"), "Maths")
        XCTAssertEqual(WeeklyReportPDFExporter.shortLabel(for: "sanskrit_class7"), "Skt")
        // Unknown ids fall back to the raw id so an unattributed bucket
        // is still visible.
        XCTAssertEqual(WeeklyReportPDFExporter.shortLabel(for: "unattributed"), "unattributed")
    }
}
