# -*- coding: utf-8 -*-
# Boss Challenge Paper 21 — Nutrition in Plants · Lines & Angles ·
#                          Winds, Storms & Cyclones · Rational Numbers
# Content-only. Uses the dependency-free examfactory engine.
# Difficulty ramp: this paper leans into FUSION — several Lines-&-Angles and
# Rational-Number items are wrapped in a real Science context (a wind vane's
# bearing, a falling night temperature, the slope of a sea breeze), so the
# child has to read a Science situation and apply a Maths skill. Class-7
# scope, simple wording, hard thinking.
# Produces, under Resources/BossChallengePapers/:
#   Paper_21_<SHORT>_QuestionPaper.html  (pure HTML — questions + options)
#   Paper_21_<SHORT>_QuestionPaper.pdf
#   Paper_21_<SHORT>_Questions.md
#   Paper_21_<SHORT>_Solutions.html
import os, sys, shutil, json, re
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from examfactory import build_paper, C, steps, U

PNUM  = "21"
SHORT = "NutritionPlants_LinesAngles_WindsStormsCyclones_RationalNumbers"
TITLE = ("Nutrition in Plants · Lines & Angles · "
         "Winds, Storms & Cyclones · Rational Numbers")
LABELS = {
    "NP": "Nutrition in Plants",
    "LA": "Lines & Angles",
    "WS": "Winds, Storms & Cyclones",
    "RN": "Rational Numbers",
}

# ---------- NUTRITION IN PLANTS (25) — Science ----------
NP = [
 ("NP","Organisms such as green plants that make their own food from simple raw materials are described as:",
   "autotrophs",
   C("Autotrophs are self-feeders: they build their own food instead of eating other living things.")+
   steps("'Auto' means self, 'troph' means feeding","Green plants build food from air, water and sunlight","So a self-feeding green plant is an autotroph.")+
   U("Every blade of grass and every tree in a park is an autotroph quietly cooking its own food."),
   [("heterotrophs","Heterotrophs depend on others for food, like animals and fungi — the opposite of a self-feeder."),
    ("parasites","A parasite steals food from a living host; it does not make its own food."),
    ("decomposers","Decomposers feed on dead matter; they do not make food from sunlight and air.")]),

 ("NP","The green pigment in leaves that captures sunlight for making food is called:",
   "chlorophyll",
   C("Chlorophyll is the green colour in leaves that traps the Sun's light energy.")+
   steps("Sunlight carries energy","Chlorophyll absorbs this light","The trapped energy then powers food-making.")+
   U("Leaves look green precisely because chlorophyll soaks up other colours and bounces back green light."),
   [("haemoglobin","Haemoglobin is the red pigment that carries oxygen in blood, not a plant's light trap."),
    ("starch","Starch is the food a leaf stores, not the pigment that captures sunlight."),
    ("chlorine","Chlorine is a chemical element and gas; it has nothing to do with trapping sunlight.")]),

 ("NP","The process by which green plants use sunlight to make their own food is called:",
   "photosynthesis",
   C("Photosynthesis is the food-making process that runs on light energy in green leaves.")+
   steps("'Photo' means light, 'synthesis' means making","Light energy joins carbon dioxide and water","The result is food (sugar) plus oxygen.")+
   U("The food on your plate — fruit, rice, vegetables — all began with photosynthesis in some green plant."),
   [("respiration","Respiration breaks food down to release energy; photosynthesis builds food up."),
    ("digestion","Digestion breaks food into simpler bits inside a body; it does not make new food from light."),
    ("transpiration","Transpiration is the loss of water vapour from leaves, not the making of food.")]),

 ("NP","Besides sunlight and chlorophyll, the two raw materials a green plant needs for photosynthesis are:",
   "carbon dioxide and water",
   C("Photosynthesis combines carbon dioxide from the air with water from the soil.")+
   steps("Leaves take in carbon dioxide through tiny pores","Roots draw up water from the soil","Sunlight then joins these two into food.")+
   U("A potted plant kept watered in bright light is being given exactly these raw materials."),
   [("oxygen and starch","Oxygen and starch are PRODUCTS of photosynthesis, not the raw materials going in."),
    ("nitrogen and salts","Nitrogen and mineral salts help growth but are not the raw materials for making sugar."),
    ("sugar and water","Sugar is the food made; it is not a raw material fed into the process.")]),

 ("NP","The gas given out by a green plant during photosynthesis in daylight is:",
   "oxygen",
   C("As plants make food in light, they release oxygen back into the air.")+
   steps("Carbon dioxide and water enter the reaction","Food (sugar) is built up","Oxygen is set free as a by-product.")+
   U("The oxygen you breathe in right now was released by green plants and ocean plankton."),
   [("carbon dioxide","Carbon dioxide is taken IN for photosynthesis, not given out, in daylight."),
    ("nitrogen","Nitrogen makes up most of the air but is neither used nor released in photosynthesis here."),
    ("water vapour","Water is a raw material that is used up; oxygen is the gas actually released.")]),

 ("NP","The tiny pores on the surface of a leaf through which gases enter and leave are called:",
   "stomata",
   C("Stomata are minute openings on leaves that let carbon dioxide in and oxygen out.")+
   steps("Leaves must swap gases with the air","Tiny adjustable pores allow this exchange","These pores are the stomata.")+
   U("On a hot day a plant can shut its stomata to save water, just like closing tiny windows."),
   [("roots","Roots absorb water and minerals from soil; they are not the leaf's gas pores."),
    ("veins","Veins are the leaf's transport tubes for water and food, not openings for gases."),
    ("petals","Petals are parts of a flower; they are not the gas-exchange pores of a leaf.")]),

 ("NP","Each stoma (leaf pore) is opened and closed by a pair of curved cells called:",
   "guard cells",
   C("Guard cells flank each stoma and change shape to open or close the pore.")+
   steps("Two bean-shaped cells border each pore","When they swell, the pore opens","When they shrink, the pore closes.")+
   U("Guard cells act like tiny automatic doors, opening for fresh air and shutting to save water."),
   [("root hairs","Root hairs absorb water in the soil; they do not guard leaf pores."),
    ("blood cells","Plants have no blood cells; guard cells, not blood cells, control the stomata."),
    ("nerve cells","Plants have no nerves; the pore is worked by guard cells, not nerve cells.")]),

 ("NP","The food made by a green leaf is stored mainly in the form of:",
   "starch",
   C("Extra sugar made in photosynthesis is stored in the leaf as starch.")+
   steps("Photosynthesis first makes sugar","Sugar not used at once is changed to starch","Starch is the leaf's stored food.")+
   U("A potato is so filling because it is a swollen store of starch the plant set aside."),
   [("protein","Plants do make protein, but the immediate stored food of a leaf is starch, not protein."),
    ("fat","Some seeds store oil, but the food first stored in a green leaf is starch."),
    ("vitamins","Vitamins are needed in tiny amounts; they are not the bulk stored food of a leaf.")]),

 ("NP","To test a leaf for the presence of starch, we add a few drops of:",
   "iodine solution",
   C("Iodine turns blue-black when it touches starch, which is how we detect starch in a leaf.")+
   steps("A leaf is boiled to remove its green colour","A drop of iodine is added","If starch is present, it turns blue-black.")+
   U("This same blue-black test is used in school labs to show that a sunlit leaf has made food."),
   [("lime water","Lime water tests for carbon dioxide, not for starch in a leaf."),
    ("blue litmus","Litmus tests whether something is acidic or basic, not for starch."),
    ("common salt","Salt has no colour-changing reaction with starch; iodine is the starch test.")]),

 ("NP","Plants that cannot make their own food and instead live on and take food from another living plant are called:",
   "parasites",
   C("A parasitic plant draws ready-made food from a living host plant.")+
   steps("Some plants lack enough chlorophyll to feed themselves","They attach to a living host","They absorb the host's food — they are parasites.")+
   U("The yellow tangled threads of Cuscuta (amarbel) over a bush is a parasite feeding off its host."),
   [("saprotrophs","Saprotrophs feed on DEAD and decaying matter, not on a living host."),
    ("autotrophs","Autotrophs make their own food; a parasite cannot and must steal it."),
    ("insectivores","Insectivorous plants trap insects; a parasite instead taps a living plant host.")]),

 ("NP","A pitcher plant traps and digests insects mainly to obtain the nutrient it lacks in marshy soil, namely:",
   "nitrogen",
   C("Pitcher plants grow in nitrogen-poor soil, so they catch insects to get the nitrogen they need.")+
   steps("Marshy soil is poor in nitrogen","The plant still makes sugar by photosynthesis","It traps insects to get nitrogen for proteins.")+
   U("The pitcher plant's leafy jug, with its slippery rim, is a clever insect trap for extra nitrogen."),
   [("sugar","The plant already makes its own sugar by photosynthesis; it traps insects for nitrogen."),
    ("oxygen","Oxygen comes freely from the air; the insect is digested for nitrogen, not oxygen."),
    ("water","Marshy ground has plenty of water; the missing nutrient there is nitrogen.")]),

 ("NP","Organisms such as bread mould and mushrooms that feed by breaking down dead and decaying matter are called:",
   "saprotrophs",
   C("Saprotrophs feed on dead, decaying material, breaking it down to absorb the nutrients.")+
   steps("Dead matter is full of stored nutrients","Saprotrophs release juices that break it down","They then soak up the simple food.")+
   U("Fuzzy mould spreading over old bread is a saprotroph quietly digesting the bread from outside."),
   [("autotrophs","Autotrophs make food from sunlight; saprotrophs instead feed on dead matter."),
    ("parasites","Parasites feed on LIVING hosts; saprotrophs feed on dead, decaying matter."),
    ("herbivores","Herbivores are animals that eat living plants, not decomposers of dead matter.")]),

 ("NP","Fungi and algae living together so closely that both benefit, as seen in a lichen, is an example of:",
   "symbiosis",
   C("In symbiosis two different organisms live together and both gain from the partnership.")+
   steps("The alga makes food by photosynthesis","The fungus gives water, shelter and minerals","Both partners benefit — that is symbiosis.")+
   U("The crusty grey-green lichen on an old wall is a fungus and an alga living as partners."),
   [("parasitism","In parasitism only one side gains while the other is harmed; in symbiosis both gain."),
    ("competition","Competition is a struggle over the same resource, not a partnership that helps both."),
    ("predation","Predation is one organism eating another; symbiosis is mutual benefit, not eating.")]),

 ("NP","The soil bacterium that lives in the root nodules of pulse (legume) plants and supplies them nitrogen is:",
   "Rhizobium",
   C("Rhizobium lives in the root nodules of legumes and converts air nitrogen into a form the plant can use.")+
   steps("Plants cannot use nitrogen gas directly","Rhizobium in the root nodules fixes this nitrogen","The legume then gets the nitrogen it needs.")+
   U("Farmers grow pulses like gram and beans partly because Rhizobium enriches the soil with nitrogen."),
   [("chlorophyll","Chlorophyll is a leaf pigment, not a bacterium that supplies nitrogen."),
    ("amoeba","Amoeba is a tiny animal-like organism in water; it does not fix nitrogen in roots."),
    ("yeast","Yeast is a fungus used in baking; it is not the nitrogen-fixing bacterium in legumes.")]),

 ("NP","Green plants need nitrogen to build proteins, but they cannot use the nitrogen gas of the air directly. They take nitrogen mostly as:",
   "nitrogen salts dissolved in soil water",
   C("Plants absorb nitrogen as soluble nitrogen salts from the soil through their roots.")+
   steps("Air nitrogen is unusable by plants directly","Bacteria turn it into soluble nitrogen salts","Roots absorb these salts dissolved in soil water.")+
   U("This is why fertilisers add nitrogen salts to the soil to help crops grow lush and green."),
   [("nitrogen gas through the leaves","Plants cannot take in nitrogen GAS directly; they need it as soluble salts in soil."),
    ("oxygen from the air","Oxygen is not a source of nitrogen; the plant needs nitrogen salts from the soil."),
    ("starch from the roots","Starch is stored food, not a source of nitrogen drawn from the soil.")]),

 ("NP","Inside a leaf cell, photosynthesis actually takes place in tiny green structures called:",
   "chloroplasts",
   C("Chloroplasts are the green bodies inside leaf cells where photosynthesis happens.")+
   steps("Each leaf cell holds many tiny chloroplasts","They contain the green chlorophyll","Food is made right inside these chloroplasts.")+
   U("Under a microscope a leaf cell is dotted with green chloroplasts — the cell's little food kitchens."),
   [("nuclei","The nucleus controls the cell, but photosynthesis happens in the chloroplasts, not the nucleus."),
    ("vacuoles","A vacuole is a storage sac of sap; it is not where food is made."),
    ("cell walls","The cell wall gives shape and support; it does not carry out photosynthesis.")]),

 ("NP","If a green leaf is destarched and then kept in the dark for two days, an iodine test on it will show:",
   "no blue-black colour, because no starch was made",
   C("Without light a leaf cannot photosynthesise, so it makes no starch and the iodine stays brown.")+
   steps("Photosynthesis needs light","In the dark the leaf makes no new food","With no starch, iodine shows no blue-black colour.")+
   U("This classic experiment proves that light is essential for a leaf to make food."),
   [("a strong blue-black colour everywhere","Blue-black would mean starch was made, but darkness stops the leaf from making any."),
    ("a bright red colour","Iodine never turns red with a leaf; with no starch it simply stays brownish."),
    ("a green colour as before","The starch test does not keep the leaf green; with no starch it stays iodine-brown.")]),

 ("NP","Animals, fungi and most bacteria, which depend on plants or other organisms for their food, are called:",
   "heterotrophs",
   C("Heterotrophs cannot make their own food and so must take it from other organisms.")+
   steps("'Hetero' means other, 'troph' means feeding","These organisms cannot make food themselves","They feed on others — they are heterotrophs.")+
   U("You, your dog and the mushroom on your pizza are all heterotrophs depending on plant-made food."),
   [("autotrophs","Autotrophs make their own food; heterotrophs are the ones that cannot."),
    ("producers","Producers are the food-making plants; heterotrophs are consumers that depend on them."),
    ("pigments","A pigment is a coloured substance, not a kind of food-dependent organism.")]),

 ("NP","Because a leaf takes in raw materials and uses light to make food, a leaf is often called the plant's:",
   "food factory",
   C("A leaf brings in carbon dioxide, water and light and turns them into food, so it works like a factory.")+
   steps("Raw materials enter the leaf","Light energy powers the food-making","Food (sugar) comes out — just like a factory.")+
   U("Spread flat to the Sun, a leaf is a busy green factory churning out the plant's food all day."),
   [("waste bin","A leaf makes useful food, not waste; calling it a food factory fits far better."),
    ("water tank","A leaf is not mainly a store of water; it is where food is actually made."),
    ("flower","A flower is the reproductive part; the leaf is the food-making factory.")]),

 ("NP","The very first food (a simple sugar) formed when a leaf carries out photosynthesis is:",
   "glucose",
   C("Photosynthesis first makes glucose, a simple sugar, which can then be stored as starch.")+
   steps("Carbon dioxide and water join using light energy","The first product is the sugar glucose","Extra glucose is later stored as starch.")+
   U("The sweetness inside ripe grapes comes largely from glucose first made by photosynthesis."),
   [("starch","Starch is the STORED form made later; the first sugar produced is glucose."),
    ("protein","Protein needs nitrogen and forms later; the first food made is the sugar glucose."),
    ("fat","Fat is built up afterwards in some plants; the first product of photosynthesis is glucose.")]),

 ("NP","Leaves look green to our eyes mainly because chlorophyll:",
   "reflects green light while absorbing other colours",
   C("Chlorophyll soaks up red and blue light for energy but bounces back green, so leaves look green.")+
   steps("White sunlight is a mix of colours","Chlorophyll absorbs most colours for energy","It reflects green light, so the leaf looks green.")+
   U("In autumn, when chlorophyll breaks down, leaves stop looking green and turn yellow or red."),
   [("absorbs only green light","If it absorbed green, leaves would not look green; chlorophyll actually reflects green."),
    ("adds green colour to sunlight","Chlorophyll does not create light; it simply reflects the green already in sunlight."),
    ("turns water green","The green is in the chlorophyll of the leaf, not a colouring of water.")]),

 ("NP","Growing pulses (legumes) in a field between crops helps the soil because their roots, with Rhizobium, restore the soil's:",
   "nitrogen",
   C("Legume roots host Rhizobium, which puts nitrogen back into the soil for the next crop.")+
   steps("Crops use up the soil's nitrogen","Legume roots host nitrogen-fixing Rhizobium","This restores nitrogen for the following crop.")+
   U("Farmers rotate wheat with gram or beans so the soil's nitrogen is naturally topped up."),
   [("water","Pulses do not add water to the soil; they restore its nitrogen through Rhizobium."),
    ("sunlight","Sunlight reaches the soil from the Sun; legumes cannot add sunlight to the soil."),
    ("carbon dioxide","Carbon dioxide comes from the air; the legumes restore the soil's nitrogen, not its CO2.")]),

 ("NP","The water and dissolved minerals a plant uses for nutrition are absorbed from the soil by its:",
   "roots",
   C("Roots absorb water and dissolved mineral salts from the soil and pass them up the plant.")+
   steps("Soil holds water with dissolved minerals","Fine root hairs soak this up","It travels up to the leaves for food-making.")+
   U("When you water a plant, the roots are busy drinking up that water along with soil minerals."),
   [("flowers","Flowers are for reproduction; they do not absorb water and minerals from the soil."),
    ("stomata","Stomata exchange gases on leaves; the soil's water and minerals enter through the roots."),
    ("fruits","Fruits hold seeds; they are not the organs that absorb soil water and minerals.")]),

 ("NP","The mode of nutrition seen in fungi growing on a rotting log, where they secrete juices to digest the dead wood and then absorb it, is:",
   "saprotrophic nutrition",
   C("Saprotrophic nutrition means feeding on dead matter by digesting it outside the body and absorbing it.")+
   steps("The fungus meets dead, decaying wood","It releases digestive juices onto it","It then absorbs the broken-down food — saprotrophic nutrition.")+
   U("Mushrooms sprouting on a dead log are saprotrophs recycling the wood's nutrients back to the soil."),
   [("parasitic nutrition","Parasites feed on LIVING hosts; here the wood is dead, so it is saprotrophic."),
    ("autotrophic nutrition","Autotrophs make their own food from light; a fungus on dead wood does not."),
    ("insectivorous nutrition","Insectivorous plants trap insects; a fungus digesting dead wood is a saprotroph.")]),

 ("NP","The simple sugar made in photosynthesis is carried from the leaves to all other parts of the plant by tubes called:",
   "phloem",
   C("Phloem is the plant's tube system that carries food made in the leaves to the rest of the plant.")+
   steps("Leaves make sugar by photosynthesis","This food must reach roots, stem and fruit","Phloem tubes carry it everywhere — including downward.")+
   U("The sweetness building up in a ripening mango travels there through phloem from the leaves."),
   [("xylem","Xylem carries WATER and minerals UP from the roots; food travels in the phloem."),
    ("stomata","Stomata are leaf pores for gases; they do not transport food through the plant."),
    ("chlorophyll","Chlorophyll is the green pigment that traps light; it is not a transport tube.")]),
]

# ---------- LINES & ANGLES (25) — Maths (with fusion stems) ----------
LA = [
 ("LA","Two angles whose measures add up to exactly 90° are said to be:",
   "complementary angles",
   C("Two angles are complementary when they add to a right angle, 90°.")+
   steps("Add the two angle measures","If the sum is exactly 90°","they are complementary angles.")+
   U("The two slanted braces meeting a vertical pole at 90° split that right angle as complementary parts."),
   [("supplementary angles","Supplementary angles add to 180°, not 90° — that is a straight angle, not a right angle."),
    ("vertically opposite angles","Vertically opposite angles are equal pairs across an X; they need not add to 90°."),
    ("adjacent angles","Adjacent angles merely share a side and vertex; their sum is not fixed at 90°.")]),

 ("LA","Two angles whose measures add up to exactly 180° are said to be:",
   "supplementary angles",
   C("Two angles are supplementary when together they make a straight angle, 180°.")+
   steps("Add the two angle measures","If the sum is exactly 180°","they are supplementary angles.")+
   U("On a straight road, the two angles a side-lane makes on either side are supplementary, summing to 180°."),
   [("complementary angles","Complementary angles add to 90°, half of what supplementary angles make."),
    ("equal angles","Equal angles simply have the same size; their sum need not be 180°."),
    ("reflex angles","A reflex angle is a single angle larger than 180°, not a supplementary pair.")]),

 ("LA","The complement of an angle measuring 35° is:",
   "55°",
   C("The complement is what must be added to reach 90°.")+
   steps("Complementary angles add to 90°","Subtract: 90° − 35°","= 55°, the complement.")+
   U("If a ramp rises at 35° from the floor, it leans 55° from the upright wall — the two make a right angle."),
   [("65°","65° + 35° = 100°, which overshoots 90°, so 65° is not the complement."),
    ("145°","145° + 35° = 180°; that makes them supplementary, not complementary."),
    ("125°","125° is larger than 90° itself, so it cannot be a complement of a positive angle.")]),

 ("LA","The supplement of an angle measuring 110° is:",
   "70°",
   C("The supplement is what must be added to reach 180°.")+
   steps("Supplementary angles add to 180°","Subtract: 180° − 110°","= 70°, the supplement.")+
   U("Where a straight pipe bends at 110° on one side, the angle on the other side is 70° — together 180°."),
   [("90°","90° + 110° = 200°, more than a straight angle, so 90° is not the supplement."),
    ("80°","80° + 110° = 190°, which is past 180°, so 80° is not correct."),
    ("250°","250° is itself larger than 180°, so it cannot be the supplement of a 110° angle.")]),

 ("LA","When two adjacent angles are placed so that their outer arms form a straight line, they make a linear pair, and their measures always add to:",
   "180°",
   C("A linear pair sits on a straight line, so the two angles together make a straight angle of 180°.")+
   steps("The outer arms form one straight line","A straight angle measures 180°","So the linear pair adds to 180°.")+
   U("A door swung partly open splits the straight wall-line into two angles that together total 180°."),
   [("90°","90° is a right angle; a linear pair lies along a straight line and totals 180°, not 90°."),
    ("360°","360° is a full turn around a point; a single straight line gives 180°, not 360°."),
    ("270°","270° is three right angles; a straight-line linear pair sums to 180°.")]),

 ("LA","When two straight lines cross, the pair of angles directly opposite each other (vertically opposite angles) are always:",
   "equal in measure",
   C("Vertically opposite angles formed by two crossing lines are always equal.")+
   steps("Two lines cross, making an X of four angles","The angles facing each other are vertically opposite","These opposite angles are always equal.")+
   U("Two crossed scissors blades make equal vertically opposite angles at the rivet where they meet."),
   [("supplementary (adding to 180°)","Vertically opposite angles are EQUAL; it is the adjacent pairs that add to 180°."),
    ("complementary (adding to 90°)","Vertically opposite angles are equal, not a pair that adds to 90°."),
    ("always right angles","They are equal to each other, but they need not each be 90° unless the lines are perpendicular.")]),

 ("LA","Two straight roads cross each other. One of the four angles formed measures 70°. The angle vertically opposite to it measures:",
   "70°",
   C("Vertically opposite angles are equal, so the angle facing the 70° angle is also 70°.")+
   steps("Two lines cross, forming an X","Vertically opposite angles are equal","So opposite the 70° angle is another 70°.")+
   U("At a simple crossroads, the angle between two roads is mirrored exactly on the opposite side."),
   [("110°","110° is the angle ADJACENT to it (a linear pair); the vertically opposite one equals 70°."),
    ("20°","20° would be the complement of 70°, but vertically opposite angles are equal, so it is 70°."),
    ("90°","The vertically opposite angle equals the original 70°, not a right angle.")]),

 ("LA","An angle that measures exactly 90° is called a:",
   "right angle",
   C("A right angle is a quarter turn, measuring exactly 90°.")+
   steps("A full turn is 360°","One quarter of that is 90°","An angle of exactly 90° is a right angle.")+
   U("The corner of this page, where two edges meet squarely, is a right angle of 90°."),
   [("straight angle","A straight angle is 180°, twice a right angle, not 90°."),
    ("acute angle","An acute angle is less than 90°; exactly 90° is the special right angle."),
    ("reflex angle","A reflex angle is more than 180°, far bigger than a 90° right angle.")]),

 ("LA","An angle whose measure is more than 90° but less than 180° is called:",
   "an obtuse angle",
   C("An obtuse angle is wider than a right angle but still less than a straight line.")+
   steps("Compare with 90° (right) and 180° (straight)","More than 90° but less than 180°","fits the obtuse angle.")+
   U("A laptop screen leaned well back, wider than a square corner, makes an obtuse angle with the keyboard."),
   [("an acute angle","An acute angle is LESS than 90°; an obtuse angle is more than 90°."),
    ("a right angle","A right angle is exactly 90°; an obtuse angle is bigger than that."),
    ("a straight angle","A straight angle is exactly 180°; an obtuse angle is less than 180°.")]),

 ("LA","Two angles of a linear pair are equal to each other. The measure of each angle is:",
   "90°",
   C("A linear pair adds to 180°; if the two are equal, each is half of 180°.")+
   steps("The two equal angles add to 180°","Each = 180° ÷ 2","= 90°.")+
   U("When a line stands perfectly upright on another, it splits the straight line into two equal 90° angles."),
   [("45°","Two 45° angles add to only 90°, but a linear pair must total 180°."),
    ("60°","Two 60° angles add to 120°, short of the 180° a linear pair needs."),
    ("180°","180° is the TOTAL of the pair, not the size of each equal angle, which is 90°.")]),

 ("LA","A transversal crosses two parallel lines. A pair of corresponding angles formed at the two crossings are always:",
   "equal in measure",
   C("With parallel lines, corresponding angles (same position at each crossing) are equal.")+
   steps("A transversal cuts both parallel lines","Corresponding angles sit in matching positions","On parallel lines these are equal.")+
   U("The matching angles where a railway sleeper crosses two parallel rails are equal corresponding angles."),
   [("supplementary (adding to 180°)","Corresponding angles are EQUAL on parallel lines; it is co-interior angles that add to 180°."),
    ("complementary (adding to 90°)","Corresponding angles are equal, not a pair summing to 90°."),
    ("always 90°","They are equal to each other, but they are only 90° if the transversal is perpendicular.")]),

 ("LA","A transversal cuts two parallel lines. A pair of alternate interior angles are always:",
   "equal in measure",
   C("Between two parallel lines, alternate interior angles (on opposite sides of the transversal) are equal.")+
   steps("Look at the angles between the two parallel lines","Take the pair on opposite sides of the transversal","On parallel lines these alternate angles are equal.")+
   U("The Z-shape of a zig-zag path between two parallel walls shows equal alternate interior angles."),
   [("supplementary","Alternate interior angles are EQUAL on parallel lines, not a pair adding to 180°."),
    ("complementary","They are equal, not a pair summing to 90°."),
    ("reflex","An alternate interior angle is an ordinary angle, equal to its partner, not a reflex angle.")]),

 ("LA","A transversal cuts two parallel lines. A pair of co-interior (allied) angles on the same side of the transversal always add up to:",
   "180°",
   C("Between parallel lines, the two interior angles on the same side of the transversal are supplementary.")+
   steps("Take the interior angles on one side of the transversal","On parallel lines they form a supplementary pair","So they add to 180°.")+
   U("The two inside angles on one side where a beam crosses two parallel rafters always sum to 180°."),
   [("90°","Co-interior angles on parallel lines add to 180°, not to a right angle."),
    ("360°","360° is a full turn; the co-interior pair sums to a straight angle, 180°."),
    ("they are equal","Co-interior angles ADD to 180°; it is alternate and corresponding angles that are equal.")]),

 ("LA","One angle of a linear pair measures 125°. The other angle measures:",
   "55°",
   C("A linear pair adds to 180°, so subtract the known angle from 180°.")+
   steps("Linear pair sum = 180°","180° − 125°","= 55°.")+
   U("Where a lamp-post leans at 125° on one side of the ground line, the other side shows 55°."),
   [("65°","65° + 125° = 190°, which overshoots the 180° of a linear pair."),
    ("75°","75° + 125° = 200°, too much for a straight-line pair."),
    ("45°","45° + 125° = 170°, short of the required 180°.")]),

 ("LA","Two complementary angles are in the ratio 1 : 2. The larger of the two angles measures:",
   "60°",
   C("Complementary angles add to 90°; split 90° in the ratio 1 : 2.")+
   steps("Let the angles be x and 2x, with x + 2x = 90°","So 3x = 90°, giving x = 30°","The larger angle = 2x = 60°.")+
   U("A folding ruler bent so one part is twice the other, meeting at a square corner, gives 30° and 60°."),
   [("30°","30° is the SMALLER angle (x); the larger one is 2x = 60°."),
    ("45°","Two equal 45° angles would be ratio 1 : 1, not 1 : 2 as required."),
    ("120°","120° is bigger than 90° itself, so it cannot be part of a complementary pair.")]),

 ("LA","A reflex angle is an angle whose measure is:",
   "more than 180° but less than 360°",
   C("A reflex angle is the large angle that is bigger than a straight angle but less than a full turn.")+
   steps("A straight angle is 180°, a full turn is 360°","A reflex angle lies between these","so it is more than 180° but less than 360°.")+
   U("The big sweep on the outside of a slightly-open pair of compasses is a reflex angle."),
   [("less than 90°","Less than 90° is an acute angle, the smallest kind, not a reflex angle."),
    ("exactly 180°","Exactly 180° is a straight angle; a reflex angle is bigger than that."),
    ("exactly 90°","Exactly 90° is a right angle, far smaller than any reflex angle.")]),

 ("LA","Two supplementary angles are in the ratio 1 : 2. The two angles are:",
   "60° and 120°",
   C("Supplementary angles add to 180°; split 180° in the ratio 1 : 2.")+
   steps("Let them be x and 2x, with x + 2x = 180°","So 3x = 180°, giving x = 60°","The angles are 60° and 2x = 120°.")+
   U("A reclining seat that opens one part twice as far as the other along a straight line gives 60° and 120°."),
   [("45° and 90°","45° + 90° = 135°, not the 180° supplementary pairs must total."),
    ("90° and 90°","Equal 90° angles are in ratio 1 : 1, not the required 1 : 2."),
    ("30° and 60°","30° + 60° = 90°; that is a complementary pair, not a supplementary one.")]),

 ("LA","A wind vane (weathercock) on a roof first points due North, then turns clockwise to point due East. The angle it has turned through is:",
   "90°",
   C("North to East is one quarter of a full turn, which is 90°.")+
   steps("A full turn around the compass is 360°","North to East is one quarter of that circle","One quarter of 360° = 90°.")+
   U("On a windy day a weathercock swinging from North round to East has turned through a right angle, 90°."),
   [("45°","45° is only half of the North-to-East quarter; the full quarter turn is 90°."),
    ("180°","180° would point the vane from North all the way to South, not just to East."),
    ("270°","270° is three-quarters of a turn; North to East directly is only one quarter, 90°.")]),

 ("LA","A weathercock turns from pointing North all the way round clockwise to point South. The angle turned is:",
   "180°",
   C("North to South, going halfway round the compass, is a straight angle of 180°.")+
   steps("A full turn is 360°","North to South is exactly half of that circle","Half of 360° = 180°.")+
   U("When the wind reverses completely, a vane swings North to South — a half turn of 180°."),
   [("90°","90° would only carry the vane from North to East, a quarter turn, not all the way to South."),
    ("360°","360° is a full circle that brings the vane back to North, not round to South."),
    ("45°","45° points the vane to the North-East direction, far short of South.")]),

 ("LA","Two angles are both equal AND supplementary to each other. Each angle therefore measures:",
   "90°",
   C("If equal angles are supplementary, each is half of 180°.")+
   steps("Equal angles: call each x, so x + x = 180°","2x = 180°","x = 90°.")+
   U("Two identical set-squares laid flat along a straight edge each open out a 90° right angle."),
   [("45°","Two 45° angles add to only 90°, but supplementary angles must total 180°."),
    ("60°","Two equal 60° angles add to 120°, not the 180° supplementary pairs need."),
    ("180°","180° is the SUM of the pair; each equal angle is half of that, 90°.")]),

 ("LA","The complement of an angle of 1° is:",
   "89°",
   C("The complement is what is needed to reach 90°.")+
   steps("Complementary angles add to 90°","90° − 1°","= 89°.")+
   U("A barely-tilted shelf almost flat against the wall leaves nearly all of the 90° corner — about 89°."),
   [("99°","99° + 1° = 100°, which overshoots 90°, so it is not the complement."),
    ("179°","179° + 1° = 180°; that is a supplementary pair, not a complementary one."),
    ("91°","91° is already larger than 90°, so it cannot be the complement of a positive angle.")]),

 ("LA","The sum of all the angles formed around a single point (a complete turn) is:",
   "360°",
   C("Going once all the way around a point is a full turn, which measures 360°.")+
   steps("Start at a ray and sweep all the way back to it","That is one complete turn","A complete turn measures 360°.")+
   U("The eight directions marked around the centre of a compass card together fill a full 360° turn."),
   [("180°","180° is only a half turn (a straight angle); a full turn around a point is 360°."),
    ("90°","90° is just a quarter turn; the angles all around a point add to a full 360°."),
    ("270°","270° is three-quarters of a turn; a complete turn around a point is 360°.")]),

 ("LA","A transversal cuts two parallel lines and one co-interior (allied) angle measures 70°. Its co-interior partner on the same side measures:",
   "110°",
   C("Co-interior angles on parallel lines are supplementary, so they add to 180°.")+
   steps("Co-interior angles add to 180° on parallel lines","180° − 70°","= 110°.")+
   U("The two inside angles on one side where a strut crosses two parallel rails are 70° and 110°."),
   [("70°","Co-interior angles ADD to 180°; equal 70° angles would be alternate or corresponding, not co-interior."),
    ("20°","20° would be the complement of 70°, but co-interior angles are supplementary, giving 110°."),
    ("90°","90° + 70° = 160°, not the 180° that co-interior angles on parallel lines require.")]),

 ("LA","An angle whose measure is less than 90° is called:",
   "an acute angle",
   C("An acute angle is smaller than a right angle.")+
   steps("Compare with the 90° right angle","Anything less than 90°","is an acute angle.")+
   U("The sharp tip of a slice of pizza, narrower than a square corner, opens out an acute angle."),
   [("an obtuse angle","An obtuse angle is MORE than 90°; an acute angle is less than 90°."),
    ("a right angle","A right angle is exactly 90°; an acute angle is smaller than that."),
    ("a reflex angle","A reflex angle is more than 180°, far larger than an acute angle under 90°.")]),

 ("LA","The supplement of an angle is three times the angle itself. The original angle measures:",
   "45°",
   C("Supplementary angles add to 180°; if the supplement is three times the angle, split 180° into four equal parts.")+
   steps("Let the angle be x; its supplement is 3x","x + 3x = 180°, so 4x = 180°","x = 45°.")+
   U("Two folding boards meeting along a straight edge, one opened three times as far as the other, give 45° and 135°."),
   [("60°","If x were 60°, its supplement would be 120°, which is only twice 60°, not three times."),
    ("90°","A 90° angle has a 90° supplement, equal to itself, not three times it."),
    ("135°","135° is the SUPPLEMENT (3x); the original angle asked for is x = 45°.")]),
]

# ---------- WINDS, STORMS & CYCLONES (25) — Science ----------
WS = [
 ("WS","The push that air exerts on the surfaces it touches, in every direction, is called air:",
   "pressure",
   C("Air has weight and pushes on everything around it; this push is air pressure.")+
   steps("Air is made of moving particles","They constantly push on surfaces","This push spread over an area is air pressure.")+
   U("A pumped-up football is firm because the air inside pushes out with pressure on its skin."),
   [("temperature","Temperature is how hot or cold the air is, not the push it exerts on surfaces."),
    ("humidity","Humidity is the water vapour in the air, not the pushing force of the air."),
    ("speed","Speed tells how fast air moves; pressure is the push it exerts even when still.")]),

 ("WS","Air that is in motion from one place to another is simply called:",
   "wind",
   C("Wind is nothing more than air on the move.")+
   steps("Air can sit still or it can move","When a body of air moves along","we feel and call it wind.")+
   U("The breeze that cools your face and flutters a kite is just moving air — wind."),
   [("pressure","Pressure is the push of air; wind is the air actually moving from place to place."),
    ("vapour","Vapour is water in gas form in the air, not the movement of the air itself."),
    ("cloud","A cloud is floating water droplets; the moving air carrying it is the wind.")]),

 ("WS","Winds always blow from a region of higher air pressure towards a region of:",
   "lower air pressure",
   C("Air flows from where pressure is high to where it is low, and that flow is wind.")+
   steps("Pressure differs from place to place","Air pushes from high pressure to low pressure","This moving air is the wind.")+
   U("Open a fizzy bottle and the high-pressure gas rushes out to the lower-pressure air with a hiss."),
   [("higher air pressure","Air does not flow towards higher pressure; it moves AWAY from high towards low pressure."),
    ("equal air pressure","Wind needs a pressure difference; if pressure were equal everywhere there would be no wind."),
    ("higher temperature","Wind is driven by the pressure difference, not by chasing higher temperatures.")]),

 ("WS","When air is heated, it expands and becomes lighter. As a result, the warm air tends to:",
   "rise upward",
   C("Heated air spreads out, grows lighter than the cooler air, and floats up.")+
   steps("Heat makes air expand","Expanded air is lighter for its size","The lighter warm air rises.")+
   U("Smoke from a fire and the warm air over a hot road both drift upward because warm air rises."),
   [("sink downward","Warm air is lighter than cool air, so it rises rather than sinks."),
    ("stay perfectly still","Heated, lighter air does not stay put; it rises, letting cooler air move in below."),
    ("turn into water","Heating does not turn air into water; the warm, lighter air simply rises.")]),

 ("WS","When warm air rises from a place, the air pressure left behind at that place becomes:",
   "lower",
   C("As warm air rises away, fewer air particles push down there, so the pressure falls.")+
   steps("Warm air rises and leaves the spot","Fewer particles remain pressing down","So the air pressure there becomes lower.")+
   U("Over a hot field, rising warm air leaves a low-pressure patch that cooler air rushes in to fill."),
   [("higher","Rising air leaves FEWER particles behind, so the pressure drops, it does not rise."),
    ("unchanged","Losing the rising warm air must change the pressure; it falls, it does not stay the same."),
    ("doubled","There is no reason for pressure to double; with warm air gone, it simply becomes lower.")]),

 ("WS","The basic reason winds blow over the Earth is the:",
   "uneven heating of the Earth by the Sun",
   C("The Sun heats different parts of the Earth unequally, setting up the pressure differences that cause winds.")+
   steps("The Sun heats land, sea and air unevenly","Uneven heating makes pressure differences","Air flowing between them is wind.")+
   U("Sea breezes, monsoons and storms all trace back to the Sun heating the Earth unevenly."),
   [("pull of the Moon","The Moon's pull mainly causes ocean tides, not the winds; uneven solar heating drives winds."),
    ("rotation of clouds","Clouds are carried by winds; they do not cause the winds, which come from uneven heating."),
    ("light of the stars","Distant stars give far too little energy to heat the Earth or drive its winds.")]),

 ("WS","During the day at a coast, the land heats up faster than the sea, so the breeze blows:",
   "from the sea towards the land",
   C("By day the hot land has low pressure, so cooler air flows in from the sea — a sea breeze.")+
   steps("Land heats faster than sea by day","Hot land has rising air and low pressure","Cool sea air flows in: a sea breeze from sea to land.")+
   U("On a sunny afternoon at the beach you feel a refreshing breeze blowing in from the sea."),
   [("from the land towards the sea","That is the NIGHT-time land breeze; by day the breeze blows from sea to land."),
    ("straight upward only","Air does rise over the hot land, but the breeze we feel moves in horizontally from the sea."),
    ("in no particular direction","There is a clear direction: by day the sea breeze blows from the cooler sea to the warm land.")]),

 ("WS","At night near a coast, the land cools faster than the sea, so the breeze blows:",
   "from the land towards the sea",
   C("By night the sea is warmer, with lower pressure, so air flows out from the cooler land — a land breeze.")+
   steps("Land cools faster than sea at night","The warmer sea now has rising air and low pressure","Cooler land air flows out to sea: a land breeze.")+
   U("Fishermen often sail out at night helped by the land breeze blowing from the shore towards the sea."),
   [("from the sea towards the land","That is the DAYTIME sea breeze; at night the breeze reverses to blow from land to sea."),
    ("there is never any breeze at night","Breezes still blow at night; the cooled land sends a land breeze out to sea."),
    ("only straight downward","The night breeze moves horizontally from land to sea, not straight down.")]),

 ("WS","If you blow hard across the top of a strip of paper held to your lips, the free end of the paper surprisingly:",
   "rises up",
   C("Fast-moving air on top lowers the pressure there, so the higher pressure below lifts the paper.")+
   steps("Blowing speeds up the air ABOVE the paper","Faster air means lower pressure above","Higher pressure below then pushes the paper up.")+
   U("This same low-pressure-over-fast-air idea helps lift aeroplane wings into the sky."),
   [("is pushed downward","Faster air above LOWERS the pressure there, so the paper is pushed up, not down."),
    ("tears in half","Gently blowing does not tear the paper; the pressure difference simply lifts it."),
    ("stays perfectly flat","The unequal pressure above and below makes the paper rise; it does not stay flat.")]),

 ("WS","Generally, the faster the air moves over a region, the air pressure there becomes:",
   "lower",
   C("Where air moves faster, it presses less on the surfaces, so the pressure is lower.")+
   steps("Still air presses fully on a surface","Fast-moving air presses less","So faster wind means lower pressure.")+
   U("Strong winds racing over a roof create low pressure above that can lift the roof off in a storm."),
   [("higher","Faster-moving air presses LESS, so the pressure falls; it does not rise."),
    ("unchanged","Speeding the air up does change the pressure — it lowers it, not leaves it the same."),
    ("zero","Pressure becomes lower with faster air, but it does not drop all the way to zero.")]),

 ("WS","A very large, violent storm with extremely high-speed winds whirling in a spiral around a calm centre is called a:",
   "cyclone",
   C("A cyclone is a huge spiralling storm of high-speed winds around a calm centre.")+
   steps("Warm moist air rises rapidly over warm seas","Surrounding air spirals in to fill the low pressure","This whirling high-wind storm is a cyclone.")+
   U("Coastal warnings before a cyclone help people move inland before its fierce winds and rain strike."),
   [("breeze","A breeze is a gentle, slow wind; a cyclone is a huge, violent, high-speed storm."),
    ("rainbow","A rainbow is a band of colours from sunlight in raindrops, not a storm of winds."),
    ("fog","Fog is a low cloud of tiny water droplets near the ground, not a spiralling windstorm.")]),

 ("WS","The calm, low-pressure region right at the centre of a cyclone is called the:",
   "eye",
   C("The eye of a cyclone is its calm central region, around which the fierce winds spiral.")+
   steps("Winds whirl violently around the centre","The very centre stays calm and clear","This calm centre is the eye of the cyclone.")+
   U("Satellite pictures of a cyclone show a clear round 'eye' at the heart of the spinning clouds."),
   [("tail","A cyclone's centre is called its eye, not a tail; the spiral has no tail like a comet."),
    ("crest","Crest names the top of a wave; the calm centre of a cyclone is its eye."),
    ("root","Root is a part of a plant; the calm middle of a cyclone is called the eye.")]),

 ("WS","The instrument used to measure the speed of the wind is called an:",
   "anemometer",
   C("An anemometer measures how fast the wind is blowing, usually with spinning cups.")+
   steps("Wind pushes small cups or vanes","They spin faster in stronger wind","A scale reads off the wind speed — an anemometer.")+
   U("Weather stations mount a spinning-cup anemometer on a pole to report each day's wind speed."),
   [("thermometer","A thermometer measures temperature, not the speed of the wind."),
    ("barometer","A barometer measures air pressure, not how fast the wind is moving."),
    ("rain gauge","A rain gauge measures the depth of rainfall, not the wind's speed.")]),

 ("WS","The very high-speed winds of a cyclone, together with the very low pressure at its centre, are dangerous mainly because they can:",
   "rip off roofs and uproot trees",
   C("The fierce winds and low pressure of a cyclone can tear roofs away and topple trees and poles.")+
   steps("Low pressure inside lets higher pressure push from outside","The racing winds shove hard on walls and roofs","Roofs lift off and trees and poles are uprooted.")+
   U("After a strong cyclone, coastal towns often show roofs blown away and trees lying uprooted."),
   [("make the weather cooler and pleasant","A cyclone brings destruction, not pleasant weather; its winds rip roofs and uproot trees."),
    ("light up the sky like a rainbow","A cyclone is a destructive storm, not a harmless display of colour."),
    ("freeze the sea into ice","Cyclones form over warm seas; they do not freeze the sea — they devastate with wind and rain.")]),

 ("WS","Towering storm clouds and thunderstorms build up most readily when the local air happens to be:",
   "hot and humid",
   C("Thunderstorms build up when the air is hot and full of moisture.")+
   steps("Hot air rises rapidly","If it is humid, it carries lots of water vapour","Rising warm moist air builds towering storm clouds.")+
   U("Sticky, sweaty summer afternoons in India often end in a sudden thunderstorm."),
   [("cold and dry","Cold, dry air does not rise and carry the moisture needed; thunderstorms favour hot, humid air."),
    ("cool and clear","Clear, cool skies lack the rising warm moisture that fuels a thunderstorm."),
    ("freezing and snowy","Snowy freezing weather is far too cold for the warm, moist updrafts a thunderstorm needs.")]),

 ("WS","Rising warm, moist air is important for storms because, as it goes up and cools, the water vapour in it:",
   "condenses to form clouds",
   C("As moist air rises and cools, its vapour turns into tiny droplets, building the clouds of a storm.")+
   steps("Warm moist air rises and cools higher up","Cooler air cannot hold as much vapour","The vapour condenses into droplets, forming clouds.")+
   U("The tall, dark thunderclouds before a storm are built from moisture condensing in rising air."),
   [("disappears completely","The vapour does not vanish; it condenses into the droplets that make storm clouds."),
    ("turns into oxygen gas","Water vapour cannot become oxygen; on cooling it condenses into liquid droplets."),
    ("sinks back to the ground as vapour","Rising vapour cools and condenses into clouds; it does not sink back down as vapour.")]),

 ("WS","When a cyclone is approaching a coast, the most sensible action for people living there is to:",
   "move to a safe shelter further inland",
   C("Because cyclones bring deadly winds, rain and a rising sea, people should evacuate to safer ground.")+
   steps("Cyclone warnings give advance notice","The coast faces the fiercest winds and flooding","Moving inland to a safe shelter saves lives.")+
   U("Coastal districts run loudspeaker warnings and shelters so families can move inland before a cyclone lands."),
   [("rush to the beach to watch the waves","The coast is the most dangerous place in a cyclone; people must move inland, not towards the sea."),
    ("ignore the warning and stay outdoors","Ignoring a cyclone warning is very dangerous; the safe choice is to shelter inland."),
    ("climb the tallest tree","High-speed cyclone winds uproot and snap trees, so climbing one is highly dangerous.")]),

 ("WS","Just before a cyclone strikes the coast, the sea water near the shore often rises sharply in a so-called storm surge. This rise mainly causes:",
   "flooding of low-lying coastal land",
   C("A storm surge pushes sea water far inland, flooding low coastal areas.")+
   steps("Cyclone winds and low pressure heap up sea water","This surge sweeps onto the shore","Low-lying coastal land is flooded.")+
   U("Storm-surge flooding is often a cyclone's deadliest effect on low-lying coastal villages."),
   [("a sudden drop in sea level","A storm surge RAISES the sea near the shore; it does not lower it."),
    ("the sea freezing over","Cyclones form over warm seas; a surge floods the land, it does not freeze the sea."),
    ("clearer, calmer weather","A storm surge comes with the cyclone's fury, not with calm, clear weather.")]),

 ("WS","A wind vane (weathercock) mounted on a roof is used to show the:",
   "direction from which the wind is blowing",
   C("A wind vane swings to point into the wind, showing the direction the wind comes from.")+
   steps("The arrow turns freely on a pivot","The wind pushes its tail around","It settles pointing into the wind, showing wind direction.")+
   U("The cockerel-shaped vane on an old building turns to show which way the wind is coming from."),
   [("speed of the wind in km/h","Wind SPEED is measured by an anemometer; a wind vane shows only the direction."),
    ("amount of rainfall","Rainfall is measured by a rain gauge, not by a wind vane."),
    ("temperature of the air","Temperature needs a thermometer; a wind vane only points out the wind's direction.")]),

 ("WS","The reason a hot-air balloon rises into the sky is that the air inside it is heated, so it becomes:",
   "lighter than the cooler air outside",
   C("Heating the air inside makes it expand and grow lighter than the surrounding air, so the balloon floats up.")+
   steps("A burner heats the air inside the balloon","Heated air expands and becomes lighter","Being lighter than the outside air, the balloon rises.")+
   U("Festival hot-air balloons climb because the flame keeps the air inside hot and light."),
   [("heavier than the cooler air outside","If the inside air were heavier, the balloon would sink; heating makes it lighter, so it rises."),
    ("turned into water","Heating air does not turn it into water; the warm, light air lifts the balloon."),
    ("the same weight as the outside air","If the weights matched, it would not rise; heated air must be lighter to lift the balloon.")]),

 ("WS","The seasonal winds that bring most of India's rain, blowing in from the sea in summer, are the:",
   "monsoon winds",
   C("The monsoon winds blow in from the warm sea in summer and bring India its main rains.")+
   steps("In summer the land heats up more than the sea","Moist air flows in from the sea towards the land","These rain-bearing seasonal winds are the monsoon.")+
   U("Farmers across India wait eagerly for the monsoon winds that water their fields each summer."),
   [("land breezes","A land breeze is a small nightly coastal wind, not the great rain-bringing monsoon."),
    ("dry desert winds","Dry desert winds bring no rain; the rain-bearing seasonal winds are the monsoon."),
    ("cyclone eye winds","The eye of a cyclone is calm; India's seasonal rains are brought by the monsoon winds.")]),

 ("WS","A flag on a tall pole flutters and streams out straight in one direction. This best shows that there is a strong:",
   "wind blowing in that direction",
   C("A flag streaming out tells us the wind is strong and shows the way it is blowing.")+
   steps("Still air leaves a flag hanging limp","Moving air pushes the cloth out","A flag held straight out shows a strong wind.")+
   U("Watching a flagpole, you can quickly judge both how strong the wind is and which way it blows."),
   [("rainfall over the pole","A fluttering flag shows wind, not rain; rainfall is measured by a rain gauge."),
    ("rise in air temperature","A flag streaming out shows moving air (wind), not a change in temperature."),
    ("drop in humidity","A flag's flutter reveals wind, not the amount of moisture in the air.")]),

 ("WS","A dark, funnel-shaped cloud that reaches down from a thundercloud to the ground, with very fast whirling winds, is called a:",
   "tornado",
   C("A tornado is a fast-spinning funnel of wind that stretches from cloud to ground.")+
   steps("A violent thundercloud forms whirling winds","A narrow funnel reaches down to the ground","This whirling funnel is a tornado.")+
   U("Tornadoes, common in some flat countries, can lift cars and tear apart houses along a narrow track."),
   [("rainbow","A rainbow is a harmless band of colours, not a destructive whirling funnel of wind."),
    ("glacier","A glacier is a slow river of ice on land, not a whirling cloud of wind."),
    ("waterfall","A waterfall is falling water over a cliff, not a funnel-shaped windstorm.")]),

 ("WS","Wind speed is commonly reported by weather offices in units of:",
   "kilometres per hour",
   C("Wind speed is usually given as a distance covered each hour, in kilometres per hour.")+
   steps("Speed is distance divided by time","For wind, the distance is in kilometres and the time in hours","So wind speed is reported in kilometres per hour.")+
   U("A weather bulletin might warn of cyclone winds of 'up to 120 kilometres per hour' near the coast."),
   [("degrees Celsius","Degrees Celsius measure temperature, not the speed of the wind."),
    ("millimetres","Millimetres measure rainfall depth, not how fast the wind blows."),
    ("kilograms","Kilograms measure mass; wind speed is a distance per time, in kilometres per hour.")]),

 ("WS","When cooler, denser air moves in to replace warm air that has risen, this horizontal movement of air is felt by us as a:",
   "wind",
   C("Cool dense air flowing in to take the place of risen warm air is the moving air we call wind.")+
   steps("Warm air rises and leaves a low-pressure gap","Cooler, denser air rushes in sideways to fill it","This horizontal flow of air is the wind.")+
   U("The cool gust you feel rushing toward a bonfire is air flowing in to replace the hot air rising above it."),
   [("cloud","A cloud is floating water droplets; the inrushing cool air itself is the wind."),
    ("rainfall","Rainfall is water dropping from clouds; the sideways flow of cool air is the wind."),
    ("pressure","Pressure is the push of air; the actual sideways movement of that air is the wind.")]),
]

# ---------- RATIONAL NUMBERS (25) — Maths (with fusion stems) ----------
RN = [
 ("RN","A number that can be written in the form p/q, where p and q are integers and q is not zero, is called a:",
   "rational number",
   C("A rational number is any number expressible as a fraction p/q of two integers with a non-zero denominator.")+
   steps("Take any two integers p and q","Make sure the denominator q is not zero","Then p/q is a rational number.")+
   U("Splitting a bill of 3 friends paying for 2 pizzas as 2/3 each is using a rational number."),
   [("whole number only","Whole numbers are rational, but the term also covers fractions like 3/4 and negatives like -2/5."),
    ("prime number","A prime is a special whole number; a rational number is any p/q with q not zero."),
    ("irrational number","An irrational number CANNOT be written as p/q; a rational number is exactly one that can.")]),

 ("RN","In a rational number written as p/q, the one value that q (the denominator) must never take is:",
   "zero",
   C("Division by zero is undefined, so the denominator of a rational number can never be zero.")+
   steps("p/q means p divided by q","Dividing by zero has no meaning","So q can never be zero.")+
   U("Sharing 5 sweets among 0 children makes no sense — which is why a denominator of zero is banned."),
   [("one","A denominator of 1 is perfectly fine; for example 5/1 is just the integer 5."),
    ("a negative number","Denominators may be negative (we then tidy the sign); only zero is forbidden."),
    ("a large number","Any size of denominator is allowed; the single forbidden value is zero.")]),

 ("RN","Which statement is true about every integer, such as 7 or -3?",
   "Every integer is also a rational number",
   C("Any integer n equals n/1, so every integer is a rational number.")+
   steps("Take an integer like 7","Write it as 7/1, a fraction of integers","So every integer is a rational number.")+
   U("A bank balance of -300 rupees is an integer and also a rational number, -300/1."),
   [("No integer is a rational number","This is false: every integer n equals n/1, which is rational."),
    ("Only positive integers are rational","Negatives like -3 = -3/1 are rational too, so this is wrong."),
    ("Integers are irrational numbers","Integers can be written as p/q, so they are rational, never irrational.")]),

 ("RN","Written in standard form (lowest terms with a positive denominator), the rational number 4/(-8) becomes:",
   "-1/2",
   C("Standard form needs a positive denominator and the lowest terms.")+
   steps("4/(-8): move the minus to the top → -4/8","Divide top and bottom by 4","= -1/2.")+
   U("A half-metre drop below a fixed mark, recorded as -4/8 m, is tidily written as -1/2 m."),
   [("1/2","The number is negative (a positive over a negative), so it is -1/2, not +1/2."),
    ("-4/8","-4/8 is correct in value but not in lowest terms; reduced, it is -1/2."),
    ("-2","Dividing 4 by 8 gives a half, not 2; the answer is -1/2, not -2.")]),

 ("RN","The additive inverse (the number you add to get 0) of the rational number 3/7 is:",
   "-3/7",
   C("The additive inverse of a number is its negative, since a number plus its negative is 0.")+
   steps("We need a number that gives 0 when added to 3/7","That number is -3/7","Check: 3/7 + (-3/7) = 0.")+
   U("Earning 3/7 of a kilo and then giving away 3/7 of a kilo leaves you with exactly nothing."),
   [("7/3","7/3 is the RECIPROCAL of 3/7, not its additive inverse, which is -3/7."),
    ("3/7","Adding 3/7 to 3/7 gives 6/7, not 0; the additive inverse is -3/7."),
    ("0","0 is the result of adding a number to its inverse, not the inverse of 3/7 itself.")]),

 ("RN","The rational number -5/8 lies on the number line between the two integers:",
   "-1 and 0",
   C("-5/8 is negative and smaller in size than 1, so it sits between -1 and 0.")+
   steps("-5/8 is negative, so it is left of 0","Its size 5/8 is less than 1","So it lies between -1 and 0.")+
   U("A temperature of -5/8 of a degree below zero sits just a little below the 0 mark on a scale."),
   [("0 and 1","-5/8 is negative, so it is to the LEFT of 0, between -1 and 0, not between 0 and 1."),
    ("-1 and -2","-5/8 has size less than 1, so it stays between 0 and -1, not as far out as -2."),
    ("5 and 8","-5/8 is a small negative number near zero, nowhere near the integers 5 and 8.")]),

 ("RN","The reciprocal (multiplicative inverse) of the rational number -2/3 is:",
   "-3/2",
   C("The reciprocal is found by swapping numerator and denominator, keeping the sign.")+
   steps("Flip -2/3 to get -3/2","Check: (-2/3) × (-3/2) = 1","So the reciprocal is -3/2.")+
   U("Recipes scale by reciprocals: to undo multiplying by -2/3 you multiply by its reciprocal, -3/2."),
   [("2/3","2/3 just drops the sign; the reciprocal keeps the sign and flips to -3/2."),
    ("3/2","3/2 has the wrong sign; the reciprocal of the negative -2/3 is the negative -3/2."),
    ("-2/3","-2/3 is the original number; its reciprocal is the flipped -3/2.")]),

 ("RN","The value of (-3/4) + (1/4) is:",
   "-1/2",
   C("With the same denominator, just add the numerators.")+
   steps("Denominators already match (4)","-3 + 1 = -2, so we get -2/4","Reduce -2/4 to -1/2.")+
   U("Owing 3/4 of a chocolate bar and then getting back 1/4 still leaves you owing 1/2."),
   [("-1","-3/4 + 1/4 = -2/4 = -1/2, not -1; -1 would need the numerators to add to -4."),
    ("-4/4","-3 + 1 is -2, giving -2/4, not -4/4; the reduced answer is -1/2."),
    ("1/2","The bigger part is negative, so the sum is NEGATIVE, -1/2, not +1/2.")]),

 ("RN","Which of these two negative rational numbers is the greater (lies further to the right on the number line): -2/3 or -3/4 ?",
   "-2/3 is greater",
   C("For negative numbers, the one closer to zero is the greater; -2/3 is closer to 0 than -3/4.")+
   steps("Use a common denominator 12: -2/3 = -8/12, -3/4 = -9/12","-8/12 is closer to 0 than -9/12","So -2/3 is the greater number.")+
   U("A debt of 2/3 rupee is smaller than a debt of 3/4 rupee, so -2/3 is the 'better', greater value."),
   [("-3/4 is greater","-3/4 = -9/12 is FURTHER from 0 than -8/12, so it is the smaller, not the greater."),
    ("they are equal","-2/3 = -8/12 and -3/4 = -9/12 are different, so they are not equal."),
    ("neither can be compared","Negative rationals can always be compared; -2/3 is greater than -3/4.")]),

 ("RN","A rational number that lies exactly between 1/4 and 1/2 on the number line is:",
   "3/8",
   C("The number midway between two rationals is their average, found by adding and halving.")+
   steps("Write 1/4 = 2/8 and 1/2 = 4/8","Their average is (2/8 + 4/8) ÷ 2 = (6/8) ÷ 2","= 3/8.")+
   U("If two shelf marks are at 1/4 m and 1/2 m, the midpoint peg goes at 3/8 m."),
   [("1/3","1/3 lies between 1/4 and 1/2 in value, but the exact MIDPOINT asked for is 3/8."),
    ("5/8","5/8 = 0.625 is bigger than 1/2, so it lies OUTSIDE the range, not between the two."),
    ("1/8","1/8 = 0.125 is smaller than 1/4, so it lies below the range, not between them.")]),

 ("RN","The product (2/3) × (-9/4) is:",
   "-3/2",
   C("Multiply numerators together and denominators together, then reduce.")+
   steps("(2 × -9)/(3 × 4) = -18/12","Divide top and bottom by 6","= -3/2.")+
   U("Scaling a -9/4 m change by a factor of 2/3 gives a change of -3/2 m."),
   [("3/2","A positive times a negative is NEGATIVE, so the answer is -3/2, not +3/2."),
    ("-18/12","-18/12 is correct in value but not reduced; in lowest terms it is -3/2."),
    ("-6","2/3 of -9/4 is -3/2, not -6; multiplying by 2/3 makes the number smaller, not bigger.")]),

 ("RN","The value of (-6/7) ÷ (-2/7) is:",
   "3",
   C("To divide by a fraction, multiply by its reciprocal; a negative divided by a negative is positive.")+
   steps("(-6/7) ÷ (-2/7) = (-6/7) × (-7/2)","= 42/14","= 3.")+
   U("Asking how many -2/7 m steps fit into a -6/7 m drop gives exactly 3 steps."),
   [("-3","A negative divided by a negative gives a POSITIVE result, so it is 3, not -3."),
    ("1/3","Dividing -6/7 by -2/7 gives 3, not 1/3; you may have flipped the wrong fraction."),
    ("3/7","The sevenths cancel, leaving 6 ÷ 2 = 3, a whole number, not 3/7.")]),

 ("RN","Written in standard form, the rational number (-7)/(-3) becomes:",
   "7/3",
   C("A negative divided by a negative is positive, and standard form keeps a positive denominator.")+
   steps("(-7)/(-3): the two minus signs cancel","This gives 7/3","7 and 3 share no common factor, so it is already standard.")+
   U("Recording 'down 7 of down 3' as (-7)/(-3) simplifies to a plain positive 7/3."),
   [("-7/3","Two negatives cancel to give a POSITIVE, so it is 7/3, not -7/3."),
    ("-7/-3","-7/-3 is correct in value but standard form moves to a positive denominator: 7/3."),
    ("3/7","Dividing -7 by -3 gives 7/3, not its flip 3/7.")]),

 ("RN","The sum of any rational number and its additive inverse is always:",
   "0",
   C("A number and its negative cancel out, leaving zero.")+
   steps("Take any rational number a","Its additive inverse is -a","a + (-a) = 0, always.")+
   U("Stepping 5/6 m forward and then 5/6 m back leaves you exactly where you started — a net of 0."),
   [("1","A number plus its NEGATIVE gives 0; it is a number times its reciprocal that gives 1."),
    ("the number itself","Adding the inverse cancels the number to 0, it does not leave the number unchanged."),
    ("a negative number","The inverse exactly cancels the number, giving 0, not some negative value.")]),

 ("RN","The product of any non-zero rational number and its reciprocal is always:",
   "1",
   C("A number times its reciprocal (multiplicative inverse) gives 1.")+
   steps("Take a non-zero rational a/b","Its reciprocal is b/a","(a/b) × (b/a) = ab/ab = 1.")+
   U("Multiplying a quantity by 3/5 and then by its reciprocal 5/3 returns you to the original amount."),
   [("0","A number times its reciprocal gives 1; it is a number PLUS its additive inverse that gives 0."),
    ("the number itself","Multiplying by the reciprocal undoes the number to give 1, not the number again."),
    ("the reciprocal itself","The product is 1, a single fixed value, not the reciprocal.")]),

 ("RN","Between any two different rational numbers on the number line, how many rational numbers can be found?",
   "infinitely many",
   C("You can always find another rational number between any two, so there are infinitely many.")+
   steps("Take two rationals; find their average — a new rational between them","Now do the same in each smaller gap","This never ends, so there are infinitely many.")+
   U("Between 1/2 m and 3/4 m on a ruler you can keep marking finer and finer points without ever stopping."),
   [("exactly one","There is not just one; you can keep averaging to find endlessly many rationals between them."),
    ("none at all","There is always at least the average between two different rationals, in fact infinitely many."),
    ("exactly ten","The count is not a fixed number like ten; it is infinitely many.")]),

 ("RN","The value of (1/2) − (3/4) is:",
   "-1/4",
   C("Use a common denominator, then subtract the numerators.")+
   steps("Write 1/2 = 2/4","2/4 − 3/4 = (2 − 3)/4","= -1/4.")+
   U("Having 1/2 litre of milk and a recipe needing 3/4 litre leaves you 1/4 litre SHORT, i.e. -1/4."),
   [("1/4","Since 3/4 is bigger than 1/2, the answer is NEGATIVE, -1/4, not +1/4."),
    ("-2/4","2/4 − 3/4 = -1/4; writing it as -2/4 mishandles the numerators 2 and 3."),
    ("5/4","Subtraction makes the result smaller, not larger; 1/2 − 3/4 = -1/4, not 5/4.")]),

 ("RN","On a winter night a hill-station thermometer reads 2°C, then falls by 5 degrees by dawn. The dawn temperature, as a rational number of degrees, is:",
   "-3",
   C("Falling 5 degrees from 2°C means subtracting 5 from 2.")+
   steps("Start at 2°C","A fall of 5 means 2 − 5","= -3, so -3°C.")+
   U("Mountain weather reports show such below-zero temperatures, written as negative numbers like -3°C."),
   [("3","A fall makes the temperature LOWER, going below zero to -3, not up to +3."),
    ("-7","2 − 5 is -3, not -7; -7 would need a starting point of -2, not +2."),
    ("7","Adding instead of subtracting gives 7; a fall of 5 from 2 actually gives -3.")]),

 ("RN","During a storm the air pressure drops steadily, falling 1/4 unit each hour for 3 hours. The total change in pressure, as a rational number, is:",
   "-3/4",
   C("A fall of 1/4 unit for 3 hours is 3 times -1/4.")+
   steps("Each hour the change is -1/4","Over 3 hours: 3 × (-1/4)","= -3/4.")+
   U("Weather charts show a cyclone's pressure dropping by such steady negative steps before it strikes."),
   [("3/4","The pressure FALLS, so the total change is negative, -3/4, not +3/4."),
    ("-1/4","-1/4 is just ONE hour's change; over 3 hours it is three times that, -3/4."),
    ("-12","3 × (1/4) is 3/4, not 12; the total change is the small value -3/4.")]),

 ("RN","Which of these correctly shows the rational number 5/(-6) written with a positive denominator?",
   "-5/6",
   C("Moving the minus sign from the denominator to the front gives a positive denominator.")+
   steps("5/(-6) has a negative denominator","Multiply top and bottom by -1","= -5/6, now with a positive denominator.")+
   U("Recording 5 equal parts of a 6-part drop as 5/(-6) is tidied to -5/6."),
   [("5/6","5/6 is positive, but 5/(-6) is negative; it equals -5/6, not +5/6."),
    ("6/5","6/5 flips the fraction (the reciprocal idea); the correct rewrite is -5/6."),
    ("-6/5","-6/5 both flips and changes the value; 5/(-6) is simply -5/6.")]),

 ("RN","The product (-2/5) × 0 is:",
   "0",
   C("Any number multiplied by zero is zero.")+
   steps("Multiplying anything by 0 gives 0","So (-2/5) × 0","= 0.")+
   U("Buying zero packets that each weigh -2/5 of a unit change still totals zero change."),
   [("-2/5","Multiplying by 0 wipes the value out to 0; it does not leave -2/5 behind."),
    ("2/5","Any number times 0 is 0, not 2/5; the sign does not matter when multiplying by zero."),
    ("1","A number times its reciprocal gives 1; a number times 0 gives 0.")]),

 ("RN","Which list shows three rational numbers that all lie between 0 and 1?",
   "1/4, 1/2, 3/4",
   C("Numbers between 0 and 1 are positive proper fractions, each less than 1.")+
   steps("Each value must be more than 0 and less than 1","1/4, 1/2 and 3/4 all satisfy this","so all three lie between 0 and 1.")+
   U("Marking 1/4 m, 1/2 m and 3/4 m on a one-metre ruler, all three fall between the 0 and 1 ends."),
   [("-1/4, 1/2, 3/4","-1/4 is NEGATIVE, so it lies below 0, not between 0 and 1."),
    ("1/2, 1, 3/2","1 is the endpoint and 3/2 is above 1, so these are not all strictly between 0 and 1."),
    ("3/4, 5/4, 7/4","5/4 and 7/4 are both greater than 1, so they lie beyond the 0-to-1 range.")]),

 ("RN","Is the number 0 a rational number, and why?",
   "Yes, because 0 can be written as 0/1",
   C("Zero is rational because it can be written as a fraction of integers, such as 0/1.")+
   steps("A rational number is any p/q with q not zero","Write 0 as 0/1, where q = 1 is not zero","So 0 is a rational number.")+
   U("A net change of zero, like adding then removing the same amount, is the rational number 0/1."),
   [("No, because 0 cannot be a fraction","0 CAN be written as 0/1, so it is rational; this reason is wrong."),
    ("No, because its denominator must be 0","0 is written as 0/1 with denominator 1, not 0, so it is perfectly rational."),
    ("Yes, but only when written as 1/0","1/0 is undefined (division by zero); 0 is rational as 0/1, not 1/0.")]),

 ("RN","The rational number midway between -1 and 0 on the number line is:",
   "-1/2",
   C("The midpoint of two numbers is their average — add them and divide by 2.")+
   steps("Average of -1 and 0 is (-1 + 0) ÷ 2","= -1 ÷ 2","= -1/2.")+
   U("A point halfway between the 0 mark and the -1 mark on a scale sits at -1/2."),
   [("-2","-2 lies beyond -1, not between -1 and 0; the midpoint is the small value -1/2."),
    ("1/2","The midpoint of -1 and 0 is NEGATIVE, -1/2, since both ends are at most 0."),
    ("-1","-1 is one of the endpoints, not the point halfway between -1 and 0, which is -1/2.")]),

 ("RN","A diver descends 3/5 of a metre each second below the water surface. After 4 seconds her depth, as a rational number of metres relative to the surface, is:",
   "-12/5",
   C("Each second adds a change of -3/5 m, so after 4 seconds multiply by 4.")+
   steps("Each second the change is -3/5 m","After 4 seconds: 4 × (-3/5)","= -12/5 m below the surface.")+
   U("Depth below a water surface is recorded with negative rational numbers, like -12/5 m here."),
   [("12/5","Going DOWN gives a negative depth, -12/5, not the positive +12/5."),
    ("-3/5","-3/5 m is just ONE second's change; after 4 seconds it is four times that, -12/5."),
    ("-7/5","4 × (-3/5) is -12/5, not -7/5; you must multiply the 3 by 4, not add.")]),
]

items = []
for i in range(25):
    items += [NP[i], LA[i], WS[i], RN[i]]
assert len(items) == 100

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

    keydist = build_paper(PNUM, TITLE, SHORT, LABELS, items, seed=21577,
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
    split = "/".join(str(counts[c]) for c in ("NP", "LA", "WS", "RN"))
    with open("PAPERS_MANIFEST.md", "a", encoding="utf-8") as fh:
        fh.write(f"| {PNUM} | 2026-06-18 | {TITLE} | {split} | ✓ |\n")

    # ---- update QUESTION_INDEX.json ----
    idx["fingerprints"] = sorted(existing | set(new_fps))
    idx.setdefault("combos", []).append({
        "paper": PNUM,
        "chapters": ["Nutrition in Plants",
                     "Lines & Angles",
                     "Winds, Storms & Cyclones",
                     "Rational Numbers"],
    })
    idx["papers"] = idx.get("papers", 0) + 1
    with open(idx_path, "w", encoding="utf-8") as fh:
        json.dump(idx, fh, ensure_ascii=False, indent=2)
        fh.write("\n")

    print("Files:", sorted(v for v in moves.values()))
    print("Answer key spread A/B/C/D =", dict(keydist))
    print("Fingerprints added:", len(new_fps))
