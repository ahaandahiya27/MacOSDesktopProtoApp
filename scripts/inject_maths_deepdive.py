#!/usr/bin/env python3
"""P1-A — add `deepDive: [StretchTopic]` arrays to every Maths chapter.

The Maths pack (`maths_class7.json`, NEP Ganita Prakash Grade 7) shipped with
zero deepDive entries, which blocked the v6 Olympiad ladder (Phase 5) and
capped the adaptive journey's difficulty (Phase 3) for Maths. This script adds
3 PDF-faithful StretchTopics per chapter (45 total), each:

  * anchored via `parentConceptId` to a REAL concept id inside that chapter
    (enforced by the mirrored MathsDeepDiveTests + Science contract),
  * tagged class_8…class_12 — a genuine forward extension of the Grade-7 idea,
  * body ≥ 120 words (Science floor is 100), with prerequisite + nextStepHint.

Additive only. Re-runnable (idempotent: overwrites the deepDive key). Writes the
canonical format `json.dumps(d, ensure_ascii=False, indent=2) + "\n"` so
verify_pack_roundtrip.py stays byte-for-byte green.
"""
import json
from pathlib import Path

PACK = Path(__file__).resolve().parent.parent / "desktopAhaan/Subjects/Packs/maths_class7.json"


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
    "ch01": [
        t("mch01_dd01", "Standard form — packing big numbers into powers of ten",
          "class_8", "mch01_t01_c01",
          "A lakh is 1,00,000 and a crore is 1,00,00,000 — but writing all those zeros is clumsy, "
          "and easy to miscount. In Class 8 you learn to write any large number as a single digit-string "
          "times a power of ten: this is standard (scientific) form. One lakh is 1 × 10⁵, because there are "
          "5 zeros; one crore is 1 × 10⁷; an arab is 1 × 10⁹. The exponent simply counts how many places the "
          "1 has been shifted left. The Sun is about 15 crore km from Earth — written compactly that is "
          "1.5 × 10⁸ km, far less error-prone than 15,00,00,000. Scientists, astronomers and computers all "
          "store numbers this way. The Indian comma groups you learned (3-2-2-2) and standard form are two "
          "views of the same place-value idea: one is for reading aloud, the other is for calculating and "
          "comparing magnitudes at a glance.",
          "Tackle this after you are comfortable reading lakhs and crores and counting their zeros.",
          "In Class 9 you extend the same exponent idea to TINY numbers — a hydrogen atom is 5 × 10⁻¹¹ m wide — and learn to multiply and divide numbers written this way."),
        t("mch01_dd02", "Significant figures — how much of a rounded number you can trust",
          "class_9", "mch01_t04_c03",
          "You learned to round to the nearest hundred or thousand because an exact value is often "
          "unnecessary — a stadium holds 'about 50,000', not 49,873. Class 9 sharpens this into significant "
          "figures: the digits in a number that actually carry information. If a city's population is reported "
          "as 32,00,000, the leading 3 and 2 are significant but the trailing zeros may just be place-holders "
          "from rounding. When you measure a desk as 1.20 m, that final zero IS significant — it says you "
          "measured to the centimetre, not just the decimetre. The rule that protects you: a calculated answer "
          "can be no more precise than the roughest measurement that went into it. Multiply a length read to "
          "2 significant figures by one read to 4, and the answer is only good to 2. This is why a calculator "
          "showing 38.715274 km after you rounded the inputs is lying about its own accuracy.",
          "Tackle this once rounding up vs rounding down and 'rounding to a precision' feel automatic.",
          "In Class 11 physics you will use significant-figure rules every time you report a measurement, and meet absolute vs relative error."),
        t("mch01_dd03", "Orders of magnitude — Fermi estimation as a thinking tool",
          "class_11", "mch01_t06_c01",
          "The 'Did You Ever Wonder' estimates — how many breaths in a lifetime, how many tabla beats in a "
          "concert — are your first taste of a method physicists call Fermi estimation, after Enrico Fermi, who "
          "famously estimated the energy of an atomic-bomb blast by watching how far scraps of paper blew. The "
          "trick is to break an impossible-seeming question into a chain of factors you CAN guess, each to the "
          "nearest power of ten (its 'order of magnitude'), then multiply. Errors above and below tend to cancel, "
          "so the final answer is usually right to within a factor of ten — astonishingly good for a back-of-"
          "envelope guess. Thinking in orders of magnitude (is this a 10³ problem or a 10⁶ problem?) is how "
          "scientists sanity-check whether an answer is even plausible before trusting a calculator. It turns "
          "'I have no idea' into 'about a million', which is often all a decision needs.",
          "Tackle this after you can comfortably break an estimate into reasonable assumptions.",
          "In Class 11 you will use the same factor-chaining when you estimate quantities in physics and chemistry, and meet the logarithm — the exact tool for measuring orders of magnitude."),
    ],
    "ch02": [
        t("mch02_dd01", "The distributive law — the engine that becomes algebra",
          "class_8", "mch02_t04_c02",
          "Removing brackets with a(b + c) = ab + ac looks like a small arithmetic convenience, but it is one of "
          "the most powerful laws in mathematics. Run it forwards and you EXPAND: 7 × 23 becomes 7 × 20 + 7 × 3, "
          "which is exactly the mental-maths shortcut you already use. Run it backwards and you FACTORISE: "
          "6x + 9 becomes 3(2x + 3), pulling out the common factor — the move at the heart of all of Class 8 "
          "algebra. The same law multiplies two brackets: (a + b)(c + d) = ac + ad + bc + bd, every term in the "
          "first paired with every term in the second. That single rule generates the famous identities "
          "(a + b)² = a² + 2ab + b² and (a + b)(a − b) = a² − b². So the bracket-removal you do with numbers now "
          "is the literal blueprint for what you will do with letters later — nothing new to learn, just the same "
          "law applied to symbols.",
          "Tackle this once you can confidently remove brackets after a + or − sign.",
          "In Class 8 you apply this law to letter-numbers to expand and factorise expressions, the foundation of all later algebra."),
        t("mch02_dd02", "From BODMAS to indices — where exponents sit in the order",
          "class_8", "mch02_t02_c01",
          "You learned that 30 + 5 × 4 is 50, not 140, because multiplication is evaluated before addition — the "
          "order of operations. Class 8 adds a new operation, the exponent (power), and slots it into the order: "
          "you handle Brackets first, then Orders (powers and roots), then Division and Multiplication, then "
          "Addition and Subtraction — the 'O' in BODMAS. So 2 + 3² × 4 means 'square the 3 first': 2 + 9 × 4 = "
          "2 + 36 = 38. Powers bind tighter than multiplication because a power is just repeated multiplication, "
          "and that repeated block has to be resolved before it can be multiplied by anything else. Calculators "
          "and spreadsheets follow exactly this hierarchy, which is why typing 2+3^2*4 gives 38, not 100. Knowing "
          "WHERE each operation sits in the pecking order — not just memorising the word BODMAS — is what stops "
          "the most common arithmetic slips.",
          "Tackle this after you are comfortable with why order of operations matters and how brackets override it.",
          "In Class 8 you will simplify algebraic expressions containing powers, where this ordering decides the answer every time."),
        t("mch02_dd03", "When swapping is not allowed — non-commutative operations",
          "class_9", "mch02_t03_c01",
          "You found that addition and multiplication are commutative — 3 + 5 = 5 + 3, and 3 × 5 = 5 × 3 — so you "
          "may swap terms freely. But this is a PRIVILEGE of those two operations, not a universal truth. "
          "Subtraction breaks it: 7 − 2 = 5 but 2 − 7 = −5. Division breaks it too: 8 ÷ 2 = 4 but 2 ÷ 8 = 0.25. "
          "Recognising exactly which operations let you swap, and which do not, is what keeps you from rearranging "
          "an expression into a different value by accident. As you climb higher, you meet whole worlds of "
          "operations where order is everything: rotating a book 90° then flipping it lands it differently from "
          "flipping then rotating, and the matrices of Class 12 multiply in a way where AB and BA are usually "
          "different objects. The lesson that starts here is precise: never assume an operation is commutative — "
          "check, because most are not.",
          "Tackle this once the commutative and associative properties of + and × feel natural.",
          "In Class 12 you meet matrix multiplication, the classic operation where AB ≠ BA, and the order of steps changes the result."),
    ],
    "ch03": [
        t("mch03_dd01", "Why some fractions give neat decimals and others never end",
          "class_8", "mch03_t03_c01",
          "Splitting a unit into tenths and hundredths lets you write 1/2 as 0.5 and 1/4 as 0.25 — clean, "
          "terminating decimals. But try 1/3 and the division never stops: 0.3333… forever. Why the difference? "
          "Because our decimal system is built on tens, and ten factorises as 2 × 5. A fraction terminates exactly "
          "when its denominator (in lowest terms) is built only from the primes 2 and 5 — then you can rewrite it "
          "over 10, 100 or 1000. 1/8 works (8 = 2³, and 1/8 = 125/1000 = 0.125); 1/3 and 1/7 cannot, because 3 and "
          "7 are not factors of any power of ten, so their decimals repeat in a block forever. This single test — "
          "look at the prime factors of the denominator — predicts in advance whether a fraction will terminate, "
          "without doing any division at all. It is your first glimpse that the 'shape' of a decimal is decided by "
          "the primes hiding inside it.",
          "Tackle this once you understand tenths, hundredths, and decimal place value.",
          "In Class 9 you classify these repeating decimals as rational numbers and meet irrationals like √2, whose decimals never repeat at all."),
        t("mch03_dd02", "Filling the gaps — from decimals to the real number line",
          "class_9", "mch03_t04_c01",
          "Locating 0.7 or 2.45 on the number line makes it feel as if decimals fill every gap between the whole "
          "numbers. Class 9 reveals a surprise: they do not. Every decimal you can write — even an endlessly "
          "repeating one like 0.333… — is a RATIONAL number, expressible as a fraction. Yet there are points on "
          "the line, like √2 (the length of a diagonal of a unit square, about 1.41421356…), whose decimal never "
          "terminates AND never repeats. These are the irrational numbers, and there are infinitely many of them "
          "hiding between the rationals. Together, rationals and irrationals form the real number line — truly "
          "gap-free at last. The number line you have been marking decimals on since Class 6 turns out to be far "
          "richer than it looked: between any two decimals, no matter how close, lurk infinitely many numbers that "
          "no decimal can ever fully capture.",
          "Tackle this once you can confidently locate and order decimals on the number line.",
          "In Class 9 and 10 you learn to represent irrationals like √2 and √3 exactly on the line using compass constructions, and to do arithmetic with them."),
        t("mch03_dd03", "Trailing zeros, leading zeros, and what a digit's place really means",
          "class_8", "mch03_t04_c02",
          "The 'zero dilemma' — knowing that 0.5, 0.50 and 0.500 are the same value while 0.05 is ten times "
          "smaller — rests on one idea: a digit's worth comes entirely from its PLACE, not its shape. A trailing "
          "zero after the decimal point adds no value because it sits in an ever-smaller place that the number "
          "had already filled with nothing. But a zero BETWEEN the point and a non-zero digit, as in 0.05, is a "
          "genuine place-holder: it pushes the 5 one column further right, dividing its value by ten. This is "
          "exactly the same logic that distinguishes 502 from 52 in whole numbers — the internal zero holds the "
          "5 in the hundreds place. Mastering which zeros matter and which do not is what lets you line up "
          "decimal points correctly when adding, and later lets you write tiny measurements in standard form, "
          "where 0.000 05 becomes a tidy 5 × 10⁻⁵.",
          "Tackle this once comparing decimals and aligning the point for addition feel reliable.",
          "In Class 9 you extend standard form to small numbers, where counting these place-holding zeros gives the negative exponent."),
    ],
    "ch04": [
        t("mch04_dd01", "From a pattern to an identity — algebra that is always true",
          "class_8", "mch04_t03_c02",
          "Using a letter-number to capture a pattern — writing the n-th matchstick figure as 3n + 1, say — is the "
          "leap from arithmetic to algebra. Class 8 takes the next step: some expressions are equal for EVERY "
          "value of the letter, and these are called identities. The most famous is (a + b)² = a² + 2ab + b². It "
          "is not an equation you solve for a special a and b; it is true whether they are 2 and 3, 10 and 7, or "
          "any numbers at all. You can SEE why with a square of side (a + b): it splits into an a×a square, a "
          "b×b square, and two a×b rectangles — area a² + b² + 2ab. The letter-numbers let you prove the pattern "
          "holds in general, not just check it on a few examples. That is the real power of algebra over "
          "arithmetic: one symbolic statement settles infinitely many numerical cases at once.",
          "Tackle this after you can use letter-numbers to express and justify a number pattern.",
          "In Class 8 and 9 you use these identities to expand and factorise quickly, and to simplify otherwise messy calculations like 102²."),
        t("mch04_dd02", "Like terms grow up into polynomials",
          "class_8", "mch04_t03_c01",
          "Collecting like terms — turning 2a + 5 + 3a into 5a + 5 — is the housekeeping rule of algebra: you may "
          "only add things that count the same kind of object. Class 8 organises these expressions into "
          "polynomials and names their parts. In 5a + 5, the 5 multiplying the a is the coefficient, and the "
          "lone 5 is the constant term. Add a squared term and you get 3a² + 5a + 5, a quadratic; the highest "
          "power present is the polynomial's degree. The like-terms rule scales up cleanly: a² terms combine only "
          "with other a² terms, a terms only with other a terms — each power keeps its own column, exactly like "
          "place value keeps tens apart from units. So the tidying you do now is the same move that will let you "
          "add, subtract and eventually multiply whole polynomials without ever mixing incompatible terms.",
          "Tackle this once collecting like terms in simple expressions is automatic.",
          "In Class 9 you add, subtract and multiply polynomials and use the degree to predict how many solutions an equation can have."),
        t("mch04_dd03", "A formula is a function — the machine behind the letters",
          "class_9", "mch04_t01_c02",
          "A formula such as 'her age = his age + 3', or the perimeter P = 4s of a square, does something subtle: "
          "feed in one number and exactly one number comes out. Class 9 gives this idea a name — a function — and "
          "a notation. Instead of P = 4s we may write f(s) = 4s, read 'f of s', a little machine that quadruples "
          "whatever you drop in: f(2) = 8, f(10) = 40. The letter-number s is the INPUT and f(s) the OUTPUT, and "
          "'substituting a value', which you do now by hand, is precisely the act of running the machine once. "
          "Seeing a formula as a function lets you ask new questions: how does the output change as the input "
          "grows? Plot input against output and the square's perimeter formula traces a straight line — your "
          "first graph of a function. The substitution skill you build here is the doorway to all of it.",
          "Tackle this once dropping the × sign and substituting values into a formula feel routine.",
          "In Class 9 and 10 you plot functions as graphs, and in Class 11 functions become the central object of all higher mathematics."),
    ],
    "ch05": [
        t("mch05_dd01", "Euclid's stubborn fifth postulate — and the geometries it hides",
          "class_9", "mch05_t02_c02",
          "Two lines in a plane are parallel when they never meet, however far you extend them. That sounds "
          "obvious, but it conceals the single most debated statement in the history of mathematics. Around "
          "300 BCE, Euclid built all of geometry from five starting assumptions (postulates). Four were simple "
          "and undeniable; the fifth — that through a point not on a line, exactly ONE parallel can be drawn — "
          "felt too complicated to be a mere assumption. For over 2000 years mathematicians tried to PROVE it "
          "from the other four, and every attempt failed. In the 1800s Lobachevsky and Riemann finally asked: "
          "what if it is simply false? Allowing MANY parallels through the point, or NONE, produces strange but "
          "perfectly consistent 'non-Euclidean' geometries — the very geometry Einstein later used to describe "
          "curved spacetime and gravity. The flat-paper parallels you study now are one valid choice among "
          "several, not the only possible world.",
          "Tackle this once you are confident about what makes two lines parallel and what a transversal is.",
          "In Class 9 you use Euclid's axioms and postulates to write formal geometric proofs for the first time."),
        t("mch05_dd02", "Why every triangle's angles add to 180° — proved with parallels",
          "class_9", "mch05_t04_c01",
          "Alternate angles on a transversal are equal — that single fact, which you verify by folding paper, is "
          "strong enough to prove the most famous theorem about triangles: the three angles inside ANY triangle "
          "add up to a straight angle, 180°. Here is the classic argument. Take a triangle and draw a line "
          "through its top vertex parallel to the base. The base and this new line are now two parallels cut by "
          "the triangle's two slanted sides, which act as transversals. So the two 'outer' angles at the top "
          "vertex equal the two base angles, as alternate angles. But those three angles at the top — left outer, "
          "the triangle's own apex angle, and right outer — sit on a straight line, so they total 180°. Therefore "
          "the triangle's three interior angles do too. No measuring, no special triangle: the parallel-line "
          "angle rules force it for every triangle at once.",
          "Tackle this after alternate and co-interior angles on a transversal are clear.",
          "In Class 9 you prove this and the exterior-angle theorem formally, and use them to find unknown angles in complex figures."),
        t("mch05_dd03", "Parallel and perpendicular, measured by slope",
          "class_10", "mch05_t02_c01",
          "On plain paper you tell parallel lines apart from perpendicular ones by eye. Class 10 coordinate "
          "geometry turns that judgement into arithmetic by giving every line a number called its slope (or "
          "gradient) — how many units it rises for each unit it runs. Two lines are parallel exactly when their "
          "slopes are EQUAL: they climb at the same rate, so they never converge. Two lines are perpendicular "
          "exactly when their slopes multiply to −1 — one climbs as steeply as the other descends, the "
          "negative-reciprocal relationship (a line of slope 2 is perpendicular to one of slope −½). Suddenly "
          "'parallel' and 'perpendicular', which felt like things you could only see, become things you can "
          "CALCULATE from two points, with no diagram at all. This is the great gift of coordinate geometry: it "
          "translates pictures into equations you can test exactly.",
          "Tackle this once perpendicular and parallel lines are clear as pictures.",
          "In Class 10 you write the equation of a line from its slope and a point, and decide whether two given lines meet, never meet, or cross at right angles."),
    ],
    "ch06": [
        t("mch06_dd01", "Parity as an invariant — proving something can NEVER happen",
          "class_9", "mch06_t02_c02",
          "You used parity to argue that five odd numbers can never add to 30 — an even target — because odd + odd "
          "+ odd + odd + odd is always odd. This is your first INVARIANT argument: a quantity that some process "
          "can never change, used to prove an outcome is impossible. The idea is astonishingly powerful. Cover a "
          "chessboard with dominoes, each covering one black and one white square; now cut off two opposite "
          "corners, which are the same colour. Can the 62 remaining squares be tiled? No — because every domino "
          "must cover one of each colour, but you have removed two of the SAME colour, breaking the balance "
          "forever. No amount of clever arranging can fix a parity mismatch. The famous 15-puzzle has positions "
          "you simply cannot reach, for exactly this reason. Spotting a quantity that stays fixed — its parity, "
          "or a sum, or a colouring — is one of a mathematician's sharpest tools for proving 'this is impossible' "
          "without checking every case.",
          "Tackle this once you can use parity to explain why certain sums are forced to be even or odd.",
          "In Class 9 and in olympiad mathematics, invariant and colouring arguments become a standard technique for impossibility proofs."),
        t("mch06_dd02", "Virahāṅka, Fibonacci, and the golden ratio hidden in the sequence",
          "class_11", "mch06_t03_c01",
          "The sequence 1, 1, 2, 3, 5, 8, 13, 21… — which Virahāṅka found counting rhythms in Sanskrit poetry "
          "centuries before Fibonacci met it counting rabbits — hides a remarkable secret. Divide each term by "
          "the one before it: 2/1 = 2, 3/2 = 1.5, 5/3 ≈ 1.667, 8/5 = 1.6, 13/8 = 1.625, 21/13 ≈ 1.615… The "
          "ratios close in on a single never-ending number, φ ≈ 1.6180339…, the golden ratio. It is the unique "
          "number that satisfies φ² = φ + 1 — the very rule the sequence itself obeys (each term is the sum of "
          "the two before). This ratio appears in the spiral of a sunflower's seeds, the arrangement of leaves "
          "that lets each catch the most light, and the proportions artists have long called pleasing. A pattern "
          "that began as a way to count poetic metres turns out to encode a constant woven through living "
          "things.",
          "Tackle this once you can generate the Virahāṅka–Fibonacci numbers by adding the previous two.",
          "In Class 11 you study sequences and series formally and meet the closed-form (Binet's) formula that produces any Fibonacci number directly from φ."),
        t("mch06_dd03", "Cryptarithms and the secret arithmetic of remainders",
          "class_8", "mch06_t04_c01",
          "Cryptarithms like SEND + MORE = MONEY, where each letter is a hidden digit, are solved not by guessing "
          "but by reasoning about carries and last digits — and that reasoning is the beginning of modular "
          "arithmetic, the maths of remainders. When you argue 'the units column ends in Y, so D + E and Y must "
          "leave the same remainder when divided by 10', you are working 'mod 10'. This clock-style arithmetic, "
          "where numbers wrap around after a fixed point, explains the divisibility rules you already use: a "
          "number is divisible by 9 exactly when its digit-sum is, because 10 leaves remainder 1 when divided by "
          "9, so every digit contributes just its own value to the remainder. The same idea tells you what day "
          "of the week a date falls on (mod 7) and underlies the check-digits that catch typos in bank account "
          "and Aadhaar numbers. Puzzle-solving with digits is a friendly door into a deep and useful theory.",
          "Tackle this once you can solve a simple cryptarithm by tracking the units digit and carries.",
          "In higher classes and computer science, modular arithmetic (clock arithmetic) underpins divisibility tests, calendars, and the cryptography that secures online payments."),
    ],
    "ch07": [
        t("mch07_dd01", "The triangle inequality says the straight path is shortest",
          "class_9", "mch07_t02_c01",
          "The rule that two sides of a triangle must together exceed the third — so 3 cm, 4 cm and 9 cm can "
          "never form a triangle — is more than a construction check. Read it as a statement about TRAVEL: going "
          "from A to C directly (one side) is always shorter than detouring through B (the other two sides), "
          "because if the direct path were longer, no triangle could close. This 'triangle inequality' is the "
          "defining property of distance itself, in any setting where 'distance' makes sense — straight-line "
          "geometry, the grid of city blocks, even the 'distance' between two strings of text that spell-checkers "
          "use. Mathematicians build the whole idea of a metric space on it. There is also a converse worth "
          "knowing: when one side is exactly equal to the sum of the other two, the three points have collapsed "
          "onto a single straight line — the triangle has flattened to nothing. The familiar shortcut 'cut "
          "across the corner' is this theorem in everyday clothes.",
          "Tackle this once you can test three lengths to see whether they form a triangle.",
          "In Class 10 and beyond, the triangle inequality is a basic tool in coordinate geometry and in defining distance in any number of dimensions."),
        t("mch07_dd02", "Right-angled triangles and the theorem of Pythagoras",
          "class_10", "mch07_t04_c01",
          "Classifying triangles by their angles gives you the right-angled triangle — one angle exactly 90°. "
          "This special shape obeys the most famous relation in geometry, known in India as the Bhaskara/"
          "Baudhāyana result and in the West as Pythagoras' theorem: the square on the longest side (the "
          "hypotenuse, opposite the right angle) equals the sum of the squares on the other two sides, "
          "a² + b² = c². So a triangle with legs 3 and 4 has hypotenuse 5, because 9 + 16 = 25. This single "
          "equation lets you find a distance you cannot measure directly — the height of a kite from its string "
          "length and ground distance, or the straight-line gap between two points on a map from their across-"
          "and-up separations. Reversed, it even TESTS for a right angle: if the three sides satisfy "
          "a² + b² = c², the triangle must be right-angled. Builders use this with a 3-4-5 rope to lay perfect "
          "corners.",
          "Tackle this once you can classify triangles by their angles and identify a right angle.",
          "In Class 10 you prove this theorem and use it constantly in coordinate geometry to compute the distance between two points."),
        t("mch07_dd03", "Altitudes, medians, and the triangle's special centres",
          "class_9", "mch07_t03_c02",
          "An altitude is the perpendicular dropped from a vertex to the opposite side — the triangle's 'height' "
          "for that base. A striking fact, not at all obvious, is that all three altitudes of a triangle pass "
          "through a single common point, called the orthocentre. The triangle has a whole family of such "
          "special lines, and each family meets at one point: the three medians (each joining a vertex to the "
          "midpoint of the opposite side) cross at the centroid, the triangle's balance point — cut a cardboard "
          "triangle out and it will balance on a pin placed there. The three perpendicular bisectors of the "
          "sides meet at the circumcentre, the centre of the circle passing through all three corners. That so "
          "many triple-line crossings land exactly on one point each, every time, is a piece of hidden order; "
          "remarkably, the orthocentre, centroid and circumcentre always lie on one straight line, the Euler "
          "line.",
          "Tackle this once you can construct a triangle and drop an altitude from a vertex.",
          "In Class 9 and 10 you prove these concurrency results and use the centroid and circumcentre in coordinate geometry."),
    ],
    "ch08": [
        t("mch08_dd01", "Fractions complete into the rational numbers",
          "class_8", "mch08_t03_c01",
          "You now multiply and divide positive fractions fluently. Class 8 stretches the system in a new "
          "direction: NEGATIVE fractions, giving the full set of rational numbers — every number that can be "
          "written as one integer over another, like −3/4 or 7/2. The arithmetic rules you have learned carry "
          "over unchanged; you simply also track signs. The pay-off is closure: within the rationals you may "
          "add, subtract, multiply and divide (except by zero) and the answer is ALWAYS another rational — "
          "something the whole numbers and integers could not promise (3 ÷ 4 escapes the integers). On the "
          "number line the rationals are packed infinitely densely: between any two of them, however close, lies "
          "another, found just by averaging the two. This is the number system in which most everyday "
          "calculation lives, and dividing by a fraction — your reciprocal rule — is one of the operations that "
          "makes it self-contained.",
          "Tackle this once dividing by a fraction by multiplying by its reciprocal is automatic.",
          "In Class 9 you place rationals alongside irrationals to build the real numbers, and prove the rationals are 'dense' on the line."),
        t("mch08_dd02", "'Of' means multiply — the bridge to percentages and ratios",
          "class_8", "mch08_t02_c01",
          "Reading 'one-half OF two-thirds' as ½ × ⅔ is a small phrase with enormous reach. A percentage is "
          "nothing but a fraction with denominator 100, so '20% of 350' is just 20/100 × 350 = 70 — the very "
          "same 'of-means-multiply' move. This single idea powers a huge share of real-world arithmetic: a 15% "
          "discount, 18% GST added to a bill, simple interest on a loan, the concentration of a salt solution. "
          "It also chains: a shirt marked down 20%, then a further 10% off the reduced price, is 0.90 × 0.80 = "
          "0.72 of the original — a 28% cut, not 30%, because the second discount acts on the smaller amount. "
          "Mistaking which whole a percentage is taken 'of' is the single commonest money error people make. "
          "Master 'of means multiply' with fractions now and percentages later become almost nothing new.",
          "Tackle this once 'fraction of a fraction' as multiplication feels natural.",
          "In Class 8 you formalise percentages, profit and loss, and simple interest — all built on this one rule."),
        t("mch08_dd03", "Unit fractions and the Egyptian way of dividing",
          "class_10", "mch08_t01_c01",
          "Multiplying a fraction by a whole number, like 5 × 1/4, rests on the idea of a unit fraction — a "
          "fraction with 1 on top, the simplest kind. Ancient Egyptian mathematicians, in the Rhind papyrus over "
          "3500 years ago, wrote EVERY fraction as a sum of distinct unit fractions: 3/4 as 1/2 + 1/4, and 2/7 "
          "as 1/4 + 1/28. This was not mere quirkiness — it made sharing practical. To split 3 loaves among 4 "
          "people, the 1/2 + 1/4 form tells each person to take half a loaf and a quarter, an actual cutting "
          "plan, whereas '3/4 each' does not. Remarkably, every fraction can be written this way, and a simple "
          "greedy method (always subtract the largest unit fraction that fits) always works, a fact only fully "
          "proved in modern times. So the humble unit fraction you meet here was, for thousands of years, the "
          "foundation of all fraction arithmetic.",
          "Tackle this once multiplying a unit fraction by a whole number is clear.",
          "These 'Egyptian fractions' connect to number theory and to the study of greedy algorithms in higher mathematics and computer science."),
    ],
    "ch09": [
        t("mch09_dd01", "Why SSS, SAS and ASA work — and why SSA does not",
          "class_9", "mch09_t02_c01",
          "The congruence criteria say you don't need all six measurements (3 sides, 3 angles) to pin a triangle "
          "down — just the right THREE. SSS, SAS, ASA and RHS each fix a triangle's shape and size completely, "
          "so any two triangles sharing one of these sets must be identical copies. But notice the dog that "
          "doesn't bark: SSA — two sides and a non-included angle — is NOT on the list, and for a sharp reason. "
          "Given two sides and an angle that is not between them, you can often swing the second side to land in "
          "TWO different places, producing two genuinely different triangles. This 'ambiguous case' is exactly "
          "why SSA is rejected: it fails to determine the triangle uniquely. Understanding which triples work and "
          "which fail is not memorisation — it is about how much information is just enough to remove all freedom "
          "from the figure, the heart of geometric proof.",
          "Tackle this once you know the SSS, SAS, ASA and RHS criteria by name.",
          "In Class 9 you write two-column congruence proofs, and in Class 10 the ambiguous SSA case reappears as the sine-rule's two solutions."),
        t("mch09_dd02", "Same shape, different size — congruence grows into similarity",
          "class_10", "mch09_t01_c01",
          "Congruent figures are exact copies: same shape AND same size. Class 10 keeps the 'same shape' but "
          "relaxes 'same size' to give SIMILAR figures — like a photo and its enlargement. In similar triangles, "
          "corresponding angles are equal and corresponding sides are in a constant ratio, the scale factor. "
          "This is far more useful than it first sounds: it is how you measure the unreachable. Hold a ruler at "
          "arm's length to find a building's height, read a map's scale to get a real distance, or work out the "
          "width of a river from the shore — all use similar triangles to turn a measurable small triangle into "
          "an unmeasurable large one sharing its angles. Congruence is the special case where the scale factor "
          "is exactly 1. So the 'exact copy' idea you study now is one rung of a ladder; loosening it to "
          "'proportional copy' unlocks indirect measurement of the whole world.",
          "Tackle this once you are comfortable with congruent figures as exact copies.",
          "In Class 10 you prove similarity criteria (AA, SSS, SAS) and use them, with trigonometry, to find heights and distances."),
        t("mch09_dd03", "Equal sides face equal angles — the isosceles theorem and its converse",
          "class_9", "mch09_t03_c01",
          "You observed that an isosceles triangle's two equal sides face two equal angles, and that an "
          "equilateral triangle, with all sides equal, has all three angles equal — necessarily 60° each, since "
          "they share 180°. Class 9 proves this and, just as importantly, its CONVERSE: if two ANGLES of a "
          "triangle are equal, then the sides facing them are equal too. A statement and its converse are "
          "different claims and each needs its own proof — a lesson that runs through all of mathematics. The "
          "elegant proof of the isosceles theorem folds the triangle along the bisector of its apex angle, "
          "matching the two halves by SAS congruence so the base angles must coincide. This 'equal sides ↔ equal "
          "angles' equivalence is a workhorse: it lets you deduce unknown angles from a single tick-mark on the "
          "sides, or unknown side-lengths from matching angles, in countless later proofs.",
          "Tackle this once you accept that equal sides face equal angles and equilateral angles are 60°.",
          "In Class 9 you prove both the theorem and its converse formally and use them throughout your geometry problems."),
    ],
    "ch10": [
        t("mch10_dd01", "Why integers needed inventing — closure under subtraction",
          "class_8", "mch10_t01_c02",
          "Integer addition has tidy properties — it is commutative, associative, and 0 leaves a number "
          "unchanged. But the deepest reason integers exist at all is closure under subtraction. Among the whole "
          "numbers, 3 − 7 has no answer; the operation 'falls off the edge' of the system. Extending to the "
          "negatives fixes this: now EVERY subtraction has a result, because subtracting is just adding the "
          "opposite, and every integer has an opposite. Mathematicians describe this by saying the integers are "
          "'closed' under subtraction. This is the same engine driving every expansion of number systems you "
          "meet: whole numbers couldn't always divide, so fractions were born; rationals couldn't measure a "
          "square's diagonal, so the reals arrived; reals couldn't square-root a negative, so the complex numbers "
          "of Class 11 followed. Each new system is invented to make some operation always work. The integers are "
          "the first chapter of that long, recurring story.",
          "Tackle this once the properties of integer addition and 'subtract = add the opposite' are clear.",
          "In Class 8 you see the same closure idea drive the rational numbers, and in Class 11 the complex numbers."),
        t("mch10_dd02", "Why a negative times a negative is positive — the proof",
          "class_8", "mch10_t02_c01",
          "The sign rule (−) × (−) = (+) is easy to memorise and famously hard to believe. It is not an arbitrary "
          "decree — it is FORCED by insisting that the distributive law keep working. Watch: we know "
          "(−3) × 0 = 0. Now write 0 as (5 + (−5)), so (−3) × (5 + (−5)) = 0. Distribute: "
          "(−3)×5 + (−3)×(−5) = 0, which is (−15) + (−3)×(−5) = 0. For this to balance, (−3)×(−5) MUST equal "
          "+15 — nothing else makes the sum zero. So 'two negatives make a positive' is the only choice that "
          "lets the laws of arithmetic stay consistent. A homelier picture: removing (×) a debt (−) repeatedly "
          "leaves you richer (+). Seeing that the rule is compelled, not invented, is a first taste of how "
          "mathematicians extend definitions: you keep the old laws and let them dictate the new cases.",
          "Tackle this once you can apply the sign rules for multiplying integers.",
          "In Class 8 this same reasoning extends to multiplying and dividing negative rationals; in algebra it guarantees that expanding brackets never breaks."),
        t("mch10_dd03", "From one number line to the coordinate plane",
          "class_9", "mch10_t01_c01",
          "Adding integers lives on a single number line, where direction encodes sign — right for positive, left "
          "for negative. Class 9 crosses TWO such lines at right angles, one horizontal and one vertical, to "
          "build the coordinate (Cartesian) plane named after René Descartes. Now every point is pinned by an "
          "ordered pair (x, y), and the signs you mastered with integers tell you exactly which of the four "
          "regions, or quadrants, a point lives in: (+, +) top-right, (−, +) top-left, (−, −) bottom-left, "
          "(+, −) bottom-right. This single idea — locating points by signed numbers — is what fuses algebra and "
          "geometry into coordinate geometry, lets a straight line become an equation, and underlies every graph, "
          "map grid, and pixel address on a screen. The signed number line you add on today is one axis of the "
          "plane on which all later graphing is drawn.",
          "Tackle this once adding integers with same and opposite signs feels natural on the number line.",
          "In Class 9 you plot points and lines in all four quadrants, the foundation of coordinate geometry and graphing."),
    ],
    "ch11": [
        t("mch11_dd01", "Euclid's algorithm — finding the HCF without listing factors",
          "class_10", "mch11_t01_c01",
          "Listing all the factors of two numbers to spot their highest common factor is fine for 12 and 16, but "
          "hopeless for 1794 and 2346. Over 2000 years ago Euclid gave a method that needs no factor lists at "
          "all, and it is still one of the fastest algorithms known. The idea: the HCF of two numbers also "
          "divides their difference, so you may repeatedly REPLACE the larger number by its remainder on "
          "division by the smaller, shrinking the pair until one becomes zero — the other is then the HCF. For "
          "1794 and 2346: 2346 = 1×1794 + 552; then 1794 = 3×552 + 138; then 552 = 4×138 + 0, so the HCF is 138, "
          "found in three quick steps. Because each step shrinks the numbers fast, even huge inputs finish "
          "quickly — which is why Euclid's algorithm runs inside the cryptography that protects online banking "
          "today. A 2000-year-old trick still guards your money.",
          "Tackle this once you can find the HCF of small numbers by listing common factors.",
          "In Class 10 you formalise Euclid's division algorithm and use it to prove the Fundamental Theorem of Arithmetic."),
        t("mch11_dd02", "The Fundamental Theorem of Arithmetic — primes are the atoms of number",
          "class_10", "mch11_t03_c01",
          "Prime factorisation feels like a routine tool for finding HCF and LCM, but it rests on a profound "
          "guarantee called the Fundamental Theorem of Arithmetic: every whole number greater than 1 can be "
          "written as a product of primes in EXACTLY ONE way, apart from the order of the factors. So 60 is "
          "always 2² × 3 × 5 — there is no second, different prime recipe for it, ever. Primes are therefore the "
          "indivisible 'atoms' from which all numbers are built, and this uniqueness is what makes the HCF (the "
          "primes two numbers share) and the LCM (all primes between them, at their highest powers) well defined "
          "in the first place. It also explains the neat identity HCF(a,b) × LCM(a,b) = a × b: between them, the "
          "HCF and LCM use up each prime exactly as many times as a and b together do. This quiet theorem is the "
          "bedrock under almost all of number theory.",
          "Tackle this once you can factorise a number into primes and use it for HCF and LCM.",
          "In Class 10 you prove √2 is irrational using this theorem, and it underpins all later work in number theory."),
        t("mch11_dd03", "Where LCM hides — adding fractions and meeting cycles",
          "class_8", "mch11_t02_c01",
          "The least common multiple looks like a stand-alone topic, but you have been using it for years without "
          "the name: it is exactly the lowest common denominator you reach for when adding unlike fractions. To "
          "add 1/6 + 1/4 you rewrite both over 12 — the LCM of 6 and 4 — because 12 is the smallest number both "
          "sixths and quarters divide into evenly. The LCM also answers every 'when do cycles line up?' question. "
          "If one bus leaves every 6 minutes and another every 8, both depart together every 24 minutes — "
          "LCM(6, 8). Planets returning to the same alignment, two blinking lights flashing in unison, gear teeth "
          "meeting again — all are LCM problems in disguise. Pairing this with the HCF×LCM = product rule lets "
          "you find one from the other instantly. So LCM is less a new idea than a name for a pattern you already "
          "rely on whenever quantities must synchronise.",
          "Tackle this once you can find the LCM of two numbers by listing multiples or using primes.",
          "In Class 8 you use the LCM constantly to add and subtract unlike fractions and rational expressions."),
    ],
    "ch12": [
        t("mch12_dd01", "Multiplying powers of ten — the rule behind shifting the point",
          "class_8", "mch12_t01_c02",
          "Multiplying a decimal by 10, 100 or 1000 shifts the point right; dividing shifts it left. Class 8 "
          "reveals the law underneath: when you multiply powers of ten you ADD their exponents, and when you "
          "divide you SUBTRACT them. So 10² × 10³ = 10⁵, and 10⁵ ÷ 10² = 10³ — and 'shifting the decimal point "
          "n places' is just multiplying by 10ⁿ. This unifies a string of separate tricks into one idea and, "
          "combined with standard form, makes giant and tiny numbers easy to multiply. To find how far light "
          "travels in a year, multiply its speed 3 × 10⁸ m/s by the 3 × 10⁷ seconds in a year: multiply the "
          "fronts (3 × 3 = 9) and ADD the exponents (8 + 7 = 15) to get 9 × 10¹⁵ m — a calculation that would be "
          "a nightmare with all the zeros written out. The point-shifting you do now is exponent arithmetic "
          "wearing everyday clothes.",
          "Tackle this once multiplying and dividing decimals by powers of ten by shifting the point is automatic.",
          "In Class 8 you state the laws of exponents in full and apply them to multiply numbers in standard form."),
        t("mch12_dd02", "Turning a repeating decimal back into a fraction",
          "class_9", "mch12_t02_c01",
          "Dividing decimals sometimes produces an answer that never stops repeating, such as 1 ÷ 3 = 0.333… or "
          "1 ÷ 11 = 0.0909… Class 9 shows the surprising reverse skill: every such repeating decimal can be "
          "converted back into an exact fraction with a neat algebra trick. Let x = 0.7777…; multiply by 10 to "
          "get 10x = 7.7777…; subtract the first line from the second and the endless tails cancel perfectly, "
          "leaving 9x = 7, so x = 7/9 — exactly. (If two digits repeat, multiply by 100 instead.) This proves "
          "something deep: every repeating decimal is rational, a ratio of two integers. It even settles the "
          "famous puzzle 0.9999… = 1, since the same method gives 9x = 9, so x = 1 — the two are genuinely the "
          "same number, just written differently. The 'messy' decimals that division throws up are not mysterious "
          "at all; they are fractions in disguise.",
          "Tackle this once you can carry out decimal division that yields a repeating block.",
          "In Class 9 this confirms which numbers are rational and sharpens the boundary with the irrationals."),
        t("mch12_dd03", "Estimation as error control — how rough inputs limit a precise answer",
          "class_8", "mch12_t03_c01",
          "Estimating before you compute is sold as a way to place the decimal point — '4.8 × 21 is about 100, so "
          "the answer near 100.8 is sensible'. But the deeper purpose is controlling error. Every measurement "
          "carries uncertainty: a length read as 4.8 cm really means 'somewhere between 4.75 and 4.85'. When you "
          "multiply two such rough numbers, the uncertainties combine, and the answer cannot honestly be more "
          "precise than its least precise input. So reporting 4.8 × 2.1 as 10.08 cm² fakes a precision the data "
          "never had — 10 cm² is the honest claim. Estimating the size and the likely spread of an answer first "
          "is how scientists and engineers avoid being fooled by a calculator's long decimal tail. The habit you "
          "build here, of asking 'roughly how big, and how sure?' before trusting a digit, is exactly the "
          "discipline of significant figures and error analysis in senior science.",
          "Tackle this once you can estimate a decimal product to check where the point belongs.",
          "In Class 11 physics this becomes the formal study of significant figures, absolute error, and propagation of uncertainty."),
    ],
    "ch13": [
        t("mch13_dd01", "Mean, median or mode — choosing the average that tells the truth",
          "class_9", "mch13_t02_c01",
          "Mean, median and mode are three different 'representative values', and the gap between them is where "
          "statistics gets interesting — and where it gets misused. The mean (arithmetic average) uses every "
          "value but is dragged around by extremes: put one billionaire in a room of ten people and the MEAN "
          "income suggests everyone is rich, while the MEDIAN — the middle value, blind to how large the outlier "
          "is — still reports the ordinary person honestly. That is why 'average income' figures usually quote "
          "the median, and why a cricketer's batting can look strong on the mean yet inconsistent once you notice "
          "the median is far lower. The mode (most frequent value) is the one to use for shoe sizes a shop should "
          "stock, where 'typical' means 'most common', not 'middle'. Knowing which average suits which question — "
          "and spotting when someone has picked the flattering one — is a genuine life skill, not just an exam "
          "topic.",
          "Tackle this once you can compute the mean, median and mode of a small data set.",
          "In Class 9 and 10 you study these measures of central tendency for grouped data and learn when each is appropriate."),
        t("mch13_dd02", "Beyond range — standard deviation measures real spread",
          "class_11", "mch13_t02_c02",
          "Range — the gap between the largest and smallest value — is your first measure of spread, but it is "
          "fragile: it depends only on the two most extreme readings and ignores everything in between, so a "
          "single freak value can blow it up. Two cricketers could have the same range yet utterly different "
          "consistency. Senior statistics fixes this with the standard deviation, which asks how far EVERY value "
          "sits from the mean, on average. You measure each value's distance from the mean, square those "
          "distances (so overs and unders don't cancel), average them, and take the square root to return to the "
          "original units. A small standard deviation means the data huddle near the mean (the consistent "
          "batsman); a large one means they scatter widely. This single number, paired with the mean, summarises "
          "a whole data set's behaviour, and underlies opinion-poll margins of error, quality control in "
          "factories, and the 'bell curve' of marks.",
          "Tackle this once you understand range as a measure of consistency and spread.",
          "In Class 11 you compute variance and standard deviation, the workhorse measures of dispersion in all of statistics."),
        t("mch13_dd03", "How a graph can lie — reading visuals with suspicion",
          "class_9", "mch13_t03_c01",
          "A bar graph turns numbers into a picture so the eye can compare them at a glance — but the same power "
          "makes graphs easy to weaponise. The classic trick is the truncated axis: start the vertical scale at "
          "90 instead of 0 and a rise from 92 to 96 LOOKS like a doubling, though it is barely a 4% change. "
          "Stretching or squashing the axes, using pictures whose AREA grows far faster than the value they "
          "stand for, or omitting the scale entirely, all mislead while showing 'real' data. Learning to read a "
          "graph critically — first checking where the axis starts and what the scale is — is as important as "
          "learning to draw one. You also meet a cousin of the bar graph, the histogram, which groups continuous "
          "data into intervals and where, crucially, it is the AREA of each bar, not just its height, that "
          "carries the meaning. A graph is an argument; treat it like one.",
          "Tackle this once you can read and draw a bar graph correctly.",
          "In Class 9 you meet histograms and frequency polygons and learn the conventions that keep statistical graphics honest."),
    ],
    "ch14": [
        t("mch14_dd01", "What a compass and straightedge can — and cannot — build",
          "class_9", "mch14_t02_c01",
          "With compass and straightedge alone you can bisect any angle exactly. So it feels as if these two "
          "tools should be able to do anything. Astonishingly, three problems the ancient Greeks posed turned out "
          "to be IMPOSSIBLE with them, no matter how clever you are: trisecting a general angle (cutting it into "
          "three equal parts), doubling the cube (building a cube of twice the volume), and squaring the circle "
          "(making a square of the same area as a given circle). These were not solved for over 2000 years — and "
          "the answer, found in the 1800s using algebra, was that they CANNOT be done. Compass-and-straightedge "
          "steps can only produce lengths reachable by +, −, ×, ÷ and square roots; trisection demands cube "
          "roots, and squaring the circle demands π, which no such construction can reach. So 'I can bisect, why "
          "not trisect?' has a deep answer: the tools have a precise, provable limit.",
          "Tackle this once you can construct and bisect an angle with compass and straightedge.",
          "In higher mathematics, field theory explains exactly which lengths and angles are constructible and proves these classical impossibilities."),
        t("mch14_dd02", "Why only triangles, squares and hexagons tile the plane",
          "class_11", "mch14_t03_c01",
          "Tiling rests on one rule: the shapes meeting at every corner must fill exactly 360°, with no gap and "
          "no overlap. That rule alone explains a striking fact — among regular polygons (all sides and angles "
          "equal), only THREE can tile the plane on their own: the triangle, the square, and the hexagon. The "
          "reason is pure arithmetic. A regular polygon's interior angle must divide 360° a whole number of "
          "times to fit around a vertex. Triangles have 60° angles (six meet: 6 × 60 = 360), squares 90° (four "
          "meet), hexagons 120° (three meet). A regular pentagon's angle is 108°, which divides 360 only 3.33 "
          "times — so pentagons always leave a gap and cannot tile alone. This is exactly why honeycomb cells, "
          "bathroom tiles and football-net patterns gravitate to those three shapes; nature and tiler alike are "
          "obeying the 360°-at-a-vertex law you meet here.",
          "Tackle this once you understand the 360°-at-a-vertex rule for tiling.",
          "This idea grows into the study of tessellations and symmetry groups, and into why certain crystals and quasicrystals form the shapes they do."),
        t("mch14_dd03", "The perpendicular bisector is a set of equally-distant points",
          "class_9", "mch14_t01_c01",
          "Constructing a perpendicular bisector with two equal arcs looks like a recipe, but it builds something "
          "with a beautiful definition: the perpendicular bisector of a segment is the set of ALL points that are "
          "the same distance from both endpoints — what mathematicians call a locus. That is precisely why the "
          "equal-arc construction works: each arc-crossing is found at an equal radius from both ends, so it must "
          "lie on the bisector. This locus idea pays off immediately. Draw the perpendicular bisectors of all "
          "three sides of a triangle and they meet at one point, the circumcentre, which is therefore equally "
          "distant from all three corners — the exact centre of the circle that passes through them. It answers "
          "real questions too: where to place a hospital equally far from two towns is a point on their "
          "perpendicular bisector. Seeing a construction as a locus turns 'how to draw it' into 'what it "
          "fundamentally is'.",
          "Tackle this once you can construct a perpendicular bisector with equal arcs.",
          "In Class 9 and 10 you use loci and the circumcentre in proofs and in coordinate geometry."),
    ],
    "ch15": [
        t("mch15_dd01", "Variables on both sides — transposition keeps the balance",
          "class_8", "mch15_t02_c01",
          "You solve an equation by doing the SAME thing to both sides, keeping the balance level. Class 8 hands "
          "you tougher equations where the unknown appears on BOTH sides, like 3x + 4 = x + 12. The balance idea "
          "still rules: subtract x from each side to gather all the x's together (2x + 4 = 12), then subtract 4 "
          "(2x = 8), then divide by 2 (x = 4). With practice this 'do the same to both sides' shortens into "
          "transposition — the familiar move where a term seems to 'cross the equals sign and flip its "
          "operation', a + becoming a − and a × becoming a ÷. It is not magic: transposing is just the balance "
          "rule done in one stroke. Recognising that the shortcut is only the balance principle in disguise is "
          "what keeps you from the classic error of changing one side while forgetting the other, or flipping the "
          "wrong sign.",
          "Tackle this once 'do the same to both sides' to isolate the unknown feels secure.",
          "In Class 8 you solve linear equations with the variable on both sides and with brackets and fractions."),
        t("mch15_dd02", "One equation, two unknowns — where lines come from",
          "class_10", "mch15_t01_c01",
          "Every equation you balance now has a single unknown and (usually) a single solution. But many real "
          "problems involve TWO unknowns at once — 'two pens and three pencils cost ₹40' is one equation in two "
          "letters, and it has infinitely many solutions, each a pair (pens, pencils). Plot all those pairs and "
          "they form a straight LINE — this is the moment algebra and geometry fuse. To pin down a unique answer "
          "you need a SECOND independent fact, a second equation; together they are simultaneous equations, and "
          "their single shared solution is exactly the point where the two lines cross. Three outcomes are "
          "possible and each has a geometric meaning: the lines cross once (one solution), run parallel (no "
          "solution — the conditions contradict), or lie on top of each other (infinitely many). The balanced "
          "single-unknown equation you master here is one line of a richer two-dimensional picture.",
          "Tackle this once you can solve a single linear equation confidently.",
          "In Class 10 you solve pairs of linear equations in two variables by substitution, elimination and graphing."),
        t("mch15_dd03", "When the unknown is squared — the leap to quadratics",
          "class_10", "mch15_t01_c02",
          "A solution is a value that makes both sides of an equation equal, and so far each equation has had "
          "just one. But raise the unknown to a power and that changes. The equation x² = 9 has TWO solutions, "
          "x = 3 and x = −3, because both square to 9 — a fact the integer sign rules you have learned make "
          "inevitable. Equations where the highest power of the unknown is 2, like x² − 5x + 6 = 0, are called "
          "quadratics, and they typically have two solutions, found by factorising into (x − 2)(x − 3) = 0 (so "
          "x = 2 or x = 3) or by the general quadratic formula. They are everywhere the real world curves rather "
          "than runs straight: the arc of a thrown ball, the area of a field given its perimeter, the path of "
          "water from a fountain. Asking 'what counts as a solution?' carefully now prepares you for the moment "
          "one equation legitimately answers with more than one number.",
          "Tackle this once you are clear on what it means for a value to satisfy an equation.",
          "In Class 10 you solve quadratic equations by factorising, completing the square, and the quadratic formula."),
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
    print(f"Injected {total} deepDive StretchTopics across {len(pack['chapters'])} Maths chapters.")


if __name__ == "__main__":
    main()
