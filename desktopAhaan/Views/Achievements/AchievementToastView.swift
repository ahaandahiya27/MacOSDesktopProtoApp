import SwiftUI
import AppKit

/// The 5-second slide-in card shown top-right when a badge unlocks during
/// normal use. Pure SwiftUI; the slide animation is gated through
/// `withAnimationRespectingReduceMotion` so Reduce Motion gets an instant
/// appearance instead of a slide.
///
/// `@MainActor` because it reads the AppKit reduce-motion flag and is only
/// ever hosted on the main thread (inside the floating panel below).
@MainActor
struct AchievementToastView: View {
    let achievement: Achievement

    @State private var offsetX: CGFloat = 360
    @State private var opacity: Double = 0

    var body: some View {
        HStack(spacing: DesignTokens.Spacing.md) {
            ZStack {
                Circle()
                    .fill(achievement.tier.tint.opacity(0.18))
                    .frame(width: 48, height: 48)
                Text(achievement.emoji)
                    .font(.system(size: 26))
                    .accessibilityHidden(true)
            }
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.xxs) {
                Text("Badge unlocked!")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(achievement.tier.tint)
                Text(achievement.title)
                    .font(.headline)
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .lineLimit(1)
                Text(achievement.tier.displayName)
                    .font(.caption2)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
            }
            Spacer(minLength: 0)
        }
        .padding(DesignTokens.Spacing.md)
        .frame(width: 300, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: DesignTokens.Radius.card)
                .fill(Color(NSColor.windowBackgroundColor))
                .shadow(color: Color.black.opacity(0.18), radius: 10, x: 0, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: DesignTokens.Radius.card)
                .stroke(achievement.tier.tint.opacity(0.4), lineWidth: 1.5)
        )
        .offset(x: offsetX)
        .opacity(opacity)
        .onAppear {
            withAnimationRespectingReduceMotion(.spring(response: 0.45, dampingFraction: 0.8)) {
                offsetX = 0
                opacity = 1
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Badge unlocked: \(achievement.title), \(achievement.tier.displayName) tier. \(achievement.detail)")
    }
}

// MARK: - Floating-panel presenter

/// Shows `AchievementToastView` in a borderless floating `NSPanel` pinned
/// to the top-right of the key window. A standalone panel (not a
/// ContentView overlay) keeps the whole feature inside this directory —
/// ContentView is owned by another surface this run.
///
/// Unlocks that arrive while one toast is on screen queue up and show one
/// after another (5 s each) so a multi-badge moment doesn't stack panels.
///
/// `@MainActor` — every method touches AppKit window APIs and is invoked
/// from the (main-actor) `AchievementEngine`.
@MainActor
final class AchievementToastPresenter {
    static let shared = AchievementToastPresenter()

    private var panel: NSPanel?
    private var queue: [Achievement] = []
    private var showing = false

    /// Visible duration per toast, in seconds.
    private let visibleSeconds: TimeInterval = 5

    func show(_ achievement: Achievement) {
        queue.append(achievement)
        if !showing { dequeue() }
    }

    private func dequeue() {
        guard !queue.isEmpty else { showing = false; return }
        showing = true
        present(queue.removeFirst())
    }

    private func present(_ achievement: Achievement) {
        // Defensive: if a previous panel is still onscreen (a race window
        // during dequeue reset could call present() while self.panel is
        // non-nil), order it out before overwriting the reference. Without
        // this the old NSPanel leaks until the dispatch-after fires and
        // calls orderOut on the now-current panel — caught in the
        // 2026-06-05 audit.
        self.panel?.orderOut(nil)
        let host = NSHostingController(rootView: AchievementToastView(achievement: achievement))
        let panel = NSPanel(contentViewController: host)
        panel.styleMask = [.borderless, .nonactivatingPanel]
        panel.isFloatingPanel = true
        panel.level = .floating
        panel.backgroundColor = .clear
        panel.isOpaque = false
        panel.hasShadow = false
        panel.ignoresMouseEvents = true
        panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        panel.setContentSize(NSSize(width: 324, height: 92))
        positionTopRight(panel)
        panel.orderFrontRegardless()
        self.panel = panel

        // Auto-dismiss. asyncAfter (not a Timer) is fine here — single
        // shot, captured weakly, and the panel is torn down on dismiss.
        DispatchQueue.main.asyncAfter(deadline: .now() + visibleSeconds) { [weak self] in
            self?.dismissCurrent()
        }
    }

    private func dismissCurrent() {
        panel?.orderOut(nil)
        panel = nil
        // Show the next queued toast, if any.
        dequeue()
    }

    /// Pin to the top-right of the key window (falling back to the main
    /// screen's visible frame when no window is key — e.g. app in
    /// background).
    private func positionTopRight(_ panel: NSPanel) {
        let margin: CGFloat = 18
        let size = panel.frame.size
        let anchor = NSApp.keyWindow?.frame
            ?? NSScreen.main?.visibleFrame
            ?? NSRect(x: 0, y: 0, width: 1024, height: 768)
        let x = anchor.maxX - size.width - margin
        let y = anchor.maxY - size.height - margin
        panel.setFrameOrigin(NSPoint(x: x, y: y))
    }
}
