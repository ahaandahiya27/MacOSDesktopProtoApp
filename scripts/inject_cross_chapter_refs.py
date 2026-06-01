#!/usr/bin/env python3
"""Inject `crossChapterRefs` into the Maths and Sanskrit Class-7 packs.

v6 Learning Journey · Phase 1 · P1-F. Both packs shipped with ZERO
`crossChapterRefs`, which left the adaptive journey (Phase 3) unable to weave
each subject into a connected arc instead of N isolated chapters. This adds
exactly 4 outbound references per chapter (Maths ch01–ch15; Sanskrit NEP
sch01–sch15 — the legacy `ch01` vocabulary deck is the documented carve-out and
is skipped), each pointing to a REAL in-pack chapter with a hand-authored,
curricularly-accurate pointer and an anchoring source-concept id.

Re-runnable / idempotent: it rebuilds the `crossChapterRefs` array for each
mapped chapter from the table below (so editing a pointer here and re-running
updates the pack deterministically). Canonical JSON format preserved:
`json.dumps(d, ensure_ascii=False, indent=2) + "\n"` — byte-for-byte with
`verify_pack_roundtrip.py`.

Schema (CrossChapterRef.swift): id `{chapterId}_cx{NN}`, toChapterId, topic,
pointer, relatedConceptIds (≥1 real source-chapter concept id).
"""

import json
import sys
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
PACKS = REPO / "desktopAhaan" / "Subjects" / "Packs"

# Short, readable target-topic labels for the Sanskrit chapters (their raw
# titles carry Devanagari + transliteration + a parenthetical gloss, too long
# for a "Looking ahead" card). Maths topics are derived from the title in-pack.
SANSKRIT_TOPIC = {
    "sch01": "Vande Bharatamataram — the Motherland",
    "sch02": "Subhashitani — wise sayings",
    "sch03": "Mitraya Namah — the Sun Salutation",
    "sch04": "The Fox and the Grapes",
    "sch05": "Seva — service as the highest duty",
    "sch06": "Shloka Antyakshari",
    "sch07": "Ishavasyam — the all-pervading Lord",
    "sch08": "Useful and pleasing speech",
    "sch09": "Annad Bhavanti Bhutani — food and life",
    "sch10": "Dashamah Kah — Who is the Tenth?",
    "sch11": "The Andaman & the Cellular Jail",
    "sch12": "Panna Dhai, the Brave",
    "sch13": "Varna-Matra — vowel quantity",
    "sch14": "Shabda-Rupani — noun declension",
    "sch15": "Dhaturupani — verb conjugation",
}

# source chapter id -> list of (toChapterId, relatedConceptId, pointer)
# Each pointer is a 1–2 sentence, textbook-faithful explanation of the real
# curricular connection. relatedConceptId is a confirmed source-chapter concept.
MATHS = {
    "ch01": [
        ("ch03", "mch01_t02_c01", "Place value doesn't stop at the units column. Ch.3 extends the very same 10-times pattern the OTHER way — past the decimal point into tenths and hundredths."),
        ("ch10", "mch01_t01_c02", "Here every number is a counting number. Ch.10 mirrors the number line to the left of zero, so the values you read in lakhs and crores gain negative twins."),
        ("ch06", "mch01_t01_c01", "The Indian comma groups and the +1 'largest-to-smallest' pattern are number play in disguise. Ch.6 turns these patterns into puzzles and proofs."),
        ("ch12", "mch01_t02_c01", "Multiplying by 10, 100, 1000 just shifts each digit one place left. Ch.12 reuses that exact place-value shift to multiply and divide decimals."),
    ],
    "ch02": [
        ("ch04", "mch02_t01_c01", "An arithmetic expression uses only numbers. Ch.4 swaps some of those numbers for letters, so one expression can stand for a whole family of calculations."),
        ("ch15", "mch02_t01_c02", "'Different expressions, same value' is the seed of an equation. Ch.15 sets two expressions equal and hunts for the unknown that makes them balance."),
        ("ch10", "mch02_t02_c01", "Order of operations is a rule about WHICH operation first. Ch.10 stress-tests it once the numbers can be negative, where a misplaced sign flips the answer."),
        ("ch08", "mch02_t02_c03", "Terms and brackets group a calculation. Ch.8 applies the same grouping when the terms are fractions, where 'of' quietly means multiply."),
    ],
    "ch03": [
        ("ch12", "mch03_t03_c01", "Ch.3 builds decimal place value; Ch.12 puts it to work — multiplying and dividing decimals by counting decimal places and shifting the point."),
        ("ch08", "mch03_t01_c02", "A tenth IS the fraction 1/10. Ch.8 works fractions in general, and decimals are simply fractions whose denominators are powers of ten."),
        ("ch01", "mch03_t03_c01", "The decimal point is the mirror line of place value. Ch.1's lakhs sit to its left; Ch.3's tenths and hundredths sit to its right — one continuous system."),
        ("ch13", "mch03_t04_c01", "Locating decimals on a number line is the skill Ch.13 leans on when it plots and averages real measured data."),
    ],
    "ch04": [
        ("ch15", "mch04_t01_c01", "Letter-numbers describe a general relationship. Ch.15 pins the letter down to one value by solving an equation, turning the general into the specific."),
        ("ch02", "mch04_t01_c01", "Ch.4's algebraic expressions are exactly Ch.2's arithmetic expressions with letters in place of some numbers — the grammar of terms and brackets is identical."),
        ("ch06", "mch04_t03_c02", "Using a letter to express and justify a number pattern is the bridge from Ch.6's number play to a real algebraic proof that works for every case."),
        ("ch13", "mch04_t01_c02", "A formula is a relationship written with letters. Ch.13 uses one — the mean = sum ÷ count — to summarise a whole data set in a single number."),
    ],
    "ch05": [
        ("ch07", "mch05_t01_c02", "Vertically opposite angles and linear pairs are the angle facts Ch.7 builds on to prove that a triangle's three angles always sum to 180°."),
        ("ch07", "mch05_t03_c02", "When a transversal cuts two parallel lines, corresponding angles are equal. Ch.7 uses that very fact to reason about the angles inside triangles."),
        ("ch14", "mch05_t02_c01", "Perpendicular and parallel lines are defined here; Ch.14 teaches how to CONSTRUCT them precisely with only a compass and straightedge."),
        ("ch09", "mch05_t01_c01", "Equal angles are the heart of congruence. Ch.9 uses the angle relationships from intersecting lines to decide when two figures are exact copies."),
    ],
    "ch06": [
        ("ch11", "mch06_t02_c01", "Parity (even/odd) is the simplest split by a factor of 2. Ch.11 generalises 'shared factors' into HCF, LCM and prime factorisation."),
        ("ch10", "mch06_t02_c01", "Ch.6 proves things with even and odd; Ch.10 gives parity its sign rules, where the product of signs behaves much like the parity of a sum."),
        ("ch04", "mch06_t04_c01", "Cryptarithms put unknown digits behind letters. Ch.4 makes letters-as-numbers a deliberate tool for expressing and justifying patterns."),
        ("ch01", "mch06_t01_c02", "The number-grid sums and the 45-invariant are large-number patterns. Ch.1's place-value structure is what makes those patterns predictable."),
    ],
    "ch07": [
        ("ch05", "mch07_t01_c01", "A triangle is three intersecting lines. Every angle fact Ch.7 uses — linear pairs, vertically opposite, transversal angles — was established in Ch.5."),
        ("ch09", "mch07_t04_c01", "Ch.7 classifies and builds triangles; Ch.9 asks when two of them are identical, giving the SSS/SAS/ASA/RHS congruence tests."),
        ("ch14", "mch07_t03_c01", "Constructing a triangle from its sides here is the warm-up for Ch.14's precise compass-and-straightedge constructions and bisections."),
        ("ch05", "mch07_t02_c01", "The triangle inequality limits which three lengths can even meet. It is a direct consequence of how the intersecting lines of Ch.5 can close up."),
    ],
    "ch08": [
        ("ch03", "mch08_t02_c01", "A fraction and a decimal are two costumes for the same value. Ch.3 writes parts of a whole with a decimal point; Ch.8 writes them as numerator over denominator."),
        ("ch12", "mch08_t03_c01", "Dividing by a fraction means multiplying by its reciprocal. Ch.12 shows the decimal face of the same division, dividing by tenths and hundredths."),
        ("ch11", "mch08_t01_c01", "Adding or comparing fractions needs a common denominator — and the least one is the LCM that Ch.11 teaches you to find."),
        ("ch02", "mch08_t02_c01", "'of' means multiply, and order of operations still rules. Ch.2's expression grammar carries straight over once the terms become fractions."),
    ],
    "ch09": [
        ("ch07", "mch09_t02_c01", "Congruence is tested on triangles first. The SSS/SAS/ASA/RHS rules of Ch.9 decide when two of Ch.7's triangles are exact copies."),
        ("ch05", "mch09_t01_c02", "Pinning a triangle down uses equal angles and equal sides — the angle relationships from Ch.5's intersecting and parallel lines."),
        ("ch14", "mch09_t01_c01", "Congruent figures are exact copies; Ch.14's equal-arc constructions are precisely how you BUILD a copy with compass and straightedge."),
        ("ch07", "mch09_t03_c01", "'Equal sides face equal angles' connects a triangle's measurements. It explains why the isosceles and equilateral triangles of Ch.7 have the angles they do."),
    ],
    "ch10": [
        ("ch15", "mch10_t01_c03", "Adding the opposite to subtract is exactly the inverse-operation move Ch.15 uses to peel an unknown off one side of an equation."),
        ("ch02", "mch10_t02_c01", "The sign rules for multiplication change how an expression evaluates. Ch.2's order-of-operations must be re-read carefully once integers can be negative."),
        ("ch01", "mch10_t01_c01", "Ch.1's number line ran from zero upward; Ch.10 extends it below zero, so every large number gains a negative partner the same distance from zero."),
        ("ch06", "mch10_t02_c01", "The sign rules echo parity: a product of two negatives is positive, just as the sum of two odds is even. Ch.6's parity reasoning rhymes with integer signs."),
    ],
    "ch11": [
        ("ch08", "mch11_t02_c01", "The LCM you find here is the least common DENOMINATOR Ch.8 needs to add or compare fractions — common ground in the most literal sense."),
        ("ch06", "mch11_t03_c01", "Prime factorisation and co-primes are number play with a purpose. Ch.6's factor and parity puzzles are the playground that makes Ch.11's tools feel natural."),
        ("ch01", "mch11_t03_c01", "Breaking a number into primes is decomposition by FACTORS, the multiplicative cousin of the place-value decomposition you met for large numbers in Ch.1."),
        ("ch12", "mch11_t01_c01", "HCF lets you reduce a fraction to lowest terms before you convert it to a decimal in Ch.12 — fewer steps, cleaner answers."),
    ],
    "ch12": [
        ("ch03", "mch12_t01_c01", "Ch.3 introduced what a decimal IS; Ch.12 is the operations sequel — multiplying, dividing, and placing the point by counting decimal places."),
        ("ch01", "mch12_t01_c02", "Multiplying a decimal by 10, 100 or 1000 shifts every digit one place left — the very same place-value shift Ch.1 used to grow whole numbers."),
        ("ch08", "mch12_t02_c01", "Dividing a decimal by another is dividing by a fraction in disguise. Ch.8's reciprocal rule and Ch.12's point-shifting are two views of one operation."),
        ("ch13", "mch12_t03_c01", "Estimating to place the decimal point is the sanity check Ch.13 relies on when it computes a mean or reads a value off a bar graph."),
    ],
    "ch13": [
        ("ch04", "mch13_t02_c01", "The mean is a formula — sum ÷ count — written for any data set. Ch.4's letter-numbers are what let one formula stand for every possible list of numbers."),
        ("ch12", "mch13_t02_c01", "Real data is rarely whole. Computing a mean, median or range usually needs the decimal multiplication and division of Ch.12."),
        ("ch01", "mch13_t01_c01", "Reasoning from data often means handling large counts — populations, rupees, distances — written in the lakh/crore place-value system of Ch.1."),
        ("ch08", "mch13_t02_c02", "Range and proportion compare parts to wholes, which is fraction thinking. Ch.8's fraction skills underpin how Ch.13 describes spread."),
    ],
    "ch14": [
        ("ch05", "mch14_t01_c01", "Constructing a perpendicular bisector or a parallel line turns Ch.5's DEFINITIONS of perpendicular and parallel into something you draw exactly."),
        ("ch07", "mch14_t01_c01", "The compass arcs that bisect a segment are the same moves Ch.7 used to construct a triangle from its three sides."),
        ("ch09", "mch14_t03_c01", "Equal arcs create equal lengths — that is congruence in action, so every Ch.14 construction is really a Ch.9 congruent figure being built."),
        ("ch05", "mch14_t03_c01", "Tiling works because the angles meeting at a vertex add to 360°. That total is read straight off the angle facts of Ch.5."),
    ],
    "ch15": [
        ("ch04", "mch15_t01_c02", "The unknown in an equation is a letter-number from Ch.4. Solving simply finds the single value of that letter that makes the statement true."),
        ("ch02", "mch15_t01_c01", "An equation is two expressions set equal. Ch.2's 'different expressions, same value' is the exact idea a balanced equation captures."),
        ("ch10", "mch15_t02_c01", "Doing the same to both sides often means adding the opposite or dividing by a negative — the integer moves Ch.10 made routine."),
        ("ch08", "mch15_t02_c01", "Inverse operations undo multiplication by a fraction with its reciprocal, so many Ch.15 solutions are the fraction arithmetic of Ch.8 run backwards."),
    ],
}

SANSKRIT = {
    "sch01": [
        ("sch11", "sch01_t01_c01", "Vande Bharatamataram bows to the motherland; the Andaman lesson shows that love made flesh in the freedom fighters of the Cellular Jail, Savarkar among them."),
        ("sch12", "sch01_t02_c01", "The hymn praises a land worth everything. Panna Dhai's story is that devotion in action — a mother who gave up her own son for her land's honour."),
        ("sch14", "sch01_t01_c01", "'Vande mātaram' literally means 'I bow to the Mother' — मातरम् is an accusative object. The full case system behind that ending is laid out in Shabda-Rupani."),
        ("sch02", "sch01_t01_c03", "This is your first taste of literary Sanskrit verse; the Subhashita lesson pours a daily cup of that same poetic nectar, one wise couplet at a time."),
    ],
    "sch02": [
        ("sch06", "sch02_t01_c01", "Subhashitas are wise couplets; the Shloka-Antyakshari lesson turns a whole game out of them, chaining one verse to the next by its last syllable."),
        ("sch08", "sch02_t01_c02", "The 'five va-qualities' praise good conduct; 'rare is speech both useful and pleasing' is one more subhashita on the same theme of disciplined, worthy living."),
        ("sch15", "sch02_t01_c01", "'पिबामः' (we drink) is a present-tense verb. Dhaturupani sets out the full conjugation pattern that such '-āmaḥ / we' forms come from."),
        ("sch05", "sch02_t01_c03", "The six faults to give up are an ethic of self-improvement; Seva Hi Paramo Dharmah turns that inner discipline outward into service of others."),
    ],
    "sch03": [
        ("sch14", "sch03_t02_c01", "'मित्राय नमः' uses the dative (चतुर्थी) case after नमः. Shabda-Rupani places that single case inside the full seven-case declension table."),
        ("sch07", "sch03_t01_c02", "Saluting the Sun with 'namaḥ' is devotion to the divine in nature; Ishavasyam takes that further — the whole universe is pervaded by the Lord."),
        ("sch05", "sch03_t01_c04", "Surya-namaskara is for a healthy body and mind; Seva Hi Paramo Dharmah explains WHY — a strong, well body is the instrument of selfless service."),
        ("sch09", "sch03_t01_c04", "A healthy body needs good food; Annad Bhavanti Bhutani makes the same point cosmic — all beings arise from anna (food)."),
    ],
    "sch04": [
        ("sch10", "sch04_t01_c04", "The fox's 'sour grapes' is a witty fable with a moral; Dashamah Kah is another short tale whose punchline teaches you something about yourself."),
        ("sch14", "sch04_t02_c01", "The -तः direction words (ततः, कुतः) are adverb forms; the full case system that organises such Sanskrit endings is taught in Shabda-Rupani."),
        ("sch06", "sch04_t01_c04", "The fox excuses his failure — weak character dressed as wisdom. The Antyakshari subhashitas warn exactly against शीलम् (character) of that kind."),
        ("sch08", "sch04_t01_c03", "'The grapes are sour' is self-flattering speech, not honest speech. Hitam Manohari prizes words that are both true and pleasing — the opposite of the fox's excuse."),
    ],
    "sch05": [
        ("sch07", "sch05_t01_c02", "Service as the highest dharma rests on seeing the divine in everyone — exactly the vision of Ishavasyam, that the Lord pervades all beings."),
        ("sch09", "sch05_t01_c03", "The physician serves by healing bodies; Annad Bhavanti Bhutani shows the most basic service of all — giving anna (food), from which life itself arises."),
        ("sch03", "sch05_t01_c04", "Serving 'tirelessly, like a machine' needs a fit body and mind — precisely what the Surya-namaskara of Mitraya Namah builds."),
        ("sch12", "sch05_t01_c01", "Seva at its limit is total sacrifice; Panna Dhai lived that ideal, giving up her own child in the service of her ward and her land."),
    ],
    "sch06": [
        ("sch02", "sch06_t01_c01", "Antyakshari is played WITH subhashitas; Nityam Pibamah Subhashitarasam is the lesson that first teaches you to savour those very couplets."),
        ("sch08", "sch06_t02_c02", "These verses prize शीलम् (character) and knowledge; Hitam Manohari adds the verse on speech that is rare because it is both useful and pleasing."),
        ("sch13", "sch06_t01_c01", "Antyakshari chains verses by their LAST syllable — pure sound-play. Varna-Matra teaches the vowel quantities that make those syllables long or short."),
        ("sch15", "sch06_t01_c01", "'क्रीडाम' (let us play) is a verb form; Dhaturupani lays out the conjugation system from which such 'let-us' (आम) endings are built."),
    ],
    "sch07": [
        ("sch09", "sch07_t01_c01", "Ishavasyam says the Lord pervades all; Annad Bhavanti Bhutani names that same omnipresent source 'Brahma', from which all beings spring through food."),
        ("sch05", "sch07_t01_c01", "If the divine dwells in everyone, serving anyone is serving the Lord — which is exactly why Seva Hi Paramo Dharmah calls service the highest duty."),
        ("sch03", "sch07_t02_c01", "Worship (आराधनम्) and name-chanting here echo the devotional 'namaḥ' you first offered to the Sun in Mitraya Namah."),
        ("sch02", "sch07_t01_c01", "This Upanishadic verse is the deepest 'subhashita' in your book; Nityam Pibamah is where you first learned to drink such concentrated wisdom."),
    ],
    "sch08": [
        ("sch02", "sch08_t02_c01", "'Rare is speech both useful and pleasing' is itself a subhashita; Nityam Pibamah Subhashitarasam is the lesson devoted to such polished sayings."),
        ("sch06", "sch08_t01_c03", "This verse scorns विकत्थनम् (boasting); the Antyakshari subhashitas make the matching point about a wicked person's empty knowledge and weak character."),
        ("sch05", "sch08_t01_c04", "It praises the क्रियावान् — the person of ACTION over talk. Seva Hi Paramo Dharmah is what that action looks like: tireless service of others."),
        ("sch15", "sch08_t01_c04", "क्रियावान् ('one who acts') is built from a verb root; Dhaturupani shows how Sanskrit grows whole families of words from those roots (धातु)."),
    ],
    "sch09": [
        ("sch07", "sch09_t01_c02", "'From food, beings come to be' names Brahma as the source — the very same all-pervading Lord that Ishavasyam declares fills the whole universe."),
        ("sch05", "sch09_t01_c01", "If all beings live by anna (food), then giving food is the most fundamental service — the seva that Seva Hi Paramo Dharmah crowns the highest duty."),
        ("sch03", "sch09_t01_c03", "Food becomes a healthy body; the Surya-namaskara of Mitraya Namah keeps that body fit, and the 'chemistry' note here even links anna to modern rasāyana."),
        ("sch15", "sch09_t01_c04", "'जानीयात्' ((one) should know) is the optative mood. Dhaturupani introduces the लकार system of tenses and moods that this single form belongs to."),
    ],
    "sch10": [
        ("sch04", "sch10_t01_c01", "'Who is the tenth?' is a witty teaching-tale with a twist, just like the Fox and the Grapes — a short story that hides a lesson about ourselves."),
        ("sch14", "sch10_t02_c01", "The ordinals प्रथमः, द्वितीयः … दशमः are adjectives that agree like nouns; Shabda-Rupani sets out the declension pattern they follow."),
        ("sch06", "sch10_t01_c04", "The traveller's clever question turns sorrow to joy — the kind of pointed wit the Antyakshari subhashitas celebrate in a single couplet."),
        ("sch08", "sch10_t01_c02", "The whole lesson hinges on a few well-chosen words from the पथिक that reveal the truth — speech that is both useful AND pleasing, the ideal of Hitam Manohari."),
    ],
    "sch11": [
        ("sch01", "sch11_t01_c03", "The Cellular Jail held heroes who lived the spirit of Vande Bharatamataram — their suffering was that hymn's reverence for the motherland made real."),
        ("sch12", "sch11_t01_c03", "Savarkar's sacrifice in the Andaman and Panna Dhai's sacrifice in Mewar are two faces of one virtue: giving everything for land and honour."),
        ("sch14", "sch11_t01_c01", "The title 'द्वीपेषु' (among the islands) is a locative-plural — one of the seven cases whose full table is taught in Shabda-Rupani."),
        ("sch05", "sch11_t01_c03", "The freedom fighters' endurance was selfless service to the nation — seva at its most extreme, the highest dharma of Seva Hi Paramo Dharmah."),
    ],
    "sch12": [
        ("sch01", "sch12_t01_c01", "Panna Dhai's devotion to her land and its prince is the lived emotion that the hymn Vande Bharatamataram puts into verse."),
        ("sch11", "sch12_t01_c02", "Her 'sacrifice of everything' stands beside the Andaman prisoners' suffering — both lessons teach that freedom and honour cost the dearest price."),
        ("sch05", "sch12_t01_c01", "A wet-nurse who gives up her own son for her ward embodies service above self — the very definition of Seva Hi Paramo Dharmah."),
        ("sch14", "sch12_t01_c03", "'षोडशे शतके' (in the sixteenth century) is a locative phrase using an ordinal; both the case and the ordinal pattern come from Shabda-Rupani."),
    ],
    "sch13": [
        ("sch14", "sch13_t01_c01", "Varna-Matra is phonics — the SOUND of Sanskrit; Shabda-Rupani is the next step, organising the words those sounds spell into the seven-case noun tables."),
        ("sch15", "sch13_t01_c02", "Mastering ह्रस्व/दीर्घ vowel lengths prepares you for Dhaturupani, where a long or short vowel in a verb ending changes the whole conjugation."),
        ("sch06", "sch13_t01_c01", "Antyakshari is a game of last SYLLABLES; you can only play it once Varna-Matra has taught you which vowel is long, short, or extra-long."),
        ("sch02", "sch13_t01_c02", "Reciting a subhashita beautifully depends on the correct vowel quantities — exactly the ह्रस्व/दीर्घ/प्लुत distinctions this lesson drills."),
    ],
    "sch14": [
        ("sch15", "sch14_t01_c01", "Shabda-Rupani gives the NOUN tables (the seven cases); Dhaturupani is its companion — the VERB tables — and together they form the spine of Sanskrit grammar."),
        ("sch13", "sch14_t01_c02", "Declension endings hang on vowel sounds — अकारान्त, इकारान्त, उकारान्त stems. Varna-Matra is the phonics that makes those endings audible and correct."),
        ("sch03", "sch14_t02_c02", "The चतुर्थी (dative) you used in 'मित्राय नमः' is just one row of this full case table; Mitraya Namah was your first meeting with it."),
        ("sch01", "sch14_t02_c01", "'वन्दे मातरम्' put मातरम् in the accusative (द्वितीया); here that ending finally takes its place in the complete seven-case scheme."),
    ],
    "sch15": [
        ("sch14", "sch15_t01_c01", "Dhaturupani conjugates VERBS from their roots; Shabda-Rupani declines NOUNS through the seven cases — the two tables are the matched halves of Sanskrit grammar."),
        ("sch13", "sch15_t01_c02", "A verb ending lives or dies by its vowel length, so the ह्रस्व/दीर्घ training of Varna-Matra is the groundwork for reading these conjugation tables."),
        ("sch09", "sch15_t01_c02", "The optative 'जानीयात्' you met in Annad Bhavanti Bhutani is one of the ten लकाराः; here the whole tense-and-mood system it belongs to is laid out."),
        ("sch02", "sch15_t02_c01", "'पिबामः' (we drink) from Nityam Pibamah Subhashitarasam is a present-tense, first-person-plural form — exactly the kind of conjugation tabulated here."),
    ],
}


def maths_topic_label(title: str) -> str:
    return title.strip()


def build_refs(src_id: str, entries, title_by_id, topic_label_fn) -> list:
    refs = []
    for i, (to_id, related_cid, pointer) in enumerate(entries, start=1):
        if to_id not in title_by_id:
            raise SystemExit(f"{src_id}_cx{i:02d}: toChapterId '{to_id}' not found in pack")
        refs.append({
            "id": f"{src_id}_cx{i:02d}",
            "toChapterId": to_id,
            "topic": topic_label_fn(to_id),
            "pointer": pointer,
            "relatedConceptIds": [related_cid],
        })
    return refs


def inject(pack_name: str, table: dict, topic_kind: str) -> int:
    path = PACKS / pack_name
    data = json.loads(path.read_text(encoding="utf-8"))
    title_by_id = {c["id"]: c.get("title", "") for c in data["chapters"]}
    concept_ids = {
        cc["id"]
        for c in data["chapters"]
        for t in c.get("topics", [])
        for cc in t.get("concepts", [])
    }

    if topic_kind == "sanskrit":
        topic_fn = lambda cid: SANSKRIT_TOPIC.get(cid, title_by_id.get(cid, cid))
    else:
        topic_fn = lambda cid: maths_topic_label(title_by_id.get(cid, cid))

    added = 0
    for chapter in data["chapters"]:
        cid = chapter["id"]
        if cid not in table:
            continue
        refs = build_refs(cid, table[cid], title_by_id, topic_fn)
        # Sanity: every anchoring source concept id must exist in-pack.
        for r in refs:
            for rid in r["relatedConceptIds"]:
                if rid not in concept_ids:
                    raise SystemExit(f"{r['id']}: relatedConceptId '{rid}' not found in pack")
        chapter["crossChapterRefs"] = refs
        added += len(refs)

    path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(f"{pack_name}: wrote {added} crossChapterRefs across {len(table)} chapters")
    return added


def main() -> int:
    total = 0
    total += inject("maths_class7.json", MATHS, "maths")
    total += inject("sanskrit_class7.json", SANSKRIT, "sanskrit")
    print(f"total crossChapterRefs written: {total}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
