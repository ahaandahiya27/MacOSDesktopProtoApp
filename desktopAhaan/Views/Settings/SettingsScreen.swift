import SwiftUI
import SwiftData

/// Settings screen, redesigned for macOS native look.
///
/// Why this rewrite: the original screen used iOS `Form` patterns with bare
/// HStacks. On macOS this caused visible content overflow (right-side text
/// truncated as "246 entr..." and "Completely F..." in the original
/// screenshots). The fix:
///   • `.formStyle(.grouped)` for proper macOS section styling.
///   • `LabeledContent` for two-column rows that flow correctly.
///   • A `GroupBox` above the Form for the "How It Works" rich content,
///     which Forms aren't designed for.
///   • `.frame(maxWidth: 540)` so the form doesn't sprawl across wide windows.
struct SettingsScreen: View {
    @ObservedObject private var settings = SettingsManager.shared
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var subjectRegistry: SubjectRegistry
    @State private var pinInput = ""
    @State private var isUnlocked = false
    @State private var pinError = false
    @State private var showClearConfirm = false
    @State private var newPIN = ""
    @State private var pinSaved = false

    @Environment(\.modelContext) private var modelContext

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
                    .frame(maxWidth: .infinity)  // outer container fills, inner caps width
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
        .foregroundStyle(.secondary)
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.background.secondary, in: RoundedRectangle(cornerRadius: 8))
    }

    // MARK: - How It Works (rich, lives outside the Form)

    private var howItWorks: some View {
        GroupBox {
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 10) {
                    Image(systemName: "checkmark.shield.fill")
                        .foregroundStyle(.green)
                        .font(.title3)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("No API Key Needed").font(.subheadline.weight(.semibold))
                        Text("Free to use. No accounts, no keys, no subscriptions.")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }

                Divider()

                Label("How It Works", systemImage: "gearshape.2")
                    .font(.caption.weight(.semibold))

                VStack(alignment: .leading, spacing: 8) {
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "internaldrive")
                            .font(.caption)
                            .foregroundStyle(.indigo)
                            .frame(width: 16)
                        Text("**Built-in Dictionary** — words and sentences from the Class 7 NCERT syllabus. Works offline, always free, always available.")
                            .font(.caption2)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "globe")
                            .font(.caption)
                            .foregroundStyle(.blue)
                            .frame(width: 16)
                        Text("**Online Translation** — for phrases not in the dictionary, the app uses a free online service (MyMemory). No registration. Limit: ~1000 words/day.")
                            .font(.caption2)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .foregroundStyle(.secondary)
            }
            .padding(4)
        } label: {
            Label("Translation", systemImage: "character.book.closed")
        }
    }

    // MARK: - Settings form (the macOS-friendly bits)

    private var settingsForm: some View {
        Form {
            // Connection status
            Section("Status") {
                LabeledContent("Connection") {
                    HStack(spacing: 6) {
                        Circle()
                            .fill(appState.isOnline ? .green : .orange)
                            .frame(width: 8, height: 8)
                        Text(appState.isOnline ? "Online" : "Offline")
                            .foregroundStyle(.secondary)
                    }
                }
                Toggle("Dictionary Only (Offline Mode)", isOn: $settings.preferOffline)
                Text("When on, the app only uses the built-in dictionary — no internet requests at all. History, favorites, flashcards, and quizzes always work offline.")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            // Parent PIN
            Section("Parent Lock") {
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
                    LabeledContent("Set PIN (4–6 digits)") {
                        HStack(spacing: 8) {
                            SecureField("PIN", text: $newPIN)
                                .frame(maxWidth: 120)
                                .accessibilityLabel("Parent PIN, 4 to 6 digits")
                                .onChange(of: newPIN) { _, value in
                                    let digits = value.filter { $0.isNumber }
                                    newPIN = String(digits.prefix(6))
                                }

                            if newPIN.count >= 4 {
                                Button("Save") {
                                    settings.parentPIN = newPIN
                                    settings.parentPINEnabled = true
                                    pinSaved = true
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(.indigo)
                            }
                        }
                    }

                    if pinSaved {
                        Label("PIN saved. Settings will be locked when you leave this tab.", systemImage: "checkmark.circle.fill")
                            .font(.caption2)
                            .foregroundStyle(.green)
                    } else {
                        Text("Enter at least 4 digits and tap Save to enable the parent lock.")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }

                    Text("Protects this Settings screen only. Translation, history, favorites, and practice remain freely accessible.")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            // Subject pack status — surfaces SubjectRegistry's loadErrors
            // so the user can see when a JSON pack failed to decode.
            Section("Subject packs") {
                if subjectRegistry.isLoading {
                    LabeledContent("Status", value: "Loading…")
                } else {
                    LabeledContent("Loaded", value: "\(subjectRegistry.packs.count) pack\(subjectRegistry.packs.count == 1 ? "" : "s")")
                    ForEach(subjectRegistry.packs) { pack in
                        LabeledContent(pack.title) {
                            Text("v\(pack.version) · \(pack.conceptCount) concepts")
                                .foregroundStyle(.secondary)
                        }
                    }
                    if subjectRegistry.loadErrors.isEmpty {
                        Label("All packs decoded successfully.", systemImage: "checkmark.circle")
                            .font(.caption2)
                            .foregroundStyle(.green)
                    } else {
                        Label("\(subjectRegistry.loadErrors.count) pack(s) failed to load:",
                              systemImage: "exclamationmark.triangle.fill")
                            .font(.caption2)
                            .foregroundStyle(.orange)
                        ForEach(subjectRegistry.loadErrors, id: \.self) { err in
                            Text(err)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
            }

            // Speech
            Section("Read Aloud") {
                LabeledContent("Voice") {
                    Picker("Language", selection: $settings.speechLanguage) {
                        ForEach(SettingsManager.availableLanguages, id: \.id) { lang in
                            Text(lang.label).tag(lang.id)
                        }
                    }
                    .labelsHidden()
                    .frame(maxWidth: 180)
                }

                LabeledContent("Speed (\(String(format: "%.1f×", settings.speechRate)))") {
                    Slider(value: $settings.speechRate, in: 0.7...1.2, step: 0.1)
                        .frame(maxWidth: 180)
                }

                Text("Controls the voice and speed used by the Read Aloud button on concept pages and articles.")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            // Data
            Section("Data") {
                Button("Clear All History", role: .destructive) {
                    showClearConfirm = true
                }
                .confirmationDialog("Clear all translation history?", isPresented: $showClearConfirm) {
                    Button("Clear All", role: .destructive) { clearHistory() }
                    Button("Cancel", role: .cancel) {}
                } message: {
                    Text("This removes all translations from history and favorites. Practice progress will also be reset.")
                }
            }

            // About
            Section("About") {
                LabeledContent("App", value: "Sanskrit Kosh v1.0")
                LabeledContent("For", value: "Class 7 Sanskrit students")
                LabeledContent("Cost") {
                    Text("Completely free").foregroundStyle(.green)
                }
                LabeledContent("Dictionary", value: "\(SanskritDictionary.shared.entries.count) entries")
            }
        }
        .formStyle(.grouped)
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
        try? modelContext.delete(model: TranslationRecord.self)
        try? modelContext.delete(model: PracticeProgress.self)
        modelContext.safeSave()
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
                .foregroundStyle(.indigo)

            Text("Parent Settings")
                .font(.title2.weight(.semibold))

            Text("Enter the parent PIN to access settings.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            SecureField("Enter PIN", text: $pinInput)
                .textFieldStyle(.roundedBorder)
                .frame(width: 200)
                .multilineTextAlignment(.center)
                .accessibilityLabel("Parent PIN")
                .onSubmit { onSubmit() }
                .onChange(of: pinInput) { _, value in
                    let digits = value.filter { $0.isNumber }
                    if digits != value {
                        pinInput = digits
                    }
                }

            if pinError {
                Text("Incorrect PIN. Please try again.")
                    .font(.caption)
                    .foregroundStyle(.red)
            }

            Button("Unlock") { onSubmit() }
                .buttonStyle(.borderedProminent)
                .tint(.indigo)
                .disabled(pinInput.count < 4)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
