import SwiftUI
import AppKit

struct TranslatorScreen: View {
    @StateObject private var vm = TranslatorViewModel()
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var dataStore: DataStore

    var body: some View {
        ScrollViewReader { scrollProxy in
            ScrollView {
                VStack(spacing: 20) {
                    if !appState.isOnline {
                        OfflineBanner()
                    }

                    LanguageSelectorBar(
                        source: $vm.sourceLanguage,
                        target: $vm.targetLanguage,
                        onSwap: { vm.swapLanguages() },
                        onSourceChanged: { vm.onSourceChanged() }
                    )

                    InputCard(
                        text: $vm.inputText,
                        sourceLanguage: vm.sourceLanguage,
                        isListening: vm.speechManager.isListening,
                        onMicTap: {
                            vm.startVoiceInput()
                        }
                    )

                    HStack(spacing: DesignTokens.Spacing.lg) {
                        Button(action: {
                            vm.clear()
                        }) {
                            Label("Clear", systemImage: "xmark.circle")
                                .font(.subheadline.weight(.medium))
                        }
                        .accessibilityIdentifier("translator-clear")

                        Button(action: {
                            runTranslate(scrollProxy: scrollProxy)
                        }) {
                            Label("Translate", systemImage: "arrow.right.circle.fill")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                        }
                        .keyboardShortcut(.return, modifiers: .command)
                        .disabled(vm.inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || vm.isTranslating)
                        .accessibilityHint("Sends the text to the translation engine")
                        .accessibilityIdentifier("translator-translate")
                    }
                    .padding(.horizontal)

                    if vm.isTranslating {
                        ProgressView("Translating...")
                            .padding()
                    }

                    if let error = vm.errorMessage {
                        ErrorCard(message: error)
                    }

                    if let speechError = vm.speechManager.errorMessage {
                        InfoCard(
                            message: speechError,
                            icon: "mic.slash",
                            color: .orange,
                            onDismiss: { vm.speechManager.clearError() }
                        )
                        .transition(.opacity)  // Big Sur: combined-with-.move can render-loop
                    }

                    if let result = vm.result, vm.showResult {
                        TranslationResultCard(
                            response: result,
                            onSpeak: { vm.speakResult() },
                            isSpeaking: vm.ttsManager.isSpeaking,
                            onFavorite: { vm.toggleFavorite(for: result, dataStore: dataStore) },
                            isFavorited: vm.isFavorited
                        )
                        .id("resultCard")

                        if !vm.translationSource.isEmpty {
                            HStack(spacing: DesignTokens.Spacing.xs) {
                                Image(systemName: SFSymbolCompat.name(vm.translationSource.contains("Online") ? "globe" : "internaldrive"))
                                    .font(.caption2)
                                Text("via \(vm.translationSource)")
                                    .font(.caption2)
                            }
                            .foregroundColor(.secondary)
                        }
                    }

                    Spacer()
                        .frame(height: 40)
                }
                .padding(.vertical)
            }
            .onReceive(NotificationCenter.default.publisher(for: .translateCommand)) { _ in
                runTranslate(scrollProxy: scrollProxy)
            }
        }
        .navigationTitle("Sanskrit Kosh")
        .onReceive(NotificationCenter.default.publisher(for: .speakResultCommand)) { _ in
            vm.speakResult()
        }
        .onReceive(NotificationCenter.default.publisher(for: .copyTranslationCommand)) { _ in
            guard let result = vm.result else { return }
            NSPasteboard.general.clearContents()
            NSPasteboard.general.setString(result.translatedText, forType: .string)
        }
    }

    private func runTranslate(scrollProxy: ScrollViewProxy) {
        Task {
            await vm.translate(dataStore: dataStore, isOnline: appState.isOnline)
            withAnimation {
                scrollProxy.scrollTo("resultCard", anchor: .top)
            }
        }
    }
}
