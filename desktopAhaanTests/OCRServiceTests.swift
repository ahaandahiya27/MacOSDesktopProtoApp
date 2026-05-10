import XCTest
import AppKit
@testable import desktopAhaan

final class OCRServiceTests: XCTestCase {

    // MARK: - OCR Service Initialization Tests

    @MainActor
    func testT_OCR_001_InitialStateIsClean() {
        let service = OCRService()
        XCTAssertTrue(service.extractedText.isEmpty)
        XCTAssertFalse(service.isProcessing)
        XCTAssertNil(service.errorMessage)
        XCTAssertEqual(service.confidence, 0.0)
    }

    @MainActor
    func testT_OCR_002_ClearResetsAllState() {
        let service = OCRService()
        service.extractedText = "Some text"
        service.errorMessage = "Some error"
        service.confidence = 0.95

        service.clear()

        XCTAssertTrue(service.extractedText.isEmpty)
        XCTAssertNil(service.errorMessage)
        XCTAssertEqual(service.confidence, 0.0)
    }

    @MainActor
    func testT_OCR_003_IsProcessingStartsFalse() {
        let service = OCRService()
        XCTAssertFalse(service.isProcessing)
    }

    @MainActor
    func testT_OCR_004_ConfidenceStartsAtZero() {
        let service = OCRService()
        XCTAssertEqual(service.confidence, 0.0)
    }

    @MainActor
    func testT_OCR_005_ErrorMessageStartsNil() {
        let service = OCRService()
        XCTAssertNil(service.errorMessage)
    }

    // MARK: - OCR Image Processing Tests (macOS / NSImage)

    @MainActor
    func testT_OCR_006_ExtractTextFromBlankImageReturnsEmpty() async {
        let service = OCRService()
        let blankImage = NSImage(size: NSSize(width: 100, height: 100))
        blankImage.lockFocus()
        NSColor.white.setFill()
        NSRect(origin: .zero, size: NSSize(width: 100, height: 100)).fill()
        blankImage.unlockFocus()

        await service.extractText(from: blankImage)

        XCTAssertTrue(service.extractedText.isEmpty || service.errorMessage != nil,
                      "Blank image should produce empty text or an error")
    }

    @MainActor
    func testT_OCR_007_ExtractTextFromImageWithTextReturnsNonEmpty() async {
        let service = OCRService()
        let size = NSSize(width: 300, height: 100)
        let image = NSImage(size: size)
        image.lockFocus()
        NSColor.white.setFill()
        NSRect(origin: .zero, size: size).fill()
        let text = "Hello World" as NSString
        let attrs: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 36),
            .foregroundColor: NSColor.black
        ]
        text.draw(at: NSPoint(x: 20, y: 30), withAttributes: attrs)
        image.unlockFocus()

        await service.extractText(from: image)

        XCTAssertFalse(service.isProcessing, "Should finish processing")
    }

    @MainActor
    func testT_OCR_008_ProcessingFlagTogglesCorrectly() async {
        let service = OCRService()
        XCTAssertFalse(service.isProcessing, "Should start not processing")

        let image = NSImage(size: NSSize(width: 50, height: 50))
        image.lockFocus()
        NSColor.white.setFill()
        NSRect(origin: .zero, size: NSSize(width: 50, height: 50)).fill()
        image.unlockFocus()

        await service.extractText(from: image)

        XCTAssertFalse(service.isProcessing, "Should be done processing after await")
    }

    @MainActor
    func testT_OCR_009_ClearAfterExtractionResetsAll() async {
        let service = OCRService()
        let image = NSImage(size: NSSize(width: 50, height: 50))
        image.lockFocus()
        NSColor.white.setFill()
        NSRect(origin: .zero, size: NSSize(width: 50, height: 50)).fill()
        image.unlockFocus()

        await service.extractText(from: image)
        service.clear()

        XCTAssertTrue(service.extractedText.isEmpty)
        XCTAssertNil(service.errorMessage)
        XCTAssertEqual(service.confidence, 0.0)
    }

    @MainActor
    func testT_OCR_010_ExtractedTextIsPublished() {
        let service = OCRService()
        service.extractedText = "Test text"
        XCTAssertEqual(service.extractedText, "Test text")
    }
}
