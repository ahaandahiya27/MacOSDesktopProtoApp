# -*- coding: utf-8 -*-
# Boss Challenge Paper 44 — Acids, Bases & Salts · Transportation in Animals
# & Plants · Rational Numbers · Lines & Angles
# Content-only. Uses the dependency-free examfactory engine.
# Difficulty ramp: leans hard into FUSION. Drops of acid neutralised by a base
# become INTEGER/RATIONAL counting; a temperature rise on neutralisation becomes
# a signed-number sum; a heartbeat rate becomes a rational quantity; the angle a
# leaning xylem stem makes with the ground becomes a LINES-&-ANGLES problem; a
# pulse measured over a fraction of a minute becomes a rational-number scale-up.
# The child meets a Science situation and reaches for a Maths skill. Class-7
# scope, simple wording, hard thinking.
# Produces, under Resources/BossChallengePapers/:
#   Paper_44_<SHORT>_QuestionPaper.html  (pure HTML — questions + options)
#   Paper_44_<SHORT>_QuestionPaper.pdf
#   Paper_44_<SHORT>_Questions.md
#   Paper_44_<SHORT>_Solutions.html
import os, sys, shutil, json, re
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from examfactory import build_paper, C, steps, U

PNUM  = "44"
SHORT = "AcidsBasesSalts_Transportation_RationalNumbers_LinesAngles"
TITLE = ("Acids, Bases & Salts · Transportation in Animals & Plants · "
         "Rational Numbers · Lines & Angles")
LABELS = {
    "AB": "Acids, Bases & Salts",
    "TP": "Transportation in Animals & Plants",
    "RN": "Rational Numbers",
    "LA": "Lines & Angles",
}

# ---------- ACIDS, BASES & SALTS (25) — Science (some fused) ----------
AB = [
 ("AB","A drop of lemon juice tastes sour and reddens moist blue litmus, marking the class of substances we call:",
   "acids",
   C("Acids are sour-tasting substances that turn blue litmus red; lemon and vinegar are everyday acids.")+
   steps("Note the sour taste","check the litmus: blue turns red","both signs point to an acid.")+
   U("Lemon juice tastes sour and reddens blue litmus — a familiar acid in the kitchen."),
   [("bases","Bases taste bitter and turn red litmus blue, the opposite of what is described here."),
    ("salts","A salt is usually neutral to litmus and is made when an acid and base react."),
    ("indicators","An indicator only shows whether something is acidic or basic; it is not the sour substance itself.")]),

 ("AB","A substance that feels soapy or slippery, tastes bitter, and turns red litmus blue is a:",
   "base",
   C("Bases feel slippery, taste bitter, and turn red litmus paper blue; soap and baking soda are bases.")+
   steps("Feel the slippery touch and note the bitter taste","test litmus: red turns blue","these together name a base.")+
   U("Soap feels slippery on wet hands and is mildly basic."),
   [("acid","An acid is sour and turns blue litmus red — the reverse of the slippery, bitter clue given."),
    ("salt","A salt is generally neutral and does not turn red litmus blue."),
    ("neutral substance","A neutral substance leaves litmus unchanged, but here red litmus turned blue.")]),

 ("AB","Mixing matched amounts of acid with base cancels both natures, and besides a salt the other product made is:",
   "water",
   C("A neutralisation reaction makes a salt and water; the acidic and basic natures cancel out.")+
   steps("Acid supplies H⁺-type particles, base supplies the opposite","they combine and neutralise","leaving a salt plus water.")+
   U("Taking an antacid neutralises stomach acid, forming a harmless salt and water."),
   [("hydrogen gas","Hydrogen comes from acid-on-metal reactions, not from acid neutralising a base."),
    ("oxygen gas","Neutralisation does not release oxygen; it produces a salt and water."),
    ("more acid","The whole point of neutralisation is that the acid is used up, not made more.")]),

 ("AB","The chemical that doctors call an antacid works on an upset stomach because it is a mild:",
   "base that neutralises extra stomach acid",
   C("The stomach makes acid; an antacid is a base that neutralises the excess and eases the burning.")+
   steps("Excess hydrochloric acid causes the burning feeling","an antacid (a base) is swallowed","it neutralises the extra acid, giving relief.")+
   U("A chewable antacid tablet settles acidity after a heavy, oily meal."),
   [("acid that adds to stomach acid","Adding more acid would worsen the burning, not relieve it."),
    ("salt that has no effect","If it did nothing it could not relieve acidity; an antacid actively neutralises."),
    ("gas that escapes the body","An antacid is not a gas; it is a base that reacts with the stomach acid.")]),

 ("AB","Turmeric paste is yellow but turns reddish-brown when soap solution is dropped on it. This tells us soap solution is:",
   "basic",
   C("Turmeric is a natural indicator; it stays yellow in acid but turns red-brown in a base like soap.")+
   steps("Turmeric stays yellow in acidic and neutral liquids","it turns reddish-brown in a base","soap turned it red-brown, so soap is basic.")+
   U("A turmeric stain on cloth turns red where alkaline soap is rubbed in, then yellow again when washed with acid."),
   [("acidic","Turmeric stays yellow in acids; the red-brown colour shows a base, not an acid."),
    ("neutral","A neutral liquid leaves turmeric yellow, but here it changed to red-brown."),
    ("a salt solution","A plain salt solution is neutral and would not turn turmeric red-brown.")]),

 ("AB","A gardener finds the soil is too acidic for crops. To raise it toward neutral, the best material to add is:",
   "lime, which is basic",
   C("Acidic soil is treated by adding a base such as lime, which neutralises the extra acid.")+
   steps("Acidic soil harms many crops","a base neutralises acid","adding lime (basic) brings the soil toward neutral.")+
   U("Farmers spread lime over sour, acidic fields before sowing to balance the soil."),
   [("vinegar, which is acidic","Adding acid to already-acidic soil makes it worse, not better."),
    ("lemon juice","Lemon juice is an acid, so it would lower the soil further from neutral."),
    ("more fertiliser only","Fertiliser feeds plants but does not neutralise the soil's acidity.")]),

 ("AB","A factory must neutralise its acidic waste with 6 litres of base for every 1 litre of acid. To treat 4 litres of acid it needs:",
   "24 litres of base",
   C("The ratio is 6 litres of base per litre of acid, so multiply: a fused dose-and-multiply problem.")+
   steps("Need 6 L base for each 1 L acid","there are 4 L of acid","6 × 4 = 24 L of base.")+
   U("Treatment plants dose alkali in fixed proportion to the acid in factory wastewater before release."),
   [("10 litres of base","That adds 6 and 4 instead of multiplying 6 by 4; the rule is 6 per litre."),
    ("6 litres of base","6 L treats only 1 L of acid; for 4 L you need four times as much."),
    ("2 litres of base","Far too little — even 1 L of acid needs 6 L of base, not a fraction of it.")]),

 ("AB","An ant's sting hurts because it injects an acid. The best simple remedy rubbed on the skin is:",
   "a mild base like baking soda",
   C("An ant sting is acidic, so a mild base such as baking soda neutralises it and eases the pain.")+
   steps("The sting injects formic acid","a base neutralises an acid","baking soda paste neutralises the sting and soothes it.")+
   U("Dabbing baking-soda paste on an ant or bee sting reduces the burning."),
   [("more acid such as vinegar","Vinegar is acidic and would not neutralise the acidic sting."),
    ("plain table salt","Salt is neutral and does not neutralise the acid of the sting."),
    ("lemon juice","Lemon juice is an acid, so it cannot cancel the acidic sting.")]),

 ("AB","Phenolphthalein is colourless in acid but turns bright pink in a base. A liquid that turns it pink must be:",
   "basic",
   C("Phenolphthalein is an indicator: colourless in acidic or neutral liquids, pink in a base.")+
   steps("Stays colourless in acid and neutral liquids","turns pink only in a base","the pink colour means the liquid is basic.")+
   U("In a school titration, the flask suddenly turns pink when enough base has been added."),
   [("acidic","Phenolphthalein stays colourless in acid; pink signals a base."),
    ("neutral","A neutral liquid leaves phenolphthalein colourless, not pink."),
    ("a strong acid","Stronger acid keeps it firmly colourless; pink is impossible in acid.")]),

 ("AB","It takes 5 drops of base to neutralise 1 mL of an acid. A beaker holds 7 mL of the same acid. Drops of base needed:",
   "35 drops",
   C("Each mL needs 5 drops, so 7 mL needs 5 × 7 — a fused neutralisation-and-multiply count.")+
   steps("5 drops neutralise 1 mL","there are 7 mL of acid","5 × 7 = 35 drops.")+
   U("In a lab, you count indicator drops in steady proportion to the acid volume you are neutralising."),
   [("12 drops","That adds 5 and 7; the rule multiplies 5 drops by each of the 7 mL."),
    ("5 drops","5 drops finish only 1 mL; the beaker has seven times that much acid."),
    ("70 drops","That doubles the answer — only 5 drops, not 10, are needed per mL.")]),

 ("AB","Litmus is obtained from lichens and is the most common laboratory:",
   "indicator",
   C("Litmus is a natural indicator from lichens that shows whether a substance is acidic or basic.")+
   steps("Lichens give a dye called litmus","it changes colour with acids and bases","so litmus is used as an indicator.")+
   U("Red and blue litmus papers are the quickest classroom test for acids and bases."),
   [("acid","Litmus is not itself an acid; it is a dye that tests for acids and bases."),
    ("base","Litmus is not a base either; it merely reveals whether something is basic."),
    ("salt","A salt is a product of neutralisation, not a colour-changing indicator.")]),

 ("AB","Which of these is the acid naturally present in lemon and orange juice, giving them their sour taste?",
   "citric acid",
   C("Citrus fruits contain citric acid, which gives lemons and oranges their sharp sour taste.")+
   steps("Lemons and oranges taste sour","the sourness comes from an acid","that acid is citric acid.")+
   U("The tang of fresh lemonade is the citric acid in the juice."),
   [("acetic acid","Acetic acid is the acid in vinegar, not the main acid of citrus fruit."),
    ("hydrochloric acid","Hydrochloric acid is found in the stomach, not in lemons."),
    ("lactic acid","Lactic acid is found in sour milk and curd, not in citrus juice.")]),

 ("AB","Vinegar used in cooking owes its sour taste to a dissolved acid called:",
   "acetic acid",
   C("Vinegar is a dilute solution of acetic acid, which makes it sour and useful in cooking.")+
   steps("Vinegar tastes sharp and sour","that comes from an acid","the acid in vinegar is acetic acid.")+
   U("A splash of vinegar in a salad dressing adds the tang of acetic acid."),
   [("citric acid","Citric acid is in citrus fruits; vinegar's acid is acetic acid."),
    ("tartaric acid","Tartaric acid is found in tamarind and grapes, not in ordinary vinegar."),
    ("sulphuric acid","Sulphuric acid is a strong lab acid and is never used to flavour food.")]),

 ("AB","A solution leaves both red and blue litmus paper unchanged. The solution is therefore:",
   "neutral",
   C("A neutral solution is neither acidic nor basic, so it changes neither colour of litmus.")+
   steps("Acids redden blue litmus, bases blue red litmus","here neither paper changes","so the solution is neutral.")+
   U("Pure water and plain salt solution are neutral and leave litmus unchanged."),
   [("strongly acidic","A strong acid would turn blue litmus firmly red, but nothing changed."),
    ("strongly basic","A strong base would turn red litmus blue, yet both papers stayed the same."),
    ("both acidic and basic","A solution cannot be both at once; unchanged litmus means neutral.")]),

 ("AB","When dilute acid is added to a base, the mixture gets warmer. This shows neutralisation:",
   "releases heat energy",
   C("Neutralisation is an exothermic reaction — it gives out heat, so the beaker warms up.")+
   steps("Acid and base react and neutralise","the reaction gives out energy as heat","so the temperature of the mixture rises.")+
   U("A self-heating chemical hand warmer uses a heat-releasing reaction like this."),
   [("absorbs heat from the room","If it absorbed heat the mixture would cool, but it warmed up."),
    ("produces light, not heat","The beaker grows warm to the touch; the energy released is heat."),
    ("changes no energy at all","A temperature rise proves energy was released, so this cannot be true.")]),

 ("AB","A beaker of acid is at 24 °C. Neutralising it with a base raises the temperature by 7 °C. The new temperature is:",
   "31 °C",
   C("Neutralisation releases heat, so add the rise to the start: a fused signed-number sum.")+
   steps("Start at 24 °C","the reaction adds 7 °C","24 + 7 = 31 °C.")+
   U("A thermometer in the flask climbs as acid and base react and give out heat."),
   [("17 °C","That subtracts 7; neutralisation releases heat, so the temperature goes up."),
    ("24 °C","The temperature does not stay the same — heat is released, raising it."),
    ("28 °C","That adds only 4 °C; the stated rise is 7 °C, giving 31 °C.")]),

 ("AB","China rose petals soaked in warm water give an indicator that turns dark pink in acids and green in:",
   "bases",
   C("China rose extract is a natural indicator: dark pink in acids, green in bases.")+
   steps("Soak china rose petals to get the dye","it turns dark pink with acids","and green with bases.")+
   U("A homemade china-rose indicator can test whether a cleaner is acidic or basic."),
   [("acids","Acids turn china rose dark pink; the green colour signals a base."),
    ("neutral water","Plain water leaves the extract nearly unchanged, not green."),
    ("salt solutions","A neutral salt solution does not turn the extract green; a base does.")]),

 ("AB","Baking soda solution is mildly slippery and turns red litmus blue. Baking soda is therefore a:",
   "base",
   C("Baking soda gives a mildly basic solution, turning red litmus blue and feeling slippery.")+
   steps("Test litmus: red turns blue","note the slippery feel","both clues identify a base.")+
   U("Baking soda is used in antacids and to soothe acidic stings because it is basic."),
   [("strong acid","An acid turns blue litmus red; baking soda does the opposite, so it is a base."),
    ("neutral salt","Although it contains a salt, its solution is basic, not neutral, to litmus."),
    ("an indicator","Baking soda is a substance being tested, not a colour-changing indicator.")]),

 ("AB","Acid rain harms buildings and plants. It forms when gases from burning fuels dissolve in:",
   "rainwater to make it acidic",
   C("Polluting gases dissolve in rain droplets, turning ordinary rain into damaging acid rain.")+
   steps("Burning fuels release gases like sulphur and nitrogen oxides","these dissolve in rain droplets","making the rain acidic.")+
   U("Acid rain slowly eats away at marble statues and stone monuments."),
   [("rainwater to make it basic","The dissolved gases form acids, so the rain becomes acidic, not basic."),
    ("the soil to make it neutral","Acid rain makes soil more acidic; it does not neutralise it."),
    ("clouds to make pure water","The pollution makes rain impure and acidic, not purer.")]),

 ("AB","The acid that the human stomach makes to help digest food is:",
   "hydrochloric acid",
   C("The stomach produces hydrochloric acid, which helps break down food and kill germs.")+
   steps("Glands in the stomach wall make acid","this acid aids digestion","that acid is hydrochloric acid.")+
   U("Heartburn is felt when this stomach acid rises up the food pipe."),
   [("citric acid","Citric acid is in citrus fruit, not made by the stomach."),
    ("acetic acid","Acetic acid is the acid in vinegar, not the stomach's digestive acid."),
    ("carbonic acid","Carbonic acid is in fizzy drinks; the stomach makes hydrochloric acid.")]),

 ("AB","The product formed when an acid neutralises a base, apart from water, is always a:",
   "salt",
   C("Neutralisation always makes a salt plus water; the salt depends on the acid and base used.")+
   steps("Acid + base react","water forms from H⁺ and OH⁺-type parts","the leftover combination is a salt.")+
   U("Common table salt can be made by neutralising an acid with the matching base."),
   [("metal","No metal is produced; neutralisation makes a salt and water."),
    ("gas","Neutralising an acid with a base does not release a gas; it makes a salt and water."),
    ("another acid","The acid is used up in neutralisation; the products are a salt and water.")]),

 ("AB","Soap solution turns red litmus blue. If you then add lemon juice drop by drop, the blue colour will:",
   "fade back toward red as the acid neutralises the base",
   C("Adding an acid neutralises the basic soap, so the litmus shifts back from blue toward red.")+
   steps("Soap is basic and turned litmus blue","lemon juice is acidic","the acid neutralises the base, so litmus moves back toward red.")+
   U("Mixing an acidic and a basic cleaner can cancel both — which is why you should not mix cleaners."),
   [("stay blue forever","Adding acid neutralises the base, so the blue cannot remain unchanged."),
    ("turn green","Litmus has no green stage; it shifts between red and blue."),
    ("turn colourless","Litmus does not go colourless; it moves back toward red as acid is added.")]),

 ("AB","Among water, milk of magnesia, lemon juice and vinegar, the only clearly BASIC one is:",
   "milk of magnesia",
   C("Milk of magnesia is a base (used as an antacid); the others are neutral or acidic.")+
   steps("Lemon juice and vinegar are acids","water is neutral","milk of magnesia is the base of the group.")+
   U("Milk of magnesia is taken to neutralise excess stomach acid."),
   [("lemon juice","Lemon juice is acidic, not basic; it contains citric acid."),
    ("vinegar","Vinegar is acidic because of acetic acid, so it is not the base."),
    ("water","Pure water is neutral, neither acidic nor basic.")]),

 ("AB","Two acidic drinks measure 'sourness' 3 and 5 on a sour-scale, and a base measures −4. Adding the base to the '5' drink moves its reading to:",
   "1",
   C("Treat the base as a negative number on the scale and add: a fused signed-number sum.")+
   steps("The acidic drink reads +5","the base contributes −4","5 + (−4) = 1, closer to neutral (0).")+
   U("Neutralising shifts a strongly acidic reading down toward neutral, just like adding a negative number."),
   [("9","That adds 5 and 4 as if both were positive; the base counts as −4."),
    ("−1","That computes 4 − 5; the sum is 5 + (−4) = 1, not −1."),
    ("0","5 + (−4) lands on 1, not exactly neutral; it would need −5 to reach 0.")]),

 ("AB","Which statement correctly pairs a property with the right type of substance?",
   "Bases feel slippery and turn red litmus blue",
   C("Acids are sour and redden blue litmus; bases are bitter, slippery and blue red litmus.")+
   steps("Recall acid signs: sour, blue→red","recall base signs: bitter/slippery, red→blue","match the property to the correct type.")+
   U("Quick litmus tests sort kitchen liquids into acids and bases by these very rules."),
   [("Acids feel slippery and turn red litmus blue","Slippery and red→blue are properties of bases, not acids."),
    ("Acids are bitter and turn red litmus blue","Acids are sour, not bitter, and they turn blue litmus red."),
    ("Bases are sour and turn blue litmus red","Sour taste and blue→red are acid properties, not base properties.")]),
]

# ---------- TRANSPORTATION IN ANIMALS & PLANTS (25) — Science (some fused) ----------
TP = [
 ("TP","The liquid that carries digested food, oxygen and wastes around the human body is the:",
   "blood",
   C("Blood is the transport fluid of the body, carrying food, oxygen and wastes to and from cells.")+
   steps("Cells need food and oxygen and must lose wastes","a moving fluid carries these around","that fluid is the blood.")+
   U("A blood test checks the very fluid that delivers oxygen and food to every cell."),
   [("saliva","Saliva starts digestion in the mouth; it does not circulate around the body."),
    ("sweat","Sweat leaves the body through the skin; it is not the internal transport fluid."),
    ("bile","Bile helps digest fats in the gut; it is not the body's circulating transport fluid.")]),

 ("TP","Which muscular organ keeps blood moving by pumping it out to every part of the body?",
   "heart",
   C("The heart is a muscular pump that pushes blood through the blood vessels to the whole body.")+
   steps("Blood must be kept moving","a pump provides the push","the heart is that pump.")+
   U("You can feel the heart's pumping as a pulse in your wrist."),
   [("lungs","The lungs add oxygen to blood but do not pump it around the body."),
    ("kidneys","The kidneys filter blood; they do not pump it."),
    ("liver","The liver processes food and cleans blood but is not the pump.")]),

 ("TP","The tubes that carry blood away from the heart to the body are the:",
   "arteries",
   C("Arteries carry blood away from the heart; veins carry it back toward the heart.")+
   steps("Blood leaves the heart under pressure","the vessels taking it out are arteries","veins return it to the heart.")+
   U("A doctor feels a pulse in an artery because blood surges through it with each heartbeat."),
   [("veins","Veins carry blood back toward the heart, not away from it."),
    ("capillaries","Capillaries are tiny exchange vessels in the tissues, not the outgoing main tubes."),
    ("xylem","Xylem is a plant tissue for water transport, not an animal blood vessel.")]),

 ("TP","The tiny thread-like vessels where oxygen and food pass from blood into the cells are the:",
   "capillaries",
   C("Capillaries are extremely thin vessels where blood exchanges materials with the body's cells.")+
   steps("Arteries branch into smaller and smaller vessels","the thinnest are capillaries","here oxygen and food cross into cells.")+
   U("A graze bleeds tiny drops because it has torn many surface capillaries."),
   [("arteries","Arteries are thick, carrying vessels; exchange happens in the thin capillaries."),
    ("veins","Veins collect blood after exchange; the exchange itself is in capillaries."),
    ("the heart","The heart pumps blood; the cell-level exchange happens in capillaries.")]),

 ("TP","In plants, the tissue that carries water and minerals up from the roots is the:",
   "xylem",
   C("Xylem is the plant transport tissue that moves water and minerals upward from the roots.")+
   steps("Roots absorb water and minerals","these must rise to the leaves","the xylem carries them up.")+
   U("A cut flower in coloured water shows the dye rising up the xylem into the petals."),
   [("phloem","Phloem carries food made in the leaves, not water rising from the roots."),
    ("arteries","Arteries are blood vessels in animals; plants use xylem and phloem."),
    ("stomata","Stomata are tiny leaf pores for gas exchange, not water-carrying tissue.")]),

 ("TP","The plant tissue that carries food made in the leaves to the rest of the plant is the:",
   "phloem",
   C("Phloem transports the food (sugars) made by photosynthesis from the leaves to all parts.")+
   steps("Leaves make sugar by photosynthesis","this food must reach roots, stems and fruits","the phloem carries it.")+
   U("A sweet fruit gets its sugar delivered through the phloem from the leaves."),
   [("xylem","Xylem moves water upward; food made in leaves travels in the phloem."),
    ("veins","Veins are animal blood vessels; the plant's food-carrying tissue is the phloem."),
    ("roots","Roots absorb water and anchor the plant; they do not transport leaf-made food.")]),

 ("TP","The loss of water as vapour from the surface of leaves is called:",
   "transpiration",
   C("Transpiration is the evaporation of water from leaf surfaces, mainly through the stomata.")+
   steps("Water reaches the leaves through the xylem","some evaporates from the leaf pores","this water loss is transpiration.")+
   U("A potted plant covered with a clear bag shows water droplets from transpiration."),
   [("respiration","Respiration releases energy from food; it is not the loss of water from leaves."),
    ("photosynthesis","Photosynthesis makes food using light; transpiration is water loss."),
    ("germination","Germination is a seed sprouting; it is unrelated to leaf water loss.")]),

 ("TP","A resting heart beats about 72 times each minute. In a quarter of a minute it beats about:",
   "18 times",
   C("A quarter of 72 is 72 × 1/4 — a fused rate-and-fraction calculation.")+
   steps("72 beats fill one whole minute","a quarter minute is 1/4 of that","72 × 1/4 = 18 beats.")+
   U("Nurses sometimes count beats for 15 seconds and multiply by four to find the per-minute rate."),
   [("36 times","That is half a minute (1/2 × 72), not a quarter."),
    ("9 times","That is an eighth of a minute (72 × 1/8), not a quarter."),
    ("24 times","That is a third of a minute (72 × 1/3), not a quarter.")]),

 ("TP","The rhythmic throb felt in the wrist with each heartbeat is called the:",
   "pulse",
   C("Each heartbeat pushes blood into the arteries, and this throb felt in the wrist is the pulse.")+
   steps("The heart pumps blood with each beat","the surge passes along an artery","felt at the wrist as the pulse.")+
   U("You count your pulse at the wrist to find how fast your heart is beating."),
   [("breath","Breathing is the movement of air in and out; the wrist throb is the pulse."),
    ("reflex","A reflex is a sudden automatic action; it is not the steady wrist throb."),
    ("hiccup","A hiccup is a jerky breathing spasm, unrelated to the heartbeat felt at the wrist.")]),

 ("TP","The waste-removing system that filters the blood and makes urine is the:",
   "excretory system, with the kidneys",
   C("The excretory system, centred on the kidneys, filters wastes from the blood to form urine.")+
   steps("Blood collects wastes from cells","the kidneys filter these out","the wastes leave as urine.")+
   U("Drinking plenty of water helps the kidneys flush wastes out as urine."),
   [("the lungs only","The lungs remove waste gas, but urine is made by the kidneys."),
    ("the heart","The heart pumps blood; it does not filter wastes into urine."),
    ("the stomach","The stomach digests food; it does not filter blood to make urine.")]),

 ("TP","A patient's heart beats 70 times a minute. Over 5 minutes the total number of beats is:",
   "350 beats",
   C("Multiply the per-minute rate by the minutes: 70 × 5 — a fused rate-and-multiply problem.")+
   steps("70 beats happen each minute","there are 5 minutes","70 × 5 = 350 beats.")+
   U("A fitness tracker estimates total beats by multiplying your heart rate by the time."),
   [("75 beats","That adds 70 and 5; the beats over 5 minutes multiply 70 by 5."),
    ("140 beats","That is only 2 minutes' worth (70 × 2), not 5."),
    ("3500 beats","That multiplies by 50, not 5; 70 × 5 is 350.")]),

 ("TP","Blood is red because it contains a substance that carries oxygen, called:",
   "haemoglobin",
   C("Haemoglobin is the red pigment in blood that binds oxygen and carries it to the cells.")+
   steps("Cells need oxygen delivered","a special carrier in blood grabs oxygen","that red carrier is haemoglobin.")+
   U("Low haemoglobin causes tiredness because less oxygen reaches the body's cells."),
   [("plasma","Plasma is the pale liquid part of blood; the oxygen carrier is haemoglobin."),
    ("platelets","Platelets help blood clot; they do not carry oxygen."),
    ("phloem sap","Phloem sap is a plant fluid, not a component of animal blood.")]),

 ("TP","Tiny pores on the underside of leaves through which water vapour escapes and gases move are the:",
   "stomata",
   C("Stomata are small pores, mostly on the lower leaf surface, for gas exchange and water loss.")+
   steps("Leaves must exchange gases and lose water vapour","tiny adjustable pores allow this","these pores are the stomata.")+
   U("On a hot day a plant closes its stomata to slow down water loss."),
   [("roots","Roots absorb water from soil; the leaf pores for vapour are the stomata."),
    ("xylem","Xylem is the water-carrying tissue inside, not the surface pores."),
    ("veins","Leaf veins carry fluids; the pores that release vapour are the stomata.")]),

 ("TP","Water rises in a tall tree partly because transpiration at the top creates a:",
   "pull that draws water up the xylem",
   C("Water lost at the leaves creates a suction (transpiration pull) that draws water up the xylem.")+
   steps("Leaves lose water by transpiration","this creates a pull at the top","water is dragged up the xylem to replace it.")+
   U("This pull lets water reach the topmost leaves of very tall trees without any heart-like pump."),
   [("push from the roots only","Root push alone cannot raise water in tall trees; the leaf pull is key."),
    ("pump like an animal heart","Plants have no heart; the transpiration pull moves water up."),
    ("gas that lifts the water","No gas lifts the water; a suction pull from transpiration draws it up.")]),

 ("TP","In animals, the wastes carried by blood to be removed include carbon dioxide and:",
   "urea",
   C("Blood carries carbon dioxide to the lungs and urea (a nitrogen waste) to the kidneys.")+
   steps("Cells make waste gases and nitrogen wastes","blood collects them","carbon dioxide and urea are carried away.")+
   U("A kidney test measures urea to check how well wastes are being cleared from the blood."),
   [("oxygen","Oxygen is a useful gas delivered to cells, not a waste to be removed."),
    ("glucose","Glucose is food for the cells, not a waste product."),
    ("haemoglobin","Haemoglobin is the oxygen carrier; it is not a waste removed from blood.")]),

 ("TP","If a heart pumps about 70 mL of blood each beat and beats 70 times a minute, blood pumped per minute is about:",
   "4900 mL",
   C("Multiply blood per beat by beats per minute: 70 × 70 — a fused multiply problem.")+
   steps("70 mL leaves the heart each beat","there are 70 beats per minute","70 × 70 = 4900 mL per minute.")+
   U("Doctors estimate how much blood the heart moves each minute by this kind of multiplication."),
   [("140 mL","That adds 70 and 70; the volume per minute multiplies them."),
    ("490 mL","That multiplies by 7, not 70; 70 × 70 is 4900."),
    ("700 mL","That is 70 × 10; the heart beats 70, not 10, times a minute.")]),

 ("TP","Veins carrying blood back to the heart have valves whose job is to:",
   "stop blood from flowing backward",
   C("Valves in veins are one-way flaps that keep blood moving toward the heart and prevent backflow.")+
   steps("Blood in veins moves slowly back to the heart","gravity could pull it backward","valves snap shut to stop backflow.")+
   U("Faulty valves can let blood pool, causing swollen veins in the legs."),
   [("speed up the heartbeat","Vein valves do not control heart rate; they prevent backflow."),
    ("make new blood","Blood is made in the bone marrow, not by vein valves."),
    ("add oxygen to blood","Oxygen is added in the lungs; valves only stop backflow.")]),

 ("TP","Single-celled animals like Amoeba do not need a transport system because materials move by:",
   "simple diffusion across their surface",
   C("In a tiny single-celled body, oxygen and food simply diffuse in and wastes diffuse out.")+
   steps("Amoeba is a single small cell","every part is close to the surface","so materials move in and out by diffusion, needing no blood.")+
   U("A single cell under a microscope takes in oxygen directly from the surrounding water."),
   [("a tiny beating heart","Amoeba has no heart; small size lets diffusion do the job."),
    ("xylem tubes","Xylem belongs to plants; Amoeba relies on diffusion."),
    ("its blood vessels","A single cell has no blood vessels; it uses diffusion instead.")]),

 ("TP","The clear, almost colourless liquid part of blood that carries cells and dissolved food is the:",
   "plasma",
   C("Plasma is the pale liquid of blood in which cells float and dissolved foods and wastes travel.")+
   steps("Blood is part liquid, part cells","the liquid carries everything along","that liquid is the plasma.")+
   U("When blood settles in a tube, the clear plasma rises above the red cells."),
   [("haemoglobin","Haemoglobin is inside red cells; the liquid part is the plasma."),
    ("urea","Urea is a waste dissolved in plasma, not the liquid itself."),
    ("platelets","Platelets are tiny cell fragments; the liquid carrying them is plasma.")]),

 ("TP","A plant absorbs water mainly through fine outgrowths of its roots called:",
   "root hairs",
   C("Root hairs are tiny outgrowths that greatly increase the surface for absorbing water and minerals.")+
   steps("Roots must take in lots of water","tiny hairs add huge surface area","root hairs absorb the water and minerals.")+
   U("Pulling a seedling roughly can tear off its delicate root hairs and slow its growth."),
   [("stomata","Stomata are leaf pores for gases; water is taken in by root hairs."),
    ("phloem","Phloem carries food; absorption from the soil is by root hairs."),
    ("petals","Petals are parts of flowers and do not absorb soil water.")]),

 ("TP","A nurse counts 18 heartbeats in 15 seconds. The heart rate per full minute is:",
   "72 beats per minute",
   C("There are four 15-second blocks in a minute, so multiply 18 by 4 — a fused scale-up.")+
   steps("18 beats happen in 15 seconds","a minute is 60 s = four 15-s blocks","18 × 4 = 72 beats per minute.")+
   U("Counting beats for 15 seconds and multiplying by four is a quick way to find heart rate."),
   [("18 beats per minute","That ignores the scale-up; 18 beats were in only 15 s, a quarter of a minute."),
    ("33 beats per minute","That adds 18 and 15; the rate scales 18 up by four."),
    ("90 beats per minute","That multiplies by 5; a minute holds four 15-second blocks, not five.")]),

 ("TP","Blood that has given up its oxygen to the body and is now carrying carbon dioxide is described as:",
   "deoxygenated",
   C("After delivering oxygen to cells, blood becomes deoxygenated and carries carbon dioxide back.")+
   steps("Oxygen-rich blood reaches the cells","cells take the oxygen and add carbon dioxide","the returning blood is now deoxygenated.")+
   U("Deoxygenated blood is carried back to the lungs to pick up fresh oxygen."),
   [("oxygenated","Oxygenated blood is rich in oxygen; this blood has given its oxygen away."),
    ("digested","'Digested' describes food, not the oxygen state of blood."),
    ("filtered","Filtering happens in the kidneys; this term describes oxygen content, so it is deoxygenated.")]),

 ("TP","Why must large animals have a transport system while a tiny Amoeba does not?",
   "their cells are too far from the surface for diffusion alone",
   C("In a big body, inner cells are far from the surface, so diffusion is too slow and a transport system is needed.")+
   steps("Diffusion works only over tiny distances","a large body has deep, distant cells","so blood must carry materials to them.")+
   U("This is why every large animal, from a dog to a whale, has a heart and blood vessels."),
   [("they have no cells that need oxygen","All animal cells need oxygen; the issue is distance, not need."),
    ("diffusion is faster in large animals","Diffusion is slower over long distances, which is exactly the problem."),
    ("small animals need more oxygen","Need is not the point; large bodies need transport because of distance.")]),

 ("TP","Over a 60-second minute the heart rests briefly between beats, beating 75 times. The average time for one full beat is:",
   "0.8 seconds",
   C("Divide the minute by the number of beats: 60 ÷ 75 — a fused rate-to-time calculation.")+
   steps("60 seconds hold 75 beats","time per beat = 60 ÷ 75","60 ÷ 75 = 0.8 seconds.")+
   U("Knowing the time for one beat helps doctors judge whether a heartbeat rhythm is healthy."),
   [("1.25 seconds","That divides 75 by 60 the wrong way round; it should be 60 ÷ 75."),
    ("8 seconds","That misplaces the decimal; 60 ÷ 75 is 0.8, not 8."),
    ("0.08 seconds","That divides by 750; with 75 beats the time per beat is 0.8 s.")]),

 ("TP","Which correctly matches the transport pathway to what it carries?",
   "Xylem carries water up; phloem carries food",
   C("Xylem moves water and minerals upward from roots; phloem moves food made in leaves to all parts.")+
   steps("Recall xylem = water up","recall phloem = food around","match each to what it carries.")+
   U("A ringed tree branch can still draw water (xylem) but its food supply (phloem) is cut off."),
   [("Xylem carries food; phloem carries water","This swaps the two; xylem carries water, phloem carries food."),
    ("Both xylem and phloem carry only water","Phloem carries food, not water, so this is wrong."),
    ("Phloem carries water up from the roots","Water rises in the xylem; the phloem carries food.")]),
]

# ---------- RATIONAL NUMBERS (25) — Maths (some fused) ----------
RN = [
 ("RN","If you can express a value as p/q with p and q whole numbers and q not zero, that value is a:",
   "rational number",
   C("Any number expressible as a fraction p/q with integer p and non-zero integer q is rational.")+
   steps("Write the number as a ratio of two integers","make sure the bottom is not zero","if you can, it is a rational number.")+
   U("Sharing 3 rotis among 4 people gives 3/4 each — a rational number."),
   [("whole number","Whole numbers are only 0,1,2,…; rationals include fractions and negatives too."),
    ("natural number","Natural numbers start at 1 and have no fractions; rationals are broader."),
    ("irrational number","Irrational numbers cannot be written as p/q, the opposite of a rational number.")]),

 ("RN","On the number line, the rational number −3/4 lies:",
   "between −1 and 0",
   C("−3/4 is a negative number a little less than −1/2, so it sits between −1 and 0.")+
   steps("−3/4 is negative, so it is left of 0","its size is less than 1","so it lies between −1 and 0.")+
   U("A temperature of −0.75 °C sits just below freezing, between −1 °C and 0 °C."),
   [("between 0 and 1","−3/4 is negative, so it must be to the left of 0, not the right."),
    ("between −1 and −2","−3/4 is bigger than −1, so it lies between −1 and 0, not below −1."),
    ("exactly at −1","−3/4 is closer to 0 than −1; it is not exactly −1.")]),

 ("RN","Which of these is the standard form of the rational number 12/(−18)?",
   "−2/3",
   C("Standard form has a positive denominator and is reduced; 12/(−18) = −2/3.")+
   steps("Move the sign to the top: −12/18","divide top and bottom by 6","−12/18 = −2/3.")+
   U("Simplifying fractions to lowest terms keeps recipe and measurement numbers tidy."),
   [("2/3","The original is negative (positive over negative), so the sign must stay: −2/3."),
    ("−12/18","Correct in sign but not reduced; dividing by 6 gives −2/3."),
    ("−3/2","That flips the fraction upside down; 12/18 reduces to 2/3, so it is −2/3.")]),

 ("RN","The sum −3/7 + 2/7 equals:",
   "−1/7",
   C("With the same denominator, add the numerators: −3 + 2 = −1, over 7.")+
   steps("Denominators are equal (7)","add tops: −3 + 2 = −1","keep the 7: −1/7.")+
   U("Owing 3/7 of a chocolate and being given 2/7 leaves you still 1/7 short."),
   [("−5/7","That adds the sizes 3 and 2 ignoring signs; −3 + 2 is −1, not −5."),
    ("1/7","The bigger number, 3/7, is negative, so the result is negative: −1/7."),
    ("−1/14","Denominators stay 7 when they are already equal; you do not add them.")]),

 ("RN","The additive inverse (the number you add to get 0) of −5/9 is:",
   "5/9",
   C("The additive inverse of a number is its opposite; for −5/9 it is +5/9, since they sum to 0.")+
   steps("Look for the number that adds to give 0","just flip the sign of −5/9","the opposite is 5/9.")+
   U("A debt of 5/9 of a rupee is cancelled exactly by a credit of 5/9 of a rupee."),
   [("−5/9","Adding −5/9 to −5/9 gives −10/9, not 0; the inverse must be the opposite sign."),
    ("9/5","That flips the fraction (the reciprocal), which is for multiplication, not addition."),
    ("0","Adding 0 leaves −5/9 unchanged; the inverse must cancel it to 0.")]),

 ("RN","Multiplying the rational numbers (−2/3) and (3/4) together gives a result of:",
   "−1/2",
   C("Multiply tops and bottoms, then simplify: (−2×3)/(3×4) = −6/12 = −1/2.")+
   steps("Multiply numerators: −2 × 3 = −6","multiply denominators: 3 × 4 = 12","−6/12 reduces to −1/2.")+
   U("Taking 3/4 of a 2/3-litre bottle's missing amount uses this kind of fraction multiplication."),
   [("1/2","A negative times a positive is negative, so the answer is −1/2, not 1/2."),
    ("−6/7","Denominators are multiplied, not added; 3 × 4 = 12, giving −1/2."),
    ("−5/12","Numerators are multiplied, not added; −2 × 3 = −6, so −6/12 = −1/2.")]),

 ("RN","To compare 2/3 and 3/5, the easiest first step is to:",
   "rewrite both with a common denominator",
   C("Fractions are easiest to compare when they share a denominator; then compare the numerators.")+
   steps("Pick a common denominator, here 15","2/3 = 10/15 and 3/5 = 9/15","now compare 10 and 9.")+
   U("Comparing 2/3 of a pizza with 3/5 of one is clear once both are in fifteenths."),
   [("compare the numerators as they are","With different denominators the raw numerators can mislead; equalise first."),
    ("compare the denominators as they are","A bigger denominator does not always mean a bigger fraction; equalise first."),
    ("add the two fractions","Adding does not tell you which is larger; rewrite with a common denominator.")]),

 ("RN","A diver descends from 0 m to −18 m, then rises 7 m. The diver's new depth (as a rational/integer) is:",
   "−11 m",
   C("Start at −18 and add the rise of +7: a signed-number sum, here applied to a depth.")+
   steps("Start at −18 m","rising 7 m adds +7","−18 + 7 = −11 m.")+
   U("A submarine's depth gauge adds and subtracts signed numbers as it dives and rises."),
   [("−25 m","Rising should move toward the surface (add +7), not deeper (−18 − 7)."),
    ("11 m","The diver is still below the surface, so the depth stays negative: −11 m."),
    ("−18 m","Rising 7 m changes the depth; it does not stay at −18 m.")]),

 ("RN","Between any two different rational numbers, the count of rational numbers lying between them is:",
   "infinitely many",
   C("Rational numbers are dense: no matter how close two are, you can always fit more between them.")+
   steps("Take the average of the two — it lies between them","average again with each — more numbers appear","you can repeat forever, so there are infinitely many.")+
   U("You can always name a price between two given prices, like ₹10.50 between ₹10 and ₹11."),
   [("exactly one","You can keep finding averages, so far more than one number lies between them."),
    ("none","The average of the two is itself a rational number lying between them, so 'none' is wrong."),
    ("exactly ten","There is no fixed count; you can always squeeze in more, so it is infinite.")]),

 ("RN","The reciprocal (multiplicative inverse) of −7/4 is:",
   "−4/7",
   C("The reciprocal flips the fraction and keeps the sign so the product is 1; for −7/4 it is −4/7.")+
   steps("Flip top and bottom: 7/4 → 4/7","keep the negative sign","−7/4 × (−4/7) = 1, confirming −4/7.")+
   U("Reciprocals appear whenever you divide by a fraction, such as splitting work rates."),
   [("4/7","Sign matters: a negative number's reciprocal is also negative, so it is −4/7."),
    ("7/4","That is the original number's size, not its reciprocal; you must flip it."),
    ("−7/4","That is the number itself; its reciprocal flips it to −4/7.")]),

 ("RN","The value of (−5/6) − (−1/6) is:",
   "−2/3",
   C("Subtracting a negative adds it: −5/6 + 1/6 = −4/6, which reduces to −2/3.")+
   steps("Subtracting −1/6 is adding 1/6","−5/6 + 1/6 = −4/6","reduce: −4/6 = −2/3.")+
   U("Cancelling a small debt from a larger one reduces how much you still owe."),
   [("−1","That treats it as −5/6 − 1/6 = −6/6; but subtracting a negative adds, giving −2/3."),
    ("−4/6","Correct before simplifying, but −4/6 reduces to −2/3."),
    ("2/3","The larger number is negative, so the result stays negative: −2/3.")]),

 ("RN","Which list is written in correct increasing order?",
   "−1, −1/2, 0, 1/2",
   C("Increasing order goes from the most negative to the most positive along the number line.")+
   steps("Most negative first: −1","then −1/2, then 0","then the positive 1/2.")+
   U("Listing temperatures from coldest to warmest follows this same left-to-right order."),
   [("0, −1/2, −1, 1/2","This puts 0 before negatives; negatives are smaller and come first."),
    ("1/2, 0, −1/2, −1","This is decreasing order, the reverse of increasing."),
    ("−1/2, −1, 0, 1/2","−1 is smaller than −1/2, so −1 should come first.")]),

 ("RN","Dividing 4/9 by 2/3 gives:",
   "2/3",
   C("To divide by a fraction, multiply by its reciprocal: (4/9) × (3/2).")+
   steps("Flip the divisor: 2/3 → 3/2","multiply: (4/9) × (3/2) = 12/18","reduce 12/18 = 2/3.")+
   U("Working out how many 2/3-litre jugs fill from 4/9 litre uses fraction division."),
   [("8/27","That multiplied straight across by 2/3 instead of by its reciprocal 3/2."),
    ("6/9","That kept the wrong product; 12/18 reduces to 2/3, not 6/9 left unreduced."),
    ("3/2","That is the reciprocal of the divisor alone, not the full result 2/3.")]),

 ("RN","A rational number is equal to its own additive inverse only when the number is:",
   "0",
   C("Only 0 satisfies n = −n, because 0 is its own opposite on the number line.")+
   steps("We need a number equal to its own opposite","for any non-zero n, n and −n differ","only 0 has 0 = −0.")+
   U("A bank balance that stays the same whether marked as a credit or a debt must be zero."),
   [("1","1 and its opposite −1 are different, so 1 is not its own additive inverse."),
    ("−1","−1 and its opposite 1 differ, so −1 fails the test."),
    ("every rational number","Most numbers differ from their opposites; only 0 equals its own inverse.")]),

 ("RN","The temperature falls from 5 °C by 8 degrees. Written as a rational/integer, the new temperature is:",
   "−3 °C",
   C("Subtract the fall from the start: 5 − 8, a signed-number sum that can go below zero.")+
   steps("Start at 5 °C","a fall of 8 means subtract 8","5 − 8 = −3 °C.")+
   U("A weather app shows temperatures dropping below zero on a cold winter night."),
   [("3 °C","Falling below zero gives a negative temperature; 5 − 8 = −3, not +3."),
    ("13 °C","A fall subtracts; adding 8 would be a rise, not a fall."),
    ("−13 °C","That subtracts from −5; the start is +5, so 5 − 8 = −3.")]),

 ("RN","Which number is NOT equal to the others?",
   "−2/4",
   C("−1/2, −3/6 and −4/8 all reduce to the same value; −2/4 reduces to −1/2 too, but the odd one is the positive look-alike.")+
   steps("Reduce each: −3/6 = −1/2, −4/8 = −1/2","2/4 (positive) = +1/2","the positive 2/4 differs from the negative halves.")+
   U("Spotting equivalent fractions stops you double-counting the same amount in different forms."),
   [("−3/6","−3/6 reduces to −1/2, matching the others, so it is not the odd one."),
    ("−4/8","−4/8 reduces to −1/2 as well, so it is equal, not different."),
    ("−1/2","−1/2 is the common reduced value the others share, so it is not the odd one.")]),

 ("RN","The product of a non-zero rational number and its reciprocal is always:",
   "1",
   C("A number times its reciprocal gives 1, because the flip cancels the original exactly.")+
   steps("Take any n/m (not zero)","its reciprocal is m/n","(n/m) × (m/n) = 1.")+
   U("Scaling a quantity up by 3 then down by 1/3 returns it to its original size."),
   [("0","Only multiplying by 0 gives 0; a number times its reciprocal gives 1."),
    ("the number itself","Multiplying by 1 leaves a number unchanged, but the reciprocal product is 1."),
    ("−1","The reciprocal keeps the sign, so a number times its reciprocal is +1, not −1.")]),

 ("RN","Where does the rational number 7/2 lie on the number line?",
   "between 3 and 4",
   C("7/2 equals 3.5, which sits halfway between the whole numbers 3 and 4.")+
   steps("Divide: 7 ÷ 2 = 3.5","3.5 is more than 3 but less than 4","so it lies between 3 and 4.")+
   U("A jump of 3.5 metres lands between the 3 m and 4 m marks on a tape."),
   [("between 7 and 2","7/2 is a single value (3.5), not a span from 7 to 2."),
    ("between 2 and 3","3.5 is greater than 3, so it lies past 3, between 3 and 4."),
    ("exactly at 7","7/2 is half of 7, namely 3.5, not 7 itself.")]),

 ("RN","A share price changes by −2 1/2 points, then by +1 3/4 points. The total change is:",
   "−3/4 point",
   C("Add the signed mixed numbers: −2 1/2 + 1 3/4 = −5/2 + 7/4 = −10/4 + 7/4 = −3/4.")+
   steps("Write as fractions: −5/2 and 7/4","common denominator 4: −10/4 + 7/4","sum = −3/4 point.")+
   U("A day's net change in a stock adds its ups and downs as signed numbers."),
   [("−4 1/4 points","That adds the two drops; the +1 3/4 is a rise and should be added, not subtracted."),
    ("3/4 point","The fall of 2 1/2 outweighs the rise of 1 3/4, so the net change is negative."),
    ("−1 1/4 points","That is −2 1/2 + 1 1/4; the rise is 1 3/4, giving a net of −3/4.")]),

 ("RN","Which statement about rational numbers is true?",
   "Every integer is a rational number",
   C("Any integer n equals n/1, so it fits the p/q form and is rational; not every rational is an integer.")+
   steps("Write an integer as itself over 1, e.g. 5 = 5/1","that fits p/q with q ≠ 0","so every integer is rational.")+
   U("Whole-number prices like ₹5 are rational numbers, just with a denominator of 1."),
   [("Every rational number is an integer","Fractions like 1/2 are rational but not integers, so this is false."),
    ("No integer is a rational number","Each integer equals n/1, so integers are rational; this is the opposite of the truth."),
    ("Rational numbers cannot be negative","Numbers like −3/4 are rational and negative, so this is false.")]),

 ("RN","The value of 0 ÷ (−5/8) is:",
   "0",
   C("Zero divided by any non-zero number is 0, because nothing shared out stays nothing.")+
   steps("0 divided by a non-zero number","share 0 into parts — each part is 0","so 0 ÷ (−5/8) = 0.")+
   U("Splitting ₹0 among friends still gives each friend ₹0."),
   [("−5/8","Dividing 0 by a number gives 0, not the divisor itself."),
    ("−8/5","That is the reciprocal of the divisor; 0 divided by anything non-zero is 0."),
    ("undefined","Dividing 0 by a non-zero number is fine and equals 0; only dividing BY zero is undefined.")]),

 ("RN","The rational number that is neither positive nor negative is:",
   "0",
   C("Zero is the only rational number that is neither positive nor negative; it is the dividing point.")+
   steps("Positive numbers are right of 0, negatives left","0 sits exactly at the centre","so 0 is neither positive nor negative.")+
   U("A bank balance of exactly ₹0 is neither in credit nor in debt."),
   [("1","1 is a positive rational number, so it cannot be the neutral one."),
    ("−1","−1 is negative, so it is not the number that is neither positive nor negative."),
    ("1/2","1/2 is positive, lying to the right of 0, so it is not neutral.")]),

 ("RN","A recipe needs 3/4 cup of milk per serving. For 2/3 of a serving you need:",
   "1/2 cup",
   C("Take 2/3 of 3/4 by multiplying: (3/4) × (2/3) = 6/12 = 1/2 — a fused fraction-of-a-fraction.")+
   steps("Multiply 3/4 by 2/3","(3 × 2)/(4 × 3) = 6/12","reduce 6/12 = 1/2 cup.")+
   U("Scaling a recipe down to a smaller portion multiplies each amount by a fraction."),
   [("3/4 cup","That is the full serving's amount; 2/3 of a serving needs less than 3/4 cup."),
    ("5/12 cup","That added the fractions in some way; multiplying gives 6/12 = 1/2."),
    ("9/8 cup","That is more than a full serving; a fraction of a serving must be smaller, 1/2 cup.")]),

 ("RN","Which property is shown by (−2/5) + (3/7) = (3/7) + (−2/5)?",
   "addition of rational numbers is commutative",
   C("Commutativity means the order of adding does not change the sum; this holds for rationals.")+
   steps("The same two numbers are added","only their order is swapped","the sum is unchanged — that is commutativity.")+
   U("Adding your two pocket-money amounts gives the same total in either order."),
   [("addition is associative","Associativity is about regrouping three numbers, not swapping the order of two."),
    ("multiplication is commutative","The example uses addition (+), not multiplication."),
    ("0 is the additive identity","That property is about adding 0; here two non-zero numbers are swapped.")]),

 ("RN","A submarine at −40 m below sea level rises in 5 equal stages to the surface (0 m). Each stage changes its depth by:",
   "+8 m",
   C("Total rise is 40 m over 5 equal stages, so each stage is 40 ÷ 5 = +8 m — a fused signed-number share.")+
   steps("It must climb from −40 m to 0 m, a rise of 40 m","share equally over 5 stages: 40 ÷ 5","each stage is +8 m.")+
   U("A diver planning safe stops divides the total ascent into equal upward steps."),
   [("−8 m","A rise moves toward the surface, so each step is positive (+8 m), not negative."),
    ("+40 m","40 m is the whole rise; one of 5 equal stages is a fifth of that, +8 m."),
    ("+5 m","That divides 40 by 8; there are 5 stages, so 40 ÷ 5 = 8 m each.")]),
]

# ---------- LINES & ANGLES (25) — Maths (some fused) ----------
LA = [
 ("LA","A pair of angles whose measures together make exactly a right angle of 90° are known as:",
   "complementary angles",
   C("Complementary angles are a pair that together make a right angle, summing to 90°.")+
   steps("Add the two angle measures","if the total is exactly 90°","they are complementary.")+
   U("The two acute angles of a right-angled triangle are complementary."),
   [("supplementary angles","Supplementary angles add to 180°, not 90°."),
    ("vertically opposite angles","Vertically opposite angles are equal, not necessarily 90° together."),
    ("adjacent angles","Adjacent angles merely share a side; they need not add to 90°.")]),

 ("LA","A pair of angles whose measures together make a straight angle of 180° are described as:",
   "supplementary angles",
   C("Supplementary angles are a pair that together make a straight angle, summing to 180°.")+
   steps("Add the two angle measures","if the total is exactly 180°","they are supplementary.")+
   U("Angles on a straight line add up to 180°, so they are supplementary."),
   [("complementary angles","Complementary angles add to 90°, not 180°."),
    ("right angles","A right angle is a single 90° angle, not a pair summing to 180°."),
    ("reflex angles","A reflex angle is one angle bigger than 180°, not a pair adding to 180°.")]),

 ("LA","An angle measures 35°; the angle needed to complete a right angle with it (its complement) is:",
   "55°",
   C("Complementary angles sum to 90°, so the complement of 35° is 90 − 35.")+
   steps("Complements add to 90°","subtract: 90 − 35","the complement is 55°.")+
   U("A ramp tilted 35° from the floor leaves 55° up to the vertical wall."),
   [("65°","That subtracts from 100, not 90; complements add to exactly 90°."),
    ("145°","That is the supplement (180 − 35), not the complement."),
    ("35°","An angle equals its own complement only at 45°; the complement of 35° is 55°.")]),

 ("LA","An angle measures 110°; the angle needed to complete a straight line with it (its supplement) is:",
   "70°",
   C("Supplementary angles sum to 180°, so the supplement of 110° is 180 − 110.")+
   steps("Supplements add to 180°","subtract: 180 − 110","the supplement is 70°.")+
   U("Two angles on a straight line, 110° and 70°, together make the straight 180°."),
   [("90°","90° would be the supplement of 90°, not of 110°; 180 − 110 = 70°."),
    ("250°","That adds instead of subtracting; supplements add to 180°, giving 70°."),
    ("20°","That subtracts from 130; the supplement uses 180 − 110 = 70°.")]),

 ("LA","When two straight lines cross, the angles directly opposite each other are:",
   "equal",
   C("Vertically opposite angles, formed when two lines cross, are always equal.")+
   steps("Two lines cross at a point","the angle pairs facing each other are vertically opposite","such pairs are equal.")+
   U("The opposite angles made by a crossing pair of scissors are equal."),
   [("supplementary","Vertically opposite angles are equal; the neighbouring (linear) pairs are supplementary."),
    ("complementary","Opposite angles at a crossing are equal, not adding to 90°."),
    ("always 90°","They are equal to each other but need not each be 90° unless the lines are perpendicular.")]),

 ("LA","Two angles that share a common vertex and a common arm, lying side by side, are called:",
   "adjacent angles",
   C("Adjacent angles sit next to each other, sharing a vertex and one arm, with no overlap.")+
   steps("Check for a shared vertex","check for a shared arm between them","if they sit side by side, they are adjacent.")+
   U("The hour and minute hands of a clock form adjacent angles around the centre."),
   [("vertically opposite angles","Vertically opposite angles face each other across a crossing, not side by side."),
    ("complementary angles","Complementary is about adding to 90°, not about sharing a vertex and arm."),
    ("alternate angles","Alternate angles lie on opposite sides of a transversal, not side by side at one vertex.")]),

 ("LA","In a linear pair, one angle is 125°. The other angle measures:",
   "55°",
   C("A linear pair lies on a straight line and sums to 180°, so the other is 180 − 125.")+
   steps("A linear pair adds to 180°","subtract: 180 − 125","the other angle is 55°.")+
   U("Where a road meets a straight kerb, the two angles formed add up to 180°."),
   [("125°","Both angles are equal only when each is 90°; here the pair sums to 180°, giving 55°."),
    ("65°","That subtracts from 190; a linear pair adds to 180°, so 180 − 125 = 55°."),
    ("35°","That subtracts from 160; the straight-line total is 180°, giving 55°.")]),

 ("LA","When a transversal crosses two parallel lines, a pair of corresponding angles are:",
   "equal",
   C("With parallel lines, corresponding angles (in matching positions) are equal.")+
   steps("A transversal cuts two parallel lines","angles in the same position at each crossing are corresponding","these are equal.")+
   U("The matching angles a fence rail makes where it crosses two parallel posts are equal."),
   [("supplementary","Corresponding angles between parallels are equal; co-interior angles are supplementary."),
    ("complementary","Corresponding angles are equal, not adding to 90°."),
    ("always right angles","They are equal to each other but are right angles only if the transversal is perpendicular.")]),

 ("LA","A leaning xylem stem makes a 65° angle with the flat ground. The angle it makes with the vertical wall behind it is:",
   "25°",
   C("Ground and wall meet at 90°, so the stem's angle to the vertical is 90 − 65 — a fused complement.")+
   steps("Ground and vertical are 90° apart","the stem takes 65° from the ground","90 − 65 = 25° from the vertical.")+
   U("A leaning plant or ladder splits the right angle between floor and wall into two complementary parts."),
   [("115°","That adds 65 to 50; the stem's angles to ground and wall add to 90°, giving 25°."),
    ("65°","65° is the angle to the ground; the angle to the vertical is its complement, 25°."),
    ("35°","That subtracts from 100; the floor-to-wall right angle is 90°, so 90 − 65 = 25°.")]),

 ("LA","When a transversal crosses two parallel lines, a pair of alternate interior angles are:",
   "equal",
   C("Alternate interior angles, on opposite sides of the transversal between the parallels, are equal.")+
   steps("Look between the two parallel lines","take the angles on opposite sides of the transversal","these alternate interior angles are equal.")+
   U("The Z-shape made by a zig-zag path across parallel kerbs shows equal alternate angles."),
   [("supplementary","Alternate interior angles are equal; it is co-interior angles that are supplementary."),
    ("complementary","Alternate interior angles are equal, not adding to 90°."),
    ("reflex","Alternate interior angles are ordinary interior angles, not reflex angles.")]),

 ("LA","An angle that is more than 90° but less than 180° is called a/an:",
   "obtuse angle",
   C("An obtuse angle measures between 90° and 180° — wider than a right angle but not yet straight.")+
   steps("Compare with 90° and 180°","if it is bigger than 90° but smaller than 180°","it is obtuse.")+
   U("The wide opening of a laptop lid tilted well back is an obtuse angle."),
   [("acute angle","An acute angle is less than 90°, not more than it."),
    ("right angle","A right angle is exactly 90°, not between 90° and 180°."),
    ("reflex angle","A reflex angle is more than 180°, beyond the obtuse range.")]),

 ("LA","Two co-interior (same-side interior) angles between parallel lines measure x and 75°. The value of x is:",
   "105°",
   C("Co-interior angles between parallels are supplementary, so x + 75 = 180.")+
   steps("Co-interior angles add to 180°","x = 180 − 75","x = 105°.")+
   U("The same-side angles where a beam crosses two parallel rails always add to a straight 180°."),
   [("75°","Co-interior angles are supplementary, not equal; x = 180 − 75 = 105°."),
    ("15°","That treats them as complementary (90°); co-interior angles add to 180°."),
    ("285°","That adds instead of subtracting; 180 − 75 = 105°, not 180 + 105.")]),

 ("LA","Three angles lie on a straight line. Two of them are 50° and 70°. The third angle is:",
   "60°",
   C("Angles on a straight line add to 180°, so the third is 180 − (50 + 70).")+
   steps("Angles on a line total 180°","add the known two: 50 + 70 = 120","180 − 120 = 60°.")+
   U("Three roof beams meeting along a straight ridge split the 180° among them."),
   [("120°","120° is the sum of the two known angles; the third fills the rest to 180°, namely 60°."),
    ("110°","That is 180 − 70 alone; both known angles, 50 and 70, must be subtracted."),
    ("130°","That is 180 − 50 alone; subtract both 50 and 70 to get 60°.")]),

 ("LA","Vertically opposite angles formed by two crossing lines are equal. If one such angle is 3x and its opposite is 60°, then x is:",
   "20",
   C("Vertically opposite angles are equal, so set 3x = 60 and solve.")+
   steps("Opposite angles are equal: 3x = 60","divide both sides by 3","x = 20.")+
   U("Reading one angle at a crossing instantly tells you its equal opposite, letting you solve for an unknown."),
   [("180","That multiplies 60 by 3 instead of dividing; 3x = 60 gives x = 20."),
    ("30","That divides 60 by 2; the coefficient is 3, so x = 60 ÷ 3 = 20."),
    ("40","That subtracts 20 from 60; you must divide 60 by 3 to undo the ×3, giving 20.")]),

 ("LA","Which pair of angles must ALWAYS be equal, no matter the figure?",
   "vertically opposite angles",
   C("Vertically opposite angles are always equal whenever two lines cross, with no extra conditions.")+
   steps("Two crossing lines always make opposite-angle pairs","these are always equal","other pairs depend on the figure.")+
   U("Open a pair of scissors any amount and the opposite angles between the blades stay equal."),
   [("adjacent angles","Adjacent angles vary with the figure and are not always equal."),
    ("co-interior angles","Co-interior angles are supplementary (add to 180°), not equal."),
    ("any two angles on a line","Angles on a line add to 180° but need not be equal to each other.")]),

 ("LA","An angle exactly equal to 180° forms a:",
   "straight angle",
   C("A straight angle is exactly 180° — its two arms point in opposite directions along a line.")+
   steps("Measure the angle","if it is exactly 180°","it is a straight angle, lying along a straight line.")+
   U("A see-saw balanced perfectly flat forms a straight 180° angle."),
   [("right angle","A right angle is 90°, half of a straight angle."),
    ("reflex angle","A reflex angle is more than 180°; exactly 180° is a straight angle."),
    ("complete angle","A complete angle is 360°, a full turn, not 180°.")]),

 ("LA","A clock's hands at 3 o'clock form an angle of 90°. This angle is best described as a:",
   "right angle",
   C("A 90° angle is a right angle, the angle between two perpendicular arms.")+
   steps("At 3 o'clock the hands are a quarter-turn apart","a quarter of 360° is 90°","90° is a right angle.")+
   U("The corner of a book or a square tile is a right angle."),
   [("straight angle","A straight angle is 180°, twice the 90° shown at 3 o'clock."),
    ("acute angle","An acute angle is less than 90°; exactly 90° is a right angle."),
    ("reflex angle","A reflex angle is more than 180°, far larger than the 90° here.")]),

 ("LA","Two angles of a linear pair are equal. Each angle must measure:",
   "90°",
   C("A linear pair sums to 180°; if the two are equal, each is half of 180°.")+
   steps("Linear pair adds to 180°","equal angles split it evenly","180 ÷ 2 = 90° each.")+
   U("Where a pole stands perfectly upright on a flat path, it makes two equal 90° angles."),
   [("45°","Two 45° angles total only 90°, not the 180° of a linear pair."),
    ("60°","Two 60° angles total 120°, short of the 180° required."),
    ("180°","180° is the total of the pair, not each angle; each is half, 90°.")]),

 ("LA","A transversal crosses two parallel rails. One corresponding angle is (2x + 10)° and its partner is 70°. Then x equals:",
   "30",
   C("Corresponding angles between parallels are equal, so 2x + 10 = 70 — a fused equation.")+
   steps("Set the equal angles: 2x + 10 = 70","subtract 10: 2x = 60","divide by 2: x = 30.")+
   U("Knowing corresponding angles are equal lets surveyors solve for unknown angles on parallel boundaries."),
   [("40","That forgot to subtract the 10 before halving; 2x = 60 gives x = 30."),
    ("35","That halved 70 directly; you must first subtract 10, then divide, giving 30."),
    ("60","That is the value of 2x, not x; divide 60 by 2 to get x = 30.")]),

 ("LA","An acute angle is one that measures:",
   "less than 90°",
   C("An acute angle is smaller than a right angle, measuring between 0° and 90°.")+
   steps("Compare the angle with 90°","if it is smaller than 90°","it is acute.")+
   U("The sharp tip of a slice of pizza forms an acute angle."),
   [("exactly 90°","Exactly 90° is a right angle, not acute."),
    ("more than 90°","Angles bigger than 90° are obtuse or reflex, not acute."),
    ("exactly 180°","180° is a straight angle, far larger than an acute angle.")]),

 ("LA","Around a single point, all the angles together add up to:",
   "360°",
   C("The angles making a full turn around a point sum to 360°, one complete revolution.")+
   steps("Going once around a point is a full turn","a full turn is 360°","so all angles at the point total 360°.")+
   U("The slices of a round pizza, measured at the centre, add up to 360°."),
   [("180°","180° is a straight angle (half a turn); a full turn around a point is 360°."),
    ("90°","90° is just a right angle, a quarter of the full turn around a point."),
    ("270°","270° is three-quarters of a turn; a complete turn is 360°.")]),

 ("LA","Two acute angles measuring 40° and 35° are placed together at a point with a 285° angle. Do they complete a full turn?",
   "yes, because 40 + 35 + 285 = 360",
   C("Angles around a point must total 360°; here the three add exactly to a full turn.")+
   steps("Add the three angles: 40 + 35 = 75","75 + 285 = 360","they sum to 360°, a full turn.")+
   U("Checking that pie-chart slices add to 360° confirms the whole circle is accounted for."),
   [("no, they add to 180°","40 + 35 + 285 is 360°, a full turn, not 180°."),
    ("no, they add to 300°","The correct sum is 40 + 35 + 285 = 360°, not 300°."),
    ("yes, because they add to 90°","Three angles around a point complete 360°, not 90°; the sum here is 360°.")]),

 ("LA","Which statement is TRUE about supplementary angles?",
   "Two supplementary angles cannot both be acute",
   C("Supplementary angles add to 180°; two angles under 90° each would total under 180°, so both cannot be acute.")+
   steps("Acute means under 90°","two acute angles total under 180°","so a supplementary pair cannot both be acute.")+
   U("On a straight line, if one angle is small and acute, its partner must be the large obtuse one."),
   [("Both supplementary angles are always acute","Two acute angles total under 180°, so they cannot be supplementary."),
    ("Supplementary angles always add to 90°","Supplementary angles add to 180°; 90° is for complementary angles."),
    ("Supplementary angles must be equal","They are equal only when each is 90°; in general they differ.")]),

 ("LA","A beam of light strikes a mirror so the angle between the beam and the mirror is 30°. The angle between the beam and the line perpendicular to the mirror (the normal) is:",
   "60°",
   C("The mirror and the normal are 90° apart, so the angle to the normal is 90 − 30 — a fused complement.")+
   steps("Mirror surface and normal meet at 90°","the beam is 30° from the mirror","90 − 30 = 60° from the normal.")+
   U("In physics, angles of light are measured from the normal, so this complement is found constantly."),
   [("30°","30° is the angle to the mirror surface; the angle to the normal is its complement, 60°."),
    ("120°","That adds 30 to 90; the mirror and normal split a right angle, giving 60°."),
    ("150°","That is 180 − 30; the relevant right angle is 90°, so 90 − 30 = 60°.")]),

 ("LA","Two parallel branches of a plant are crossed by a slanting twig. One angle made is 65°. The co-interior angle on the same side measures:",
   "115°",
   C("Co-interior angles between two parallel lines are supplementary, adding to 180°.")+
   steps("The twig is a transversal cutting parallel branches","co-interior angles add to 180°","180 − 65 = 115°.")+
   U("Where a diagonal support crosses two parallel rails, the same-side angles always make a straight 180°."),
   [("65°","Co-interior angles are supplementary, not equal; 180 − 65 = 115°."),
    ("25°","That treats them as complementary (90°); co-interior angles add to 180°."),
    ("295°","That adds rather than subtracts; the supplement is 180 − 65 = 115°.")]),
]

# ---------- assemble: interleave so no two consecutive share a chapter ----------
assert all(len(b) == 25 for b in (AB, TP, RN, LA)), [len(AB), len(TP), len(RN), len(LA)]
items = []
for i in range(25):
    items += [AB[i], TP[i], RN[i], LA[i]]
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

    keydist = build_paper(PNUM, TITLE, SHORT, LABELS, items, seed=44023,
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
    split = "/".join(str(counts[c]) for c in ("AB", "TP", "RN", "LA"))
    with open("PAPERS_MANIFEST.md", "a", encoding="utf-8") as fh:
        fh.write(f"| {PNUM} | 2026-06-18 | {TITLE} | {split} | ✓ |\n")

    # ---- update QUESTION_INDEX.json ----
    idx["fingerprints"] = sorted(existing | set(new_fps))
    idx.setdefault("combos", []).append({
        "paper": PNUM,
        "chapters": ["Acids, Bases & Salts",
                     "Transportation in Animals & Plants",
                     "Rational Numbers",
                     "Lines & Angles"],
    })
    idx["papers"] = idx.get("papers", 0) + 1
    with open(idx_path, "w", encoding="utf-8") as fh:
        json.dump(idx, fh, ensure_ascii=False, indent=2)
        fh.write("\n")

    print("Files:", sorted(v for v in moves.values()))
    print("Answer key spread A/B/C/D =", dict(keydist))
    print("Fingerprints added:", len(new_fps))
