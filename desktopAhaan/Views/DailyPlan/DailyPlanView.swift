import SwiftUI

/// The adaptive "today's 5 things" view: 3 SRS reviews due now, 1 unmastered
/// concept to read, 1 Discover scene to attempt. Each row taps through to its
/// surface (routing the main window via `AppState`), can be skipped, and
/// auto-ticks Done when the kid completes it elsewhere. A streak indicator
/// shows consecutive completed-plan days.
///
/// `@MainActor` — reads/writes `DataStore` + `AppState` on the main thread.
@MainActor
struct DailyPlanView: View {
    @EnvironmentObject private var dataStore: DataStore
    @EnvironmentObject private var subjectRegistry: SubjectRegistry
    @EnvironmentObject private var appState: AppState

    /// Called to close the hosting window after a tap-through navigation.
    var onNavigate: (() -> Void)?

    @State private var plan: DailyPlan = DailyPlan(planDay: Date(), items: [])
    @State private var reminderOn: Bool = DailyPlanNotifications.shared.isReminderEnabled
    /// Today vs Whole Journey. Seeded from the persisted choice; changing it
    /// persists + rebuilds the plan through the new lens.
    @State private var journeyMode: JourneyMode = JourneyPlannerStorage.currentMode()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                header
                modePicker
                if plan.items.isEmpty {
                    if isDayOne {
                        DailyPlanEmptyStateView(onStart: { startDayOne() })
                    } else {
                        emptyState
                    }
                } else {
                    ForEach(plan.items) { item in
                        DailyPlanRow(
                            item: item,
                            onOpen: { open(item) },
                            onDone: { markDone(item) },
                            onSkip: { skip(item) })
                    }
                }
                Divider()
                reminderFooter
            }
            .padding(DesignTokens.Spacing.xl)
        }
        .frame(minWidth: 520, minHeight: 460)
        .onAppear { reload() }
        .onReceive(dataStore.objectWillChange) { _ in
            // Auto-Done reconciliation: a review answered / concept opened /
            // scene finished elsewhere flips the matching row. Defer to the
            // next runloop tick so we read post-change state.
            DispatchQueue.main.async { reload() }
        }
        .onAppear { DailyPlanNotifications.shared.requestAuthorizationIfFirstTime() }
    }

    // MARK: - Header

    private var header: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
            Text("Today's Plan")
                .font(.largeTitle.weight(.bold))
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            HStack(spacing: 14) {
                Label("\(plan.doneCount) of \(plan.itemCount) done",
                      systemImage: SFSymbolCompat.name("checkmark.circle.fill"))
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                streakBadge
            }
            .font(.headline)
        }
    }

    @ViewBuilder
    private var streakBadge: some View {
        let streak = dataStore.dailyPlanStreak
        if streak > 0 {
            Label("\(streak)-day streak", systemImage: SFSymbolCompat.name("flame.fill"))
                .foregroundColor(DesignTokens.BrandColor.mnemonic)
        }
    }

    // MARK: - Mode picker (Today / Whole Journey)

    /// Segmented Today ↔ Whole Journey switch. Whole Journey samples by mastery
    /// gaps across every subject (see `JourneyPlanner`); changing it persists
    /// the choice and rebuilds the plan. SegmentedPickerStyle + onChange are
    /// both Big-Sur-safe (used elsewhere in the app).
    private var modePicker: some View {
        VStack(alignment: .leading, spacing: 6) {
            Picker("Plan mode", selection: $journeyMode) {
                ForEach(JourneyMode.allCases, id: \.self) { mode in
                    Text(mode.title).tag(mode)
                }
            }
            .pickerStyle(.segmented)
            .labelsHidden()
            .onChange(of: journeyMode) { newValue in
                JourneyPlannerStorage.setMode(newValue)
                reload()
            }
            .accessibilityLabel("Plan mode")
            Text(journeyMode.subtitle)
                .font(.caption)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var emptyState: some View {
        VStack(spacing: 10) {
            Text("🎉")
                .font(.system(size: 48))
                .accessibilityHidden(true)
            Text("You're all caught up!")
                .font(.title3.weight(.semibold))
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            Text("No reviews are due and your concepts are fresh. Explore a Discover scene or come back tomorrow for a new plan.")
                .font(.body)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 380)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, DesignTokens.Spacing.xxl)
    }

    // MARK: - Reminder footer

    private var reminderFooter: some View {
        Toggle(isOn: Binding(
            get: { reminderOn },
            set: { newValue in
                reminderOn = newValue
                DailyPlanNotifications.shared.setReminderEnabled(
                    newValue, itemCount: plan.remainingCount)
            })) {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.xxs) {
                Text("Daily practice reminder")
                    .font(.subheadline.weight(.medium))
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                Text("A gentle nudge at 5pm if you haven't finished your plan.")
                    .font(.caption)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
            }
        }
        .toggleStyle(.switch)
    }

    // MARK: - Actions

    /// True when there's no practice history at all — the day-one welcome
    /// empty state (vs the "all caught up" message for an established kid).
    private var isDayOne: Bool {
        dataStore.questionReviews.isEmpty
            && dataStore.understoodConceptIds.isEmpty
            && dataStore.discoverProgress.isEmpty
    }

    /// Day-one CTA: open Science Chapter 1 in the main window, then close.
    private func startDayOne() {
        let packId = "science_class7"
        appState.sidebarSelection = .subject(packId)
        appState.pendingRoute = PendingRoute(
            route: .chapter(packId: packId, chapterId: "ch01"))
        onNavigate?()
    }

    private func reload() {
        plan = dataStore.currentDailyPlan(registry: subjectRegistry)
        DailyPlanNotifications.shared.refreshIfEnabled(itemCount: plan.remainingCount)
    }

    private func markDone(_ item: DailyPlanItem) {
        dataStore.markDailyPlanItemDone(item.id, registry: subjectRegistry)
        reload()
    }

    private func skip(_ item: DailyPlanItem) {
        dataStore.skipDailyPlanItem(item.id, registry: subjectRegistry)
        reload()
    }

    /// Route the main window to this item's surface, then close the plan
    /// window so the kid lands on the destination.
    private func open(_ item: DailyPlanItem) {
        switch item.kind {
        case .review:
            appState.sidebarSelection = .subject(item.packId)
            appState.pendingRoute = PendingRoute(
                route: .question(packId: item.packId, questionId: item.targetId))
        case .concept:
            appState.sidebarSelection = .subject(item.packId)
            appState.pendingRoute = PendingRoute(
                route: .concept(packId: item.packId, conceptId: item.targetId))
        case .discover:
            appState.sidebarSelection = .subject(item.packId)
            appState.pendingRoute = PendingRoute(
                route: .discover(packId: item.packId, chapterId: item.targetId))
        }
        onNavigate?()
    }
}

// MARK: - Row

/// One plan row: kind glyph, title + subtitle, and trailing Done / Skip
/// controls. A `Done` row reads as ticked + struck-through; a `Skipped` row
/// dims. The whole row (when actionable) taps through to its surface.
@MainActor
struct DailyPlanRow: View {
    let item: DailyPlanItem
    let onOpen: () -> Void
    let onDone: () -> Void
    let onSkip: () -> Void

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(Color(NSColor.controlBackgroundColor))
                    .frame(width: 44, height: 44)
                Text(item.kind.emoji)
                    .font(.system(size: 22))
                    .opacity(item.isSkipped ? 0.4 : 1)
                    .accessibilityHidden(true)
            }
            textColumn
            Spacer(minLength: 8)
            controls
        }
        .padding(DesignTokens.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(NSColor.controlBackgroundColor).opacity(0.6))
        )
        .contentShape(Rectangle())
        .onTapGesture { if item.isActionable { onOpen() } }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(item.kind.sectionLabel): \(item.title). \(statusWord)")
    }

    private var textColumn: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(item.kind.sectionLabel.uppercased())
                .font(.caption2.weight(.bold))
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
            Text(item.title)
                .font(.headline)
                .foregroundColor(DesignTokens.BrandColor.canvasText)
                .strikethrough(item.isDone)
                .lineLimit(2)
            Text(item.subtitle)
                .font(.caption)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                .lineLimit(1)
        }
        .opacity(item.isSkipped ? 0.5 : 1)
    }

    @ViewBuilder
    private var controls: some View {
        if item.isDone {
            Image(systemName: SFSymbolCompat.name("checkmark.circle.fill"))
                .font(.system(size: 24))
                .foregroundColor(DesignTokens.BrandColor.success)
                .accessibilityHidden(true)
        } else if item.isSkipped {
            Text("Skipped")
                .font(.caption.weight(.medium))
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
        } else {
            HStack(spacing: DesignTokens.Spacing.sm) {
                Button("Skip", action: onSkip)
                    .buttonStyle(.borderless)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                Button(action: onDone) {
                    Image(systemName: SFSymbolCompat.name("checkmark.circle"))
                        .font(.system(size: 24))
                }
                .buttonStyle(.borderless)
                .help("Mark done")
                .accessibilityLabel("Mark done")
            }
        }
    }

    private var statusWord: String {
        if item.isDone { return "Done." }
        if item.isSkipped { return "Skipped." }
        return item.subtitle
    }
}
