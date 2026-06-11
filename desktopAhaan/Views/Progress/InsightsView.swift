import SwiftUI
import AppKit

// MARK: - InsightsView — the longitudinal "how is it trending?" surface (v8)
//
// v8 Longitudinal Insights · Phase 5. Ties the three new longitudinal pieces
// together in one window: the pure-SwiftUI trend chart (overall + a per-subject
// toggle), the week-over-week mastery delta, and each subject's latest standing.
// Opened via Help → Insights / ⌘⇧I (see `InsightsWindow.swift`).
//
// READ-ONLY over the SRS: it captures today's snapshot (which derives from
// `MasteryEngine` and writes only `progress_history.json`) and reads the history
// series — it never mutates `questionReviews`. Pinned by the v8 capstone in
// `LearningJourneyReadOnlyTests`.
//
// `@MainActor` because it reads `DataStore` (main-actor-isolated) synchronously
// in `onAppear` — same convention as `WeeklyProgressView`.
@MainActor
struct InsightsView: View {
    @EnvironmentObject var dataStore: DataStore
    @EnvironmentObject var registry: SubjectRegistry

    @State private var snapshots: [ProgressSnapshot] = []
    @State private var weekOverWeek: ProgressDelta?
    @State private var seriesOptions: [TrendSeries] = []

    /// Subject presentation order for the per-subject lines + standings.
    private static let subjectOrder = ["science_class7", "maths_class7",
                                       "sanskrit_class7", "socialscience_class7"]

    private static let rangeFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.dateFormat = "MMM d"
        return f
    }()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                header
                trendCard
                weekOverWeekCard
                standingsCard
            }
            .padding(20)
            .frame(maxWidth: 720, alignment: .leading)
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .background(Color(NSColor.windowBackgroundColor))
        .onAppear { reload() }
        .navigationTitle("Insights")
    }

    private func reload() {
        // Record today's snapshot (read-only over SRS), then read the series.
        dataStore.captureProgressSnapshot(registry: registry)
        let history = dataStore.progressHistorySorted()
        snapshots = history
        weekOverWeek = dataStore.progressWeekOverWeek()
        seriesOptions = buildSeriesOptions(history)
    }

    // MARK: - Header

    private var header: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
            HStack(spacing: 10) {
                Text("🔍").font(.system(size: 34)).accessibilityHidden(true)
                Text("Insights")
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
            }
            Text("How mastery is trending over time — and how this week compares with last.")
                .font(.subheadline)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Insights. How mastery is trending over time.")
    }

    // MARK: - Trend chart

    private var trendCard: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
            Text("Mastery over time")
                .font(.headline)
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            TrendChartView(seriesOptions: seriesOptions, subtitle: trendSubtitle)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(DesignTokens.BrandColor.canvasTextSecondary.opacity(0.06))
        )
    }

    private var trendSubtitle: String? {
        guard let first = snapshots.first, let last = snapshots.last,
              snapshots.count >= 2 else { return nil }
        return "\(Self.rangeFormatter.string(from: first.date)) – \(Self.rangeFormatter.string(from: last.date)) · \(snapshots.count) days"
    }

    // MARK: - Week-over-week

    @ViewBuilder
    private var weekOverWeekCard: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
            Text("Compared with last week")
                .font(.headline)
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            if let wow = weekOverWeek {
                HStack(spacing: 10) {
                    Text(deltaArrow(wow.overallMasteryDelta))
                        .font(.system(size: 24)).accessibilityHidden(true)
                    Text("Overall mastery \(signedPct(wow.overallMasteryDelta)) vs last week")
                        .font(.title3.weight(.semibold))
                        .foregroundColor(deltaColor(wow.overallMasteryDelta))
                }
            } else {
                Text("Your week-over-week trend appears once there's a snapshot from about a week ago. Keep practising — it builds automatically.")
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(DesignTokens.BrandColor.canvasTextSecondary.opacity(0.06))
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel(weekOverWeekLabel)
    }

    // MARK: - Per-subject standings (latest snapshot)

    @ViewBuilder
    private var standingsCard: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
            Text("Where each subject stands today")
                .font(.headline)
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            if let latest = snapshots.last, !latest.subjects.isEmpty {
                ForEach(sortedPoints(latest), id: \.packId) { point in
                    standingRow(point)
                }
            } else {
                Text("No mastery recorded yet — answer a few questions and check back.")
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(DesignTokens.BrandColor.canvasTextSecondary.opacity(0.06))
        )
    }

    private func standingRow(_ point: SubjectProgressPoint) -> some View {
        HStack(spacing: DesignTokens.Spacing.sm) {
            Circle().fill(tint(for: point.packId))
                .frame(width: 9, height: 9).accessibilityHidden(true)
            Text(subjectName(point.packId))
                .font(.callout.weight(.medium))
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            Spacer(minLength: 8)
            Text("\(pct(point.masteryFraction)) mastery · \(pct(point.coverageFraction)) covered")
                .font(.caption.monospacedDigit())
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(subjectName(point.packId)): \(pct(point.masteryFraction)) mastery, \(pct(point.coverageFraction)) covered.")
    }

    // MARK: - Series construction

    private func buildSeriesOptions(_ history: [ProgressSnapshot]) -> [TrendSeries] {
        var options: [TrendSeries] = [
            TrendSeries(id: "overall", label: "Overall",
                        tint: DesignTokens.BrandColor.success,
                        points: ProgressHistory.overallSeries(history))
        ]
        for packId in Self.subjectOrder {
            let points = ProgressHistory.series(history, forPackId: packId)
            guard !points.isEmpty else { continue }
            options.append(TrendSeries(id: packId,
                                       label: WeeklyReportPDFExporter.shortLabel(for: packId),
                                       tint: tint(for: packId),
                                       points: points))
        }
        return options
    }

    // MARK: - Helpers

    private func sortedPoints(_ snapshot: ProgressSnapshot) -> [SubjectProgressPoint] {
        snapshot.subjects.sorted { lhs, rhs in
            let li = Self.subjectOrder.firstIndex(of: lhs.packId) ?? Self.subjectOrder.count
            let ri = Self.subjectOrder.firstIndex(of: rhs.packId) ?? Self.subjectOrder.count
            return li != ri ? li < ri : lhs.packId < rhs.packId
        }
    }

    private func subjectName(_ packId: String) -> String {
        registry.pack(withId: packId)?.title ?? WeeklyReportPDFExporter.shortLabel(for: packId)
    }

    private func tint(for packId: String) -> Color {
        switch packId {
        case "science_class7":       return Color.compatBlue
        case "maths_class7":         return Color.orange   // Big-Sur-safe (orange isn't banned)
        case "sanskrit_class7":      return Color.compatPurple
        case "socialscience_class7": return Color.compatTeal
        default:                     return DesignTokens.BrandColor.canvasTextSecondary
        }
    }

    private func pct(_ f: Double) -> String {
        "\(Int((max(0, min(1, f)) * 100).rounded()))%"
    }

    private func signedPct(_ delta: Double) -> String {
        let points = Int((delta * 100).rounded())
        if points > 0 { return "+\(points)%" }
        if points < 0 { return "−\(abs(points))%" }
        return "no change"
    }

    private func deltaArrow(_ delta: Double) -> String {
        let points = Int((delta * 100).rounded())
        if points > 0 { return "📈" }
        if points < 0 { return "📉" }
        return "➖"
    }

    private func deltaColor(_ delta: Double) -> Color {
        let points = Int((delta * 100).rounded())
        if points > 0 { return DesignTokens.BrandColor.success }
        if points < 0 { return DesignTokens.BrandColor.danger }
        return DesignTokens.BrandColor.canvasTextSecondary
    }

    private var weekOverWeekLabel: String {
        guard let wow = weekOverWeek else {
            return "Compared with last week: not enough history yet."
        }
        return "Compared with last week: overall mastery \(signedPct(wow.overallMasteryDelta))."
    }
}
