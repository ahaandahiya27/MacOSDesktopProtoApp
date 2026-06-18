# -*- coding: utf-8 -*-
# Boss Challenge Paper 35 — Nutrition in Plants · Respiration in Organisms
#                            · Lines & Angles · Perimeter & Area
# Content-only. Uses the dependency-free examfactory engine.
# Difficulty ramp: this paper leans into FUSION. A leaf's light-catching surface is an AREA
# (side × side); a breathing rate over several minutes is a MULTIPLICATION; the rise in an
# athlete's breathing is a SUBTRACTION; fencing a vegetable garden is a PERIMETER. The child meets
# a Science situation and reaches for a Maths skill. Class-7 scope, simple wording, hard thinking.
# Produces, under Resources/BossChallengePapers/:
#   Paper_35_<SHORT>_QuestionPaper.html  (pure HTML — questions + options)
#   Paper_35_<SHORT>_QuestionPaper.pdf
#   Paper_35_<SHORT>_Questions.md
#   Paper_35_<SHORT>_Solutions.html
import os, sys, shutil, json, re
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from examfactory import build_paper, C, steps, U

PNUM  = "35"
SHORT = "NutritionPlants_Respiration_LinesAngles_PerimeterArea"
TITLE = ("Nutrition in Plants · Respiration in Organisms · "
         "Lines & Angles · Perimeter & Area")
LABELS = {
    "NP": "Nutrition in Plants",
    "RO": "Respiration in Organisms",
    "LA": "Lines & Angles",
    "PA": "Perimeter & Area",
}

# ---------- NUTRITION IN PLANTS (25) — Science ----------
NP = [
 ("NP","The process by which green plants prepare their own food using sunlight, water and air is called:",
   "photosynthesis",
   C("Green plants use sunlight to build food from carbon dioxide and water; this food-making is photosynthesis.")+
   steps("A green plant has chlorophyll, water and air","in sunlight it builds its own food","this food-making process is called photosynthesis."),
   [("respiration","Respiration breaks food down for energy; photosynthesis builds the food up."),
    ("digestion","Digestion breaks food into simpler parts; plants instead make food by photosynthesis."),
    ("transpiration","Transpiration is loss of water vapour from leaves, not the making of food.")]),

 ("NP","Green plants are described as autotrophs mainly because they:",
   "make their own food",
   C("'Auto' means self and 'troph' means feed — autotrophs make their own food.")+
   steps("Break the word: auto = self, troph = feeding","green plants feed themselves by photosynthesis","so they are called autotrophs."),
   [("eat other animals","Plants do not eat animals; autotrophs make their own food."),
    ("depend fully on other plants","Autotrophs do not depend on others; they make their own food."),
    ("never need any food at all","Plants do need food — they simply make it themselves.")]),

 ("NP","The green colouring substance in leaves that traps sunlight for food-making is called:",
   "chlorophyll",
   C("Chlorophyll is the green pigment that captures the Sun's energy for photosynthesis.")+
   steps("Leaves look green because of a pigment","this pigment captures sunlight","the green light-trapping pigment is chlorophyll."),
   [("haemoglobin","Haemoglobin is the red pigment in our blood, not in leaves."),
    ("chlorine","Chlorine is a gas, not the green pigment of leaves; the pigment is chlorophyll."),
    ("starch","Starch is the stored food made later; the green pigment is chlorophyll.")]),

 ("NP","The tiny pores on the surface of a leaf through which gases pass in and out are called:",
   "stomata",
   C("Leaves have tiny pores called stomata that let gases move in and out.")+
   steps("Gases must enter and leave the leaf","they pass through tiny pores on the leaf","these pores are called stomata."),
   [("veins","Veins carry water and food through the leaf; gases pass through stomata."),
    ("roots","Roots are underground; the leaf's gas pores are the stomata."),
    ("petals","Petals belong to a flower; the leaf's gas pores are the stomata.")]),

 ("NP","Besides chlorophyll and sunlight, the two raw materials a leaf needs to make food are water and:",
   "carbon dioxide",
   C("A leaf makes food from water and carbon dioxide, using sunlight trapped by chlorophyll.")+
   steps("List what the leaf takes in","water comes from the soil, and a gas from the air","that gas is carbon dioxide."),
   [("oxygen","Oxygen is given OUT in photosynthesis; the gas taken in is carbon dioxide."),
    ("nitrogen","Plants use nitrogen as a soil nutrient, not as the raw gas for photosynthesis."),
    ("smoke","Smoke is not a raw material; the gas needed is carbon dioxide.")]),

 ("NP","The food first made by green leaves during photosynthesis is a simple sugar called:",
   "glucose",
   C("Photosynthesis first makes the sugar glucose, which can then be stored as starch.")+
   steps("The leaf builds food from carbon dioxide and water","the first food made is a simple sugar","that sugar is glucose."),
   [("protein","Proteins need nitrogen and form later; the first food made is the sugar glucose."),
    ("vitamin","Vitamins are not the main product; photosynthesis first makes glucose."),
    ("fat","Fat is not the first food made; photosynthesis produces the sugar glucose.")]),

 ("NP","During photosynthesis, the gas that green plants take IN from the surrounding air is:",
   "carbon dioxide",
   C("Plants absorb carbon dioxide from the air to use in photosynthesis.")+
   steps("Photosynthesis needs a gas from the air","plants take in carbon dioxide through stomata","so the gas taken in is carbon dioxide."),
   [("oxygen","Oxygen is RELEASED during photosynthesis, not taken in."),
    ("hydrogen","Plants do not take in hydrogen gas; they take in carbon dioxide."),
    ("nitrogen","Nitrogen is used as a soil nutrient, not the gas taken in for photosynthesis.")]),

 ("NP","During photosynthesis, the gas that green plants give OUT into the air is:",
   "oxygen",
   C("As plants make food, they release oxygen — the gas we breathe — into the air.")+
   steps("Photosynthesis splits water and builds sugar","a gas is left over and released","that released gas is oxygen."),
   [("carbon dioxide","Carbon dioxide is taken IN for photosynthesis; oxygen is given out."),
    ("nitrogen","Nitrogen is not released by photosynthesis; the gas given out is oxygen."),
    ("water vapour","Water vapour leaves in transpiration; the gas made in photosynthesis is oxygen.")]),

 ("NP","To test whether a leaf has made food, a few drops of this solution are dripped onto it:",
   "iodine, which turns blue-black with starch",
   C("Iodine turns blue-black where starch is present, showing the leaf has made food.")+
   steps("Starch is the stored food in a leaf","iodine reacts with starch","it turns blue-black, showing starch is there."),
   [("lime water, which turns milky","Lime water tests for carbon dioxide gas, not starch in a leaf."),
    ("litmus, which turns red","Litmus tests acids and bases, not starch; iodine tests starch."),
    ("salt water, which turns clear","Salt water is not a starch test; iodine turns blue-black with starch.")]),

 ("NP","Living things that cannot make their own food and depend on others for it are called:",
   "heterotrophs",
   C("'Hetero' means other — heterotrophs depend on other organisms for their food.")+
   steps("Some living things cannot make food themselves","they take food from other living things","such feeders are called heterotrophs."),
   [("autotrophs","Autotrophs MAKE their own food; heterotrophs depend on others."),
    ("producers","Producers make their own food; dependent feeders are heterotrophs."),
    ("chlorophylls","That is a pigment, not a feeding type; food-dependent organisms are heterotrophs.")]),

 ("NP","Cuscuta (amarbel), a pale climber that draws its food from another living plant, is a:",
   "parasite",
   C("Cuscuta has no chlorophyll and takes ready-made food from a host plant, so it is a parasite.")+
   steps("Cuscuta is yellow, lacking chlorophyll","it twines on a host and sucks its food","living off another, it is a parasite."),
   [("saprotroph","Saprotrophs feed on DEAD matter; Cuscuta feeds on a LIVING host, so it is a parasite."),
    ("autotroph","An autotroph makes its own food; Cuscuta cannot, so it is a parasite."),
    ("insectivore","Insectivores trap insects; Cuscuta takes food from a living plant, so it is a parasite.")]),

 ("NP","The pitcher plant traps and digests insects mainly because the soil it grows in is poor in:",
   "nitrogen",
   C("Pitcher plants grow in nitrogen-poor soil, so they trap insects to get the nitrogen they lack.")+
   steps("The pitcher plant's soil lacks a key nutrient","it traps and digests insects","this gives it the missing nitrogen."),
   [("water","These plants usually grow in wet places; what their soil lacks is nitrogen."),
    ("sunlight","Sunlight comes from above, not the soil; the soil is poor in nitrogen."),
    ("carbon dioxide","Carbon dioxide is taken from the air; the soil here is poor in nitrogen.")]),

 ("NP","A plant such as the pitcher plant that catches and feeds on insects is called an:",
   "insectivorous plant",
   C("Plants that capture and digest insects for nutrients are called insectivorous plants.")+
   steps("Some plants trap insects","they digest them for nutrients","such plants are called insectivorous plants."),
   [("parasitic plant","A parasite feeds on another PLANT host; this plant feeds on insects."),
    ("saprotrophic plant","Saprotrophs feed on dead matter; insect-eaters are insectivorous plants."),
    ("aquatic plant","Living in water is a different idea; an insect-eater is an insectivorous plant.")]),

 ("NP","Mushrooms and bread mould obtain their food from dead and decaying matter, so they are called:",
   "saprotrophs",
   C("Organisms that feed on dead, rotting matter are called saprotrophs.")+
   steps("Mushrooms and mould grow on dead, rotting things","they absorb food from this dead matter","such feeders are saprotrophs."),
   [("parasites","Parasites feed on LIVING hosts; these feed on DEAD matter, so they are saprotrophs."),
    ("autotrophs","Autotrophs make their own food; mould cannot, so it is a saprotroph."),
    ("insectivores","Insectivores trap insects; mould feeds on dead matter as a saprotroph.")]),

 ("NP","The close partnership in which a fungus and an alga live together and help each other is called a:",
   "lichen",
   C("A lichen is a fungus and an alga living together — the alga makes food, the fungus gives shelter and water.")+
   steps("A fungus and an alga live closely together","the alga makes food; the fungus supplies water and shelter","this partnership is called a lichen."),
   [("parasite","A parasite harms its host; in a lichen both partners HELP each other."),
    ("saprotroph","A saprotroph feeds on dead matter; a lichen is a living fungus–alga partnership."),
    ("root nodule","Root nodules hold bacteria in plant roots; the fungus–alga pair is a lichen.")]),

 ("NP","Farmers often grow leguminous plants such as beans and peas because their roots help to enrich the soil with:",
   "nitrogen",
   C("Bacteria in the root nodules of legumes fix nitrogen, enriching the soil naturally.")+
   steps("Legume roots carry special bacteria","these bacteria fix nitrogen from the air","so the soil gains nitrogen."),
   [("oxygen","Soil is not enriched with oxygen by legumes; they add nitrogen."),
    ("carbon","Legumes restore nitrogen, not carbon, to the soil."),
    ("plain water","Legumes do not store water in soil; they enrich it with nitrogen.")]),

 ("NP","The bacteria living in the root nodules of pulse plants are useful chiefly because they can fix:",
   "nitrogen from the air",
   C("Rhizobium bacteria in root nodules take nitrogen from the air and change it into a form plants can use.")+
   steps("Root nodules of pulses hold special bacteria","these bacteria take nitrogen from the air","they fix it into a usable form for the plant."),
   [("oxygen from the air","These bacteria fix nitrogen, not oxygen, from the air."),
    ("water from the soil","Roots absorb water directly; the bacteria fix nitrogen from the air."),
    ("sunlight for food","Bacteria cannot fix sunlight; they fix nitrogen from the air.")]),

 ("NP","Water and dissolved minerals are taken up from the soil into a plant chiefly by its:",
   "roots",
   C("A plant's roots absorb water and minerals from the soil and pass them up to the rest of the plant.")+
   steps("Water and minerals lie in the soil","the part touching the soil takes them in","the roots absorb them for the plant."),
   [("leaves","Leaves make food and lose water vapour; the soil's water is taken in by roots."),
    ("flowers","Flowers help in reproduction; water from soil enters through the roots."),
    ("fruits","Fruits hold seeds; soil water is absorbed by the roots.")]),

 ("NP","A leaf is often called the 'kitchen' or food factory of a green plant because it:",
   "carries out photosynthesis to make food",
   C("Leaves hold the chlorophyll and stomata needed to make food, so they are the plant's kitchen.")+
   steps("Food-making needs chlorophyll, gas and light","the leaf has chlorophyll and stomata","so it makes the food — the plant's kitchen."),
   [("stores all the plant's seeds","Seeds form in fruits, not leaves; the leaf is the food-making kitchen."),
    ("anchors the plant in the soil","Roots anchor the plant; the leaf is where food is made."),
    ("carries water up to the flowers","Stems carry water; the leaf is the place where food is made.")]),

 ("NP","Photosynthesis in a green plant can take place only when there is:",
   "sunlight",
   C("Photosynthesis needs the energy of sunlight, so it stops in the dark.")+
   steps("Chlorophyll must trap energy to build food","that energy comes from sunlight","so photosynthesis needs sunlight."),
   [("total darkness","In darkness there is no light energy, so photosynthesis cannot happen."),
    ("moonlight only","Moonlight is far too weak; photosynthesis needs proper sunlight."),
    ("soil but no light at all","Soil alone cannot drive food-making; sunlight is required.")]),

 ("NP","Apart from the leaves, photosynthesis can also take place in a plant's stem when the stem is:",
   "green (contains chlorophyll)",
   C("A green stem has chlorophyll, so it too can carry out photosynthesis.")+
   steps("Photosynthesis needs chlorophyll","a green stem contains chlorophyll","so a green stem can also make food."),
   [("brown and woody","A brown woody stem lacks chlorophyll, so it cannot photosynthesise."),
    ("very thick and tall","Thickness does not matter; the stem must be GREEN to photosynthesise."),
    ("buried underground","An underground stem gets no light; a GREEN stem in light can photosynthesise.")]),

 ("NP","Growing the same crop again and again drains the soil of nutrients, which farmers put back by adding:",
   "manure or fertilisers",
   C("Manure and fertilisers replace the nutrients that repeated cropping removes from the soil.")+
   steps("Crops take nutrients out of the soil","the soil grows poor after repeated cropping","adding manure or fertilisers restores the nutrients."),
   [("more stones","Stones add no nutrients; manure or fertilisers restore the soil."),
    ("plain dry sand","Sand has no nutrients to give; manure or fertilisers are added."),
    ("extra sunlight","Sunlight is from the Sun, not added to soil; nutrients come from manure or fertilisers.")]),

 ("NP","Inside the green cells of a leaf, chlorophyll is held in tiny green bodies called:",
   "chloroplasts",
   C("Chlorophyll sits inside small green structures in the cell called chloroplasts.")+
   steps("Leaf cells contain tiny structures","the green pigment chlorophyll is packed inside them","these green bodies are chloroplasts."),
   [("chromosomes","Chromosomes carry inherited information, not chlorophyll; that is the chloroplast's job."),
    ("nuclei","The nucleus controls the cell; chlorophyll is held in chloroplasts."),
    ("stomata","Stomata are pores on the leaf surface, not the green bodies holding chlorophyll.")]),

 ("NP","A square leaf has each side 6 cm long. The flat surface over which it can catch sunlight is, with area = side × side:",
   "36 cm²",
   C("A square leaf's light-catching area is side × side = 6 × 6 = 36 cm² — a science surface found with an area formula.")+
   steps("The leaf is a square of side 6 cm","area of a square = side × side","6 × 6 = 36, so the area is 36 cm²."),
   [("24 cm²","24 is 6 × 4, a perimeter idea; AREA is side × side = 36 cm²."),
    ("12 cm²","12 is 6 + 6; area is side × side = 6 × 6 = 36 cm²."),
    ("18 cm²","18 has no basis; the square leaf's area is 6 × 6 = 36 cm².")]),

 ("NP","A rectangular leaf measures 8 cm in length and 3 cm in breadth. The surface it spreads out to catch sunlight is:",
   "24 cm²",
   C("A rectangular leaf's area is length × breadth = 8 × 3 = 24 cm² — a leaf's light-catching surface from an area formula.")+
   steps("The leaf is a rectangle, 8 cm by 3 cm","area of a rectangle = length × breadth","8 × 3 = 24, so the area is 24 cm²."),
   [("22 cm²","22 is the perimeter 2 × (8 + 3); AREA is 8 × 3 = 24 cm²."),
    ("11 cm²","11 is 8 + 3; area is length × breadth = 24 cm²."),
    ("16 cm²","16 has no basis; the leaf's area is 8 × 3 = 24 cm².")]),
]

NP_UC = [
 "Knowing photosynthesis is how you grasp that nearly all our food traces back to green plants.",
 "Knowing plants are autotrophs is why the food chain begins with green plants every time.",
 "Knowing chlorophyll traps light is why leaves are green and why a plant in the dark turns pale.",
 "Knowing about stomata is how you understand a leaf 'breathing' gases in and out.",
 "Knowing the raw materials is how a gardener sees why a plant needs both water and fresh air.",
 "Knowing glucose is the first food is how you connect a leaf's work to the sweetness in fruit.",
 "Knowing plants take in carbon dioxide is why green plants help clean the air we breathe.",
 "Knowing plants give out oxygen is why forests are often called the lungs of the Earth.",
 "The iodine starch test is the classic class experiment proving a leaf has made food.",
 "Knowing heterotrophs is how you classify every animal and fungus that cannot make its own food.",
 "Spotting a parasite like amarbel is how a farmer knows which climber is harming a crop.",
 "Knowing why the pitcher plant traps insects explains how it survives in poor, boggy soil.",
 "Naming an insectivorous plant is how you describe the Venus flytrap and pitcher plant correctly.",
 "Knowing saprotrophs is how you understand mould rotting bread and mushrooms on a log.",
 "Knowing about lichens is how you read those crusty patches on rocks and tree bark.",
 "Knowing legumes enrich soil is why farmers rotate beans into a field to refresh it.",
 "Knowing root-nodule bacteria fix nitrogen is the science behind natural soil fertility.",
 "Knowing roots absorb water is why watering the soil, not the leaves, keeps a plant alive.",
 "Calling the leaf a kitchen is a simple way to remember where a plant's food is made.",
 "Knowing photosynthesis needs light is why a plant by a sunny window grows best.",
 "Knowing green stems photosynthesise is how you understand a cactus making food without true leaves.",
 "Knowing crops drain soil is why manure and crop rotation keep a field productive.",
 "Knowing chloroplasts hold chlorophyll is how you picture where food-making happens in a cell.",
 "Finding a square leaf's area is how you would estimate how much sunlight a leaf can gather.",
 "Finding a rectangular leaf's area is how a botanist compares the light-catching size of leaves.",
]

# ---------- RESPIRATION IN ORGANISMS (25) — Science ----------
RO = [
 ("RO","The process in which living cells break down food to release energy is called:",
   "respiration",
   C("Cells break down food, usually with oxygen, to release the energy needed to live — this is respiration.")+
   steps("Living cells need energy to work","they break down food to release it","this energy-releasing process is respiration."),
   [("photosynthesis","Photosynthesis BUILDS food; respiration breaks it down for energy."),
    ("digestion","Digestion breaks food into simpler bits; respiration releases energy from it inside cells."),
    ("excretion","Excretion removes waste; respiration is the release of energy from food.")]),

 ("RO","During normal breathing, the gas that humans take IN from the air and use is:",
   "oxygen",
   C("We breathe in air and our body uses the oxygen in it to release energy from food.")+
   steps("Breathing draws air into the lungs","the body needs one gas from that air","that gas is oxygen."),
   [("carbon dioxide","Carbon dioxide is breathed OUT as waste, not taken in and used."),
    ("nitrogen","Air is mostly nitrogen, but the body uses the oxygen it breathes in."),
    ("hydrogen","We do not breathe in hydrogen; the useful gas taken in is oxygen.")]),

 ("RO","The gas that humans breathe OUT in larger amounts than they breathe in is:",
   "carbon dioxide",
   C("Respiration produces carbon dioxide as waste, so exhaled air is richer in it.")+
   steps("Cells use oxygen and make a waste gas","this waste gas leaves with the breath","exhaled air is rich in carbon dioxide."),
   [("oxygen","Oxygen is breathed IN and used up; the waste gas breathed out is carbon dioxide."),
    ("nitrogen","Nitrogen passes in and out roughly unchanged; the waste gas is carbon dioxide."),
    ("hydrogen","Hydrogen is not a breathing waste; we breathe out carbon dioxide.")]),

 ("RO","Respiration that uses oxygen to break down food fully is called:",
   "aerobic respiration",
   C("'Aerobic' means with air/oxygen — this respiration uses oxygen and releases a lot of energy.")+
   steps("Check whether oxygen is used","here oxygen breaks the food down fully","using oxygen, it is aerobic respiration."),
   [("anaerobic respiration","Anaerobic respiration works WITHOUT oxygen; this one uses oxygen."),
    ("photosynthesis","Photosynthesis makes food; this is the oxygen-using breakdown, aerobic respiration."),
    ("transpiration","Transpiration is water loss from leaves, not an oxygen-using respiration.")]),

 ("RO","Respiration that takes place without using oxygen is called:",
   "anaerobic respiration",
   C("'An-aerobic' means without air/oxygen — this respiration releases energy without oxygen.")+
   steps("Check whether oxygen is used","here no oxygen is used","without oxygen, it is anaerobic respiration."),
   [("aerobic respiration","Aerobic respiration USES oxygen; this one does not, so it is anaerobic."),
    ("photosynthesis","Photosynthesis makes food in light; this is energy release without oxygen."),
    ("germination","Germination is a seed sprouting, not a kind of respiration.")]),

 ("RO","When our muscles run short of oxygen during hard exercise, the food is broken down to give energy and:",
   "lactic acid",
   C("With too little oxygen, muscle cells break glucose into lactic acid, which causes cramp.")+
   steps("Hard exercise uses oxygen faster than it arrives","muscles then respire without enough oxygen","this produces lactic acid."),
   [("alcohol","Alcohol forms in yeast, not in human muscles; muscles make lactic acid."),
    ("pure oxygen","Oxygen is what is in SHORT supply here; the product is lactic acid."),
    ("starch","Starch is a stored food, not a product; muscles produce lactic acid.")]),

 ("RO","The painful muscle cramps felt after running very fast are caused by a build-up of:",
   "lactic acid in the muscles",
   C("Lactic acid made during low-oxygen respiration builds up and causes painful cramps.")+
   steps("Fast running starves muscles of oxygen","they make lactic acid as they respire","the build-up of lactic acid causes cramp."),
   [("extra oxygen","Cramp comes from too LITTLE oxygen and built-up lactic acid, not extra oxygen."),
    ("water in the bones","Cramp is in the muscles from lactic acid, not water in the bones."),
    ("undigested food","Cramp here is from lactic acid building in the muscles, not undigested food.")]),

 ("RO","In yeast, anaerobic respiration breaks down sugar to give alcohol, energy and the gas:",
   "carbon dioxide",
   C("Yeast respiring without oxygen makes alcohol and carbon dioxide — the gas that makes dough rise.")+
   steps("Yeast respires without oxygen","it breaks sugar into alcohol and a gas","that gas is carbon dioxide."),
   [("oxygen","Yeast here works WITHOUT oxygen; the gas it gives off is carbon dioxide."),
    ("hydrogen","Yeast does not release hydrogen; it gives off carbon dioxide."),
    ("nitrogen","Nitrogen is not a product; yeast fermentation gives off carbon dioxide.")]),

 ("RO","In a living organism, the breakdown of food to release energy takes place mainly inside the:",
   "cells",
   C("Respiration happens inside the cells, where food is broken down to release energy.")+
   steps("Energy is needed throughout the body","it is released where food is broken down","that breakdown happens inside the cells."),
   [("bones","Bones support the body; respiration occurs inside the cells."),
    ("hair","Hair is non-living at its tip; respiration takes place in living cells."),
    ("nails","Nails do not respire; the breakdown of food happens in cells.")]),

 ("RO","The taking in of air rich in oxygen into the body is called:",
   "inhalation",
   C("Breathing in air rich in oxygen is called inhalation.")+
   steps("Air is drawn into the lungs","this incoming air is rich in oxygen","taking it in is called inhalation."),
   [("exhalation","Exhalation is breathing OUT; taking air in is inhalation."),
    ("respiration","Respiration is the cell-level energy release; breathing in is inhalation."),
    ("digestion","Digestion handles food, not air; breathing in is inhalation.")]),

 ("RO","The giving out of air rich in carbon dioxide from the body is called:",
   "exhalation",
   C("Breathing out air rich in carbon dioxide is called exhalation.")+
   steps("Used air collects in the lungs","it is rich in carbon dioxide","pushing it out is called exhalation."),
   [("inhalation","Inhalation is breathing IN; giving air out is exhalation."),
    ("respiration","Respiration is energy release in cells; breathing out is exhalation."),
    ("transpiration","Transpiration is water loss from plants; breathing out is exhalation.")]),

 ("RO","One complete inhalation taken together with one exhalation makes up one:",
   "breath",
   C("Breathing in once and out once together count as a single breath.")+
   steps("Take air in once — inhalation","let it out once — exhalation","the two together make one breath."),
   [("heartbeat","A heartbeat is a pulse of the heart, not an inhale-plus-exhale; that is a breath."),
    ("pulse","A pulse is felt in an artery; an inhale plus exhale is one breath."),
    ("step","A step is a movement of the leg; one inhale and exhale make one breath.")]),

 ("RO","A boy at rest counts 18 complete breaths in one minute; this 18-per-minute figure for him is his:",
   "breathing rate",
   C("How many breaths a person takes per minute is the breathing rate.")+
   steps("Count complete breaths in a minute","this count measures breathing speed","it is called the breathing rate."),
   [("heart rate","Heart rate counts heartbeats per minute, not breaths; breaths give the breathing rate."),
    ("growth rate","Growth rate is about getting bigger over time, not breaths per minute."),
    ("pulse rate","Pulse rate counts heartbeats; breaths per minute is the breathing rate.")]),

 ("RO","The large dome-shaped muscle lying just below the lungs that helps in breathing is the:",
   "diaphragm",
   C("The diaphragm moves down and up to draw air into and push it out of the lungs.")+
   steps("Below the lungs lies a sheet of muscle","it moves to change the chest's size","this breathing muscle is the diaphragm."),
   [("heart","The heart pumps blood; the breathing muscle below the lungs is the diaphragm."),
    ("liver","The liver handles food chemistry; the breathing muscle is the diaphragm."),
    ("stomach","The stomach digests food; the muscle that aids breathing is the diaphragm.")]),

 ("RO","In humans, the exchange of gases takes place in the tiny balloon-like air sacs of the lungs called:",
   "alveoli",
   C("The lungs end in tiny air sacs called alveoli, where oxygen and carbon dioxide are exchanged.")+
   steps("Air travels down into the lungs","it reaches tiny thin-walled sacs","these alveoli exchange the gases."),
   [("nephrons","Nephrons are filtering units of the kidney, not the lung's air sacs."),
    ("neurons","Neurons are nerve cells; the lung's gas-exchange sacs are alveoli."),
    ("villi","Villi line the intestine for absorbing food; the lung's sacs are alveoli.")]),

 ("RO","Insects take in air for respiration through tiny openings along the sides of their body called:",
   "spiracles",
   C("Insects breathe through small holes called spiracles that lead to air tubes inside the body.")+
   steps("An insect has no lungs like ours","air enters through tiny body openings","these openings are called spiracles."),
   [("gills","Gills belong to fish in water; insects breathe through spiracles."),
    ("stomata","Stomata are pores on plant leaves, not the breathing holes of insects."),
    ("nostrils","Insects do not have nostrils; they breathe through spiracles.")]),

 ("RO","Fish are able to breathe under water using special organs that take oxygen from the water, called:",
   "gills",
   C("Fish use gills to take dissolved oxygen out of the water they live in.")+
   steps("A fish lives surrounded by water","water holds some dissolved oxygen","gills pull that oxygen from the water."),
   [("lungs","Fish do not breathe air with lungs; they use gills in water."),
    ("spiracles","Spiracles are the breathing holes of insects, not fish; fish use gills."),
    ("nostrils","Fish breathe mainly through gills, not nostrils.")]),

 ("RO","An earthworm has no lungs or gills, so it breathes mainly through its moist:",
   "skin",
   C("Gases pass in and out through the earthworm's damp skin, so it must stay moist to breathe.")+
   steps("An earthworm has no special breathing organs","its skin is thin and kept moist","gases pass through this moist skin."),
   [("gills","Gills are for fish; an earthworm breathes through its moist skin."),
    ("lungs","An earthworm has no lungs; it breathes through its skin."),
    ("spiracles","Spiracles belong to insects; the earthworm breathes through its skin.")]),

 ("RO","Like animals, green plants also respire, exchanging respiratory gases through the leaf pores called:",
   "stomata",
   C("Leaves take in oxygen and give out carbon dioxide for respiration through the tiny pores, the stomata.")+
   steps("Plant cells respire and must exchange gases","leaves have tiny pores for this","these pores are the stomata."),
   [("alveoli","Alveoli are air sacs in animal lungs; leaves use stomata."),
    ("spiracles","Spiracles are insect breathing holes; leaves use stomata."),
    ("veins","Veins carry water and food; gas exchange in a leaf is through stomata.")]),

 ("RO","The roots of a plant get the oxygen they need for respiration from air present in the:",
   "spaces between the soil particles",
   C("Air trapped in the gaps between soil particles supplies oxygen to the roots.")+
   steps("Roots need oxygen to respire","soil has air in the gaps between its particles","roots take oxygen from this soil air."),
   [("middle of solid rocks","Solid rock holds no air for roots; the air is in the gaps between soil particles."),
    ("water deep underground","Roots use the air in soil gaps, not deep water, for oxygen."),
    ("leaves far above them","Leaves get their own air; roots use the air in the soil's gaps.")]),

 ("RO","We pant and breathe much faster after running because the body suddenly needs more:",
   "oxygen",
   C("Hard work uses energy fast, so the body needs extra oxygen, and we breathe faster to get it.")+
   steps("Running uses up energy quickly","more oxygen is needed to release that energy","so we breathe faster to take in more oxygen."),
   [("carbon dioxide","We breathe faster to take in more OXYGEN and clear carbon dioxide, not gather it."),
    ("food","Eating does not happen by breathing; fast breathing brings in more oxygen."),
    ("water","Thirst is separate; fast breathing after running supplies more oxygen.")]),

 ("RO","A simple way to show that exhaled air carries more carbon dioxide is that, blown through it, lime water turns:",
   "milky",
   C("Carbon dioxide in our breath turns clear lime water milky white.")+
   steps("Blow exhaled air through clear lime water","its carbon dioxide reacts with the lime water","the lime water turns milky white."),
   [("bright red","Lime water turns MILKY with carbon dioxide, not red."),
    ("deep blue","Carbon dioxide turns lime water milky white, not blue."),
    ("clear and colourless","It does the opposite — clear lime water turns cloudy milky.")]),

 ("RO","A resting person breathes 15 times each minute. The number of breaths taken in 4 minutes, found by 15 × 4, is:",
   "60 breaths",
   C("Breaths in 4 minutes = breathing rate × time = 15 × 4 = 60 — a body count solved by multiplication.")+
   steps("The breathing rate is 15 breaths per minute","over 4 minutes: 15 × 4","15 × 4 = 60, so 60 breaths."),
   [("19 breaths","19 just adds 15 + 4; the number of breaths is 15 × 4 = 60."),
    ("11 breaths","11 subtracts 15 − 4; breaths are 15 × 4 = 60."),
    ("45 breaths","45 is 15 × 3; over 4 minutes it is 15 × 4 = 60.")]),

 ("RO","An athlete's breathing rate rises from 18 breaths per minute at rest to 30 during a run. The increase, found by 30 − 18, is:",
   "12 breaths per minute",
   C("Increase = new rate − old rate = 30 − 18 = 12 breaths per minute — a science change found by subtraction.")+
   steps("Resting rate is 18; running rate is 30","increase = 30 − 18","30 − 18 = 12 breaths per minute."),
   [("48 breaths per minute","48 ADDS the two rates; the increase is 30 − 18 = 12."),
    ("30 breaths per minute","30 is the new rate alone; the increase is 30 − 18 = 12."),
    ("2 breaths per minute","2 is not the difference; 30 − 18 = 12 breaths per minute.")]),

 ("RO","During daytime a green plant both photosynthesises and respires, but overall it gives out more:",
   "oxygen than carbon dioxide",
   C("In bright light, photosynthesis runs faster than respiration, so the plant releases more oxygen overall.")+
   steps("By day the plant makes food and respires","photosynthesis is faster than respiration in light","so it gives out more oxygen than carbon dioxide."),
   [("carbon dioxide than oxygen","By day photosynthesis dominates, so MORE oxygen is given out, not carbon dioxide."),
    ("water than oxygen","The point is the respiratory gases; by day the plant releases more oxygen."),
    ("nitrogen than oxygen","Plants do not release nitrogen this way; by day they give out more oxygen.")]),
]

RO_UC = [
 "Knowing respiration releases energy is how you understand where your body's energy really comes from.",
 "Knowing we breathe in oxygen is the first fact behind every lesson on the lungs.",
 "Knowing we breathe out carbon dioxide is why a closed, crowded room soon feels stuffy.",
 "Knowing aerobic respiration is how you explain why steady exercise needs a good oxygen supply.",
 "Knowing anaerobic respiration is how you understand energy release when oxygen runs short.",
 "Knowing muscles make lactic acid is why a hard sprint leaves your legs aching.",
 "Knowing lactic acid causes cramp is why athletes warm down to ease their muscles.",
 "Knowing yeast makes carbon dioxide is why dough rises and bread turns out soft.",
 "Knowing respiration happens in cells is how you place this process at the body's smallest level.",
 "Knowing inhalation is how you name the breathing-in half of every breath.",
 "Knowing exhalation is how you name the breathing-out half of every breath.",
 "Counting one inhale and exhale as a breath is how a doctor measures your breathing.",
 "Knowing breathing rate is how a nurse checks how fast a patient is breathing.",
 "Knowing the diaphragm is how you understand the muscle that powers each breath.",
 "Knowing about alveoli is how you picture where oxygen actually enters the blood.",
 "Knowing insects use spiracles is how you explain breathing in a creature with no lungs.",
 "Knowing fish use gills is how you understand breathing under water.",
 "Knowing earthworms breathe through skin is why they die if their skin dries out.",
 "Knowing plants respire through stomata is how you see plants breathe like animals do.",
 "Knowing roots use soil air is why waterlogged soil can suffocate a plant's roots.",
 "Knowing why we pant is how you understand catching your breath after a sprint.",
 "The lime-water test is the classic way to prove your breath carries carbon dioxide.",
 "Multiplying rate by time is how you would work out total breaths over several minutes.",
 "Subtracting two rates is how a coach measures how much exercise raised an athlete's breathing.",
 "Knowing plants give out more oxygen by day is why a leafy room feels fresh in daylight.",
]

# ---------- LINES & ANGLES (25) — Maths ----------
LA = [
 ("LA","An angle that measures exactly 90°, like the corner of a book, is called a:",
   "right angle",
   C("An angle of exactly 90°, like a square corner, is a right angle.")+
   steps("Look at an angle of exactly 90°","it forms a perfect square corner","such an angle is a right angle."),
   [("straight angle","A straight angle is 180°, not 90°; a 90° angle is a right angle."),
    ("acute angle","An acute angle is LESS than 90°; exactly 90° is a right angle."),
    ("obtuse angle","An obtuse angle is MORE than 90°; exactly 90° is a right angle.")]),

 ("LA","An angle whose measure is less than 90° is called an:",
   "acute angle",
   C("Any angle smaller than a right angle (under 90°) is an acute angle.")+
   steps("Compare the angle with 90°","it is smaller than a right angle","an angle under 90° is acute."),
   [("obtuse angle","An obtuse angle is MORE than 90°; less than 90° is acute."),
    ("right angle","A right angle is exactly 90°; less than 90° is acute."),
    ("reflex angle","A reflex angle is more than 180°; under 90° is acute.")]),

 ("LA","An angle that is greater than 90° but less than 180° is called an:",
   "obtuse angle",
   C("An angle between a right angle and a straight angle (90°–180°) is obtuse.")+
   steps("Compare the angle with 90° and 180°","it is bigger than 90° but smaller than 180°","such an angle is obtuse."),
   [("acute angle","An acute angle is LESS than 90°; between 90° and 180° is obtuse."),
    ("right angle","A right angle is exactly 90°; more than that (under 180°) is obtuse."),
    ("straight angle","A straight angle is exactly 180°; under 180° but over 90° is obtuse.")]),

 ("LA","An angle of exactly 180°, where the two arms form one straight line, is called a:",
   "straight angle",
   C("When the arms of an angle point in exactly opposite directions, forming a line, it is a 180° straight angle.")+
   steps("Open an angle until its arms make a straight line","the measure is exactly 180°","this is a straight angle."),
   [("right angle","A right angle is 90°; a flat 180° angle is a straight angle."),
    ("complete angle","A complete angle is a full 360° turn; a straight line is 180°."),
    ("reflex angle","A reflex angle is more than 180°; exactly 180° is a straight angle.")]),

 ("LA","An angle of 35° is placed beside an angle of 55°; because their measures total 90°, this pair is called:",
   "complementary angles",
   C("A pair of angles that together make 90° are complementary.")+
   steps("Add the two angles' measures","if the total is exactly 90°","the angles are complementary."),
   [("supplementary angles","Supplementary angles add to 180°, not 90°; these add to 90°, so complementary."),
    ("vertically opposite angles","Vertically opposite angles are equal, not necessarily 90° together."),
    ("adjacent angles","Adjacent means side by side; a 90° total makes them complementary.")]),

 ("LA","Angles of 110° and 70° lie next to each other along a straight line and total 180°; such a pair is called:",
   "supplementary angles",
   C("A pair of angles that together make 180° are supplementary.")+
   steps("Add the two angles' measures","if the total is exactly 180°","the angles are supplementary."),
   [("complementary angles","Complementary angles add to 90°, not 180°; these add to 180°, so supplementary."),
    ("vertically opposite angles","Vertically opposite angles are equal; a 180° total makes them supplementary."),
    ("corresponding angles","Corresponding angles are about a transversal; a 180° total is supplementary.")]),

 ("LA","If an angle measures 30°, then its complement, the angle that completes it to 90°, is:",
   "60°",
   C("Complement = 90° − 30° = 60°, since complementary angles add to 90°.")+
   steps("Complementary angles add to 90°","subtract: 90° − 30°","90 − 30 = 60, so the complement is 60°."),
   [("150°","150° would complete it to 180° (a supplement); the complement is 90 − 30 = 60°."),
    ("70°","70° does not add to 90° with 30°; the complement is 90 − 30 = 60°."),
    ("33°","33° has no basis; the complement of 30° is 90 − 30 = 60°.")]),

 ("LA","If an angle measures 110°, then its supplement, the angle that completes it to 180°, is:",
   "70°",
   C("Supplement = 180° − 110° = 70°, since supplementary angles add to 180°.")+
   steps("Supplementary angles add to 180°","subtract: 180° − 110°","180 − 110 = 70, so the supplement is 70°."),
   [("90°","90° + 110° = 200°, not 180°; the supplement is 180 − 110 = 70°."),
    ("80°","80° + 110° = 190°, not 180°; the supplement is 70°."),
    ("250°","A supplement is under 180°; 180 − 110 = 70°, not 250°.")]),

 ("LA","Two angles that share a common vertex and a common arm and lie on opposite sides of that arm are called:",
   "adjacent angles",
   C("Angles sharing a vertex and one arm, sitting next to each other, are adjacent angles.")+
   steps("Two angles share the same corner and one arm","they lie side by side on either side of that arm","such angles are adjacent."),
   [("vertically opposite angles","Vertically opposite angles face each other across crossing lines, not side by side."),
    ("complementary angles","Complementary is about adding to 90°, not about sharing an arm."),
    ("alternate angles","Alternate angles sit on opposite sides of a transversal, not sharing one arm.")]),

 ("LA","A pair of adjacent angles whose outer (non-common) arms together form a straight line is called a:",
   "linear pair",
   C("Adjacent angles whose outer arms make a straight line form a linear pair.")+
   steps("Take two adjacent angles","their outer arms point opposite, making a straight line","this is a linear pair."),
   [("complementary pair","A complementary pair adds to 90°; a linear pair sits on a straight line (180°)."),
    ("vertical pair","Vertically opposite angles face across crossing lines; this is a linear pair."),
    ("equal pair","Being equal is not the definition; arms on a straight line make a linear pair.")]),

 ("LA","The two angles that together form a linear pair always add up to:",
   "180°",
   C("Because their outer arms form a straight line, the angles of a linear pair sum to 180°.")+
   steps("A linear pair sits on a straight line","a straight angle measures 180°","so the two angles add up to 180°."),
   [("90°","A linear pair sits on a straight line, so it adds to 180°, not 90°."),
    ("360°","360° is a full turn; a linear pair on a straight line adds to 180°."),
    ("100°","A linear pair always totals exactly 180°, not 100°.")]),

 ("LA","When two straight lines cross, the pair of angles lying directly opposite each other are equal and are called:",
   "vertically opposite angles",
   C("Crossing lines make two pairs of equal angles facing each other — vertically opposite angles.")+
   steps("Two lines cross at a point","the angles opposite each other are equal","these are vertically opposite angles."),
   [("adjacent angles","Adjacent angles sit side by side; the equal facing pair is vertically opposite."),
    ("complementary angles","Complementary is about a 90° sum; facing equal angles are vertically opposite."),
    ("corresponding angles","Corresponding angles involve a transversal across two lines, not one crossing point.")]),

 ("LA","The two long rails of a railway track keep the same gap apart and never cross, no matter how far they run; they are:",
   "parallel lines",
   C("Lines that keep the same distance apart and never meet are parallel.")+
   steps("Two lines run in the same plane","they stay the same distance apart","never meeting, they are parallel."),
   [("perpendicular lines","Perpendicular lines DO meet, at a right angle; parallel lines never meet."),
    ("intersecting lines","Intersecting lines cross; parallel lines never meet."),
    ("curved lines","These are straight lines; straight lines that never meet are parallel.")]),

 ("LA","Two lines that cross each other forming an angle of exactly 90° are said to be:",
   "perpendicular",
   C("Lines meeting at a right angle (90°) are perpendicular to each other.")+
   steps("Two lines cross","the angle between them is exactly 90°","such lines are perpendicular."),
   [("parallel","Parallel lines never meet; lines meeting at 90° are perpendicular."),
    ("acute to each other","Meeting at exactly 90° is a right angle; the lines are perpendicular."),
    ("equal","'Equal' is not a relation between lines; meeting at 90° they are perpendicular.")]),

 ("LA","A line that cuts across two or more other lines at separate points is called a:",
   "transversal",
   C("A line crossing two or more lines is a transversal.")+
   steps("Draw a line that cuts across others","it crosses each at a separate point","this crossing line is a transversal."),
   [("parallel line","A parallel line never meets the others; a line cutting across them is a transversal."),
    ("perpendicular line","A perpendicular crosses at 90° only; any line cutting across is a transversal."),
    ("bisector","A bisector cuts an angle in half; a line cutting across others is a transversal.")]),

 ("LA","When a transversal cuts two parallel lines, each pair of corresponding angles turns out to be:",
   "equal",
   C("Across two parallel lines, corresponding angles are always equal.")+
   steps("A transversal cuts two parallel lines","matching-position (corresponding) angles are formed","with parallel lines these are equal."),
   [("supplementary, adding to 180°","Corresponding angles between parallels are EQUAL, not supplementary."),
    ("always exactly 90°","They equal each other but need not be 90° unless the transversal is perpendicular."),
    ("always exactly 45°","There is no fixed 45°; corresponding angles are simply equal.")]),

 ("LA","When a transversal crosses two parallel lines, a pair of alternate interior angles turns out to be:",
   "equal",
   C("Between two parallel lines, alternate interior angles are equal.")+
   steps("A transversal crosses two parallel lines","alternate interior angles lie on opposite sides, inside","with parallel lines they are equal."),
   [("supplementary, adding to 180°","Alternate interior angles between parallels are EQUAL, not supplementary."),
    ("always right angles","They are equal to each other, not necessarily 90°."),
    ("always reflex angles","Alternate interior angles are ordinary equal angles, not reflex.")]),

 ("LA","The angle between the hour hand and the minute hand of a clock at exactly 3 o'clock is:",
   "90°, a right angle",
   C("At 3 o'clock the hands point to 12 and 3, a quarter turn apart, which is 90°.")+
   steps("At 3 o'clock one hand is at 12, the other at 3","that is a quarter of the full dial","a quarter turn is 90°, a right angle."),
   [("180°, a straight angle","180° is a half turn (as at 6 o'clock); at 3 o'clock the hands are 90° apart."),
    ("45°, half a right angle","45° is half a right angle; at 3 o'clock the hands are a full 90° apart."),
    ("360°, a complete turn","360° is a whole turn; the 3 o'clock angle is 90°.")]),

 ("LA","If the two angles of a linear pair are equal to each other, then each of them must measure:",
   "90°",
   C("A linear pair adds to 180°; if the two are equal, each is 180° ÷ 2 = 90°.")+
   steps("A linear pair adds to 180°","equal angles share that total evenly","180 ÷ 2 = 90, so each is 90°."),
   [("45°","45° + 45° = 90°, not 180°; equal angles of a linear pair are each 90°."),
    ("180°","180° each would total 360°; a linear pair totals 180°, so each equal angle is 90°."),
    ("60°","60° + 60° = 120°, not 180°; each equal angle is 90°.")]),

 ("LA","An angle of exactly 360°, made by turning all the way round back to the start, is called a:",
   "complete angle",
   C("A full turn of 360° is called a complete angle.")+
   steps("Turn an arm all the way round","it returns to where it started","this full 360° turn is a complete angle."),
   [("straight angle","A straight angle is 180°, only half a turn; a full 360° is a complete angle."),
    ("right angle","A right angle is 90°, a quarter turn; a full turn is a complete angle."),
    ("reflex angle","A reflex angle is between 180° and 360°; exactly 360° is a complete angle.")]),

 ("LA","Two complementary angles happen to be equal to each other. Each of these angles therefore measures:",
   "45°",
   C("Complementary angles add to 90°; if equal, each is 90° ÷ 2 = 45°.")+
   steps("Complementary angles add to 90°","equal angles share it evenly","90 ÷ 2 = 45, so each is 45°."),
   [("90°","90° each would total 180°; complementary equal angles are each 45°."),
    ("30°","30° + 30° = 60°, not 90°; each equal complementary angle is 45°."),
    ("60°","60° + 60° = 120°, not 90°; each is 45°.")]),

 ("LA","An angle whose measure is more than 180° but less than 360° is called a:",
   "reflex angle",
   C("An angle bigger than a straight angle (over 180°) but under a full turn is a reflex angle.")+
   steps("Compare the angle with 180° and 360°","it is more than 180° but less than 360°","such an angle is a reflex angle."),
   [("obtuse angle","An obtuse angle is between 90° and 180°; over 180° it is reflex."),
    ("straight angle","A straight angle is exactly 180°; more than that is reflex."),
    ("complete angle","A complete angle is exactly 360°; less than that but over 180° is reflex.")]),

 ("LA","When two lines cross, one of the angles formed measures 65°. The angle vertically opposite to it measures:",
   "65°",
   C("Vertically opposite angles are equal, so the opposite angle is also 65°.")+
   steps("Two crossing lines make vertically opposite angles","such angles are always equal","so the opposite of 65° is 65°."),
   [("115°","115° is the adjacent angle (180 − 65); the vertically OPPOSITE angle equals 65°."),
    ("25°","25° would be a complement; the vertically opposite angle is equal, 65°."),
    ("90°","Vertically opposite angles equal the original, so it is 65°, not 90°.")]),

 ("LA","One angle of a linear pair measures 120°. The other angle of that pair measures:",
   "60°",
   C("A linear pair adds to 180°, so the other angle is 180° − 120° = 60°.")+
   steps("A linear pair adds to 180°","subtract: 180° − 120°","180 − 120 = 60, so the other angle is 60°."),
   [("120°","Both being 120° would total 240°; the pair totals 180°, so the other is 60°."),
    ("240°","240° is more than a straight line; the linear pair totals 180°, giving 60°."),
    ("90°","90° + 120° = 210°, not 180°; the other angle is 60°.")]),

 ("LA","At exactly 6 o'clock, the hour and minute hands point in opposite directions, forming an angle of:",
   "180°, a straight angle",
   C("At 6 o'clock the hands point straight up and straight down — exactly opposite — making a 180° straight angle.")+
   steps("At 6 o'clock one hand is at 12, the other at 6","they point in exactly opposite directions","opposite directions make a 180° straight angle."),
   [("90°, a right angle","90° is the 3 o'clock right angle; at 6 o'clock the hands are 180° apart."),
    ("360°, a complete turn","360° is a full turn; opposite hands make a half turn of 180°."),
    ("60°, an acute angle","60° is the gap of one hour mark; at 6 o'clock the hands are 180° apart.")]),
]

LA_UC = [
 "Knowing a right angle is how you check a corner is truly square when building or drawing.",
 "Knowing acute angles is how you describe the sharp corner of a slice of pizza.",
 "Knowing obtuse angles is how you name the wide opening of a reclining chair.",
 "Knowing a straight angle is how you see a flat line as an angle of 180°.",
 "Knowing complementary angles is how you find a missing angle that completes a right angle.",
 "Knowing supplementary angles is how you find a missing angle along a straight line.",
 "Finding a complement is the quick subtraction 90° minus the angle you already know.",
 "Finding a supplement is the quick subtraction 180° minus the angle you already know.",
 "Knowing adjacent angles is how you describe two angles sharing a corner and an arm.",
 "Knowing a linear pair is how you spot two angles sitting on one straight line.",
 "Knowing a linear pair totals 180° is how you find one angle from the other on a line.",
 "Knowing vertically opposite angles is how you read crossing roads or scissors at a glance.",
 "Knowing parallel lines is how you understand railway tracks that never meet.",
 "Knowing perpendicular lines is how you describe a wall meeting the floor at a right angle.",
 "Knowing a transversal is how you read a road cutting across two parallel streets.",
 "Knowing corresponding angles are equal is a shortcut for finding angles between parallels.",
 "Knowing alternate angles are equal is another quick way to find angles between parallels.",
 "Reading the 3 o'clock angle is an everyday way to picture a right angle on a clock face.",
 "Knowing equal linear-pair angles are 90° is how you prove two crossing lines are perpendicular.",
 "Knowing a complete angle is how you measure a full spin of 360°.",
 "Knowing equal complementary angles are 45° is how a 45° set-square corner is understood.",
 "Knowing reflex angles is how you measure the larger angle going the long way round.",
 "Using vertically opposite angles is how you find an unknown angle without measuring it.",
 "Using a linear pair is how you find the angle next to a known one on a straight line.",
 "Reading the 6 o'clock angle is an everyday way to picture a straight 180° angle.",
]

# ---------- PERIMETER & AREA (25) — Maths ----------
PA = [
 ("PA","A gardener wants to put a fence right along the outer edge of a rectangular plot; the fencing length needed equals the plot's:",
   "perimeter",
   C("The distance once around the edge of a shape is its perimeter.")+
   steps("Trace right around the edge of the shape","add up the lengths of all the sides","this total boundary length is the perimeter."),
   [("area","Area is the surface a shape COVERS; the boundary length is the perimeter."),
    ("volume","Volume is the space a solid fills; the boundary of a flat shape is its perimeter."),
    ("diagonal","A diagonal is one line across a shape, not the whole boundary, which is the perimeter.")]),

 ("PA","To work out how many floor tiles are needed to cover a room's floor completely, you must first find the floor's:",
   "area",
   C("How much surface a shape covers is its area, measured in square units.")+
   steps("Look at the flat surface the shape covers","measure how much space that surface takes","this covered surface is the area."),
   [("perimeter","Perimeter is the boundary LENGTH; the surface covered is the area."),
    ("volume","Volume is for solids; a flat shape's covered surface is its area."),
    ("height","Height is one measurement; the surface covered is the area.")]),

 ("PA","The perimeter of a square whose side is 5 cm long, found by 4 × side, is:",
   "20 cm",
   C("A square has 4 equal sides, so perimeter = 4 × 5 = 20 cm.")+
   steps("A square has 4 equal sides","perimeter = 4 × side = 4 × 5","4 × 5 = 20, so the perimeter is 20 cm."),
   [("25 cm","25 is the AREA (5 × 5); the perimeter is 4 × 5 = 20 cm."),
    ("10 cm","10 is only two sides; a square has four, giving 4 × 5 = 20 cm."),
    ("9 cm","9 has no basis; the perimeter is 4 × 5 = 20 cm.")]),

 ("PA","The area of a square whose side is 5 cm long, found by side × side, is:",
   "25 cm²",
   C("Area of a square = side × side = 5 × 5 = 25 cm².")+
   steps("A square's area = side × side","put in 5 × 5","5 × 5 = 25, so the area is 25 cm²."),
   [("20 cm²","20 is the PERIMETER (4 × 5); the area is 5 × 5 = 25 cm²."),
    ("10 cm²","10 is 5 + 5; area is side × side = 25 cm²."),
    ("15 cm²","15 has no basis; the area is 5 × 5 = 25 cm².")]),

 ("PA","The perimeter of a rectangle is correctly found using the formula:",
   "2 × (length + breadth)",
   C("A rectangle's perimeter adds all four sides: two lengths and two breadths, i.e. 2 × (length + breadth).")+
   steps("A rectangle has 2 lengths and 2 breadths","add one length and one breadth, then double","this gives 2 × (length + breadth)."),
   [("length × breadth","That formula gives the AREA, not the perimeter, of a rectangle."),
    ("length + breadth alone","This adds only one of each side; the perimeter doubles it: 2 × (length + breadth)."),
    ("4 × length","4 × side works for a SQUARE; a rectangle's perimeter is 2 × (length + breadth).")]),

 ("PA","The area of a rectangle is correctly found using the formula:",
   "length × breadth",
   C("A rectangle's area is its length multiplied by its breadth.")+
   steps("A rectangle's area fills length by breadth","multiply the two","area = length × breadth."),
   [("2 × (length + breadth)","That formula gives the PERIMETER, not the area."),
    ("length + breadth alone","Adding the sides does not give area; area = length × breadth."),
    ("side × side","Side × side is for a SQUARE; a rectangle's area is length × breadth.")]),

 ("PA","A rectangle is 7 cm long and 4 cm wide. Its perimeter, found by 2 × (7 + 4), is:",
   "22 cm",
   C("Perimeter = 2 × (length + breadth) = 2 × (7 + 4) = 2 × 11 = 22 cm.")+
   steps("Add length and breadth: 7 + 4 = 11","double it: 2 × 11","2 × 11 = 22, so the perimeter is 22 cm."),
   [("28 cm","28 is the AREA (7 × 4); the perimeter is 2 × 11 = 22 cm."),
    ("11 cm","11 is just length + breadth; the perimeter doubles it to 22 cm."),
    ("14 cm","14 is 2 × 7 only; the perimeter is 2 × (7 + 4) = 22 cm.")]),

 ("PA","A rectangle is 7 cm long and 4 cm wide. Its area, found by 7 × 4, is:",
   "28 cm²",
   C("Area = length × breadth = 7 × 4 = 28 cm².")+
   steps("Area of a rectangle = length × breadth","put in 7 × 4","7 × 4 = 28, so the area is 28 cm²."),
   [("22 cm²","22 is the PERIMETER 2 × (7 + 4); the area is 7 × 4 = 28 cm²."),
    ("11 cm²","11 is 7 + 4; area is length × breadth = 28 cm²."),
    ("14 cm²","14 is 2 × 7; the area is 7 × 4 = 28 cm².")]),

 ("PA","The area of a right-angled triangle with base 6 cm and height 4 cm, found by ½ × base × height, is:",
   "12 cm²",
   C("Area of a triangle = ½ × base × height = ½ × 6 × 4 = 12 cm².")+
   steps("Area of a triangle = ½ × base × height","put in ½ × 6 × 4","½ × 24 = 12, so the area is 12 cm²."),
   [("24 cm²","24 is base × height; a triangle takes HALF of that, giving 12 cm²."),
    ("10 cm²","10 is 6 + 4; area is ½ × 6 × 4 = 12 cm²."),
    ("20 cm²","20 has no basis; the area is ½ × 6 × 4 = 12 cm².")]),

 ("PA","The area of a triangle is correctly found using the formula:",
   "½ × base × height",
   C("A triangle's area is half the base times the height.")+
   steps("A triangle fills half of a matching rectangle","so take half of base × height","area = ½ × base × height."),
   [("base × height alone","Base × height gives a PARALLELOGRAM's area; a triangle is HALF of that."),
    ("length × breadth","That is a rectangle's area; a triangle uses ½ × base × height."),
    ("side × side","Side × side is a square's area; a triangle uses ½ × base × height.")]),

 ("PA","The area of a parallelogram is correctly found using the formula:",
   "base × height",
   C("A parallelogram's area is its base multiplied by its perpendicular height.")+
   steps("A parallelogram reshapes into a rectangle of the same base and height","its area is base × height","so area = base × height."),
   [("½ × base × height","That formula is for a TRIANGLE, which is half a parallelogram."),
    ("2 × (base + height)","That looks like a perimeter formula, not the parallelogram's area."),
    ("side × side","Side × side is a square's area; a parallelogram uses base × height.")]),

 ("PA","A parallelogram has a base of 10 cm and a height of 4 cm. Its area, found by 10 × 4, is:",
   "40 cm²",
   C("Area of a parallelogram = base × height = 10 × 4 = 40 cm².")+
   steps("Area = base × height","put in 10 × 4","10 × 4 = 40, so the area is 40 cm²."),
   [("20 cm²","20 would halve it like a triangle; a parallelogram is base × height = 40 cm²."),
    ("14 cm²","14 is 10 + 4; the area is 10 × 4 = 40 cm²."),
    ("28 cm²","28 is 2 × (10 + 4), a perimeter idea; the area is 10 × 4 = 40 cm².")]),

 ("PA","One square metre (1 m²) is equal to this many square centimetres:",
   "10000 cm²",
   C("1 m = 100 cm, so 1 m² = 100 × 100 = 10000 cm².")+
   steps("1 metre = 100 centimetres","a square metre is 100 cm × 100 cm","100 × 100 = 10000, so 1 m² = 10000 cm²."),
   [("100 cm²","100 cm² mistakes m² for m; 1 m² = 100 × 100 = 10000 cm²."),
    ("1000 cm²","1000 is 10 × 100; a square metre is 100 × 100 = 10000 cm²."),
    ("1000000 cm²","That would be square millimetres in a m²; in cm² it is 10000.")]),

 ("PA","The distance once around a square park whose side is 25 m, found by 4 × side, is:",
   "100 m",
   C("Perimeter of a square = 4 × side = 4 × 25 = 100 m.")+
   steps("A square park has 4 equal sides of 25 m","perimeter = 4 × 25","4 × 25 = 100, so it is 100 m around."),
   [("625 m","625 is the AREA (25 × 25); the distance around is 4 × 25 = 100 m."),
    ("50 m","50 is only two sides; all four give 4 × 25 = 100 m."),
    ("75 m","75 is three sides; the full boundary is 4 × 25 = 100 m.")]),

 ("PA","The area of a square field whose side is 20 m, found by side × side, is:",
   "400 m²",
   C("Area of a square = side × side = 20 × 20 = 400 m².")+
   steps("Area of a square = side × side","put in 20 × 20","20 × 20 = 400, so the area is 400 m²."),
   [("80 m²","80 is the PERIMETER (4 × 20); the area is 20 × 20 = 400 m²."),
    ("40 m²","40 is 20 + 20; area is side × side = 400 m²."),
    ("200 m²","200 has no basis; the area is 20 × 20 = 400 m².")]),

 ("PA","The proper kind of unit used to measure the AREA of a surface is a:",
   "square unit, such as cm² or m²",
   C("Area is measured in square units like square centimetres or square metres.")+
   steps("Area covers a two-dimensional surface","its units multiply length by length","so area is measured in square units."),
   [("plain length unit, such as cm","Plain cm measures length or perimeter; AREA uses square units."),
    ("cubic unit, such as cm³","Cubic units measure VOLUME of solids; area uses square units."),
    ("unit of time, such as seconds","Time has nothing to do with area; area uses square units.")]),

 ("PA","The proper kind of unit used to measure the PERIMETER of a figure is a:",
   "unit of length, such as cm or m",
   C("Perimeter is a length around a shape, so it is measured in length units like cm or m.")+
   steps("Perimeter is a distance round the edge","distance is measured in length units","so perimeter uses cm, m and the like."),
   [("square unit, such as cm²","Square units measure AREA; perimeter is a length in cm or m."),
    ("cubic unit, such as cm³","Cubic units measure volume; perimeter uses length units."),
    ("unit of mass, such as grams","Mass is unrelated; perimeter is a length in cm or m.")]),

 ("PA","To work out how much fencing is needed to go right around a field, you must first find its:",
   "perimeter",
   C("Fencing runs along the boundary, so you need the perimeter — the distance around.")+
   steps("Fencing follows the edge of the field","the edge length is the boundary","that boundary length is the perimeter."),
   [("area","Area is the surface inside; fencing follows the boundary, which is the perimeter."),
    ("volume","Volume is for solids; fencing needs the perimeter."),
    ("diagonal","A single diagonal is not the boundary; fencing needs the full perimeter.")]),

 ("PA","To work out how many tiles are needed to cover a floor, you must first find its:",
   "area",
   C("Tiles cover the surface, so you need the area — the amount of surface to cover.")+
   steps("Tiles cover the whole floor surface","you need the size of that surface","that surface size is the area."),
   [("perimeter","Perimeter is just the boundary; covering the floor needs the area."),
    ("height","Height is not needed for a flat floor; covering it needs the area."),
    ("diagonal","A diagonal is one line, not the surface; tiling needs the area.")]),

 ("PA","A square and a rectangle have the SAME perimeter. For the same perimeter, the shape with the larger area is usually the:",
   "square",
   C("For a fixed perimeter, a square encloses more area than a long thin rectangle.")+
   steps("Keep the boundary length the same","a square spreads it into a compact shape","so the square encloses the larger area."),
   [("long thin rectangle","A long thin rectangle wastes space; the square holds the larger area."),
    ("they are always equal","Same perimeter does not mean same area; the square holds more."),
    ("it cannot be decided at all","It can be decided: for equal perimeter the square has the larger area.")]),

 ("PA","If the side of a square is doubled, while it stays a square, its area becomes:",
   "four times as large",
   C("Area depends on side × side, so doubling the side multiplies the area by 2 × 2 = 4.")+
   steps("Area = side × side","double the side: (2 × side) × (2 × side)","this is 4 × side × side, so 4 times the area."),
   [("two times as large","The perimeter doubles, but the area uses side × side, so it becomes 4 times."),
    ("the same as before","Changing the side changes the area; doubling the side makes it 4 times."),
    ("eight times as large","Eight times would be for volume; a square's area becomes 4 times.")]),

 ("PA","A rectangle measures 12 cm by 5 cm. Its area, found by 12 × 5, is:",
   "60 cm²",
   C("Area = length × breadth = 12 × 5 = 60 cm².")+
   steps("Area of a rectangle = length × breadth","put in 12 × 5","12 × 5 = 60, so the area is 60 cm²."),
   [("34 cm²","34 is the PERIMETER 2 × (12 + 5); the area is 12 × 5 = 60 cm²."),
    ("17 cm²","17 is 12 + 5; area is length × breadth = 60 cm²."),
    ("24 cm²","24 is 2 × 12; the area is 12 × 5 = 60 cm².")]),

 ("PA","An equilateral triangle has all three sides 9 cm long. Its perimeter, found by 3 × 9, is:",
   "27 cm",
   C("An equilateral triangle has 3 equal sides, so perimeter = 3 × 9 = 27 cm.")+
   steps("All three sides are 9 cm","perimeter = 3 × side = 3 × 9","3 × 9 = 27, so the perimeter is 27 cm."),
   [("18 cm","18 counts only two sides; a triangle has three, giving 3 × 9 = 27 cm."),
    ("81 cm","81 is 9 × 9, an area-style product; the perimeter is 3 × 9 = 27 cm."),
    ("12 cm","12 has no basis; the perimeter is 3 × 9 = 27 cm.")]),

 ("PA","A rectangular vegetable garden is 10 m long and 6 m wide. The fence needed to enclose it, found by 2 × (10 + 6), is:",
   "32 m",
   C("Fencing follows the perimeter = 2 × (length + breadth) = 2 × (10 + 6) = 32 m — a garden job solved with a perimeter formula.")+
   steps("Add length and breadth: 10 + 6 = 16","double it for all four sides: 2 × 16","2 × 16 = 32, so 32 m of fence."),
   [("60 m","60 is the AREA (10 × 6); fencing follows the perimeter 2 × 16 = 32 m."),
    ("16 m","16 is just length + breadth; fencing needs the full 2 × 16 = 32 m."),
    ("20 m","20 is 2 × 10 only; the perimeter is 2 × (10 + 6) = 32 m.")]),

 ("PA","A square seed-bed of side 4 m is to be covered with a layer of soil. The area to be covered, found by 4 × 4, is:",
   "16 m²",
   C("The soil covers the square's area = side × side = 4 × 4 = 16 m² — a gardening surface found with an area formula.")+
   steps("The seed-bed is a square of side 4 m","area = side × side = 4 × 4","4 × 4 = 16, so 16 m² of soil is needed."),
   [("16 m","Soil covers a surface, so the unit is m², not m; the area is 16 m²."),
    ("8 m²","8 is 4 + 4; the area is side × side = 16 m²."),
    ("12 m²","12 has no basis; the area is 4 × 4 = 16 m².")]),
]

PA_UC = [
 "Knowing perimeter is how you measure the ribbon needed to go around a gift box.",
 "Knowing area is how you measure the paint needed to cover a wall.",
 "Finding a square's perimeter is how you measure the edging around a square tile.",
 "Finding a square's area is how you work out the carpet for a square room.",
 "Knowing the rectangle perimeter formula is how you total the four sides of a frame.",
 "Knowing the rectangle area formula is how you find the floor space of a room.",
 "Working a rectangle's perimeter is how you measure the fence around a plot.",
 "Working a rectangle's area is how you find how much turf a lawn needs.",
 "Finding a triangle's area is how you measure a triangular flag of cloth.",
 "Knowing the triangle area formula is the half-of-a-rectangle idea you reuse everywhere.",
 "Knowing the parallelogram area formula is how you measure a slanted plot of land.",
 "Working a parallelogram's area is how you find the surface of a tilted panel.",
 "Knowing 1 m² = 10000 cm² is how you switch between small and large area units.",
 "Finding a square park's perimeter is how a runner knows the distance once around it.",
 "Finding a square field's area is how a farmer knows how much ground a crop will fill.",
 "Knowing area uses square units is how you avoid mixing up cm and cm² in answers.",
 "Knowing perimeter uses length units is how you keep boundary answers in cm or m.",
 "Knowing fencing needs the perimeter is how a farmer orders the right length of wire.",
 "Knowing tiling needs the area is how you buy the right number of floor tiles.",
 "Knowing a square beats a rectangle for area is why compact fields waste less fencing.",
 "Knowing area becomes four times is how you predict the jump when a square is scaled up.",
 "Working a 12-by-5 area is the everyday sum behind sizing a tabletop or sheet.",
 "Finding an equilateral triangle's perimeter is how you edge a triangular sign.",
 "Working a garden's perimeter is exactly how you would buy fencing for a vegetable patch.",
 "Working a seed-bed's area is exactly how you would order soil to cover a planting square.",
]


def _with_uc(lst, ucs):
    assert len(lst) == len(ucs) == 25, (len(lst), len(ucs))
    out = []
    for it, uc in zip(lst, ucs):
        code, stem, correct, html, distr = it
        out.append((code, stem, correct, html + U(uc), distr))
    return out


NP = _with_uc(NP, NP_UC)
RO = _with_uc(RO, RO_UC)
LA = _with_uc(LA, LA_UC)
PA = _with_uc(PA, PA_UC)

items = []
for i in range(25):
    items += [NP[i], RO[i], LA[i], PA[i]]
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

    keydist = build_paper(PNUM, TITLE, SHORT, LABELS, items, seed=35817,
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
    split = "/".join(str(counts[c]) for c in ("NP", "RO", "LA", "PA"))
    with open("PAPERS_MANIFEST.md", "a", encoding="utf-8") as fh:
        fh.write(f"| {PNUM} | 2026-06-18 | {TITLE} | {split} | ✓ |\n")

    # ---- update QUESTION_INDEX.json ----
    idx["fingerprints"] = sorted(existing | set(new_fps))
    idx.setdefault("combos", []).append({
        "paper": PNUM,
        "chapters": ["Nutrition in Plants",
                     "Respiration in Organisms",
                     "Lines & Angles",
                     "Perimeter & Area"],
    })
    idx["papers"] = idx.get("papers", 0) + 1
    with open(idx_path, "w", encoding="utf-8") as fh:
        json.dump(idx, fh, ensure_ascii=False, indent=2)
        fh.write("\n")

    print("Files:", sorted(v for v in moves.values()))
    print("Answer key spread A/B/C/D =", dict(keydist))
    print("Fingerprints added:", len(new_fps))
