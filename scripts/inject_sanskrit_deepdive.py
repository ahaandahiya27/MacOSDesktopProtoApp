#!/usr/bin/env python3
"""P1-B — add `deepDive: [StretchTopic]` arrays to every NEP Sanskrit chapter.

The Sanskrit pack (`sanskrit_class7.json`, NCERT Deepakam Grade 7) shipped with
zero deepDive entries — the last subject blocking the v6 Olympiad ladder
(Phase 5) and capping the adaptive journey (Phase 3). This adds 3 PDF-faithful
StretchTopics per NEP chapter (sch01–sch15 → 45 total). The legacy `ch01`
vocabulary deck is the documented carve-out and is intentionally skipped.

Each StretchTopic:
  * is anchored via `parentConceptId` to a REAL concept id inside that chapter,
  * is tagged class_8…class_12 — a genuine forward extension of the Grade-7
    idea, whether grammar (sandhi, samāsa, kāraka, the lakāra system, taddhita
    suffixes, chandas), literature (Īśopaniṣad, Bhagavad Gītā, Bhartṛhari's
    subhāṣitas, the Pañcatantra nīti tradition), or history/culture (Vande
    Mataram, the Cellular Jail, Mewar and Panna Dhai),
  * has a prerequisite + next-step hint and a body ≥ 120 words.

Additive only. Re-runnable. Writes the canonical format
`json.dumps(d, ensure_ascii=False, indent=2) + "\n"` so verify_pack_roundtrip.py
stays byte-for-byte green and Devanagari survives unescaped.
"""
import json
from pathlib import Path

PACK = Path(__file__).resolve().parent.parent / "desktopAhaan/Subjects/Packs/sanskrit_class7.json"


def t(id, title, grade, parent, body, prereq, nxt):
    return {
        "id": id,
        "title": title,
        "gradeLevel": grade,
        "parentConceptId": parent,
        "body": body,
        "prerequisite": prereq,
        "bonusQuestions": None,
        "nextStepHint": nxt,
    }


DEEP_DIVE = {
    "sch01": [
        t("sch01_dd01", "From a novel to a nation's song — the story of Vande Mataram",
          "class_9", "sch01_t01_c02",
          "Bankim Chandra Chattopadhyay did not write वन्दे मातरम् as a separate poem — he wove it into his 1882 "
          "Bengali novel आनन्दमठ (Ānandamaṭha), where sannyāsī rebels sing it as a hymn to the motherland imagined "
          "as a goddess. Its language is the famous 'maṇipravāḷa' blend, opening in pure Sanskrit (वन्दे मातरम्, "
          "सुजलां सुफलां…) before shifting to Bengali. Rabindranath Tagore set it to music and first sang it at "
          "the 1896 session of the Indian National Congress, and through the freedom struggle the cry 'Vande "
          "Mataram!' became a slogan that sent thousands to jail. On 24 January 1950 the Constituent Assembly gave "
          "it the status of राष्ट्रगीत (national song), holding it equal in honour to the राष्ट्रगान (national "
          "anthem) जन गण मन. Knowing this history turns the verses you recite from pretty words into a living "
          "document of how a language and a song helped build a country.",
          "Tackle this once you can recite the opening lines and know Bankim Chandra wrote them.",
          "In later classes you study the literature of India's freedom movement and the difference between the national song and the national anthem."),
        t("sch01_dd02", "समासः — how Sanskrit packs a whole phrase into one word",
          "class_8", "sch01_t02_c04",
          "सस्यश्यामला — 'dark-green with crops' — looks like one word but is really a compressed phrase: सस्यैः "
          "श्यामला, 'green BY/with crops'. This packing of several words into one is समास (compound), one of "
          "Sanskrit's signature powers and the reason its poetry can be so dense. Class 8 names the main types you "
          "will meet everywhere: तत्पुरुष, where the first word qualifies the second (राजपुत्रः = राज्ञः पुत्रः, "
          "'king's son'); कर्मधारय, where both words describe the same thing (नीलकमलम्, 'blue lotus'); द्वन्द्व, a "
          "simple 'and' list (रामलक्ष्मणौ, 'Rāma and Lakṣmaṇa'); and बहुव्रीहि, which points OUTSIDE itself "
          "(पीताम्बरः = 'one whose cloth is yellow', i.e. Viṣṇu). To read a compound you 'unpack' it (विग्रह) back "
          "into the phrase it stands for. Once you can split सस्यश्यामला, the longest, most frightening words in "
          "a Sanskrit verse become solvable puzzles rather than walls.",
          "Tackle this after you understand सस्यश्यामला as 'green with crops'.",
          "In Class 8 and 9 you formally study the four compound types and learn to do विग्रह (splitting a compound into its phrase)."),
        t("sch01_dd03", "Bhārata as a goddess — the देवीस्तुति tradition behind the verses",
          "class_10", "sch01_t02_c01",
          "Calling the land पर्वतराजः-crowned and रत्नाकरः-girdled is not random scenery — it follows a centuries-"
          "old Sanskrit convention of praising a being by listing its glories, the स्तुति (hymn of praise). The "
          "same form describes a deity: a goddess is invoked by her attributes — her mountains, rivers, and holy "
          "places — until the listener sees her whole. Vande Mataram deliberately borrows this devotional template, "
          "casting भारतमाता as a divine mother (मातृभूमि personified as देवी). This is why the song moves so many "
          "people: it speaks of a country in the grammar of worship. The wider tradition includes the देवीमाहात्म्य "
          "and countless अष्टक and स्तोत्र hymns, where epithets pile up in long compounds and the rhythm itself "
          "feels like a prayer. Recognising the स्तुति shape lets you see that a 'patriotic poem' is using one of "
          "Sanskrit literature's oldest and most powerful poetic engines.",
          "Tackle this once you know the epithets पर्वतराजः and रत्नाकरः describe the motherland.",
          "In Class 10 and beyond you read देवीस्तुति and स्तोत्र literature and study how epithet-stacking builds devotional poetry."),
    ],
    "sch02": [
        t("sch02_dd01", "सुभाषितम् — the great anthology tradition of Sanskrit wisdom-verses",
          "class_9", "sch02_t01_c01",
          "A सुभाषितम् (literally 'well-spoken') is a short, self-contained verse carrying one polished nugget of "
          "wisdom — and Sanskrit produced these by the thousand. The most famous single author is भर्तृहरि, whose "
          "शतकत्रय (three centuries of verses) splits into the नीतिशतक (on right conduct), शृङ्गारशतक (on love) and "
          "वैराग्यशतक (on detachment). Later scholars gathered the best from everywhere into huge collections like "
          "the सुभाषितरत्नभाण्डागारम् — a 'treasure-house of subhāṣita gems', the very image your chapter's title "
          "uses with रसम् (nectar). What makes a good subhāṣita memorable is craft: a tight metre, a vivid "
          "comparison, and a turn of thought in the last line. They were the SMS and proverbs of classical India, "
          "carried in memory and quoted to settle an argument. Reading them is the easiest doorway into real "
          "Sanskrit literature, because each verse is a complete, bite-sized poem.",
          "Tackle this once you know what a सुभाषितम् is and have learnt one by heart.",
          "In later classes you read selections from Bhartṛhari's शतकत्रय and study how anthologies preserved Sanskrit wisdom literature."),
        t("sch02_dd02", "अनुष्टुप् — the 8-syllable beat that carries most subhāṣitas",
          "class_8", "sch02_t01_c05",
          "The verse जलबिन्दुनिपातेन क्रमशः पूर्यते घटः ('drop by drop the pot is filled') is not just wise — it is "
          "built on a precise rhythm called अनुष्टुप् (anuṣṭubh), the workhorse metre of Sanskrit. An anuṣṭubh "
          "śloka has four quarters (पाद) of exactly eight syllables each, so 32 syllables in all, which is why so "
          "many subhāṣitas feel the same shape. Sanskrit prosody (छन्दस्) measures each syllable as light (लघु, "
          "one mātrā) or heavy (गुरु, two mātrās), and the anuṣṭuph has gentle rules — for instance the 5th "
          "syllable of a quarter is usually light and the 6th heavy — that give it its lilt. Almost the entire "
          "Rāmāyaṇa, the Mahābhārata and the Bhagavad Gītā are composed in this metre, which is why a child who "
          "internalises its beat can recite epic verses almost effortlessly. The 'drop-by-drop' lesson works on "
          "the metre too: feel a few ślokas and the rhythm fills you gradually.",
          "Tackle this once you can recite the जलबिन्दु verse with its natural rhythm.",
          "In later classes you study छन्दस् (prosody) formally, counting लघु and गुरु syllables to identify metres."),
        t("sch02_dd03", "दृष्टान्त — the art of the perfect comparison",
          "class_10", "sch02_t02_c04",
          "Subhāṣitas almost never just state a rule; they prove it with a picture. 'A pot fills drop by drop'; "
          "'company (सङ्गतिः) shapes a person as water takes the colour of the cloth it touches'. This deliberate "
          "use of a familiar example to illuminate an abstract truth is the अलङ्कार (figure of speech) called "
          "दृष्टान्त — 'the illustrative instance'. Sanskrit poetics (अलङ्कारशास्त्र) catalogues dozens of such "
          "figures: उपमा (simile, 'X is like Y'), रूपक (metaphor, 'X is Y'), उत्प्रेक्षा (poetic fancy), and many "
          "more, all studied in works like the काव्यप्रकाश. The reason the सङ्गतिः verse stays in your memory is "
          "that the comparison does the teaching — your mind keeps the image and the moral rides along with it. "
          "Learning to spot which अलङ्कार a verse uses turns reading from 'understanding the words' into "
          "appreciating the poet's craft, the real goal of literary study.",
          "Tackle this once you grasp that सङ्गतिः (company) shapes character, taught through a comparison.",
          "In senior classes you study अलङ्कारशास्त्र (Sanskrit poetics) and learn to identify उपमा, रूपक, दृष्टान्त and other figures of speech."),
    ],
    "sch03": [
        t("sch03_dd01", "Why नमः demands the dative — a first look at कारक theory",
          "class_8", "sch03_t02_c01",
          "मित्राय नमः means 'salutation TO Mitra', and the -आय ending (चतुर्थी, the dative) is not a free choice: "
          "the word नमः GOVERNS the dative. Sanskrit grammar explains this through कारक theory — the system that "
          "links a verb or word to the roles around it. The dative marks the सम्प्रदान कारक, the recipient 'for "
          "whom' something is meant, and Pāṇini's rule नमःस्वस्तिस्वाहास्वधालंवषड्योगाच्च specifically lists नमः "
          "(and स्वस्ति, स्वाहा…) as words after which the dative MUST appear. So 'नमः' + dative is a fixed "
          "partnership, exactly like English 'pertaining TO'. Each of the twelve sun-salutation mantras — ॐ "
          "मित्राय नमः, ॐ रवये नमः, ॐ सूर्याय नमः — repeats this pattern, drilling the dative twelve times in one "
          "practice. Seeing that the case ending is dictated by the governing word, not guessed, is your first "
          "step from 'memorising endings' to understanding WHY Sanskrit chooses each one.",
          "Tackle this once you can identify the चतुर्थी (dative) ending in मित्राय.",
          "In Class 9 you study the six कारक relations and how each maps to one of the seven cases (विभक्ति)."),
        t("sch03_dd02", "सूर्यस्य द्वादश नामानि — the twelve Ādityas and their meanings",
          "class_9", "sch03_t01_c03",
          "The Sun Salutation pairs each posture with one of सूर्य's twelve names, and these are not loose "
          "nicknames — they form the ancient set of द्वादश आदित्याः (the twelve Ādityas), one for each month of the "
          "year. The mantra-names you chant — मित्र (the friend), रवि (the radiant), सूर्य (the impeller), भानु "
          "(the shining), खग (the sky-goer), पूषन् (the nourisher), हिरण्यगर्भ (the golden-wombed), मरीचि (the "
          "ray-lord), आदित्य (son of Aditi), सवितृ (the vivifier), अर्क (the fire-orb), and भास्कर (the "
          "light-maker) — each captures a different power the sun was felt to have. The names double as a Sanskrit "
          "vocabulary lesson, because most are transparent: भास्करः literally 'doer of light' (भास् + कर). The "
          "Vedas already praise सूर्य/सवितृ (the गायत्री मन्त्र addresses सवितृ), so reciting these twelve names "
          "connects your morning stretch to one of the oldest threads in Indian thought.",
          "Tackle this once you can name a few of the sun's twelve names from the mantras.",
          "In later study you meet the गायत्री मन्त्र and the Vedic hymns to सूर्य/सवितृ, deepening the tradition behind these names."),
        t("sch03_dd03", "योगः and the science behind सूर्यनमस्कारः",
          "class_10", "sch03_t01_c01",
          "सूर्यनमस्कारः is one limb of the vast discipline of योग, systematised in Patañjali's योगसूत्र around two "
          "thousand years ago as a path of eight steps (अष्टाङ्गयोग) from ethical restraints (यम, नियम) through "
          "posture (आसन) and breath-control (प्राणायाम) to deep concentration (समाधि). The salutation chains twelve "
          "आसन — प्रणामासन, हस्तउत्तानासन, पादहस्तासन and the rest — each Sanskrit name describing the body's shape "
          "(पादहस्त = 'feet-and-hands'). Modern physiology explains why the sequence works: it alternately "
          "stretches and compresses the spine, syncs movement with inhalation and exhalation, and warms the whole "
          "body — which is exactly स्वस्थं शरीरम्, the 'healthy body' the chapter promises. Sanskrit is the "
          "technical language of this science the way Latin is for medicine, so learning the आसन names IS learning "
          "anatomy in Sanskrit. The chapter's blend of mantra and movement is yoga in miniature.",
          "Tackle this once you understand सूर्यनमस्कारः combines postures with mantras for a healthy body.",
          "In later study you explore Patañjali's अष्टाङ्गयोग and the Sanskrit names of the major आसन and प्राणायाम."),
    ],
    "sch04": [
        t("sch04_dd01", "The तसिल् suffix — building 'from / by way of' adverbs",
          "class_8", "sch04_t02_c01",
          "The direction words पूर्वतः ('from the east'), दक्षिणतः, उत्तरतः all share the ending -तः, and that "
          "ending is a real grammatical tool called the तसिल् (tasil) suffix. Added to a noun, -तः makes an "
          "indeclinable adverb meaning roughly 'from', 'by way of', or 'with respect to' — so मुखतः means 'from "
          "the mouth / orally', and शास्त्रतः means 'according to the scriptures'. It belongs to the large family "
          "of तद्धित (taddhita) suffixes, the endings Sanskrit attaches to nouns to spin off new words: -तः for "
          "'from-ness', -त्व and -ता for 'the quality of' (मधुरता = sweetness), -मत्/-वत् for 'possessing'. Because "
          "a word ending in -तः never changes form, it is wonderfully easy to use once you recognise it. Spotting "
          "the तसिल् suffix lets you instantly decode a whole class of direction- and source-words you will meet "
          "everywhere in Sanskrit prose.",
          "Tackle this once you can read direction words like पूर्वतः and दक्षिणतः.",
          "In Class 9 you study the तद्धित (secondary) suffixes more fully, including -त्व, -ता and -मत्."),
        t("sch04_dd02", "नीतिकथा — the Sanskrit fable tradition behind the fox",
          "class_9", "sch04_t01_c01",
          "Your शृगालः-and-grapes story is a Sanskrit retelling of one of Aesop's Greek fables, and the fit is no "
          "accident: India had its own ancient, hugely influential tradition of the नीतिकथा — the moral animal "
          "tale. The great collection is the पञ्चतन्त्रम् (c. 300 CE), where a wise teacher instructs three dull "
          "princes through stories of clever crows, foolish donkeys and scheming jackals; its shorter cousin is "
          "the हितोपदेशः. These were so beloved that they travelled west, translated through Persian and Arabic "
          "(as Kalīla wa Dimna) into nearly every European language — so Aesop and the Pañcatantra are distant "
          "cousins in a single world-tradition of teaching wisdom through talking animals. The fox who calls the "
          "unreachable grapes 'sour' (आम्लम्) is doing exactly what a पञ्चतन्त्र character does: dramatising a "
          "human failing so the moral sticks. The genre's whole point is that a story remembered teaches better "
          "than a rule recited.",
          "Tackle this once you can retell the fox-and-grapes fable and state its moral.",
          "In later classes you read tales from the पञ्चतन्त्रम् and हितोपदेशः in the original Sanskrit."),
        t("sch04_dd03", "उत्पतति — how a prefix (उपसर्ग) rebuilds a verb's meaning",
          "class_10", "sch04_t01_c03",
          "उत्पतति ('he jumps UP') is the verb root पत् ('to fall/fly') with the prefix उद् ('up') fastened in "
          "front — and that little prefix completely steers the meaning. Such prefixes are the उपसर्ग, a closed "
          "set of about twenty-two particles (प्र, परा, अप, सम्, नि, उद्, अव, आ, वि, अधि…) that attach to roots and "
          "twist their sense, sometimes drastically. From the single root हृ ('take') the prefixes spin off "
          "आहरति (brings), विहरति (wanders/plays), संहरति (gathers/destroys), प्रहरति (strikes) and प्रतिहरति "
          "(strikes back). A classical verse jokes that 'उपसर्गेण धात्वर्थो बलादन्यत्र नीयते' — a prefix drags the "
          "root's meaning forcibly elsewhere. So learning a handful of roots plus the उपसर्ग multiplies your "
          "vocabulary many times over, because you can predict उत्पतति from पत् once you know उद् means 'up'. "
          "Reading Sanskrit becomes far easier when you can peel the prefix off a verb and find the familiar root "
          "underneath.",
          "Tackle this once you can see उत्पतति as उद् + पत् ('jump up').",
          "In later classes you study the उपसर्ग systematically and learn how each shifts a root's meaning."),
    ],
    "sch05": [
        t("sch05_dd01", "धर्मः — the many meanings of 'the highest duty'",
          "class_9", "sch05_t01_c02",
          "When the chapter declares सेवा परमो धर्मः, 'service is the highest धर्म', it uses one of the deepest and "
          "least translatable words in Sanskrit. धर्म is not simply 'religion'; it spans duty, righteousness, "
          "natural law, and the right way of living suited to one's role and stage of life. Classical thought sets "
          "it among the four पुरुषार्थ — the legitimate aims of a human life: धर्म (right conduct), अर्थ "
          "(prosperity), काम (well-directed desire), and मोक्ष (liberation) — with धर्म as the foundation that "
          "keeps the other three honest. The phrasing परमो धर्मः ('the supreme duty') echoes a famous Mahābhārata "
          "line, अहिंसा परमो धर्मः ('non-violence is the highest duty'). By slotting सेवा into that exalted frame, "
          "the chapter argues that selfless service ranks among life's loftiest goals — an idea Gandhi made central "
          "to modern India. Understanding धर्म's range turns a simple sentence into a window on Indian ethics.",
          "Tackle this once you understand सेवा परमो धर्मः as 'service is the highest duty'.",
          "In later classes you study the four पुरुषार्थ and how धर्म is understood across the epics and dharmaśāstra."),
        t("sch05_dd02", "यन्त्रवत् — the वति suffix that means 'just like'",
          "class_8", "sch05_t01_c04",
          "The physician serves यन्त्रवत् — 'like a machine', tirelessly. That handy -वत् ending is the वति (vati) "
          "suffix, which turns a noun into an adverb meaning 'like / in the manner of'. So पुत्रवत् पालयति means "
          "'(he) protects like a son', and राजवत् वर्तते means '(he) behaves like a king'. Pāṇini's rule तेन "
          "तुल्यं क्रिया चेद्वतिः captures it: when an action is COMPARABLE to something, attach -वत्. Be careful "
          "though — -वत् wears two hats. As the वति suffix it means 'like' (यन्त्रवत् = 'like a machine'); but the "
          "very similar मतुप्/-वत् possessive suffix means 'having' (धनवत् = 'having wealth, rich'). Context tells "
          "them apart: an adverb of comparison versus an adjective of possession. Mastering the वति suffix lets "
          "you build crisp similes in a single word, exactly the kind of compression that makes Sanskrit so "
          "economical and expressive.",
          "Tackle this once you read यन्त्रवत् as 'like a machine'.",
          "In Class 9 you study the तद्धित suffixes and learn to distinguish the comparison -वत् (वति) from the possessive -वत् (मतुप्)."),
        t("sch05_dd03", "कषायम् and the Sanskrit roots of आयुर्वेद",
          "class_10", "sch05_t02_c03",
          "The serving physician prepares a कषायम् — a herbal decoction — and that single word opens the door to "
          "आयुर्वेद, India's classical 'science of life' (आयुस् = life, वेद = knowledge). Its foundational texts "
          "are in Sanskrit: the चरकसंहिता on internal medicine, the सुश्रुतसंहिता famed for surgery, and the "
          "अष्टाङ्गहृदय. Āyurveda explains health through the balance of three दोष — वात, पित्त and कफ — and treats "
          "imbalance with diet, lifestyle, and plant-based preparations of which the कषाय (a simmered herbal "
          "extract) is one classic form, alongside चूर्ण (powders) and अरिष्ट (fermented tonics). Because the "
          "entire pharmacopoeia is named in Sanskrit, reading even a recipe is a Sanskrit exercise. The chapter's "
          "doctor, who chooses tireless service over चasing degrees and posts, embodies the आयुर्वेदिक ideal of "
          "the वैद्य whose first duty is the patient — making कषायम् far more than a vocabulary word.",
          "Tackle this once you know कषायम् is a herbal decoction the physician prepares.",
          "In later study you encounter the Sanskrit medical classics (चरक, सुश्रुत) and the vocabulary of आयुर्वेद."),
    ],
    "sch06": [
        t("sch06_dd01", "अक्षरम् — the syllable, the true building block of Sanskrit sound",
          "class_8", "sch06_t01_c01",
          "श्लोकान्त्याक्षरी works by a simple rule: the next verse must begin with the LAST अक्षर (syllable) of "
          "the one before. That makes the अक्षर — not the letter — the real unit of spoken Sanskrit. An अक्षर is "
          "one vowel together with any consonants that lean on it: न-मः is two syllables, but स्व-स्ति shows how a "
          "cluster (स्व) still forms a single beat around its vowel. This is why Sanskrit is written and counted by "
          "syllable, and why a 'conjunct' consonant (संयुक्ताक्षर) like क्ष or ज्ञ is one written sign. The whole "
          "game of antyākṣarī trains your ear to hear where one syllable ends and the next begins — exactly the "
          "skill prosody and recitation depend on. Once you think in अक्षर rather than separate letters, splitting "
          "words for sandhi, counting metres, and reciting cleanly all become far easier, because you are hearing "
          "Sanskrit the way it is actually built.",
          "Tackle this once you can find the last syllable of a śloka to start the next.",
          "In Class 9 you use the अक्षर as the counting unit when you study प्रोसody (छन्दस्) and sandhi."),
        t("sch06_dd02", "विद्या in the subhāṣitas — knowledge as the only lasting wealth",
          "class_9", "sch06_t01_c02",
          "विद्याहीना न शोभन्ते — 'those without knowledge do not shine' — belongs to a whole family of Sanskrit "
          "verses that exalt विद्या (learning) above every other possession. The full subhāṣita compares the "
          "beautiful-but-ignorant to किंशुक flowers: gorgeous to look at, yet scentless. Bhartṛhari's नीतिशतक "
          "returns to this again and again — विद्या is the wealth thieves cannot steal, that grows when spent, and "
          "that earns respect in every land (विद्या नाम नरस्य रूपमधिकम्). The same idea drives the famous "
          "definition सा विद्या या विमुक्तये, 'that is true knowledge which liberates'. These verses are not just "
          "moral cheerleading; they encode a civilisation's value-system, where the scholar outranked the rich. "
          "Reading them alongside your antyākṣarī shlokas shows you that the verses you play with are drawn from a "
          "deep, coherent tradition of thought about what makes a human life worthwhile — and why your own "
          "schooling sits at its centre.",
          "Tackle this once you can recite विद्याहीना न शोभन्ते and grasp its meaning.",
          "In later classes you read more of Bhartṛhari's नीतिशतक on the supremacy of विद्या (knowledge)."),
        t("sch06_dd03", "यशस्विनी — the -विन् suffix that means 'rich in'",
          "class_10", "sch06_t02_c04",
          "यशस्विनी means 'she who is full of fame', from यशस् (fame) + the possessive suffix -विन् (with its "
          "feminine -विनी). This -विन् belongs to the same possessive family as -मत्/-वत्: all of them turn a "
          "quality-noun into an adjective meaning 'possessing that quality'. So तेजस् (radiance) gives तेजस्विन् "
          "(radiant, full of energy), and मेधा (intellect) gives मेधाविन् (intelligent). Sanskrit also loves to "
          "PERSONIFY abstract qualities as goddesses — लक्ष्मीः is not just 'wealth' but Wealth herself, who, the "
          "verse warns, behaves very differently in wicked hands (खलः) than in good ones. Notice how grammar and "
          "imagery cooperate: the feminine -विनी ending and the goddess-personification together let a poet treat "
          "fame, fortune and learning as living women who choose whom to favour. Spotting the -विन्/-मत् suffix "
          "lets you unlock dozens of 'rich-in-X' words, and seeing the personification lets you read the poetry "
          "behind them.",
          "Tackle this once you can read यशस्विनी as 'full of fame'.",
          "In later classes you study the possessive suffixes (मतुप्, विनिप्) and the poetic personification of abstract nouns."),
    ],
    "sch07": [
        t("sch07_dd01", "ईशावास्यम् — your first verse of the Upaniṣads",
          "class_10", "sch07_t01_c01",
          "ईशावास्यमिदं सर्वम् is the opening line of the ईशोपनिषद् (Īśopaniṣad), one of the ten principal "
          "Upaniṣads and part of the शुक्लयजुर्वेद. The Upaniṣads are the philosophical summit of the Vedas — the "
          "वेदान्त, 'the end of the Veda' — where the focus turns from ritual to the nature of reality and the "
          "self. This short text of just 18 verses delivers one of India's most quoted ethical teachings in its "
          "very next words: तेन त्यक्तेन भुञ्जीथाः, 'enjoy through renunciation' — take what you need, claim "
          "nothing as ultimately yours, since the Lord pervades all. Gandhi said that if every other scripture "
          "were lost but this one verse survived, Hinduism would live on. Meeting ईशावास्यम् in Class 7 means you "
          "have already touched the headwaters of Indian philosophy; the words you recite are studied by scholars "
          "and saints alike as a complete worldview compressed into a single line.",
          "Tackle this once you understand ईशावास्यमिदं सर्वम् as 'all this is pervaded by the Lord'.",
          "In senior classes you study the principal Upaniṣads as the वेदान्त, the philosophical core of the Vedas."),
        t("sch07_dd02", "दास्यन्ति — how Sanskrit builds the future tense (लृट्)",
          "class_8", "sch07_t02_c02",
          "दास्यन्ति means 'they SHALL give', and that future meaning lives in a single inserted piece: the marker "
          "-स्य- (technically the लृट् लकार, simple future). Take the root दा ('give'); add -स्य- and the personal "
          "endings, and you get दास्यति (he will give), दास्यतः (those two will give), दास्यन्ति (they will give). "
          "The same recipe works across roots: from पठ् you get पठिष्यति (he will read), from गम् → गमिष्यति (he "
          "will go) — the tell-tale -ष्य/-स्य announcing 'future' every time. This contrasts neatly with the "
          "present (लट्, पठति 'he reads') and the past you meet elsewhere. Sanskrit thus marks WHEN an action "
          "happens by changing the verb's middle, not by adding a separate word like English 'will'. Once you can "
          "hear the -स्य- inside दास्यन्ति, you can both recognise and form the future of almost any verb — a huge "
          "step up from memorising whole conjugation tables.",
          "Tackle this once you can read दास्यन्ति as the future 'they shall give'.",
          "In Class 8 you learn the लृट् (future) of common roots and contrast it with the present and imperfect tenses."),
        t("sch07_dd03", "सर्वशक्तिमान् and the vision of अद्वैत वेदान्त",
          "class_11", "sch07_t01_c02",
          "Saying God is सर्वशक्तिमान् (all-powerful) and pervades everything points straight at the boldest idea "
          "in Indian philosophy: अद्वैत (non-dualism), most famously expounded by आदि शङ्कराचार्य around 700 CE. "
          "Advaita holds that the ultimate reality, ब्रह्मन्, is one without a second, and that the individual self "
          "(आत्मन्) is not separate from it — the great Upaniṣadic sentences (महावाक्य) declare अहं ब्रह्मास्मि ('I "
          "am Brahman') and तत्त्वमसि ('That thou art'). Because ब्रह्मन् is beyond all description, the seers point "
          "to it by negation — नेति नेति, 'not this, not this' — peeling away everything finite until only the "
          "infinite remains. The chapter's gentle phrase 'God pervades all' is the doorway to this entire system, "
          "elaborated in Śaṅkara's commentaries (भाष्य) on the Upaniṣads, the Gītā and the Brahmasūtras. To grasp "
          "सर्वशक्तिमान् fully is to begin asking the question वेदान्त exists to answer: what is real, and who am I?",
          "Tackle this once you understand the chapter's idea that one all-powerful Lord pervades everything.",
          "In senior classes you study अद्वैत वेदान्त, Śaṅkara's commentaries, and the महावाक्य of the Upaniṣads."),
    ],
    "sch08": [
        t("sch08_dd01", "सूक्तिः and the Sanskrit reverence for वाक् (speech)",
          "class_9", "sch08_t02_c01",
          "A सूक्तिः ('well-said thing', su + ukti) is a close cousin of the सुभाषितम्, and the chapter's theme — "
          "that speech should be both हितम् (beneficial) AND मनोहारि (pleasing) — reflects a civilisation that "
          "treated वाक् (speech) as sacred. In the Veda, वाक् is a goddess (वाग्देवी, identified with सरस्वती), and "
          "the grammarian-philosopher Bhartṛhari built a whole philosophy of language around the idea that "
          "ultimate reality is शब्दब्रह्मन्, 'reality as the Word'. His Vākyapadīya describes four levels of "
          "speech — परा (the unmanifest), पश्यन्ती (the visionary), मध्यमा (the mental), and वैखरी (the spoken) — "
          "through which a thought descends into audible sound. Against that backdrop, the demand that speech be "
          "useful, true, AND beautiful is not mere politeness; it treats every word as carrying real power. The "
          "subhāṣita सत्यं ब्रूयात् प्रियं ब्रूयात् ('speak the truth, speak it kindly') states the same ideal. "
          "Sanskrit literature returns endlessly to the ethics of how we speak.",
          "Tackle this once you grasp that good speech is both useful (हितम्) and pleasing (मनोहारि).",
          "In senior study you meet Bhartṛhari's philosophy of language and the Sanskrit tradition that treats वाक् (speech) as sacred."),
        t("sch08_dd02", "क्षणशः कणशः — the शस् suffix for 'bit by bit'",
          "class_8", "sch08_t01_c02",
          "क्षणशः कणशः — 'moment by moment, particle by particle' — teaches both a life-lesson (learning and wealth "
          "accumulate gradually) and a neat grammar point. The -शः ending is the शस् (śas) suffix, which attaches "
          "to a noun to mean 'one by one' or 'in units of', a sense Sanskrit grammar calls वीप्सा (distributive "
          "repetition). So शतशः means 'by the hundreds', सहस्रशः 'by the thousands', एकशः 'one at a time', and "
          "अंशशः 'portion by portion'. Like the -तः (तसिल्) adverbs you met earlier, a -शः word is indeclinable: "
          "it never changes its form. The pairing क्षणशः कणशः is also a piece of poetic craft — two -शः adverbs "
          "echoing each other to drive the 'little by little' idea home through sound as well as sense. Recognising "
          "the शस् suffix lets you instantly read any 'X by X' adverb, and shows you how Sanskrit packs a whole "
          "English phrase ('particle by particle') into one tidy word.",
          "Tackle this once you can read क्षणशः कणशः as 'moment by moment, particle by particle'.",
          "In Class 9 you study the distributive (वीप्सा) suffix शस् and other adverb-forming तद्धित endings."),
        t("sch08_dd03", "क्रियावान् — being a person 'of action', and the matup suffix",
          "class_10", "sch08_t01_c04",
          "The subhāṣitas praise the क्रियावान् — the 'one possessing action', the doer — and warn against mere "
          "विकत्थनम् (boasting). Grammatically क्रियावान् is क्रिया (action) + the possessive suffix -मत्/-वत् "
          "(मतुप्), which means 'having' or 'rich in'. The same suffix builds बुद्धिमान् (having intelligence, "
          "wise), बलवान् (having strength, strong), धनवान् (having wealth, rich) and भगवान् (the possessor of all "
          "glories). A spelling rule decides the shape: roots and words with certain sounds take -वत् (भगवत्), "
          "others -मत् (श्रीमत्). The lesson and the grammar reinforce each other — to be called क्रियावान् you "
          "must actually POSSESS deeds, just as धनवान् must possess wealth; you cannot become either by talking. "
          "This is the same possessive family as the -विन् in यशस्विन्, so once you know मतुप्, a huge set of "
          "'having-X' adjectives opens up. Sanskrit lets one suffix turn almost any noun into 'the one who has "
          "it'.",
          "Tackle this once you grasp क्रियावान् as 'one of action' versus the boaster.",
          "In later classes you study the मतुप्/वतुप् possessive suffixes that build बुद्धिमान्, बलवान् and भगवान्."),
    ],
    "sch09": [
        t("sch09_dd01", "अन्नाद् भवन्ति भूतानि — a verse straight from the Bhagavad Gītā",
          "class_10", "sch09_t01_c01",
          "The chapter's title is verse 3.14 of the भगवद्गीता, and the Gītā states it as one link in a great cycle: "
          "अन्नाद्भवन्ति भूतानि (from food, beings arise), पर्जन्यादन्नसम्भवः (food from rain), यज्ञाद्भवति "
          "पर्जन्यः (rain from sacrifice), यज्ञः कर्मसमुद्भवः (sacrifice from action). Beings → food → rain → "
          "यज्ञ → action → beings: a wheel (चक्र) that keeps the world turning, where each part owes its existence "
          "to the next. The Gītā's point is ethical as much as ecological — one who takes from this cycle without "
          "giving back, the next verse says, 'lives in vain'. The Gītā itself is 700 verses set within the "
          "Mahābhārata, Krishna's counsel to Arjuna on duty, action and devotion, and among the most translated "
          "books on Earth. Meeting one of its verses in Class 7 means the simple words 'from food, beings come to "
          "be' carry, in their home text, a whole philosophy of interdependence and selfless action (कर्मयोग).",
          "Tackle this once you understand the food-rain-sacrifice cycle the verse describes.",
          "In senior classes you study the भगवद्गीता's teaching of कर्मयोग and the यज्ञ-cycle of which this verse is a part."),
        t("sch09_dd02", "जानीयात् — the optative (विधिलिङ्) for 'one should'",
          "class_8", "sch09_t01_c04",
          "जानीयात् means '(one) SHOULD know', and that flavour of advice, duty or possibility lives in a special "
          "mood called the विधिलिङ् (optative or potential). Where the present tense जानाति simply reports 'he "
          "knows', the optative जानीयात् prescribes 'he ought to know / let him know'. Sanskrit uses this mood "
          "constantly for rules and good counsel: सत्यं वदेत् ('one should speak the truth'), धर्मं चरेत् ('one "
          "should practise dharma'), न हिंस्यात् सर्वभूतानि ('one should not harm any creature'). The tell-tale "
          "marker is the -ई-/-या- that slips in before the ending (भवति → भवेत्, पठति → पठेत्). Because so much "
          "Sanskrit literature — dharmaśāstra, subhāṣitas, instructions of every kind — is phrased as 'one "
          "should', the optative is one of the most useful moods to recognise. Once you spot the विधिलिङ्, you can "
          "tell a command or recommendation apart from a plain statement of fact at a glance.",
          "Tackle this once you can read जानीयात् as 'one should know'.",
          "In Class 8 you learn the विधिलिङ् (optative) of common roots and use it to express 'should / ought'."),
        t("sch09_dd03", "रसायनशास्त्रम् — how Sanskrit coins words for modern science",
          "class_9", "sch09_t01_c03",
          "The chapter's 'modern touch' word रसायनशास्त्रम् (chemistry) shows a living power of Sanskrit: building "
          "precise new technical terms from old roots, the way English reaches for Greek and Latin. रसायन (rasa, "
          "'fluid/essence' + ayana, 'course') was the alchemy-and-elixir branch of आयुर्वेद, and शास्त्रम् means "
          "'science/discipline', so the compound neatly names the science of substances. The same method generates "
          "a whole modern vocabulary: दूरभाषः (telephone, 'far-speech'), संगणकः (computer, 'the calculator'), "
          "विद्युत् (electricity), आकाशवाणी (radio, 'voice from the sky'), and दूरदर्शनम् (television, 'far-"
          "seeing'). Because Sanskrit words are transparent — each part means something — a coined term often "
          "explains itself. This is why Sanskrit has been proposed as a clear, unambiguous language for "
          "terminology, and why scientific Hindi borrows its vocabulary wholesale from Sanskrit roots. Seeing "
          "रसायनशास्त्रम् taken apart teaches you that you can often GUESS a Sanskrit technical word's meaning from "
          "its pieces.",
          "Tackle this once you know रसायनशास्त्रम् means 'chemistry'.",
          "In later study you see how Sanskrit roots and compounds supply the technical vocabulary of modern Indian science."),
    ],
    "sch10": [
        t("sch10_dd01", "'You are the tenth' — the parable as a Vedānta teaching",
          "class_10", "sch10_t01_c01",
          "Ten boys cross a river, each counts the others, finds only nine, and grieves for a lost companion — "
          "until a wise passer-by points and says दशमस्त्वमसि: 'YOU are the tenth.' Vedānta teachers have told "
          "this story for centuries because it is a perfect image of the central Upaniṣadic insight. The counter "
          "overlooks the very self that is doing the counting, exactly as a person searches everywhere for "
          "happiness and meaning while overlooking their own true Self (आत्मन्). The teacher's words echo the "
          "महावाक्य तत्त्वमसि ('That thou art') from the छान्दोग्योपनिषद् — the truth was never missing, only "
          "unrecognised. Vidyāraṇya's पञ्चदशी uses precisely this 'tenth man' (दशम) example to explain how "
          "self-knowledge is not the GAINING of something new but the removal of an error. So the charming "
          "children's puzzle in your textbook is also one of the most elegant teaching-stories in Indian "
          "philosophy: what you seek, you already are.",
          "Tackle this once you can retell the parable and its surprise — the counter forgot himself.",
          "In senior study you meet तत्त्वमसि and the Vedāntic use of the 'tenth man' parable to teach self-knowledge."),
        t("sch10_dd02", "तीर्त्वा — the क्त्वा gerund for 'having done X'",
          "class_8", "sch10_t02_c02",
          "तीर्त्वा means 'having crossed/swum across', and that '-ing first, then…' sense comes from the क्त्वा "
          "(ktvā) suffix, the Sanskrit gerund or absolutive. It marks the EARLIER of two actions by the same "
          "doer: स्नात्वा भुङ्क्ते means 'having bathed, he eats' (i.e. he bathes, THEN eats); पठित्वा गच्छति, "
          "'having studied, he goes'. The ending appears as -त्वा (गत्वा 'having gone', कृत्वा 'having done', "
          "दृष्ट्वा 'having seen'). There is one important twist: when the verb carries a prefix (उपसर्ग), the "
          "क्त्वा changes to -य, the ल्यप् form — so from आ + गम् you get आगत्य ('having come'), and from वि + हस् "
          "you get विहस्य ('having laughed'). The gerund lets Sanskrit chain a sequence of actions tidily without "
          "repeating 'and then'. Recognising तीर्त्वा as 'having crossed' is your key to reading narrative "
          "Sanskrit, where these -त्वा / -य forms string the events of a story together.",
          "Tackle this once you can read तीर्त्वा as 'having swum across'.",
          "In Class 8 you study the क्त्वा (gerund) and its prefixed form ल्यप् (-य) to link successive actions."),
        t("sch10_dd03", "अगणयत् — the imperfect past (लङ्) and its tell-tale अ-",
          "class_9", "sch10_t02_c03",
          "अगणयत् means 'he counted', a past-tense form, and the clue to its pastness sits right at the front: the "
          "little अ- prefix called the अट् augment (आगम). Sanskrit's everyday past tense is the लङ् लकार "
          "(imperfect), and it is built by putting अ- before the stem and adding past endings — so the present "
          "गणयति ('he counts') becomes अगणयत् ('he counted'), पठति → अपठत्, भवति → अभवत्, गच्छति → अगच्छत्. That "
          "leading अ- is the single most reliable signpost of the imperfect: see a verb beginning with अ that "
          "is not part of the root, and you are almost certainly looking at a past action. (Sanskrit actually has "
          "three past tenses — लङ् imperfect, लिट् perfect, लुङ् aorist — but the अ-augmented लङ् is the one "
          "stories use most.) Once you can strip the अट् augment off अगणयत् to find the familiar present stem, "
          "reading past-tense narrative becomes far easier.",
          "Tackle this once you can read अगणयत् as the past 'he counted'.",
          "In Class 9 you learn the लङ् (imperfect) with its अ-augment and contrast it with the present and future."),
    ],
    "sch11": [
        t("sch11_dd01", "कालापानी — the Cellular Jail and the freedom struggle",
          "class_9", "sch11_t01_c02",
          "The सेल्युलर कारागारम् (Cellular Jail) at Port Blair, dreaded as कालापानी ('the black water'), is one of "
          "the most sombre sites in India's freedom story. Built by the British and completed in 1906, its name "
          "comes from its design: seven wings of tiny solitary CELLS radiating from a central tower, so prisoners "
          "could neither see nor speak to one another. To this remote island the colonial government "
          "'transported' revolutionaries — sentence to कालापानी meant exile across the sea, cut off from family "
          "and homeland, doing brutal labour like pressing oil at the kolhu. Among those imprisoned here was वीर "
          "सावरकर, who served years in its cells. After independence the jail became a national memorial; its "
          "walls carry the names of freedom fighters who endured it. So when your chapter tours the beautiful "
          "Andamans, it also asks you to remember their darker history — and the word त्रितलात्मकम् "
          "('three-storied') in the lesson literally describes the jail's grim architecture.",
          "Tackle this once you know सेल्युलर कारागारम् / कालापानी refers to the Andaman prison.",
          "In later classes you study the history of the freedom struggle and the role of revolutionaries transported to the Andamans."),
        t("sch11_dd02", "सोढवान् — the past active participle (क्तवतु)",
          "class_8", "sch11_t02_c03",
          "सोढवान् means 'he (has) borne / endured', and it is not a finite verb but a past active participle, "
          "formed with the क्तवतु (-तवत्) suffix. This participle turns a verb into an adjective meaning 'one who "
          "has done X', agreeing in gender and number with its subject: from कृ ('do') comes कृतवान् ('he who has "
          "done'), कृतवती ('she who has done'); from गम् comes गतवान् ('he who has gone'). It pairs with its "
          "passive twin, the क्त (-त) past PASSIVE participle — कृतम् ('done'), गतः ('gone') — so Sanskrit can "
          "say either 'the boy who has eaten' (बालकः खादितवान्) or 'the food that was eaten' (अन्नं खादितम्). "
          "These participles let you express past actions compactly, often standing in for a full past-tense verb. "
          "Spotting the -तवत् ending in सोढवान् tells you instantly that someone HAS COMPLETED an action — here, "
          "the heroic endurance the chapter celebrates in those who suffered at the Cellular Jail.",
          "Tackle this once you can read सोढवान् as 'he bore / endured'.",
          "In Class 8 you study the क्त and क्तवतु past participles (passive and active) and use them for past actions."),
        t("sch11_dd03", "प्रवालप्रस्तरैः — the instrumental plural and a descriptive compound",
          "class_10", "sch11_t02_c01",
          "प्रवालप्रस्तरैः ('with coral reefs') does two grammatical jobs at once. First, the -ऐः ending is the "
          "तृतीया (instrumental) PLURAL — the case that means 'by / with / by means of', here describing what the "
          "islands are adorned WITH. The instrumental is the workhorse for instruments and accompaniment (लेखन्या "
          "लिखति, 'he writes with a pen') and is governed by words like सह ('along with'). Second, "
          "प्रवालप्रस्तर is itself a compound: प्रवाल (coral) + प्रस्तर (rock/slab) = 'coral-rock', a कर्मधारय/"
          "तत्पुरुष joining the two nouns into one. So a single inflected word, प्रवालप्रस्तरैः, carries 'with "
          "[the] coral-rocks' — noun, adjective and preposition all folded together. Sanskrit's case endings make "
          "this possible: because -ऐः already says 'with, plural', no separate word for 'with' is needed. "
          "Unpacking प्रवालप्रस्तरैः into its compound and its case is exactly the two-step reading that long "
          "Sanskrit words always reward.",
          "Tackle this once you can read प्रवालप्रस्तरैः as 'with coral reefs'.",
          "In Class 9 and 10 you study the seven cases in full, including the तृतीया (instrumental) and its uses."),
    ],
    "sch12": [
        t("sch12_dd01", "Panna Dhai and the history of Mewar",
          "class_9", "sch12_t01_c01",
          "पन्नाधाया (Panna Dhai) was the wet-nurse and guardian of the infant prince उदयसिंह of मेवाड (Mewar) in "
          "the 16th century. When the usurper Banbir killed the reigning king and came to murder the child heir, "
          "Panna Dhai made the most terrible choice a mother could face: she placed her own son Chandan in the "
          "prince's bed to be slain in his stead, and smuggled उदयसिंह to safety in a fruit-basket. The prince she "
          "saved grew up to found the city of Udaipur, and his son was महाराणा प्रताप, Mewar's legendary defender "
          "against Akbar. Mewar's ruling house, the Sisodia Rajputs of Chittor, prized loyalty and sacrifice above "
          "life itself, and Panna Dhai's देed became its supreme example — which is why the chapter says her name "
          "is written स्वर्णिमाक्षरैः, 'in golden letters'. Knowing the Mewar setting turns a moving story into a "
          "real episode of Rajput history, with consequences that shaped a dynasty.",
          "Tackle this once you know Panna Dhai sacrificed her own son to save prince Udai Singh.",
          "In later classes you study the history of Mewar, Chittor, and Maharana Pratap's resistance to the Mughals."),
        t("sch12_dd02", "मारयितुम् — the infinitive of purpose, and the causative",
          "class_8", "sch12_t02_c03",
          "मारयितुम् means 'in order to KILL (cause to die)', and it shows two grammar tools at once. The -तुम् "
          "ending is the तुमुन् suffix, the infinitive that expresses PURPOSE — 'to / in order to' — and it pairs "
          "with verbs of wishing and going: पठितुं गच्छति ('he goes [in order] to study'), द्रष्टुम् इच्छति ('he "
          "wishes to see'). Underneath, मारयति itself is a CAUSATIVE: from the root मृ ('to die') Sanskrit builds "
          "मारयति, 'causes to die = kills', by inserting the णिच् (-अय-) marker. The causative turns 'X happens' "
          "into 'someone MAKES X happen': पठति ('he reads') → पाठयति ('he makes [someone] read = teaches'); भवति "
          "('it is') → भावयति ('he brings into being'). So मारयितुम् literally stacks 'to' + 'cause-to-die'. "
          "Recognising the तुमुन् infinitive lets you read every 'in order to' clause, and spotting the causative "
          "-अय- explains a whole class of 'make-someone-do' verbs.",
          "Tackle this once you can read मारयितुम् as 'in order to kill'.",
          "In Class 8 and 9 you study the तुमुन् (infinitive of purpose) and the णिच् causative formation."),
        t("sch12_dd03", "षोडशे शतके — Sanskrit ordinals and the locative of time",
          "class_10", "sch12_t01_c03",
          "षोडशे शतके means 'in the sixteenth century', and it teaches how Sanskrit expresses both NUMBER and "
          "TIME. षोडश ('sixteen') is itself a compound — षट् (six) + दश (ten) — and its ordinal षोडश ('sixteenth') "
          "patterns with प्रथम, द्वितीय, तृतीय … which you met counting the ten boys. The ending -ए on both words "
          "is the सप्तमी (locative) singular, the case meaning 'in / on / at'. Sanskrit uses this same locative "
          "for time: the locative answers 'WHEN?' just as it answers 'where?' — so 'in the sixteenth century' and "
          "'in the village' (ग्रामे) take the identical ending. The agreement is exact: both adjective (षोडशे) and "
          "noun (शतके) carry locative -ए because they describe one thing together. This is the famous 'locative of "
          "time' (कालाधिकरण). Once you see that -ए can mark a point in time as readily as a place, dates and "
          "settings in Sanskrit prose stop being mysterious.",
          "Tackle this once you can read षोडशे शतके as 'in the sixteenth century'.",
          "In later classes you study the सप्तमी (locative) of time and place and the formation of Sanskrit ordinals."),
    ],
    "sch13": [
        t("sch13_dd01", "मात्रा — vowel-length as the foundation of Sanskrit metre",
          "class_9", "sch13_t01_c01",
          "वर्णमात्रा — the duration of a vowel — is not a dry phonetics fact; it is the raw material of all "
          "Sanskrit poetry. Once you can hear that अ is ह्रस्व (short, one मात्रा) and आ is दीर्घ (long, two "
          "मात्रास), you are ready for छन्दस् (prosody), the science of metre. In a verse every syllable counts as "
          "either लघु (light) or गुरु (heavy): a syllable is heavy if its vowel is long, OR if a short vowel is "
          "followed by a conjunct consonant or an अनुस्वार/विसर्ग. Poets arrange these light and heavy beats into "
          "fixed patterns — the अनुष्टुप् counts syllables, while metres like इन्द्रवज्रा and मन्दाक्रान्ता fix "
          "the exact लघु-गुरु sequence of every line. Classical handbooks even group beats into गण (triplets, each "
          "with its own name) to make scanning easy. So the simple ह्रस्व-दीर्घ distinction you learn here is the "
          "seed from which the entire, beautiful machinery of Sanskrit verse grows.",
          "Tackle this once you can tell a ह्रस्व (short) vowel from a दीर्घ (long) one.",
          "In later classes you study छन्दस् (metre), scanning verses into लघु and गुरु syllables and identifying common metres."),
        t("sch13_dd02", "प्लुत — the rare 'extra-long' vowel of calling and song",
          "class_8", "sch13_t01_c02",
          "Among the three vowel-quantities, ह्रस्व (1 मात्रा) and दीर्घ (2 मात्रास) are everyday, but the third — "
          "प्लुत, the 'protracted' vowel of THREE मात्रास — is a fascinating special case. प्लुत is used when a "
          "vowel is deliberately drawn out, above all in CALLING someone from a distance: हे राऽऽम (written with "
          "the figure ३ to mark it, राम३) stretches the आ to summon attention across a field. It also appears in "
          "questions shouted back, in expressions of grief or surprise, and especially in Vedic chanting (सामवेद), "
          "where syllables are extended to fit a melody. The rooster's crow कुक्कुटः रौति in your chapter is a "
          "playful, everyday illustration of a sound held long. Most Indian languages kept only short and long "
          "vowels, so प्लुत is a distinctive survival that shows how finely Sanskrit measured spoken sound — down "
          "to a third length used for the human act of calling out.",
          "Tackle this once you know the three names ह्रस्व, दीर्घ and प्लुत.",
          "In Vedic study you meet प्लुत vowels in chanting and learn how they are marked and pronounced."),
        t("sch13_dd03", "शिक्षा — the Vedāṅga of phonetics behind Sanskrit's perfect sounds",
          "class_10", "sch13_t01_c04",
          "Classifying vowels into types (भेद) and sub-types (उपभेद) by their length is a small piece of शिक्षा, "
          "the science of phonetics — and शिक्षा is one of the six वेदाङ्ग, the auxiliary disciplines developed to "
          "preserve the Vedas perfectly. Ancient Indian phoneticians achieved an astonishingly precise map of "
          "speech: every sound is classified by its place of articulation (स्थान — throat कण्ठ्य, palate तालव्य, "
          "lips ओष्ठ्य…) and its effort/manner (प्रयत्न), which is exactly why the Sanskrit alphabet is laid out "
          "in a scientific grid rather than an arbitrary ABC order. Pāṇini's grammar opens with the माहेश्वरसूत्राणि "
          "(Śiva Sūtras), fourteen lines that ingeniously encode the whole sound-system so rules can refer to "
          "groups of letters at once. This phonetic rigour is why Sanskrit was transmitted orally, unchanged, for "
          "thousands of years. The vowel-quantities you study here are one cell in that vast, meticulous map of "
          "how the human voice makes meaning.",
          "Tackle this once you can sort vowels by their भेद (type) and उपभेद (sub-type).",
          "In senior study you meet the six वेदाङ्ग and how शिक्षा classifies sounds by place (स्थान) and manner (प्रयत्न) of articulation."),
    ],
    "sch14": [
        t("sch14_dd01", "कारक theory — how seven cases map to six relations",
          "class_9", "sch14_t01_c01",
          "The सप्तविभक्तयः (seven cases) are the ENDINGS, but Sanskrit grammar explains them through a deeper "
          "layer of MEANING called the कारक — the six roles a noun can play in relation to the action of a verb. "
          "Pāṇini defines them: कर्तृ (the doer → usually प्रथमा/nominative), कर्म (the thing acted on → "
          "द्वितीया/accusative), करण (the instrument 'by which' → तृतीया), सम्प्रदान (the recipient 'for whom' → "
          "चतुर्थी), अपादान (the source 'from which' → पञ्चमी), and अधिकरण (the locus 'in/on which' → सप्तमी). "
          "Notice the genitive (षष्ठी, 'of') is deliberately LEFT OUT of the कारक — because 'of' expresses a "
          "relation between two nouns, not between a noun and the verb's action. This separation of role (कारक) "
          "from ending (विभक्ति) is one of the great insights of Indian grammar, letting one ending serve several "
          "roles and one role take different endings. Learning the seven declension columns becomes far more "
          "logical once you see the six MEANINGS driving them.",
          "Tackle this once you can name the seven विभक्ति (cases) and what each broadly does.",
          "In Class 9 you study Pāṇini's कारक theory in depth, mapping each role to its case and its exceptions."),
        t("sch14_dd02", "Beyond अकारान्त — the other declension families and the dual",
          "class_8", "sch14_t01_c02",
          "देव (a masculine अकारान्त noun) is only one of many declension paradigms (शब्दरूप). Once you have देव by "
          "heart, the system opens up in two directions. By GENDER and ending: feminine nouns decline differently "
          "(आकारान्त रमा/लता, ईकारान्त नदी/मति), and so do neuters (फलम्, which has identical nominative and "
          "accusative — फलम् in both — a hallmark of neuter nouns). By the इ- and उ-ending masculines you already "
          "meet here (कवि, गुरु). The other great feature your three columns reveal is the द्विवचन — the DUAL "
          "number. Sanskrit counts in THREE numbers, not two: singular (एकवचन), dual (द्विवचन, for exactly two), "
          "and plural (बहुवचन, for three or more). So देवः / देवौ / देवाः means 'one god / two gods / many gods', "
          "each with its own endings throughout all seven cases. Mastering one paradigm gives you the template; "
          "the others are variations on the same seven-case, three-number grid.",
          "Tackle this once you can recite the देव (अकारान्त masculine) declension.",
          "In Class 8 and 9 you learn the feminine and neuter paradigms and use the dual (द्विवचन) confidently."),
        t("sch14_dd03", "सम्बोधनम् — calling someone, and the सुप् endings that attach",
          "class_10", "sch14_t02_c04",
          "The सम्बोधनम् (vocative) — हे देव! 'O god!' — is the form you use to ADDRESS or call someone, and "
          "Sanskrit grammar treats it as a special use of the प्रथमा (nominative): often it just shortens the "
          "nominative (देवः → हे देव), which is why declension tables list it beside the first case. All these "
          "case-endings — the marks that turn a bare stem like देव into देवः, देवम्, देवेन, देवाय … — are called "
          "the सुप् (sup) suffixes in Pāṇini's system: twenty-one endings (seven cases × three numbers) that the "
          "अष्टाध्यायी attaches by rule. A further wrinkle is that when words meet in a sentence, their final and "
          "initial sounds fuse by सन्धि (e.g. देवः + अत्र → देवोऽत्र), so reading real Sanskrit means UNDOING both "
          "the सन्धि and the सुप् ending to find the stem. Recognising the vocative and knowing that every ending "
          "is a सुप् suffix added to a stem is what lets you parse any inflected noun you meet.",
          "Tackle this once you can form the vocative (हे देव!) from the nominative.",
          "In senior study you meet Pāṇini's सुप् (case-ending) system and how सन्धि fuses words at their boundaries."),
    ],
    "sch15": [
        t("sch15_dd01", "The ten गण — why not all verbs conjugate like पठ्",
          "class_9", "sch15_t02_c01",
          "पठति ('he reads') looks simple, but it hides a choice: every Sanskrit root belongs to one of TEN classes "
          "called गण (gaṇa), and the class decides how the present-tense stem is built. पठ् is a भ्वादि (first "
          "class) root, which inserts -अ- before the ending (पठ् + अ + ति = पठति) — the largest and most regular "
          "group, named after भू ('to be', भवति). Other classes behave differently: the अदादि (second class, like "
          "अस् 'to be' → अस्ति) add endings DIRECTLY to the root with no vowel; the चुरादि (tenth class, like चुर् "
          "→ चोरयति) insert -अय-; the तुदादि, दिवादि, स्वादि and the rest each have their own stem-marker. This is "
          "why a conjugation table works for पठ्, नम्, गम् and वद् (all भ्वादि) but not blindly for अस् or कृ. "
          "Knowing a root's गण tells you in advance how to form its present, imperfect and imperative — turning "
          "what looks like memorising endless tables into applying ten predictable patterns.",
          "Tackle this once you can conjugate पठ् → पठति, पठतः, पठन्ति in the present.",
          "In Class 9 you learn that roots fall into ten गण (classes), each forming its present stem differently."),
        t("sch15_dd02", "The लकार system — Sanskrit's ten tense-moods",
          "class_10", "sch15_t01_c02",
          "Sanskrit organises ALL of a verb's tenses and moods into ten sets of endings called the लकाराः, each "
          "named with a code-letter ल् plus a marker. The five you most need are लट् (present — पठति, 'reads'), "
          "लङ् (imperfect past — अपठत्, 'read', with its अ-augment), लृट् (future — पठिष्यति, 'will read'), लोट् "
          "(imperative/command — पठतु, 'let him read'), and विधिलिङ् (optative — पठेत्, 'should read'). Beyond these "
          "lie the more advanced लकाराः you meet later: लिट् (the perfect, for remote past — पपाठ), लुङ् (the "
          "aorist), लुट् (a periphrastic future), आशीर्लिङ् (the benedictive, for blessings), and लृङ् (the "
          "conditional, 'would have'). Each लकार is simply a complete kit of personal endings expressing one "
          "time-or-mood. Once you realise that learning a verb means learning which लकार you need — present to "
          "report, लोट् to command, विधिलिङ् to advise — the whole verb system becomes a tidy menu of ten choices "
          "rather than a fog of forms.",
          "Tackle this once you know लट् (present) and have met a past and a future form.",
          "In Class 10 and beyond you study the full लकार system, adding the perfect, aorist, imperative and optative."),
        t("sch15_dd03", "परस्मैपद and आत्मनेपद — two families of verb endings",
          "class_8", "sch15_t01_c03",
          "Sanskrit verbs come in two voice-classes with DIFFERENT sets of personal endings: परस्मैपद (literally "
          "'word for another') and आत्मनेपद ('word for oneself'). पठति, गच्छति, करोति take परस्मैपद endings "
          "(-ति, -तः, -न्ति), while भाषते ('speaks'), लभते ('obtains') and सेवते ('serves') take आत्मनेपद endings "
          "(-ते, -एते, -न्ते) — which is exactly why your paradigm भाष् → भाषते, भाषेते, भाषन्ते looks so different "
          "from पठ् → पठति, पठतः, पठन्ति. Historically आत्मनेपद hinted that the action's fruit returns to the doer "
          "(reflexive/middle voice), though in practice each root simply 'belongs' to one set, or to both "
          "(उभयपदी). All these endings are the तिङ् (tiṅ) suffixes in Pāṇini's grammar — eighteen forms (nine "
          "परस्मैपद + nine आत्मनेपद across three persons and three numbers). Knowing whether a root is परस्मैपदी or "
          "आत्मनेपदी tells you which ending-set to reach for, so you never confuse भाषते with a nonexistent "
          "*भाषति.",
          "Tackle this once you notice भाषते uses different endings from पठति.",
          "In Class 8 and 9 you study परस्मैपद and आत्मनेपद endings (the तिङ् suffixes) and which roots take each."),
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
        if ch["id"] == "ch01":
            continue  # legacy vocabulary deck — documented carve-out, skipped
        items = DEEP_DIVE.get(ch["id"])
        if not items:
            raise SystemExit(f"No deepDive authored for {ch['id']}")
        if len(items) < 3:
            raise SystemExit(f"{ch['id']} has only {len(items)} deepDive items (<3)")
        for it in items:
            if it["id"] in seen_ids:
                raise SystemExit(f"Duplicate deepDive id {it['id']}")
            seen_ids.add(it["id"])
            parent = it["parentConceptId"]
            if parent not in chapter_concept_ids[ch["id"]]:
                raise SystemExit(f"{it['id']} parentConceptId {parent} not in {ch['id']}")
            wc = len(it["body"].split())
            if wc < 120:
                raise SystemExit(f"{it['id']} body only {wc} words (<120)")
        ch["deepDive"] = items
        total += len(items)

    PACK.write_text(json.dumps(pack, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(f"Injected {total} deepDive StretchTopics across the 15 NEP Sanskrit chapters (ch01 legacy deck skipped).")


if __name__ == "__main__":
    main()
