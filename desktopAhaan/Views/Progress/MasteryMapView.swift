import SwiftUI
import AppKit

/// v6 Learning Journey · Phase 2. The cross-subject **Mastery Map** — one
/// scrollable surface that rolls every subject up into a single "where am I on
/// the whole journey?" picture, built from the read-only `MasteryEngine`
/// snapshot. Two bars per subject answer two different questions:
///   • Coverage — how MUCH of the subject has been attempted.
///   • Mastery  — how WELL the attempted material is known.
/// Plus an overall summary and a "focus next" nudge toward the weakest started
/// subject.
///
/// Presented in its own AppKit window via Help → Mastery Map (see
/// `MasteryMapWindow.swift` + `desktopAhaanApp.swift`). `@MainActor` because it
/// reads `DataStore` (main-actor-isolated) synchronously in `onAppear`. Static
/// bars only — no animation, no particles — so it costs the legacy AMD GPU
/// nothing.
@MainActor
struct MasteryMapView: View {
    @EnvironmentObject var dataStore: DataStore
    @EnvironmentObject var registry: SubjectRegistry

    @State private var snapshot: OverallMasterySnapshot?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                header
                content
            }
            .padding(20)
            .frame(maxWidth: 760, alignment: .leading)
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .background(Color(NSColor.windowBackgroundColor))
        .onAppear { reload() }
        .navigationTitle("Mastery Map")
    }

    @ViewBuilder
    private var content: some View {
        if let snap = snapshot {
            if snap.isEmpty {
                emptyState
            } else {
                Group {
                    overallCard(snap)
                    if let weak = snap.weakestStartedSubject {
                        focusCard(weak)
                    }
                    subjectsSection(snap)
                    legend
                }
            }
        } else {
            ProgressView("Mapping your progress…")
                .padding(.vertical, 40)
                .frame(maxWidth: .infinity)
        }
    }

    private func reload() {
        snapshot = MasteryEngine.snapshot(registry: registry, dataStore: dataStore)
    }

    // MARK: - Header

    private var header: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
            HStack(spacing: 10) {
                Text("🗺️").font(.system(size: 34)).accessibilityHidden(true)
                Text("Mastery Map")
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
            }
            Text("Your whole learning journey, across every subject.")
                .font(.subheadline)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Mastery Map. Your whole learning journey, across every subject.")
    }

    // MARK: - Overall card

    private func overallCard(_ snap: OverallMasterySnapshot) -> some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
            HStack(spacing: DesignTokens.Spacing.md) {
                Text("🌟").font(.system(size: 30)).accessibilityHidden(true)
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.xxs) {
                    Text("Overall")
                        .font(.title2.weight(.bold))
                        .foregroundColor(DesignTokens.BrandColor.canvasText)
                    Text("\(snap.totalReviewed) of \(snap.totalReviewable) questions practised across \(snap.startedSubjects.count) subject\(snap.startedSubjects.count == 1 ? "" : "s")")
                        .font(.callout)
                        .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                }
                Spacer(minLength: 0)
                levelChip(snap.overallLevel)
            }
            meter(title: "Coverage",
                  fraction: snap.overallCoverageFraction,
                  tint: DesignTokens.BrandColor.tryAtHome,
                  trailing: percent(snap.overallCoverageFraction))
            meter(title: "Mastery",
                  fraction: snap.overallMasteryFraction,
                  tint: snap.overallLevel.tint,
                  trailing: percent(snap.overallMasteryFraction))
            if snap.totalDue > 0 {
                Text("\(snap.totalDue) question\(snap.totalDue == 1 ? "" : "s") due for review today.")
                    .font(.caption)
                    .foregroundColor(DesignTokens.BrandColor.warning)
            }
        }
        .padding(DesignTokens.Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: DesignTokens.cornerRadiusCard)
                .fill(DesignTokens.BrandColor.primaryAction.opacity(0.07))
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel(overallAccessibilityLabel(snap))
    }

    private func overallAccessibilityLabel(_ snap: OverallMasterySnapshot) -> String {
        "Overall: \(snap.overallLevel.displayName). "
            + "Coverage \(percent(snap.overallCoverageFraction)), "
            + "mastery \(percent(snap.overallMasteryFraction)). "
            + "\(snap.totalReviewed) of \(snap.totalReviewable) questions practised. "
            + (snap.totalDue > 0 ? "\(snap.totalDue) due for review today." : "Nothing due right now.")
    }

    // MARK: - Focus-next nudge

    private func focusCard(_ subject: SubjectMasterySnapshot) -> some View {
        HStack(spacing: DesignTokens.Spacing.md) {
            Text("🎯")
                .font(.system(size: 28))
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.xxs) {
                Text("Focus next")
                    .font(.headline)
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                Text("\(subject.subjectTitle) is your lightest subject right now — a little practice there will lift your whole journey the most.")
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer(minLength: 0)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: DesignTokens.cornerRadiusCard)
                .fill(DesignTokens.BrandColor.tryAtHome.opacity(0.08))
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Focus next: \(subject.subjectTitle) is your lightest subject right now. Practising there lifts your whole journey the most.")
    }

    // MARK: - Per-subject rows

    private func subjectsSection(_ snap: OverallMasterySnapshot) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("By subject")
                .font(.headline)
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            ForEach(snap.subjects) { subject in
                subjectRow(subject)
            }
        }
    }

    private func subjectRow(_ subject: SubjectMasterySnapshot) -> some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
            HStack(spacing: DesignTokens.Spacing.sm) {
                Text(emoji(for: subject.packId))
                    .font(.system(size: 22))
                    .accessibilityHidden(true)
                Text(subject.subjectTitle)
                    .font(.headline)
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                Spacer(minLength: 0)
                if subject.hasStarted {
                    levelChip(subject.level)
                }
            }
            if subject.hasStarted {
                startedRowBody(subject)
            } else {
                Text("Not started yet — open this subject to begin.")
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: DesignTokens.cornerRadiusCard)
                .fill(subject.hasStarted
                      ? DesignTokens.BrandColor.success.opacity(0.06)
                      : Color.gray.opacity(0.05))
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel(subjectAccessibilityLabel(subject))
    }

    private func startedRowBody(_ subject: SubjectMasterySnapshot) -> some View {
        Group {
            meter(title: "Coverage",
                  fraction: subject.coverageFraction,
                  tint: DesignTokens.BrandColor.tryAtHome,
                  trailing: "\(subject.reviewedQuestions) of \(subject.totalReviewableQuestions)")
            meter(title: "Mastery",
                  fraction: subject.masteryFraction,
                  tint: subject.level.tint,
                  trailing: percent(subject.masteryFraction))
            if subject.dueCount > 0 {
                Text("\(subject.dueCount) due for review.")
                    .font(.caption)
                    .foregroundColor(DesignTokens.BrandColor.warning)
            }
        }
    }

    private func subjectAccessibilityLabel(_ subject: SubjectMasterySnapshot) -> String {
        guard subject.hasStarted else {
            return "\(subject.subjectTitle): not started yet."
        }
        return "\(subject.subjectTitle): \(subject.level.displayName). "
            + "Coverage \(percent(subject.coverageFraction)), "
            + "\(subject.reviewedQuestions) of \(subject.totalReviewableQuestions) questions practised. "
            + "Mastery \(percent(subject.masteryFraction)). "
            + (subject.dueCount > 0 ? "\(subject.dueCount) due for review." : "")
    }

    // MARK: - Legend

    private var legend: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("What the levels mean")
                .font(.subheadline.weight(.semibold))
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            ForEach(MasteryLevel.allCases) { level in
                HStack(spacing: DesignTokens.Spacing.sm) {
                    Circle()
                        .fill(level.tint)
                        .frame(width: 11, height: 11)
                        .accessibilityHidden(true)
                    Text(level.displayName)
                        .font(.caption.weight(.semibold))
                        .foregroundColor(DesignTokens.BrandColor.canvasText)
                    Text(level.caption)
                        .font(.caption)
                        .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel("\(level.displayName): \(level.caption)")
            }
        }
        .padding(.top, DesignTokens.Spacing.xs)
    }

    // MARK: - Empty state

    private var emptyState: some View {
        VStack(spacing: DesignTokens.Spacing.md) {
            Text("🚀").font(.system(size: 48)).accessibilityHidden(true)
            Text("Your journey starts here")
                .font(.title2.weight(.bold))
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            Text("Answer a few questions in any subject and your Mastery Map will fill in — one bar for how much you've explored, one for how well you know it.")
                .font(.callout)
                .multilineTextAlignment(.center)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .padding(.horizontal, 20)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Your journey starts here. Answer a few questions in any subject and your Mastery Map will fill in.")
    }

    // MARK: - Reusable pieces

    private func meter(title: String, fraction: Double, tint: Color, trailing: String) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            HStack {
                Text(title)
                    .font(.caption.weight(.medium))
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                Spacer(minLength: 0)
                Text(trailing)
                    .font(.caption.monospacedDigit())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
            }
            MeterBar(fraction: fraction, tint: tint)
        }
        .accessibilityHidden(true)   // parent card carries the spoken summary
    }

    private func levelChip(_ level: MasteryLevel) -> some View {
        Text(level.displayName)
            .font(.caption.weight(.bold))
            .foregroundColor(.white)
            .padding(.horizontal, 9)
            .padding(.vertical, 3)
            .background(Capsule().fill(level.tint))
            .accessibilityHidden(true)
    }

    private func percent(_ f: Double) -> String {
        "\(Int((max(0, min(1, f)) * 100).rounded()))%"
    }

    private func emoji(for packId: String) -> String {
        registry.pack(withId: packId)?.coverEmoji ?? "•"
    }
}

// MARK: - MeterBar
//
// A static horizontal progress bar: a muted track with a tinted fill sized to
// `fraction` (0…1). No animation — the fill width is set directly, so it costs
// the legacy GPU nothing and is unaffected by Reduce Motion. Marked
// accessibility-hidden; the owning card speaks the value.
private struct MeterBar: View {
    let fraction: Double
    let tint: Color

    var body: some View {
        GeometryReader { geo in
            let clampedFraction: CGFloat = max(0, min(1, fraction))
            let fillW: CGFloat = clampedFraction * geo.size.width
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(DesignTokens.BrandColor.mutedSurface.opacity(0.5))
                Capsule()
                    .fill(tint)
                    .frame(width: fillW)
            }
        }
        .frame(height: 10)
        .accessibilityHidden(true)
    }
}
