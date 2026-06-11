import SwiftUI
import AppKit

// MARK: - ScientistsSectionView
//
// Surfaces `chapter.scientists: [ScientistProfile]?` on the chapter
// detail page. Each profile renders as a compact card showing the
// scientist's name + one-line legacy. Tapping opens a sheet with the
// full 120–200 word narrative.
//
// Most chapters ship one scientist; the schema and the layout both
// scale to several. Auto-hides when `chapter.scientists` is empty.

struct ScientistsSectionView: View {
    let chapter: Chapter

    @State private var presentedScientist: ScientistProfile?

    private var profiles: [ScientistProfile] { chapter.scientistsList }

    var body: some View {
        if !profiles.isEmpty {
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: DesignTokens.Spacing.sm) {
                    Image(systemName: SFSymbolCompat.name("person.crop.circle.badge.checkmark"))
                        .font(.title3)
                        .foregroundColor(Color.compatPurple)
                        .accessibilityHidden(true)
                    Text(profiles.count == 1 ? "Featured scientist" : "Featured scientists")
                        .font(.headline)
                        .accessibilityAddTraits(.isHeader)
                    Spacer()
                }
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(profiles) { profile in
                        ScientistCard(profile: profile) {
                            presentedScientist = profile
                        }
                    }
                }
            }
            .padding(DesignTokens.Spacing.lg)
            .background(
                RoundedRectangle(cornerRadius: DesignTokens.Radius.card)
                    .fill(Color.compatPurple.opacity(0.06))
            )
            .sheet(item: $presentedScientist) { profile in
                ScientistDetailSheet(profile: profile,
                                     onDismiss: { presentedScientist = nil })
            }
        }
    }
}

// MARK: - ScientistCard (compact)

private struct ScientistCard: View {
    let profile: ScientistProfile
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(alignment: .center, spacing: DesignTokens.Spacing.md) {
                avatarCircle
                    .frame(width: 44, height: 44)
                VStack(alignment: .leading, spacing: 3) {
                    HStack(alignment: .firstTextBaseline, spacing: 6) {
                        Text(profile.name)
                            .font(.callout.weight(.semibold))
                            .foregroundColor(.primary)
                        if let lifespan = profile.lifespan, !lifespan.isEmpty {
                            Text("(\(lifespan))")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    Text(profile.oneLineLegacy)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(3)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer(minLength: 0)
                Image(systemName: "chevron.right")
                    .font(.caption.weight(.bold))
                    .foregroundColor(.secondary)
                    .accessibilityHidden(true)
            }
            .padding(10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
                    .fill(Color(NSColor.controlBackgroundColor))
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .pointingCursor()
        .accessibilityLabel("\(profile.name)\(profile.lifespan.map { ", \($0)" } ?? ""). \(profile.oneLineLegacy)")
        .accessibilityHint("Opens the full story of this scientist.")
    }

    /// Initial-based avatar circle. No bundled photographs (Big Sur +
    /// licensing complications). The initials read clearly and the
    /// purple tint matches the section.
    private var avatarCircle: some View {
        let initials = profile.name
            .split(separator: " ")
            .compactMap { $0.first.map(String.init) }
            .prefix(2)
            .joined()
        return ZStack {
            Circle().fill(Color.compatPurple.opacity(0.85))
            Text(initials.isEmpty ? "?" : initials)
                .font(.headline.weight(.bold))
                .foregroundColor(.white)
        }
        .accessibilityHidden(true)
    }
}

// MARK: - ScientistDetailSheet

private struct ScientistDetailSheet: View {
    let profile: ScientistProfile
    let onDismiss: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            header
            Divider()
            ScrollView {
                Text(profile.narrative)
                    .font(.body)
                    .lineSpacing(5)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: 640, alignment: .leading)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.horizontal, DesignTokens.Spacing.xl)
                    .padding(.vertical, 18)
            }
            Divider()
            footer
        }
        .frame(minWidth: 520, idealWidth: 640, maxWidth: 760,
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
        HStack(alignment: .top, spacing: 14) {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                Text("Featured scientist")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)
                Text(profile.name)
                    .font(.title2.bold())
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                HStack(spacing: DesignTokens.Spacing.sm) {
                    if let lifespan = profile.lifespan, !lifespan.isEmpty {
                        Label(lifespan, systemImage: SFSymbolCompat.name("calendar"))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    if let nationality = profile.nationality, !nationality.isEmpty {
                        Label(nationality, systemImage: SFSymbolCompat.name("globe"))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                Text(profile.oneLineLegacy)
                    .font(.callout)
                    .foregroundColor(Color.compatPurple)
                    .italic()
                    .lineSpacing(3)
                    .padding(.top, DesignTokens.Spacing.xs)
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
            .accessibilityLabel("Close")
        }
        .padding(.horizontal, DesignTokens.Spacing.xl)
        .padding(.top, 20)
        .padding(.bottom, 14)
    }

    private var footer: some View {
        HStack {
            Spacer()
            Button("Done", action: onDismiss)
                .keyboardShortcut(.defaultAction)
        }
        .padding(.horizontal, DesignTokens.Spacing.xl)
        .padding(.vertical, DesignTokens.Spacing.md)
    }
}
