import XCTest
import SwiftUI
@testable import desktopAhaan

// MARK: - ShapeDiagramRegistryTests
//
// Pins the v7 Phase 3 Shape Diagram Library. As chapter-slices land, the
// `ShapeDiagramRegistry` grows from empty toward the 76 `shapeDiagram`
// MediaAsset resource keys authored in `science_class7.json`. These tests
// guard two invariants per slice:
//   • no ORPHAN registration — every registered key is a real pack resource
//     (a typo'd key would silently never render);
//   • every registered key resolves to a non-nil factory (the lookup works).
// Plus a per-slice coverage floor (ch01's four keys are all registered).
final class ShapeDiagramRegistryTests: XCTestCase {

    /// All `shapeDiagram` resource keys declared across the science pack.
    private func packDiagramKeys() throws -> Set<String> {
        let pack = try loadPack("science_class7")
        var keys = Set<String>()
        for ch in pack.chapters {
            for asset in ch.mediaAssetsList where asset.kind == .shapeDiagram {
                if let r = asset.resource { keys.insert(r) }
            }
        }
        return keys
    }

    /// Every REGISTERED diagram key must correspond to a real pack resource —
    /// no orphan registrations that can never be reached by MediaAssetView.
    func testNoOrphanRegistrations() throws {
        let packKeys = try packDiagramKeys()
        for key in ShapeDiagramRegistry.registeredKeys {
            XCTAssertTrue(packKeys.contains(key),
                "Registered diagram '\(key)' has no matching shapeDiagram resource in the pack — orphan registration.")
        }
    }

    /// Every registered key resolves to a non-nil factory (the lookup path
    /// MediaAssetView depends on actually works).
    func testRegisteredKeysResolveToAFactory() {
        for key in ShapeDiagramRegistry.registeredKeys {
            XCTAssertNotNil(ShapeDiagramRegistry.factory(for: key),
                "Registered diagram '\(key)' did not resolve to a factory.")
        }
    }

    /// An unregistered key must return nil so MediaAssetView falls back to its
    /// placeholder card (no crash, no wrong diagram).
    func testUnregisteredKeyReturnsNil() {
        XCTAssertNil(ShapeDiagramRegistry.factory(for: "ch99_does_not_exist"))
    }

    /// Chapter prefixes that the v7 Phase 3 library has fully illustrated so
    /// far. Each landed chapter is appended here; the test then asserts that
    /// EVERY shapeDiagram key the pack declares for that chapter resolves to a
    /// registered factory — a per-chapter completeness floor.
    private static let fullyCoveredChapters = [
        "ch01",   // Nutrition in Plants
        "ch02",   // Nutrition in Animals
        "ch03",   // Fibre to Fabric (wool & silk)
        "ch04",   // Heat
        "ch05"    // Acids, Bases and Salts
    ]

    /// Coverage floor — every key the pack declares for a fully-covered
    /// chapter is registered AND resolves to a factory.
    func testFullyCoveredChaptersAreComplete() throws {
        let packKeys = try packDiagramKeys()
        let registered = Set(ShapeDiagramRegistry.registeredKeys)
        for ch in Self.fullyCoveredChapters {
            let chapterKeys = packKeys.filter { $0.hasPrefix(ch + "_") }
            XCTAssertFalse(chapterKeys.isEmpty,
                "Pack declares no shapeDiagram keys for covered chapter '\(ch)'.")
            for key in chapterKeys {
                XCTAssertTrue(registered.contains(key),
                    "Chapter '\(ch)' diagram '\(key)' is authored in the pack but not registered.")
                XCTAssertNotNil(ShapeDiagramRegistry.factory(for: key),
                    "Chapter '\(ch)' diagram '\(key)' did not resolve to a factory.")
            }
        }
    }

    // MARK: - Helpers

    private func loadPack(_ resource: String) throws -> SubjectPack {
        guard let url = Bundle.main.url(forResource: resource, withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            throw XCTSkip("\(resource).json missing from test bundle.")
        }
        return try JSONDecoder().decode(SubjectPack.self, from: data)
    }
}
