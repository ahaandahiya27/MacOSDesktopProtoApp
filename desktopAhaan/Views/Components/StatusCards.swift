import SwiftUI

struct OfflineBanner: View {
    var body: some View {
        HStack(spacing: DesignTokens.Spacing.sm) {
            Image(systemName: "wifi.slash")
            Text("You're offline. Some features need internet.")
                .font(.caption)
        }
        .foregroundColor(DesignTokens.BrandColor.tryAtHome)
        .padding(10)
        .frame(maxWidth: .infinity)
        .background(Color.orange.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: DesignTokens.Radius.md))
        .padding(.horizontal)
    }
}

struct ErrorCard: View {
    let message: String

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.red)
            Text(message)
                .font(.subheadline)
                .foregroundColor(.primary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.red.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal)
    }
}

struct InfoCard: View {
    let message: String
    let icon: String
    let color: Color
    var onDismiss: (() -> Void)? = nil

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .foregroundColor(color)
            Text(message)
                .font(.caption)
                .foregroundColor(.secondary)

            Spacer()

            if let dismiss = onDismiss {
                Button(action: dismiss) {
                    Image(systemName: "xmark")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .frame(width: 28, height: 28)
                        .background(Color.gray.opacity(0.25))
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Dismiss")
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(color.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal)
    }
}

/// Compact pill-shaped count badge (e.g., "8 needs review", "3 new").
/// Reused wherever a small numerical indicator sits next to a label or
/// row title. Defaults to orange (the existing "needs review" semantic)
/// but accepts any tint.
///
/// macOS 10.15+ compatible.
struct BadgePill: View {
    let count: Int
    var tint: Color = .orange
    /// Optional `.help(...)` and `.accessibilityLabel(...)` text. When
    /// non-nil, the pill is screen-reader-announced as this; when nil,
    /// the bare count is announced.
    var accessibilityText: String? = nil

    var body: some View {
        Text("\(count)")
            .font(.caption2.weight(.semibold).monospacedDigit())
            .foregroundColor(.white)
            .padding(.horizontal, 6)
            .padding(.vertical, 1)
            .background(Capsule().fill(tint))
            .accessibilityLabel(accessibilityText ?? "\(count)")
            .help(accessibilityText ?? "")
    }
}

/// Standard empty-state for screens with no content yet (no bookmarks,
/// no history, no favorites, no search results, etc.). Use this directly
/// rather than re-inlining a `VStack { Image + Text + Text }` per screen,
/// so visual treatment stays consistent across the app.
struct EmptyStateView: View {
    let icon: String
    let title: String
    let subtitle: String

    var body: some View {
        VStack(spacing: DesignTokens.Spacing.md) {
            Image(systemName: icon)
                .font(.system(size: 48))
                .foregroundColor(.secondary)
                .accessibilityHidden(true)
            Text(title)
                .font(.title2.weight(.semibold))
            Text(subtitle)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 520)
        }
        .padding(40)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
