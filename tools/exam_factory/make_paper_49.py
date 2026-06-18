# -*- coding: utf-8 -*-
# Boss Challenge Paper 49 — Acids, Bases & Salts · Reproduction in Plants ·
# Comparing Quantities · Symmetry
# Content-only. Uses the dependency-free examfactory engine.
# Difficulty ramp: leans hard into FUSION. The strength of an acid solution is
# read as a PERCENTAGE by mass; a seed tray's germination becomes a percentage
# and a ratio; a flower's identical petals decide its lines / order of
# symmetry; a neutralisation in the lab is reported as a ratio of volumes.
# The child meets a Science situation and reaches for a Maths skill.
# Class-7 scope, simple wording, hard thinking.
# Produces, under Resources/BossChallengePapers/:
#   Paper_49_<SHORT>_QuestionPaper.html  (pure HTML — questions + options)
#   Paper_49_<SHORT>_QuestionPaper.pdf
#   Paper_49_<SHORT>_Questions.md
#   Paper_49_<SHORT>_Solutions.html
import os, sys, shutil, json, re
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from examfactory import build_paper, C, steps, U

PNUM  = "49"
SHORT = "AcidsBases_ReproductionPlants_ComparingQuantities_Symmetry"
TITLE = ("Acids, Bases & Salts · Reproduction in Plants · "
         "Comparing Quantities · Symmetry")
LABELS = {
    "AB": "Acids, Bases & Salts",
    "RP": "Reproduction in Plants",
    "CQ": "Comparing Quantities",
    "SY": "Symmetry",
}

# ---------- ACIDS, BASES & SALTS (25) — Science (several fused with Maths) ----------
AB = [
 ("AB","A substance that tastes sour and turns blue litmus paper red is classed as an:",
   "acid",
   C("Acids taste sour and turn blue litmus red. Lemon juice and vinegar are everyday examples.")+
   steps("Note the sour taste and the litmus change","blue litmus going red signals an acid","so the substance is an acid.")+
   U("The sour bite of a lemon comes from the citric acid in its juice."),
   [("base","Bases taste bitter and turn red litmus blue; a sour taste with blue→red litmus means an acid."),
    ("salt","A salt is the neutral product of an acid and a base; the sour, litmus-reddening substance is an acid."),
    ("indicator","An indicator only signals acids or bases by changing colour; the sour substance itself is an acid.")]),

 ("AB","A substance that feels soapy, tastes bitter and turns red litmus paper blue is a:",
   "base",
   C("Bases feel slippery, taste bitter and turn red litmus blue. Soap and baking soda solution are common bases.")+
   steps("Note the bitter taste and soapy feel","red litmus turning blue signals a base","so the substance is a base.")+
   U("Wet soap feels slippery between the fingers because soap is a base."),
   [("acid","Acids are sour and turn blue litmus red; a bitter, soapy substance turning red litmus blue is a base."),
    ("salt","A salt is the neutral product of neutralisation; the bitter, soapy, litmus-bluing substance is a base."),
    ("neutral substance","A neutral substance leaves litmus unchanged; this one turns red litmus blue, so it is a base.")]),

 ("AB","A special substance that tells us whether something is acidic or basic by changing its colour is called an:",
   "indicator",
   C("Indicators such as litmus, turmeric and china rose change colour in acids and bases, revealing their nature.")+
   steps("We need to know if a liquid is acidic or basic","a substance that changes colour to show this","is called an indicator.")+
   U("A strip of litmus paper is the simplest indicator in any school lab."),
   [("acid","An acid is one of the things being tested; the colour-changing tester is the indicator."),
    ("base","A base is also something being tested; the substance that signals it by colour is the indicator."),
    ("salt","A salt is a neutral product, not a tester; the colour-changing tester is the indicator.")]),

 ("AB","Natural litmus, the most common laboratory indicator, is extracted from a plant called:",
   "lichen",
   C("Litmus is a purple dye obtained from lichens. It turns red in acids and blue in bases.")+
   steps("Litmus is a natural purple dye","it is drawn from a plant","that plant is the lichen.")+
   U("The litmus strips in a school kit start as a dye squeezed from lichen."),
   [("rose","China rose petals give a different indicator; the source of litmus is the lichen."),
    ("turmeric","Turmeric is its own yellow indicator; litmus comes from the lichen."),
    ("hibiscus","Hibiscus (china rose) is a separate indicator; litmus is extracted from lichen.")]),

 ("AB","When turmeric paper (a yellow indicator) is touched by a base such as soap solution, it turns:",
   "red",
   C("Turmeric stays yellow in acids and neutral liquids but turns red in a base.")+
   steps("Turmeric is yellow to start","a base is added","the yellow turns red, showing a base.")+
   U("A yellow turmeric curry stain on cloth turns reddish where soap (a base) touches it."),
   [("blue","Turmeric does not turn blue; in a base it turns red, while it stays yellow in acid."),
    ("green","Turmeric does not turn green; the base makes it turn red."),
    ("colourless","Turmeric keeps a strong colour; with a base it turns red, not colourless.")]),

 ("AB","The reaction in which an acid and a base cancel each other to give a salt and water is called:",
   "neutralisation",
   C("In neutralisation an acid reacts with a base to form a salt and water, and the mixture becomes neutral.")+
   steps("Mix an acid with a base","they react to give a salt and water","this acid–base cancelling is neutralisation.")+
   U("Taking an antacid neutralises extra acid in the stomach, easing the burning feeling."),
   [("evaporation","Evaporation is water turning to vapour, not an acid–base reaction; that is neutralisation."),
    ("respiration","Respiration is how living things release energy; the acid–base reaction is neutralisation."),
    ("oxidation","Oxidation is reaction with oxygen; an acid cancelling a base is neutralisation.")]),

 ("AB","A person with acidity in the stomach is given a mild base to ease the pain. Such a medicine is called an:",
   "antacid",
   C("Antacids are mild bases (like milk of magnesia) that neutralise the excess hydrochloric acid in the stomach.")+
   steps("Excess stomach acid causes the burning","a mild base is taken to neutralise it","this base medicine is an antacid.")+
   U("A spoon of milk of magnesia settles an acidic, upset stomach by neutralising the acid."),
   [("an indicator","An indicator only reveals acid or base; the base medicine that neutralises stomach acid is an antacid."),
    ("a vitamin","A vitamin is a nutrient, not an acid neutraliser; the stomach-acid remedy is an antacid."),
    ("a salt solution","A neutral salt would not cancel the acid; a mild base — an antacid — is used.")]),

 ("AB","An ant's sting injects formic acid into the skin. Rubbing on baking soda (a mild base) helps because it:",
   "neutralises the acid",
   C("Baking soda is a mild base, so it neutralises the formic acid of the sting, relieving the burning.")+
   steps("The sting leaves an acid in the skin","a mild base, baking soda, is rubbed on","it neutralises the acid and eases the pain.")+
   U("Dabbing baking soda paste on a bee or ant sting calms the burning by neutralising the acid."),
   [("adds more acid to the skin","Adding acid would worsen the sting; baking soda is a base that neutralises the acid."),
    ("cools the skin like ice","The relief is chemical, not just cooling; the base neutralises the sting's acid."),
    ("washes the dirt away","Cleaning alone would not stop the burn; the base neutralises the injected acid.")]),

 ("AB","A field whose soil has become too acidic for crops is treated by the farmer with:",
   "a base such as lime (quicklime)",
   C("Acidic soil is corrected by adding a base — slaked lime or quicklime — which neutralises the excess acid.")+
   steps("The soil is too acidic for crops","a base is spread to cancel the acid","lime (a base) neutralises and balances the soil.")+
   U("Farmers spread lime over sour, acidic fields so crops grow well again."),
   [("more acid such as vinegar","Adding acid makes acidic soil worse; a base like lime is needed to neutralise it."),
    ("plain sand","Sand changes texture, not acidity; a base such as lime neutralises the excess acid."),
    ("table salt","A neutral salt will not fix acidity; a base like lime is used to neutralise the soil.")]),

 ("AB","The sour taste of lemons, oranges and other citrus fruits is due to the presence of:",
   "citric acid",
   C("Citrus fruits contain citric acid, which gives them their sharp, sour taste.")+
   steps("Citrus fruits taste sour","the sourness comes from an acid","that acid is citric acid.")+
   U("A squeeze of lemon adds a sour kick to food because of its citric acid."),
   [("acetic acid","Acetic acid gives vinegar its sourness; the sour taste of citrus fruits is citric acid."),
    ("lactic acid","Lactic acid sours curd and milk; in lemons and oranges the acid is citric acid."),
    ("hydrochloric acid","Hydrochloric acid is found in the stomach, not in fruit; citrus sourness is citric acid.")]),

 ("AB","Vinegar, used in pickles and cooking, gets its sharp sour taste from:",
   "acetic acid",
   C("Vinegar is a dilute solution of acetic acid, which gives it a sour, sharp taste and smell.")+
   steps("Vinegar tastes and smells sour","this comes from an acid","in vinegar that acid is acetic acid.")+
   U("Pickles keep longer in vinegar because its acetic acid stops spoilage."),
   [("citric acid","Citric acid is the acid of citrus fruits; vinegar's acid is acetic acid."),
    ("tartaric acid","Tartaric acid is found in tamarind and grapes; vinegar contains acetic acid."),
    ("formic acid","Formic acid is in ant stings; the acid that sours vinegar is acetic acid.")]),

 ("AB","Curd and sour milk taste sour because, as they ferment, bacteria produce:",
   "lactic acid",
   C("When milk turns to curd, bacteria produce lactic acid, which gives curd its sour taste.")+
   steps("Milk ferments into curd","bacteria make an acid as it sets","that acid is lactic acid, giving the sour taste.")+
   U("Curd left out grows more sour as bacteria keep making lactic acid."),
   [("citric acid","Citric acid is the acid of citrus fruits; curd's sourness is lactic acid."),
    ("acetic acid","Acetic acid sours vinegar; the sourness of curd comes from lactic acid."),
    ("hydrochloric acid","Hydrochloric acid is a stomach acid; the acid formed in curd is lactic acid.")]),

 ("AB","The strong acid that our own stomach makes to help digest food and kill germs is:",
   "hydrochloric acid",
   C("The stomach produces hydrochloric acid, which aids digestion and destroys swallowed germs.")+
   steps("The stomach secretes a digestive acid","it is a strong acid that kills germs","this is hydrochloric acid.")+
   U("Eating too much can leave the stomach making extra hydrochloric acid, causing acidity."),
   [("citric acid","Citric acid is found in fruits, not made by the stomach; the stomach makes hydrochloric acid."),
    ("acetic acid","Acetic acid is in vinegar; the digestive acid of the stomach is hydrochloric acid."),
    ("lactic acid","Lactic acid forms in curd and muscles; the stomach's digestive acid is hydrochloric acid.")]),

 ("AB","Lime water, used to test for carbon dioxide, is a solution of the base:",
   "calcium hydroxide",
   C("Lime water is a solution of calcium hydroxide, a base that turns milky when carbon dioxide is passed through it.")+
   steps("Lime water is a clear basic solution","its base is calcium hydroxide","so lime water is calcium hydroxide solution.")+
   U("Blowing through a straw into lime water turns it milky, showing the carbon dioxide you breathe out."),
   [("hydrochloric acid","Hydrochloric acid is an acid, not the base in lime water, which is calcium hydroxide."),
    ("sodium chloride","Sodium chloride is common salt, a neutral substance; lime water's base is calcium hydroxide."),
    ("citric acid","Citric acid is an acid from fruit; lime water is a solution of the base calcium hydroxide.")]),

 ("AB","Which of these is a NEUTRAL substance that changes the colour of neither red nor blue litmus?",
   "common salt solution",
   C("A neutral substance is neither acidic nor basic, so it leaves both red and blue litmus unchanged. Salt solution and pure water are neutral.")+
   steps("Test with both red and blue litmus","a neutral substance changes neither","common salt solution is neutral.")+
   U("Plain salt water tastes neither sour nor bitter and leaves litmus unchanged — it is neutral."),
   [("lemon juice","Lemon juice is acidic and turns blue litmus red; the neutral one is salt solution."),
    ("soap solution","Soap solution is basic and turns red litmus blue; the neutral choice is salt solution."),
    ("vinegar","Vinegar is acidic and reddens blue litmus; salt solution is the neutral substance.")]),

 ("AB","Factory waste water is often acidic. Before it is let into a river, it is first treated with a base to:",
   "neutralise it and make it safe",
   C("Acidic factory waste would harm river life, so a base is added to neutralise it before release.")+
   steps("The waste water is harmfully acidic","a base is added to cancel the acid","neutralised water is safer for the river.")+
   U("Treatment plants add a base to acidic effluent so the water entering a river will not kill fish."),
   [("make it more acidic","Adding acid would make the waste more harmful; a base is added to neutralise it."),
    ("turn it into a salt crystal","The aim is safe water, not crystals; a base neutralises the acidic waste."),
    ("colour it with an indicator","Indicators only test acidity; treatment uses a base to neutralise the waste.")]),

 ("AB","Toothpastes are usually mildly basic. They protect teeth by neutralising the acids that:",
   "bacteria make from leftover food",
   C("Mouth bacteria turn leftover food into acids that attack teeth; basic toothpaste neutralises these acids.")+
   steps("Bacteria turn food bits into acids","these acids attack the teeth","a basic toothpaste neutralises them, protecting teeth.")+
   U("Brushing with toothpaste after meals neutralises mouth acids and helps prevent cavities."),
   [("the toothbrush bristles release","Bristles only scrub; the harmful acids come from bacteria acting on food, and toothpaste neutralises them."),
    ("flow in from drinking water","Tap water is roughly neutral; the tooth-attacking acids are made by bacteria from food."),
    ("the toothpaste itself contains","Toothpaste is basic, not acidic; it neutralises the acids bacteria make from food.")]),

 ("AB","A 200 g sample of dilute acid solution is 15% acid by mass. The mass of pure acid in it is:",
   "30 g",
   C("A percentage by mass means that fraction of the total mass is the acid: mass of acid = percent × total mass.")+
   steps("15% of 200 g = (15 ÷ 100) × 200","= 0.15 × 200","= 30 g of pure acid.")+
   U("A chemist reads a bottle labelled '15% acid' and multiplies by the mass to find the pure acid inside."),
   [("15 g","15 g uses the percent as if the sample were 100 g; 15% of 200 g is 30 g."),
    ("185 g","185 g is the water part (the other 85%); the acid is 15% of 200 g = 30 g."),
    ("3000 g","That forgets to divide by 100; 15% of 200 g = 0.15 × 200 = 30 g.")]),

 ("AB","In a neutralisation, acid and base are mixed in the ratio 2 : 3. To use 40 mL of acid, the base needed is:",
   "60 mL",
   C("Keep the ratio fixed. If 2 parts acid go with 3 parts base, each part here is 40 ÷ 2 = 20 mL, so the base is 3 parts.")+
   steps("Ratio acid : base = 2 : 3","one part = 40 ÷ 2 = 20 mL","base = 3 × 20 = 60 mL.")+
   U("A lab technician scaling up a neutralisation keeps the acid-to-base ratio so the mix stays exactly neutral."),
   [("26.7 mL","That uses the ratio upside down (40 × 2 ÷ 3); for 2 : 3 the base is 40 ÷ 2 × 3 = 60 mL."),
    ("40 mL","Equal volumes ignore the 2 : 3 ratio; the base must be 60 mL to keep the ratio."),
    ("120 mL","That triples the acid instead of scaling by parts; the base is 3 × 20 = 60 mL.")]),

 ("AB","Of 250 liquid samples tested with litmus, 40% turned blue litmus red. The number of acidic samples is:",
   "100",
   C("Acidic samples turn blue litmus red. Find 40% of the total number of samples.")+
   steps("40% of 250 = (40 ÷ 100) × 250","= 0.40 × 250","= 100 acidic samples.")+
   U("A water-quality survey reports the share of acidic samples as a percentage of all those tested."),
   [("40","40 just repeats the percent figure; 40% of 250 is 0.40 × 250 = 100 samples."),
    ("150","150 is the 60% that were not acidic; the acidic share is 40% of 250 = 100."),
    ("210","210 subtracts 40 from 250; 40% of 250 means 0.40 × 250 = 100.")]),

 ("AB","The salt formed when hydrochloric acid is exactly neutralised by the base sodium hydroxide is:",
   "sodium chloride (common salt)",
   C("Acid + base → salt + water. Hydrochloric acid with sodium hydroxide gives sodium chloride and water.")+
   steps("Combine hydrochloric acid and sodium hydroxide","the metal of the base joins the acid's part","forming sodium chloride — common salt — and water.")+
   U("The common salt on the table can be made by neutralising hydrochloric acid with sodium hydroxide."),
   [("sodium hydroxide","Sodium hydroxide is the base used up in the reaction; the salt produced is sodium chloride."),
    ("hydrochloric acid","Hydrochloric acid is the acid that reacts; the salt formed is sodium chloride."),
    ("calcium carbonate","Calcium carbonate needs different reactants; hydrochloric acid plus sodium hydroxide gives sodium chloride.")]),

 ("AB","China rose indicator turns dark pink (magenta) in acids and green in bases. Dipped in soap solution, it turns:",
   "green",
   C("China rose extract goes dark pink in an acid and green in a base. Soap solution is basic, so it turns green.")+
   steps("Recall: china rose is green in a base","soap solution is basic","so the indicator turns green.")+
   U("Testing window-cleaner (a base) with china rose indicator gives a green colour."),
   [("dark pink (magenta)","Dark pink shows an acid; soap solution is basic, so china rose turns green."),
    ("blue","China rose does not turn blue; in a base it turns green and in an acid dark pink."),
    ("colourless","China rose keeps a clear colour; in the basic soap solution it turns green.")]),

 ("AB","A bottle reads '25% acid by mass'. To get 50 g of pure acid, the total mass of solution you must take is:",
   "200 g",
   C("If 25% of the mass is acid, then the pure acid is one-quarter of the total; reverse it: total = acid ÷ percent.")+
   steps("25% of total = 50 g, so total × 0.25 = 50","total = 50 ÷ 0.25","= 200 g of solution.")+
   U("To collect a fixed mass of pure acid, a chemist works backward from the percentage on the label."),
   [("12.5 g","12.5 g is 25% of 50, going the wrong way; you need total = 50 ÷ 0.25 = 200 g."),
    ("75 g","75 g just adds 50 + 25; reverse the percent: total = 50 ÷ 0.25 = 200 g."),
    ("1250 g","That multiplies 50 × 25; dividing by the fraction gives 50 ÷ 0.25 = 200 g.")]),

 ("AB","Blue litmus is dipped into four liquids. It stays blue in all but one, where it turns red. That liquid is:",
   "the only acidic one",
   C("Blue litmus turns red only in an acid. The single liquid that reddens it is the acidic one; the rest are basic or neutral.")+
   steps("Blue litmus reddens only in acid","three liquids leave it blue (basic or neutral)","the one turning it red is the acidic liquid.")+
   U("Testing several household liquids, only the acidic one (like vinegar) turns blue litmus red."),
   [("the only basic one","A base leaves blue litmus blue; the liquid that turns it red is the acidic one."),
    ("the only neutral one","A neutral liquid leaves blue litmus unchanged; the reddening one is acidic."),
    ("the most dilute one","Dilution is not the test; blue litmus turning red marks the acidic liquid.")]),

 ("AB","Two acidic solutions are compared. Solution X is 10% acid by mass and Solution Y is 25% acid by mass. The stronger acid solution is:",
   "Solution Y",
   C("A higher percentage of acid by mass means more acid in the same amount of liquid, so the solution is more concentrated (stronger).")+
   steps("Compare the percentages: 10% vs 25%","25% packs more acid into the same mass","so Solution Y is the stronger acid solution.")+
   U("Reading the percentage on two acid bottles tells you at a glance which is more concentrated."),
   [("Solution X","X is only 10% acid, weaker than Y's 25%; the higher percentage, Y, is stronger."),
    ("both are equal","10% and 25% are different concentrations, so they are not equal; Y is stronger."),
    ("neither can be compared","Percentages by mass compare directly; 25% > 10%, so Solution Y is stronger.")]),
]

# ---------- REPRODUCTION IN PLANTS (25) — Science (several fused with Maths) ----------
RP = [
 ("RP","The life process by which living things produce new individuals of their own kind is called:",
   "reproduction",
   C("Reproduction is how organisms make new members of their own species, keeping life going from one generation to the next.")+
   steps("Living things must produce offspring","making new individuals of the same kind","is the process called reproduction.")+
   U("A mango tree dropping seeds that grow into new mango trees is reproduction in action."),
   [("respiration","Respiration releases energy from food; making new individuals is reproduction."),
    ("germination","Germination is just a seed sprouting; the whole making of new individuals is reproduction."),
    ("transpiration","Transpiration is water loss from leaves; producing offspring is reproduction.")]),

 ("RP","Reproduction in which a new plant arises from a single parent, without flowers, seeds or fusion, is:",
   "asexual reproduction",
   C("Asexual reproduction needs only one parent and no fusion of gametes; the offspring are produced from the parent's own cells.")+
   steps("Only one parent is involved","no flowers, seeds or fusion take part","this single-parent way is asexual reproduction.")+
   U("A new potato plant sprouting from the 'eyes' of one potato is asexual reproduction."),
   [("sexual reproduction","Sexual reproduction needs two gametes fusing, usually via flowers; the single-parent way is asexual."),
    ("pollination","Pollination is one step in the sexual route; reproduction from a single parent is asexual."),
    ("fertilisation","Fertilisation is the fusion of gametes in sexual reproduction; the one-parent way is asexual.")]),

 ("RP","Growing a new plant from a root, stem or leaf of the parent plant (as in potato or rose) is called:",
   "vegetative propagation",
   C("In vegetative propagation a new plant grows from a vegetative part — root, stem or leaf — of the parent. It is a kind of asexual reproduction.")+
   steps("Take a root, stem or leaf of the parent","it grows into a whole new plant","this is vegetative propagation.")+
   U("Gardeners grow new rose bushes by planting stem cuttings — vegetative propagation."),
   [("spore formation","Spore formation makes tiny spores in fungi and ferns; growing from a stem or leaf is vegetative propagation."),
    ("budding","Budding is an outgrowth pinching off, as in yeast; growing from a plant part is vegetative propagation."),
    ("pollination","Pollination moves pollen in the sexual route; growing from roots, stems or leaves is vegetative propagation.")]),

 ("RP","In yeast, a small bulge grows on the parent cell, enlarges and finally separates as a new individual. This is:",
   "budding",
   C("In budding a small outgrowth (bud) forms on the parent, grows, and detaches to live as a new organism.")+
   steps("A small bud appears on the parent cell","it grows and then pinches off","this single-parent process is budding.")+
   U("Under a microscope, yeast in dough shows tiny buds pinching off to form new cells."),
   [("fragmentation","Fragmentation is a body breaking into pieces that each grow; yeast forms a bud, so it is budding."),
    ("spore formation","Spore formation scatters tiny spores; a bulge pinching off the parent is budding."),
    ("fertilisation","Fertilisation fuses two gametes; a bud growing and detaching from one parent is budding.")]),

 ("RP","Spirogyra, a green water plant, breaks into pieces that each grow into a new plant. This way of reproducing is:",
   "fragmentation",
   C("In fragmentation the body breaks into fragments, and each fragment grows into a complete new individual.")+
   steps("The plant breaks into separate pieces","each piece grows into a whole new plant","this is fragmentation.")+
   U("Pond scum (Spirogyra) spreads quickly because broken bits each grow into new threads."),
   [("budding","Budding is an outgrowth pinching off one parent; breaking into pieces that each grow is fragmentation."),
    ("pollination","Pollination transfers pollen in flowering plants; breaking into growing pieces is fragmentation."),
    ("germination","Germination is a seed sprouting; a plant breaking into pieces that grow is fragmentation.")]),

 ("RP","Ferns and many fungi reproduce by making tiny, light reproductive units that scatter in the air, called:",
   "spores",
   C("Spores are tiny reproductive units that can grow into new plants. Ferns, mosses and fungi spread by spores.")+
   steps("Ferns and fungi make minute reproductive units","these are light and scatter in air","such units are called spores.")+
   U("Bread mould spreads through a kitchen as countless spores drift through the air."),
   [("seeds","Seeds form after fertilisation in flowering plants; ferns and fungi spread by tiny spores."),
    ("buds","Buds are outgrowths that pinch off, as in yeast; ferns and fungi scatter spores."),
    ("gametes","Gametes are the sex cells that fuse; the airborne reproductive units of ferns and fungi are spores.")]),

 ("RP","The male reproductive part of a flower, which produces pollen grains, is the:",
   "stamen",
   C("The stamen is the male part of a flower. Its anther makes pollen, held up by the filament.")+
   steps("Find the part that makes pollen","it has an anther on a filament","this male part is the stamen.")+
   U("Brushing past a lily, yellow pollen from its stamens dusts your clothes."),
   [("pistil","The pistil is the female part with the ovary; the pollen-making male part is the stamen."),
    ("petal","Petals are the coloured leaves that attract insects, not the pollen-maker; that is the stamen."),
    ("sepal","Sepals are the small green leaves protecting the bud; the male pollen part is the stamen.")]),

 ("RP","The female reproductive part of a flower, made of stigma, style and ovary, is the:",
   "pistil (carpel)",
   C("The pistil (carpel) is the flower's female part: the stigma catches pollen, the style connects down to the ovary, which holds the ovules.")+
   steps("Find the part with stigma, style and ovary","this part receives pollen and holds ovules","it is the female pistil (carpel).")+
   U("Inside a flower the central pistil swells into the fruit once its ovules are fertilised."),
   [("stamen","The stamen is the male part that makes pollen; the female part with the ovary is the pistil."),
    ("petal","Petals attract pollinators; the female stigma-style-ovary part is the pistil."),
    ("filament","The filament is the stalk of the male stamen; the female part is the pistil.")]),

 ("RP","Moving pollen grains from a flower's anther onto a stigma, the step before fertilisation, is named:",
   "pollination",
   C("Pollination is the movement of pollen from the anther (male) to the stigma (female), the step before fertilisation.")+
   steps("Pollen leaves the anther","it lands on a stigma","this transfer of pollen is pollination.")+
   U("A bee crawling over flowers carries pollen between them, performing pollination."),
   [("fertilisation","Fertilisation is the later fusion of male and female gametes; moving pollen to the stigma is pollination."),
    ("germination","Germination is a seed or pollen starting to grow; the transfer of pollen itself is pollination."),
    ("dispersal","Dispersal scatters seeds away from the parent; moving pollen to the stigma is pollination.")]),

 ("RP","When pollen from a flower's anther reaches the stigma of a DIFFERENT flower, the pollination is called:",
   "cross-pollination",
   C("Cross-pollination carries pollen from one flower to the stigma of another flower (often on another plant); within the same flower it is self-pollination.")+
   steps("Pollen moves to a stigma","but on a different flower","so it is cross-pollination.")+
   U("Insects flying between separate flowers bring about cross-pollination, mixing the plants' traits."),
   [("self-pollination","Self-pollination keeps pollen within the same flower; reaching a different flower is cross-pollination."),
    ("fertilisation","Fertilisation is the fusion of gametes after pollination; pollen reaching another flower is cross-pollination."),
    ("germination","Germination is sprouting, not pollen transfer; pollen reaching a different flower is cross-pollination.")]),

 ("RP","The fusion of the male gamete from a pollen grain with the female gamete (egg) inside the ovule is called:",
   "fertilisation",
   C("Fertilisation is the joining of the male gamete and the female gamete to form a zygote, which grows into a new plant.")+
   steps("A pollen grain delivers the male gamete to the ovule","it fuses with the egg (female gamete)","this fusion is fertilisation, forming a zygote.")+
   U("Only after fertilisation does a flower's ovule begin to grow into a seed."),
   [("pollination","Pollination only delivers pollen to the stigma; the fusion of gametes that follows is fertilisation."),
    ("germination","Germination is a seed sprouting later; the fusion of gametes is fertilisation."),
    ("budding","Budding is an asexual outgrowth; the fusion of male and female gametes is fertilisation.")]),

 ("RP","After fertilisation, the ovule of a flower develops into a seed, while the ovary grows into the:",
   "fruit",
   C("Once fertilised, each ovule becomes a seed and the whole ovary ripens into the fruit that protects the seeds.")+
   steps("Fertilisation finishes inside the ovary","each ovule turns into a seed","and the ovary itself becomes the fruit.")+
   U("A pea pod is a ripened ovary (the fruit) with the peas inside being the seeds."),
   [("root","The root anchors the plant and is not formed from the ovary; the ovary becomes the fruit."),
    ("flower","The flower came before fertilisation; afterwards the ovary develops into the fruit."),
    ("leaf","Leaves make food and are unrelated to the ovary; the ovary ripens into the fruit.")]),

 ("RP","Light seeds with wings or hair, like those of the drumstick or dandelion, are carried away from the parent mainly by:",
   "wind",
   C("Winged or hairy seeds are light and catch the breeze, so wind carries them far from the parent plant — wind dispersal.")+
   steps("The seed is light with wings or hair","such seeds float on moving air","so they are dispersed by wind.")+
   U("A dandelion 'puff' breaks apart and its feathery seeds drift away on the wind."),
   [("water","Water disperses floating seeds like the coconut; light winged or hairy seeds travel by wind."),
    ("animals","Animals carry hooked or eaten seeds; light winged, hairy seeds are blown by wind."),
    ("bursting of the fruit","Bursting flings seeds a short way; feathery winged seeds are carried far by wind.")]),

 ("RP","Of 200 seeds sown in a tray, 150 sprout into seedlings. The germination percentage is:",
   "75%",
   C("Germination percentage = (seeds that sprouted ÷ seeds sown) × 100.")+
   steps("Sprouted = 150, sown = 200","(150 ÷ 200) × 100","= 0.75 × 100 = 75%.")+
   U("A seed company prints the germination percentage on the packet so farmers know how many will grow."),
   [("150%","A percentage cannot exceed 100% here; it is (150 ÷ 200) × 100 = 75%, not 150%."),
    ("50%","50% would need 100 of 200 to sprout; 150 of 200 gives 75%."),
    ("25%","25% is the share that did NOT sprout (50 of 200); the germination percentage is 75%.")]),

 ("RP","A flower that has both stamens and a pistil — the male and female parts together — is called a:",
   "bisexual flower",
   C("A bisexual (perfect) flower carries both the male stamens and the female pistil in the same flower.")+
   steps("Check for both male and female parts","stamens and a pistil are both present","so it is a bisexual flower.")+
   U("A hibiscus flower is bisexual, holding both its stamens and pistil together."),
   [("unisexual flower","A unisexual flower has only stamens OR only a pistil; one with both is bisexual."),
    ("male flower","A male flower has only stamens; a flower with both stamens and a pistil is bisexual."),
    ("female flower","A female flower has only a pistil; one with both parts is a bisexual flower.")]),

 ("RP","In a garden bed there are 60 marigold plants. If 20% of them die from a disease, the number of plants that die is:",
   "12",
   C("Find 20% of the total number of plants: number dead = percent × total.")+
   steps("20% of 60 = (20 ÷ 100) × 60","= 0.20 × 60","= 12 plants die.")+
   U("A gardener tracking a plant disease records what percentage of the bed was lost."),
   [("20","20 just repeats the percent figure; 20% of 60 plants is 0.20 × 60 = 12."),
    ("48","48 is the 80% that survive; the share that dies is 20% of 60 = 12."),
    ("40","40 mis-multiplies; 20% of 60 means 0.20 × 60 = 12 plants.")]),

 ("RP","The 'eyes' on a potato are buds that can sprout into new plants. Growing potatoes from these eyes is an example of:",
   "vegetative propagation",
   C("The eyes of a potato are buds on the underground stem (tuber); each can grow into a new plant, a form of vegetative propagation.")+
   steps("A potato's eyes are tiny buds","planted, each bud grows a new plant","this single-parent way is vegetative propagation.")+
   U("Farmers plant cut pieces of potato, each with an eye, to raise the next potato crop."),
   [("seed germination","No seed is used here; the new plant grows from a bud on the tuber — vegetative propagation."),
    ("pollination","Pollination moves pollen between flowers; growing potatoes from eyes is vegetative propagation."),
    ("spore formation","Spores belong to ferns and fungi; potatoes sprout from buds by vegetative propagation.")]),

 ("RP","A Bryophyllum leaf placed on moist soil sprouts tiny new plants along its notched edges. This shows reproduction by:",
   "leaves (vegetative propagation)",
   C("Bryophyllum grows buds in the notches of its leaves; each bud can root and form a new plant — vegetative propagation from a leaf.")+
   steps("Buds form in the leaf's notches","each bud drops and roots in the soil","so the leaf gives new plants by vegetative propagation.")+
   U("A fallen Bryophyllum leaf can carpet a damp pot with tiny new plantlets."),
   [("seeds","No seed is involved; the new plants grow from buds on the leaf — vegetative propagation."),
    ("spores","Spores belong to ferns and fungi; Bryophyllum sprouts plantlets from its leaf buds."),
    ("pollen grains","Pollen is for sexual reproduction in flowers; the leaf buds show vegetative propagation.")]),

 ("RP","In a field the ratio of male (pollen-bearing) flowers to female flowers on the plants is 3 : 2. If there are 30 male flowers, the female flowers number:",
   "20",
   C("Keep the ratio. With male : female = 3 : 2, each part = 30 ÷ 3 = 10, so female flowers = 2 parts.")+
   steps("Ratio male : female = 3 : 2","one part = 30 ÷ 3 = 10 flowers","female = 2 × 10 = 20 flowers.")+
   U("A botanist counting flower types on a plant uses their ratio to estimate one count from the other."),
   [("45","45 scales the wrong way (30 × 3 ÷ 2); for 3 : 2 the female count is 30 ÷ 3 × 2 = 20."),
    ("30","Equal numbers ignore the 3 : 2 ratio; the female flowers number 20."),
    ("12","12 misreads the parts; with 30 males at 3 parts, 2 parts give 20 female flowers.")]),

 ("RP","A coconut can float across the sea and sprout on a far shore. Its seed is mainly dispersed by:",
   "water",
   C("Coconuts have a light, fibrous husk that lets them float, so ocean water carries them to new shores — water dispersal.")+
   steps("The coconut floats because of its husk","sea water carries it far away","so the coconut is dispersed by water.")+
   U("Coconut palms grow on distant beaches because the nuts drifted there on ocean currents."),
   [("wind","A heavy coconut cannot be blown by wind; its floating husk lets water carry it."),
    ("animals","Animals do not haul coconuts across the sea; the floating nut is dispersed by water."),
    ("bursting of the fruit","A coconut does not burst to scatter; it floats, so it is dispersed by water.")]),

 ("RP","A money plant or rose is commonly grown by planting a piece of its stem in soil. This piece is called a:",
   "cutting",
   C("A cutting is a piece of stem (with a bud or two) planted to grow roots and become a new plant — a common vegetative method.")+
   steps("Take a short length of the parent stem","plant it so it grows its own roots","this planted stem piece is a cutting.")+
   U("A snipped money-plant stem placed in water soon grows roots and becomes a new plant."),
   [("spore","Spores are tiny reproductive units of ferns and fungi; a planted stem piece is a cutting."),
    ("seed","A seed forms after fertilisation; a piece of stem planted to grow is a cutting."),
    ("gamete","A gamete is a sex cell; the stem piece used to grow a new plant is a cutting.")]),

 ("RP","Out of 400 seeds tested, 70% germinate. The number of seeds that did NOT germinate is:",
   "120",
   C("If 70% germinate, then 30% do not. Find 30% of the total seeds.")+
   steps("Not germinated = 100% − 70% = 30%","30% of 400 = 0.30 × 400","= 120 seeds did not germinate.")+
   U("A seed lab reports both the germination percentage and, by subtraction, the share that failed."),
   [("280","280 is the 70% that DID germinate; the share that did not is 30% of 400 = 120."),
    ("70","70 just repeats the germination percent; 30% of 400 seeds is 120."),
    ("30","30 is only the leftover percent figure; applied to 400 seeds it gives 120.")]),

 ("RP","Why does a flowering plant produce far more pollen grains and seeds than the number of new plants that finally grow?",
   "many are lost, so extra numbers improve the chance some survive",
   C("Most pollen and seeds are lost to wind, water, animals or poor conditions, so plants make a large surplus to ensure at least some succeed.")+
   steps("Pollen and seeds face many dangers and waste","only a few reach the right place to grow","so making extra raises the chance of survival.")+
   U("A single poppy makes thousands of seeds because only a handful will land somewhere they can grow."),
   [("the extra pollen and seeds are simply waste with no purpose","They are not pointless; the surplus raises the chance that some pollen and seeds will survive."),
    ("plants cannot control how many they make","Plants produce a large, adaptive surplus on purpose; it improves survival, not from lack of control."),
    ("more seeds always means heavier fruit only","The reason is survival odds, not fruit weight; the surplus offsets heavy losses.")]),

 ("RP","Burr seeds with tiny hooks that cling to an animal's fur and are carried far away are dispersed by:",
   "animals",
   C("Hooked or sticky seeds catch on animal fur (or are eaten and dropped elsewhere), so animals carry them away — animal dispersal.")+
   steps("The seed has hooks that grip fur","an animal carries it as it moves","so the seed is dispersed by animals.")+
   U("Sticky burrs caught on a dog's coat are seeds hitching a ride to a new spot."),
   [("wind","Heavy hooked burrs are not blown by wind; clinging to fur, they are dispersed by animals."),
    ("water","These hooked seeds grip fur rather than float; they are dispersed by animals."),
    ("bursting of the fruit","No bursting is involved; the hooks let animals carry the seeds away.")]),

 ("RP","The sticky tip of the pistil, on which pollen grains land during pollination, is called the:",
   "stigma",
   C("The stigma is the sticky top of the pistil; it catches and holds the pollen grains brought during pollination.")+
   steps("Find the top of the female pistil","it is sticky to trap pollen","this pollen-catching tip is the stigma.")+
   U("Pollen brushed off a bee sticks to the flower's stigma, beginning the path to fertilisation."),
   [("anther","The anther is the pollen-MAKING tip of the male stamen; the pollen-CATCHING tip of the pistil is the stigma."),
    ("ovary","The ovary is the swollen base of the pistil holding the ovules; the sticky pollen-catching tip is the stigma."),
    ("filament","The filament is the stalk of the male stamen; the sticky tip of the pistil is the stigma.")]),
]

# ---------- COMPARING QUANTITIES (25) — Maths (several fused with Science) ----------
CQ = [
 ("CQ","A comparison of two quantities of the same kind by division, written with a colon, is called a:",
   "ratio",
   C("A ratio compares two like quantities by division, written a : b, and tells how many times one is of the other.")+
   steps("Two quantities of the same kind are compared","the comparison is done by dividing one by the other","this is a ratio, written a : b.")+
   U("Mixing juice as 1 part syrup to 4 parts water is using a ratio."),
   [("percentage","A percentage compares a quantity to 100; comparing two like quantities by division is a ratio."),
    ("perimeter","Perimeter is the boundary length of a shape, not a comparison; comparing by division is a ratio."),
    ("average","An average is a central value of several numbers; comparing two quantities by division is a ratio.")]),

 ("CQ","When reduced to lowest terms by dividing out the common factor, the ratio 4 : 6 becomes:",
   "2 : 3",
   C("Simplify a ratio by dividing both numbers by their highest common factor.")+
   steps("4 : 6 — both share the factor 2","divide each by 2: 4 ÷ 2 and 6 ÷ 2","gives 2 : 3, the simplest form.")+
   U("A recipe of 4 cups flour to 6 cups milk is the same as 2 : 3 when scaled down."),
   [("4 : 6","4 : 6 is not in lowest terms; dividing both by 2 gives 2 : 3."),
    ("3 : 2","3 : 2 reverses the order; 4 : 6 simplifies to 2 : 3, keeping the order."),
    ("6 : 4","6 : 4 swaps the numbers and is unsimplified; 4 : 6 in lowest terms is 2 : 3.")]),

 ("CQ","The word 'per cent' means 'out of a hundred'. So 7% as a fraction is:",
   "7/100",
   C("A percentage is a number out of 100, so x% = x/100.")+
   steps("Per cent means 'out of 100'","write 7 over 100","7% = 7/100.")+
   U("A label saying '7% fruit' means 7 parts in every 100 are fruit."),
   [("7/10","7/10 is 70%, ten times too big; 7% means 7 out of 100 = 7/100."),
    ("100/7","100/7 flips the fraction; 7% is 7 out of 100, written 7/100."),
    ("7","7 alone drops the 'out of a hundred'; 7% means 7/100.")]),

 ("CQ","The fraction 1/4 written as a percentage is:",
   "25%",
   C("To turn a fraction into a percentage, multiply it by 100.")+
   steps("1/4 × 100","= 100 ÷ 4","= 25, so 1/4 = 25%.")+
   U("Saying a quarter of the class is absent is the same as saying 25% are absent."),
   [("4%","4% is wrong; 1/4 means one part of four, which is 25% of the whole."),
    ("14%","14% misreads the fraction; 1/4 × 100 = 25%."),
    ("40%","40% would be 2/5; one-fourth is 1/4 × 100 = 25%.")]),

 ("CQ","The decimal 0.35 written as a percentage is:",
   "35%",
   C("To change a decimal to a percentage, multiply by 100 (move the point two places right).")+
   steps("0.35 × 100","move the decimal two places right","= 35%.")+
   U("A test score of 0.35 of the marks is the same as scoring 35%."),
   [("3.5%","3.5% moves the point only one place; 0.35 × 100 = 35%."),
    ("0.35%","0.35% forgets to multiply by 100; 0.35 as a percent is 35%."),
    ("350%","350% moves the point too far; 0.35 × 100 = 35%.")]),

 ("CQ","Taking twenty per cent of the number one hundred and fifty gives:",
   "30",
   C("'Of' means multiply: x% of a number = (x ÷ 100) × number.")+
   steps("20% of 150 = (20 ÷ 100) × 150","= 0.20 × 150","= 30.")+
   U("A 20% deposit on a ₹150 item is ₹30 paid up front."),
   [("3","3 divides by 100 once too often; 20% of 150 is 0.20 × 150 = 30."),
    ("130","130 subtracts 20 from 150; 20% of 150 means 0.20 × 150 = 30."),
    ("300","300 multiplies 150 by 2; 20% of 150 is 30.")]),

 ("CQ","An article bought for ₹400 (cost price) is sold for ₹500 (selling price). The profit is:",
   "₹100",
   C("Profit = selling price − cost price, when the selling price is the larger.")+
   steps("Selling price = ₹500, cost price = ₹400","profit = 500 − 400","= ₹100.")+
   U("A shopkeeper finds the profit on an item by subtracting what it cost from what it sold for."),
   [("₹900","₹900 adds the two prices; profit is selling price − cost price = 500 − 400 = ₹100."),
    ("₹500","₹500 is the selling price itself; the profit is 500 − 400 = ₹100."),
    ("₹25","₹25 looks like a percent; the actual profit in rupees is 500 − 400 = ₹100.")]),

 ("CQ","An item costing ₹250 is sold for ₹200. This is a:",
   "loss of ₹50",
   C("When the selling price is less than the cost price, there is a loss = cost price − selling price.")+
   steps("Cost price = ₹250, selling price = ₹200","selling price is lower, so it is a loss","loss = 250 − 200 = ₹50.")+
   U("Selling old stock below cost gives a shopkeeper a loss, found by subtracting."),
   [("profit of ₹50","Selling below cost is a loss, not a profit; the loss is 250 − 200 = ₹50."),
    ("loss of ₹450","₹450 adds the prices; the loss is cost − selling = 250 − 200 = ₹50."),
    ("no profit and no loss","Since the prices differ, there is a loss of ₹50, not a break-even.")]),

 ("CQ","A shopkeeper buys a toy for ₹200 and sells it at a 10% profit. The selling price is:",
   "₹220",
   C("Profit = percent of cost price; add it to the cost price to get the selling price.")+
   steps("Profit = 10% of 200 = ₹20","selling price = 200 + 20","= ₹220.")+
   U("Pricing goods 'at 10% profit' means adding 10% of the cost to the cost itself."),
   [("₹210","₹210 adds only ₹10; 10% of ₹200 is ₹20, giving ₹220."),
    ("₹180","₹180 subtracts the profit; a 10% profit raises ₹200 to ₹220."),
    ("₹2000","₹2000 multiplies by 10; a 10% profit adds ₹20, giving ₹220.")]),

 ("CQ","A sum of ₹1000 is kept for 2 years at 5% per year. The simple interest earned is:",
   "₹100",
   C("Simple interest = (Principal × Rate × Time) ÷ 100.")+
   steps("SI = (1000 × 5 × 2) ÷ 100","= 10000 ÷ 100","= ₹100.")+
   U("A bank works out the interest you earn using principal × rate × time ÷ 100."),
   [("₹50","₹50 uses only 1 year; for 2 years SI = (1000 × 5 × 2) ÷ 100 = ₹100."),
    ("₹1100","₹1100 is the amount (principal + interest); the interest alone is ₹100."),
    ("₹200","₹200 doubles the rate or drops the ÷100 step; SI = (1000 × 5 × 2) ÷ 100 = ₹100.")]),

 ("CQ","A water sample is 30% salt by mass. In 500 g of this water, the mass of salt is:",
   "150 g",
   C("A percentage by mass gives that share of the total mass: salt = percent × total mass.")+
   steps("30% of 500 g = (30 ÷ 100) × 500","= 0.30 × 500","= 150 g of salt.")+
   U("A scientist testing sea water multiplies its salt percentage by the sample mass to find the salt present."),
   [("30 g","30 g uses the percent as if the sample were 100 g; 30% of 500 g is 150 g."),
    ("350 g","350 g is the water part (the other 70%); the salt is 30% of 500 g = 150 g."),
    ("15000 g","That forgets to divide by 100; 30% of 500 g = 0.30 × 500 = 150 g.")]),

 ("CQ","A shirt marked ₹800 is sold at a 25% discount. The discount amount is:",
   "₹200",
   C("A discount is a percentage of the marked price: discount = percent × marked price.")+
   steps("25% of 800 = (25 ÷ 100) × 800","= 0.25 × 800","= ₹200 off.")+
   U("A '25% off' tag on an ₹800 shirt takes ₹200 off the price at the counter."),
   [("₹600","₹600 is the price after the discount; the discount itself is 25% of 800 = ₹200."),
    ("₹25","₹25 just repeats the percent figure; 25% of ₹800 is ₹200."),
    ("₹775","₹775 subtracts only ₹25; the discount is 25% of 800 = ₹200.")]),

 ("CQ","The ratio 3 : 5 expressed as a percentage of the first quantity to the total is:",
   "37.5%",
   C("First find the fraction of the total, then turn it into a percentage. The first part is 3 of 3 + 5 = 8.")+
   steps("First part of total = 3 / (3 + 5) = 3/8","3/8 × 100 = 300 ÷ 8","= 37.5%.")+
   U("Saying '3 out of every 8 students walk to school' is the same as 37.5%."),
   [("3%","3% ignores the total of 8; the share is 3/8 × 100 = 37.5%."),
    ("60%","60% is 3/5 × 100, comparing to the wrong total; against 3 + 5 = 8 it is 37.5%."),
    ("30%","30% misreads the fraction; 3 out of 8 is 3/8 × 100 = 37.5%.")]),

 ("CQ","If 5 pens cost ₹60, then at the same rate the cost of 8 pens is:",
   "₹96",
   C("Use the unitary method: find the cost of one pen, then multiply by the number wanted.")+
   steps("One pen = 60 ÷ 5 = ₹12","8 pens = 8 × 12","= ₹96.")+
   U("To price a different number of the same item, find the cost of one, then scale up."),
   [("₹68","₹68 just adds ₹8 to ₹60; one pen is ₹12, so 8 pens cost 8 × 12 = ₹96."),
    ("₹75","₹75 is a wrong scaling; at ₹12 each, 8 pens cost ₹96."),
    ("₹480","₹480 multiplies ₹60 by 8 without finding the unit price; the answer is 8 × 12 = ₹96.")]),

 ("CQ","In a class of 40 students, 60% are girls. The number of boys in the class is:",
   "16",
   C("If 60% are girls, then 40% are boys. Find 40% of the class.")+
   steps("Boys = 100% − 60% = 40%","40% of 40 = 0.40 × 40","= 16 boys.")+
   U("Knowing the girls' percentage lets a teacher work out the boys by subtracting and scaling."),
   [("24","24 is the number of girls (60% of 40); the boys are 40% of 40 = 16."),
    ("40","40 is the whole class; the boys are 40% of it, which is 16."),
    ("4","4 divides by 10; 40% of 40 students is 0.40 × 40 = 16.")]),

 ("CQ","The price of a bag rose from ₹500 to ₹600. The percentage increase in price is:",
   "20%",
   C("Percentage increase = (increase ÷ original) × 100.")+
   steps("Increase = 600 − 500 = ₹100","(100 ÷ 500) × 100","= 20%.")+
   U("A shopper works out a price rise as a percentage of the old price to judge how steep it is."),
   [("100%","100% mistakes the rupee rise for the percent; (100 ÷ 500) × 100 = 20%."),
    ("16.7%","16.7% divides by the new price 600; percentage increase uses the original: 100 ÷ 500 = 20%."),
    ("10%","10% halves the result; (100 ÷ 500) × 100 = 20%.")]),

 ("CQ","A test is marked out of 80. A student scores 60. As a percentage, the score is:",
   "75%",
   C("Percentage marks = (marks scored ÷ total marks) × 100.")+
   steps("Scored = 60, total = 80","(60 ÷ 80) × 100","= 0.75 × 100 = 75%.")+
   U("A report card turns raw marks into a percentage so scores out of different totals can be compared."),
   [("60%","60% just copies the raw marks; out of 80 the score is (60 ÷ 80) × 100 = 75%."),
    ("80%","80% uses the total as the percent; the score is 60 of 80 = 75%."),
    ("20%","20% is the share lost (20 of 80); the score itself is 75%.")]),

 ("CQ","Two quantities are in the ratio 1 : 4 and together they total 250 mL. The smaller quantity is:",
   "50 mL",
   C("Add the ratio parts to get the total parts, find one part, then take the smaller share.")+
   steps("Total parts = 1 + 4 = 5","one part = 250 ÷ 5 = 50 mL","smaller (1 part) = 50 mL.")+
   U("Mixing a 1 : 4 squash-to-water drink to make 250 mL means 50 mL of squash."),
   [("62.5 mL","62.5 mL divides 250 by 4, ignoring the first part; total parts are 5, so one part is 50 mL."),
    ("200 mL","200 mL is the larger (4 parts) share; the smaller 1 part is 50 mL."),
    ("125 mL","125 mL halves the total as if the ratio were 1 : 1; for 1 : 4 the smaller part is 50 mL.")]),

 ("CQ","A solution is made by mixing acid and water in the ratio 1 : 3. The percentage of acid in the solution is:",
   "25%",
   C("Acid is 1 part out of 1 + 3 = 4 total parts; turn this fraction into a percentage.")+
   steps("Acid fraction = 1 / (1 + 3) = 1/4","1/4 × 100","= 25% acid.")+
   U("A lab notes that a 1 : 3 acid-to-water mix is a 25% acid solution."),
   [("33.3%","33.3% is 1/3, comparing acid to water alone; against the whole 4 parts it is 1/4 = 25%."),
    ("75%","75% is the water share (3 of 4); the acid is 1 of 4 = 25%."),
    ("13%","13% misreads the parts; 1 out of 4 parts is 1/4 × 100 = 25%.")]),

 ("CQ","An item is sold for ₹360 at a 20% profit. Its cost price was:",
   "₹300",
   C("At a 20% profit the selling price is 120% of the cost. Reverse it: cost = selling price ÷ 1.20.")+
   steps("Selling price = 120% of cost = ₹360","cost = 360 ÷ 1.20","= ₹300.")+
   U("Knowing the sale price and the profit percent, a trader works backward to the original cost."),
   [("₹288","₹288 takes 20% off the ₹360; instead the ₹360 is 120% of cost, so cost = 360 ÷ 1.2 = ₹300."),
    ("₹340","₹340 subtracts ₹20; the cost is 360 ÷ 1.20 = ₹300."),
    ("₹432","₹432 adds 20% to ₹360; the cost (before profit) is 360 ÷ 1.20 = ₹300.")]),

 ("CQ","A football team played 25 matches and won 60% of them. The number of matches won is:",
   "15",
   C("Matches won = percent × total matches.")+
   steps("60% of 25 = (60 ÷ 100) × 25","= 0.60 × 25","= 15 matches won.")+
   U("A sports page turns a win percentage and the games played into the number of wins."),
   [("10","10 is the 40% they did not win; the wins are 60% of 25 = 15."),
    ("60","60 just repeats the percent; 60% of 25 matches is 15."),
    ("6","6 divides 60 by 10 only; 60% of 25 is 0.60 × 25 = 15.")]),

 ("CQ","Out of every 100 g of a snack, 12 g is sugar. In a 250 g pack, the mass of sugar is:",
   "30 g",
   C("12 g per 100 g is 12%, so find 12% of the pack's mass.")+
   steps("Sugar = 12% of 250 g = (12 ÷ 100) × 250","= 0.12 × 250","= 30 g of sugar.")+
   U("A nutrition label's 'per 100 g' figure is a percentage you scale to the whole pack."),
   [("12 g","12 g is the amount per 100 g; the 250 g pack holds 12% of 250 = 30 g."),
    ("48 g","48 g over-scales; 12% of 250 g is 0.12 × 250 = 30 g."),
    ("3 g","3 g divides too far; 12% of 250 g = 30 g.")]),

 ("CQ","The ratio of the length to the breadth of a field is 5 : 2. If the length is 35 m, the breadth is:",
   "14 m",
   C("Keep the ratio. With length : breadth = 5 : 2, each part = 35 ÷ 5 = 7 m, so breadth = 2 parts.")+
   steps("Ratio length : breadth = 5 : 2","one part = 35 ÷ 5 = 7 m","breadth = 2 × 7 = 14 m.")+
   U("A surveyor given a field's shape ratio and one side works out the other side."),
   [("87.5 m","87.5 m scales the wrong way (35 × 5 ÷ 2); for 5 : 2 the breadth is 35 ÷ 5 × 2 = 14 m."),
    ("70 m","70 m doubles the length; with 5 : 2 the breadth is 14 m."),
    ("17.5 m","17.5 m just halves 35; using the 5 : 2 ratio the breadth is 14 m.")]),

 ("CQ","A number is increased to 130% of itself. If the original number was 40, the new number is:",
   "52",
   C("130% of a number means 1.30 times it.")+
   steps("130% of 40 = (130 ÷ 100) × 40","= 1.30 × 40","= 52.")+
   U("A salary raised to 130% of the old figure is the old amount times 1.3."),
   [("13","13 divides too far; 130% of 40 is 1.30 × 40 = 52."),
    ("70","70 adds 30 to 40; 130% of 40 means 1.3 × 40 = 52."),
    ("130","130 just repeats the percent; 130% of 40 is 52.")]),

 ("CQ","A garden has roses and lilies in the ratio 7 : 3. The percentage of the flowers that are lilies is:",
   "30%",
   C("Lilies are 3 parts out of 7 + 3 = 10 total parts; turn this into a percentage.")+
   steps("Lily fraction = 3 / (7 + 3) = 3/10","3/10 × 100","= 30% lilies.")+
   U("Knowing the ratio of two flower types lets a gardener state each as a percentage of the bed."),
   [("3%","3% ignores the total of 10 parts; lilies are 3/10 × 100 = 30%."),
    ("70%","70% is the rose share (7 of 10); the lilies are 3 of 10 = 30%."),
    ("43%","43% is 3/7, comparing lilies to roses alone; against the whole 10 parts it is 30%.")]),
]

# ---------- SYMMETRY (25) — Maths (several fused with Science) ----------
SY = [
 ("SY","A line that divides a figure into two identical halves that fold exactly onto each other is a:",
   "line of symmetry",
   C("A line of symmetry splits a figure into two mirror-image halves that match perfectly when folded along it.")+
   steps("Fold the figure along a line","if the two halves cover each other exactly","that fold line is a line of symmetry.")+
   U("Folding a paper heart down the middle so the halves match shows its line of symmetry."),
   [("diagonal","A diagonal joins opposite corners but need not give matching halves; a fold giving equal halves is a line of symmetry."),
    ("perimeter","Perimeter is the boundary length of a shape, not a dividing fold line; the matching fold is a line of symmetry."),
    ("radius","A radius is a line from a circle's centre to its edge; the equal-halves fold line is a line of symmetry.")]),

 ("SY","The number of lines of symmetry a square has is:",
   "4",
   C("A square has 4 lines of symmetry: two through the midpoints of opposite sides and two along its diagonals.")+
   steps("Fold a square in different ways","2 folds across the middle of sides + 2 along diagonals match","so a square has 4 lines of symmetry.")+
   U("A square tile looks the same when flipped along any of its 4 lines of symmetry."),
   [("2","2 counts only the side-to-side folds; the diagonals also work, giving a square 4 lines."),
    ("1","1 is far too few; a square has 4 lines of symmetry."),
    ("8","8 confuses lines of symmetry with rotational positions; a square has 4 lines of symmetry.")]),

 ("SY","Folding a non-square rectangle to make its halves match, you find its lines of symmetry total:",
   "2",
   C("A non-square rectangle has 2 lines of symmetry — through the midpoints of each pair of opposite sides. Its diagonals are NOT lines of symmetry.")+
   steps("Fold a rectangle across its width and length","both folds match the halves","its diagonals do not, so it has 2 lines.")+
   U("A rectangular door looks balanced across its two midlines — its lines of symmetry."),
   [("4","4 is the square's count; a non-square rectangle's diagonals do not match, so it has only 2."),
    ("1","1 is too few; a rectangle has 2 lines of symmetry."),
    ("0","0 is wrong; a rectangle has 2 lines of symmetry through its midpoints.")]),

 ("SY","Counting every fold that maps one half onto the other, an equilateral triangle has lines of symmetry totalling:",
   "3",
   C("An equilateral triangle has 3 lines of symmetry, one from each vertex to the midpoint of the opposite side.")+
   steps("Draw a line from each corner to the opposite side's middle","each such fold matches the halves","so there are 3 lines of symmetry.")+
   U("A triangular road sign with equal sides balances along any of its 3 lines of symmetry."),
   [("1","1 fits an isosceles (only two equal sides); an equilateral triangle has 3 lines of symmetry."),
    ("2","2 is too few; the equilateral triangle has one line from each of its 3 vertices."),
    ("0","0 fits a scalene triangle; the equilateral one has 3 lines of symmetry.")]),

 ("SY","The number of lines of symmetry a circle has is:",
   "infinitely many",
   C("Any line through the centre of a circle (a diameter) divides it into two identical halves, so a circle has countless lines of symmetry.")+
   steps("Draw any line through the centre","it splits the circle into two matching halves","since there are endless such lines, a circle has infinitely many.")+
   U("A round plate looks the same no matter which way you fold it through the centre."),
   [("1","1 is far too few; every diameter is a line of symmetry, so a circle has infinitely many."),
    ("4","4 fits a square, not a circle; a circle has infinitely many lines of symmetry."),
    ("0","0 is wrong; a circle has infinitely many lines of symmetry through its centre.")]),

 ("SY","An isosceles triangle, which has just two equal sides, has this many lines of symmetry:",
   "1",
   C("An isosceles triangle has exactly 1 line of symmetry, running from the apex between the equal sides to the midpoint of the base.")+
   steps("Fold along the line from the top vertex to the base's middle","the two equal sides match","so it has just 1 line of symmetry.")+
   U("A simple kite shape or an isosceles flag balances along its single line of symmetry."),
   [("3","3 fits the equilateral triangle (all sides equal); an isosceles one has just 1 line."),
    ("2","2 is too many; with only two equal sides, an isosceles triangle has 1 line of symmetry."),
    ("0","0 fits a scalene triangle; an isosceles triangle has 1 line of symmetry.")]),

 ("SY","A scalene triangle, in which all three sides have different lengths, has this many lines of symmetry:",
   "0",
   C("A scalene triangle has no equal sides, so no fold gives matching halves — it has zero lines of symmetry.")+
   steps("Try folding along any line","with all sides different, no halves match","so a scalene triangle has 0 lines of symmetry.")+
   U("An irregular triangular off-cut of paper cannot be folded into matching halves."),
   [("1","1 fits an isosceles triangle; with all sides unequal, a scalene triangle has 0 lines."),
    ("3","3 fits the equilateral triangle; a scalene one has no lines of symmetry."),
    ("2","2 is wrong; a scalene triangle has 0 lines of symmetry.")]),

 ("SY","The capital letter that has a single VERTICAL line of symmetry is:",
   "A",
   C("The letter A can be folded down a vertical centre line so its left and right halves match.")+
   steps("Try a vertical fold down the middle of each letter","A's left and right halves match","so A has a vertical line of symmetry.")+
   U("Designing a balanced logo, you fold letters like A down the middle to check symmetry."),
   [("F","F has no line of symmetry — neither a vertical nor a horizontal fold matches; A has a vertical one."),
    ("P","P has no line of symmetry; the letter with a vertical line of symmetry here is A."),
    ("R","R has no line of symmetry; A folds neatly down a vertical line.")]),

 ("SY","The capital letter B has a line of symmetry that is:",
   "horizontal",
   C("The letter B matches top-to-bottom, so its line of symmetry is horizontal, across the middle.")+
   steps("Try folding B across the middle (horizontally)","its top and bottom halves match","so B has a horizontal line of symmetry.")+
   U("Letters like B and E read the same top and bottom — a horizontal line of symmetry."),
   [("vertical","A vertical fold of B does not match the left and right; its line of symmetry is horizontal."),
    ("diagonal","B has no diagonal line of symmetry; it matches across a horizontal fold."),
    ("both vertical and horizontal","B matches only across the horizontal fold, not the vertical one.")]),

 ("SY","Turning a figure about a fixed centre point so that it looks exactly the same is called:",
   "rotational symmetry",
   C("A figure has rotational symmetry if, on turning it about a centre by less than a full turn, it looks the same as before.")+
   steps("Spin the figure about its centre","at some turn it looks unchanged","this property is rotational symmetry.")+
   U("A ceiling fan's blades look the same as it spins — that is rotational symmetry."),
   [("line symmetry","Line symmetry is about folding into matching halves; looking the same on turning is rotational symmetry."),
    ("translation","Translation is sliding a shape without turning; matching on a turn is rotational symmetry."),
    ("reflection","Reflection is a mirror flip; looking unchanged after a turn is rotational symmetry.")]),

 ("SY","The order of rotational symmetry of a square (how many times it matches itself in one full turn) is:",
   "4",
   C("A square looks the same after every quarter turn (90°), so in one full turn it matches itself 4 times — order 4.")+
   steps("Turn the square by 90° each time","it looks the same at 90°, 180°, 270° and 360°","that is 4 matches — order 4.")+
   U("A square tile dropped back in any of 4 turned positions fits the same gap."),
   [("2","2 fits a rectangle; a square matches itself every 90°, giving order 4."),
    ("1","Order 1 means it matches only after a full turn; a square matches 4 times, so order 4."),
    ("8","8 confuses lines of symmetry counts; a square's rotational order is 4.")]),

 ("SY","For a shape with rotational symmetry of order n, the smallest angle of rotation that maps it onto itself is:",
   "360° ÷ n",
   C("The smallest turning angle equals a full turn divided by the order: 360° ÷ n.")+
   steps("One full turn is 360°","split it equally into n matching positions","each step is 360° ÷ n.")+
   U("A shape of order 5 repeats every 360 ÷ 5 = 72°, the angle each identical part is turned."),
   [("360° × n","Multiplying overshoots a full turn; the smallest angle is 360° ÷ n."),
    ("180° ÷ n","180° is only a half turn; the full turn 360° divided by n gives the angle."),
    ("n ÷ 360°","That inverts the formula and gives no angle; the smallest angle is 360° ÷ n.")]),

 ("SY","An equilateral triangle matches itself on turning every:",
   "120°",
   C("An equilateral triangle has rotational order 3, so its smallest matching turn is 360° ÷ 3 = 120°.")+
   steps("Order of an equilateral triangle = 3","smallest angle = 360° ÷ 3","= 120°.")+
   U("A three-bladed propeller, like an equilateral triangle, looks the same every 120° of spin."),
   [("60°","60° is half of 120°; the triangle first matches after a 120° turn."),
    ("90°","90° fits a square (order 4); the equilateral triangle matches every 120°."),
    ("360°","360° is a full turn; the triangle already matches at 120°.")]),

 ("SY","A regular pentagon (5 equal sides) has lines of symmetry numbering:",
   "5",
   C("A regular polygon has as many lines of symmetry as it has sides, so a regular pentagon has 5.")+
   steps("A regular polygon's lines of symmetry equal its number of sides","a pentagon has 5 sides","so it has 5 lines of symmetry.")+
   U("A regular five-sided shape, like a school badge, balances along 5 lines of symmetry."),
   [("1","1 is far too few; a regular pentagon has 5 lines of symmetry, one per side."),
    ("2","2 fits a non-square rectangle; a regular pentagon has 5 lines of symmetry."),
    ("10","10 doubles the count; a regular pentagon has exactly 5 lines of symmetry.")]),

 ("SY","A flower has 5 identical petals spaced evenly around its centre. Its order of rotational symmetry is:",
   "5",
   C("With 5 identical petals evenly spaced, the flower matches itself every 360° ÷ 5 = 72°, so its rotational order is 5. (A reproduction-in-plants link to symmetry.)")+
   steps("5 identical petals are evenly placed","each 72° turn lands one petal where the next was","so it matches 5 times — order 5.")+
   U("A buttercup or hibiscus with 5 even petals shows rotational symmetry of order 5."),
   [("1","Order 1 means only a full turn matches; 5 even petals give 5 matches, order 5."),
    ("2","2 fits a shape matching only twice per turn; 5 even petals give order 5."),
    ("10","10 doubles the petal count; 5 evenly spaced petals give rotational order 5.")]),

 ("SY","Because a regular polygon's lines of symmetry equal its sides, a regular six-sided hexagon has:",
   "6",
   C("A regular polygon has lines of symmetry equal to its number of sides, so a regular hexagon has 6.")+
   steps("Lines of symmetry = number of sides for a regular polygon","a hexagon has 6 sides","so 6 lines of symmetry.")+
   U("A honeycomb's regular six-sided cell balances along 6 lines of symmetry."),
   [("3","3 is half the sides; a regular hexagon has 6 lines of symmetry."),
    ("4","4 fits a square; a regular hexagon has 6 lines of symmetry."),
    ("12","12 doubles the count; a regular hexagon has exactly 6 lines of symmetry.")]),

 ("SY","A leaf is often symmetric along its midrib, so a typical simple leaf has this many lines of symmetry:",
   "1",
   C("A simple leaf can usually be folded along its midrib so the two halves match, giving it 1 line of symmetry. (A link from symmetry to plant parts.)")+
   steps("Fold the leaf along its central midrib","the left and right halves match","so the leaf has 1 line of symmetry.")+
   U("Folding a mango or peepal leaf along its midrib shows its single line of symmetry."),
   [("0","Most simple leaves do fold into matching halves along the midrib, giving 1 line, not 0."),
    ("2","A leaf matches only along the midrib, not across it, so it has 1 line, not 2."),
    ("infinitely many","Only a circle has infinitely many; a leaf has a single line of symmetry along the midrib.")]),

 ("SY","A figure that looks the same after a half turn (180°) but not after a quarter turn has rotational symmetry of order:",
   "2",
   C("Matching after a 180° turn (and again at 360°) means it matches twice in a full turn — order 2.")+
   steps("It matches at 180° and at 360°","that is two matching positions in one turn","so the order of rotational symmetry is 2.")+
   U("The letter S or a playing-card design looks the same after a half turn — order 2."),
   [("1","Order 1 matches only after a full turn; matching at 180° too makes it order 2."),
    ("4","Order 4 needs matching every 90°; matching only at 180° is order 2."),
    ("0","Order is at least 1; matching at 180° gives order 2.")]),

 ("SY","A parallelogram (that is not a rectangle or rhombus) has lines of symmetry numbering:",
   "0",
   C("A general parallelogram has no line of symmetry — no fold gives matching halves — though it does have rotational symmetry of order 2.")+
   steps("Try folding a slanted parallelogram any way","no fold makes the halves match","so it has 0 lines of symmetry.")+
   U("A leaning parallelogram shape cannot be folded into mirror-matching halves."),
   [("2","2 fits a rectangle or rhombus; a general parallelogram has 0 lines of symmetry."),
    ("4","4 fits a square; a slanted parallelogram has no line of symmetry."),
    ("1","1 fits an isosceles triangle; a general parallelogram has 0 lines of symmetry.")]),

 ("SY","When a shape is flipped across a line to give its mirror image, the result is its:",
   "reflection",
   C("A reflection is the mirror image of a figure flipped across a line; line symmetry means a figure is its own reflection across that line.")+
   steps("Place a mirror along a line beside a shape","the image you see is flipped across the line","this flipped image is the reflection.")+
   U("Your reflection in a still pond is a mirror image flipped across the water's edge."),
   [("rotation","Rotation turns a shape about a point; the mirror-image flip across a line is a reflection."),
    ("translation","Translation slides a shape without flipping; the mirror image is a reflection."),
    ("enlargement","Enlargement changes size; a same-size mirror image is a reflection.")]),

 ("SY","A regular octagon (8 equal sides) has rotational symmetry of order:",
   "8",
   C("A regular polygon with n sides has rotational order n, so a regular octagon has order 8 (matching every 360° ÷ 8 = 45°).")+
   steps("A regular polygon's rotational order equals its sides","an octagon has 8 sides","so order 8, matching every 45°.")+
   U("A STOP-sign-shaped octagon looks the same after every 45° turn — order 8."),
   [("4","4 fits a square; a regular octagon's rotational order is 8."),
    ("2","2 fits a rectangle; a regular octagon matches 8 times in a full turn."),
    ("16","16 doubles the sides; a regular octagon has rotational order 8.")]),

 ("SY","The English capital letter that has BOTH a vertical and a horizontal line of symmetry is:",
   "H",
   C("The letter H matches when folded either vertically or horizontally, so it has two lines of symmetry.")+
   steps("Fold H down the middle — halves match (vertical)","fold H across the middle — halves match (horizontal)","so H has both lines of symmetry.")+
   U("Letters like H, I and O are popular in balanced designs for their two lines of symmetry."),
   [("A","A has only a vertical line of symmetry, not a horizontal one; H has both."),
    ("B","B has only a horizontal line of symmetry; H has both vertical and horizontal."),
    ("P","P has no line of symmetry at all; H has both a vertical and a horizontal one.")]),

 ("SY","Every regular polygon has its number of lines of symmetry exactly equal to its number of:",
   "sides",
   C("For a regular polygon, the count of lines of symmetry always equals the number of sides (and equals its rotational order).")+
   steps("A regular polygon is fully even-sided","each side and each vertex gives a matching fold","so lines of symmetry = number of sides.")+
   U("Knowing a regular 12-sided shape has 12 sides tells you at once it has 12 lines of symmetry."),
   [("right angles","A regular polygon need not have right angles; its lines of symmetry equal its number of sides."),
    ("diagonals","The number of diagonals is different from the sides; lines of symmetry equal the number of sides."),
    ("vertices it shares with a circle","That has no clear meaning here; lines of symmetry equal the number of sides.")]),

 ("SY","A windmill design with 4 identical blades evenly placed looks the same on turning by 90° but has no line of symmetry. It has:",
   "rotational symmetry only",
   C("Such a windmill matches itself every 90° (rotational order 4) yet no fold gives mirror-matching halves, so it has rotational symmetry but no line symmetry.")+
   steps("Turning 90° lands each blade where the next was — it matches","but a fold does not give mirror halves (the blades curve one way)","so it has rotational symmetry only.")+
   U("A pinwheel or fan with slanted, swept blades spins to look the same yet has no mirror line."),
   [("line symmetry only","The swept blades give no mirror-matching fold, so it has rotational symmetry, not line symmetry."),
    ("both line and rotational symmetry","With no mirror-matching fold there is no line symmetry; only rotational symmetry is present."),
    ("no symmetry at all","Matching every 90° is genuine rotational symmetry, so it is not symmetry-free.")]),

 ("SY","A rhombus (a slanted shape with all four sides equal) has lines of symmetry numbering:",
   "2",
   C("A rhombus has 2 lines of symmetry, lying along its two diagonals; its sides' midlines are NOT lines of symmetry.")+
   steps("Fold a rhombus along each diagonal","both folds give matching halves","so a rhombus has 2 lines of symmetry.")+
   U("A diamond-shaped kite (a rhombus) balances along its two diagonals."),
   [("4","4 fits a square; a slanted rhombus has only its 2 diagonals as lines of symmetry."),
    ("1","1 is too few; a rhombus has 2 lines of symmetry along its diagonals."),
    ("0","0 fits a general parallelogram; a rhombus does have 2 lines of symmetry.")]),
]

# ---------- assemble: interleave so no two consecutive share a chapter ----------
assert all(len(b) == 25 for b in (AB, RP, CQ, SY)), [len(AB), len(RP), len(CQ), len(SY)]
items = []
for i in range(25):
    items += [AB[i], RP[i], CQ[i], SY[i]]
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

    keydist = build_paper(PNUM, TITLE, SHORT, LABELS, items, seed=49071,
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
    split = "/".join(str(counts[c]) for c in ("AB", "RP", "CQ", "SY"))
    with open("PAPERS_MANIFEST.md", "a", encoding="utf-8") as fh:
        fh.write(f"| {PNUM} | 2026-06-18 | {TITLE} | {split} | ✓ |\n")

    # ---- update QUESTION_INDEX.json ----
    idx["fingerprints"] = sorted(existing | set(new_fps))
    idx.setdefault("combos", []).append({
        "paper": PNUM,
        "chapters": ["Acids, Bases & Salts",
                     "Reproduction in Plants",
                     "Comparing Quantities",
                     "Symmetry"],
    })
    idx["papers"] = idx.get("papers", 0) + 1
    with open(idx_path, "w", encoding="utf-8") as fh:
        json.dump(idx, fh, ensure_ascii=False, indent=2)
        fh.write("\n")

    print("Files:", sorted(v for v in moves.values()))
    print("Answer key spread A/B/C/D =", dict(keydist))
