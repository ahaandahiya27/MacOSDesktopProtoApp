import Foundation

// MARK: - Adaptive difficulty model
//
// Pure value types backing `AdaptiveDifficultyEngine`. The engine ranks
// candidate questions by a `DifficultyBand` derived from three signals:
//   1. the kid's rolling 5-question correct/incorrect window in the chapter
//      (a `PracticeWindow`),
//   2. the question's intrinsic authored difficulty (`Question.difficulty`,
//      or an inferred band when that's missing/out of range), and
//   3. the question's SRS easiness factor (`QuestionReview.ease`).
//
// Everything here is FS-free and Foundation-only so the band table and the
// ranking are unit-testable without standing up the app. Big Sur compatible:
// plain enums/structs, no macOS 12+ APIs, no Combine.

/// The four difficulty bands the engine sorts questions into, ordered
/// easiest → hardest so `rawValue` doubles as a sort key. Raw values are the
/// persistence contract for any future serialization — never renumber a
/// shipped case.
internal enum DifficultyBand: Int, Codable, CaseIterable, Hashable {
    case easy = 0
    case core = 1
    case stretch = 2
    case challenge = 3

    var displayName: String {
        switch self {
        case .easy:      return "Easy"
        case .core:      return "Core"
        case .stretch:   return "Stretch"
        case .challenge: return "Challenge"
        }
    }
}

/// A rolling window of the kid's most-recent answer outcomes in one chapter
/// (most-recent appended last; capped at `capacity`). The `band` derivation
/// implements the brief's table:
///
///   5/5 correct → bias `.stretch` then `.challenge`
///   4/5         → `.core` then `.stretch`
///   3/5         → `.core` only
///   2/5 or worse → `.easy` then `.core`  (recover confidence)
///
/// The table is defined on a FULL 5-answer window. Partial windows (a fresh
/// chapter) bias to `.core` — we don't yank a kid up to `.challenge` or down
/// to `.easy` off one or two answers — except a clearly-struggling partial
/// run (≤40% correct) which nudges to `.easy` early.
internal struct PracticeWindow: Codable, Hashable {
    /// Most-recent outcomes, oldest first, newest last. Capped at `capacity`.
    private(set) var outcomes: [Bool]

    /// The brief's "rolling 5-question" window size.
    static let capacity = 5

    init(outcomes: [Bool] = []) {
        self.outcomes = Array(outcomes.suffix(Self.capacity))
    }

    /// Record one outcome, evicting the oldest if the window is full.
    mutating func record(_ correct: Bool) {
        outcomes.append(correct)
        if outcomes.count > Self.capacity {
            outcomes.removeFirst(outcomes.count - Self.capacity)
        }
    }

    var sampleCount: Int { outcomes.count }
    var correctCount: Int { outcomes.lazy.filter { $0 }.count }

    /// Preference-ordered bands for the next pull. The first element is the
    /// primary `band`; later elements are the fallbacks the engine reaches
    /// for when the primary band has no candidate question.
    var preferredBands: [DifficultyBand] {
        // Until the window is full we stay neutral, with one exception: a
        // clearly-struggling partial run drops to `.easy` to rebuild
        // confidence rather than waiting for the full 5.
        guard sampleCount >= Self.capacity else {
            if sampleCount == 0 { return Self.coreFirst }
            let frac = Double(correctCount) / Double(sampleCount)
            return frac <= 0.4 ? Self.easyFirst : Self.coreFirst
        }
        switch correctCount {                              // out of 5
        case 5:  return [.stretch, .challenge, .core, .easy]
        case 4:  return [.core, .stretch, .easy, .challenge]
        case 3:  return [.core, .easy, .stretch, .challenge]
        default: return [.easy, .core, .stretch, .challenge]   // 0, 1, 2
        }
    }

    /// The primary recommended band for the next pull.
    var band: DifficultyBand { preferredBands.first ?? .core }

    /// Fallback orderings, hoisted so the partial-window branch and the
    /// full-window table read off the same lists.
    static let coreFirst: [DifficultyBand] = [.core, .stretch, .easy, .challenge]
    static let easyFirst: [DifficultyBand] = [.easy, .core, .stretch, .challenge]
}

// MARK: - Persisted state

/// The whole engine's persisted state: one `PracticeWindow` per chapter,
/// keyed by `"<packId>::<chapterId>"`. Persisted as a single-element array
/// (`[AdaptivePracticeState]`) so the shared `DataStore.readFile` /
/// `performAtomicWrite` array plumbing applies unchanged.
internal struct AdaptivePracticeState: Codable, Hashable {
    /// `windowKey(packId:chapterId:)` → window.
    var windows: [String: PracticeWindow]

    init(windows: [String: PracticeWindow] = [:]) {
        self.windows = windows
    }

    /// Stable composite key. Bare chapter ids (`ch01`) collide across packs
    /// (Science/Maths/Sanskrit share the scheme), so the pack id is part of
    /// the key — mirrors the `QuestionReview.packId` disambiguation.
    static func windowKey(packId: String, chapterId: String) -> String {
        "\(packId)::\(chapterId)"
    }
}

// MARK: - Persistence keys

/// `UserDefaults` keys for the adaptive-practice feature. Kept here (not in
/// the shared `AppStorageKeys`) so the whole feature stays inside this run's
/// files — same precedent as `DailyPlanStorage`.
internal enum AdaptiveDifficultyStorage {
    /// Master on/off for adaptive question ordering. Default ON. When off,
    /// the engine becomes a pass-through (SRS due order is preserved).
    static let engineEnabledKey = "adaptiveDifficultyEngineEnabled"

    /// `true` when the engine has never been configured — read so a fresh
    /// install defaults to enabled without writing the key eagerly.
    static func isEngineEnabled(_ defaults: UserDefaults = .standard) -> Bool {
        if defaults.object(forKey: engineEnabledKey) == nil { return true }
        return defaults.bool(forKey: engineEnabledKey)
    }

    static func setEngineEnabled(_ on: Bool, _ defaults: UserDefaults = .standard) {
        defaults.set(on, forKey: engineEnabledKey)
    }
}
