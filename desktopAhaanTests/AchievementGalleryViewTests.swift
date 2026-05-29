import XCTest
import SwiftUI
import AppKit
@testable import desktopAhaan

/// Render smoke tests for the achievement UI. SwiftUI body internals aren't
/// introspectable in XCTest, so these render each view through an
/// `NSHostingView` and force a layout pass to catch any crash in `body` —
/// across empty / partial / full unlock states.
@MainActor
final class AchievementGalleryViewTests: XCTestCase {

    private var tmp: URL!
    private var store: DataStore!
    private var registry: SubjectRegistry!

    override func setUp() async throws {
        try await super.setUp()
        tmp = URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent("desktopAhaan-gallery-\(UUID().uuidString)")
        try FileManager.default.createDirectory(at: tmp, withIntermediateDirectories: true)
        store = DataStore(streakCalendar: nil, storeDir: tmp, autoLoad: false)
        registry = SubjectRegistry()
    }

    override func tearDown() async throws {
        try? FileManager.default.removeItem(at: tmp)
        store = nil; registry = nil; tmp = nil
        try await super.tearDown()
    }

    private func render<V: View>(_ view: V, height: CGFloat = 600) {
        let host = NSHostingView(rootView: view)
        host.frame = NSRect(x: 0, y: 0, width: 720, height: height)
        host.layoutSubtreeIfNeeded()
        XCTAssertGreaterThanOrEqual(host.fittingSize.height, 0)
    }

    // MARK: - Gallery container

    func testGalleryRendersOnEmptyState() {
        render(AchievementGalleryView()
            .environmentObject(store!)
            .environmentObject(registry!))
    }

    func testGalleryRendersWithPartialProgress() {
        // Seed signals so several badges read as "started" (visible, locked).
        store.understoodConceptIds = ["ch01_t01_c01", "ch01_t01_c02"]
        store.readArticleIds = ["ch01_beyond"]
        store.discoverProgress = [DiscoverProgress(chapterId: "ch01", sceneId: "s1")]
        render(AchievementGalleryView()
            .environmentObject(store!)
            .environmentObject(registry!))
    }

    // MARK: - Badge cell (both states)

    func testBadgeCellRendersLockedAndUnlocked() {
        let badge = Achievement.byId["mastery_10"]!
        var snap = AchievementSnapshot(); snap.conceptsMastered = 3
        render(AchievementBadgeView(
            achievement: badge, isUnlocked: false, unlockDate: nil,
            progress: badge.progress(in: snap)), height: 180)

        render(AchievementBadgeView(
            achievement: badge, isUnlocked: true,
            unlockDate: Date(timeIntervalSince1970: 1_700_000_000),
            progress: badge.progress(in: snap)), height: 180)
    }

    // MARK: - Detail sheet (both states)

    func testDetailSheetRenders() {
        let badge = Achievement.byId["streak_7"]!
        render(AchievementDetailSheet(
            achievement: badge, isUnlocked: false, unlockDate: nil,
            progress: badge.progress(in: AchievementSnapshot()),
            onClose: {}), height: 420)

        var snap = AchievementSnapshot(); snap.bestStreakDays = 7
        render(AchievementDetailSheet(
            achievement: badge, isUnlocked: true,
            unlockDate: Date(), progress: badge.progress(in: snap),
            onClose: {}), height: 420)
    }

    // MARK: - Toast

    func testToastRenders() {
        for id in ["streak_first_day", "mastery_subject", "discover_all_science"] {
            render(AchievementToastView(achievement: Achievement.byId[id]!), height: 100)
        }
    }
}
