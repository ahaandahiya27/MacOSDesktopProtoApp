import Foundation

// Sanskrit (NEP "Deepakam" Class 7) article registrations. Split out of
// ArticleIndex.entries so Sanskrit content edits stay disjoint from Science
// and Maths. Keys carry the `sch` prefix (sch01..sch15) — distinct from
// Science's `ch*` and Maths's `mch*` namespaces. Merged into
// ArticleIndex.entries in ArticleIndex.swift.
extension ArticleIndex {
    static let sanskritEntries: [String: ArticleEntry] = [
        "sch01_beyond": ArticleEntry(id: "sch01_beyond", filename: "sch01_beyond.html", title: "Beyond the Book — The Song That Became a Nation's Heartbeat", chapterFolder: "Articles/SanskritChapter1", estimatedMinutes: 6),
    ]
}
