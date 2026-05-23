import Foundation

// MARK: - AppStorage keys
//
// Central registry for every `@AppStorage` key the app uses. Routing every
// key through this enum prevents typo-driven progress loss across the
// Discover chapter dispatchers (a single misspelled key silently forks a
// fresh cursor on next launch).
//
// Lifted out of `Extensions.swift` 2026-05-23 to keep that file under
// the 600 LOC Big Sur type-checker ceiling after adding compatBlue +
// compatPurple Color tokens and the three discoverability-layer keys
// below.
enum AppStorageKeys {
    /// One-time first-launch welcome overlay dismissal flag.
    static let hasSeenWelcome = "hasSeenWelcome"

    /// Set to true after the student dismisses the "all 19 Discover
    /// chapters complete" celebration overlay (DM7/EM4). Prevents the
    /// overlay from reappearing on every launch once seen.
    static let hasSeenAllChaptersCelebration = "hasSeenAllChaptersCelebration"

    /// Per-chapter Discover Mode scene cursor (0-indexed). `chapterNumber`
    /// is the integer chapter number (1, 2, ..., 19 in the current pack).
    static func discoverScene(_ chapterNumber: Int) -> String {
        String(format: "discover_scene_ch%02d", chapterNumber)
    }

    /// Current consecutive-days review streak. Incremented when the kid
    /// completes a review session and the previous credited day was
    /// yesterday; reset to 1 if the gap is more than 1 day; left alone
    /// if the streak already counts today. Stored as Int.
    static let reviewStreakDays = "reviewStreakDays"

    /// ISO-8601 date string (yyyy-MM-dd) of the last day the streak was
    /// credited. Used to decide whether tonight's completion extends
    /// (yesterday), keeps (today), or resets (>1 day gap) the streak.
    static let reviewStreakLastDate = "reviewStreakLastDate"

    /// All-time longest streak achieved by the kid. Bumped whenever the
    /// current streak exceeds the previous high-water-mark. Surfaces in
    /// the Daily Practice header alongside the current streak so the
    /// kid sees both: "you're on day 3 of a streak; your best ever is 14".
    static let reviewStreakBest = "reviewStreakBest"

    // MARK: - Discoverability (added 2026-05-23 polish session)

    /// True after the 3-panel Welcome Tour has been dismissed once.
    /// Re-launchable from Help → "Show Welcome Tour" (which clears this
    /// flag if Rohan wants the kid to see it again, OR simply re-presents
    /// the sheet without clearing — either path is fine).
    static let hasSeenWelcomeTour = "hasSeenWelcomeTour"

    /// CFBundleShortVersionString that was current when the user last
    /// dismissed the "What's New" sheet. Used to gate auto-presentation
    /// after a version bump.
    static let whatsNewLastSeenVersion = "whatsNewLastSeenVersion"

    /// How many times the kid has opened any chapter while the 'New!' badge
    /// on the Go Deeper disclosure has been visible. Hits 3 → badge stops
    /// showing on next chapter open. Stored as Int.
    static let goDeeperNewBadgeShownCount = "goDeeperNewBadgeShownCount"
}
