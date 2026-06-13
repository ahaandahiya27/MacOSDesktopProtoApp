import Foundation

// MARK: - MockTest models
//
// v9 Exam Simulation. The value model for a timed, auto-graded "Mock Test" — a
// realistic practice paper assembled from the existing question banks
// (`questions` + `bossQuestions` + `quickCheckQuestions` +
// `deepDive.bonusQuestions`) across all four packs, sampled by mastery gaps and
// balanced across topics.
//
// Strictly value types here. The pure assembly + grading lives in
// `MockTestEngine`; the live gathering / persistence / SRS recording lives in
// `DataStore+MockTest.swift`. Mirrors the MilestoneAssessment split.
//
// Big Sur compatible: Foundation-only Codable value types, no macOS 12+ APIs.

// MARK: - Difficulty band

/// Which authored-difficulty range a paper draws from. `Question.difficulty`
/// runs 1 (recall) … 5 (evaluate/create). A thin band yields a SHORTER paper
/// rather than filler, exactly like the milestone sampler.
enum MockTestDifficultyBand: String, Codable, Hashable, CaseIterable {
    case foundation   // 1–2: recall + understanding
    case balanced     // 1–5: the whole spread
    case challenge    // 3–5: apply + analyse + create

    var displayName: String {
        switch self {
        case .foundation: return "Foundation"
        case .balanced:   return "Balanced"
        case .challenge:  return "Challenge"
        }
    }

    var subtitle: String {
        switch self {
        case .foundation: return "Recall & understanding (easier)"
        case .balanced:   return "A mix across every level"
        case .challenge:  return "Apply, analyse & create (harder)"
        }
    }

    /// Inclusive difficulty range a question must fall in to be eligible.
    var range: ClosedRange<Int> {
        switch self {
        case .foundation: return 1...2
        case .balanced:   return 1...5
        case .challenge:  return 3...5
        }
    }

    /// True if a question's authored difficulty qualifies for this band.
    /// Difficulty is clamped to 1…5 first so an out-of-range datum can't
    /// silently exclude an otherwise-valid question.
    func admits(difficulty: Int) -> Bool {
        let d = max(1, min(5, difficulty))
        return range.contains(d)
    }
}

// MARK: - Subject selection

/// Which subjects a paper covers: one pack, or a mixed cross-subject paper.
enum MockTestSubjectSelection: Hashable {
    case single(packId: String)
    case mixed

    /// `true` for the cross-subject paper.
    var isMixed: Bool { if case .mixed = self { return true } else { return false } }

    /// The single pack id, or nil for a mixed paper.
    var singlePackId: String? {
        if case let .single(packId) = self { return packId }
        return nil
    }
}

// MARK: - Marking scheme

/// How a paper is scored. Default is the competitive-exam +4 / −1 MCQ scheme;
/// unanswered questions always score zero. Kept as a value so a future "no
/// negative marking" preset is a one-line change at the call site.
struct MockTestMarkingScheme: Codable, Hashable {
    let marksPerCorrect: Int
    let penaltyPerWrong: Int   // a POSITIVE magnitude subtracted for a wrong answer
    // (unanswered always scores 0 — no field needed)

    /// +4 correct, −1 wrong — the standard Olympiad / competitive-exam scheme.
    static let standard = MockTestMarkingScheme(marksPerCorrect: 4, penaltyPerWrong: 1)

    /// +1 correct, no penalty — a gentler scheme for younger practice.
    static let gentle = MockTestMarkingScheme(marksPerCorrect: 1, penaltyPerWrong: 0)

    /// Marks for one outcome. `answered == false` ⇒ 0 regardless of correctness.
    func marks(correct: Bool, answered: Bool) -> Int {
        guard answered else { return 0 }
        return correct ? marksPerCorrect : -penaltyPerWrong
    }
}

// MARK: - Config + presets

/// Everything that defines a paper before it's assembled: which subjects, which
/// difficulty band, how many questions, how long, and how it's scored.
struct MockTestConfig: Hashable {
    let selection: MockTestSubjectSelection
    let band: MockTestDifficultyBand
    let questionCount: Int
    let timeLimitSeconds: Int
    let marking: MockTestMarkingScheme

    init(selection: MockTestSubjectSelection,
         band: MockTestDifficultyBand,
         questionCount: Int,
         timeLimitSeconds: Int,
         marking: MockTestMarkingScheme = .standard) {
        self.selection = selection
        self.band = band
        self.questionCount = max(1, questionCount)
        self.timeLimitSeconds = max(60, timeLimitSeconds)
        self.marking = marking
    }
}

/// Sensible length/time presets the setup screen offers.
enum MockTestPreset: String, CaseIterable, Hashable {
    case quick      // 15 Q / 20 min
    case standard   // 30 Q / 45 min

    var displayName: String {
        switch self {
        case .quick:    return "Quick"
        case .standard: return "Standard"
        }
    }

    var questionCount: Int {
        switch self {
        case .quick:    return 15
        case .standard: return 30
        }
    }

    var timeLimitSeconds: Int {
        switch self {
        case .quick:    return 20 * 60
        case .standard: return 45 * 60
        }
    }

    /// A compact "15 Q · 20 min" descriptor.
    var summary: String {
        "\(questionCount) Q · \(timeLimitSeconds / 60) min"
    }

    /// Build a config from this preset plus the chosen subjects + band.
    func config(selection: MockTestSubjectSelection,
                band: MockTestDifficultyBand,
                marking: MockTestMarkingScheme = .standard) -> MockTestConfig {
        MockTestConfig(selection: selection, band: band,
                       questionCount: questionCount,
                       timeLimitSeconds: timeLimitSeconds, marking: marking)
    }
}

// MARK: - Which bank a question came from

/// The origin bank of a sampled question — drives a small "Boss" / "Deep Dive"
/// chip in the UI and lets a future surface weight banks differently.
enum MockTestBank: String, Codable, Hashable {
    case topic        // chapter → topic → questions (textbook canonical)
    case boss         // chapter.bossQuestions
    case quickCheck   // chapter.quickCheckQuestions
    case deepDive     // chapter.deepDive[*].bonusQuestions

    var displayName: String {
        switch self {
        case .topic:      return "Textbook"
        case .boss:       return "Boss Quiz"
        case .quickCheck: return "Quick Check"
        case .deepDive:   return "Deep Dive"
        }
    }
}

// MARK: - Sampled question

/// One sampled question with the subject/chapter/topic context the runner +
/// report need, so neither has to re-resolve the id against the registry. The
/// resolved `Question` is carried verbatim from the immutable pack.
struct MockTestQuestion: Hashable, Identifiable {
    /// Owning pack id (`science_class7`, …) — also the `preferredPackId` to
    /// record a later answer against, so a colliding bare id lands in the right
    /// subject.
    let packId: String
    let subjectTitle: String
    let chapterId: String
    let chapterTitle: String
    /// A stable topic key for the per-topic breakdown — the topic id for
    /// textbook questions, or a synthetic per-chapter bank key for
    /// boss/quick-check/deep-dive items (which live outside the topic tree).
    let topicKey: String
    /// Human topic/strand label for the breakdown row.
    let topicTitle: String
    let bank: MockTestBank
    /// The question itself, copied from the pack.
    let question: Question

    /// Composite identity: a bare question id can repeat across packs (Science
    /// `ch01_*` vs the Sanskrit legacy `ch01_*` deck), so the paper keys on
    /// `packId::questionId` to keep SwiftUI identity + grading unambiguous.
    var id: String { "\(packId)::\(question.id)" }
}

// MARK: - Assembled paper

/// A generated mock-test paper: an ordered, possibly-mixed question set plus the
/// config it was built from. Value type — produced in one pass, never mutated.
struct MockTestPaper: Hashable {
    let questions: [MockTestQuestion]
    let config: MockTestConfig
    /// When the paper was generated (passed in by the builder; the pure engine
    /// never reads the clock).
    let generatedAt: Date

    /// `true` when nothing could be sampled — the UI shows a "not enough
    /// questions" state rather than an empty runner.
    var isEmpty: Bool { questions.isEmpty }

    /// Number of questions actually in the paper (≤ requested count when the
    /// eligible pool is thin).
    var count: Int { questions.count }

    /// Distinct subject titles, in first-appearance order — a compact "covers …"
    /// line for the setup confirmation.
    var subjectTitles: [String] {
        var seen = Set<String>()
        var titles: [String] = []
        for q in questions where !seen.contains(q.subjectTitle) {
            seen.insert(q.subjectTitle)
            titles.append(q.subjectTitle)
        }
        return titles
    }

    /// How many questions came from each pack id — drives the report's
    /// per-subject section and the parent report-card line.
    var subjectCounts: [String: Int] {
        var counts: [String: Int] = [:]
        for q in questions { counts[q.packId, default: 0] += 1 }
        return counts
    }
}
