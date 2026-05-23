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
}
