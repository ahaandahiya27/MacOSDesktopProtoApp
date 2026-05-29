import Foundation

// MARK: - OnboardingStep
//
// One page of the first-launch tour. A pure value type so the page set is
// unit-testable without spinning up SwiftUI, and so `FirstLaunchTourView`
// stays a thin, declarative renderer over data.
//
// Big Sur note: no SwiftUI / macOS 12+ types live here — it's plain
// Foundation. SF Symbol names are stored raw and routed through
// `SFSymbolCompat.name(_:)` at render time in the view.

struct OnboardingStep: Identifiable, Equatable {
    /// 0-based page index, also the `Identifiable` id.
    let id: Int
    /// SF Symbol name for the hero glyph. Routed through SFSymbolCompat in
    /// the view so a Big Sur (SF Symbols 2) machine gets a sensible fallback.
    let symbol: String
    let title: String
    let message: String
    /// Subject rows — non-empty only on the "Three subjects" page.
    let subjects: [SubjectBlurb]
    /// Label for the primary button on the FINAL page. nil on earlier pages
    /// (which show "Next"). The last page shows this as the call-to-action.
    let primaryCTA: String?

    init(
        id: Int,
        symbol: String,
        title: String,
        message: String,
        subjects: [SubjectBlurb] = [],
        primaryCTA: String? = nil
    ) {
        self.id = id
        self.symbol = symbol
        self.title = title
        self.message = message
        self.subjects = subjects
        self.primaryCTA = primaryCTA
    }

    /// One subject row on page 2.
    struct SubjectBlurb: Identifiable, Equatable {
        /// Emoji marker (matches the sidebar cover emoji style; not an SF
        /// Symbol, so it renders identically on Big Sur).
        let emoji: String
        let name: String
        let blurb: String
        var id: String { name }
    }
}

extension OnboardingStep {
    /// The canonical 4-page first-launch tour. Order is the presentation
    /// order. The view renders exactly these pages; tests assert the count,
    /// the final-page CTA, and that every page carries non-empty copy.
    static let tour: [OnboardingStep] = [
        OnboardingStep(
            id: 0,
            symbol: "sparkles",
            title: "Welcome to desktopAhaan",
            message: "A friendly home for Class 7 Science, Maths, and Sanskrit — explore each idea, then practise just enough to make it stick."
        ),
        OnboardingStep(
            id: 1,
            symbol: "books.vertical.fill",
            title: "Three subjects, one app",
            message: "Pick a subject from the sidebar any time. Each one is built for the way you learn.",
            subjects: [
                .init(emoji: "🔬", name: "Science",
                      blurb: "19 NCERT chapters with an interactive Discover Mode you can poke at."),
                .init(emoji: "🔢", name: "Maths",
                      blurb: "NEP “Ganita Prakash” chapters with worked examples and quizzes."),
                .init(emoji: "📖", name: "Sanskrit",
                      blurb: "A translator, an on-device dictionary, and chapter-by-chapter lessons.")
            ]
        ),
        OnboardingStep(
            id: 2,
            symbol: "flame.fill",
            title: "A little every day",
            message: "The app quietly remembers what you’ve learned and brings each idea back right before you’d forget it. A few minutes of Daily Practice beats cramming the night before — and a streak keeps you going."
        ),
        OnboardingStep(
            id: 3,
            symbol: "play.circle.fill",
            title: "Ready when you are",
            message: "That’s the whole tour. Jump into Science Chapter 1 to see Discover Mode — or click any subject in the sidebar to start exploring.",
            primaryCTA: "Open Science Ch.1"
        )
    ]

    /// Pack id the final-page CTA opens. Centralised here so the view, the
    /// presenter, and the tests all agree on the destination.
    static let getStartedPackId = "science_class7"
}
