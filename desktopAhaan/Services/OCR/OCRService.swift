import Foundation
import Combine
import Vision
import AppKit

/// OCR service using Apple Vision framework for text extraction
@MainActor
final class OCRService: ObservableObject {
    @Published var extractedText: String = ""
    @Published var isProcessing: Bool = false
    @Published var errorMessage: String?
    @Published var confidence: Double = 0.0

    /// Extract text from an NSImage using Vision framework
    func extractText(from image: NSImage) async {
        let scaled = Self.downscaleIfNeeded(image, maxDimension: 2048)
        guard let cgImage = scaled.cgImage else {
            errorMessage = "Could not process this image. Please try another one."
            return
        }

        isProcessing = true
        errorMessage = nil
        extractedText = ""
        confidence = 0.0

        do {
            let result = try await performOCR(on: cgImage)
            extractedText = result.text
            confidence = result.confidence
            if result.text.isEmpty {
                errorMessage = "No text found in the image. Try a clearer photo with visible text."
            }
        } catch {
            errorMessage = "Could not read text from the image: \(error.localizedDescription)"
        }

        isProcessing = false
    }

    private func performOCR(on cgImage: CGImage) async throws -> (text: String, confidence: Double) {
        try await withCheckedThrowingContinuation { continuation in
            let request = VNRecognizeTextRequest { request, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }

                guard let observations = request.results as? [VNRecognizedTextObservation] else {
                    continuation.resume(returning: ("", 0.0))
                    return
                }

                var lines: [String] = []
                var totalConfidence: Double = 0

                for observation in observations {
                    if let topCandidate = observation.topCandidates(1).first {
                        lines.append(topCandidate.string)
                        totalConfidence += Double(topCandidate.confidence)
                    }
                }

                let avgConfidence = observations.isEmpty ? 0.0 : totalConfidence / Double(observations.count)
                let text = lines.joined(separator: "\n")
                continuation.resume(returning: (text, avgConfidence))
            }

            // Configure for multiple languages including Devanagari
            request.recognitionLevel = .accurate
            request.usesLanguageCorrection = true
            // automaticallyDetectsLanguage was added in macOS 13. The symbol
            // is not in the macOS 12 SDK that ships with Big Sur's Xcode 13.2,
            // so we can't reference it directly even behind an #available
            // guard. KVC bypasses compile-time symbol resolution; the call is
            // gated by #available so it only runs on macOS 13+.
            if #available(macOS 13.0, *) {
                request.setValue(true, forKey: "automaticallyDetectsLanguage")
            }
            // Support English, Hindi, Sanskrit (Devanagari script).
            // On Big Sur this is the authoritative language list; on macOS 13+
            // it's a fallback if auto-detection can't decide.
            request.recognitionLanguages = ["en", "hi", "sa"]

            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            do {
                try handler.perform([request])
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }

    func clear() {
        extractedText = ""
        isProcessing = false
        errorMessage = nil
        confidence = 0.0
    }
}

extension OCRService {
    static func downscaleIfNeeded(_ image: NSImage, maxDimension: CGFloat) -> NSImage {
        let w = image.size.width
        let h = image.size.height
        guard max(w, h) > maxDimension else { return image }
        let scale = maxDimension / max(w, h)
        let newSize = NSSize(width: w * scale, height: h * scale)
        let resized = NSImage(size: newSize)
        resized.lockFocus()
        image.draw(in: NSRect(origin: .zero, size: newSize),
                   from: NSRect(origin: .zero, size: image.size),
                   operation: .copy, fraction: 1.0)
        resized.unlockFocus()
        return resized
    }
}

private extension NSImage {
    var cgImage: CGImage? {
        var rect = CGRect(origin: .zero, size: size)
        return cgImage(forProposedRect: &rect, context: nil, hints: nil)
    }
}
