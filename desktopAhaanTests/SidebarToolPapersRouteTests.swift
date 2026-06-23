import XCTest
@testable import desktopAhaan

/// Pins the sidebar-route invariants added 2026-06-23 to surface
/// Boss Challenge + Brutal Series in the primary navigation, alongside
/// the existing Help-menu (⌘⌥B / ⌘⌥R) entry points.
///
/// Three contracts to lock:
///   1. `SidebarTool.allCases` contains both new cases (sidebar list
///      iterates this).
///   2. `SidebarSelection.tool(.<paper-browser>)` round-trips through
///      `persistedString` so the new selections survive an app restart.
///   3. Each new tool's title/systemImage/keyboardShortcut returns the
///      expected user-facing strings — locks both the sidebar label
///      and the trailing-badge shortcut text. The shortcut strings are
///      DISPLAY ONLY; the actual binding lives in `desktopAhaanApp.swift`.
@MainActor
final class SidebarToolPapersRouteTests: XCTestCase {

    func testAllCasesIncludesBossChallengeAndBrutalSeries() {
        let cases = SidebarTool.allCases
        XCTAssertTrue(cases.contains(.bossChallenge),
            "SidebarTool.allCases must include .bossChallenge for sidebar list render.")
        XCTAssertTrue(cases.contains(.brutalSeries),
            "SidebarTool.allCases must include .brutalSeries for sidebar list render.")
    }

    /// Sidebar ordering — Boss Challenge and Brutal Series cluster next
    /// to Olympiad (the existing practice-paper hub) and ahead of
    /// Settings, which sits last. If a future edit shuffles them
    /// arbitrarily the kid's mental model of the sidebar shifts.
    func testPaperBrowsersClusterAfterOlympiadBeforeSettings() {
        let cases = SidebarTool.allCases
        guard let olympiad = cases.firstIndex(of: .olympiad),
              let boss = cases.firstIndex(of: .bossChallenge),
              let brutal = cases.firstIndex(of: .brutalSeries),
              let settings = cases.firstIndex(of: .settings) else {
            XCTFail("Required tools missing from allCases.")
            return
        }
        XCTAssertLessThan(olympiad, boss,
            ".olympiad should come before .bossChallenge in the sidebar")
        XCTAssertLessThan(boss, brutal,
            ".bossChallenge should come before .brutalSeries (alphabetical-with-purpose).")
        XCTAssertLessThan(brutal, settings,
            ".brutalSeries should come before .settings (settings sits last).")
    }

    func testBossChallengeUserFacingStrings() {
        XCTAssertEqual(SidebarTool.bossChallenge.title, "Boss Challenge")
        XCTAssertEqual(SidebarTool.bossChallenge.systemImage, "crown.fill")
        // Display string for the trailing badge: ⌘⌥B
        XCTAssertEqual(SidebarTool.bossChallenge.keyboardShortcut, "\u{2318}\u{2325}B")
    }

    func testBrutalSeriesUserFacingStrings() {
        XCTAssertEqual(SidebarTool.brutalSeries.title, "Brutal Series")
        XCTAssertEqual(SidebarTool.brutalSeries.systemImage, "bolt.fill")
        // Display string for the trailing badge: ⌘⌥R
        XCTAssertEqual(SidebarTool.brutalSeries.keyboardShortcut, "\u{2318}\u{2325}R")
    }

    /// Both selections must round-trip through `SidebarSelection.persistedString`
    /// so the new selection survives the `@AppStorage` save/restore on
    /// app relaunch. A regression here would silently drop the kid back
    /// to the default subject on every cold start.
    func testBossChallengeSelectionRoundTripsThroughPersistedString() {
        let original = SidebarSelection.tool(.bossChallenge)
        let raw = original.persistedString
        XCTAssertEqual(raw, "tool:bossChallenge")
        let restored = SidebarSelection(persistedString: raw)
        XCTAssertEqual(restored, original,
            "Boss Challenge selection must round-trip through persistedString.")
    }

    func testBrutalSeriesSelectionRoundTripsThroughPersistedString() {
        let original = SidebarSelection.tool(.brutalSeries)
        let raw = original.persistedString
        XCTAssertEqual(raw, "tool:brutalSeries")
        let restored = SidebarSelection(persistedString: raw)
        XCTAssertEqual(restored, original,
            "Brutal Series selection must round-trip through persistedString.")
    }

    /// SF-Symbols pin: both icons must be names that are available in
    /// the Big-Sur SF Symbols 2 set. `crown.fill` and `bolt.fill` are
    /// both SF1+, so passing them through `SFSymbolCompat.name(_:)`
    /// returns the same string. This is a forward-compat check — if a
    /// future maintainer swaps to an SF3+ symbol, this test catches it.
    func testIconsAreBigSurSafe() {
        XCTAssertEqual(
            SFSymbolCompat.name(SidebarTool.bossChallenge.systemImage),
            SidebarTool.bossChallenge.systemImage,
            "Boss Challenge icon must be Big-Sur safe (SF Symbols 2 set).")
        XCTAssertEqual(
            SFSymbolCompat.name(SidebarTool.brutalSeries.systemImage),
            SidebarTool.brutalSeries.systemImage,
            "Brutal Series icon must be Big-Sur safe (SF Symbols 2 set).")
    }
}
