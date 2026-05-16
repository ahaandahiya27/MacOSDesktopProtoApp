import SwiftUI

struct SettingsScreen: View {
    @ObservedObject private var settings = SettingsManager.shared
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var subjectRegistry: SubjectRegistry
    @EnvironmentObject var dataStore: DataStore
    @State private var pinInput = ""
    @State private var isUnlocked = false
    @State private var pinError = false
    @State private var showClearConfirm = false
    @State private var newPIN = ""
    @State private var pinSaved = false

    var body: some View {
        Group {
            if settings.parentPINEnabled && !isUnlocked {
                PINEntryView(pinInput: $pinInput, pinError: $pinError, onSubmit: validatePIN)
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        infoBanner
                        howItWorks
                        settingsForm
                    }
                    .padding(20)
                    .frame(maxWidth: 560, alignment: .leading)
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .navigationTitle("Settings")
    }

    // MARK: - Info banner

    private var infoBanner: some View {
        Label(
            "These settings are for parents. Your child uses the other tabs to learn.",
            systemImage: "info.circle"
        )
        .font(.caption)
        .foregroundColor(.secondary)
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.1))
        )
    }

    // MARK: - How It Works

    private var howItWorks: some View {
        GroupBox(label: Label("Translation", systemImage: "character.book.closed")) {
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 10) {
                    Image(systemName: "checkmark.shield.fill")
                        .foregroundColor(.green)
                        .font(.title3)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("No API Key Needed").font(.subheadline.weight(.semibold))
                        Text("Free to use. No accounts, no keys, no subscriptions.")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }

                Divider()

                Label("How It Works", systemImage: "gearshape.2")
                    .font(.caption.weight(.semibold))

                VStack(alignment: .leading, spacing: 8) {
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "internaldrive")
                            .font(.caption)
                            .foregroundColor(Color.compatIndigo)
                            .frame(width: 16)
                        Text("**Built-in Dictionary** — words and sentences from the Class 7 NCERT syllabus. Works offline, always free, always available.")
                            .font(.caption2)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "globe")
                            .font(.caption)
                            .foregroundColor(.blue)
                            .frame(width: 16)
                        Text("**Online Translation** — for phrases not in the dictionary, the app uses a free online service (MyMemory). No registration. Limit: ~1000 words/day.")
                            .font(.caption2)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .foregroundColor(.secondary)
            }
            .padding(4)
        }
    }

    // MARK: - Settings form

    private var settingsForm: some View {
        Form {
            Section(header: Text("Status")) {
                HStack {
                    Text("Connection")
                    Spacer()
                    HStack(spacing: 6) {
                        Circle()
                            .fill(appState.isOnline ? .green : .orange)
                            .frame(width: 8, height: 8)
                        Text(appState.isOnline ? "Online" : "Offline")
                            .foregroundColor(.secondary)
                    }
                }
                Toggle("Dictionary Only (Offline Mode)", isOn: $settings.preferOffline)
                Text("When on, the app only uses the built-in dictionary — no internet requests at all. History, favorites, flashcards, and quizzes always work offline.")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Section(header: Text("Parent Lock")) {
                Toggle("Require PIN for Settings", isOn: Binding(
                    get: { settings.parentPINEnabled },
                    set: { newValue in
                        if newValue {
                            let currentPIN = settings.parentPIN ?? ""
                            if currentPIN.count >= 4 {
                                settings.parentPINEnabled = true
                            } else {
                                settings.parentPINEnabled = false
                                newPIN = ""
                                pinSaved = false
                            }
                        } else {
                            settings.parentPINEnabled = false
                            settings.parentPIN = nil
                            newPIN = ""
                            pinSaved = false
                        }
                    }
                ))

                if settings.parentPINEnabled || !pinSaved {
                    HStack {
                        Text("Set PIN (4–6 digits)")
                        Spacer()
                        HStack(spacing: 8) {
                            SecureField("PIN", text: $newPIN)
                                .frame(maxWidth: 120)
                                .accessibilityLabel("Parent PIN, 4 to 6 digits")
                                .onChange(of: newPIN) { value in
                                    let digits = value.filter { $0.isNumber }
                                    newPIN = String(digits.prefix(6))
                                }

                            if newPIN.count >= 4 {
                                Button("Save") {
                                    settings.parentPIN = newPIN
                                    settings.parentPINEnabled = true
                                    pinSaved = true
                                }
                            }
                        }
                    }

                    if pinSaved {
                        Label("PIN saved. Settings will be locked when you leave this tab.", systemImage: "checkmark.circle.fill")
                            .font(.caption2)
                            .foregroundColor(.green)
                    } else {
                        Text("Enter at least 4 digits and tap Save to enable the parent lock.")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }

                    Text("Protects this Settings screen only. Translation, history, favorites, and practice remain freely accessible.")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            Section(header: Text("Subject packs")) {
                if subjectRegistry.isLoading {
                    HStack {
                        Text("Status")
                        Spacer()
                        Text("Loading…").foregroundColor(.secondary)
                    }
                } else {
                    HStack {
                        Text("Loaded")
                        Spacer()
                        Text("\(subjectRegistry.packs.count) pack\(subjectRegistry.packs.count == 1 ? "" : "s")")
                            .foregroundColor(.secondary)
                    }
                    ForEach(subjectRegistry.packs) { pack in
                        HStack {
                            Text(pack.title)
                            Spacer()
                            Text("v\(pack.version) · \(pack.conceptCount) concepts")
                                .foregroundColor(.secondary)
                        }
                    }
                    if subjectRegistry.loadErrors.isEmpty {
                        Label("All packs decoded successfully.", systemImage: "checkmark.circle")
                            .font(.caption2)
                            .foregroundColor(.green)
                    } else {
                        Label("\(subjectRegistry.loadErrors.count) pack(s) failed to load:",
                              systemImage: "exclamationmark.triangle.fill")
                            .font(.caption2)
                            .foregroundColor(.orange)
                        ForEach(subjectRegistry.loadErrors, id: \.self) { err in
                            Text(err)
                                .font(.caption2)
                                .foregroundColor(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
            }

            Section(header: Text("Read Aloud")) {
                HStack {
                    Text("Voice")
                    Spacer()
                    Picker("Language", selection: $settings.speechLanguage) {
                        ForEach(SettingsManager.availableLanguages, id: \.id) { lang in
                            Text(lang.label).tag(lang.id)
                        }
                    }
                    .labelsHidden()
                    .frame(maxWidth: 180)
                }

                HStack {
                    Text("Speed (\(String(format: "%.1f×", settings.speechRate)))")
                    Spacer()
                    Slider(value: $settings.speechRate, in: 0.7...1.2, step: 0.1)
                        .frame(maxWidth: 180)
                }

                Text("Controls the voice and speed used by the Read Aloud button on concept pages and articles.")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Section(header: Text("Data")) {
                Button(action: { showClearConfirm = true }) {
                    Text("Clear All History")
                        .foregroundColor(.red)
                }
                .alert(isPresented: $showClearConfirm) {
                    Alert(
                        title: Text("Clear all translation history?"),
                        message: Text("This removes all translations from history and favorites. Practice progress will also be reset."),
                        primaryButton: .destructive(Text("Clear All")) { clearHistory() },
                        secondaryButton: .cancel()
                    )
                }
            }

            Section(header: Text("About")) {
                HStack {
                    Text("App")
                    Spacer()
                    Text("Sanskrit Kosh v1.0").foregroundColor(.secondary)
                }
                HStack {
                    Text("For")
                    Spacer()
                    Text("Class 7 Sanskrit students").foregroundColor(.secondary)
                }
                HStack {
                    Text("Cost")
                    Spacer()
                    Text("Completely free").foregroundColor(.green)
                }
                HStack {
                    Text("Dictionary")
                    Spacer()
                    Text("\(SanskritDictionary.shared.entries.count) entries").foregroundColor(.secondary)
                }
            }
        }
        .onAppear {
            if let existing = settings.parentPIN, !existing.isEmpty {
                pinSaved = true
            }
        }
    }

    // MARK: - Actions

    private func validatePIN() {
        let currentPIN = settings.parentPIN ?? ""
        if !currentPIN.isEmpty && pinInput == currentPIN {
            isUnlocked = true
            pinError = false
        } else if currentPIN.isEmpty {
            settings.parentPINEnabled = false
            isUnlocked = true
            pinError = false
        } else {
            pinError = true
            pinInput = ""
        }
    }

    private func clearHistory() {
        dataStore.deleteAllTranslations()
        dataStore.deleteAllProgress()
    }
}

// MARK: - PIN entry (locked state)

struct PINEntryView: View {
    @Binding var pinInput: String
    @Binding var pinError: Bool
    let onSubmit: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "lock.fill")
                .font(.system(size: 48))
                .foregroundColor(Color.compatIndigo)

            Text("Parent Settings")
                .font(.title2.weight(.semibold))

            Text("Enter the parent PIN to access settings.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            SecureField("Enter PIN", text: $pinInput)
                .textFieldStyle(.roundedBorder)
                .frame(width: 200)
                .multilineTextAlignment(.center)
                .accessibilityLabel("Parent PIN")
                .onChange(of: pinInput) { value in
                    let digits = value.filter { $0.isNumber }
                    if digits != value {
                        pinInput = digits
                    }
                }

            if pinError {
                Text("Incorrect PIN. Please try again.")
                    .font(.caption)
                    .foregroundColor(.red)
            }

            Button("Unlock") { onSubmit() }
                .disabled(pinInput.count < 4)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
