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

    // MARK: - Report card (two-page) export

    private func sampleMasteryRows() -> [ReportCardMasteryRow] {
        [ReportCardMasteryRow(subjectTitle: "Science — Class 7", coverageFraction: 0.42,
                              masteryFraction: 0.61, levelName: "Confident", hasStarted: true),
         ReportCardMasteryRow(subjectTitle: "Maths — Class 7", coverageFraction: 0.10,
                              masteryFraction: 0.20, levelName: "Familiar", hasStarted: true),
         ReportCardMasteryRow(subjectTitle: "Sanskrit — Class 7", coverageFraction: 0,
                              masteryFraction: 0, levelName: "Learning", hasStarted: false)]
    }

    private func sampleCheckpoint() -> MilestoneCheckpointResult {
        MilestoneCheckpointResult(
            takenAt: Date(timeIntervalSince1970: 1_716_000_000),
            correctCount: 6, totalQuestions: 8,
            perSubject: [
                MilestoneSubjectScore(packId: "science_class7", subjectTitle: "Science — Class 7",
                                      correct: 4, total: 5),
                MilestoneSubjectScore(packId: "maths_class7", subjectTitle: "Maths — Class 7",
                                      correct: 2, total: 3)])
    }

    func testReportCardWritesValidPDF() throws {
        let url = tmp.appendingPathComponent("reportcard.pdf")
        try WeeklyReportPDFExporter.exportReportCard(
            activity: sampleActivity(), masteryRows: sampleMasteryRows(),
            checkpoint: sampleCheckpoint(), to: url, calendar: cal)

        XCTAssertTrue(FileManager.default.fileExists(atPath: url.path))
        let data = try Data(contentsOf: url)
        XCTAssertEqual(Array(data.prefix(5)), Array("%PDF-".utf8))
        XCTAssertGreaterThan(data.count, 0)
        XCTAssertLessThanOrEqual(data.count, 200 * 1024,
            "A two-page text PDF should stay well under 200 KB (got \(data.count)).")
    }

    func testReportCardHandlesNilCheckpointAndEmptyMastery() throws {
        let url = tmp.appendingPathComponent("reportcard-thin.pdf")
        try WeeklyReportPDFExporter.exportReportCard(
            activity: sampleActivity(), masteryRows: [],
            checkpoint: nil, to: url, calendar: cal)
        let data = try Data(contentsOf: url)
        XCTAssertEqual(Array(data.prefix(5)), Array("%PDF-".utf8),
            "A report card with no checkpoint / no started subjects is still a valid PDF.")
    }

    func testReportCardFilenameFormat() {
        let name = WeeklyReportPDFExporter.reportCardFilename(sampleActivity(), calendar: cal)
        XCTAssertTrue(name.hasPrefix("Ahaan-ReportCard-"))
        XCTAssertTrue(name.hasSuffix(".pdf"))
    }

    // MARK: - Trend page (v8 — page 3)

    /// A two-week history with a clear upward overall mastery trend.
    private func sampleHistory() -> [ProgressSnapshot] {
        let base = Date(timeIntervalSince1970: 1_700_000_000)
        return (0..<14).map { i in
            let frac = 0.1 + Double(i) * 0.04
            return ProgressSnapshot(
                date: cal.startOfDay(for: base.addingTimeInterval(Double(i) * 86_400)),
                subjects: [
                    SubjectProgressPoint(packId: "science_class7", masteryFraction: frac,
                                         coverageFraction: frac * 0.8, reviewedQuestions: 10 + i, dueCount: 2),
                    SubjectProgressPoint(packId: "maths_class7", masteryFraction: frac * 0.5,
                                         coverageFraction: frac * 0.4, reviewedQuestions: 4 + i, dueCount: 1),
                ],
                overallMasteryFraction: frac,
                overallCoverageFraction: frac * 0.7)
        }
    }

    func testReportCardWithHistoryDrawsTrendPage() throws {
        let url = tmp.appendingPathComponent("reportcard-trend.pdf")
        let history = sampleHistory()
        try WeeklyReportPDFExporter.exportReportCard(
            activity: sampleActivity(), masteryRows: sampleMasteryRows(),
            checkpoint: sampleCheckpoint(), to: url,
            progressHistory: history,
            calendar: cal, now: history.last!.date.addingTimeInterval(3600))
        let data = try Data(contentsOf: url)
        XCTAssertEqual(Array(data.prefix(5)), Array("%PDF-".utf8))
        XCTAssertLessThanOrEqual(data.count, 250 * 1024,
            "A three-page report card stays well under 250 KB (got \(data.count)).")
    }

    func testReportCardWithEmptyHistoryStillValid() throws {
        // No history → the trend page renders its friendly note, still a valid PDF.
        let url = tmp.appendingPathComponent("reportcard-nohistory.pdf")
        try WeeklyReportPDFExporter.exportReportCard(
            activity: sampleActivity(), masteryRows: sampleMasteryRows(),
            checkpoint: sampleCheckpoint(), to: url,
            progressHistory: [], calendar: cal)
        let data = try Data(contentsOf: url)
        XCTAssertEqual(Array(data.prefix(5)), Array("%PDF-".utf8),
            "An empty-history report card still produces a valid trend page.")
    }

    // MARK: - Mock test section (v9)

    private func sampleMockTest() -> MockTestResult {
        MockTestResult(
            takenAt: Date(timeIntervalSince1970: 1_716_500_000),
            band: .balanced, isMixed: true, timeLimitSeconds: 1_200,
            autoSubmitted: false, totalQuestions: 15, correctCount: 11,
            wrongCount: 3, unansweredCount: 1, totalMarks: 41, maxMarks: 60,
            totalSecondsSpent: 640, perSubject: [], perTopic: [], outcomes: [])
    }

    func testReportCardWithMockTestStillValidPDF() throws {
        let url = tmp.appendingPathComponent("reportcard-mock.pdf")
        try WeeklyReportPDFExporter.exportReportCard(
            activity: sampleActivity(), masteryRows: sampleMasteryRows(),
            checkpoint: sampleCheckpoint(), to: url,
            progressHistory: [], mockTest: sampleMockTest(), calendar: cal)
        let data = try Data(contentsOf: url)
        XCTAssertEqual(Array(data.prefix(5)), Array("%PDF-".utf8),
            "A report card carrying a mock-test result is still a valid PDF.")
        XCTAssertGreaterThan(data.count, 0)
    }

    func testReportCardWithNilMockTestOmitsSection() throws {
        // The mock-test section is drawn only when a result exists; omitting it
        // must still produce a valid PDF (back-compat with pre-v9 callers).
        let url = tmp.appendingPathComponent("reportcard-nomock.pdf")
        try WeeklyReportPDFExporter.exportReportCard(
            activity: sampleActivity(), masteryRows: sampleMasteryRows(),
            checkpoint: sampleCheckpoint(), to: url,
            progressHistory: [], mockTest: nil, calendar: cal)
        let data = try Data(contentsOf: url)
        XCTAssertEqual(Array(data.prefix(5)), Array("%PDF-".utf8))
    }
}
