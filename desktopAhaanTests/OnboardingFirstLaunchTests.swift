import XCTest
import SwiftUI
import AppKit
@testable import desktopAhaan

/// First-launch onboarding (2026-05-30, Distribution & Onboarding sweep).
///
/// Covers the three things that, if broken, would either re-onboard a kid
/// who's already seen the tour or crash the tour itself:
///   1. Completing the tour flips `OnboardingState.hasSeenOnboarding` and the
///      flag persists across a fresh `OnboardingState` reading the same suite.
///   2. The canonical 4-page deck has the shape the view + presenter rely on
///      (page count, final-page CTA, non-empty copy, the three subjects).
///   3. Every page renders through an off-screen NSHostingView without crash.
///
/// State is driven against an isolated `UserDefaults` suite so tests never
/// touch `.standard` (which would leak the flag into the real app + other
/// test methods).
@MainActor
final class OnboardingFirstLaunchTests: XCTestCase {

    private var suiteName: String!
    private var defaults: UserDefaults!

    override func setUp() {
        super.setUp()
        suiteName = "onboarding-first-launch-\(UUID().uuidString)"
        defaults = UserDefaults(suiteName: suiteName)
    }

    override func tearDown() {
        defaults.removePersistentDomain(forName: suiteName)
        defaults = nil
        suiteName = nil
        super.tearDown()
    }

    // MARK: - Flag lifecycle

    /// A brand-new install reads "not seen" so the tour auto-presents.
    func testFreshInstallHasNotSeenOnboarding() {
        let state = OnboardingState(defaults: defaults)
        XCTAssertFalse(state.hasSeenOnboarding,
            "A fresh UserDefaults suite must read hasSeenOnboarding == false.")
    }

    /// Completing the tour (the presenter's `onGetStarted` / Done path calls
    /// `markSeen()`) flips the flag, and it stays flipped for a new instance
    /// reading the same backing store — i.e. it survives relaunch.
    func testCompletingTourPersistsHasSeenFlag() {
        let state = OnboardingState(defaults: defaults)
        XCTAssertFalse(state.hasSeenOnboarding)

        state.markSeen()
        XCTAssertTrue(state.hasSeenOnboarding,
            "markSeen() must set hasSeenOnboarding to true.")

        // Simulate the next launch: a fresh OnboardingState over the same
        // suite must still read "seen" so the tour does not re-present.
        let nextLaunch = OnboardingState(defaults: defaults)
        XCTAssertTrue(nextLaunch.hasSeenOnboarding,
            "The flag must persist across OnboardingState instances (relaunch).")
    }

    /// The flag is keyed on the documented UserDefaults key, so the view's
    /// `@AppStorage(OnboardingState.hasSeenOnboardingKey)` reads the same bit.
    func testFlagIsStoredUnderDocumentedKey() {
        let state = OnboardingState(defaults: defaults)
        state.markSeen()
        XCTAssertTrue(defaults.bool(forKey: OnboardingState.hasSeenOnboardingKey),
            "markSeen() must write the documented hasSeenOnboardingKey.")
    }

    // MARK: - Tour catalog shape

    func testTourHasExactlyFourPages() {
        XCTAssertEqual(OnboardingStep.tour.count, 4,
            "The first-launch tour is a 4-page flow (welcome / subjects / daily practice / get started).")
    }

    func testOnlyFinalPageCarriesPrimaryCTA() {
        let tour = OnboardingStep.tour
        for step in tour.dropLast() {
            XCTAssertNil(step.primaryCTA,
                "Only the final page should carry a primaryCTA (page \(step.id) had one).")
        }
        XCTAssertNotNil(tour.last?.primaryCTA,
            "The final page must carry the call-to-action label.")
        XCTAssertFalse(tour.last?.primaryCTA?.isEmpty ?? true,
            "The final-page CTA label must be non-empty.")
    }

    func testEveryPageHasNonEmptyCopy() {
        for step in OnboardingStep.tour {
            XCTAssertFalse(step.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                "Page \(step.id) has an empty title.")
            XCTAssertFalse(step.message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                "Page \(step.id) has an empty message.")
            XCTAssertFalse(step.symbol.isEmpty,
                "Page \(step.id) has an empty hero symbol name.")
        }
    }

    /// Exactly one page (the "Three subjects" page) carries subject rows, and
    /// it lists all three subjects with non-empty names + blurbs.
    func testSubjectsPageListsAllThreeSubjects() {
        let withSubjects = OnboardingStep.tour.filter { !$0.subjects.isEmpty }
        XCTAssertEqual(withSubjects.count, 1,
            "Exactly one page should carry subject rows.")
        let subjects = withSubjects.first?.subjects ?? []
        XCTAssertEqual(subjects.count, 3,
            "The subjects page should list Science, Maths, and Sanskrit.")
        let names = subjects.map { $0.name }
        XCTAssertEqual(Set(names), ["Science", "Maths", "Sanskrit"])
        for s in subjects {
            XCTAssertFalse(s.emoji.isEmpty, "\(s.name) row is missing its emoji.")
            XCTAssertFalse(s.blurb.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                "\(s.name) row has an empty blurb.")
        }
    }

    /// The CTA destination is the science pack id the registry actually loads.
    func testGetStartedPackIdMatchesSciencePack() {
        XCTAssertEqual(OnboardingStep.getStartedPackId, "science_class7",
            "The final-page CTA must open the science pack the registry loads.")
    }

    // MARK: - Render smoke (every page lays out without crashing)

    /// Render each page as a single-page deck so the view's internal page
    /// index lands on it, then force a layout pass. Catches any crash in a
    /// page body — including the subjects-list branch on page 2.
    func testEveryPageRendersWithoutCrash() {
        for step in OnboardingStep.tour {
            let view = FirstLaunchTourView(
                steps: [step],
                onClose: {},
                onGetStarted: {}
            )
            let host = NSHostingView(rootView: view)
            host.frame = NSRect(x: 0, y: 0, width: 600, height: 560)
            host.layoutSubtreeIfNeeded()
            XCTAssertGreaterThan(host.fittingSize.height, 0,
                "Page \(step.id) should lay out a non-empty body.")
        }
    }

    /// The full 4-page tour renders as one view without crashing.
    func testFullTourRendersWithoutCrash() {
        let view = FirstLaunchTourView(onClose: {}, onGetStarted: {})
        let host = NSHostingView(rootView: view)
        host.frame = NSRect(x: 0, y: 0, width: 600, height: 560)
        host.layoutSubtreeIfNeeded()
        XCTAssertGreaterThan(host.fittingSize.height, 0,
            "The full tour should lay out a non-empty body.")
    }
}
