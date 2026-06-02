import XCTest
import SwiftUI
@testable import desktopAhaan

// MARK: - TrendChartShapeTests
//
// v8 Longitudinal Insights · Phase 2. Pure geometry tests for the trend chart's
// drawing primitives. `Shape.path(in:)` is a pure function of its inputs, so we
// can pin the mapped coordinates without rendering anything — the cheapest
// possible "snapshot" of the chart's shape.

final class TrendChartShapeTests: XCTestCase {

    private let rect = CGRect(x: 0, y: 0, width: 100, height: 100)

    func testLineShapeMapsNormalizedPointsFlippingY() {
        // (0,0) → bottom-left (0,100); (1,1) → top-right (100,0).
        let shape = TrendLineShape(normalizedPoints: [CGPoint(x: 0, y: 0),
                                                      CGPoint(x: 1, y: 1)])
        let box = shape.path(in: rect).boundingRect
        XCTAssertEqual(box.minX, 0, accuracy: 0.001)
        XCTAssertEqual(box.minY, 0, accuracy: 0.001)
        XCTAssertEqual(box.maxX, 100, accuracy: 0.001)
        XCTAssertEqual(box.maxY, 100, accuracy: 0.001)
    }

    func testLineShapeMidpointMapsToCentreWithYFlip() {
        // A single mid point (0.5, 0.25) maps to x=50, y = 100 - 25 = 75.
        let shape = TrendLineShape(normalizedPoints: [CGPoint(x: 0.5, y: 0.25)])
        let box = shape.path(in: rect).boundingRect
        XCTAssertEqual(box.minX, 50, accuracy: 0.001)
        XCTAssertEqual(box.minY, 75, accuracy: 0.001)
    }

    func testLineShapeEmptyIsEmptyPath() {
        XCTAssertTrue(TrendLineShape(normalizedPoints: []).path(in: rect).isEmpty)
    }

    func testGridShapeSpansFullRect() {
        let box = TrendGridShape(lineCount: 5).path(in: rect).boundingRect
        XCTAssertEqual(box.minX, 0, accuracy: 0.001)
        XCTAssertEqual(box.minY, 0, accuracy: 0.001)
        XCTAssertEqual(box.width, 100, accuracy: 0.001)
        XCTAssertEqual(box.height, 100, accuracy: 0.001)
    }

    func testGridShapeClampsLineCountToAtLeastTwo() {
        // lineCount 1 is clamped to 2 — still draws the 0% and 100% frame edges,
        // so the path spans the full rect height rather than collapsing.
        let box = TrendGridShape(lineCount: 1).path(in: rect).boundingRect
        XCTAssertEqual(box.height, 100, accuracy: 0.001)
    }
}
