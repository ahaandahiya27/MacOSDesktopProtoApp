#!/usr/bin/env python3
"""P1-H — add `examConnections` to the 15 NEP Sanskrit chapters.

The Sanskrit pack carried `whatIfs` (≥3/ch, shipped earlier), `deepDive`,
`bossQuestions` and `crossChapterRefs`, but ZERO `examConnections` — so
`ExamConnectionCalloutView` was dark on every Sanskrit chapter tab. This adds
3 "you'll see this again" forward pointers per NEP chapter (45 total), each:

  * 60–120 words, a genuine pointer toward where the Grade-7 idea is formally
    studied in higher Sanskrit (Class 8…Class 12) — the grammar ladder,
    the subhāṣita / Upanishadic / Gītā literary tradition, and the
    history/culture threads;
  * `targetExam`-tagged (class8 / class9 / class10 / class12);
  * anchored by ≥1 REAL in-chapter `relatedConceptId` (the injector hard-fails
    if any anchor does not resolve in-pack).

The legacy `ch01` vocabulary deck is the documented carve-out and is skipped —
a `ch01_xc*` id would collide with Science's `ch01_xc*` and muddy the
cross-pack id index. Ids are `schNN_xcII`, distinct from Science `chNN_xc`.

Additive only. Re-runnable (idempotent: overwrites the `examConnections` key on
the NEP chapters only). Writes the canonical format
`json.dumps(d, ensure_ascii=False, indent=2) + "\n"` so verify_pack_roundtrip
stays byte-for-byte green (Devanagari survives via ensure_ascii=False).
"""
import json
from pathlib import Path

PACK = Path(__file__).resolve().parent.parent / "desktopAhaan/Subjects/Packs/sanskrit_class7.json"


def xc(id, title, body, target, related):
    return {
        "id": id,
        "title": title,
        "body": body,
        "targetExam": target,
        "relatedConceptIds": related,
    }


EXAM = {
    "sch01": [
        xc("sch01_xc01", "Compound words (समास) — the grammar behind सस्यश्यामला",
           "Words like सस्यश्यामला ('dark-green with crops') and पर्वतराजः ('king of mountains') are compounds — "
           "two words fused into one, a hallmark of Sanskrit you meet formally in Class 8 as समास. There you learn "
           "the named types: तत्पुरुष (पर्वतराजः = the king OF mountains), कर्मधारय (descriptive), and द्वन्द्व "
           "(and-compounds). Splitting a long compound back into its parts (विग्रह) becomes a core exam skill, and "
           "this patriotic poem is full of them — so the words you sing now are your first live samāsas.",
           "class8", ["sch01_t02_c04", "sch01_t02_c01"]),
        xc("sch01_xc02", "Patriotic literature — Vande Mātaram in its full setting",
           "The single line वन्दे मातरम् you bow with here is the opening of a longer hymn that Bankim Chandra "
           "wove into his 1882 novel Ānandamaṭha. In Class 9 and 10 Sanskrit and history you read the fuller song "
           "and learn how a Sanskrit verse became independent India's national song, sung at the 1896 Congress by "
           "Rabindranath Tagore. The grammar of देवी-stem feminine nouns and the genitive 'of the motherland' that "
           "you taste here is studied systematically later.",
           "class9", ["sch01_t01_c01", "sch01_t01_c02"]),
        xc("sch01_xc03", "The vocative — how Sanskrit calls out and salutes",
           "वन्दे … मातरम् addresses the motherland directly — that 'calling' form is the vocative (सम्बोधन) case. "
           "In Class 8 declension tables you learn the vocative as one of the eight forms every noun takes, and "
           "you meet it constantly in prayers and salutations (हे राम!, भारतमातः!). Recognising when a noun is "
           "being SPOKEN TO rather than spoken about is exactly the skill this salutation introduces, and it is "
           "tested in every declension exercise from Class 8 onward.",
           "class8", ["sch01_t01_c01", "sch01_t02_c03"]),
    ],
    "sch02": [
        xc("sch02_xc01", "The subhāṣita tradition — Bhartṛhari's three Śatakas",
           "These wise verses are subhāṣitas — 'well-spoken' couplets that pack a life-lesson into four lines. In "
           "Class 9 and 10 you study India's great subhāṣita collections, above all Bhartṛhari's three Śatakas "
           "(hundred-verse sets) on niti (ethics), śṛṅgāra (love) and vairāgya (renunciation). The drop-by-drop "
           "image (जलबिन्दुनिपातेन) you meet here is itself one of the most quoted subhāṣitas. Learning to read, "
           "scan and memorise such verses is a standard Sanskrit exam task in higher classes.",
           "class9", ["sch02_t01_c01", "sch02_t01_c05"]),
        xc("sch02_xc02", "Meter (छन्दस्) — why a śloka has exactly this rhythm",
           "Most subhāṣitas are written in the anuṣṭubh metre — four quarters of eight syllables each, the "
           "commonest śloka shape in all Sanskrit. In Class 9 and 10 you formally study chandas (prosody): how to "
           "mark each syllable as light (ह्रस्व) or heavy (दीर्घ) and check that a verse scans. The steady beat you "
           "feel when you recite these sayings is no accident — it is the metre, and scanning it correctly is a "
           "tested skill that builds directly on the vowel-quantity work of chapter 13.",
           "class9", ["sch02_t01_c01", "sch02_t01_c02"]),
        xc("sch02_xc03", "Building Sanskrit vocabulary — synonyms and word-families",
           "Words such as रिपुः (enemy), प्रेरकः (one who inspires) and सङ्गतिः (company) are the seed of the rich "
           "synonym-sets Sanskrit prizes. In Class 8 onward you learn to group such words by root and meaning, and "
           "the Amarakośa — the classical thesaurus students once memorised — lists dozens of synonyms for common "
           "ideas. The habit of collecting a word with its near-synonyms, which these verses encourage, becomes a "
           "deliberate vocabulary-building method tested in comprehension and composition.",
           "class8", ["sch02_t02_c03", "sch02_t02_c01"]),
    ],
    "sch03": [
        xc("sch03_xc01", "The dative case (चतुर्थी) and the whole vibhakti system",
           "मित्राय नमः puts 'to the Sun' in the dative (चतुर्थी), the case Sanskrit uses after नमः ('salutation "
           "TO'). In Class 8 you learn all seven cases (सप्तविभक्ति) as a full table, and the rule that नमः, "
           "स्वस्ति and similar words always take the dative. The single dative ending you meet here in worship is "
           "one cell of a paradigm you will decline completely for masculine, feminine and neuter stems — the "
           "backbone of every later grammar exam.",
           "class8", ["sch03_t02_c01", "sch03_t01_c02"]),
        xc("sch03_xc02", "The stotra tradition — the twelve names and beyond",
           "The सूर्यस्य द्वादश नामानि (twelve names of the Sun) are a small stotra — a Sanskrit praise-litany of "
           "names. In higher classes you read longer stotras like the Āditya-hṛdayam and the many nāmāvalī "
           "('garland of names') hymns, and learn how each name is a meaningful epithet, not just a label. The "
           "pattern of saluting one deity by many names, which you practise here, is a whole devotional genre "
           "studied in Sanskrit literature.",
           "class10", ["sch03_t01_c03", "sch03_t01_c01"]),
        xc("sch03_xc03", "Yoga and Sanskrit — the language of well-being",
           "सूर्यनमस्कार links Sanskrit to yoga, whose technical vocabulary — आसन, प्राणायाम, the qualities प्रज्ञा "
           "(wisdom), तेजस् (radiance) and वीर्य (vigour) — is entirely Sanskrit. In Class 11 and 12 physical-"
           "education and value-education courses, and in any serious yoga study, this terminology returns "
           "untranslated. The healthy-body theme (स्वस्थं शरीरम्) you meet here is the doorway to a Sanskrit "
           "vocabulary used worldwide today.",
           "class12", ["sch03_t01_c01", "sch03_t01_c04"]),
    ],
    "sch04": [
        xc("sch04_xc01", "The fable tradition — Pañcatantra and Hitopadeśa",
           "The fox-and-grapes story is a fable in the great Indian tradition of the Pañcatantra and Hitopadeśa, "
           "animal tales that teach nīti (worldly wisdom). In Class 8 and 9 you read more of these in the "
           "original Sanskrit, each ending in a moral subhāṣita. You also learn how the Pañcatantra travelled "
           "westward and shaped Aesop and later European fables — so this single tale is your entry into a "
           "story-form that circled the globe.",
           "class8", ["sch04_t01_c01", "sch04_t01_c04"]),
        xc("sch04_xc02", "Indeclinable adverbs — the तसिल् direction words",
           "Words like अधस्तात् and उपरिष्टात् ('below', 'above') are direction-adverbs formed with the तसिल् "
           "suffix, and they never change their form. In Class 8 and 9 you study such avyaya (indeclinables) as a "
           "category — adverbs of place, time and manner that stay fixed while everything around them declines. "
           "Spotting that these direction-words behave differently from nouns, which this fable introduces, is a "
           "tested grammar point later.",
           "class9", ["sch04_t02_c01", "sch04_t01_c03"]),
        xc("sch04_xc03", "The present tense (लट् लकार) in narration",
           "Verbs like उत्पतति ('he jumps up') tell the story in the present tense — what Sanskrit calls the लट् "
           "लकार. In Class 8 you conjugate लट् fully across all three persons and numbers, and notice how Sanskrit "
           "often narrates even past events in a vivid present, exactly as this fable does. The single verb-form "
           "you read here is one cell of the conjugation table you build systematically in chapter 15 and master "
           "in Class 8.",
           "class8", ["sch04_t01_c03", "sch04_t01_c01"]),
    ],
    "sch05": [
        xc("sch05_xc01", "Karma-yoga — selfless service in the Bhagavad Gītā",
           "सेवा परमो धर्मः ('service is the highest duty') is the heart of karma-yoga, the path of selfless action "
           "the Bhagavad Gītā teaches. In Class 10 and 12 value-education and Sanskrit courses you read Gītā verses "
           "on निष्काम कर्म — acting without craving the reward — and trace how this idea shaped leaders like "
           "Gandhi. The doctor who serves यन्त्रवत् (tirelessly, like a machine) is a living example of the "
           "principle you study in depth later.",
           "class12", ["sch05_t01_c01", "sch05_t01_c04"]),
        xc("sch05_xc02", "Formal vocabulary — degrees, titles and humane values",
           "Words such as उपाधिः (degree), पदवी (position) and मानवीयाः (humane) belong to the register of formal, "
           "modern Sanskrit used for official and ethical writing. In Class 9 and 10 composition you use exactly "
           "this vocabulary to write essays on character and citizenship, and learn how Sanskrit coins precise "
           "terms for modern roles. The respectful, value-laden words this lesson introduces are the building "
           "blocks of higher-class Sanskrit essay-writing.",
           "class9", ["sch05_t02_c01", "sch05_t02_c02b"]),
        xc("sch05_xc03", "Āyurveda — the Sanskrit science of healing",
           "The कषायम् (herbal decoction) the physician prepares points to Āyurveda, India's classical medical "
           "system, whose entire literature — Caraka and Suśruta Saṃhitā — is in Sanskrit. In higher study, and in "
           "any Āyurveda or biology-of-medicine course, this terminology returns. The healing-service theme you "
           "meet here connects Sanskrit to a living science still practised across India today.",
           "class10", ["sch05_t02_c03", "sch05_t01_c03"]),
    ],
    "sch06": [
        xc("sch06_xc01", "Memorising the classics — antyākṣarī to the Subhāṣita-Ratna-Bhāṇḍāgāra",
           "Śloka-antyākṣarī, the game of capping verses, rests on having many subhāṣitas by heart. In Class 9 and "
           "10 you build that memory bank, drawing on great anthologies like the Subhāṣita-Ratna-Bhāṇḍāgāra "
           "('treasure-house of well-spoken jewels'). The verses on विद्या (learning) you play with here — "
           "विद्याहीना न शोभन्ते — are among the most quoted, and reciting them accurately, with correct sandhi and "
           "metre, is a standard exam and recitation task.",
           "class9", ["sch06_t01_c01", "sch06_t01_c02"]),
        xc("sch06_xc02", "Sandhi — why the last syllable of a verse matters",
           "Antyākṣarī turns on the FINAL sound of each verse — and that final sound is governed by sandhi, the "
           "Sanskrit rules for how sounds join and change at word and line boundaries. In Class 8, 9 and 10 you "
           "study svara-sandhi and vyañjana-sandhi formally, learning why अ + इ becomes ए and how a verse's last "
           "letter is determined. The very thing that makes this game work is a tested grammar topic ahead.",
           "class8", ["sch06_t01_c01", "sch06_t01_c03"]),
        xc("sch06_xc03", "Personification in poetry — when लक्ष्मी and यशस्विनी act",
           "Verses that speak of लक्ष्मीः (Fortune) and यशस्विनी (the Fame-bearer) as if they were people use "
           "personification, a poetic device (अलङ्कार). In Class 10 and 11 Sanskrit literature you study alaṅkāra-"
           "śāstra — the formal theory of figures of speech like upamā (simile), rūpaka (metaphor) and "
           "personification. Noticing that an abstract quality is being treated as a living agent, as these "
           "subhāṣitas do, is the first step into that rich analytical tradition.",
           "class10", ["sch06_t02_c03", "sch06_t02_c04"]),
    ],
    "sch07": [
        xc("sch07_xc01", "The Upaniṣads and Vedānta — Īśāvāsya in full",
           "ईशावास्यम् इदं सर्वम् is the opening line of the Īśa Upaniṣad, one of the principal Upaniṣads. In Class "
           "12 Sanskrit and philosophy you read this short Upaniṣad in full and meet the Vedānta idea that one "
           "divine reality pervades everything — the doctrine of Advaita summed up in तत्त्वमसि ('thou art that'). "
           "The single verse you contemplate here opens onto the deepest stratum of Sanskrit thought, studied "
           "formally in senior classes.",
           "class12", ["sch07_t01_c01", "sch07_t01_c02"]),
        xc("sch07_xc02", "Future tense (लृट् लकार) — दास्यन्ति, 'they shall give'",
           "दास्यन्ति ('they shall give') is in the future tense, the लृट् लकार. In Class 9 you conjugate लृट् "
           "fully and learn how Sanskrit forms the future with the स/ष्य marker. This Upaniṣadic verse, promising "
           "what devotion shall yield, gives you a live future-tense form to recognise before you study the whole "
           "paradigm — one of the ten लकार you map in chapter 15.",
           "class9", ["sch07_t02_c02", "sch07_t01_c04"]),
        xc("sch07_xc03", "Present-tense verbs of devotion — ध्यायन्ति, आराधनम्",
           "ध्यायन्ति ('they meditate') and the noun आराधनम् (worship) belong to a family of devotional verbs and "
           "verbal nouns. In Class 8 and 9 you learn how a verb root like ध्यै yields both a conjugated verb and a "
           "derived noun, and how the ल्युट् suffix builds action-nouns ending in -अनम्. The pairing of 'to "
           "meditate' with 'meditation' that you meet here is a regular word-formation pattern studied later.",
           "class8", ["sch07_t02_c03", "sch07_t02_c01"]),
    ],
    "sch08": [
        xc("sch08_xc01", "Ethics of speech — the सूक्ति tradition and the Gītā's vāṅmaya tapas",
           "हितं मनोहारि च दुर्लभं वचः — 'rare is speech both useful and pleasing' — is a sūkti (good saying) about "
           "the ethics of speech. In Class 10 and 12 you meet the Bhagavad Gītā's vāṅmaya tapas (the 'austerity of "
           "speech': words that are true, kind and beneficial), and study how Sanskrit literature repeatedly "
           "praises measured speech. The standard this verse sets becomes a recurring theme in value-education "
           "texts ahead.",
           "class12", ["sch08_t01_c01", "sch08_t02_c01"]),
        xc("sch08_xc02", "Adverbs of manner — क्षणशः, कणशः ('moment by moment')",
           "क्षणशः ('moment by moment') and कणशः ('bit by bit') are formed with the शस् suffix, which turns a noun "
           "into an adverb of distribution. In Class 8 and 9 you study this and related suffixes (तसिल्, वति) that "
           "build adverbs, and use them to write precise sentences about how and how-much. The vivid "
           "'little-by-little' words this verse uses to praise steady effort are a tested word-formation pattern.",
           "class9", ["sch08_t01_c02", "sch08_t01_c04"]),
        xc("sch08_xc03", "Contrasting virtue and vice — the किया-vs-boast couplet",
           "This verse sets the क्रियावान् (one of action) against the विकत्थनम् (boaster) — a contrast-couplet, a "
           "favourite subhāṣita structure. In Class 9 and 10 you read many such verses built on opposition, and "
           "learn to identify the device and state the moral in your own Sanskrit. Recognising how a single śloka "
           "stages two opposed characters to teach a lesson, as this one does, is a comprehension skill tested "
           "later.",
           "class10", ["sch08_t01_c04", "sch08_t01_c03"]),
    ],
    "sch09": [
        xc("sch09_xc01", "The Gītā's yajña-cycle — Bhagavad Gītā 3.14 in full",
           "अन्नाद् भवन्ति भूतानि is the opening of Bhagavad Gītā 3.14, which traces a whole cycle: beings come "
           "from food, food from rain, rain from yajña (sacrifice), yajña from action. In Class 12 Sanskrit and "
           "philosophy you read this verse and its neighbours in full and learn how the Gītā links ecology, duty "
           "and the cosmos. The single line you meet here is the first link of a chain studied closely in senior "
           "classes.",
           "class12", ["sch09_t01_c01", "sch09_t01_c02"]),
        xc("sch09_xc02", "The optative (विधिलिङ्) — जानीयात्, '(one) should know'",
           "जानीयात् ('one should know') is in the optative mood, the विधिलिङ् लकार, used for advice, rules and "
           "'should' statements. In Class 9 and 10 you conjugate विधिलिङ् fully and meet it everywhere ethical "
           "texts give guidance (e.g. सत्यं वदेत्, 'one should speak truth'). This verse's gentle 'should know' "
           "gives you a live optative form before you study the whole mood — one of the ten लकार of chapter 15.",
           "class9", ["sch09_t01_c04", "sch09_t01_c03"]),
        xc("sch09_xc03", "Sanskrit and modern science — रसायनशास्त्रम् and beyond",
           "The word रसायनशास्त्रम् ('chemistry') shows Sanskrit coining vocabulary for modern science from "
           "classical roots — रसायन once meant alchemy and Āyurvedic tonics. In Class 9 and 10 you meet the "
           "Sanskrit terms for the sciences (विज्ञानम्, भौतिकशास्त्रम्, जीवविज्ञानम्) and see how the language "
           "renews itself. This verse's bridge from ancient 'food makes beings' to modern biochemistry is exactly "
           "the old-meets-new theme explored further later.",
           "class10", ["sch09_t01_c03", "sch09_t02_c04"]),
    ],
    "sch10": [
        xc("sch10_xc01", "Ordinal numbers — प्रथमः to दशमः and the saṅkhyā system",
           "The riddle turns on counting प्रथमः, द्वितीयः … दशमः (first to tenth) — the ordinal numbers. In Class "
           "8 you study Sanskrit's full number system (saṅkhyā): cardinals (एकम्, द्वे, त्रीणि…), ordinals, and how "
           "numerals agree with the nouns they count. The ten ordinals you use to solve 'who is the tenth?' are "
           "one slice of a number-grammar studied completely in higher classes.",
           "class8", ["sch10_t02_c01", "sch10_t01_c01"]),
        xc("sch10_xc02", "The imperfect past (लङ् लकार) — अगणयत्, 'he counted'",
           "अगणयत् ('he counted') is in the imperfect past tense, the लङ् लकार, marked by the augment अ- at the "
           "front. In Class 9 you conjugate लङ् fully and learn to recognise that initial अ- as the sign of past "
           "narration. This story, told partly in the past, gives you a live imperfect form before you master the "
           "whole paradigm — another of the ten लकार mapped in chapter 15.",
           "class9", ["sch10_t02_c03", "sch10_t01_c04"]),
        xc("sch10_xc03", "Interrogatives — कः, कतमः, कतरः and the किम् paradigm",
           "दशमः कः? ('who is the tenth?') uses the question-word कः, and the lesson distinguishes कतमः ('which of "
           "many?') from कतरः ('which of two?'). In Class 8 you decline the full किम् (interrogative) pronoun "
           "across all cases and genders, and learn these fine 'which?' distinctions Sanskrit makes that English "
           "blurs. The questions that drive this riddle are your introduction to a pronoun paradigm tested "
           "thoroughly later.",
           "class8", ["sch10_t02_c04", "sch10_t01_c01"]),
    ],
    "sch11": [
        xc("sch11_xc01", "Modern history in Sanskrit — the Cellular Jail and Savarkar",
           "This lesson tells, in Sanskrit, of the सेल्युलर कारागारम् (Cellular Jail) and वीर सावरकर's "
           "imprisonment — modern history written in the classical language. In Class 9 and 10 you read more such "
           "historical Sanskrit prose about India's freedom struggle, and learn how Sanskrit is used today to "
           "narrate recent events. The freedom-fighter narrative you meet here shows the language as living, not "
           "merely ancient — a theme developed in senior comprehension passages.",
           "class10", ["sch11_t01_c02", "sch11_t01_c03"]),
        xc("sch11_xc02", "The past active participle (क्तवतु) — सोढवान्, 'he bore'",
           "सोढवान् ('he bore/endured') is a past active participle, formed with the क्तवतु suffix (-तवत्), which "
           "turns a verb into an adjective meaning 'having done'. In Class 9 and 10 you study क्त and क्तवतु "
           "participles as a pair and use them to compress sentences ('he, having endured…'). This single word, "
           "describing Savarkar's endurance, is a live example of a participle system tested in higher grammar.",
           "class9", ["sch11_t02_c03", "sch11_t01_c03"]),
        xc("sch11_xc03", "Descriptive prose and compounds — द्वीप, कारागारम्, त्रितलात्मकम्",
           "Phrases like प्रवालप्रस्तरैः ('with coral rocks') and त्रितलात्मकम् ('three-storeyed') are rich "
           "descriptive compounds typical of Sanskrit prose. In Class 9 and 10 you read longer descriptive "
           "passages (वर्णनात्मक गद्य) and learn to unpack such compounds and answer comprehension questions on "
           "them. The vivid, compound-heavy description of the Andaman islands you read here previews the prose "
           "style you analyse in senior classes.",
           "class9", ["sch11_t02_c01", "sch11_t02_c02"]),
    ],
    "sch12": [
        xc("sch12_xc01", "Historical heroism in Sanskrit — Rajput valour and Panna Dhai",
           "The tale of पन्नाधाया, who sacrificed her own son to save the Mewar prince in षोडशे शतके (the "
           "sixteenth century), is Sanskrit historical narrative. In Class 9 and 10 you read more such "
           "biographical prose about India's heroes and learn to retell and analyse it in Sanskrit. The "
           "sacrifice-and-loyalty theme (सर्वस्वत्यागः), written in classical language about real history, is the "
           "kind of passage tested in senior comprehension and composition.",
           "class10", ["sch12_t01_c01", "sch12_t01_c02"]),
        xc("sch12_xc02", "The infinitive (तुमुन्) — मारयितुम्, 'to kill'",
           "मारयितुम् ('to kill') is an infinitive, formed with the तुमुन् suffix (-तुम्), expressing purpose — "
           "'came IN ORDER TO kill'. In Class 8 and 9 you form infinitives from many roots and use them after "
           "verbs of wishing and ability (इच्छति … गन्तुम्, 'wishes to go'). This single purpose-form, naming the "
           "assassin's intent, is a live तुमुन् infinitive before you study the whole pattern formally.",
           "class9", ["sch12_t02_c03", "sch12_t02_c02"]),
        xc("sch12_xc03", "Feminine vocabulary and honour — धाया, वीराङ्गना",
           "Words like धाया (wet-nurse / foster-mother) and वीराङ्गना (a brave woman) belong to Sanskrit's "
           "feminine vocabulary of honour. In Class 9 and 10 you decline आकारान्त feminine stems fully and write "
           "about heroic women of India in Sanskrit. The respectful feminine words this lesson uses for Panna "
           "Dhai introduce a stem-class and a value-theme you develop in higher composition.",
           "class9", ["sch12_t02_c01", "sch12_t01_c01"]),
    ],
    "sch13": [
        xc("sch13_xc01", "Prosody (छन्दस्) — vowel-quantity becomes metre",
           "Marking vowels as ह्रस्व (short), दीर्घ (long) or प्लुत (prolonged) is the foundation of chandas — "
           "Sanskrit prosody. In Class 9 and 10 you use exactly this short/long distinction to scan verses and "
           "name their metres (anuṣṭubh, indravajrā…), since a metre is defined by its pattern of light and heavy "
           "syllables. The vowel-quantity you measure here is the very alphabet of the metrical analysis tested in "
           "senior literature.",
           "class9", ["sch13_t01_c01", "sch13_t01_c02"]),
        xc("sch13_xc02", "Śikṣā — the Vedāṅga of correct pronunciation",
           "Caring about exact vowel-duration belongs to Śikṣā, the Vedāṅga (limb of the Veda) devoted to correct "
           "pronunciation, so that sacred verses are chanted precisely. In Class 11 and 12, and in any study of "
           "Vedic recitation, you meet Śikṣā's rules of accent (स्वर) and duration. The precision this chapter "
           "trains — that a long vowel is genuinely twice a short one — is the discipline that kept the Vedas "
           "intact orally for millennia.",
           "class12", ["sch13_t01_c01", "sch13_t01_c03"]),
        xc("sch13_xc03", "Onomatopoeia and animal sounds — कुक्कुटः रौति",
           "Verbs naming animal cries — कुक्कुटः रौति ('the rooster crows'), and the calls of the वायस (crow) and "
           "शिखी (peacock) — are onomatopoeic and use special roots. In Class 8 you collect such sound-words and "
           "the Sanskrit names of common birds and animals, and conjugate रु in singular and plural (रौति / "
           "रुवन्ति). The playful animal-sounds that teach vowel length here also build the vocabulary tested in "
           "later word-lists.",
           "class8", ["sch13_t02_c01", "sch13_t02_c03"]),
    ],
    "sch14": [
        xc("sch14_xc01", "The seven cases (सप्तविभक्ति) across every stem-class",
           "This chapter introduces the seven cases on अ-, इ- and उ-ending masculine stems. In Class 8 and 9 you "
           "extend the same सप्तविभक्ति framework to feminine and neuter stems, to consonant-ending words, and to "
           "pronouns — building a full library of declension tables (शब्दरूप). Knowing that every noun answers "
           "seven 'role' questions (who? whom? by? for? from? whose? where?), which you start here, is the single "
           "most tested grammar skill in all later Sanskrit.",
           "class8", ["sch14_t01_c01", "sch14_t01_c02"]),
        xc("sch14_xc02", "Kāraka theory — cases as the roles in a sentence",
           "The cases are not just endings; each marks a kāraka — the ROLE a word plays around the verb (agent, "
           "object, instrument, recipient…). In Class 9 and 10 you study kāraka theory formally, learning rules "
           "like 'the agent takes प्रथमा in active voice but तृतीया in passive'. The instrumental (तृतीया) and "
           "ablative (पञ्चमी) you decline here are your first look at a role-system that governs how every Sanskrit "
           "sentence is built.",
           "class9", ["sch14_t02_c02", "sch14_t01_c01"]),
        xc("sch14_xc03", "The vocative (सम्बोधन) and how Sanskrit addresses people",
           "The सम्बोधन (vocative) form you meet in these tables is how Sanskrit calls out to someone — हे बालक!, "
           "हे राम!. In Class 8 you use the vocative throughout conversation and prayer, and notice how it usually "
           "echoes but sometimes shortens the nominative. Mastering the calling-form, introduced here as the last "
           "of the case-row, is essential for reading dialogue and devotional verse in higher classes.",
           "class8", ["sch14_t02_c04", "sch14_t01_c01"]),
    ],
    "sch15": [
        xc("sch15_xc01", "The ten लकार — the full tense-and-mood system",
           "This chapter shows the present-tense conjugation; Sanskrit has ten such paradigms, the दश लकाराः, "
           "covering present, past (three kinds), future (two kinds) and the moods (command, advice, condition). "
           "In Class 9 and 10 you learn to recognise and form each लकार by its tell-tale markers — the अ- augment "
           "of the past, the स्य of the future, the लिङ् of the optative. The single present paradigm you build "
           "here is one rung of a ten-rung ladder climbed across senior grammar.",
           "class9", ["sch15_t01_c02", "sch15_t02_c01"]),
        xc("sch15_xc02", "परस्मैपद vs आत्मनेपद and the ten verb-classes (गण)",
           "Verbs split into परस्मैपद (action for another, पठति) and आत्मनेपद (action for oneself, भाषते), and into "
           "ten conjugation-classes (गण) by how the root joins its endings. In Class 9 and 10 you learn which गण a "
           "root belongs to and which pada it takes — the key to conjugating any verb correctly. The contrast "
           "between पठति and भाषते you meet here is your first sight of a classification central to all verb "
           "grammar.",
           "class10", ["sch15_t01_c03", "sch15_t02_c04"]),
        xc("sch15_xc03", "Derived verbs — causatives, desideratives and the passive",
           "Once you know the basic conjugation of a root like कृ (करोति), Sanskrit lets you derive new verbs from "
           "it: the causative ('makes do', कारयति), the desiderative ('wishes to do', चिकीर्षति) and the passive "
           "('is done', क्रियते). In Class 10 and 11 you form these systematically. The plain present-tense verbs "
           "you conjugate here are the base on which a whole architecture of derived verbs is later built.",
           "class10", ["sch15_t02_c03", "sch15_t01_c01"]),
    ],
}


def main():
    pack = json.loads(PACK.read_text(encoding="utf-8"))
    chapter_concept_ids = {}
    for ch in pack["chapters"]:
        ids = set()
        for tp in ch["topics"]:
            for c in tp["concepts"]:
                ids.add(c["id"])
        chapter_concept_ids[ch["id"]] = ids

    seen_ids = set()
    total = 0
    for ch in pack["chapters"]:
        cid = ch["id"]
        if cid == "ch01":
            continue  # legacy vocab deck carve-out
        items = EXAM.get(cid)
        if not items or len(items) < 3:
            raise SystemExit(f"{cid}: need ≥3 examConnections, got {len(items or [])}")
        for it in items:
            if it["id"] in seen_ids:
                raise SystemExit(f"Duplicate id {it['id']}")
            seen_ids.add(it["id"])
            wc = len(it["body"].split())
            if wc < 50 or wc > 130:
                raise SystemExit(f"{it['id']} body {wc} words (want 50–130)")
            for rc in it["relatedConceptIds"]:
                if rc not in chapter_concept_ids[cid]:
                    raise SystemExit(f"{it['id']} relatedConceptId {rc} not in {cid}")
        ch["examConnections"] = items
        total += len(items)

    PACK.write_text(json.dumps(pack, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(f"Injected {total} examConnections across the 15 NEP Sanskrit chapters.")


if __name__ == "__main__":
    main()
