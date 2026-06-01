#!/usr/bin/env python3
"""P1-G — add `examConnections` + `whatIfs` to every Maths chapter.

The Maths pack (`maths_class7.json`, NEP Ganita Prakash Grade 7) shipped with
zero `examConnections` and zero `whatIfs`, the last two enrichment surfaces
where Science (3/ch each) outranked Maths. ChapterDetailView's
`ExamConnectionCalloutView` and `WhatIfsSectionView` read these structured
fields directly — below the floor, those surfaces go dark on the Maths tab.

This script adds, per chapter:
  * 3 `examConnections` — "you'll see this again" pointers toward Class 8…JEE
    content, each 60–120 words, `relatedConceptIds`-anchored to ≥1 REAL concept
    id in that chapter (enforced by the mirrored MathsEnrichmentTests +
    the Science contract);
  * 3 `whatIfs` — speculative "what would happen if…?" cards, a one-line
    question + a 3–5 sentence guided answer (≥30 chars), each anchored to ≥1
    real in-chapter concept id.

Ids are `mchNN_xcII` / `mchNN_wiII` — the `mch` namespace keeps them distinct
from Science's `chNN_xc` / `chNN_wi` so a global Identifiable index never
collides across packs.

Additive only. Re-runnable (idempotent: overwrites the two keys). Writes the
canonical format `json.dumps(d, ensure_ascii=False, indent=2) + "\n"` so
verify_pack_roundtrip.py stays byte-for-byte green.
"""
import json
from pathlib import Path

PACK = Path(__file__).resolve().parent.parent / "desktopAhaan/Subjects/Packs/maths_class7.json"


def xc(id, title, body, target, related):
    return {
        "id": id,
        "title": title,
        "body": body,
        "targetExam": target,
        "relatedConceptIds": related,
    }


def wi(id, question, answer, related):
    return {
        "id": id,
        "question": question,
        "answer": answer,
        "relatedConceptIds": related,
    }


EXAM = {
    "ch01": [
        xc("mch01_xc01", "Lakhs and crores become powers of ten — Class 8",
           "The place-value counting you do here (a lakh is five zeros, a crore is seven) is rewritten in "
           "Class 8 as standard form: 1 lakh = 1 × 10⁵, 1 crore = 1 × 10⁷. The exponent is just the zero-count "
           "you are mastering now. Once numbers are written this way, multiplying giants like 15 crore × 200 "
           "becomes adding exponents instead of wrangling zeros — the same place-value idea, made calculation-ready.",
           "class8", ["mch01_t01_c01", "mch01_t03_c01"]),
        xc("mch01_xc02", "Rounding grows into significant figures — Class 11 Physics",
           "Deciding when an approximation is 'good enough' and rounding to the nearest neighbour is your first "
           "step toward significant figures, a rule you will use in every Class 11 physics measurement. The "
           "principle there is the one forming here: an answer can be no more precise than the roughest number "
           "that went into it, so a calculator's long decimal tail after a rounded input is a false promise of "
           "accuracy. The judgement 'how exact do I really need to be?' is a lifelong scientific habit.",
           "class11", ["mch01_t04_c01", "mch01_t04_c03"]),
        xc("mch01_xc03", "Fermi estimation reappears in JEE and Olympiad problems",
           "Breaking an impossible-looking question — breaths in a lifetime, beats in a concert — into a chain of "
           "rough factors is a method physicists call Fermi estimation. In JEE and in science olympiads you meet "
           "'estimation' questions that cannot be solved exactly and are graded on this very skill: guess each "
           "factor to the nearest power of ten, multiply, and trust that the over- and under-guesses cancel. The "
           "back-of-the-envelope reasoning you practise here is a tested ability later, not just a curiosity.",
           "jee", ["mch01_t06_c01", "mch01_t06_c02"]),
    ],
    "ch02": [
        xc("mch02_xc01", "The distributive law becomes algebra — Class 8",
           "Removing brackets with a(b + c) = ab + ac feels like an arithmetic convenience now, but in Class 8 it "
           "is the engine of algebra. Run it backwards to FACTORISE (6x + 9 = 3(2x + 3)); use it on two brackets "
           "to expand (a + b)(c + d); and it generates the famous identities (a + b)² = a² + 2ab + b². Every "
           "manipulation of letters you do for years rests on this one law you are meeting here with numbers.",
           "class8", ["mch02_t04_c02", "mch02_t04_c01"]),
        xc("mch02_xc02", "Order of operations gains a new tier — Class 8",
           "BODMAS as you use it now handles brackets, ×, ÷, +, −. Class 8 inserts a new operation, the exponent, "
           "and slots it in: Brackets, then Orders (powers), then Division/Multiplication, then "
           "Addition/Subtraction. So 2 + 3² × 4 means square first: 2 + 9 × 4 = 38. Calculators and spreadsheets "
           "follow exactly this hierarchy, which is why typing 2+3^2*4 returns 38 — the ordering you learn here "
           "decides the answer every time.",
           "class8", ["mch02_t02_c01", "mch02_t02_c03"]),
        xc("mch02_xc03", "Commutativity is a privilege, not a law of nature — Class 12",
           "You found that + and × let you swap terms freely. Class 12 shows this is special, not universal: "
           "matrices multiply so that AB and BA are usually DIFFERENT objects, and the order of two rotations of "
           "a book changes where it lands. The careful question you start asking here — 'is this operation "
           "actually commutative, or am I assuming it?' — is exactly what keeps higher algebra honest, because "
           "most operations beyond + and × are not.",
           "class12", ["mch02_t03_c01", "mch02_t03_c02"]),
    ],
    "ch03": [
        xc("mch03_xc01", "Decimals join the real number line — Class 9",
           "Locating 0.7 or 2.45 on the line makes decimals feel as if they fill every gap. Class 9 reveals they "
           "do not: every decimal you can write, even a repeating one, is RATIONAL, yet points like √2 ≈ 1.41421… "
           "never terminate and never repeat. These irrationals, packed infinitely between the rationals, "
           "complete the real number line. The decimal point you master here is one tool on a line far richer "
           "than it first appears.",
           "class9", ["mch03_t04_c01", "mch03_t03_c01"]),
        xc("mch03_xc02", "Tiny place-holders become negative exponents — Class 8",
           "The 'zero dilemma' — knowing 0.05 is ten times smaller than 0.5 because of where the place-holding "
           "zero sits — is exactly what standard form for SMALL numbers needs in Class 8. There, 0.000 05 is "
           "written 5 × 10⁻⁵, and counting those place-holding zeros gives the negative exponent. The careful "
           "reading of which zeros change a value and which do not, which you build here, becomes the rule for "
           "compactly writing the width of an atom or the mass of a dust grain.",
           "class8", ["mch03_t04_c02", "mch03_t03_c01"]),
        xc("mch03_xc03", "Adding decimals foreshadows place-value alignment in all measurement — Class 11",
           "Lining up the decimal points before you add is the rule that, in Class 11 physics and chemistry, "
           "becomes adding measured quantities with consistent units and precision. The deeper lesson — that you "
           "may only combine digits sitting in the same place — is the same one that later forbids adding a "
           "length in metres to one in centimetres without converting first. Careful column alignment now is the "
           "habit that prevents unit-mismatch errors in every quantitative science.",
           "class11", ["mch03_t05_c01", "mch03_t03_c01"]),
    ],
    "ch04": [
        xc("mch04_xc01", "Letter-numbers become identities — Class 8",
           "Writing the n-th figure of a pattern as 3n + 1 is the leap from arithmetic to algebra. Class 8 takes "
           "the next step: some expressions are equal for EVERY value of the letter — identities like "
           "(a + b)² = a² + 2ab + b². These are not equations to solve but truths to use, and you can SEE the "
           "square identity in a square of side (a + b). The letter-numbers you meet here let one symbolic "
           "statement settle infinitely many numerical cases at once.",
           "class8", ["mch04_t03_c02", "mch04_t01_c01"]),
        xc("mch04_xc02", "Collecting like terms grows into polynomials — Class 9",
           "Turning 2a + 5 + 3a into 5a + 5 is the housekeeping rule of algebra: only add things that count the "
           "same object. Class 9 organises such expressions into polynomials with named parts — coefficient, "
           "constant, degree — and the like-terms rule scales up cleanly: a² terms combine only with a² terms, "
           "just as place value keeps tens apart from units. The tidying you practise here is the same move that "
           "later lets you add, subtract and multiply whole polynomials.",
           "class9", ["mch04_t03_c01", "mch04_t02_c01"]),
        xc("mch04_xc03", "A formula is a function — Class 11",
           "A formula like P = 4s takes one input and returns exactly one output. Class 11 names this idea a "
           "FUNCTION and writes f(s) = 4s — a little machine you run by substituting, exactly the skill you build "
           "here. Functions become the central object of all higher mathematics: calculus studies how their "
           "output changes as the input grows. The substitution you practise now is the doorway to that whole "
           "world.",
           "class11", ["mch04_t01_c02", "mch04_t02_c01"]),
    ],
    "ch05": [
        xc("mch05_xc01", "Parallel-line angle rules prove the triangle angle-sum — Class 9",
           "Alternate angles being equal — which you verify by folding — is strong enough to PROVE that every "
           "triangle's angles add to 180°: draw a line through the apex parallel to the base, and the base angles "
           "reappear as alternate angles on a straight line. Class 9 turns this observation into a formal proof, "
           "your first taste of deductive geometry, where a single parallel-line fact forces a result for every "
           "triangle at once.",
           "class9", ["mch05_t04_c01", "mch05_t02_c02"]),
        xc("mch05_xc02", "Parallel and perpendicular become slope arithmetic — Class 10",
           "On paper you tell parallel from perpendicular by eye. Class 10 coordinate geometry gives every line a "
           "number, its slope, and turns the judgement into arithmetic: parallel lines have EQUAL slopes, "
           "perpendicular lines have slopes multiplying to −1. Suddenly these relationships can be CALCULATED "
           "from two points with no diagram — the great gift of coordinate geometry, translating the pictures you "
           "study here into exact equations.",
           "class10", ["mch05_t02_c02", "mch05_t02_c01"]),
        xc("mch05_xc03", "Euclid's fifth postulate and curved space — Class 9 and beyond",
           "That exactly one parallel passes through a point off a line seems obvious, yet it is the most debated "
           "statement in mathematical history. Class 9 introduces Euclid's axioms and postulates; later "
           "mathematics shows that DENYING this one yields perfectly consistent non-Euclidean geometries — the "
           "very geometry Einstein used for curved spacetime. The flat-paper parallels you study here are one "
           "valid choice, not the only possible world.",
           "class9", ["mch05_t02_c02", "mch05_t01_c01"]),
    ],
    "ch06": [
        xc("mch06_xc01", "Parity becomes the invariant proof — Class 9 and Olympiad",
           "Arguing that five odd numbers can never total 30 is your first INVARIANT proof: a quantity a process "
           "cannot change, used to show an outcome is impossible. In olympiad mathematics this becomes a standard "
           "weapon — the mutilated-chessboard and 15-puzzle impossibility proofs all turn on a parity or "
           "colouring that simply cannot be undone. Spotting what stays fixed, which you begin here, is one of a "
           "mathematician's sharpest tools.",
           "jee", ["mch06_t02_c02", "mch06_t02_c01"]),
        xc("mch06_xc02", "The Virahāṅka–Fibonacci numbers hide the golden ratio — Class 11",
           "The sequence 1, 1, 2, 3, 5, 8, 13… that you build by adding the previous two hides a secret you meet "
           "in Class 11 sequences and series: divide each term by the one before and the ratios close in on "
           "φ ≈ 1.618, the golden ratio, the unique number with φ² = φ + 1 — the sequence's own rule. It governs "
           "sunflower spirals and leaf arrangements. A pattern from counting poetic metres turns out to encode a "
           "constant woven through living things.",
           "class11", ["mch06_t03_c01"]),
        xc("mch06_xc03", "Cryptarithms open the door to modular arithmetic — Class 8 and CS",
           "Solving SEND + MORE = MONEY by reasoning about last digits and carries IS the beginning of modular "
           "arithmetic — the maths of remainders. Class 8's divisibility rules (a number is divisible by 9 when "
           "its digit-sum is) are 'mod 9' facts, and the same idea later underpins calendar calculations and the "
           "check-digits in Aadhaar and bank account numbers. Puzzle-solving with digits is a friendly door into "
           "a deep, widely-used theory.",
           "class8", ["mch06_t04_c01", "mch06_t01_c01"]),
    ],
    "ch07": [
        xc("mch07_xc01", "The triangle inequality defines distance itself — Class 10",
           "That two sides must exceed the third is more than a construction check — it says the straight path "
           "from A to C beats any detour through B. Class 10 coordinate geometry and all higher mathematics build "
           "the very idea of 'distance' on this triangle inequality, in settings from city-block grids to the gap "
           "between two text strings. The rule you test here is the defining property of distance in any number "
           "of dimensions.",
           "class10", ["mch07_t02_c01", "mch07_t01_c01"]),
        xc("mch07_xc02", "Right triangles obey Pythagoras — Class 10",
           "Classifying triangles by angle gives you the right-angled triangle, which obeys the most famous "
           "relation in geometry — known in India as the Baudhāyana result and in the West as Pythagoras' "
           "theorem: a² + b² = c². Class 10 proves it and uses it constantly to compute the distance between two "
           "points on a coordinate plane. The 90° angle you identify here unlocks measuring distances you cannot "
           "reach directly.",
           "class10", ["mch07_t04_c01", "mch07_t01_c01"]),
        xc("mch07_xc03", "Altitudes meet at a single point — Class 9 and 10",
           "An altitude is the perpendicular from a vertex to the opposite side. A striking, non-obvious fact "
           "proved in Class 9 and 10 is that all three altitudes pass through ONE point, the orthocentre — and "
           "the medians meet at the centroid (the balance point), the perpendicular bisectors at the "
           "circumcentre. That so many triple crossings land on a single point each is hidden order you first "
           "glimpse when constructing an altitude here.",
           "class9", ["mch07_t03_c02", "mch07_t03_c01"]),
    ],
    "ch08": [
        xc("mch08_xc01", "Fractions complete into the rational numbers — Class 8",
           "You now multiply and divide positive fractions fluently. Class 8 adds negative fractions to give the "
           "full set of rational numbers, where + − × ÷ (except by zero) always returns another rational — a "
           "self-contained system the integers could not promise. Your reciprocal rule for dividing by a fraction "
           "is one of the operations that makes this closure work. Between any two rationals, however close, lies "
           "another, found just by averaging.",
           "class8", ["mch08_t03_c01", "mch08_t01_c01"]),
        xc("mch08_xc02", "'Of means multiply' powers percentages and interest — Class 8",
           "Reading 'half OF two-thirds' as ½ × ⅔ has enormous reach: a percentage is just a fraction over 100, "
           "so '20% of 350' is 20/100 × 350 = 70 — the same move. Class 8 builds discounts, GST, profit-and-loss "
           "and simple interest entirely on this one rule, and chains it: a 20% then 10% discount is "
           "0.90 × 0.80 = 0.72 of the original, a 28% cut. Mastering 'of means multiply' now makes percentages "
           "later almost nothing new.",
           "class8", ["mch08_t02_c01", "mch08_t02_c02"]),
        xc("mch08_xc03", "Unit fractions and the Egyptian method — number theory",
           "Multiplying a fraction by a whole number rests on the unit fraction — 1 over something, the simplest "
           "kind. Ancient Egyptians wrote EVERY fraction as a sum of distinct unit fractions (3/4 = 1/2 + 1/4), a "
           "form that gave an actual sharing plan for loaves. A simple greedy method always works — a fact only "
           "fully proved in modern times — connecting the humble unit fraction you meet here to number theory and "
           "greedy algorithms in computer science.",
           "class10", ["mch08_t01_c01", "mch08_t02_c01"]),
    ],
    "ch09": [
        xc("mch09_xc01", "Why SSA fails — the ambiguous case returns in the sine rule — Class 10",
           "SSS, SAS, ASA and RHS each pin a triangle down completely, but SSA — two sides and a non-included "
           "angle — does NOT, because the second side can swing into two positions. Class 10 trigonometry meets "
           "this exact ambiguity again as the sine rule's 'two solutions' case. Understanding which triples give "
           "just enough information, which you start here, is the heart of geometric proof.",
           "class10", ["mch09_t02_c01", "mch09_t01_c02"]),
        xc("mch09_xc02", "Congruence relaxes into similarity — Class 10",
           "Congruent figures are exact copies — same shape AND size. Class 10 keeps the shape but relaxes the "
           "size to give SIMILAR figures, like a photo and its enlargement, with sides in a constant ratio. This "
           "is how you measure the unreachable: a building's height from a ruler at arm's length, a river's width "
           "from the shore. Congruence, which you study here, is the special case where that scale factor is "
           "exactly 1.",
           "class10", ["mch09_t01_c01", "mch09_t02_c01"]),
        xc("mch09_xc03", "Equal sides ↔ equal angles, proved both ways — Class 9",
           "You observed that an isosceles triangle's equal sides face equal angles. Class 9 proves this AND its "
           "converse — equal angles force equal sides — using SAS congruence by folding along the apex bisector. "
           "A statement and its converse are different claims, each needing its own proof: a lesson running "
           "through all of mathematics. This equivalence becomes a workhorse for deducing unknown angles and "
           "sides in later proofs.",
           "class9", ["mch09_t03_c01", "mch09_t02_c01"]),
    ],
    "ch10": [
        xc("mch10_xc01", "Closure under subtraction is why integers exist — Class 8",
           "Among whole numbers, 3 − 7 has no answer; the operation falls off the edge. Integers fix this — every "
           "subtraction now has a result, because subtracting is adding the opposite. Class 8 shows this same "
           "'closure' engine driving every number-system expansion: fractions so division always works, reals so "
           "you can measure a diagonal, complex numbers so you can square-root a negative. The integers you meet "
           "here are the first chapter of that recurring story.",
           "class8", ["mch10_t01_c03", "mch10_t01_c02"]),
        xc("mch10_xc02", "Why (−)×(−)=(+) is FORCED — Class 8",
           "The sign rule is easy to memorise and hard to believe — but it is forced by keeping the distributive "
           "law working. Since (−3)×0 = 0 and 0 = 5 + (−5), distributing gives (−15) + (−3)(−5) = 0, so (−3)(−5) "
           "MUST be +15. Class 8 extends this same reasoning to negative rationals. Seeing that the rule is "
           "compelled, not invented, is your first taste of how mathematicians extend definitions: keep the old "
           "laws and let them dictate the new cases.",
           "class8", ["mch10_t02_c01"]),
        xc("mch10_xc03", "One number line crosses into the coordinate plane — Class 9",
           "Adding integers lives on a single number line, where direction encodes sign. Class 9 crosses two such "
           "lines at right angles to build the Cartesian plane, where the signs you master here tell you which of "
           "four quadrants a point (x, y) lives in. This single idea fuses algebra and geometry, turns a line "
           "into an equation, and underlies every graph, map grid and pixel address on a screen.",
           "class9", ["mch10_t01_c01", "mch10_t01_c02"]),
    ],
    "ch11": [
        xc("mch11_xc01", "Euclid's algorithm finds the HCF fast — Class 10",
           "Listing factors works for 12 and 16 but is hopeless for big numbers. Class 10 formalises Euclid's "
           "2000-year-old method: replace the larger number by its remainder on division by the smaller, repeat "
           "until one is zero, and the other is the HCF — found in a few steps even for huge inputs. It is still "
           "one of the fastest algorithms known and runs inside the cryptography that protects online banking.",
           "class10", ["mch11_t01_c01", "mch11_t03_c01"]),
        xc("mch11_xc02", "Primes are the atoms of number — Class 10",
           "Prime factorisation rests on the Fundamental Theorem of Arithmetic: every whole number above 1 has "
           "EXACTLY ONE prime recipe, apart from order. Class 10 proves √2 is irrational with it, and it is why "
           "the HCF and LCM are well defined and obey HCF × LCM = product. The factorisation you use here for HCF "
           "and LCM rests on this quiet, profound guarantee — the bedrock of all number theory.",
           "class10", ["mch11_t03_c01", "mch11_t01_c01"]),
        xc("mch11_xc03", "LCM is the lowest common denominator — Class 8",
           "The least common multiple looks like a stand-alone topic, but it IS the lowest common denominator you "
           "reach for when adding unlike fractions: 1/6 + 1/4 rewrites over 12 = LCM(6, 4). Class 8 uses the LCM "
           "constantly for fraction and rational-expression arithmetic, and for every 'when do cycles line up?' "
           "question — buses, blinking lights, gear teeth. So the LCM you meet here names a pattern you already "
           "rely on whenever quantities must synchronise.",
           "class8", ["mch11_t02_c01", "mch11_t03_c01"]),
    ],
    "ch12": [
        xc("mch12_xc01", "Shifting the point becomes the laws of exponents — Class 8",
           "Multiplying a decimal by 10, 100 or 1000 shifts the point — and Class 8 reveals the law beneath: "
           "multiplying powers of ten ADDS exponents, dividing SUBTRACTS them, so shifting n places is "
           "multiplying by 10ⁿ. Combined with standard form this makes giant numbers easy: light-speed "
           "3×10⁸ m/s × the 3×10⁷ s in a year is 9×10¹⁵ m, by multiplying fronts and adding exponents. The "
           "point-shifting you practise here is exponent arithmetic in everyday clothes.",
           "class8", ["mch12_t01_c02", "mch12_t01_c01"]),
        xc("mch12_xc02", "Repeating decimals turn back into fractions — Class 9",
           "Dividing decimals sometimes yields an endless repeat like 1 ÷ 3 = 0.333… Class 9 shows the reverse: "
           "let x = 0.777…, then 10x = 7.777…, subtract and the tails cancel, leaving 9x = 7, so x = 7/9 exactly. "
           "This proves every repeating decimal is rational, and even settles 0.999… = 1. The repeating answers "
           "your division throws up here are fractions in disguise.",
           "class9", ["mch12_t02_c01", "mch12_t03_c01"]),
        xc("mch12_xc03", "Estimation grows into error analysis — Class 11 Physics",
           "Estimating before computing is sold as a way to place the decimal point, but its deeper purpose — "
           "controlling how much precision an answer can honestly claim — becomes formal error analysis in Class "
           "11 physics. A length read as 4.8 cm really means 4.75–4.85; multiply two such rough numbers and the "
           "answer cannot beat its least precise input. The 'roughly how big, and how sure?' habit you build here "
           "is the discipline of significant figures and uncertainty.",
           "class11", ["mch12_t03_c01", "mch12_t01_c01"]),
    ],
    "ch13": [
        xc("mch13_xc01", "Mean, median, mode — choosing the honest average — Class 9",
           "Class 9 sharpens these three 'representative values' and when each tells the truth. The mean is "
           "dragged by extremes — one billionaire makes a room's MEAN income look rich while the MEDIAN reports "
           "the ordinary person honestly — which is why income figures quote the median. The mode suits shoe "
           "sizes a shop should stock. Knowing which average fits a question, and spotting the flattering choice, "
           "is a life skill you begin here.",
           "class9", ["mch13_t02_c01", "mch13_t01_c01"]),
        xc("mch13_xc02", "Range grows into standard deviation — Class 11",
           "Range — largest minus smallest — is fragile: it ignores everything between the two extremes, so a "
           "single freak value blows it up. Class 11 fixes this with the standard deviation, which measures how "
           "far EVERY value sits from the mean on average. It underlies opinion-poll margins of error, factory "
           "quality control and the bell curve of marks. The spread you measure here with range is the first step "
           "toward the workhorse measure of dispersion.",
           "class11", ["mch13_t02_c02", "mch13_t02_c01"]),
        xc("mch13_xc03", "Bar graphs grow into histograms — and how graphs lie — Class 9",
           "A bar graph turns numbers into a picture, but the same power makes graphs easy to weaponise: a "
           "truncated axis starting at 90 makes a 4% rise look like a doubling. Class 9 teaches you to read the "
           "axis and scale critically, and meets the histogram, where it is the AREA of each bar, not just the "
           "height, that carries meaning. The graph-reading you start here is as important as drawing one — a "
           "graph is an argument.",
           "class9", ["mch13_t03_c01", "mch13_t01_c01"]),
    ],
    "ch14": [
        xc("mch14_xc01", "What compass and straightedge cannot build — higher mathematics",
           "With these two tools you can bisect any angle exactly, so it feels as if they can do anything. "
           "Astonishingly, three ancient problems — trisecting a general angle, doubling the cube, squaring the "
           "circle — were PROVED impossible with them in the 1800s using algebra, because the tools reach only "
           "lengths built from + − × ÷ and square roots. Field theory explains exactly which constructions are "
           "possible — a deep answer to 'I can bisect, why not trisect?'",
           "class11", ["mch14_t02_c01", "mch14_t01_c01"]),
        xc("mch14_xc02", "Only three regular shapes tile the plane — symmetry and crystals",
           "Tiling needs the shapes at every corner to fill exactly 360°. That rule alone explains why only the "
           "triangle (60°, six meet), square (90°, four meet) and hexagon (120°, three meet) tile alone — a "
           "pentagon's 108° divides 360 only 3.33 times, leaving a gap. This grows into the study of "
           "tessellations and symmetry groups, and explains why honeycombs and certain crystals take the shapes "
           "they do. The 360° rule you meet here is doing all the work.",
           "class11", ["mch14_t03_c01", "mch14_t03_c02"]),
        xc("mch14_xc03", "The perpendicular bisector is a locus — Class 10",
           "Constructing a perpendicular bisector with equal arcs builds something with a beautiful definition: "
           "the set of ALL points equidistant from the two endpoints — a locus. That is exactly why the equal-arc "
           "method works. Class 10 uses loci and the circumcentre (where all three bisectors meet, equidistant "
           "from every corner) in proofs and coordinate geometry. Seeing a construction as a locus turns 'how to "
           "draw it' into 'what it fundamentally is'.",
           "class10", ["mch14_t01_c01", "mch14_t02_c01"]),
    ],
    "ch15": [
        xc("mch15_xc01", "Transposition is the balance rule in one stroke — Class 8",
           "You solve equations by doing the same thing to both sides, keeping the balance level. Class 8 hands "
           "you equations with the unknown on BOTH sides (3x + 4 = x + 12) and the balance idea still rules — "
           "gather the x's, then isolate. The familiar shortcut 'a term crosses the equals sign and flips its "
           "operation' is just this balance rule done in one move. Recognising the shortcut as the principle in "
           "disguise is what stops the classic one-side-only error.",
           "class8", ["mch15_t02_c01", "mch15_t01_c01"]),
        xc("mch15_xc02", "One equation, two unknowns, becomes a line — Class 10",
           "Every equation you balance now has one unknown and one solution. Class 10 meets equations with TWO "
           "unknowns — 'two pens and three pencils cost ₹40' — which has infinitely many solution pairs that plot "
           "as a straight LINE. A second equation pins down the unique answer where the two lines cross: "
           "simultaneous equations. The single-unknown balance you master here is one line of a richer "
           "two-dimensional picture.",
           "class10", ["mch15_t01_c01", "mch15_t02_c01"]),
        xc("mch15_xc03", "When the unknown is squared — quadratics — Class 10",
           "A solution makes both sides equal, and so far each equation has had one. But x² = 9 has TWO solutions "
           "(3 and −3), because both square to 9 — a consequence of the integer sign rules. Class 10 studies "
           "quadratics like x² − 5x + 6 = 0, solved by factorising into (x − 2)(x − 3) = 0 or the quadratic "
           "formula; they describe a thrown ball's arc and a fountain's path. Asking 'what counts as a solution?' "
           "carefully here prepares you for more than one answer.",
           "class10", ["mch15_t01_c02", "mch15_t01_c01"]),
    ],
}


WHATIF = {
    "ch01": [
        wi("mch01_wi01", "What if India switched from the lakh–crore system to the international million–billion system overnight?",
           "Every digit would keep its value — 50,00,000 is exactly 5 million — so no quantity would change, only "
           "how it is grouped and read aloud. Newspapers, bank statements and exam papers would regroup the "
           "commas from 3-2-2-2 to groups of three, and 'one crore' would become 'ten million'. People fluent in "
           "one system would briefly misread the other, which is precisely why learning to translate between the "
           "two place-value groupings matters. The arithmetic underneath stays identical.",
           ["mch01_t03_c02", "mch01_t01_c03"]),
        wi("mch01_wi02", "What if you rounded every number in a long bill to the nearest hundred before adding?",
           "Each rounding nudges a value up or down by at most fifty, and across many items these errors partly "
           "cancel — but not perfectly, so the rounded total can drift noticeably from the true one, sometimes by "
           "hundreds. Rounding first is great for a quick estimate to check whether an answer is sensible, but it "
           "is the wrong tool for the final amount you actually pay. This is exactly why a shopkeeper estimates "
           "to sanity-check, then totals the exact figures.",
           ["mch01_t04_c01", "mch01_t04_c02"]),
        wi("mch01_wi03", "What if you tried to write the number of grains of rice on a chessboard by counting zeros?",
           "Doubling on each of 64 squares reaches about 1.8 × 10¹⁹ grains — a number with twenty digits that no "
           "one could write without losing count of the zeros. This is the moment standard form and orders of "
           "magnitude stop being optional: you describe the answer as 'about 10¹⁹', which is enough to see it "
           "dwarfs the world's annual rice harvest. The legend works precisely because human intuition fails at "
           "these scales while powers of ten do not.",
           ["mch01_t05_c02", "mch01_t06_c01"]),
    ],
    "ch02": [
        wi("mch02_wi01", "What if everyone evaluated 30 + 5 × 4 strictly left to right?",
           "You would get 140 instead of 50, because left-to-right does the addition first. If the whole world "
           "agreed to that convention, calculators and textbooks could be built around it and answers would still "
           "be consistent — the point of an order-of-operations rule is shared agreement, not a law of nature. "
           "But our chosen convention (× before +) matches how terms naturally group: 5 × 4 is one bundle added "
           "to 30. Mixing conventions, not the convention itself, is what produces wrong answers.",
           ["mch02_t02_c01", "mch02_t02_c03"]),
        wi("mch02_wi02", "What if brackets did not exist in mathematics?",
           "Without brackets you could not force an addition to happen before a multiplication, so expressions "
           "like '(3 + 4) × 5' would be impossible to write — you would be stuck with whatever the default order "
           "gives. Many real calculations (total cost = items × (price + tax)) genuinely need the inner step "
           "first, so mathematics would need some other grouping mark to survive. Brackets are the tool that lets "
           "you OVERRIDE the default order whenever a problem demands it.",
           ["mch02_t02_c02", "mch02_t01_c01"]),
        wi("mch02_wi03", "What if subtraction were commutative like addition?",
           "Then 7 − 2 would have to equal 2 − 7, forcing 5 = −5, which is false — so the whole number line would "
           "collapse into nonsense. Subtraction simply cannot be commutative; order carries real meaning ('took "
           "away' is directional). This is why you may freely rearrange a sum but must keep subtractions in place, "
           "and why recognising which operations allow swapping protects you from accidentally changing an "
           "expression's value.",
           ["mch02_t03_c01", "mch02_t04_c01"]),
    ],
    "ch03": [
        wi("mch03_wi01", "What if we had ten fingers but counted in groups of eight instead of ten?",
           "Our decimal places (tenths, hundredths) exist only because we group in tens; a base-eight world would "
           "split a unit into eighths and sixty-fourths instead, and '0.1' would mean one-eighth. The quantities "
           "themselves would not change — half is half in any base — but which fractions give neat 'decimals' "
           "would. In base eight, 1/2 stays tidy but 1/5 would repeat forever. Computers actually do something "
           "like this, working in base two, which is why some everyday decimals can't be stored exactly.",
           ["mch03_t02_c01", "mch03_t01_c02"]),
        wi("mch03_wi02", "What if you wrote 0.5 and 0.05 with the decimal point removed?",
           "You would be left with '5' in both cases and could no longer tell a half from a twentieth — the point "
           "and the place of each digit are the only things distinguishing them. This is why aligning the decimal "
           "point before adding is non-negotiable: 0.5 + 0.05 is 0.55, but a careless writer who drops or "
           "misplaces the point could turn it into 1.0 or 0.10. The point is not decoration; it anchors every "
           "digit to its true value.",
           ["mch03_t04_c02", "mch03_t03_c01"]),
        wi("mch03_wi03", "What if a shopkeeper ignored the third decimal place on every price?",
           "Most prices stop at paise (two places), so usually nothing changes — but quantities like petrol, "
           "sold at prices such as ₹96.726 per litre, do use a third place. Truncating it would shave a tiny "
           "amount off each litre; across a busy pump's thousands of litres a day, those discarded thousandths "
           "add up to real rupees. It shows why the place a digit sits in still matters even when it looks "
           "negligibly small.",
           ["mch03_t04_c01", "mch03_t05_c01"]),
    ],
    "ch04": [
        wi("mch04_wi01", "What if a formula could give two different outputs for the same input?",
           "Then it would not be a reliable rule — feed in s = 5 and a perimeter formula must always return 20, "
           "never sometimes 20 and sometimes 25, or no one could trust it. A genuine formula pairs each input "
           "with exactly one output; that single-valued behaviour is what later earns it the name 'function'. An "
           "expression that gave two answers would be a contradiction, not a formula, and would signal a mistake "
           "in how it was built.",
           ["mch04_t01_c02", "mch04_t01_c01"]),
        wi("mch04_wi02", "What if you 'simplified' 2a + 3b into 5ab?",
           "You would be adding things that count different objects — like claiming 2 apples + 3 bananas = 5 "
           "apple-bananas. The like-terms rule forbids it: 2a and 3b stay separate because a and b may stand for "
           "different numbers, so 2a + 3b is already in its simplest form. Only matching terms combine "
           "(2a + 3a = 5a). This single error is the most common slip in early algebra, and it comes from "
           "forgetting that a letter is a placeholder for a quantity, not just a symbol to merge.",
           ["mch04_t03_c01", "mch04_t02_c01"]),
        wi("mch04_wi03", "What if letter-numbers had never been invented and we wrote every rule in words?",
           "A compact formula like A = l × w would become a sentence — 'the area equals the length multiplied by "
           "the width' — and a long derivation would run to paragraphs, hard to scan or manipulate. Historically "
           "this is exactly how mathematics was done for centuries, and progress was slow. Letters let one short "
           "expression capture a rule that holds for ALL numbers at once, and let you rearrange it mechanically — "
           "the leap that made modern algebra possible.",
           ["mch04_t01_c01", "mch04_t03_c02"]),
    ],
    "ch05": [
        wi("mch05_wi01", "What if two railway tracks were laid almost, but not exactly, parallel?",
           "True parallel lines stay the same distance apart forever; tracks tilted by even a hair would slowly "
           "converge or spread, and far enough along the gauge would be wrong and a train would derail. This is "
           "why 'parallel' is defined as never meeting however far extended, not just 'looking side by side' over "
           "a short stretch. The tiny angle that seems harmless nearby becomes a large gap at distance — geometry "
           "with real safety stakes.",
           ["mch05_t02_c02", "mch05_t03_c01"]),
        wi("mch05_wi02", "What if alternate angles on a transversal were NOT equal?",
           "Then the two lines being crossed could not be parallel — unequal alternate angles are the tell-tale "
           "sign that the lines will eventually meet. The equality of alternate angles and the parallelness of "
           "the lines are two faces of the same fact, which is why you can use the angles to TEST for parallel "
           "lines without extending them to infinity. Break the angle equality and you have broken the "
           "parallelism.",
           ["mch05_t04_c01", "mch05_t02_c02"]),
        wi("mch05_wi03", "What if a transversal crossed the two lines at exactly 90°?",
           "Every one of the eight angles formed would be a right angle, so corresponding, alternate and "
           "co-interior angles would all be equal at 90° — the special, symmetric case. The lines would be "
           "parallel and the transversal perpendicular to both. It is the cleanest situation to reason about, "
           "which is why right-angle grids (graph paper, city blocks) are so easy to navigate compared with "
           "slanted intersections.",
           ["mch05_t03_c02", "mch05_t02_c01"]),
    ],
    "ch06": [
        wi("mch06_wi01", "What if you tried to make 30 by adding exactly five odd numbers?",
           "It is impossible, and parity proves it without trying a single combination: odd + odd is even, so "
           "four odds make an even, and adding a fifth odd makes the total odd again — but 30 is even. No clever "
           "arrangement can escape this, because each odd number contributes an unavoidable 'leftover one'. This "
           "is the power of a parity argument: it rules out infinitely many attempts at once by tracking a "
           "quantity (oddness) the process can never fix.",
           ["mch06_t02_c01", "mch06_t02_c02"]),
        wi("mch06_wi02", "What if you started the Virahāṅka–Fibonacci rule with two different numbers, say 2 and 5?",
           "You would get a brand-new sequence — 2, 5, 7, 12, 19, 31… — by the same 'add the previous two' rule. "
           "Remarkably, divide consecutive terms and the ratios STILL close in on the golden ratio φ ≈ 1.618, "
           "exactly as the classic 1, 1 start does. The starting pair changes the numbers but not the long-run "
           "ratio, because that ratio is forced by the rule itself, not the seeds. The pattern's deepest feature "
           "is built into how it grows.",
           ["mch06_t03_c01"]),
        wi("mch06_wi03", "What if two different letters in a cryptarithm stood for the same digit?",
           "The puzzle's core promise would break — in SEND + MORE = MONEY each letter is a DISTINCT digit, and "
           "that uniqueness is what lets you deduce them by logic. If S and E could both be 7, the columns would "
           "no longer constrain each other and there would usually be many sloppy 'solutions' instead of one "
           "elegant answer. The one-letter-one-digit rule is exactly what turns a guessing game into a deduction.",
           ["mch06_t04_c01", "mch06_t01_c01"]),
    ],
    "ch07": [
        wi("mch07_wi01", "What if you tried to build a triangle from sticks of 3 cm, 4 cm and 9 cm?",
           "It cannot close: the two shorter sticks (3 + 4 = 7 cm) together fall short of the 9 cm side, so their "
           "free ends can never meet. This is the triangle inequality in action — the two shorter sides must SUM "
           "to more than the longest. Push 3 + 4 up to exactly 9 and the 'triangle' flattens into a straight "
           "line; only when the sum genuinely exceeds the longest side does a real triangle with area appear.",
           ["mch07_t02_c01", "mch07_t01_c01"]),
        wi("mch07_wi02", "What if a triangle could have two right angles?",
           "Its three angles would then total at least 90° + 90° = 180° before the third angle is even counted, "
           "leaving nothing for it — impossible, since all three must sum to exactly 180°. Two of the sides would "
           "in effect be parallel and never meet to close the figure. This is why a triangle has at most one "
           "right angle (or one obtuse angle): the fixed 180° budget simply cannot afford two.",
           ["mch07_t04_c01", "mch07_t01_c01"]),
        wi("mch07_wi03", "What if you dropped an altitude in a very 'flat' obtuse triangle?",
           "For the obtuse angle's neighbouring sides, the foot of the altitude lands OUTSIDE the triangle, on the "
           "extension of the base — the perpendicular height has to be measured beyond the actual side. This "
           "surprises many students who expect every height to sit inside the shape. It shows that an altitude is "
           "defined by the perpendicular distance from a vertex to the line of the opposite side, not merely to "
           "the side segment itself.",
           ["mch07_t03_c02", "mch07_t04_c01"]),
    ],
    "ch08": [
        wi("mch08_wi01", "What if multiplying always made numbers bigger?",
           "Many people believe this, but multiplying by a fraction less than 1 SHRINKS a number: ½ × 8 = 4, and "
           "⅓ × 6 = 2. 'Multiply' really means 'take this many of', and taking half OF something gives less, not "
           "more. The 'multiplication makes bigger, division makes smaller' rule only holds for whole numbers "
           "above 1; fractions overturn it. Spotting that this childhood intuition fails is a key step in truly "
           "understanding fraction multiplication.",
           ["mch08_t02_c01", "mch08_t01_c01"]),
        wi("mch08_wi02", "What if you divided a number by a fraction smaller than 1?",
           "The answer comes out LARGER than what you started with: 6 ÷ ½ = 12, because you are asking 'how many "
           "halves fit into 6?' and there are twelve of them. This feels backwards to anyone who thinks division "
           "always shrinks, but the reciprocal rule (÷½ is the same as ×2) makes it inevitable. It explains why a "
           "recipe needing ½-cup scoops gets you twice as many servings from the same flour.",
           ["mch08_t03_c01", "mch08_t02_c02"]),
        wi("mch08_wi03", "What if you forgot to convert a mixed number before multiplying?",
           "Multiplying 2½ × 4 by handling the 2 and the ½ separately and adding wrongly gives nonsense; you must "
           "first turn 2½ into the improper fraction 5/2, then 5/2 × 4 = 10. Skipping the conversion is one of "
           "the commonest fraction errors, because the whole part and the fractional part cannot be multiplied in "
           "isolation. Converting to a single improper fraction puts every part over one denominator so the "
           "ordinary rule applies cleanly.",
           ["mch08_t02_c02", "mch08_t03_c01"]),
    ],
    "ch09": [
        wi("mch09_wi01", "What if two triangles had all three EQUAL angles but different sizes?",
           "They would not be congruent — equal angles fix only the SHAPE, not the size, so a small triangle and "
           "a giant one can share all three angles. This is exactly why 'AAA' is not a congruence criterion: it "
           "leaves the scale free. Such triangles are instead called SIMILAR, and recognising that equal angles "
           "guarantee same shape but not same size is the very distinction that separates congruence from "
           "similarity.",
           ["mch09_t01_c02", "mch09_t01_c01"]),
        wi("mch09_wi02", "What if you tried to prove two triangles congruent using SSA?",
           "You might fail, because two sides and a non-included angle can describe TWO different triangles — the "
           "free side can swing to two positions. So an SSA match is not enough to guarantee the triangles are "
           "identical, which is why SSA is deliberately left off the list of valid criteria (SSS, SAS, ASA, RHS). "
           "Relying on it is a classic proof error; you need a triple that pins the triangle down with no "
           "ambiguity.",
           ["mch09_t02_c01", "mch09_t01_c02"]),
        wi("mch09_wi03", "What if a triangle had two equal angles but you were told its sides were all different?",
           "That is a contradiction: equal angles FORCE the sides facing them to be equal (the converse of the "
           "isosceles property), so a triangle with two equal angles must have two equal sides. Being told all "
           "sides differ would mean someone measured wrongly. This 'equal angles ↔ equal sides' link runs both "
           "ways, which is why a single pair of equal angles is enough to conclude the triangle is isosceles.",
           ["mch09_t03_c01", "mch09_t02_c01"]),
    ],
    "ch10": [
        wi("mch10_wi01", "What if there were no negative numbers and you owed more money than you had?",
           "You could not write your balance as a single number — 'I have ₹200 but owe ₹500' would need words "
           "instead of −₹300. Negative numbers let one number capture 'below zero' situations directly: debt, "
           "temperatures under freezing, floors below ground level. Without them, subtraction like 200 − 500 "
           "would simply have 'no answer', and everyday accounting, thermometers and lift buttons would lose "
           "their cleanest description.",
           ["mch10_t01_c01", "mch10_t01_c03"]),
        wi("mch10_wi02", "What if (−1) × (−1) equalled −1 instead of +1?",
           "Then the distributive law would break: since 0 = 1 + (−1), multiplying by (−1) should give "
           "(−1) + (−1)×(−1) = 0, which only balances if (−1)×(−1) = +1. Setting it to −1 instead would force "
           "0 = −2, collapsing arithmetic into contradiction. So 'a negative times a negative is positive' is not "
           "a choice — it is the only value that keeps every other rule of arithmetic consistent.",
           ["mch10_t02_c01"]),
        wi("mch10_wi03", "What if you walked 5 steps right, then 8 steps left on a number line?",
           "You would land 3 steps to the LEFT of where you began, at −3 — modelling 5 + (−8) = −3. Walking left "
           "is adding a negative, and because you walked further left than right, the result dips below your "
           "start. This 'direction = sign, distance = size' picture turns every integer addition into a short "
           "journey, and makes clear why a bigger negative can overpower a smaller positive.",
           ["mch10_t01_c01", "mch10_t01_c02"]),
    ],
    "ch11": [
        wi("mch11_wi01", "What if two numbers shared no common factor except 1?",
           "They are called co-prime, and their HCF is 1 — like 8 and 15, which share nothing despite neither "
           "being prime. Co-prime pairs behave specially: their LCM is simply their product (8 × 15 = 120), and "
           "fractions like 8/15 are already in lowest terms because nothing cancels. Recognising co-primality "
           "saves work, since there is no common factor to divide out before adding fractions or simplifying "
           "ratios.",
           ["mch11_t01_c02", "mch11_t01_c01"]),
        wi("mch11_wi02", "What if a number could be factorised into primes in two different ways?",
           "Whole-number arithmetic would lose its foundation: the HCF and LCM would no longer be well defined, "
           "because there would be competing 'recipes' for the same number. The Fundamental Theorem of Arithmetic "
           "guarantees this never happens — every number above 1 has EXACTLY ONE prime factorisation apart from "
           "order. That uniqueness is precisely what lets prime factorisation reliably produce a single correct "
           "HCF and LCM every time.",
           ["mch11_t03_c01", "mch11_t01_c01"]),
        wi("mch11_wi03", "What if two buses leave a stop together, one every 6 minutes and one every 12?",
           "They depart together again every 12 minutes — the LCM of 6 and 12 — because 12 is the smallest time "
           "both cycles complete a whole number of trips. Since 6 divides 12, the slower bus's schedule already "
           "contains the faster one's meeting points. Every 'when do repeating events coincide?' question — "
           "blinking lights, planet alignments, gear teeth — is an LCM problem in disguise, which is why the LCM "
           "is far more than a fraction tool.",
           ["mch11_t02_c01", "mch11_t01_c01"]),
    ],
    "ch12": [
        wi("mch12_wi01", "What if you multiplied 0.3 × 0.2 and expected an answer bigger than 0.3?",
           "You would be surprised: 0.3 × 0.2 = 0.06, SMALLER than either factor, because multiplying by a number "
           "below 1 shrinks. Counting decimal places explains the size — one place plus one place gives two "
           "places, so the answer is six hundredths. The instinct that 'multiplying grows a number' fails for "
           "decimals under 1, and tracking the decimal-place count is what keeps you from misplacing the point by "
           "a factor of ten.",
           ["mch12_t01_c01", "mch12_t03_c01"]),
        wi("mch12_wi02", "What if you divided 5 by 0.5 and guessed the answer was 2.5?",
           "The true answer is 10, because dividing by 0.5 asks 'how many halves are in 5?' — and there are ten. "
           "Dividing by a number smaller than 1 makes the result LARGER, the opposite of dividing by a whole "
           "number. The reliable fix is to turn 'divide by 0.5' into 'multiply by 2'. This is the single most "
           "common decimal-division trap, and it comes from assuming division always shrinks.",
           ["mch12_t02_c01", "mch12_t03_c01"]),
        wi("mch12_wi03", "What if you trusted a calculator showing 4.8 × 2.1 = 10.08 cm² as exact?",
           "If 4.8 and 2.1 were rounded measurements, that trailing '08' is a false precision — the inputs were "
           "only known to a couple of figures, so the honest area is about 10 cm². A calculator faithfully "
           "multiplies the digits you type but knows nothing about how precise your measurements were. Estimating "
           "first ('about 5 × 2 = 10') reminds you which digits to trust and which the calculator merely "
           "invented.",
           ["mch12_t03_c01", "mch12_t01_c01"]),
    ],
    "ch13": [
        wi("mch13_wi01", "What if a cricketer's mean score was high but their median was much lower?",
           "It would mean a few huge innings are dragging the mean up while most innings are modest — the player "
           "is inconsistent, not reliably good. The mean is pulled by big outliers; the median, the middle value, "
           "ignores how extreme they are and reports the typical innings honestly. Spotting a wide gap between "
           "mean and median is a clue that an 'average' is hiding the real story, a habit that protects you from "
           "misleading statistics.",
           ["mch13_t02_c01", "mch13_t01_c01"]),
        wi("mch13_wi02", "What if two classes had the same average mark but very different ranges?",
           "The class with the larger range has marks spread far apart — some very high, some very low — while "
           "the small-range class is bunched near the average, far more consistent. An identical mean can hide "
           "completely different stories, which is exactly why range (and later, standard deviation) is reported "
           "alongside the average. Knowing the spread tells you whether 'average' describes everyone or just a "
           "balancing act between extremes.",
           ["mch13_t02_c02", "mch13_t02_c01"]),
        wi("mch13_wi03", "What if a bar graph's vertical axis started at 90 instead of 0?",
           "A change from 92 to 96 — barely 4% — would look like a dramatic near-doubling, because the eye reads "
           "bar HEIGHTS as if they start from zero. This 'truncated axis' is the classic way an honest-looking "
           "graph misleads. Always checking where the axis begins, and what its scale is, before trusting the "
           "picture is the single most useful graph-reading skill — a graph is an argument that can be rigged.",
           ["mch13_t03_c01", "mch13_t01_c01"]),
    ],
    "ch14": [
        wi("mch14_wi01", "What if you tried to tile a floor using only regular pentagons?",
           "You cannot cover it without gaps or overlaps. A regular pentagon's interior angle is 108°, and 108 "
           "does not divide 360 evenly — three pentagons at a corner make only 324°, leaving a 36° wedge, while "
           "four overlap. The 360°-at-a-vertex rule is unforgiving, which is why only triangles, squares and "
           "hexagons tile alone. It explains why you never see a pentagon-tiled bathroom floor.",
           ["mch14_t03_c01", "mch14_t03_c02"]),
        wi("mch14_wi02", "What if your compass slipped and the two arcs for a perpendicular bisector had different radii?",
           "The two arc-crossings would no longer be equidistant from both endpoints, so the line through them "
           "would NOT be the true perpendicular bisector — it would tilt and miss the midpoint. The whole "
           "construction works precisely because both arcs share one radius, placing every crossing equally far "
           "from the two ends (the locus property). Keeping the compass width fixed is what guarantees a correct "
           "bisector.",
           ["mch14_t01_c01", "mch14_t02_c01"]),
        wi("mch14_wi03", "What if you rearranged the seven tangram pieces into a totally different shape?",
           "The total AREA stays exactly the same, however you arrange them, because cutting and rearranging "
           "never creates or destroys area — it only moves it around. A tall thin figure and a squat wide one "
           "built from the same seven pieces cover identical area despite looking nothing alike. This "
           "conservation of area is the quiet principle behind every dissection puzzle and behind deriving one "
           "shape's area formula from another's.",
           ["mch14_t03_c02", "mch14_t03_c01"]),
    ],
    "ch15": [
        wi("mch15_wi01", "What if you added 5 to only one side of a balanced equation?",
           "The balance tips — the two sides are no longer equal, so the equation becomes false and any 'solution' "
           "you find from it is wrong. An equation is a statement that two sides weigh the same; to keep it true "
           "you must do the IDENTICAL operation to both sides. Changing one side alone is the single most common "
           "equation-solving error, and the balance picture is exactly what reminds you to mirror every move.",
           ["mch15_t01_c01", "mch15_t02_c01"]),
        wi("mch15_wi02", "What if an equation had the unknown on both sides, like 3x + 4 = x + 12?",
           "You handle it with the same balance rule: subtract x from both sides to gather the unknowns "
           "(2x + 4 = 12), then isolate x to get x = 4. The unknown appearing twice is not a new kind of problem — "
           "it just needs one extra balancing step to bring the x-terms together first. Recognising this keeps "
           "you from panicking at equations that look more tangled than they are.",
           ["mch15_t02_c01", "mch15_t01_c01"]),
        wi("mch15_wi03", "What if you solved an equation but never checked the answer by substitution?",
           "You might never catch a slip — a dropped sign or a mis-transposed term can give a wrong x that looks "
           "perfectly plausible. Substituting your answer back into the ORIGINAL equation and confirming both "
           "sides match is a free, foolproof check: if they balance, the answer is right. Skipping this step is "
           "how avoidable errors survive into the final answer, which is why verification is part of solving, not "
           "an optional extra.",
           ["mch15_t03_c01", "mch15_t01_c02"]),
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
    total_xc = 0
    total_wi = 0
    for ch in pack["chapters"]:
        cid = ch["id"]
        xcs = EXAM.get(cid)
        wis = WHATIF.get(cid)
        if not xcs or len(xcs) < 3:
            raise SystemExit(f"{cid}: need ≥3 examConnections, got {len(xcs or [])}")
        if not wis or len(wis) < 3:
            raise SystemExit(f"{cid}: need ≥3 whatIfs, got {len(wis or [])}")
        for it in xcs:
            if it["id"] in seen_ids:
                raise SystemExit(f"Duplicate id {it['id']}")
            seen_ids.add(it["id"])
            wc = len(it["body"].split())
            if wc < 50 or wc > 130:
                raise SystemExit(f"{it['id']} body {wc} words (want 50–130)")
            for rc in it["relatedConceptIds"]:
                if rc not in chapter_concept_ids[cid]:
                    raise SystemExit(f"{it['id']} relatedConceptId {rc} not in {cid}")
        for it in wis:
            if it["id"] in seen_ids:
                raise SystemExit(f"Duplicate id {it['id']}")
            seen_ids.add(it["id"])
            if len(it["question"].strip()) < 5:
                raise SystemExit(f"{it['id']} question too short")
            if len(it["answer"].strip()) < 30:
                raise SystemExit(f"{it['id']} answer too short")
            for rc in it["relatedConceptIds"]:
                if rc not in chapter_concept_ids[cid]:
                    raise SystemExit(f"{it['id']} relatedConceptId {rc} not in {cid}")
        ch["examConnections"] = xcs
        ch["whatIfs"] = wis
        total_xc += len(xcs)
        total_wi += len(wis)

    PACK.write_text(json.dumps(pack, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(f"Injected {total_xc} examConnections + {total_wi} whatIfs across {len(pack['chapters'])} Maths chapters.")


if __name__ == "__main__":
    main()
