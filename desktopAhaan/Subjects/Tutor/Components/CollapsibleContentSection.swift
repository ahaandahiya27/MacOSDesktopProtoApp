import SwiftUI
import AppKit

// MARK: - CollapsibleContentSection
//
// Generic disclosure-style section used by the "surface the content"
// surfaces: NCERT Q&A, Misconceptions, WhatIfs, Mnemonics, and similar
// JSON-backed lists that sit on the chapter detail page.
//
// Visually mirrors `DeepDiveSection` (shipped 5fcc96e): a tinted block
// with an SF Symbol, title, optional badge count, and a chevron header
// that toggles the body. Open/closed persists across launches via
// `@AppStorage` keyed by the caller's `storageKey`. New collapsibles
// default to closed so a parent who opens the app sees a clean,
// uncluttered chapter — every "spoiler" stays folded until tapped.
//
// Big Sur compatibility:
//   - `DisclosureGroup` is macOS 10.15+ ✅
//   - Pure `Color.compat*` tokens.
//   - Animation routes through `.respectReduceMotion(animation:)`.
//   - `@ViewBuilder` direct-child count kept ≤ 3 in every closure.

struct CollapsibleContentSection<Content: View>: View {
    let title: String
    let icon: String
    let badgeCount: Int?
    let tint: Color
    @AppStorage private var isExpanded: Bool
    @ViewBuilder let content: () -> Content

    /// `storageKey` is namespaced to `collapsibleSection.<storageKey>.expanded`
    /// at the @AppStorage layer so two sections with the same name in
    /// different chapters don't collide.
    init(
        title: String,
        icon: String,
        badgeCount: Int? = nil,
        tint: Color = .compatIndigo,
        storageKey: String,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.icon = icon
        self.badgeCount = badgeCount
        self.tint = tint
        self._isExpanded = AppStorage(
            wrappedValue: false,
            "collapsibleSection.\(storageKey).expanded"
        )
        self.content = content
    }

    var body: some View {
        DisclosureGroup(isExpanded: $isExpanded) {
            expandedBody
        } label: {
            header
        }
        .padding(DesignTokens.Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: DesignTokens.Radius.card, style: .continuous)
                .fill(tint.opacity(0.08))
        )
        .respectReduceMotion(animation: .easeInOut(duration: 0.22))
        .accessibilityElement(children: .contain)
        .accessibilityLabel(a11yLabel)
        .accessibilityHint("Tap to \(isExpanded ? "collapse" : "expand") this section.")
    }

    private var header: some View {
        HStack(spacing: 10) {
            Image(systemName: SFSymbolCompat.name(icon))
                .font(.title3)
                .foregroundColor(tint)
                .accessibilityHidden(true)
            Text(title)
                .font(.headline)
            if let n = badgeCount, n > 0 {
                Text("\(n)")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 7)
                    .padding(.vertical, DesignTokens.Spacing.xxs)
                    .background(Capsule().fill(tint))
                    .accessibilityHidden(true)
            }
            Spacer()
        }
        .contentShape(Rectangle())
    }

    private var expandedBody: some View {
        VStack(alignment: .leading, spacing: 10) {
            content()
        }
        .padding(.top, 10)
    }

    private var a11yLabel: String {
        if let n = badgeCount, n > 0 {
            return "\(title), \(n) item\(n == 1 ? "" : "s")."
        }
        return title
    }
}
