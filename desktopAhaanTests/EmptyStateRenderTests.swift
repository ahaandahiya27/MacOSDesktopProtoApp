import XCTest
import SwiftUI
@testable import desktopAhaan

/// Smoke-renders the day-one empty states so an empty data store doesn't crash
/// the Daily Plan / Achievement windows, and pins the starter-badge selection.
@MainActor
final class EmptyStateRenderTests: XCTestCase {

    /// Force a SwiftUI view body to evaluate by hosting it. Throws/crashes if
    /// the body references something unsafe on an empty world.
    private func render<V: View>(_ view: V) {
        let host = NSHostingView(rootView: view)
        host.frame = NSRect(x: 0, y: 0, width: 600, height: 600)
        host.layoutSubtreeIfNeeded()
        XCTAssertNotNil(host)
    }

    // MARK: - Daily Plan empty state

    func testDailyPlanEmptyStateRendersWithoutCrash() {
        render(DailyPlanEmptyStateView(onStart: {}))
    }

    func testDailyPlanEmptyStateInvokesOnStart() {
        var started = false
        let view = DailyPlanEmptyStateView(onStart: { started = true })
        view.onStart?()
        XCTAssertTrue(started)
    }

    // MARK: - Achievement gallery empty state

    func testAchievementEmptyStateShowsFirstThreeBronze() {
        let starters = AchievementGalleryEmptyStateView.starterBadges
        XCTAssertEqual(starters.count, 3)
        XCTAssertTrue(starters.allSatisfy { $0.tier == .bronze },
                      "Starter goals are all bronze.")
        // They're the first three bronze badges in catalog order.
        let expected = Array(Achievement.all.filter { $0.tier == .bronze }.prefix(3)).map { $0.id }
        XCTAssertEqual(starters.map { $0.id }, expected)
    }

    func testAchievementEmptyStateRendersWithEmptySnapshot() {
        render(AchievementGalleryEmptyStateView(snapshot: AchievementSnapshot()))
    }

    func testAchievementEmptyStateStarterBadgesHaveHowToEarnText() {
        for badge in AchievementGalleryEmptyStateView.starterBadges {
            XCTAssertFalse(badge.detail.isEmpty, "\(badge.id) needs how-to-earn text.")
        }
    }
}
