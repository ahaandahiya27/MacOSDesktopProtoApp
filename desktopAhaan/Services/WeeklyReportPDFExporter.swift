import Foundation
import AppKit
import CoreGraphics

// MARK: - Weekly report PDF export
//
// Renders a single US-Letter page summarising a `WeeklyActivity` that a
// parent can read on their phone. Pure Core Graphics (CGContext +
// CGDataConsumer, macOS 10.0+) — no PDFKit, no macOS 12+ APIs — so it
// builds and runs on the Big Sur deploy iMac. Text is drawn with
// `NSAttributedString.draw` against an `NSGraphicsContext` wrapping the
// PDF `CGContext`.
//
// `export(_:to:)` is `static` so tests can drive it without any UI. All
// writes are `.atomic`.

final class WeeklyReportPDFExporter {

    enum ExportError: LocalizedError {
        case contextCreationFailed
        var errorDescription: String? {
            switch self {
            case .contextCreationFailed:
                return "Could not create the PDF drawing context."
            }
        }
    }

    /// US Letter portrait at 72 dpi.
    private static let pageSize = CGSize(width: 612, height: 792)
    private static let margin: CGFloat = 54

    /// Render `activity` to a single-page PDF at `url`.
    static func export(
        _ activity: WeeklyActivity,
        to url: URL,
        calendar: Calendar = .current,
        now: Date = Date()
    ) throws {
        try withPDFContext(to: url) { ctx in
            drawPage(ctx) { draw(activity, calendar: calendar, now: now) }
        }
    }

    /// Render a three-page **parent report card** at `url`: page 1 is the weekly
    /// summary (identical to `export`), page 2 adds the cross-subject mastery
    /// picture (coverage + mastery per subject) and the latest milestone
    /// checkpoint score, page 3 adds the longitudinal mastery trend (a Core
    /// Graphics sparkline of the overall series + the week-over-week delta).
    /// `masteryRows`, `checkpoint` and `progressHistory` are plain values the
    /// caller builds from `MasteryEngine.snapshot` + `DataStore`, so the
    /// exporter stays UI-free and testable. `progressHistory` defaults to empty
    /// so older callers/tests still produce a valid (note-only) trend page.
    static func exportReportCard(
        activity: WeeklyActivity,
        masteryRows: [ReportCardMasteryRow],
        checkpoint: MilestoneCheckpointResult?,
        to url: URL,
        progressHistory: [ProgressSnapshot] = [],
        calendar: Calendar = .current,
        now: Date = Date()
    ) throws {
        try withPDFContext(to: url) { ctx in
            drawPage(ctx) { draw(activity, calendar: calendar, now: now) }
            drawPage(ctx) {
                drawReportCardPage(masteryRows: masteryRows, checkpoint: checkpoint,
                                   calendar: calendar, now: now)
            }
            drawPage(ctx) {
                drawTrendPage(history: progressHistory, calendar: calendar, now: now)
            }
        }
    }

    /// Filename-safe report-card name, e.g. `Ahaan-ReportCard-2026-05-24.pdf`.
    static func reportCardFilename(_ activity: WeeklyActivity,
                                   calendar: Calendar = .current) -> String {
        "Ahaan-ReportCard-\(weekStartStamp(activity, calendar: calendar)).pdf"
    }

    // MARK: - PDF context plumbing

    /// Create a US-Letter PDF context backed by an in-memory buffer, run
    /// `body` (which draws one or more pages via `drawPage`), then close and
    /// atomically write the result to `url`.
    private static func withPDFContext(to url: URL, _ body: (CGContext) -> Void) throws {
        let pdfData = NSMutableData()
        guard let consumer = CGDataConsumer(data: pdfData as CFMutableData) else {
            throw ExportError.contextCreationFailed
        }
        var mediaBox = CGRect(origin: .zero, size: pageSize)
        guard let ctx = CGContext(consumer: consumer, mediaBox: &mediaBox, nil) else {
            throw ExportError.contextCreationFailed
        }
        body(ctx)
        ctx.closePDF()
        try (pdfData as Data).write(to: url, options: .atomic)
    }

    /// Begin a page, install a flipped `NSGraphicsContext` (origin top-left, y
    /// grows downward so the top-down `cursorY` layout reads naturally), run
    /// `draw`, then restore + end the page.
    private static func drawPage(_ ctx: CGContext, _ draw: () -> Void) {
        ctx.beginPDFPage(nil)
        let nsContext = NSGraphicsContext(cgContext: ctx, flipped: true)
        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.current = nsContext
        draw()
        NSGraphicsContext.restoreGraphicsState()
        ctx.endPDFPage()
    }

    /// Filename-safe "week of" stamp, e.g. `2026-05-24`.
    static func weekStartStamp(_ activity: WeeklyActivity,
                               calendar: Calendar = .current) -> String {
        let fmt = DateFormatter()
        fmt.calendar = calendar
        fmt.locale = Locale(identifier: "en_US_POSIX")
        fmt.dateFormat = "yyyy-MM-dd"
        return fmt.string(from: activity.weekStart)
    }

    // MARK: - Drawing

    private static func draw(_ activity: WeeklyActivity,
                             calendar: Calendar, now: Date) {
        let contentWidth = pageSize.width - margin * 2
        var cursorY = margin

        // Title.
        cursorY = drawText("Ahaan — Weekly Progress",
                           at: CGPoint(x: margin, y: cursorY),
                           width: contentWidth,
                           font: .systemFont(ofSize: 26, weight: .bold),
                           color: NSColor(calibratedRed: 0.18, green: 0.18, blue: 0.45, alpha: 1))
        cursorY += 2

        // Week range subtitle.
        let rangeFmt = DateFormatter()
        rangeFmt.calendar = calendar
        rangeFmt.locale = Locale(identifier: "en_US_POSIX")
        rangeFmt.dateFormat = "MMMM d"
        let weekEnd = activity.days.last?.date ?? activity.weekStart
        let subtitle = "Week of \(rangeFmt.string(from: activity.weekStart)) – \(rangeFmt.string(from: weekEnd))"
        cursorY = drawText(subtitle,
                           at: CGPoint(x: margin, y: cursorY),
                           width: contentWidth,
                           font: .systemFont(ofSize: 13, weight: .regular),
                           color: NSColor.darkGray)
        cursorY += 16

        // Streak + summary line. (Built in pieces — long `+`/interpolation
        // chains trip Swift 5.5's type-check-time budget on Big Sur.)
        var streakLine = "Current streak: \(activity.streakDays) day\(plural(activity.streakDays))"
        if activity.streakBest > activity.streakDays {
            streakLine += "   ·   Best ever: \(activity.streakBest)"
        }
        cursorY = drawText(streakLine,
                           at: CGPoint(x: margin, y: cursorY),
                           width: contentWidth,
                           font: .systemFont(ofSize: 14, weight: .semibold),
                           color: NSColor.black)
        cursorY += 6

        let summaryParts: [String] = [
            "\(activity.totalReviews) review\(plural(activity.totalReviews))",
            "\(activity.totalConcepts) concept\(plural(activity.totalConcepts))",
            "\(activity.totalDiscoverScenes) discover scene\(plural(activity.totalDiscoverScenes))",
            "~\(activity.totalMinutesEstimate) min (estimate)"
        ]
        let summary = "This week: " + summaryParts.joined(separator: "   ·   ")
        cursorY = drawText(summary,
                           at: CGPoint(x: margin, y: cursorY),
                           width: contentWidth,
                           font: .systemFont(ofSize: 12, weight: .regular),
                           color: NSColor.darkGray)
        cursorY += 18

        // Day-by-day section header.
        cursorY = drawText("Day by day",
                           at: CGPoint(x: margin, y: cursorY),
                           width: contentWidth,
                           font: .systemFont(ofSize: 15, weight: .bold),
                           color: NSColor.black)
        cursorY += 6

        let dayFmt = DateFormatter()
        dayFmt.calendar = calendar
        dayFmt.locale = Locale(identifier: "en_US_POSIX")
        dayFmt.dateFormat = "EEE MMM d"

        for day in activity.days {
            let label = dayFmt.string(from: day.date)
            let detail: String
            if day.isEmpty {
                detail = "— no activity"
            } else {
                detail = subjectSummary(for: day) + "   (~\(day.totalMinutesEstimate) min)"
            }
            cursorY = drawRow(label: label, detail: detail,
                              at: cursorY, width: contentWidth)
            cursorY += 4
        }

        cursorY += 14

        // Mastery delta.
        cursorY = drawText("Mastery this week",
                           at: CGPoint(x: margin, y: cursorY),
                           width: contentWidth,
                           font: .systemFont(ofSize: 15, weight: .bold),
                           color: NSColor.black)
        cursorY += 6
        cursorY = drawText(masteryLine(activity.masteryDelta),
                           at: CGPoint(x: margin, y: cursorY),
                           width: contentWidth,
                           font: .systemFont(ofSize: 12.5, weight: .regular),
                           color: NSColor(calibratedRed: 0.10, green: 0.52, blue: 0.18, alpha: 1))

        // Footer pinned near the page bottom.
        let footerFmt = DateFormatter()
        footerFmt.calendar = calendar
        footerFmt.locale = Locale(identifier: "en_US_POSIX")
        footerFmt.dateFormat = "yyyy-MM-dd HH:mm"
        let footer = "Generated by desktopAhaan on \(footerFmt.string(from: now)). "
            + "Minute figures are rough estimates (0.5 min/review, 2 min/concept, 3 min/discover scene)."
        _ = drawText(footer,
                     at: CGPoint(x: margin, y: pageSize.height - margin - 24),
                     width: contentWidth,
                     font: .systemFont(ofSize: 9, weight: .regular),
                     color: NSColor.gray)
    }

    /// Page 2 — the cross-subject mastery picture + latest checkpoint.
    private static func drawReportCardPage(
        masteryRows: [ReportCardMasteryRow],
        checkpoint: MilestoneCheckpointResult?,
        calendar: Calendar, now: Date
    ) {
        let contentWidth = pageSize.width - margin * 2
        var cursorY = margin

        cursorY = drawText("Ahaan — Report Card",
                           at: CGPoint(x: margin, y: cursorY),
                           width: contentWidth,
                           font: .systemFont(ofSize: 26, weight: .bold),
                           color: NSColor(calibratedRed: 0.18, green: 0.18, blue: 0.45, alpha: 1))
        cursorY += 4
        cursorY = drawText("Where Ahaan is across the whole learning journey.",
                           at: CGPoint(x: margin, y: cursorY),
                           width: contentWidth,
                           font: .systemFont(ofSize: 13, weight: .regular),
                           color: NSColor.darkGray)
        cursorY += 18

        // Mastery by subject.
        cursorY = drawText("Mastery by subject",
                           at: CGPoint(x: margin, y: cursorY),
                           width: contentWidth,
                           font: .systemFont(ofSize: 15, weight: .bold),
                           color: NSColor.black)
        cursorY += 6
        if masteryRows.isEmpty {
            cursorY = drawRow(label: "—",
                              detail: "No subjects started yet.",
                              at: cursorY, width: contentWidth)
            cursorY += 4
        } else {
            for row in masteryRows {
                let detail: String
                if row.hasStarted {
                    detail = "Coverage \(pct(row.coverageFraction))   ·   "
                        + "Mastery \(pct(row.masteryFraction))   ·   \(row.levelName)"
                } else {
                    detail = "Not started yet"
                }
                cursorY = drawRow(label: row.subjectTitle, detail: detail,
                                  at: cursorY, width: contentWidth)
                cursorY += 4
            }
        }
        cursorY += 14

        // Latest checkpoint.
        cursorY = drawText("Latest checkpoint",
                           at: CGPoint(x: margin, y: cursorY),
                           width: contentWidth,
                           font: .systemFont(ofSize: 15, weight: .bold),
                           color: NSColor.black)
        cursorY += 6
        if let checkpoint = checkpoint, checkpoint.totalQuestions > 0 {
            let dateFmt = DateFormatter()
            dateFmt.calendar = calendar
            dateFmt.locale = Locale(identifier: "en_US_POSIX")
            dateFmt.dateFormat = "MMMM d, yyyy"
            let scoreLine = "Scored \(checkpoint.correctCount) of \(checkpoint.totalQuestions) "
                + "(\(pct(checkpoint.scoreFraction))) on \(dateFmt.string(from: checkpoint.takenAt))."
            cursorY = drawText(scoreLine,
                               at: CGPoint(x: margin, y: cursorY),
                               width: contentWidth,
                               font: .systemFont(ofSize: 13, weight: .semibold),
                               color: NSColor.black)
            cursorY += 6
            for sub in checkpoint.perSubject {
                cursorY = drawRow(label: sub.subjectTitle,
                                  detail: "\(sub.correct) of \(sub.total) correct",
                                  at: cursorY, width: contentWidth)
                cursorY += 4
            }
        } else {
            cursorY = drawText("No checkpoint taken yet — open Help → Milestone Checkpoint to try one.",
                               at: CGPoint(x: margin, y: cursorY),
                               width: contentWidth,
                               font: .systemFont(ofSize: 12.5, weight: .regular),
                               color: NSColor.darkGray)
        }

        // Footer.
        let footerFmt = DateFormatter()
        footerFmt.calendar = calendar
        footerFmt.locale = Locale(identifier: "en_US_POSIX")
        footerFmt.dateFormat = "yyyy-MM-dd HH:mm"
        _ = drawText("Coverage = how much of a subject has been attempted; Mastery = how well the attempted material is known. Generated \(footerFmt.string(from: now)).",
                     at: CGPoint(x: margin, y: pageSize.height - margin - 24),
                     width: contentWidth,
                     font: .systemFont(ofSize: 9, weight: .regular),
                     color: NSColor.gray)
    }

    /// Page 3 — the longitudinal mastery trend: a Core Graphics sparkline of the
    /// overall mastery series plus the week-over-week delta (overall + per
    /// subject). All Big-Sur-safe (NSBezierPath over the flipped context). Falls
    /// back to a friendly note when there aren't yet two days of history.
    private static func drawTrendPage(history: [ProgressSnapshot],
                                      calendar: Calendar, now: Date) {
        let contentWidth = pageSize.width - margin * 2
        var cursorY = margin

        cursorY = drawText("Ahaan — Progress Trend",
                           at: CGPoint(x: margin, y: cursorY),
                           width: contentWidth,
                           font: .systemFont(ofSize: 26, weight: .bold),
                           color: NSColor(calibratedRed: 0.18, green: 0.18, blue: 0.45, alpha: 1))
        cursorY += 4
        cursorY = drawText("How mastery has moved over time, and the change vs last week.",
                           at: CGPoint(x: margin, y: cursorY),
                           width: contentWidth,
                           font: .systemFont(ofSize: 13, weight: .regular),
                           color: NSColor.darkGray)
        cursorY += 18

        let overall = ProgressHistory.overallSeries(history)
        guard overall.count >= 2 else {
            _ = drawText("A trend line appears once there are at least two days of progress recorded. Keep practising — open this report again in a few days to see the curve.",
                         at: CGPoint(x: margin, y: cursorY),
                         width: contentWidth,
                         font: .systemFont(ofSize: 12.5, weight: .regular),
                         color: NSColor.darkGray)
            drawTrendFooter(calendar: calendar, now: now)
            return
        }

        // Overall mastery sparkline.
        cursorY = drawText("Overall mastery over time",
                           at: CGPoint(x: margin, y: cursorY),
                           width: contentWidth,
                           font: .systemFont(ofSize: 15, weight: .bold),
                           color: NSColor.black)
        cursorY += 8
        let chartRect = CGRect(x: margin, y: cursorY, width: contentWidth, height: 150)
        drawSparkline(overall.map { $0.masteryFraction }, in: chartRect)
        cursorY = chartRect.maxY + 6
        let rangeFmt = DateFormatter()
        rangeFmt.calendar = calendar
        rangeFmt.locale = Locale(identifier: "en_US_POSIX")
        rangeFmt.dateFormat = "MMM d"
        if let first = overall.first, let last = overall.last {
            let axis = "\(rangeFmt.string(from: first.date))   →   \(rangeFmt.string(from: last.date))   ·   y-axis 0–100% mastery"
            cursorY = drawText(axis,
                               at: CGPoint(x: margin, y: cursorY),
                               width: contentWidth,
                               font: .systemFont(ofSize: 10, weight: .regular),
                               color: NSColor.gray)
        }
        cursorY += 18

        // Week-over-week.
        cursorY = drawText("Compared with last week",
                           at: CGPoint(x: margin, y: cursorY),
                           width: contentWidth,
                           font: .systemFont(ofSize: 15, weight: .bold),
                           color: NSColor.black)
        cursorY += 6
        if let wow = ProgressHistory.weekOverWeek(history, now: now, calendar: calendar) {
            cursorY = drawText(signedPct("Overall mastery", wow.overallMasteryDelta),
                               at: CGPoint(x: margin, y: cursorY),
                               width: contentWidth,
                               font: .systemFont(ofSize: 13, weight: .semibold),
                               color: NSColor.black)
            cursorY += 6
            let subjectKeys = wow.perSubjectMasteryDelta.keys.sorted {
                shortLabel(for: $0) < shortLabel(for: $1)
            }
            for key in subjectKeys {
                let d = wow.perSubjectMasteryDelta[key] ?? 0
                cursorY = drawRow(label: shortLabel(for: key),
                                  detail: signedDeltaDetail(d),
                                  at: cursorY, width: contentWidth)
                cursorY += 4
            }
        } else {
            _ = drawText("Not enough history yet to compare with a week ago — this fills in once there's a snapshot from about seven days back.",
                         at: CGPoint(x: margin, y: cursorY),
                         width: contentWidth,
                         font: .systemFont(ofSize: 12.5, weight: .regular),
                         color: NSColor.darkGray)
        }

        drawTrendFooter(calendar: calendar, now: now)
    }

    private static func drawTrendFooter(calendar: Calendar, now: Date) {
        let footerFmt = DateFormatter()
        footerFmt.calendar = calendar
        footerFmt.locale = Locale(identifier: "en_US_POSIX")
        footerFmt.dateFormat = "yyyy-MM-dd HH:mm"
        _ = drawText("Trend is built from a once-a-day mastery snapshot kept on this Mac (up to 180 days). Generated \(footerFmt.string(from: now)).",
                     at: CGPoint(x: margin, y: pageSize.height - margin - 24),
                     width: pageSize.width - margin * 2,
                     font: .systemFont(ofSize: 9, weight: .regular),
                     color: NSColor.gray)
    }

    /// Draw a faint framed sparkline of `fractions` (each 0…1) into `rect`,
    /// using NSBezierPath over the current flipped NSGraphicsContext. y is
    /// flipped so a higher fraction sits nearer the top.
    private static func drawSparkline(_ fractions: [Double], in rect: CGRect) {
        // Frame.
        let frame = NSBezierPath(rect: rect)
        frame.lineWidth = 1
        NSColor(white: 0.78, alpha: 1).setStroke()
        frame.stroke()
        // Midline (50%).
        let mid = NSBezierPath()
        mid.move(to: NSPoint(x: rect.minX, y: rect.midY))
        mid.line(to: NSPoint(x: rect.maxX, y: rect.midY))
        mid.lineWidth = 0.5
        NSColor(white: 0.88, alpha: 1).setStroke()
        mid.stroke()

        guard fractions.count >= 2 else { return }
        let line = NSBezierPath()
        line.lineWidth = 2.4
        line.lineJoinStyle = .round
        line.lineCapStyle = .round
        let stepX = rect.width / CGFloat(fractions.count - 1)
        for (i, f) in fractions.enumerated() {
            let clamped = CGFloat(max(0, min(1, f)))
            let x = rect.minX + CGFloat(i) * stepX
            // Flipped context: top is rect.minY, so high fraction → small y.
            let y = rect.minY + (1 - clamped) * rect.height
            let pt = NSPoint(x: x, y: y)
            if i == 0 { line.move(to: pt) } else { line.line(to: pt) }
        }
        NSColor(calibratedRed: 0.10, green: 0.52, blue: 0.18, alpha: 1).setStroke()
        line.stroke()
    }

    /// "Overall mastery: +6% vs last week" — sign always shown.
    private static func signedPct(_ label: String, _ delta: Double) -> String {
        "\(label): \(signedDeltaDetail(delta)) vs last week"
    }

    /// "+6%" / "−3%" / "no change", from a signed 0…1 fraction delta.
    private static func signedDeltaDetail(_ delta: Double) -> String {
        let points = Int((delta * 100).rounded())
        if points > 0 { return "+\(points)%" }
        if points < 0 { return "−\(abs(points))%" }
        return "no change"
    }

    private static func pct(_ f: Double) -> String {
        "\(Int((max(0, min(1, f)) * 100).rounded()))%"
    }

    /// Draw a "label — detail" row with the label in a fixed-width gutter.
    private static func drawRow(label: String, detail: String,
                                at y: CGFloat, width: CGFloat) -> CGFloat {
        let gutter: CGFloat = 96
        _ = drawText(label,
                     at: CGPoint(x: margin, y: y),
                     width: gutter,
                     font: .systemFont(ofSize: 12, weight: .semibold),
                     color: NSColor.black)
        return drawText(detail,
                        at: CGPoint(x: margin + gutter, y: y),
                        width: width - gutter,
                        font: .systemFont(ofSize: 12, weight: .regular),
                        color: NSColor.darkGray)
    }

    /// Draw `text` in a box of `width` starting at `point` (top-left).
    /// Returns the y just below the drawn text.
    @discardableResult
    private static func drawText(_ text: String, at point: CGPoint,
                                 width: CGFloat, font: NSFont,
                                 color: NSColor) -> CGFloat {
        let para = NSMutableParagraphStyle()
        para.lineBreakMode = .byWordWrapping
        let attrs: [NSAttributedString.Key: Any] = [
            .font: font, .foregroundColor: color, .paragraphStyle: para
        ]
        let attributed = NSAttributedString(string: text, attributes: attrs)
        let bounds = attributed.boundingRect(
            with: CGSize(width: width, height: .greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading]
        )
        attributed.draw(with: CGRect(x: point.x, y: point.y, width: width, height: ceil(bounds.height)),
                        options: [.usesLineFragmentOrigin, .usesFontLeading])
        return point.y + ceil(bounds.height)
    }

    // MARK: - Text helpers

    private static func plural(_ n: Int) -> String { n == 1 ? "" : "s" }

    /// Per-subject one-liner for a day, e.g. "Sci 3 · Maths 2 · Skt 1".
    private static func subjectSummary(for day: DayActivity) -> String {
        // Stable order: science, maths, sanskrit, then any others.
        let order = ["science_class7", "maths_class7", "sanskrit_class7"]
        let sortedKeys = day.perSubject.keys.sorted { lhs, rhs in
            let li = order.firstIndex(of: lhs) ?? order.count
            let ri = order.firstIndex(of: rhs) ?? order.count
            return li != ri ? li < ri : lhs < rhs
        }
        return sortedKeys.compactMap { key -> String? in
            guard let activity = day.perSubject[key] else { return nil }
            let total = activity.total
            guard total > 0 else { return nil }
            return "\(shortLabel(for: key)) \(total)"
        }.joined(separator: " · ")
    }

    /// Compact subject label for the known pack ids; falls back to the
    /// raw id so an unattributed bucket is still visible (and honest).
    static func shortLabel(for packId: String) -> String {
        switch packId {
        case "science_class7":       return "Sci"
        case "maths_class7":         return "Maths"
        case "sanskrit_class7":      return "Skt"
        case "socialscience_class7": return "SocSci"
        default:                     return packId
        }
    }

    private static func masteryLine(_ delta: MasteryDelta) -> String {
        if delta.isEmpty {
            return "No new mastery milestones this week — every bit of practice still counts!"
        }
        var parts: [String] = []
        if delta.newMastered > 0 { parts.append("Mastered \(delta.newMastered)") }
        if delta.newConfident > 0 { parts.append("got Confident on \(delta.newConfident)") }
        if delta.newFamiliar > 0 { parts.append("became Familiar with \(delta.newFamiliar)") }
        return "This week, Ahaan " + joinClauses(parts) + "."
    }

    private static func joinClauses(_ parts: [String]) -> String {
        switch parts.count {
        case 0: return ""
        case 1: return parts[0]
        case 2: return parts[0] + " and " + parts[1]
        default:
            // `default` only fires when parts.count >= 3, so parts.last is
            // guaranteed non-nil; but a `??` keeps the code defensive against
            // future refactors that change the dispatch arms.
            let tail = parts.last ?? ""
            return parts.dropLast().joined(separator: ", ") + ", and " + tail
        }
    }
}
