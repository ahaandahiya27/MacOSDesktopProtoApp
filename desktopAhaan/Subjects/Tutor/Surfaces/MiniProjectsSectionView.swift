import SwiftUI
import AppKit

// MARK: - MiniProjectsSectionView
//
// Surfaces `chapter.miniProjects: [MiniProject]?` as a "Build
// something" section on the chapter detail page. Each project is
// surfaced as a tappable card that opens a detail sheet — long-form
// content (materials + 5-8 numbered steps + expected observation +
// why-it-works) belongs in the sheet, not inline.
//
// Uses `CollapsibleContentSection` for the disclosure.

struct MiniProjectsSectionView: View {
    let chapter: Chapter

    private var projects: [MiniProject] { chapter.miniProjectsList }

    @State private var presentedProject: MiniProject?

    var body: some View {
        if !projects.isEmpty {
            CollapsibleContentSection(
                title: "Build something",
                icon: "hammer.fill",
                badgeCount: projects.count,
                tint: .compatBrown,
                storageKey: "\(chapter.id).miniProjects"
            ) {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(projects) { project in
                        MiniProjectCard(project: project) {
                            presentedProject = project
                        }
                    }
                }
            }
            .sheet(item: $presentedProject) { project in
                MiniProjectDetailSheet(
                    project: project,
                    onDismiss: { presentedProject = nil }
                )
            }
        }
    }
}

// MARK: - MiniProjectCard (collapsed summary)

private struct MiniProjectCard: View {
    let project: MiniProject
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(alignment: .center, spacing: DesignTokens.Spacing.md) {
                Text(project.emoji)
                    .font(.system(size: 30))
                    .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: 3) {
                    Text(project.title)
                        .font(.callout.weight(.semibold))
                        .foregroundColor(.primary)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                    HStack(spacing: 10) {
                        Label("\(project.estimatedMinutes) min", systemImage: SFSymbolCompat.name("clock"))
                        Label("\(project.needs.count) materials", systemImage: SFSymbolCompat.name("list.bullet"))
                    }
                    .font(.caption2)
                    .foregroundColor(.secondary)
                }
                Spacer(minLength: 0)
                Image(systemName: "chevron.right")
                    .font(.caption.weight(.bold))
                    .foregroundColor(.secondary)
                    .accessibilityHidden(true)
            }
            .padding(DesignTokens.Spacing.md)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.08))
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .pointingCursor()
        .accessibilityLabel("Mini-project: \(project.title), \(project.estimatedMinutes) minutes, \(project.needs.count) materials.")
        .accessibilityHint("Opens steps, expected observation, and the why-it-works explanation.")
    }
}

// MARK: - MiniProjectDetailSheet

private struct MiniProjectDetailSheet: View {
    let project: MiniProject
    let onDismiss: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            header
            Divider()
            ScrollView {
                content
                    .padding(.horizontal, DesignTokens.Spacing.xl)
                    .padding(.vertical, 18)
                    .frame(maxWidth: 700, alignment: .leading)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            Divider()
            footer
        }
        .frame(minWidth: 540, idealWidth: 680, maxWidth: 820,
               minHeight: 460, idealHeight: 600, maxHeight: 800)
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
            Text(project.emoji)
                .font(.system(size: 44))
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                Text("Mini-project")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)
                Text(project.title)
                    .font(.title2.bold())
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)
                Text("≈ \(project.estimatedMinutes) min")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer(minLength: 0)
        }
        .padding(.horizontal, DesignTokens.Spacing.xl)
        .padding(.top, 20)
        .padding(.bottom, DesignTokens.Spacing.md)
    }

    private var content: some View {
        VStack(alignment: .leading, spacing: 22) {
            materialsBlock
            stepsBlock
            observationBlock
            whyItWorksBlock
        }
    }

    private var materialsBlock: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
            Text("You'll need")
                .font(.headline)
                .accessibilityAddTraits(.isHeader)
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                ForEach(project.needs, id: \.self) { item in
                    HStack(alignment: .top, spacing: 6) {
                        Text("•").font(.body.weight(.bold)).foregroundColor(.secondary)
                        Text(item).font(.callout)
                    }
                }
            }
        }
    }

    private var stepsBlock: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
            Text("Steps")
                .font(.headline)
                .accessibilityAddTraits(.isHeader)
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                ForEach(project.steps.indices, id: \.self) { idx in
                    HStack(alignment: .top, spacing: DesignTokens.Spacing.sm) {
                        Text("\(idx + 1).")
                            .font(.callout.weight(.bold))
                            .foregroundColor(Color.compatBrown)
                            .frame(width: 22, alignment: .leading)
                        Text(project.steps[idx])
                            .font(.callout)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
        }
    }

    private var observationBlock: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
            Text("Expect to see")
                .font(.headline)
                .accessibilityAddTraits(.isHeader)
            Text(project.expectedObservation)
                .font(.callout)
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(DesignTokens.Spacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.compatTeal.opacity(0.08))
        )
    }

    private var whyItWorksBlock: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
            Text("Why it works")
                .font(.headline)
                .accessibilityAddTraits(.isHeader)
            Text(project.whyItWorks)
                .font(.callout)
                .foregroundColor(.secondary)
                .lineSpacing(3)
                .fixedSize(horizontal: false, vertical: true)
        }
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
