import Foundation
import Combine
import Security

/// Manages app settings. No API keys needed — the app uses free translation.
final class SettingsManager: ObservableObject {
    static let shared = SettingsManager()

    private let defaults = UserDefaults.standard

    private enum Keys {
        static let preferOffline = "preferOffline"
        static let parentPIN = "com.sanskritkosh.parentpin"
        static let parentPINEnabled = "parentPINEnabled"
        static let speechRate = "speechRate"
        static let speechLanguage = "speechLanguage"
    }

    // MARK: - Offline preference
    @Published var preferOffline: Bool {
        didSet { defaults.set(preferOffline, forKey: Keys.preferOffline) }
    }

    // MARK: - Parent PIN (stored in Keychain for safety)
    var parentPIN: String? {
        get { readKeychain(service: Keys.parentPIN) }
        set {
            if let value = newValue {
                saveKeychain(service: Keys.parentPIN, data: value)
            } else {
                deleteKeychain(service: Keys.parentPIN)
            }
            objectWillChange.send()
        }
    }

    @Published var parentPINEnabled: Bool {
        didSet { defaults.set(parentPINEnabled, forKey: Keys.parentPINEnabled) }
    }

    // MARK: - Speech settings
    /// Speech rate multiplier (0.7–1.2). Default 0.9.
    @Published var speechRate: Float {
        didSet { defaults.set(speechRate, forKey: Keys.speechRate) }
    }

    /// Voice language identifier. Default "en-IN".
    @Published var speechLanguage: String {
        didSet { defaults.set(speechLanguage, forKey: Keys.speechLanguage) }
    }

    static let availableLanguages: [(id: String, label: String)] = [
        ("en-IN", "English (India)"),
        ("en-US", "English (US)"),
        ("hi-IN", "Hindi (India)")
    ]

    init() {
        self.preferOffline = defaults.bool(forKey: Keys.preferOffline)
        self.parentPINEnabled = defaults.bool(forKey: Keys.parentPINEnabled)
        let storedRate = defaults.float(forKey: Keys.speechRate)
        self.speechRate = storedRate > 0 ? storedRate : 0.9
        self.speechLanguage = defaults.string(forKey: Keys.speechLanguage) ?? "en-IN"
    }

    // MARK: - Keychain
    @discardableResult
    private func saveKeychain(service: String, data: String) -> Bool {
        guard let data = data.data(using: .utf8) else { return false }
        deleteKeychain(service: service)
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }

    private func readKeychain(service: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var item: CFTypeRef?
        guard SecItemCopyMatching(query as CFDictionary, &item) == errSecSuccess,
              let data = item as? Data else { return nil }
        return String(data: data, encoding: .utf8)
    }

    private func deleteKeychain(service: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service
        ]
        SecItemDelete(query as CFDictionary)
    }
}
