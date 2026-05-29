import XCTest
@testable import desktopAhaan

/// Skip path for the first-launch tour (2026-05-30).
///
/// Skipping must be indistinguishable from completing as far as persistence
/// goes — the presenter's `onClose` (Skip / Esc) and `onGetStarted` (Done +
/// open Science) both call `OnboardingState.markSeen()`, so a kid who skips
/// is never re-onboarded on the next launch. These tests pin that contract
/// against an isolated UserDefaults suite.
final class OnboardingSkipTests: XCTestCase {

    private var suiteName: String!
    private var defaults: UserDefaults!

    override func setUp() {
        super.setUp()
        suiteName = "onboarding-skip-\(UUID().uuidString)"
        defaults = UserDefaults(suiteName: suiteName)
    }

    override func tearDown() {
        defaults.removePersistentDomain(forName: suiteName)
        defaults = nil
        suiteName = nil
        super.tearDown()
    }

    /// Skipping (which calls `markSeen()`, same as Done) flips the flag and
    /// it persists for the next launch — no re-onboarding.
    func testSkipPersistsHasSeenFlag() {
        let state = OnboardingState(defaults: defaults)
        XCTAssertFalse(state.hasSeenOnboarding)

        state.markSeen()   // Skip and Done share this path.
        XCTAssertTrue(state.hasSeenOnboarding)

        let nextLaunch = OnboardingState(defaults: defaults)
        XCTAssertTrue(nextLaunch.hasSeenOnboarding,
            "Skipping the tour must suppress it on the next launch.")
    }

    /// `reset()` (test/replay hook) returns the flag to its fresh-install
    /// state so the tour would present again.
    func testResetReturnsToUnseen() {
        let state = OnboardingState(defaults: defaults)
        state.markSeen()
        XCTAssertTrue(state.hasSeenOnboarding)

        state.reset()
        XCTAssertFalse(state.hasSeenOnboarding,
            "reset() must clear the flag so the tour can present again.")
    }

    /// Setting the flag directly is observable through the same accessor —
    /// guards the getter/setter pair against drifting apart.
    func testSetterAndGetterAgree() {
        let state = OnboardingState(defaults: defaults)
        state.hasSeenOnboarding = true
        XCTAssertTrue(state.hasSeenOnboarding)
        state.hasSeenOnboarding = false
        XCTAssertFalse(state.hasSeenOnboarding)
    }
}
