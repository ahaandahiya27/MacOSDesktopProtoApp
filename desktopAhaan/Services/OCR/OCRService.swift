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
        guard let cgImage = image.cgImage else {
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
            if #available(iOS 16.0, *) {
                request.automaticallyDetectsLanguage = true
            }
            // Support English, Hindi, Sanskrit (Devanagari script)
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

private extension NSImage {
    var cgImage: CGImage? {
        var rect = CGRect(origin: .zero, size: size)
        return cgImage(forProposedRect: &rect, context: nil, hints: nil)
    }
}
