import Foundation

// Sanskrit (NEP "Deepakam" Class 7) article registrations. Split out of
// ArticleIndex.entries so Sanskrit content edits stay disjoint from Science
// and Maths. Keys carry the `sch` prefix (sch01..sch15) — distinct from
// Science's `ch*` and Maths's `mch*` namespaces. Merged into
// ArticleIndex.entries in ArticleIndex.swift.
extension ArticleIndex {
    static let sanskritEntries: [String: ArticleEntry] = [
        "sch01_beyond": ArticleEntry(id: "sch01_beyond", filename: "sch01_beyond.html", title: "Beyond the Book — The Song That Became a Nation's Heartbeat", chapterFolder: "Articles/SanskritChapter1", estimatedMinutes: 6),
        "sch02_beyond": ArticleEntry(id: "sch02_beyond", filename: "sch02_beyond.html", title: "Beyond the Book — The गemstones Called सुभाषितम्", chapterFolder: "Articles/SanskritChapter2", estimatedMinutes: 6),
        "sch03_beyond": ArticleEntry(id: "sch03_beyond", filename: "sch03_beyond.html", title: "Beyond the Book — A Practice Older Than the Asana", chapterFolder: "Articles/SanskritChapter3", estimatedMinutes: 6),
        "sch04_beyond": ArticleEntry(id: "sch04_beyond", filename: "sch04_beyond.html", title: "Beyond the Book — How Aesop Came to India (or Was It the Other Way?)", chapterFolder: "Articles/SanskritChapter4", estimatedMinutes: 6),
        "sch05_beyond": ArticleEntry(id: "sch05_beyond", filename: "sch05_beyond.html", title: "Beyond the Book — Why India Built a Culture Around सेवा", chapterFolder: "Articles/SanskritChapter5", estimatedMinutes: 6),
        "sch06_beyond": ArticleEntry(id: "sch06_beyond", filename: "sch06_beyond.html", title: "Beyond the Book — The Game That Kept Sanskrit Alive", chapterFolder: "Articles/SanskritChapter6", estimatedMinutes: 6),
        "sch07_beyond": ArticleEntry(id: "sch07_beyond", filename: "sch07_beyond.html", title: "Beyond the Book — India's Shortest, Most-Quoted Upaniṣad", chapterFolder: "Articles/SanskritChapter7", estimatedMinutes: 6),
        "sch08_beyond": ArticleEntry(id: "sch08_beyond", filename: "sch08_beyond.html", title: "Beyond the Book — The Hardest Speech-Rule in the World", chapterFolder: "Articles/SanskritChapter8", estimatedMinutes: 6),
        "sch09_beyond": ArticleEntry(id: "sch09_beyond", filename: "sch09_beyond.html", title: "Beyond the Book — A 2,500-Year-Old Ecology Lesson", chapterFolder: "Articles/SanskritChapter9", estimatedMinutes: 6),
        "sch10_beyond": ArticleEntry(id: "sch10_beyond", filename: "sch10_beyond.html", title: "Beyond the Book — When Indian Philosophy Said 'You Are It'", chapterFolder: "Articles/SanskritChapter10", estimatedMinutes: 6),
        "sch11_beyond": ArticleEntry(id: "sch11_beyond", filename: "sch11_beyond.html", title: "Beyond the Book — The Andamans After Independence", chapterFolder: "Articles/SanskritChapter11", estimatedMinutes: 6),
        "sch12_beyond": ArticleEntry(id: "sch12_beyond", filename: "sch12_beyond.html", title: "Beyond the Book — The Heroines Mewar Built On", chapterFolder: "Articles/SanskritChapter12", estimatedMinutes: 6),
        "sch13_beyond": ArticleEntry(id: "sch13_beyond", filename: "sch13_beyond.html", title: "Beyond the Book — The Phonetics That Invented Modern Linguistics", chapterFolder: "Articles/SanskritChapter13", estimatedMinutes: 6),
        "sch14_beyond": ArticleEntry(id: "sch14_beyond", filename: "sch14_beyond.html", title: "Beyond the Book — Why Sanskrit Has Eight Cases (and English Has Almost None)", chapterFolder: "Articles/SanskritChapter14", estimatedMinutes: 6),
        "sch15_beyond": ArticleEntry(id: "sch15_beyond", filename: "sch15_beyond.html", title: "Beyond the Book — Sanskrit's Verb Forest", chapterFolder: "Articles/SanskritChapter15", estimatedMinutes: 6),
    ]
}
