import SwiftUI
import AppKit

// MARK: - WhatsNewSheet
//
// "What's New" sheet shown once after a version bump, gated on
// `AppStorageKeys.whatsNewLastSeenVersion`. Re-launchable from
// Help → "What's New".
//
// The release notes list is hard-coded below (`Self.entries`) rather
// than fetched — desktopAhaan ships offline-first and the notes need
// to land WITH the build that introduced the feature anyway.
//
// Big Sur compat: ScrollView + VStack only.

struct WhatsNewSheet: View {
    var onDismiss: () -> Void

    /// Current app version — `CFBundleShortVersionString`. Used both
    /// to head the sheet and to advance the "last seen" pointer on
    /// dismiss.
    static var currentVersion: String {
        (Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String) ?? "1.0"
    }

    var body: some View {
        VStack(spacing: 0) {
            header
            Divider()
            ScrollView {
                content
                    .padding(.horizontal, 24)
                    .padding(.vertical, 18)
                    .frame(maxWidth: 700, alignment: .leading)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            Divider()
            footerBar
        }
        .frame(minWidth: 520, idealWidth: 620, maxWidth: 760,
               minHeight: 420, idealHeight: 540, maxHeight: 720)
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
            Image(systemName: SFSymbolCompat.name("sparkles"))
                .font(.title)
                .foregroundColor(Color.compatIndigo)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 4) {
                Text("What's New")
                    .font(.title2.bold())
                Text("Version \(Self.currentVersion)")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.secondary)
            }
            Spacer()
            Button(action: onDismiss) {
                Image(systemName: "xmark.circle.fill")
                    .font(.title3)
                    .foregroundColor(.secondary)
            }
            .buttonStyle(.plain)
            .pointingCursor()
            .accessibilityLabel("Close What's New")
            .accessibilityHint("Closes the sheet and marks this version as seen.")
        }
        .padding(.horizontal, 24)
        .padding(.top, 20)
        .padding(.bottom, 14)
    }

    private var content: some View {
        VStack(alignment: .leading, spacing: 24) {
            ForEach(Self.entries) { entry in
                WhatsNewEntryView(entry: entry)
            }
        }
    }

    private var footerBar: some View {
        HStack {
            Spacer()
            Button("Done", action: onDismiss)
                .keyboardShortcut(.defaultAction)
                .accessibilityIdentifier("whats-new-done")
                .accessibilityLabel("Done")
                .accessibilityHint("Closes the sheet. You can replay it from Help → What's New.")
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
    }

    // MARK: - Release notes table

    /// What's-new entries, newest first. Keep this list pruned —
    /// older versions can drop off once they're not really "new"
    /// anymore (rule of thumb: keep last 3 versions, or all of them
    /// while the app is on 1.x and shipping a feature a month).
    static let entries: [WhatsNewEntry] = [
        WhatsNewEntry(
            id: "1.0-deep-dive",
            heading: "Go deeper — grade-tagged stretch topics",
            body: "Every chapter detail page now has a Go deeper disclosure at the bottom. Three stretch topics per chapter, each tagged Class 8 through NEET / JEE, with worked bonus questions and a next-step hint.",
            symbol: "arrow.up.right.circle.fill",
            tint: .compatIndigo
        ),
        WhatsNewEntry(
            id: "1.0-audio",
            heading: "Read articles aloud with paragraph highlight",
            body: "Inside any Beyond-the-Book article, tap the speaker icon to start paragraph-by-paragraph narration. The paragraph being read is highlighted and scrolled into view automatically. Respects the system Reduce Motion preference.",
            symbol: "speaker.wave.2.fill",
            tint: .compatCyan
        ),
        WhatsNewEntry(
            id: "1.0-quiz-variety",
            heading: "More variety in the Quiz Bank",
            body: "Match-the-following question type now has dedicated rendering, with each chapter populated to a deeper question floor. Difficulty badges across all questions help you pick recall vs. evaluate-style problems.",
            symbol: "list.bullet.clipboard.fill",
            tint: .compatTeal
        ),
        WhatsNewEntry(
            id: "1.0-help-menu",
            heading: "New Help menu entries",
            body: "Help → Show Welcome Tour replays the 3-panel first-launch tour. Help → About Deep Dive Mode and About Audio Narration explain those features in plain language for parents.",
            symbol: "questionmark.circle.fill",
            tint: .compatPurple
        )
    ]
}

// MARK: - WhatsNewEntry

struct WhatsNewEntry: Identifiable, Hashable {
    let id: String
    let heading: String
    let body: String
    let symbol: String
    let tint: Color
}

// MARK: - WhatsNewEntryView

private struct WhatsNewEntryView: View {
    let entry: WhatsNewEntry

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: SFSymbolCompat.name(entry.symbol))
                .font(.title3)
                .foregroundColor(entry.tint)
                .frame(width: 32, height: 32)
                .background(
                    Circle().fill(entry.tint.opacity(0.15))
                )
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 6) {
                Text(entry.heading)
                    .font(.body.weight(.semibold))
                    .accessibilityAddTraits(.isHeader)
                Text(entry.body)
                    .font(.callout)
                    .foregroundColor(.secondary)
                    .lineSpacing(3)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .accessibilityElement(children: .combine)
    }
}
