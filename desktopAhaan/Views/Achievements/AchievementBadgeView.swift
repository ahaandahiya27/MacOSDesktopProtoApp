import SwiftUI

/// One badge cell in the gallery grid. Two visual states:
///   • Unlocked → full-colour emoji, tier ring, title, unlock date.
///   • Locked (but started) → grayscale emoji + lock glyph, title, and a
///     "current / target" progress hint so the kid sees how close they are.
///
/// Not-yet-started badges are filtered out by the gallery, so this view only
/// ever renders unlocked or in-progress badges.
///
/// `@MainActor` — rendered inside the gallery window's hosting controller on
/// the main thread; keeps it aligned with the rest of the feature.
@MainActor
struct AchievementBadgeView: View {
    let achievement: Achievement
    let isUnlocked: Bool
    let unlockDate: Date?
    let progress: AchievementProgress

    private static let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .none
        return f
    }()

    var body: some View {
        VStack(spacing: DesignTokens.Spacing.sm) {
            emblem
            Text(achievement.title)
                .font(.subheadline.weight(.semibold))
                .foregroundColor(isUnlocked
                    ? DesignTokens.BrandColor.canvasText
                    : DesignTokens.BrandColor.canvasTextSecondary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .frame(maxWidth: .infinity)
            caption
        }
        .padding(DesignTokens.Spacing.md)
        .frame(maxWidth: .infinity, minHeight: 150)
        .background(
            RoundedRectangle(cornerRadius: DesignTokens.Radius.card)
                .fill(Color(NSColor.controlBackgroundColor))
        )
        .overlay(
            RoundedRectangle(cornerRadius: DesignTokens.Radius.card)
                .stroke(isUnlocked ? achievement.tier.tint.opacity(0.55)
                                   : Color.gray.opacity(0.25),
                        lineWidth: isUnlocked ? 1.5 : 1)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityText)
    }

    // MARK: - Pieces

    private var emblem: some View {
        ZStack {
            Circle()
                .fill(isUnlocked ? achievement.tier.tint.opacity(0.16)
                                 : Color.gray.opacity(0.12))
                .frame(width: 60, height: 60)
            Text(achievement.emoji)
                .font(.system(size: 32))
                .grayscale(isUnlocked ? 0 : 1)
                .opacity(isUnlocked ? 1 : 0.5)
                .accessibilityHidden(true)
            if !isUnlocked {
                Image(systemName: SFSymbolCompat.name("lock.fill"))
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    .padding(DesignTokens.Spacing.xs)
                    .background(Circle().fill(Color(NSColor.controlBackgroundColor)))
                    .offset(x: 20, y: 20)
                    .accessibilityHidden(true)
            }
        }
    }

    @ViewBuilder
    private var caption: some View {
        if isUnlocked {
            Text(unlockDate.map { "Earned \(Self.dateFormatter.string(from: $0))" }
                 ?? achievement.tier.displayName)
                .font(.caption2)
                .foregroundColor(achievement.tier.tint)
                .lineLimit(1)
        } else {
            VStack(spacing: DesignTokens.Spacing.xs) {
                ProgressView(value: progress.fraction)
                    .frame(maxWidth: 90)
                Text("\(progress.current) / \(progress.target)")
                    .font(.caption2.monospacedDigit())
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
            }
        }
    }

    private var accessibilityText: String {
        if isUnlocked {
            let when = unlockDate.map { " Earned \(Self.dateFormatter.string(from: $0))." } ?? ""
            return "\(achievement.title), \(achievement.tier.displayName) tier, unlocked.\(when)"
        }
        return "\(achievement.title), locked. \(achievement.detail) Progress \(progress.current) of \(progress.target)."
    }
}
