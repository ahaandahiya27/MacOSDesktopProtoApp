import Foundation

/// Provides all built-in vocabulary and phrases for offline practice
final class BuiltInContent {
    static let shared = BuiltInContent()

    private lazy var allItems: [PracticeItem] = {
        greetings + numbers + family + classroom + dailyActions + schoolPhrases + simpleSentences
    }()

    func items(for category: PracticeCategory) -> [PracticeItem] {
        allItems.filter { $0.category == category }
    }

    func dailyPhrase() -> PracticeItem {
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        let index = dayOfYear % allItems.count
        return allItems[index]
    }

    func allPhrases() -> [PracticeItem] { allItems }

    // MARK: - Greetings
    private let greetings: [PracticeItem] = [
        PracticeItem(id: "g1", category: .greetings,
                     english: "Hello / Greetings",
                     hindi: "नमस्ते",
                     sanskrit: "नमस्ते",
                     transliteration: "namaste",
                     grammarNote: "'namah' (bow) + 'te' (to you) = a respectful greeting",
                     difficulty: .easy),
        PracticeItem(id: "g2", category: .greetings,
                     english: "Good morning",
                     hindi: "सुप्रभात",
                     sanskrit: "सुप्रभातम्",
                     transliteration: "suprabhātam",
                     grammarNote: "'su' (good) + 'prabhāta' (morning) with neuter ending '-m'",
                     difficulty: .easy),
        PracticeItem(id: "g3", category: .greetings,
                     english: "How are you?",
                     hindi: "आप कैसे हैं?",
                     sanskrit: "भवान् कथम् अस्ति?",
                     transliteration: "bhavān katham asti?",
                     grammarNote: "'bhavān' = you (respectful), 'katham' = how, 'asti' = is",
                     difficulty: .medium),
        PracticeItem(id: "g4", category: .greetings,
                     english: "I am fine",
                     hindi: "मैं ठीक हूँ",
                     sanskrit: "अहं कुशली अस्मि",
                     transliteration: "ahaṁ kuśalī asmi",
                     grammarNote: "'aham' = I, 'kuśalī' = well/fine, 'asmi' = am",
                     difficulty: .easy),
        PracticeItem(id: "g5", category: .greetings,
                     english: "Thank you",
                     hindi: "धन्यवाद",
                     sanskrit: "धन्यवादः",
                     transliteration: "dhanyavādaḥ",
                     grammarNote: "'dhanya' (blessed) + 'vāda' (speech) — masculine nominative with visarga",
                     difficulty: .easy),
        PracticeItem(id: "g6", category: .greetings,
                     english: "Welcome",
                     hindi: "स्वागत है",
                     sanskrit: "स्वागतम्",
                     transliteration: "svāgatam",
                     grammarNote: "'su' (good) + 'āgata' (arrived) = welcome; neuter nominative",
                     difficulty: .easy),
        PracticeItem(id: "g7", category: .greetings,
                     english: "Goodbye",
                     hindi: "अलविदा / नमस्ते",
                     sanskrit: "पुनर्मिलामः",
                     transliteration: "punarmilāmaḥ",
                     grammarNote: "'punar' (again) + 'milāmaḥ' (we shall meet) — first person plural future",
                     difficulty: .medium),
    ]

    // MARK: - Numbers
    private let numbers: [PracticeItem] = [
        PracticeItem(id: "n1", category: .numbers, english: "One", hindi: "एक", sanskrit: "एकम्", transliteration: "ekam", grammarNote: "Neuter nominative form", difficulty: .easy),
        PracticeItem(id: "n2", category: .numbers, english: "Two", hindi: "दो", sanskrit: "द्वे", transliteration: "dve", grammarNote: "Dual number — Sanskrit has a special form for 'two'", difficulty: .easy),
        PracticeItem(id: "n3", category: .numbers, english: "Three", hindi: "तीन", sanskrit: "त्रीणि", transliteration: "trīṇi", grammarNote: "Neuter nominative plural", difficulty: .easy),
        PracticeItem(id: "n4", category: .numbers, english: "Four", hindi: "चार", sanskrit: "चत्वारि", transliteration: "catvāri", grammarNote: "Neuter nominative plural", difficulty: .easy),
        PracticeItem(id: "n5", category: .numbers, english: "Five", hindi: "पाँच", sanskrit: "पञ्च", transliteration: "pañca", grammarNote: "Same form for all genders in nominative", difficulty: .easy),
        PracticeItem(id: "n6", category: .numbers, english: "Six", hindi: "छह", sanskrit: "षट्", transliteration: "ṣaṭ", grammarNote: "Indeclinable numeral", difficulty: .easy),
        PracticeItem(id: "n7", category: .numbers, english: "Seven", hindi: "सात", sanskrit: "सप्त", transliteration: "sapta", grammarNote: "Indeclinable numeral", difficulty: .easy),
        PracticeItem(id: "n8", category: .numbers, english: "Eight", hindi: "आठ", sanskrit: "अष्ट", transliteration: "aṣṭa", grammarNote: "Indeclinable numeral", difficulty: .easy),
        PracticeItem(id: "n9", category: .numbers, english: "Nine", hindi: "नौ", sanskrit: "नव", transliteration: "nava", grammarNote: "Indeclinable numeral", difficulty: .easy),
        PracticeItem(id: "n10", category: .numbers, english: "Ten", hindi: "दस", sanskrit: "दश", transliteration: "daśa", grammarNote: "Indeclinable numeral", difficulty: .easy),
    ]

    // MARK: - Family
    private let family: [PracticeItem] = [
        PracticeItem(id: "f1", category: .family, english: "Mother", hindi: "माँ", sanskrit: "माता", transliteration: "mātā", grammarNote: "Feminine noun, ā-stem nominative singular", difficulty: .easy),
        PracticeItem(id: "f2", category: .family, english: "Father", hindi: "पिता", sanskrit: "पिता", transliteration: "pitā", grammarNote: "Masculine noun, ṛ-stem nominative singular", difficulty: .easy),
        PracticeItem(id: "f3", category: .family, english: "Brother", hindi: "भाई", sanskrit: "भ्राता", transliteration: "bhrātā", grammarNote: "Masculine noun, ṛ-stem", difficulty: .easy),
        PracticeItem(id: "f4", category: .family, english: "Sister", hindi: "बहन", sanskrit: "भगिनी", transliteration: "bhaginī", grammarNote: "Feminine noun, ī-stem nominative singular", difficulty: .easy),
        PracticeItem(id: "f5", category: .family, english: "Teacher (male)", hindi: "गुरु / शिक्षक", sanskrit: "गुरुः", transliteration: "guruḥ", grammarNote: "Masculine noun, u-stem nominative with visarga", difficulty: .easy),
        PracticeItem(id: "f6", category: .family, english: "Teacher (female)", hindi: "गुरु / शिक्षिका", sanskrit: "गुर्वी", transliteration: "gurvī", grammarNote: "Feminine form of guru", difficulty: .medium),
        PracticeItem(id: "f7", category: .family, english: "Friend", hindi: "मित्र / दोस्त", sanskrit: "मित्रम्", transliteration: "mitram", grammarNote: "Neuter noun, a-stem nominative singular", difficulty: .easy),
        PracticeItem(id: "f8", category: .family, english: "Student", hindi: "छात्र / विद्यार्थी", sanskrit: "छात्रः", transliteration: "chātraḥ", grammarNote: "Masculine noun, a-stem nominative with visarga", difficulty: .easy),
    ]

    // MARK: - Classroom
    private let classroom: [PracticeItem] = [
        PracticeItem(id: "c1", category: .classroom, english: "Book", hindi: "किताब / पुस्तक", sanskrit: "पुस्तकम्", transliteration: "pustakam", grammarNote: "Neuter noun, a-stem nominative singular", difficulty: .easy),
        PracticeItem(id: "c2", category: .classroom, english: "Pen", hindi: "कलम", sanskrit: "लेखनी", transliteration: "lekhanī", grammarNote: "Feminine noun, ī-stem — literally 'that which writes'", difficulty: .easy),
        PracticeItem(id: "c3", category: .classroom, english: "Water", hindi: "पानी / जल", sanskrit: "जलम्", transliteration: "jalam", grammarNote: "Neuter noun, a-stem", difficulty: .easy),
        PracticeItem(id: "c4", category: .classroom, english: "School", hindi: "विद्यालय", sanskrit: "विद्यालयः", transliteration: "vidyālayaḥ", grammarNote: "'vidyā' (knowledge) + 'ālaya' (abode) — a compound word", difficulty: .medium),
        PracticeItem(id: "c5", category: .classroom, english: "Classroom", hindi: "कक्षा", sanskrit: "कक्षा", transliteration: "kakṣā", grammarNote: "Feminine noun, ā-stem", difficulty: .easy),
        PracticeItem(id: "c6", category: .classroom, english: "Knowledge", hindi: "ज्ञान / विद्या", sanskrit: "विद्या", transliteration: "vidyā", grammarNote: "Feminine noun, ā-stem — root 'vid' means 'to know'", difficulty: .easy),
        PracticeItem(id: "c7", category: .classroom, english: "Fruit", hindi: "फल", sanskrit: "फलम्", transliteration: "phalam", grammarNote: "Neuter noun, a-stem — a very common textbook word", difficulty: .easy),
    ]

    // MARK: - Daily Actions
    private let dailyActions: [PracticeItem] = [
        PracticeItem(id: "d1", category: .dailyActions, english: "I go", hindi: "मैं जाता/जाती हूँ", sanskrit: "अहं गच्छामि", transliteration: "ahaṁ gacchāmi", grammarNote: "'gam' (to go) → present tense, first person singular 'gacchāmi'", difficulty: .easy),
        PracticeItem(id: "d2", category: .dailyActions, english: "I read", hindi: "मैं पढ़ता/पढ़ती हूँ", sanskrit: "अहं पठामि", transliteration: "ahaṁ paṭhāmi", grammarNote: "'paṭh' (to read) → first person singular present 'paṭhāmi'", difficulty: .easy),
        PracticeItem(id: "d3", category: .dailyActions, english: "I eat", hindi: "मैं खाता/खाती हूँ", sanskrit: "अहं खादामि", transliteration: "ahaṁ khādāmi", grammarNote: "'khād' (to eat) → first person singular present", difficulty: .easy),
        PracticeItem(id: "d4", category: .dailyActions, english: "I drink", hindi: "मैं पीता/पीती हूँ", sanskrit: "अहं पिबामि", transliteration: "ahaṁ pibāmi", grammarNote: "'pā' (to drink) → present stem 'piba', first person 'pibāmi'", difficulty: .easy),
        PracticeItem(id: "d5", category: .dailyActions, english: "I write", hindi: "मैं लिखता/लिखती हूँ", sanskrit: "अहं लिखामि", transliteration: "ahaṁ likhāmi", grammarNote: "'likh' (to write) → first person singular present", difficulty: .easy),
        PracticeItem(id: "d6", category: .dailyActions, english: "I speak", hindi: "मैं बोलता/बोलती हूँ", sanskrit: "अहं वदामि", transliteration: "ahaṁ vadāmi", grammarNote: "'vad' (to speak) → first person singular present", difficulty: .easy),
        PracticeItem(id: "d7", category: .dailyActions, english: "I play", hindi: "मैं खेलता/खेलती हूँ", sanskrit: "अहं क्रीडामि", transliteration: "ahaṁ krīḍāmi", grammarNote: "'krīḍ' (to play) → first person singular present", difficulty: .easy),
    ]

    // MARK: - School Phrases
    private let schoolPhrases: [PracticeItem] = [
        PracticeItem(id: "s1", category: .schoolPhrases, english: "Please sit down", hindi: "कृपया बैठिए", sanskrit: "कृपया उपविशतु", transliteration: "kṛpayā upaviśatu", grammarNote: "'kṛpayā' (please) + 'upaviśatu' (may sit — imperative third person)", difficulty: .medium),
        PracticeItem(id: "s2", category: .schoolPhrases, english: "Open the book", hindi: "पुस्तक खोलो", sanskrit: "पुस्तकं उद्घाटय", transliteration: "pustakaṁ udghāṭaya", grammarNote: "'pustakam' (book, accusative) + 'udghāṭaya' (open — imperative)", difficulty: .medium),
        PracticeItem(id: "s3", category: .schoolPhrases, english: "What is your name?", hindi: "आपका नाम क्या है?", sanskrit: "भवतः नाम किम्?", transliteration: "bhavataḥ nāma kim?", grammarNote: "'bhavataḥ' (your, genitive) + 'nāma' (name) + 'kim' (what)", difficulty: .medium),
        PracticeItem(id: "s4", category: .schoolPhrases, english: "My name is...", hindi: "मेरा नाम...है", sanskrit: "मम नाम...अस्ति", transliteration: "mama nāma...asti", grammarNote: "'mama' (my, genitive) + 'nāma' (name) + 'asti' (is)", difficulty: .easy),
        PracticeItem(id: "s5", category: .schoolPhrases, english: "I understand", hindi: "मैं समझता/समझती हूँ", sanskrit: "अहं अवगच्छामि", transliteration: "ahaṁ avagacchāmi", grammarNote: "'ava' (prefix) + 'gacchāmi' = understand, literally 'go into'", difficulty: .medium),
        PracticeItem(id: "s6", category: .schoolPhrases, english: "I do not understand", hindi: "मैं नहीं समझता/समझती", sanskrit: "अहं न अवगच्छामि", transliteration: "ahaṁ na avagacchāmi", grammarNote: "'na' is the negation particle — placed before the verb", difficulty: .medium),
    ]

    // MARK: - Simple Sentences
    private let simpleSentences: [PracticeItem] = [
        PracticeItem(id: "ss1", category: .simpleSentences, english: "The boy goes to school", hindi: "लड़का विद्यालय जाता है", sanskrit: "बालकः विद्यालयं गच्छति", transliteration: "bālakaḥ vidyālayaṁ gacchati", grammarNote: "Subject (nominative) + object (accusative) + verb — standard Sanskrit word order", difficulty: .medium),
        PracticeItem(id: "ss2", category: .simpleSentences, english: "The girl reads a book", hindi: "लड़की पुस्तक पढ़ती है", sanskrit: "बालिका पुस्तकं पठति", transliteration: "bālikā pustakaṁ paṭhati", grammarNote: "'bālikā' (girl, nominative) + 'pustakam' (book, accusative) + 'paṭhati' (reads)", difficulty: .medium),
        PracticeItem(id: "ss3", category: .simpleSentences, english: "Water is life", hindi: "जल ही जीवन है", sanskrit: "जलम् एव जीवनम्", transliteration: "jalam eva jīvanam", grammarNote: "'eva' means 'indeed/only' — an emphatic particle", difficulty: .easy),
        PracticeItem(id: "ss4", category: .simpleSentences, english: "Knowledge is power", hindi: "ज्ञान शक्ति है", sanskrit: "विद्या बलम् अस्ति", transliteration: "vidyā balam asti", grammarNote: "A classical Sanskrit proverb structure: subject + predicate + 'asti'", difficulty: .easy),
        PracticeItem(id: "ss5", category: .simpleSentences, english: "The sun rises", hindi: "सूर्य उदय होता है", sanskrit: "सूर्यः उदेति", transliteration: "sūryaḥ udeti", grammarNote: "'ud' (up) + 'eti' (goes) = rises; a compound verb", difficulty: .medium),
        PracticeItem(id: "ss6", category: .simpleSentences, english: "Trees give fruit", hindi: "पेड़ फल देते हैं", sanskrit: "वृक्षाः फलानि यच्छन्ति", transliteration: "vṛkṣāḥ phalāni yacchanti", grammarNote: "Plural subject + plural object + third person plural verb", difficulty: .hard),
        PracticeItem(id: "ss7", category: .simpleSentences, english: "The earth is round", hindi: "पृथ्वी गोल है", sanskrit: "पृथ्वी गोलाकारा अस्ति", transliteration: "pṛthvī golākārā asti", grammarNote: "'golākārā' = round-shaped (feminine adjective agreeing with pṛthvī)", difficulty: .medium),
    ]
}
