import SwiftUI

/// The trophy case. Renders the 24-badge catalog in a 4-column grid, grouped
/// by family. Badges the kid hasn't started on yet are hidden so the case
/// grows over time rather than showing 24 grey cells on day one. Tapping a
/// badge opens a detail sheet (how-to-earn + unlock date / progress).
///
/// Reads `AchievementEngine.shared` (unlock map) + the live `DataStore` /
/// `SubjectRegistry` (to compute progress hints). `@MainActor` because it
/// reads main-actor state and is hosted on the main thread.
@MainActor
struct AchievementGalleryView: View {
    @EnvironmentObject private var dataStore: DataStore
    @EnvironmentObject private var subjectRegistry: SubjectRegistry
    @ObservedObject private var engine = AchievementEngine.shared

    @State private var selected: Achievement?

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 4)

    /// Frozen metric snapshot for progress hints, recomputed each render.
    private var snapshot: AchievementSnapshot {
        dataStore.achievementSnapshot(registry: subjectRegistry)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.xl) {
                header
                ForEach(AchievementFamily.allCases) { family in
                    familySection(family)
                }
                if visibleBadges.isEmpty {
                    // Day-one: no unlocks and nothing started yet → preview the
                    // first three bronze badges as goals (with live progress).
                    AchievementGalleryEmptyStateView(snapshot: snapshot)
                }
            }
            .padding(DesignTokens.Spacing.xl)
        }
        .frame(minWidth: 560, minHeight: 480)
        .sheet(item: $selected) { badge in
            AchievementDetailSheet(
                achievement: badge,
                isUnlocked: engine.isUnlocked(badge.id),
                unlockDate: engine.unlockDate(badge.id),
                progress: badge.progress(in: snapshot),
                onClose: { selected = nil })
        }
    }

    // MARK: - Header

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Achievements")
                .font(.largeTitle.weight(.bold))
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            Text("\(engine.unlockedCount) of \(Achievement.all.count) badges earned")
                .font(.headline)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
        }
    }

    // MARK: - Family section

    @ViewBuilder
    private func familySection(_ family: AchievementFamily) -> some View {
        let badges = visibleBadges.filter { $0.family == family }
        if !badges.isEmpty {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
                Text(family.displayName)
                    .font(.title3.weight(.semibold))
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                LazyVGrid(columns: columns, spacing: DesignTokens.Spacing.lg) {
                    ForEach(badges) { badge in
                        Button {
                            selected = badge
                        } label: {
                            AchievementBadgeView(
                                achievement: badge,
                                isUnlocked: engine.isUnlocked(badge.id),
                                unlockDate: engine.unlockDate(badge.id),
                                progress: badge.progress(in: snapshot))
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel(badge.title)
                        .accessibilityValue(engine.isUnlocked(badge.id) ? "Unlocked" : "Locked")
                    }
                }
            }
        }
    }

    // MARK: - Visibility

    /// Unlocked OR in-progress badges. Not-yet-started, still-locked badges
    /// stay hidden so the gallery grows with the kid.
    private var visibleBadges: [Achievement] {
        let snap = snapshot
        return Achievement.all.filter { badge in
            engine.isUnlocked(badge.id) || badge.progress(in: snap).hasStarted
        }
    }
}

// MARK: - Detail sheet

/// Per-badge detail: emoji, title, tier, how-to-earn, and either the unlock
/// date or a progress hint. A plain sheet (no NavigationStack — macOS 13+).
@MainActor
struct AchievementDetailSheet: View {
    let achievement: Achievement
    let isUnlocked: Bool
    let unlockDate: Date?
    let progress: AchievementProgress
    let onClose: () -> Void

    private static let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .long
        f.timeStyle = .none
        return f
    }()

    var body: some View {
        VStack(spacing: 18) {
            ZStack {
                Circle()
                    .fill(isUnlocked ? achievement.tier.tint.opacity(0.18)
                                     : Color.gray.opacity(0.12))
                    .frame(width: 96, height: 96)
                Text(achievement.emoji)
                    .font(.system(size: 52))
                    .grayscale(isUnlocked ? 0 : 1)
                    .opacity(isUnlocked ? 1 : 0.5)
                    .accessibilityHidden(true)
            }
            Text(achievement.title)
                .font(.title.weight(.bold))
                .foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center)
            Text("\(achievement.tier.displayName) · \(achievement.family.displayName)")
                .font(.subheadline.weight(.medium))
                .foregroundColor(achievement.tier.tint)
            Text(achievement.detail)
                .font(.body)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 360)
            statusLine
            Button("Done", action: onClose)
                .keyboardShortcut(.defaultAction)
        }
        .padding(28)
        .frame(width: 420)
    }

    @ViewBuilder
    private var statusLine: some View {
        if isUnlocked {
            Text(unlockDate.map { "Earned \(Self.dateFormatter.string(from: $0))" } ?? "Unlocked")
                .font(.headline)
                .foregroundColor(achievement.tier.tint)
        } else {
            VStack(spacing: 6) {
                ProgressView(value: progress.fraction)
                    .frame(maxWidth: 220)
                Text("\(progress.current) of \(progress.target)")
                    .font(.subheadline.monospacedDigit())
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
            }
        }
    }
}
