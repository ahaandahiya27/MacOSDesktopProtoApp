import SwiftUI
import AppKit

// MARK: - FeatureExplainerSheet
//
// One-screen explainer sheet for a single feature. Used by the Help
// menu entries:
//
//   • Help → About Deep Dive Mode    → FeatureExplainerSheet.aboutDeepDive
//   • Help → About Audio Narration   → FeatureExplainerSheet.aboutAudio
//
// Both are small, parent-friendly explainers. Distinct from
// `WelcomeTourSheet` (multi-step) and `WhatsNewSheet` (release notes).
//
// Big Sur compat: ScrollView + VStack only.

struct FeatureExplainerSheet: View {
    let title: String
    let subtitle: String
    let symbol: String
    let tint: Color
    /// One-paragraph body per bullet point; rendered in order.
    let paragraphs: [String]
    /// "How to find it" line — concrete pointer to the surface.
    let howToFindIt: String
    var onDismiss: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            header
            Divider()
            ScrollView {
                content
                    .padding(.horizontal, DesignTokens.Spacing.xl)
                    .padding(.vertical, 18)
                    .frame(maxWidth: 640, alignment: .leading)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            Divider()
            footer
        }
        .frame(minWidth: 520, idealWidth: 600, maxWidth: 720,
               minHeight: 380, idealHeight: 480, maxHeight: 640)
        .background(Color(NSColor.windowBackgroundColor))
        .background(
            Button("Dismiss", action: onDismiss)
                .keyboardShortcut(.cancelAction)
                .opacity(0)
                .frame(width: 0, height: 0)
                .accessibilityHidden(true)
        )
    }

    private var header: some View {
        HStack(alignment: .center, spacing: 14) {
            Image(systemName: SFSymbolCompat.name(symbol))
                .font(.title)
                .foregroundColor(tint)
                .frame(width: 44, height: 44)
                .background(
                    Circle().fill(tint.opacity(0.15))
                )
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.title2.bold())
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
        }
        .padding(.horizontal, DesignTokens.Spacing.xl)
        .padding(.top, 20)
        .padding(.bottom, 14)
    }

    private var content: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.lg) {
            ForEach(paragraphs.indices, id: \.self) { idx in
                Text(paragraphs[idx])
                    .font(.body)
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
            }
            howToFindBlock
        }
    }

    private var howToFindBlock: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "location.circle.fill")
                .font(.body)
                .foregroundColor(tint)
                .accessibilityHidden(true)
            Text(howToFindIt)
                .font(.callout.weight(.semibold))
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(DesignTokens.Spacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
                .fill(tint.opacity(0.08))
        )
        .padding(.top, 6)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("How to find it: \(howToFindIt)")
    }

    private var footer: some View {
        HStack {
            Spacer()
            Button("Done", action: onDismiss)
                .keyboardShortcut(.defaultAction)
                .accessibilityIdentifier("feature-explainer-done")
        }
        .padding(.horizontal, DesignTokens.Spacing.xl)
        .padding(.vertical, DesignTokens.Spacing.md)
    }
}

// MARK: - Factories for the two shipped explainers

extension FeatureExplainerSheet {
    /// "About Deep Dive Mode" — what stretch topics are, how grade
    /// badges work, why Class-7-level kids see Class-8-through-NEET
    /// content tagged.
    static func aboutDeepDive(onDismiss: @escaping () -> Void) -> FeatureExplainerSheet {
        FeatureExplainerSheet(
            title: "About Deep Dive Mode",
            subtitle: "Grade-tagged stretch topics for fast learners.",
            symbol: "arrow.up.right.circle.fill",
            tint: .compatIndigo,
            paragraphs: [
                "Every chapter has three stretch topics that extend a Class-7 concept into Class 8, 9, 10, 11 / 12, or NEET / JEE territory. They live behind a 'Go deeper' disclosure at the bottom of the chapter detail page — folded by default so the standard topic flow stays uncluttered.",
                "Each stretch topic is tagged with a grade-level badge (Class 8 / Class 9 / …). The badge color follows the same palette as the rest of the app — blue for Class 8, teal for Class 9, cyan for Class 10, indigo for Class 11 / 12, purple for NEET / JEE.",
                "Tap a stretch topic to open its detail sheet — the full 120–250 word body, optional bonus questions with worked answers, and a one-line 'where this goes next' hint pointing the kid at the right next chapter or class.",
                "The 'NEW' pill on the disclosure stops showing after the kid has opened the disclosure a few times. After that the feature stands on its own."
            ],
            howToFindIt: "Open any chapter from Science → Class 7 → Chapter N. Scroll to the bottom of the detail page; the 'Go deeper' disclosure is the last block.",
            onDismiss: onDismiss
        )
    }

    /// "About Daily Practice" — what spaced repetition is, how the
    /// queue grows, and where mastery shows up. Kid-friendly framing
    /// (no "SuperMemo / SM-2" jargon).
    static func aboutDailyPractice(onDismiss: @escaping () -> Void) -> FeatureExplainerSheet {
        FeatureExplainerSheet(
            title: "About Daily Practice",
            subtitle: "How the app remembers what you're about to forget.",
            symbol: "flame.fill",
            tint: .orange,
            paragraphs: [
                "Every time you answer a practice question — or hit the 'Tough — review later' button on one — the app schedules that question for a future review. Get it right and the gap widens (1 day → 3 days → 7 → 14 → 21+). Get it wrong and it bounces back inside 10 minutes so the right answer sinks in.",
                "Daily Practice in the sidebar shows what's due today. A 5-minute session is usually enough — answer each card, hit Forgot / Hard / Good / Easy, and the scheduler does the rest. The orange badge tells you how many cards are waiting; when there are none, you're all caught up.",
                "My Progress in the sidebar shows where each chapter sits — how many questions are still in Learning, Familiar, Confident, or Mastered. A question only counts as Mastered once its review gap has stretched to 21 days or more, so you can't fake it by clicking Easy a few times in a row.",
                "Practising a little every day is how brains actually learn. The streak counter is a nudge, not a grade — it resets if you skip a day, but the underlying mastery state never resets. You won't lose progress by missing a day; you just won't gain a new one."
            ],
            howToFindIt: "Open the sidebar. Daily Practice (⌘⇧P) sits between Bookmarks and My Progress; My Progress (⌘⇧M) is right below it.",
            onDismiss: onDismiss
        )
    }

    /// "About Audio Narration" — what paragraph-highlight does, how
    /// to start / pause / step through, and the Reduce-Motion note.
    static func aboutAudio(onDismiss: @escaping () -> Void) -> FeatureExplainerSheet {
        FeatureExplainerSheet(
            title: "About Audio Narration",
            subtitle: "Read articles aloud with paragraph-by-paragraph highlight.",
            symbol: "speaker.wave.2.fill",
            tint: .compatCyan,
            paragraphs: [
                "Inside any Beyond-the-Book enrichment article, the toolbar shows a small speaker icon. Tap it to start narration — the system voice reads the article paragraph-by-paragraph.",
                "The paragraph currently being read is highlighted, and the view scrolls automatically so the highlight stays in sight. Tap the speaker once to pause; tap again to resume from the same place.",
                "Narration uses the system Text-to-Speech voice configured in macOS System Settings → Accessibility → Spoken Content. Change voice or rate there.",
                "The highlight transition respects the system Reduce Motion preference. If Reduce Motion is on the highlight jumps instantly rather than animating — same source of truth as the rest of the app."
            ],
            howToFindIt: "Open Science → any chapter → Beyond the Book card. The speaker icon sits in the article toolbar, top-right.",
            onDismiss: onDismiss
        )
    }
}
