# -*- coding: utf-8 -*-
# Boss Challenge Paper 54 — Reproduction in Plants · Winds, Storms & Cyclones ·
#                           Algebraic Expressions · Fractions & Decimals
# Content-only. Uses the dependency-free examfactory engine.
# Difficulty ramp: leans into FUSION. The seeds in a pod become a FRACTION; a
# cyclone's rising wind speed becomes a DIFFERENCE and a RATE; the number of
# seeds in many pods becomes an ALGEBRAIC expression; a plant's daily growth
# becomes a formula in a variable; rainfall over two days becomes a DECIMAL sum.
# A Science situation, a Maths skill.
# Class-7 scope, simple wording, hard thinking.
# Produces, under Resources/BossChallengePapers/:
#   Paper_54_<SHORT>_QuestionPaper.html  (pure HTML — questions + options)
#   Paper_54_<SHORT>_QuestionPaper.pdf
#   Paper_54_<SHORT>_Questions.md
#   Paper_54_<SHORT>_Solutions.html
import os, sys, shutil, json, re
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from examfactory import build_paper, C, steps, U

PNUM  = "54"
SHORT = "ReproductionPlants_WindsStorms_AlgExpr_FractionsDecimals"
TITLE = ("Reproduction in Plants · Winds, Storms & Cyclones · "
         "Algebraic Expressions · Fractions & Decimals")
LABELS = {
    "RP": "Reproduction in Plants",
    "WS": "Winds, Storms & Cyclones",
    "AE": "Algebraic Expressions",
    "FD": "Fractions & Decimals",
}

# ---------- REPRODUCTION IN PLANTS (25) — several fused with fractions ----------
RP = [
 ("RP","A potato left in a basket sprouts new shoots from the buds (the 'eyes') on its surface. This way of making new plants without seeds is called:",
   "vegetative propagation",
   C("Vegetative propagation is asexual reproduction in which a new plant grows from a part of the parent — here, the buds on a potato tuber.")+
   steps("New plant grows from a part of the parent","no seeds or flowers are involved","this is vegetative propagation.")+
   U("Farmers plant pieces of potato with buds to raise a whole field of potato plants."),
   [("pollination","Pollination is the transfer of pollen between flowers; growing a shoot from a tuber bud is vegetative propagation."),
    ("fertilisation","Fertilisation is the fusion of male and female gametes; a sprouting potato makes new plants asexually, by vegetative propagation."),
    ("germination of a seed","No seed is involved here — the shoot grows from a bud on the tuber, which is vegetative propagation.")]),

 ("WS","A balloon stays firm and rounded when blown up because the air trapped inside pushes outward on its walls. This shows that air:",
   "exerts pressure",
   C("Air pushing outward on the balloon's walls is air pressure. Air, though invisible, presses on everything it touches.")+
   steps("Air inside pushes on the walls","this outward push is a force over area","so air exerts pressure.")+
   U("The firm feel of a pumped-up cycle tyre is the air pressure inside it pushing out."),
   [("has no weight","Air does have weight; the point shown by the firm balloon is that air exerts pressure."),
    ("cannot move","Air moves easily as wind; the balloon shows that trapped air exerts pressure on its walls."),
    ("is solid","Air is a gas, not a solid; the balloon stays firm because the air inside exerts pressure.")]),

 ("AE","In algebra a letter such as x, which can stand for different numbers at different times, is called a:",
   "variable",
   C("A variable is a symbol (often a letter) that can take different values. Its value is not fixed.")+
   steps("A letter stands in for a number","its value can change","such a symbol is a variable.")+
   U("Spreadsheets use variables so one formula works for whatever number you type in a cell."),
   [("constant","A constant has a FIXED value (like 7); a letter that can change value is a variable."),
    ("coefficient","A coefficient is the number multiplying a variable (the 5 in 5x); the changeable letter itself is a variable."),
    ("equation","An equation is a statement that two expressions are equal; the changeable symbol in it is a variable.")]),

 ("FD","Adding the two fractions one-half and one-quarter together, the sum 1/2 + 1/4 comes to:",
   "3/4",
   C("Make the denominators the same: 1/2 = 2/4. Then 2/4 + 1/4 = 3/4.")+
   steps("1/2 = 2/4","2/4 + 1/4","= 3/4.")+
   U("Half a cup plus a quarter cup of flour is three-quarters of a cup in all."),
   [("2/6","2/6 wrongly adds tops and bottoms separately; with a common denominator 1/2 + 1/4 = 3/4."),
    ("1/4","1/4 is only the second fraction; added to 1/2 it gives 3/4."),
    ("1/2","1/2 ignores the quarter being added; 1/2 + 1/4 = 3/4.")]),

 ("RP","The part of a flower that makes the dust-like pollen grains is the anther, which is held up on a stalk. The anther together with its stalk is the:",
   "stamen",
   C("The stamen is the male part of a flower: an anther (which makes pollen) on a stalk called the filament.")+
   steps("Pollen is made in the anther","the anther sits on a stalk","anther + stalk = the stamen, the male part.")+
   U("Brushing past a lily, you may get yellow pollen from its stamens on your clothes."),
   [("pistil","The pistil is the FEMALE part (stigma, style, ovary); the pollen-making male part is the stamen."),
    ("petal","Petals are the coloured leaves that attract insects, not the pollen-maker; that is the stamen."),
    ("sepal","Sepals are the small green parts protecting the bud; the pollen-bearing male part is the stamen.")]),

 ("WS","Whenever a portion of air is heated, it expands, becomes lighter than the cooler air around it, and therefore tends to:",
   "rise upward",
   C("Warm air expands and grows less dense than the surrounding cool air, so the lighter warm air rises.")+
   steps("Heated air expands","it becomes lighter (less dense) than cool air","so the warm air rises up.")+
   U("A hot-air balloon floats up because the air inside it is heated and rises."),
   [("sink to the floor","It is COOL, heavier air that sinks; the heated, lighter air rises."),
    ("stay exactly in place","Warm air does not stay put — being lighter, it rises above the cooler air."),
    ("turn into water","Heating does not turn air to water; warmed air simply expands and rises.")]),

 ("AE","In the algebraic term 5x, the number 5 that multiplies the variable x is known as its:",
   "coefficient",
   C("In a term like 5x, the number multiplying the variable is the coefficient. Here the coefficient of x is 5.")+
   steps("Term = number x variable","the number part 5","is the coefficient of x.")+
   U("In 'cost = 5n', the 5 is the coefficient — the price per item multiplying the count n."),
   [("variable","The variable is the changeable letter x; the number 5 multiplying it is the coefficient."),
    ("constant","A constant stands alone with no variable; 5 here multiplies x, so it is the coefficient."),
    ("exponent","An exponent is a small raised power; the 5 multiplying x is the coefficient, not an exponent.")]),

 ("FD","Taking one-half of one-third, the product 1/2 x 1/3 works out to:",
   "1/6",
   C("To multiply fractions, multiply the tops and multiply the bottoms: (1x1)/(2x3) = 1/6.")+
   steps("Multiply numerators: 1 x 1 = 1","multiply denominators: 2 x 3 = 6","= 1/6.")+
   U("Half of a third of a pizza is one-sixth of the whole pizza."),
   [("2/5","2/5 wrongly adds across; multiplying 1/2 by 1/3 gives 1/6."),
    ("1/3","1/3 ignores the halving; half of 1/3 is 1/6."),
    ("3/2","3/2 flips the fractions; the product 1/2 x 1/3 is 1/6.")]),

 ("RP","When pollen grains move from a flower's anther across to the stigma, whether on the same bloom or another, this process is called:",
   "pollination",
   C("Pollination is the moving of pollen from the anther to the stigma. It must happen before fertilisation can occur.")+
   steps("Pollen leaves the anther","it lands on the stigma","this transfer is pollination.")+
   U("Bees carry out pollination as they move from flower to flower collecting nectar."),
   [("fertilisation","Fertilisation is the LATER fusion of gametes; the earlier transfer of pollen to the stigma is pollination."),
    ("germination","Germination is a seed sprouting into a seedling; pollen moving to the stigma is pollination."),
    ("respiration","Respiration is how living things release energy; moving pollen to the stigma is pollination.")]),

 ("WS","Wind always blows from a place where the air pressure is higher towards a place where the air pressure is:",
   "lower",
   C("Air moves from high pressure to low pressure. This movement of air is what we feel as wind.")+
   steps("Air pushes from where pressure is high","towards where pressure is low","that moving air is the wind.")+
   U("A sea breeze blows from the cooler high-pressure sea towards the warmer low-pressure land."),
   [("higher","Wind moves AWAY from high pressure, towards LOW pressure, not towards higher pressure."),
    ("exactly equal","If pressures were equal there would be no push and no wind; wind needs higher-to-lower pressure."),
    ("frozen","'Frozen' describes temperature, not pressure; wind flows from higher to lower pressure.")]),

 ("AE","Collecting the like terms 4x and 3x into a single term, the sum 4x + 3x equals:",
   "7x",
   C("Like terms have the same variable, so their coefficients simply add: 4 + 3 = 7, giving 7x.")+
   steps("4x and 3x are like terms","add the coefficients 4 + 3 = 7","= 7x.")+
   U("Adding 4 apples-worth and 3 apples-worth gives 7 apples-worth — the same idea as 4x + 3x."),
   [("12x","12 multiplies 4 and 3; like terms ADD their coefficients, giving 4 + 3 = 7x."),
    ("7","Dropping the x loses the variable; 4x + 3x keeps it, giving 7x."),
    ("7x^2","The power of x does not change when adding like terms; 4x + 3x = 7x, not 7x^2.")]),

 ("FD","Adding the two decimals 0.5 and 0.25, the sum 0.5 + 0.25 comes to:",
   "0.75",
   C("Line up the decimal points and add: 0.50 + 0.25 = 0.75.")+
   steps("Write 0.50 + 0.25","add place by place","= 0.75.")+
   U("Half a litre plus a quarter litre of water is 0.75 litre in the jug."),
   [("0.30","0.30 mis-adds the digits; 0.50 + 0.25 = 0.75."),
    ("0.7","0.7 drops the last digit; 0.50 + 0.25 = 0.75."),
    ("7.5","7.5 misplaces the decimal point; the sum is 0.75.")]),

 ("RP","A pod splits open to reveal 8 seeds, and exactly 6 of them are healthy enough to sprout. The fraction of the seeds that will sprout is:",
   "3/4",
   C("The fraction is sprouting seeds over total seeds: 6/8. Dividing top and bottom by 2 gives 3/4.")+
   steps("Fraction = 6 of 8 = 6/8","divide top and bottom by 2","= 3/4.")+
   U("A seed packet's 'germination rate' is exactly this fraction of seeds that grow."),
   [("6/8","6/8 is correct but NOT in lowest terms; dividing both by 2 gives 3/4."),
    ("8/6","8/6 turns the fraction upside down; sprouting over total is 6/8 = 3/4."),
    ("1/4","1/4 is the fraction that did NOT sprout (2 of 8); the sprouting fraction is 3/4.")]),

 ("WS","Holding a paper strip to your lips and blowing hard over its upper surface makes the free end lift up. This happens because fast-moving air has a:",
   "lower pressure",
   C("Fast-moving air has lower pressure. The slower air below the paper, at higher pressure, pushes it up into the fast stream.")+
   steps("You speed up the air above the paper","fast air has lower pressure","higher pressure below lifts the paper.")+
   U("The same low-pressure-above effect helps lift an aeroplane's wing."),
   [("higher pressure","Fast-moving air has LOWER pressure, not higher; that is why the paper is pushed up into it."),
    ("no effect on pressure","Moving air clearly changes pressure here; faster air means lower pressure, lifting the paper."),
    ("a solid surface","Air is not solid; the lift comes from fast air above having lower pressure.")]),

 ("AE","An algebraic expression made up of just a single term, such as 7y, is given the special name:",
   "monomial",
   C("'Mono' means one. An expression with exactly one term, like 7y, is a monomial.")+
   steps("'Mono' = one","one term only, e.g. 7y","such an expression is a monomial.")+
   U("Naming expressions by their number of terms helps describe formulas precisely."),
   [("binomial","A binomial has TWO terms (like x + 3); a single term such as 7y is a monomial."),
    ("trinomial","A trinomial has THREE terms; one term alone is a monomial."),
    ("equation","An equation has an equals sign joining two sides; a single term like 7y is a monomial.")]),

 ("FD","Finding one-half of 6 by multiplying, the value of 1/2 x 6 is:",
   "3",
   C("One-half of 6 means 6 divided by 2, which is 3.")+
   steps("1/2 x 6 = 6 / 2","= 3.")+
   U("Sharing 6 sweets equally between 2 children gives each one-half, i.e. 3 sweets."),
   [("12","12 doubles instead of halving; half of 6 is 3."),
    ("6","6 is the whole amount; one-half of it is 3."),
    ("2","2 is the denominator, not the answer; half of 6 is 3.")]),

 ("RP","In the tiny fungus called yeast, a small bulge grows out of the parent cell and then pinches off to live on its own. This form of asexual reproduction is:",
   "budding",
   C("In budding, a new individual grows as an outgrowth (a bud) on the parent and later separates. Yeast reproduces this way.")+
   steps("A bulge (bud) grows on the parent","it pinches off","this is reproduction by budding.")+
   U("Yeast budding rapidly is what makes bread dough rise as it multiplies."),
   [("fragmentation","Fragmentation is the parent BREAKING into pieces; a bud growing out and separating is budding."),
    ("pollination","Pollination involves flowers and pollen; a yeast cell making a bud is budding."),
    ("fertilisation","Fertilisation needs two gametes to fuse; yeast simply forms a bud, which is budding.")]),

 ("WS","A cyclone is a huge weather system built around a centre of very low air pressure, with strong winds spiralling inwards. The calm region at its very centre is called the:",
   "eye",
   C("The centre of a cyclone, where the air is calm and skies may clear briefly, is called the eye of the cyclone.")+
   steps("Strong winds spiral around a low-pressure centre","the centre itself is calm","that calm centre is the eye.")+
   U("Satellite pictures of a cyclone show a clear round 'eye' at its middle."),
   [("tail","A cyclone has no 'tail'; its calm low-pressure centre is the eye."),
    ("crest","'Crest' is the top of a wave, not part of a cyclone; the calm centre is the eye."),
    ("front","A 'front' is a boundary between air masses; the calm cyclone centre is the eye.")]),

 ("AE","Counting the separate terms in the expression 3x + 4y - 7, the number of terms is:",
   "three",
   C("Terms are the parts separated by + or - signs. Here 3x, 4y and -7 are three terms, so the expression is a trinomial.")+
   steps("Parts separated by + and -","3x, 4y and -7","that is three terms.")+
   U("Knowing how many terms an expression has tells you whether it is a monomial, binomial or trinomial."),
   [("one","An expression with one term is a monomial; 3x + 4y - 7 has three separate terms."),
    ("two","Two terms would be a binomial; here 3x, 4y and -7 make three terms."),
    ("seven","7 is one of the numbers, not the count of terms; there are three terms.")]),

 ("FD","Adding the decimals 1.5 and 2.5 together, the sum 1.5 + 2.5 equals:",
   "4",
   C("Add the whole and decimal parts: 1.5 + 2.5 = 4.0, which is just 4.")+
   steps("1.5 + 2.5","= 4.0","= 4.")+
   U("1.5 litres of juice plus 2.5 litres makes exactly 4 litres."),
   [("3.10","3.10 mis-adds the halves; 1.5 + 2.5 = 4."),
    ("4.10","4.10 wrongly tacks on the tenths; the two halves combine to a whole, giving 4."),
    ("3.5","3.5 forgets to carry the two halves into a whole; 1.5 + 2.5 = 4.")]),

 ("RP","A pond plant called Spirogyra grows into a long thread that breaks into smaller pieces, and each piece grows into a new plant. This kind of asexual reproduction is:",
   "fragmentation",
   C("In fragmentation, the body of the parent breaks into fragments and each fragment grows into a new individual.")+
   steps("The thread breaks into pieces","each piece grows into a new plant","this is fragmentation.")+
   U("Spirogyra can quickly cover a pond because each broken fragment becomes a new plant."),
   [("budding","Budding makes a new plant from an OUTGROWTH on the parent; breaking into pieces is fragmentation."),
    ("pollination","Pollination is about flowers and pollen; a thread breaking into growing pieces is fragmentation."),
    ("germination","Germination is a seed sprouting; Spirogyra breaking into pieces is fragmentation.")]),

 ("WS","Light, dry seeds fitted with wings or tufts of hair, such as those of the drumstick or madar plant, are carried far from the parent mainly by:",
   "wind",
   C("Winged or hairy seeds are light and catch the moving air, so the wind carries them away from the parent plant.")+
   steps("The seeds are light, with wings or hairs","moving air catches them","so the wind disperses them.")+
   U("Dandelion 'parachutes' drifting on the breeze show wind dispersal in action."),
   [("water","Water disperses seeds that float, like the coconut; light winged or hairy seeds are spread by wind."),
    ("animals","Animals carry seeds with hooks or tasty fruits; winged, hairy seeds are blown by the wind."),
    ("sound","Sound cannot move seeds; light winged seeds are dispersed by the wind.")]),

 ("AE","Writing 'five more than a number n' as an algebraic expression gives:",
   "n + 5",
   C("'Five more than n' means start with n and add 5, written n + 5.")+
   steps("Start with the number n","'more than' means add","add 5 -> n + 5.")+
   U("If you are 5 years older than your cousin aged n, your age is n + 5."),
   [("5n","5n means 5 TIMES n, not 5 more than n; 'five more than n' is n + 5."),
    ("n - 5","n - 5 is 5 LESS than n; 'five more than n' adds, giving n + 5."),
    ("5 - n","5 - n subtracts n from 5; 'five more than a number n' is n + 5.")]),

 ("FD","A gardener sows 200 seeds and 0.6 of them come up as seedlings. The number of seeds that germinated is:",
   "120",
   C("0.6 of 200 means 0.6 x 200 = 120 seeds.")+
   steps("Germinated = 0.6 x 200","= 120 seeds.")+
   U("Seed companies state a decimal germination rate so you know how many of a packet will grow."),
   [("60","60 would be 0.3 of 200; 0.6 x 200 = 120 seeds."),
    ("6","6 misplaces the decimal; 0.6 of 200 is 120, not 6."),
    ("200","200 is the total sown; only 0.6 of them, i.e. 120 seeds, germinated.")]),

 ("RP","After fertilisation inside a flower, the ovule grows and develops into the:",
   "seed",
   C("Once fertilised, each ovule turns into a seed, which can later grow into a new plant.")+
   steps("Fertilisation happens inside the ovule","the fertilised ovule develops","into a seed.")+
   U("The peas inside a pod are the seeds that each grew from a fertilised ovule."),
   [("fruit","It is the OVARY (not the ovule) that becomes the fruit; the ovule becomes the seed."),
    ("flower","The flower is what existed BEFORE fertilisation; the fertilised ovule becomes the seed."),
    ("root","The root is part of the growing plant later; the fertilised ovule itself becomes the seed.")]),

 ("WS","A wide stretch of warm ocean adds large amounts of water vapour and heat to the air above it, which is why violent cyclones most often build up over:",
   "warm seas near the coast",
   C("Cyclones draw their energy from warm, moist ocean air, so they form over warm seas and strike coastal areas.")+
   steps("Warm seas add heat and water vapour to the air","this feeds the rising, spiralling storm","so cyclones form over warm coastal seas.")+
   U("Coastal towns get cyclone warnings because cyclones gather strength over the nearby warm sea."),
   [("cold mountain tops","Cold, dry mountain air cannot fuel a cyclone; cyclones build over warm, moist seas."),
    ("dry deserts","Deserts lack the water vapour a cyclone needs; cyclones form over warm coastal seas."),
    ("deep underground caves","Caves have no role in weather; cyclones grow over warm seas near the coast.")]),

 ("AE","Replacing x with 3 in the expression x + 5, its value becomes:",
   "8",
   C("Substitute x = 3: the expression x + 5 becomes 3 + 5 = 8.")+
   steps("Put x = 3","3 + 5","= 8.")+
   U("Plugging a number into a formula to get a result is exactly this 'finding the value'."),
   [("15","15 multiplies 3 by 5; the expression ADDS, giving 3 + 5 = 8."),
    ("35","35 just writes the digits together; x + 5 at x = 3 is 3 + 5 = 8."),
    ("2","2 subtracts 3 from 5; the expression x + 5 at x = 3 is 8.")]),

 ("RP","The female reproductive part of a flower, made up of the stigma, the style and the ovary, is called the:",
   "pistil",
   C("The pistil is the female part of a flower. Its sticky top is the stigma, on a stalk (style) above the ovary, which holds the ovules.")+
   steps("Female part of the flower","stigma + style + ovary","together form the pistil.")+
   U("The swelling base of a flower's pistil, the ovary, later becomes the fruit."),
   [("stamen","The stamen is the MALE part that makes pollen; the female part is the pistil."),
    ("petal","Petals are the coloured parts that attract pollinators; the female part is the pistil."),
    ("sepal","Sepals are the green parts protecting the bud; the female reproductive part is the pistil.")]),

 ("WS","An open tin can with a little water is boiled, then sealed and cooled. It suddenly crumples inward. The can is crushed because, after the steam cools, it is pushed by the:",
   "greater air pressure outside the can",
   C("Cooling turns the steam back to water, leaving low pressure inside. The higher outside air pressure then pushes the can in.")+
   steps("Steam cools and condenses, lowering inside pressure","outside air pressure is now greater","it pushes the can inward.")+
   U("This crushing-can demonstration is the classic proof that air presses with real force."),
   [("water boiling again inside","Boiling would push the walls OUT, not in; the can is crushed by the greater outside air pressure."),
    ("the metal melting","The can does not melt — it is crushed by the higher air pressure outside it."),
    ("a magnet pulling it","No magnet is involved; the outside air pressure, now greater, pushes the can inward.")]),

 ("AE","Substituting x = 4 into the expression 2x + 3, the value of the expression is:",
   "11",
   C("Put x = 4: 2x + 3 = 2 x 4 + 3 = 8 + 3 = 11.")+
   steps("2x = 2 x 4 = 8","8 + 3","= 11.")+
   U("Working out '2 times the items plus a 3-rupee fee' uses this same substitution."),
   [("14","14 adds 3 to 11 by mistake, or multiplies wrongly; 2 x 4 + 3 = 11."),
    ("9","9 forgets to double x; 2 x 4 + 3 = 11, not 4 + 3 + ... "),
    ("24","24 multiplies everything together; 2x + 3 at x = 4 is 8 + 3 = 11.")]),

 ("FD","The reciprocal of the fraction 2/3 (the fraction you turn it upside down to get) is:",
   "3/2",
   C("To find a reciprocal, swap the top and bottom. The reciprocal of 2/3 is 3/2.")+
   steps("Swap numerator and denominator","2/3 becomes 3/2.")+
   U("Dividing by a fraction means multiplying by its reciprocal — a key trick with fractions."),
   [("2/3","2/3 is the original fraction; its reciprocal flips it to 3/2."),
    ("1/6","1/6 multiplies the parts; the reciprocal simply flips 2/3 to 3/2."),
    ("6","6 multiplies 2 and 3; the reciprocal of 2/3 is the flipped fraction 3/2.")]),

 ("RP","Flowers that are brightly coloured, sweetly scented and rich in nectar are usually adapted to be pollinated by:",
   "insects",
   C("Bright colour, scent and nectar attract insects such as bees and butterflies, which carry the pollen between flowers.")+
   steps("Colour, scent and nectar attract visitors","bees and butterflies come for the nectar","so such flowers are insect-pollinated.")+
   U("A garden buzzing with bees is full of insect-pollinated flowers."),
   [("wind","Wind-pollinated flowers are usually small, dull and without scent or nectar; showy scented ones attract insects."),
    ("water","Water pollinates certain aquatic plants; showy, nectar-rich flowers are pollinated by insects."),
    ("sunlight","Sunlight gives energy but does not carry pollen; bright scented flowers are pollinated by insects.")]),

 ("WS","At a weather station, the device with spinning cups that records how fast the wind blows is the:",
   "anemometer",
   C("An anemometer, often with spinning cups, measures how fast the wind is blowing.")+
   steps("Wind turns the cups of the device","the faster the wind, the faster they spin","this wind-speed meter is the anemometer.")+
   U("Weather stations use an anemometer to record wind speed for forecasts and cyclone warnings."),
   [("thermometer","A thermometer measures temperature, not wind speed; that is the anemometer."),
    ("barometer","A barometer measures air pressure; wind speed is measured by the anemometer."),
    ("rain gauge","A rain gauge measures rainfall; wind speed is measured by the anemometer.")]),

 ("AE","Naming the type of expression that has exactly two terms, such as x + 7, we call it a:",
   "binomial",
   C("'Bi' means two. An expression with exactly two terms, like x + 7, is a binomial.")+
   steps("'Bi' = two","two terms, e.g. x + 7","such an expression is a binomial.")+
   U("Describing an expression as a binomial tells others at once that it has two terms."),
   [("monomial","A monomial has just ONE term; two terms like x + 7 make a binomial."),
    ("trinomial","A trinomial has THREE terms; x + 7 has two, so it is a binomial."),
    ("variable","A variable is a single changeable letter, not an expression; x + 7 is a binomial.")]),

 ("FD","Dividing one-half by one-quarter, the value of 1/2 ÷ 1/4 is:",
   "2",
   C("To divide by a fraction, multiply by its reciprocal: 1/2 x 4/1 = 4/2 = 2.")+
   steps("1/2 ÷ 1/4 = 1/2 x 4/1","= 4/2","= 2.")+
   U("How many quarter-cups fit in a half-cup? Exactly 2 — that is this division."),
   [("1/8","1/8 multiplies the two fractions; DIVIDING flips the second, giving 2."),
    ("1/2","1/2 forgets to divide; 1/2 ÷ 1/4 = 2."),
    ("4","4 uses the reciprocal but forgets the 1/2; 1/2 x 4 = 2.")]),

 ("RP","After fertilisation, while the ovule becomes the seed, the ovary of the flower grows and ripens into the:",
   "fruit",
   C("The ovary, the swollen base of the pistil, develops into the fruit, which encloses and protects the seeds.")+
   steps("Ovule -> seed","ovary -> grows and ripens","into the fruit that holds the seeds.")+
   U("A tomato is a ripened ovary — a fruit — with its seeds inside."),
   [("seed","The ovule (inside the ovary) becomes the seed; the ovary itself becomes the fruit."),
    ("root","The root anchors the plant; the ovary develops into the fruit."),
    ("petal","Petals usually fall off after fertilisation; the ovary becomes the fruit.")]),

 ("WS","During a thunderstorm, warm moist air rises rapidly, cools high up, and its water vapour turns into water droplets. This change of vapour into droplets is called:",
   "condensation",
   C("Condensation is water vapour turning into liquid water droplets when air cools. Rising moist air in a storm cools and condenses into clouds and rain.")+
   steps("Warm moist air rises and cools","its water vapour turns to droplets","this is condensation.")+
   U("Dew forming on cool morning grass is everyday condensation, the same process as in storm clouds."),
   [("evaporation","Evaporation is liquid water turning INTO vapour — the opposite; vapour turning to droplets is condensation."),
    ("germination","Germination is a seed sprouting; vapour becoming droplets in a storm is condensation."),
    ("filtration","Filtration separates solids from liquids; water vapour turning to droplets is condensation.")]),

 ("AE","The number of seeds in one pod is the same in every pod of a plant. If each pod has p seeds, the total number of seeds in 6 such pods is:",
   "6p",
   C("Six pods, each with p seeds, hold 6 x p = 6p seeds in all.")+
   steps("Seeds per pod = p","6 pods means 6 x p","= 6p seeds.")+
   U("Writing a total as 6p lets a botanist work out seeds for any pod size p."),
   [("p + 6","p + 6 ADDS 6 instead of multiplying; 6 pods of p seeds is 6 x p = 6p."),
    ("6","6 counts only the pods, not the seeds; with p seeds each, the total is 6p."),
    ("p/6","p/6 divides instead of multiplying; 6 pods of p seeds total 6p.")]),

 ("FD","Comparing the two fractions 1/2 and 1/3, the larger fraction is:",
   "1/2",
   C("With the same numerator, the fraction with the smaller denominator is larger. Halves are bigger than thirds, so 1/2 > 1/3.")+
   steps("Same top (1), compare bottoms","smaller bottom = bigger piece","so 1/2 is larger than 1/3.")+
   U("Half a chocolate bar is more than a third of the same bar."),
   [("1/3","1/3 is the SMALLER piece; with equal tops, the smaller denominator (1/2) is larger."),
    ("they are equal","1/2 and 1/3 are not equal; one half is larger than one third."),
    ("1/6","1/6 is smaller than both; comparing the two given fractions, 1/2 is the larger.")]),

 ("RP","Some seeds are covered with tiny hooks or stiff spines that catch onto the fur of passing animals and are carried away. These seeds are dispersed by:",
   "animals",
   C("Hooked or spiny seeds cling to the fur (or clothes) of animals, which carry them to new places — dispersal by animals.")+
   steps("Hooks and spines grip animal fur","the animal carries the seed away","this is dispersal by animals.")+
   U("Burrs sticking to a dog's coat after a walk are seeds being dispersed by an animal."),
   [("wind","Wind carries light, winged or hairy seeds; hooked, clinging seeds are carried by animals."),
    ("water","Water carries floating seeds like the coconut; hooked seeds cling to fur and are spread by animals."),
    ("sunlight","Sunlight cannot carry seeds; hooked, clinging seeds are dispersed by animals.")]),

 ("WS","A steady fall in the reading of a barometer (the air pressure dropping over a few hours) is often a useful warning that there may soon be:",
   "a storm",
   C("Falling air pressure usually means stormy weather is on the way, so a dropping barometer warns of a coming storm.")+
   steps("Barometer reading falls = pressure dropping","low pressure brings stormy weather","so a falling barometer warns of a storm.")+
   U("Sailors long watched a falling barometer as a sign to prepare for rough weather."),
   [("a clear sunny day","Clear, calm weather goes with HIGH or rising pressure; FALLING pressure warns of a storm."),
    ("a cold frost","Frost is about low temperature, not falling pressure; a dropping barometer warns of a storm."),
    ("a rainbow","A rainbow simply needs sun and rain together; a falling barometer warns of an approaching storm.")]),

 ("AE","Identifying the constant term in the expression 3x + 7, the term that has no variable is:",
   "7",
   C("A constant term has a fixed value and no variable attached. In 3x + 7, that term is 7.")+
   steps("3x contains the variable x","7 has no variable","so the constant term is 7.")+
   U("In 'fare = 3x + 7', the 7 is a fixed booking charge — the constant — added to the per-km cost."),
   [("3x","3x contains the variable x, so it is not the constant; the constant term is 7."),
    ("3","3 is the COEFFICIENT of x, part of the term 3x; the standalone constant is 7."),
    ("x","x is the variable itself; the term with no variable, the constant, is 7.")]),

 ("FD","Writing the decimal 0.1 as a fraction, it equals:",
   "1/10",
   C("The first place after the decimal point is tenths, so 0.1 means one-tenth, written 1/10.")+
   steps("0.1 is one digit after the point = tenths","one tenth","= 1/10.")+
   U("Reading 0.1 litre on a measuring jug is reading one-tenth of a litre."),
   [("1/100","1/100 is 0.01 (two places); 0.1 with one decimal place is 1/10."),
    ("10","10 misreads the place value; 0.1 is one-tenth, i.e. 1/10."),
    ("1","1 ignores the decimal; 0.1 is a tenth, written 1/10.")]),

 ("RP","A flower that contains BOTH stamens (male part) and a pistil (female part) within the same flower is described as a:",
   "bisexual flower",
   C("A bisexual (or perfect) flower has both the male stamens and the female pistil in the one flower.")+
   steps("Has stamens (male)","and a pistil (female)","both together = a bisexual flower.")+
   U("A mustard or hibiscus flower is bisexual — it carries both stamens and a pistil."),
   [("unisexual flower","A unisexual flower has only ONE kind of part (stamens OR pistil); both together make it bisexual."),
    ("seedless flower","Having or lacking seeds is not the point; a flower with both stamens and pistil is bisexual."),
    ("petal-less flower","Whether petals are present is unrelated; a flower with stamens and pistil is bisexual.")]),

 ("WS","Coastal towns hit by cyclones often suffer flooding and great damage because a cyclone brings together very high-speed winds and:",
   "very heavy rainfall",
   C("A cyclone combines fierce winds with torrential rain, and together these flood low-lying coasts and cause severe damage.")+
   steps("Cyclone = strong spiralling winds","plus very heavy rain","together they flood and damage the coast.")+
   U("Cyclone warnings urge coastal people to move to safety before the winds and floods arrive."),
   [("bright sunshine","Cyclones bring storm clouds and rain, not sunshine; the damage comes from winds plus heavy rain."),
    ("a fall in temperature","A temperature drop is not what floods a coast; the cyclone's winds and heavy rain do."),
    ("dry dusty air","Cyclones are very moist, not dry; they bring heavy rain along with strong winds.")]),

 ("AE","A young plant grows taller by 2 cm every day. The total growth, in centimetres, after d days is given by the expression:",
   "2d",
   C("Growing 2 cm per day for d days gives 2 x d = 2d centimetres of total growth.")+
   steps("Growth per day = 2 cm","over d days = 2 x d","= 2d centimetres.")+
   U("A formula like 2d lets you predict a plant's growth for any number of days d."),
   [("d + 2","d + 2 ADDS 2 once instead of each day; 2 cm a day for d days is 2 x d = 2d."),
    ("2 + d","2 + d also just adds; multiplying the daily 2 cm by d days gives 2d."),
    ("d/2","d/2 divides instead of multiplying; the total growth is 2d.")]),

 ("FD","Working out three-quarters of 20, the value of 3/4 x 20 is:",
   "15",
   C("One-quarter of 20 is 5, so three-quarters is 3 x 5 = 15. (Or 3/4 x 20 = 60/4 = 15.)")+
   steps("1/4 of 20 = 5","3/4 = 3 x 5","= 15.")+
   U("A '3/4 full' tank that holds 20 litres has 15 litres in it."),
   [("5","5 is only ONE quarter of 20; three-quarters is 3 x 5 = 15."),
    ("60","60 is 3 x 20 without dividing by 4; 3/4 of 20 is 60/4 = 15."),
    ("23","23 adds 3 and 20; three-quarters of 20 is 15.")]),

 ("RP","Cross-pollination takes place when pollen from one flower is carried to the stigma of a flower on a different plant of the same kind. Self-pollination, by contrast, happens when pollen reaches the stigma of:",
   "the same flower (or another flower on the same plant)",
   C("Self-pollination is pollen landing on the stigma of the same flower or another flower of the SAME plant; cross-pollination involves a different plant.")+
   steps("Self-pollination stays within one plant","pollen reaches the same/own plant's stigma","cross-pollination needs a different plant.")+
   U("Plants that self-pollinate can set seed even when few pollinators are around."),
   [("a flower on a completely different plant","Reaching a DIFFERENT plant is CROSS-pollination; self-pollination stays on the same plant."),
    ("a flower of a different species","Self-pollination is within the SAME plant, not a different species; that would not be self-pollination."),
    ("the soil around the roots","Pollination involves the stigma, not the soil; self-pollination reaches the same plant's own stigma.")]),

 ("WS","High windows or ventilators are placed near the ceiling of a room mainly so that the warm air, which collects at the top because it is lighter, can:",
   "escape and let the room stay cool",
   C("Warm air rises and gathers near the ceiling. High ventilators let this warm air flow out, helping the room stay cooler.")+
   steps("Warm air is lighter and rises to the ceiling","high ventilators are at that level","so the warm air escapes, cooling the room.")+
   U("Old houses have high ventilators so hot air leaves and the rooms feel cooler."),
   [("trap the warm air inside","Trapping warm air would make the room hotter; high ventilators let it escape."),
    ("keep cold air from rising","Cold air sinks, it does not rise; the high vents release the risen warm air."),
    ("stop any air from moving","The whole purpose is to MOVE warm air out; ventilators let it escape to cool the room.")]),

 ("AE","Forming the expression for 'three less than twice a number x', we write:",
   "2x - 3",
   C("'Twice a number x' is 2x; 'three less than' it means subtract 3, giving 2x - 3.")+
   steps("Twice x = 2x","'three less than' = subtract 3","-> 2x - 3.")+
   U("If a fare is 3 rupees less than double the distance x, it is 2x - 3 rupees."),
   [("3 - 2x","3 - 2x subtracts the other way; 'three less than 2x' is 2x - 3."),
    ("2x + 3","2x + 3 ADDS 3; 'three less than' means subtract, giving 2x - 3."),
    ("2(x - 3)","2(x - 3) takes 3 off FIRST then doubles; 'three less than twice x' is 2x - 3.")]),

 ("FD","Over two days a rain gauge collected 2.5 cm of rain on the first day and 1.5 cm on the second. The total rainfall for the two days was:",
   "4 cm",
   C("Add the two daily amounts: 2.5 cm + 1.5 cm = 4 cm.")+
   steps("Day 1 = 2.5 cm, day 2 = 1.5 cm","2.5 + 1.5","= 4 cm.")+
   U("Weather records add daily rainfall like this to give a storm's total."),
   [("1 cm","1 cm SUBTRACTS the amounts; the total rainfall ADDS them, giving 4 cm."),
    ("3.10 cm","3.10 mis-adds the tenths; 2.5 + 1.5 = 4 cm."),
    ("40 cm","40 cm misplaces the decimal; 2.5 + 1.5 = 4 cm, not 40 cm.")]),

 ("RP","Tiny new plantlets sprout along the notched edges of the thick leaf of a Bryophyllum plant, drop off and grow into new plants. This is an example of reproduction by:",
   "vegetative propagation through leaves",
   C("New plants growing from buds on a Bryophyllum leaf is vegetative (asexual) propagation — here from a leaf, not from seeds.")+
   steps("Buds on the leaf grow into plantlets","they fall off and root","this is vegetative propagation by leaves.")+
   U("A single Bryophyllum leaf can give rise to many new plants along its edge."),
   [("seed germination","No seed is involved; the plantlets grow from buds on the leaf — vegetative propagation."),
    ("pollination","Pollination concerns flowers and pollen; plantlets growing on a leaf is vegetative propagation."),
    ("fertilisation","Fertilisation needs gametes to fuse; the leaf simply buds new plants, which is vegetative propagation.")]),

 ("WS","Seeds and fruits that are light and can float, like the coconut with its thick fibrous husk, are most often carried to new places by:",
   "water",
   C("A coconut's husk traps air and lets it float, so rivers and the sea carry it far — dispersal by water.")+
   steps("The husk makes the coconut float","water carries the floating fruit","this is dispersal by water.")+
   U("Coconuts float across the sea and sprout on distant beaches — water dispersal at work."),
   [("wind","Wind carries light winged or hairy seeds; a heavy floating coconut is carried by water."),
    ("animals","Animals carry hooked or tasty seeds; a floating coconut is dispersed by water."),
    ("magnets","Magnets have no effect on seeds; the floating coconut is dispersed by water.")]),

 ("AE","Combining the like terms in the expression 3a + 2b + 5a, the simplified form is:",
   "8a + 2b",
   C("Add the like terms 3a and 5a to get 8a; 2b is unlike and stays. So 3a + 2b + 5a = 8a + 2b.")+
   steps("Like terms: 3a + 5a = 8a","2b is unlike, unchanged","result = 8a + 2b.")+
   U("Tidying a long expression into fewer terms makes it far easier to use."),
   [("10ab","10ab wrongly multiplies and merges different letters; only like terms add, giving 8a + 2b."),
    ("8a + 5a","8a + 5a counts the 5a twice; once combined, 3a + 5a = 8a, leaving 8a + 2b."),
    ("5ab + 5a","5ab invents a product that is not there; combining like terms gives 8a + 2b.")]),

 ("FD","Writing the fraction 5/10 in its simplest form, it reduces to:",
   "1/2",
   C("Divide the top and bottom by their common factor 5: 5/10 = 1/2.")+
   steps("5/10, divide top and bottom by 5","= 1/2.")+
   U("Five out of ten correct answers is simply half — the same as 1/2."),
   [("5/10","5/10 is correct but NOT simplified; dividing both by 5 gives 1/2."),
    ("1/5","1/5 divides only the bottom; dividing both parts of 5/10 by 5 gives 1/2."),
    ("2/1","2/1 turns the fraction upside down; 5/10 in simplest form is 1/2.")]),

 ("RP","The sticky tip at the top of the pistil, which receives the pollen grains during pollination, is the:",
   "stigma",
   C("The stigma is the sticky upper tip of the pistil. Its stickiness helps catch and hold pollen grains.")+
   steps("Top of the female pistil","sticky to catch pollen","that tip is the stigma.")+
   U("Pollen sticking to a flower's stigma is the first step toward forming a seed."),
   [("ovary","The ovary is the swollen BASE of the pistil holding the ovules; the pollen-catching tip is the stigma."),
    ("anther","The anther is part of the MALE stamen and makes pollen; the pollen-receiving female tip is the stigma."),
    ("filament","The filament is the stalk of the stamen; the sticky tip that receives pollen is the stigma.")]),

 ("WS","On a hot afternoon at the seaside, the land heats up faster than the sea, so cool air moves in from the sea towards the land. This daytime wind is called the:",
   "sea breeze",
   C("By day the land warms faster, the warm air over it rises, and cooler air flows in from the sea — a sea breeze.")+
   steps("Land heats faster than the sea by day","warm air over the land rises","cool sea air flows in: a sea breeze.")+
   U("People at the beach feel a refreshing sea breeze blowing in from the water on a hot day."),
   [("land breeze","A LAND breeze blows from land to sea at NIGHT; the daytime sea-to-land wind is a sea breeze."),
    ("monsoon wind","A monsoon is a seasonal wind over a whole region; the daily cool wind off the sea is a sea breeze."),
    ("cyclone","A cyclone is a violent storm, not a gentle daily wind; the daytime onshore wind is a sea breeze.")]),

 ("AE","A model for a gust of wind gives its speed in km/h as 20 + 5t, where t is the time in hours. When t = 4, the wind speed is:",
   "40 km/h",
   C("Substitute t = 4: 20 + 5 x 4 = 20 + 20 = 40 km/h.")+
   steps("5t = 5 x 4 = 20","20 + 20","= 40 km/h.")+
   U("Forecasters use simple formulas like this to estimate how a wind will pick up over time."),
   [("100 km/h","100 multiplies 20 and 5 wrongly; 20 + 5 x 4 = 40 km/h."),
    ("29 km/h","29 adds 20, 5 and 4 without multiplying; 5t = 20, so 20 + 20 = 40 km/h."),
    ("25 km/h","25 forgets to multiply by t; with t = 4, 5t = 20, giving 20 + 20 = 40 km/h.")]),

 ("FD","Multiplying the two decimals 0.2 and 0.3, the product 0.2 x 0.3 equals:",
   "0.06",
   C("Multiply as 2 x 3 = 6, then place two decimal places (one from each factor): 0.06.")+
   steps("2 x 3 = 6","two decimal places in all","= 0.06.")+
   U("Multiplying decimal measurements, like 0.2 m by 0.3 m, needs this careful point placement."),
   [("0.6","0.6 keeps only one decimal place; two factors give two places, so 0.2 x 0.3 = 0.06."),
    ("0.5","0.5 ADDS the decimals instead of multiplying; 0.2 x 0.3 = 0.06."),
    ("6","6 drops the decimal point entirely; 0.2 x 0.3 = 0.06.")]),

 ("RP","Seeds are usually scattered far away from the parent plant. The main advantage of this dispersal is that the new seedlings:",
   "do not crowd and compete with the parent for water, light and space",
   C("Spreading seeds out means new plants grow away from the parent, so they don't all fight over the same water, sunlight and space.")+
   steps("If seeds fell only at the parent's base...","...the seedlings would crowd and compete","dispersal spreads them out to grow well.")+
   U("Dispersal also lets a plant species spread into new areas over time."),
   [("grow faster than every other plant","Dispersal does not guarantee fast growth; its benefit is avoiding crowding and competition with the parent."),
    ("stay close together for warmth","Plants do not huddle for warmth; dispersal SPREADS seeds so they do not compete."),
    ("never need any sunlight","All green plants need sunlight; dispersal helps them get it by avoiding crowding under the parent.")]),

 ("WS","The fusion of the male gamete (from a pollen grain) with the egg inside the ovule, which happens after pollination, is called:",
   "fertilisation",
   C("Fertilisation is the joining (fusion) of the male gamete with the female egg cell inside the ovule. It follows pollination and leads to seed formation.")+
   steps("After pollination, the pollen grain reaches the ovule","its male gamete fuses with the egg","this fusion is fertilisation.")+
   U("Only after fertilisation can an ovule grow into a seed and the ovary into a fruit."),
   [("pollination","Pollination is the EARLIER transfer of pollen to the stigma; the fusion of gametes is fertilisation."),
    ("germination","Germination is a seed later sprouting; the fusion of male and female gametes is fertilisation."),
    ("transpiration","Transpiration is water loss from leaves; the fusion of gametes inside the ovule is fertilisation.")]),

 ("AE","Out of the terms in the expression 2x - 5, the two separate terms are:",
   "2x and -5",
   C("Terms are separated by + or - signs. In 2x - 5, the terms are 2x and -5.")+
   steps("Split at the - sign","first term 2x","second term -5.")+
   U("Spotting the terms of an expression is the first step to simplifying or evaluating it."),
   [("2 and x","2 and x are the parts WITHIN the single term 2x; the two terms of the expression are 2x and -5."),
    ("2x and 5","The sign belongs to the term: it is -5, not +5; the terms are 2x and -5."),
    ("x and -5","Dropping the coefficient loses part of the term; the first term is 2x, giving 2x and -5.")]),

 ("FD","Among the three decimals 0.5, 0.05 and 0.55, the greatest in value is:",
   "0.55",
   C("Compare place by place: 0.55 has 5 tenths and 5 hundredths, more than 0.5 (5 tenths) and far more than 0.05 (0 tenths). So 0.55 is greatest.")+
   steps("0.55 = 5 tenths + 5 hundredths","0.5 = 5 tenths; 0.05 = 0 tenths","so 0.55 is the largest.")+
   U("Comparing decimal prices or measurements correctly depends on reading place value like this."),
   [("0.5","0.5 has 5 tenths but no hundredths; 0.55 has more, so 0.55 is greatest."),
    ("0.05","0.05 is the SMALLEST (no tenths); the greatest of the three is 0.55."),
    ("they are all equal","The three decimals differ in value; the greatest is 0.55.")]),

 # ===== second pass — 37 more items, keeping the RP/WS/AE/FD interleave =====
 ("RP","A flower that carries only stamens, or only a pistil, but not both kinds of reproductive part, is described as a:",
   "unisexual flower",
   C("A unisexual flower has just one kind of reproductive part — either stamens (male) or a pistil (female), not both.")+
   steps("Only stamens OR only a pistil","one kind of part present","so it is a unisexual flower.")+
   U("Maize and papaya bear unisexual flowers — separate male and female ones."),
   [("bisexual flower","A bisexual flower has BOTH stamens and a pistil; having only one kind makes it unisexual."),
    ("seedless flower","Whether seeds form is not the point; a flower with only one kind of part is unisexual."),
    ("scented flower","Scent is unrelated to this; a flower with only stamens or only a pistil is unisexual.")]),

 ("WS","Air that moves from one place to another, which we can feel on our skin and which makes flags flutter, is simply:",
   "wind",
   C("Wind is nothing but moving air. Differences in air pressure set the air in motion, and that moving air is the wind.")+
   steps("Air moves from place to place","this moving air...","...is what we call wind.")+
   U("A kite flies because moving air — the wind — pushes against it."),
   [("pressure","Pressure is the push air exerts; the MOVING air itself is the wind."),
    ("vapour","Vapour is water in gas form; ordinary moving air is the wind."),
    ("sound","Sound is a vibration we hear; air moving past us is the wind.")]),

 ("AE","Writing 'twice a number x' as an algebraic expression gives:",
   "2x",
   C("'Twice' means two times, so twice a number x is 2 x x, written 2x.")+
   steps("'Twice' = two times","two times x","= 2x.")+
   U("If a rope is twice as long as a stick of length x, its length is 2x."),
   [("x + 2","x + 2 ADDS 2; 'twice x' MULTIPLIES by 2, giving 2x."),
    ("x/2","x/2 HALVES x; 'twice x' doubles it, giving 2x."),
    ("x^2","x^2 is x times x; 'twice x' is 2 times x, i.e. 2x.")]),

 ("FD","Writing the fraction 7/10 as a decimal number, it equals:",
   "0.7",
   C("Tenths sit in the first place after the decimal point, so 7/10 is written 0.7.")+
   steps("7/10 means 7 tenths","tenths = first decimal place","= 0.7.")+
   U("Scoring 7 out of 10 on a quiz is the same as 0.7 of the marks."),
   [("0.07","0.07 is 7 hundredths (7/100); 7/10 is 7 tenths, i.e. 0.7."),
    ("7.0","7.0 is the whole number 7; the fraction 7/10 is 0.7."),
    ("70","70 ignores the decimal; 7/10 equals 0.7.")]),

 ("RP","A bread mould spreads to fresh bread by releasing huge numbers of tiny, dust-like reproductive units into the air. These units are called:",
   "spores",
   C("Many fungi, like bread mould, reproduce by spores — tiny units that scatter in the air and grow into new fungi where they settle.")+
   steps("Mould releases tiny units into the air","they land and grow into new mould","these units are spores.")+
   U("Ferns and mushrooms also spread by releasing spores."),
   [("seeds","Seeds come from flowering plants after fertilisation; mould spreads by tiny spores, not seeds."),
    ("buds","Buds are outgrowths on a parent (as in yeast); the airborne units of a mould are spores."),
    ("roots","Roots anchor a plant; the dust-like reproductive units of a mould are spores.")]),

 ("WS","On a clear night at the coast the land cools faster than the sea, so air now blows from the land out towards the sea. This night-time wind is the:",
   "land breeze",
   C("At night the land cools quicker than the sea; the warmer air over the sea rises and cooler air flows out from the land — a land breeze.")+
   steps("At night the land cools faster than the sea","warmer air rises over the sea","cool air flows out from the land: a land breeze.")+
   U("Fishermen once set out at night helped by the land breeze blowing them seaward."),
   [("sea breeze","A SEA breeze blows from sea to land by DAY; the night-time land-to-sea wind is a land breeze."),
    ("cyclone","A cyclone is a violent storm, not a gentle daily wind; the night offshore wind is a land breeze."),
    ("monsoon","A monsoon is a seasonal wind over a whole region; the nightly offshore wind is a land breeze.")]),

 ("AE","Writing 'a number x decreased by 4' as an algebraic expression gives:",
   "x - 4",
   C("'Decreased by 4' means subtract 4 from the number, written x - 4.")+
   steps("Start with the number x","'decreased by' = subtract","subtract 4 -> x - 4.")+
   U("If a price x is reduced by 4 rupees, the new price is x - 4."),
   [("x + 4","x + 4 ADDS 4; 'decreased by 4' subtracts, giving x - 4."),
    ("4 - x","4 - x subtracts the other way; 'x decreased by 4' is x - 4."),
    ("4x","4x MULTIPLIES; 'decreased by 4' means subtract, giving x - 4.")]),

 ("FD","Writing the decimal 0.75 as a fraction in its simplest form, it equals:",
   "3/4",
   C("0.75 means 75 hundredths, 75/100. Dividing top and bottom by 25 gives 3/4.")+
   steps("0.75 = 75/100","divide both by 25","= 3/4.")+
   U("A glass that is 0.75 full is three-quarters full."),
   [("75/10","75/10 misplaces the denominator; 0.75 is 75/100 = 3/4."),
    ("7/5","7/5 is more than 1; 0.75 is less than 1, equal to 3/4."),
    ("1/4","1/4 is 0.25, not 0.75; the decimal 0.75 is 3/4.")]),

 ("RP","Once a pollen grain settles on the stigma, it grows a fine tube down through the style. The job of this pollen tube is to carry the male gamete to the:",
   "ovule (containing the egg)",
   C("The pollen tube grows down to the ovule and delivers the male gamete to the egg inside, so fertilisation can take place.")+
   steps("Pollen grain on the stigma grows a tube","the tube reaches the ovule","it carries the male gamete to the egg.")+
   U("This delivery by the pollen tube is the hidden step that lets a seed begin to form."),
   [("petal","Petals are the showy parts that attract insects; the pollen tube grows to the ovule, not the petal."),
    ("root","The root is far below in the soil; the pollen tube carries the gamete to the ovule in the flower."),
    ("sepal","Sepals protect the bud; the pollen tube delivers the male gamete to the ovule.")]),

 ("WS","Because the Sun heats the Earth unevenly, the air over some regions becomes warmer than over others. This uneven heating of the air is the basic cause of:",
   "winds",
   C("Uneven heating makes some air warmer and lighter, setting up pressure differences. Air then flows from high to low pressure — that flow is wind.")+
   steps("Sun heats the Earth unevenly","warm air rises, creating pressure differences","air flows from high to low pressure: winds.")+
   U("The world's great wind belts all trace back to the uneven heating of the air."),
   [("earthquakes","Earthquakes come from movements in the Earth's crust, not from heated air; uneven heating causes winds."),
    ("eclipses","An eclipse is a shadow in space; uneven heating of air sets up winds."),
    ("tides","Tides are caused by the Moon's pull; uneven heating of the air causes winds.")]),

 ("AE","Writing 'the product of 3 and y' as an algebraic expression gives:",
   "3y",
   C("A product means a multiplication, so the product of 3 and y is 3 x y, written 3y.")+
   steps("'Product' = multiply","3 times y","= 3y.")+
   U("If each bag holds y marbles, 3 bags hold 3y marbles."),
   [("3 + y","3 + y is a SUM, not a product; the product of 3 and y is 3y."),
    ("y - 3","y - 3 is a difference; the product of 3 and y is 3y."),
    ("y/3","y/3 is a division; the product of 3 and y is 3y.")]),

 ("FD","Working out one-fifth of 100, the value of 1/5 x 100 is:",
   "20",
   C("One-fifth of 100 means 100 divided by 5, which is 20.")+
   steps("1/5 x 100 = 100 / 5","= 20.")+
   U("Sharing 100 rupees equally among 5 friends gives each one-fifth, i.e. 20 rupees."),
   [("5","5 is the denominator, not the answer; one-fifth of 100 is 20."),
    ("100","100 is the whole; one-fifth of it is 20."),
    ("50","50 is one HALF of 100; one-fifth is 20.")]),

 ("RP","Flowers that depend on the wind to carry their pollen are usually small, dull-coloured and without scent or nectar. They also tend to make:",
   "large amounts of light pollen",
   C("Wind cannot aim pollen, so wind-pollinated flowers make plenty of light, dry pollen that the breeze can carry — and skip the showy colour and nectar that attract insects.")+
   steps("Wind scatters pollen randomly","so lots of light pollen is needed","hence large amounts of light pollen.")+
   U("Grasses are wind-pollinated and shed clouds of light pollen, which can trigger sneezing."),
   [("very few heavy pollen grains","Heavy grains would not travel on the wind; wind-pollinated flowers make lots of LIGHT pollen."),
    ("sweet nectar to attract bees","Nectar is for INSECT pollination; wind-pollinated flowers skip it and make plenty of light pollen."),
    ("brightly coloured petals","Bright petals attract insects; dull wind-pollinated flowers instead make abundant light pollen.")]),

 ("WS","When a cyclone warning is given for a coastal area, the safest and most sensible action for people there is to:",
   "move to a safe shelter and follow official advice",
   C("Cyclones are dangerous, so people should move to a sturdy shelter and follow the warnings and instructions from the authorities.")+
   steps("A cyclone warning means danger is near","the safe choice is to shelter","and follow official advice.")+
   U("Coastal communities are evacuated to cyclone shelters when a strong storm is forecast."),
   [("go to the beach to watch the waves","The beach is the most dangerous place in a cyclone; people should shelter and follow advice."),
    ("ignore the warning and carry on","Ignoring a cyclone warning risks lives; the safe action is to shelter and follow advice."),
    ("open all the windows wide","Open windows let in damaging wind and rain; people should shelter safely and follow advice.")]),

 ("AE","Subtracting the like term 2x from 5x, the difference 5x - 2x equals:",
   "3x",
   C("Like terms subtract by subtracting their coefficients: 5 - 2 = 3, giving 3x.")+
   steps("5x and 2x are like terms","5 - 2 = 3","= 3x.")+
   U("Removing 2 packets-worth from 5 packets-worth leaves 3 packets-worth — like 5x - 2x."),
   [("3","Dropping the x loses the variable; 5x - 2x = 3x."),
    ("7x","7x ADDS the coefficients; subtracting gives 5 - 2 = 3x."),
    ("10x","10x multiplies 5 and 2; subtracting like terms gives 3x.")]),

 ("FD","Adding the fractions one-third and one-third, the sum 1/3 + 1/3 equals:",
   "2/3",
   C("With the same denominator, just add the tops: 1 + 1 = 2 over 3, giving 2/3.")+
   steps("Same bottom (3), add tops","1 + 1 = 2","= 2/3.")+
   U("Two one-third slices of a chapati together make two-thirds of it."),
   [("2/6","2/6 wrongly adds the bottoms too; with a common denominator the sum is 2/3."),
    ("1/3","1/3 ignores the second third; 1/3 + 1/3 = 2/3."),
    ("1/6","1/6 multiplies the fractions; ADDING them gives 2/3.")]),

 ("RP","Seeds are produced only after a male gamete fuses with a female egg cell. Because it needs this fusion of two gametes, seed formation is an example of:",
   "sexual reproduction",
   C("Forming seeds requires fertilisation — the fusion of a male and a female gamete — so it is sexual reproduction, unlike budding or fragmentation.")+
   steps("A male gamete fuses with an egg","two gametes join (fertilisation)","so seed formation is sexual reproduction.")+
   U("Because seeds mix features from two parents, seed-grown plants can show useful variation."),
   [("asexual reproduction","Asexual reproduction needs only ONE parent and no gametes; seed formation, needing fertilisation, is sexual."),
    ("vegetative propagation","Vegetative propagation grows new plants from parts of one parent; seed formation by fertilisation is sexual reproduction."),
    ("budding","Budding is asexual, with no fusion of gametes; seed formation requires fertilisation, making it sexual reproduction.")]),

 ("WS","A violently spinning column of air with a narrow funnel shape, which forms over land and can suck up dust and objects, is called a:",
   "tornado",
   C("A tornado is a fast-spinning, funnel-shaped column of air that reaches down to the land and causes great damage along its narrow path.")+
   steps("A spinning funnel of air over land","very high winds in a narrow column","that is a tornado.")+
   U("A passing tornado can lift roofs and uproot trees along its narrow track."),
   [("sea breeze","A sea breeze is a gentle daytime coastal wind, not a violent funnel; the spinning land funnel is a tornado."),
    ("rainbow","A rainbow is an arc of colours from sunlight and rain; a spinning funnel of air is a tornado."),
    ("dewfall","Dewfall is moisture settling at night; a violent spinning air column is a tornado.")]),

 ("AE","Replacing x with 3 in the expression 10 - 2x, the value of the expression is:",
   "4",
   C("Substitute x = 3: 10 - 2x = 10 - 2 x 3 = 10 - 6 = 4.")+
   steps("2x = 2 x 3 = 6","10 - 6","= 4.")+
   U("Working out 'budget minus 2 rupees per item' uses exactly this kind of substitution."),
   [("6","6 is the value of 2x, not the whole expression; 10 - 6 = 4."),
    ("16","16 ADDS 6 instead of subtracting; 10 - 2 x 3 = 4."),
    ("8","8 takes only 10 - 2; with x = 3, 2x = 6, so 10 - 6 = 4.")]),

 ("FD","Multiplying the decimal 2.5 by 2, the product 2.5 x 2 equals:",
   "5",
   C("2.5 doubled is 2.5 + 2.5 = 5.0, which is just 5.")+
   steps("2.5 x 2 = 2.5 + 2.5","= 5.0","= 5.")+
   U("Two bottles of 2.5 litres hold 5 litres altogether."),
   [("4.10","4.10 mis-adds the halves; 2.5 x 2 = 5."),
    ("2.10","2.10 doubles only the decimal part wrongly; 2.5 x 2 = 5."),
    ("25","25 forgets the decimal point; 2.5 x 2 = 5.")]),

 ("RP","In a brightly coloured flower, the showy parts whose main job is to attract insects for pollination are the:",
   "petals",
   C("Petals are usually large and colourful (and often scented) to attract insects, which then carry pollen between flowers.")+
   steps("The colourful showy parts of a flower","attract insects for pollination","are the petals.")+
   U("A rose's bright petals draw bees and butterflies that help pollinate it."),
   [("sepals","Sepals are the small green parts that protect the bud; the showy insect-attracting parts are the petals."),
    ("anthers","Anthers make pollen and are part of the stamen; the colourful attracting parts are the petals."),
    ("ovules","Ovules are inside the ovary and become seeds; the showy parts that attract insects are the petals.")]),

 ("WS","An 'empty' bottle is pushed mouth-down into a tub of water and bubbles escape from it. This shows that the bottle was not really empty but was filled with air, proving that air:",
   "takes up space (occupies volume)",
   C("The bubbles are air leaving the bottle as water enters. Since the air was taking up room inside, it shows air occupies space.")+
   steps("Bubbles rise as water enters the bottle","those bubbles are the air leaving","so the air was occupying space.")+
   U("The same idea is why you must let air out of a bottle to fill it completely with water."),
   [("has a colour","The air is invisible here; the bubbles show that air takes up space."),
    ("is a liquid","Air is a gas, not a liquid; the escaping bubbles show air occupies space."),
    ("cannot move","The air clearly moves out as bubbles; the demonstration shows air takes up space.")]),

 ("AE","In the algebraic term 7m, the part that can take different values — the variable — is:",
   "m",
   C("In 7m, the number 7 is the fixed coefficient, while m is the letter that can stand for different numbers — the variable.")+
   steps("7 is the fixed multiplier (coefficient)","m is the changeable letter","so the variable is m.")+
   U("In 'cost = 7m', m is the variable count of items, while 7 is the fixed price each."),
   [("7","7 is the COEFFICIENT, a fixed number; the changeable letter, the variable, is m."),
    ("7m","7m is the whole term, not the variable alone; the variable is m."),
    ("+","A plus sign is an operation, not a variable; the variable in 7m is m.")]),

 ("FD","Finding one-half of 0.5, the value of 1/2 x 0.5 is:",
   "0.25",
   C("Half of 0.5 means 0.5 divided by 2, which is 0.25.")+
   steps("1/2 x 0.5 = 0.5 / 2","= 0.25.")+
   U("Half of half a litre (0.5 L) is a quarter litre, 0.25 L."),
   [("1","1 doubles instead of halving; half of 0.5 is 0.25."),
    ("0.5","0.5 is the whole amount; half of it is 0.25."),
    ("0.025","0.025 misplaces the decimal; half of 0.5 is 0.25.")]),

 ("RP","Before a flower opens, its delicate inner parts are wrapped and protected by the small, usually green, leaf-like structures called the:",
   "sepals",
   C("Sepals are the outermost, usually green parts of a flower. They enclose and protect the developing bud before it opens.")+
   steps("Outer green leaf-like parts","they cover the bud","protecting it: the sepals.")+
   U("Peel back the green sepals of a rosebud and the folded petals appear inside."),
   [("petals","Petals are the colourful parts that attract insects; the protective green parts of the bud are the sepals."),
    ("stamens","Stamens are the pollen-making male parts; the green parts protecting the bud are the sepals."),
    ("stigma","The stigma is the pollen-receiving tip of the pistil; the bud's protective green parts are the sepals.")]),

 ("WS","During a thunderstorm we first see a flash of lightning and a little later hear the thunder. The flash comes first because, compared with sound, light travels:",
   "very much faster",
   C("Light travels far faster than sound, so the lightning flash reaches us almost at once while the thunder, slower, arrives later.")+
   steps("Light is far faster than sound","the flash arrives almost instantly","the slower thunder is heard afterwards.")+
   U("Counting seconds between a flash and its thunder tells you how far the storm is."),
   [("at the same speed","If they were equally fast, flash and thunder would arrive together; light is far faster, so the flash comes first."),
    ("much more slowly","Light is FASTER than sound, not slower; that is why the flash is seen before the thunder."),
    ("only as fast as the wind","Light is vastly faster than any wind; its great speed is why the flash beats the thunder.")]),

 ("AE","An algebraic expression that has exactly three terms, such as 2x + 3y - 5, is called a:",
   "trinomial",
   C("'Tri' means three. An expression with exactly three terms, like 2x + 3y - 5, is a trinomial.")+
   steps("'Tri' = three","three terms, e.g. 2x + 3y - 5","such an expression is a trinomial.")+
   U("Calling an expression a trinomial tells others at once that it has three terms."),
   [("monomial","A monomial has just ONE term; three terms make a trinomial."),
    ("binomial","A binomial has TWO terms; three terms make a trinomial."),
    ("variable","A variable is a single changeable letter, not a whole expression; 2x + 3y - 5 is a trinomial.")]),

 ("FD","A cluster on a plant holds 12 buds, and exactly one-third of them have opened into flowers. The number of buds that have opened is:",
   "4",
   C("One-third of 12 means 12 divided by 3, which is 4 opened buds.")+
   steps("1/3 of 12 = 12 / 3","= 4 opened buds.")+
   U("A gardener tracking how many buds have bloomed uses a fraction of the total just like this."),
   [("12","12 is the TOTAL number of buds; only one-third, i.e. 4, have opened."),
    ("3","3 is the denominator, not the count; one-third of 12 is 4."),
    ("8","8 is TWO-thirds of 12 (the unopened buds); one-third opened is 4.")]),

 ("WS","As a cyclone strengthened, its strongest wind speed rose from 90 km/h to 120 km/h. The increase in wind speed was:",
   "30 km/h",
   C("The increase is the new speed minus the old: 120 - 90 = 30 km/h.")+
   steps("Increase = new - old","= 120 - 90","= 30 km/h.")+
   U("Forecasters track how fast a cyclone's winds are climbing to judge the danger."),
   [("210 km/h","210 ADDS the two speeds; the increase SUBTRACTS them, giving 120 - 90 = 30 km/h."),
    ("120 km/h","120 is the NEW speed, not the increase; the rise is 120 - 90 = 30 km/h."),
    ("90 km/h","90 is the OLD speed; the increase is 120 - 90 = 30 km/h.")]),

 ("AE","A pod holds s seeds. A botanist has 4 such pods plus 2 loose seeds. The total number of seeds, as an algebraic expression, is:",
   "4s + 2",
   C("Four pods of s seeds give 4s seeds; add the 2 loose seeds to get 4s + 2.")+
   steps("4 pods of s seeds = 4 x s = 4s","add the 2 loose seeds","= 4s + 2.")+
   U("Writing a total as 4s + 2 lets you find the count for any pod size s."),
   [("6s","6s wrongly merges the 4 and the 2 as if both multiplied s; only the pods do, giving 4s + 2."),
    ("4s","4s leaves out the 2 loose seeds; the total is 4s + 2."),
    ("4 + 2s","4 + 2s attaches the variable to the wrong number; it is the pods (4) that hold s seeds, giving 4s + 2.")]),

 ("RP","A plant bears 100 seeds, and one-quarter of them actually germinate into seedlings. The number of seeds that germinated is:",
   "25",
   C("One-quarter of 100 means 100 divided by 4, which is 25 seeds.")+
   steps("1/4 of 100 = 100 / 4","= 25 seeds.")+
   U("A nursery uses such a fraction to predict how many seedlings a batch of seeds will give."),
   [("100","100 is the TOTAL number of seeds; only one-quarter, i.e. 25, germinated."),
    ("4","4 is the denominator, not the count; one-quarter of 100 is 25."),
    ("50","50 is one HALF of 100; one-quarter is 25.")]),

 ("FD","Out of 25 seeds sown, three-fifths of them sprout. The number of seeds that sprouted is:",
   "15",
   C("Three-fifths of 25: one-fifth of 25 is 5, so three-fifths is 3 x 5 = 15. (Or 3/5 x 25 = 75/5 = 15.)")+
   steps("1/5 of 25 = 5","3/5 = 3 x 5","= 15 seeds.")+
   U("Reading a packet's '3/5 germination' tells a gardener how many of 25 seeds will grow."),
   [("5","5 is only ONE-fifth of 25; three-fifths is 3 x 5 = 15."),
    ("25","25 is the TOTAL sown; three-fifths of them, i.e. 15, sprouted."),
    ("10","10 is two-fifths of 25; three-fifths is 15.")]),

 ("AE","Replacing x with 2 in the expression 3x - 1, the value of the expression is:",
   "5",
   C("Substitute x = 2: 3x - 1 = 3 x 2 - 1 = 6 - 1 = 5.")+
   steps("3x = 3 x 2 = 6","6 - 1","= 5.")+
   U("Plugging a value into a formula such as '3 per unit, minus a 1-rupee rebate' works this way."),
   [("6","6 is the value of 3x, before subtracting 1; 6 - 1 = 5."),
    ("4","4 takes only 3 + x - 1; with x = 2, 3x = 6, so 6 - 1 = 5."),
    ("8","8 ADDS 1 instead of subtracting; 3 x 2 - 1 = 5.")]),

 ("FD","Adding the three equal fractions one-quarter, one-quarter and one-quarter, the sum 1/4 + 1/4 + 1/4 equals:",
   "3/4",
   C("With the same denominator, add the tops: 1 + 1 + 1 = 3 over 4, giving 3/4.")+
   steps("Same bottom (4), add tops","1 + 1 + 1 = 3","= 3/4.")+
   U("Three quarter-cups of rice together make three-quarters of a cup."),
   [("3/12","3/12 wrongly adds the bottoms too; with a common denominator the sum is 3/4."),
    ("1/4","1/4 counts only one quarter; three of them make 3/4."),
    ("1/12","1/12 multiplies the fractions; ADDING the three quarters gives 3/4.")]),

 ("WS","A cyclone's centre moved a distance of 90 km across the sea in 3 hours. The speed at which the cyclone was moving was:",
   "30 km/h",
   C("Speed is distance divided by time: 90 km / 3 h = 30 km/h.")+
   steps("Speed = distance / time","= 90 km / 3 h","= 30 km/h.")+
   U("Forecasters track how fast a cyclone is moving to predict when it will reach the coast."),
   [("90 km/h","90 km is the DISTANCE moved, not the speed; dividing by 3 hours gives 30 km/h."),
    ("270 km/h","270 multiplies distance by time; speed DIVIDES, giving 90 / 3 = 30 km/h."),
    ("3 km/h","3 is the number of hours, not the speed; the speed is 90 / 3 = 30 km/h.")]),

 ("RP","Plants raised from cuttings or tubers, rather than from seeds, flower earlier and are exactly like the parent plant. This sameness happens because such plants are produced by:",
   "asexual reproduction (vegetative propagation)",
   C("Vegetative propagation is asexual — it uses parts of a single parent, so the new plants are genetically identical copies of that parent and can flower sooner.")+
   steps("New plants grow from a part of one parent","no mixing of two parents' features","so they are identical copies — asexual reproduction.")+
   U("Growers raise grapes and roses from cuttings to get plants exactly like a prized parent."),
   [("sexual reproduction","Sexual reproduction MIXES features from two parents, giving variation; identical copies come from asexual reproduction."),
    ("pollination by insects","Insect pollination leads to seeds and variation; identical plants from cuttings arise by asexual reproduction."),
    ("cross-pollination","Cross-pollination mixes two plants' features; identical copies are made by asexual (vegetative) reproduction.")]),

 ("FD","Writing the fraction 4/5 as a decimal number, it equals:",
   "0.8",
   C("Make it tenths: 4/5 = 8/10, which as a decimal is 0.8.")+
   steps("4/5 = 8/10","8 tenths","= 0.8.")+
   U("Scoring 4 out of 5 on a short quiz is the same as 0.8 of the marks."),
   [("0.45","0.45 just writes the digits 4 and 5; 4/5 equals 8/10 = 0.8."),
    ("0.4","0.4 is 4/10, not 4/5; four-fifths is 8/10 = 0.8."),
    ("5.4","5.4 mixes up the numbers; the fraction 4/5 is 0.8.")]),
]

# ---------- WINDS, STORMS & CYCLONES — note: above list interleaves all four ----------
# (Items are authored already interleaved as RP, WS, AE, FD in groups of four.)

# ---------- assemble: the RP list above ALREADY holds all 100 interleaved items ----------
items = RP
assert len(items) == 100, len(items)

# sanity: 25 of each chapter
from collections import Counter
_c = Counter(it[0] for it in items)
assert all(_c[k] == 25 for k in ("RP", "WS", "AE", "FD")), dict(_c)

# no two consecutive items share a chapter
for a, b in zip(items, items[1:]):
    assert a[0] != b[0], (a[1], b[1])


def fingerprint(stem):
    words = re.sub(r"[^\w\s]", "", stem.lower()).split()
    return " ".join(words[:14])


if __name__ == "__main__":
    here = os.path.dirname(os.path.abspath(__file__))
    papers_dir = os.path.abspath(os.path.join(
        here, "..", "..", "desktopAhaan", "Resources", "BossChallengePapers"))

    # ---- fingerprint collision guard against the running index ----
    idx_path = os.path.join(papers_dir, "QUESTION_INDEX.json")
    with open(idx_path, encoding="utf-8") as fh:
        idx = json.load(fh)
    existing = set(idx.get("fingerprints", []))

    new_fps = [fingerprint(it[1]) for it in items]
    dupe_internal = {f for f in new_fps if new_fps.count(f) > 1}
    assert not dupe_internal, ("internal dup fingerprints", dupe_internal)
    clash = [f for f in new_fps if f in existing]
    assert not clash, ("fingerprint clash with existing index", clash)

    os.chdir(papers_dir)

    keydist = build_paper(PNUM, TITLE, SHORT, LABELS, items, seed=54141,
                          append_manifest=False)

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

    counts = {}
    for ch, *_ in items:
        counts[ch] = counts.get(ch, 0) + 1
    split = "/".join(str(counts[c]) for c in ("RP", "WS", "AE", "FD"))
    with open("PAPERS_MANIFEST.md", "a", encoding="utf-8") as fh:
        fh.write(f"| {PNUM} | 2026-06-18 | {TITLE} | {split} | ✓ |\n")

    # ---- update QUESTION_INDEX.json ----
    idx["fingerprints"] = sorted(existing | set(new_fps))
    idx.setdefault("combos", []).append({
        "paper": PNUM,
        "chapters": ["Reproduction in Plants",
                     "Winds, Storms & Cyclones",
                     "Algebraic Expressions",
                     "Fractions & Decimals"],
    })
    idx["papers"] = idx.get("papers", 0) + 1
    with open(idx_path, "w", encoding="utf-8") as fh:
        json.dump(idx, fh, ensure_ascii=False, indent=2)
        fh.write("\n")

    print("Files:", sorted(v for v in moves.values()))
    print("Answer key spread A/B/C/D =", dict(keydist))
