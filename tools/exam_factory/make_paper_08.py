# -*- coding: utf-8 -*-
# Boss Challenge Paper 08 — Acids, Bases & Salts · Electric Current & its Effects
#                            · Algebraic Expressions · Exponents & Powers
# Content-only. Uses the dependency-free examfactory engine (no reportlab needed).
# Produces, under Resources/BossChallengePapers/:
#   Paper_08_<SHORT>_QuestionPaper.html  (pure HTML — questions + options, no answers)
#   Paper_08_<SHORT>_QuestionPaper.pdf   (dependency-free PDF, so the in-app browser lists it)
#   Paper_08_<SHORT>_Questions.md
#   Paper_08_<SHORT>_Solutions.html
import os, sys, shutil, json
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from examfactory import build_paper, C, steps, U

PNUM  = "08"
SHORT = "AcidsBases_ElectricCurrent_AlgExpr_Exponents"
TITLE = ("Acids, Bases & Salts · Electric Current & its Effects "
         "· Algebraic Expressions · Exponents & Powers")
LABELS = {
    "ABS": "Acids, Bases & Salts",
    "EC":  "Electric Current",
    "ALG": "Algebraic Expressions",
    "EXP": "Exponents & Powers",
}

# ---------- ACIDS, BASES & SALTS (25) ----------
ABS = [
 ("ABS","A liquid turns blue litmus red but leaves red litmus unchanged. What can you safely conclude?",
   "It is acidic.",
   C("Acids turn blue litmus red; bases turn red litmus blue; a neutral liquid changes neither.")+
   steps("Blue litmus -> red  => an acid is present","Red litmus stays red  => no base present","So the liquid is acidic.")+
   U("This is exactly how a lab tests an unknown liquid with a single strip of litmus."),
   [("It is basic.","A base would turn the RED litmus blue, which did not happen."),
    ("It is neutral.","A neutral liquid changes neither colour, but here blue litmus turned red."),
    ("It is a salt and so always basic.","Salts can be acidic, basic OR neutral; 'always basic' is false.")]),

 ("ABS","Phenolphthalein stays colourless in liquid X. When X is added to a pink phenolphthalein-base mixture, the pink fades. X is most likely:",
   "an acid",
   C("Phenolphthalein is pink in a base and colourless in acid/neutral. If adding X removes the pink, X is cancelling (neutralising) the base.")+
   steps("X is colourless with phenolphthalein -> X is not basic","Adding X destroys the pink of a base -> X neutralises the base","Only an acid neutralises a base, so X is an acid.")+
   U("Squeezing lemon (an acid) onto a soapy base would fade such a pink colour."),
   [("a strong base","A base keeps phenolphthalein pink; it would not fade the colour."),
    ("pure water","Water only dilutes; it cannot neutralise the base and remove the colour."),
    ("a basic salt","A basic solution would keep the pink, not destroy it.")]),

 ("ABS","An ant's sting injects formic acid into the skin. The best quick remedy from the kitchen is to rub on:",
   "baking soda (a mild base)",
   C("Pain from a sting is caused by an acid. A mild base neutralises that acid and eases the pain.")+
   steps("Sting = acid (formic acid)","Neutralise an acid with a base","Baking soda is a safe mild base for skin.")+
   U("This is why anti-sting creams are mildly basic."),
   [("vinegar","Vinegar is an acid (acetic acid) and would add to the acid, not cancel it."),
    ("lemon juice","Lemon is an acid (citric acid); it cannot neutralise another acid."),
    ("common salt solution","Salt water is neutral, so it cannot neutralise the acid.")]),

 ("ABS","Which group contains only acids?",
   "lemon (citric), vinegar (acetic), tamarind (tartaric)",
   C("Many foods are sour because they contain acids. We must check every item in the group is an acid.")+
   steps("Lemon = citric acid","Vinegar = acetic acid","Tamarind = tartaric acid -> all three are acids.")+
   U("Knowing food acids helps explain why sour foods sting a mouth ulcer."),
   [("lemon, vinegar, milk of magnesia","Milk of magnesia is a base, so the group is not all acids."),
    ("curd, soap solution, orange","Soap solution is a base; the group mixes acid and base."),
    ("ant sting, lime water, spinach","Lime water is a base, so this group is not all acids.")]),

 ("ABS","A drop of soap solution on a yellow turmeric stain turns the stain red. This shows soap solution is:",
   "basic",
   C("Turmeric is a natural indicator: it stays yellow in acids but turns red in bases.")+
   steps("Turmeric yellow -> red means a base is present","Soap caused the change","So soap solution is basic.")+
   U("This is the classic 'red spot on a washed turmeric-stained cloth' demonstration."),
   [("acidic","In an acid, turmeric stays yellow; it does not turn red."),
    ("neutral","A neutral liquid leaves turmeric yellow, so the red proves it is not neutral."),
    ("a salt with no effect","The colour clearly changed, so the liquid is not inert.")]),

 ("ABS","When an acid reacts completely with a base, the products are always:",
   "a salt and water",
   C("Neutralisation is the reaction acid + base -> salt + water. The acid and base cancel each other.")+
   steps("Acid + base react","Their harmful natures cancel (neutralise)","Products: a salt + water.")+
   U("Factories neutralise acidic waste this way before releasing it."),
   [("two salts","Neutralisation makes ONE salt plus water, not two salts."),
    ("a base and water","The base is used up in the reaction; it is not a product."),
    ("hydrogen gas and a salt","That describes acid-on-metal, not acid + base.")]),

 ("ABS","A farmer's field is too acidic for crops. The correct substance to add to the soil is:",
   "slaked lime (a base)",
   C("Acidic soil is treated by adding a base, which neutralises the extra acid.")+
   steps("Problem: soil too acidic","Cure: add a base","Slaked lime (or quicklime) is the base used.")+
   U("Lime is spread on sour soils across farms every season."),
   [("vinegar","Vinegar is an acid and would make acidic soil even more acidic."),
    ("an acid fertiliser","Adding more acid worsens the acidity, not fixes it."),
    ("common salt","Salt is neutral, so it cannot neutralise the soil's acid.")]),

 ("ABS","China rose indicator turns a solution green. The solution must be:",
   "basic",
   C("China rose (gudhal) indicator turns dark pink (magenta) in acids and green in bases.")+
   steps("Green colour with china rose -> base","No green appears in acids","So the solution is basic.")+
   U("China rose flowers make a handy home-made indicator."),
   [("acidic","An acid turns china rose magenta/dark pink, not green."),
    ("neutral","A neutral solution shows little change, certainly not green."),
    ("always a salt","Colour shows it is basic; a salt is not implied.")]),

 ("ABS","Why must a factory neutralise its acidic waste before letting it flow into a river?",
   "to remove the acid's harmful effect and protect aquatic life",
   C("Acidic water harms fish, plants and the river. Neutralising it makes the water safe.")+
   steps("Acidic waste would lower the river's safety","Adding a base neutralises the acid","Now the water no longer harms aquatic life.")+
   U("Pollution-control rules require this treatment for industries."),
   [("to make the water taste sweet","Neutralisation is about safety, not flavour."),
    ("to increase the acid's strength","Neutralising lowers the acid effect; it does not strengthen it."),
    ("because salts always evaporate","Salts do not simply vanish; the aim is to protect the river.")]),

 ("ABS","Fresh milk is almost neutral, but on standing it slowly turns sour. The best explanation is that:",
   "an acid (lactic acid) forms in it",
   C("Souring means an acid has appeared. Bacteria turn milk's sugar into lactic acid.")+
   steps("Sour taste -> acid formed","The acid is lactic acid","So the milk has become acidic.")+
   U("The same souring sets curd from milk."),
   [("a base forms in it","Bases taste bitter/soapy, not sour, so a base does not explain souring."),
    ("it turns into pure water","Sour milk is clearly not water."),
    ("a salt forms and makes it sour","Salts are not the cause of the sour taste here; an acid is.")]),

 ("ABS","An antacid tablet relieves acidity in the stomach because it:",
   "is a mild base that neutralises excess stomach acid",
   C("Too much stomach acid causes discomfort. A mild base neutralises the extra acid.")+
   steps("Problem = excess acid","Cure = a base","Antacids are mild bases (like milk of magnesia).")+
   U("This is why antacids are taken after a heavy, spicy meal."),
   [("adds more acid to digest food","Adding acid would worsen acidity, not relieve it."),
    ("is a strong acid that burns the germs","A strong acid would increase the problem and harm the stomach."),
    ("is a neutral salt that absorbs water","A neutral salt cannot neutralise the acid causing the pain.")]),

 ("ABS","Which liquid is most likely to leave BOTH red and blue litmus unchanged?",
   "distilled water",
   C("Only a neutral liquid changes neither litmus colour.")+
   steps("Acid changes blue litmus; base changes red litmus","A liquid that changes neither is neutral","Distilled water is neutral.")+
   U("Neutral distilled water is used to rinse litmus tests."),
   [("lemon juice","An acid turns blue litmus red, so it does change litmus."),
    ("soap solution","A base turns red litmus blue, so it changes litmus."),
    ("baking soda solution","Baking soda is basic and turns red litmus blue.")]),

 ("ABS","You have one bottle of dilute acid and one of dilute base, but ONLY red litmus paper. Which can you definitely identify?",
   "the base, because it turns red litmus blue",
   C("Red litmus changes colour only in a base. It cannot reveal an acid (red stays red in acid).")+
   steps("Red litmus in base -> turns blue (clear signal)","Red litmus in acid -> stays red (no signal)","So only the base is certainly identified.")+
   U("Choosing the right indicator for the job is a real lab skill."),
   [("the acid, because it turns red litmus blue","An acid does NOT turn red litmus blue; that is what a base does."),
    ("both, immediately","Red litmus cannot signal the acid, so 'both' is wrong."),
    ("neither, you always need blue litmus","Red litmus alone can still identify the base.")]),

 ("ABS","Equal strengths of an acid and a base are mixed to give a neutral solution. A little MORE acid is then added. The mixture becomes:",
   "acidic",
   C("At neutral, acid and base exactly balance. Extra acid tips the balance towards acid.")+
   steps("Start: perfectly neutral","Add extra acid -> acid is now in excess","Excess acid makes the mixture acidic.")+
   U("Over-squeezing lemon into neutralised water makes it sour again."),
   [("basic","Adding acid cannot make a solution basic; it adds acid."),
    ("still perfectly neutral","Extra acid breaks the balance, so it is no longer neutral."),
    ("turned into pure salt only","A solution remains; it does not become only solid salt.")]),

 ("ABS","Many toothpastes are mildly basic. The main reason is to:",
   "neutralise the acid made by mouth bacteria",
   C("Bacteria in the mouth make acids that attack teeth. A mild base neutralises that acid.")+
   steps("Acids from food/bacteria harm teeth","A mild base neutralises the acid","So toothpaste is made mildly basic.")+
   U("Brushing after meals helps cancel mouth acids."),
   [("make the mouth strongly acidic","Acid harms teeth, so making the mouth acidic is the opposite of helpful."),
    ("add sugar to feed bacteria","Feeding bacteria makes more acid, which is harmful."),
    ("dissolve the enamel faster","Toothpaste protects enamel; it is not meant to dissolve it.")]),

 ("ABS","Which of these is a base?",
   "caustic soda (sodium hydroxide)",
   C("Bases feel soapy/bitter and turn red litmus blue. Caustic soda is a well-known strong base.")+
   steps("Check each for acid vs base","Caustic soda (NaOH) is a strong base","The rest are acids or neutral salts.")+
   U("Caustic soda is used in soap making and drain cleaners."),
   [("vinegar","Vinegar is an acid (acetic acid)."),
    ("citric acid","As the name says, it is an acid."),
    ("common salt","Common salt is a neutral salt, not a base.")]),

 ("ABS","Common salt is dissolved in water. The solution will be:",
   "neutral",
   C("Common salt is made from a strong acid and a strong base, so its solution is neutral.")+
   steps("Salt = sodium chloride","From a strong acid + strong base","Such a salt solution is neutral.")+
   U("That is why salty cooking water does not sting like lemon does."),
   [("strongly acidic","Common salt water does not turn blue litmus red."),
    ("strongly basic","Common salt water does not turn red litmus blue."),
    ("able to turn blue litmus red","Only an acid does that; salt water is neutral.")]),

 ("ABS","Litmus, the most common natural indicator, is obtained from:",
   "lichens",
   C("Litmus is a natural dye extracted from lichens. Other plants give other indicators.")+
   steps("Litmus comes from lichens","Turmeric, china rose and red cabbage are different indicators","So the source of litmus is lichens.")+
   U("Litmus paper in classrooms is made from this lichen dye."),
   [("rose petals","Rose/china-rose gives a different indicator, not litmus."),
    ("turmeric roots","Turmeric is its own indicator; it is not the source of litmus."),
    ("only red cabbage","Red cabbage is another indicator, not the source of litmus.")]),

 ("ABS","Plants are dying in a strongly BASIC soil. Which addition best moves the soil towards neutral?",
   "organic manure / compost",
   C("Basic soil is treated by adding decaying organic matter, which acts acidic and neutralises the base.")+
   steps("Problem: soil too basic","Cure: add something acidic in effect","Organic manure/compost lowers the basicity.")+
   U("Composting kitchen waste improves over-limed soils."),
   [("slaked lime","Lime is a base and would make basic soil even more basic."),
    ("baking soda","Baking soda is basic, so it worsens the problem."),
    ("caustic soda","Caustic soda is a strong base and would harm the soil further.")]),

 ("ABS","Phenolphthalein is pink in a solution. Which single action will most likely turn it colourless?",
   "adding enough acid",
   C("Phenolphthalein is pink in a base. Adding acid neutralises the base, removing the colour.")+
   steps("Pink = base present","Add acid -> neutralises the base","With the base gone, the colour disappears.")+
   U("This colour change marks the 'end point' of a neutralisation."),
   [("adding more base","More base keeps it pink, not colourless."),
    ("adding common salt","Neutral salt does not neutralise the base, so the pink stays."),
    ("cooling the solution","Cooling does not neutralise the base; the pink remains.")]),

 ("ABS","Pouring vinegar on baking soda makes bubbles of gas. This tells us that vinegar is:",
   "acidic",
   C("Vinegar is an acid; it reacts with baking soda and releases carbon dioxide bubbles.")+
   steps("Bubbles show a reaction is happening","Baking soda reacts in this way with acids","So vinegar is an acid.")+
   U("This fizzing reaction is used in baking and in toy 'volcanoes'."),
   [("basic","Two basic things would not fizz like this with baking soda."),
    ("neutral","A neutral liquid would not react and bubble with baking soda."),
    ("a metal","Vinegar is a liquid acid, not a metal.")]),

 ("ABS","Which one of these statements about acids and bases is correct?",
   "Acids turn blue litmus red; bases turn red litmus blue.",
   C("Remember the rule: ACID reddens BLUE litmus; BASE blues RED litmus.")+
   steps("Acid + blue litmus -> red","Base + red litmus -> blue","The other combinations are false.")+
   U("This single rule lets you read any litmus test correctly."),
   [("Acids turn red litmus blue.","That is what bases do, not acids."),
    ("Bases turn blue litmus red.","That is what acids do, not bases."),
    ("Neutral liquids turn both litmus papers red.","Neutral liquids change neither colour.")]),

 ("ABS","Lime water turns red litmus blue. This tells us that lime water is:",
   "a base",
   C("Turning red litmus blue is the signature of a base.")+
   steps("Red litmus -> blue means a base","Lime water caused the change","So lime water is basic.")+
   U("Lime water (a base) is also used to test for carbon dioxide gas."),
   [("an acid","An acid turns blue litmus red; it does not blue red litmus."),
    ("neutral","A neutral liquid leaves red litmus unchanged."),
    ("a strong acid like a lemon","Lemon is acidic; lime water behaves oppositely.")]),

 ("ABS","Solution X turns china rose magenta; solution Y turns turmeric red. X and Y are respectively:",
   "an acid and a base",
   C("China rose -> magenta means acid. Turmeric -> red means base.")+
   steps("China rose magenta -> X is an acid","Turmeric red -> Y is a base","So X = acid, Y = base.")+
   U("Using two indicators together makes identification very reliable."),
   [("a base and an acid","That reverses both clues; china rose magenta is acid, turmeric red is base."),
    ("both acids","Turmeric turning red shows Y is a base, not an acid."),
    ("both bases","China rose turning magenta shows X is an acid, not a base.")]),

 ("ABS","A factory releases BASIC waste water. To make it safe before release, the cheapest correct choice is to add a/an:",
   "acid",
   C("Basic waste is neutralised by adding an acid, just as acidic waste is treated with a base.")+
   steps("Waste is basic","Neutralise a base with an acid","Adding an acid brings it towards neutral and safe.")+
   U("Treatment plants dose acid or base depending on the waste."),
   [("stronger base","More base makes the waste more basic, not safe."),
    ("common salt","Neutral salt cannot neutralise the basic waste."),
    ("only fresh water","Diluting with water does not neutralise the base.")]),
]

# ---------- ALGEBRAIC EXPRESSIONS (25) ----------
ALG = [
 ("ALG","In the term -7xy, the numerical coefficient is:",
   "-7",
   C("The numerical coefficient is the number multiplying the variables, INCLUDING its sign.")+
   steps("Term: -7xy","Number part = -7","So the coefficient is -7 (keep the minus sign).")+
   U("Coefficients tell you 'how many' of something in a formula."),
   [("7","The sign is part of the coefficient; it is -7, not 7."),
    ("xy","xy is the variable part, not the numerical coefficient."),
    ("-7xy","That is the whole term, not just the coefficient.")]),

 ("ALG","Which pair are LIKE terms?",
   "3ab and -7ba",
   C("Like terms have exactly the same variables (order does not matter, since ab = ba).")+
   steps("3ab has variables a and b","-7ba also has a and b (ba = ab)","Same variables -> like terms.")+
   U("Only like terms can be added or subtracted directly."),
   [("3a and 3b","Different variables (a vs b), so they are unlike."),
    ("5x^2 and 5x","x^2 and x are different powers, so they are unlike."),
    ("2xy and 2x","One has xy, the other only x, so they are unlike.")]),

 ("ALG","If x = 2 and y = 3, the value of 2x^2 - y is:",
   "5",
   C("Square first, then multiply, then subtract. Note 2x^2 means 2 times (x squared), not (2x) squared.")+
   steps("x^2 = 2^2 = 4","2x^2 = 2 x 4 = 8","8 - y = 8 - 3 = 5.")+
   U("Careful order of operations matters in every science formula."),
   [("13","That treats it as (2x)^2 = 4^2 = 16, then 16-3=13 — but 2x^2 = 8."),
    ("10","That uses 2x = 4 then 4^2... mis-step; the value is 5."),
    ("-1","That subtracts wrongly; 8 - 3 = 5, not -1.")]),

 ("ALG","Sohan is 5 years older than twice Ravi's age. If Ravi is r years old, Sohan's age is:",
   "2r + 5",
   C("'Twice Ravi' = 2r. '5 older' means add 5.")+
   steps("Twice Ravi's age = 2r","5 years older -> add 5","Sohan's age = 2r + 5.")+
   U("Turning sentences into expressions is the heart of word problems."),
   [("5r + 2","That is five times Ravi plus 2 — not what the sentence says."),
    ("2(r + 5)","That doubles (r+5); but 5 is added AFTER doubling, giving 2r+5."),
    ("r + 5","This misses the 'twice', which doubles Ravi's age.")]),

 ("ALG","How many terms are in the expression 4x^2 - 3xy + 7 ?",
   "3",
   C("Terms are the parts separated by + or - signs.")+
   steps("Parts: 4x^2 | -3xy | 7","Count them: 1, 2, 3","So there are 3 terms (a trinomial).")+
   U("Counting terms tells you if an expression is a monomial, binomial, etc."),
   [("2","There are three separated parts, not two."),
    ("4","Do not count variables; count the +/- separated parts (3)."),
    ("1","The +/- signs split it into more than one term.")]),

 ("ALG","Subtract (3a - 2b) from (5a + b).",
   "2a + 3b",
   C("'Subtract P from Q' means Q - P. Change every sign of P before adding.")+
   steps("(5a + b) - (3a - 2b)","= 5a + b - 3a + 2b","= 2a + 3b.")+
   U("Sign care in subtraction prevents the most common algebra slip."),
   [("2a - 3b","The -2b becomes +2b on subtracting, giving +3b not -3b."),
    ("8a - b","That ADDS the expressions instead of subtracting."),
    ("-2a - 3b","That computes P - Q; the question asks Q - P.")]),

 ("ALG","Simplify: 7x - 3x + 2 - 5.",
   "4x - 3",
   C("Combine like terms: the x-terms together, the numbers together.")+
   steps("7x - 3x = 4x","2 - 5 = -3","Result: 4x - 3.")+
   U("Simplifying first makes any later substitution much easier."),
   [("4x + 3","2 - 5 = -3, so the constant is -3, not +3."),
    ("10x - 3","7x - 3x = 4x, not 10x (it is subtraction)."),
    ("4x - 7","2 - 5 = -3, not -7.")]),

 ("ALG","The expression 3(2x + 4) is equal to:",
   "6x + 12",
   C("Use the distributive rule: multiply the outside number by EACH inside term.")+
   steps("3 x 2x = 6x","3 x 4 = 12","So 3(2x+4) = 6x + 12.")+
   U("Expanding brackets is needed to solve many equations."),
   [("6x + 4","The 3 must also multiply the 4, giving 12 not 4."),
    ("5x + 7","You multiply, not add, the 3 into the bracket."),
    ("6x + 7","3 x 4 = 12, not 7.")]),

 ("ALG","In 5x^2 - 2x + 9, the constant term is:",
   "9",
   C("The constant term is the part with NO variable.")+
   steps("5x^2 has a variable","-2x has a variable","9 has no variable -> it is the constant.")+
   U("The constant is the 'starting value' in many real formulas."),
   [("5","5 is the coefficient of x^2, not the constant."),
    ("-2","-2 is the coefficient of x, not the constant."),
    ("x","x is a variable, not the constant term.")]),

 ("ALG","The perimeter of a rectangle with length l and breadth b is given by the expression:",
   "2(l + b)",
   C("Perimeter is the total distance around: two lengths and two breadths.")+
   steps("Two lengths = 2l","Two breadths = 2b","Total = 2l + 2b = 2(l + b).")+
   U("This formula fences a field or frames a picture."),
   [("l x b","That is the AREA, not the perimeter."),
    ("l + b","That is only one length and one breadth, i.e. half the perimeter."),
    ("2l + b","This counts two lengths but only one breadth.")]),

 ("ALG","Joined squares in a row need 3n + 1 matchsticks for n squares. How many sticks are needed for 10 squares?",
   "31",
   C("Substitute n = 10 into the rule 3n + 1.")+
   steps("3n + 1 with n = 10","= 3 x 10 + 1","= 30 + 1 = 31.")+
   U("Such 'nth-term' rules predict patterns without drawing them all."),
   [("40","That is 4 x 10, treating each square as 4 separate sticks (they share sides)."),
    ("30","This forgets the +1 starting stick."),
    ("34","That adds 4 instead of 1 at the end.")]),

 ("ALG","Which of the following is a MONOMIAL?",
   "-6x^2y",
   C("A monomial is an expression with exactly ONE term.")+
   steps("Count +/- separated terms","-6x^2y is a single term -> monomial","The others have 2 or 3 terms.")+
   U("Classifying expressions helps you pick the right method to simplify."),
   [("x + y","Two terms -> a binomial, not a monomial."),
    ("2x - 3","Two terms -> a binomial."),
    ("a + b + c","Three terms -> a trinomial.")]),

 ("ALG","The factors of the term 5xy are:",
   "5, x and y",
   C("Factors are the things multiplied together to make the term.")+
   steps("5xy = 5 x x x y","So its factors are 5, x and y","(1 is a factor of every term too, but the key factors are 5, x, y).")+
   U("Spotting factors is the first step in cancelling and simplifying."),
   [("5 and xy only","xy can be split further into x and y; list all factors."),
    ("x and y only","The number 5 is also a factor of the term."),
    ("5x and 5y","5x x 5y = 25xy, which is not the original term 5xy.")]),

 ("ALG","If a = -2, the value of a^2 + 3a is:",
   "-2",
   C("Square the negative first (a negative squared is positive), then add 3a.")+
   steps("a^2 = (-2)^2 = 4","3a = 3 x (-2) = -6","4 + (-6) = -2.")+
   U("Sign care with squares appears all over physics and finance."),
   [("10","That treats a^2 as -4 wrongly; (-2)^2 = +4, giving -2 overall."),
    ("-10","That uses a^2 = -4 (wrong) and adds, giving -10; but a^2 = +4."),
    ("2","4 + (-6) = -2, not +2.")]),

 ("ALG","Add the expressions 2x^2 + 3x and x^2 - x + 4.",
   "3x^2 + 2x + 4",
   C("Add like terms: x^2 with x^2, x with x, numbers with numbers.")+
   steps("2x^2 + x^2 = 3x^2","3x - x = 2x","constant: 0 + 4 = 4 -> 3x^2 + 2x + 4.")+
   U("Combining expressions models adding two cost formulas together."),
   [("3x^2 + 4x + 4","3x - x = 2x, not 4x (it is a subtraction)."),
    ("2x^2 + 2x + 4","2x^2 + x^2 = 3x^2, not 2x^2."),
    ("3x^2 + 2x - 4","The constant is +4 (only the second expression has one).")]),

 ("ALG","In the expression x^2 - x, the coefficient of x is:",
   "-1",
   C("A lone -x means -1 times x, so its coefficient is -1.")+
   steps("Term with x is '-x'","-x = -1 x x","So the coefficient of x is -1.")+
   U("Reading hidden coefficients of 1 prevents sign mistakes."),
   [("1","The term is -x, so the coefficient is -1, not +1."),
    ("0","x does appear, so its coefficient is not 0."),
    ("x","x is the variable; the coefficient is the number -1.")]),

 ("ALG","A hall has c chairs (4 legs each) and t stools (3 legs each). The total number of legs is:",
   "4c + 3t",
   C("Multiply each count by its legs, then add.")+
   steps("Chairs: 4 legs each -> 4c","Stools: 3 legs each -> 3t","Total legs = 4c + 3t.")+
   U("Such expressions help count parts in furniture or machines."),
   [("3c + 4t","This swaps the legs: chairs have 4 legs, stools 3."),
    ("7(c + t)","Not every item has 7 legs; chairs and stools differ."),
    ("4c + 3","The stools number t must be multiplied by 3, giving 3t not 3.")]),

 ("ALG","Which two terms CANNOT be added together (they are unlike)?",
   "6x^2 and 6x",
   C("Only like terms (same variable AND same power) can be combined.")+
   steps("6x^2 has power 2","6x has power 1","Different powers -> unlike -> cannot be added.")+
   U("This is why x^2 and x stay separate in an answer."),
   [("2y and 5y","Same variable y, same power -> they are like terms."),
    ("-3ab and ab","Both are ab terms -> like terms."),
    ("x and 4x","Both are x terms -> like terms.")]),

 ("ALG","The cost in rupees of x pencils at Rs 4 each plus one Rs 10 eraser is C = 4x + 10. The cost of 7 pencils and one eraser is:",
   "Rs 38",
   C("Substitute x = 7 into the cost formula.")+
   steps("C = 4x + 10","= 4 x 7 + 10","= 28 + 10 = Rs 38.")+
   U("Shops use exactly this kind of formula at the billing counter."),
   [("Rs 40","That forgets to multiply: 4 x 7 = 28, not 30."),
    ("Rs 48","That adds an extra item; 4 x 7 + 10 = 38."),
    ("Rs 28","This forgets to add the Rs 10 eraser.")]),

 ("ALG","Simplify: 3a + 4b - a + 2b.",
   "2a + 6b",
   C("Group the a-terms together and the b-terms together.")+
   steps("3a - a = 2a","4b + 2b = 6b","Result: 2a + 6b.")+
   U("Tidying like terms is the most common first step in algebra."),
   [("2a + 2b","4b + 2b = 6b, not 2b."),
    ("4a + 6b","3a - a = 2a, not 4a (it is a subtraction)."),
    ("2a - 6b","Both b-terms are positive, so the b total is +6b.")]),

 ("ALG","Which expression is a BINOMIAL?",
   "2x - 5",
   C("A binomial has exactly TWO terms.")+
   steps("Count +/- separated terms","2x - 5 has two terms -> binomial","The others have 1 or 3 terms.")+
   U("Naming expressions by their term-count is basic algebra vocabulary."),
   [("7","A single number is one term -> a monomial."),
    ("3xy","One term -> a monomial, not a binomial."),
    ("a + b + c","Three terms -> a trinomial.")]),

 ("ALG","If p = 3, the value of 2p^2 is:",
   "18",
   C("Square p first, then multiply by 2. 2p^2 is NOT (2p)^2.")+
   steps("p^2 = 3^2 = 9","2p^2 = 2 x 9","= 18.")+
   U("This trap (2p^2 vs (2p)^2) catches many students."),
   [("36","That is (2p)^2 = 6^2 = 36; but 2p^2 means 2 x 9 = 18."),
    ("12","That computes 2 x 3 x 2; 2p^2 = 2 x 9 = 18."),
    ("9","That is just p^2; you must still multiply by 2.")]),

 ("ALG","A taxi charges Rs 30 fixed plus Rs 12 per km. For a ride of d km the fare in rupees is:",
   "12d + 30",
   C("Per-km charge multiplies the distance; the fixed charge is added once.")+
   steps("Distance charge = 12 x d = 12d","Fixed charge = 30 (added once)","Fare = 12d + 30.")+
   U("Ride-app fares are built from exactly this kind of expression."),
   [("30d + 12","That charges Rs 30 per km and Rs 12 fixed — the reverse."),
    ("42d","You cannot add 12d and 30 into 42d; they are unlike terms."),
    ("12 + 30d","This makes the fixed Rs 30 depend on distance, which is wrong.")]),

 ("ALG","On collecting like terms, 5xy + 3x - 2xy + x equals:",
   "3xy + 4x",
   C("Combine xy-terms separately from x-terms.")+
   steps("5xy - 2xy = 3xy","3x + x = 4x","Result: 3xy + 4x.")+
   U("Collecting like terms shortens long expressions safely."),
   [("3xy + 3x","3x + x = 4x, not 3x (the lone x counts as 1x)."),
    ("7xy + 4x","5xy - 2xy = 3xy, not 7xy (it is a subtraction)."),
    ("3xy + 2x","3x + x = 4x; you cannot drop the lone x.")]),

 ("ALG","For the cost expression 8n (n notebooks at Rs 8 each), which statement is correct?",
   "8 is the fixed price per notebook (a constant) and n is the variable number of notebooks.",
   C("A constant keeps the same value; a variable can change. The price is fixed, the count varies.")+
   steps("Price per notebook is fixed -> 8 is a constant","The number bought can change -> n is a variable","So 8 = constant, n = variable.")+
   U("Telling constants from variables is key to reading any formula."),
   [("8 is the number of notebooks and n is the price.","That swaps their meanings; 8 is the price, n the count."),
    ("Both 8 and n are constants.","n can change with how many you buy, so n is a variable."),
    ("Both 8 and n are variables.","The price 8 is fixed, so it is a constant, not a variable.")]),
]

# ---------- ELECTRIC CURRENT & ITS EFFECTS (25) ----------
EC = [
 ("EC","In a circuit diagram, a long thin line next to a short thick line represents:",
   "a cell",
   C("The cell symbol is a long line (positive terminal) beside a shorter, thicker line (negative terminal).")+
   steps("Long line = + terminal","Short thick line = - terminal","Together they stand for a cell.")+
   U("Reading circuit symbols lets you build a circuit from a diagram."),
   [("a switch","A switch is shown as a gap with a movable lever, not two parallel lines."),
    ("a bulb","A bulb is a circle with a cross or loop inside."),
    ("a resistor","A resistor symbol is a zig-zag or a rectangle, not two lines.")]),

 ("EC","Two or more cells joined together form a:",
   "battery",
   C("A single unit is a cell; several cells joined together make a battery.")+
   steps("One unit = a cell","Join several cells in a line","The combination is called a battery.")+
   U("A torch usually runs on a battery of two cells."),
   [("switch","A switch breaks or completes a circuit; it is not made of cells."),
    ("fuse","A fuse is a safety wire, not a group of cells."),
    ("filament","A filament is the glowing wire inside a bulb.")]),

 ("EC","To make a working battery, cells are joined so that:",
   "the positive terminal of one cell connects to the negative terminal of the next",
   C("Cells must be lined up + to - so their pushes add up in the same direction.")+
   steps("Line cells head-to-tail","+ of one -> - of the next","Their voltages add to drive more current.")+
   U("Putting a cell in backwards is why a torch sometimes won't light."),
   [("the positive terminal joins the positive terminal","Joining + to + opposes the cells and they cancel out."),
    ("the negative terminal joins the negative terminal","Joining - to - also makes the cells oppose each other."),
    ("the terminals are left unconnected","Unconnected cells form no battery and pass no current.")]),

 ("EC","When current passes through a wire and makes it hot, this is called the:",
   "heating effect of current",
   C("Electric current can heat a conductor it flows through. This is its heating effect.")+
   steps("Current flows through the wire","The wire warms up","This warming is the heating effect of current.")+
   U("Electric heaters, irons and toasters all use this effect."),
   [("magnetic effect of current","The magnetic effect deflects a compass; it does not heat the wire."),
    ("chemical effect of current","The chemical effect happens in liquids, e.g. plating."),
    ("lighting effect of current","'Lighting effect' is not a named effect; heating is.")]),

 ("EC","Equal currents pass through a thick copper wire and a thin nichrome wire. Which gets hotter?",
   "the thin nichrome wire",
   C("More resistance means more heat for the same current. Nichrome resists more than copper, and a thinner wire resists more than a thick one.")+
   steps("Nichrome has high resistance; copper low","Thin wire resists more than thick","So the thin nichrome wire heats up most.")+
   U("That is why heating coils are made of thin nichrome, while connecting wires are thick copper."),
   [("the thick copper wire","Copper has low resistance, so it stays comparatively cool."),
    ("both heat equally","Their resistances differ greatly, so the heating differs."),
    ("neither heats at all","Current through any real wire produces some heat.")]),

 ("EC","The filament of an electric bulb glows mainly because:",
   "current heats the thin high-resistance filament until it gives out light",
   C("The filament is a thin, high-resistance wire. Current heats it white-hot, and it glows.")+
   steps("Current meets high resistance in the thin filament","The filament heats up strongly","It becomes so hot that it glows and gives light.")+
   U("This is the heating effect put to work for lighting."),
   [("the glass cover gets hot","The glass is not what produces the light; the filament does."),
    ("the bulb is filled with water","Bulbs are not filled with water; that would cool the filament."),
    ("the switch becomes a magnet","A switch's magnetism, if any, does not light the bulb.")]),

 ("EC","A fuse protects an electrical circuit because it:",
   "melts and breaks the circuit when the current becomes too large",
   C("A fuse is a thin wire that melts if too much current flows, cutting off the circuit before damage.")+
   steps("Too much current -> fuse wire overheats","Fuse melts -> circuit breaks","Current stops, protecting the appliance.")+
   U("Fuses prevent house wiring fires during a short circuit."),
   [("increases the current in the circuit","A fuse limits damage; it does not boost current."),
    ("stores electric charge for later","Storing charge is a cell/capacitor's job, not a fuse's."),
    ("makes the bulb glow brighter","A fuse is a safety device, not a brightness control.")]),

 ("EC","A fuse wire is deliberately made of a metal that melts easily so that:",
   "it breaks the circuit before the appliance's own wires overheat",
   C("The fuse is the planned 'weak point' that fails first, saving the rest of the circuit.")+
   steps("Excess current heats the fuse wire fastest","It melts first and opens the circuit","The appliance wires are saved from overheating.")+
   U("Replacing a blown fuse is far cheaper than replacing burnt wiring."),
   [("the current in the circuit increases","Melting the fuse stops the current, it does not increase it."),
    ("the bulb glows brighter","The fuse exists for safety, not brightness."),
    ("the wire becomes a permanent magnet","A fuse melting has nothing to do with magnetism.")]),

 ("EC","A compass needle near a wire deflects only when the switch is ON. This shows that:",
   "an electric current produces a magnetic effect",
   C("A flowing current creates magnetism around the wire, which turns a nearby compass needle.")+
   steps("Switch ON -> current flows","Needle deflects only then","So the current is producing a magnetic effect.")+
   U("This discovery (Oersted's) is the basis of every electromagnet."),
   [("current produces only heat","Heat would not turn a compass needle; magnetism does."),
    ("the compass is faulty","The needle moves only with current ON, so it is working correctly."),
    ("the wire is charged like a rubbed balloon","Static charge is not why the needle turns; the current's magnetism is.")]),

 ("EC","A coil of wire wound around an iron nail acts as a magnet ONLY while current flows. This device is a/an:",
   "electromagnet",
   C("An electromagnet is a coil with an iron core that is magnetic only while current passes.")+
   steps("Coil + iron core + current -> magnetism","Switch off the current -> magnetism stops","This on/off magnet is an electromagnet.")+
   U("Cranes use giant electromagnets to pick up and drop scrap iron."),
   [("permanent magnet","A permanent magnet stays magnetic even with no current."),
    ("fuse","A fuse is a safety wire, not a magnet."),
    ("cell","A cell stores chemical energy; it is not made magnetic by a coil.")]),

 ("EC","Which change makes an electromagnet STRONGER?",
   "increasing the number of turns in the coil",
   C("More turns of wire (and more current) make the electromagnet stronger.")+
   steps("Each turn adds to the magnetism","More turns -> stronger field","So adding turns strengthens the electromagnet.")+
   U("Powerful lifting magnets have thousands of turns."),
   [("using fewer turns","Fewer turns weaken the electromagnet."),
    ("removing the iron core","The iron core boosts the field; removing it weakens the magnet."),
    ("switching off the current","With no current there is no magnetism at all.")]),

 ("EC","The main advantage of an electromagnet over a permanent magnet is that:",
   "its magnetism can be switched on and off",
   C("An electromagnet is magnetic only while current flows, so you control it with a switch.")+
   steps("Current ON -> magnet works","Current OFF -> magnet stops","This on/off control is its key advantage.")+
   U("A scrap-yard crane drops its load simply by switching the current off."),
   [("it never needs any current","An electromagnet needs current to work; that is the point."),
    ("it is always weaker than any magnet","Electromagnets can be made extremely strong."),
    ("it cannot attract iron","An electromagnet attracts iron strongly while switched on.")]),

 ("EC","An electric bell works mainly using the ____ effect of current.",
   "magnetic",
   C("An electric bell uses an electromagnet to repeatedly pull a hammer onto the gong.")+
   steps("Current makes the electromagnet pull the hammer","The hammer striking breaks the circuit, magnet releases","This repeats, ringing the bell — a magnetic effect.")+
   U("Doorbells and old telephone ringers work this way."),
   [("heating","Heating would not make the hammer move to and fro."),
    ("chemical","The chemical effect acts in liquids, not in a bell."),
    ("cooling","There is no 'cooling effect' driving a bell.")]),

 ("EC","If the switch in a single-loop circuit is left OPEN, the bulb will:",
   "not glow, because the circuit is incomplete",
   C("Current flows only in a complete (closed) loop. An open switch breaks the loop.")+
   steps("Open switch = a gap in the loop","No complete path for current","So no current flows and the bulb stays dark.")+
   U("A light turns off the instant you flip the switch open."),
   [("glow brighter than before","No current flows in an open circuit, so it cannot glow at all."),
    ("glow dimly","An open circuit carries no current, so there is no dim glow either."),
    ("become a magnet","With no current there is no magnetic effect.")]),

 ("EC","In a circuit two bulbs are connected one after another (in series). If one bulb fuses, the other bulb will:",
   "also stop glowing, because the circuit is broken",
   C("In a series circuit there is a single path. If it breaks anywhere, current stops everywhere.")+
   steps("Series = one single path for current","A fused bulb breaks that path","So no current flows, and the other bulb goes out too.")+
   U("Old fairy lights went fully dark when a single bulb failed."),
   [("glow much brighter","With the path broken, no current flows, so it cannot brighten."),
    ("be completely unaffected","In series, a break anywhere stops the whole current."),
    ("turn into a fuse","A bulb does not become a fuse when its neighbour fails.")]),

 ("EC","Adding one more cell (connected correctly) to a torch usually makes the bulb:",
   "brighter, because more current flows",
   C("Adding cells the right way increases the push, so more current flows and the bulb glows brighter.")+
   steps("Extra cell -> larger total push","Larger push -> more current","More current -> a brighter bulb.")+
   U("Two-cell torches are brighter than one-cell ones."),
   [("dimmer","Correctly added cells increase current, making it brighter, not dimmer."),
    ("exactly the same","More cells change the current, so the brightness changes."),
    ("magnetic instead of bright","A bulb gives light, not magnetism, from more current.")]),

 ("EC","The heating element of an electric room heater is made of nichrome because nichrome:",
   "has a high resistance and a high melting point",
   C("A good heating element must resist current strongly (to get hot) and not melt at that high temperature.")+
   steps("High resistance -> lots of heat from the current","High melting point -> it survives glowing red-hot","Nichrome has both, so it is ideal.")+
   U("Toasters, geysers and irons all use nichrome coils."),
   [("is a poor conductor that blocks current completely","If it blocked all current it could not heat up at all."),
    ("melts very easily","An easily melting wire would fail the moment it glowed."),
    ("is naturally magnetic","Magnetism is not why nichrome is used for heating.")]),

 ("EC","Why should you NEVER touch an electric switch with wet hands?",
   "water lets electricity pass through you easily, risking a dangerous shock",
   C("Wet skin conducts electricity far better than dry skin, so current can flow through you.")+
   steps("Dry skin resists current somewhat","Wet skin conducts current easily","So wet hands raise the shock danger.")+
   U("This is why bathroom switches are kept out of wet reach."),
   [("wet hands repel electric current","Water does the opposite — it helps current flow through you."),
    ("water cools the switch and breaks it","The danger is a shock to you, not cooling the switch."),
    ("wet hands turn into magnets","Wet hands do not become magnets; the risk is electric shock.")]),

 ("EC","An electromagnet uses a soft iron core rather than a steel core because soft iron:",
   "loses its magnetism quickly when the current is switched off",
   C("Soft iron is magnetic only while current flows and lets go fast when it stops — perfect for an on/off magnet.")+
   steps("Current ON -> soft iron becomes strongly magnetic","Current OFF -> soft iron loses magnetism at once","This clean on/off behaviour is what we want.")+
   U("A crane must drop its iron load instantly when switched off."),
   [("stays a magnet forever after one use","That describes steel; it would not let the crane release its load."),
    ("cannot be magnetised at all","Soft iron magnetises very easily; that is why it is chosen."),
    ("conducts no electric current","The core's job is magnetism; current flows in the coil around it.")]),

 ("EC","Which device works mainly on the MAGNETIC effect of current?",
   "an electromagnet crane lifting scrap iron",
   C("Lifting iron needs magnetism, which a current creates in an electromagnet.")+
   steps("Crane uses an electromagnet","Electromagnet works by magnetism","So it uses the magnetic effect of current.")+
   U("Scrap yards sort iron from other metals using such cranes."),
   [("an electric iron (press)","An iron presses clothes using the heating effect."),
    ("an electric bulb","A bulb glows using the heating effect of current."),
    ("a room heater","A heater warms a room using the heating effect.")]),

 ("EC","Which appliance works mainly on the HEATING effect of current?",
   "an electric toaster",
   C("A toaster's coils get red-hot from current resisting through them — the heating effect.")+
   steps("Current flows through high-resistance coils","Coils heat up strongly","That heat toasts the bread.")+
   U("Geysers and hair dryers use the same heating effect."),
   [("an electric bell","A bell uses the magnetic effect (an electromagnet)."),
    ("an electromagnet crane","A crane lifts iron using magnetism, not heat."),
    ("a compass near a wire","A compass shows the magnetic effect, not heating.")]),

 ("EC","In a circuit diagram, an OPEN switch means the switch is:",
   "OFF, so current cannot flow",
   C("An open switch leaves a gap in the circuit, so the loop is incomplete and no current flows.")+
   steps("Open switch = gap in the loop","Incomplete loop -> no current","So 'open' means OFF.")+
   U("Flicking a switch open is exactly how you turn a light off."),
   [("ON, so current flows freely","A closed switch is ON; an open switch is OFF."),
    ("a cell that supplies current","A switch is not a source of current."),
    ("a fuse that has melted","An open switch is a chosen OFF state, not a blown fuse.")]),

 ("EC","A torch bulb will not light even with a brand-new bulb and the switch closed. The MOST likely cause is:",
   "the cells are used up, so no current flows",
   C("If the bulb and switch are fine, the dead cells are the usual culprit — no push, no current.")+
   steps("New bulb -> bulb is fine","Switch closed -> loop is complete","So the fault is the source: the cells are flat.")+
   U("Swapping in fresh cells is the first thing to try in a dead torch."),
   [("there is too much magnetism in the wire","Magnetism does not stop a bulb from lighting like this."),
    ("the bulb is too new to work","A new bulb works immediately; newness is not a fault."),
    ("the connecting wire is too short","Wire length does not stop a complete circuit from working.")]),

 ("EC","An appliance normally draws a working current of about 5 A. For safety, the fuse fitted to it should melt at a current that is:",
   "a little above the normal working current (just over 5 A)",
   C("A good fuse allows the normal current but melts when the current rises dangerously above it.")+
   steps("Normal current ~5 A must pass without melting the fuse","A dangerous overload is well above 5 A","So set the fuse to melt just above 5 A.")+
   U("Matching the fuse rating to the appliance is basic electrical safety."),
   [("far below the normal working current","A fuse rated below 5 A would melt during normal use, cutting power constantly."),
    ("exactly zero amperes","A 0 A fuse would never let the appliance work at all."),
    ("as high as possible so it never melts","A fuse that never melts gives no protection during a fault.")]),

 ("EC","In a simple circuit, conventional current is taken to flow through the wire starting from the:",
   "positive terminal of the cell",
   C("By agreement, conventional current is drawn flowing OUT of the positive terminal of the cell, through the circuit, and back into the negative terminal.")+
   steps("Current leaves the + terminal of the cell","Travels through the wires and the bulb","Returns to the - terminal of the cell.")+
   U("Circuit diagrams everywhere use this agreed direction."),
   [("negative terminal of the cell","Conventional current is taken to leave the +, not the - terminal."),
    ("both terminals at once","Current flows one way around the loop, not from both ends at once."),
    ("middle of the connecting wire","Current is driven by the cell's terminals, not from the wire's middle.")]),
]

# ---------- EXPONENTS & POWERS (25) ----------
EXP = [
 ("EXP","The expression 2^5 means:",
   "2 multiplied by itself five times (2 x 2 x 2 x 2 x 2)",
   C("In a^n, the base a is multiplied by itself n times. So 2^5 uses five 2's.")+
   steps("Base = 2, exponent = 5","2^5 = 2 x 2 x 2 x 2 x 2","= 32.")+
   U("Powers let us write repeated multiplication compactly."),
   [("2 x 5","That is just 10; a power is repeated multiplication, not 2 times 5."),
    ("5 x 5","The base is 2, not 5, so it cannot be 5 x 5."),
    ("2 + 2 + 2 + 2 + 2","That is repeated ADDITION (= 10), not a power.")]),

 ("EXP","The value of 3^4 is:",
   "81",
   C("3^4 means 3 x 3 x 3 x 3.")+
   steps("3 x 3 = 9","9 x 3 = 27","27 x 3 = 81.")+
   U("Powers of small numbers grow surprisingly fast."),
   [("12","That is 3 x 4; a power is not the base times the exponent."),
    ("64","64 is 4^3, not 3^4."),
    ("27","27 is 3^3; one more factor of 3 gives 81.")]),

 ("EXP","Using the laws of exponents, 3^2 x 3^3 equals:",
   "3^5",
   C("When multiplying powers with the SAME base, ADD the exponents.")+
   steps("Same base 3","Add exponents: 2 + 3 = 5","So 3^2 x 3^3 = 3^5.")+
   U("This rule keeps huge-number calculations short."),
   [("3^6","You add exponents (2+3=5), not multiply them (2x3=6)."),
    ("9^5","The base stays 3, not 9; only the exponents add."),
    ("3^1","Multiplying powers adds exponents; it does not subtract them.")]),

 ("EXP","Using the laws of exponents, 5^7 / 5^4 equals:",
   "5^3",
   C("When dividing powers with the SAME base, SUBTRACT the exponents.")+
   steps("Same base 5","Subtract exponents: 7 - 4 = 3","So 5^7 / 5^4 = 5^3.")+
   U("Division of powers shrinks big ratios neatly."),
   [("5^11","Division subtracts exponents (7-4=3); it does not add them."),
    ("5^(7/4)","You subtract the exponents, you do not divide them."),
    ("1^3","The base stays 5; it does not become 1.")]),

 ("EXP","The value of (2^3)^2 is:",
   "64",
   C("A power raised to a power MULTIPLIES the exponents: (2^3)^2 = 2^(3x2) = 2^6.")+
   steps("Multiply exponents: 3 x 2 = 6","2^6 = 64","So (2^3)^2 = 64.")+
   U("This rule appears when areas or volumes are themselves squared."),
   [("32","32 is 2^5; here the exponents multiply to 6, giving 64."),
    ("12","That is 2^3 x 2 done wrongly; (2^3)^2 = 2^6 = 64."),
    ("2","The value is 2^6 = 64, far from 2.")]),

 ("EXP","Any non-zero number raised to the power 0 equals:",
   "1",
   C("By the laws of exponents, a^0 = 1 for any non-zero a.")+
   steps("a^m / a^m = 1","But a^m / a^m = a^(m-m) = a^0","So a^0 = 1.")+
   U("This keeps the exponent rules consistent across all calculations."),
   [("0","a^0 is 1, not 0 (only when the base is non-zero)."),
    ("the number itself","a^1 equals the number; a^0 equals 1."),
    ("undefined","For a non-zero base, a^0 is well defined and equals 1.")]),

 ("EXP","The value of (-1)^100 is:",
   "1",
   C("A negative base raised to an EVEN power gives a positive result.")+
   steps("(-1) multiplied an even number of times","Pairs of (-1)x(-1) = +1","100 is even -> the result is +1.")+
   U("Even/odd power rules quickly fix the sign of an answer."),
   [("-1","-1 would come from an ODD power; 100 is even, so it is +1."),
    ("100","The exponent is not multiplied with the base; the value is 1."),
    ("-100","Neither the size nor the sign is -100; (-1) to any power is +1 or -1.")]),

 ("EXP","The value of (-1)^101 is:",
   "-1",
   C("A negative base raised to an ODD power stays negative.")+
   steps("Multiply (-1) an odd number of times","After pairing, one (-1) is left over","101 is odd -> the result is -1.")+
   U("This tells you the sign instantly without multiplying it all out."),
   [("1","+1 comes from an EVEN power; 101 is odd, so the result is -1."),
    ("101","The exponent is not the answer; the value is just -1."),
    ("-101","(-1) raised to any power is only +1 or -1, never -101.")]),

 ("EXP","The number 47000 written in standard form is:",
   "4.7 x 10^4",
   C("Standard form is k x 10^n with k between 1 and 10. Move the decimal so one non-zero digit stays before it.")+
   steps("47000 -> 4.7 (move decimal 4 places left)","4 places left -> x 10^4","So 47000 = 4.7 x 10^4.")+
   U("Scientists write huge numbers like star distances in standard form."),
   [("47 x 10^3","47 is not between 1 and 10, so this is not standard form."),
    ("4.7 x 10^3","4.7 x 10^3 = 4700, which is ten times too small."),
    ("0.47 x 10^5","0.47 is less than 1, so it is not proper standard form.")]),

 ("EXP","The number 5.2 x 10^3 equals:",
   "5200",
   C("Multiplying by 10^3 moves the decimal point three places to the right.")+
   steps("Start with 5.2","Move the decimal 3 places right","5.2 -> 52 -> 520 -> 5200.")+
   U("Converting from standard form back to a full number is a common step."),
   [("52000","That moves the decimal 4 places; 10^3 moves it only 3."),
    ("520","That moves the decimal only 2 places; 10^3 needs 3."),
    ("5.2000","Adding zeros after the decimal does not change the value 5.2.")]),

 ("EXP","Which is greater, 2^5 or 5^2?",
   "2^5",
   C("Work out both values and compare; do not assume the bigger base wins.")+
   steps("2^5 = 32","5^2 = 25","32 > 25, so 2^5 is greater.")+
   U("This shows why you must compute, not guess, with powers."),
   [("5^2","5^2 = 25, which is less than 2^5 = 32."),
    ("they are equal","32 is not equal to 25, so they are not equal."),
    ("they cannot be compared","Both are ordinary numbers and can be compared.")]),

 ("EXP","(2 x 3)^2 is equal to:",
   "2^2 x 3^2 = 36",
   C("A product raised to a power means each factor is raised to that power: (ab)^n = a^n b^n.")+
   steps("(2 x 3)^2 = 6^2 = 36","Also = 2^2 x 3^2 = 4 x 9 = 36","Both routes agree: 36.")+
   U("This rule simplifies squaring products in geometry and science."),
   [("2 x 3^2 = 18","Only the 3 is squared here; but the whole product is squared, giving 36."),
    ("2^2 x 3 = 12","Only the 2 is squared here; both factors must be squared."),
    ("2 x 3 x 2 = 12","That multiplies by 2 instead of squaring the product.")]),

 ("EXP","Expressed as a product of prime powers, 72 equals:",
   "2^3 x 3^2",
   C("Break 72 into prime factors, then group equal primes as powers.")+
   steps("72 = 2 x 36 = 2 x 2 x 18 = 2 x 2 x 2 x 9","= 2 x 2 x 2 x 3 x 3","= 2^3 x 3^2.")+
   U("Prime-power form is used to find HCF and LCM quickly."),
   [("2^2 x 3^3","2^2 x 3^3 = 4 x 27 = 108, not 72."),
    ("2^3 x 3^3","2^3 x 3^3 = 8 x 27 = 216, not 72."),
    ("2^4 x 3","2^4 x 3 = 16 x 3 = 48, not 72.")]),

 ("EXP","Using the laws of exponents, 10^3 x 10^2 x 10 equals:",
   "10^6",
   C("Multiplying powers of the same base adds the exponents (remember 10 = 10^1).")+
   steps("Exponents: 3, 2 and 1","Add them: 3 + 2 + 1 = 6","So the product is 10^6.")+
   U("Place-value and large numbers rest on powers of ten."),
   [("10^5","Do not forget the lone 10 counts as 10^1; total is 6, not 5."),
    ("10^7","The exponents add to 6 (3+2+1), not 7."),
    ("100^6","The base stays 10, not 100; only exponents add.")]),

 ("EXP","The value of 7^5 / 7^5 is:",
   "1",
   C("Any non-zero number divided by itself is 1; by the rule it is 7^(5-5) = 7^0 = 1.")+
   steps("Subtract exponents: 5 - 5 = 0","7^0 = 1","So 7^5 / 7^5 = 1.")+
   U("This is the everyday fact that anything divided by itself is 1."),
   [("7","Dividing equal powers gives 7^0 = 1, not 7."),
    ("0","A non-zero number over itself is 1, not 0."),
    ("7^10","Division subtracts exponents (5-5=0); it does not add them.")]),

 ("EXP","A distance is written as 9 x 10^7 km. Written in full, this is:",
   "90,000,000 km",
   C("10^7 means 1 followed by 7 zeros; multiply 9 by that.")+
   steps("10^7 = 10,000,000","9 x 10,000,000 = 90,000,000","So it is 90 million km.")+
   U("Distances in space are huge, so standard form is handy."),
   [("9,000,000 km","That is 9 x 10^6, one zero short."),
    ("900,000,000 km","That is 9 x 10^8, one zero too many."),
    ("79,000,000 km","9 x 10^7 is exactly 90 million, not 79 million.")]),

 ("EXP","Which of the following equals 64?",
   "2^6",
   C("Compute each power and compare with 64.")+
   steps("2^6 = 2x2x2x2x2x2 = 64","2^5 = 32, 4^4 = 256, 3^4 = 81","Only 2^6 equals 64.")+
   U("Recognising powers of 2 is useful in computers (bits and bytes)."),
   [("2^5","2^5 = 32, which is half of 64."),
    ("4^4","4^4 = 256, much larger than 64."),
    ("3^4","3^4 = 81, not 64.")]),

 ("EXP","Since a^3 = a x a x a, the product a^3 x a^2 is the same as:",
   "a x a x a x a x a = a^5",
   C("Write out the factors: three a's times two a's makes five a's.")+
   steps("a^3 = a x a x a","a^2 = a x a","Together: five a's = a^5 (exponents add: 3+2=5).")+
   U("Seeing WHY exponents add makes the rule easy to remember."),
   [("a^6","Exponents ADD when multiplying (3+2=5); they are not multiplied."),
    ("a^9","3 + 2 = 5, not 9."),
    ("a^1","Multiplying powers increases the exponent to 5, not down to 1.")]),

 ("EXP","Six lakh forty thousand (6,40,000) written in standard form is:",
   "6.4 x 10^5",
   C("Place one non-zero digit before the decimal; count how many places it moved.")+
   steps("640000 -> 6.4 (decimal moved 5 places left)","5 places -> x 10^5","So 6,40,000 = 6.4 x 10^5.")+
   U("Population and money figures are often shown in standard form."),
   [("64 x 10^4","64 is not between 1 and 10, so this is not standard form."),
    ("6.4 x 10^4","6.4 x 10^4 = 64000, which is ten times too small."),
    ("0.64 x 10^6","0.64 is less than 1, so it is not proper standard form.")]),

 ("EXP","(5^2)^3 has the same value as:",
   "5^6",
   C("A power of a power multiplies the exponents: (5^2)^3 = 5^(2x3).")+
   steps("Multiply exponents: 2 x 3 = 6","So (5^2)^3 = 5^6","(In full, that is 15625.)")+
   U("This rule keeps repeated squaring/cubing manageable."),
   [("5^5","Here exponents multiply (2x3=6), they do not add (2+3=5)."),
    ("5^8","2 x 3 = 6, not 8."),
    ("5^23","You multiply the exponents (2x3=6); you do not stick them together as 23.")]),

 ("EXP","Without multiplying it all out, the sign of (-2)^6 is:",
   "positive",
   C("A negative base to an EVEN power is positive, because the minus signs pair up.")+
   steps("(-2) used 6 times","6 is even -> minus signs cancel in pairs","So the result is positive (in fact +64).")+
   U("Knowing the sign first guards against careless errors."),
   [("negative","A negative result needs an ODD power; 6 is even."),
    ("zero","(-2)^6 = 64, which is not zero."),
    ("cannot be decided without full multiplication","The even exponent alone fixes the sign as positive.")]),

 ("EXP","Which is greater, 3^4 or 4^3?",
   "3^4",
   C("Compute both: do not assume the larger base or exponent wins.")+
   steps("3^4 = 81","4^3 = 64","81 > 64, so 3^4 is greater.")+
   U("Comparing powers correctly needs actual values, not guesses."),
   [("4^3","4^3 = 64, which is less than 3^4 = 81."),
    ("they are equal","81 is not equal to 64."),
    ("they cannot be compared","Both are ordinary numbers and can be compared.")]),

 ("EXP","Simplify 2^8 / (2^3 x 2^2).",
   "2^3 (= 8)",
   C("Combine the bottom first by adding exponents, then divide by subtracting exponents.")+
   steps("Bottom: 2^3 x 2^2 = 2^5","2^8 / 2^5 = 2^(8-5)","= 2^3 = 8.")+
   U("Layered exponent rules show up in scientific calculations."),
   [("2^13","You must DIVIDE, so subtract; do not add all exponents."),
    ("2^3 = 6","2^3 = 8, not 6 (2x2x2 = 8)."),
    ("2^(8/5)","Dividing powers subtracts exponents (8-5=3); it does not divide them.")]),

 ("EXP","A number in standard form is written as k x 10^n. The value of k must satisfy:",
   "1 <= k < 10",
   C("Standard form keeps exactly one non-zero digit before the decimal point, so k is at least 1 but less than 10.")+
   steps("k must have one digit before the decimal","That digit is from 1 to 9","So 1 <= k < 10.")+
   U("This rule makes every standard-form number unique and easy to compare."),
   [("k can be any whole number","If k were 47, say, it would not be standard form."),
    ("k is always greater than 10","Standard form needs k below 10, not above it."),
    ("k is exactly 10","If k reached 10 we would rewrite it as 1 x 10^(n+1).")]),

 ("EXP","Light travels about 3 x 10^5 km in one second. In 2 seconds it travels:",
   "6 x 10^5 km",
   C("Multiply only the number in front (the coefficient) by 2; the power of ten stays the same.")+
   steps("Distance = speed x time","= (3 x 10^5) x 2","= 6 x 10^5 km.")+
   U("This is how astronomers scale up distances light covers."),
   [("3 x 10^10 km","You double the 3, not the exponent; the power of ten is unchanged."),
    ("6 x 10^10 km","The exponent must stay 5; only the coefficient doubles."),
    ("3 x 10^25 km","Neither the coefficient nor the exponent is changed this way.")]),
]

assert len(ABS)==25 and len(ALG)==25 and len(EC)==25 and len(EXP)==25, (
    len(ABS), len(ALG), len(EC), len(EXP))

# Interleave so no two consecutive questions share a chapter, and Science/Maths alternate.
items = []
for i in range(25):
    items += [ABS[i], ALG[i], EC[i], EXP[i]]
assert len(items) == 100

# Guard: no two consecutive same chapter.
for a, b in zip(items, items[1:]):
    assert a[0] != b[0], (a[1], b[1])

if __name__ == "__main__":
    here = os.path.dirname(os.path.abspath(__file__))
    papers_dir = os.path.abspath(os.path.join(
        here, "..", "..", "desktopAhaan", "Resources", "BossChallengePapers"))
    os.chdir(papers_dir)  # build_paper writes Paper_08_<SHORT>/ here

    keydist = build_paper(PNUM, TITLE, SHORT, LABELS, items, seed=8081,
                          append_manifest=False)

    # Flatten the engine's per-paper folder into the flat, prefixed names the
    # in-app browser + pbxproj generator expect.
    subdir = f"Paper_{PNUM}_{SHORT}"
    moves = {
        "QuestionPaper.html": f"Paper_{PNUM}_{SHORT}_QuestionPaper.html",
        "QuestionPaper.pdf":  f"Paper_{PNUM}_{SHORT}_QuestionPaper.pdf",
        "Questions.md":       f"Paper_{PNUM}_{SHORT}_Questions.md",
        "Solutions.html":     f"Paper_{PNUM}_{SHORT}_Solutions.html",
    }
    for src, dst in moves.items():
        shutil.move(os.path.join(subdir, src), dst)
    os.rmdir(subdir)

    # Curated manifest row (date today; balanced 25/25/25/25 split).
    counts = {}
    for ch, *_ in items:
        counts[ch] = counts.get(ch, 0) + 1
    split = "/".join(str(counts[c]) for c in ("ABS", "EC", "ALG", "EXP"))
    with open("PAPERS_MANIFEST.md", "a", encoding="utf-8") as fh:
        fh.write(f"| {PNUM} | 2026-06-18 | {TITLE} | {split} | ✓ |\n")

    print("Files:", sorted(v for v in moves.values()))
    print("Answer key spread A/B/C/D =", dict(keydist))
