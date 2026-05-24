import SwiftUI

// MARK: - MasteryDashboard
//
// Sidebar tool showing a per-chapter mastery readout derived from the
// existing `questionReviews` map (see SM2Scheduler in DataStore.swift).
// Distinct from `DiscoverProgressDashboard`, which only tracks scene
// completion — that's a binary done/not-done count. This one shows the
// *learning state* of each canonical Practice Question the kid has
// answered: how many they're learning, familiar with, confident on,
// or have mastered.
//
// Math lives in `DataStore.masterySummary(forPackId:chapters:locator:)`
// in `DataStore+Mastery.swift`; this view just renders. The dashboard
// re-renders automatically when `dataStore.questionReviews` mutates
// (the @Published binding propagates through SwiftUI).
//
// Big Sur 11.5 compatible — no .foregroundStyle, no @Observable, no
// macOS 12+ APIs. Tested against the standard XCUI walker by the
// SidebarTool.mastery route in ContentView.

struct MasteryDashboard: View {
    var body: some View {
        TutorNavigationContainer {
            MasteryDashboardContent()
        }
    }
}

private struct MasteryDashboardContent: View {
    @EnvironmentObject private var subjectRegistry: SubjectRegistry
    @EnvironmentObject private var dataStore: DataStore
    @EnvironmentObject private var nav: TutorNavigationState
    @EnvironmentObject private var appState: AppState

    /// Subject the dashboard is currently filtered to. Defaults to
    /// Science (the larger of the two packs) so the kid lands on the
    /// most useful view; the tab control lets them flip to Sanskrit.
    @State private var selectedPackId: String = "science_class7"

    @AppStorage(AppStorageKeys.reviewStreakDays) private var streakDays: Int = 0
    @AppStorage(AppStorageKeys.reviewStreakBest) private var streakBest: Int = 0

    private var packs: [SubjectPack] { subjectRegistry.packs }

    private var selectedPack: SubjectPack? {
        subjectRegistry.pack(withId: selectedPackId)
    }

    private var summary: MasterySummary {
        guard let pack = selectedPack else {
            return MasterySummary(subjectPackId: selectedPackId,
                                  chapters: [],
                                  dueCount: 0,
                                  totalReviewed: 0)
        }
        return dataStore.masterySummary(
            forPackId: pack.id,
            chapters: pack.chapters,
            locator: { id in
                guard let loc = subjectRegistry.location(forQuestionId: id),
                      loc.pack.id == pack.id else { return nil }
                return (
                    chapterId: loc.chapter.id,
                    chapterTitle: loc.chapter.title,
                    chapterNumber: loc.chapter.number
                )
            },
            topicLocator: { id in
                guard let loc = subjectRegistry.location(forQuestionId: id),
                      loc.pack.id == pack.id else { return nil }
                // Find the question's owning topic. Walk the chapter
                // topics linearly — typical chapter has 3-5 topics
                // so this is cheap (≤ 5 hash lookups via prefix-check).
                for (idx, topic) in loc.chapter.topics.enumerated() {
                    if topic.questions.contains(where: { $0.id == id }) {
                        return TopicLocation(
                            topicId: topic.id,
                            topicTitle: topic.title,
                            displayOrder: idx
                        )
                    }
                }
                return nil
            }
        )
    }

    /// Expanded chapter ids (D6 drill-down). Tap a chapter card →
    /// the per-topic rows slide in beneath. Closed by default so the
    /// dashboard isn't a wall of topic rows for a kid mid-review.
    @State private var expandedChapterIds: Set<String> = []

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                header
                if packs.count > 1 {
                    subjectTabs
                }
                if summary.isEmpty {
                    emptyState
                } else {
                    overallBar
                    reviewQueueCTA
                    Text("Chapter mastery")
                        .font(.headline)
                        .padding(.top, 4)
                    ForEach(summary.chapters) { row in
                        chapterCard(row)
                    }
                }
                legend
            }
            .padding(20)
            .frame(maxWidth: DesignTokens.contentMaxWidth, alignment: .leading)
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .background(Color.white)
        .navigationTitle("My Progress")
    }

    // MARK: - Header

    private var header: some View {
        HStack(alignment: .firstTextBaseline, spacing: 12) {
            Text("📊")
                .font(.system(size: 36))
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 2) {
                Text("My Progress")
                    .font(.largeTitle.bold())
                Text(subtitle)
                    .font(.subheadline.monospacedDigit())
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
            }
            Spacer(minLength: 0)
            if streakDays > 0 {
                streakChip
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.compatIndigo.opacity(0.08))
        )
    }

    private var subtitle: String {
        if summary.isEmpty {
            return "Answer your first practice question to start tracking mastery."
        }
        let pct = Int((summary.overallMasteryFraction * 100).rounded())
        return "\(summary.totalReviewed) question\(summary.totalReviewed == 1 ? "" : "s") tracked · \(pct)% overall mastery"
    }

    private var streakChip: some View {
        HStack(spacing: 6) {
            Image(systemName: "flame.fill")
                .foregroundColor(DesignTokens.BrandColor.tryAtHome)
                .font(.callout)
            Text("\(streakDays) day\(streakDays == 1 ? "" : "s")")
                .font(.callout.monospacedDigit().weight(.semibold))
                .foregroundColor(DesignTokens.BrandColor.canvasText)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Capsule().fill(Color.white))
        .overlay(
            Capsule().strokeBorder(
                DesignTokens.BrandColor.tryAtHome.opacity(0.35),
                lineWidth: 1
            )
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel(
            "Current streak: \(streakDays) day\(streakDays == 1 ? "" : "s")."
            + (streakBest > streakDays ? " Best ever: \(streakBest)." : "")
        )
    }

    // MARK: - Subject tabs

    private var subjectTabs: some View {
        HStack(spacing: 8) {
            ForEach(packs) { pack in
                let isSelected = pack.id == selectedPackId
                Button {
                    selectedPackId = pack.id
                } label: {
                    HStack(spacing: 6) {
                        Text(pack.coverEmoji)
                        Text(pack.title)
                            .font(.callout.weight(isSelected ? .semibold : .regular))
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 7)
                    .background(
                        Capsule().fill(
                            isSelected
                                ? Color.compatIndigo.opacity(0.15)
                                : Color.gray.opacity(0.08)
                        )
                    )
                    .overlay(
                        Capsule().strokeBorder(
                            isSelected ? Color.compatIndigo.opacity(0.45) : .clear,
                            lineWidth: 1
                        )
                    )
                    .foregroundColor(
                        isSelected
                            ? Color.compatIndigo
                            : DesignTokens.BrandColor.canvasText
                    )
                }
                .buttonStyle(.plain)
                .pointingCursor()
                .accessibilityLabel("\(pack.title) filter")
                .accessibilityAddTraits(isSelected ? .isSelected : [])
            }
            Spacer(minLength: 0)
        }
    }

    // MARK: - Overall bar + queue CTA

    private var overallBar: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Overall mastery")
                .font(.caption.weight(.semibold))
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
            // Build a stacked segmented bar from the aggregate counts.
            // Each segment width is proportional to its count; the bar
            // is purely informational so we don't bother with totals
            // labels here — the chapter cards carry counts.
            GeometryReader { geo in
                let totals = aggregateCounts(summary: summary)
                let total = max(1, totals.values.reduce(0, +))
                HStack(spacing: 0) {
                    ForEach(MasteryLevel.allCases) { level in
                        let count = totals[level] ?? 0
                        let fraction = Double(count) / Double(total)
                        Rectangle()
                            .fill(level.tint)
                            .frame(width: geo.size.width * CGFloat(fraction))
                            .accessibilityHidden(true)
                    }
                }
            }
            .frame(height: 10)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .accessibilityLabel("Overall mastery bar — \(Int((summary.overallMasteryFraction * 100).rounded())) percent")
        }
    }

    private var reviewQueueCTA: some View {
        HStack(spacing: 14) {
            Image(systemName: "flame.fill")
                .font(.title2)
                .foregroundColor(.orange)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 4) {
                Text(reviewQueueTitle)
                    .font(.title3.weight(.semibold))
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                Text("The spaced-review scheduler surfaces what you're about to forget.")
                    .font(.caption)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
            }
            Spacer(minLength: 8)
            Button("Start Daily Practice") {
                appState.sidebarSelection = .tool(.dailyPractice)
            }
            .keyboardShortcut(.defaultAction)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.orange.opacity(0.10))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(Color.orange.opacity(0.3), lineWidth: 1)
        )
    }

    private var reviewQueueTitle: String {
        if summary.dueCount == 0 {
            return "All caught up — no reviews due"
        }
        return "\(summary.dueCount) question\(summary.dueCount == 1 ? "" : "s") due for review"
    }

    // MARK: - Per-chapter card

    @ViewBuilder
    private func chapterCard(_ row: ChapterMasterySummary) -> some View {
        let isExpanded = expandedChapterIds.contains(row.chapterId)
        VStack(alignment: .leading, spacing: 10) {
            Button {
                if row.topicSummaries.isEmpty {
                    openChapter(row)
                } else {
                    if isExpanded {
                        expandedChapterIds.remove(row.chapterId)
                    } else {
                        expandedChapterIds.insert(row.chapterId)
                    }
                }
            } label: {
                HStack(spacing: 14) {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 6) {
                            Text("Ch. \(row.chapterNumber) — \(row.chapterTitle)")
                                .font(.headline)
                                .multilineTextAlignment(.leading)
                                .lineLimit(2)
                            Spacer(minLength: 0)
                            Text("\(row.totalReviewed)")
                                .font(.caption.weight(.semibold).monospacedDigit())
                                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                        }
                        masteryBar(for: row)
                        levelChips(for: row)
                    }
                    Image(systemName: row.topicSummaries.isEmpty
                          ? "chevron.right"
                          : (isExpanded ? "chevron.down" : "chevron.right"))
                        .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                        .accessibilityHidden(true)
                }
                .padding(14)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(NSColor.controlBackgroundColor))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(Color.gray.opacity(0.15), lineWidth: 1)
                )
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .pointingCursor()
            .accessibilityLabel(a11yLabel(for: row))

            // D6 — per-topic drill-down. Renders only when the chapter
            // card is expanded AND the aggregator gave us topic data.
            if isExpanded {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(row.topicSummaries) { topic in
                        topicRow(topic)
                    }
                    Button("Open chapter") { openChapter(row) }
                        .font(.caption)
                        .padding(.top, 4)
                }
                .padding(.leading, 18)
            }
        }
    }

    private func topicRow(_ topic: TopicMasterySummary) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(topic.topicTitle)
                    .font(.callout.weight(.medium))
                    .lineLimit(2)
                Spacer(minLength: 0)
                Text("\(topic.totalReviewed)")
                    .font(.caption2.monospacedDigit())
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
            }
            // Same segmented-bar shape as the chapter card; smaller height.
            GeometryReader { geo in
                let total = max(1, topic.totalReviewed)
                HStack(spacing: 0) {
                    ForEach(MasteryLevel.allCases) { level in
                        let count = topic.counts[level] ?? 0
                        let fraction = Double(count) / Double(total)
                        Rectangle()
                            .fill(level.tint)
                            .frame(width: geo.size.width * CGFloat(fraction))
                            .accessibilityHidden(true)
                    }
                }
            }
            .frame(height: 6)
            .clipShape(RoundedRectangle(cornerRadius: 3))
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.06))
        )
        .accessibilityLabel("Topic \(topic.topicTitle): \(topic.totalReviewed) tracked")
    }

    private func masteryBar(for row: ChapterMasterySummary) -> some View {
        GeometryReader { geo in
            let total = max(1, row.totalReviewed)
            HStack(spacing: 0) {
                ForEach(MasteryLevel.allCases) { level in
                    let count = row.counts[level] ?? 0
                    let fraction = Double(count) / Double(total)
                    Rectangle()
                        .fill(level.tint)
                        .frame(width: geo.size.width * CGFloat(fraction))
                        .accessibilityHidden(true)
                }
            }
        }
        .frame(height: 8)
        .clipShape(RoundedRectangle(cornerRadius: 4))
    }

    private func levelChips(for row: ChapterMasterySummary) -> some View {
        HStack(spacing: 8) {
            ForEach(MasteryLevel.allCases.reversed()) { level in
                let count = row.counts[level] ?? 0
                if count > 0 {
                    HStack(spacing: 4) {
                        Circle()
                            .fill(level.tint)
                            .frame(width: 8, height: 8)
                        Text("\(level.displayName) \(count)")
                            .font(.caption2.monospacedDigit())
                            .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    }
                }
            }
        }
    }

    private func a11yLabel(for row: ChapterMasterySummary) -> String {
        let parts = MasteryLevel.allCases
            .compactMap { level -> String? in
                let count = row.counts[level] ?? 0
                guard count > 0 else { return nil }
                return "\(count) \(level.displayName)"
            }
            .joined(separator: ", ")
        return "Chapter \(row.chapterNumber): \(row.chapterTitle). \(row.totalReviewed) tracked: \(parts)."
    }

    // MARK: - Legend

    private var legend: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("How mastery levels work")
                .font(.caption.weight(.semibold))
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
            ForEach(MasteryLevel.allCases) { level in
                HStack(spacing: 8) {
                    Circle()
                        .fill(level.tint)
                        .frame(width: 10, height: 10)
                    Text("\(level.displayName) — \(level.caption)")
                        .font(.caption)
                        .foregroundColor(DesignTokens.BrandColor.canvasText)
                }
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.05))
        )
        .padding(.top, 8)
    }

    // MARK: - Empty state

    private var emptyState: some View {
        EmptyStateView(
            icon: "chart.bar",
            title: "No mastery to show yet",
            subtitle: "Answer a few practice questions and your per-chapter mastery will appear here. The spaced-review scheduler kicks in as soon as you've answered your first question."
        )
        .padding(.top, 8)
    }

    // MARK: - Helpers

    private func aggregateCounts(summary: MasterySummary) -> [MasteryLevel: Int] {
        var totals: [MasteryLevel: Int] = [
            .learning: 0, .familiar: 0, .confident: 0, .mastered: 0
        ]
        for row in summary.chapters {
            for (level, count) in row.counts {
                totals[level, default: 0] += count
            }
        }
        return totals
    }

    private func openChapter(_ row: ChapterMasterySummary) {
        guard subjectRegistry.pack(withId: row.subjectPackId) != nil else {
            return
        }
        // Same route the sidebar uses to open a chapter — push the
        // chapter detail onto the tutor nav stack. The push API takes
        // a TutorRoute case; using `.chapter` puts us at the chapter
        // landing page directly.
        nav.push(.chapter(packId: row.subjectPackId, chapterId: row.chapterId))
    }
}
