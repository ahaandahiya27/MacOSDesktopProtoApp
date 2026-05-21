import SwiftUI
import AppKit
import UniformTypeIdentifiers

struct OCRTranslationScreen: View {
    @StateObject private var ocrService = OCRService()
    @StateObject private var vm = TranslatorViewModel()
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var dataStore: DataStore

    @State private var selectedImage: NSImage?
    @State private var editedText: String = ""
    @State private var hasExtractedText = false
    /// Tracks whether a file is being dragged over the drop zone — drives
    /// the EM5 hover-state styling (dashed purple border + icon scale).
    @State private var isDropTargeted: Bool = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                imageSelectionArea

                if ocrService.isProcessing {
                    ProgressView("Reading text from image...")
                        .padding()
                }

                if let error = ocrService.errorMessage {
                    ErrorCard(message: error)
                }

                if hasExtractedText {
                    extractedTextEditor
                    translationControls
                }

                if vm.isTranslating {
                    ProgressView("Translating...")
                        .padding()
                }

                if let error = vm.errorMessage {
                    ErrorCard(message: error)
                }

                if let result = vm.result, vm.showResult {
                    TranslationResultCard(
                        response: result,
                        onSpeak: { vm.speakResult() },
                        isSpeaking: vm.ttsManager.isSpeaking,
                        onFavorite: { vm.toggleFavorite(for: result, dataStore: dataStore) },
                        isFavorited: vm.isFavorited
                    )
                }

                Spacer().frame(height: 40)
            }
            .padding(.vertical)
        }
        .navigationTitle("Scan & Translate")
        .onReceive(NotificationCenter.default.publisher(for: .openImageCommand)) { _ in
            openImagePanel()
        }
    }

    private var imageSelectionArea: some View {
        VStack(spacing: 12) {
            if let image = selectedImage {
                Image(nsImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 220)
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                Button("Choose Different Image") {
                    openImagePanel()
                }
                .font(.caption)
                .foregroundColor(.secondary)
                .pointingCursor()
            } else {
                VStack(spacing: 16) {
                    Image(systemName: SFSymbolCompat.name("doc.text.viewfinder"))
                        .font(.system(size: 48))
                        .foregroundColor(.purple)
                        .scaleEffect(isDropTargeted ? 1.08 : 1.0)
                        .animation(.spring(response: 0.25, dampingFraction: 0.65))

                    Text(isDropTargeted ? "Drop to scan" : "Open or Drop an Image")
                        .font(.headline)
                        .foregroundColor(isDropTargeted ? .purple : .primary)

                    Button(action: openImagePanel) {
                        Label("Open Image", systemImage: SFSymbolCompat.name("photo.on.rectangle.angled"))
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                    }
                    .pointingCursor()
                }
            }
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor))
        .overlay(
            // Drop-zone hover state: dashed purple border appears when the
            // user is dragging a valid file over the area (EM5).
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(
                    Color.purple.opacity(isDropTargeted ? 0.85 : 0),
                    style: StrokeStyle(lineWidth: 2, dash: [6, 4])
                )
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
        .onDrop(of: ["public.file-url"], isTargeted: $isDropTargeted, perform: handleDrop)
    }

    private var extractedTextEditor: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Extracted Text (editable)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Button("Clear") {
                    editedText = ""
                    hasExtractedText = false
                    selectedImage = nil
                    ocrService.clear()
                    vm.clear()
                }
                .font(.caption)
                .foregroundColor(.red)
            }

            TextEditor(text: $editedText)
                .frame(minHeight: 80, maxHeight: 150)
                .font(.body)
                .padding(8)
                .background(Color.gray.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                // Soft cap matched to a typical textbook page after OCR;
                // anything longer is almost certainly accidental paste.
                .onChange(of: editedText) { newValue in
                    if newValue.count > 2000 {
                        editedText = String(newValue.prefix(2000))
                    }
                }
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
    }

    private var translationControls: some View {
        VStack(spacing: 12) {
            LanguageSelectorBar(
                source: $vm.sourceLanguage,
                target: $vm.targetLanguage,
                onSwap: { vm.swapLanguages() },
                onSourceChanged: { vm.onSourceChanged() }
            )

            Button(action: {
                vm.inputText = editedText
                Task {
                    await vm.translate(dataStore: dataStore, isOnline: appState.isOnline)
                }
            }) {
                Label("Translate", systemImage: "arrow.right.circle.fill")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            }
            .disabled(editedText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || vm.isTranslating)
            .padding(.horizontal)
        }
    }

    private func openImagePanel() {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [.image]
        panel.canChooseFiles = true
        panel.canChooseDirectories = false
        panel.allowsMultipleSelection = false
        if panel.runModal() == .OK, let url = panel.url {
            loadImage(from: url)
        }
    }

    private func handleDrop(providers: [NSItemProvider]) -> Bool {
        guard let provider = providers.first(where: { $0.hasItemConformingToTypeIdentifier("public.file-url") }) else {
            return false
        }

        provider.loadItem(forTypeIdentifier: "public.file-url", options: nil) { item, _ in
            guard let data = item as? Data,
                  let url = URL(dataRepresentation: data, relativeTo: nil) else { return }
            // Only accept image files. Dropping a .txt or .pdf was previously
            // accepted silently and NSImage init would just fail without any
            // user-visible feedback.
            let ext = url.pathExtension.lowercased()
            let imageExtensions: Set<String> = [
                "png", "jpg", "jpeg", "heic", "heif", "tiff", "tif",
                "gif", "bmp", "webp"
            ]
            guard imageExtensions.contains(ext) else {
                Task { @MainActor in
                    ocrService.errorMessage = "That's not an image file. Drop a PNG, JPG, HEIC, or similar."
                }
                return
            }
            Task { @MainActor in
                loadImage(from: url)
            }
        }
        return true
    }

    @MainActor
    private func loadImage(from url: URL) {
        guard let image = NSImage(contentsOf: url) else {
            ocrService.errorMessage = "Couldn't open that image. The file may be corrupt or in an unsupported format."
            return
        }
        selectedImage = image
        Task {
            await ocrService.extractText(from: image)
            if !ocrService.extractedText.isEmpty {
                editedText = ocrService.extractedText
                hasExtractedText = true
            }
        }
    }
}
