import Foundation
import UserNotifications

// MARK: - Daily Plan local notifications
//
// Opt-in daily 5pm reminder via `UNUserNotificationCenter` (macOS 10.14+, so
// Big-Sur-safe). Permission is requested the first time the Daily Plan view
// opens, with a graceful decline path: if the kid says no, the toggle simply
// stays off and nothing is scheduled. The reminder is a single repeating
// calendar notification at 17:00 local.
//
// No special entitlement is needed for LOCAL notifications (the push
// entitlement is only for remote pushes), so the locked entitlements set is
// untouched. Uses completion-handler APIs (the async/await variants are
// macOS 12+).
//
// `@MainActor` — invoked from the (main-actor) Daily Plan view.
@MainActor
final class DailyPlanNotifications {
    static let shared = DailyPlanNotifications()

    /// Identifier for the single repeating reminder so re-scheduling replaces
    /// rather than stacks.
    private let reminderId = "dailyPlan.dailyReminder"
    private let reminderHour = 17   // 5pm local

    private var center: UNUserNotificationCenter { .current() }

    /// True under XCTest — `UNUserNotificationCenter` can prompt / behave
    /// unpredictably in a headless test host, so every entry point no-ops
    /// here. Keeps render-smoke tests (which fire `onAppear`) side-effect-free.
    private var isTestRun: Bool {
        ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
    }

    // MARK: - Permission

    /// Whether the reminder toggle is on. Default OFF — opt-in.
    var isReminderEnabled: Bool {
        UserDefaults.standard.bool(forKey: DailyPlanStorage.reminderEnabledKey)
    }

    /// Ask for notification permission exactly once (the first Daily Plan
    /// open). Declining is fine — we never re-prompt and never schedule.
    func requestAuthorizationIfFirstTime() {
        guard !isTestRun else { return }
        let defaults = UserDefaults.standard
        guard !defaults.bool(forKey: DailyPlanStorage.notifPermissionAskedKey) else { return }
        defaults.set(true, forKey: DailyPlanStorage.notifPermissionAskedKey)
        center.requestAuthorization(options: [.alert, .sound]) { _, _ in
            // Granted or not, we don't enable the reminder automatically —
            // the kid opts in via the toggle. No-op on the result.
        }
    }

    // MARK: - Toggle

    /// Turn the daily reminder on/off. When enabling, (re)schedules with the
    /// current plan's item count so the message reflects today; when
    /// disabling, removes the pending request.
    func setReminderEnabled(_ enabled: Bool, itemCount: Int) {
        UserDefaults.standard.set(enabled, forKey: DailyPlanStorage.reminderEnabledKey)
        guard !isTestRun else { return }
        if enabled {
            // Ensure we have permission before scheduling; request if needed.
            // `UNUserNotificationCenter.current()` is not actor-isolated, so
            // it's safe to touch inside these Sendable completion closures;
            // the actual scheduling hops back to the main actor.
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                switch settings.authorizationStatus {
                case .authorized, .provisional:
                    Task { @MainActor in DailyPlanNotifications.shared.scheduleReminder(itemCount: itemCount) }
                case .notDetermined:
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, _ in
                        guard granted else { return }
                        Task { @MainActor in DailyPlanNotifications.shared.scheduleReminder(itemCount: itemCount) }
                    }
                default:
                    break   // denied — nothing to schedule; toggle stays visually on but inert
                }
            }
        } else {
            center.removePendingNotificationRequests(withIdentifiers: [reminderId])
        }
    }

    /// Refresh the scheduled reminder's body with the latest item count, but
    /// only if it's already enabled (so opening the view keeps the message
    /// current without nagging the kid to opt in).
    func refreshIfEnabled(itemCount: Int) {
        guard !isTestRun, isReminderEnabled else { return }
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized
                    || settings.authorizationStatus == .provisional else { return }
            Task { @MainActor in DailyPlanNotifications.shared.scheduleReminder(itemCount: itemCount) }
        }
    }

    // MARK: - Scheduling

    private func scheduleReminder(itemCount: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Today's Plan is waiting"
        content.body = Self.reminderBody(itemCount: itemCount)
        content.sound = .default

        var components = DateComponents()
        components.hour = reminderHour
        components.minute = 0
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: reminderId, content: content, trigger: trigger)

        center.removePendingNotificationRequests(withIdentifiers: [reminderId])
        center.add(request, withCompletionHandler: nil)
    }

    /// Friendly reminder copy. Roughly ~2 minutes of practice per plan item.
    static func reminderBody(itemCount: Int) -> String {
        guard itemCount > 0 else {
            return "Open Today's Plan to keep your learning streak alive."
        }
        let minutes = max(2, itemCount * 2)
        let itemWord = itemCount == 1 ? "item" : "items"
        return "\(itemCount) \(itemWord) waiting — about \(minutes) minutes of practice."
    }
}
