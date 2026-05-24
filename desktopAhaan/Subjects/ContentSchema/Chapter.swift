import Foundation

/// A textbook chapter.
///
/// Every field added beyond the original (`id`, `number`, `title`,
/// `summary`, `topics`, `pageRefs`) is **Optional** so the existing
/// `science_class7.json` continues to decode unchanged. New content
/// authoring fills these arrays chapter-by-chapter; `ChapterContentTests`
/// proves the decode stays stable.
struct Chapter: Codable, Hashable, Identifiable {
    let id: String                  // e.g. "ch01"
    let number: Int
    let title: String
    let summary: String
    let topics: [Topic]
    let pageRefs: [Int]

    // MARK: - Optional content-expansion arrays
    //
    // Every field below is Optional with a sensible default of `nil`,
    // letting callers treat absence as "empty list". The matching
    // accessors below provide a non-Optional `[T]` so the views never
    // need to nil-check the array itself, only its emptiness.

    let realWorldExamples: [RealWorldExample]?
    let examConnections: [ExamConnection]?
    let mnemonics: [Mnemonic]?
    let misconceptions: [Misconception]?
    let ncertQA: [NcertQAEntry]?
    let glossary: [GlossaryTerm]?
    let miniProjects: [MiniProject]?
    let scientists: [ScientistProfile]?
    let whatIfs: [WhatIfScenario]?
    let crossChapterRefs: [CrossChapterRef]?
    let curriculumBridge: CurriculumBridge?
    let gallery: [GalleryItem]?
    let timelines: [ContentTimeline]?

    /// Grade-tagged stretch topics for fast learners. Hidden behind a
    /// "Go deeper" disclosure on the chapter detail page; every entry's
    /// `parentConceptId` MUST resolve to a concept id in the same chapter.
    let deepDive: [StretchTopic]?

    /// Visual & multimedia learning assets attached to this chapter
    /// (illustrations, shape diagrams, scene refs, bundled videos,
    /// narration flags). Rendered by `MediaAssetView`.
    let mediaAssets: [MediaAsset]?

    /// Node-and-edge graph describing how this chapter's concepts
    /// connect — and how they reach across to other chapters. Pre-baked
    /// in JSON so layout stays editorially-controlled; the renderer
    /// (`ConceptMapView`, a chapter-agnostic Component) just draws it.
    /// Backwards-compatible: nil for every chapter without an authored
    /// concept map. Added 2026-05-23 (Ch.1 pilot); renderer
    /// generalised 2026-05-24.
    let conceptMap: ConceptMap?
}

// MARK: - Empty-list accessors
//
// View code generally wants `chapter.misconceptions` to behave like
// `[Misconception]` (empty when absent), not `[Misconception]?`. These
// computed properties let callers `ForEach(chapter.misconceptionsList) { ... }`
// without first unwrapping the Optional.

extension Chapter {
    var realWorldExamplesList: [RealWorldExample] { realWorldExamples ?? [] }
    var examConnectionsList: [ExamConnection] { examConnections ?? [] }
    var mnemonicsList: [Mnemonic] { mnemonics ?? [] }
    var misconceptionsList: [Misconception] { misconceptions ?? [] }
    var ncertQAList: [NcertQAEntry] { ncertQA ?? [] }
    var glossaryList: [GlossaryTerm] { glossary ?? [] }
    var miniProjectsList: [MiniProject] { miniProjects ?? [] }
    var scientistsList: [ScientistProfile] { scientists ?? [] }
    var whatIfsList: [WhatIfScenario] { whatIfs ?? [] }
    var crossChapterRefsList: [CrossChapterRef] { crossChapterRefs ?? [] }
    var galleryList: [GalleryItem] { gallery ?? [] }
    var timelinesList: [ContentTimeline] { timelines ?? [] }
    var deepDiveList: [StretchTopic] { deepDive ?? [] }
    var mediaAssetsList: [MediaAsset] { mediaAssets ?? [] }

    /// Flat list of every Question id in this chapter, walking the
    /// chapter → topic → question tree. Used by D4's "Stuck here?"
    /// strip to intersect chapter scope with the tough-flagged and
    /// recently-missed signals. Computed each access — typical
    /// chapter has ~40 questions, well under any noticeable cost.
    var allQuestionIds: [String] {
        topics.flatMap { $0.questions.map(\.id) }
    }

    /// Flat list of every Concept id in this chapter — same shape as
    /// `allQuestionIds`. The "Stuck here?" strip intersects this with
    /// the user's bookmarked concept set to surface chapter-scoped
    /// bookmarks.
    var allConceptIds: [String] {
        topics.flatMap { $0.concepts.map(\.id) }
    }
}
