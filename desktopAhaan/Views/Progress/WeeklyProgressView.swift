import SwiftUI
import AppKit

/// Parent / Weekly Progress dashboard. A single scrollable surface that
/// rolls up the week's activity across every subject — per-day per-
/// subject counts, the streak, the mastery delta — and exports a
/// one-page PDF a parent can read on their phone.
///
/// Presented in its own window via ⌘⇧W / Help → Weekly Progress (see
/// `WeeklyProgressWindow.swift` + `desktopAhaanApp.swift`). `@MainActor`
/// because it reads `DataStore` (a main-actor-isolated class) synchronously
/// in `onAppear` — keeps the call chain nonisolated-free under Swift 5.5
/// on Big Sur.
@MainActor
struct WeeklyProgressView: View {
    @EnvironmentObject var dataStore: DataStore
    @EnvironmentObject var registry: SubjectRegistry

    @State private var activity: WeeklyActivity?
    @State private var weekOverWeek: ProgressDelta?
    @State private var exportStatus: String?
    @State private var exportIsError = false

    private static let weekdayFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.dateFormat = "EEE"
        return f
    }()
    private static let dayNumberFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.dateFormat = "d"
        return f
    }()
    private static let rangeFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.dateFormat = "MMMM d"
        return f
    }()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                header
                if let activity = activity {
                    streakCard(activity)
                    weekGrid(activity)
                    masteryDeltaCard(activity.masteryDelta)
                    weekOverWeekCard
                    exportSection(activity)
                } else {
                    ProgressView("Building this week's summary…")
                        .padding(.vertical, 40)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(20)
            .frame(maxWidth: 720, alignment: .leading)
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .background(Color(NSColor.windowBackgroundColor))
        .onAppear { reload() }
        .navigationTitle("Weekly Progress")
    }

    private func reload() {
        // Record today's mastery snapshot so the week-over-week delta + the PDF
        // trend page have fresh, accruing history. Read-only over the SRS;
        // idempotent per calendar day; no-ops until packs load.
        dataStore.captureProgressSnapshot(registry: registry)
        weekOverWeek = dataStore.progressWeekOverWeek()
        activity = dataStore.weeklyActivity(chapterLocator: { id, packId in
            registry.location(forQuestionId: id, preferredPackId: packId)?.chapter.id
        })
    }

    // MARK: - Header

    private var header: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
            HStack(spacing: 10) {
                Text("📈").font(.system(size: 34)).accessibilityHidden(true)
                Text("Weekly Progress")
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
            }
            Text(weekRangeText)
                .font(.subheadline)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Weekly Progress. \(weekRangeText)")
    }

    private var weekRangeText: String {
        guard let activity = activity else { return "This week" }
        let start = Self.rangeFormatter.string(from: activity.weekStart)
        let end = Self.rangeFormatter.string(from: activity.days.last?.date ?? activity.weekStart)
        return "Week of \(start) – \(end)"
    }

    // MARK: - Streak card

    private func streakCard(_ activity: WeeklyActivity) -> some View {
        HStack(spacing: DesignTokens.Spacing.lg) {
            Image(systemName: SFSymbolCompat.name("flame.fill"))
                .font(.system(size: 36))
                .foregroundColor(DesignTokens.BrandColor.tryAtHome)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.xxs) {
                Text(streakHeadline(activity.streakDays))
                    .font(.title2.weight(.bold))
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                Text(activity.streakBest > 0 ? "Best ever: \(activity.streakBest) days" : "Answer a question to start a streak.")
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
            }
            Spacer(minLength: 0)
            weekTotalsBadge(activity)
        }
        .padding(DesignTokens.Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: DesignTokens.Radius.card)
                .fill(DesignTokens.BrandColor.tryAtHome.opacity(0.08))
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(streakHeadline(activity.streakDays)). Best ever \(activity.streakBest) days.")
    }

    private func streakHeadline(_ days: Int) -> String {
        days <= 0 ? "No streak yet" : "\(days)-day streak!"
    }

    private func weekTotalsBadge(_ activity: WeeklyActivity) -> some View {
        VStack(alignment: .trailing, spacing: DesignTokens.Spacing.xxs) {
            Text("~\(activity.totalMinutesEstimate) min")
                .font(.title3.weight(.semibold).monospacedDigit())
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            Text("this week")
                .font(.caption)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("About \(activity.totalMinutesEstimate) estimated minutes this week.")
    }

    // MARK: - Week grid

    private func weekGrid(_ activity: WeeklyActivity) -> some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
            Text("Day by day")
                .font(.headline)
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            HStack(alignment: .top, spacing: DesignTokens.Spacing.sm) {
                ForEach(activity.days, id: \.date) { day in
                    dayCard(day)
                }
            }
            Text("Minutes are rough estimates: 0.5 / review, 2 / concept, 3 / discover scene.")
                .font(.caption2)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
        }
    }

    private func dayCard(_ day: DayActivity) -> some View {
        VStack(spacing: DesignTokens.Spacing.xs) {
            Text(Self.weekdayFormatter.string(from: day.date))
                .font(.caption.weight(.semibold))
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
            Text(Self.dayNumberFormatter.string(from: day.date))
                .font(.headline.monospacedDigit())
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            Divider().opacity(0.4)
            if day.isEmpty {
                Text("—")
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary.opacity(0.6))
                    .frame(maxHeight: .infinity, alignment: .center)
            } else {
                subjectPills(day)
                Text("~\(day.totalMinutesEstimate)m")
                    .font(.caption2.monospacedDigit())
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
            }
        }
        .padding(DesignTokens.Spacing.sm)
        .frame(maxWidth: .infinity, minHeight: 112, alignment: .top)
        .background(
            RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
                .fill(day.isEmpty
                      ? Color.gray.opacity(0.06)
                      : DesignTokens.BrandColor.success.opacity(0.08))
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel(dayAccessibilityLabel(day))
    }

    private func subjectPills(_ day: DayActivity) -> some View {
        VStack(spacing: 3) {
            ForEach(sortedSubjects(day), id: \.packId) { subject in
                HStack(spacing: 3) {
                    Text(emoji(for: subject.packId))
                        .font(.caption2)
                        .accessibilityHidden(true)
                    Text("\(WeeklyReportPDFExporter.shortLabel(for: subject.packId)) \(subject.total)")
                        .font(.caption2.weight(.medium))
                        .foregroundColor(DesignTokens.BrandColor.canvasText)
                        .minimumScaleFactor(0.7)
                        .lineLimit(1)
                }
            }
        }
    }

    // MARK: - Mastery delta card

    private func masteryDeltaCard(_ delta: MasteryDelta) -> some View {
        HStack(spacing: DesignTokens.Spacing.md) {
            Text(delta.isEmpty ? "🌱" : "🎉")
                .font(.system(size: 30))
                .accessibilityHidden(true)
            Text(masteryText(delta))
                .font(.callout)
                .foregroundColor(DesignTokens.BrandColor.canvasText)
                .fixedSize(horizontal: false, vertical: true)
            Spacer(minLength: 0)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(DesignTokens.BrandColor.success.opacity(delta.isEmpty ? 0.05 : 0.10))
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel(masteryText(delta))
    }

    private func masteryText(_ delta: MasteryDelta) -> String {
        if delta.isEmpty {
            return "No new mastery milestones this week — every bit of practice still counts!"
        }
        var parts: [String] = []
        if delta.newMastered > 0 { parts.append("Mastered \(delta.newMastered)") }
        if delta.newConfident > 0 { parts.append("got Confident on \(delta.newConfident)") }
        if delta.newFamiliar > 0 { parts.append("became Familiar with \(delta.newFamiliar)") }
        return "This week, Ahaan " + joinClauses(parts) + "."
    }

    private func joinClauses(_ parts: [String]) -> String {
        switch parts.count {
        case 0: return ""
        case 1: return parts[0]
        case 2: return parts[0] + " and " + parts[1]
        default: return parts.dropLast().joined(separator: ", ") + ", and " + (parts.last ?? "")
        }
    }

    // MARK: - Week-over-week delta (v8)

    @ViewBuilder
    private var weekOverWeekCard: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
            Text("Compared with last week")
                .font(.headline)
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            if let wow = weekOverWeek {
                wowBody(wow)
            } else {
                Text("Your week-over-week trend appears here once there's a mastery snapshot from about a week ago. Keep practising — it builds automatically.")
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
        .accessibilityLabel(weekOverWeekAccessibilityLabel)
    }

    private func wowBody(_ wow: ProgressDelta) -> some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
            HStack(spacing: 10) {
                Text(deltaArrow(wow.overallMasteryDelta))
                    .font(.system(size: 26))
                    .accessibilityHidden(true)
                Text("Overall mastery \(signedPct(wow.overallMasteryDelta)) vs last week")
                    .font(.title3.weight(.semibold))
                    .foregroundColor(deltaColor(wow.overallMasteryDelta))
            }
            let subjects = sortedSubjectDeltas(wow)
            if !subjects.isEmpty {
                VStack(alignment: .leading, spacing: 3) {
                    ForEach(subjects, id: \.0) { entry in
                        Text("\(subjectName(entry.0)): \(signedPct(entry.1))")
                            .font(.caption)
                            .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    }
                }
            }
        }
    }

    /// Per-subject mastery deltas, in the dashboard's subject order, dropping
    /// any zero-change rows so the card stays focused on what moved.
    private func sortedSubjectDeltas(_ wow: ProgressDelta) -> [(String, Double)] {
        let order = ["science_class7", "maths_class7", "sanskrit_class7", "socialscience_class7"]
        return wow.perSubjectMasteryDelta
            .filter { abs($0.value) >= 0.005 }   // ≥ 0.5% to round to a visible point
            .sorted { lhs, rhs in
                let li = order.firstIndex(of: lhs.key) ?? order.count
                let ri = order.firstIndex(of: rhs.key) ?? order.count
                return li != ri ? li < ri : lhs.key < rhs.key
            }
            .map { ($0.key, $0.value) }
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

    private func subjectName(_ packId: String) -> String {
        registry.pack(withId: packId)?.title ?? WeeklyReportPDFExporter.shortLabel(for: packId)
    }

    private var weekOverWeekAccessibilityLabel: String {
        guard let wow = weekOverWeek else {
            return "Compared with last week: not enough history yet."
        }
        var label = "Compared with last week: overall mastery \(signedPct(wow.overallMasteryDelta))."
        for entry in sortedSubjectDeltas(wow) {
            label += " \(subjectName(entry.0)) \(signedPct(entry.1))."
        }
        return label
    }

    // MARK: - Export

    private func exportSection(_ activity: WeeklyActivity) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Button(action: { exportPDF(activity) }) {
                HStack(spacing: 6) {
                    Image(systemName: SFSymbolCompat.name("square.and.arrow.up"))
                    Text("Export Report Card (PDF)")
                }
                .padding(.horizontal, 14)
                .padding(.vertical, DesignTokens.Spacing.sm)
                .frame(minHeight: 44)
            }
            .accessibilityLabel("Export a PDF report card — this week's progress plus mastery by subject and the latest checkpoint — to save or share.")
            .accessibilityHint("Opens a save dialog to write the weekly report as a PDF")
            if let status = exportStatus {
                Text(status)
                    .font(.caption)
                    .foregroundColor(exportIsError ? DesignTokens.BrandColor.danger : DesignTokens.BrandColor.canvasTextSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private func exportPDF(_ activity: WeeklyActivity) {
        let panel = NSSavePanel()
        panel.allowedFileTypes = ["pdf"]
        panel.nameFieldStringValue = WeeklyReportPDFExporter.reportCardFilename(activity)
        panel.message = "Save a report card — this week plus mastery by subject and the latest checkpoint."
        guard panel.runModal() == .OK, let url = panel.url else { return }
        // Build the cross-subject mastery rows + latest checkpoint to fold in.
        let snapshot = MasteryEngine.snapshot(registry: registry, dataStore: dataStore)
        let masteryRows = ReportCardMasteryRow.rows(from: snapshot)
        let checkpoint = dataStore.latestCheckpointResult()
        do {
            try WeeklyReportPDFExporter.exportReportCard(
                activity: activity, masteryRows: masteryRows,
                checkpoint: checkpoint, to: url,
                progressHistory: dataStore.progressHistorySorted())
            exportStatus = "Saved to \(url.lastPathComponent)."
            exportIsError = false
        } catch {
            exportStatus = "Save failed: \(error.localizedDescription)"
            exportIsError = true
        }
    }

    // MARK: - Subject helpers

    private func sortedSubjects(_ day: DayActivity) -> [SubjectActivity] {
        let order = ["science_class7", "maths_class7", "sanskrit_class7"]
        return day.perSubject.values
            .filter { $0.total > 0 }
            .sorted { lhs, rhs in
                let li = order.firstIndex(of: lhs.packId) ?? order.count
                let ri = order.firstIndex(of: rhs.packId) ?? order.count
                return li != ri ? li < ri : lhs.packId < rhs.packId
            }
    }

    private func emoji(for packId: String) -> String {
        registry.pack(withId: packId)?.coverEmoji ?? "•"
    }

    private func dayAccessibilityLabel(_ day: DayActivity) -> String {
        let weekday = Self.weekdayFormatter.string(from: day.date)
        if day.isEmpty { return "\(weekday): no activity." }
        let subjectText = sortedSubjects(day)
            .map { "\(WeeklyReportPDFExporter.shortLabel(for: $0.packId)) \($0.total)" }
            .joined(separator: ", ")
        return "\(weekday): \(subjectText). About \(day.totalMinutesEstimate) minutes."
    }
}
