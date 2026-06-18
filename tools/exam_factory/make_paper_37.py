# -*- coding: utf-8 -*-
# Boss Challenge Paper 37 — Forests · Soil · Integers · Arithmetic Expressions
# Content-only. Uses the dependency-free examfactory engine.
# Difficulty ramp: this paper leans hard into FUSION. A seed buried below the ground is a NEGATIVE
# integer; a temperature that drops overnight is a SUBTRACTION across zero; rows of trees in a
# forest patch are a PRODUCT; compost spread plus a fixed extra is an ARITHMETIC EXPRESSION with
# brackets. The child meets a Science situation and reaches for a Maths skill. Class-7 scope,
# simple wording, hard thinking.
# Produces, under Resources/BossChallengePapers/:
#   Paper_37_<SHORT>_QuestionPaper.html  (pure HTML — questions + options)
#   Paper_37_<SHORT>_QuestionPaper.pdf
#   Paper_37_<SHORT>_Questions.md
#   Paper_37_<SHORT>_Solutions.html
import os, sys, shutil, json, re
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from examfactory import build_paper, C, steps, U

PNUM  = "37"
SHORT = "Forests_Soil_Integers_ArithExpr"
TITLE = ("Forests · Soil · "
         "Integers · Arithmetic Expressions")
LABELS = {
    "FO": "Forests",
    "SO": "Soil",
    "IN": "Integers",
    "AR": "Arithmetic Expressions",
}

# ---------- FORESTS (25) — Science ----------
FO = [
 ("FO","The uppermost layer of a forest, formed by the spreading branches of the tallest trees, is called the:",
   "canopy",
   C("The leafy roof made by the crowns of the tallest trees is called the canopy.")+
   steps("The tallest trees spread their branches at the top","their leaves together form a roof-like layer","this topmost layer is the canopy."),
   [("understorey","The understorey is the shorter layer BELOW the tall trees; the top roof is the canopy."),
    ("forest floor","The forest floor is the ground at the very bottom; the top layer is the canopy."),
    ("bedrock","Bedrock is solid rock under the soil, nothing to do with the treetops, which form the canopy.")]),

 ("FO","The branchy top part of a single tree, made of all its branches and leaves, is called its:",
   "crown",
   C("The leafy, branchy upper part of one tree is its crown.")+
   steps("Look at one whole tree","its trunk holds up a mass of branches and leaves on top","that upper leafy part is the crown."),
   [("root","The root is below the ground; the leafy top of a tree is its crown."),
    ("trunk","The trunk is the woody stem; the branchy leafy top is the crown."),
    ("canopy","The canopy is the shared roof of MANY trees; one tree's own top is its crown.")]),

 ("FO","Below the tallest trees, the shorter trees and large shrubs that receive only partial sunlight form the:",
   "understorey",
   C("The middle layer of shorter trees and shrubs under the canopy is the understorey.")+
   steps("Below the tall canopy there is less light","shorter trees and shrubs grow there","this middle layer is the understorey."),
   [("canopy","The canopy is the TOP roof of tall trees; the shorter middle layer is the understorey."),
    ("subsoil","Subsoil is a layer of earth below the topsoil, not a layer of plants; that is the understorey."),
    ("humus","Humus is rotted matter in the soil, not a plant layer; the shorter layer is the understorey.")]),

 ("FO","The dark, crumbly substance formed in the topsoil from rotted dead leaves and animal remains is:",
   "humus",
   C("Rotted leaves and remains form a dark, rich material in the soil called humus.")+
   steps("Dead leaves and animals fall to the forest floor","they rot and break down over time","the dark crumbly result is humus."),
   [("clay","Clay is a kind of fine mineral soil, not rotted matter; rotted remains form humus."),
    ("sand","Sand is large mineral grains, not decayed matter; the rotted material is humus."),
    ("bedrock","Bedrock is solid rock; the dark rotted material in topsoil is humus.")]),

 ("FO","Tiny organisms such as bacteria and fungi that break down dead leaves and dead animals into humus are called:",
   "decomposers",
   C("Bacteria and fungi that rot dead matter into humus are the decomposers.")+
   steps("Dead leaves and animals must be broken down","tiny bacteria and fungi do this rotting","such organisms are called decomposers."),
   [("producers","Producers are green plants that MAKE food; the rotting organisms are decomposers."),
    ("predators","Predators hunt live prey; the organisms that rot dead matter are decomposers."),
    ("herbivores","Herbivores eat living plants; the rotters of dead matter are decomposers.")]),

 ("FO","Forests are often called the 'green lungs' of the Earth because, in daylight, their trees give out:",
   "oxygen",
   C("By day, forest trees release oxygen during photosynthesis, refreshing the air like lungs.")+
   steps("Green leaves make food in sunlight","this process gives out a gas we breathe","that gas is oxygen, so forests act like lungs."),
   [("carbon dioxide","Trees TAKE IN carbon dioxide by day; the gas they give out is oxygen."),
    ("smoke","Trees do not make smoke; in daylight they release oxygen."),
    ("nitrogen","Nitrogen is not released by photosynthesis; daytime trees give out oxygen.")]),

 ("FO","Trees help balance the air by taking in the gas that animals breathe out; that gas is:",
   "carbon dioxide",
   C("Trees absorb the carbon dioxide that animals exhale, helping keep the air balanced.")+
   steps("Animals breathe OUT carbon dioxide","trees take this gas IN to make food","so trees absorb carbon dioxide."),
   [("oxygen","Animals breathe IN oxygen; trees take in the gas animals breathe out — carbon dioxide."),
    ("water vapour","Water vapour is not the gas of breathing; trees take in carbon dioxide."),
    ("hydrogen","Hydrogen is not breathed out by animals; trees take in carbon dioxide.")]),

 ("FO","Fallen leaves and tree roots let rainwater soak slowly into the ground rather than run off, which helps to:",
   "recharge groundwater",
   C("Forest litter and roots let rain seep in, refilling the underground water store.")+
   steps("Rain falls on the leafy forest floor","leaves and roots slow it and let it sink in","the water seeps down and recharges groundwater."),
   [("dry up the rivers","Letting water sink in feeds water sources, not dries them; it recharges groundwater."),
    ("cause floods","Soaking water in REDUCES flooding; it recharges groundwater."),
    ("pollute the soil","Clean rainwater soaking in does not pollute; it recharges groundwater.")]),

 ("FO","By gripping the soil with their roots, forest trees prevent the fertile topsoil from being washed away — that is, they prevent:",
   "soil erosion",
   C("Tree roots hold soil in place, so rain and wind cannot carry the topsoil away — they prevent erosion.")+
   steps("Bare soil is washed away by rain and wind","tree roots bind the soil firmly","so the topsoil stays — erosion is prevented."),
   [("photosynthesis","Photosynthesis is food-making by leaves, not soil loss; roots prevent soil erosion."),
    ("germination","Germination is a seed sprouting; holding soil in place prevents soil erosion."),
    ("evaporation","Evaporation is water turning to vapour; roots gripping soil prevent soil erosion.")]),

 ("FO","The sequence that shows who eats whom, such as grass → deer → tiger, is called a:",
   "food chain",
   C("A food chain shows the order of who eats whom, like grass → deer → tiger.")+
   steps("Grass is eaten by a deer","the deer is eaten by a tiger","this eating order is a food chain."),
   [("food web","A food web is MANY food chains linked together; a single eating line is a food chain."),
    ("life cycle","A life cycle shows stages of one organism's life, not who eats whom; that is a food chain."),
    ("water cycle","The water cycle traces water, not feeding order; who eats whom is a food chain.")]),

 ("FO","When many food chains in a forest cross and link with one another, together they form a:",
   "food web",
   C("Many interconnected food chains together make up a food web.")+
   steps("A forest has many food chains","these chains share animals and plants","linked together they form a food web."),
   [("food chain","A single line of who-eats-whom is a food chain; many linked chains make a food web."),
    ("crown","A crown is the leafy top of a tree, not feeding links; linked chains make a food web."),
    ("canopy","The canopy is a tree layer, not feeding links; linked food chains form a food web.")]),

 ("FO","Forest animals such as deer and rabbits, which eat only plants, are called:",
   "herbivores",
   C("Animals that feed only on plants are herbivores.")+
   steps("Some animals eat only plant matter","deer and rabbits feed on grass and leaves","such plant-eaters are herbivores."),
   [("carnivores","Carnivores eat OTHER ANIMALS; plant-eaters like deer are herbivores."),
    ("decomposers","Decomposers rot dead matter; living-plant eaters are herbivores."),
    ("producers","Producers are the plants themselves; the plant-eaters are herbivores.")]),

 ("FO","Forest animals such as the tiger, which hunt and eat other animals, are called:",
   "carnivores",
   C("Animals that feed on other animals are carnivores.")+
   steps("The tiger hunts deer and other animals","it feeds on their flesh","such flesh-eaters are carnivores."),
   [("herbivores","Herbivores eat only plants; the meat-eating tiger is a carnivore."),
    ("producers","Producers are green plants that make food; the tiger is a carnivore."),
    ("decomposers","Decomposers rot dead matter; the live-prey-hunting tiger is a carnivore.")]),

 ("FO","The cutting down of forests on a large scale for timber, farming or building is called:",
   "deforestation",
   C("Clearing forests on a large scale is called deforestation.")+
   steps("People cut large areas of forest","for wood, fields or buildings","this large-scale clearing is deforestation."),
   [("afforestation","Afforestation is PLANTING new forests; cutting them down is deforestation."),
    ("decomposition","Decomposition is dead matter rotting; clearing forests is deforestation."),
    ("germination","Germination is a seed sprouting; large-scale forest clearing is deforestation.")]),

 ("FO","Seeds of many forest plants are carried to new places by wind, water and animals; this scattering of seeds is called:",
   "seed dispersal",
   C("The spreading of seeds away from the parent plant by wind, water or animals is seed dispersal.")+
   steps("Seeds must reach new ground to grow","wind, water and animals carry them away","this scattering is seed dispersal."),
   [("pollination","Pollination is the transfer of pollen, not seeds; scattering seeds is seed dispersal."),
    ("germination","Germination is a seed sprouting after it lands; the scattering itself is seed dispersal."),
    ("decomposition","Decomposition is rotting of dead matter; spreading seeds is seed dispersal.")]),

 ("FO","Fallen trees in a forest are slowly replaced as new plants grow on their own, so the forest renews itself; this natural renewal is called:",
   "regeneration",
   C("A forest renewing itself naturally as new plants replace old ones is called regeneration.")+
   steps("Old trees die and fall","seeds sprout and new plants grow in their place","this self-renewal is regeneration."),
   [("deforestation","Deforestation is the LOSS of forest; the natural renewal of forest is regeneration."),
    ("erosion","Erosion is soil being washed away; a forest renewing itself is regeneration."),
    ("evaporation","Evaporation is water turning to vapour; forest self-renewal is regeneration.")]),

 ("FO","The smallest, soft green plants growing on the forest floor, such as grasses and small flowering plants, are the:",
   "herbs",
   C("The smallest soft-stemmed plants of the forest floor are herbs.")+
   steps("On the forest floor grow tiny soft plants","they have soft, green, non-woody stems","these smallest plants are herbs."),
   [("shrubs","Shrubs are medium woody bushes, bigger than the smallest plants, which are herbs."),
    ("trees","Trees are the tallest woody plants; the smallest soft plants are herbs."),
    ("canopy","The canopy is the leafy roof of tall trees, not floor plants; the smallest plants are herbs.")]),

 ("FO","Medium-sized woody plants, larger than the floor herbs but shorter than trees, are the:",
   "shrubs",
   C("Bushy, medium woody plants between herbs and trees are shrubs.")+
   steps("Above the tiny herbs grow bushier plants","they are woody but not as tall as trees","these medium plants are shrubs."),
   [("herbs","Herbs are the SMALLEST soft plants; the medium woody bushes are shrubs."),
    ("trees","Trees are the tallest woody plants; the medium woody bushes are shrubs."),
    ("decomposers","Decomposers are rotting organisms, not plants by size; the medium bushes are shrubs.")]),

 ("FO","The government department whose job is to look after, manage and protect the forests is the:",
   "Forest Department",
   C("Forests are cared for and protected by the Forest Department.")+
   steps("Forests need protection and management","a government body is given this duty","it is called the Forest Department."),
   [("Police Department","The police keep public order, not forests; forests are managed by the Forest Department."),
    ("Health Department","Health departments look after people's health; forests are the Forest Department's job."),
    ("Water Department","Water supply is a different service; forests are managed by the Forest Department.")]),

 ("FO","When decomposers break down dead leaves, the nutrients locked inside are returned back to the:",
   "soil",
   C("Decomposers release the nutrients of dead matter back into the soil for plants to reuse.")+
   steps("Dead leaves hold useful nutrients","decomposers rot them and free the nutrients","these nutrients pass back into the soil."),
   [("air","Solid nutrients return to the ground, not the air; they go back to the soil."),
    ("sunlight","Sunlight is energy from the Sun, not a store of nutrients; nutrients return to the soil."),
    ("clouds","Clouds carry water vapour, not soil nutrients; the nutrients return to the soil.")]),

 ("FO","Forests help bring rain because water vapour rises into the air from the leaves of trees through the process of:",
   "transpiration",
   C("Trees release water vapour from their leaves by transpiration, adding moisture to the air for rain.")+
   steps("Trees draw up water through their roots","leaves give off this water as vapour","this loss of water vapour is transpiration."),
   [("respiration","Respiration releases energy from food; the loss of water vapour from leaves is transpiration."),
    ("condensation","Condensation is vapour turning back to water; vapour leaving the leaf is transpiration."),
    ("germination","Germination is a seed sprouting; water vapour leaving leaves is transpiration.")]),

 ("FO","A small forest patch is planted in 8 rows with 9 trees in each row. The total number of trees, found by 8 × 9, is:",
   "72",
   C("Total trees = rows × trees per row = 8 × 9 = 72 — a forest count found by multiplication.")+
   steps("There are 8 rows, each with 9 trees","total = 8 × 9","8 × 9 = 72 trees."),
   [("17","17 just adds 8 + 9; the total is 8 × 9 = 72."),
    ("1","1 divides 9 ÷ 9 or so; the total is 8 × 9 = 72."),
    ("81","81 is 9 × 9; with 8 rows it is 8 × 9 = 72.")]),

 ("FO","In a tree census a forester counts 40 trees and finds that 5 of them are dead. The number of living trees, found by 40 − 5, is:",
   "35",
   C("Living trees = total − dead = 40 − 5 = 35 — a forest count found by subtraction.")+
   steps("There are 40 trees in all, 5 are dead","living = 40 − 5","40 − 5 = 35 living trees."),
   [("45","45 ADDS 40 + 5; the living trees are 40 − 5 = 35."),
    ("200","200 multiplies 40 × 5; the living trees are 40 − 5 = 35."),
    ("8","8 divides 40 ÷ 5; the living trees are 40 − 5 = 35.")]),

 ("FO","Green plants in a forest, which make their own food using sunlight and stand at the start of every food chain, are called:",
   "producers",
   C("Green plants make their own food and begin every food chain, so they are called producers.")+
   steps("Green plants trap sunlight to make food","they are eaten by animals to pass on this food","because they make and provide food first, they are producers."),
   [("consumers","Consumers EAT other living things for food; the food-making plants are producers."),
    ("decomposers","Decomposers rot dead matter; the green food-making plants are producers."),
    ("predators","Predators hunt prey; the green plants that make food are producers.")]),

 ("FO","The whole variety of different plants and animals living together in a forest is called its:",
   "biodiversity",
   C("The rich variety of living things in a forest is its biodiversity.")+
   steps("A forest holds many kinds of plants and animals","this great variety of life has a name","it is called biodiversity."),
   [("canopy","The canopy is the top tree layer, not the variety of life, which is biodiversity."),
    ("humus","Humus is rotted matter in soil, not the variety of life; that is biodiversity."),
    ("erosion","Erosion is soil being washed away; the variety of forest life is biodiversity.")]),
]

FO_UC = [
 "Knowing the canopy is how you picture the leafy roof that shades a whole forest.",
 "Knowing the crown is how you describe the branchy top of any single tree.",
 "Knowing the understorey is how you name the shadier middle layer of a forest.",
 "Knowing about humus is how you understand why forest soil is so dark and rich.",
 "Knowing decomposers is how you explain where fallen leaves disappear to.",
 "Knowing forests give out oxygen is why they are called the planet's green lungs.",
 "Knowing trees take in carbon dioxide is how forests help clean the air we share.",
 "Knowing forests recharge groundwater is why losing them dries up village wells.",
 "Knowing roots stop erosion is why hillsides are planted to keep the soil in place.",
 "Knowing a food chain is how you trace energy from a plant to a top predator.",
 "Knowing a food web is how you see all the feeding links in a forest at once.",
 "Knowing herbivores is how you sort the plant-eaters of any habitat.",
 "Knowing carnivores is how you name the hunters at the top of a food chain.",
 "Knowing deforestation is how you name the loss of forest that worries the world.",
 "Knowing seed dispersal is how you explain plants spreading to brand-new ground.",
 "Knowing regeneration is how a forest heals itself after old trees fall.",
 "Knowing herbs are the smallest plants is the first step in reading a forest's layers.",
 "Knowing shrubs are the middle layer completes your picture of forest plant sizes.",
 "Knowing the Forest Department is how you name who protects a country's forests.",
 "Knowing nutrients return to the soil is how the forest recycles everything it grows.",
 "Knowing transpiration is how forests put moisture back into the air to make rain.",
 "Multiplying rows of trees is how a forester quickly counts a planted patch.",
 "Subtracting dead trees is how a census finds how many trees are still alive.",
 "Knowing producers is how you spot the green plants that feed an entire forest.",
 "Knowing biodiversity is how you value the huge variety of life a forest holds.",
]

# ---------- SOIL (25) — Science ----------
SO = [
 ("SO","The slow breaking down of rocks into fine particles over a very long time, which forms soil, is called:",
   "weathering",
   C("Soil is made as rocks are broken into tiny particles over ages by weathering.")+
   steps("Big rocks are exposed to sun, water and wind","over very long times they crack and crumble","this rock breakdown is weathering."),
   [("erosion","Erosion is the CARRYING AWAY of soil; the breaking of rock into particles is weathering."),
    ("germination","Germination is a seed sprouting, nothing to do with rocks; rock breakdown is weathering."),
    ("evaporation","Evaporation is water turning to vapour; rock breaking into soil is weathering.")]),

 ("SO","A vertical cut showing the different layers of soil from the surface down to solid rock is called the:",
   "soil profile",
   C("The side view of soil layers from top to bedrock is the soil profile.")+
   steps("Dig straight down and look at the side","you see different layers stacked up","this layered side view is the soil profile."),
   [("food chain","A food chain is about who eats whom, not soil layers; the layered view is the soil profile."),
    ("water table","The water table is the level of underground water, not the layers; that is the soil profile."),
    ("canopy","The canopy is a forest's leafy top, not soil layers; the layered view is the soil profile.")]),

 ("SO","A single distinct band within the soil profile, such as the dark topsoil, is known as a:",
   "horizon",
   C("A single layer within a soil profile is called a horizon.")+
   steps("A soil profile shows stacked layers","each distinct layer has its own name","that layer is called a horizon."),
   [("crown","A crown is the top of a tree, not a soil layer, which is a horizon."),
    ("term","A term is a part of a maths expression, not a soil layer; that layer is a horizon."),
    ("orbit","An orbit is a path in space, nothing to do with soil; the layer is a horizon.")]),

 ("SO","The topmost, dark soil layer that is richest in humus and where most plant roots grow is called the:",
   "topsoil",
   C("The dark, humus-rich upper layer where plants root is the topsoil.")+
   steps("Look at the very top layer of soil","it is dark and full of humus","this fertile upper layer is the topsoil."),
   [("subsoil","Subsoil is the lighter layer BELOW with less humus; the rich top layer is the topsoil."),
    ("bedrock","Bedrock is the solid rock at the very bottom; the dark top layer is the topsoil."),
    ("canopy","The canopy is a forest's treetops, not a soil layer; the top soil layer is the topsoil.")]),

 ("SO","The layer of solid, unbroken rock lying at the very bottom of a soil profile is the:",
   "bedrock",
   C("The hard, solid rock at the base of the soil profile is the bedrock.")+
   steps("Go below all the loose soil layers","you reach hard, unbroken rock","this bottom solid rock is the bedrock."),
   [("topsoil","Topsoil is the dark layer at the TOP; the solid rock at the bottom is the bedrock."),
    ("humus","Humus is rotted matter near the top, not solid rock; the bottom rock is the bedrock."),
    ("subsoil","Subsoil is loose earth above the rock; the solid bottom layer is the bedrock.")]),

 ("SO","Soil made of the largest particles, through which water drains away very quickly, is:",
   "sandy soil",
   C("Sandy soil has big particles with large gaps, so water drains through it fast.")+
   steps("Feel soil with large, loose grains","water runs straight through the big gaps","this fast-draining soil is sandy soil."),
   [("clayey soil","Clayey soil has the FINEST particles and holds water; fast-draining big-grained soil is sandy."),
    ("loamy soil","Loamy soil is a balanced mix; the soil with the biggest, fast-draining grains is sandy."),
    ("humus","Humus is rotted matter, not a particle size; big-grained fast-draining soil is sandy.")]),

 ("SO","Soil made of very fine, tightly packed particles, which holds a great deal of water, is:",
   "clayey soil",
   C("Clayey soil has tiny tightly packed particles that trap and hold a lot of water.")+
   steps("Feel soil with very fine, sticky particles","the tiny gaps trap water and hold it","this water-holding soil is clayey soil."),
   [("sandy soil","Sandy soil has the LARGEST particles and drains fast; fine water-holding soil is clayey."),
    ("loamy soil","Loamy soil is a balanced mix; the finest, most water-holding soil is clayey."),
    ("bedrock","Bedrock is solid rock, not a soil type; the fine water-holding soil is clayey.")]),

 ("SO","Crops grow best in a balanced mix of sand, silt and clay; this all-round soil is called:",
   "loamy soil",
   C("Loamy soil mixes sand, clay and silt in good balance, making it ideal for most crops.")+
   steps("Mix some sand, some clay and some silt","the result holds water yet drains and breathes well","this best all-round soil is loamy soil."),
   [("sandy soil","Pure sandy soil drains too fast for most crops; the balanced best soil is loamy."),
    ("clayey soil","Pure clayey soil holds too much water; the balanced best soil is loamy."),
    ("bedrock","Bedrock is solid rock, not a growing soil; the best crop soil is loamy.")]),

 ("SO","The trickling of water slowly downward through the soil is called:",
   "percolation",
   C("Water seeping down through the soil layers is called percolation.")+
   steps("Pour water on top of the soil","it slowly works its way down through the gaps","this downward seeping is percolation."),
   [("evaporation","Evaporation is water rising as vapour; water sinking down through soil is percolation."),
    ("transpiration","Transpiration is water vapour leaving leaves; water seeping through soil is percolation."),
    ("condensation","Condensation is vapour turning to water; water trickling down soil is percolation.")]),

 ("SO","The amount of water that a particular soil is able to hold is called its:",
   "water-holding capacity",
   C("How much water a soil can hold on to is its water-holding capacity.")+
   steps("Add water to a soil sample","some soils keep more water than others","this 'how much it holds' is the water-holding capacity."),
   [("percolation rate","The percolation rate is how FAST water sinks, not how much is held; that is water-holding capacity."),
    ("weathering","Weathering is rock breaking into soil, not water held; that is water-holding capacity."),
    ("temperature","Temperature is how hot the soil is, not how much water it keeps; that is water-holding capacity.")]),

 ("SO","Sandy soil has a low water-holding capacity mainly because water passes through its large gaps:",
   "quickly",
   C("Sandy soil's big gaps let water drain away fast, so it holds little water.")+
   steps("Sandy soil has large particles with big gaps","water runs straight through these gaps","because it drains quickly, little water is held."),
   [("slowly","If water drained slowly it would be HELD; sandy soil drains quickly, holding little."),
    ("upward","Water sinks down through soil, not up; in sandy soil it drains quickly down."),
    ("never","Water does pass through; in sandy soil it does so quickly, holding little.")]),

 ("SO","Clayey soil is well suited to growing paddy (rice) because clayey soil is able to:",
   "hold water well",
   C("Paddy needs standing water, and clayey soil holds water well, so it suits rice.")+
   steps("Rice needs its field kept full of water","clayey soil traps water and holds it","so clayey soil holds water well for paddy."),
   [("drain water fast","Fast draining would dry a paddy field; clayey soil instead holds water well."),
    ("stop roots growing","Roots do grow in clayey soil; what suits paddy is that it holds water well."),
    ("make its own water","Soil cannot make water; clayey soil suits paddy by holding water well.")]),

 ("SO","The mixing of harmful substances such as plastic and chemicals into the soil is called:",
   "soil pollution",
   C("Adding harmful waste like plastic and chemicals to the soil is soil pollution.")+
   steps("Plastics and chemicals get dumped on land","they harm the soil and the life in it","this contamination is soil pollution."),
   [("soil erosion","Erosion is the soil being WASHED AWAY; harmful waste in soil is soil pollution."),
    ("weathering","Weathering is rock breaking into soil, a natural process; harmful waste is soil pollution."),
    ("percolation","Percolation is water seeping down; adding harmful waste is soil pollution.")]),

 ("SO","The carrying away of the fertile topsoil by flowing water and strong wind is called:",
   "soil erosion",
   C("When wind and running water carry off the topsoil, it is called soil erosion.")+
   steps("Bare topsoil lies loose on the surface","wind and flowing water sweep it away","this removal of topsoil is soil erosion."),
   [("soil pollution","Pollution is harmful waste ADDED to soil; topsoil being carried off is soil erosion."),
    ("percolation","Percolation is water seeping DOWN, not soil carried away; that is soil erosion."),
    ("weathering","Weathering breaks rock into soil; the carrying away of topsoil is soil erosion.")]),

 ("SO","The rotted remains of plants and animals that make the topsoil dark and fertile are the:",
   "humus",
   C("The dark, rotted plant-and-animal matter that enriches topsoil is humus.")+
   steps("Dead leaves and animals decay in the soil","they form a dark, rich material","this fertile rotted matter is humus."),
   [("sand","Sand is large mineral grains, not rotted matter; the fertile rotted matter is humus."),
    ("bedrock","Bedrock is solid rock at the base; the fertile rotted matter near the top is humus."),
    ("clay","Clay is fine mineral particles, not decayed remains; the rotted matter is humus.")]),

 ("SO","A soil scientist marks the topsoil as ending at −20 cm and the subsoil as ending at −50 cm below ground. The thickness of the subsoil layer, found by the gap between 20 cm and 50 cm, is:",
   "30 cm",
   C("Thickness = deeper depth − shallower depth = 50 − 20 = 30 cm — a soil-layer thickness found by subtraction.")+
   steps("Topsoil ends 20 cm down, subsoil ends 50 cm down","thickness = 50 − 20","50 − 20 = 30 cm of subsoil."),
   [("70 cm","70 ADDS 50 + 20; the subsoil thickness is 50 − 20 = 30 cm."),
    ("50 cm","50 cm is only the total depth to the bottom; the subsoil layer alone is 50 − 20 = 30 cm."),
    ("20 cm","20 cm is only the topsoil depth; the subsoil thickness is 50 − 20 = 30 cm.")]),

 ("SO","The lighter-coloured layer that lies just below the topsoil, with less humus and more small rock pieces, is the:",
   "subsoil",
   C("Below the dark topsoil lies the lighter, rockier subsoil.")+
   steps("Go one layer below the dark topsoil","it is paler, with little humus and more grit","this layer is the subsoil."),
   [("topsoil","Topsoil is the DARK upper layer rich in humus; the paler layer below is the subsoil."),
    ("bedrock","Bedrock is solid rock at the bottom; the layer just below the topsoil is the subsoil."),
    ("canopy","The canopy is treetops, not a soil layer; below the topsoil is the subsoil.")]),

 ("SO","When wet, clayey soil can be rolled into a ball because it feels:",
   "smooth and sticky",
   C("Clayey soil's fine particles make it feel smooth and sticky, so it holds together.")+
   steps("Wet a sample of clayey soil","its tiny particles cling together","it feels smooth and sticky and can be rolled into a ball."),
   [("rough and gritty","Rough and gritty is how SANDY soil feels; clayey soil feels smooth and sticky."),
    ("dry and dusty","Wet clayey soil is sticky, not dusty; it feels smooth and sticky."),
    ("hard like rock","Clayey soil is not solid rock; when wet it feels smooth and sticky.")]),

 ("SO","When you rub dry sandy soil between your fingers, it feels:",
   "rough and gritty",
   C("Sandy soil's large particles make it feel rough and gritty to the touch.")+
   steps("Rub dry sandy soil between your fingers","its big, hard grains scratch against the skin","so it feels rough and gritty."),
   [("smooth and sticky","Smooth and sticky is how wet CLAYEY soil feels; sandy soil feels rough and gritty."),
    ("soft like flour","Sandy soil is grainy, not powdery-soft; it feels rough and gritty."),
    ("wet and slippery","Dry sandy soil is not slippery; it feels rough and gritty.")]),

 ("SO","Apart from anchoring their roots, plants depend on the soil to supply them with water and dissolved:",
   "minerals",
   C("Soil gives plants water and the dissolved minerals (nutrients) they need to grow.")+
   steps("Roots grip the soil and drink water","the water carries dissolved nutrients","these nutrients are minerals from the soil."),
   [("oxygen for photosynthesis","Leaves get carbon dioxide and make oxygen; from soil, roots take water and minerals."),
    ("sunlight","Sunlight comes from above, not the soil; from soil plants take water and minerals."),
    ("plastic","Plastic is a pollutant, not a plant nutrient; plants take water and minerals from soil.")]),

 ("SO","A root tip is growing at a depth of −12 cm and pushes 6 cm deeper into the soil. Its new depth, found by −12 + (−6), is:",
   "−18 cm",
   C("Going deeper makes the depth more negative: −12 + (−6) = −18 cm — a soil depth found with integers.")+
   steps("Start at −12 cm below ground","growing deeper ADDS another −6","−12 + (−6) = −18 cm."),
   [("−6 cm","−6 cm would be closer to the surface; growing deeper gives −12 + (−6) = −18 cm."),
    ("18 cm","Below ground the depth is NEGATIVE; the new depth is −18 cm, not +18 cm."),
    ("−72 cm","−72 multiplies 12 × 6; growing 6 cm deeper gives −12 + (−6) = −18 cm.")]),

 ("SO","Earthworms are called a farmer's friend because, by burrowing through the ground, they make the soil more:",
   "loose and airy",
   C("Earthworm burrows loosen the soil and let air in, helping roots and water move through.")+
   steps("Earthworms tunnel through the soil","their burrows open up spaces","so the soil becomes loose and airy."),
   [("hard and packed","Burrowing LOOSENS soil, it does not pack it; worms make soil loose and airy."),
    ("salty","Worms do not add salt; they make the soil loose and airy."),
    ("waterproof","Worm tunnels let water IN, not out; they make the soil loose and airy.")]),

 ("SO","Using far too much chemical fertilizer year after year can, over time, damage the soil's:",
   "fertility",
   C("Overusing chemical fertilizers gradually harms the soil's natural fertility.")+
   steps("Chemical fertilizers are added again and again","over years this upsets the soil's balance","so the soil's fertility is harmed."),
   [("colour only","The real harm is to fertility, not merely the colour; the soil's fertility is damaged."),
    ("shape","Soil has no fixed shape to damage; what is harmed is its fertility."),
    ("temperature","Fertilizers do not chiefly change temperature; they damage the soil's fertility.")]),

 ("SO","A field is divided into 6 equal plots, and each plot needs 7 kg of compost. The total compost required, found by 6 × 7, is:",
   "42 kg",
   C("Total compost = plots × compost per plot = 6 × 7 = 42 kg — a soil-care amount found by multiplication.")+
   steps("There are 6 plots, each needing 7 kg","total = 6 × 7","6 × 7 = 42 kg of compost."),
   [("13 kg","13 just adds 6 + 7; the total is 6 × 7 = 42 kg."),
    ("1 kg","1 would be 7 ÷ 7 or so; the total is 6 × 7 = 42 kg."),
    ("36 kg","36 is 6 × 6; with 7 kg per plot it is 6 × 7 = 42 kg.")]),

 ("SO","Crops like wheat and gram grow best in soil that holds both water and air well, namely:",
   "loamy soil",
   C("Loamy soil keeps enough water and air, which is just what wheat and gram need.")+
   steps("Wheat and gram need water but not waterlogging","they also need air around the roots","loamy soil balances both, so it suits them best."),
   [("pure sandy soil","Pure sandy soil drains too fast and dries out; wheat and gram do best in loamy soil."),
    ("pure clayey soil","Pure clayey soil holds too much water and little air; the balanced choice is loamy soil."),
    ("bedrock","Bedrock is solid rock, not a growing medium; wheat and gram need loamy soil.")]),
]

SO_UC = [
 "Knowing weathering is how you understand where soil itself comes from.",
 "Knowing the soil profile is how a scientist reads the layers under a field.",
 "Knowing a horizon is how you name each separate band in that profile.",
 "Knowing the topsoil is how you find the layer where crops actually grow.",
 "Knowing bedrock is how you mark the solid floor beneath all the soil.",
 "Knowing sandy soil drains fast is how you choose soil for plants that hate wet feet.",
 "Knowing clayey soil holds water is how you pick soil for thirsty crops like rice.",
 "Knowing loamy soil is best is how a farmer judges good cropland.",
 "Knowing percolation is how you understand rainwater reaching the underground store.",
 "Knowing water-holding capacity is how you match a soil to the right crop.",
 "Knowing sandy soil drains quickly is why it dries out so fast after rain.",
 "Knowing clayey soil suits paddy is everyday science behind a flooded rice field.",
 "Knowing soil pollution is how you name the harm done by dumping waste on land.",
 "Knowing soil erosion is how you explain a bare slope losing its fertile top.",
 "Knowing humus enriches soil is how you understand what makes land fertile.",
 "Subtracting layer depths is how a scientist measures the thickness of the subsoil.",
 "Knowing the subsoil is how you complete your picture of the soil's middle layer.",
 "Knowing clayey soil feels sticky is a simple field test you can do by hand.",
 "Knowing sandy soil feels gritty is the touch test for a coarse, fast-draining soil.",
 "Knowing plants take minerals from soil is how you link healthy soil to healthy crops.",
 "Using integers for root depth is how a scientist tracks how far roots reach down.",
 "Knowing earthworms loosen soil is why gardeners welcome them in their beds.",
 "Knowing overusing fertilizer harms soil is why farmers are urged to use it sparingly.",
 "Multiplying plots by compost is how a farmer orders the right amount for a field.",
 "Knowing loamy soil suits wheat and gram links soil type to the crops it grows best.",
]

# ---------- INTEGERS (25) — Maths ----------
IN = [
 ("IN","Positive numbers, negative numbers and zero, such as −3, 0 and +5, are together called:",
   "integers",
   C("The whole numbers together with their negatives and zero are the integers.")+
   steps("Take the counting numbers 1, 2, 3 …","add their negatives −1, −2, −3 … and zero","this whole set is the integers."),
   [("fractions","Fractions are parts of a whole like 1/2; whole numbers with negatives are integers."),
    ("decimals","Decimals like 0.5 are not whole; the whole numbers with negatives are integers."),
    ("multiples","Multiples are the times-table of a number; the set with negatives and zero is the integers.")]),

 ("IN","On a number line, the integers lying to the left of zero, such as −2 and −5, are all:",
   "negative",
   C("Every integer to the left of zero on the number line is a negative integer.")+
   steps("Mark zero in the middle of the line","look at the side to the LEFT of zero","all those integers are negative."),
   [("positive","Positive integers lie to the RIGHT of zero; those on the left are negative."),
    ("zero","Zero is the single point in the middle; the integers left of it are negative."),
    ("fractions","Left-of-zero integers are not fractions; they are negative integers.")]),

 ("IN","The one integer that is neither positive nor negative is:",
   "zero",
   C("Zero is the only integer that is neither positive nor negative.")+
   steps("Positive integers are right of the middle, negatives are left","one number sits exactly in the middle","that number, neither side, is zero."),
   [("one","One is a POSITIVE integer; the neither-positive-nor-negative integer is zero."),
    ("−1","−1 is a NEGATIVE integer; the one that is neither is zero."),
    ("ten","Ten is positive; the integer that is neither positive nor negative is zero.")]),

 ("IN","A seed is buried 4 cm below the soil surface, shown as the integer −4. If it is lifted 4 cm up to the surface, it reaches the integer:",
   "0",
   C("Coming up 4 cm from −4 reaches the surface: −4 + 4 = 0 — a soil position shown with integers.")+
   steps("The seed starts at −4 (4 cm below)","lifting it 4 cm ADDS 4","−4 + 4 = 0, the surface."),
   [("−8","−8 would be going DEEPER; lifting up gives −4 + 4 = 0."),
    ("4","4 would be 4 cm ABOVE the surface; reaching the surface is exactly 0."),
    ("−4","−4 is where it started; after rising 4 cm it is at −4 + 4 = 0.")]),

 ("IN","The sum −3 + 5 equals:",
   "2",
   C("Adding −3 and 5: start at −3 and move 5 to the right to reach 2.")+
   steps("Start at −3 on the number line","add 5 means move 5 steps right","−3, −2, −1, 0, 1, 2 → 2."),
   [("−2","−2 would be 3 − 5; here it is −3 + 5 = 2."),
    ("8","8 adds 3 + 5 ignoring the minus; −3 + 5 = 2."),
    ("−8","−8 would be −3 + (−5); here it is −3 + 5 = 2.")]),

 ("IN","The sum −6 + (−2) equals:",
   "−8",
   C("Adding two negatives makes a larger negative: −6 + (−2) = −8.")+
   steps("Both numbers are negative","add their sizes: 6 + 2 = 8","keep the minus sign: −8."),
   [("−4","−4 would be −6 + 2; here BOTH are negative, giving −8."),
    ("8","8 drops the minus; two negatives give −6 + (−2) = −8."),
    ("4","4 would be 6 − 2; adding two negatives gives −8.")]),

 ("IN","The difference 4 − 9 equals:",
   "−5",
   C("Subtracting a larger number gives a negative result: 4 − 9 = −5.")+
   steps("Start at 4 and move 9 to the left","you cross zero into the negatives","4 − 9 = −5."),
   [("5","5 ignores the sign; 4 − 9 crosses below zero to −5."),
    ("13","13 ADDS 4 + 9; the difference 4 − 9 is −5."),
    ("−13","−13 would be −4 − 9; here it is 4 − 9 = −5.")]),

 ("IN","At night a forest is at −2°C; by noon it rises by 7°C. The noon temperature, found by −2 + 7, is:",
   "5°C",
   C("Warming up 7° from −2° gives −2 + 7 = 5°C — a temperature change handled with integers.")+
   steps("Start at −2°C","a 7° rise ADDS 7","−2 + 7 = 5°C."),
   [("−9°C","−9 would be −2 + (−7), a FALL; a rise gives −2 + 7 = 5°C."),
    ("9°C","9 ignores the start being below zero; −2 + 7 = 5°C."),
    ("−5°C","−5 would be 2 − 7; from −2 a 7° rise gives 5°C.")]),

 ("IN","The product (−3) × 4 equals:",
   "−12",
   C("A negative times a positive gives a negative: (−3) × 4 = −12.")+
   steps("Multiply the sizes: 3 × 4 = 12","one factor is negative, one positive","negative × positive = negative, so −12."),
   [("12","A negative times a positive is NEGATIVE; (−3) × 4 = −12, not +12."),
    ("−7","−7 would be −3 − 4; multiplying gives (−3) × 4 = −12."),
    ("−1","−1 would be −3 + ... ; the product (−3) × 4 = −12.")]),

 ("IN","The product (−5) × (−2) equals:",
   "10",
   C("A negative times a negative gives a positive: (−5) × (−2) = 10.")+
   steps("Multiply the sizes: 5 × 2 = 10","both factors are negative","negative × negative = positive, so +10."),
   [("−10","Two negatives multiply to a POSITIVE; (−5) × (−2) = +10, not −10."),
    ("−7","−7 would be −5 − 2; multiplying gives (−5) × (−2) = 10."),
    ("7","7 would be 5 + 2; the product is (−5) × (−2) = 10.")]),

 ("IN","Dividing (−12) ÷ 3 gives:",
   "−4",
   C("A negative divided by a positive gives a negative: (−12) ÷ 3 = −4.")+
   steps("Divide the sizes: 12 ÷ 3 = 4","one is negative, one positive","negative ÷ positive = negative, so −4."),
   [("4","A negative divided by a positive is NEGATIVE; (−12) ÷ 3 = −4."),
    ("−9","−9 would be −12 + 3; dividing gives (−12) ÷ 3 = −4."),
    ("−36","−36 multiplies 12 × 3; dividing gives (−12) ÷ 3 = −4.")]),

 ("IN","Dividing (−20) ÷ (−4) gives:",
   "5",
   C("A negative divided by a negative gives a positive: (−20) ÷ (−4) = 5.")+
   steps("Divide the sizes: 20 ÷ 4 = 5","both are negative","negative ÷ negative = positive, so +5."),
   [("−5","Two negatives divide to a POSITIVE; (−20) ÷ (−4) = +5, not −5."),
    ("−16","−16 would be −20 + 4; dividing gives (−20) ÷ (−4) = 5."),
    ("80","80 multiplies 20 × 4; dividing gives (−20) ÷ (−4) = 5.")]),

 ("IN","The additive inverse (the opposite) of +7 is:",
   "−7",
   C("The additive inverse of a number is the value that adds with it to give zero; for +7 it is −7.")+
   steps("We need the number that adds to +7 to make 0","+7 + (−7) = 0","so the opposite of +7 is −7."),
   [("+7","+7 added to itself gives 14, not 0; its opposite is −7."),
    ("0","Zero is its own opposite; the opposite of +7 is −7."),
    ("1/7","1/7 is the reciprocal, used for multiplying; the additive inverse of +7 is −7.")]),

 ("IN","On a number line, the greater of the two integers −1 and −6 is:",
   "−1",
   C("The integer farther to the right is greater; −1 lies to the right of −6, so −1 is greater.")+
   steps("Mark −1 and −6 on the line","−1 is closer to zero, on the right of −6","the right-hand one is greater, so −1."),
   [("−6","−6 is farther LEFT, so it is the SMALLER; the greater is −1."),
    ("they are equal","−1 and −6 are different points; the greater is −1."),
    ("0","0 is not one of the two given; between −1 and −6 the greater is −1.")]),

 ("IN","An earthworm is at a depth of −15 cm and burrows 5 cm deeper. Its new depth, found by −15 + (−5), is:",
   "−20 cm",
   C("Going deeper adds another negative: −15 + (−5) = −20 cm — a soil depth tracked with integers.")+
   steps("Start at −15 cm below ground","burrowing deeper ADDS −5","−15 + (−5) = −20 cm."),
   [("−10 cm","−10 cm would be closer to the surface; deeper gives −15 + (−5) = −20 cm."),
    ("20 cm","Below ground the depth is NEGATIVE; the new depth is −20 cm, not +20 cm."),
    ("−75 cm","−75 multiplies 15 × 5; burrowing 5 cm deeper gives −15 + (−5) = −20 cm.")]),

 ("IN","The absolute value |−8|, which is the distance of −8 from zero, equals:",
   "8",
   C("Absolute value is distance from zero, always positive; |−8| = 8.")+
   steps("Find how far −8 is from zero on the line","that distance is 8 steps","so |−8| = 8."),
   [("−8","Absolute value is never negative; |−8| = 8, not −8."),
    ("0","−8 is 8 steps from zero, not 0 steps; |−8| = 8."),
    ("16","16 would be 8 + 8; the distance of −8 from zero is just 8.")]),

 ("IN","Adding any integer to zero, for example −9 + 0, gives back:",
   "−9",
   C("Zero added to a number leaves it unchanged, so −9 + 0 = −9.")+
   steps("Zero is the 'do-nothing' number in addition","adding 0 changes nothing","so −9 + 0 = −9."),
   [("0","Adding 0 keeps the number; −9 + 0 = −9, not 0."),
    ("9","Adding zero does not change the sign; −9 + 0 = −9."),
    ("−18","−18 would be −9 + (−9); adding 0 leaves −9.")]),

 ("IN","The product of any integer and zero, for example (−7) × 0, is always:",
   "0",
   C("Any number multiplied by zero is zero, so (−7) × 0 = 0.")+
   steps("Multiplying by zero means 'zero lots of' the number","zero lots of anything is nothing","so (−7) × 0 = 0."),
   [("−7","Multiplying by 0 gives 0, not the number; (−7) × 0 = 0."),
    ("7","(−7) × 0 is 0, not 7; any number times zero is zero."),
    ("−70","−70 would be −7 × 10; times zero it is 0.")]),

 ("IN","The sum of an integer and its opposite, for example 6 + (−6), is:",
   "0",
   C("A number and its opposite cancel out to give zero: 6 + (−6) = 0.")+
   steps("6 and −6 are opposites","move 6 right then 6 left from zero","you return to 0, so 6 + (−6) = 0."),
   [("12","12 would be 6 + 6; a number plus its opposite gives 0."),
    ("−12","−12 would be −6 + (−6); 6 + (−6) cancels to 0."),
    ("6","The 6 is cancelled by the −6; the sum is 0.")]),

 ("IN","A fish floats at −3 m and a stone rests at −9 m below a forest pond's surface. The difference in their depths, found by −3 − (−9), is:",
   "6 m",
   C("Subtracting a negative adds: −3 − (−9) = −3 + 9 = 6 m apart — a depth gap found with integers.")+
   steps("The depths are −3 m and −9 m","difference = −3 − (−9) = −3 + 9","−3 + 9 = 6, so they are 6 m apart."),
   [("−12 m","−12 would be −3 + (−9); subtracting the negative gives −3 + 9 = 6 m."),
    ("12 m","12 ignores that one depth is shallower; the gap is −3 + 9 = 6 m."),
    ("3 m","3 m is just the fish's depth; the gap between them is 6 m.")]),

 ("IN","The product (−1) × (−1) × (−1) equals:",
   "−1",
   C("Three negative factors give a negative result: (−1) × (−1) × (−1) = −1.")+
   steps("(−1) × (−1) = +1 (two negatives make positive)","then +1 × (−1) = −1","an odd number of negatives stays negative, so −1."),
   [("1","An ODD count of negatives gives a negative; the product is −1, not +1."),
    ("−3","−3 would add the ones; multiplying three −1's gives −1."),
    ("3","Multiplying, not adding, three −1's gives −1.")]),

 ("IN","Among the integers −4, 0, 3 and −7, the smallest is:",
   "−7",
   C("The integer farthest to the left on the number line is smallest; that is −7.")+
   steps("Place −4, 0, 3 and −7 on the line","the one farthest LEFT is the smallest","−7 is farthest left, so it is smallest."),
   [("−4","−4 is left of zero but RIGHT of −7; the smallest is −7."),
    ("0","0 is bigger than the negatives here; the smallest is −7."),
    ("3","3 is the LARGEST of these; the smallest is −7.")]),

 ("IN","Of two integers shown on a number line, the one lying farther to the right is always the:",
   "greater",
   C("On a number line, numbers increase to the right, so the right-hand integer is greater.")+
   steps("Numbers grow as you move right along the line","the right-hand integer is past the other","so the right-hand one is greater."),
   [("smaller","Numbers grow to the right, so the right-hand one is GREATER, not smaller."),
    ("negative","An integer's sign is not decided by being on the right; the right-hand one is greater."),
    ("equal","Two different points are not equal; the right-hand integer is greater.")]),

 ("IN","A hill forest is at 3°C and the temperature drops by 8°C overnight. The new temperature, found by 3 − 8, is:",
   "−5°C",
   C("Cooling 8° from 3° takes it below zero: 3 − 8 = −5°C — a temperature change handled with integers.")+
   steps("Start at 3°C","an 8° drop SUBTRACTS 8","3 − 8 = −5°C."),
   [("5°C","Dropping below zero gives a NEGATIVE; 3 − 8 = −5°C, not +5°C."),
    ("11°C","11 ADDS 3 + 8; a drop gives 3 − 8 = −5°C."),
    ("−11°C","−11 would be −3 − 8; from +3 a drop of 8 gives −5°C.")]),

 ("IN","Subtracting a negative number, as in 5 − (−3), gives:",
   "8",
   C("Subtracting a negative is the same as adding: 5 − (−3) = 5 + 3 = 8.")+
   steps("Subtracting −3 flips to adding 3","5 + 3","5 + 3 = 8."),
   [("2","2 would be 5 − 3; subtracting a NEGATIVE adds, giving 5 + 3 = 8."),
    ("−8","−8 would be −5 − 3; here 5 − (−3) = 8."),
    ("−2","−2 would be 3 − 5; 5 − (−3) = 5 + 3 = 8.")]),
]

IN_UC = [
 "Knowing what integers are is how you handle temperatures, depths and money owed.",
 "Knowing negatives sit left of zero is the picture behind every below-zero reading.",
 "Knowing zero is neither sign is a small fact that keeps comparisons straight.",
 "Using integers for a buried seed is how you track a position below the surface.",
 "Adding across zero is how you work out a temperature that rises past freezing.",
 "Adding two negatives is how you total two debts or two downward steps.",
 "Knowing 4 − 9 is negative is how you handle 'spending more than you have'.",
 "Adding to a below-zero temperature is everyday integer maths in cold weather.",
 "Knowing a negative times a positive is negative is a core sign rule you reuse.",
 "Knowing two negatives multiply to a positive is the rule that surprises everyone.",
 "Dividing a negative by a positive is how you share a loss evenly.",
 "Knowing two negatives divide to a positive completes your sign rules for dividing.",
 "Knowing the additive inverse is how a number and its opposite cancel to zero.",
 "Comparing −1 and −6 is how you judge which cold reading is actually warmer.",
 "Using integers for a burrowing worm is how you track depth getting deeper.",
 "Knowing absolute value is how you talk about distance from zero, ignoring sign.",
 "Knowing adding zero changes nothing is a handy check in longer calculations.",
 "Knowing times-zero is always zero is a shortcut that saves a lot of work.",
 "Knowing a number plus its opposite is zero underlies solving many equations.",
 "Subtracting negatives is how you find the gap between two below-surface depths.",
 "Knowing odd-many negatives stays negative is how you sign a long product fast.",
 "Finding the smallest integer is how you order temperatures or scores with negatives.",
 "Knowing right-is-greater is the rule for comparing any two integers at a glance.",
 "Subtracting a drop from a temperature is how you find a cold overnight low.",
 "Knowing 'minus a minus' adds is the trick that fixes the commonest integer error.",
]

# ---------- ARITHMETIC EXPRESSIONS (25) — Maths ----------
AR = [
 ("AR","In the expression 7 + 4, the numbers 7 and 4 that are joined by the plus sign are called the:",
   "terms",
   C("The numbers added in a sum are called its terms; in 7 + 4 the terms are 7 and 4.")+
   steps("Look at the parts of 7 + 4","each part joined by + or − is a term","so 7 and 4 are the terms."),
   [("products","A product is the result of MULTIPLYING; the added parts of a sum are terms."),
    ("brackets","Brackets are grouping symbols, not the added parts; those parts are terms."),
    ("factors","Factors are numbers that MULTIPLY together; the added parts are terms.")]),

 ("AR","The result obtained by adding numbers together is called their:",
   "sum",
   C("Adding numbers gives their sum.")+
   steps("Take two or more numbers","join them with the plus operation","the answer is called the sum."),
   [("product","A product is the result of MULTIPLYING; the result of adding is the sum."),
    ("difference","A difference is the result of SUBTRACTING; the result of adding is the sum."),
    ("quotient","A quotient is the result of DIVIDING; the result of adding is the sum.")]),

 ("AR","The result obtained by multiplying numbers together is called their:",
   "product",
   C("Multiplying numbers gives their product.")+
   steps("Take two or more numbers","join them with the multiply operation","the answer is called the product."),
   [("sum","A sum is the result of ADDING; the result of multiplying is the product."),
    ("difference","A difference is the result of SUBTRACTING; the result of multiplying is the product."),
    ("quotient","A quotient is the result of DIVIDING; the result of multiplying is the product.")]),

 ("AR","In the expression 6 × 3, the result of the multiplication, that is the product, is:",
   "18",
   C("The product of 6 and 3 is 6 × 3 = 18.")+
   steps("Multiply 6 by 3","6 × 3 means three sixes: 6 + 6 + 6","6 × 3 = 18."),
   [("9","9 ADDS 6 + 3; the product is 6 × 3 = 18."),
    ("3","3 divides 6 ÷ ... ; the product is 6 × 3 = 18."),
    ("63","63 just sticks the digits together; the product is 6 × 3 = 18.")]),

 ("AR","To evaluate 4 + 5 × 2, the multiplication is done first, giving:",
   "14",
   C("Multiply before adding: 5 × 2 = 10, then 4 + 10 = 14.")+
   steps("Do the multiplication first: 5 × 2 = 10","then add: 4 + 10","4 + 10 = 14."),
   [("18","18 adds 4 + 5 first then × 2; multiplication comes FIRST, giving 14."),
    ("13","13 mis-multiplies; 5 × 2 = 10 and 4 + 10 = 14."),
    ("40","40 multiplies everything; only 5 × 2 is the product, giving 14.")]),

 ("AR","In the expression 12 − 2 × 3, doing the multiplication first gives:",
   "6",
   C("Multiply first: 2 × 3 = 6, then 12 − 6 = 6.")+
   steps("Do 2 × 3 = 6 first","then subtract: 12 − 6","12 − 6 = 6."),
   [("30","30 does 12 − 2 = 10 first then × 3; multiplication comes FIRST, giving 6."),
    ("36","36 multiplies 12 × 3; only 2 × 3 is the product, giving 12 − 6 = 6."),
    ("8","8 mis-subtracts; 12 − 6 = 6.")]),

 ("AR","Because the bracket is worked first, the expression (3 + 4) × 2 equals:",
   "14",
   C("Brackets first: 3 + 4 = 7, then 7 × 2 = 14.")+
   steps("Work inside the bracket: 3 + 4 = 7","then multiply: 7 × 2","7 × 2 = 14."),
   [("11","11 does 3 + 4 × 2 with NO bracket; the bracket makes it (7) × 2 = 14."),
    ("9","9 adds 3 + 4 + 2; the bracket gives (7) × 2 = 14."),
    ("24","24 would be (3 + 4) + ... or 4 × ... ; (3 + 4) × 2 = 14.")]),

 ("AR","Without any bracket, the expression 3 + 4 × 2 equals:",
   "11",
   C("Multiply first: 4 × 2 = 8, then 3 + 8 = 11.")+
   steps("Do the multiplication first: 4 × 2 = 8","then add: 3 + 8","3 + 8 = 11."),
   [("14","14 adds 3 + 4 first then × 2; without a bracket, multiplication is first, giving 11."),
    ("9","9 adds 3 + 4 + 2; here it is 3 + (4 × 2) = 11."),
    ("24","24 multiplies everything; only 4 × 2 is the product, giving 11.")]),

 ("AR","Comparing (3 + 4) × 2 with 3 + 4 × 2, the two expressions are:",
   "not equal",
   C("With the bracket the answer is 14, without it the answer is 11, so they are not equal.")+
   steps("(3 + 4) × 2 = 7 × 2 = 14","3 + 4 × 2 = 3 + 8 = 11","14 ≠ 11, so they are not equal."),
   [("always equal","They give 14 and 11, which differ, so they are NOT always equal."),
    ("both equal to 24","Neither equals 24; one is 14 and the other 11, so they are not equal."),
    ("both equal to 9","Neither equals 9; the bracket changes the value, so they are not equal.")]),

 ("AR","The value of 20 ÷ (2 + 3) is:",
   "4",
   C("Bracket first: 2 + 3 = 5, then 20 ÷ 5 = 4.")+
   steps("Work the bracket: 2 + 3 = 5","then divide: 20 ÷ 5","20 ÷ 5 = 4."),
   [("13","13 does 20 ÷ 2 = 10 then + 3; the bracket is first, giving 20 ÷ 5 = 4."),
    ("25","25 adds 20 + ... ; the value is 20 ÷ 5 = 4."),
    ("5","5 is just the bracket's value; then 20 ÷ 5 = 4.")]),

 ("AR","The value of 2 × (5 + 1) is:",
   "12",
   C("Bracket first: 5 + 1 = 6, then 2 × 6 = 12.")+
   steps("Work the bracket: 5 + 1 = 6","then multiply: 2 × 6","2 × 6 = 12."),
   [("11","11 does 2 × 5 = 10 then + 1; the bracket is first, giving 2 × 6 = 12."),
    ("8","8 adds 2 + 5 + 1; the value is 2 × 6 = 12."),
    ("16","16 mis-multiplies; 2 × 6 = 12.")]),

 ("AR","The expression 5 × 8 has the same value as 8 × 5 because multiplication can be done in any:",
   "order",
   C("Multiplication is commutative: the order of the numbers does not change the product, so 5 × 8 = 8 × 5.")+
   steps("Multiply 5 × 8 = 40","multiply 8 × 5 = 40 as well","the order did not matter — any order gives the same product."),
   [("direction","'Direction' is not a property of multiplying; the order can be swapped freely."),
    ("colour","Numbers have no colour; multiplication can be done in any order."),
    ("size only","It is the order, not size, that may be swapped; 5 × 8 = 8 × 5.")]),

 ("AR","A forest patch is laid out as 4 plots, each holding (10 trees + 2 saplings). The total number of plants, found by 4 × (10 + 2), is:",
   "48",
   C("Bracket first then multiply: 4 × (10 + 2) = 4 × 12 = 48 — a forest count written as an expression.")+
   steps("Work the bracket: 10 + 2 = 12 plants per plot","multiply by 4 plots: 4 × 12","4 × 12 = 48 plants."),
   [("42","42 does 4 × 10 = 40 then + 2; the bracket is first, giving 4 × 12 = 48."),
    ("16","16 adds 4 + 10 + 2; the total is 4 × 12 = 48."),
    ("18","18 forgets to multiply all plots; 4 × (10 + 2) = 48.")]),

 ("AR","Three bags of soil weigh 25 kg each, and an extra 10 kg is added on top. The total mass, found by 3 × 25 + 10, is:",
   "85 kg",
   C("Multiply first then add: 3 × 25 = 75, then 75 + 10 = 85 kg — a soil amount written as an expression.")+
   steps("Three 25 kg bags: 3 × 25 = 75 kg","add the extra 10 kg: 75 + 10","75 + 10 = 85 kg."),
   [("105 kg","105 does 3 × (25 + 10); here the +10 is added once: 3 × 25 + 10 = 85 kg."),
    ("75 kg","75 kg is only the three bags; with the extra it is 75 + 10 = 85 kg."),
    ("38 kg","38 adds 3 + 25 + 10; the total is 3 × 25 + 10 = 85 kg.")]),

 ("AR","The value of 100 − (40 + 30) is:",
   "30",
   C("Bracket first: 40 + 30 = 70, then 100 − 70 = 30.")+
   steps("Work the bracket: 40 + 30 = 70","then subtract: 100 − 70","100 − 70 = 30."),
   [("90","90 does 100 − 40 = 60 then + 30; the bracket is first, giving 100 − 70 = 30."),
    ("170","170 adds everything; the value is 100 − 70 = 30."),
    ("70","70 is just the bracket's value; then 100 − 70 = 30.")]),

 ("AR","The repeated sum 6 + 6 + 6 can be written more shortly as the product:",
   "3 × 6",
   C("Adding 6 three times is the same as 3 × 6 = 18.")+
   steps("Count how many 6's are added: three of them","'three sixes' means 3 × 6","so 6 + 6 + 6 = 3 × 6 = 18."),
   [("6 × 6","6 × 6 is six sixes (36); three sixes is 3 × 6 = 18."),
    ("3 + 6","3 + 6 just adds two numbers; three sixes is 3 × 6 = 18."),
    ("6 + 3","6 + 3 adds two numbers; the repeated sum is 3 × 6 = 18.")]),

 ("AR","Using the distributive idea, 6 × (10 + 1) is the same as 6 × 10 + 6 × 1, which equals:",
   "66",
   C("Multiply each part and add: 6 × 10 + 6 × 1 = 60 + 6 = 66 (and 6 × 11 = 66 as a check).")+
   steps("Split: 6 × 10 = 60 and 6 × 1 = 6","add the parts: 60 + 6","60 + 6 = 66."),
   [("17","17 adds 6 + 10 + 1; the value is 60 + 6 = 66."),
    ("60","60 is only 6 × 10; you must also add 6 × 1, giving 66."),
    ("61","61 forgets one part; 6 × 10 + 6 × 1 = 66.")]),

 ("AR","A forester plants 5 rows of 8 trees, but 4 trees later fall. The number left, found by 5 × 8 − 4, is:",
   "36",
   C("Multiply first then subtract: 5 × 8 = 40, then 40 − 4 = 36 — a forest count written as an expression.")+
   steps("Five rows of 8: 5 × 8 = 40 trees","subtract the 4 fallen: 40 − 4","40 − 4 = 36 trees left."),
   [("20","20 does 5 × (8 − 4); here only 4 trees fall in all: 5 × 8 − 4 = 36."),
    ("40","40 is the planted total; after 4 fall it is 40 − 4 = 36."),
    ("9","9 adds 5 + 8 − 4; the count is 5 × 8 − 4 = 36.")]),

 ("AR","Adding zero to a number, as in 15 + 0, leaves the value as:",
   "15",
   C("Adding zero changes nothing, so 15 + 0 = 15.")+
   steps("Zero is the 'do-nothing' number for adding","adding 0 leaves the number alone","so 15 + 0 = 15."),
   [("0","Adding 0 keeps the number, it does not erase it; 15 + 0 = 15."),
    ("150","Adding 0 does not append a digit; 15 + 0 = 15."),
    ("16","Adding 0, not 1; 15 + 0 = 15.")]),

 ("AR","The value of 24 ÷ 6 + 1 is:",
   "5",
   C("Divide before adding: 24 ÷ 6 = 4, then 4 + 1 = 5.")+
   steps("Do the division first: 24 ÷ 6 = 4","then add: 4 + 1","4 + 1 = 5."),
   [("3","3 does 24 ÷ (6 + 1) ≈; without a bracket, divide first: 24 ÷ 6 + 1 = 5."),
    ("25","25 adds 24 + 1; the value is 24 ÷ 6 + 1 = 5."),
    ("4","4 is only 24 ÷ 6; you must still add 1, giving 5.")]),

 ("AR","The value of 2 × 2 × 2 is:",
   "8",
   C("Multiplying step by step: 2 × 2 = 4, then 4 × 2 = 8.")+
   steps("First 2 × 2 = 4","then 4 × 2","4 × 2 = 8."),
   [("6","6 ADDS 2 + 2 + 2; multiplying gives 2 × 2 × 2 = 8."),
    ("4","4 is only 2 × 2; multiply by one more 2 to get 8."),
    ("2","One factor alone is 2; multiplying all three gives 8.")]),

 ("AR","To make the value of 2 + 3 × 4 come out as 20, you must place a bracket to get:",
   "(2 + 3) × 4",
   C("Bracketing the addition forces it first: (2 + 3) × 4 = 5 × 4 = 20.")+
   steps("We want the + done before the ×","put a bracket round 2 + 3","(2 + 3) × 4 = 5 × 4 = 20."),
   [("2 + (3 × 4)","2 + (3 × 4) = 2 + 12 = 14, not 20; the bracket must go round 2 + 3."),
    ("(2 + 3) + 4","(2 + 3) + 4 = 9, not 20; you need (2 + 3) × 4 = 20."),
    ("2 × 3 + 4","2 × 3 + 4 = 10, not 20; the correct bracketing is (2 + 3) × 4 = 20.")]),

 ("AR","Comparing the two products 5 × 10 and 5 × 9, the larger one is:",
   "5 × 10",
   C("With the same first number, multiplying by the bigger second number gives the larger product: 5 × 10 = 50 beats 5 × 9 = 45.")+
   steps("5 × 10 = 50","5 × 9 = 45","50 is bigger, so 5 × 10 is larger."),
   [("5 × 9","5 × 9 = 45 is the SMALLER; 5 × 10 = 50 is larger."),
    ("they are equal","50 and 45 differ, so they are not equal; 5 × 10 is larger."),
    ("neither","One must be larger; 5 × 10 = 50 is larger than 5 × 9 = 45.")]),

 ("AR","A topsoil sample gains 3 g of humus each year for 7 years, on top of a starting 4 g. Its total humus, found by 3 × 7 + 4, is:",
   "25 g",
   C("Multiply first then add: 3 × 7 = 21, then 21 + 4 = 25 g — a soil amount written as an expression.")+
   steps("Seven years at 3 g each: 3 × 7 = 21 g","add the starting 4 g: 21 + 4","21 + 4 = 25 g."),
   [("49 g","49 does (3 + 4) × 7; only the yearly gain is multiplied: 3 × 7 + 4 = 25 g."),
    ("21 g","21 g is only the gain; with the starting 4 g it is 21 + 4 = 25 g."),
    ("14 g","14 adds 3 + 7 + 4; the total is 3 × 7 + 4 = 25 g.")]),

 ("AR","Worked from left to right, the expression 8 − 3 + 2 equals:",
   "7",
   C("Addition and subtraction are done left to right: 8 − 3 = 5, then 5 + 2 = 7.")+
   steps("Go left to right: 8 − 3 = 5","then 5 + 2","5 + 2 = 7."),
   [("3","3 does 8 − (3 + 2) by adding first; left to right gives 8 − 3 + 2 = 7."),
    ("13","13 adds 8 + 3 + 2; here it is 8 − 3 + 2 = 7."),
    ("9","9 mis-steps; 8 − 3 + 2 = 7.")]),
]

AR_UC = [
 "Knowing the terms of a sum is how you read which parts are being added.",
 "Knowing the word 'sum' is how you name the answer to any addition.",
 "Knowing the word 'product' is how you name the answer to any multiplication.",
 "Finding a product is the everyday skill behind 'how many altogether' in equal groups.",
 "Doing multiplication before addition is the order rule that keeps answers correct.",
 "Knowing to multiply before subtracting is how you avoid a classic order mistake.",
 "Knowing brackets come first is how a writer forces the addition to happen early.",
 "Knowing the no-bracket order is how you read an expression exactly as written.",
 "Seeing that brackets change the value is why every bracket really matters.",
 "Working the bracket then dividing is order-of-operations in a real split.",
 "Working the bracket then multiplying is how grouped amounts get scaled up.",
 "Knowing multiplication can be reordered is a shortcut you use to multiply easily.",
 "Writing 4 × (10 + 2) for a forest patch turns a real count into one neat expression.",
 "Writing 3 × 25 + 10 for soil bags is how a total with a fixed extra is set down.",
 "Working the bracket then subtracting is how you take a group away from a whole.",
 "Writing 6 + 6 + 6 as 3 × 6 is how repeated addition becomes quick multiplication.",
 "Using the distributive idea is how you multiply big numbers by splitting them up.",
 "Writing 5 × 8 − 4 for fallen trees shows a real count as an arithmetic expression.",
 "Knowing adding zero changes nothing is a quick check inside longer sums.",
 "Dividing before adding is the order rule that keeps a two-step answer right.",
 "Evaluating 2 × 2 × 2 is the first step toward understanding powers.",
 "Placing a bracket to reach a target value is how you control an expression's result.",
 "Comparing two products is how you judge which equal-group total is bigger.",
 "Writing 3 × 7 + 4 for humus over years links a soil change to an expression.",
 "Working left to right is the rule that settles a mixed plus-and-minus expression.",
]


def _with_uc(lst, ucs):
    assert len(lst) == len(ucs) == 25, (len(lst), len(ucs))
    out = []
    for it, uc in zip(lst, ucs):
        code, stem, correct, html, distr = it
        out.append((code, stem, correct, html + U(uc), distr))
    return out


FO = _with_uc(FO, FO_UC)
SO = _with_uc(SO, SO_UC)
IN = _with_uc(IN, IN_UC)
AR = _with_uc(AR, AR_UC)

items = []
for i in range(25):
    items += [FO[i], IN[i], SO[i], AR[i]]
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

    keydist = build_paper(PNUM, TITLE, SHORT, LABELS, items, seed=37013,
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
    split = "/".join(str(counts[c]) for c in ("FO", "IN", "SO", "AR"))
    with open("PAPERS_MANIFEST.md", "a", encoding="utf-8") as fh:
        fh.write(f"| {PNUM} | 2026-06-18 | {TITLE} | {split} | ✓ |\n")

    # ---- update QUESTION_INDEX.json ----
    idx["fingerprints"] = sorted(existing | set(new_fps))
    idx.setdefault("combos", []).append({
        "paper": PNUM,
        "chapters": ["Forests",
                     "Soil",
                     "Integers",
                     "Arithmetic Expressions"],
    })
    idx["papers"] = idx.get("papers", 0) + 1
    with open(idx_path, "w", encoding="utf-8") as fh:
        json.dump(idx, fh, ensure_ascii=False, indent=2)
        fh.write("\n")

    print("Files:", sorted(v for v in moves.values()))
    print("Answer key spread A/B/C/D =", dict(keydist))
    print("Fingerprints added:", len(new_fps))
