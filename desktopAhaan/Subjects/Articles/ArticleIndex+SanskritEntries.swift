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
        "sch01_glossary": ArticleEntry(id: "sch01_glossary", filename: "sch01_glossary.html", title: "Vocabulary Deck — वन्दे भारतमातरम् — Vande Bharatamataram (I Salute the Motherland)", chapterFolder: "Articles/SanskritChapter1", estimatedMinutes: 4),
        "sch02_glossary": ArticleEntry(id: "sch02_glossary", filename: "sch02_glossary.html", title: "Vocabulary Deck — नित्यं पिबामः सुभाषितरसम् — Nityam Pibamah Subhashitarasam (Let Us Daily Drink the Nectar of Wise Sayings)", chapterFolder: "Articles/SanskritChapter2", estimatedMinutes: 4),
        "sch03_glossary": ArticleEntry(id: "sch03_glossary", filename: "sch03_glossary.html", title: "Vocabulary Deck — मित्राय नमः — Mitraya Namah (Salutation to the Sun)", chapterFolder: "Articles/SanskritChapter3", estimatedMinutes: 4),
        "sch04_glossary": ArticleEntry(id: "sch04_glossary", filename: "sch04_glossary.html", title: "Vocabulary Deck — न लभ्यते चेत् आम्लं द्राक्षाफलम् — The Fox and the Grapes", chapterFolder: "Articles/SanskritChapter4", estimatedMinutes: 4),
        "sch05_glossary": ArticleEntry(id: "sch05_glossary", filename: "sch05_glossary.html", title: "Vocabulary Deck — सेवा हि परमो धर्मः — Seva Hi Paramo Dharmah (Service Is the Highest Duty)", chapterFolder: "Articles/SanskritChapter5", estimatedMinutes: 4),
        "sch06_glossary": ArticleEntry(id: "sch06_glossary", filename: "sch06_glossary.html", title: "Vocabulary Deck — क्रीडाम वयं श्लोकान्त्याक्षरीम् — Krīḍāma Vayam Shlokāntyākṣarīm (Let Us Play Shloka-Antyakshari)", chapterFolder: "Articles/SanskritChapter6", estimatedMinutes: 4),
        "sch07_glossary": ArticleEntry(id: "sch07_glossary", filename: "sch07_glossary.html", title: "Vocabulary Deck — ईशावास्यम् इदं सर्वम् — Īśāvāsyam Idam Sarvam (All This Is Pervaded by the Lord)", chapterFolder: "Articles/SanskritChapter7", estimatedMinutes: 4),
        "sch08_glossary": ArticleEntry(id: "sch08_glossary", filename: "sch08_glossary.html", title: "Vocabulary Deck — हितं मनोहारि च दुर्लभं वचः — Hitam Manohāri cha Durlabham Vachah (Rare Is Speech Both Useful and Pleasing)", chapterFolder: "Articles/SanskritChapter8", estimatedMinutes: 4),
        "sch09_glossary": ArticleEntry(id: "sch09_glossary", filename: "sch09_glossary.html", title: "Vocabulary Deck — अन्नाद् भवन्ति भूतानि — Annād Bhavanti Bhūtāni (From Food, Beings Come To Be)", chapterFolder: "Articles/SanskritChapter9", estimatedMinutes: 4),
        "sch10_glossary": ArticleEntry(id: "sch10_glossary", filename: "sch10_glossary.html", title: "Vocabulary Deck — दशमः कः? — Daśamaḥ Kaḥ? (Who Is the Tenth?)", chapterFolder: "Articles/SanskritChapter10", estimatedMinutes: 4),
        "sch11_glossary": ArticleEntry(id: "sch11_glossary", filename: "sch11_glossary.html", title: "Vocabulary Deck — द्वीपेषु रम्यः द्वीपोऽण्डमानः — Dvīpeṣu Ramyaḥ Dvīpo'ṇḍamānaḥ (Among Islands, the Beautiful Andaman)", chapterFolder: "Articles/SanskritChapter11", estimatedMinutes: 4),
        "sch12_glossary": ArticleEntry(id: "sch12_glossary", filename: "sch12_glossary.html", title: "Vocabulary Deck — वीराङ्गना पन्नाधाया — Vīrāṅganā Pannādhāyā (Panna Dhai, the Brave)", chapterFolder: "Articles/SanskritChapter12", estimatedMinutes: 4),
        "sch13_glossary": ArticleEntry(id: "sch13_glossary", filename: "sch13_glossary.html", title: "Vocabulary Deck — वर्णमात्रा-परिचयः — Varṇa-Mātrā-Paricayaḥ (Introduction to Vowel-Quantity)", chapterFolder: "Articles/SanskritChapter13", estimatedMinutes: 4),
        "sch14_glossary": ArticleEntry(id: "sch14_glossary", filename: "sch14_glossary.html", title: "Vocabulary Deck — शब्दरूपाणि — Śabda-Rūpāṇi (Noun Declension Tables)", chapterFolder: "Articles/SanskritChapter14", estimatedMinutes: 4),
        "sch15_glossary": ArticleEntry(id: "sch15_glossary", filename: "sch15_glossary.html", title: "Vocabulary Deck — धातुरूपाणि — Dhāturūpāṇi (Verb Conjugation Tables)", chapterFolder: "Articles/SanskritChapter15", estimatedMinutes: 4),
    ]
}
