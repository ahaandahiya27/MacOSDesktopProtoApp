import SwiftUI

/// Sidebar tool: a single-page overview of every Discover chapter and how
/// many scenes the kid has finished. Tapping a row jumps straight into that
/// chapter's Discover experience.
struct DiscoverProgressDashboard: View {
    var body: some View {
        TutorNavigationContainer {
            DiscoverProgressContent()
        }
    }
}

private struct DiscoverProgressContent: View {
    @EnvironmentObject private var subjectRegistry: SubjectRegistry
    @EnvironmentObject private var dataStore: DataStore
    @EnvironmentObject private var nav: TutorNavigationState

    private var pack: SubjectPack? {
        subjectRegistry.pack(withId: DiscoverMode.hostPackId)
    }

    private var chapters: [Chapter] {
        guard let pack = pack else { return [] }
        // O(1) dict lookup vs O(N) first(where:) per supportedChapterId
        // (was 19 × 19 = 361 comparisons per dashboard render).
        let index = pack.chapterIndex
        return DiscoverMode.supportedChapterIds.compactMap { index[$0] }
    }

    private var totalCompleted: Int {
        chapters.reduce(0) { $0 + completedCount(for: $1) }
    }

    private var totalScenes: Int {
        chapters.count * DiscoverMode.scenesPerChapter
    }

    private var overallPercent: Double {
        guard totalScenes > 0 else { return 0 }
        return Double(totalCompleted) / Double(totalScenes)
    }

    /// 3 chapters with at least one scene done but not yet complete, ordered
    /// by how close they are to completion. Encourages finishing started work.
    private var closestToCompletion: [Chapter] {
        let total = DiscoverMode.scenesPerChapter
        let scored = chapters.compactMap { ch -> (Chapter, Int)? in
            let done = completedCount(for: ch)
            guard done > 0 && done < total else { return nil }
            return (ch, done)
        }
        return scored.sorted { $0.1 > $1.1 }.prefix(3).map { $0.0 }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                header
                if !closestToCompletion.isEmpty {
                    closestCard
                }
                ForEach(chapters) { ch in
                    chapterCard(ch)
                }
            }
            .padding(20)
            // Center the bounded-width content within the full-width
            // detail pane. See QuestionDetailView for the same pattern.
            .frame(maxWidth: DesignTokens.contentMaxWidth, alignment: .leading)
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .background(Color.white)
        .navigationTitle("Discover Progress")
    }

    private var closestCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: DesignTokens.Spacing.sm) {
                Image(systemName: SFSymbolCompat.name("flag.checkered"))
                    .foregroundColor(.orange)
                Text("Almost there")
                    .font(.headline)
                Spacer()
            }
            ForEach(closestToCompletion) { ch in
                let done = completedCount(for: ch)
                let total = DiscoverMode.scenesPerChapter
                Button {
                    openChapter(ch)
                } label: {
                    HStack {
                        Text("Ch. \(ch.number) — \(ch.title)")
                            .font(.callout.weight(.medium))
                            .lineLimit(1)
                        Spacer()
                        Text("\(done)/\(total)")
                            .font(.caption.weight(.semibold).monospacedDigit())
                            .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                        Image(systemName: "chevron.right")
                            .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                            .font(.caption)
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .pointingCursor()
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.orange.opacity(0.10))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(Color.orange.opacity(0.30), lineWidth: 1)
        )
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .firstTextBaseline) {
                Text("\u{2728}")
                    .font(.system(size: 36))
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.xxs) {
                    Text("Discover Mode")
                        .font(.largeTitle.bold())
                    Text("\(totalCompleted) of \(totalScenes) scenes completed across \(chapters.count) chapters")
                        .font(.subheadline.monospacedDigit())
                        .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                }
            }
            ProgressView(value: overallPercent)
                .progressViewStyle(.linear)
                .accessibilityLabel("Overall Discover progress")
                .accessibilityValue("\(Int(overallPercent * 100)) percent")
        }
        .padding(DesignTokens.Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.compatIndigo.opacity(0.08))
        )
    }

    @ViewBuilder
    private func chapterCard(_ chapter: Chapter) -> some View {
        let done = completedCount(for: chapter)
        let total = DiscoverMode.scenesPerChapter
        let fraction = total > 0 ? Double(done) / Double(total) : 0
        let isComplete = done >= total

        Button {
            openChapter(chapter)
        } label: {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .strokeBorder(Color.gray.opacity(0.2), lineWidth: 4)
                        .frame(width: 52, height: 52)
                    Circle()
                        .trim(from: 0, to: CGFloat(fraction))
                        .stroke(isComplete ? Color.green : ChapterTheme.accent(for: chapter.id),
                                style: StrokeStyle(lineWidth: 4, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                        .frame(width: 52, height: 52)
                    if isComplete {
                        Image(systemName: "checkmark")
                            .font(.body.weight(.bold))
                            .foregroundColor(.green)
                    } else {
                        Text("\(done)/\(total)")
                            .font(.caption.weight(.semibold).monospacedDigit())
                            .foregroundColor(DesignTokens.BrandColor.canvasText)
                    }
                }

                VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                    Text("Ch. \(chapter.number) \u{2014} \(chapter.title)")
                        .font(.headline)
                        .multilineTextAlignment(.leading)
                    HStack(spacing: DesignTokens.Spacing.sm) {
                        Text(isComplete ? "All scenes completed" : "\(total - done) scene\(total - done == 1 ? "" : "s") left")
                            .font(.caption)
                            .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                        if let bq = bossQuizScore(for: chapter) {
                            // Boss Quiz score badge — surfaces the per-chapter
                            // performance number that was previously only visible
                            // inside the chapter itself. Helps identify weak
                            // topics from the sidebar at a glance.
                            let perfect = bq.score == bq.max
                            HStack(spacing: DesignTokens.Spacing.xs) {
                                Image(systemName: perfect ? "checkmark.seal.fill" : "trophy.fill")
                                    .font(.caption2)
                                Text("\(bq.score)/\(bq.max)")
                                    .font(.caption.monospacedDigit())
                            }
                            .foregroundColor(perfect ? .green : .orange)
                            .accessibilityLabel("Boss Quiz score \(bq.score) out of \(bq.max)")
                        }
                    }
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
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
        .accessibilityLabel("Chapter \(chapter.number), \(chapter.title)")
        .accessibilityValue("\(done) of \(total) scenes completed")
    }

    /// Uses `dataStore.discoverRowCount(for:)` which is backed by a cached
    /// chapterId → count dict. The previous `.discoverRows(for:).count` did
    /// a linear scan over all DiscoverProgress entries — and this dashboard
    /// calls `completedCount` 19+ times per render (closestToCompletion +
    /// totalCompleted + per-chapterCard).
    private func completedCount(for chapter: Chapter) -> Int {
        dataStore.discoverRowCount(for: chapter.id)
    }

    /// Boss Quiz score (score, maxScore) for the chapter's Scene 9, or
    /// nil if the student hasn't completed the Boss Quiz yet. Read once
    /// per chapterCard render; uses the same discoverProgress data the
    /// other counts derive from.
    fileprivate func bossQuizScore(for chapter: Chapter) -> (score: Int, max: Int)? {
        for row in dataStore.discoverRows(for: chapter.id) where row.sceneId == "scene9" {
            if let s = row.score, let m = row.maxScore, m > 0 {
                return (s, m)
            }
        }
        return nil
    }

    fileprivate func openChapter(_ chapter: Chapter) {
        guard let pack = pack else { return }
        nav.push(.discover(packId: pack.id, chapterId: chapter.id))
    }
}
