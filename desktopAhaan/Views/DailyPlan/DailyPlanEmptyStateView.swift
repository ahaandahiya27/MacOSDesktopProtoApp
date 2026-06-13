import SwiftUI

/// Day-one empty state for the Daily Plan: shown when the kid has nothing due,
/// nothing visited today, and no Discover scene in progress — i.e. there's no
/// history to build a plan from yet. Instead of a blank list, it greets them
/// and points at a concrete first step (Science Chapter 1).
///
/// Self-contained (no DataStore reads) so it renders from any state without a
/// crash — the "should I show this?" decision lives in `DailyPlanView`.
///
/// `@MainActor` — hosted in the Daily Plan window on the main thread.
@MainActor
struct DailyPlanEmptyStateView: View {
    /// Opens the day-one starting point (Science Chapter 1).
    var onStart: (() -> Void)?

    var body: some View {
        VStack(spacing: 14) {
            Text("📚")
                .font(.system(size: 52))
                .accessibilityHidden(true)
            Text("Welcome! Let's start with Science Chapter 1.")
                .font(.title3.weight(.semibold))
                .foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center)
            Text("Your daily plan fills up as you read concepts and answer questions. Open the first chapter to get going — it only takes a few minutes.")
                .font(.body)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 380)
            Button("Open Science Chapter 1") { onStart?() }
                .keyboardShortcut(.defaultAction)
                .accessibilityLabel("Open Science Chapter 1")
                .accessibilityHint("Starts your first Science chapter to begin building a daily plan")
                .accessibilityIdentifier("daily-plan-day-one-start")
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 28)
    }
}
