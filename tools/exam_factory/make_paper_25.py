# -*- coding: utf-8 -*-
# Boss Challenge Paper 25 — Forests · Wastewater Story · The Triangle & its Properties · Exponents & Powers
# Content-only. Uses the dependency-free examfactory engine.
# Difficulty ramp: this paper leans hard into FUSION — many Triangle items are wrapped in a real
# Forests situation (a ladder against a tree, three trees forming a triangular plot, a guy-wire to
# a peg, the area of a triangular leaf), and many Exponents items are wrapped in a Wastewater
# situation (sewage bacteria doubling every hour, litres of water a plant cleans written as powers
# of ten, a village's daily wastewater as 10^a x 10^b). The child reads a Science context and
# applies a Maths skill. Class-7 scope, simple wording, hard thinking.
# Produces, under Resources/BossChallengePapers/:
#   Paper_25_<SHORT>_QuestionPaper.html  (pure HTML — questions + options)
#   Paper_25_<SHORT>_QuestionPaper.pdf
#   Paper_25_<SHORT>_Questions.md
#   Paper_25_<SHORT>_Solutions.html
import os, sys, shutil, json, re
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from examfactory import build_paper, C, steps, U

PNUM  = "25"
SHORT = "Forests_Wastewater_Triangle_Exponents"
TITLE = ("Forests · Wastewater Story · The Triangle & its Properties · Exponents & Powers")
LABELS = {
    "FO": "Forests",
    "WW": "Wastewater Story",
    "TR": "The Triangle & its Properties",
    "EX": "Exponents & Powers",
}

# ---------- FORESTS (25) — Science ----------
FO = [
 ("FO","Why do people describe a thick forest as the 'green lungs' of our planet? Because trees:",
   "release oxygen and take in carbon dioxide",
   C("During photosynthesis trees take in carbon dioxide and give out oxygen, just as our lungs exchange gases.")+
   steps("Green leaves photosynthesise in daylight","They absorb carbon dioxide and release oxygen","so a forest acts like a giant pair of lungs."),
   [("release carbon dioxide and take in oxygen","That is what animals do when they breathe; trees release oxygen by photosynthesis."),
    ("store all the rainwater inside their leaves","Leaves do not store the rain; the 'green lungs' name is about exchanging gases."),
    ("give out only water vapour and no gases","Trees also give out oxygen, which is exactly why they are called green lungs.")]),

 ("FO","The animals and microorganisms that break down dead plants and animals in a forest are called:",
   "decomposers",
   C("Decomposers feed on dead material and break it down into simple substances that return to the soil.")+
   steps("Dead leaves and animals fall to the floor","Fungi and bacteria feed on them","this breaking-down group is the decomposers."),
   [("producers","Producers are green plants that make their own food; the breakers-down are decomposers."),
    ("consumers","Consumers eat other living things; those that rot dead matter are decomposers."),
    ("predators","Predators hunt living prey; the rotting of dead matter is done by decomposers.")]),

 ("FO","The branches of the tall trees in a forest spread out and join to form a roof-like cover called the:",
   "canopy",
   C("The canopy is the continuous leafy roof formed where the crowns of many tall trees meet.")+
   steps("Tall trees grow side by side","Their leafy tops touch and overlap","this shady roof is the canopy."),
   [("crown","A crown is the branchy top of one single tree; the roof made by many is the canopy."),
    ("understorey","The understorey is the shrub layer below; the high roof of leaves is the canopy."),
    ("humus","Humus is the dark decayed matter in the soil, not a layer of branches.")]),

 ("FO","The branchy top part of one single tree is called its:",
   "crown",
   C("The crown is the spreading leafy and branchy top of an individual tree.")+
   steps("Look at one tree on its own","Its trunk holds up a head of branches and leaves","that head is the crown."),
   [("canopy","The canopy is the shared roof made by the crowns of many trees together."),
    ("trunk","The trunk is the main woody stem; the branchy top is the crown."),
    ("humus","Humus is decayed matter in the soil, not part of a tree's shape.")]),

 ("FO","The dark-coloured, nutrient-rich layer formed in forest soil by the decay of dead leaves and animals is called:",
   "humus",
   C("Humus is the dark, crumbly material made when decomposers break down dead matter in the soil.")+
   steps("Dead litter piles on the forest floor","Decomposers slowly rot it down","the dark rich result mixed into the soil is humus."),
   [("bedrock","Bedrock is the solid rock deep below; the decayed top matter is humus."),
    ("sand","Sand is mineral grains; the decayed organic matter is humus."),
    ("clay","Clay is a fine mineral soil; the dark decayed organic part is humus.")]),

 ("FO","Forests help prevent floods mainly because:",
   "their roots and dead leaves let rainwater soak slowly into the ground",
   C("Roots and leaf litter slow the rain and let it sink into the soil instead of rushing away.")+
   steps("Rain falls on the leafy floor","Litter and roots hold it back and soak it in","so water seeps down slowly instead of flooding."),
   [("they make the rain stop falling","Forests cannot switch off rain; they slow the water that has fallen."),
    ("their leaves drink up all the river water","Leaves do not drink rivers; roots and litter let rain soak into the ground."),
    ("they heat the air so the clouds disappear","Forests cool the air; they prevent floods by soaking up rain, not by removing clouds.")]),

 ("FO","A forest is described as a 'dynamic living entity' because:",
   "it is full of life and keeps changing and renewing itself",
   C("A forest is always growing, decaying and regrowing, so it is living and ever-changing.")+
   steps("Plants and animals are born, grow and die","Decomposers recycle the dead matter","this constant change makes it a dynamic living entity."),
   [("it never changes at all","A forest is always changing; that is why it is called dynamic."),
    ("it is made only of non-living rock","A forest is full of living things, not just rock."),
    ("it can move from place to place","A forest does not walk about; 'dynamic' means it keeps changing and renewing.")]),

 ("FO","In a forest food chain, the green plants are the:",
   "producers",
   C("Green plants make their own food by photosynthesis, so they are producers and the base of every food chain.")+
   steps("Only green plants can trap sunlight to make food","All other organisms depend on this food","so plants are the producers."),
   [("consumers","Consumers eat ready-made food; only green plants produce it."),
    ("decomposers","Decomposers rot dead matter; the food-makers are the green plants."),
    ("predators","Predators hunt prey; the food-making plants are the producers.")]),

 ("FO","Cutting down large numbers of forest trees (deforestation) leads to:",
   "more carbon dioxide staying in the air",
   C("Fewer trees take in less carbon dioxide, so the gas builds up in the air.")+
   steps("Trees normally absorb carbon dioxide","Cutting them removes these absorbers","so carbon dioxide in the air increases."),
   [("less carbon dioxide in the air","Removing trees means less is absorbed, so carbon dioxide rises, not falls."),
    ("more oxygen in the air","Fewer trees give out less oxygen, so oxygen does not rise."),
    ("more rainfall everywhere","Deforestation usually reduces rainfall, not increases it.")]),

 ("FO","Forests help the water cycle because they:",
   "recharge groundwater and release water vapour into the air",
   C("Forests let rain soak in to refill groundwater and give out water vapour that helps form clouds.")+
   steps("Rain soaks down through the leafy soil","This refills the underground water","leaves also release vapour that returns to the sky."),
   [("stop water from ever evaporating","Trees actually release lots of water vapour; they do not stop evaporation."),
    ("turn rivers into deserts","Forests keep land moist; they do not dry rivers into deserts."),
    ("make all the rain fall as snow","Forests do not change rain into snow; they recharge water and release vapour.")]),

 ("FO","The chief job of microorganisms that rot dead leaves on the forest floor is to:",
   "return nutrients to the soil as humus",
   C("By decaying dead matter, microorganisms release its nutrients back into the soil for new plants.")+
   steps("Dead litter contains locked-up nutrients","Microbes break the litter down","the nutrients go back into the soil as humus."),
   [("remove all nutrients from the soil","They add nutrients back to the soil, not take them away."),
    ("make the soil poisonous","Decomposing makes the soil fertile, not poisonous."),
    ("turn the soil into solid rock","They enrich the soil with humus; they do not make rock.")]),

 ("FO","Which of these is NOT a natural product we get from forests?",
   "plastic",
   C("Plastic is made in factories from petroleum chemicals; it does not grow in forests.")+
   steps("List forest products: gum, paper, medicines, wood","Plastic is man-made from chemicals","so plastic is the odd one out."),
   [("gum","Gum oozes naturally from forest trees, so it is a forest product."),
    ("paper","Paper is made from wood pulp that comes from forest trees."),
    ("medicines","Many medicines come from forest plants, so they are a forest product.")]),

 ("FO","The layer of small shrubs and herbs growing below the canopy is the:",
   "understorey",
   C("The understorey is the shaded lower layer of shrubs and herbs beneath the tall-tree canopy.")+
   steps("Tall trees form the high canopy","Below them grow shorter shrubs and herbs","this lower layer is the understorey."),
   [("canopy","The canopy is the high leafy roof; the shrub layer below it is the understorey."),
    ("crown","A crown is one tree's branchy top, not a whole lower layer."),
    ("humus","Humus is decayed matter in the soil, not a layer of living plants.")]),

 ("FO","Animals help forests grow by dispersing seeds when they:",
   "eat fruits and drop the seeds far from the parent tree",
   C("Animals carry seeds in fruit they eat and release them elsewhere, spreading the plants to new places.")+
   steps("An animal eats a juicy fruit","It moves away and drops or passes the seeds","the seeds sprout far from the parent tree."),
   [("cut the trees down for timber","Cutting trees harms the forest; seed dispersal is about spreading seeds, not felling."),
    ("eat all the seeds so none can grow","If every seed were destroyed nothing would grow; many seeds survive and spread."),
    ("press the seeds deep into solid rock","Seeds need soil, not rock; animals spread them across the ground.")]),

 ("FO","Forests reduce soil erosion mainly because:",
   "tree roots bind the soil and hold it in place",
   C("A dense network of roots grips the soil so wind and water cannot wash it away.")+
   steps("Roots spread through the topsoil","They knit the soil particles together","so rain and wind cannot carry the soil off."),
   [("the leaves push the soil away","Leaves do not push soil; roots hold it in place."),
    ("the trees make the soil into rock","Trees enrich soil with humus; they do not turn it to rock."),
    ("they dry the soil into loose dust","Forests keep soil moist and bound, not dusty.")]),

 ("FO","The top layer of forest soil is dark and fertile mainly because:",
   "decaying leaves keep adding humus to it",
   C("Falling litter rots into humus year after year, making the topsoil dark and rich.")+
   steps("Leaves and twigs fall every season","Decomposers turn them into humus","the humus darkens and feeds the topsoil."),
   [("rainwater bleaches it dark","Rain does not darken soil; rotting litter adds dark humus."),
    ("the sunlight burns it black","Sunlight does not blacken soil; humus from decay does."),
    ("animals paint it with mud","The dark, fertile colour comes from humus, not from mud painting.")]),

 ("FO","Forests can be a renewable resource only if:",
   "new trees are planted to replace those that are cut",
   C("A resource is renewable when it is replaced as fast as it is used, so replanting keeps a forest renewable.")+
   steps("Cutting trees uses up the forest","Planting new trees restores it","so balanced replanting keeps forests renewable."),
   [("every tree is cut down at once","Clearing everything destroys the forest; renewal needs replanting."),
    ("the forest is covered with concrete","Concreting land ends the forest; it does not renew it."),
    ("no rain is ever allowed to fall","Trees need rain to grow; renewal comes from replanting, not from stopping rain.")]),

 ("FO","Forests help regulate the local climate by:",
   "keeping the surroundings cooler and the air more humid",
   C("Shade and the water vapour trees release lower the temperature and raise the moisture nearby.")+
   steps("Tree shade blocks harsh sunlight","Leaves release water vapour","so the area stays cooler and more humid."),
   [("making the area hotter and drier","Forests cool and moisten the air; they do not dry it out."),
    ("stopping the wind from ever blowing","Forests slow strong winds but do not stop wind everywhere; the key effect is cooling."),
    ("removing all moisture from the air","Trees add moisture as vapour; they do not remove it.")]),

 ("FO","In the food chain grass → deer → tiger, the deer is a:",
   "herbivore and a primary consumer",
   C("The deer eats plants (grass), so it is a plant-eating herbivore and the first consumer in the chain.")+
   steps("Grass is the producer","The deer eats the grass","so the deer is a herbivore / primary consumer."),
   [("producer","Producers make their own food; the deer eats grass, so it is a consumer."),
    ("decomposer","Decomposers rot dead matter; the grass-eating deer is a consumer."),
    ("top carnivore","The top carnivore here is the tiger; the deer is a plant-eating consumer.")]),

 ("FO","The continuous give-and-take among trees, animals, soil and water in a forest makes it an:",
   "ecosystem",
   C("An ecosystem is a community of living things interacting with their non-living surroundings.")+
   steps("Living things share the forest with soil, air and water","They depend on and affect one another","this whole interacting system is an ecosystem."),
   [("desert","A desert is a dry, almost lifeless region, the opposite of a rich forest community."),
    ("island","An island is a landform; the interacting forest community is called an ecosystem."),
    ("factory","A factory is a man-made workplace, not a natural community of living things.")]),

 ("FO","Cutting too many forests can reduce rainfall in an area because:",
   "fewer trees release less water vapour into the air",
   C("Trees give out water vapour that helps clouds form, so fewer trees mean less vapour and less rain.")+
   steps("Leaves normally release water vapour","This vapour helps make clouds and rain","fewer trees release less vapour, so rainfall drops."),
   [("trees push the clouds away","Trees do not push clouds; they release vapour that helps make rain."),
    ("the soil becomes too wet to rain","Soil wetness does not stop rain; rainfall drops because less vapour is released."),
    ("animals drink up all the clouds","Animals cannot drink clouds; rainfall falls because of less water vapour.")]),

 ("FO","The layer of dead and decaying leaves and twigs lying on the forest floor is called:",
   "litter",
   C("Litter is the loose blanket of fallen leaves, twigs and dead matter on top of the forest soil.")+
   steps("Leaves and twigs drop to the ground","They pile up before rotting","this fallen layer is called litter."),
   [("humus","Humus is the dark matter formed after the litter has fully decayed."),
    ("canopy","The canopy is the high roof of branches, not the floor cover."),
    ("crown","A crown is a single tree's top, not a layer on the ground.")]),

 ("FO","Forests act as natural air cleaners because they:",
   "absorb carbon dioxide and trap dust on their leaves",
   C("Trees take in carbon dioxide and their leaves catch floating dust, cleaning the air.")+
   steps("Leaves take in carbon dioxide for photosynthesis","Dust settles and sticks on the leaves","so the air leaving a forest is cleaner."),
   [("give out smoke and dust","Forests clean the air; they do not give out smoke and dust."),
    ("burn up all the oxygen","Trees release oxygen; they do not burn it up."),
    ("turn clean air into poison gas","Forests purify air; they do not make poison gas.")]),

 ("FO","One strong reason not to cut down too many trees is that it:",
   "destroys animal homes and lets carbon dioxide build up",
   C("Felling forests removes the habitat animals depend on and the trees that soak up carbon dioxide.")+
   steps("Many animals live only in the forest","Trees absorb carbon dioxide","cutting them takes away homes and lets the gas build up."),
   [("makes the air much cleaner","Cutting trees makes the air dirtier, not cleaner."),
    ("increases the number of wild animals","Losing habitat reduces animals; it does not increase them."),
    ("adds more oxygen to the atmosphere","Fewer trees release less oxygen, so oxygen does not increase.")]),

 ("FO","Which statement about a forest food web is correct?",
   "many food chains link together because animals eat more than one kind of food",
   C("A food web is several food chains joined, because most animals have several food sources.")+
   steps("One animal may eat several different things","Its food chains cross and join","the joined-up network is a food web."),
   [("every animal eats only one single food","Most animals eat several foods, which is why chains join into a web."),
    ("a food web has no green plants in it","Green plants are the producers at the base of every food web."),
    ("decomposers are never part of a food web","Decomposers recycle dead matter and are an essential part of the web.")]),
]

# ---------- WASTEWATER STORY (25) — Science ----------
WW = [
 ("WW","The used, dirty water from homes, toilets and factories is called:",
   "wastewater (sewage)",
   C("Wastewater, also called sewage, is the dirty water we have already used and thrown away.")+
   steps("Water is used for washing, flushing and factories","It comes out dirty and full of waste","this used dirty water is wastewater or sewage."),
   [("fresh water","Fresh water is clean and unused; the used dirty water is wastewater."),
    ("rainwater","Rainwater falls clean from the sky; wastewater is water we have already dirtied."),
    ("distilled water","Distilled water is purified water; wastewater is the opposite — dirty used water.")]),

 ("WW","The network of underground pipes that carries sewage away is called the:",
   "sewerage",
   C("Sewerage is the system of pipes and drains that carries sewage to a treatment plant.")+
   steps("Dirty water leaves each house","It enters a system of underground pipes","this carrying system is the sewerage."),
   [("sewage","Sewage is the dirty water itself; the pipes that carry it are the sewerage."),
    ("rainwater drain only","Sewerage carries used water, not just rain; rain-only drains are separate."),
    ("water supply line","A water supply line brings clean water in; sewerage takes dirty water out.")]),

 ("WW","The harmful and unwanted substances dissolved or floating in wastewater are called:",
   "contaminants",
   C("Contaminants are the impurities — chemicals, waste and germs — that make wastewater unsafe.")+
   steps("Wastewater carries many unwanted substances","These dirty and poison the water","such impurities are called contaminants."),
   [("nutrients only","Wastewater holds many harmful substances, not just nutrients; all are contaminants."),
    ("minerals only","Useful minerals are not the harmful part; the impurities are contaminants."),
    ("gases only","Contaminants include solids, chemicals and germs, not only gases.")]),

 ("WW","The place where wastewater is cleaned before being let out is called a:",
   "wastewater treatment plant",
   C("A wastewater treatment plant (WWTP) removes contaminants so the water can be safely released.")+
   steps("Dirty sewage is collected by pipes","It is sent to a special plant","there it is cleaned in a wastewater treatment plant."),
   [("water tank","A water tank just stores clean water; the cleaning happens at a treatment plant."),
    ("power plant","A power plant makes electricity; sewage is cleaned at a treatment plant."),
    ("dairy","A dairy handles milk; wastewater is cleaned at a treatment plant.")]),

 ("WW","Large floating objects like rags, sticks and plastic are first removed from sewage by passing it through:",
   "bar screens",
   C("Bar screens are metal bars that hold back large solid objects as the sewage flows through.")+
   steps("Sewage carries rags, sticks and plastic","It flows through closely spaced metal bars","the big objects are caught — these are bar screens."),
   [("an aeration tank","Aeration adds air for bacteria; large solids are caught earlier by bar screens."),
    ("a sand filter","Sand filters trap fine grit later; the big objects are caught by bar screens first."),
    ("a boiler","A boiler heats water; large solids in sewage are removed by bar screens.")]),

 ("WW","After the bar screens, sand, grit and small pebbles are allowed to settle out in the:",
   "grit and sand removal tank",
   C("In this tank the heavy sand and grit sink to the bottom while the water flows on.")+
   steps("Water from the screens slows down","Heavy sand and grit sink to the bottom","this happens in the grit and sand removal tank."),
   [("aeration tank","Aeration adds air for bacteria; sand and grit settle earlier in the grit tank."),
    ("bar screen","Bar screens catch only large objects; the fine sand settles in the grit tank."),
    ("chlorine tank","Chlorine disinfects at the end; sand and grit settle in the grit tank.")]),

 ("WW","The heavy solid waste that sinks to the bottom of a settling tank is called:",
   "sludge",
   C("Sludge is the thick solid matter that settles at the bottom of the settling tank.")+
   steps("Cleared water sits still in the settling tank","Heavy solids sink down","this settled solid is the sludge."),
   [("clear water","The clear water flows off the top; the settled solid is sludge."),
    ("scum","Scum floats on top; the matter that sinks to the bottom is sludge."),
    ("foam","Foam is bubbles on the surface; the bottom solid is sludge.")]),

 ("WW","Oils, grease and other light matter that float on the top of the settling tank are skimmed off as:",
   "scum",
   C("Scum is the floating layer of oil and grease removed from the surface of the tank.")+
   steps("Light oils and grease rise to the surface","A skimmer scrapes the floating layer off","this skimmed layer is the scum."),
   [("sludge","Sludge sinks to the bottom; the floating oily layer is scum."),
    ("sand","Sand settles out earlier; the floating oily layer is scum."),
    ("clarified water","Clarified water is the cleaned water; the floating layer is scum.")]),

 ("WW","Air is bubbled through the cleared water in the aeration tank so that helpful bacteria can:",
   "feed on the remaining human waste and other matter",
   C("Air lets aerobic bacteria grow and consume the leftover organic waste, cleaning the water further.")+
   steps("Air gives bacteria the oxygen they need","The bacteria multiply and feed","they eat up the leftover waste in the water."),
   [("make the water dirty again","The bacteria clean the water by eating waste; they do not dirty it."),
    ("remove all the oxygen from the water","Air is added to give oxygen, not to remove it."),
    ("turn the water into oil","Bacteria eat organic waste; they do not make oil.")]),

 ("WW","The mass of helpful bacteria that grows and settles during aeration is called:",
   "activated sludge",
   C("Activated sludge is the settled clump of bacteria that have grown while feeding on the waste.")+
   steps("Bacteria multiply in the aerated water","They clump and settle out","this settled bacterial mass is activated sludge."),
   [("scum","Scum is floating oil and grease, not a settled bacterial mass."),
    ("grit","Grit is sand removed early on, not the bacterial sludge."),
    ("chlorine","Chlorine is a disinfectant chemical, not a mass of bacteria.")]),

 ("WW","Before the cleaned water is released, it is often disinfected by adding:",
   "chlorine",
   C("Chlorine is added to kill any remaining germs so the released water is safe.")+
   steps("Cleaned water may still hold some germs","Chlorine is added to it","the chlorine kills the germs before release."),
   [("oil","Oil is a contaminant we remove; chlorine is the disinfectant added."),
    ("sand","Sand is removed during treatment; the disinfectant added is chlorine."),
    ("sludge","Sludge is settled waste; the germ-killing chemical added is chlorine.")]),

 ("WW","After it is dried, the sludge from a treatment plant is often used as:",
   "manure",
   C("Dried sludge is rich in nutrients, so it is used as manure to enrich farm soil.")+
   steps("Sludge is the settled organic waste","It is dried out","the dried, nutrient-rich solid is used as manure."),
   [("drinking water","Sludge is solid waste, never drinking water."),
    ("fuel for cars","Dried sludge is used as manure, not as petrol for cars."),
    ("window glass","Glass is made from sand; dried sludge is used as manure.")]),

 ("WW","Pouring used cooking oil down the kitchen drain is harmful because the oil:",
   "hardens and blocks the drainage pipes",
   C("Oil cools, sticks and hardens inside pipes, clogging them and stopping the flow of water.")+
   steps("Hot oil cools as it flows down","It sticks to the pipe walls and hardens","the build-up blocks the drain."),
   [("makes the water flow faster","Oil clogs pipes and slows the flow; it does not speed it up."),
    ("cleans the inside of the pipes","Oil dirties and blocks pipes; it does not clean them."),
    ("turns into safe drinking water","Oil in the drain blocks pipes; it does not become drinking water.")]),

 ("WW","Where there is no sewer connection, a low-cost on-site way to treat household sewage is a:",
   "septic tank",
   C("A septic tank holds sewage in a sealed underground tank where bacteria break it down on site.")+
   steps("There are no pipes to a big plant","Sewage collects in a sealed underground tank","bacteria break it down — this is a septic tank."),
   [("overhead water tank","An overhead tank stores clean water; sewage is treated on site in a septic tank."),
    ("treatment plant","A full treatment plant needs a sewer network; the on-site option is a septic tank."),
    ("river reservoir","A reservoir stores water for use; household sewage is treated in a septic tank.")]),

 ("WW","Which of these should NOT be thrown into a household drain?",
   "used cooking oil and tea leaves",
   C("Oils and solids like tea leaves clog drains and harm the treatment process, so they must be kept out.")+
   steps("Oil hardens and blocks pipes","Tea leaves and solids choke the drain","so neither should go down the drain."),
   [("clean tap water","Clean water flows freely and does not block drains."),
    ("a little hand soap while washing","Small amounts of soap from washing pass through and are treated."),
    ("rinse water from a glass","Plain rinse water is fine; it is oil and solids that must be kept out.")]),

 ("WW","Letting untreated sewage flow straight into a river is dangerous because it:",
   "spreads water-borne diseases like cholera and typhoid",
   C("Untreated sewage carries germs that cause diseases such as cholera and typhoid when the water is used.")+
   steps("Sewage is full of disease germs","Untreated, it pollutes the river","people using the water catch diseases like cholera."),
   [("makes the river water safe to drink","Untreated sewage pollutes the river; it does not make it safe."),
    ("adds extra oxygen to the river","Sewage uses up oxygen in the river; it does not add it."),
    ("kills all the germs in the river","Sewage adds germs to the river; it does not kill them.")]),

 ("WW","Diseases such as cholera, typhoid and dysentery usually spread through:",
   "drinking water polluted with sewage",
   C("These illnesses are water-borne; their germs travel in water that sewage has contaminated.")+
   steps("Sewage carries disease germs","It contaminates drinking water","people drink it and fall ill with cholera, typhoid or dysentery."),
   [("breathing clean mountain air","These are water-borne diseases, not airborne ones."),
    ("eating fresh washed fruit","Properly washed fruit is safe; the danger is sewage-polluted water."),
    ("touching dry sand","Dry sand does not spread these diseases; polluted water does.")]),

 ("WW","Good sanitation means:",
   "the safe disposal of human waste and keeping surroundings clean",
   C("Sanitation is about getting rid of waste safely and keeping the environment clean and healthy.")+
   steps("Human waste must be removed safely","Surroundings must be kept clean","together this is good sanitation."),
   [("storing waste openly near homes","Open waste spreads disease; sanitation means safe disposal."),
    ("using more water for fun","Sanitation is about clean, safe waste disposal, not water use for fun."),
    ("throwing rubbish into rivers","Dumping rubbish in rivers is poor sanitation, the opposite of clean disposal.")]),

 ("WW","Why should people never defecate in the open?",
   "it pollutes the soil and water and spreads disease",
   C("Open defecation lets germs reach the soil and water supply, spreading illness in the community.")+
   steps("Open waste is full of germs","Rain washes it into soil and water","this pollution spreads disease — so it must be avoided."),
   [("it helps plants grow faster","Raw human waste spreads disease; it is not a safe fertiliser in the open."),
    ("it cleans the surroundings","Open defecation dirties surroundings; it does not clean them."),
    ("it makes water safe to drink","It pollutes water with germs; it does not make it safe.")]),

 ("WW","Treated water released back into a river is good because it:",
   "lowers the pollution of natural water bodies",
   C("Because contaminants have been removed, treated water adds far less pollution to the river.")+
   steps("Treatment removes most contaminants","The released water is much cleaner","so it pollutes the river far less."),
   [("kills the fish in the river","Treated water is cleaner and safer for the river life, not deadly."),
    ("makes the river overflow at once","Releasing treated water does not by itself flood the river."),
    ("adds more germs to the river","Treatment removes germs, so the released water adds far fewer.")]),

 ("WW","The main aim of treating wastewater is to:",
   "remove pollutants so the water can be safely returned to nature",
   C("Treatment cleans the water by taking out contaminants so it can rejoin rivers or the ground safely.")+
   steps("Wastewater is full of contaminants","Treatment removes them step by step","the cleaned water can be safely released back to nature."),
   [("make the water taste sweet","Treatment removes pollutants; it is not about sweetening the taste."),
    ("colour the water blue","Treatment cleans the water; it does not dye it."),
    ("turn the water into ice","Treatment removes contaminants; freezing is not its purpose.")]),

 ("WW","Manholes are placed at intervals along a sewer line mainly to:",
   "allow workers to clean and check the pipes",
   C("Manholes are access openings where blockages can be cleared and the sewer inspected.")+
   steps("Sewer pipes run underground","They need cleaning and checking","manholes give workers a way in to do this."),
   [("let rainwater into the sewer","Manholes are for access and cleaning, not for letting rain in."),
    ("store clean drinking water","Manholes give access to sewers; they do not store drinking water."),
    ("generate electricity for the city","Manholes are access points, not power generators.")]),

 ("WW","The dirty water entering a treatment plant is called the:",
   "influent",
   C("Influent is the untreated wastewater that flows into the plant to be cleaned.")+
   steps("Wastewater arrives at the plant","It has not yet been cleaned","this incoming dirty water is the influent."),
   [("effluent","Effluent is the treated water leaving the plant, not the dirty water entering."),
    ("sludge","Sludge is the settled solid waste, not the incoming water stream."),
    ("scum","Scum is the floating oily layer, not the incoming wastewater.")]),

 ("WW","The treated water that finally leaves a wastewater treatment plant is called the:",
   "effluent",
   C("Effluent is the cleaned water that flows out of the plant after treatment.")+
   steps("The water is cleaned through the plant","It is now safe to release","this outgoing treated water is the effluent."),
   [("influent","Influent is the dirty water entering the plant, not the treated water leaving."),
    ("sludge","Sludge is the settled solid waste, not the water that leaves."),
    ("grit","Grit is the sand removed early on, not the treated water leaving.")]),

 ("WW","Why is it important to dispose of human waste safely rather than dumping it untreated?",
   "untreated waste contaminates water and soil and causes epidemics",
   C("Untreated waste spreads germs through water and soil, which can trigger outbreaks of disease.")+
   steps("Untreated waste is full of germs","It seeps into water and soil","this can cause whole epidemics — so safe disposal matters."),
   [("untreated waste makes crops grow huge","Raw waste spreads disease; it is not a safe miracle fertiliser."),
    ("untreated waste cleans the rivers","Dumping untreated waste pollutes rivers, not cleans them."),
    ("untreated waste produces fresh oxygen","Decaying waste uses up oxygen in water; it does not make fresh oxygen.")]),
]

# ---------- THE TRIANGLE & ITS PROPERTIES (25) — Maths (many FUSED with Forests) ----------
TR = [
 ("TR","A forester leans a 5 m ladder against a tree so its foot is 3 m from the base of the trunk. By the right-angle (Pythagoras) property, how high up the trunk does the ladder reach?",
   "4 m",
   C("In a right triangle, (height)² = (ladder)² − (foot distance)² = 5² − 3² = 25 − 9 = 16, so height = 4 m.")+
   steps("The trunk, ground and ladder form a right triangle","height² = 5² − 3² = 25 − 9 = 16","height = √16 = 4 m."),
   [("8 m","8 m is just 5 + 3; you must use 5² − 3² = 16, giving 4 m."),
    ("2 m","2 m is 5 − 3; the Pythagoras rule gives √(25 − 9) = 4 m."),
    ("6 m","6 m does not fit; √(5² − 3²) = √16 = 4 m.")]),

 ("TR","If you measure and add up all three corner angles inside any triangle, the total comes to:",
   "180°",
   C("The angle-sum property says the three angles of every triangle add up to 180°.")+
   steps("Take any triangle","Add its three interior angles","the total is always 180°."),
   [("90°","90° is the size of one right angle, not the sum of all three angles."),
    ("360°","360° is the angle sum of a quadrilateral; a triangle's three angles add to 180°."),
    ("270°","The three angles of a triangle add to 180°, not 270°.")]),

 ("TR","A triangle in which all three sides are equal in length is called:",
   "equilateral",
   C("An equilateral triangle has three equal sides (and three equal 60° angles).")+
   steps("Check the three sides","All three are the same length","so the triangle is equilateral."),
   [("isosceles","An isosceles triangle has only two equal sides, not all three."),
    ("scalene","A scalene triangle has all sides of different lengths."),
    ("right-angled","A right-angled triangle is named for its 90° angle, not for equal sides.")]),

 ("TR","An exterior angle of a triangle is equal to the:",
   "sum of the two interior opposite angles",
   C("The exterior-angle property states that an exterior angle equals the two interior angles not next to it.")+
   steps("Extend one side to make an exterior angle","It equals the two far (opposite) interior angles","that is the exterior-angle property."),
   [("sum of all three interior angles","All three add to 180°; the exterior angle equals only the two opposite ones."),
    ("interior angle right next to it","The exterior and its adjacent interior angle add to 180°; the rule uses the two opposite ones."),
    ("difference of the other two angles","The exterior angle is the sum, not the difference, of the two opposite angles.")]),

 ("TR","Two angles of a triangular forest plot measure 50° and 60°. The third angle is:",
   "70°",
   C("The three angles add to 180°, so the third = 180° − (50° + 60°) = 70°.")+
   steps("Angle sum is 180°","50° + 60° = 110°","third angle = 180° − 110° = 70°."),
   [("110°","110° is the sum of the two given angles; the third is 180° − 110° = 70°."),
    ("80°","80° does not fit; 180° − 50° − 60° = 70°."),
    ("90°","90° would need the others to add to 90°, but they add to 110°, so the third is 70°.")]),

 ("TR","A triangle that has one angle exactly equal to 90° is called a:",
   "right-angled triangle",
   C("A right-angled triangle contains one 90° (right) angle.")+
   steps("Look at the angles","One of them is exactly 90°","so it is a right-angled triangle."),
   [("acute-angled triangle","An acute triangle has all angles below 90°, not one equal to 90°."),
    ("obtuse-angled triangle","An obtuse triangle has one angle above 90°, not exactly 90°."),
    ("equilateral triangle","An equilateral triangle has three 60° angles, none of them 90°.")]),

 ("TR","A triangle with exactly two equal sides is called:",
   "isosceles",
   C("An isosceles triangle has two equal sides and the two base angles equal.")+
   steps("Measure the three sides","Exactly two are equal","so the triangle is isosceles."),
   [("equilateral","An equilateral triangle has all three sides equal, not just two."),
    ("scalene","A scalene triangle has no two sides equal."),
    ("right-angled","A right-angled triangle is named for a 90° angle, not for two equal sides.")]),

 ("TR","Inside a triangle, a straight segment drawn from a corner to the exact middle of the side facing it is a:",
   "median",
   C("A median runs from a vertex to the midpoint of the opposite side; a triangle has three of them.")+
   steps("Pick a vertex","Find the midpoint of the side facing it","the segment joining them is a median."),
   [("altitude","An altitude is the perpendicular from a vertex to the opposite side, not to its midpoint."),
    ("base","The base is a side you measure from, not the line to the opposite midpoint."),
    ("hypotenuse","The hypotenuse is the longest side of a right triangle, not a median.")]),

 ("TR","The perpendicular line drawn from a vertex of a triangle to its opposite side is called the:",
   "altitude",
   C("An altitude is the perpendicular (height) from a vertex straight to the opposite side.")+
   steps("From a vertex drop a line to the opposite side","Make it meet the side at a right angle","this perpendicular is the altitude."),
   [("median","A median goes to the midpoint of the opposite side, not perpendicular to it."),
    ("base","The base is the side at the bottom; the perpendicular to it from the top vertex is the altitude."),
    ("hypotenuse","The hypotenuse is a side of a right triangle, not a perpendicular height.")]),

 ("TR","Three trees stand so that two sides of the triangle they make are 6 m and 8 m. For a triangle to be possible, the third side must be less than:",
   "14 m",
   C("By the triangle inequality, any side must be less than the sum of the other two: 6 + 8 = 14 m.")+
   steps("Two sides are 6 m and 8 m","Their sum is 6 + 8 = 14 m","the third side must be less than 14 m."),
   [("2 m","2 m is the difference; the third side must be MORE than 2 m and LESS than 14 m."),
    ("48 m","48 m is 6 × 8; the limit comes from the SUM 6 + 8 = 14 m."),
    ("more than 14 m","The third side must be LESS than the sum 14 m, not more.")]),

 ("TR","The triangle inequality states that the sum of the lengths of any two sides of a triangle is:",
   "greater than the third side",
   C("For a real triangle, any two sides together must be longer than the remaining side.")+
   steps("Pick any two sides of a triangle","Add their lengths","the sum is always greater than the third side."),
   [("equal to the third side","If two sides only equalled the third, the triangle would flatten into a line."),
    ("less than the third side","If the sum were less, the sides could not meet to close the triangle."),
    ("equal to 180°","180° is the angle sum, not a rule about side lengths.")]),

 ("TR","A right-angled triangular warning sign in the forest has its two shorter sides (legs) measuring 9 m and 12 m. Its longest side (hypotenuse) is:",
   "15 m",
   C("By Pythagoras, hypotenuse² = 9² + 12² = 81 + 144 = 225, so hypotenuse = 15 m.")+
   steps("Square the two legs: 9² = 81, 12² = 144","Add them: 81 + 144 = 225","hypotenuse = √225 = 15 m."),
   [("21 m","21 m is 9 + 12; you must use √(9² + 12²) = √225 = 15 m."),
    ("3 m","3 m is 12 − 9; the hypotenuse is √(81 + 144) = 15 m."),
    ("225 m","225 is 9² + 12²; you still take the square root, giving 15 m.")]),

 ("TR","In a right-angled triangle, the side directly opposite the right angle is called the:",
   "hypotenuse",
   C("The hypotenuse lies opposite the 90° angle and is the longest side of a right triangle.")+
   steps("Find the right angle","Look at the side facing it","that longest side is the hypotenuse."),
   [("median","A median joins a vertex to a midpoint; the side opposite the right angle is the hypotenuse."),
    ("altitude","An altitude is a perpendicular height, not the side opposite the right angle."),
    ("base","The base is any chosen bottom side; the side opposite the 90° angle is the hypotenuse.")]),

 ("TR","Each interior angle of an equilateral triangle measures:",
   "60°",
   C("All three angles are equal and add to 180°, so each is 180° ÷ 3 = 60°.")+
   steps("The three angles are equal","They add to 180°","each = 180° ÷ 3 = 60°."),
   [("90°","90° angles would add to more than 180° for three of them; each is 60°."),
    ("45°","Three 45° angles add to only 135°; each angle of an equilateral triangle is 60°."),
    ("180°","180° is the total of all three angles, not the size of one.")]),

 ("TR","In an isosceles triangle, the two angles opposite the two equal sides are:",
   "equal to each other",
   C("The base-angles property says the angles facing the two equal sides are equal.")+
   steps("Two sides are equal","The angles opposite those sides face equal sides","so those two angles are equal."),
   [("always 90° each","Two 90° angles would already total 180°, leaving nothing for the third; they are simply equal."),
    ("always different sizes","Equal sides force equal opposite angles, so they are the same, not different."),
    ("each equal to 60°","60° angles belong to an equilateral triangle; isosceles base angles are just equal to each other.")]),

 ("TR","A triangular leaf has a base of 10 cm and a height of 6 cm. Its area is:",
   "30 cm²",
   C("Area of a triangle = ½ × base × height = ½ × 10 × 6 = 30 cm².")+
   steps("Use area = ½ × base × height","= ½ × 10 × 6","= ½ × 60 = 30 cm²."),
   [("60 cm²","60 cm² forgets the ½; the area is ½ × 10 × 6 = 30 cm²."),
    ("16 cm²","16 cm² adds 10 + 6; the area uses ½ × 10 × 6 = 30 cm²."),
    ("32 cm²","32 cm² does not fit; ½ × 10 × 6 = 30 cm².")]),

 ("TR","A triangle in which all three angles are less than 90° is called an:",
   "acute-angled triangle",
   C("An acute-angled triangle has every angle smaller than 90°.")+
   steps("Check all three angles","Each one is below 90°","so it is an acute-angled triangle."),
   [("obtuse-angled triangle","An obtuse triangle has one angle greater than 90°."),
    ("right-angled triangle","A right-angled triangle has one angle exactly equal to 90°."),
    ("straight-angled triangle","There is no such thing; with all angles under 90° it is acute-angled.")]),

 ("TR","When one of the corner angles inside a triangle is bigger than a right angle, the triangle is called an:",
   "obtuse-angled triangle",
   C("An obtuse-angled triangle contains one angle larger than 90° (an obtuse angle).")+
   steps("Look at the angles","One of them is bigger than 90°","so it is an obtuse-angled triangle."),
   [("acute-angled triangle","An acute triangle has all angles below 90°, not one above."),
    ("right-angled triangle","A right-angled triangle has one angle exactly 90°, not more."),
    ("equilateral triangle","An equilateral triangle has three 60° angles, all below 90°.")]),

 ("TR","Two tree-trunks lean so that the gap between them is a right-angled triangle. One acute angle is 35°. The other acute angle is:",
   "55°",
   C("The two acute angles of a right triangle add to 90°, so the other = 90° − 35° = 55°.")+
   steps("The right angle is 90°","The three angles add to 180°, so the two acute ones add to 90°","other acute angle = 90° − 35° = 55°."),
   [("65°","65° does not fit; the two acute angles add to 90°, so it is 90° − 35° = 55°."),
    ("145°","145° is more than the whole 90° share of the acute angles; the answer is 55°."),
    ("45°","45° would need the first acute angle to be 45° too; here it is 90° − 35° = 55°.")]),

 ("TR","A scalene triangle is one in which:",
   "all three sides are of different lengths",
   C("A scalene triangle has no two sides equal — every side is a different length.")+
   steps("Measure the three sides","No two are the same","so the triangle is scalene."),
   [("all three sides are equal","Three equal sides make an equilateral, not a scalene, triangle."),
    ("exactly two sides are equal","Two equal sides make an isosceles triangle; scalene has all sides different."),
    ("all three angles are 60°","Three 60° angles describe an equilateral triangle, not a scalene one.")]),

 ("TR","An equilateral triangular garden has a perimeter of 18 m. The length of each side is:",
   "6 m",
   C("All three sides are equal, so each side = perimeter ÷ 3 = 18 ÷ 3 = 6 m.")+
   steps("Equilateral means three equal sides","Each side = 18 ÷ 3","= 6 m."),
   [("9 m","9 m would be 18 ÷ 2; a triangle has three sides, so each is 18 ÷ 3 = 6 m."),
    ("3 m","3 m is too small; 18 ÷ 3 = 6 m."),
    ("54 m","54 m is 18 × 3; to find one side you divide, giving 6 m.")]),

 ("TR","Counting one from each corner to the midpoint of the opposite side, the total number of medians in a triangle is:",
   "3",
   C("A triangle has three vertices, and each gives one median, so there are three medians.")+
   steps("Each vertex has an opposite side with a midpoint","One median joins each vertex to that midpoint","three vertices give 3 medians."),
   [("1","Only counting one vertex gives one median; all three vertices give 3."),
    ("2","Two vertices give two medians; the third vertex adds one more, making 3."),
    ("6","A triangle has 3 vertices, so 3 medians, not 6.")]),

 ("TR","A vertical forest watch-pole is 12 m tall. A support wire runs from the top of the pole to a peg in the ground 5 m from its foot. The length of the wire is:",
   "13 m",
   C("By Pythagoras, wire² = 12² + 5² = 144 + 25 = 169, so wire = 13 m.")+
   steps("The pole, ground and wire form a right triangle","wire² = 12² + 5² = 144 + 25 = 169","wire = √169 = 13 m."),
   [("17 m","17 m is 12 + 5; the wire is √(12² + 5²) = √169 = 13 m."),
    ("7 m","7 m is 12 − 5; the wire length is √(144 + 25) = 13 m."),
    ("169 m","169 is 12² + 5²; you must take the square root, giving 13 m.")]),

 ("TR","Is it possible to draw a single triangle that contains two right angles inside it?",
   "No, because the three angles would then add up to more than 180°",
   C("Two right angles already total 180°, leaving nothing for the third angle, so it is impossible.")+
   steps("Two right angles = 90° + 90° = 180°","The three angles must total exactly 180°","that leaves 0° for the third — impossible, so no."),
   [("Yes, every triangle has two right angles","Most triangles have none; two right angles are impossible."),
    ("Yes, but only if it is isosceles","No isosceles triangle can have two right angles either; it always exceeds 180°."),
    ("Yes, if the triangle is very large","Size does not matter; two right angles always overshoot 180°.")]),

 ("TR","In triangle ABC, angle A = 90° and angle B = 45°. The measure of angle C is:",
   "45°",
   C("The angles add to 180°, so angle C = 180° − 90° − 45° = 45°.")+
   steps("Angle sum is 180°","90° + 45° = 135°","angle C = 180° − 135° = 45°."),
   [("90°","Two 90° angles would total 180° with nothing left; angle C is 180° − 135° = 45°."),
    ("135°","135° is the sum of A and B; the remaining angle C is 180° − 135° = 45°."),
    ("35°","35° does not fit; 180° − 90° − 45° = 45°.")]),
]

# ---------- EXPONENTS & POWERS (25) — Maths (many FUSED with Wastewater) ----------
EX = [
 ("EX","One bacterium in untreated sewage doubles every hour: 1 → 2 → 4 → 8 … After 5 hours the number is 2⁵, which equals:",
   "32",
   C("2⁵ means 2 multiplied by itself 5 times: 2 × 2 × 2 × 2 × 2 = 32.")+
   steps("Doubling 5 times means 2⁵","2 × 2 × 2 × 2 × 2","= 32 bacteria."),
   [("10","10 is just 2 × 5; powers mean repeated multiplication, so 2⁵ = 32."),
    ("25","25 is 5²; the doubling gives 2⁵ = 32, not 5²."),
    ("16","16 is 2⁴ (4 hours); after 5 hours it is 2⁵ = 32.")]),

 ("EX","The value of 3⁴ is:",
   "81",
   C("3⁴ means 3 × 3 × 3 × 3 = 81.")+
   steps("Multiply 3 by itself 4 times","3 × 3 = 9, 9 × 3 = 27","27 × 3 = 81."),
   [("12","12 is 3 × 4; the power means 3 × 3 × 3 × 3 = 81."),
    ("64","64 is 4³ or 2⁶; 3⁴ = 81."),
    ("27","27 is 3³; one more factor of 3 gives 3⁴ = 81.")]),

 ("EX","In the expression 5³, the number 3 is called the:",
   "exponent (power)",
   C("In 5³, the small raised number 3 is the exponent, telling how many times the base is multiplied.")+
   steps("Write 5³ = 5 × 5 × 5","The raised 3 says 'use 5 three times'","so 3 is the exponent or power."),
   [("base","The base is the number being multiplied — here that is 5, not 3."),
    ("product","The product is the answer (125); 3 is the exponent."),
    ("root","A root is the reverse of a power; the raised number 3 is the exponent.")]),

 ("EX","Using the laws of exponents, aᵐ × aⁿ equals:",
   "a^(m+n)",
   C("When multiplying powers with the same base, you keep the base and ADD the exponents.")+
   steps("Same base a is multiplied","Add the exponents m and n","so aᵐ × aⁿ = a^(m+n)."),
   [("a^(m−n)","Subtracting exponents is the rule for division, not multiplication."),
    ("a^(m×n)","Multiplying the exponents is the rule for (aᵐ)ⁿ, not for aᵐ × aⁿ."),
    ("a^(m/n)","Dividing exponents is not a power law; multiplying powers adds the exponents.")]),

 ("EX","Using the laws of exponents, aᵐ ÷ aⁿ (with a ≠ 0) equals:",
   "a^(m−n)",
   C("When dividing powers with the same base, you keep the base and SUBTRACT the exponents.")+
   steps("Same base a is divided","Subtract the exponent n from m","so aᵐ ÷ aⁿ = a^(m−n)."),
   [("a^(m+n)","Adding exponents is the rule for multiplication, not division."),
    ("a^(m×n)","Multiplying exponents is the rule for a power of a power, not division."),
    ("a^(n−m)","You subtract the bottom exponent from the top: m − n, not n − m.")]),

 ("EX","Using the laws of exponents, (aᵐ)ⁿ equals:",
   "a^(m×n)",
   C("A power raised to another power multiplies the exponents.")+
   steps("(aᵐ)ⁿ means aᵐ used n times","Adding m, n times gives m × n","so (aᵐ)ⁿ = a^(m×n)."),
   [("a^(m+n)","Adding exponents is for multiplying powers, not for a power of a power."),
    ("a^(m−n)","Subtracting exponents is for division, not for a power of a power."),
    ("a","A power of a power is a^(m×n), not just a.")]),

 ("EX","If you take a number that is not zero and raise it to the power zero, you always get:",
   "1",
   C("By the rules of exponents, anything (except 0) to the power 0 equals 1.")+
   steps("Note aⁿ ÷ aⁿ = 1","But by the law it is also a^(n−n) = a⁰","so a⁰ = 1."),
   [("0","a⁰ equals 1, not 0, for any non-zero a."),
    ("the number itself","a¹ equals the number itself; a⁰ equals 1."),
    ("infinity","a⁰ is a fixed value of 1, not infinity.")]),

 ("EX","A treatment plant cleans 10⁶ litres of water a day. Written out in full, 10⁶ litres is:",
   "10,00,000 litres (ten lakh)",
   C("10⁶ means 1 followed by 6 zeros, which is 10,00,000 — ten lakh.")+
   steps("10⁶ = 1 with 6 zeros","Write 10,00,000","that is ten lakh litres."),
   [("1,00,000 litres","1,00,000 is 10⁵ (5 zeros); 10⁶ has 6 zeros = 10,00,000."),
    ("1,00,00,000 litres","1,00,00,000 is 10⁷ (7 zeros); 10⁶ has 6 zeros = 10,00,000."),
    ("60 litres","10⁶ is not 10 × 6; it is 1 with 6 zeros = 10,00,000.")]),

 ("EX","The standard (scientific) form of 47000 is:",
   "4.7 × 10⁴",
   C("In standard form the first factor is between 1 and 10, and the power of ten counts the places the point moves.")+
   steps("Move the decimal after the first digit: 4.7","The point moved 4 places","so 47000 = 4.7 × 10⁴."),
   [("47 × 10³","The first factor must be between 1 and 10; 47 is too big, so use 4.7 × 10⁴."),
    ("4.7 × 10³","10³ is only 4700; 47000 needs 10⁴, giving 4.7 × 10⁴."),
    ("0.47 × 10⁵","The first factor must be at least 1; 0.47 is too small, so use 4.7 × 10⁴.")]),

 ("EX","10⁵ ÷ 10² equals:",
   "10³",
   C("Dividing powers of the same base subtracts the exponents: 10^(5−2) = 10³ = 1000.")+
   steps("Same base 10 is divided","Subtract exponents: 5 − 2 = 3","so 10⁵ ÷ 10² = 10³ = 1000."),
   [("10⁷","Adding exponents (5 + 2) is for multiplication; division subtracts, giving 10³."),
    ("10¹⁰","Multiplying exponents (5 × 2) is for a power of a power; division gives 10³."),
    ("10²","You subtract 5 − 2 = 3, not the other way; the answer is 10³.")]),

 ("EX","2³ × 2² equals:",
   "2⁵",
   C("Multiplying powers of the same base adds the exponents: 2^(3+2) = 2⁵ = 32.")+
   steps("Same base 2 is multiplied","Add exponents: 3 + 2 = 5","so 2³ × 2² = 2⁵ = 32."),
   [("2⁶","2⁶ would need exponents 3 + 3; here 3 + 2 = 5, so 2⁵."),
    ("4⁵","The base stays 2, not 4, when you multiply; the answer is 2⁵."),
    ("2¹","You add the exponents (3 + 2 = 5); the result is 2⁵, not 2¹.")]),

 ("EX","Harmful bacteria in a polluted pond multiply 10 times each day. After 3 days one bacterium becomes 10³, which equals:",
   "1000",
   C("10³ means 10 × 10 × 10 = 1000.")+
   steps("Multiplying by 10 three times means 10³","10 × 10 × 10","= 1000 bacteria."),
   [("30","30 is 10 × 3; the power means 10 × 10 × 10 = 1000."),
    ("100","100 is 10² (2 days); after 3 days it is 10³ = 1000."),
    ("300","300 is not a power of ten here; 10³ = 1000.")]),

 ("EX","The value of (−1) raised to any odd power, such as (−1)⁷, is:",
   "−1",
   C("An odd number of negative factors leaves the product negative, so (−1)^odd = −1.")+
   steps("Each factor is −1","An odd count of them keeps one negative left over","so the result is −1."),
   [("1","An even power of −1 gives 1; an odd power gives −1."),
    ("0","Multiplying −1's never gives 0; an odd power gives −1."),
    ("7","The exponent 7 is not the answer; (−1)⁷ = −1.")]),

 ("EX","The value of (−1) raised to any even power, such as (−1)⁸, is:",
   "1",
   C("An even number of negative factors pair up to give a positive product, so (−1)^even = 1.")+
   steps("Each factor is −1","An even count pairs them into positive products","so the result is 1."),
   [("−1","An odd power of −1 gives −1; an even power gives 1."),
    ("0","Multiplying −1's never gives 0; an even power gives 1."),
    ("8","The exponent 8 is not the answer; (−1)⁸ = 1.")]),

 ("EX","Which is greater, 2⁵ or 5²?",
   "2⁵ is greater",
   C("2⁵ = 32 while 5² = 25, so 2⁵ is the larger.")+
   steps("2⁵ = 32","5² = 25","32 > 25, so 2⁵ is greater."),
   [("5² is greater","5² = 25 is smaller than 2⁵ = 32, so 5² is not greater."),
    ("they are equal","2⁵ = 32 and 5² = 25 are not equal."),
    ("they cannot be compared","Both have clear values (32 and 25), so they can be compared.")]),

 ("EX","A wastewater plant processes 5 × 10⁵ litres in the morning and another 5 × 10⁵ litres in the evening. The total processed is:",
   "10⁶ litres",
   C("5 × 10⁵ + 5 × 10⁵ = 10 × 10⁵ = 10⁶ litres.")+
   steps("Add like terms: 5 × 10⁵ + 5 × 10⁵","= 10 × 10⁵","= 10⁶ litres."),
   [("25 × 10¹⁰ litres","You add the two amounts, not multiply them; the total is 10⁶ litres."),
    ("10⁵ litres","Two lots of 5 × 10⁵ make 10 × 10⁵ = 10⁶, not 10⁵."),
    ("5 × 10¹⁰ litres","Adding does not change the power like that; 5 × 10⁵ + 5 × 10⁵ = 10⁶.")]),

 ("EX","The number 100000000 (a 1 followed by eight zeros) written as a power of ten is:",
   "10⁸",
   C("The power of ten equals the number of zeros after the 1, so eight zeros means 10⁸.")+
   steps("Count the zeros after the 1","There are 8 of them","so the number is 10⁸."),
   [("10⁷","10⁷ has only 7 zeros; eight zeros make 10⁸."),
    ("10⁹","10⁹ has 9 zeros; eight zeros make 10⁸."),
    ("8¹⁰","The base is 10 (we count tens), not 8; the answer is 10⁸.")]),

 ("EX","Expressed as a power of 2, the number 1024 is:",
   "2¹⁰",
   C("Doubling from 1 ten times reaches 1024, so 1024 = 2¹⁰.")+
   steps("2² = 4, 2⁵ = 32, 2⁸ = 256","2⁹ = 512, and 512 × 2 = 1024","so 1024 = 2¹⁰."),
   [("2⁹","2⁹ = 512, which is half of 1024; one more doubling gives 2¹⁰."),
    ("2¹²","2¹² = 4096, which is far more than 1024; 1024 = 2¹⁰."),
    ("10²","10² = 100, not 1024; the power of two is 2¹⁰.")]),

 ("EX","The value of (2³)² is:",
   "64",
   C("(2³)² multiplies the exponents: 2^(3×2) = 2⁶ = 64.")+
   steps("Power of a power multiplies exponents","2^(3×2) = 2⁶","= 64."),
   [("32","32 is 2⁵; (2³)² = 2⁶ = 64."),
    ("12","12 is 2³ × 2 wrongly added; (2³)² = 2⁶ = 64."),
    ("256","256 is 2⁸; (2³)² multiplies 3 × 2 = 6, giving 2⁶ = 64.")]),

 ("EX","The value of 7² + 3³ is:",
   "76",
   C("Work out each power first, then add: 7² = 49, 3³ = 27, and 49 + 27 = 76.")+
   steps("7² = 49","3³ = 27","49 + 27 = 76."),
   [("58","58 wrongly uses 7² = 49 and 3³ = 9; but 3³ = 27, giving 76."),
    ("100","100 would need both powers to add to 100; 49 + 27 = 76."),
    ("70","70 misadds the powers; 49 + 27 = 76.")]),

 ("EX","Which of these is equal to 1?",
   "9⁰",
   C("Any non-zero number to the power 0 equals 1, so 9⁰ = 1.")+
   steps("The zero-power rule: a⁰ = 1 for a ≠ 0","Here a = 9","so 9⁰ = 1."),
   [("5⁰ = 5","5⁰ is 1, not 5; any non-zero number to the power 0 is 1."),
    ("0² = 2","0² = 0, not 2; the value equal to 1 is 9⁰."),
    ("3¹ = 1","3¹ = 3, not 1; the value equal to 1 is 9⁰.")]),

 ("EX","Bacteria in dirty water double every hour. Starting from 1, how many hours does it take to reach 64 bacteria? (64 = 2⁶)",
   "6 hours",
   C("Since 64 = 2⁶, six doublings are needed, so it takes 6 hours.")+
   steps("Each hour the count doubles (×2)","64 = 2⁶ means six doublings","so it takes 6 hours."),
   [("64 hours","64 is the final count, not the time; 64 = 2⁶ takes 6 hours."),
    ("32 hours","32 is 2⁵, the count after 5 hours; reaching 64 = 2⁶ takes 6 hours."),
    ("8 hours","8 = 2³ is the count after 3 hours; reaching 64 = 2⁶ takes 6 hours.")]),

 ("EX","Written in standard (scientific) form, 6,40,000 is:",
   "6.4 × 10⁵",
   C("Place the decimal after the first digit (6.4) and count the places it moved (5) for the power of ten.")+
   steps("6,40,000 → 6.4 after the decimal point","The point moved 5 places","so it is 6.4 × 10⁵."),
   [("64 × 10⁴","The first factor must be between 1 and 10; 64 is too big, so use 6.4 × 10⁵."),
    ("6.4 × 10⁴","10⁴ gives only 64,000; 6,40,000 needs 10⁵, so 6.4 × 10⁵."),
    ("0.64 × 10⁶","The first factor must be at least 1; 0.64 is too small, so use 6.4 × 10⁵.")]),

 ("EX","3² × 3² × 3² equals:",
   "3⁶",
   C("Multiplying powers of the same base adds the exponents: 2 + 2 + 2 = 6, so 3⁶ = 729.")+
   steps("Same base 3 multiplied three times","Add exponents: 2 + 2 + 2 = 6","so the answer is 3⁶ = 729."),
   [("3⁸","3⁸ would need exponents adding to 8; here 2 + 2 + 2 = 6, so 3⁶."),
    ("9⁶","The base stays 3, not 9, when you multiply; the answer is 3⁶."),
    ("3⁵","The exponents add to 6, not 5; the answer is 3⁶.")]),

 ("EX","A village of 10³ people each produces about 10² litres of wastewater a day. The total daily wastewater is 10³ × 10² =",
   "10⁵ litres",
   C("Multiplying powers of ten adds the exponents: 10³ × 10² = 10^(3+2) = 10⁵.")+
   steps("Same base 10 multiplied","Add the exponents: 3 + 2 = 5","so 10³ × 10² = 10⁵ litres."),
   [("10⁶ litres","10⁶ would need exponents 3 + 3; here 3 + 2 = 5, giving 10⁵."),
    ("10¹ litres","You add the exponents (3 + 2 = 5); the total is 10⁵, not 10¹."),
    ("10²³ litres","You add the exponents 3 + 2 = 5, not write them side by side; the total is 10⁵.")]),
]

# ---------- real-life use-case for every item (the "Where you meet it" box) ----------
FO_UC = [
 "On a hot afternoon the air under a leafy banyan feels cooler and fresher, because the tree is taking in carbon dioxide and giving out oxygen.",
 "The dark crumbly soil under a heap of old leaves in a garden is quietly made by decomposers breaking those leaves down.",
 "Walking through a dense forest at noon it stays dim and shady because the canopy overhead blocks most of the sunlight.",
 "A lone neem tree in a field spreads a wide leafy crown that shades the people resting under it.",
 "Gardeners mix dark humus-rich soil into their pots because it holds water and feeds the plants.",
 "Villages below forested hills flood far less than villages below bare hills, because the forest soaks up the rain.",
 "A patch of forest left untouched for years still keeps changing, as old trees fall and new saplings rise in their place.",
 "Every animal in a jungle, from deer to tiger, ultimately lives off the green producer plants that begin the food chain.",
 "Cities that have cleared their trees often feel hotter and choke on more polluted, carbon-dioxide-rich air.",
 "Wells and springs near a forest stay full right through summer because the trees keep recharging the groundwater.",
 "A farmer who lets crop stubble rot back into the field is using microbes to return nutrients to the soil.",
 "Packing for a forest trek you can carry forest-grown gum, paper and herbal medicine, but the plastic bottle is factory-made.",
 "Many medicinal herbs and shrubs are gathered from the shady understorey that grows below the tall trees.",
 "A mango seedling sprouting far from any mango tree was probably carried there inside a fruit eaten by a bird or monkey.",
 "On a grassy tree-covered slope the soil stays put in heavy rain, while a bare slope washes away into gullies.",
 "Forest-floor soil is so dark and fertile that nurseries prize it for raising healthy young plants.",
 "A plantation can supply paper year after year only because new trees are planted to replace the ones that are cut.",
 "Sitting in a city park on a summer day feels noticeably cooler and more humid than standing on the open road nearby.",
 "In a wildlife park the spotted deer grazing on grass is the herbivore that the tigers will later hunt.",
 "A pond, a forest or a coral reef is each called an ecosystem because its living things and surroundings all depend on one another.",
 "Regions that lose their forests often see their yearly rainfall slowly drop, because there are fewer trees to release water vapour.",
 "The springy brown blanket of fallen leaves you walk on in a forest is the litter that will slowly rot into humus.",
 "Roadside trees in a busy city help by soaking up carbon dioxide and catching dust on their leaves, cleaning the air a little.",
 "When a hillside forest is cleared for timber, the animals that lived there lose their homes and the air loses a carbon-dioxide sponge.",
 "In a real jungle a tiger eats deer and wild boar, and those eat several plants, so the chains cross into a tangled food web.",
]
WW_UC = [
 "The soapy, dirty water that runs out after you wash dishes or bathe is the wastewater that flows into the drain.",
 "The hidden network of pipes under a city street that carries away everyone's used water is the sewerage system.",
 "A water-testing kit shows a sample is unsafe by detecting the contaminants — germs and chemicals — dissolved in it.",
 "Before the water from your town's drains can rejoin a river, it is cleaned at a wastewater treatment plant.",
 "At a treatment plant the first thing you see is sewage flowing through bar screens that catch rags, sticks and plastic.",
 "Just after the screens, heavy sand and grit washed off the roads settle out in the grit-removal tank.",
 "When a settling tank is emptied, the thick muck scraped from the bottom is the sludge.",
 "The greasy film skimmed off the top of a settling tank, just like the scum on top of cooling dal, is removed and treated.",
 "The bubbling, frothy aeration tank at a treatment plant is where helpful bacteria feast on the leftover waste.",
 "Operators measure the settled brown mass of bacteria, the activated sludge, to check the plant is cleaning well.",
 "Just as a swimming pool is dosed with chlorine to kill germs, treated water is chlorinated before it is released.",
 "Farmers near a treatment plant collect the dried sludge to spread on their fields as nutrient-rich manure.",
 "A kitchen sink that keeps getting blocked is often choked by old cooking oil that hardened inside the pipe.",
 "A house in a village with no sewer line sends its toilet waste into an underground septic tank in the yard.",
 "Tipping leftover cooking oil and tea leaves down the sink is what slowly clogs a home's drainpipes.",
 "Towns that dump raw sewage into a river often suffer outbreaks of cholera and typhoid downstream.",
 "During a flood, drinking water mixed with sewage is what spreads cholera, typhoid and dysentery through a neighbourhood.",
 "Building clean toilets and keeping streets free of waste is what we mean by good sanitation in a village.",
 "Campaigns to build household toilets exist because open defecation pollutes the soil and water and spreads disease.",
 "The cleaner water a treatment plant releases means the river it flows into stays far less polluted.",
 "The whole reason a city runs a treatment plant is to strip out the pollutants so the water can safely return to nature.",
 "The round metal covers you see set into a road are manholes, opened so workers can clean and check the sewer below.",
 "The dirty water arriving at the gate of a treatment plant, before any cleaning, is the influent.",
 "The clean stream of water leaving a treatment plant on its way to the river is the effluent.",
 "Safe disposal of human waste matters because untreated waste seeping into wells can trigger a whole epidemic.",
]
TR_UC = [
 "A painter leaning a ladder against a wall uses this same right-angle rule to work out how high it will reach.",
 "A carpenter checking a triangular bracket knows its three corners must always add up to a straight 180°.",
 "The three equal sides of a traffic 'give way' sign make it an equilateral triangle.",
 "A surveyor extends one side of a triangular plot and uses the exterior-angle rule to find a missing corner angle.",
 "Knowing two corners of a triangular garden bed lets a gardener work out the third without measuring it.",
 "A set square in your geometry box is a right-angled triangle, with one perfect 90° corner.",
 "The two equal sloping sides of many roof trusses make them isosceles triangles.",
 "An engineer balancing a triangular plate finds its balance point along the medians drawn to the midpoints of the sides.",
 "The straight 'height' line a builder drops from the apex of a gable to its base is an altitude.",
 "Before buying fencing, a farmer checks that two sides of a triangular plot really can be joined by the third.",
 "Carpenters rely on the rule that any two sides of a triangular frame together must beat the third, or the pieces won't meet.",
 "A builder squaring a 9-by-12 corner knows the diagonal brace must be exactly 15 units long.",
 "On a ramp shaped like a right triangle, the long sloping top surface you walk up is the hypotenuse.",
 "Each corner of a perfectly triangular samosa or 'give way' sign measures 60°.",
 "A kite with two equal sides has equal angles at its base, which is why it flies straight.",
 "A gardener finds the cloth needed for a triangular flag using half its base times its height.",
 "A triangular sail with all corners sharp and under a right angle is an acute-angled triangle.",
 "A wide, flat triangular pizza slice with one blunt corner over 90° is an obtuse-angled triangle.",
 "A ramp builder who fixes one acute angle of a right-angled support instantly knows the other is what is left of 90°.",
 "A triangular plot with three differently sized sides, like many real fields, is a scalene triangle.",
 "Knowing a triangular park's fence is 18 m long, the gardener divides by three to mark out each equal side.",
 "When balancing a triangular tray, all three medians from the corners meet at its single balance point.",
 "A flagpole's slanting support wire to a ground peg forms a right triangle, and Pythagoras gives its length.",
 "A builder knows a triangular window can never have two square corners, because that already uses up all 180°.",
 "In a right-angled set square with a 45° corner, the remaining corner is also 45°.",
]
EX_UC = [
 "Bacteria in spoiled food double again and again, so a tiny start becomes a huge number in just a few hours, like 2⁵ = 32.",
 "Powers crop up whenever something grows by repeated multiplying, such as 3⁴ stacks of 3 boxes.",
 "When a scientist writes 5³ for a measurement, the small raised 3 is the exponent telling how many times to multiply.",
 "Engineers add the exponents to combine quantities like 10³ metres × 10² (so aᵐ × aⁿ = a^(m+n)).",
 "Comparing two big quantities written as powers of ten, you simply subtract the exponents to divide them.",
 "Working out a volume as a power raised to a power, like (10²)³, you multiply the exponents.",
 "On a calculator, anything (except 0) to the power 0 shows 1 — a handy check when simplifying formulas.",
 "A treatment plant's daily flow of 10⁶ litres is easier to say as 'ten lakh litres' once you expand the power.",
 "Scientists write huge or tiny measurements like 47000 compactly as 4.7 × 10⁴ in standard form.",
 "Dividing a population of 10⁵ by 10² groups is done in your head by subtracting exponents to get 10³.",
 "Doubling a 2³-litre tank twice more is found by adding exponents: 2³ × 2² = 2⁵ litres.",
 "Germs that multiply tenfold each day reach 10³ = 1000 in just three days from a single cell.",
 "An odd number of minus signs multiplied together stays negative, which is why (−1) to an odd power is −1.",
 "An even number of minus signs cancels in pairs, so (−1) to an even power comes back to +1.",
 "Comparing 2⁵ and 5² shows that which number is on top of the power matters: 32 beats 25.",
 "Adding a plant's morning and evening flows, 5 × 10⁵ + 5 × 10⁵, neatly rolls up to 10⁶ litres.",
 "A 1 followed by eight zeros, like a country's huge population, is written compactly as 10⁸.",
 "Computer memory sizes are powers of two, which is why 1024 bytes (a kilobyte) is exactly 2¹⁰.",
 "Cubing then squaring a length, as in (2³)², is solved fast by multiplying the exponents to get 64.",
 "Adding the areas of a 7-square and a 3-cube tile, 7² + 3³, means working each power first to reach 76.",
 "Spotting that any non-zero base to the power 0 equals 1 lets you cancel such terms instantly, as with 9⁰.",
 "If germs double hourly, reaching 64 (which is 2⁶) tells you exactly six hours have passed.",
 "A reading of 6,40,000 is written in tidy standard form as 6.4 × 10⁵ on a lab report.",
 "Multiplying three equal powers, 3² × 3² × 3², is just adding the exponents to get 3⁶ = 729.",
 "Estimating a town's daily sewage as 10³ people × 10² litres each gives 10⁵ litres by adding exponents.",
]


def _with_uc(lst, ucs):
    assert len(lst) == len(ucs) == 25
    out = []
    for it, uc in zip(lst, ucs):
        code, stem, correct, html, distr = it
        out.append((code, stem, correct, html + U(uc), distr))
    return out


FO = _with_uc(FO, FO_UC)
WW = _with_uc(WW, WW_UC)
TR = _with_uc(TR, TR_UC)
EX = _with_uc(EX, EX_UC)

items = []
for i in range(25):
    items += [FO[i], TR[i], WW[i], EX[i]]
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

    keydist = build_paper(PNUM, TITLE, SHORT, LABELS, items, seed=25733,
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
    split = "/".join(str(counts[c]) for c in ("FO", "WW", "TR", "EX"))
    with open("PAPERS_MANIFEST.md", "a", encoding="utf-8") as fh:
        fh.write(f"| {PNUM} | 2026-06-18 | {TITLE} | {split} | ✓ |\n")

    # ---- update QUESTION_INDEX.json ----
    idx["fingerprints"] = sorted(existing | set(new_fps))
    idx.setdefault("combos", []).append({
        "paper": PNUM,
        "chapters": ["Forests",
                     "Wastewater Story",
                     "The Triangle & its Properties",
                     "Exponents & Powers"],
    })
    idx["papers"] = idx.get("papers", 0) + 1
    with open(idx_path, "w", encoding="utf-8") as fh:
        json.dump(idx, fh, ensure_ascii=False, indent=2)
        fh.write("\n")

    print("Files:", sorted(v for v in moves.values()))
    print("Answer key spread A/B/C/D =", dict(keydist))
    print("Fingerprints added:", len(new_fps))
