import Foundation

// MARK: - OnboardingState
//
// Owns the single "has the first-launch tour been completed?" flag. Backed
// by UserDefaults so it persists across launches and is shared with the
// `@AppStorage(OnboardingState.hasSeenOnboardingKey)` the view reads.
//
// Why the key lives here and not in `AppStorageKeys`:
//   The project convention is to route every @AppStorage key through the
//   `AppStorageKeys` enum (Extensions/AppStorageKeys.swift). That file is
//   outside this change's touch list (it belongs to the shared surface other
//   agents own this run), so the key is defined here instead, mirroring the
//   same `static let` style. A follow-up that owns AppStorageKeys should fold
//   `hasSeenOnboarding` into the enum — tracked in POLISH_TODOS. There is no
//   lint that enforces the routing, and the codebase already has a raw
//   `@AppStorage("…")` precedent (DeepDiveSection), so this is safe.
//
// Injectable `UserDefaults` so tests run against an isolated suite instead of
// `.standard` (which would leak state between test methods and the real app).
final class OnboardingState {
    /// UserDefaults key for the completed-tour flag. Bool; defaults to false
    /// (UserDefaults.bool returns false for an absent key), so a brand-new
    /// install reads "not seen" and gets the tour.
    static let hasSeenOnboardingKey = AppStorageKeys.hasSeenOnboarding

    /// Process-wide instance used by the app. Tests construct their own with
    /// a scratch suite.
    static let shared = OnboardingState()

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    /// True once the tour has been completed OR skipped. Drives whether the
    /// tour auto-presents on launch.
    var hasSeenOnboarding: Bool {
        get { defaults.bool(forKey: Self.hasSeenOnboardingKey) }
        set { defaults.set(newValue, forKey: Self.hasSeenOnboardingKey) }
    }

    /// Call when the tour completes or is skipped — flips the flag so it
    /// won't auto-present again.
    func markSeen() {
        hasSeenOnboarding = true
    }

    /// Test/replay helper. Not wired to any UI today (the tour is one-shot;
    /// re-running it would be a future Help-menu item, like the legacy
    /// Welcome Tour). Exposed so tests can reset between cases.
    func reset() {
        defaults.set(false, forKey: Self.hasSeenOnboardingKey)
    }
}
