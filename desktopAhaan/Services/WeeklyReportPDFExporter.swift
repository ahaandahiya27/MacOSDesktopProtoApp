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
        let pdfData = NSMutableData()
        guard let consumer = CGDataConsumer(data: pdfData as CFMutableData) else {
            throw ExportError.contextCreationFailed
        }
        var mediaBox = CGRect(origin: .zero, size: pageSize)
        guard let ctx = CGContext(consumer: consumer, mediaBox: &mediaBox, nil) else {
            throw ExportError.contextCreationFailed
        }

        ctx.beginPDFPage(nil)
        let nsContext = NSGraphicsContext(cgContext: ctx, flipped: true)
        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.current = nsContext
        // flipped: true → origin top-left, y grows downward, so the
        // top-down `cursorY` layout below reads naturally.
        draw(activity, calendar: calendar, now: now)
        NSGraphicsContext.restoreGraphicsState()
        ctx.endPDFPage()
        ctx.closePDF()

        try (pdfData as Data).write(to: url, options: .atomic)
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
        case "science_class7":  return "Sci"
        case "maths_class7":    return "Maths"
        case "sanskrit_class7": return "Skt"
        default:                return packId
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
            return parts.dropLast().joined(separator: ", ") + ", and " + parts.last!
        }
    }
}
