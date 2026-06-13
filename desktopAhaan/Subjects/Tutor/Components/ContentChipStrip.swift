import SwiftUI
import AppKit

// MARK: - ContentChipStrip
//
// Horizontal scrolling row of small "chip" pills, each a tap target
// that surfaces a detail popover. Used by:
//
//   • Real-world examples — chip per example, popover shows the 60–100
//     word body.
//   • Mnemonics — chip per mnemonic, popover shows the mnemonic + how
//     to unpack it.
//   • Cross-chapter refs — chip per cross-ref, popover offers to jump
//     to the target chapter.
//
// Big Sur compatibility:
//   - `ScrollView(.horizontal)` is macOS 10.15+ ✅
//   - Pure `Color.compat*` tokens.
//   - Reduce-Motion-gated chip hover.
//
// Each chip's label is short (≤ 36 chars after truncation); the popover
// surfaces the full detail string and any optional action.

struct ContentChipStripItem: Identifiable {
    let id: String
    let label: String
    /// Long-form text shown when the chip is tapped. May be multi-paragraph.
    let detail: String
    /// Optional action button text and handler. When non-nil the popover
    /// shows a button beneath the body — useful for "Jump to chapter"
    /// kinds of follow-ups.
    /// (Not Hashable because of this closure — Identifiable alone is
    /// enough for ForEach and sheet(item:).)
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil
}

struct ContentChipStrip: View {
    let title: String?
    let items: [ContentChipStripItem]
    let tint: Color

    init(title: String? = nil, items: [ContentChipStripItem], tint: Color = .compatTeal) {
        self.title = title
        self.items = items
        self.tint = tint
    }

    @State private var presentedItem: ContentChipStripItem?

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            if let t = title, !t.isEmpty {
                Text(t)
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)
                    .accessibilityAddTraits(.isHeader)
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: DesignTokens.Spacing.sm) {
                    ForEach(items) { item in
                        ChipButton(item: item, tint: tint) {
                            presentedItem = item
                        }
                    }
                }
                .padding(.vertical, DesignTokens.Spacing.xs)
            }
        }
        .sheet(item: $presentedItem) { item in
            ChipDetailSheet(
                item: item,
                tint: tint,
                onDismiss: { presentedItem = nil }
            )
        }
    }
}

// MARK: - ChipButton

private struct ChipButton: View {
    let item: ContentChipStripItem
    let tint: Color
    let onTap: () -> Void

    @State private var isHovered = false

    var body: some View {
        Button(action: onTap) {
            Text(item.label)
                .font(.caption.weight(.semibold))
                .foregroundColor(.primary)
                .lineLimit(1)
                .truncationMode(.tail)
                .padding(.horizontal, DesignTokens.Spacing.md)
                .padding(.vertical, 6)
                .background(
                    Capsule().fill(tint.opacity(isHovered ? 0.30 : 0.20))
                )
                .overlay(
                    Capsule().strokeBorder(tint.opacity(0.45), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
        .pointingCursor()
        .onHover { hovering in
            // Reduce-Motion gate on the hover-color shift — opacity
            // alone isn't motion strictly, but combined with the
            // background change it reads as one. Skip when RM is on.
            isHovered = hovering && !NSWorkspace.shared.accessibilityDisplayShouldReduceMotion
        }
        .accessibilityLabel(item.label)
        .accessibilityHint("Opens the detail.")
    }
}

// MARK: - ChipDetailSheet

private struct ChipDetailSheet: View {
    let item: ContentChipStripItem
    let tint: Color
    let onDismiss: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            header
            Divider()
            ScrollView {
                Text(item.detail)
                    .font(.body)
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: 560, alignment: .leading)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.horizontal, DesignTokens.Spacing.xl)
                    .padding(.vertical, 18)
            }
            Divider()
            footer
        }
        .frame(minWidth: 460, idealWidth: 560, maxWidth: 700,
               minHeight: 280, idealHeight: 380, maxHeight: 560)
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
        HStack(spacing: 10) {
            Text(item.label)
                .font(.title3.bold())
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
            Spacer(minLength: 0)
            Button(action: onDismiss) {
                Image(systemName: "xmark.circle.fill")
                    .font(.title3)
                    .foregroundColor(.secondary)
            }
            .buttonStyle(.plain)
            .pointingCursor()
            .accessibilityLabel("Close detail")
            .accessibilityIdentifier("content-chip-detail-close-x")
        }
        .padding(.horizontal, 20)
        .padding(.top, 18)
        .padding(.bottom, DesignTokens.Spacing.md)
    }

    private var footer: some View {
        HStack(spacing: 10) {
            Spacer()
            if let title = item.actionTitle, let act = item.action {
                Button(title) {
                    act()
                    onDismiss()
                }
                .buttonStyle(.bordered)
                .accentColor(tint)
                .accessibilityHint("Performs the chip's follow-up action and closes this sheet.")
                .accessibilityIdentifier("content-chip-detail-action")
            }
            Button("Done", action: onDismiss)
                .keyboardShortcut(.defaultAction)
                .accessibilityIdentifier("content-chip-detail-done")
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
}
