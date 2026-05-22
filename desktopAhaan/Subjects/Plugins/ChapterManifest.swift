import Foundation

// MARK: - ChapterManifest
//
// S3 of the SCALE_PLAN. A value type declaring which of the 22 module
// types (per the parity prompt §C / COVERAGE_MATRIX.md columns) a
// chapter implements. The chapter detail UI iterates `modules` to
// decide which CTAs to render.
//
// Pure data, `Hashable`, `Equatable`. No SwiftUI. No closures. Safe to
// pass anywhere, including across actor boundaries.

/// The 22 module types every science chapter targets for parity.
///
/// Order matches the 22 columns in `COVERAGE_MATRIX.md`. Don't reorder
/// — `rawValue` is what the matrix stores. Adding new modules at the
/// END is safe; renumbering existing ones isn't.
enum ChapterModule: Int, CaseIterable, Hashable, Codable, Comparable {
    case animatedScene      = 1
    case discoveryMode      = 2
    case conceptCards       = 3
    case quickQuiz          = 4
    case realWorldExample   = 5
    case examBridge         = 6
    case mnemonic           = 7
    case hotspots           = 8
    case processTimeline    = 9
    case bossQuiz           = 10
    case article            = 11
    case progressTracker    = 12
    case scientists         = 13
    case whatIf             = 14
    case glossary           = 15
    case commonMistakes     = 16
    case ncertQA            = 17
    case gallery            = 18
    case miniProject        = 19
    case selfCheck          = 20
    case curriculumBridge   = 21
    case masterInfographic  = 22

    static func < (lhs: ChapterModule, rhs: ChapterModule) -> Bool {
        lhs.rawValue < rhs.rawValue
    }

    /// Human-readable label, used in `COVERAGE_MATRIX.md` and any
    /// future debug UI. Kept short to fit table cells.
    var shortLabel: String {
        switch self {
        case .animatedScene:     return "Animated Scene"
        case .discoveryMode:     return "Discovery Mode"
        case .conceptCards:      return "Concept Cards"
        case .quickQuiz:         return "Quick Quiz"
        case .realWorldExample:  return "Real-world"
        case .examBridge:        return "Exam Bridge"
        case .mnemonic:          return "Mnemonic"
        case .hotspots:          return "Hotspots"
        case .processTimeline:   return "Process Timeline"
        case .bossQuiz:          return "Boss Quiz"
        case .article:           return "Article"
        case .progressTracker:   return "Progress"
        case .scientists:        return "Scientists"
        case .whatIf:            return "What-If"
        case .glossary:          return "Glossary"
        case .commonMistakes:    return "Mistakes"
        case .ncertQA:           return "NCERT Q&A"
        case .gallery:           return "Gallery"
        case .miniProject:       return "Mini-Project"
        case .selfCheck:         return "Self-Check"
        case .curriculumBridge:  return "Bridge"
        case .masterInfographic: return "Infographic"
        }
    }
}

/// Declares which `ChapterModule`s a chapter implements. The chapter
/// detail UI reads `modules.contains(...)` before showing each CTA.
///
/// Construct one per chapter inside its `ChapterPlugin` implementation:
///
///     let manifest = ChapterManifest(modules: [
///         .animatedScene, .discoveryMode, .conceptCards, .quickQuiz,
///         .realWorldExample, .examBridge, .mnemonic, .bossQuiz,
///         .article, .progressTracker, .scientists, .whatIf, .glossary,
///         .commonMistakes, .ncertQA, .gallery, .miniProject,
///         .selfCheck, .curriculumBridge, .masterInfographic,
///     ])
struct ChapterManifest: Hashable, Codable {
    /// The set of modules this chapter implements. Order-independent;
    /// callers should use `.contains(_:)` rather than iteration order.
    let modules: Set<ChapterModule>

    init(modules: Set<ChapterModule>) {
        self.modules = modules
    }

    /// Convenience initializer for the common case of "implements
    /// everything" — passes `Set(ChapterModule.allCases)`.
    static var complete: ChapterManifest {
        ChapterManifest(modules: Set(ChapterModule.allCases))
    }

    /// Convenience initializer for the minimum a chapter must declare:
    /// the 12 core modules (1..12). Wraps the "ways of learning"
    /// (13..22) as optional add-ons.
    static var core: ChapterManifest {
        ChapterManifest(modules: Set(ChapterModule.allCases.prefix(12)))
    }

    func has(_ module: ChapterModule) -> Bool {
        modules.contains(module)
    }
}
