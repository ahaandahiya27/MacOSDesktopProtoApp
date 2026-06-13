import SwiftUI
import AppKit

// MARK: - CurriculumBridgeChip
//
// Single chip placed near the DeepDive disclosure showing
// "In Class 8 this becomes…" and "By NEET/JEE…" previews from
// `chapter.curriculumBridge: CurriculumBridge?`.
//
// Auto-hides when the chapter has no bridge authored. Tapping opens a
// small popover with both bridge texts side-by-side.

struct CurriculumBridgeChip: View {
    let chapter: Chapter

    private var bridge: CurriculumBridge? { chapter.curriculumBridge }

    @State private var isShowingDetail = false

    var body: some View {
        if let bridge = bridge {
            Button(action: { isShowingDetail = true }) {
                HStack(spacing: DesignTokens.Spacing.sm) {
                    Image(systemName: SFSymbolCompat.name("arrow.up.forward.circle.fill"))
                        .font(.body)
                        .foregroundColor(Color.compatIndigo)
                        .accessibilityHidden(true)
                    Text("Where this goes in later years")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(.primary)
                    Spacer(minLength: 0)
                    Image(systemName: "chevron.right")
                        .font(.caption2.weight(.bold))
                        .foregroundColor(.secondary)
                        .accessibilityHidden(true)
                }
                .padding(10)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
                        .fill(Color.compatIndigo.opacity(0.08))
                )
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .pointingCursor()
            .accessibilityLabel("Curriculum bridge")
            .accessibilityHint("Shows how this chapter's ideas reappear in Class 8 and at NEET / JEE level.")
            .accessibilityIdentifier("curriculum-bridge-chip")
            .sheet(isPresented: $isShowingDetail) {
                CurriculumBridgeSheet(
                    chapter: chapter,
                    bridge: bridge,
                    onDismiss: { isShowingDetail = false }
                )
            }
        }
    }
}

// MARK: - CurriculumBridgeSheet

private struct CurriculumBridgeSheet: View {
    let chapter: Chapter
    let bridge: CurriculumBridge
    let onDismiss: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            header
            Divider()
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    BridgeBlock(
                        label: "In Class 8…",
                        message: bridge.nextYearClass8,
                        tint: .compatBlue,
                        symbol: "8.circle.fill"
                    )
                    BridgeBlock(
                        label: "By NEET / JEE…",
                        message: bridge.forNeetJee,
                        tint: .compatPurple,
                        symbol: "graduationcap.fill"
                    )
                }
                .padding(.horizontal, DesignTokens.Spacing.xl)
                .padding(.vertical, 18)
                .frame(maxWidth: 640, alignment: .leading)
                .frame(maxWidth: .infinity, alignment: .center)
            }
            Divider()
            footer
        }
        .frame(minWidth: 480, idealWidth: 580, maxWidth: 700,
               minHeight: 340, idealHeight: 420, maxHeight: 560)
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
        HStack(spacing: 14) {
            VStack(alignment: .leading, spacing: 3) {
                Text("Ch. \(chapter.number) · Curriculum bridge")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)
                Text(chapter.title)
                    .font(.title3.bold())
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer(minLength: 0)
            Button(action: onDismiss) {
                Image(systemName: "xmark.circle.fill")
                    .font(.title3)
                    .foregroundColor(.secondary)
            }
            .buttonStyle(.plain)
            .pointingCursor()
            .accessibilityLabel("Close curriculum bridge")
            .accessibilityIdentifier("curriculum-bridge-close-x")
        }
        .padding(.horizontal, DesignTokens.Spacing.xl)
        .padding(.top, 20)
        .padding(.bottom, DesignTokens.Spacing.md)
    }

    private var footer: some View {
        HStack {
            Spacer()
            Button("Done", action: onDismiss)
                .keyboardShortcut(.defaultAction)
                .accessibilityIdentifier("curriculum-bridge-done")
        }
        .padding(.horizontal, DesignTokens.Spacing.xl)
        .padding(.vertical, DesignTokens.Spacing.md)
    }
}

private struct BridgeBlock: View {
    let label: String
    let message: String
    let tint: Color
    let symbol: String

    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
            HStack(spacing: DesignTokens.Spacing.sm) {
                Image(systemName: SFSymbolCompat.name(symbol))
                    .font(.title3)
                    .foregroundColor(tint)
                    .accessibilityHidden(true)
                Text(label)
                    .font(.headline)
                    .foregroundColor(tint)
                    .accessibilityAddTraits(.isHeader)
            }
            Text(message)
                .font(.callout)
                .foregroundColor(.primary)
                .lineSpacing(3)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(tint.opacity(0.08))
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(label) \(message)")
    }
}
