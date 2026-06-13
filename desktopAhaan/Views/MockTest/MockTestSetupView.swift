import SwiftUI

// MARK: - MockTestSetupView
//
// v9 Exam Simulation · Phase 2. The pre-test setup: pick the subject scope
// (Mixed or a single subject), the difficulty band, and a length/time preset,
// then Start. Hands the assembled `MockTestConfig` back to the coordinator via
// `onStart`.
//
// Big Sur safe: DesignTokens spacing/radius + brand colours, Picker(.segmented)
// (macOS 11), no macOS 12+ APIs, ≥44pt targets, explicit a11y throughout.
@MainActor
struct MockTestSetupView: View {
    @EnvironmentObject var registry: SubjectRegistry

    /// Called with the finished config when the kid taps Start.
    let onStart: (MockTestConfig) -> Void

    /// Sentinel for the "Mixed (all subjects)" choice in `subjectChoice`.
    private static let mixedTag = "__mixed__"

    @State private var subjectChoice: String = MockTestSetupView.mixedTag
    @State private var band: MockTestDifficultyBand = .balanced
    @State private var preset: MockTestPreset = .quick

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.xl) {
                header
                subjectSection
                difficultySection
                lengthSection
                startRow
            }
            .padding(DesignTokens.Spacing.xl)
            .frame(maxWidth: 640, alignment: .leading)
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .background(Color(NSColor.windowBackgroundColor))
    }

    // MARK: - Header

    private var header: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
            HStack(spacing: DesignTokens.Spacing.sm) {
                Text("📝").font(.system(size: 34)).accessibilityHidden(true)
                Text("Mock Test")
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
            }
            Text("Sit a realistic, timed paper and get graded feedback — just like an exam.")
                .font(.subheadline)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Mock Test. Sit a realistic, timed paper and get graded feedback, just like an exam.")
    }

    // MARK: - Subject

    private var subjectSection: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
            sectionTitle("Subject")
            selectableRow(title: "Mixed — all subjects",
                          subtitle: "A cross-subject paper, weighted toward what needs work",
                          emoji: "🎲",
                          isSelected: subjectChoice == Self.mixedTag,
                          identifier: "mocktest-subject-mixed") {
                subjectChoice = Self.mixedTag
            }
            ForEach(registry.packs, id: \.id) { pack in
                selectableRow(title: pack.title,
                              subtitle: "\(pack.chapters.count) chapters",
                              emoji: pack.coverEmoji,
                              isSelected: subjectChoice == pack.id,
                              identifier: "mocktest-subject-\(pack.id)") {
                    subjectChoice = pack.id
                }
            }
        }
    }

    // MARK: - Difficulty

    private var difficultySection: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
            sectionTitle("Difficulty")
            Picker("Difficulty", selection: $band) {
                ForEach(MockTestDifficultyBand.allCases, id: \.self) { b in
                    Text(b.displayName).tag(b)
                }
            }
            .pickerStyle(.segmented)
            .labelsHidden()
            .accessibilityIdentifier("mocktest-difficulty-picker")
            Text(band.subtitle)
                .font(.caption)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                .accessibilityLabel("Difficulty: \(band.displayName). \(band.subtitle)")
        }
    }

    // MARK: - Length / time

    private var lengthSection: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
            sectionTitle("Length")
            Picker("Length", selection: $preset) {
                ForEach(MockTestPreset.allCases, id: \.self) { p in
                    Text("\(p.displayName) · \(p.summary)").tag(p)
                }
            }
            .pickerStyle(.segmented)
            .labelsHidden()
            .accessibilityIdentifier("mocktest-length-picker")
            Text("Scoring: +4 for a correct answer, −1 for a wrong one, 0 if you skip it.")
                .font(.caption)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    // MARK: - Start

    private var startRow: some View {
        HStack {
            Spacer(minLength: 0)
            Button(action: { start() }) {
                Text("Start test")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, DesignTokens.Spacing.lg)
                    .padding(.vertical, DesignTokens.Spacing.md)
                    .frame(minHeight: 44)
                    .background(Capsule().fill(DesignTokens.BrandColor.primaryAction))
            }
            .buttonStyle(.plain)
            .keyboardShortcut(.defaultAction)
            .accessibilityLabel("Start test")
            .accessibilityHint("Builds and begins the timed \(preset.summary) paper")
            .accessibilityIdentifier("mocktest-start")
        }
    }

    private func start() {
        let selection: MockTestSubjectSelection =
            subjectChoice == Self.mixedTag ? .mixed : .single(packId: subjectChoice)
        onStart(preset.config(selection: selection, band: band))
    }

    // MARK: - Reusable pieces

    private func sectionTitle(_ text: String) -> some View {
        Text(text)
            .font(.headline)
            .foregroundColor(DesignTokens.BrandColor.canvasText)
    }

    private func selectableRow(title: String, subtitle: String, emoji: String,
                               isSelected: Bool, identifier: String,
                               action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: DesignTokens.Spacing.md) {
                Text(emoji).font(.system(size: 22)).accessibilityHidden(true)
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.xxs) {
                    Text(title)
                        .font(.callout.weight(.semibold))
                        .foregroundColor(DesignTokens.BrandColor.canvasText)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                }
                Spacer(minLength: 0)
                Text(isSelected ? "●" : "○")
                    .font(.headline)
                    .foregroundColor(isSelected
                                     ? DesignTokens.BrandColor.primaryAction
                                     : DesignTokens.BrandColor.mutedSurface)
                    .accessibilityHidden(true)
            }
            .padding(.horizontal, DesignTokens.Spacing.md)
            .padding(.vertical, DesignTokens.Spacing.md)
            .frame(minHeight: 44)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: DesignTokens.Radius.card)
                    .fill(isSelected
                          ? DesignTokens.BrandColor.primaryAction.opacity(0.10)
                          : Color.gray.opacity(0.05))
            )
            .overlay(
                RoundedRectangle(cornerRadius: DesignTokens.Radius.card)
                    .stroke(isSelected
                            ? DesignTokens.BrandColor.primaryAction
                            : DesignTokens.BrandColor.dividerLine, lineWidth: 1.5)
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(title). \(subtitle)")
        .accessibilityHint("Choose this subject scope for the test")
        .accessibilityAddTraits(isSelected ? .isSelected : [])
        .accessibilityIdentifier(identifier)
    }
}
