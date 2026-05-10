import SwiftUI
import AppKit

/// macOS placeholder to keep project structure aligned with iOS source.
/// OCR image selection is handled directly in OCRTranslationScreen via NSOpenPanel and drag & drop.
struct ImagePicker: View {
    @Binding var selectedImage: NSImage?

    var body: some View {
        EmptyView()
    }
}
