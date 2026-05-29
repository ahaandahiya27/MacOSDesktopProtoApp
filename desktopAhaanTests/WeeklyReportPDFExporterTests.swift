import XCTest
@testable import desktopAhaan

/// Pins the shape of the file `WeeklyReportPDFExporter.export(_:to:)`
/// writes (Parent Dashboard, 2026-05-29): a real, single-page, small
/// PDF starting with the `%PDF-` magic bytes. Drives the exporter
/// directly (it's `static`) — no UI / NSSavePanel.
final class WeeklyReportPDFExporterTests: XCTestCase {

    private var tmp: URL!

    private var cal: Calendar = {
        var c = Calendar(identifier: .gregorian)
        c.timeZone = TimeZone(identifier: "UTC")!
        return c
    }()

    override func setUpWithError() throws {
        try super.setUpWithError()
        tmp = URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent("desktopAhaan-pdf-\(UUID().uuidString)")
        try FileManager.default.createDirectory(at: tmp, withIntermediateDirectories: true)
    }

    override func tearDownWithError() throws {
        try? FileManager.default.removeItem(at: tmp)
        tmp = nil
        try super.tearDownWithError()
    }

    /// Build a small but non-trivial activity value.
    private func sampleActivity() -> WeeklyActivity {
        var comps = DateComponents()
        comps.year = 2026; comps.month = 5; comps.day = 29; comps.hour = 12
        let endStart = cal.startOfDay(for: cal.date(from: comps)!)
        var days: [DayActivity] = []
        for offset in stride(from: 6, through: 0, by: -1) {
            let date = cal.date(byAdding: .day, value: -offset, to: endStart)!
            let perSubject: [String: SubjectActivity]
            if offset % 2 == 0 {
                perSubject = [
                    "science_class7": SubjectActivity(
                        packId: "science_class7", reviews: 4, conceptsVisited: 2,
                        discoverScenesCompleted: 1, topChapter: "ch04"),
                    "maths_class7": SubjectActivity(
                        packId: "maths_class7", reviews: 2, conceptsVisited: 0,
                        discoverScenesCompleted: 0, topChapter: nil)
                ]
            } else {
                perSubject = [:]
            }
            let minutes = perSubject.values.reduce(0) {
                $0 + Int((Double($1.reviews) * 0.5 + Double($1.conceptsVisited) * 2 + Double($1.discoverScenesCompleted) * 3).rounded())
            }
            days.append(DayActivity(date: date, perSubject: perSubject,
                                    totalMinutesEstimate: minutes))
        }
        return WeeklyActivity(
            weekStart: days.first!.date, days: days,
            totalReviews: 16, totalConcepts: 8, totalDiscoverScenes: 4,
            masteryDelta: MasteryDelta(newFamiliar: 3, newConfident: 2, newMastered: 1),
            streakDays: 4, streakBest: 9)
    }

    func testExportWritesValidPDFFile() throws {
        let url = tmp.appendingPathComponent("report.pdf")
        try WeeklyReportPDFExporter.export(sampleActivity(), to: url, calendar: cal)

        XCTAssertTrue(FileManager.default.fileExists(atPath: url.path))
        let data = try Data(contentsOf: url)
        XCTAssertGreaterThan(data.count, 0, "PDF must be non-empty.")
        // %PDF- magic bytes.
        let magic = Array(data.prefix(5))
        XCTAssertEqual(magic, Array("%PDF-".utf8), "File must start with the %PDF- magic.")
    }

    func testExportedPDFIsSmall() throws {
        let url = tmp.appendingPathComponent("report.pdf")
        try WeeklyReportPDFExporter.export(sampleActivity(), to: url, calendar: cal)
        let size = try Data(contentsOf: url).count
        XCTAssertLessThanOrEqual(size, 100 * 1024,
            "A single-page text PDF should be well under 100 KB (got \(size) bytes).")
    }

    func testExportHandlesEmptyActivity() throws {
        // An all-empty week must still produce a valid one-page PDF.
        var days: [DayActivity] = []
        let endStart = cal.startOfDay(for: Date())
        for offset in stride(from: 6, through: 0, by: -1) {
            let date = cal.date(byAdding: .day, value: -offset, to: endStart)!
            days.append(DayActivity(date: date, perSubject: [:], totalMinutesEstimate: 0))
        }
        let empty = WeeklyActivity(
            weekStart: days.first!.date, days: days,
            totalReviews: 0, totalConcepts: 0, totalDiscoverScenes: 0,
            masteryDelta: .zero, streakDays: 0, streakBest: 0)
        let url = tmp.appendingPathComponent("empty.pdf")
        try WeeklyReportPDFExporter.export(empty, to: url, calendar: cal)
        let data = try Data(contentsOf: url)
        XCTAssertEqual(Array(data.prefix(5)), Array("%PDF-".utf8))
    }

    func testWeekStartStampFormat() {
        let activity = sampleActivity()
        let stamp = WeeklyReportPDFExporter.weekStartStamp(activity, calendar: cal)
        // yyyy-MM-dd.
        XCTAssertEqual(stamp.count, 10)
        XCTAssertEqual(stamp.filter { $0 == "-" }.count, 2)
    }
}
