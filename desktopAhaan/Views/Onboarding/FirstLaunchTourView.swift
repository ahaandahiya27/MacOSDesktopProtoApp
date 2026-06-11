import SwiftUI

// MARK: - FirstLaunchTourView
//
// The 4-page "fresh install" welcome shown ONCE the first time the app is
// opened on a new Mac. Data-driven by `OnboardingStep.tour`; this view is a
// thin, declarative renderer so the page set stays unit-testable without a
// running window (see OnboardingFirstLaunchTests / OnboardingSkipTests).
//
// Flow:
//   - Page 1  Welcome + one-line pitch.
//   - Page 2  Three subjects (Science / Maths / Sanskrit) with blurbs.
//   - Page 3  Daily Practice / spaced-repetition in kid-friendly terms.
//   - Page 4  Get started — primary CTA opens Science Ch.1.
//
// Every page has a Skip button (top-right). The last page swaps "Next" for
// the CTA. Both Skip and finishing the tour flip
// `OnboardingState.hasSeenOnboarding` via the closures the presenter passes
// in — this view itself owns no persistence so tests can drive it directly.
//
// Big Sur compatibility (deploy target 11.5):
//   - No NavigationStack, no TabView(.page) (absent on macOS 11), no
//     @Observable / Bindable / .foregroundStyle / Layout. Pure macOS 10.15+
//     surface — a switch-based pager like the legacy WelcomeTourSheet.
//   - SF Symbol names routed through SFSymbolCompat.name(_:) so SF Symbols 3+
//     glyphs get a sensible Big Sur (SF Symbols 2) fallback.
//   - Page transitions go through withAnimationRespectingReduceMotion.

struct FirstLaunchTourView: View {
    /// The pages to render, in presentation order. Injectable so a test can
    /// pass a shorter deck; defaults to the canonical 4-page tour.
    var steps: [OnboardingStep] = OnboardingStep.tour

    /// Called when the tour is dismissed WITHOUT taking the final CTA — i.e.
    /// Skip on any page, or "Done"-style close. The presenter flips the
    /// hasSeenOnboarding flag and dismisses.
    var onClose: () -> Void

    /// Called when the final-page CTA ("Open Science Ch.1") is tapped. The
    /// presenter navigates to the science pack AND flips the flag + dismisses.
    var onGetStarted: () -> Void

    @State private var pageIndex: Int = 0

    var body: some View {
        VStack(spacing: 0) {
            topBar
            Divider()
            pageContent
            Divider()
            footerBar
        }
        .frame(minWidth: 520, idealWidth: 600, maxWidth: 700,
               minHeight: 460, idealHeight: 520, maxHeight: 640)
        .background(Color(NSColor.windowBackgroundColor))
        // Esc closes the tour (counts as skip) — invisible cancelAction button.
        .background(
            Button("Skip", action: onClose)
                .keyboardShortcut(.cancelAction)
                .opacity(0)
                .frame(width: 0, height: 0)
                .accessibilityHidden(true)
        )
    }

    // MARK: - Top bar (Skip)

    private var topBar: some View {
        HStack {
            Spacer()
            Button("Skip", action: onClose)
                .buttonStyle(.borderless)
                .foregroundColor(.secondary)
                .accessibilityIdentifier("onboarding-skip")
                .accessibilityHint("Closes the welcome tour. You can replay it any time from Help → Show Welcome Tour.")
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 10)
    }

    // MARK: - Page content (switch-based pager — Big Sur has no TabView(.page))

    @ViewBuilder
    private var pageContent: some View {
        if let step = currentStep {
            OnboardingPageView(step: step)
        } else {
            // Defensive: an empty deck shouldn't happen (tour is a static
            // non-empty constant), but render nothing rather than crash.
            Spacer()
        }
    }

    // MARK: - Footer (progress dots + Previous / Next-or-CTA)

    private var footerBar: some View {
        HStack(spacing: 14) {
            progressDots
            Spacer()
            Button("Previous") { advance(by: -1) }
                .disabled(pageIndex == 0)
                .accessibilityHint(pageIndex == 0 ? "First page — no previous page." : "Goes back one page.")
            primaryButton
        }
        .padding(.horizontal, 22)
        .padding(.vertical, DesignTokens.Spacing.md)
    }

    /// On the last page this is the CTA (e.g. "Open Science Ch.1"); on every
    /// earlier page it's "Next".
    private var primaryButton: some View {
        Button(primaryLabel) {
            if isLastPage {
                onGetStarted()
            } else {
                advance(by: +1)
            }
        }
        .keyboardShortcut(.defaultAction)
        .accessibilityIdentifier("onboarding-primary")
        .accessibilityLabel(primaryLabel)
        .accessibilityHint(isLastPage ? "Opens Science Chapter 1 and closes the tour." : "Goes to the next page.")
    }

    private var progressDots: some View {
        HStack(spacing: 7) {
            ForEach(0..<steps.count, id: \.self) { idx in
                Circle()
                    .fill(idx == pageIndex ? Color.compatIndigo : Color.secondary.opacity(0.4))
                    .frame(width: 8, height: 8)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Page \(pageIndex + 1) of \(steps.count).")
    }

    // MARK: - Derived state

    private var currentStep: OnboardingStep? {
        guard pageIndex >= 0 && pageIndex < steps.count else { return nil }
        return steps[pageIndex]
    }

    private var isLastPage: Bool { pageIndex >= steps.count - 1 }

    /// "Next" on intermediate pages; the final page's `primaryCTA` (or a
    /// generic "Get started" if a deck omits it) on the last page.
    private var primaryLabel: String {
        if isLastPage {
            return currentStep?.primaryCTA ?? "Get started"
        }
        return "Next"
    }

    private func advance(by delta: Int) {
        let next = max(0, min(steps.count - 1, pageIndex + delta))
        withAnimationRespectingReduceMotion(.easeInOut(duration: 0.2)) {
            pageIndex = next
        }
    }
}

// MARK: - OnboardingPageView (one page layout)

/// Static layout for one onboarding page. Private so the structure stays in
/// this file and the @ViewBuilder direct-child cap stays easy to reason about.
private struct OnboardingPageView: View {
    let step: OnboardingStep

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                hero
                Text(step.title)
                    .font(.title.bold())
                    .fixedSize(horizontal: false, vertical: true)
                Text(step.message)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
                subjectsList
            }
            .padding(.horizontal, 30)
            .padding(.top, 26)
            .padding(.bottom, DesignTokens.Spacing.xl)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    /// Centered hero glyph in a tinted disc. SF Symbol routed through
    /// SFSymbolCompat for a Big Sur fallback.
    private var hero: some View {
        HStack {
            Spacer()
            Image(systemName: SFSymbolCompat.name(step.symbol))
                .font(.system(size: 46, weight: .semibold))
                .foregroundColor(.compatIndigo)
                .frame(width: 84, height: 84)
                .background(Circle().fill(Color.compatIndigo.opacity(0.15)))
                .accessibilityHidden(true)
            Spacer()
        }
        .padding(.bottom, DesignTokens.Spacing.xxs)
    }

    /// Subject rows — only present on page 2. Renders nothing otherwise.
    @ViewBuilder
    private var subjectsList: some View {
        if !step.subjects.isEmpty {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
                ForEach(step.subjects) { subject in
                    SubjectRowView(subject: subject)
                }
            }
            .padding(.top, DesignTokens.Spacing.xxs)
        }
    }
}

// MARK: - SubjectRowView (one subject blurb on page 2)

private struct SubjectRowView: View {
    let subject: OnboardingStep.SubjectBlurb

    var body: some View {
        HStack(alignment: .top, spacing: DesignTokens.Spacing.md) {
            Text(subject.emoji)
                .font(.system(size: 26))
                .frame(width: 36)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.xxs) {
                Text(subject.name)
                    .font(.headline)
                Text(subject.blurb)
                    .font(.callout)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(subject.name). \(subject.blurb)")
    }
}
