import SwiftUI
import AppKit

// MARK: - WelcomeTourSheet
//
// Three-panel guided tour shown ONCE on first launch (gated on
// `AppStorageKeys.hasSeenWelcomeTour`). Re-launchable from
// Help → "Show Welcome Tour".
//
// Why this exists:
//   - The DeepDive disclosure, the audio narration with per-paragraph
//     highlight, and the chapter Discover Mode all ship — but the kid
//     has to wander into them. The tour points at each in plain
//     language so they don't sit dark for weeks.
//
// Big Sur compat:
//   - No TabView(.page). macOS 11's TabView doesn't have a paging
//     style; we roll a switch-based panel + Prev/Next/Done buttons.
//   - No `Layout`, no `@Observable`, no `.scrollPosition` — pure
//     macOS 10.15+ surface.
//   - All page transitions go through `respectReduceMotion`.

struct WelcomeTourSheet: View {
    var onDismiss: () -> Void

    @State private var panelIndex: Int = 0

    private static let panelCount = 4

    var body: some View {
        VStack(spacing: 0) {
            panelContent
            Divider()
            footerBar
        }
        .frame(minWidth: 520, idealWidth: 600, maxWidth: 700,
               minHeight: 440, idealHeight: 500, maxHeight: 620)
        .background(Color(NSColor.windowBackgroundColor))
        // Esc/⌘W close — invisible cancelAction button pattern.
        .background(
            Button("Dismiss", action: onDismiss)
                .keyboardShortcut(.cancelAction)
                .opacity(0)
                .frame(width: 0, height: 0)
                .accessibilityHidden(true)
        )
    }

    /// Switch-style pager — Big Sur's TabView lacks the .page style,
    /// so we render exactly one panel based on `panelIndex` and
    /// re-render on Prev/Next.
    @ViewBuilder
    private var panelContent: some View {
        switch panelIndex {
        case 0: panelDiscover
        case 1: panelDeepDive
        case 2: panelReadAloud
        default: panelDailyPractice
        }
    }

    // MARK: - Panel 1: Discover Mode

    private var panelDiscover: some View {
        WelcomeTourPanel(
            stepNumber: 1,
            heroSymbol: "sparkles",
            heroTint: .compatTeal,
            title: "Start with Discover Mode",
            subtitle: "Every chapter has a free-form, illustrated Discover Mode — drag, tap, and explore the concept before the textbook view.",
            bullets: [
                "Tap the green **Try Discover Mode** banner at the top of any chapter.",
                "Each chapter has 9–20 scenes — including a final boss quiz that scores you out of N.",
                "Scenes are paced so you can leave halfway and come back — your progress is saved."
            ]
        )
    }

    // MARK: - Panel 2: Deep Dive disclosure

    private var panelDeepDive: some View {
        WelcomeTourPanel(
            stepNumber: 2,
            heroSymbol: "arrow.up.right.circle.fill",
            heroTint: .compatIndigo,
            title: "Tap 'Go deeper' once you've grasped the basics",
            subtitle: "At the bottom of every chapter detail page is a 'Go deeper' disclosure — three grade-tagged stretch topics that show how this Class 7 idea grows in Class 8, 9, 10, 11 / 12, or NEET / JEE.",
            bullets: [
                "Each stretch topic carries a grade badge — Class 8, Class 9, Class 10, …",
                "Tap a row to see the full body + bonus questions with worked answers.",
                "The 'NEW' pill on the disclosure stops showing after you've opened it a few times — it's not permanent."
            ]
        )
    }

    // MARK: - Panel 3: Read aloud with paragraph highlight

    private var panelReadAloud: some View {
        WelcomeTourPanel(
            stepNumber: 3,
            heroSymbol: "speaker.wave.2.fill",
            heroTint: .compatCyan,
            title: "Have the article read aloud — words highlight as the audio plays",
            subtitle: "Inside Beyond-the-Book articles, tap the speaker icon to start paragraph-by-paragraph narration. The paragraph being read is highlighted and scrolled into view automatically.",
            bullets: [
                "Tap the speaker icon to start. Tap again to pause; tap once more to resume.",
                "The highlight follows the audio in real time so you can read along.",
                "Use Reduce Motion in System Settings if the highlight transition feels distracting — the app respects that."
            ]
        )
    }

    // MARK: - Panel 4: Daily Practice + My Progress

    /// Spaced-repetition + mastery dashboard surfaces. Pointed out
    /// last because by the time the kid has answered any practice
    /// questions, Daily Practice has something to show — earlier in
    /// the tour it'd land on an empty queue.
    private var panelDailyPractice: some View {
        WelcomeTourPanel(
            stepNumber: 4,
            heroSymbol: "flame.fill",
            heroTint: .orange,
            title: "Daily Practice queues up what you're about to forget",
            subtitle: "The app remembers every question you answer and shows you each one again just before you'd forget it. A few minutes a day beats an hour the night before.",
            bullets: [
                "**Daily Practice** in the sidebar shows the questions due for review today.",
                "**My Progress** in the sidebar shows per-chapter mastery — how many questions you're learning, familiar with, confident on, or have mastered.",
                "The orange badge on Daily Practice tells you when reviews are waiting."
            ]
        )
    }

    /// Footer with progress dots + Prev / Next-or-Done buttons.
    private var footerBar: some View {
        HStack(spacing: 14) {
            progressDots
            Spacer()
            Button("Previous") {
                advancePanel(by: -1)
            }
            .disabled(panelIndex == 0)
            .accessibilityHint(panelIndex == 0 ? "First step — no previous step." : "Goes back one step in the welcome tour.")

            Button(isLastPanel ? "Done" : "Next") {
                if isLastPanel {
                    onDismiss()
                } else {
                    advancePanel(by: +1)
                }
            }
            .keyboardShortcut(.defaultAction)
            .accessibilityIdentifier("welcome-tour-primary")
            .accessibilityLabel(isLastPanel ? "Done" : "Next")
            .accessibilityHint(isLastPanel ? "Closes the welcome tour. You can replay it from Help → Show Welcome Tour." : "Goes to the next step in the welcome tour.")
        }
        .padding(.horizontal, 22)
        .padding(.vertical, DesignTokens.Spacing.md)
    }

    private var progressDots: some View {
        HStack(spacing: 7) {
            ForEach(0..<Self.panelCount, id: \.self) { idx in
                Circle()
                    .fill(idx == panelIndex ? Color.compatIndigo : Color.secondary.opacity(0.4))
                    .frame(width: 8, height: 8)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Step \(panelIndex + 1) of \(Self.panelCount).")
    }

    private var isLastPanel: Bool { panelIndex >= Self.panelCount - 1 }

    private func advancePanel(by delta: Int) {
        let next = max(0, min(Self.panelCount - 1, panelIndex + delta))
        withAnimationRespectingReduceMotion(.easeInOut(duration: 0.2)) {
            panelIndex = next
        }
    }
}

// MARK: - WelcomeTourPanel (one panel layout)

/// Static layout for one tour panel. Kept private so the structure
/// stays inside `WelcomeTourSheet`'s file and the @ViewBuilder
/// direct-child cap is easy to reason about.
private struct WelcomeTourPanel: View {
    let stepNumber: Int
    let heroSymbol: String
    let heroTint: Color
    let title: String
    let subtitle: String
    let bullets: [String]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                heroBlock
                Text(title)
                    .font(.title2.bold())
                    .fixedSize(horizontal: false, vertical: true)
                Text(subtitle)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
                bulletList
            }
            .padding(.horizontal, 28)
            .padding(.top, 28)
            .padding(.bottom, 22)
        }
    }

    /// Hero icon + step badge. SF Symbols are routed through
    /// SFSymbolCompat so a Big Sur user gets a sensible fallback when
    /// the symbol is SF Symbols 3+.
    private var heroBlock: some View {
        HStack(alignment: .center, spacing: 14) {
            Image(systemName: SFSymbolCompat.name(heroSymbol))
                .font(.system(size: 38, weight: .semibold))
                .foregroundColor(heroTint)
                .frame(width: 56, height: 56)
                .background(
                    Circle().fill(heroTint.opacity(0.15))
                )
                .accessibilityHidden(true)
            Text("Step \(stepNumber)")
                .font(.caption.weight(.bold))
                .foregroundColor(.white)
                .padding(.horizontal, 10)
                .padding(.vertical, DesignTokens.Spacing.xs)
                .background(
                    Capsule().fill(heroTint)
                )
                .accessibilityHidden(true)
            Spacer()
        }
    }

    /// Bullets list — each row reads as a separate VoiceOver element
    /// so users can navigate between tips with the rotor.
    private var bulletList: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(bullets, id: \.self) { bullet in
                HStack(alignment: .top, spacing: 10) {
                    Text("•")
                        .font(.body.weight(.bold))
                        .foregroundColor(.secondary)
                        .accessibilityHidden(true)
                    Text(bullet)
                        .font(.callout)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }
}
