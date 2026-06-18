# -*- coding: utf-8 -*-
# Boss Challenge Paper 32 — Soil · Wastewater Story · Comparing Quantities · Algebraic Expressions
# Content-only. Uses the dependency-free examfactory engine.
# Difficulty ramp: this paper leans into FUSION. Several Comparing-Quantities items wear a Science
# coat (the % of clay in a soil sample, the % of water recovered at a treatment plant), and a couple
# of Algebraic-Expressions items build a formula from a Science situation (percolation rate r = w ÷ t,
# the litres in a filling tank after h hours). The child reads a Science context and applies a Maths
# skill. Class-7 scope, simple wording, hard thinking.
# Produces, under Resources/BossChallengePapers/:
#   Paper_32_<SHORT>_QuestionPaper.html  (pure HTML — questions + options)
#   Paper_32_<SHORT>_QuestionPaper.pdf
#   Paper_32_<SHORT>_Questions.md
#   Paper_32_<SHORT>_Solutions.html
import os, sys, shutil, json, re
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from examfactory import build_paper, C, steps, U

PNUM  = "32"
SHORT = "Soil_Wastewater_ComparingQuantities_AlgExpr"
TITLE = ("Soil · Wastewater Story · Comparing Quantities · Algebraic Expressions")
LABELS = {
    "SO": "Soil",
    "WW": "Wastewater Story",
    "CQ": "Comparing Quantities",
    "AE": "Algebraic Expressions",
}

# ---------- SOIL (25) — Science ----------
SO = [
 ("SO","The slow breaking down of rocks into tiny particles, over very long times, to form soil is called:",
   "weathering",
   C("Rocks crack and crumble under sun, water and wind over ages; this rock-breaking process is weathering.")+
   steps("Rocks are exposed to heat, rain and frost","they slowly crack into smaller and smaller bits","this rock-breaking that builds soil is weathering."),
   [("melting","Melting needs great heat to turn rock to liquid; soil forms by slow breaking, not melting."),
    ("flooding","A flood can move soil but does not by itself make rock into soil particles."),
    ("digging","Digging only moves existing soil; it does not create soil from rock.")]),

 ("SO","The dark, crumbly material in soil, made from the decayed remains of plants and animals, is called:",
   "humus",
   C("Decayed once-living matter forms a dark, rich material called humus that makes soil fertile.")+
   steps("Dead leaves and animals rot in the soil","this rotting leaves behind a dark crumbly stuff","that fertile dark matter is humus."),
   [("clay","Clay is a kind of tiny rock particle, not decayed living matter."),
    ("gravel","Gravel is small stones, not the decayed remains of living things."),
    ("sand","Sand is large rock grains, not the dark decayed plant matter.")]),

 ("SO","The set of distinct layers you see when you cut down through the ground is called the:",
   "soil profile",
   C("A vertical slice through the ground shows ordered layers; this arrangement is the soil profile.")+
   steps("Dig a deep pit and look at the side wall","you see bands of different colour and texture","this layered side view is the soil profile."),
   [("water table","The water table is the level below which soil is soaked with water, not the layers themselves."),
    ("food chain","A food chain is about who eats whom, nothing to do with soil layers."),
    ("crop pattern","A crop pattern is what farmers plant, not the layers in the ground.")]),

 ("SO","The topmost, dark layer of soil, richest in humus, where most plants spread their roots, is the:",
   "topsoil",
   C("The uppermost layer holds the most humus and is where most roots grow; it is the topsoil.")+
   steps("Plants need humus and air near the surface","the top layer holds the most of both","so most roots grow in the topsoil."),
   [("bedrock","Bedrock is the solid rock at the very bottom, far below the roots."),
    ("subsoil","Subsoil lies below the topsoil and holds far less humus."),
    ("water table","The water table is a level of soaked soil, not the humus-rich top layer.")]),

 ("SO","Among the three particle types — sand, silt and clay — the LARGEST particles are:",
   "sand",
   C("Sand grains are the biggest of the three; you can even see and feel them separately.")+
   steps("Rub dry soil between your fingers","the grittiest, biggest grains are easy to feel","those biggest grains are sand."),
   [("silt","Silt particles are medium-sized, smaller than sand."),
    ("clay","Clay particles are the smallest of all three, not the largest."),
    ("humus","Humus is decayed matter, not one of the rock-particle sizes.")]),

 ("SO","Among sand, silt and clay, the SMALLEST particles are:",
   "clay",
   C("Clay particles are the tiniest of the three and pack tightly together.")+
   steps("Compare the three particle sizes","sand is biggest, silt is middling","so clay is the smallest.")+"",
   [("sand","Sand grains are the largest, not the smallest, of the three."),
    ("silt","Silt is medium-sized, larger than clay."),
    ("gravel","Gravel is small stones, far larger than clay particles.")]),

 ("SO","A soil through which water passes very quickly and which dries out fast is mostly:",
   "sandy soil",
   C("Large sand grains leave wide gaps, so water rushes through; sandy soil drains and dries fast.")+
   steps("Big sand grains cannot pack tightly","wide air gaps stay between them","so water drains straight through sandy soil."),
   [("clayey soil","Clayey soil holds water and drains slowly, the opposite of this."),
    ("loamy soil","Loamy soil holds a balanced amount of water, not draining super fast."),
    ("frozen soil","Frozen soil is a temperature state, not a particle-based soil type.")]),

 ("SO","A soil that holds a great deal of water and feels sticky when wet is mostly:",
   "clayey soil",
   C("Tiny clay particles pack tightly and trap water, so clayey soil is sticky and water-holding.")+
   steps("Clay particles are very small","they pack tightly with little gap","so water is trapped and the soil feels sticky."),
   [("sandy soil","Sandy soil drains fast and feels gritty, not sticky."),
    ("loamy soil","Loamy soil is a balanced mix, less sticky than pure clay."),
    ("rocky soil","Rocky soil is full of stones, not sticky water-holding clay.")]),

 ("SO","The soil that is best for growing most crops, being a balanced mixture of sand, silt, clay and humus, is:",
   "loamy soil",
   C("Loam balances drainage and water-holding and is rich in humus, making it the best all-round crop soil.")+
   steps("Crops need water held but not waterlogged","a balanced mix does this and has humus","that balanced soil is loam."),
   [("pure sandy soil","Pure sand drains too fast and holds too little water for most crops."),
    ("pure clayey soil","Pure clay holds too much water and gets waterlogged for many crops."),
    ("gravelly soil","Gravel holds almost no water or humus, poor for most crops.")]),

 ("SO","The downward movement of water through soil, measured as the amount that sinks in a given time, is the:",
   "percolation rate",
   C("How fast water soaks downward through soil is its percolation rate.")+
   steps("Pour water on soil in a tube","time how fast it sinks through","that speed of sinking is the percolation rate."),
   [("evaporation rate","Evaporation is water leaving as vapour into the air, not sinking down."),
    ("germination rate","Germination is about seeds sprouting, not water sinking."),
    ("erosion rate","Erosion is topsoil being carried away, not water moving downward.")]),

 ("SO","Sandy soil has a HIGH percolation rate mainly because:",
   "its large particles leave big air gaps for water to pass",
   C("Wide gaps between big sand grains let water flow through quickly, giving a high percolation rate.")+
   steps("Sand grains are large","large grains cannot pack closely","so wide gaps let water race through."),
   [("it contains a lot of humus","Humus content is not why sand drains fast; the big gaps are."),
    ("it has tiny tightly-packed particles","Tiny tight particles describe clay, which drains slowly."),
    ("it is always found near rivers","Where sand is found does not set its percolation rate.")]),

 ("SO","Clayey soil is well suited to a crop like paddy (rice) because clay:",
   "holds water for a long time",
   C("Paddy needs standing water, and water-holding clayey soil keeps the field wet, suiting rice.")+
   steps("Rice grows in flooded fields","the soil must keep water from draining away","clay holds water long, so it suits paddy."),
   [("lets water drain away at once","Fast draining would dry a paddy field; clay does the opposite."),
    ("contains no minerals at all","Clay does carry minerals; that is not the reason here."),
    ("never needs any rain","All crops, including rice, still need water; clay just holds it.")]),

 ("SO","The hard, solid, unbroken rock found at the very bottom of a soil profile is the:",
   "bedrock",
   C("Beneath all the soil layers lies the solid parent rock, the bedrock.")+
   steps("Dig deeper and deeper through the layers","at last you reach unbroken solid rock","that bottom solid rock is the bedrock."),
   [("topsoil","Topsoil is the dark humus-rich layer at the very top, not the bottom rock."),
    ("humus","Humus is decayed matter near the surface, not solid bottom rock."),
    ("subsoil","Subsoil sits above the bedrock and is made of broken particles, not solid rock.")]),

 ("SO","Earthworms are called the farmer's friend mainly because they:",
   "make burrows that let air and water into the soil",
   C("As earthworms tunnel, they loosen the soil and open paths for air and water, helping plants.")+
   steps("Earthworms dig through the soil","their tunnels open up the packed soil","so air and water reach the roots more easily."),
   [("eat all the crop seeds","Earthworms feed on dead matter, not on the farmer's seeds."),
    ("turn clay into pure sand","Earthworms cannot change one particle type into another."),
    ("stop all rain from falling","Earthworms have nothing to do with rainfall.")]),

 ("SO","The carrying away of fertile topsoil by wind or running water is called:",
   "soil erosion",
   C("When wind or water strips off and transports the topsoil, that loss is soil erosion.")+
   steps("Bare soil is exposed to wind and rain","the loose top layer is picked up and carried off","this loss of topsoil is erosion."),
   [("percolation","Percolation is water sinking downward, not topsoil being carried away."),
    ("weathering","Weathering breaks rock into soil; erosion moves the soil away."),
    ("irrigation","Irrigation is supplying water to crops, not losing topsoil.")]),

 ("SO","Planting trees and grass on a bare hillside helps mainly by:",
   "holding the soil with roots and preventing erosion",
   C("Plant roots grip the soil and their cover softens rain, so erosion of the slope is reduced.")+
   steps("Bare slopes lose soil to rain and wind","roots bind the soil grains together","so planting cover prevents the soil washing away."),
   [("making the soil into solid rock","Plants do not turn soil back into solid rock."),
    ("stopping the sun from ever shining","Plants do not block sunshine from the region."),
    ("removing all the humus","Plants add humus to soil; they do not remove it.")]),

 ("SO","The amount of water a soil can keep after the extra has drained away is called its:",
   "water-holding capacity",
   C("How much water a soil retains once the surplus drains off is its water-holding capacity.")+
   steps("Water a sample and let the excess drain","some water still stays behind in the soil","that retained amount is the water-holding capacity."),
   [("percolation rate","Percolation rate is how fast water sinks, not how much is kept."),
    ("boiling point","Boiling point is a temperature; it has nothing to do with soil water."),
    ("particle size","Particle size affects water holding but is not the held amount itself.")]),

 ("SO","Clayey soil has a LOW percolation rate because its tiny particles:",
   "pack tightly together, leaving very little space for water",
   C("Small clay particles pack closely with almost no gaps, so water seeps through only slowly.")+
   steps("Clay particles are very small","small particles pack with tiny gaps","so water can barely squeeze through — low percolation."),
   [("are very large with wide gaps","Large particles with wide gaps describe sand, which drains fast."),
    ("are made of pure humus","Clay particles are tiny rock bits, not humus."),
    ("float away in the wind easily","Floating away is erosion; it is not why clay drains slowly.")]),

 ("SO","Mixing dead leaves and cow dung into a field improves the soil mainly by:",
   "increasing its humus and making it more fertile",
   C("Rotting leaves and dung add humus, enriching the soil and feeding crops.")+
   steps("Dead leaves and dung rot in the soil","rotting adds dark, rich humus","more humus makes the soil more fertile."),
   [("turning the soil into clay","Adding humus does not change the particle type to clay."),
    ("removing all its water","Humus actually helps soil hold water, not lose it."),
    ("making it unfit for any crop","Added humus makes soil better for crops, not unfit.")]),

 ("SO","Arranged from LARGEST to smallest, the three soil particle types are:",
   "sand, silt, clay",
   C("Sand is biggest, silt is medium and clay is smallest — sand, silt, clay.")+
   steps("Recall sand is the largest grain","silt is medium-sized","clay is the smallest, so the order is sand, silt, clay."),
   [("clay, silt, sand","That is smallest-to-largest, the reverse of what is asked."),
    ("silt, sand, clay","Sand is larger than silt, so silt cannot come first."),
    ("clay, sand, silt","This mixes up the order; sand must be first as the largest.")]),

 ("SO","The mixing of harmful materials like plastic and chemicals into the soil is called:",
   "soil pollution",
   C("When wastes such as plastic and chemicals foul the soil, that spoiling is soil pollution.")+
   steps("Plastic and chemicals are dumped on land","they make the soil harmful for plants and animals","this spoiling of the soil is pollution."),
   [("soil erosion","Erosion is topsoil being carried away, not poisoning by chemicals."),
    ("weathering","Weathering is natural rock breaking, not harmful dumping."),
    ("percolation","Percolation is water sinking down, not soil being polluted.")]),

 ("SO","Sandy-loam soil suits cotton well because it:",
   "drains well and warms up quickly",
   C("Cotton dislikes waterlogging; well-draining, quick-warming sandy loam suits its roots.")+
   steps("Cotton roots rot in waterlogged soil","sandy loam lets extra water drain off","and it warms fast, which cotton likes."),
   [("stays flooded all year","Flooding would harm cotton; sandy loam drains instead."),
    ("contains no air at all","Sandy loam is airy; lack of air would hurt the roots."),
    ("never lets any water in","Cotton still needs some water; sandy loam holds enough.")]),

 ("SO","The layer lying just below the topsoil, harder and with much less humus, is the:",
   "subsoil",
   C("Beneath the humus-rich topsoil lies a paler, harder layer with little humus — the subsoil.")+
   steps("Below the dark top layer the soil changes","it becomes paler and harder with less humus","that layer is the subsoil."),
   [("topsoil","Topsoil is the dark humus-rich layer above, not this paler layer."),
    ("bedrock","Bedrock is the solid rock far below the subsoil."),
    ("humus","Humus is decayed matter, not a soil layer name here.")]),

 ("SO","In a percolation test, 200 mL of water sinks through a soil sample in 20 minutes. The percolation rate is:",
   "10 mL per minute",
   C("Percolation rate = amount of water ÷ time taken = 200 mL ÷ 20 min = 10 mL/min.")+
   steps("Write rate = water ÷ time","put in 200 mL ÷ 20 min","work it out: 200 ÷ 20 = 10 mL per minute."),
   [("4000 mL per minute","That multiplies instead of dividing; rate needs water ÷ time."),
    ("20 mL per minute","20 is the time in minutes, not the rate; 200 ÷ 20 = 10."),
    ("100 mL per minute","100 would be 200 ÷ 2; here the time is 20, so the rate is 10.")]),

 ("SO","When wet clay can be rolled into a thin thread without breaking, it shows that clay particles:",
   "stick closely together",
   C("Wet clay rolls into threads because its tiny particles cling tightly to one another.")+
   steps("Wet a little clay and roll it","it forms a smooth unbroken thread","this shows clay particles stick closely together."),
   [("are very far apart","If far apart, the clay would crumble, not roll into a thread."),
    ("are the largest of all soils","Clay particles are the smallest, not the largest."),
    ("cannot hold any water","Clay holds water well, which is why it rolls smoothly.")]),
]

SO_UC = [
 "Knowing rocks weather into soil explains why every farm field began as bare stone long ago.",
 "Spotting humus tells a gardener which dark, crumbly soil will grow the healthiest vegetables.",
 "Reading a soil profile helps a builder judge how deep to dig before reaching firm ground.",
 "Recognising topsoil is why farmers protect the thin top layer that feeds every crop.",
 "Feeling for sand grains is how a potter tests whether a soil is too gritty for clay pots.",
 "Knowing clay is finest explains why it is chosen to line ponds so water does not leak away.",
 "Spotting sandy soil tells a gardener to water more often because it dries out so quickly.",
 "Recognising sticky clayey soil warns a builder it may swell and crack a foundation in the rain.",
 "Choosing loam is what lets a kitchen-garden grow tomatoes, beans and herbs all at once.",
 "Measuring percolation is how an engineer decides if a field will drain after heavy monsoon rain.",
 "Knowing why sand drains fast helps you choose it for the base of a plant pot to stop rot.",
 "Picking water-holding clay for rice is why paddy fields are bunded to keep the water in.",
 "Knowing bedrock lies below is why well-diggers keep going until they hit solid rock.",
 "Valuing earthworms is why organic farmers avoid chemicals that would kill these soil-tillers.",
 "Spotting erosion early is how a village decides where to plant a protective row of trees.",
 "Planting cover on slopes is exactly how hillsides are saved from landslides after rain.",
 "Judging water-holding capacity helps a farmer decide how often a particular field needs watering.",
 "Knowing clay packs tight explains why clayey paths turn to slippery mud instead of draining.",
 "Adding leaf-and-dung compost is the cheapest way a home gardener enriches tired soil.",
 "Ordering sand-silt-clay by size is the first step in naming a soil sample in a lab.",
 "Recognising soil pollution warns a community not to dump plastic where crops will later grow.",
 "Matching cotton to sandy loam is how a farmer picks the right field for the right crop.",
 "Reading the subsoil layer tells a builder where the softer, less stable ground begins.",
 "Doing a percolation sum is what an irrigation planner actually calculates before laying drains.",
 "The clay-thread test is a quick field trick farmers use to identify clayey soil by hand.",
]

# ---------- WASTEWATER STORY (25) — Science ----------
WW = [
 ("WW","Water that has been used by homes, factories and farms, and so made dirty, is called:",
   "wastewater (sewage)",
   C("Used, dirtied water carrying wastes is wastewater, also called sewage.")+
   steps("Water is used for washing, cooking and toilets","it picks up dirt, soap and wastes","this used dirty water is wastewater, or sewage."),
   [("rainwater","Fresh rainwater falling from clouds is clean, not used and dirtied water."),
    ("groundwater","Groundwater stored underground is usually clean, not used wastewater."),
    ("distilled water","Distilled water is specially purified, the opposite of dirty sewage.")]),

 ("WW","The network of underground pipes that carries sewage away from our homes is called the:",
   "sewerage",
   C("The system of pipes that collects and carries sewage away is the sewerage.")+
   steps("Each home's dirty water must go somewhere","pipes underground collect it all","this pipe network is the sewerage."),
   [("pipeline of drinking water","Drinking-water pipes bring clean water in, not carry sewage out."),
    ("electric cable","Electric cables carry current, not sewage."),
    ("canal","A canal is an open channel for irrigation, not the buried sewage pipes.")]),

 ("WW","The special place where dirty water is cleaned before being let out is called a:",
   "wastewater treatment plant",
   C("Sewage is cleaned step by step at a wastewater (sewage) treatment plant before release.")+
   steps("Dirty water cannot go straight into a river","it must be cleaned in stages first","that cleaning station is the treatment plant."),
   [("power plant","A power plant makes electricity, not clean water from sewage."),
    ("water tank","A storage tank only holds water; it does not clean sewage."),
    ("pumping station","A pumping station only pushes water along; it does not treat it.")]),

 ("WW","At a treatment plant, large floating objects like rags, sticks and plastic are first removed by:",
   "bar screens",
   C("Bars set across the flow catch big floating rubbish; these are the bar screens.")+
   steps("Big rags and sticks would clog the machines","metal bars across the flow trap them first","these trapping bars are the bar screens."),
   [("an aerator","An aerator bubbles air much later; it does not catch big rubbish first."),
    ("a settling tank","A settling tank lets fine solids sink; bar screens catch the big stuff first."),
    ("a chimney","A chimney lets out smoke; it has nothing to do with screening sewage.")]),

 ("WW","The tank in which heavy sand, grit and small pebbles settle out of the sewage is the:",
   "grit and sand removal tank",
   C("Slowing the water lets heavy grit and sand sink, in the grit and sand removal tank.")+
   steps("After big rubbish is screened off","the water is slowed so heavy grit sinks","this sinking happens in the grit and sand removal tank."),
   [("aeration tank","The aeration tank bubbles air to grow bacteria, not to settle grit."),
    ("biogas tank","The biogas tank makes gas from sludge, not removes grit."),
    ("overhead tank","An overhead tank stores clean water; it does not remove grit.")]),

 ("WW","In a settling tank, the solid waste that sinks and collects at the bottom is called:",
   "sludge",
   C("The settled solids gathering at the tank bottom are called sludge.")+
   steps("In still water, solids slowly sink","they pile up on the tank floor","this settled solid is the sludge."),
   [("scum","Scum floats on top; it is not the solid that sinks to the bottom."),
    ("biogas","Biogas is a gas made later from sludge, not the settled solid itself."),
    ("clear water","Clear water is what is left above; the sludge is the solid below.")]),

 ("WW","In a settling tank, the oil, grease and other light matter that float on top are skimmed off as:",
   "scum",
   C("Floating oils and light wastes are skimmed from the surface as scum.")+
   steps("Oil and grease are lighter than water","they rise and float on the surface","this floating layer is skimmed off as scum."),
   [("sludge","Sludge is the heavy solid that sinks, not the floating layer."),
    ("manure","Manure is dried treated sludge used on fields, not the floating skim."),
    ("clean water","Clean water is the treated output, not the floating oily layer.")]),

 ("WW","Air is bubbled through the cleared water in the aeration tank mainly to help:",
   "useful aerobic bacteria grow and eat the wastes",
   C("Bubbled air supplies oxygen so helpful aerobic bacteria multiply and consume the wastes.")+
   steps("Helpful bacteria need oxygen to work","bubbling air supplies that oxygen","so the bacteria grow and eat the remaining wastes."),
   [("make the water look fizzy for sale","Aeration is for the bacteria, not to make a fizzy drink."),
    ("freeze the water solid","Bubbling air does not freeze water; it feeds bacteria."),
    ("add colour to the water","Aeration adds oxygen, not colour, to the water.")]),

 ("WW","The bacteria that break down the wastes in the aeration tank are able to work only when there is:",
   "oxygen (air)",
   C("These are aerobic bacteria; they need oxygen from the bubbled air to break down wastes.")+
   steps("The helpful bacteria are aerobic","aerobic means they need oxygen","so the bubbled air supplies the oxygen they need."),
   [("no air at all","Aerobic bacteria need air; without it they cannot do this job."),
    ("bright sunlight","These bacteria work on oxygen, not on sunlight."),
    ("salt water","They need oxygen, not salty water, to break down the wastes.")]),

 ("WW","The cleaned water leaving the treatment plant is usually:",
   "released into a river or sea, or used to water gardens",
   C("Treated water is safe enough to return to a river or sea, or to irrigate gardens and parks.")+
   steps("The water has now been cleaned in stages","it is safe to put back into nature","so it is released to a river or sea, or used for gardens."),
   [("sent straight back to kitchen taps","Treated sewage is not piped to drinking taps; it goes to rivers or gardens."),
    ("buried deep underground forever","Cleaned water is reused or released, not buried away."),
    ("burned in a furnace","Water is not burned; the cleaned water is released or reused.")]),

 ("WW","The settled sludge is moved to a closed tank where bacteria break it down and produce a useful fuel gas called:",
   "biogas",
   C("In a digester, bacteria act on sludge without air to make biogas, a useful fuel.")+
   steps("Sludge is rich in matter bacteria can eat","in a closed tank bacteria break it down","this releases biogas, which can be burned as fuel."),
   [("oxygen","Oxygen is used up, not produced, when sludge is broken down for biogas."),
    ("petrol","Petrol comes from crude oil, not from sludge in a digester."),
    ("steam","Steam is just hot water vapour, not the fuel gas made from sludge.")]),

 ("WW","Untreated sewage flowing through open drains is dangerous mainly because it:",
   "spreads diseases like cholera and typhoid",
   C("Raw sewage teems with germs, so open sewage spreads diseases such as cholera and typhoid.")+
   steps("Sewage is full of disease germs","open drains let people and flies contact it","so it spreads diseases like cholera and typhoid."),
   [("makes the water taste sweet","Sewage is foul, not sweet, and it carries germs."),
    ("turns into clean drinking water","Untreated sewage stays dirty; it does not clean itself."),
    ("cools the whole neighbourhood","Open sewage does not cool an area; it spreads disease.")]),

 ("WW","Dissolved substances in sewage such as nitrogen and phosphorus compounds are examples of its:",
   "contaminants (nutrients)",
   C("Sewage carries dissolved nutrients like nitrogen and phosphorus, which are contaminants.")+
   steps("Sewage is not just water","it carries dissolved matter such as nitrogen and phosphorus","these dissolved substances are contaminants."),
   [("clean minerals safe to drink","These dissolved nutrients in sewage are contaminants, not safe minerals."),
    ("pure oxygen gas","Nitrogen and phosphorus compounds are dissolved solids, not oxygen gas."),
    ("harmless food colours","They are sewage contaminants, not food colouring.")]),

 ("WW","Keeping our surroundings clean and disposing of human and other wastes properly is called:",
   "sanitation",
   C("Proper, hygienic disposal of waste and keeping surroundings clean is sanitation.")+
   steps("Wastes must be removed safely","surroundings must be kept clean and germ-free","this care is called sanitation."),
   [("irrigation","Irrigation is supplying water to crops, not waste disposal."),
    ("ventilation","Ventilation is letting fresh air in, not handling wastes."),
    ("decoration","Decoration is making a place pretty, not keeping it hygienic.")]),

 ("WW","Used cooking oil should NOT be poured down the kitchen drain because it:",
   "hardens and blocks the drain pipes",
   C("Cooking oil congeals in pipes, narrowing and blocking them, so it must not be poured down drains.")+
   steps("Oil cools inside the pipe","it sets into a sticky, hard layer","this coating builds up and blocks the drain."),
   [("makes the water cleaner","Oil dirties and clogs drains; it does not clean the water."),
    ("turns into safe drinking water","Oil does not become drinking water; it blocks pipes."),
    ("kills no germs and helps flow","Oil hinders flow by clogging; it does not help it.")]),

 ("WW","A low-cost toilet that turns human waste into useful manure with the help of worms is a:",
   "vermi-processing toilet",
   C("A vermi-processing toilet uses worms to convert human waste into manure cheaply.")+
   steps("Human waste can be turned into manure","worms speed up this breakdown","a toilet using worms is a vermi-processing toilet."),
   [("flush-and-forget sewer toilet","A sewer toilet sends waste to a plant; it does not use worms to make manure."),
    ("solar water heater","A solar heater warms water; it is not a toilet at all."),
    ("rainwater tank","A rainwater tank stores rain; it does not process human waste.")]),

 ("WW","Paints, medicines and other chemicals must not be poured into drains because they:",
   "kill the helpful bacteria that clean the sewage",
   C("Such chemicals poison the aerobic bacteria the plant relies on, so cleaning fails.")+
   steps("The plant depends on helpful bacteria","paints and medicines are poisons to them","so pouring chemicals in kills the cleaning bacteria."),
   [("make the bacteria grow faster","These chemicals poison the bacteria; they do not feed them."),
    ("turn the sewage into pure water","Chemicals harm treatment; they do not purify sewage."),
    ("add useful vitamins to the water","Paints and medicines are pollutants, not vitamins.")]),

 ("WW","After it is dried, the treated sludge can be put to good use as:",
   "manure for fields",
   C("Dried, stabilised sludge is rich in nutrients and can be spread on fields as manure.")+
   steps("Sludge holds plant nutrients","once dried and treated it is safe to use","so it serves as manure for crops."),
   [("drinking water","Sludge is solid waste, not something to drink."),
    ("window glass","Sludge cannot be made into glass; it is used as manure."),
    ("cooking fuel oil","The dried solid is used as manure; biogas, not oil, is the fuel made from it.")]),

 ("WW","Where there is no underground sewer, household sewage can be collected and partly treated on the spot in a:",
   "septic tank",
   C("A septic tank holds and partly breaks down sewage on site where no sewer exists.")+
   steps("Some homes have no sewer pipe nearby","sewage is collected in an underground tank","there bacteria partly treat it — this is a septic tank."),
   [("overhead water tank","An overhead tank stores clean water; it does not hold sewage."),
    ("petrol tank","A petrol tank holds fuel, not household sewage."),
    ("biogas cylinder","A biogas cylinder stores gas; it is not where sewage is collected.")]),

 ("WW","Diseases such as typhoid, cholera and dysentery spread mainly through:",
   "water contaminated by sewage",
   C("These illnesses are carried by sewage-polluted water that people drink or touch.")+
   steps("Sewage holds the germs of these diseases","when it mixes with drinking water","people fall ill — so dirty water spreads them."),
   [("clean filtered air","These are water-borne diseases, not spread mainly by clean air."),
    ("bright sunlight","Sunlight does not carry these germs; sewage-polluted water does."),
    ("dry sand","Dry sand is not the main carrier; contaminated water is.")]),

 ("WW","Throwing tea leaves, solid food scraps and cotton into the kitchen sink is wrong because they:",
   "clog the drains",
   C("Solid scraps do not dissolve; they pile up and clog the drain pipes.")+
   steps("Solids like tea leaves do not dissolve","they collect inside the pipe","over time they clog and block the drain."),
   [("clean the pipes from inside","Solids block pipes; they do not scrub them clean."),
    ("turn into safe gas","Tea leaves in a sink do not become gas; they clog the drain."),
    ("make the water drinkable","Adding scraps makes water dirtier, not drinkable.")]),

 ("WW","The first group of steps at a plant that removes solids by screening and letting them settle is called the:",
   "physical (mechanical) cleaning",
   C("Screening and settling remove solids by physical means, so this stage is physical cleaning.")+
   steps("Bar screens and settling tanks only move solids out","no germs are eaten and no chemicals added yet","so this stage is physical (mechanical) cleaning."),
   [("the biogas stage","Biogas is made from sludge much later, not during the first screening."),
    ("the chlorination stage","Chlorination is a final germ-killing step, not the first solid-removal."),
    ("the bottling stage","Treated sewage is not bottled; there is no bottling stage.")]),

 ("WW","An open drain running close to a house is a health risk because it is a:",
   "breeding place for disease-carrying flies and mosquitoes",
   C("Stagnant open sewage lets flies and mosquitoes breed, and they spread disease.")+
   steps("Open sewage stands still and stinks","flies and mosquitoes lay eggs in it","they breed and then spread disease to people."),
   [("source of clean drinking water","An open sewage drain gives dirty, germ-filled water, not clean water."),
    ("good place to store food","Storing food by a sewage drain would contaminate it, not help."),
    ("safe playground for children","An open drain is dangerous and dirty, not a safe play area.")]),

 ("WW","A town sends 5000 litres of sewage to the plant, and 4000 litres come out as treated water. The percentage of water recovered is:",
   "80%",
   C("Percentage recovered = (treated ÷ sent) × 100 = (4000 ÷ 5000) × 100 = 80%.")+
   steps("Write the fraction recovered: 4000 out of 5000","simplify 4000/5000 to 4/5","4/5 × 100 = 80%."),
   [("20%","20% is the part LOST (1000 L); the part recovered is 4000 L = 80%."),
    ("40%","40% would be 2000 of 5000; here 4000 of 5000 is 80%."),
    ("125%","You cannot recover more than was sent; 4000 of 5000 is 80%, not 125%.")]),

 ("WW","We should use water carefully and avoid wasting it so that:",
   "less sewage is produced and less needs to be treated",
   C("Using less water means less wastewater is made, easing the load on treatment plants.")+
   steps("Every litre we use becomes wastewater","less water used means less sewage made","so careful use means less to clean and release."),
   [("more germs grow in the pipes","Saving water reduces sewage; it does not breed more germs."),
    ("the river becomes dirtier","Less sewage means cleaner rivers, not dirtier ones."),
    ("treatment plants run out of work for good","Saving water eases the load; plants are still needed.")]),
]

WW_UC = [
 "Knowing sink water becomes sewage is why a city must plan where all its used water will go.",
 "Understanding sewerage is what lets engineers map the hidden pipes beneath a busy street.",
 "Recognising a treatment plant explains why a river downstream of a city can still run clean.",
 "Picturing bar screens shows why the very first job at a plant is catching the big rubbish.",
 "Knowing grit settles first is how a plant protects its pumps from being scoured by sand.",
 "Spotting sludge at the bottom is what an operator checks to know a settling tank is working.",
 "Skimming scum is the daily task that keeps oil and grease from fouling the next tank.",
 "Bubbling air for bacteria is the clever trick that lets tiny microbes do most of the cleaning.",
 "Knowing the bacteria need oxygen is why the aeration blowers must never be switched off.",
 "Understanding where treated water goes is why parks near plants are often watered for free.",
 "Turning sludge into biogas is how a plant can power its own lights from the very waste it cleans.",
 "Knowing raw sewage spreads cholera is why open drains near homes are a public-health alarm.",
 "Spotting nutrient contaminants explains why too much sewage makes ponds choke with green algae.",
 "Valuing sanitation is the reason towns build toilets and covered drains for everyone.",
 "Knowing oil clogs pipes is why kitchens are told to bin used cooking oil, not pour it away.",
 "Choosing a vermi-toilet is how a village without sewers still turns waste into useful manure.",
 "Knowing chemicals kill the bacteria is why paint and medicine should never go down the sink.",
 "Reusing dried sludge as manure is how a plant turns a waste problem into a farming resource.",
 "Building a septic tank is the practical answer for a home far from any city sewer line.",
 "Knowing these are water-borne diseases is why boiling or filtering drinking water saves lives.",
 "Not dumping scraps in the sink is the simple habit that keeps a home's drains from blocking.",
 "Naming the physical-cleaning stage helps you follow a plant tour from screen to settling tank.",
 "Spotting an open drain as a mosquito nursery is how a health worker finds a malaria hotspot.",
 "Working out the % recovered is exactly what a plant reports to show how well it is running.",
 "Saving water is the easiest way every family lightens the load on the town's treatment plant.",
]

# ---------- COMPARING QUANTITIES (25) — Maths ----------
CQ = [
 ("CQ","A ratio is a way of comparing two quantities of the same kind by:",
   "division (how many times one is of the other)",
   C("A ratio compares two like quantities by dividing one by the other, written with a colon.")+
   steps("Take two like amounts, say 4 and 6","compare them by dividing: 4 ÷ 6","this comparison by division is their ratio, 4 : 6."),
   [("addition","A ratio compares by dividing, not by adding the two quantities."),
    ("subtraction","Subtraction gives a difference, not the times-comparison a ratio makes."),
    ("rounding off","Rounding changes a number's look; it does not compare two quantities.")]),

 ("CQ","The ratio 4 : 6 written in its simplest form is:",
   "2 : 3",
   C("Divide both parts by their common factor 2: 4 : 6 becomes 2 : 3.")+
   steps("Find a common factor of 4 and 6, which is 2","divide both: 4 ÷ 2 = 2 and 6 ÷ 2 = 3","so 4 : 6 = 2 : 3."),
   [("4 : 6","That is the original ratio, not yet reduced to simplest form."),
    ("3 : 2","This flips the order; 4 : 6 reduces to 2 : 3, not 3 : 2."),
    ("8 : 12","That is a larger equivalent ratio, not the simplest form.")]),

 ("CQ","To change the fraction 3/4 into a percentage you multiply it by 100, which gives:",
   "75%",
   C("A fraction becomes a percentage when multiplied by 100: 3/4 × 100 = 75%.")+
   steps("Multiply the fraction by 100","3/4 × 100 = 300/4","300 ÷ 4 = 75, so 3/4 = 75%."),
   [("34%","75% comes from 3/4 × 100; 34% just glues the digits 3 and 4 together."),
    ("43%","Reversing the digits is wrong; 3/4 × 100 is 75%."),
    ("300%","You divided by nothing; 300/4 still has to be divided by 4 to give 75%.")]),

 ("CQ","The percentage 25% written as a fraction in its simplest form is:",
   "1/4",
   C("25% means 25 out of 100; 25/100 reduces to 1/4.")+
   steps("Write 25% as 25/100","divide top and bottom by 25","25 ÷ 25 = 1 and 100 ÷ 25 = 4, so 1/4."),
   [("1/2","1/2 is 50%, not 25%; 25% reduces to 1/4."),
    ("1/25","25% is 25/100 = 1/4, not 1/25."),
    ("25/10","25% is 25/100, which is less than 1; 25/10 is far too big.")]),

 ("CQ","Expressed as a percentage, the decimal 0.6 becomes:",
   "60%",
   C("Multiply a decimal by 100 to make a percentage: 0.6 × 100 = 60%.")+
   steps("Multiply 0.6 by 100","0.6 × 100 = 60","so 0.6 is 60%."),
   [("6%","6% is 0.06; moving the point only one place is wrong, 0.6 = 60%."),
    ("0.6%","0.6% is the tiny number 0.006; 0.6 itself equals 60%."),
    ("600%","600% would be 6.0; 0.6 × 100 is just 60%.")]),

 ("CQ","20% of 150 is:",
   "30",
   C("20% of 150 = (20 ÷ 100) × 150 = 30.")+
   steps("Write 20% as 20/100 = 1/5","find 1/5 of 150","150 ÷ 5 = 30."),
   [("3","3 is 2% of 150, not 20%; 20% of 150 is 30."),
    ("20","20 is the percentage figure, not 20% of 150, which is 30."),
    ("300","300 is 200% of 150; 20% of 150 is just 30.")]),

 ("CQ","If 2 pens cost ₹30, then by the unitary method 5 pens cost:",
   "₹75",
   C("First find one pen's cost, then multiply: ₹30 ÷ 2 = ₹15 each, so 5 × ₹15 = ₹75.")+
   steps("Cost of 1 pen = 30 ÷ 2 = ₹15","cost of 5 pens = 5 × 15","5 × 15 = ₹75."),
   [("₹150","₹150 multiplies 5 by 30 without first finding one pen's price of ₹15."),
    ("₹60","₹60 is 2 × 30; you must first find one pen (₹15), then × 5 = ₹75."),
    ("₹15","₹15 is the cost of one pen, not of five; five pens cost ₹75.")]),

 ("CQ","When the selling price of an article is MORE than its cost price, the seller makes a:",
   "profit",
   C("Selling above the cost price gives a gain, which is called profit.")+
   steps("Compare selling price with cost price","here selling price is the higher one","selling above cost gives a profit."),
   [("loss","A loss happens when the selling price is LOWER than the cost price."),
    ("discount","A discount is a cut from the marked price, not the gain over cost."),
    ("interest","Interest is the charge for borrowed money, not the gain on a sale.")]),

 ("CQ","A toy is bought for ₹200 and sold for ₹250. The profit is:",
   "₹50",
   C("Profit = selling price − cost price = 250 − 200 = ₹50.")+
   steps("Write profit = selling price − cost price","put in 250 − 200","250 − 200 = ₹50."),
   [("₹450","₹450 adds the two prices; profit is the difference, 250 − 200 = ₹50."),
    ("₹250","₹250 is the selling price, not the profit, which is 250 − 200 = ₹50."),
    ("₹200","₹200 is the cost price, not the profit of ₹50.")]),

 ("CQ","A toy costing ₹200 is sold for ₹250, a profit of ₹50. The profit per cent is:",
   "25%",
   C("Profit% = (profit ÷ cost price) × 100 = (50 ÷ 200) × 100 = 25%.")+
   steps("Write profit% = (profit ÷ cost) × 100","put in (50 ÷ 200) × 100","50/200 = 1/4, and 1/4 × 100 = 25%."),
   [("50%","Profit% is on the cost (200), not on the profit; 50/200 × 100 = 25%."),
    ("20%","20% would be 50/250; profit% is figured on the cost 200, giving 25%."),
    ("5%","5% misplaces the decimal; 50/200 × 100 is 25%.")]),

 ("CQ","A shirt costing ₹400 is sold for ₹360. The loss per cent is:",
   "10%",
   C("Loss = 400 − 360 = ₹40; loss% = (40 ÷ 400) × 100 = 10%.")+
   steps("Loss = cost − selling = 400 − 360 = ₹40","loss% = (loss ÷ cost) × 100","(40 ÷ 400) × 100 = 10%."),
   [("40%","₹40 is the loss in rupees, not the percentage; 40/400 × 100 = 10%."),
    ("4%","4% misplaces the decimal; 40/400 × 100 is 10%."),
    ("90%","90% is the fraction still recovered; the loss is 40 of 400 = 10%.")]),

 ("CQ","Two ratios are said to be in proportion when:",
   "the two ratios are equal",
   C("If one ratio equals another, the four numbers are in proportion.")+
   steps("Write the two ratios side by side","check whether they are equal","if they are equal, the quantities are in proportion."),
   [("their sums are equal","Proportion needs the ratios equal, not their sums."),
    ("one is double the other","Proportion needs the ratios EQUAL, not one double the other."),
    ("both contain the number 1","Containing a 1 has nothing to do with being in proportion.")]),

 ("CQ","In the proportion 3 : 5 = 9 : ?, the missing number is:",
   "15",
   C("The first ratio is multiplied by 3 (3→9), so the second part is 5 × 3 = 15.")+
   steps("See how 3 became 9: it was multiplied by 3","do the same to 5","5 × 3 = 15, so the missing number is 15."),
   [("11","11 adds 2 instead of scaling; 3→9 is ×3, so 5×3 = 15."),
    ("45","45 is 9 × 5; the correct second part scales 5 by 3 to give 15."),
    ("7","7 adds 2 to 5; proportion needs ×3, giving 15.")]),

 ("CQ","The extra money paid for the use of borrowed money over time is called:",
   "simple interest",
   C("The charge for using borrowed money for a period is the (simple) interest.")+
   steps("Borrowed money must be paid back","a little extra is paid for using it","that extra over time is the interest."),
   [("principal","The principal is the borrowed sum itself, not the extra charge on it."),
    ("profit","Profit is the gain on selling goods, not the charge on a loan."),
    ("discount","A discount is a price cut, not a charge for borrowing money.")]),

 ("CQ","The formula for simple interest, with principal P, rate R% per year and time T years, is:",
   "SI = (P × R × T) ÷ 100",
   C("Simple interest = (Principal × Rate × Time) ÷ 100.")+
   steps("Multiply principal, rate and time together","because the rate is a per cent, divide by 100","so SI = (P × R × T) ÷ 100."),
   [("SI = P + R + T","Interest is found by multiplying then dividing by 100, not by adding."),
    ("SI = P × R × T × 100","You divide by 100 for the per cent, not multiply by 100."),
    ("SI = P ÷ (R × T)","The principal is multiplied by R and T, not divided by them.")]),

 ("CQ","For ₹1000 lent at 5% per year over a period of 2 years, the simple interest works out to:",
   "₹100",
   C("SI = (1000 × 5 × 2) ÷ 100 = 10000 ÷ 100 = ₹100.")+
   steps("Put values into SI = (P × R × T) ÷ 100","(1000 × 5 × 2) = 10000","10000 ÷ 100 = ₹100."),
   [("₹1000","₹1000 is the principal, not the interest, which works out to ₹100."),
    ("₹50","₹50 is the interest for just one year; for 2 years it is ₹100."),
    ("₹200","₹200 forgets to divide by 100 properly; the SI is ₹100.")]),

 ("CQ","The total money to be repaid on a loan, called the amount, is equal to:",
   "principal + interest",
   C("Amount = the original principal plus the interest charged on it.")+
   steps("You must return the borrowed sum, the principal","plus the extra charge, the interest","so amount = principal + interest."),
   [("principal − interest","You pay back MORE than you borrowed, so you add interest, not subtract it."),
    ("interest only","You must return the principal too, not just the interest."),
    ("principal × interest","The amount adds interest to principal; it does not multiply them.")]),

 ("CQ","In a class of 40 students, 10 are absent. The percentage of students absent is:",
   "25%",
   C("Percentage absent = (10 ÷ 40) × 100 = 25%.")+
   steps("Write the fraction absent: 10 out of 40","10/40 simplifies to 1/4","1/4 × 100 = 25%."),
   [("10%","10 is the number absent, not the per cent; 10/40 × 100 = 25%."),
    ("40%","40 is the class size, not the per cent absent, which is 25%."),
    ("75%","75% is the percentage PRESENT; the absent fraction 10/40 is 25%.")]),

 ("CQ","To find what per cent 15 is of 60, you should compute:",
   "(15 ÷ 60) × 100",
   C("Part-as-a-percent = (part ÷ whole) × 100 = (15 ÷ 60) × 100 = 25%.")+
   steps("Put the part over the whole: 15/60","multiply by 100 to make a per cent","(15 ÷ 60) × 100 = 25%."),
   [("(60 ÷ 15) × 100","This flips part and whole; the part 15 goes on top, not the whole."),
    ("15 × 60","Multiplying the two numbers does not give a percentage."),
    ("15 + 60","Adding them gives 75, which is not a percentage at all.")]),

 ("CQ","Increasing 50 by 10% gives:",
   "55",
   C("10% of 50 is 5, and 50 + 5 = 55.")+
   steps("Find 10% of 50: that is 5","add it on to the original 50","50 + 5 = 55."),
   [("60","60 adds 10 (the per cent number), not 10% of 50, which is 5 → 55."),
    ("45","45 subtracts 5; the question says increase, so 50 + 5 = 55."),
    ("500","500 multiplies wrongly; a 10% rise on 50 gives just 55.")]),

 ("CQ","Decreasing 80 by 25% gives:",
   "60",
   C("25% of 80 is 20, and 80 − 20 = 60.")+
   steps("Find 25% of 80: that is 20","subtract it from 80 because it decreases","80 − 20 = 60."),
   [("100","100 adds 20; the question says decrease, so 80 − 20 = 60."),
    ("55","55 subtracts 25 (the per cent number) instead of 25% of 80, which is 20."),
    ("20","20 is the amount of the decrease, not the result; 80 − 20 = 60.")]),

 ("CQ","The ratio of 50 paise to 1 rupee (100 paise), in simplest form, is:",
   "1 : 2",
   C("Both must be in the same unit: 50 paise : 100 paise = 1 : 2.")+
   steps("Change ₹1 to 100 paise so units match","write 50 : 100","divide both by 50 to get 1 : 2."),
   [("50 : 1","This compares paise with rupees without matching units; in paise it is 50 : 100 = 1 : 2."),
    ("2 : 1","That flips the order; the smaller amount 50 paise comes first, giving 1 : 2."),
    ("1 : 50","50 paise is half of 100 paise, so the ratio is 1 : 2, not 1 : 50.")]),

 ("CQ","On a map drawn to a scale of 1 : 1000, a length of 1 cm on the map stands for:",
   "1000 cm on the ground",
   C("A scale of 1 : 1000 means every 1 unit on the map is 1000 of the same unit in real life.")+
   steps("Read the scale 1 : 1000","1 cm on the map matches 1000 cm in reality","so 1 cm represents 1000 cm on the ground."),
   [("1 cm on the ground","If 1 cm meant 1 cm, the map and land would be the same size."),
    ("10 cm on the ground","The scale is 1 : 1000, so 1 cm is 1000 cm, not 10 cm."),
    ("1000 km on the ground","The unit stays the same; 1 cm is 1000 cm, not 1000 km.")]),

 ("CQ","In a 500 g sample of soil, 100 g is found to be clay. The percentage of clay in the soil is:",
   "20%",
   C("Percentage of clay = (100 ÷ 500) × 100 = 20%.")+
   steps("Write the clay fraction: 100 out of 500","100/500 simplifies to 1/5","1/5 × 100 = 20%."),
   [("100%","100 g is only the clay part of the 500 g, so it is 20%, not the whole sample."),
    ("50%","50% would be 250 g of 500 g; here clay is 100 g = 20%."),
    ("5%","5% misplaces the decimal; 100/500 × 100 is 20%.")]),

 ("CQ","In a tank, the water is mixed as 3 parts clean water to 1 part sludge. The fraction of the mixture that is sludge is:",
   "1/4",
   C("Total parts = 3 + 1 = 4, and sludge is 1 of those parts, so the fraction is 1/4.")+
   steps("Add the parts: 3 clean + 1 sludge = 4 parts","sludge is 1 of the 4 parts","so the sludge fraction is 1/4."),
   [("1/3","1/3 compares sludge with clean water alone, not with the whole 4 parts."),
    ("3/4","3/4 is the CLEAN-water fraction; the sludge is the 1 part, 1/4."),
    ("1/2","Half would be 2 of 4 parts; sludge is only 1 of 4, so 1/4.")]),
]

CQ_UC = [
 "Using ratios is how a cook keeps a recipe tasting right when doubling it for more guests.",
 "Reducing a ratio is what lets a map-maker shrink huge real distances onto a small sheet.",
 "Turning 3/4 into 75% is exactly what a teacher does to put a test score on a report card.",
 "Reading 25% as 1/4 helps you split a bill or a pizza into four fair shares in your head.",
 "Changing 0.6 to 60% is what a shopkeeper does to show a decimal sale figure as a percent.",
 "Finding 20% of an amount is the everyday skill behind working out a sale discount quickly.",
 "The unitary method is how you compare which pack is cheaper per piece at the market.",
 "Spotting a profit is the first thing a shopkeeper checks before deciding a fair selling price.",
 "Working out the rupee profit is what a small trader does at the end of each day's sales.",
 "Computing profit% lets a seller compare two deals fairly even when the prices differ.",
 "Computing loss% warns a trader exactly how much each unsold-cheap item is really costing.",
 "Checking proportion is how a builder keeps a model in true shape with the real building.",
 "Filling a missing proportion value is how you scale a recipe or a drawing up or down.",
 "Knowing what interest is helps a family understand the real cost of borrowing for a purchase.",
 "Using the SI formula is how a bank clerk quickly tells a customer the interest on a deposit.",
 "Calculating SI on a real sum is what you do before deciding whether a savings plan is worth it.",
 "Knowing amount = principal + interest is how you check the final figure a lender asks back.",
 "Finding a percentage absent is how a school office reports attendance to the education board.",
 "Expressing one number as a percent of another is the core skill behind every statistic you read.",
 "Increasing by a percent is exactly what a shop does when it adds a service charge to a bill.",
 "Decreasing by a percent is the maths behind every 'flat 25% off' sign in a shop window.",
 "Matching units before forming a ratio stops the classic paise-versus-rupees mix-up in money sums.",
 "Reading a map scale is how a hiker turns a few centimetres on paper into real kilometres of trail.",
 "Finding the % of clay is exactly what a soil lab reports to tell a farmer the soil type.",
 "Turning a parts-ratio into a fraction is how a plant operator states how much of a tank is sludge.",
]

# ---------- ALGEBRAIC EXPRESSIONS (25) — Maths ----------
AE = [
 ("AE","A symbol such as x, which can stand for many different number values, is called a:",
   "variable",
   C("A letter that can take various values, like x or n, is a variable.")+
   steps("A box that could hold any number is needed","we use a letter such as x for it","this changeable letter is a variable."),
   [("constant","A constant has one fixed value; a variable can change, so it is not constant."),
    ("equation","An equation states two things are equal; it is not a single changing symbol."),
    ("product","A product is the result of multiplying, not a changeable symbol.")]),

 ("AE","A fixed number such as 7, whose value never changes, is called a:",
   "constant",
   C("A number with one unchanging value, like 7, is a constant.")+
   steps("Some numbers in an expression never change","7 is always 7, whatever happens","such a fixed value is a constant."),
   [("variable","A variable can take many values; a constant stays fixed, so this is wrong."),
    ("coefficient","A coefficient multiplies a variable; a lone fixed number is a constant."),
    ("term","A term is a part of an expression; the fixed number itself is a constant.")]),

 ("AE","In the term 5x, the number 5 that multiplies the variable x is called the:",
   "coefficient",
   C("The number multiplying a variable in a term is its coefficient; in 5x it is 5.")+
   steps("Look at the term 5x","the 5 is multiplying the x","that multiplying number is the coefficient."),
   [("constant","5x changes with x, so the 5 is a coefficient, not a standalone constant."),
    ("exponent","An exponent sits raised above; here 5 multiplies x, so it is the coefficient."),
    ("variable","The variable is x; the 5 that multiplies it is the coefficient.")]),

 ("AE","The parts of an expression that are separated by + or − signs are called its:",
   "terms",
   C("An expression breaks at its + and − signs into pieces called terms.")+
   steps("Look at where the + and − signs are","each piece between them is one part","these parts are called terms."),
   [("factors","Factors are numbers multiplied together within a term, not the +/− pieces."),
    ("coefficients","A coefficient is the number multiplying a variable, not a whole piece."),
    ("powers","A power is a repeated multiplication, not a +/− separated piece.")]),

 ("AE","Terms that have exactly the same variable factors, such as 3x and 7x, are called:",
   "like terms",
   C("Terms with the same variable part, such as 3x and 7x, are like terms and can be combined.")+
   steps("Compare the variable parts of the terms","3x and 7x both have just x","same variable part means they are like terms."),
   [("unlike terms","Unlike terms have DIFFERENT variable parts; 3x and 7x share x, so they are like."),
    ("constants","3x and 7x both contain x, so they are not plain constants."),
    ("coefficients","3 and 7 are the coefficients; the whole terms 3x and 7x are like terms.")]),

 ("AE","The terms 3x and 3y are:",
   "unlike terms",
   C("They have different variable parts (x and y), so 3x and 3y are unlike terms.")+
   steps("Compare the variable parts: x versus y","they are different letters","so 3x and 3y are unlike terms."),
   [("like terms","Like terms need the SAME variable part; x and y differ, so they are unlike."),
    ("equal terms","Equal would mean the same value; 3x and 3y are not equal in general."),
    ("constant terms","Both contain a variable, so neither is a constant term.")]),

 ("AE","An expression having exactly ONE term, such as 4xy, is called a:",
   "monomial",
   C("An expression with a single term is a monomial; 'mono' means one.")+
   steps("Count the terms in 4xy","there is just one term, no +/− splitting it","one term means it is a monomial."),
   [("binomial","A binomial has two terms; 4xy has only one."),
    ("trinomial","A trinomial has three terms; 4xy has only one."),
    ("equation","An equation needs an equals sign; 4xy is a single-term expression.")]),

 ("AE","An expression having exactly TWO terms, such as x + 5, is called a:",
   "binomial",
   C("An expression with two terms is a binomial; 'bi' means two.")+
   steps("Count the terms in x + 5","there are two: x and 5","two terms means it is a binomial."),
   [("monomial","A monomial has one term; x + 5 has two."),
    ("trinomial","A trinomial has three terms; x + 5 has only two."),
    ("constant","A constant is a single fixed number; x + 5 has a variable and two terms.")]),

 ("AE","An expression having exactly THREE terms is called a:",
   "trinomial",
   C("An expression with three terms is a trinomial; 'tri' means three.")+
   steps("Count the terms; here there are three","three separate parts joined by + or −","three terms means it is a trinomial."),
   [("monomial","A monomial has one term, not three."),
    ("binomial","A binomial has two terms, not three."),
    ("variable","A variable is a single symbol, not a three-term expression.")]),

 ("AE","Adding the like terms 6a + 2a gives:",
   "8a",
   C("Like terms add by adding their coefficients: 6a + 2a = (6 + 2)a = 8a.")+
   steps("They are like terms, both in a","add the coefficients: 6 + 2 = 8","so 6a + 2a = 8a."),
   [("12a","12 comes from 6 × 2; adding like terms uses 6 + 2 = 8, giving 8a."),
    ("8a²","Adding does not change a into a²; the answer keeps a, giving 8a."),
    ("8","The variable a does not vanish; 6a + 2a = 8a, not 8.")]),

 ("AE","Simplifying 9y − 4y gives:",
   "5y",
   C("Subtract the coefficients of like terms: 9y − 4y = (9 − 4)y = 5y.")+
   steps("Both terms are in y, so they are like","subtract the coefficients: 9 − 4 = 5","so 9y − 4y = 5y."),
   [("13y","13 comes from 9 + 4; the question subtracts, giving 9 − 4 = 5y."),
    ("5","The y stays; 9y − 4y = 5y, not just 5."),
    ("5y²","Subtracting like terms does not create a square; the answer is 5y.")]),

 ("AE","Written in algebra, 'a number x made 5 greater' is the expression:",
   "x + 5",
   C("'Increased by 5' means add 5 to x, giving x + 5.")+
   steps("Start with the number x","'increased by 5' means add 5","so the expression is x + 5."),
   [("5x","5x means 5 TIMES x, which is multiplying, not increasing by 5."),
    ("x − 5","x − 5 means decreased by 5; increased means add, giving x + 5."),
    ("x ÷ 5","Dividing by 5 is not increasing by 5; the answer is x + 5.")]),

 ("AE","The algebraic expression for 'twice a number n' is:",
   "2n",
   C("'Twice' means two times, so twice n is 2 × n, written 2n.")+
   steps("'Twice' means multiply by 2","apply it to n","2 × n is written 2n."),
   [("n + 2","n + 2 means 2 MORE than n, not twice n; twice is 2 × n = 2n."),
    ("n²","n² is n times n, not 2 times n; twice n is 2n."),
    ("n ÷ 2","Dividing by 2 is half of n, the opposite of twice n.")]),

 ("AE","The value of the expression 2x + 3 when x = 4 is:",
   "11",
   C("Substitute x = 4: 2 × 4 + 3 = 8 + 3 = 11.")+
   steps("Replace x with 4","2 × 4 = 8","then 8 + 3 = 11."),
   [("14","14 multiplies (4 + 3) by 2; the rule is 2×4 first, then + 3 = 11."),
    ("9","9 forgets to double x; 2 × 4 + 3 = 11, not 4 + 3 + 2."),
    ("24","24 multiplies everything wrongly; 2 × 4 + 3 = 11.")]),

 ("AE","The value of x² when x = 5 is:",
   "25",
   C("x² means x × x, so 5² = 5 × 5 = 25.")+
   steps("x² means x multiplied by itself","put in 5 × 5","5 × 5 = 25."),
   [("10","10 is 5 × 2; x² means 5 × 5 = 25, not 5 + 5."),
    ("7","7 is 5 + 2; squaring means 5 × 5 = 25."),
    ("52","52 just writes the digits; 5² is 5 × 5 = 25.")]),

 ("AE","Adding the expressions 3x + 2 and 5x + 4 gives:",
   "8x + 6",
   C("Add like terms separately: (3x + 5x) + (2 + 4) = 8x + 6.")+
   steps("Add the x-terms: 3x + 5x = 8x","add the constants: 2 + 4 = 6","so the sum is 8x + 6."),
   [("8x + 8","The constants are 2 + 4 = 6, not 8; the sum is 8x + 6."),
    ("15x + 6","15x comes from 3 × 5; you ADD the x-terms: 3x + 5x = 8x."),
    ("8x² + 6","Adding x-terms keeps x, not x²; the answer is 8x + 6.")]),

 ("AE","Subtracting 2a from 7a gives:",
   "5a",
   C("'Subtract 2a from 7a' means 7a − 2a = 5a.")+
   steps("'From 7a' means start with 7a","take away 2a: 7a − 2a","7 − 2 = 5, so 5a."),
   [("9a","9a adds the terms; the question subtracts, giving 7a − 2a = 5a."),
    ("5","The a remains; 7a − 2a = 5a, not just 5."),
    ("2a − 7a","Reading the order backwards gives a negative; from 7a means 7a − 2a = 5a.")]),

 ("AE","In the term −3pq, the variable factors are:",
   "p and q",
   C("The variable part of −3pq is pq, so the variables are p and q; −3 is the coefficient.")+
   steps("Separate the number from the letters","−3 is the coefficient","the letters p and q are the variable factors."),
   [("−3 and p","−3 is the coefficient, a number, not a variable factor."),
    ("3 and q","3 is part of the coefficient; the variable factors are p and q."),
    ("p, q and 3","The 3 is the coefficient; only p and q are the variable factors.")]),

 ("AE","The perimeter of a square whose side is s units is written as the expression:",
   "4s",
   C("A square has four equal sides of length s, so the perimeter is s + s + s + s = 4s.")+
   steps("A square has 4 equal sides","each side is s, so add four of them","s + s + s + s = 4s."),
   [("s⁴","s⁴ means s multiplied four times; perimeter ADDS four sides, giving 4s."),
    ("s + 4","s + 4 adds 4 once; four sides of s give 4 × s = 4s."),
    ("2s","2s is the sum of only two sides; a square has four, giving 4s.")]),

 ("AE","The algebraic expression for 'a number y decreased by 8' is:",
   "y − 8",
   C("'Decreased by 8' means take 8 away from y, giving y − 8.")+
   steps("Start with the number y","'decreased by 8' means subtract 8","so the expression is y − 8."),
   [("y + 8","y + 8 means increased by 8; decreased means subtract, giving y − 8."),
    ("8 − y","8 − y reverses the order; decreasing y by 8 is y − 8."),
    ("8y","8y means 8 times y, not 8 less than y; the answer is y − 8.")]),

 ("AE","The number of terms in the expression 2x + 3y − 7 is:",
   "three",
   C("Splitting at the + and − signs gives 2x, 3y and 7 — three terms.")+
   steps("Break the expression at its + and − signs","the pieces are 2x, 3y and 7","that is three terms."),
   [("two","There are three pieces (2x, 3y, 7), not two."),
    ("one","The +/− signs split it into three pieces, not one."),
    ("four","There are only three terms: 2x, 3y and 7.")]),

 ("AE","The coefficient of x in the term −x is:",
   "−1",
   C("−x means −1 × x, so the coefficient is −1.")+
   steps("Write −x in full as −1 × x","the number multiplying x is −1","so the coefficient is −1."),
   [("1","The minus sign belongs to the coefficient, making it −1, not +1."),
    ("0","If the coefficient were 0 the term would vanish; −x has coefficient −1."),
    ("x","x is the variable, not the coefficient; the coefficient is −1.")]),

 ("AE","Soil scientists write the percolation rate r as the water w divided by the time t. As a formula this is:",
   "r = w ÷ t",
   C("'Water divided by time' is written r = w ÷ t (or r = w/t).")+
   steps("The rate is water amount divided by time","let r be rate, w be water, t be time","so r = w ÷ t."),
   [("r = w × t","'Divided by' means division, not multiplication; r = w ÷ t."),
    ("r = t ÷ w","That flips it; water is divided BY time, so r = w ÷ t."),
    ("r = w + t","Rate is a division of w by t, not their sum.")]),

 ("AE","A tank already holds 200 litres and gains 100 litres every hour. After h hours it holds:",
   "(200 + 100h) litres",
   C("Start with 200, then add 100 for each of the h hours: 200 + 100 × h.")+
   steps("Begin with the starting 200 litres","each hour adds 100, so h hours add 100h","total = 200 + 100h litres."),
   [("(200 × 100h) litres","The 100 per hour is ADDED on, not multiplied with the start."),
    ("(300h) litres","You cannot merge the fixed 200 with the 100h; it stays 200 + 100h."),
    ("(200 − 100h) litres","The tank is filling, so the 100h is added, not subtracted.")]),

 ("AE","The value of the expression 3n − 1 when n = 10 is:",
   "29",
   C("Substitute n = 10: 3 × 10 − 1 = 30 − 1 = 29.")+
   steps("Replace n with 10","3 × 10 = 30","then 30 − 1 = 29."),
   [("31","31 adds 1; the expression subtracts, giving 30 − 1 = 29."),
    ("27","27 would be 3 × 9; here n = 10, so 3 × 10 − 1 = 29."),
    ("2","2 is roughly 3 − 1; you must multiply 3 by 10 first, giving 29.")]),
]

AE_UC = [
 "Using a variable is how a shop's bill formula works for any number of items you buy.",
 "Spotting a constant is what tells you which part of a phone plan never changes each month.",
 "Reading a coefficient is how you see at a glance how many of a thing a term counts.",
 "Counting terms is the first thing you do before tidying any long algebra expression.",
 "Recognising like terms is the skill that lets you shorten 3x + 7x into a single neat 10x.",
 "Telling unlike terms apart stops you from wrongly adding rupees to litres in a word problem.",
 "Naming a monomial helps you describe a single-term cost like '4 rupees per pencil'.",
 "Naming a binomial fits a two-part charge such as a fixed fee plus a per-item price.",
 "Naming a trinomial helps when a bill has three separate parts to add up.",
 "Adding like terms is exactly how you total several same-priced items in one step.",
 "Subtracting like terms is how you work out how many of a thing are left after some go.",
 "Writing 'increased by 5' as x + 5 is how you turn an everyday sentence into algebra.",
 "Writing 'twice n' as 2n is the move that lets a formula handle any starting number.",
 "Substituting a value is how a single formula gives the right answer for each new case.",
 "Squaring a number is the skill behind finding the area of any square room or tile.",
 "Adding two expressions is how you combine two separate cost formulas into one total.",
 "Subtracting expressions is how you find the difference between two changing quantities.",
 "Spotting the variable factors helps you decide whether two terms can be combined.",
 "Writing perimeter as 4s is how a carpenter finds the edging needed for any square frame.",
 "Writing 'decreased by 8' as y − 8 turns a discount sentence straight into algebra.",
 "Counting the terms of an expression is a quick check before you simplify or substitute.",
 "Knowing −x means −1·x stops a sign slip that would flip a whole answer's value.",
 "Writing rate = w ÷ t is exactly how a soil scientist turns a percolation test into a formula.",
 "Writing 200 + 100h is how an engineer predicts a filling tank's level at any future hour.",
 "Evaluating 3n − 1 for a given n is how one rule answers a whole table of values at once.",
]


def _with_uc(lst, ucs):
    assert len(lst) == len(ucs) == 25
    out = []
    for it, uc in zip(lst, ucs):
        code, stem, correct, html, distr = it
        out.append((code, stem, correct, html + U(uc), distr))
    return out


SO = _with_uc(SO, SO_UC)
WW = _with_uc(WW, WW_UC)
CQ = _with_uc(CQ, CQ_UC)
AE = _with_uc(AE, AE_UC)

items = []
for i in range(25):
    items += [SO[i], WW[i], CQ[i], AE[i]]
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

    keydist = build_paper(PNUM, TITLE, SHORT, LABELS, items, seed=32412,
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
    split = "/".join(str(counts[c]) for c in ("SO", "WW", "CQ", "AE"))
    with open("PAPERS_MANIFEST.md", "a", encoding="utf-8") as fh:
        fh.write(f"| {PNUM} | 2026-06-18 | {TITLE} | {split} | ✓ |\n")

    # ---- update QUESTION_INDEX.json ----
    idx["fingerprints"] = sorted(existing | set(new_fps))
    idx.setdefault("combos", []).append({
        "paper": PNUM,
        "chapters": ["Soil",
                     "Wastewater Story",
                     "Comparing Quantities",
                     "Algebraic Expressions"],
    })
    idx["papers"] = idx.get("papers", 0) + 1
    with open(idx_path, "w", encoding="utf-8") as fh:
        json.dump(idx, fh, ensure_ascii=False, indent=2)
        fh.write("\n")

    print("Files:", sorted(v for v in moves.values()))
    print("Answer key spread A/B/C/D =", dict(keydist))
    print("Fingerprints added:", len(new_fps))
