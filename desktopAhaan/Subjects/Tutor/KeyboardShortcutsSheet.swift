import SwiftUI

/// One-page reference for every app-level keyboard shortcut. Opens via
/// ⌘/ from anywhere in the app (wired in desktopAhaanApp.swift).
struct KeyboardShortcutsSheet: View {
    var onDismiss: () -> Void

    private struct Shortcut: Identifiable {
        let id = UUID()
        let combo: String
        let description: String
    }

    private struct Group: Identifiable {
        let id = UUID()
        let title: String
        let shortcuts: [Shortcut]
    }

    private let groups: [Group] = [
        Group(title: "Navigation", shortcuts: [
            Shortcut(combo: "⌘K",        description: "Jump to anything (command palette)"),
            Shortcut(combo: "⌘[",        description: "Go back"),
            Shortcut(combo: "⌘⇧[",       description: "Back to subject home"),
            Shortcut(combo: "⌘←",        description: "Previous question (also bare ←)"),
            Shortcut(combo: "⌘→",        description: "Next question (also bare →)"),
            Shortcut(combo: "⌘F",        description: "Search across all subjects"),
        ]),
        Group(title: "Question detail", shortcuts: [
            Shortcut(combo: "Return",    description: "Check answer"),
            Shortcut(combo: "Space",     description: "I get it! (Discover scenes)"),
        ]),
        Group(title: "Discover Mode", shortcuts: [
            Shortcut(combo: "←  →",      description: "Previous / next scene"),
            Shortcut(combo: "⌘1..⌘9",   description: "Jump to scene N in the current chapter"),
        ]),
        Group(title: "Concept detail", shortcuts: [
            Shortcut(combo: "⌘B",        description: "Bookmark / unbookmark this concept"),
        ]),
        Group(title: "Translator", shortcuts: [
            Shortcut(combo: "⌘O",        description: "Open image for OCR"),
            Shortcut(combo: "⌘↩",        description: "Translate now"),
            Shortcut(combo: "⌘⇧C",       description: "Copy translation"),
            Shortcut(combo: "⌘⇧S",       description: "Speak result"),
        ]),
        Group(title: "Help", shortcuts: [
            Shortcut(combo: "⌘/",        description: "Show this cheat sheet"),
        ]),
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Label("Keyboard shortcuts", systemImage: "keyboard")
                    .font(.title2.bold())
                Spacer()
                Button("Done", action: onDismiss)
                    .keyboardShortcut(.cancelAction)
                    .accessibilityIdentifier("keyboard-shortcuts-done")
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, DesignTokens.Spacing.md)

            Divider()

            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    ForEach(groups) { group in
                        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                            Text(group.title)
                                .font(.caption.weight(.semibold))
                                .foregroundColor(.secondary)
                                .textCase(.uppercase)
                            ForEach(group.shortcuts) { sc in
                                HStack(alignment: .firstTextBaseline, spacing: 14) {
                                    Text(sc.combo)
                                        .font(.system(.callout, design: .monospaced).bold())
                                        .frame(width: 90, alignment: .leading)
                                        .foregroundColor(Color.compatIndigo)
                                    Text(sc.description)
                                        .font(.callout)
                                    Spacer(minLength: 0)
                                }
                                // VoiceOver default reads the chip as
                                // verbatim characters ("command shift
                                // left bracket"), which is noisy AND
                                // loses the description's intent. Combine
                                // the row into one element with the
                                // description as the label and the chip
                                // as the value — VoiceOver then says
                                // "Jump to anything, Keyboard shortcut:
                                // ⌘K." cleanly.
                                .accessibilityElement(children: .ignore)
                                .accessibilityLabel(sc.description)
                                .accessibilityValue("Keyboard shortcut: \(sc.combo)")
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, DesignTokens.Spacing.lg)
            }
        }
        .frame(minWidth: 460, idealWidth: 520, maxWidth: 600,
               minHeight: 420, idealHeight: 560, maxHeight: 720)
    }
}
