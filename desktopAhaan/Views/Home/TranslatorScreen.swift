import SwiftUI
import SwiftData
import AppKit

struct TranslatorScreen: View {
    @StateObject private var vm = TranslatorViewModel()
    @EnvironmentObject var appState: AppState
    @Environment(\.modelContext) private var modelContext
    @FocusState private var isInputFocused: Bool

    var body: some View {
        ScrollViewReader { scrollProxy in
            ScrollView {
                VStack(spacing: 20) {
                    // Online/Offline indicator
                    if !appState.isOnline {
                        OfflineBanner()
                    }

                    // Language selector
                    LanguageSelectorBar(
                        source: $vm.sourceLanguage,
                        target: $vm.targetLanguage,
                        onSwap: { vm.swapLanguages() },
                        onSourceChanged: { vm.onSourceChanged() }
                    )

                    // Input area
                    InputCard(
                        text: $vm.inputText,
                        sourceLanguage: vm.sourceLanguage,
                        isListening: vm.speechManager.isListening,
                        isFocused: $isInputFocused,
                        onMicTap: {
                            isInputFocused = false // Dismiss keyboard when mic starts
                            vm.startVoiceInput()
                        }
                    )

                    // Action buttons
                    HStack(spacing: 16) {
                        Button(action: {
                            isInputFocused = false
                            vm.clear()
                        }) {
                            Label("Clear", systemImage: "xmark.circle")
                                .font(.subheadline.weight(.medium))
                        }
                        .buttonStyle(.bordered)
                        .tint(.secondary)

                        Button(action: {
                            runTranslate(scrollProxy: scrollProxy)
                        }) {
                            Label("Translate", systemImage: "arrow.right.circle.fill")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.indigo)
                        .keyboardShortcut(.return, modifiers: .command)
                        .disabled(vm.inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || vm.isTranslating)
                    }
                    .padding(.horizontal)

                    // Loading
                    if vm.isTranslating {
                        ProgressView("Translating...")
                            .padding()
                    }

                    // Error
                    if let error = vm.errorMessage {
                        ErrorCard(message: error)
                    }

                    // Speech error / info (dismissible)
                    if let speechError = vm.speechManager.errorMessage {
                        InfoCard(
                            message: speechError,
                            icon: "mic.slash",
                            color: .orange,
                            onDismiss: { vm.speechManager.clearError() }
                        )
                        .transition(.move(edge: .top).combined(with: .opacity))
                    }

                    // Result
                    if let result = vm.result, vm.showResult {
                        TranslationResultCard(
                            response: result,
                            onSpeak: { vm.speakResult() },
                            isSpeaking: vm.ttsManager.isSpeaking,
                            onFavorite: { vm.toggleFavorite(for: result, modelContext: modelContext) },
                            isFavorited: vm.isFavorited
                        )
                        .id("resultCard")

                        if !vm.translationSource.isEmpty {
                            HStack(spacing: 4) {
                                Image(systemName: vm.translationSource.contains("Online") ? "globe" : "internaldrive")
                                    .font(.caption2)
                                Text("via \(vm.translationSource)")
                                    .font(.caption2)
                            }
                            .foregroundStyle(.tertiary)
                        }
                    }

                    // Bottom spacer so content isn't hidden behind keyboard
                    Spacer()
                        .frame(height: 40)
                }
                .padding(.vertical)
            }
            .scrollDismissesKeyboard(.interactively)
            .onReceive(NotificationCenter.default.publisher(for: .translateCommand)) { _ in
                runTranslate(scrollProxy: scrollProxy)
            }
        }
        .navigationTitle("Sanskrit Kosh")
        .onTapGesture {
            isInputFocused = false
        }
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
        isInputFocused = false
        Task {
            await vm.translate(modelContext: modelContext, isOnline: appState.isOnline)
            withAnimation {
                scrollProxy.scrollTo("resultCard", anchor: .top)
            }
        }
    }
}
