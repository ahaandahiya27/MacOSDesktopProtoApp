import SwiftUI

/// Day-one empty state for the Achievement Gallery: shown when the kid hasn't
/// unlocked anything yet. Rather than a blank trophy case, it previews the
/// first three bronze badges (still locked) with their how-to-earn text and a
/// friendly nudge, so day-one users see attainable goals instead of nothing.
///
/// `@MainActor` — hosted in the gallery window on the main thread.
@MainActor
struct AchievementGalleryEmptyStateView: View {
    /// Snapshot for the locked badges' progress hints (an empty snapshot on a
    /// true day-one; passed in so the gallery can supply live progress).
    var snapshot: AchievementSnapshot = AchievementSnapshot()

    /// The first three bronze badges, in catalog order — the starter goals.
    static let starterBadges: [Achievement] =
        Array(Achievement.all.filter { $0.tier == .bronze }.prefix(3))

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 3)

    var body: some View {
        VStack(spacing: 18) {
            Text("🏆")
                .font(.system(size: 52))
                .accessibilityHidden(true)
            Text("Your trophy case is waiting")
                .font(.title3.weight(.semibold))
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            Text("Complete your first practice session to earn your first badge! Here are three to aim for:")
                .font(.body)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 420)
            LazyVGrid(columns: columns, spacing: DesignTokens.Spacing.lg) {
                ForEach(Self.starterBadges) { badge in
                    AchievementBadgeView(
                        achievement: badge,
                        isUnlocked: false,
                        unlockDate: nil,
                        progress: badge.progress(in: snapshot))
                }
            }
            .frame(maxWidth: 460)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 28)
    }
}
