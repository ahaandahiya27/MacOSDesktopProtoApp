import SwiftUI
import AppKit

// MARK: - ChapterDetailView + Ch.1 pilot — shared visual helpers
//
// The Ch.1 pilot ships three chapter-detail CTAs (BuildAPlantSandbox
// + two sheet-launching cards). The CTAs themselves stay inline in
// ChapterDetailView.swift because they need access to that file's
// private `presentedSheet` state. This sister file hosts the
// gradient-card visual builder both CTAs share — pure static visuals,
// no state — so the parent file stays under the 600 LOC Big Sur
// type-checker ceiling.
//
// Lifted 2026-05-23 while shipping Phase 2E.

struct Ch1PilotCTACard: View {
    let symbol: String
    let title: String
    let subtitle: String
    let gradient: [Color]

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: SFSymbolCompat.name(symbol))
                .font(.system(size: 28))
                .foregroundColor(.white)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.92))
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer(minLength: 0)
            Image(systemName: "chevron.right")
                .foregroundColor(.white.opacity(0.85))
                .accessibilityHidden(true)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: gradient,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .contentShape(Rectangle())
    }
}
