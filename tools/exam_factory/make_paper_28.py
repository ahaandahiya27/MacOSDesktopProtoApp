# -*- coding: utf-8 -*-
# Boss Challenge Paper 28 — Heat · Reproduction in Plants · Integers · Symmetry
# Content-only. Uses the dependency-free examfactory engine.
# Difficulty ramp: this paper leans into FUSION — many Integers items are wrapped in a Heat
# context (a temperature that falls below zero overnight, the gap between a freezer and a hot
# kitchen, a rise of so many degrees by noon). Several Symmetry items are wrapped in a
# Reproduction-in-Plants context (the fold-line down a leaf's midrib, the matching halves of a
# regular five-petalled flower). The child reads a Science context and applies a Maths skill.
# Class-7 scope, simple wording, hard thinking.
# Produces, under Resources/BossChallengePapers/:
#   Paper_28_<SHORT>_QuestionPaper.html  (pure HTML — questions + options)
#   Paper_28_<SHORT>_QuestionPaper.pdf
#   Paper_28_<SHORT>_Questions.md
#   Paper_28_<SHORT>_Solutions.html
import os, sys, shutil, json, re
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from examfactory import build_paper, C, steps, U

PNUM  = "28"
SHORT = "Heat_ReproductionPlants_Integers_Symmetry"
TITLE = ("Heat · Reproduction in Plants · Integers · Symmetry")
LABELS = {
    "HE": "Heat",
    "RP": "Reproduction in Plants",
    "IN": "Integers",
    "SY": "Symmetry",
}

# ---------- HEAT (25) — Science ----------
HE = [
 ("HE","The degree of hotness or coldness of a body, telling us how hot or cold it is, is called its:",
   "temperature",
   C("Temperature is the measure of how hot or cold something is.")+
   steps("Touch tells us only roughly how warm a thing is","a number on a scale is needed for an exact measure","that number is the temperature."),
   [("weight","Weight measures how heavy a body is, not how hot or cold it is."),
    ("length","Length measures how long a body is, not its hotness or coldness."),
    ("volume","Volume measures the space a body takes up, not its temperature.")]),

 ("HE","The instrument that is used to measure the temperature of a body accurately is the:",
   "thermometer",
   C("A thermometer reads temperature off a marked scale.")+
   steps("A liquid inside rises or falls as it warms or cools","its level lines up with a number on the scale","that reading is the temperature — given by a thermometer."),
   [("barometer","A barometer measures air pressure, not temperature."),
    ("speedometer","A speedometer measures how fast a vehicle moves, not its temperature."),
    ("ammeter","An ammeter measures electric current, not temperature.")]),

 ("HE","The special thermometer kept by a doctor to measure the temperature of the human body is the:",
   "clinical thermometer",
   C("A clinical thermometer is made just for reading body temperature.")+
   steps("A doctor needs the body's temperature","a clinical thermometer reads the narrow range around body heat","so it is the one used.")
   ,
   [("laboratory thermometer","A laboratory thermometer is for general experiments, not for measuring the body."),
    ("maximum–minimum thermometer","That records the day's highest and lowest air temperatures, not body heat."),
    ("digital clock","A clock measures time, not temperature.")]),

 ("HE","The temperature of a healthy human body, the value a doctor expects to read, is about:",
   "37°C",
   C("Normal human body temperature is close to 37 degrees Celsius.")+
   steps("A healthy person is neither feverish nor cold","their body settles near 37°C","so that is the normal reading."),
   [("0°C","0°C is the freezing point of water, far colder than a living body."),
    ("100°C","100°C is the boiling point of water; the body is nowhere near that hot."),
    ("50°C","50°C is too high for a healthy body; the normal value is about 37°C.")]),

 ("HE","A clinical thermometer has a small bend, called a kink, in its tube. The kink stops the mercury from:",
   "slipping back on its own",
   C("The kink holds the mercury in place so the reading does not drop before you read it.")+
   steps("After the thermometer is taken out, it starts to cool","without the kink the mercury would fall at once","the kink traps it so you can read the value calmly."),
   [("rising too fast","The kink does not slow the rise; it stops the mercury falling back after removal."),
    ("turning into gas","Mercury does not boil away here; the kink simply keeps the reading from dropping."),
    ("changing colour","Mercury does not change colour; the kink holds the reading steady.")]),

 ("HE","For measuring the temperature of things other than the body, such as hot water in an experiment, we use a:",
   "laboratory thermometer",
   C("A laboratory thermometer covers a wider range than a clinical one, for general use.")+
   steps("Experiments may be far hotter or colder than the body","a wider scale is needed","the laboratory thermometer provides it."),
   [("clinical thermometer","A clinical thermometer is built for the body's narrow range, not for general experiments."),
    ("compass","A compass shows direction, not temperature."),
    ("weighing scale","A weighing scale measures mass, not temperature.")]),

 ("HE","When a hot cup of tea is left on a table, heat flows on its own from the hotter tea to the cooler surroundings, that is, always from a:",
   "hotter body to a colder body",
   C("Heat always moves by itself from where it is hotter to where it is colder.")+
   steps("The tea is hotter than the air around it","heat leaves the tea and warms the air","so heat flows hotter → colder."),
   [("colder body to a hotter body","Heat never flows by itself from cold to hot; it goes from hot to cold."),
    ("heavier body to a lighter body","Heat flow depends on temperature, not on weight."),
    ("larger body to a smaller body","Heat flow depends on temperature difference, not on size.")]),

 ("HE","The way heat travels through a solid metal rod from the hot end to the cold end, without the metal itself moving, is called:",
   "conduction",
   C("Conduction passes heat from particle to particle through a solid, while the solid stays put.")+
   steps("Heat the rod at one end","the warmth is handed along the particles","the far end gets hot — this is conduction."),
   [("convection","Convection needs the heated material itself to move, which happens in liquids and gases, not solid rods."),
    ("radiation","Radiation carries heat as rays through space, not particle-to-particle along a solid."),
    ("reflection","Reflection bounces light or heat away; it does not pass heat along a rod.")]),

 ("HE","Materials such as iron, copper and aluminium, which let heat pass through them easily, are called:",
   "conductors",
   C("Conductors allow heat to move through them quickly.")+
   steps("Touch a metal spoon left in hot food","its handle soon turns hot too","because metals are good conductors of heat."),
   [("insulators","Insulators block heat; metals are the opposite — they conduct it well."),
    ("liquids","Iron and copper are solids, and the property asked about is conduction, not state."),
    ("gases","Iron and copper are solid conductors, not gases.")]),

 ("HE","Materials such as wood, plastic and cloth, which do not let heat pass through them easily, are called:",
   "insulators",
   C("Insulators slow the flow of heat, so the far side stays cool.")+
   steps("Hold a wooden spoon in hot food","its handle stays cool to touch","because wood is a poor conductor — an insulator."),
   [("conductors","Conductors let heat pass easily; wood and plastic resist it, so they are insulators."),
    ("metals","Metals are good conductors; the materials listed are insulators, not metals."),
    ("fuels","A fuel is something that burns to give heat; insulators simply block heat flow.")]),

 ("HE","In water and air, heat travels by the actual movement of the heated portions rising and the cooler ones sinking. This way of heat transfer is called:",
   "convection",
   C("Convection carries heat as the warm fluid rises and cool fluid takes its place.")+
   steps("Water at the bottom of a pan is heated","the warm water rises and cooler water sinks to be heated","this circulating flow is convection."),
   [("conduction","Conduction passes heat through a still solid; convection needs the fluid itself to move."),
    ("radiation","Radiation needs no material at all; convection needs a moving liquid or gas."),
    ("freezing","Freezing is water turning to ice, not a way of carrying heat.")]),

 ("HE","Heat from the Sun reaches the Earth across the empty space where there is no air or material. This way of heat travel is called:",
   "radiation",
   C("Radiation carries heat as rays and needs no material to travel through.")+
   steps("Between the Sun and Earth there is empty space","yet the Sun's heat still reaches us","so it must travel as radiation."),
   [("conduction","Conduction needs a solid material to pass heat along; space has none."),
    ("convection","Convection needs a moving liquid or gas; empty space has neither."),
    ("evaporation","Evaporation is water turning to vapour, not heat crossing empty space.")]),

 ("HE","On a hot, sunny day we feel cooler in light-coloured clothes because light or white surfaces:",
   "reflect most of the heat",
   C("Light surfaces bounce heat away, so less is soaked up and we feel cooler.")+
   steps("Sunlight falls on the cloth","a light colour sends most of the heat back","less heat is absorbed, so we stay cooler."),
   [("absorb most of the heat","Light colours reflect heat; it is dark colours that absorb it."),
    ("make their own heat","Cloth does not make heat; a light colour simply reflects the Sun's heat away."),
    ("turn heat into light","Cloth cannot turn heat into light; it just reflects the Sun's heat.")]),

 ("HE","In winter we often prefer dark-coloured clothes because dark surfaces:",
   "absorb more heat",
   C("Dark colours soak up heat, helping us feel warmer in the cold.")+
   steps("Sunlight falls on the dark cloth","a dark colour takes in most of the heat","more heat is absorbed, so we feel warmer."),
   [("reflect more heat","Dark colours absorb heat; it is light colours that reflect it."),
    ("block all heat","Dark cloth does not block heat; it absorbs it, keeping us warm."),
    ("cool the body down","Dark clothes warm us by absorbing heat, not by cooling us.")]),

 ("HE","During the day the land heats up faster than the sea, so a cool wind blows from the sea towards the land. This is called the:",
   "sea breeze",
   C("By day the warm land lets air rise, and cooler air flows in from the sea — the sea breeze.")+
   steps("By day the land grows hotter than the sea","warm air over the land rises","cooler air rushes in from the sea — the sea breeze."),
   [("land breeze","A land breeze blows from land to sea at night, the reverse of this daytime flow."),
    ("monsoon wind","A monsoon is a seasonal wind over months, not a daily sea-to-land breeze."),
    ("cyclone","A cyclone is a violent swirling storm, not a gentle daytime sea breeze.")]),

 ("HE","At night the land cools faster than the sea, so a wind blows from the land towards the sea. This is called the:",
   "land breeze",
   C("By night the warmer sea lets air rise, and cooler air flows out from the land — the land breeze.")+
   steps("At night the land cools faster than the sea","warm air over the sea rises","cooler air flows out from the land — the land breeze."),
   [("sea breeze","A sea breeze blows from sea to land by day, the reverse of this night-time flow."),
    ("storm","A storm is a violent weather event, not the gentle night-time land breeze."),
    ("whirlwind","A whirlwind is a small spinning column of air, not a steady land breeze.")]),

 ("HE","Woollen clothes keep us warm in winter mainly because the wool fibres trap a layer of:",
   "air, which is a poor conductor of heat",
   C("Trapped air does not let body heat escape easily, so we stay warm.")+
   steps("Wool fibres hold tiny pockets of air","air is a poor conductor of heat","so body heat cannot escape and we feel warm."),
   [("water, which carries heat away","Wool keeps us warm by trapping air, not water; wet wool actually feels cold."),
    ("metal, which conducts heat","Wool traps air, a poor conductor; it contains no warming metal."),
    ("heat made by the wool itself","Wool makes no heat of its own; it traps the body's heat using air.")]),

 ("HE","Wearing two thin blankets can keep you warmer than one thick blanket because the gap between them traps:",
   "a layer of air",
   C("The air trapped between the blankets is a poor conductor, so it holds in body heat.")+
   steps("Two thin blankets leave a gap between them","air is caught in that gap","trapped air blocks heat loss, keeping you warmer."),
   [("extra heat from outside","No outside heat is added; the trapped air simply stops body heat escaping."),
    ("cold water","Nothing wet is involved; it is trapped air, a poor conductor, that keeps you warm."),
    ("sunlight","Sunlight is not stored at night; the warmth comes from trapped air holding body heat.")]),

 ("HE","The silvery liquid that rises and falls inside many common thermometers as the temperature changes is:",
   "mercury",
   C("Mercury is a liquid metal that expands and rises evenly as it warms.")+
   steps("A thin tube holds the silvery liquid","as it warms the liquid expands and rises","that liquid is mercury."),
   [("water","Water is not used in these thermometers; the silvery liquid is mercury."),
    ("oil","Oil is not the silvery thread in a mercury thermometer; mercury is."),
    ("milk","Milk is never used in a thermometer; the liquid is mercury.")]),

 ("HE","Before using a clinical thermometer, a doctor gives it a few sharp jerks. This is done to:",
   "bring the mercury down below normal",
   C("The jerks push the trapped mercury back down so the next reading starts fresh.")+
   steps("Mercury from the last patient is held above the kink","sharp jerks shake it back down the tube","now the thermometer is ready to read afresh."),
   [("warm the thermometer up","Jerking does not warm it; it shakes the mercury back down before use."),
    ("clean the glass outside","Jerking is about the mercury inside, not cleaning the outside glass."),
    ("make the mercury boil","Jerking does not boil the mercury; it merely lowers the reading.")]),

 ("HE","When a steel spoon is left standing in a cup of hot tea, its top end soon becomes warm too. This happens by:",
   "conduction",
   C("Heat passes along the solid metal spoon from the hot end to the cool end — conduction.")+
   steps("The lower end of the spoon sits in hot tea","heat is handed along the metal particles","the top end warms up, by conduction."),
   [("convection","Convection moves heat by a flowing fluid; here the heat passes through a solid spoon."),
    ("radiation","Radiation carries heat as rays through space, not along a solid spoon."),
    ("melting","The spoon does not melt; heat simply travels along it by conduction.")]),

 ("HE","The handles of cooking pans are often made of plastic or wood rather than metal because these materials are good:",
   "insulators",
   C("Insulating handles stay cool, so the cook's hand is not burned.")+
   steps("Metal would carry the heat to the hand","plastic and wood are poor conductors","so insulating handles stay cool and safe to hold."),
   [("conductors","If the handle conducted heat well it would burn the hand; insulators are chosen instead."),
    ("reflectors","The handle is chosen to block heat, not to reflect light; it is an insulator."),
    ("fuels","A handle is not meant to burn; it is an insulator that keeps the hand safe.")]),

 ("HE","A clinical thermometer's scale usually runs only over a narrow range, from about:",
   "35°C to 42°C",
   C("Body temperature stays near 37°C, so the scale need only cover a little above and below it.")+
   steps("A healthy body is about 37°C","fever raises it only a few degrees","so a 35–42°C range is enough for a clinical thermometer."),
   [("0°C to 100°C","That is the wide range of a laboratory thermometer, not the clinical one."),
    ("−10°C to 50°C","That is far wider than a body ever reaches; the clinical range is 35–42°C."),
    ("100°C to 200°C","Body temperature never reaches such heat; the clinical range is 35–42°C.")]),

 ("HE","When a metal ball is heated strongly, it gets slightly bigger. This increase in size on heating is called:",
   "thermal expansion",
   C("Most materials expand a little when heated because their particles move apart.")+
   steps("Heating gives the particles more energy","they jiggle harder and spread out","so the ball grows slightly — thermal expansion."),
   [("conduction","Conduction is heat passing through a material, not the material growing in size."),
    ("evaporation","Evaporation is a liquid turning to vapour, not a solid ball expanding."),
    ("freezing","Freezing is cooling to a solid; expansion on heating is the opposite idea.")]),

 ("HE","In short, heat is best described as a form of:",
   "energy that flows because of a temperature difference",
   C("Heat is the energy that moves from a hotter body to a colder one.")+
   steps("Two bodies are at different temperatures","energy flows from the hotter to the colder","that flowing energy is heat."),
   [("matter that you can weigh","Heat is energy, not a material substance you can place on a scale."),
    ("light made only by the Sun","Heat is energy of motion of particles, not simply sunlight."),
    ("a liquid stored inside hot objects","Heat is not a stored liquid; it is energy that flows due to a temperature difference.")]),
]

# ---------- REPRODUCTION IN PLANTS (25) — Science ----------
RP = [
 ("RP","The process by which living organisms produce new individuals of their own kind is called:",
   "reproduction",
   C("Reproduction is how life makes more life, passing on the kind from parents to offspring.")+
   steps("Every kind of living thing must continue","parents give rise to young of the same kind","this making of new individuals is reproduction."),
   [("respiration","Respiration is the release of energy from food, not the making of new individuals."),
    ("digestion","Digestion is the breaking down of food, not the production of offspring."),
    ("germination","Germination is just a seed sprouting; reproduction is the wider making of new plants.")]),

 ("RP","When a new plant is produced from a single parent, without seeds and without the joining of two cells, the reproduction is called:",
   "asexual reproduction",
   C("Asexual reproduction needs only one parent and makes copies without seeds.")+
   steps("Only one parent plant is involved","no fusion of male and female cells occurs","the new plant forms directly — this is asexual reproduction."),
   [("sexual reproduction","Sexual reproduction needs two parents and the joining of cells; this needs only one."),
    ("pollination","Pollination is only the transfer of pollen, a step in sexual reproduction, not a whole type."),
    ("germination","Germination is a seed sprouting; the type of reproduction here is asexual.")]),

 ("RP","Reproduction that involves two parents and the joining of a male and a female cell, usually giving seeds, is called:",
   "sexual reproduction",
   C("Sexual reproduction joins cells from two parents and commonly forms seeds.")+
   steps("A male cell and a female cell are made","they fuse together","a seed forms and grows — this is sexual reproduction."),
   [("asexual reproduction","Asexual reproduction needs only one parent and no joining of cells."),
    ("vegetative propagation","Vegetative propagation is an asexual way using plant parts, not the two-parent, seed way."),
    ("budding","Budding is an asexual method; sexual reproduction joins two parents' cells.")]),

 ("RP","In yeast, a small bulge grows out from the parent cell, enlarges and finally separates as a new yeast. This method is called:",
   "budding",
   C("In budding a bulge, or bud, grows on the parent and breaks off as a new individual.")+
   steps("A small bud appears on the yeast cell","it grows and may form its own bud","finally it breaks away as a new yeast — budding."),
   [("fragmentation","Fragmentation breaks the body into pieces that each grow; budding grows a single bud."),
    ("pollination","Pollination is pollen transfer in flowers, not a bud forming on yeast."),
    ("fertilisation","Fertilisation is the fusing of two cells; budding needs only the one parent.")]),

 ("RP","New potato plants can sprout from the small buds, called 'eyes', on a potato. Growing a new plant from such a plant part is called:",
   "vegetative propagation",
   C("Vegetative propagation grows a new plant from a root, stem, leaf or bud of the parent.")+
   steps("The potato is a swollen underground stem with buds","each bud can sprout into a shoot and roots","a new plant grows from that part — vegetative propagation."),
   [("pollination","Pollination is pollen transfer in flowers, not a new plant sprouting from a potato bud."),
    ("fertilisation","Fertilisation joins two cells; here the new plant grows directly from a stem bud."),
    ("seed dispersal","Seed dispersal spreads seeds; the potato grows a new plant from a bud, not a seed.")]),

 ("RP","The leaves of the Bryophyllum plant carry tiny buds along their edges, and each bud can grow into a new plant. This shows vegetative propagation by:",
   "leaves",
   C("In Bryophyllum, buds on the leaf margins drop off and grow into new plants.")+
   steps("Tiny buds form along the leaf's edge","a bud falls onto moist soil","it grows roots and shoots — a new plant from a leaf."),
   [("roots","In Bryophyllum the new plants grow from buds on the leaves, not from the roots."),
    ("seeds","No seed is used here; the new plants come from buds on the leaf edges."),
    ("flowers","The new plants form from leaf-edge buds, not from flowers.")]),

 ("RP","Mosses and ferns often reproduce by tiny, light cells that are scattered by the wind and grow into new plants. These cells are called:",
   "spores",
   C("Spores are tiny reproductive cells that can grow into new plants without seeds.")+
   steps("Ferns make tiny spores in cases under their leaves","the spores are carried off by the wind","each can grow into a new fern."),
   [("seeds","Ferns and mosses make spores, not seeds; spores are far smaller and need no flower."),
    ("buds","Buds grow on a parent's body; spores are tiny cells released to scatter on the wind."),
    ("roots","Roots anchor a plant; spores are the tiny cells that grow into new ferns and mosses.")]),

 ("RP","The male reproductive part of a flower, which makes the pollen, is called the:",
   "stamen",
   C("The stamen is the flower's male part; it produces pollen grains.")+
   steps("Look inside the flower for the slender stalks topped with knobs","these make and hold the pollen","they are the stamens — the male part."),
   [("pistil","The pistil is the female part of the flower, not the male part that makes pollen."),
    ("petal","Petals are the coloured parts that attract insects, not the male reproductive part."),
    ("sepal","Sepals are the small green parts protecting the bud, not the male reproductive part.")]),

 ("RP","The female reproductive part of a flower, which contains the ovary, is called the:",
   "pistil",
   C("The pistil is the flower's female part, holding the ovary with its ovules.")+
   steps("Find the central flask-shaped part of the flower","it holds the ovary at its base","this is the pistil — the female part."),
   [("stamen","The stamen is the male part that makes pollen, not the female part."),
    ("petal","Petals attract insects; they are not the female reproductive part."),
    ("sepal","Sepals protect the young bud; they are not the female reproductive part.")]),

 ("RP","The sticky top of the pistil, on which pollen grains land and are caught, is called the:",
   "stigma",
   C("The stigma is the sticky tip of the pistil that receives pollen.")+
   steps("Pollen is carried to the flower","it lands on the sticky top of the pistil","that sticky landing pad is the stigma."),
   [("anther","The anther is the top of the stamen that makes pollen, not the part that receives it."),
    ("ovary","The ovary is the swollen base of the pistil holding ovules, not the sticky top."),
    ("filament","The filament is the stalk of the stamen, not the sticky pollen-catching tip.")]),

 ("RP","Pollen grains are made and stored in a part at the top of the stamen called the:",
   "anther",
   C("The anther is the pollen-bearing tip of the stamen.")+
   steps("The stamen has a stalk topped by a small sac","this sac makes and holds the pollen","that sac is the anther."),
   [("stigma","The stigma is the female part that receives pollen, not the part that makes it."),
    ("ovule","Ovules are inside the ovary and become seeds; pollen is made in the anther."),
    ("sepal","Sepals protect the bud; pollen is made in the anther of the stamen.")]),

 ("RP","The transfer of pollen grains from the anther of a flower to the stigma is called:",
   "pollination",
   C("Pollination is the movement of pollen from the male anther to the female stigma.")+
   steps("Pollen leaves the anther","it is carried to a stigma","this transfer of pollen is pollination."),
   [("fertilisation","Fertilisation is the joining of cells that happens after pollination, not the transfer itself."),
    ("germination","Germination is a seed sprouting, which comes much later than pollination."),
    ("respiration","Respiration is energy release from food, nothing to do with moving pollen.")]),

 ("RP","When pollen from a flower is transferred to the stigma of the same flower or another flower on the same plant, it is called:",
   "self-pollination",
   C("Self-pollination keeps the pollen on the same flower or the same plant.")+
   steps("Pollen leaves the anther","it lands on a stigma of the same plant","that is self-pollination."),
   [("cross-pollination","Cross-pollination carries pollen to a different plant of the same kind, not the same plant."),
    ("fertilisation","Fertilisation is the joining of cells, not the transfer of pollen within one plant."),
    ("dispersal","Dispersal is the spreading of seeds, not the transfer of pollen on the same plant.")]),

 ("RP","When pollen from one plant's flower is carried to the stigma of a flower on a different plant of the same kind, it is called:",
   "cross-pollination",
   C("Cross-pollination moves pollen between two different plants of the same kind.")+
   steps("Pollen leaves one plant's anther","an agent carries it to another plant's stigma","that is cross-pollination."),
   [("self-pollination","Self-pollination keeps pollen on the same plant; cross-pollination uses a different plant."),
    ("fertilisation","Fertilisation is the joining of cells after the pollen arrives, not the transfer itself."),
    ("germination","Germination is a seed sprouting, not the carrying of pollen between plants.")]),

 ("RP","Flowers depend on outside helpers to carry their pollen about. The common natural agents of pollination are:",
   "wind, water and insects",
   C("Wind, water and insects are the usual carriers that move pollen from flower to flower.")+
   steps("Pollen cannot move on its own","wind blows it, water floats it, insects brush it along","so these are the agents of pollination."),
   [("only earthworms","Earthworms live in soil and do not carry pollen between flowers."),
    ("only electricity","Electricity does not move pollen; wind, water and insects do."),
    ("only sunlight","Sunlight powers food-making but does not carry pollen; wind, water and insects do.")]),

 ("RP","Once fertilisation is over, the whole ovary of the flower swells and ripens to become the:",
   "fruit",
   C("Once fertilised, the whole ovary swells and becomes the fruit, holding the seeds.")+
   steps("Fertilisation happens inside the ovary","the ovary then grows and ripens","it becomes the fruit around the seeds."),
   [("root","The root anchors the plant in soil; it is the ovary that becomes the fruit."),
    ("leaf","Leaves make food; the fruit forms from the ripened ovary, not from a leaf."),
    ("stem","The stem holds the plant up; the fruit develops from the ovary, not the stem.")]),

 ("RP","After fertilisation, each ovule inside the ovary develops into a:",
   "seed",
   C("A fertilised ovule grows into a seed, which can later sprout into a new plant.")+
   steps("Ovules sit inside the ovary","after fertilisation each ovule ripens","it becomes a seed."),
   [("flower","A flower is the reproductive shoot; it is the ovule that becomes a seed."),
    ("root","Roots anchor the plant; the seed forms from a fertilised ovule, not a root."),
    ("petal","Petals attract insects; the seed develops from the ovule, not from a petal.")]),

 ("RP","The actual joining, or fusion, of a male cell from the pollen with the female cell (egg) in the ovule is called:",
   "fertilisation",
   C("Fertilisation is the fusing of the male and female cells to start a new plant.")+
   steps("Pollen reaches the ovule's egg cell","the male and female cells join together","that fusion is fertilisation."),
   [("pollination","Pollination is only the transfer of pollen, the step before the cells actually join."),
    ("germination","Germination is a seed sprouting, which comes after the seed has formed."),
    ("budding","Budding is an asexual method with one parent; fertilisation joins two cells.")]),

 ("RP","A flower that has both stamens (the male part) and a pistil (the female part) in the same flower is called a:",
   "bisexual flower",
   C("A bisexual flower carries both the male and the female reproductive parts together.")+
   steps("Look inside one flower","find both stamens and a pistil present","such a flower is bisexual."),
   [("unisexual flower","A unisexual flower has only one of the two parts, not both together."),
    ("seedless flower","Having both parts has nothing to do with being seedless; such a flower is bisexual."),
    ("petal-less flower","Whether petals are present is a separate matter; both parts present means bisexual.")]),

 ("RP","A flower that has only stamens or only a pistil, but not both, is called a:",
   "unisexual flower",
   C("A unisexual flower carries just one of the two reproductive parts.")+
   steps("Look inside the flower","find either stamens alone or a pistil alone","such a flower is unisexual."),
   [("bisexual flower","A bisexual flower has both parts together; a unisexual one has only one."),
    ("complete flower","Having only one reproductive part makes it unisexual, not 'complete'."),
    ("double flower","'Double' refers to extra petals; having only one reproductive part makes it unisexual.")]),

 ("RP","Some seeds, such as those of the drumstick and maple, have wing-like flaps that help them float away on moving air. These seeds are dispersed by:",
   "wind",
   C("Light, winged seeds are carried off by moving air, spreading the plant far and wide.")+
   steps("The seed has thin wings or hairs","a breeze lifts and carries it","so it is dispersed by wind."),
   [("water","Winged seeds catch the air; water disperses seeds that can float, like the coconut."),
    ("animals","Hooked or tasty seeds travel on animals; winged seeds travel on the wind."),
    ("explosion","Some pods burst open, but winged seeds drift away chiefly on the wind.")]),

 ("RP","Some seeds, such as those of Xanthium, have tiny hooks or spines that cling to the fur of passing animals. These seeds are dispersed by:",
   "animals",
   C("Hooked seeds catch onto animal fur and are carried far before dropping off.")+
   steps("The seed has small hooks or spines","they catch onto a passing animal's coat","the animal carries the seed away — dispersal by animals."),
   [("wind","Hooked seeds are too heavy to drift; wind carries light, winged seeds instead."),
    ("water","These hooked seeds cling to fur, not float on water; water carries floating seeds."),
    ("the plant itself","The plant cannot walk; an animal carries the hooked seed away.")]),

 ("RP","A coconut can float on the sea for a long way before sprouting on a distant shore. Such floating seeds are dispersed by:",
   "water",
   C("Light, floating seeds and fruits are carried by water to new places.")+
   steps("The coconut's husk traps air and floats","sea or river currents carry it along","it lands far away — dispersal by water."),
   [("wind","A coconut is too heavy for the wind; it travels by floating on water."),
    ("insects","Insects carry pollen, not heavy floating coconuts; water disperses these."),
    ("magnetism","Seeds are not magnetic; the coconut is carried by floating on water.")]),

 ("RP","Seed dispersal — the scattering of seeds away from the parent plant — is important mainly because it prevents the new plants from:",
   "overcrowding and competing for the same space, water and light",
   C("Spreading seeds out gives each new plant room, water and light of its own.")+
   steps("If all seeds fell at the parent's foot they would be crammed together","they would fight for the same water, light and minerals","dispersal spreads them out to avoid this overcrowding."),
   [("ever making flowers","Dispersal does not stop flowering; it stops the seedlings from crowding each other."),
    ("growing roots at all","Dispersed seeds still grow roots; dispersal simply avoids overcrowding."),
    ("being eaten by anything","Dispersal does not make seeds uneatable; it spreads them to avoid crowding.")]),

 ("RP","A money-plant grown by placing a cut piece of its stem in water, where it forms roots and grows, is an example of:",
   "vegetative propagation",
   C("Growing a whole new plant from a stem cutting is a form of vegetative propagation.")+
   steps("A piece of stem is cut from the parent","it is kept in water or soil and grows roots","a new plant develops — vegetative propagation."),
   [("pollination","Pollination is pollen transfer in flowers, not growing a plant from a stem cutting."),
    ("fertilisation","Fertilisation joins two cells; here the new plant grows directly from a stem piece."),
    ("seed germination","No seed is involved; the new plant grows from a stem cutting, which is vegetative propagation.")]),
]

# ---------- INTEGERS (25) — Maths ----------
IN = [
 ("IN","The collection of numbers that includes the positive whole numbers, zero and the negative whole numbers — such as …, −2, −1, 0, 1, 2, … — is called the:",
   "integers",
   C("Integers are the whole numbers together with their negatives and zero.")+
   steps("Take the counting numbers 1, 2, 3 …","add zero and the negatives −1, −2, −3 …","together they form the integers."),
   [("fractions","Fractions are parts of a whole like 1/2; integers are whole numbers and their negatives."),
    ("decimals","Decimals such as 0.5 are not integers; integers have no fractional part."),
    ("only positive numbers","Integers include the negatives and zero too, not just the positive numbers.")]),

 ("IN","Among all the integers, the one number that is neither positive nor negative is:",
   "0",
   C("Zero sits exactly between the positives and negatives, belonging to neither side.")+
   steps("Positive integers are to the right of zero","negative integers are to its left","zero itself is in the middle — neither positive nor negative."),
   [("1","1 is a positive integer, sitting to the right of zero."),
    ("−1","−1 is a negative integer, sitting to the left of zero."),
    ("10","10 is a positive integer; the number that is neither positive nor negative is 0.")]),

 ("IN","On a number line drawn in the usual way, the integers that lie to the left of zero are all:",
   "negative",
   C("Everything to the left of zero on the number line is a negative integer.")+
   steps("Zero is marked in the middle","numbers grow larger to the right and smaller to the left","so those on the left of zero are negative."),
   [("positive","Positive integers lie to the right of zero, not the left."),
    ("zero","Only one point is zero; the whole stretch to its left is negative."),
    ("fractions","The marks to the left of zero are negative integers, not fractions.")]),

 ("IN","When you add two negative integers together, such as (−3) + (−4), the answer is always:",
   "negative",
   C("Adding two negatives moves further left of zero, giving a negative sum.")+
   steps("Start at −3 on the number line","add another −4 means move 4 more steps left","you land on −7, which is negative."),
   [("positive","Two negatives added together move further into the negatives, not into the positives."),
    ("zero","(−3) + (−4) = −7, which is not zero; two negatives give a negative sum."),
    ("either positive or negative","Adding two negatives always gives a negative; the sign is never in doubt.")]),

 ("IN","The value of (−5) + 8 is:",
   "3",
   C("Adding a larger positive to a smaller negative lands you on the positive side.")+
   steps("Start at −5 on the number line","move 8 steps to the right (add 8)","you reach +3."),
   [("−3","Moving 8 right from −5 passes zero and reaches +3, not −3."),
    ("13","That adds 5 and 8 ignoring the minus sign; with the sign it is −5 + 8 = 3."),
    ("−13","That adds the two as if both were negative; correctly −5 + 8 = 3.")]),

 ("IN","Adding the two negatives in (−6) + (−9) gives a result of:",
   "−15",
   C("Adding two negatives means going further left, so the magnitudes add and the sign stays negative.")+
   steps("Both numbers are negative","add their sizes: 6 + 9 = 15","keep the negative sign, giving −15."),
   [("15","Two negatives add to a negative; the answer is −15, not +15."),
    ("−3","That subtracts 6 from 9; adding two negatives means 6 + 9 = 15, so −15."),
    ("3","That subtracts and drops the sign; (−6) + (−9) = −15.")]),

 ("IN","The value of 7 − 10 is:",
   "−3",
   C("Subtracting a larger number from a smaller one crosses below zero.")+
   steps("Start at 7 on the number line","move 10 steps to the left (subtract 10)","you pass zero and land on −3."),
   [("3","Taking 10 from 7 goes below zero to −3, not up to +3."),
    ("17","That adds 7 and 10; the question subtracts, giving 7 − 10 = −3."),
    ("−17","That adds the two as negatives; correctly 7 − 10 = −3.")]),

 ("IN","Working out (−4) − (−9), where subtracting a negative turns into adding, gives:",
   "5",
   C("Subtracting a negative is the same as adding its positive.")+
   steps("(−4) − (−9) becomes (−4) + 9","start at −4 and move 9 steps right","you reach +5."),
   [("−13","That treats −(−9) as −9; subtracting a negative adds, giving −4 + 9 = 5."),
    ("−5","That keeps the wrong sign; −4 + 9 = 5, a positive answer."),
    ("13","That adds 4 and 9 as positives; correctly −4 + 9 = 5.")]),

 ("IN","The product (−3) × 4 works out to:",
   "−12",
   C("A negative times a positive gives a negative product.")+
   steps("Multiply the sizes: 3 × 4 = 12","a negative times a positive is negative","so the answer is −12."),
   [("12","A negative times a positive is negative, so it is −12, not +12."),
    ("−7","That adds 3 and 4; the question multiplies, giving −12."),
    ("1","That subtracts 3 from 4; the question multiplies, giving (−3) × 4 = −12.")]),

 ("IN","The value of (−5) × (−6) is:",
   "30",
   C("A negative times a negative gives a positive product.")+
   steps("Multiply the sizes: 5 × 6 = 30","a negative times a negative is positive","so the answer is +30."),
   [("−30","Two negatives multiplied give a positive, so it is +30, not −30."),
    ("−11","That adds 5 and 6 with a sign; the question multiplies, giving +30."),
    ("11","That adds 5 and 6; multiplying gives (−5) × (−6) = 30.")]),

 ("IN","When two negative integers are multiplied together, the product is always:",
   "positive",
   C("Multiplying two negatives cancels the minus signs, giving a positive result.")+
   steps("A negative times a negative reverses sign twice","two reversals bring you back to positive","so the product is positive."),
   [("negative","Two negatives multiplied give a positive, not a negative."),
    ("zero","Unless one factor is zero, two negatives multiply to a positive, not zero."),
    ("sometimes negative","The product of two negatives is always positive, never negative.")]),

 ("IN","Dividing (−20) ÷ 5 gives a quotient of:",
   "−4",
   C("A negative divided by a positive gives a negative quotient.")+
   steps("Divide the sizes: 20 ÷ 5 = 4","a negative divided by a positive is negative","so the answer is −4."),
   [("4","A negative divided by a positive is negative, so it is −4, not +4."),
    ("−15","That subtracts 5 from 20; the question divides, giving −4."),
    ("−100","That multiplies 20 by 5; the question divides, giving (−20) ÷ 5 = −4.")]),

 ("IN","The value of (−36) ÷ (−6) is:",
   "6",
   C("A negative divided by a negative gives a positive quotient.")+
   steps("Divide the sizes: 36 ÷ 6 = 6","a negative divided by a negative is positive","so the answer is +6."),
   [("−6","A negative divided by a negative is positive, so it is +6, not −6."),
    ("−42","That subtracts wrongly; the question divides, giving 36 ÷ 6 = 6."),
    ("30","That subtracts 6 from 36; the question divides, giving (−36) ÷ (−6) = 6.")]),

 ("IN","The additive inverse (the number that you add to it to get zero) of the integer 7 is:",
   "−7",
   C("The additive inverse of a number is the one that brings it back to zero when added.")+
   steps("We need a number that gives 7 + ? = 0","that number must be −7","since 7 + (−7) = 0."),
   [("7","7 + 7 = 14, not zero; the additive inverse of 7 is −7."),
    ("0","7 + 0 = 7, not zero; the inverse that gives zero is −7."),
    ("1/7","1/7 is the multiplying inverse; the adding inverse of 7 is −7.")]),

 ("IN","On the number line, the integer that comes just to the right of −1 (one step larger) is:",
   "0",
   C("Moving one step right on the number line adds 1.")+
   steps("Start at −1","take one step to the right, which adds 1","−1 + 1 = 0."),
   [("−2","−2 is one step to the left of −1, which is smaller, not larger."),
    ("1","1 is two steps to the right of −1; just one step right lands on 0."),
    ("−1","That stays put; one step right from −1 lands on 0.")]),

 ("IN","Among the integers −3, −7, 2 and 0, the greatest (largest) one is:",
   "2",
   C("On the number line the number furthest to the right is the greatest.")+
   steps("Place them on a number line: −7, −3, 0, 2","the one furthest right is 2","so 2 is the greatest."),
   [("0","0 is greater than the negatives but less than 2; the greatest is 2."),
    ("−3","−3 is negative, so it is less than 0 and less than 2."),
    ("−7","−7 is the smallest here, furthest to the left, not the greatest.")]),

 ("IN","At dawn a hill station reads −5°C. By noon the temperature has risen by 8°C. Treating the rise as adding +8, the noon temperature is:",
   "3°C",
   C("A rise in temperature means adding to the starting value, even when it begins below zero.")+
   steps("Start at −5°C","a rise of 8°C means −5 + 8","= 3°C."),
   [("−13°C","A rise adds, so −5 + 8 = 3°C; subtracting would wrongly give −13°C."),
    ("13°C","That ignores the minus sign on −5; −5 + 8 = 3°C, not 13°C."),
    ("−3°C","That keeps a minus sign by mistake; −5 + 8 = +3°C.")]),

 ("IN","One evening a town is at 4°C. Overnight the temperature falls by 10°C. Treating the fall as subtracting 10, the morning temperature is:",
   "−6°C",
   C("A fall in temperature means subtracting, which can take the value below zero.")+
   steps("Start at 4°C","a fall of 10°C means 4 − 10","= −6°C."),
   [("6°C","Taking 10 from 4 goes below zero to −6°C, not up to +6°C."),
    ("14°C","A fall subtracts, so 4 − 10 = −6°C; adding would wrongly give 14°C."),
    ("−14°C","That adds the two as negatives; correctly 4 − 10 = −6°C.")]),

 ("IN","A deep freezer is kept at −12°C. When its door is left open, the inside warms up by 5°C. Adding +5, the new temperature is:",
   "−7°C",
   C("Warming up means adding degrees, moving the value towards (but here not past) zero.")+
   steps("Start at −12°C","a warming of 5°C means −12 + 5","= −7°C."),
   [("−17°C","Warming adds, so −12 + 5 = −7°C; subtracting would wrongly give −17°C."),
    ("7°C","That drops the minus sign; −12 + 5 is still below zero at −7°C."),
    ("−5°C","That subtracts wrongly; −12 + 5 = −7°C, not −5°C.")]),

 ("IN","When any integer is multiplied by (−1), the result you obtain is:",
   "the same number with its sign changed",
   C("Multiplying by −1 simply flips a number to its opposite.")+
   steps("Take any number, say 6","multiply by −1 to get −6","the size stays, only the sign flips."),
   [("zero every time","Multiplying by −1 flips the sign; only multiplying by 0 gives zero."),
    ("the same number unchanged","Multiplying by +1 leaves it unchanged; −1 flips its sign."),
    ("always a positive number","Multiplying by −1 flips the sign, so a positive becomes negative, not always positive.")]),

 ("IN","The value of 0 × (−8) is:",
   "0",
   C("Any number multiplied by zero is zero, whatever its sign.")+
   steps("Zero groups of anything is nothing","0 × (−8) means zero lots of −8","so the answer is 0."),
   [("−8","Multiplying by zero gives zero, not −8."),
    ("8","Multiplying by zero gives zero; the sign does not matter."),
    ("−80","Multiplying by zero gives 0, not −80.")]),

 ("IN","The value of (−15) + 15 is:",
   "0",
   C("A number added to its additive inverse gives zero.")+
   steps("Start at −15","add 15 means move 15 steps right","you land exactly on 0."),
   [("30","That adds the sizes ignoring the signs; −15 + 15 = 0."),
    ("−30","That adds both as negatives; correctly −15 + 15 = 0."),
    ("1","Adding a number to its opposite gives 0, not 1.")]),

 ("IN","The number that must be added to −8 to give a total of 0 is:",
   "8",
   C("To reach zero you add the additive inverse of the number.")+
   steps("We need −8 + ? = 0","the number must cancel the −8","that number is +8, since −8 + 8 = 0."),
   [("−8","−8 + (−8) = −16, not zero; you need +8 to reach 0."),
    ("0","−8 + 0 = −8, not zero; you need +8."),
    ("16","−8 + 16 = 8, not zero; the right number is +8.")]),

 ("IN","On a cold day a kitchen is at 6°C while the freezer is at −4°C. The difference between these two temperatures (kitchen minus freezer) is:",
   "10°C",
   C("The difference is found by subtracting, and subtracting a negative adds.")+
   steps("Difference = 6 − (−4)","subtracting −4 is the same as adding 4: 6 + 4","= 10°C."),
   [("2°C","That works 6 − 4 instead of 6 − (−4); subtracting the negative gives 6 + 4 = 10°C."),
    ("−10°C","Distance between temperatures is taken as a positive gap; 6 − (−4) = 10°C."),
    ("24°C","That multiplies 6 by 4; the difference is 6 − (−4) = 10°C.")]),

 ("IN","The property shown when 5 + (−5) = 0 — that every integer has an opposite which adds to give zero — is the:",
   "additive inverse property",
   C("Each integer pairs with its opposite, and the two add to zero.")+
   steps("5 has the opposite −5","adding them: 5 + (−5) = 0","this opposite-adds-to-zero rule is the additive inverse property."),
   [("multiplicative inverse property","That is about a number times its reciprocal giving 1, not adding to give 0."),
    ("distributive property","The distributive property spreads multiplication over addition, not this opposite-to-zero rule."),
    ("closure property","Closure says the answer stays an integer; this rule is about opposites adding to zero.")]),
]

# ---------- SYMMETRY (25) — Maths ----------
SY = [
 ("SY","A figure that can be folded along a line so that its two halves fall exactly on top of each other is said to have:",
   "line symmetry",
   C("Line symmetry means a fold makes the two halves match perfectly.")+
   steps("Fold the figure along a chosen line","check whether the two halves cover each other exactly","if they do, the figure has line symmetry."),
   [("no symmetry","If the halves match on folding, the figure does have symmetry, not none."),
    ("rotational symmetry only","Folding tests line symmetry; rotational symmetry is about turning, not folding."),
    ("curved symmetry","There is no such term; matching halves on a fold means line symmetry.")]),

 ("SY","The line along which a figure is folded so that the two halves match exactly is called its:",
   "line of symmetry",
   C("The fold-line that splits a figure into matching halves is its line of symmetry.")+
   steps("Find the fold that makes the halves match","mark that fold as a line","it is the line (or axis) of symmetry."),
   [("number line","A number line is for plotting numbers, not the fold-line of a symmetric figure."),
    ("base line","'Base line' is not the term; the matching fold-line is the line of symmetry."),
    ("diagonal only","A line of symmetry need not be a diagonal; it is simply the matching fold-line.")]),

 ("SY","The number of lines of symmetry that a square has is:",
   "4",
   C("A square folds onto itself along four different lines.")+
   steps("Fold a square top-to-bottom and side-to-side: 2 lines","fold along each diagonal: 2 more lines","that makes 4 lines of symmetry."),
   [("2","A square has more than 2; both midlines and both diagonals work, giving 4."),
    ("1","A square has 4 lines of symmetry, not just 1."),
    ("0","A square is highly symmetric, with 4 lines of symmetry, not 0.")]),

 ("SY","The number of lines of symmetry that a rectangle (which is not a square) has is:",
   "2",
   C("A rectangle folds onto itself along its two midlines only.")+
   steps("Fold a rectangle across its width: it matches","fold it across its length: it matches","but the diagonals do not match — so 2 lines."),
   [("4","A non-square rectangle's diagonals do not give symmetry, so it has 2, not 4."),
    ("1","A rectangle has 2 lines of symmetry, one through each pair of opposite sides."),
    ("0","A rectangle does have symmetry — 2 lines through its midpoints.")]),

 ("SY","The number of lines of symmetry that an equilateral triangle has is:",
   "3",
   C("An equilateral triangle folds onto itself along a line from each corner to the opposite side.")+
   steps("From each of the 3 corners draw a fold to the middle of the opposite side","each such fold makes the halves match","so there are 3 lines of symmetry."),
   [("1","An equilateral triangle has 3 lines; an isosceles triangle has just 1."),
    ("2","An equilateral triangle has 3 lines of symmetry, not 2."),
    ("0","An equilateral triangle is symmetric, with 3 lines, not 0.")]),

 ("SY","The number of lines of symmetry that a circle has is:",
   "infinitely many",
   C("Any line through the centre of a circle splits it into matching halves.")+
   steps("Draw any straight line through the circle's centre","the two halves always match exactly","since there are endless such lines, the circle has infinitely many."),
   [("only 1","A circle has far more than one; any line through its centre works, so infinitely many."),
    ("4","A circle is not limited to 4; every line through its centre is a line of symmetry."),
    ("0","A circle is the most symmetric shape, with infinitely many lines, not 0.")]),

 ("SY","The line of symmetry of the capital letter A is:",
   "a vertical line down the middle",
   C("Folding A down a central vertical line makes its two halves match.")+
   steps("Look at the letter A","fold it down the middle from top to bottom","the left and right halves match — a vertical line of symmetry."),
   [("a horizontal line across the middle","A folded across the middle does not match top to bottom; its symmetry line is vertical."),
    ("a diagonal line","A's matching fold is vertical, not along a slanting diagonal."),
    ("no line at all","The letter A does have a vertical line of symmetry.")]),

 ("SY","The number of lines of symmetry that the capital letter H has is:",
   "2",
   C("H matches when folded both vertically and horizontally.")+
   steps("Fold H down the middle: the halves match (1)","fold H across the middle: the halves match (2)","so H has 2 lines of symmetry."),
   [("1","H has both a vertical and a horizontal line of symmetry, giving 2."),
    ("0","H is symmetric in two ways; it has 2 lines, not 0."),
    ("4","H matches only on its vertical and horizontal folds, giving 2, not 4.")]),

 ("SY","The number of lines of symmetry that an isosceles triangle (two equal sides) has is:",
   "1",
   C("An isosceles triangle folds onto itself along just one line — through its apex.")+
   steps("Fold from the top corner straight down to the middle of the base","the two equal sides match","but no other fold works, so there is 1 line."),
   [("3","Three lines belong to the equilateral triangle; an isosceles one has just 1."),
    ("2","An isosceles triangle has only 1 line of symmetry, not 2."),
    ("0","An isosceles triangle does have symmetry — exactly 1 line.")]),

 ("SY","The number of lines of symmetry that a scalene triangle (all sides different) has is:",
   "0",
   C("With every side a different length, no fold can make the halves match.")+
   steps("Try folding the triangle any way you like","because all sides differ, no two halves ever match","so it has 0 lines of symmetry."),
   [("1","A scalene triangle has no matching fold, so 0 lines, not 1."),
    ("3","Three lines belong to the equilateral triangle, not the all-different scalene one."),
    ("infinitely many","Only a circle has infinitely many; a scalene triangle has none.")]),

 ("SY","When a figure is turned about a fixed point and still looks exactly the same before a full turn is complete, it is said to have:",
   "rotational symmetry",
   C("Rotational symmetry means the figure looks unchanged after a partial turn about a point.")+
   steps("Spin the figure about a central point","if it looks the same again before a full circle","it has rotational symmetry."),
   [("line symmetry","Line symmetry is about folding; this one is about turning the figure."),
    ("no symmetry","Looking the same after a partial turn does count as symmetry — rotational symmetry."),
    ("translation symmetry","Translation is sliding; here the figure is being turned, so it is rotational symmetry.")]),

 ("SY","The fixed point about which a figure is rotated when we test its rotational symmetry is called the:",
   "centre of rotation",
   C("The centre of rotation is the still point the figure spins around.")+
   steps("Pin the figure at one point","spin it around that point","that fixed pivot is the centre of rotation."),
   [("line of symmetry","A line of symmetry is a fold-line, not the point a figure spins about."),
    ("vertex only","The pivot need not be a vertex; it is whatever fixed point the figure turns about."),
    ("midpoint of a side","The turning point is the centre of rotation, not necessarily a side's midpoint.")]),

 ("SY","As a square is turned through one full circle about its centre, the number of times it looks exactly the same (its order of rotational symmetry) is:",
   "4",
   C("A square matches its starting look four times in one full turn.")+
   steps("Turn the square by 90° — it looks the same","keep turning by 90° each time","in one full turn it matches 4 times — order 4."),
   [("1","A square matches 4 times in a full turn, not just once."),
    ("2","A square has order 4; order 2 belongs to a rectangle."),
    ("8","A square matches every 90°, which is 4 times in 360°, not 8.")]),

 ("SY","The smallest angle through which a square must be turned about its centre to look exactly the same again is:",
   "90°",
   C("A square repeats its look every quarter turn, which is 90°.")+
   steps("A full turn is 360°","a square matches 4 times in that turn","360° ÷ 4 = 90°."),
   [("45°","Turning a square by 45° does not bring it back to looking the same; 90° does."),
    ("180°","A square matches before 180°, at every 90°."),
    ("360°","A full 360° turn brings any figure back; the square matches sooner, at 90°.")]),

 ("SY","A figure that looks exactly the same after a half turn (a turn of 180°) about its centre has rotational symmetry of order:",
   "2",
   C("Matching at a half turn means it matches twice in a full turn — order 2.")+
   steps("Turn the figure 180° — it looks the same","turn another 180° to complete the circle — same again","that is 2 matches, so order 2."),
   [("1","Order 1 means it matches only after a full turn; matching at 180° makes it order 2."),
    ("4","Order 4 needs a match every 90°; matching only at 180° is order 2."),
    ("3","Order 3 needs a match every 120°; a half-turn match is order 2.")]),

 ("SY","A regular five-petalled flower looks just like a regular pentagon shape. The number of lines of symmetry it has is:",
   "5",
   C("A regular five-sided shape has one line of symmetry through each petal, giving five.")+
   steps("A regular pentagon-like flower has 5 equal petals","a fold from each petal to the opposite gap makes the halves match","so there are 5 lines of symmetry."),
   [("1","A regular five-petalled flower has 5 lines of symmetry, not just 1."),
    ("2","Five equal petals give 5 lines of symmetry, not 2."),
    ("10","A regular pentagon shape has 5 lines of symmetry, not 10.")]),

 ("SY","When a simple leaf is folded along its midrib (the central vein), the two halves match. For that leaf the midrib acts as a:",
   "line of symmetry",
   C("The midrib is the fold-line that splits many leaves into matching halves.")+
   steps("Fold the leaf along its central vein","the left and right halves cover each other","so the midrib is a line of symmetry."),
   [("centre of rotation","The midrib is a fold-line, not a point the leaf spins about."),
    ("diagonal of a square","The leaf's matching fold is its midrib, not a square's diagonal."),
    ("axis of rotation","Folding tests line symmetry; the midrib is a line of symmetry, not a rotation axis.")]),

 ("SY","The two wings of a butterfly are mirror images of each other. The line of symmetry of the butterfly passes:",
   "down the middle of its body",
   C("A butterfly's line of symmetry runs along its body, separating the matching left and right wings.")+
   steps("Look at the butterfly from above","fold it down the middle of its body","the two wings match — that midline is the line of symmetry."),
   [("across the tips of the wings","A fold across the wing tips would not match the head to the tail; the line runs down the body."),
    ("around the edge of a wing","A line of symmetry is a straight fold-line, not a path around a wing's edge."),
    ("through one wing only","The line must separate the two matching wings, so it runs down the central body.")]),

 ("SY","A figure that looks the same only after a complete full turn of 360° (and at no smaller turn) is said to have rotational symmetry of order:",
   "1",
   C("Order 1 means the only turn that restores its look is a full turn — effectively no rotational symmetry.")+
   steps("Turn the figure a little — it looks different","only after a complete 360° turn does it look the same again","matching once in a full turn is order 1."),
   [("0","Every figure matches itself after a full turn, so the lowest order is 1, not 0."),
    ("2","Order 2 needs a match at a half turn; matching only at a full turn is order 1."),
    ("4","Order 4 needs a match every quarter turn; matching only at 360° is order 1.")]),

 ("SY","The image of a shape seen in a mirror placed along a line, flipped to the other side of that line, is called its:",
   "reflection",
   C("A reflection is the mirror-flipped copy of a shape across a line.")+
   steps("Place a mirror line beside the shape","each point flips to the same distance on the other side","the flipped copy is the reflection."),
   [("rotation","A rotation turns a shape about a point; a mirror flip across a line is a reflection."),
    ("translation","A translation slides a shape without flipping; a mirror gives a reflection."),
    ("enlargement","An enlargement changes size; a mirror simply flips the shape — a reflection.")]),

 ("SY","The number of lines of symmetry that a regular hexagon (six equal sides) has is:",
   "6",
   C("A regular hexagon has one line of symmetry for each of its six matching positions.")+
   steps("A regular hexagon has 6 equal sides and corners","folds through opposite corners and opposite side-midpoints both match","altogether that gives 6 lines of symmetry."),
   [("3","A regular hexagon has 6 lines of symmetry, not 3."),
    ("4","Four lines belong to a square; a regular hexagon has 6."),
    ("12","A regular hexagon has 6 lines of symmetry, not 12.")]),

 ("SY","The capital letter S looks the same after a half turn about its centre but cannot be folded into matching halves. So the letter S has:",
   "rotational symmetry but no line symmetry",
   C("S matches after a 180° turn, yet no fold gives matching halves.")+
   steps("Turn S by 180° — it looks the same, so it has rotational symmetry","try to fold S any way — the halves never match","so it has rotational symmetry but no line symmetry."),
   [("line symmetry but no rotational symmetry","S cannot be folded to match, so it has no line symmetry; it does have rotational symmetry."),
    ("both line and rotational symmetry","S has no matching fold, so it lacks line symmetry, though it has rotational symmetry."),
    ("neither kind of symmetry","S does match after a half turn, so it has rotational symmetry.")]),

 ("SY","A rangoli pattern whose left half is the exact mirror image of its right half is showing:",
   "line symmetry",
   C("When one half mirrors the other across a line, the pattern has line symmetry.")+
   steps("Imagine a fold-line down the middle of the rangoli","the left half lands exactly on the right half","so the pattern has line symmetry."),
   [("rotational symmetry only","Mirror-matching halves show line symmetry; rotational symmetry is about turning."),
    ("no symmetry","Mirror-image halves are a clear sign of symmetry — line symmetry."),
    ("translation only","Translation is sliding; mirror-image halves show line symmetry.")]),

 ("SY","An equilateral triangle is turned about its centre through one full circle. The number of times it looks exactly the same (its order of rotational symmetry) is:",
   "3",
   C("An equilateral triangle matches its starting look three times in a full turn.")+
   steps("Turn the triangle by 120° — it looks the same","turn 120° again, and once more","in a full turn it matches 3 times — order 3."),
   [("1","An equilateral triangle matches 3 times in a full turn, not just once."),
    ("2","Order 2 belongs to shapes that match every half turn; this triangle is order 3."),
    ("6","An equilateral triangle matches every 120°, which is 3 times, not 6.")]),

 ("SY","The number of lines of symmetry that a rhombus (a slanted four-sided shape with all sides equal) has is:",
   "2",
   C("A rhombus folds onto itself along its two diagonals only.")+
   steps("Fold a rhombus along one diagonal: the halves match","fold along the other diagonal: they match again","but its midlines do not match — so 2 lines of symmetry."),
   [("4","Four lines belong to a square; a slanted rhombus matches only along its 2 diagonals."),
    ("1","A rhombus has 2 lines of symmetry, one along each diagonal, not just 1."),
    ("0","A rhombus is symmetric along both its diagonals, giving 2 lines, not 0.")]),
]

# ---------- use-case lines (25 each) ----------
HE_UC = [
 "Reading a temperature lets you decide whether to wear a coat or run the fan.",
 "Every doctor, cook and weather report depends on a thermometer to read temperature.",
 "A clinical thermometer is what tells a parent whether a child really has a fever.",
 "Knowing 37°C is normal lets you spot a fever the moment the reading climbs above it.",
 "The kink is why a clinical thermometer still shows the right reading after it leaves the mouth.",
 "Science labs reach for a laboratory thermometer to track water heating far past body warmth.",
 "Knowing heat flows hot-to-cold explains why a hot drink always cools, never warms, on the table.",
 "Conduction is why a metal ladle left in a pot soon gets too hot to hold.",
 "Choosing good conductors matters when you want a pan to spread a stove's heat evenly.",
 "Insulators are why oven mitts and wooden spoons keep your hands from burning.",
 "Convection is why a room heater warms the whole room as warm air rises and circulates.",
 "Radiation is why you feel the Sun's warmth on your face even on a cold, still day.",
 "Light summer clothes keep you cooler by reflecting the Sun's heat away.",
 "Dark winter clothes help you feel warmer by soaking up the Sun's heat.",
 "The cool daytime sea breeze is what makes a beach pleasant on a hot afternoon.",
 "The night-time land breeze is why coastal evenings often feel a gentle wind off the shore.",
 "Trapped air in wool is why a light sweater can keep you so warm.",
 "Layering two thin blankets traps air and can beat one thick blanket on a cold night.",
 "Mercury's even rise is what lets a thermometer give a steady, readable temperature.",
 "Shaking down a clinical thermometer first is why the next reading starts honest, not stuck high.",
 "Conduction along a spoon is the everyday reason a spoon left in hot tea heats up.",
 "Insulating handles on pans are a safety design you rely on at every meal you cook.",
 "A clinical thermometer's narrow 35–42°C scale is tuned exactly to the range a body can reach.",
 "Thermal expansion is why engineers leave small gaps in metal railway tracks and bridges.",
 "Seeing heat as flowing energy explains every kettle, fridge and radiator in your home.",
]

RP_UC = [
 "Reproduction is why gardens, forests and farms can keep going generation after generation.",
 "Asexual reproduction is how a single cutting can quickly fill a pot with new plants.",
 "Sexual reproduction and its seeds are what give a field its mix of healthy, varied crops.",
 "Budding in yeast is the very process that makes bread rise and dough double in size.",
 "Farmers plant potato pieces with eyes to grow a whole new crop without buying seeds.",
 "Gardeners multiply Bryophyllum and many house plants straight from their leaves.",
 "Spores are how ferns and mushrooms spread across a damp forest floor without seeds.",
 "Knowing the stamen is the male part helps you understand how a flower makes pollen.",
 "Spotting the pistil tells you which part of a flower will grow into the fruit.",
 "The sticky stigma is the landing pad that decides whether a flower gets pollinated.",
 "Knowing pollen comes from the anther explains the yellow dust bees carry between flowers.",
 "Understanding pollination explains why bees and gardens depend on each other.",
 "Self-pollination lets a lone plant set seed even when no other plant is nearby.",
 "Cross-pollination mixes traits, which is how farmers breed tastier or hardier crops.",
 "Knowing wind, water and insects carry pollen explains why orchards keep beehives close.",
 "Realising the ovary becomes the fruit explains where the apple on your plate came from.",
 "Knowing the ovule becomes the seed explains the pips you find inside that apple.",
 "Fertilisation is the exact moment a flower's promise turns into a future seed.",
 "Spotting a bisexual flower tells a gardener it can often pollinate itself.",
 "Recognising unisexual flowers explains why papaya and some plants need partners to fruit.",
 "Winged seeds drifting on the breeze are why maple and drumstick spread so far from the tree.",
 "Hooked seeds catching on socks and fur are nature's way of hitching a free ride.",
 "A coconut floating ashore is how palm trees colonise far-off island beaches.",
 "Seed dispersal is why a whole forest never sprouts crammed under one parent tree.",
 "Growing a money plant from a stem cutting is the easiest plant most children ever raise.",
]

IN_UC = [
 "Integers let us count both what we have and what we owe, above and below zero.",
 "Zero is the dividing mark on every thermometer, lift panel and bank balance.",
 "Negative marks left of zero are how a number line shows debts and below-zero temperatures.",
 "Adding two negatives is how losses pile up when you owe on two separate bills.",
 "Working −5 + 8 is the everyday sum of a debt being cleared and a little left over.",
 "Adding two negative temperatures or debts is daily arithmetic for shopkeepers and scientists.",
 "Computing 7 − 10 is how you find an overdraft when you spend more than you have.",
 "Subtracting a negative shows up when a debt is cancelled and your balance jumps up.",
 "Negative times positive is how repeated losses are totalled in seconds on a calculator.",
 "Negative times negative going positive is a rule banks and physicists both rely on.",
 "Knowing two negatives multiply to a positive keeps your sign right in every formula.",
 "Dividing a negative by a positive shares a single loss out into equal smaller losses.",
 "Dividing a negative by a negative is how you find how many equal debts make a total.",
 "Additive inverses are how a deposit of ₹7 exactly cancels a debt of ₹7.",
 "Stepping one to the right on a number line is the basic move behind every count-up.",
 "Comparing integers is how you rank temperatures, scores and balances from least to greatest.",
 "Adding a sunrise rise to a below-zero start is real winter-morning temperature maths.",
 "Subtracting an overnight fall is exactly how a weather app drops a reading below zero.",
 "Adding warmth to a freezer's −12°C is the sum a fridge engineer does every day.",
 "Multiplying by −1 is the quick flip that turns a credit into a debit and back.",
 "Multiplying by zero reminds us that no matter the price, zero items cost nothing.",
 "A number plus its opposite giving zero is how every balanced account settles to nil.",
 "Finding what to add to reach zero is how you work out the exact payment to clear a debt.",
 "The gap between a warm room and a cold freezer is found by subtracting a negative.",
 "The additive-inverse rule is the backbone of solving equations and balancing accounts.",
]

SY_UC = [
 "Line symmetry is why folded paper cut-outs open into perfectly balanced shapes.",
 "Architects mark a line of symmetry to keep a building's front balanced left and right.",
 "A square's four lines of symmetry guide tile and floor patterns in homes everywhere.",
 "A rectangle's two lines of symmetry help carpenters cut doors and tables evenly.",
 "An equilateral triangle's three lines show up in road signs and warning boards.",
 "A circle's endless symmetry is why wheels, plates and coins look the same from every side.",
 "Spotting A's vertical line helps designers space and balance letters on a sign.",
 "H's two lines of symmetry make it one of the most balanced letters in any logo.",
 "An isosceles triangle's single line shapes tents, roofs and many warning signs.",
 "Knowing a scalene triangle has no symmetry warns a designer it will always look lopsided.",
 "Rotational symmetry is why a fan or wheel looks the same as it spins.",
 "The centre of rotation is the hub every wheel, fan and turntable spins around.",
 "A square's order-4 rotational symmetry is why a square tile fits four ways in its space.",
 "Knowing a square repeats every 90° helps you lay tiles without spotting a wrong turn.",
 "Order-2 symmetry is why playing-card designs read the same upside down.",
 "A five-petalled flower's five lines of symmetry are a favourite example from nature.",
 "Folding a leaf along its midrib is the simplest symmetry test a child can do outdoors.",
 "A butterfly's body-line symmetry is one of nature's most beautiful balanced designs.",
 "Order-1 'symmetry' is a neat way of saying a shape has no real rotational symmetry.",
 "Reflections across a line are how mirrors, water and design software flip an image.",
 "A regular hexagon's six lines of symmetry are why honeycomb cells pack so neatly.",
 "S having rotational but no line symmetry is a classic puzzle about the two kinds.",
 "Rangoli and mehndi artists use line symmetry to make both halves match beautifully.",
 "A rhombus's two diagonal lines of symmetry guide the cut of many diamond-shaped tiles and kites.",
 "An equilateral triangle's order-3 turning symmetry shows in three-bladed logos and signs.",
]


def _with_uc(lst, ucs):
    assert len(lst) == len(ucs) == 25
    out = []
    for it, uc in zip(lst, ucs):
        code, stem, correct, html, distr = it
        out.append((code, stem, correct, html + U(uc), distr))
    return out


HE = _with_uc(HE, HE_UC)
RP = _with_uc(RP, RP_UC)
IN = _with_uc(IN, IN_UC)
SY = _with_uc(SY, SY_UC)

items = []
for i in range(25):
    items += [HE[i], RP[i], IN[i], SY[i]]
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

    keydist = build_paper(PNUM, TITLE, SHORT, LABELS, items, seed=28503,
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
    split = "/".join(str(counts[c]) for c in ("HE", "RP", "IN", "SY"))
    with open("PAPERS_MANIFEST.md", "a", encoding="utf-8") as fh:
        fh.write(f"| {PNUM} | 2026-06-18 | {TITLE} | {split} | ✓ |\n")

    # ---- update QUESTION_INDEX.json ----
    idx["fingerprints"] = sorted(existing | set(new_fps))
    idx.setdefault("combos", []).append({
        "paper": PNUM,
        "chapters": ["Heat",
                     "Reproduction in Plants",
                     "Integers",
                     "Symmetry"],
    })
    idx["papers"] = idx.get("papers", 0) + 1
    with open(idx_path, "w", encoding="utf-8") as fh:
        json.dump(idx, fh, ensure_ascii=False, indent=2)
        fh.write("\n")

    print("Files:", sorted(v for v in moves.values()))
    print("Answer key spread A/B/C/D =", dict(keydist))
    print("Fingerprints added:", len(new_fps))
