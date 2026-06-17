# -*- coding: utf-8 -*-
# Boss Challenge Paper 14 — Nutrition in Plants · Acids, Bases & Salts
#                          · Simple Equations · Rational Numbers
# Content-only. Uses the dependency-free examfactory engine.
# Difficulty ramp: this paper pushes FUSION — a Science context (chlorophyll,
# leaf area, acid drops, soil pH, photosynthesis rate) wrapped around a Maths
# skill (forming/solving simple equations, rational-number arithmetic).
# Class-7 scope, simple wording, hard thinking.
# Produces, under Resources/BossChallengePapers/:
#   Paper_14_<SHORT>_QuestionPaper.html  (pure HTML — questions + options, no answers)
#   Paper_14_<SHORT>_QuestionPaper.pdf
#   Paper_14_<SHORT>_Questions.md
#   Paper_14_<SHORT>_Solutions.html
import os, sys, shutil, json
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from examfactory import build_paper, C, steps, U

PNUM  = "14"
SHORT = "NutritionPlants_AcidsBases_SimpleEquations_RationalNumbers"
TITLE = "Nutrition in Plants · Acids, Bases & Salts · Simple Equations · Rational Numbers"
LABELS = {
    "NP": "Nutrition in Plants",
    "AB": "Acids, Bases & Salts",
    "SE": "Simple Equations",
    "RN": "Rational Numbers",
}

# ---------- NUTRITION IN PLANTS (25) — Science ----------
NP = [
 ("NP","The process by which green plants make their own food using sunlight is called:",
   "photosynthesis",
   C("Green plants are autotrophs — they build their own food from simple raw materials using light energy.")+
   steps("Leaves trap sunlight with chlorophyll","Carbon dioxide and water are combined","Glucose (food) and oxygen are produced.")+
   U("Every meal you eat traces back to a plant that once did photosynthesis."),
   [("respiration","Respiration releases energy from food; photosynthesis makes the food in the first place."),
    ("transpiration","Transpiration is loss of water vapour from leaves, not food-making."),
    ("digestion","Digestion breaks food down; plants build food up by photosynthesis.")]),

 ("NP","The green pigment in leaves that captures sunlight for photosynthesis is:",
   "chlorophyll",
   C("Chlorophyll is the molecule that absorbs light energy and gives leaves their green colour.")+
   steps("Sunlight falls on the leaf","Chlorophyll absorbs the light energy","That energy powers the food-making reaction.")+
   U("A plant grown in the dark turns pale because it cannot make fresh chlorophyll."),
   [("cytoplasm","Cytoplasm is the jelly inside a cell; the light-trapping pigment is chlorophyll."),
    ("starch","Starch is the stored food made; chlorophyll is the pigment that captures light."),
    ("haemoglobin","Haemoglobin carries oxygen in animal blood, not light-capture in leaves.")]),

 ("NP","Tiny pores on the underside of a leaf through which gases enter and leave are called:",
   "stomata",
   C("Stomata are small openings, each guarded by two cells, that let carbon dioxide in and oxygen out.")+
   steps("Carbon dioxide is needed for photosynthesis","It cannot pass the waxy leaf surface","Stomata open to let gases exchange.")+
   U("On a hot afternoon a plant may shut its stomata to save water — like closing a window."),
   [("veins","Veins carry water and food inside the leaf; gases move through stomata."),
    ("roots","Roots absorb water and minerals from soil, not gases from air."),
    ("chloroplasts","Chloroplasts house chlorophyll; the gas-exchange pores are the stomata.")]),

 ("NP","The raw materials a green plant needs to carry out photosynthesis are:",
   "carbon dioxide and water",
   C("Photosynthesis combines carbon dioxide from the air with water from the soil, using light.")+
   steps("Water rises from roots to leaves","Carbon dioxide enters through stomata","Light energy joins them into glucose.")+
   U("This is why a healthy plant needs both watering and fresh air to thrive."),
   [("oxygen and glucose","Oxygen and glucose are the products of photosynthesis, not the raw materials."),
    ("nitrogen and water","Nitrogen is needed for proteins, but the food-making raw material is carbon dioxide."),
    ("starch and sunlight","Starch is stored food and sunlight is energy; the material inputs are CO₂ and water.")]),

 ("NP","Plants like Cuscuta (Amarbel) that take food from another living plant are called:",
   "parasites",
   C("A parasitic plant has no chlorophyll of its own, so it draws ready-made food from a host plant.")+
   steps("Cuscuta lacks green chlorophyll","It coils around a host plant","Special roots pierce in and suck out food.")+
   U("Farmers pull out Amarbel early because it weakens the crop it climbs on."),
   [("saprotrophs","Saprotrophs feed on dead, decaying matter; a parasite feeds on a living host."),
    ("insectivores","Insectivorous plants trap insects but still photosynthesise; Cuscuta has no chlorophyll."),
    ("autotrophs","Autotrophs make their own food; Cuscuta cannot, so it steals from a host.")]),

 ("NP","A pitcher plant traps and digests insects mainly to obtain:",
   "nitrogen",
   C("Insectivorous plants grow in nitrogen-poor soil, so they get this nutrient from insect bodies.")+
   steps("The soil lacks enough nitrogen","The plant still photosynthesises for energy","It digests insects to supply missing nitrogen.")+
   U("It is a clever fix — make your own food, but catch insects for the minerals the ground cannot give."),
   [("water","Water comes easily from rain and soil; insects supply scarce nitrogen instead."),
    ("sunlight","Sunlight is captured by the green parts; insects provide a mineral, not light."),
    ("glucose","Glucose is made by photosynthesis; the insect provides nitrogen, not sugar.")]),

 ("NP","The mode of nutrition in which an organism feeds on dead and decaying matter is:",
   "saprotrophic nutrition",
   C("Saprotrophs such as many fungi release juices onto dead matter, then absorb the dissolved food.")+
   steps("Fungus settles on dead bread or wood","It secretes digestive juices outside its body","It soaks up the broken-down nutrients.")+
   U("This is why mushrooms sprout on a rotting log — they are eating it from outside."),
   [("parasitic nutrition","A parasite feeds on a living host; a saprotroph feeds on dead matter."),
    ("autotrophic nutrition","Autotrophs make their own food from sunlight, not from decaying matter."),
    ("holozoic nutrition","Holozoic feeders swallow solid food; saprotrophs digest it outside first.")]),

 ("NP","Rhizobium bacteria living in the root nodules of leguminous plants help by:",
   "fixing nitrogen from the air into the soil",
   C("Rhizobium and the legume share a partnership: the bacterium turns air nitrogen into a form the plant can use.")+
   steps("Air nitrogen cannot be used directly by plants","Rhizobium in root nodules converts it","The plant gets nitrogen; the bacterium gets food.")+
   U("Farmers grow gram or pea to naturally enrich a tired field with nitrogen."),
   [("absorbing extra sunlight for the plant","Sunlight is captured by leaves, not by root bacteria."),
    ("digesting insects for the plant","Digesting insects is done by pitcher plants, not Rhizobium."),
    ("storing water in the roots","Rhizobium supplies nitrogen, it does not store water.")]),

 ("NP","The test used to show that a leaf has made starch during photosynthesis uses:",
   "iodine solution",
   C("Starch turns blue-black with iodine, so iodine reveals where a leaf has stored its food.")+
   steps("Boil the leaf to remove chlorophyll","Add iodine solution to the pale leaf","Starch-rich areas turn blue-black.")+
   U("The same iodine trick checks whether a potato or rice grain is full of starch."),
   [("lime water","Lime water tests for carbon dioxide, not for starch."),
    ("blue litmus","Litmus tests for acids and bases, not for starch in a leaf."),
    ("copper sulphate","Copper sulphate is not the food-detecting test; iodine turns starch blue-black.")]),

 ("NP","The food made during photosynthesis is mainly stored in plants in the form of:",
   "starch",
   C("Glucose made in the leaf is converted to starch, an insoluble store that does not dissolve away.")+
   steps("Photosynthesis first makes glucose","Extra glucose is changed to starch","Starch is stored in leaves, roots or seeds.")+
   U("A potato is mostly stored starch — the plant's underground food bank."),
   [("protein","Proteins are built using nitrogen; the direct food store from photosynthesis is starch."),
    ("fat","Some seeds store oil, but the main carbohydrate store is starch."),
    ("glucose","Glucose is the first product, but it is stored as insoluble starch.")]),

 ("NP","Photosynthesis can take place in the green stem of a plant because the stem contains:",
   "chlorophyll",
   C("Any green part has chlorophyll, so green stems can trap light and make food just like leaves.")+
   steps("The stem looks green","Green colour means chlorophyll is present","Chlorophyll lets that part photosynthesise.")+
   U("A cactus has tiny leaves but a fat green stem that does most of its food-making."),
   [("starch","Starch is the stored food, not the pigment that lets the stem make food."),
    ("water","Water is a raw material, but the green colour comes from chlorophyll."),
    ("roots","Roots are not part of a stem and are usually not green or food-making.")]),

 ("NP","During photosynthesis the gas released by green plants into the air is:",
   "oxygen",
   C("Splitting water inside the leaf releases oxygen, which leaves through the stomata.")+
   steps("Water is broken apart using light","Oxygen is set free as a by-product","It escapes into the air through stomata.")+
   U("The oxygen you breathe is largely the leftover from countless plants photosynthesising."),
   [("carbon dioxide","Carbon dioxide is taken IN for photosynthesis; oxygen is given out."),
    ("nitrogen","Nitrogen is not produced by photosynthesis; the released gas is oxygen."),
    ("water vapour","Water vapour leaves by transpiration; the gas made in photosynthesis is oxygen.")]),

 ("NP","Nutrients such as nitrogen, phosphorus and potassium are returned to farm soil by adding:",
   "fertilisers or manure",
   C("Repeated cropping removes minerals, so farmers replace them with manure or fertiliser.")+
   steps("Plants take up minerals to grow","Harvesting removes those minerals","Manure or fertiliser puts them back.")+
   U("This is why fields are rested or fed compost between crops to keep yields high."),
   [("more sunlight","Sunlight gives energy, but it cannot replace soil minerals removed by crops."),
    ("extra carbon dioxide","Carbon dioxide is taken from the air, not added to soil as a nutrient."),
    ("plain water","Water is essential but does not by itself replace nitrogen and phosphorus.")]),

 ("NP","A plant kept completely in the dark for several days fails to make food because it lacks:",
   "light energy",
   C("Without light the chlorophyll has no energy to drive the food-making reaction.")+
   steps("Carbon dioxide and water are still present","But the energy source, light, is missing","So no glucose can be formed.")+
   U("Plants near a window lean toward the light because they cannot make food in the dark."),
   [("carbon dioxide","Carbon dioxide is still in the room's air; the missing factor in the dark is light."),
    ("water","The plant can still be watered; what the dark removes is light energy."),
    ("chlorophyll","The leaf still has chlorophyll, but with no light it has nothing to absorb.")]),

 ("NP","Organisms that cannot make their own food and depend on others for it are called:",
   "heterotrophs",
   C("Heterotrophs — including all animals and fungi — must take in food made by other organisms.")+
   steps("They have no way to trap light into food","So they eat plants or other organisms","This dependent mode is heterotrophic.")+
   U("You are a heterotroph — every bite of your dinner was first made by some autotroph."),
   [("autotrophs","Autotrophs make their own food; heterotrophs cannot and must take it in."),
    ("producers","Producers are the food-makers; food-takers are called heterotrophs."),
    ("chlorophytes","Green chlorophyll-bearing plants make food; heterotrophs do not.")]),

 ("NP","If one leaf makes 6 units of glucose in sunlight, the total made by 4 such leaves is:",
   "24 units",
   C("Each leaf works the same way, so multiply the per-leaf amount by the number of leaves.")+
   steps("One leaf = 6 units","Four leaves = 6 × 4","= 24 units of glucose.")+
   U("Counting per-leaf output this way estimates how much food a whole branch can make."),
   [("10 units","10 adds 6 and 4; the leaves multiply their output, giving 24."),
    ("12 units","12 is only two leaves' worth (6 × 2); four leaves give 24."),
    ("18 units","18 is three leaves (6 × 3); the fourth leaf brings it to 24.")]),

 ("NP","Water absorbed by the roots is carried up to the leaves through tubes called:",
   "xylem",
   C("Xylem is the plant's plumbing that moves water and minerals upward from root to leaf.")+
   steps("Roots absorb water from soil","Xylem tubes form a continuous pipe","Water rises to the leaves for photosynthesis.")+
   U("When you put a white flower in coloured water, the xylem carries the colour up the stem."),
   [("phloem","Phloem carries made food around the plant; water travels up in the xylem."),
    ("stomata","Stomata are leaf pores for gas exchange, not water-carrying tubes."),
    ("nodules","Nodules are root swellings with bacteria, not water-conducting tubes.")]),

 ("NP","Lichens, often seen on rocks and tree bark, are an example of a partnership between:",
   "a fungus and an alga",
   C("In a lichen the alga makes food by photosynthesis while the fungus supplies shelter and water.")+
   steps("The alga has chlorophyll and makes food","The fungus gives water and protection","Both partners benefit — symbiosis.")+
   U("Lichens are pollution indicators — they vanish from city air that is too dirty."),
   [("two parasites","Neither partner is a parasite; both gain, so it is mutual symbiosis."),
    ("an animal and a plant","Lichens are not animal partnerships; they pair a fungus with an alga."),
    ("two fungi","Only one partner is a fungus; the food-maker is an alga.")]),

 ("NP","A relationship in which two different organisms live together and both benefit is called:",
   "symbiosis",
   C("Symbiosis is a 'living together' partnership where each organism gives something the other needs.")+
   steps("Two unlike organisms live closely","Each provides a service to the other","Both gain — this is symbiosis.")+
   U("Rhizobium and the pea plant are symbiotic — nitrogen for the plant, food for the bacterium."),
   [("parasitism","In parasitism only one side benefits while the other is harmed."),
    ("competition","Competition means organisms struggle against each other, not help each other."),
    ("predation","Predation is one organism eating another, not a mutual partnership.")]),

 ("NP","The cell organelles inside leaf cells that actually contain chlorophyll are the:",
   "chloroplasts",
   C("Chloroplasts are tiny green bodies inside leaf cells where photosynthesis takes place.")+
   steps("Chlorophyll must be held somewhere","It sits inside chloroplasts","There the light reactions make food.")+
   U("Under a microscope a leaf cell looks dotted with green — those dots are chloroplasts."),
   [("mitochondria","Mitochondria release energy by respiration; chloroplasts do photosynthesis."),
    ("vacuoles","The large vacuole stores cell sap, not chlorophyll."),
    ("nucleus","The nucleus controls the cell; chlorophyll is held in chloroplasts.")]),

 ("NP","If a leaf produces 9 bubbles of oxygen each minute in bright light, in 5 minutes it makes:",
   "45 bubbles",
   C("Multiply the per-minute rate by the number of minutes to get the total.")+
   steps("Rate = 9 bubbles per minute","Time = 5 minutes","Total = 9 × 5 = 45 bubbles.")+
   U("Counting oxygen bubbles from a water plant is a real lab way to measure photosynthesis speed."),
   [("14 bubbles","14 adds 9 and 5; the rate must be multiplied by time, giving 45."),
    ("40 bubbles","40 is 8 × 5; at 9 per minute the total is 45."),
    ("54 bubbles","54 is 9 × 6; only 5 minutes pass, so the total is 45.")]),

 ("NP","Why is the lower surface of most leaves usually lighter green than the upper surface?",
   "the upper surface has more chloroplasts to catch sunlight",
   C("The top of the leaf faces the sun, so it packs more chlorophyll-rich cells than the shaded underside.")+
   steps("Sunlight strikes the upper surface first","More chloroplasts gather there to use it","So the top looks a darker green.")+
   U("Gardeners turn houseplants so every side gets a turn facing the light."),
   [("the lower surface stores all the water","Water storage does not decide leaf colour; chloroplast number does."),
    ("the lower surface has no veins","Veins run through both surfaces; the colour reflects chloroplast density."),
    ("the lower surface makes more food","The sunlit upper surface, richer in chloroplasts, makes more food.")]),

 ("NP","Insectivorous plants are usually found growing in soil that is poor in:",
   "nitrogen",
   C("Marshy, washed-out soils lack nitrogen, so these plants catch insects to make up the shortfall.")+
   steps("The boggy soil cannot supply nitrogen","The plant still photosynthesises for energy","It traps insects to get the missing nitrogen.")+
   U("This explains why Venus flytraps grow naturally in poor, swampy ground."),
   [("carbon","Carbon comes from carbon dioxide in air, not from the soil."),
    ("oxygen","Oxygen is taken from air and water; the scarce soil nutrient is nitrogen."),
    ("sunlight","Sunlight is not a soil nutrient; the lacking element is nitrogen.")]),

 ("NP","The main reason a desert plant such as a cactus has very small, spine-like leaves is to:",
   "reduce water loss",
   C("Small leaves mean fewer stomata and less surface, so the plant loses far less water in dry heat.")+
   steps("Big leaves lose lots of water vapour","A desert plant cannot spare water","Tiny spiny leaves cut that loss.")+
   U("The fat green stem then takes over the job of photosynthesis."),
   [("trap more sunlight","Small leaves trap less light; their real job is to save water."),
    ("store extra starch","Spines do not store starch; they cut water loss in the desert."),
    ("attract more insects","Spines deter animals; their purpose is reducing water loss, not luring insects.")]),

 ("NP","Two leaves together release 14 units of oxygen; if one leaf released 6 units, the other released:",
   "8 units",
   C("Subtract the known leaf's output from the total to find the second leaf's share.")+
   steps("Total oxygen = 14 units","One leaf = 6 units","Other leaf = 14 − 6 = 8 units.")+
   U("Splitting a measured total between contributors is everyday lab bookkeeping."),
   [("20 units","20 adds 14 and 6; the share is the difference, 8 units."),
    ("7 units","7 halves the total, but one leaf already gave 6, leaving 8 for the other."),
    ("6 units","6 is the first leaf's output; the second gave the remaining 8.")]),
]

# ---------- ACIDS, BASES & SALTS (25) — Science ----------
AB = [
 ("AB","A substance that tastes sour and turns blue litmus red is best described as:",
   "an acid",
   C("Acids share two everyday signs: a sour taste and the power to turn blue litmus paper red.")+
   steps("Taste of lemon or vinegar is sour","Dip blue litmus in it","It turns red — a sign of an acid.")+
   U("This is the quick litmus check chemists use to spot an acid in seconds."),
   [("a base","Bases taste bitter and turn red litmus blue — the opposite of an acid."),
    ("a salt","A salt is usually neutral; acids are the sour, blue-to-red ones."),
    ("an indicator","An indicator only shows the result; the sour substance itself is the acid.")]),

 ("AB","Bases generally taste bitter and feel:",
   "soapy",
   C("Bases have a characteristic bitter taste and a slippery, soapy feel to the touch.")+
   steps("Touch a soap solution carefully","It feels slippery and soapy","That soapy feel is typical of a base.")+
   U("This is why soap, which is basic, feels slippery when it gets on your hands."),
   [("gritty","Bases feel slippery, not gritty; grittiness is not a sign of a base."),
    ("sour","Sour is the taste of acids; bases are bitter and soapy."),
    ("sticky","Bases feel soapy and slippery, not particularly sticky.")]),

 ("AB","A natural indicator extracted from lichen that is used to test acids and bases is:",
   "litmus",
   C("Litmus, obtained from lichens, comes as blue and red paper and is the classic acid-base indicator.")+
   steps("Litmus is taken from a lichen","It is soaked into paper strips","Colour change reveals acid or base.")+
   U("A school chemistry set almost always includes red and blue litmus paper."),
   [("turmeric","Turmeric is also a natural indicator, but the lichen-derived one is litmus."),
    ("china rose","China rose petals act as an indicator, yet the lichen one is litmus."),
    ("phenolphthalein","Phenolphthalein is a synthetic indicator, not extracted from lichen.")]),

 ("AB","Turmeric paper, a natural indicator, turns from yellow to which colour in a base?",
   "red",
   C("Turmeric is yellow normally and turns red when it meets a base; acids leave it yellow.")+
   steps("Turmeric paper starts yellow","Touch it with a basic solution","It changes to red.")+
   U("A curry stain (turmeric) on cloth turns reddish where soap, a base, touches it."),
   [("blue","Turmeric does not go blue; with a base it turns red."),
    ("green","Green is not a turmeric result; bases turn it red."),
    ("colourless","Turmeric keeps its colour in acid and turns red in base, never colourless.")]),

 ("AB","The reaction between an acid and a base that produces a salt and water is called:",
   "neutralisation",
   C("When an acid and a base are mixed in the right amounts, they cancel each other to give salt and water.")+
   steps("Acid + base are combined","Their acidic and basic natures cancel","Salt and water are formed.")+
   U("An antacid tablet neutralises excess stomach acid to relieve acidity."),
   [("evaporation","Evaporation only removes water; the acid-base cancelling is neutralisation."),
    ("respiration","Respiration is a life process, not an acid-base reaction."),
    ("condensation","Condensation turns vapour to liquid; it is not neutralisation.")]),

 ("AB","When an ant bites, it injects formic acid; the best home remedy is to rub on it:",
   "a mild base like baking soda",
   C("The sting is acidic, so a mild base neutralises it and eases the pain.")+
   steps("Ant sting injects formic acid","A base can neutralise an acid","Baking soda paste calms the sting.")+
   U("This is the science behind dabbing baking soda on insect bites."),
   [("lemon juice","Lemon juice is itself an acid and would not neutralise the acidic sting."),
    ("vinegar","Vinegar is acetic acid — adding acid to an acid sting will not help."),
    ("plain sugar","Sugar is neutral and harmless but cannot neutralise the acid sting.")]),

 ("AB","Curd and lemon are sour because they contain, respectively:",
   "lactic acid and citric acid",
   C("Different sour foods owe their tang to different natural acids.")+
   steps("Curd turns sour as milk ferments","That sourness is lactic acid","Lemon's sourness is citric acid.")+
   U("Knowing the acid in a food helps explain why it tastes the way it does."),
   [("citric acid and lactic acid","The pairing is reversed — curd has lactic acid, lemon has citric acid."),
    ("acetic acid and tartaric acid","Acetic acid is in vinegar and tartaric in tamarind; curd and lemon differ."),
    ("hydrochloric acid and nitric acid","These are strong lab acids, not the mild acids in curd and lemon.")]),

 ("AB","Which of these household substances is basic in nature?",
   "soap solution",
   C("Soaps and cleaning agents are bases, which is why they feel slippery and clean grease.")+
   steps("Test soap solution with red litmus","Red litmus turns blue","Blue from red means a base.")+
   U("Most window and floor cleaners are basic because grease dissolves better in a base."),
   [("vinegar","Vinegar contains acetic acid, so it is acidic, not basic."),
    ("lemon juice","Lemon juice has citric acid and is acidic."),
    ("curd","Curd has lactic acid and is acidic, not basic.")]),

 ("AB","When a base turns red litmus blue, we can say the solution is:",
   "basic",
   C("Red litmus going blue is the standard signal that a solution is basic.")+
   steps("Dip red litmus in the solution","It changes to blue","Blue means the solution is basic.")+
   U("A quick litmus dip tells a lab worker whether a liquid is safe to taste-class as basic."),
   [("acidic","An acid turns blue litmus red, not red litmus blue; this one is basic."),
    ("neutral","A neutral solution leaves litmus unchanged; here red went blue."),
    ("salty","A colour change shows acid or base, not saltiness; this is basic.")]),

 ("AB","Excess use of fertilisers can make soil too acidic; to treat it, farmers add:",
   "quicklime or slaked lime (a base)",
   C("Acidic soil is neutralised by adding a base such as lime, restoring it for crops.")+
   steps("Over-fertilising lowers soil's nature to acidic","A base neutralises the acid","Lime is spread to fix the soil.")+
   U("This is a real farming practice called 'liming' an acidic field."),
   [("vinegar","Vinegar is acidic and would make acidic soil worse, not better."),
    ("more fertiliser","More fertiliser can add to the acidity; a base is needed instead."),
    ("common salt","Common salt is neutral and cannot neutralise the soil's acidity.")]),

 ("AB","A solution that does not change the colour of either red or blue litmus is:",
   "neutral",
   C("Neutral solutions are neither acidic nor basic, so litmus shows no change.")+
   steps("Add red litmus — no change","Add blue litmus — no change","No change means the solution is neutral.")+
   U("Pure water and common salt solution are neutral and leave litmus untouched."),
   [("strongly acidic","A strong acid would turn blue litmus red; no change means neutral."),
    ("strongly basic","A strong base would turn red litmus blue; here nothing changes."),
    ("an indicator","An indicator shows the result; the unchanging litmus marks a neutral solution.")]),

 ("AB","The acid present in the human stomach that helps digest food is:",
   "hydrochloric acid",
   C("The stomach makes hydrochloric acid, which helps break down food and kill germs.")+
   steps("Glands in the stomach release acid","It is hydrochloric acid","It digests food and destroys microbes.")+
   U("Too much of this acid causes acidity, which antacids relieve."),
   [("citric acid","Citric acid is found in citrus fruit, not made by the stomach."),
    ("sulphuric acid","Sulphuric acid is a lab acid; the stomach uses hydrochloric acid."),
    ("lactic acid","Lactic acid forms in curd and tired muscles, not the digesting stomach.")]),

 ("AB","An antacid tablet relieves acidity in the stomach because it is:",
   "a mild base",
   C("Antacids are mild bases that neutralise the excess stomach acid causing discomfort.")+
   steps("Acidity is too much stomach acid","A base neutralises an acid","The mild base in the antacid cancels the excess.")+
   U("This is why a person with heartburn is given an antacid, not more acid."),
   [("a strong acid","Adding acid would worsen acidity; the antacid is a mild base."),
    ("a neutral salt","A neutral salt cannot cancel the excess acid; a base is needed."),
    ("an indicator","Indicators only reveal acidity; the antacid actually neutralises it.")]),

 ("AB","Which one of these gives the same colour with both turmeric and litmus as a base does?",
   "another basic solution such as washing soda",
   C("All basic solutions behave alike — turning turmeric red and red litmus blue.")+
   steps("Washing soda is a base","Like all bases it turns turmeric red","And turns red litmus blue.")+
   U("Recognising that all bases react the same way lets you classify an unknown solution."),
   [("lemon juice","Lemon juice is acidic and reacts oppositely to a base."),
    ("vinegar","Vinegar is an acid; it will not act like a base on the indicators."),
    ("sugar solution","Sugar solution is neutral and changes neither indicator.")]),

 ("AB","To exactly neutralise an acid you must add a base until the mixture becomes:",
   "neutral",
   C("Neutralisation is complete when just enough base has cancelled the acid, leaving a neutral mix.")+
   steps("Start with an acid","Add base bit by bit","Stop when the mixture is neutral.")+
   U("In a titration, an indicator's colour change shows the exact neutral point."),
   [("more acidic","Adding a base reduces acidity; the goal is a neutral, not more acidic, mix."),
    ("a strong acid","You are removing acidity, so the end point is neutral, not strongly acidic."),
    ("a gas","Neutralisation gives salt and water; the aim is a neutral solution.")]),

 ("AB","Common salt (table salt), formed from an acid and a base, has the chemical name:",
   "sodium chloride",
   C("Table salt is sodium chloride, the salt left when hydrochloric acid reacts with sodium hydroxide.")+
   steps("Acid: hydrochloric acid","Base: sodium hydroxide","Their salt is sodium chloride.")+
   U("The salt in your kitchen is exactly this neutralisation product, sodium chloride."),
   [("calcium carbonate","Calcium carbonate is chalk or marble, not common table salt."),
    ("sodium bicarbonate","Sodium bicarbonate is baking soda, a different salt from table salt."),
    ("magnesium sulphate","Magnesium sulphate is Epsom salt, not common table salt.")]),

 ("AB","If 3 drops of base neutralise 1 drop of a certain acid, then 12 drops of acid need:",
   "36 drops of base",
   C("Scale the ratio up: each acid drop needs 3 base drops, so multiply by the number of acid drops.")+
   steps("1 acid drop needs 3 base drops","12 acid drops needed","12 × 3 = 36 base drops.")+
   U("Chemists scale neutralisation ratios exactly this way when mixing larger batches."),
   [("4 drops of base","4 divides 12 by 3; you must multiply by 3, giving 36 drops."),
    ("15 drops of base","15 adds 12 and 3; the ratio means multiplying, so 36 drops."),
    ("9 drops of base","9 is 3 acid drops' worth; 12 acid drops need 36 base drops.")]),

 ("AB","Phenolphthalein, a common indicator, stays colourless in acid but in a base turns:",
   "pink",
   C("Phenolphthalein is a clear-to-pink indicator: colourless in acid, pink in base.")+
   steps("Add phenolphthalein to an acid — colourless","Add a base slowly","The solution turns pink.")+
   U("In a titration the first lasting pink tells the chemist neutralisation is complete."),
   [("yellow","Phenolphthalein does not go yellow; in a base it turns pink."),
    ("blue","Litmus goes blue in a base, but phenolphthalein turns pink."),
    ("black","Phenolphthalein never turns black; a base makes it pink.")]),

 ("AB","Rain that becomes acidic due to gases from burning fuels is called:",
   "acid rain",
   C("Polluting gases dissolve in rain water to form acids, producing harmful acid rain.")+
   steps("Burning fuel releases acidic gases","They dissolve in rain droplets","The rain falls as acid rain.")+
   U("Acid rain eats into marble buildings — even the Taj Mahal is at risk."),
   [("hard water","Hard water has dissolved minerals; acidic rain from pollution is acid rain."),
    ("distilled water","Distilled water is pure and neutral, not acidic from pollution."),
    ("mineral water","Mineral water is bottled drinking water, not polluted acidic rain.")]),

 ("AB","Why does adding lime to a lake harmed by acid rain help fish survive?",
   "lime is a base that neutralises the acid in the water",
   C("The lake water has turned acidic; lime, a base, neutralises it back toward neutral.")+
   steps("Acid rain makes the lake water acidic","Lime is a base","It neutralises the acid, saving the fish.")+
   U("Authorities really do add lime to acid-damaged lakes to rescue aquatic life."),
   [("lime adds oxygen for the fish","Lime neutralises acid; it does not directly supply oxygen."),
    ("lime makes the water more acidic","Lime is a base, so it reduces acidity, not increases it."),
    ("lime is a food for the fish","Lime is not fish food; it works by neutralising the acid.")]),

 ("AB","Two strips of litmus are dipped in vinegar. Which colour change is correct?",
   "blue litmus turns red, red litmus stays red",
   C("Vinegar is acidic, so it reddens blue litmus and leaves red litmus unchanged.")+
   steps("Vinegar contains acetic acid","Acids turn blue litmus red","Red litmus already red — no change.")+
   U("This double check confirms a liquid is an acid, not a base."),
   [("red litmus turns blue, blue stays blue","That is the result for a base; vinegar is an acid."),
    ("both strips turn green","Litmus does not turn green; an acid reddens blue litmus."),
    ("neither strip changes colour","No change means neutral; vinegar is acidic and reddens blue litmus.")]),

 ("AB","Baking soda used in cooking and as a mild antacid is chemically a:",
   "salt that gives a basic solution",
   C("Baking soda (sodium bicarbonate) is a salt, but its solution is mildly basic.")+
   steps("Baking soda is sodium bicarbonate","Dissolved in water it is mildly basic","That mild base soothes stomach acidity.")+
   U("It both makes cakes rise and works as a gentle antacid because it is basic."),
   [("strong acid","Baking soda is not an acid; its solution is mildly basic."),
    ("strong base like caustic soda","Baking soda is only mildly basic, not a strong corrosive base."),
    ("neutral like table salt","Unlike table salt, baking soda's solution is mildly basic, not neutral.")]),

 ("AB","The bee sting injects an acidic liquid; the soothing agent is therefore one that is:",
   "basic",
   C("Since a bee sting is acidic, a mild base will neutralise it and relieve the pain.")+
   steps("Bee sting is acidic","An acid is neutralised by a base","So a basic remedy soothes it.")+
   U("A paste of baking soda, a base, is the classic remedy for a bee sting."),
   [("acidic","Adding an acid to an acidic sting would not help; a base is needed."),
    ("neutral","A neutral substance cannot cancel the acid; a base is required."),
    ("oily","Oiliness does not neutralise acid; a base does the job.")]),

 ("AB","A wasp sting is alkaline (basic), so the correct soothing agent is a mild:",
   "acid like vinegar",
   C("Because a wasp sting is basic, a mild acid neutralises it — the reverse of a bee sting.")+
   steps("Wasp sting is basic","A base is neutralised by an acid","A mild acid like vinegar soothes it.")+
   U("Bee sting → use baking soda; wasp sting → use vinegar — opposites, neatly."),
   [("base like baking soda","Baking soda is a base and suits an acidic bee sting, not a basic wasp sting."),
    ("neutral like water","Plain water cannot neutralise the basic sting; a mild acid can."),
    ("salt solution","A neutral salt solution will not neutralise the basic wasp sting.")]),

 ("AB","If pure water leaves litmus unchanged but adding a little lemon turns blue litmus red, lemon is:",
   "more acidic than water",
   C("The colour change appears only after lemon is added, showing lemon makes the mix acidic.")+
   steps("Water alone: litmus unchanged (neutral)","Add lemon: blue litmus turns red","So lemon adds acidity.")+
   U("This step-by-step test is how you prove a food is acidic rather than neutral."),
   [("more basic than water","A base turns red litmus blue; here blue went red, so lemon is acidic."),
    ("exactly as neutral as water","If it were neutral, litmus would not change; it did, so lemon is acidic."),
    ("a salt solution","A neutral salt would not redden litmus; the change shows lemon is acidic.")]),
]

# ---------- SIMPLE EQUATIONS (25) — Maths ----------
SE = [
 ("SE","The solution of the equation x + 7 = 12 is:",
   "x = 5",
   C("To undo 'add 7', subtract 7 from both sides so x stands alone.")+
   steps("x + 7 = 12","x = 12 − 7","x = 5.")+
   U("Working out how many more marks you need to reach a target uses exactly this step."),
   [("x = 19","19 adds 12 and 7; to free x you subtract, giving 5."),
    ("x = 7","7 is the number being added, not the value of x, which is 5."),
    ("x = 84","84 is 12 × 7; the equation needs subtraction, so x = 5.")]),

 ("SE","Solving 3x = 21 gives the value of x as:",
   "x = 7",
   C("To undo 'multiply by 3', divide both sides by 3.")+
   steps("3x = 21","x = 21 ÷ 3","x = 7.")+
   U("Sharing 21 sweets equally among 3 friends is the same division."),
   [("x = 18","18 is 21 − 3; here you divide, giving 7."),
    ("x = 63","63 is 21 × 3; to undo multiplication you divide, so x = 7."),
    ("x = 24","24 adds 21 and 3; the equation needs division, giving x = 7.")]),

 ("SE","The value of y in the equation y − 4 = 9 is:",
   "y = 13",
   C("To undo 'subtract 4', add 4 to both sides.")+
   steps("y − 4 = 9","y = 9 + 4","y = 13.")+
   U("If you spent 4 rupees and have 9 left, you started with 13 — same idea."),
   [("y = 5","5 is 9 − 4; to reverse the subtraction you add, giving 13."),
    ("y = 36","36 is 9 × 4; the operation here is addition, so y = 13."),
    ("y = 9","9 is the right side; adding back the 4 gives y = 13.")]),

 ("SE","Solving the equation x/5 = 4 gives:",
   "x = 20",
   C("To undo 'divide by 5', multiply both sides by 5.")+
   steps("x/5 = 4","x = 4 × 5","x = 20.")+
   U("If each of 5 boxes holds the same and one holds 4, the total packed is 20."),
   [("x = 9","9 adds 4 and 5; to reverse division you multiply, giving 20."),
    ("x = 0.8","0.8 is 4 ÷ 5; the equation needs multiplication, so x = 20."),
    ("x = 1","1 is 5 − 4; multiplying 4 by 5 gives the correct x = 20.")]),

 ("SE","Which equation correctly represents 'a number increased by 6 gives 15'?",
   "n + 6 = 15",
   C("'Increased by 6' means add 6 to the number, and 'gives 15' sets the result equal to 15.")+
   steps("Let the number be n","Increased by 6 → n + 6","Result is 15 → n + 6 = 15.")+
   U("Turning a word puzzle into an equation is the first step to solving it."),
   [("n − 6 = 15","'Increased by' means add, not subtract; the equation is n + 6 = 15."),
    ("6n = 15","6n means 6 times the number; 'increased by 6' is n + 6."),
    ("n + 15 = 6","This swaps the numbers; 'increased by 6 gives 15' is n + 6 = 15.")]),

 ("SE","The solution of 2x + 3 = 11 is:",
   "x = 4",
   C("First undo the +3 by subtracting, then undo the ×2 by dividing.")+
   steps("2x + 3 = 11 → 2x = 11 − 3 = 8","x = 8 ÷ 2","x = 4.")+
   U("Two equal-priced pens plus a 3-rupee eraser cost 11 — each pen is 4 rupees."),
   [("x = 7","7 forgets to divide by 2; after 2x = 8 you get x = 4."),
    ("x = 8","8 is the value of 2x; dividing by 2 gives x = 4."),
    ("x = 2.5","2.5 ignores the +3 properly; the correct working gives x = 4.")]),

 ("SE","If 5x = 35, then the value of x + 2 is:",
   "9",
   C("First find x from the equation, then add 2 to it.")+
   steps("5x = 35 → x = 35 ÷ 5 = 7","x + 2 = 7 + 2","= 9.")+
   U("Solving for an unknown first, then using it, is a two-step routine you will reuse often."),
   [("7","7 is x itself; the question asks for x + 2, which is 9."),
    ("37","37 adds 2 to 35 instead of to x; first x = 7, then x + 2 = 9."),
    ("12","12 is 35 ÷ 5 + 5; correctly, x = 7 and x + 2 = 9.")]),

 ("SE","The number which when multiplied by 4 and then 5 is added gives 25 is:",
   "5",
   C("Form the equation 4n + 5 = 25, then solve step by step.")+
   steps("4n + 5 = 25 → 4n = 20","n = 20 ÷ 4","n = 5.")+
   U("Word-to-equation translation like this is the heart of solving real problems."),
   [("10","10 ignores the ×4; with 4n + 5 = 25 the number is 5."),
    ("6","6 gives 4×6 + 5 = 29, not 25; the correct number is 5."),
    ("20","20 is the value of 4n, not n; dividing by 4 gives 5.")]),

 ("SE","Solving 7 = x − 2 gives:",
   "x = 9",
   C("Even when the unknown is on the right, add 2 to both sides to free x.")+
   steps("7 = x − 2","7 + 2 = x","x = 9.")+
   U("An equation reads the same both ways — the unknown can sit on either side."),
   [("x = 5","5 is 7 − 2; to reverse the subtraction you add, giving 9."),
    ("x = 14","14 is 7 × 2; the operation is addition, so x = 9."),
    ("x = 7","7 is the left side; adding the 2 back gives x = 9.")]),

 ("SE","If one-third of a number is 8, the number is:",
   "24",
   C("'One-third of a number is 8' becomes n/3 = 8; multiply by 3 to solve.")+
   steps("n/3 = 8","n = 8 × 3","n = 24.")+
   U("If a third of the class is 8 students, the whole class is 24."),
   [("11","11 adds 8 and 3; to undo dividing by 3 you multiply, giving 24."),
    ("2.67","2.67 divides 8 by 3; the number is 8 × 3 = 24."),
    ("16","16 is 8 × 2; one-third means multiply by 3, giving 24.")]),

 ("SE","The equation for 'Reena is 3 years older than Sita, and Reena is 12' is:",
   "s + 3 = 12",
   C("Let Sita's age be s; 'Reena is 3 years older' means s + 3, set equal to Reena's age 12.")+
   steps("Sita's age = s","Reena = s + 3","Reena is 12 → s + 3 = 12.")+
   U("Setting up age problems as equations is a classic use of this skill."),
   [("s − 3 = 12","Reena is older, so add 3 to Sita's age: s + 3 = 12."),
    ("3s = 12","3s means three times Sita's age; 'older by 3' is s + 3."),
    ("s + 12 = 3","This misplaces the numbers; the correct equation is s + 3 = 12.")]),

 ("SE","The value of x in 4x − 6 = 10 is:",
   "x = 4",
   C("Undo the −6 by adding, then undo the ×4 by dividing.")+
   steps("4x − 6 = 10 → 4x = 16","x = 16 ÷ 4","x = 4.")+
   U("Reversing a chain of operations in the right order is the key to multi-step equations."),
   [("x = 1","1 comes from 10 ÷ 4 without restoring the 6; correctly x = 4."),
    ("x = 16","16 is the value of 4x; dividing by 4 gives x = 4."),
    ("x = 4.75","4.75 mishandles the −6 step; the proper working gives x = 4.")]),

 ("SE","If twice a number decreased by 5 equals 9, the number is:",
   "7",
   C("Write 2n − 5 = 9, then solve in two steps.")+
   steps("2n − 5 = 9 → 2n = 14","n = 14 ÷ 2","n = 7.")+
   U("Translating 'twice ... decreased by ...' into symbols is a frequent exam skill."),
   [("2","2 is 9 ÷ 5 roughly; the correct equation gives n = 7."),
    ("14","14 is the value of 2n, not n; halving gives 7."),
    ("4.5","4.5 ignores adding back the 5; solving fully gives n = 7.")]),

 ("SE","The solution of the equation 6 = 2x is:",
   "x = 3",
   C("Divide both sides by 2 to undo the multiplication, even with the number on the left.")+
   steps("6 = 2x","6 ÷ 2 = x","x = 3.")+
   U("Splitting a total into equal parts is exactly this kind of division."),
   [("x = 12","12 is 6 × 2; to undo ×2 you divide, giving 3."),
    ("x = 4","4 is 6 − 2; the operation is division, so x = 3."),
    ("x = 8","8 adds 6 and 2; dividing 6 by 2 gives x = 3.")]),

 ("SE","If 18 sweets are shared so each of x children gets 3, the equation and answer are:",
   "3x = 18, x = 6",
   C("Each child gets 3, and there are x children, so 3x equals the total 18.")+
   steps("Total = 3 × number of children","3x = 18","x = 18 ÷ 3 = 6.")+
   U("Word problems about equal sharing turn straight into equations like this."),
   [("x + 3 = 18, x = 15","Each child gets 3 each (multiply), so it is 3x = 18, giving x = 6."),
    ("3x = 18, x = 9","Dividing 18 by 3 gives 6, not 9."),
    ("18x = 3, x = 6","The total 18 equals 3x, not 18x; the setup is 3x = 18.")]),

 ("SE","A leaf makes x units of food; if 2 leaves together make 16 units, then x equals:",
   "8 units",
   C("Two equal leaves give 2x, set equal to the total 16, then solve.")+
   steps("2x = 16","x = 16 ÷ 2","x = 8 units.")+
   U("This blends a plant-food idea with equation-solving — the per-leaf output is the unknown."),
   [("14 units","14 is 16 − 2; the equation 2x = 16 gives x = 8."),
    ("32 units","32 is 16 × 2; you divide to undo the ×2, giving 8."),
    ("4 units","4 is 16 ÷ 4; two leaves means divide by 2, so x = 8.")]),

 ("SE","If 3 drops of base neutralise 1 drop of acid and 5x drops of base are used for 5 acid drops, then x is:",
   "x = 3",
   C("Five acid drops need 5 × 3 = 15 base drops, so 5x = 15 and x = 3.")+
   steps("5 acid drops need 5 × 3 = 15 base drops","5x = 15","x = 15 ÷ 5 = 3.")+
   U("This fuses the acid-base ratio with solving a simple equation for x."),
   [("x = 15","15 is the total base drops (5x); dividing by 5 gives x = 3."),
    ("x = 5","5 is the number of acid drops, not x; solving gives x = 3."),
    ("x = 1","1 is the acid-drop count per group; the equation gives x = 3.")]),

 ("SE","The value of m in m/2 + 1 = 5 is:",
   "m = 8",
   C("Subtract 1 first, then multiply by 2 to undo the divide.")+
   steps("m/2 + 1 = 5 → m/2 = 4","m = 4 × 2","m = 8.")+
   U("Order matters — peel off the +1 before reversing the division."),
   [("m = 12","12 multiplies 5 by 2 without removing the +1 first; correctly m = 8."),
    ("m = 4","4 is the value of m/2; multiplying by 2 gives m = 8."),
    ("m = 10","10 is 5 × 2; first subtract 1, then double, to get m = 8.")]),

 ("SE","If 5 is added to twice a number the result is 17. The number is:",
   "6",
   C("Form 2n + 5 = 17 and solve step by step.")+
   steps("2n + 5 = 17 → 2n = 12","n = 12 ÷ 2","n = 6.")+
   U("Reading a sentence carefully into an equation is half the battle in word problems."),
   [("11","11 forgets to halve; after 2n = 12 the number is 6."),
    ("12","12 is the value of 2n, not n; halving gives 6."),
    ("8.5","8.5 is 17 ÷ 2 alone; removing the 5 first gives n = 6.")]),

 ("SE","Solving the equation 9 − x = 4 gives:",
   "x = 5",
   C("Bring x and the numbers together: 9 − 4 leaves the value of x.")+
   steps("9 − x = 4","9 − 4 = x","x = 5.")+
   U("Equations with the unknown subtracted are common in 'how much is left' puzzles."),
   [("x = 13","13 adds 9 and 4; here you subtract, giving x = 5."),
    ("x = −5","−5 keeps the wrong sign; rearranging gives x = 5."),
    ("x = 36","36 is 9 × 4; the correct value is x = 5.")]),

 ("SE","The perimeter of a square is 4s. If a square garden's perimeter is 28 m, its side s is:",
   "7 m",
   C("Set 4s = 28 (perimeter rule) and divide by 4 to find the side.")+
   steps("Perimeter = 4s = 28","s = 28 ÷ 4","s = 7 m.")+
   U("Builders find a side length from a known boundary length exactly this way."),
   [("24 m","24 is 28 − 4; the perimeter rule needs division, giving 7 m."),
    ("14 m","14 is 28 ÷ 2; a square has 4 sides, so s = 7 m."),
    ("112 m","112 is 28 × 4; to undo ×4 you divide, so s = 7 m.")]),

 ("SE","Half of a number, added to 6, gives 10. The number is:",
   "8",
   C("Write n/2 + 6 = 10, remove the 6, then double.")+
   steps("n/2 + 6 = 10 → n/2 = 4","n = 4 × 2","n = 8.")+
   U("'Half of a number plus something' is a phrasing you must turn into n/2 quickly."),
   [("32","32 doubles 16; you must first subtract 6, giving n = 8."),
    ("4","4 is the value of n/2; doubling gives n = 8."),
    ("20","20 is 10 × 2 without removing the 6; correctly n = 8.")]),

 ("SE","If x + x + x = 18, then x equals:",
   "6",
   C("x added three times is 3x, so 3x = 18 and x = 6.")+
   steps("x + x + x = 3x = 18","x = 18 ÷ 3","x = 6.")+
   U("Recognising repeated addition as multiplication speeds up solving equations."),
   [("9","9 halves 18; three equal x's mean dividing by 3, giving 6."),
    ("3","3 is the number of x's, not the value; x = 6."),
    ("54","54 is 18 × 3; to undo 3× you divide, so x = 6.")]),

 ("SE","Check: is x = 4 a solution of 5x − 3 = 17?",
   "Yes, because 5×4 − 3 = 17",
   C("To check a solution, put the value into the equation and see if both sides match.")+
   steps("Left side = 5 × 4 − 3","= 20 − 3 = 17","Right side = 17, so they match — yes.")+
   U("Substituting back is how you confirm you solved an equation correctly."),
   [("No, because 5×4 − 3 = 20","5 × 4 is 20, but minus 3 makes 17; the check passes."),
    ("No, because x must be 3","Testing x = 4 gives 17, matching the equation, so it is a solution."),
    ("Cannot be checked without a graph","You simply substitute the value; 5×4 − 3 = 17 confirms it.")]),

 ("SE","When 4 is subtracted from three times a number, the result is 11. The number is:",
   "5",
   C("Translate to 3n − 4 = 11, then undo the steps in reverse order.")+
   steps("3n − 4 = 11 → 3n = 15","n = 15 ÷ 3","n = 5.")+
   U("Pulling 'three times a number minus 4' out of a sentence is a core exam skill."),
   [("9","9 forgets to divide by 3; after 3n = 15 the number is 5."),
    ("15","15 is the value of 3n, not n; dividing by 3 gives 5."),
    ("2.33","2.33 ignores adding the 4 back; the proper working gives n = 5.")]),
]

# ---------- RATIONAL NUMBERS (25) — Maths ----------
RN = [
 ("RN","Which of the following is a rational number?",
   "−3/4",
   C("A rational number can be written as a fraction p/q where p and q are integers and q is not zero.")+
   steps("−3/4 has integer top and bottom","The bottom 4 is not zero","So it fits the form p/q — it is rational.")+
   U("Most numbers you meet daily — like ₹3/4 of a metre — are rational."),
   [("a number that cannot be written as p/q","By definition such a number is NOT rational."),
    ("only positive whole numbers","Rational numbers include negatives and fractions too, like −3/4."),
    ("any number with a square root sign","Many square roots are irrational; −3/4 is a clear rational number.")]),

 ("RN","The standard (simplest) form of the rational number 12/18 is:",
   "2/3",
   C("Divide the top and bottom by their greatest common factor to reach lowest terms.")+
   steps("GCF of 12 and 18 is 6","12 ÷ 6 = 2, 18 ÷ 6 = 3","12/18 = 2/3.")+
   U("Recipes are scaled by reducing fractions to their simplest form like this."),
   [("6/9","6/9 still shares a factor of 3; fully reduced it is 2/3."),
    ("4/6","4/6 can be reduced again by 2 to 2/3."),
    ("12/18","12/18 is the original, not the simplest form, which is 2/3.")]),

 ("RN","The sum 1/4 + 2/4 equals:",
   "3/4",
   C("With equal denominators, add the numerators and keep the denominator.")+
   steps("Denominators are both 4","Add tops: 1 + 2 = 3","Sum = 3/4.")+
   U("Adding quarter-litre amounts of water uses this same fraction addition."),
   [("3/8","3/8 wrongly adds the denominators too; keep 4, giving 3/4."),
    ("2/4","2/4 ignores the 1/4; the correct sum is 3/4."),
    ("1/2","1/2 is 2/4, missing the extra 1/4; the sum is 3/4.")]),

 ("RN","On the number line, the rational number −1/2 lies:",
   "halfway between 0 and −1",
   C("Negative rationals sit left of zero; −1/2 is exactly midway to −1.")+
   steps("Mark 0 and −1 on the line","Halve the gap between them","That midpoint is −1/2.")+
   U("A temperature of −0.5°C sits halfway between 0 and −1 on a thermometer scale."),
   [("halfway between 0 and 1","That midpoint is +1/2; −1/2 is on the negative side."),
    ("exactly at 1","−1/2 is a small negative number, far from 1."),
    ("to the right of 0","Negative numbers lie to the LEFT of 0, not the right.")]),

 ("RN","Which rational number is greater: 3/5 or 2/5?",
   "3/5",
   C("With the same denominator, the fraction with the larger numerator is greater.")+
   steps("Both have denominator 5","Compare tops: 3 > 2","So 3/5 > 2/5.")+
   U("Comparing 3/5 of a pizza with 2/5 tells you which slice is bigger."),
   [("2/5","2/5 has the smaller numerator, so it is the smaller fraction."),
    ("they are equal","Different numerators over the same 5 are not equal; 3/5 is bigger."),
    ("cannot be compared","Same-denominator fractions compare easily; 3/5 is greater.")]),

 ("RN","The additive inverse (opposite) of the rational number 5/7 is:",
   "−5/7",
   C("The additive inverse is the number that adds to it to give zero — just flip the sign.")+
   steps("We need 5/7 + ? = 0","The opposite sign works","So the inverse is −5/7.")+
   U("Owing ₹5/7 cancels having ₹5/7 — they sum to zero."),
   [("7/5","7/5 is the reciprocal, not the additive inverse, which is −5/7."),
    ("5/7","5/7 added to itself gives 10/7, not 0; the inverse is −5/7."),
    ("0","0 is the result of adding the inverse, not the inverse itself, which is −5/7.")]),

 ("RN","The product 2/3 × 3/4 in simplest form is:",
   "1/2",
   C("Multiply numerators together and denominators together, then simplify.")+
   steps("Tops: 2 × 3 = 6; bottoms: 3 × 4 = 12","6/12","Simplifies to 1/2.")+
   U("Finding two-thirds of three-quarters of something uses exactly this multiplication."),
   [("5/7","5/7 adds the numbers instead of multiplying; the product is 1/2."),
    ("6/12","6/12 is correct before simplifying; in lowest terms it is 1/2."),
    ("6/7","6/7 mixes the operations; multiplying gives 6/12 = 1/2.")]),

 ("RN","Between which two integers does the rational number 7/2 lie?",
   "3 and 4",
   C("Divide to see where the fraction falls between whole numbers.")+
   steps("7 ÷ 2 = 3.5","3.5 is more than 3 but less than 4","So 7/2 lies between 3 and 4.")+
   U("Knowing 3.5 km is between the 3 and 4 km posts uses this idea."),
   [("2 and 3","7/2 is 3.5, which is past 3, so it lies between 3 and 4."),
    ("4 and 5","3.5 is below 4, so it sits between 3 and 4, not 4 and 5."),
    ("7 and 8","7/2 equals 3.5, nowhere near 7 and 8.")]),

 ("RN","The rational number 0/9 is equal to:",
   "0",
   C("Zero divided by any non-zero number is always zero.")+
   steps("0/9 means 0 shared into 9 parts","Each part is 0","So 0/9 = 0.")+
   U("Sharing nothing among friends still leaves everyone with nothing."),
   [("9","9 is the denominator; zero divided by 9 is 0, not 9."),
    ("1","Only a number divided by itself is 1; 0 over 9 is 0."),
    ("undefined","Dividing BY zero is undefined; 0 divided by 9 is simply 0.")]),

 ("RN","Which sign makes the statement true: −2/3 ___ −1/3 ?",
   "<  (less than)",
   C("For negatives, the number further from zero (more negative) is the smaller one.")+
   steps("Both are negative thirds","−2/3 is further left than −1/3","So −2/3 < −1/3.")+
   U("A debt of ₹2/3 is 'less' (worse) than a debt of ₹1/3 on the number line."),
   [(">  (greater than)","−2/3 is more negative, so it is less than −1/3, not greater."),
    ("=  (equal)","They have different numerators, so they are not equal."),
    ("cannot be decided","Negative fractions can be ordered; −2/3 < −1/3.")]),

 ("RN","The reciprocal (multiplicative inverse) of 4/9 is:",
   "9/4",
   C("The reciprocal is found by swapping the numerator and denominator.")+
   steps("Flip 4/9 upside down","Top and bottom swap","Reciprocal = 9/4.")+
   U("Dividing by 4/9 is the same as multiplying by 9/4 — the reciprocal."),
   [("−4/9","That is the additive inverse; the reciprocal flips it to 9/4."),
    ("4/9","A number times its reciprocal is 1; 4/9 × 4/9 is not 1, but 4/9 × 9/4 is."),
    ("1/4","1/4 only flips part of it; the full reciprocal of 4/9 is 9/4.")]),

 ("RN","The difference 5/6 − 1/6 equals:",
   "4/6 = 2/3",
   C("Same denominators: subtract the numerators and keep the denominator, then simplify.")+
   steps("Tops: 5 − 1 = 4","4/6","Simplifies to 2/3.")+
   U("Eating 1/6 of a cake that was 5/6 full leaves 2/3 of the original behind."),
   [("4/0","Subtract numerators, not denominators; the answer keeps the 6."),
    ("6/6","6/6 adds wrongly; 5 − 1 over 6 is 4/6 = 2/3."),
    ("1","1 would be 6/6; the difference is 4/6 = 2/3.")]),

 ("RN","How many rational numbers lie between 1/4 and 1/2?",
   "infinitely many",
   C("Between any two different rational numbers there are unlimited rationals.")+
   steps("Pick the midpoint of 1/4 and 1/2","You can keep finding midpoints forever","So there are infinitely many.")+
   U("This 'always room for one more' idea is a key property of rational numbers."),
   [("exactly one","You can always squeeze another fraction in, so there are infinitely many."),
    ("none","Plenty of fractions, like 3/8, fit between them — infinitely many in fact."),
    ("exactly three","No fixed small count works; there are infinitely many.")]),

 ("RN","Expressed as a rational number, the decimal 0.5 is:",
   "1/2",
   C("0.5 means five tenths, which simplifies to one half.")+
   steps("0.5 = 5/10","Divide top and bottom by 5","= 1/2.")+
   U("Half a litre on a bottle, shown as 0.5 L, is the fraction 1/2."),
   [("5/100","5/100 is 0.05, ten times too small; 0.5 is 1/2."),
    ("1/5","1/5 is 0.2, not 0.5; the correct fraction is 1/2."),
    ("5/1","5/1 is 5, far larger than 0.5, which equals 1/2.")]),

 ("RN","The value of (−3/5) + (3/5) is:",
   "0",
   C("A rational number plus its additive inverse always gives zero.")+
   steps("−3/5 and 3/5 are opposites","Opposites cancel on the number line","Their sum is 0.")+
   U("Going 3/5 of a step back and then 3/5 forward leaves you where you started."),
   [("6/5","Adding opposites cancels to 0, not 6/5."),
    ("−6/5","The signs are opposite, so they cancel to 0, not −6/5."),
    ("3/5","Only one term is left out here; the two opposites sum to 0.")]),

 ("RN","Which rational number is equivalent to 3/4?",
   "9/12",
   C("Equivalent fractions are made by multiplying top and bottom by the same number.")+
   steps("Multiply 3/4 by 3/3","3 × 3 = 9, 4 × 3 = 12","So 3/4 = 9/12.")+
   U("Re-scaling a recipe to a bigger pot uses equivalent fractions like this."),
   [("4/3","4/3 is the reciprocal, a different value from 3/4."),
    ("6/12","6/12 equals 1/2, not 3/4; the match is 9/12."),
    ("3/12","3/12 equals 1/4, not 3/4; the equivalent is 9/12.")]),

 ("RN","A water tank is 2/3 full; if 1/6 more is added, the tank is now:",
   "5/6 full",
   C("Make the denominators equal, then add the numerators.")+
   steps("2/3 = 4/6","4/6 + 1/6 = 5/6","Tank is 5/6 full.")+
   U("Topping up a partly filled tank by a fraction uses fraction addition."),
   [("3/9 full","3/9 wrongly adds across; with a common denominator it is 5/6."),
    ("1/2 full","1/2 is less than 2/3, but we ADDED water; the answer is 5/6."),
    ("full","2/3 + 1/6 is 5/6, not a complete tank.")]),

 ("RN","The quotient (2/5) ÷ (4/5) in simplest form is:",
   "1/2",
   C("Divide by a fraction by multiplying by its reciprocal, then simplify.")+
   steps("(2/5) ÷ (4/5) = 2/5 × 5/4","= 10/20","= 1/2.")+
   U("Splitting 2/5 of a load into 4/5-sized scoops gives half a scoop — same maths."),
   [("8/25","8/25 multiplies instead of using the reciprocal; the answer is 1/2."),
    ("2/4","2/4 reduces to 1/2 — but the cleanest simplest form is 1/2 itself."),
    ("5/2","5/2 flips the wrong fraction; dividing gives 1/2.")]),

 ("RN","The rational number 1 lies between which pair using halves?",
   "1/2 and 3/2",
   C("1 can be written as 2/2, which sits between 1/2 and 3/2.")+
   steps("Write 1 as 2/2","1/2 < 2/2 < 3/2","So 1 lies between 1/2 and 3/2.")+
   U("Seeing whole numbers as fractions helps place them among other fractions."),
   [("3/2 and 5/2","1 equals 2/2, which is below 3/2, so it is between 1/2 and 3/2."),
    ("0 and 1/2","1 is bigger than 1/2, so it cannot lie between 0 and 1/2."),
    ("2/2 and 4/2","2/2 IS 1, so 1 does not lie strictly between 2/2 and 4/2.")]),

 ("RN","If a leaf covers 3/8 of a sheet and another covers 1/8, together they cover:",
   "1/2 of the sheet",
   C("Add the like fractions, then simplify to compare with the whole.")+
   steps("3/8 + 1/8 = 4/8","Simplify 4/8","= 1/2.")+
   U("Estimating how much of a page two leaf prints cover blends biology with fractions."),
   [("4/16","Keep the denominator 8 when adding; 4/8 simplifies to 1/2."),
    ("3/8","3/8 ignores the second leaf; together they cover 1/2."),
    ("the whole sheet","3/8 + 1/8 is only 1/2, not the entire sheet.")]),

 ("RN","Which list is arranged from smallest to largest: −1/2, 0, 1/2 ?",
   "−1/2, 0, 1/2",
   C("On the number line, values increase from left (negative) to right (positive).")+
   steps("Negatives are smallest","Zero is in the middle","Positives are largest.")+
   U("Sorting temperatures from coldest to hottest follows this same order."),
   [("1/2, 0, −1/2","This is largest to smallest; smallest first is −1/2, 0, 1/2."),
    ("0, −1/2, 1/2","−1/2 is below 0, so it must come first."),
    ("1/2, −1/2, 0","Order by value: −1/2, then 0, then 1/2.")]),

 ("RN","The product of a rational number and its reciprocal is always:",
   "1",
   C("By definition, a number times its reciprocal multiplies to one.")+
   steps("Take any p/q (not zero)","Multiply by its reciprocal q/p","(p×q)/(q×p) = 1.")+
   U("This is why dividing by a number undoes multiplying by it."),
   [("0","Zero is the result of adding a number to its negative, not its reciprocal."),
    ("the number itself","Multiplying by 1 gives the number; by its reciprocal gives 1."),
    ("its negative","The negative comes from the additive inverse, not the reciprocal.")]),

 ("RN","Adding 1/3 to a number gives 5/6. The number (as a rational) is:",
   "1/2",
   C("Subtract 1/3 from 5/6, using a common denominator, to find the number.")+
   steps("Number = 5/6 − 1/3","1/3 = 2/6, so 5/6 − 2/6 = 3/6","= 1/2.")+
   U("Working backward from a total to a missing part is everyday fraction reasoning."),
   [("7/6","7/6 adds instead of subtracting; the number is 5/6 − 1/3 = 1/2."),
    ("4/3","4/3 mishandles the denominators; correctly it is 1/2."),
    ("1/3","1/3 is what was added, not the original number, which is 1/2.")]),

 ("RN","Acid is mixed so it is 1/4 of a bottle and water is 1/2; the empty space is:",
   "1/4 of the bottle",
   C("Add the filled fractions, then subtract from the whole bottle (1).")+
   steps("Filled = 1/4 + 1/2 = 1/4 + 2/4 = 3/4","Empty = 1 − 3/4","= 1/4.")+
   U("Working out leftover space in a part-filled bottle blends chemistry with fractions."),
   [("1/2 of the bottle","1/2 is the water alone; the empty space after both is 1/4."),
    ("3/4 of the bottle","3/4 is the filled part; the empty part is 1 − 3/4 = 1/4."),
    ("nothing — it is full","1/4 + 1/2 is only 3/4, so 1/4 of the bottle stays empty.")]),

 ("RN","The rational number lying exactly midway between 1/2 and 3/2 is:",
   "1",
   C("The midpoint of two rationals is their average — add them and divide by two.")+
   steps("Add: 1/2 + 3/2 = 4/2 = 2","Divide by 2: 2 ÷ 2","= 1.")+
   U("Finding the middle reading between two marks on a scale uses this averaging."),
   [("2","2 is the SUM of the two; the midpoint is the sum halved, giving 1."),
    ("1/2","1/2 is the lower end, not the middle; the midpoint is 1."),
    ("3/4","3/4 is the midpoint of 1/2 and 1, not of 1/2 and 3/2, which is 1.")]),
]

assert len(NP) == 25 and len(AB) == 25 and len(SE) == 25 and len(RN) == 25

# Interleave so no two consecutive questions share a chapter; Science/Maths alternate.
items = []
for i in range(25):
    items += [NP[i], SE[i], AB[i], RN[i]]
assert len(items) == 100

for a, b in zip(items, items[1:]):
    assert a[0] != b[0], (a[1], b[1])

if __name__ == "__main__":
    here = os.path.dirname(os.path.abspath(__file__))
    papers_dir = os.path.abspath(os.path.join(
        here, "..", "..", "desktopAhaan", "Resources", "BossChallengePapers"))
    os.chdir(papers_dir)

    keydist = build_paper(PNUM, TITLE, SHORT, LABELS, items, seed=14127,
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
    split = "/".join(str(counts[c]) for c in ("NP", "AB", "SE", "RN"))
    with open("PAPERS_MANIFEST.md", "a", encoding="utf-8") as fh:
        fh.write(f"| {PNUM} | 2026-06-18 | {TITLE} | {split} | ✓ |\n")

    print("Files:", sorted(v for v in moves.values()))
    print("Answer key spread A/B/C/D =", dict(keydist))
