import Foundation

struct ArticleEntry: Hashable, Identifiable {
    let id: String
    let filename: String
    let title: String
    let chapterFolder: String
    let estimatedMinutes: Int
}

enum ArticleIndex {
    /// Namespaces an article base key (e.g. `"ch05_glossary"`) to the owning
    /// subject pack. Maths article keys carry an `m` prefix
    /// (`mch05_glossary`); Science reuses the bare key. Returns nil for packs
    /// that ship no articles (e.g. Sanskrit) so callers gate the surface off
    /// entirely.
    ///
    /// Pure + testable single source of truth so a cross-subject article leak
    /// (a Maths chapter resolving to a Science `chNN_` article because the key
    /// was built from the shared `chapter.id` alone) can't recur silently.
    static func packScopedKey(forPackId packId: String, baseKey: String) -> String? {
        switch packId {
        case "science_class7": return baseKey
        case "maths_class7":   return "m" + baseKey
        default:               return nil
        }
    }

    static let chapter1Folder = "Articles/Chapter1"
    static let chapter2Folder = "Articles/Chapter2"
    static let chapter3Folder = "Articles/Chapter3"
    static let chapter4Folder = "Articles/Chapter4"
    static let chapter5Folder = "Articles/Chapter5"
    static let chapter6Folder = "Articles/Chapter6"
    static let chapter7Folder = "Articles/Chapter7"
    static let chapter8Folder = "Articles/Chapter8"
    static let chapter9Folder = "Articles/Chapter9"
    static let chapter10Folder = "Articles/Chapter10"
    static let chapter11Folder = "Articles/Chapter11"
    static let chapter12Folder = "Articles/Chapter12"
    static let chapter13Folder = "Articles/Chapter13"
    static let chapter14Folder = "Articles/Chapter14"
    static let chapter15Folder = "Articles/Chapter15"
    static let chapter16Folder = "Articles/Chapter16"
    static let chapter17Folder = "Articles/Chapter17"
    static let chapter18Folder = "Articles/Chapter18"
    static let chapter19Folder = "Articles/Chapter19"

    static let entries: [String: ArticleEntry] =
        scienceEntries1
            .merging(scienceEntries2) { current, _ in current }
            .merging(scienceEntries3) { current, _ in current }
            .merging(scienceEntries4) { current, _ in current }
            .merging(mathsEntries) { current, _ in current }
            .merging(sanskritEntries) { current, _ in current }
            .merging(socialScienceEntries) { current, _ in current }


    static func entry(forConceptId id: String) -> ArticleEntry? {
        entries[id]
    }

    static func entry(forTopicId id: String) -> ArticleEntry? {
        entries[id]
    }

    static func entry(forChapterId id: String) -> ArticleEntry? {
        entries[id]
    }
}
