import SwiftUI

/// Compact "🔥 N-day streak" badge surfaced on `ChapterListView`
/// above the DailyQuestionCard. Reads the streak state already
/// tracked by `DataStore.creditReviewStreak` (UserDefaults-backed
/// via `AppStorageKeys.reviewStreakDays` /
/// `AppStorageKeys.reviewStreakLastDate`) so this view doesn't
/// own any new state.
///
/// Visibility rules (mirrors what DailyPracticeViewSheet does
/// internally):
///   - `streakDays == 0` → hidden (no streak yet).
///   - `streakDays > 0` AND `streakLastDate` is today or
///     yesterday → shown (streak still "live").
///   - `streakLastDate` is more than 1 day ago → hidden (the
///     streak will reset to 1 on the next review). The visible
///     value would be misleading otherwise.
///
/// Lives in a sister file so `ChapterListView.swift` stays under
/// the 600-LOC Big Sur ceiling.
struct StreakBadge: View {
    @AppStorage(AppStorageKeys.reviewStreakDays) private var streakDays: Int = 0
    @AppStorage(AppStorageKeys.reviewStreakLastDate) private var streakLastDate: String = ""

    var body: some View {
        if isVisible {
            HStack(spacing: DesignTokens.Spacing.sm) {
                Text("🔥")
                    .font(.title3)
                    .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.xxs) {
                    Text("\(streakDays)-day streak")
                        .font(.callout.weight(.semibold))
                        .foregroundColor(DesignTokens.BrandColor.canvasText)
                    Text(streakHint)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer(minLength: 0)
            }
            .padding(.vertical, DesignTokens.Spacing.sm)
            .padding(.horizontal, DesignTokens.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: DesignTokens.Radius.md, style: .continuous)
                    .fill(Color.orange.opacity(0.10))
            )
            .overlay(
                RoundedRectangle(cornerRadius: DesignTokens.Radius.md, style: .continuous)
                    .strokeBorder(Color.orange.opacity(0.30), lineWidth: 1)
            )
            .accessibilityElement(children: .combine)
            .accessibilityLabel("\(streakDays) day review streak. \(streakHint)")
        }
    }

    /// Hidden if no streak yet, or the streak's last-active date
    /// is too far back for the displayed number to still be
    /// accurate.
    var isVisible: Bool {
        Self.shouldShow(streakDays: streakDays,
                        lastDate: streakLastDate,
                        today: Date())
    }

    /// Pure predicate — exposed for unit testing without needing
    /// to mount the SwiftUI view. Same calendar shape as
    /// `DataStore.creditReviewStreak`.
    static func shouldShow(streakDays: Int,
                           lastDate: String,
                           today: Date) -> Bool {
        guard streakDays > 0, !lastDate.isEmpty else { return false }
        let cal = Calendar(identifier: .gregorian)
        let fmt = DateFormatter()
        fmt.calendar = cal
        fmt.locale = Locale(identifier: "en_US_POSIX")
        fmt.dateFormat = "yyyy-MM-dd"
        let todayStr = fmt.string(from: today)
        if lastDate == todayStr { return true }
        // Allow "yesterday" — the streak is still alive even if
        // the kid hasn't reviewed today yet. Anything older means
        // the next review will reset the counter, so showing the
        // stale value would mislead.
        if let yesterday = cal.date(byAdding: .day, value: -1, to: today) {
            let yStr = fmt.string(from: yesterday)
            return lastDate == yStr
        }
        return false
    }

    private var streakHint: String {
        if streakDays == 1 { return "Review one question today to grow it." }
        return "Keep it going — review one today."
    }
}
