# -*- coding: utf-8 -*-
# Boss Challenge Paper 45 — Nutrition in Plants · Wastewater Story ·
# Perimeter & Area · Exponents & Powers
# Content-only. Uses the dependency-free examfactory engine.
# Difficulty ramp: leans hard into FUSION. A leaf's sunlit surface becomes an
# AREA problem; bacteria doubling in an aeration tank becomes EXPONENTS; the
# floor of a treatment tank becomes PERIMETER & AREA; the food a green plant
# packs into starch becomes powers-of-ten counting. The child meets a Science
# situation and reaches for a Maths skill. Class-7 scope, simple wording, hard
# thinking.
# Produces, under Resources/BossChallengePapers/:
#   Paper_45_<SHORT>_QuestionPaper.html  (pure HTML — questions + options)
#   Paper_45_<SHORT>_QuestionPaper.pdf
#   Paper_45_<SHORT>_Questions.md
#   Paper_45_<SHORT>_Solutions.html
import os, sys, shutil, json, re
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from examfactory import build_paper, C, steps, U

PNUM  = "45"
SHORT = "NutritionInPlants_WastewaterStory_PerimeterArea_ExponentsPowers"
TITLE = ("Nutrition in Plants · Wastewater Story · "
         "Perimeter & Area · Exponents & Powers")
LABELS = {
    "NP": "Nutrition in Plants",
    "WW": "Wastewater Story",
    "PA": "Perimeter & Area",
    "EP": "Exponents & Powers",
}

# ---------- NUTRITION IN PLANTS (25) — Science (some fused) ----------
NP = [
 ("NP","A plant that builds its own food from simple raw materials, using sunlight, is said to follow the mode of nutrition called:",
   "autotrophic",
   C("Green plants are autotrophs: they make their own food by photosynthesis instead of eating other organisms.")+
   steps("'Auto' means self and 'troph' means feeding","a green plant feeds itself by making food","so its mode of nutrition is autotrophic.")+
   U("A mango tree in your yard makes its own sugars in its leaves — nobody feeds it."),
   [("heterotrophic","Heterotrophs take ready-made food from others; that describes animals, not green plants."),
    ("parasitic","A parasite steals food from a living host; a self-feeding green plant does the opposite."),
    ("saprotrophic","Saprotrophs feed on dead, decaying matter; a green plant in sunlight does not.")]),

 ("NP","The green colouring matter in a leaf that captures the energy of sunlight for food-making is named:",
   "chlorophyll",
   C("Chlorophyll is the green pigment in leaves that traps sunlight, powering photosynthesis.")+
   steps("Leaves look green because of a pigment","that pigment soaks up sunlight energy","it is called chlorophyll.")+
   U("Grass and leaves look green everywhere because each is packed with chlorophyll."),
   [("cytoplasm","Cytoplasm is the jelly filling a cell; it is not the green light-trapping pigment."),
    ("haemoglobin","Haemoglobin carries oxygen in animal blood; it is red, not the green leaf pigment."),
    ("starch","Starch is the stored food the leaf makes, not the pigment that traps sunlight.")]),

 ("NP","The tiny pores on the surface of a leaf, through which gases move in and out, are called:",
   "stomata",
   C("Stomata are minute openings on leaves that let carbon dioxide in and oxygen out during photosynthesis.")+
   steps("A leaf must swap gases with the air","it does this through tiny surface pores","these pores are the stomata.")+
   U("On a humid morning, water vapour also escapes a leaf through its open stomata."),
   [("veins","Veins carry water and food inside the leaf; they are not the surface pores for gases."),
    ("nodes","A node is the point on a stem where a leaf joins; it is not a leaf pore."),
    ("roots","Roots absorb water from soil; they are not the gas pores on a leaf.")]),

 ("NP","Besides sunlight and chlorophyll, the two raw materials a green leaf needs to carry out photosynthesis are:",
   "carbon dioxide and water",
   C("Photosynthesis combines carbon dioxide from air with water from soil, using sunlight and chlorophyll.")+
   steps("Sunlight and chlorophyll supply the energy and the trap","the leaf still needs raw materials to build food","these are carbon dioxide and water.")+
   U("A potted plant on a sunny sill quietly draws in air and soil-water to feed itself."),
   [("oxygen and glucose","Oxygen and glucose are the products of photosynthesis, not the raw materials fed in."),
    ("nitrogen and salt","Nitrogen and salt are not the raw materials photosynthesis joins to make food."),
    ("starch and water","Starch is the made food, not a raw material; only water belongs among the inputs.")]),

 ("NP","The gas that a green plant releases into the air as a by-product of photosynthesis during the day is:",
   "oxygen",
   C("Photosynthesis gives out oxygen as a by-product, which is why green plants freshen the air.")+
   steps("The leaf takes in carbon dioxide to make food","in doing so it splits water and frees oxygen","oxygen is released to the air.")+
   U("A room full of healthy plants feels fresh because they release oxygen by day."),
   [("carbon dioxide","Carbon dioxide is taken in for photosynthesis, not released by it during the day."),
    ("nitrogen","Nitrogen makes up most of the air but is not a product of photosynthesis."),
    ("water vapour","Water vapour escapes by transpiration, not as the food-making by-product asked about.")]),

 ("NP","When a few drops of iodine solution are placed on a leaf that has made food, the colour that appears is:",
   "blue-black",
   C("Iodine turns blue-black with starch, so a food-making leaf shows blue-black — proof of photosynthesis.")+
   steps("Leaves store made food as starch","iodine reacts with starch to give a blue-black colour","seeing blue-black proves starch is present.")+
   U("A school experiment uses iodine on a destarched, then sunlit, leaf to show photosynthesis happened."),
   [("bright red","Iodine does not turn red with starch; the starch test gives a blue-black colour."),
    ("colourless","If no starch were present it would stay brownish; a food-making leaf turns blue-black."),
    ("grass green","The green is the leaf's own colour, not the iodine reaction that signals starch.")]),

 ("NP","The amarbel (Cuscuta), a yellow climbing plant that twines on a host and draws food from it, is an example of a:",
   "parasite",
   C("Cuscuta has no chlorophyll and feeds off a living host plant, so it is a parasite.")+
   steps("Amarbel is yellow, lacking green chlorophyll","it cannot make its own food","it takes food from a living host, so it is a parasite.")+
   U("You can spot yellow amarbel threads smothering a hedge, feeding on the plant beneath."),
   [("saprotroph","A saprotroph feeds on dead matter; amarbel feeds on a living host instead."),
    ("autotroph","An autotroph makes its own food; amarbel lacks chlorophyll and cannot."),
    ("host","The host is the plant being fed upon; amarbel is the feeder, not the host.")]),

 ("NP","An insect-trapping plant such as the pitcher plant catches insects mainly to obtain the nutrient it lacks in marshy soil, namely:",
   "nitrogen",
   C("Insectivorous plants grow in nitrogen-poor soil and trap insects to get the nitrogen they need.")+
   steps("Pitcher plants live in soil short of nitrogen","they still need nitrogen to build proteins","they trap and digest insects to get it.")+
   U("In a boggy patch, a pitcher plant lures an ant into its slippery jug to top up on nitrogen."),
   [("carbon","Plants get carbon from carbon dioxide in air, not by trapping insects."),
    ("oxygen","Oxygen is freely available in air and water; it is not why the plant traps insects."),
    ("water","Marshy soil is rich in water; the missing nutrient the plant seeks is nitrogen.")]),

 ("NP","A mushroom growing on a rotting log feeds by breaking down the dead wood for nutrients. Its mode of nutrition is:",
   "saprotrophic",
   C("Saprotrophs like fungi feed on dead and decaying matter, breaking it down for nutrients.")+
   steps("A mushroom has no chlorophyll to make food","it lives on dead, rotting wood","feeding on dead matter is saprotrophic nutrition.")+
   U("Mushrooms sprouting on a damp, rotting log are recycling the dead wood as they feed."),
   [("autotrophic","Autotrophs make their own food; a mushroom has no chlorophyll and cannot."),
    ("parasitic","A parasite feeds on a living host; this fungus feeds on dead wood instead."),
    ("insectivorous","Insectivorous nutrition means trapping insects, which a mushroom does not do.")]),

 ("NP","Rhizobium bacteria living in the root nodules of pulses help the plant by converting air's nitrogen into a usable form. This partnership is called:",
   "symbiosis",
   C("Rhizobium and legumes live in symbiosis: the bacteria fix nitrogen, the plant gives them food and shelter.")+
   steps("Bacteria in the root nodules trap nitrogen from air","the plant gets usable nitrogen and the bacteria get food","both gain, so it is symbiosis.")+
   U("Farmers grow gram or beans to enrich tired soil, thanks to this bacteria-plant partnership."),
   [("parasitism","In parasitism one side is harmed; here both the plant and bacteria benefit."),
    ("predation","Predation means one organism eats another; the bacteria and plant instead cooperate."),
    ("digestion","Digestion is breaking food down inside a body, not a partnership between two organisms.")]),

 ("NP","The part of a green plant that acts as the main 'food factory', where most photosynthesis happens, is the:",
   "leaf",
   C("Leaves are the main sites of photosynthesis because they hold the most chlorophyll and catch sunlight.")+
   steps("Photosynthesis needs chlorophyll and sunlight","leaves are broad, green and sun-facing","so the leaf is the plant's food factory.")+
   U("A plant kept in the dark soon weakens because its leaf-factories cannot work."),
   [("root","Roots absorb water and anchor the plant; they are usually underground and not green."),
    ("flower","A flower is for reproduction; it is not the plant's main food-making organ."),
    ("seed","A seed stores food for a new plant; it does not carry out photosynthesis.")]),

 ("NP","Cells around each stoma that swell and shrink to open or close the pore are called:",
   "guard cells",
   C("Each stoma is bordered by two guard cells that open and close the pore to control gas and water loss.")+
   steps("A stoma is a pore that must open and shut","two bean-shaped cells flank it","these guard cells control the opening.")+
   U("On a hot afternoon, guard cells close the stomata so the plant loses less water."),
   [("root hairs","Root hairs absorb water from soil; they have nothing to do with leaf pores."),
    ("xylem cells","Xylem cells form water-carrying tubes; they do not open and close stomata."),
    ("nerve cells","Plants have no nerve cells; the stoma is worked by guard cells.")]),

 ("NP","Non-green plants and all animals ultimately depend on green plants for food, which is why green plants are called the:",
   "producers",
   C("Green plants are producers: they make food that supports all other living things in a food chain.")+
   steps("Only green plants can make food from sunlight","every other organism depends on that food","so green plants are the producers.")+
   U("From grass to grasshopper to bird, the whole chain traces back to green producers."),
   [("consumers","Consumers eat food made by others; green plants make their own, so they are producers."),
    ("decomposers","Decomposers break down dead matter; that is not the role of food-making green plants."),
    ("parasites","Parasites steal food from hosts; green plants make their own food instead.")]),

 ("NP","To put back the nitrogen that crops remove from a field, a farmer can grow a crop of pulses such as gram or beans because their roots:",
   "host nitrogen-fixing bacteria",
   C("Legume roots carry Rhizobium, which fixes air nitrogen into the soil, restoring fertility naturally.")+
   steps("Pulses have root nodules full of Rhizobium","these bacteria fix nitrogen into the soil","so growing pulses replenishes soil nitrogen.")+
   U("Crop rotation with beans is a low-cost way to refresh a tired field's nitrogen."),
   [("burn nitrogen out of the soil","Pulses add nitrogen through their root bacteria; they do not burn it away."),
    ("block water from the soil","Roots take in water; they do not block it, and that is not how nitrogen returns."),
    ("turn the soil acidic","Restoring nitrogen comes from the root bacteria, not from acidifying the soil.")]),

 ("NP","A lichen growing as a grey crust on a rock is actually a partnership of two organisms: a fungus together with a(n):",
   "alga",
   C("A lichen is a symbiosis of a fungus and an alga; the alga makes food, the fungus gives shelter and water.")+
   steps("A lichen is not a single organism","it pairs a fungus with a green partner","that partner is an alga that photosynthesises.")+
   U("Grey-green lichen patches on old walls show this fungus-and-alga teamwork at work."),
   [("moss","Moss is a small green plant, not the photosynthetic partner inside a lichen."),
    ("insect","An insect is an animal and cannot photosynthesise; the lichen's partner is an alga."),
    ("bacterium","The classic lichen partner that makes food is an alga, not a bacterium.")]),

 ("NP","Carbon dioxide needed for photosynthesis enters the leaf chiefly through its:",
   "stomata",
   C("Carbon dioxide diffuses into the leaf through the stomata, the tiny pores on its surface.")+
   steps("The leaf must take in carbon dioxide from air","air enters through surface pores","those pores are the stomata.")+
   U("With its stomata open in daylight, a leaf drinks in carbon dioxide to build sugars."),
   [("roots","Roots absorb water and minerals from soil, not carbon dioxide from the air."),
    ("waxy cuticle","The waxy cuticle is a sealing layer that resists gas passage, not the entry point."),
    ("flowers","Flowers are for reproduction; carbon dioxide enters the leaf, through its stomata.")]),

 ("NP","A destarched plant is kept in sunlight with one leaf partly covered by black paper. After the starch test, the covered part stays pale because that part:",
   "received no light and made no food",
   C("Photosynthesis needs light; the covered strip got none, so it made no starch and gave no blue-black.")+
   steps("Both parts had chlorophyll and air","only the uncovered part received light","without light no starch formed, so the covered part stays pale.")+
   U("This classic covered-leaf experiment proves sunlight is essential for a leaf to make food."),
   [("had no chlorophyll","The covered strip still had chlorophyll; what it lacked was sunlight."),
    ("was given extra water","Water reached the whole leaf; the pale strip's problem was missing light."),
    ("was the oldest part of the leaf","Age did not cause the pale strip; the black paper blocked its light.")]),

 ("NP","Water and dissolved minerals taken up by the roots are carried up to the leaves through tube-like vessels called:",
   "xylem",
   C("Xylem vessels carry water and minerals upward from the roots to the leaves.")+
   steps("Roots absorb water and minerals","these must travel up to the leaves","they rise through the xylem tubes.")+
   U("Cut a celery stalk standing in coloured water and you see the xylem tubes carrying it up."),
   [("phloem","Phloem carries made food away from the leaves, not water up from the roots."),
    ("stomata","Stomata are leaf pores for gases, not the tubes that carry water up the stem."),
    ("cuticle","The cuticle is a protective waxy layer; it does not transport water.")]),

 ("NP","The simple sugar first made during photosynthesis, before it is stored as starch, is:",
   "glucose",
   C("Photosynthesis first makes glucose, a simple sugar, which the plant later stores as starch.")+
   steps("The leaf joins carbon dioxide and water using sunlight","the first food made is the sugar glucose","extra glucose is stored as starch.")+
   U("The sweetness building up in ripening fruit traces back to glucose made in the leaves."),
   [("protein","Proteins are built later using nitrogen; the first food made is the sugar glucose."),
    ("oxygen","Oxygen is a released by-product, not the food sugar the leaf makes."),
    ("fat","Fats can be made later for storage, but the first product of photosynthesis is glucose.")]),

 ("NP","A leaf has roughly the shape of a rectangle 8 cm long and 3 cm wide. Treating it so, the sunlit surface area of one side is about:",
   "24 square cm",
   C("Area of a rectangle is length times breadth, so the leaf's flat face is about 8 × 3 = 24 cm². [FUSION: Nutrition in Plants × area]")+
   steps("Model the leaf as a rectangle 8 cm by 3 cm","area = length × breadth = 8 × 3","that gives 24 square centimetres of sunlit surface.")+
   U("A bigger sunlit leaf area catches more light, so it can make more food."),
   [("11 square cm","11 cm is 8 + 3, the half-perimeter, not the area; area multiplies the two sides."),
    ("22 square cm","22 cm is the full perimeter (2 × (8 + 3)), a length, not an area."),
    ("16 square cm","16 cm² would be 8 × 2; the breadth here is 3 cm, giving 8 × 3 = 24.")]),

 ("NP","One leaf makes about 5 mg of starch in an hour. A branch of 12 such leaves, working for 3 hours, makes a total starch of:",
   "180 mg",
   C("Multiply leaves, rate and hours: 12 × 5 × 3 = 180 mg of starch. [FUSION: Nutrition in Plants × multiplication]")+
   steps("One leaf makes 5 mg each hour","12 leaves in 1 hour make 12 × 5 = 60 mg","over 3 hours that is 60 × 3 = 180 mg.")+
   U("A leafy plant on a long sunny day stores up a surprising amount of food."),
   [("60 mg","60 mg is just one hour's work for all 12 leaves; the question asks for 3 hours."),
    ("20 mg","20 mg ignores the leaves; it is only 5 × 4, not 12 leaves over 3 hours."),
    ("36 mg","36 is 12 × 3 but leaves out the 5 mg rate; the full product is 12 × 5 × 3 = 180.")]),

 ("NP","A single mesophyll cell divides so the number of food-making cells doubles each round: 1, 2, 4, 8, … After 5 rounds the count of cells, written as a power of 2, is:",
   "2 to the power 5, which is 32",
   C("Doubling five times means 2⁵ = 32 cells. [FUSION: Nutrition in Plants × exponents]")+
   steps("Each round doubles the cell count","five doublings give 2 × 2 × 2 × 2 × 2","that is 2⁵ = 32 cells.")+
   U("Tissues grow by repeated doubling, so cell counts climb as powers of two."),
   [("2 to the power 5, which is 10","2⁵ means five 2's multiplied, not 2 × 5; that product is 32, not 10."),
    ("5 to the power 2, which is 25","5² is 25, but doubling gives base 2, so it is 2⁵ = 32."),
    ("2 to the power 4, which is 16","Four doublings give 16; the fifth doubling takes it to 32.")]),

 ("NP","A square patch of clover used to fix nitrogen measures 9 m along each side. The area of soil it enriches is:",
   "81 square metres",
   C("Area of a square is side × side, so 9 × 9 = 81 m². [FUSION: Nutrition in Plants × area]")+
   steps("The patch is a square of side 9 m","area of a square = side × side","9 × 9 = 81 square metres.")+
   U("Knowing the patch area helps a farmer judge how much soil the clover will enrich."),
   [("36 square metres","36 m is the perimeter (4 × 9), a length, not the area."),
    ("18 square metres","18 is 9 + 9 or 9 × 2, not the side multiplied by itself."),
    ("90 square metres","90 is 9 × 10; the square's area is 9 × 9 = 81.")]),

 ("NP","A plant packs the energy of about 10 × 10 × 10 sunlight-units into one starch grain. Written as a power of ten, that energy is:",
   "10 to the power 3",
   C("10 × 10 × 10 is 10³, that is 1000 units. [FUSION: Nutrition in Plants × powers of ten]")+
   steps("Three tens are multiplied together","that is written 10³","its value is 1000 units.")+
   U("Powers of ten are a quick shorthand for the big numbers nature deals in."),
   [("10 to the power 2","10² is 10 × 10 = 100; here three tens are multiplied, so it is 10³."),
    ("3 to the power 10","3¹⁰ uses base 3; here the base is 10 multiplied three times, so 10³."),
    ("30","30 is 10 × 3, not 10 multiplied by itself three times, which is 1000.")]),

 ("NP","A potted plant kept in a totally dark cupboard for many days grows pale and weak chiefly because, without light, its leaves cannot:",
   "carry out photosynthesis to make food",
   C("Without light the leaves cannot photosynthesise, so the plant runs short of food and weakens.")+
   steps("Photosynthesis needs light energy","in the dark the leaves cannot make food","starved of food, the plant grows pale and weak.")+
   U("A plant pushed into a dark corner soon yellows and droops for want of light."),
   [("absorb water through their roots","Roots can still take up water in the dark; the missing factor is light for food-making."),
    ("breathe out carbon dioxide","Plants respire day and night; darkness stops food-making, not breathing."),
    ("grow new roots underground","Root growth is not the issue; without light the leaves cannot make food.")]),
]

# ---------- WASTEWATER STORY (25) — Science (some fused) ----------
WW = [
 ("WW","The used, dirty water that drains from homes, factories and farms — water rich in waste — is given the general name:",
   "sewage",
   C("Sewage is the wastewater carrying human, household and industrial waste that flows out through drains.")+
   steps("Used water leaves homes, farms and factories","it carries dissolved and solid waste","this dirty wastewater is called sewage.")+
   U("Whatever goes down the kitchen sink or the toilet becomes part of the sewage."),
   [("rainwater","Rainwater is naturally clean falling water, not the waste-laden water from drains."),
    ("ground water","Ground water lies stored beneath the soil and is usually clean, unlike sewage."),
    ("distilled water","Distilled water is purified water with nothing dissolved in it, the opposite of sewage.")]),

 ("WW","The network of underground pipes that carries sewage away from buildings to a treatment plant is the:",
   "sewer system",
   C("Sewers are the buried pipes that carry sewage from homes to a wastewater treatment plant.")+
   steps("Sewage must be carried away from where it is made","a web of underground pipes does this","that network is the sewer system.")+
   U("Under every town's streets runs a hidden sewer network taking dirty water away."),
   [("water mains","Water mains bring clean drinking water in; sewers carry dirty water out."),
    ("canal","A canal is an open channel, often for irrigation, not the closed pipes for sewage."),
    ("aqueduct","An aqueduct carries clean water across distances; it is not the sewage pipe network.")]),

 ("WW","At a treatment plant the sewage is first passed through bar screens, whose job is to remove:",
   "large floating objects like rags and sticks",
   C("Bar screens trap big floating solids such as rags, sticks and plastic before further treatment.")+
   steps("Raw sewage carries large floating junk","bar screens are metal bars with gaps","they hold back the big objects and let water through.")+
   U("Cloth, polythene and twigs are caught on the bar screens right at the plant's entrance."),
   [("dissolved salts","Dissolved salts pass through the bars; screens only catch large floating solids."),
    ("harmful bacteria","Bacteria are microscopic and slip past the bars; screens stop large objects."),
    ("bad smell","Screens remove solids, not odour; smell is dealt with later in treatment.")]),

 ("WW","After screening, the sewage flows slowly through a grit-and-sand removal tank so that:",
   "sand, grit and pebbles settle out",
   C("In the grit chamber the slow flow lets heavy sand, grit and pebbles sink and be removed.")+
   steps("Sewage still carries gritty heavy particles","the water is slowed in a tank","sand and grit settle to the bottom and are taken out.")+
   U("Slowing the flow drops the gritty soil so it does not wear out later machinery."),
   [("oil rises and is skimmed","Oil is skimmed in a different step; the grit chamber drops heavy sand, not oil."),
    ("bacteria are added","Bacteria are added later to digest waste; the grit chamber simply settles sand."),
    ("chlorine kills germs","Chlorination is a final step; the grit chamber removes sand and grit, not germs.")]),

 ("WW","In a settling tank the cleared water moves on while the solids that sink to the bottom are collected as:",
   "sludge",
   C("The solid muck that settles at the bottom of a sedimentation tank is called sludge.")+
   steps("In the settling tank heavy solids sink","this settled solid layer is scraped from the bottom","that material is the sludge.")+
   U("The thick sludge from a treatment plant is later digested to make biogas and manure."),
   [("scum","Scum is the oily layer skimmed from the top, not the solid that settles at the bottom."),
    ("clarified water","Clarified water is the cleared liquid that moves on, not the settled solid."),
    ("grit","Grit is the sand removed earlier; the settled organic solid here is sludge.")]),

 ("WW","Floatable oil, grease and fat that rise to the surface of the settling tank are removed by:",
   "skimming them off the top",
   C("Lighter oils and grease float up and are skimmed off as scum from the tank's surface.")+
   steps("Oil and grease are lighter than water","they float to the top of the tank","a skimmer scrapes this scum off the surface.")+
   U("Cooking oil poured down the sink ends up as floating scum that must be skimmed at the plant."),
   [("letting them settle at the bottom","Oil is lighter than water and rises; only heavy solids settle to the bottom."),
    ("boiling the whole tank","Plants do not boil sewage; the floating oil is simply skimmed off."),
    ("filtering through sand","Floating oil is skimmed from the surface, not pushed through a sand filter.")]),

 ("WW","After settling, the water is sent to an aeration tank where air is bubbled through it. This air feeds helpful microbes that:",
   "consume the dissolved and suspended organic waste",
   C("Air-loving bacteria in the aeration tank eat up organic waste, cleaning the water further.")+
   steps("Cleared water still holds dissolved organic waste","air is bubbled in to feed aerobic bacteria","these microbes consume the organic waste.")+
   U("The frothy aeration tank is where tiny bacteria do the real cleaning of the water."),
   [("add minerals back to the water","The microbes remove organic waste; they are not there to add minerals."),
    ("turn the water into drinking water at once","Treated water is cleaner but still not instantly drinkable from this step."),
    ("colour the water blue","Aeration feeds bacteria to eat waste; it does not dye the water.")]),

 ("WW","The clarified water leaving the treatment plant, now much cleaner, is usually:",
   "released into a river or sea, or used for gardening",
   C("Treated water can be discharged into rivers or the sea, or reused to water parks and fields.")+
   steps("The water has been screened, settled and digested by microbes","it is now far cleaner than raw sewage","it is released to a water body or reused for irrigation.")+
   U("Treated wastewater often greens city parks and gardens instead of being wasted."),
   [("poured back into the toilet","Treated water is reused or released to nature, not cycled straight back into toilets."),
    ("sealed in tanks forever","Storing it forever is pointless; cleaned water is released or reused."),
    ("burned as fuel","Water cannot be burned; the cleaned water is released or used for irrigation.")]),

 ("WW","Throwing cooking oil, paint and chemicals down the drain is harmful mainly because they:",
   "kill the helpful microbes that clean sewage",
   C("Oils and chemicals poison the bacteria that break down waste, crippling the treatment process.")+
   steps("Treatment relies on helpful microbes eating waste","oils and chemicals are toxic to these microbes","so pouring them down the drain harms cleaning.")+
   U("Tipping leftover paint down the sink can quietly cripple a whole treatment plant."),
   [("make the water taste sweet","Chemicals down the drain harm microbes; taste is not the concern here."),
    ("help the pipes flow faster","Oils actually clog pipes and harm microbes; they do not speed flow."),
    ("turn sewage into drinking water","These wastes poison the cleaning microbes; they do not purify water.")]),

 ("WW","A simple low-cost sanitation toilet that needs no flush water and turns waste into manure is the:",
   "compost toilet",
   C("A compost (or vermi-composting) toilet treats waste on the spot, turning it into useful manure without flushing.")+
   steps("Some places lack water and sewers for flush toilets","a compost toilet collects waste in a chamber","microbes or worms turn it into manure.")+
   U("Eco-toilets in dry regions save water and give farmers free compost."),
   [("flush toilet on a sewer","A flush toilet needs water and a sewer; the no-flush, manure-making one is a compost toilet."),
    ("septic tank with soak pit","A septic tank still uses flush water; the no-water manure type is the compost toilet."),
    ("open drain","An open drain is not a toilet and spreads disease; it is the opposite of safe sanitation.")]),

 ("WW","Leaving human waste in the open is dangerous because flies and contaminated water can spread diseases such as:",
   "cholera and typhoid",
   C("Open defecation lets germs reach food and water, spreading diseases like cholera, typhoid and dysentery.")+
   steps("Waste left open carries disease germs","flies and water carry these germs to food","this spreads illnesses like cholera and typhoid.")+
   U("Clean toilets and treated sewage are a town's first defence against cholera outbreaks."),
   [("malaria and dengue","Malaria and dengue spread through mosquitoes, not chiefly through human waste in water."),
    ("scurvy and rickets","Scurvy and rickets come from missing vitamins, not from contaminated water."),
    ("asthma and allergy","Asthma and allergy are not water-borne diseases spread by open waste.")]),

 ("WW","Open drains and uncovered waste are a serious health risk partly because stagnant dirty water becomes a breeding place for:",
   "disease-carrying mosquitoes and flies",
   C("Stagnant sewage breeds mosquitoes and flies that carry disease, so drains should be covered and clean.")+
   steps("Still, dirty water collects in open drains","mosquitoes and flies breed there","these insects then spread disease.")+
   U("A covered, flowing drain gives mosquitoes nowhere to breed near homes."),
   [("clean drinking water","Stagnant sewage is the opposite of clean water; it breeds disease carriers."),
    ("useful honeybees","Honeybees do not breed in dirty drains; mosquitoes and flies do."),
    ("oxygen bubbles","Stagnant sewage actually loses oxygen; it breeds insects, not oxygen.")]),

 ("WW","The thick sludge collected from sewage is often put into a sealed tank without air, where bacteria digest it and release a useful fuel gas called:",
   "biogas",
   C("In an anaerobic digester, bacteria break down sludge and give off biogas, a usable fuel.")+
   steps("Sludge is sealed in an airless tank","anaerobic bacteria digest the organic matter","they release biogas, which can be burned as fuel.")+
   U("Some treatment plants run on the very biogas they make from their own sludge."),
   [("oxygen","Oxygen is used up, not released; the digester gives off biogas instead."),
    ("chlorine","Chlorine is added to disinfect water; it is not a gas made by digesting sludge."),
    ("petrol","Petrol comes from crude oil refining, not from bacteria digesting sewage sludge.")]),

 ("WW","Citizens can help wastewater treatment work better by NOT throwing into the drain things like:",
   "tea leaves, cotton, sanitary towels and plastic",
   C("Solids like tea leaves, cotton, plastics and oils clog pipes and harm treatment, so they should go in a bin.")+
   steps("Drains are meant only for dirty water","solid items clog pipes and choke treatment","so tea leaves, cotton, plastics and oils belong in a bin.")+
   U("Putting kitchen solids in the bin, not the sink, keeps the town's drains flowing."),
   [("only clean rainwater","Clean rainwater is fine; the warning is against solids and oils, not rain."),
    ("treated water from the plant","Treated water is the harmless output; the rule is about not adding solids."),
    ("dissolved oxygen","You cannot throw away dissolved oxygen; the rule targets solids and oils.")]),

 ("WW","The final treatment step where the cleaned water is disinfected, often by adding chlorine, is meant to:",
   "kill any remaining harmful germs",
   C("Chlorination disinfects the treated water, killing leftover disease-causing germs before release.")+
   steps("Even cleaned water may hold some germs","chlorine (or ozone/UV) is added","this kills the remaining harmful microbes.")+
   U("The faint chlorine smell of tap water is a sign that germs have been killed."),
   [("add nutrients for plants","Chlorination kills germs; it does not add plant nutrients to the water."),
    ("make the water fizzy","Disinfection is for safety, not to add fizz to the water."),
    ("turn the water into ice","Chlorine disinfects; it has nothing to do with freezing the water.")]),

 ("WW","A household uses about 150 litres of water a day and sends roughly four-fifths of it down the drain as wastewater. The wastewater made each day is:",
   "120 litres",
   C("Four-fifths of 150 is (4 ÷ 5) × 150 = 120 litres of wastewater. [FUSION: Wastewater Story × fractions]")+
   steps("Find one-fifth of 150: 150 ÷ 5 = 30","four-fifths is 4 × 30 = 120","so 120 litres become wastewater each day.")+
   U("Knowing how much wastewater a home makes helps plan the size of treatment plants."),
   [("30 litres","30 litres is only one-fifth of 150; four-fifths is 4 × 30 = 120."),
    ("150 litres","150 litres is all the water used; only four-fifths, 120 litres, becomes wastewater."),
    ("75 litres","75 litres is half of 150; the fraction here is four-fifths, giving 120.")]),

 ("WW","An aeration tank's floor is a rectangle 12 m long and 5 m wide. The area of its floor is:",
   "60 square metres",
   C("Area of a rectangle is length × breadth, so 12 × 5 = 60 m². [FUSION: Wastewater Story × area]")+
   steps("The floor is a rectangle 12 m by 5 m","area = length × breadth = 12 × 5","that gives 60 square metres.")+
   U("Engineers size a treatment tank's floor area to handle a town's daily sewage."),
   [("34 square metres","34 m is the perimeter (2 × (12 + 5)), a length, not the area."),
    ("17 square metres","17 m is just 12 + 5, the half-perimeter, not the area."),
    ("120 square metres","120 would be 12 × 10; the width is 5 m, so the area is 12 × 5 = 60.")]),

 ("WW","Bacteria in an aeration tank double every hour. Starting from 1 colony, the number of colonies after 6 hours, written with a power, is:",
   "2 to the power 6, which is 64",
   C("Doubling six times gives 2⁶ = 64 colonies. [FUSION: Wastewater Story × exponents]")+
   steps("Each hour the colony count doubles","six doublings is 2 × 2 × 2 × 2 × 2 × 2","that is 2⁶ = 64 colonies.")+
   U("Cleaning microbes multiply fast, so their numbers climb as powers of two."),
   [("2 to the power 6, which is 12","2⁶ means six 2's multiplied, not 2 × 6; the value is 64, not 12."),
    ("6 to the power 2, which is 36","6² is 36, but doubling has base 2, so it is 2⁶ = 64."),
    ("2 to the power 5, which is 32","Five doublings give 32; the sixth doubling makes 64.")]),

 ("WW","A treatment plant cleans 1000 litres in the time it takes to clean 10 × 10 batches of 10 litres. Written as a power of ten, 1000 is:",
   "10 to the power 3",
   C("1000 is 10 × 10 × 10 = 10³. [FUSION: Wastewater Story × powers of ten]")+
   steps("1000 = 10 × 10 × 10","three tens multiplied is written 10³","so 1000 equals 10 to the power 3.")+
   U("Powers of ten keep big plant-capacity numbers short and easy to compare."),
   [("10 to the power 2","10² is only 100; one thousand is 10 × 10 × 10 = 10³."),
    ("10 to the power 4","10⁴ is 10 000; one thousand is 10³, one ten less."),
    ("100 to the power 3","100³ is a million; 1000 is 10 multiplied three times, that is 10³.")]),

 ("WW","A square settling tank has each side 7 m long. The length of fencing needed to run once around its top edge (its perimeter) is:",
   "28 metres",
   C("Perimeter of a square is 4 × side, so 4 × 7 = 28 m. [FUSION: Wastewater Story × perimeter]")+
   steps("A square has four equal sides","each side is 7 m","perimeter = 4 × 7 = 28 metres.")+
   U("Knowing the perimeter tells workers how much railing to fit around a tank."),
   [("49 metres","49 m² is the area (7 × 7); the distance around the edge is 4 × 7 = 28."),
    ("14 metres","14 m is only two sides (7 + 7); a square has four sides, so 28 m."),
    ("11 metres","11 m has no clear meaning here; the perimeter of the square is 4 × 7 = 28.")]),

 ("WW","A town produces 2400 litres of sludge a day. If a digester can be filled by collecting equal amounts over 8 hours, the sludge gathered each hour is:",
   "300 litres",
   C("Divide the day's sludge by the hours: 2400 ÷ 8 = 300 litres per hour. [FUSION: Wastewater Story × division]")+
   steps("Total sludge is 2400 litres over 8 hours","share it equally: 2400 ÷ 8","that gives 300 litres each hour.")+
   U("Even hourly collection keeps a digester filling at a steady, manageable rate."),
   [("19200 litres","19200 is 2400 × 8; sharing over hours means dividing, giving 300, not multiplying."),
    ("240 litres","240 is 2400 ÷ 10, but there are 8 hours, so 2400 ÷ 8 = 300."),
    ("8 litres","8 is just the number of hours, not the sludge per hour, which is 300.")]),

 ("WW","Out of every 100 litres of treated water, a park reuses 35 litres for watering. The percentage of treated water reused for the park is:",
   "35 percent",
   C("35 out of 100 is exactly 35 percent. [FUSION: Wastewater Story × percentages]")+
   steps("35 litres are reused out of every 100","'per cent' means 'out of a hundred'","35 out of 100 is 35 percent.")+
   U("Reusing treated water for parks saves precious fresh water for drinking."),
   [("65 percent","65 percent is the part NOT reused (100 − 35); the reused part is 35 percent."),
    ("3.5 percent","3.5 percent would be 3.5 out of 100; here it is 35 out of 100, that is 35 percent."),
    ("100 percent","Only 35 of every 100 litres are reused, not all of it, so it is 35 percent.")]),

 ("WW","A rectangular grit tank is 10 m long and 4 m wide. The distance you walk going once around its edge is:",
   "28 metres",
   C("Perimeter of a rectangle is 2 × (length + breadth) = 2 × (10 + 4) = 28 m. [FUSION: Wastewater Story × perimeter]")+
   steps("Add length and breadth: 10 + 4 = 14","go around both pairs of sides: 2 × 14","that gives a perimeter of 28 metres.")+
   U("The walk-around distance tells workers how much walkway railing a tank needs."),
   [("40 square metres","40 is the area (10 × 4) in square metres, not the distance around the edge."),
    ("14 metres","14 m is just length plus breadth, half the perimeter; the full trip is 28 m."),
    ("20 metres","20 m is 2 × 10, only the two long sides; the perimeter is 2 × (10 + 4) = 28.")]),

 ("WW","A plant treats 5 lakh litres of sewage a day. Written in the short power-of-ten form (5 × 10 raised to a power), 500000 is:",
   "5 times 10 to the power 5",
   C("500000 is 5 followed by five zeros, so it is 5 × 10⁵. [FUSION: Wastewater Story × exponents]")+
   steps("Count the zeros after the 5 in 500000: there are five","each zero is a factor of ten, so that is 10⁵","the number is 5 × 10⁵.")+
   U("Scientists write huge plant capacities in power-of-ten form to keep them short."),
   [("5 times 10 to the power 4","5 × 10⁴ is 50000, ten times too small; 500000 needs 10⁵."),
    ("5 times 10 to the power 6","5 × 10⁶ is 5000000, ten times too big; 500000 is 5 × 10⁵."),
    ("50 times 10 to the power 5","50 × 10⁵ is 5000000; the tidy form of 500000 is 5 × 10⁵.")]),

 ("WW","The main reason a town builds a wastewater treatment plant rather than letting sewage flow straight into a river is to:",
   "stop disease and protect the river's plants and animals",
   C("Untreated sewage spreads disease and chokes river life, so treatment protects both people and the river.")+
   steps("Raw sewage carries germs and rots, using up the river's oxygen","fish and plants die and people fall ill","treating it first prevents disease and protects the river.")+
   U("Towns that treat their sewage keep their rivers alive and their people healthy."),
   [("make the river flow faster","Treatment is about cleaning the water, not changing how fast the river flows."),
    ("turn the river water sweet","Treatment removes waste and germs; it is not done to sweeten the river."),
    ("collect rainwater for drinking","A treatment plant cleans sewage; rainwater harvesting is a separate idea.")]),
]

# ---------- PERIMETER & AREA (25) — Maths (some fused) ----------
PA = [
 ("PA","The total distance once around the boundary of a closed flat shape is called its:",
   "perimeter",
   C("Perimeter is the total length of the boundary of a closed figure.")+
   steps("Walk all the way around the edge of a shape","add up every side you travel","that total length is the perimeter.")+
   U("The fencing you buy to enclose a field is measured by the field's perimeter."),
   [("area","Area is the surface a shape covers, measured in square units, not the boundary length."),
    ("volume","Volume is the space a solid takes up; perimeter is a length around a flat shape."),
    ("diameter","Diameter is the width across a circle, not the distance around a whole shape.")]),

 ("PA","The amount of flat surface a shape covers, measured in square units, is its:",
   "area",
   C("Area is the measure of the surface enclosed by a shape, given in square units.")+
   steps("Look at the surface a shape covers","count how many unit squares fit inside","that count is the area.")+
   U("The tiles needed to cover a floor are worked out from the floor's area."),
   [("perimeter","Perimeter is the boundary length, measured in plain units, not the surface covered."),
    ("height","Height is one measurement of a shape, not the whole surface it covers."),
    ("radius","Radius is the distance from a circle's centre to its edge, not a surface measure.")]),

 ("PA","For a rectangle whose length is l and whose breadth is b, the correct rule for its boundary length is:",
   "2 times (l + b)",
   C("A rectangle has two lengths and two breadths, so its perimeter is 2 × (l + b).")+
   steps("Add one length and one breadth: l + b","there are two of each pair","so perimeter = 2 × (l + b).")+
   U("To border a rectangular photo with tape, you need 2 × (l + b) of tape."),
   [("l times b","l × b gives the area of the rectangle, not its boundary length."),
    ("l + b","l + b is only half the way around; the full perimeter is 2 × (l + b)."),
    ("4 times l","4 × l fits a square of side l, not a rectangle with different sides.")]),

 ("PA","The area of a rectangle with length 9 cm and breadth 4 cm is:",
   "36 square cm",
   C("Area of a rectangle is length × breadth, so 9 × 4 = 36 cm².")+
   steps("Multiply length by breadth","9 × 4 = 36","so the area is 36 square centimetres.")+
   U("A 9 cm by 4 cm card covers 36 cm² of the table it lies on."),
   [("26 square cm","26 cm is the perimeter (2 × (9 + 4)), a length, not the area."),
    ("13 square cm","13 cm is just 9 + 4, the half-perimeter, not the area."),
    ("36 cm","The number 36 is right but area is in square units, so it is 36 square cm.")]),

 ("PA","A square has each side 6 cm long. Its perimeter is:",
   "24 cm",
   C("Perimeter of a square is 4 × side, so 4 × 6 = 24 cm.")+
   steps("A square has four equal sides","each side is 6 cm","perimeter = 4 × 6 = 24 cm.")+
   U("To frame a square 6 cm tile, you need 24 cm of edging."),
   [("36 cm","36 cm² is the area (6 × 6); the distance around is 4 × 6 = 24 cm."),
    ("12 cm","12 cm is only two sides (6 + 6); a square has four, so 24 cm."),
    ("10 cm","10 cm has no clear basis here; the square's perimeter is 4 × 6 = 24.")]),

 ("PA","A square garden plot measures 7 m along every edge. The surface it covers works out to:",
   "49 square metres",
   C("Area of a square is side × side, so 7 × 7 = 49 m².")+
   steps("Multiply the side by itself","7 × 7 = 49","so the area is 49 square metres.")+
   U("A square garden of side 7 m covers 49 m² of ground."),
   [("28 square metres","28 m is the perimeter (4 × 7), a length, not the area."),
    ("14 square metres","14 is 7 + 7 or 7 × 2, not the side multiplied by itself."),
    ("49 metres","The value 49 is right but area is in square metres, not plain metres.")]),

 ("PA","A rectangular field is 40 m long and 25 m wide. The length of wire needed to fence it all the way round is:",
   "130 metres",
   C("Perimeter of the rectangle is 2 × (40 + 25) = 2 × 65 = 130 m of fencing.")+
   steps("Add length and breadth: 40 + 25 = 65","go around both pairs: 2 × 65","that needs 130 metres of wire.")+
   U("A farmer buys fencing wire by the perimeter of the field to be enclosed."),
   [("1000 metres","1000 m² is the area (40 × 25); fencing follows the perimeter, 130 m."),
    ("65 metres","65 m is just length plus breadth, half the way round; the full fence is 130 m."),
    ("80 metres","80 m is only 2 × 40, the two long sides; the perimeter is 2 × (40 + 25) = 130.")]),

 ("PA","The area of a right triangle is half the base times the height. A triangle of base 10 cm and height 6 cm has area:",
   "30 square cm",
   C("Area of a triangle is ½ × base × height, so ½ × 10 × 6 = 30 cm².")+
   steps("Multiply base by height: 10 × 6 = 60","take half: 60 ÷ 2 = 30","so the area is 30 square centimetres.")+
   U("A triangular flag's cloth area is worked out as half its base times its height."),
   [("60 square cm","60 cm² is base × height; a triangle's area is half of that, so 30 cm²."),
    ("16 square cm","16 is 10 + 6, not half of base times height, which is 30."),
    ("30 cm","The value 30 is right but area is in square units, so 30 square cm.")]),

 ("PA","A square and a rectangle have the same perimeter. The square's side is 8 cm; the rectangle is 10 cm long. The rectangle's breadth is:",
   "6 cm",
   C("The square's perimeter is 4 × 8 = 32 cm; for the rectangle, 2 × (10 + b) = 32 gives b = 6 cm.")+
   steps("Square perimeter = 4 × 8 = 32 cm","rectangle: 2 × (10 + b) = 32, so 10 + b = 16","b = 16 − 10 = 6 cm.")+
   U("Two frames with the same edging can still be different shapes inside."),
   [("8 cm","8 cm would make the rectangle a square; matching perimeters here gives breadth 6 cm."),
    ("16 cm","16 cm is length plus breadth (10 + b), not the breadth itself, which is 6."),
    ("4 cm","4 cm would give perimeter 28, not 32; the matching breadth is 6 cm.")]),

 ("PA","One side of a square room is doubled to make a bigger square. The new area compared with the old is:",
   "4 times as large",
   C("Doubling the side multiplies the area by 2 × 2 = 4, since area depends on side squared.")+
   steps("Old area = side × side","new side is 2 × side, so new area = 2 × side × 2 × side","that is 4 × (side × side), four times the old area.")+
   U("Doubling a room's side gives four times the floor, not just twice."),
   [("2 times as large","Doubling the side doubles each of two dimensions, giving 2 × 2 = 4 times, not 2."),
    ("3 times as large","The area grows by the square of the scale; doubling gives 4 times, not 3."),
    ("8 times as large","8 times is for volume of a doubled cube; flat area grows 4 times.")]),

 ("PA","A path runs around the inside edge of a square plot. If the plot's perimeter is 48 m, each side of the square is:",
   "12 metres",
   C("A square's perimeter is 4 × side, so side = 48 ÷ 4 = 12 m.")+
   steps("Perimeter = 4 × side = 48","divide both sides by 4","side = 48 ÷ 4 = 12 metres.")+
   U("Knowing one side helps you work out a square plot's area for planting."),
   [("24 metres","24 m is half the perimeter; each side is the perimeter divided by 4, that is 12."),
    ("6 metres","6 m would give a perimeter of 24, not 48; the side here is 12 m."),
    ("48 metres","48 m is the whole perimeter, not one side, which is 48 ÷ 4 = 12.")]),

 ("PA","A rectangular tile covers 48 cm² of surface and measures 8 cm along its length. Working backwards, its breadth must be:",
   "6 cm",
   C("Breadth = area ÷ length, so 48 ÷ 8 = 6 cm.")+
   steps("Area = length × breadth = 48","so breadth = 48 ÷ length = 48 ÷ 8","breadth = 6 cm.")+
   U("Knowing a tile's area and length lets you find its width to fit a gap."),
   [("40 cm","40 is 48 − 8, but breadth is found by dividing, 48 ÷ 8 = 6, not subtracting."),
    ("384 cm","384 is 48 × 8; breadth comes from dividing area by length, giving 6."),
    ("8 cm","8 cm is the given length; the breadth is 48 ÷ 8 = 6 cm.")]),

 ("PA","To find how many square tiles of side 1 m cover a floor 5 m by 3 m, you should compute the floor's:",
   "area",
   C("The number of unit tiles equals the floor's area, 5 × 3 = 15 tiles.")+
   steps("Each 1 m tile covers one square metre","count how many fit: that is the area","5 × 3 = 15 tiles cover the floor.")+
   U("Tilers always work out floor area first to know how many tiles to buy."),
   [("perimeter","Perimeter tells the boundary length, not how many tiles cover the surface."),
    ("height","Height is not part of a flat floor's tiling; the area decides the tile count."),
    ("diagonal","The diagonal is one line across; tile count comes from the area.")]),

 ("PA","The area of a rectangle is 56 m² and its breadth is 7 m. Its perimeter is:",
   "30 metres",
   C("Length = 56 ÷ 7 = 8 m, so perimeter = 2 × (8 + 7) = 30 m.")+
   steps("Find length: area ÷ breadth = 56 ÷ 7 = 8 m","perimeter = 2 × (length + breadth) = 2 × (8 + 7)","that is 2 × 15 = 30 metres.")+
   U("From a known area and one side you can still work out the fencing needed."),
   [("15 metres","15 m is length plus breadth (8 + 7), half the way round; the full perimeter is 30."),
    ("56 metres","56 is the area in square metres, not the perimeter, which is 30 m."),
    ("28 metres","28 would need different sides; here length 8 and breadth 7 give 2 × 15 = 30.")]),

 ("PA","A wire 36 cm long is bent into a square. The area enclosed by the square is:",
   "81 square cm",
   C("Side = 36 ÷ 4 = 9 cm, so area = 9 × 9 = 81 cm².")+
   steps("The wire is the perimeter: 4 × side = 36, so side = 9 cm","area of the square = side × side","9 × 9 = 81 square centimetres.")+
   U("Bending a fixed length of wire into a square gives the most area for that wire."),
   [("36 square cm","36 cm is the wire's length (the perimeter), not the area, which is 81 cm²."),
    ("144 square cm","144 cm² would be side 12; here the side is 36 ÷ 4 = 9, giving 81."),
    ("9 square cm","9 cm is the side length; the area is 9 × 9 = 81 square cm.")]),

 ("PA","The distance around a circular flower bed is called its:",
   "circumference",
   C("The boundary length of a circle is its circumference, the circular version of perimeter.")+
   steps("Perimeter is the distance around any closed shape","for a circle this boundary has a special name","it is called the circumference.")+
   U("To edge a round bed with bricks, you measure its circumference."),
   [("radius","Radius is the distance from the centre to the edge, not the distance around."),
    ("area","Area is the surface a circle covers, not the distance around its boundary."),
    ("diameter","Diameter crosses the circle through the centre; the way around is the circumference.")]),

 ("PA","A rectangular garden 20 m by 15 m has a 1 m wide path running all around it on the OUTSIDE is not asked; instead, the garden's own area is:",
   "300 square metres",
   C("Area of the rectangle is length × breadth, so 20 × 15 = 300 m².")+
   steps("Multiply length by breadth","20 × 15 = 300","so the garden covers 300 square metres.")+
   U("Knowing a garden's area tells you how much manure to spread over it."),
   [("70 square metres","70 m is the perimeter (2 × (20 + 15)), a length, not the area."),
    ("35 square metres","35 m is just 20 + 15, the half-perimeter, not the area."),
    ("300 metres","The value 300 is right but area is in square metres, not plain metres.")]),

 ("PA","Two identical right triangles, each of base 8 cm and height 5 cm, are joined to form a rectangle. The rectangle's area is:",
   "40 square cm",
   C("Each triangle is ½ × 8 × 5 = 20 cm²; two of them make 8 × 5 = 40 cm².")+
   steps("One triangle's area = ½ × 8 × 5 = 20 cm²","two equal triangles make a rectangle","its area = 8 × 5 = 40 square centimetres.")+
   U("Two matching triangular tiles fit together into a neat rectangle."),
   [("20 square cm","20 cm² is just one triangle; two together make 40 cm²."),
    ("13 square cm","13 is 8 + 5, not the area; the rectangle's area is 8 × 5 = 40."),
    ("80 square cm","80 cm² would be 8 × 10; the height is 5, so the rectangle is 8 × 5 = 40.")]),

 ("PA","A leaf shaped like a rectangle is 6 cm by 2 cm. A caterpillar eats a square hole of side 1 cm in it. The leaf area left is:",
   "11 square cm",
   C("Leaf area is 6 × 2 = 12 cm²; subtract the 1 × 1 = 1 cm² hole to get 11 cm². [FUSION: leaf biology × area]")+
   steps("Whole leaf area = 6 × 2 = 12 cm²","the hole eaten = 1 × 1 = 1 cm²","area left = 12 − 1 = 11 square centimetres.")+
   U("A leaf with bites taken out has less sunlit area, so it makes a little less food."),
   [("12 square cm","12 cm² is the whole leaf; the eaten 1 cm² hole leaves 11 cm²."),
    ("1 square cm","1 cm² is only the hole; the leaf left over is 12 − 1 = 11 cm²."),
    ("13 square cm","13 adds the hole instead of removing it; the leaf left is 12 − 1 = 11.")]),

 ("PA","A square settling tank covers 64 m². The length of railing to fit once around its edge is:",
   "32 metres",
   C("Side = √64 = 8 m, so perimeter = 4 × 8 = 32 m. [FUSION: tank engineering × area & perimeter]")+
   steps("Area = side × side = 64, so side = 8 m","perimeter of a square = 4 × side","4 × 8 = 32 metres of railing.")+
   U("From a tank's floor area you can work out how much edge railing it needs."),
   [("64 metres","64 is the area in square metres, not the distance around, which is 32 m."),
    ("16 metres","16 m is only two sides (8 + 8); a square has four, giving 32 m."),
    ("8 metres","8 m is just one side; all four sides total 4 × 8 = 32 m.")]),

 ("PA","A photosynthesis tray holds plants in a grid 4 rows by 5 columns of 1 cm squares. The total lit area of the grid is:",
   "20 square cm",
   C("A 4 by 5 grid of unit squares has 4 × 5 = 20 squares, so 20 cm². [FUSION: plant trays × area]")+
   steps("Count the unit squares: 4 rows × 5 columns","that is 4 × 5 = 20 squares","each is 1 cm², so the lit area is 20 cm².")+
   U("Arranging seedlings in a neat grid makes it easy to work out the lit area."),
   [("9 square cm","9 is 4 + 5, not 4 × 5; the grid holds 4 × 5 = 20 squares."),
    ("18 square cm","18 is the perimeter count (2 × (4 + 5)), not the 20 unit squares."),
    ("45 square cm","45 mixes up the digits; a 4 by 5 grid has 4 × 5 = 20 squares.")]),

 ("PA","A rectangular sewage screen is 3 m wide and has area 21 m². Its length is:",
   "7 metres",
   C("Length = area ÷ width, so 21 ÷ 3 = 7 m. [FUSION: wastewater screens × area]")+
   steps("Area = length × width = 21","length = 21 ÷ width = 21 ÷ 3","length = 7 metres.")+
   U("Knowing a screen's area and width lets engineers fix its length to fit a channel."),
   [("18 metres","18 is 21 − 3, but length comes from dividing, 21 ÷ 3 = 7, not subtracting."),
    ("63 metres","63 is 21 × 3; length is area divided by width, giving 7."),
    ("3 metres","3 m is the given width; the length is 21 ÷ 3 = 7 m.")]),

 ("PA","A square plot's side is increased from 5 m to 10 m. The increase in its area is:",
   "75 square metres",
   C("New area 10 × 10 = 100 m² minus old area 5 × 5 = 25 m² gives an increase of 75 m².")+
   steps("Old area = 5 × 5 = 25 m²","new area = 10 × 10 = 100 m²","increase = 100 − 25 = 75 square metres.")+
   U("Doubling a plot's side adds far more area than you might first guess."),
   [("25 square metres","25 m² is only the doubling of the old, not the actual rise of 100 − 25 = 75."),
    ("50 square metres","50 m² assumes the area just doubles; it grows from 25 to 100, a rise of 75."),
    ("100 square metres","100 m² is the new total area, not the increase, which is 100 − 25 = 75.")]),

 ("PA","A rectangular field 30 m by 20 m is to be watered with treated wastewater at 2 litres per square metre. The water needed is:",
   "1200 litres",
   C("Field area = 30 × 20 = 600 m²; at 2 L/m² that is 600 × 2 = 1200 L. [FUSION: wastewater reuse × area]")+
   steps("Find the area: 30 × 20 = 600 m²","each square metre needs 2 litres","600 × 2 = 1200 litres of treated water.")+
   U("Reusing treated wastewater to irrigate fields saves precious fresh water."),
   [("600 litres","600 is the area in m²; at 2 litres each, the water is 600 × 2 = 1200 L."),
    ("100 litres","100 m is the perimeter, not the area; the water needed is 1200 litres."),
    ("2400 litres","2400 would be 600 × 4; the rate is 2 litres per m², giving 1200.")]),

 ("PA","A rectangular plot is 18 m long and 12 m wide. The cost of fencing it at 5 rupees per metre is:",
   "300 rupees",
   C("Perimeter = 2 × (18 + 12) = 60 m; cost = 60 × 5 = 300 rupees.")+
   steps("Perimeter = 2 × (18 + 12) = 2 × 30 = 60 m","fencing costs 5 rupees per metre","cost = 60 × 5 = 300 rupees.")+
   U("A fencing bill is worked out from the plot's perimeter times the rate per metre."),
   [("1080 rupees","1080 uses the area (216 m²) × 5; fencing follows the perimeter, giving 300."),
    ("60 rupees","60 m is the perimeter itself; the cost is 60 × 5 = 300 rupees."),
    ("150 rupees","150 would be only half the boundary (30 m) × 5; the full perimeter gives 300.")]),
]

# ---------- EXPONENTS & POWERS (25) — Maths (some fused) ----------
EP = [
 ("EP","In the expression 5 raised to the power 3, the small raised number 3 is called the:",
   "exponent",
   C("In a power, the small raised number tells how many times the base is used; it is the exponent.")+
   steps("Write a power as base with a raised number","the big number is the base","the small raised number is the exponent.")+
   U("Scientists use exponents to write very large or very small numbers neatly."),
   [("base","The base is the big number that is multiplied; the small raised number is the exponent."),
    ("product","The product is the answer after multiplying; the raised number is the exponent."),
    ("factor","A factor is one of the equal numbers multiplied; the raised count is the exponent.")]),

 ("EP","The value of 2 raised to the power 4 (that is 2 × 2 × 2 × 2) is:",
   "16",
   C("2⁴ means four 2's multiplied: 2 × 2 × 2 × 2 = 16.")+
   steps("Multiply step by step: 2 × 2 = 4","4 × 2 = 8","8 × 2 = 16.")+
   U("Doubling something four times — like folding paper — multiplies it by 16."),
   [("8","8 is 2³ (three 2's); the fourth 2 takes it to 16."),
    ("6","6 is 2 × 3, not 2 multiplied by itself four times, which is 16."),
    ("12","12 is not a power of 2; four 2's multiplied give 16.")]),

 ("EP","The value of 10 raised to the power 4 is:",
   "10000",
   C("10⁴ is 1 followed by four zeros, that is 10 000.")+
   steps("Each power of ten adds one zero","10⁴ has four zeros after the 1","so 10⁴ = 10 000.")+
   U("Powers of ten make it easy to write big numbers like populations or distances."),
   [("1000","1000 is 10³, with only three zeros; 10⁴ has four, so 10 000."),
    ("100000","100000 is 10⁵, with five zeros; 10⁴ has four, so 10 000."),
    ("40","40 is 10 × 4, not 10 multiplied by itself four times, which is 10 000.")]),

 ("EP","Written with a single exponent, the product 3 × 3 × 3 × 3 × 3 is:",
   "3 to the power 5",
   C("Five equal 3's multiplied is written 3⁵.")+
   steps("Count the equal factors of 3: there are five","the base is 3, the exponent is 5","so the product is 3⁵.")+
   U("Exponent form is a short way to write long strings of equal factors."),
   [("3 to the power 4","3⁴ is only four 3's; here there are five, so 3⁵."),
    ("5 to the power 3","5³ has base 5; here the repeated factor is 3, so 3⁵."),
    ("15","15 is 3 × 5, not five 3's multiplied; that product is 3⁵ = 243.")]),

 ("EP","When multiplying powers of the same base, like 2³ × 2⁴, the exponents are:",
   "added, giving 2 to the power 7",
   C("To multiply powers with the same base, add the exponents: 2³ × 2⁴ = 2⁷.")+
   steps("2³ × 2⁴ means (2×2×2) × (2×2×2×2)","that is seven 2's multiplied","so the exponents add: 3 + 4 = 7, giving 2⁷.")+
   U("This rule keeps big multiplications short when the bases match."),
   [("multiplied, giving 2 to the power 12","Multiplying powers of the same base adds the exponents (3 + 4 = 7), not multiplies them."),
    ("subtracted, giving 2 to the power 1","Subtracting is for dividing same-base powers; multiplying adds, giving 2⁷."),
    ("kept the same, giving 2 to the power 4","The exponents must add when multiplying; 3 + 4 = 7, so 2⁷.")]),

 ("EP","When dividing powers of the same base, like 5⁶ ÷ 5⁲ (5 to the 6 divided by 5 to the 2), the exponents are:",
   "subtracted, giving 5 to the power 4",
   C("To divide powers with the same base, subtract the exponents: 5⁶ ÷ 5² = 5⁴.")+
   steps("5⁶ ÷ 5² cancels two 5's from the six on top","that leaves four 5's","so the exponents subtract: 6 − 2 = 4, giving 5⁴.")+
   U("The subtract rule shortens division of big same-base powers."),
   [("added, giving 5 to the power 8","Adding is for multiplying powers; dividing subtracts, giving 5⁴."),
    ("divided, giving 5 to the power 3","You subtract the exponents, not divide them; 6 − 2 = 4, so 5⁴."),
    ("multiplied, giving 5 to the power 12","Dividing same-base powers subtracts exponents; the answer is 5⁴.")]),

 ("EP","Following the laws of exponents, whenever a non-zero base is given the power zero, the result always comes out to be:",
   "1",
   C("By the rules of exponents, any non-zero number to the power 0 equals 1.")+
   steps("Note that aⁿ ÷ aⁿ = 1 for any non-zero a","but aⁿ ÷ aⁿ = a^(n−n) = a⁰","so a⁰ must equal 1.")+
   U("This neat rule keeps the exponent laws working all the way down to zero."),
   [("0","Zero is not the answer; any non-zero base to the power 0 equals 1."),
    ("the base itself","The base appears for power 1, not power 0; power 0 gives 1."),
    ("undefined","For a non-zero base it is well defined and equals 1.")]),

 ("EP","The number 64 can be written as a power of 2 because 2 × 2 × 2 × 2 × 2 × 2 equals 64. So 64 is:",
   "2 to the power 6",
   C("Six 2's multiplied give 64, so 64 = 2⁶.")+
   steps("Multiply 2's: 2,4,8,16,32,64","that took six 2's","so 64 = 2⁶.")+
   U("Computer memory sizes are powers of 2, which is why numbers like 64 appear."),
   [("2 to the power 5","2⁵ is 32; one more doubling gives 64 = 2⁶."),
    ("6 to the power 2","6² is 36, not 64; six 2's multiplied give 2⁶ = 64."),
    ("2 to the power 7","2⁷ is 128; 64 is one doubling less, that is 2⁶.")]),

 ("EP","In the number 7⁵, the base is:",
   "7",
   C("The base is the number being multiplied repeatedly; in 7⁵ that is 7.")+
   steps("A power has a base and an exponent","the big number multiplied again and again is the base","in 7⁵ the base is 7.")+
   U("Reading a power correctly starts with spotting which number is the base."),
   [("5","5 is the exponent, telling how many 7's are multiplied; the base is 7."),
    ("35","35 is 7 × 5, not the base; the base is simply 7."),
    ("12","12 is 7 + 5, not the base; the base of 7⁵ is 7.")]),

 ("EP","Standard (scientific) form writes 4500 as 4.5 × 10 raised to a power. That power is:",
   "3",
   C("Moving the point in 4500 to after the 4 gives 4.5, shifting three places, so 4500 = 4.5 × 10³.")+
   steps("Write 4500 as 4.5 followed by moving the point","the point moves 3 places to the left","so 4500 = 4.5 × 10³.")+
   U("Scientific form keeps big measurements short and easy to compare."),
   [("2","4.5 × 10² is 450, ten times too small; 4500 needs 10³."),
    ("4","4.5 × 10⁴ is 45000, ten times too big; 4500 is 4.5 × 10³."),
    ("1","4.5 × 10¹ is 45, far too small; 4500 is 4.5 × 10³.")]),

 ("EP","The value of 3 raised to the power 4 is:",
   "81",
   C("3⁴ means 3 × 3 × 3 × 3 = 81.")+
   steps("3 × 3 = 9","9 × 3 = 27","27 × 3 = 81.")+
   U("Repeated tripling — like a rumour spreading — grows fast, reaching 81 in four steps."),
   [("12","12 is 3 × 4, not 3 multiplied by itself four times, which is 81."),
    ("27","27 is 3³ (three 3's); the fourth 3 takes it to 81."),
    ("64","64 is 4³, not 3⁴; four 3's multiplied give 81.")]),

 ("EP","Comparing 2⁵ and 5², the larger value is:",
   "2 to the power 5",
   C("2⁵ = 32 while 5² = 25, so 2⁵ is the larger.")+
   steps("2⁵ = 2×2×2×2×2 = 32","5² = 5×5 = 25","32 is greater than 25, so 2⁵ is larger.")+
   U("Swapping base and exponent usually changes the value, so always compute both."),
   [("5 to the power 2","5² is 25, which is less than 2⁵ = 32."),
    ("they are equal","They are not equal: 2⁵ = 32 but 5² = 25."),
    ("neither, both are 10","Both are not 10; 2⁵ = 32 and 5² = 25.")]),

 ("EP","Expressed as a power of 10, the number one lakh (1,00,000) is:",
   "10 to the power 5",
   C("One lakh is 1 followed by five zeros, so it is 10⁵.")+
   steps("Count the zeros in 100000: there are five","each zero is a factor of ten","so one lakh = 10⁵.")+
   U("Large counts like a lakh are written as powers of ten for quick comparison."),
   [("10 to the power 4","10⁴ is ten thousand; one lakh has five zeros, so 10⁵."),
    ("10 to the power 6","10⁶ is ten lakh (a million); one lakh is 10⁵."),
    ("5 to the power 10","5¹⁰ is far larger and base 5; one lakh is 10⁵.")]),

 ("EP","The prime factorisation 2 × 2 × 3 × 3 × 3 written using exponents is:",
   "2 squared times 3 cubed",
   C("Two 2's and three 3's group into 2² × 3³.")+
   steps("Count the 2's: two of them give 2²","count the 3's: three of them give 3³","so the product is 2² × 3³.")+
   U("Writing a number's prime factors with exponents keeps the factorisation tidy."),
   [("2 cubed times 3 squared","That swaps the counts; there are two 2's and three 3's, so 2² × 3³."),
    ("6 to the power 5","6⁵ is not the same; the factors are 2² × 3³ = 4 × 27 = 108."),
    ("2 times 3 to the power 5","There are two 2's, not one; the correct grouping is 2² × 3³.")]),

 ("EP","Folding a sheet of paper in half doubles the layers each time. After 8 folds the number of layers is:",
   "2 to the power 8, which is 256",
   C("Each fold doubles the layers, so 8 folds give 2⁸ = 256 layers. [FUSION: paper folding × exponents]")+
   steps("One fold doubles the layers","eight folds is 2 × 2 ... eight times","that is 2⁸ = 256 layers.")+
   U("This is why a sheet of paper gets impossibly thick after only a few folds."),
   [("2 to the power 8, which is 16","2⁸ means eight 2's multiplied, not 2 × 8; the value is 256, not 16."),
    ("8 to the power 2, which is 64","8² is 64, but doubling has base 2, so it is 2⁸ = 256."),
    ("2 to the power 7, which is 128","Seven folds give 128; the eighth fold doubles it to 256.")]),

 ("EP","A bacterium in an aeration tank splits into 2 every 20 minutes. In 2 hours (six splits) one bacterium becomes:",
   "2 to the power 6, which is 64",
   C("Six doublings give 2⁶ = 64 bacteria. [FUSION: wastewater microbes × exponents]")+
   steps("2 hours hold six 20-minute splits","each split doubles the count","2⁶ = 64 bacteria from one.")+
   U("Fast-doubling microbes are why an aeration tank cleans sewage so quickly."),
   [("2 to the power 6, which is 12","2⁶ means six 2's multiplied, not 2 × 6; the value is 64, not 12."),
    ("6 to the power 2, which is 36","6² is 36, but doubling has base 2, so 2⁶ = 64."),
    ("2 to the power 5, which is 32","Five splits give 32; the sixth split doubles it to 64.")]),

 ("EP","A leaf cell divides into 2 each day. Starting from 1 cell on Monday, the number of cells on Friday (after 4 divisions) is:",
   "2 to the power 4, which is 16",
   C("Four doublings give 2⁴ = 16 cells. [FUSION: plant growth × exponents]")+
   steps("Monday to Friday is 4 days of dividing","each day doubles the count","2⁴ = 16 cells by Friday.")+
   U("Plant tissue grows by repeated cell doubling, so counts climb as powers of two."),
   [("2 to the power 4, which is 8","2⁴ means four 2's multiplied, not 2 × 4; the value is 16, not 8."),
    ("4 to the power 2, which is 16","The value 16 is right but the form is 2⁴, since doubling has base 2."),
    ("2 to the power 3, which is 8","Three doublings give 8; the fourth doubling makes 16.")]),

 ("EP","A treatment plant cleans water in batches that grow ten-fold: 10 L, then 100 L, then 1000 L. The fourth such batch, as a power of ten, is:",
   "10 to the power 4 litres",
   C("The batches are 10¹, 10², 10³, so the fourth is 10⁴ = 10000 L. [FUSION: wastewater scale × powers of ten]")+
   steps("First batch 10 = 10¹, second 100 = 10², third 1000 = 10³","each step adds one to the power","the fourth batch is 10⁴ = 10000 litres.")+
   U("Plant capacities are often described in tidy powers of ten."),
   [("10 to the power 3 litres","10³ is the third batch (1000 L); the fourth is 10⁴."),
    ("4 to the power 10 litres","4¹⁰ has base 4; these batches grow as powers of ten, so 10⁴."),
    ("40 litres","40 is 10 × 4, not 10 multiplied by itself four times, which is 10⁴ = 10000.")]),

 ("EP","A square photosynthesis tray has 10 rows and 10 columns of cells. Written as a power, the total number of cells is:",
   "10 squared, which is 100",
   C("A 10 by 10 grid has 10 × 10 = 10² = 100 cells. [FUSION: plant trays × exponents]")+
   steps("Cells = rows × columns = 10 × 10","that is 10²","which equals 100 cells.")+
   U("Square grids give counts that are perfect squares, like 100."),
   [("10 squared, which is 20","10² means 10 × 10 = 100, not 10 + 10 = 20."),
    ("2 to the power 10, which is 1024","Base 2 is wrong here; a 10 by 10 grid is 10² = 100."),
    ("10 cubed, which is 1000","10³ would be a 10×10×10 stack; a flat 10 by 10 grid is 10² = 100.")]),

 ("EP","Pond algae double their covered area every week. If they cover 3 m² now, after 3 weeks they cover:",
   "24 square metres",
   C("Three doublings multiply by 2³ = 8, so 3 × 8 = 24 m². [FUSION: algae growth × exponents]")+
   steps("Three weeks of doubling is × 2 × 2 × 2 = 2³ = 8","start with 3 m²","3 × 8 = 24 square metres.")+
   U("Fast-doubling algae can choke a whole pond in just a few weeks."),
   [("9 square metres","9 is 3 × 3; three doublings multiply by 2³ = 8, giving 3 × 8 = 24."),
    ("6 square metres","6 is only one doubling (3 × 2); three doublings give 3 × 8 = 24."),
    ("12 square metres","12 is two doublings (3 × 4); the third doubling makes 24.")]),

 ("EP","A sample shows the bacteria count rising as 3, 3², 3³ each hour. After 4 hours the count is 3⁴, which equals:",
   "81",
   C("3⁴ = 3 × 3 × 3 × 3 = 81 bacteria. [FUSION: microbe growth × exponents]")+
   steps("Each hour multiplies the count by 3","after 4 hours that is 3⁴","3 × 3 × 3 × 3 = 81.")+
   U("Tripling each hour, microbes reach surprising numbers within a single morning."),
   [("12","12 is 3 × 4, not 3 multiplied by itself four times, which is 81."),
    ("27","27 is 3³ (three hours); the fourth hour takes it to 81."),
    ("64","64 is 2⁶ or 4³, not 3⁴; four 3's multiplied give 81.")]),

 ("EP","The thickness of folded paper doubles each fold. Comparing 3 folds with 5 folds, the 5-fold stack is thicker by a factor of:",
   "4",
   C("From 3 to 5 folds is two more doublings, a factor of 2² = 4. [FUSION: paper folding × exponents]")+
   steps("3 folds give 2³, 5 folds give 2⁵","the ratio is 2⁵ ÷ 2³ = 2^(5−3) = 2²","that is 4 times thicker.")+
   U("Each extra fold doubles thickness, so two extra folds multiply it by four."),
   [("2","Two extra folds means two doublings, 2 × 2 = 4 times, not 2."),
    ("8","8 would be three extra folds (2³); from 3 to 5 is two folds, so 4."),
    ("32","32 is 2⁵, the total layers at 5 folds, not the factor of increase, which is 4.")]),

 ("EP","One litre of treated water is split among 10 test tubes, then each tenth is split among 10 more. The number of tiny final samples is:",
   "100, which is 10 squared",
   C("Ten groups split into ten each gives 10 × 10 = 10² = 100 samples. [FUSION: wastewater testing × exponents]")+
   steps("First split: 10 tubes","each splits into 10 again: 10 × 10","that is 10² = 100 final samples.")+
   U("Repeated ten-fold splitting is how labs prepare tiny, even test samples."),
   [("20, which is 10 plus 10","Splitting each of 10 into 10 multiplies, giving 10 × 10 = 100, not 10 + 10."),
    ("10, which is 10 to the power 1","That is only the first split; splitting again gives 10² = 100."),
    ("1000, which is 10 cubed","10³ would be three splits; here there are two, giving 10² = 100.")]),

 ("EP","A field is watered in plots arranged 5 across and 5 down, each plot taking 2² litres. Written with exponents, the total water used is:",
   "5 squared times 2 squared, which is 100 litres",
   C("Plots = 5 × 5 = 5² = 25; each takes 2² = 4 L; total = 25 × 4 = 100 L. [FUSION: irrigation × exponents]")+
   steps("Number of plots = 5 × 5 = 5² = 25","each plot uses 2² = 4 litres","total = 25 × 4 = 100 litres.")+
   U("Grids of plots and fixed doses combine neatly using exponent shorthand."),
   [("5 plus 2, which is 7 litres","Adding the bases is wrong; the total is 5² × 2² = 25 × 4 = 100 litres."),
    ("10 squared minus 1, which is 99 litres","The total is exactly 5² × 2² = 100 litres, not 99."),
    ("2 to the power 5, which is 32 litres","2⁵ = 32 ignores the 25 plots; the total is 25 × 4 = 100.")]),

 ("EP","The value of 2³ × 5³, using the rule that equal exponents let you multiply the bases first, is:",
   "10 cubed, which is 1000",
   C("2³ × 5³ = (2 × 5)³ = 10³ = 1000, since the exponents match.")+
   steps("With the same exponent, multiply the bases: 2 × 5 = 10","keep the shared exponent: (2 × 5)³ = 10³","10³ = 1000.")+
   U("Matching exponents let you combine bases, turning a messy product into a tidy power of ten."),
   [("10 to the power 6, which is 1000000","You keep the shared exponent 3, not add them; (2×5)³ = 10³ = 1000."),
    ("7 cubed, which is 343","You multiply the bases (2 × 5 = 10), not add them; the answer is 10³ = 1000."),
    ("10 squared, which is 100","The shared exponent is 3, so it is 10³ = 1000, not 10².")]),
]

# ---------- assemble: interleave so no two consecutive share a chapter ----------
assert all(len(b) == 25 for b in (NP, WW, PA, EP)), [len(NP), len(WW), len(PA), len(EP)]
items = []
for i in range(25):
    items += [NP[i], WW[i], PA[i], EP[i]]
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

    keydist = build_paper(PNUM, TITLE, SHORT, LABELS, items, seed=45029,
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
    split = "/".join(str(counts[c]) for c in ("NP", "WW", "PA", "EP"))
    with open("PAPERS_MANIFEST.md", "a", encoding="utf-8") as fh:
        fh.write(f"| {PNUM} | 2026-06-18 | {TITLE} | {split} | ✓ |\n")

    # ---- update QUESTION_INDEX.json ----
    idx["fingerprints"] = sorted(existing | set(new_fps))
    idx.setdefault("combos", []).append({
        "paper": PNUM,
        "chapters": ["Nutrition in Plants",
                     "Wastewater Story",
                     "Perimeter & Area",
                     "Exponents & Powers"],
    })
    idx["papers"] = idx.get("papers", 0) + 1
    with open(idx_path, "w", encoding="utf-8") as fh:
        json.dump(idx, fh, ensure_ascii=False, indent=2)
        fh.write("\n")

    print("Files:", sorted(v for v in moves.values()))
    print("Answer key spread A/B/C/D =", dict(keydist))
    print("Fingerprints added:", len(new_fps))
