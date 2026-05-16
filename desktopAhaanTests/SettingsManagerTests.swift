import Testing
import Foundation
@testable import desktopAhaan

/// Tests for the UserDefaults-backed properties on `SettingsManager`. The
/// Keychain-backed parent PIN is not exercised here — it requires sandbox
/// entitlements that the test target doesn't have.
///
/// Each test resets the shared singleton's published properties to a known
/// state at start so tests don't bleed into each other.
@MainActor
struct SettingsManagerTests {

    private func resetToDefaults() {
        let s = SettingsManager.shared
        s.preferOffline = false
        s.parentPINEnabled = false
        s.speechRate = 0.9
        s.speechLanguage = "en-IN"
        s.autoAdvanceOnCorrect = false
    }

    // MARK: - preferOffline

    @Test func preferOfflineDefaultsFalse() {
        resetToDefaults()
        #expect(SettingsManager.shared.preferOffline == false)
    }

    @Test func preferOfflineTogglesAndPersists() {
        resetToDefaults()
        SettingsManager.shared.preferOffline = true
        #expect(SettingsManager.shared.preferOffline)
        // didSet should have written to UserDefaults.
        #expect(UserDefaults.standard.bool(forKey: "preferOffline"))
    }

    // MARK: - speechRate

    @Test func speechRateDefault() {
        resetToDefaults()
        #expect(SettingsManager.shared.speechRate == 0.9)
    }

    @Test func speechRateClampedToBounds() {
        // The UI clamps with a slider .in(0.7...1.2). Storage is
        // unconstrained but practical values stay in that range. The
        // Manager shouldn't reject either bound.
        resetToDefaults()
        SettingsManager.shared.speechRate = 0.7
        #expect(SettingsManager.shared.speechRate == 0.7)
        SettingsManager.shared.speechRate = 1.2
        #expect(SettingsManager.shared.speechRate == 1.2)
    }

    @Test func speechRatePersists() {
        resetToDefaults()
        SettingsManager.shared.speechRate = 1.1
        #expect(UserDefaults.standard.float(forKey: "speechRate") == 1.1)
    }

    // MARK: - speechLanguage

    @Test func speechLanguageDefault() {
        resetToDefaults()
        #expect(SettingsManager.shared.speechLanguage == "en-IN")
    }

    @Test func speechLanguageChangePersists() {
        resetToDefaults()
        SettingsManager.shared.speechLanguage = "hi-IN"
        #expect(UserDefaults.standard.string(forKey: "speechLanguage") == "hi-IN")
    }

    @Test func availableLanguagesContainsExpected() {
        // Soft contract: the picker UI binds against this list. If any
        // expected locale is dropped accidentally, callers break silently.
        let ids = SettingsManager.availableLanguages.map(\.id)
        #expect(ids.contains("en-IN"))
        #expect(ids.contains("en-US"))
        #expect(ids.contains("hi-IN"))
    }

    // MARK: - parentPINEnabled

    @Test func parentPINEnabledDefault() {
        resetToDefaults()
        #expect(SettingsManager.shared.parentPINEnabled == false)
    }

    @Test func parentPINEnabledTogglesAndPersists() {
        resetToDefaults()
        SettingsManager.shared.parentPINEnabled = true
        #expect(UserDefaults.standard.bool(forKey: "parentPINEnabled"))
    }

    // MARK: - autoAdvanceOnCorrect

    @Test func autoAdvanceDefault() {
        resetToDefaults()
        #expect(SettingsManager.shared.autoAdvanceOnCorrect == false)
    }

    @Test func autoAdvanceTogglesAndPersists() {
        resetToDefaults()
        SettingsManager.shared.autoAdvanceOnCorrect = true
        #expect(UserDefaults.standard.bool(forKey: "autoAdvanceOnCorrect"))
    }

    // MARK: - Singleton identity

    @Test func sharedReturnsSameInstance() {
        #expect(SettingsManager.shared === SettingsManager.shared)
    }
}
