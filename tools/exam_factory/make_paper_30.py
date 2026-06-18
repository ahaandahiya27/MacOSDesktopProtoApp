# -*- coding: utf-8 -*-
# Boss Challenge Paper 30 — Winds, Storms & Cyclones · Nutrition in Animals · Data Handling · Perimeter & Area
# Content-only. Uses the dependency-free examfactory engine.
# Difficulty ramp: this paper leans into FUSION — several Data-Handling items are wrapped in a
# Winds/Cyclone context (averaging recorded wind speeds, the mode of the month cyclones struck)
# and a Nutrition context (mean number of teeth), while several Perimeter-&-Area items are set
# inside a Science scene (the rectangular floor of a cyclone shelter, fencing a cattle shed).
# The child reads a Science context and applies a Maths skill. Class-7 scope, simple wording, hard thinking.
# Produces, under Resources/BossChallengePapers/:
#   Paper_30_<SHORT>_QuestionPaper.html  (pure HTML — questions + options)
#   Paper_30_<SHORT>_QuestionPaper.pdf
#   Paper_30_<SHORT>_Questions.md
#   Paper_30_<SHORT>_Solutions.html
import os, sys, shutil, json, re
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from examfactory import build_paper, C, steps, U

PNUM  = "30"
SHORT = "WindsStorms_NutritionAnimals_DataHandling_PerimeterArea"
TITLE = ("Winds, Storms & Cyclones · Nutrition in Animals · Data Handling · Perimeter & Area")
LABELS = {
    "WS": "Winds, Storms & Cyclones",
    "NA": "Nutrition in Animals",
    "DH": "Data Handling",
    "PA": "Perimeter & Area",
}

# ---------- WINDS, STORMS & CYCLONES (25) — Science ----------
WS = [
 ("WS","The push that moving and still air presses on everything around it is called air:",
   "pressure",
   C("Air presses on all the surfaces it touches, and this push is air pressure.")+
   steps("Air is made of countless moving particles","they constantly bump against surfaces","this push spread over the surface is air pressure."),
   [("weight","Weight is the pull of gravity on a body, not the push that air exerts all around."),
    ("speed","Speed is how fast the air moves, not the push it presses on surfaces."),
    ("volume","Volume is how much space the air fills, not the push it exerts.")]),

 ("WS","Wind is nothing other than air that is:",
   "moving",
   C("Wind is simply air on the move from one place to another.")+
   steps("Still air around us is not wind","when that air starts to flow","the moving air is what we call wind."),
   [("still","Still air is not wind; wind is air that is actually moving."),
    ("frozen","Frozen air is not how wind forms; wind is moving air."),
    ("heavy","Wind is defined by motion, not by being heavy.")]),

 ("WS","When air is heated it expands, becomes lighter, and therefore tends to:",
   "rise up",
   C("Warm air spreads out, grows lighter, and floats upward.")+
   steps("Heating makes air particles spread apart","the warmed air becomes lighter than the cool air around","so the warm air rises up."),
   [("sink down","Cool, heavier air sinks; warm light air rises, not sinks."),
    ("stay still","Heated air does not stay put; being lighter, it rises."),
    ("turn solid","Air does not turn solid on heating; it expands and rises.")]),

 ("WS","When warm air rises over a hot region, the air that rushes in to take its place is the cooler air that is:",
   "denser and heavier",
   C("Cool air is denser and heavier, so it flows in beneath the rising warm air.")+
   steps("Warm light air lifts off a hot patch","a gap of low pressure is left behind","heavier cool air rushes in to fill it."),
   [("lighter and warmer","Warmer, lighter air rises away; it is the cooler heavier air that moves in."),
    ("perfectly still","The cool air does move in; it does not stay still."),
    ("frozen solid","Air does not freeze solid here; cooler denser air simply flows in.")]),

 ("WS","Blowing hard over the top of a strip of paper makes it lift, showing that fast-moving air has a:",
   "lower pressure",
   C("Where air moves faster, its pressure drops, so the higher pressure below lifts the paper.")+
   steps("Blow fast across the top of the strip","the moving air on top presses less than the still air below","the greater pressure underneath pushes the paper up."),
   [("higher pressure","Faster air has lower, not higher, pressure; that is why the paper lifts."),
    ("greater weight","The paper lifts because of a pressure difference, not the air's weight."),
    ("no effect at all","There is a clear effect: the lower pressure on top lets the paper rise.")]),

 ("WS","On a very large scale, winds are caused mainly by the uneven:",
   "heating of the Earth",
   C("The Sun heats different parts of the Earth unequally, and this drives the winds.")+
   steps("The equator is heated more than the poles","air over the hotter regions rises","cooler air flows in to replace it — creating winds."),
   [("cooling of the oceans","It is uneven heating, not a separate cooling of oceans, that drives global winds."),
    ("spinning of clouds","Clouds are carried by winds; their spinning does not cause the winds."),
    ("rising of mountains","Mountains shape some local winds but do not cause winds on the whole Earth.")]),

 ("WS","During the daytime, near the coast, the wind that blows from the cool sea towards the warm land is called the:",
   "sea breeze",
   C("By day the land heats faster, its air rises, and cooler sea air flows in — the sea breeze.")+
   steps("Land warms faster than the sea by day","warm air over the land rises","cool air moves in from the sea — the sea breeze."),
   [("land breeze","A land breeze blows from land to sea at night, the reverse of this."),
    ("monsoon wind","Monsoon winds are seasonal winds over whole regions, not the daily coastal breeze."),
    ("cyclone","A cyclone is a violent storm, not the gentle daytime sea breeze.")]),

 ("WS","At night near the coast the land cools faster than the sea, so the wind blows from land to sea; this is the:",
   "land breeze",
   C("At night the sea stays warmer, its air rises, and cooler land air flows out — the land breeze.")+
   steps("Land cools faster than the sea at night","the air over the warmer sea rises","cooler air moves out from the land — the land breeze."),
   [("sea breeze","A sea breeze blows from sea to land by day, the reverse of this."),
    ("trade wind","Trade winds are steady global winds, not this nightly coastal breeze."),
    ("storm surge","A storm surge is sea water rising onto land, not a night-time breeze.")]),

 ("WS","The seasonal winds that reverse their direction with the seasons and bring heavy rain to India are the:",
   "monsoon winds",
   C("Monsoon winds change direction by season and carry the rains across India.")+
   steps("Uneven heating of land and sea over months sets up these winds","they switch direction between summer and winter","the rain-bearing ones are the monsoon winds."),
   [("land breezes","Land breezes are tiny nightly coastal winds, not the seasonal rain-bringing monsoon."),
    ("sea breezes","Sea breezes are small daytime coastal winds, not the seasonal monsoon."),
    ("tornado winds","A tornado is a small violent whirl, not a seasonal rain-bearing wind system.")]),

 ("WS","A storm with strong winds, lightning, thunder and heavy rain that forms in hot, humid weather is called a:",
   "thunderstorm",
   C("Thunderstorms build up in hot, moist air, bringing lightning, thunder and rain.")+
   steps("Hot humid air rises quickly and forms tall clouds","water drops and ice rub and build charge","this gives lightning, thunder and a thunderstorm."),
   [("sea breeze","A sea breeze is a gentle daytime wind, not a violent storm."),
    ("drought","A drought is a long dry spell, the opposite of a rainy thunderstorm."),
    ("land breeze","A land breeze is a calm night-time wind, not a thunderstorm.")]),

 ("WS","A very strong storm with violent winds whirling around a region of very low pressure is called a:",
   "cyclone",
   C("A cyclone is a whirling storm built around a centre of very low air pressure.")+
   steps("Warm moist air over the sea rises fast","this leaves a centre of very low pressure","winds spiral inwards violently — a cyclone."),
   [("sea breeze","A sea breeze is a mild daytime coastal wind, not a whirling violent storm."),
    ("monsoon","The monsoon is a rainy season of seasonal winds, not a single whirling storm."),
    ("rainbow","A rainbow is an arc of colours in the sky, not a storm.")]),

 ("WS","The calm region right at the centre of a cyclone, where the winds are light and the sky may clear, is called the:",
   "eye of the cyclone",
   C("The eye is the quiet low-pressure centre around which a cyclone's winds spin.")+
   steps("The fierce winds whirl around a centre","at the very centre the air is calm","this calm middle is the eye of the cyclone."),
   [("edge of the cyclone","The edge is where the strongest whirling winds are, not the calm part."),
    ("storm surge","A storm surge is the rise of sea water on land, not the calm centre."),
    ("monsoon trough","A monsoon trough is a low-pressure belt of the rainy season, not the cyclone's calm eye.")]),

 ("WS","Indian cyclones grow over warm sea water; what a cyclone needs to form and grow stronger is:",
   "warm, moist air over the sea",
   C("Cyclones draw their energy from warm, moisture-rich air rising off a warm sea.")+
   steps("A warm sea heats the air above it","this warm moist air rises fast","feeding the whirling storm — so warm moist sea air is needed."),
   [("cold, dry desert air","Cold dry air over deserts cannot feed a cyclone; it needs warm moist sea air."),
    ("ice on high mountains","Mountain ice does not power a sea-born cyclone; warm moist sea air does."),
    ("still air over cities","Still city air does not build a cyclone; rising warm sea air does.")]),

 ("WS","A dark, funnel-shaped cloud that reaches down from the sky to the ground, whirling very fast, is a:",
   "tornado",
   C("A tornado is a fast-whirling, funnel-shaped column of air reaching from cloud to ground.")+
   steps("Air spins into a narrow violent column","it hangs down as a dark funnel cloud","when it touches the ground it is a tornado."),
   [("sea breeze","A sea breeze is a gentle daytime wind, not a whirling funnel cloud."),
    ("rainbow","A rainbow is a band of colours, not a violent funnel of air."),
    ("monsoon","The monsoon is a rainy season, not a single funnel-shaped whirl.")]),

 ("WS","Wind speed at a weather station is measured using the instrument called the:",
   "anemometer",
   C("An anemometer measures how fast the wind is blowing.")+
   steps("Cups or vanes catch the wind and spin","the faster the wind, the faster they turn","the turning is read off as wind speed on an anemometer."),
   [("thermometer","A thermometer measures temperature, not the speed of the wind."),
    ("barometer","A barometer measures air pressure, not wind speed."),
    ("rain gauge","A rain gauge measures how much rain falls, not how fast the wind blows.")]),

 ("WS","A steady fall in the reading on a barometer often warns that a storm is on its way because the air pressure is:",
   "dropping",
   C("Storms form in low pressure, so a falling barometer warns one is coming.")+
   steps("A barometer measures the air pressure","before a storm the pressure falls","so a dropping barometer warns of an approaching storm."),
   [("rising steadily","Rising pressure usually means fair weather, not an approaching storm."),
    ("staying perfectly fixed","Fixed pressure suggests no change; it is a falling reading that warns of a storm."),
    ("turning into wind speed","A barometer reads pressure, not wind speed; the falling pressure is the warning.")]),

 ("WS","Today, the movement and strength of a cyclone far out at sea are mainly tracked using:",
   "satellites and radars",
   C("Weather satellites and radars watch cyclones from above and send warnings.")+
   steps("Satellites photograph the storm from space","radars track its rain and winds","together they let forecasters follow and warn of the cyclone."),
   [("a hand-held compass","A compass shows direction; it cannot track a cyclone far out at sea."),
    ("counting the rainfall by eye","Eyeballing rain cannot track a distant storm; satellites and radars do."),
    ("a kitchen thermometer","A thermometer reads temperature; it cannot follow a cyclone over the sea.")]),

 ("WS","When a cyclone warning is issued, the safest thing for people in the area to do is to:",
   "move to a safe shelter",
   C("Moving to a strong, safe shelter protects people from a cyclone's winds and water.")+
   steps("A cyclone brings violent winds and flooding","staying out in the open is very dangerous","so people should move to a safe shelter."),
   [("go out to watch the storm","Going out into a cyclone is extremely dangerous, not safe."),
    ("stand under a tall tree","Trees can be uprooted in a cyclone; sheltering under one is dangerous."),
    ("ignore the warning","Ignoring a cyclone warning risks lives; people should take shelter.")]),

 ("WS","The sudden rise of sea water that floods low coastal land when a cyclone strikes is called a storm:",
   "surge",
   C("A storm surge is the wall of sea water that a cyclone pushes onto the coast.")+
   steps("A cyclone's winds and low pressure heap up the sea","this raised water rushes ashore","that flooding rise is the storm surge."),
   [("breeze","A breeze is a gentle wind, not the sea water flooding the coast."),
    ("shadow","A shadow has nothing to do with sea water rising onto land."),
    ("shower","A shower is light rain, not the sea-water flood of a storm surge.")]),

 ("WS","The roof of a poorly built house can be blown off in a cyclone because the very fast wind above it creates:",
   "lower pressure above the roof",
   C("Fast wind over the roof lowers the pressure there, so the higher pressure inside pushes the roof up and off.")+
   steps("Wind races over the top of the roof","fast air above means lower pressure there","the higher pressure inside lifts the roof off."),
   [("higher pressure above the roof","Fast wind lowers, not raises, the pressure above; that is why the roof lifts."),
    ("a vacuum with no air at all","It is lower pressure, not a total vacuum, that lifts the roof."),
    ("extra weight pressing down","The roof is lifted by a pressure difference, not pressed down by extra weight.")]),

 ("WS","To reduce the loss of life in cyclone-prone coastal areas, governments build strong cyclone:",
   "shelters",
   C("Sturdy cyclone shelters give people a safe place to wait out the storm.")+
   steps("Cyclones threaten weak houses near the coast","strong buildings can withstand the winds and surge","people gather in these cyclone shelters to stay safe."),
   [("swimming pools","Swimming pools do not protect people from a cyclone; strong shelters do."),
    ("kite grounds","Open grounds are dangerous in a cyclone; people need sturdy shelters."),
    ("glass towers","Tall glass towers are risky in violent winds; safe cyclone shelters are needed.")]),

 ("WS","When a cyclone is likely within about 48 hours, the weather office issues a cyclone:",
   "alert",
   C("A cyclone alert is the early notice that a cyclone may strike in about two days.")+
   steps("Forecasters watch the storm approach","they give early notice so people can prepare","this early notice is a cyclone alert."),
   [("holiday","A holiday is a day off, not an official storm warning."),
    ("festival","A festival is a celebration, not a cyclone warning from the weather office."),
    ("rainbow","A rainbow is a sky arc of colour, not a cyclone warning.")]),

 ("WS","During a cyclone, people should trust official news and warnings and should never:",
   "believe rumours",
   C("Rumours can cause panic and bad decisions; only official warnings should be trusted.")+
   steps("False messages spread fast during a disaster","acting on them can be dangerous","so people must ignore rumours and follow official warnings."),
   [("listen to the weather office","People should listen to the weather office; it is rumours they must ignore."),
    ("move to a shelter","Moving to a shelter is wise; it is rumours that should never be believed."),
    ("keep emergency supplies","Keeping supplies is sensible; what people must avoid is believing rumours.")]),

 ("WS","Planting rows of trees along a coast helps in a cyclone because the trees act as a:",
   "windbreak that slows the wind",
   C("A belt of trees slows the wind and lessens the cyclone's damage on the coast.")+
   steps("Bare coasts let cyclone winds rush in freely","rows of trees stand in the wind's path","they slow the wind, so they act as a windbreak."),
   [("source of more wind","Trees do not create wind; they slow it as a windbreak."),
    ("magnet that pulls the storm in","Trees do not attract storms; they shield the coast by slowing the wind."),
    ("roof over the whole town","A tree belt is not a roof; it works by slowing the oncoming wind.")]),

 ("WS","A spinning storm of the kind called a cyclone in India is given the name 'hurricane' in:",
   "America",
   C("The same kind of storm is called a hurricane in the Americas.")+
   steps("Tropical spinning storms have local names","over the American region they are called hurricanes","over the Indian Ocean the same storm is a cyclone."),
   [("India","In India this storm is called a cyclone, not a hurricane."),
    ("the deep desert","Deserts do not breed these sea-born storms; the American name is hurricane."),
    ("outer space","These storms form on Earth over warm seas; the American name is hurricane.")]),
]

# ---------- NUTRITION IN ANIMALS (25) — Science ----------
NA = [
 ("NA","The taking in of food and its use by the body to stay alive and grow is called:",
   "nutrition",
   C("Nutrition is taking in food and using it to live, grow and work.")+
   steps("An animal must take in food","the body breaks it down and uses it","this whole taking-in-and-using is nutrition."),
   [("respiration","Respiration releases energy from food; nutrition is taking in and using the food itself."),
    ("excretion","Excretion removes waste; nutrition is the taking in and use of food."),
    ("reproduction","Reproduction is producing young; it is not the taking in of food.")]),

 ("NA","The taking of food into the body, the very first step of nutrition, is called:",
   "ingestion",
   C("Ingestion is the act of taking food into the body.")+
   steps("Food is put into the mouth","it is taken into the body","this taking-in is called ingestion."),
   [("digestion","Digestion is the breaking down of food that comes after it is taken in."),
    ("egestion","Egestion is throwing out undigested waste, the last step, not the first."),
    ("absorption","Absorption is taking digested food into the blood, not the first taking-in of food.")]),

 ("NA","The breaking down of complex food into simpler substances the body can absorb is called:",
   "digestion",
   C("Digestion breaks food into simple forms the body can take up.")+
   steps("Food taken in is too complex to use directly","the gut breaks it into simple substances","this breaking down is digestion."),
   [("ingestion","Ingestion is only the taking in of food, not the breaking of it down."),
    ("egestion","Egestion is the removal of undigested waste, not the breaking down of food."),
    ("assimilation","Assimilation is using the absorbed food, which comes after digestion.")]),

 ("NA","The removal of the undigested, unwanted part of food from the body is called:",
   "egestion",
   C("Egestion is throwing out the part of the food the body cannot digest.")+
   steps("Some food cannot be digested","it passes to the end of the food canal","the body pushes it out — this is egestion."),
   [("ingestion","Ingestion is the taking in of food, the opposite end of the process."),
    ("digestion","Digestion is the breaking down of food, not the removal of waste."),
    ("absorption","Absorption takes digested food into the blood; egestion removes the waste.")]),

 ("NA","The long tube running from the mouth to the anus, through which food passes, is called the:",
   "alimentary canal",
   C("The alimentary canal is the whole food tube from mouth to anus.")+
   steps("Food enters at the mouth","it travels through a long connected tube","that tube from mouth to anus is the alimentary canal."),
   [("wind pipe","The wind pipe carries air to the lungs, not food through the body."),
    ("backbone","The backbone is a chain of bones, not the tube food passes through."),
    ("blood vessel","Blood vessels carry blood; the food tube is the alimentary canal.")]),

 ("NA","The sharp, chisel-shaped front teeth used mainly for cutting and biting food are the:",
   "incisors",
   C("Incisors are the flat, sharp front teeth that cut and bite food.")+
   steps("Look at the front of the mouth","the teeth there are flat and sharp-edged","these cutting teeth are the incisors."),
   [("molars","Molars are the broad back teeth used for grinding, not cutting at the front."),
    ("canines","Canines are the pointed teeth for tearing, next to the incisors, not the front cutters."),
    ("premolars","Premolars sit behind the canines and help grind, not bite at the very front.")]),

 ("NA","The flat, broad back teeth that crush and grind the food into a paste are the:",
   "molars",
   C("Molars are the wide back teeth that grind food before swallowing.")+
   steps("Food is moved to the back of the mouth","the broad flat teeth there crush it","these grinding back teeth are the molars."),
   [("incisors","Incisors are the sharp front teeth for cutting, not the back grinders."),
    ("canines","Canines are pointed teeth for tearing, not the flat back grinders."),
    ("milk teeth","Milk teeth are a child's first set; molars name a kind by their grinding job.")]),

 ("NA","The watery juice in the mouth that wets the food and begins to break down starch is called:",
   "saliva",
   C("Saliva moistens food and starts turning starch into sugar in the mouth.")+
   steps("Glands in the mouth release a watery juice","it wets the food and acts on the starch","this juice is saliva."),
   [("bile","Bile is made by the liver and acts on fats in the intestine, not in the mouth."),
    ("blood","Blood carries food and oxygen around the body; it does not start digestion in the mouth."),
    ("sweat","Sweat is released by the skin to cool the body, not to break down food.")]),

 ("NA","The muscular food pipe that carries swallowed food from the mouth down to the stomach is the:",
   "oesophagus",
   C("The oesophagus is the tube that moves food down to the stomach.")+
   steps("Swallowed food leaves the mouth","it travels down a muscular tube","that food tube to the stomach is the oesophagus."),
   [("wind pipe","The wind pipe carries air to the lungs, not food to the stomach."),
    ("small intestine","The small intestine comes after the stomach; the pipe to the stomach is the oesophagus."),
    ("liver","The liver is a gland, not the tube that carries food to the stomach.")]),

 ("NA","Food is pushed along the food pipe and gut by the squeezing, wave-like movement of its muscular walls, called:",
   "peristalsis",
   C("Peristalsis is the wave of muscle squeezing that pushes food through the gut.")+
   steps("The walls of the food canal are muscular","they squeeze in waves behind the food","this wave-like push is peristalsis."),
   [("digestion","Digestion is the chemical breakdown of food, not the muscular pushing wave."),
    ("breathing","Breathing moves air in and out; it does not push food along the gut."),
    ("absorption","Absorption takes digested food into the blood; the pushing wave is peristalsis.")]),

 ("NA","The J-shaped, bag-like organ that churns food and mixes it with acidic digestive juices is the:",
   "stomach",
   C("The stomach churns food and mixes it with acid and juices.")+
   steps("Food arrives from the food pipe","a muscular bag churns and mixes it with juices","that bag-like organ is the stomach."),
   [("liver","The liver makes bile but does not churn food; the churning bag is the stomach."),
    ("small intestine","The small intestine completes digestion and absorbs food; the churning bag is the stomach."),
    ("tongue","The tongue mixes and tastes food in the mouth, not the churning bag below.")]),

 ("NA","Most of the digestion is completed and the digested food is absorbed in the longest part of the gut, the:",
   "small intestine",
   C("The small intestine finishes digestion and absorbs the digested food.")+
   steps("Food leaves the stomach part-digested","the long coiled small intestine finishes the job","and absorbs the food into the blood there."),
   [("stomach","The stomach starts digestion by churning; the small intestine completes and absorbs it."),
    ("large intestine","The large intestine mainly absorbs water; digestion is completed in the small intestine."),
    ("food pipe","The food pipe only carries food down; digestion is completed in the small intestine.")]),

 ("NA","Tiny finger-like folds lining the small intestine that greatly increase its surface for absorbing food are called:",
   "villi",
   C("Villi are the tiny finger-like projections that soak up digested food.")+
   steps("The small intestine wall is folded into tiny fingers","these give a huge surface to absorb food","these finger-like folds are the villi."),
   [("teeth","Teeth chew food in the mouth; they do not line the intestine to absorb food."),
    ("ribs","Ribs are bones of the chest, not folds in the intestine."),
    ("nerves","Nerves carry signals; the absorbing finger-like folds are the villi.")]),

 ("NA","The largest gland in the body, which makes bile to help digest fats, is the:",
   "liver",
   C("The liver is the body's biggest gland and makes bile for digesting fats.")+
   steps("A gland makes a useful juice","the biggest one makes bile","that gland is the liver."),
   [("stomach","The stomach is a churning bag, not a gland that makes bile."),
    ("heart","The heart pumps blood; it is not a gland that makes bile."),
    ("kidney","The kidney filters blood to make urine; the bile-making gland is the liver.")]),

 ("NA","The watery juice made by the liver that helps in the digestion of fats is called:",
   "bile",
   C("Bile, made by the liver, helps break fats into tiny droplets for digestion.")+
   steps("The liver makes a greenish juice","it acts on the fats in the food","this fat-helping juice is bile."),
   [("saliva","Saliva acts on starch in the mouth, not on fats from the liver."),
    ("plasma","Plasma is the liquid part of blood, not the liver's fat-digesting juice."),
    ("mucus","Mucus protects the gut lining; the liver's fat-digesting juice is bile.")]),

 ("NA","The last, wider part of the gut, where extra water is absorbed from the undigested food, is the:",
   "large intestine",
   C("The large intestine absorbs water from the leftover undigested food.")+
   steps("Undigested food reaches the wide final tube","much of its water is soaked back in","that water-absorbing tube is the large intestine."),
   [("small intestine","The small intestine absorbs digested food; the large one mainly absorbs water."),
    ("stomach","The stomach churns food early on; water is absorbed in the large intestine."),
    ("oesophagus","The oesophagus only carries food down; water is absorbed in the large intestine.")]),

 ("NA","The tiny one-celled animal Amoeba captures its food using finger-like extensions of its body called:",
   "pseudopodia",
   C("Amoeba pushes out pseudopodia (false feet) to surround and trap its food.")+
   steps("Amoeba senses a food particle nearby","it pushes out arm-like extensions around it","these false feet, the pseudopodia, trap the food."),
   [("teeth","Amoeba has no teeth; it traps food with its pseudopodia."),
    ("gills","Gills are for breathing in fish, not for an amoeba catching food."),
    ("roots","Roots belong to plants; an amoeba uses pseudopodia to grab food.")]),

 ("NA","Inside an Amoeba, the trapped food is digested within a small bubble-like space called the:",
   "food vacuole",
   C("A food vacuole is the bubble in which an amoeba digests its trapped food.")+
   steps("The pseudopodia engulf the food","it is sealed inside a tiny bubble","digestion happens there — in the food vacuole."),
   [("stomach","An amoeba has no stomach; it digests food in a food vacuole."),
    ("nucleus","The nucleus controls the cell; the food is digested in the food vacuole."),
    ("villus","Villi line the human intestine; an amoeba uses a food vacuole.")]),

 ("NA","Grass-eating animals like cows quickly swallow grass and store it in a part of the stomach called the:",
   "rumen",
   C("The rumen stores swallowed grass before it is brought back up to be chewed.")+
   steps("A cow swallows grass quickly while grazing","it is held in a stomach chamber","that storage chamber is the rumen."),
   [("liver","The liver is a gland that makes bile, not the grass-storing stomach chamber."),
    ("food vacuole","A food vacuole belongs to an amoeba, not to a cow's stomach."),
    ("villus","A villus is a tiny intestinal fold, not the grass-storing chamber.")]),

 ("NA","Cattle and other grass-eaters later bring the stored, partly digested grass back to the mouth to chew slowly; this is called chewing the:",
   "cud",
   C("Bringing back stored grass to chew again is called chewing the cud.")+
   steps("Grass is first swallowed quickly into the rumen","later it returns to the mouth in lumps","the animal chews these lumps — the cud."),
   [("bile","Bile is a digestive juice from the liver, not the food brought back to chew."),
    ("saliva","Saliva wets food in the mouth; the returned grass that is chewed is the cud."),
    ("mucus","Mucus protects the gut lining; the returned grass chewed again is the cud.")]),

 ("NA","Grass is rich in a tough material that grass-eaters digest with the help of bacteria living in their gut; this material is:",
   "cellulose",
   C("Cellulose is the tough part of grass that gut bacteria help grass-eaters digest.")+
   steps("Grass cell walls are made of a tough material","grass-eaters cannot break it down alone","gut bacteria digest this cellulose for them."),
   [("starch","Starch is easily digested even by us; the tough grass material is cellulose."),
    ("bile","Bile is a digestive juice, not the tough material that makes up grass."),
    ("saliva","Saliva is a mouth juice, not the tough fibre of grass; that is cellulose.")]),

 ("NA","The opening at the end of the alimentary canal through which the undigested waste leaves the body is the:",
   "anus",
   C("The anus is the opening at the very end through which waste is egested.")+
   steps("Undigested food reaches the end of the gut","it must leave the body","it passes out through the anus."),
   [("mouth","The mouth is where food is taken in, not where waste leaves."),
    ("nose","The nose is for breathing and smelling, not for egesting waste."),
    ("ear","The ear is for hearing; waste leaves through the anus.")]),

 ("NA","The using up of absorbed, digested food by body cells to build the body and release energy is called:",
   "assimilation",
   C("Assimilation is the body using absorbed food to build tissue and get energy.")+
   steps("Digested food is absorbed into the blood","cells take it in and put it to use","this using of food by cells is assimilation."),
   [("ingestion","Ingestion is taking food in; assimilation is the cells later using the absorbed food."),
    ("egestion","Egestion removes waste; assimilation is the body using the absorbed food."),
    ("digestion","Digestion breaks food down; assimilation is the cells using the absorbed result.")]),

 ("NA","Adding a few drops of iodine to food and seeing it turn blue-black tells us the food contains:",
   "starch",
   C("Iodine turns blue-black only when starch is present, so it tests for starch.")+
   steps("Put a drop of iodine on the food","watch the colour it turns","a blue-black colour shows starch is present."),
   [("fat","Fat is shown by a greasy translucent stain on paper, not by iodine turning blue-black."),
    ("protein","Protein is tested with a different chemical; iodine's blue-black shows starch."),
    ("water","Water gives no blue-black with iodine; that colour shows starch.")]),

 ("NA","If you chew a piece of bread (which contains starch) for a long time, it begins to taste slightly sweet because saliva turns the starch into:",
   "sugar",
   C("Saliva acts on the starch in bread and changes it into sweet-tasting sugar.")+
   steps("Bread is rich in starch, which is not sweet","saliva in the mouth acts on the starch","it changes into sugar, so the bread tastes sweet."),
   [("fat","Fat is not made from starch by saliva; saliva changes starch into sugar."),
    ("protein","Saliva does not turn starch into protein; it turns it into sugar."),
    ("salt","Salt is not produced from starch; saliva changes starch into sugar.")]),
]

# ---------- DATA HANDLING (25) — Maths ----------
DH = [
 ("DH","A collection of numbers gathered to give some useful information is called:",
   "data",
   C("Data is the set of numbers or facts collected to give information.")+
   steps("Suppose you note down many readings or counts","this organised set of numbers gives information","that collection is called data."),
   [("a graph","A graph is one way to show data; the collected numbers themselves are the data."),
    ("a ruler","A ruler is a measuring tool, not a collection of information."),
    ("an angle","An angle is a turn between two lines, not a collection of numbers.")]),

 ("DH","The average of a set of numbers, found by adding them all and dividing by how many there are, is called the:",
   "mean",
   C("The mean is the sum of the values divided by the number of values.")+
   steps("Add up all the numbers in the set","count how many numbers there are","divide the sum by that count to get the mean."),
   [("range","The range is the highest minus the lowest, not the average."),
    ("mode","The mode is the most frequent value, not the sum divided by the count."),
    ("median","The median is the middle value when arranged, not the average.")]),

 ("DH","Wind speeds on three days were recorded as 20, 30 and 40 km/h. The mean (average) wind speed is:",
   "30 km/h",
   C("Add the three speeds and divide by 3 to get the mean.")+
   steps("Add the speeds: 20 + 30 + 40 = 90","there are 3 days, so divide by 3","90 ÷ 3 = 30 km/h."),
   [("90 km/h","90 km/h is the total of the three speeds; the mean still needs dividing by 3."),
    ("40 km/h","40 km/h is the highest single reading, not the average of the three."),
    ("10 km/h","10 km/h is the range (40 − 30 of part), not the mean; 90 ÷ 3 = 30.")]),

 ("DH","The difference between the highest and the lowest value in a set of data is called the:",
   "range",
   C("The range is found by subtracting the smallest value from the largest.")+
   steps("Find the largest value in the data","find the smallest value","subtract the smallest from the largest — that is the range."),
   [("mean","The mean is the average, found by adding and dividing, not by subtracting."),
    ("mode","The mode is the most common value, not the highest minus the lowest."),
    ("median","The median is the middle value, not the spread between highest and lowest.")]),

 ("DH","The value that occurs most often in a set of data is called the:",
   "mode",
   C("The mode is the number that appears the greatest number of times.")+
   steps("List how many times each value appears","find the value that appears most often","that most frequent value is the mode."),
   [("mean","The mean is the average of all values, not the most frequent one."),
    ("range","The range is the highest minus the lowest, not the most common value."),
    ("median","The median is the middle value when ordered, not the most frequent one.")]),

 ("DH","When data is arranged in order, the value that lies exactly in the middle is called the:",
   "median",
   C("The median is the middle value of data arranged in order.")+
   steps("Arrange the numbers from smallest to largest","find the value in the very middle","that middle value is the median."),
   [("mode","The mode is the most frequent value, not the middle one."),
    ("mean","The mean is the average, found by adding and dividing, not the middle value."),
    ("range","The range is the spread between highest and lowest, not the middle value.")]),

 ("DH","Data shown using bars of equal width, whose heights stand for the amounts, is displayed as a:",
   "bar graph",
   C("A bar graph uses bars whose heights represent the quantities.")+
   steps("Draw bars of equal width side by side","make each bar's height match its value","this picture of bars is a bar graph."),
   [("number line","A number line marks numbers along a line; it does not use bars for amounts."),
    ("protractor","A protractor measures angles; it is not a way to display data."),
    ("compass","A compass draws circles; it is not a chart of bars showing data.")]),

 ("DH","A way of showing data using pictures or symbols, where each symbol stands for a fixed number, is a:",
   "pictograph",
   C("A pictograph shows data with symbols, each standing for a set number.")+
   steps("Pick a symbol to stand for a fixed amount","draw the right number of symbols for each item","this picture-based chart is a pictograph."),
   [("bar graph","A bar graph uses bars, not repeated picture symbols, to show the amounts."),
    ("median","The median is a middle value, not a way of displaying data with pictures."),
    ("range","The range is a difference between values, not a picture chart.")]),

 ("DH","To compare two sets of data side by side on the same chart, the best choice is a:",
   "double bar graph",
   C("A double bar graph places two bars together for each item to compare two sets.")+
   steps("You have two related sets of values","draw two bars side by side for each item","this is a double bar graph for easy comparison."),
   [("single bar graph","A single bar graph shows just one set; two sets need a double bar graph."),
    ("number line","A number line cannot easily compare two whole sets of data at once."),
    ("pie of one slice","One slice shows nothing to compare; two sets need a double bar graph.")]),

 ("DH","The mean of the first five whole numbers 0, 1, 2, 3 and 4 is:",
   "2",
   C("Add the five numbers and divide by 5.")+
   steps("Add them: 0 + 1 + 2 + 3 + 4 = 10","there are 5 numbers, so divide by 5","10 ÷ 5 = 2."),
   [("10","10 is the total of the five numbers; the mean still needs dividing by 5."),
    ("4","4 is the largest of the numbers, not their average."),
    ("5","5 is how many numbers there are, not their average; 10 ÷ 5 = 2.")]),

 ("DH","In a set of marks 7, 9, 9, 9 and 11, the mode is:",
   "9",
   C("The mode is the value that appears most often, here 9.")+
   steps("Count how often each mark appears","9 appears three times, more than any other","so the mode is 9."),
   [("7","7 appears only once; the value appearing most often is 9."),
    ("11","11 appears only once; the most frequent value is 9."),
    ("45","45 is the total of all the marks, not the most frequent value.")]),

 ("DH","Arranged in order, the data 3, 5, 7, 9 and 11 has a median of:",
   "7",
   C("With five ordered values, the middle (third) one is the median.")+
   steps("The numbers are already in order","there are five of them, so the middle is the third","the third value is 7 — the median."),
   [("3","3 is the smallest value, not the middle one."),
    ("11","11 is the largest value, not the middle one."),
    ("5","5 is the second value; the middle of five values is the third, which is 7.")]),

 ("DH","Suppose four numbers have a mean of 10; the total you get by adding all four is:",
   "40",
   C("The sum equals the mean multiplied by how many numbers there are.")+
   steps("Mean is the sum divided by the count","so the sum is mean times the count","10 × 4 = 40."),
   [("14","14 comes from adding the mean and the count; the sum is mean times count."),
    ("2.5","2.5 comes from dividing 10 by 4; the sum is found by multiplying, not dividing."),
    ("10","10 is just the mean; the total of 4 such numbers is 10 × 4 = 40.")]),

 ("DH","The range of the daily highest temperatures 28°, 31°, 26° and 33° is:",
   "7°",
   C("The range is the highest value minus the lowest value.")+
   steps("The highest temperature is 33°","the lowest is 26°","33 − 26 = 7°, the range."),
   [("33°","33° is only the highest reading; the range is the highest minus the lowest."),
    ("26°","26° is only the lowest reading; the range is the difference, 33 − 26 = 7°."),
    ("59°","59° comes from adding 33 and 26; the range is found by subtracting.")]),

 ("DH","Over four health check-ups a cow was found to have 32, 32, 32 and 30 teeth. The mode of these counts is:",
   "32",
   C("The mode is the value that appears most often, here 32.")+
   steps("List how often each count appears","32 appears three times, 30 only once","so the mode is 32."),
   [("30","30 appears only once; the count appearing most often is 32."),
    ("2","2 is the difference between 32 and 30, not the most frequent value."),
    ("126","126 is the total of all four counts, not the most frequent value.")]),

 ("DH","When you toss a fair coin once, the chance of getting a head is:",
   "1 out of 2",
   C("A coin has two equally likely faces, so a head is one chance out of two.")+
   steps("A coin can land as head or tail","both are equally likely","so a head is 1 out of 2 chances."),
   [("1 out of 6","1 out of 6 is for a single face of a die, not a two-sided coin."),
    ("certain","A head is not certain; tails is equally possible, so it is 1 out of 2."),
    ("impossible","Getting a head is clearly possible; the chance is 1 out of 2.")]),

 ("DH","An event that is sure to happen, such as the Sun rising in the east, has a chance that is:",
   "certain",
   C("An event sure to happen is described as certain.")+
   steps("Some events always happen","the Sun rising in the east is one of them","such a sure event is called certain."),
   [("impossible","Impossible means it can never happen, the opposite of a sure event."),
    ("equally likely to a coin head","A sure event is more than a coin's chance; it is certain to happen."),
    ("never","An event that never happens is impossible; a sure event is certain.")]),

 ("DH","An event that can never happen, such as a tossed coin landing on its thin edge and standing forever, is described as:",
   "impossible",
   C("An event that can never happen is described as impossible.")+
   steps("Some events simply cannot occur","a coin standing forever on its edge is one","such an event is called impossible."),
   [("certain","Certain means sure to happen, the opposite of an event that never can."),
    ("very likely","A never-happening event is not likely at all; it is impossible."),
    ("1 out of 2","1 out of 2 is the chance of a coin head; this event is impossible.")]),

 ("DH","To find the median of a list of numbers, the first thing you must always do is:",
   "arrange them in order",
   C("The median is the middle value, so the numbers must first be put in order.")+
   steps("The median is the middle value of the data","but a jumbled list has no clear middle","so first arrange the numbers in order."),
   [("add them all up","Adding gives the mean, not the median; for the median you first order the numbers."),
    ("pick the largest","The largest is for the range, not the median; first order the numbers."),
    ("multiply them","Multiplying is not part of finding a median; you first arrange them in order.")]),

 ("DH","Cyclones struck a coast in the months March, July, July and November over four years. The mode of these months is:",
   "July",
   C("The mode is the month that appears most often, here July.")+
   steps("List how often each month appears","July appears twice, the others once each","so the mode is July."),
   [("March","March appears only once; the most frequent month is July."),
    ("November","November appears only once; the most frequent month is July."),
    ("four","Four is the number of cyclones, not the most frequent month.")]),

 ("DH","If one very large value is added to a small set of numbers, the measure most pulled upward by it is the:",
   "mean",
   C("A single very large value raises the total, so it pulls the mean up the most.")+
   steps("The mean uses the total of all values","a very large value greatly raises that total","so the mean is pulled up the most by it."),
   [("mode","The mode is just the most frequent value; one large number need not change it."),
    ("range","The range may change, but the question asks which measure is pulled up — the mean uses every value."),
    ("median","The median is the middle value and shifts little when one large value is added.")]),

 ("DH","The mean of the four numbers 6, 8, 10 and 12 is:",
   "9",
   C("Add the four numbers and divide by 4.")+
   steps("Add them: 6 + 8 + 10 + 12 = 36","there are 4 numbers, so divide by 4","36 ÷ 4 = 9."),
   [("36","36 is the total of the four numbers; the mean still needs dividing by 4."),
    ("12","12 is the largest value, not the average of all four."),
    ("4","4 is how many numbers there are, not the average; 36 ÷ 4 = 9.")]),

 ("DH","A pictograph shows that one picture of a tree stands for 10 trees. A row of 4 such pictures means:",
   "40 trees",
   C("Multiply the value of one symbol by the number of symbols.")+
   steps("Each tree picture stands for 10 trees","there are 4 pictures in the row","4 × 10 = 40 trees."),
   [("4 trees","4 is just the number of pictures; each one stands for 10, so it is 40."),
    ("14 trees","14 comes from adding 10 and 4; you must multiply, giving 40."),
    ("10 trees","10 is what one picture stands for; four pictures mean 4 × 10 = 40.")]),

 ("DH","On a double bar graph comparing rainfall in two towns, each town is shown for every month by:",
   "two bars side by side",
   C("A double bar graph draws a pair of bars together for each item compared.")+
   steps("Two sets of data are being compared","for each month, one bar is drawn for each town","so each month shows two bars side by side."),
   [("a single bar","A single bar shows only one town; comparing two needs two bars side by side."),
    ("no bars at all","A double bar graph does use bars — two side by side for each month."),
    ("a circle","A double bar graph uses paired bars, not a circle, for each month.")]),

 ("DH","Counting how many students scored each mark and writing the counts in a neat table makes the data easier to:",
   "read and understand",
   C("Organising data into a table makes it far easier to read and understand.")+
   steps("Raw, jumbled data is hard to make sense of","arranging the counts neatly in a table sorts it out","so a table makes the data easier to read and understand."),
   [("hide from everyone","A table is meant to show data clearly, not to hide it."),
    ("turn into a wind","Organising data has nothing to do with making wind; it makes data clearer."),
    ("make impossible to use","A table makes data easier, not impossible, to use.")]),
]

# ---------- PERIMETER & AREA (25) — Maths ----------
PA = [
 ("PA","The total length of the boundary that goes all the way around a closed figure is called its:",
   "perimeter",
   C("Perimeter is the total distance around the edge of a figure.")+
   steps("Trace right around the outside of the figure","add up the lengths of all the sides","that total boundary length is the perimeter."),
   [("area","Area is the space inside the figure, not the length of its boundary."),
    ("volume","Volume is the space a solid takes up, not the boundary of a flat figure."),
    ("radius","The radius is the distance from a circle's centre to its edge, not the whole boundary.")]),

 ("PA","The amount of flat surface that a closed figure covers is called its:",
   "area",
   C("Area is the size of the flat surface a figure covers.")+
   steps("Look at the space enclosed by the figure","measure how much surface it covers","that surface measure is the area."),
   [("perimeter","Perimeter is the length around the boundary, not the surface covered."),
    ("height","Height is one measurement of a figure, not the surface it covers."),
    ("diameter","The diameter is a line across a circle, not the surface a figure covers.")]),

 ("PA","For a rectangle whose length is l and whose breadth is b, the perimeter equals:",
   "2 × (l + b)",
   C("A rectangle has two lengths and two breadths, so the perimeter is 2 × (l + b).")+
   steps("Add one length and one breadth: l + b","a rectangle has two of each","so the perimeter is 2 × (l + b)."),
   [("l × b","l × b gives the area of the rectangle, not its perimeter."),
    ("l + b","l + b is only one length plus one breadth; the perimeter needs two of each."),
    ("4 × l","4 × l would suit a square's perimeter, not a rectangle's.")]),

 ("PA","The area of a rectangle of length l and breadth b is found using:",
   "l × b",
   C("The area of a rectangle is its length multiplied by its breadth.")+
   steps("A rectangle covers length times breadth of unit squares","so multiply l by b","the area is l × b."),
   [("2 × (l + b)","2 × (l + b) gives the perimeter, not the area."),
    ("l + b","l + b is just a sum of two sides, not the area."),
    ("4 × l","4 × l is for a square's perimeter, not a rectangle's area.")]),

 ("PA","The area of a square of side s is given by:",
   "s × s",
   C("A square's area is its side multiplied by itself.")+
   steps("All four sides of a square are equal, length s","area is length times breadth, here s and s","so the area is s × s."),
   [("4 × s","4 × s gives the perimeter of the square, not its area."),
    ("2 × s","2 × s is just two sides added, not the area."),
    ("s + s","s + s is twice the side, not the area of the square.")]),

 ("PA","The perimeter of a square of side s is:",
   "4 × s",
   C("A square has four equal sides, so its perimeter is 4 times the side.")+
   steps("All four sides are equal, each length s","add them: s + s + s + s","that is 4 × s."),
   [("s × s","s × s gives the area of the square, not its perimeter."),
    ("2 × s","2 × s is only two sides; a square has four equal sides."),
    ("8 × s","8 × s doubles the count; a square has only four sides, so it is 4 × s.")]),

 ("PA","The floor of a rectangular cyclone shelter is 8 m long and 5 m broad. Its area is:",
   "40 square metres",
   C("Multiply the length by the breadth to find the area of the floor.")+
   steps("Length is 8 m and breadth is 5 m","area of a rectangle is length × breadth","8 × 5 = 40 square metres."),
   [("13 square metres","13 comes from adding 8 + 5; area needs multiplication, not addition."),
    ("26 square metres","26 is the perimeter, 2 × (8 + 5); the area is length × breadth = 40."),
    ("80 square metres","80 doubles the answer; 8 × 5 is 40, not 80.")]),

 ("PA","A rectangular cattle shed is 10 m long and 6 m wide. The length of fencing needed to go right around it is:",
   "32 metres",
   C("Fencing all around equals the perimeter, 2 × (length + breadth).")+
   steps("Add length and breadth: 10 + 6 = 16","a rectangle needs two of each, so multiply by 2","2 × 16 = 32 metres of fencing."),
   [("60 metres","60 is the area, 10 × 6; fencing the boundary needs the perimeter, 32 m."),
    ("16 metres","16 is just one length plus one breadth; the full boundary is twice that, 32 m."),
    ("26 metres","26 comes from a wrong sum; 2 × (10 + 6) = 32 metres.")]),

 ("PA","A square field has each side 9 m long. Its area is:",
   "81 square metres",
   C("The area of a square is the side multiplied by itself.")+
   steps("Each side of the square is 9 m","area of a square is side × side","9 × 9 = 81 square metres."),
   [("36 square metres","36 is the perimeter, 4 × 9; the area is side × side = 81."),
    ("18 square metres","18 is 9 + 9, just two sides; the area is 9 × 9 = 81."),
    ("90 square metres","90 is not 9 × 9; the area of the square is 81 square metres.")]),

 ("PA","The area of a triangle with base b and height h is given by:",
   "½ × b × h",
   C("A triangle's area is half the product of its base and its height.")+
   steps("A triangle is half of a rectangle on the same base and height","so take base times height","and halve it: ½ × b × h."),
   [("b × h","b × h is the area of a rectangle; a triangle is only half of that."),
    ("2 × b × h","2 × b × h is far too big; a triangle's area is half of b × h."),
    ("b + h","b + h is just a sum of two lengths, not an area at all.")]),

 ("PA","Work out the area of a triangle whose base measures 10 cm and whose height is 6 cm:",
   "30 square cm",
   C("Use half the base times the height to find the triangle's area.")+
   steps("Multiply base by height: 10 × 6 = 60","take half of it: 60 ÷ 2","the area is 30 square cm."),
   [("60 square cm","60 is base × height; a triangle's area is only half of that, 30."),
    ("16 square cm","16 comes from 10 + 6; area needs ½ × base × height, giving 30."),
    ("32 square cm","32 is a wrong figure; ½ × 10 × 6 = 30 square cm.")]),

 ("PA","The area of a parallelogram with base b and height h is found using:",
   "b × h",
   C("A parallelogram's area is its base multiplied by its height.")+
   steps("Cut a triangle from one end of the parallelogram","slide it to the other end to make a rectangle","so the area is base × height."),
   [("½ × b × h","½ × b × h gives a triangle's area; a parallelogram's is the full b × h."),
    ("b + h","b + h is only a sum of two lengths, not an area."),
    ("4 × b","4 × b is not a parallelogram's area; the area is base × height.")]),

 ("PA","A parallelogram has a base of 12 cm and a height of 5 cm. Its area is:",
   "60 square cm",
   C("Multiply the base by the height to find the area of the parallelogram.")+
   steps("Base is 12 cm and height is 5 cm","area of a parallelogram is base × height","12 × 5 = 60 square cm."),
   [("17 square cm","17 comes from 12 + 5; area needs multiplication, giving 60."),
    ("30 square cm","30 is half of base × height, which is a triangle's area, not a parallelogram's."),
    ("34 square cm","34 is a wrong figure; 12 × 5 = 60 square cm.")]),

 ("PA","Area is measured in square units, while perimeter is measured in:",
   "units of length",
   C("Perimeter is a length around a figure, so it is measured in units of length.")+
   steps("Perimeter is the distance around a figure","distance is a length","so perimeter is measured in units of length like cm or m."),
   [("square units","Square units measure area; perimeter is a length, in plain length units."),
    ("cubic units","Cubic units measure volume of solids, not the perimeter of a flat figure."),
    ("degrees","Degrees measure angles, not the length around a figure.")]),

 ("PA","To find the cost of fencing all around a rectangular field, you should multiply the rate per metre by the field's:",
   "perimeter",
   C("Fencing runs along the boundary, so the cost uses the perimeter.")+
   steps("Fencing follows the whole boundary","the boundary length is the perimeter","so multiply the rate per metre by the perimeter."),
   [("area","Area is the surface inside; fencing follows the boundary, which is the perimeter."),
    ("diagonal","A single diagonal is not the whole boundary; fencing uses the perimeter."),
    ("height","Height is one measurement; the fencing length is the perimeter.")]),

 ("PA","To find the cost of laying tiles to cover a rectangular floor, you should multiply the rate per square metre by the floor's:",
   "area",
   C("Tiles cover the surface, so the cost uses the area of the floor.")+
   steps("Tiles cover the whole flat surface","the surface measure is the area","so multiply the rate per square metre by the area."),
   [("perimeter","The perimeter is only the boundary; covering the surface uses the area."),
    ("length only","Length alone is not the surface; covering it needs the area, length × breadth."),
    ("one diagonal","A diagonal is a single line; covering the floor uses the area.")]),

 ("PA","A square and a rectangle each have a perimeter of 24 cm. The square has side 6 cm; the rectangle is 8 cm by 4 cm. The one with the larger area is the:",
   "square",
   C("With the same perimeter, the square's area beats the long thin rectangle's.")+
   steps("Square area: 6 × 6 = 36 sq cm","rectangle area: 8 × 4 = 32 sq cm","36 is larger, so the square has the larger area."),
   [("rectangle","The rectangle's area is 32 sq cm, less than the square's 36 sq cm."),
    ("they are equal","Their areas differ: 36 sq cm for the square against 32 sq cm for the rectangle."),
    ("neither has any area","Both have area; the square's 36 sq cm is the larger.")]),

 ("PA","In a circle, the distance right across through the centre is the diameter, and it is always the radius:",
   "doubled",
   C("The diameter passes through the centre and equals twice the radius.")+
   steps("The radius runs from the centre to the edge","the diameter crosses from edge to edge through the centre","so the diameter is two radii — the radius doubled."),
   [("halved","The radius is half the diameter; the diameter is the radius doubled, not halved."),
    ("squared","The diameter is twice the radius, not the radius multiplied by itself."),
    ("the same length","The diameter is longer than the radius; it is the radius doubled.")]),

 ("PA","The distance all the way around the edge of a circle is given its own special name, the:",
   "circumference",
   C("The boundary length of a circle is called its circumference.")+
   steps("A circle's boundary is a curved line","the length right around it has a special name","that name is the circumference."),
   [("area","Area is the surface inside the circle, not the length around its edge."),
    ("radius","The radius is from centre to edge, not the length around the circle."),
    ("diameter","The diameter crosses the circle; the length around the edge is the circumference.")]),

 ("PA","A rectangular plot is 7 m long and 3 m wide. Its perimeter is:",
   "20 metres",
   C("The perimeter of a rectangle is 2 × (length + breadth).")+
   steps("Add length and breadth: 7 + 3 = 10","a rectangle has two of each, so multiply by 2","2 × 10 = 20 metres."),
   [("21 metres","21 is the area, 7 × 3; the perimeter is 2 × (7 + 3) = 20 m."),
    ("10 metres","10 is just one length plus one breadth; the full boundary is twice that, 20 m."),
    ("14 metres","14 is a wrong figure; 2 × (7 + 3) = 20 metres.")]),

 ("PA","One square metre is the same as the number of square centimetres equal to:",
   "10000",
   C("A metre is 100 cm, so a square metre is 100 × 100 = 10000 square cm.")+
   steps("1 m = 100 cm along each side","a square metre is 100 cm by 100 cm","100 × 100 = 10000 square cm."),
   [("100","100 is the number of cm in a metre of length, not square cm in a square metre."),
    ("1000","1000 is not 100 × 100; a square metre holds 10000 square cm."),
    ("10","10 is far too small; a square metre is 10000 square cm.")]),

 ("PA","Doubling both the length and the breadth of a rectangle makes its area become:",
   "four times as large",
   C("Doubling both sides multiplies the area by 2 × 2 = 4.")+
   steps("Area is length × breadth","double each: 2 × length and 2 × breadth","the new area is 2 × 2 = 4 times the old.")  ,
   [("twice as large","Doubling only one side would double the area; doubling both makes it four times."),
    ("the same","Doubling both sides certainly changes the area; it becomes four times as large."),
    ("half as large","Doubling the sides enlarges the area, not shrinks it; it becomes four times.")]),

 ("PA","A footpath of bricks runs around the inside edge of a square park of side 20 m. The length of the path's outer boundary equals the park's:",
   "perimeter",
   C("A path running right around the edge follows the park's perimeter.")+
   steps("The path hugs the inside of the boundary","its outer edge runs along the park's boundary","so its length matches the park's perimeter."),
   [("area","Area is the whole surface inside; the path's edge follows the boundary, the perimeter."),
    ("diagonal","A diagonal cuts across the park; the path runs around the boundary, the perimeter."),
    ("side only","A single side is not the whole way around; the path follows the full perimeter.")]),

 ("PA","A square cyclone-shelter floor and a rectangular one both cover the same area of 36 square metres. The square one has side:",
   "6 metres",
   C("The side of a square of area 36 is the number that times itself gives 36.")+
   steps("Area of a square is side × side","find the number whose square is 36","6 × 6 = 36, so the side is 6 metres."),
   [("36 metres","36 metres is the area in square metres, not the side; the side is √36 = 6 m."),
    ("18 metres","18 is half of 36, not the side; the side is the number squared to give 36, which is 6."),
    ("9 metres","9 × 9 = 81, not 36; the side that squares to 36 is 6 metres.")]),

 ("PA","A rectangle and a square both have an area of 36 square metres, but their perimeters differ; this shows that the same area can go with a:",
   "different perimeter",
   C("Two shapes can enclose the same area yet have different boundary lengths.")+
   steps("A 6 × 6 square and a 9 × 4 rectangle both have area 36 sq m","but the square's perimeter is 24 m and the rectangle's is 26 m","so equal area can come with a different perimeter."),
   [("equal perimeter always","Equal areas need not have equal perimeters; here 24 m differs from 26 m."),
    ("zero perimeter","Both shapes have a real boundary, so neither perimeter is zero."),
    ("the same shape always","Different shapes can share an area; equal area does not force the same shape.")]),
]

# ---------- real-life use-case lines (25 each) ----------
WS_UC = [
 "Air pressure is the very push that holds a sucker hook firmly onto a smooth bathroom wall.",
 "Wind being moving air is what you feel the moment you stick a hand out of a car window.",
 "Warm air rising is why a hot-air balloon floats up once the burner heats the air inside it.",
 "Cool air rushing in to replace rising warm air is the breeze you feel near an open bonfire.",
 "The paper-strip lift is the same low-pressure trick that helps an aeroplane wing rise.",
 "Uneven heating of the Earth is the engine behind every wind that crosses the globe.",
 "The cool sea breeze is what makes an afternoon at the beach feel pleasant in summer.",
 "The land breeze is the off-shore wind that helps fishing boats set out in the early morning.",
 "Monsoon winds are the rains farmers across India wait for to sow their fields each year.",
 "A thunderstorm is the hot-afternoon storm that sends everyone running indoors with the first lightning.",
 "A cyclone is the violent sea storm that coastal radio warns about days before it lands.",
 "The calm eye of a cyclone is the eerie quiet that fools people into thinking the storm is over.",
 "Warm sea water is why cyclones build over tropical oceans and not over cold polar seas.",
 "A tornado is the spinning funnel that can lift roofs and cars in a matter of seconds.",
 "An anemometer's spinning cups are what weather stations read to report the day's wind speed.",
 "A falling barometer is the old sailor's clue that rough weather is on the way.",
 "Satellites and radars are why forecasters can warn a whole coast about a cyclone in advance.",
 "Moving to a shelter on a cyclone warning is the single most life-saving thing a family can do.",
 "A storm surge is the deadly wall of sea water that floods low coasts when a cyclone lands.",
 "Roofs lifting off in a storm show the same wind-pressure rule that lifts an aircraft wing.",
 "Sturdy cyclone shelters are why far fewer lives are lost on Indian coasts than in the past.",
 "A cyclone alert is the two-day early notice that lets fishermen bring their boats safely home.",
 "Ignoring rumours during a storm is what keeps people calm and following safe official advice.",
 "Coastal tree belts are planted as windbreaks to soften the blow of every passing storm.",
 "Knowing a cyclone is a hurricane in America shows the same storm wears different names worldwide.",
]
NA_UC = [
 "Nutrition is the whole reason you eat breakfast before a long day at school.",
 "Ingestion is simply the bite you take the moment you put food into your mouth.",
 "Digestion is what slowly turns your lunch into substances small enough for the body to use.",
 "Egestion is the body's way of clearing out the part of food it simply cannot use.",
 "The alimentary canal is the long food tube doctors picture when they study digestion.",
 "Your sharp front incisors are the teeth you use to bite into a crisp apple.",
 "Your flat back molars are the teeth that grind a mouthful of rice into a soft paste.",
 "Saliva is why a dry biscuit becomes easy to swallow after a few moments of chewing.",
 "The oesophagus is the pipe that carries each swallow down even when you eat upside-down.",
 "Peristalsis is the muscle wave that lets you swallow water while standing on your head.",
 "The stomach's churning is the gurgling you sometimes hear when you are very hungry.",
 "The small intestine is where most of your food is finally taken into the blood.",
 "Villi are the tiny folds that pack a huge absorbing surface into a small gut.",
 "The liver is the large gland that makes the bile your body uses to digest fats.",
 "Bile is the greenish juice that breaks oily food into tiny droplets in the gut.",
 "The large intestine soaking up water is why proper drinking keeps you from getting constipated.",
 "An amoeba's pseudopodia are the false feet it pushes out to grab a passing food particle.",
 "A food vacuole is the tiny bubble in which an amoeba quietly digests its meal.",
 "The rumen is where a grazing cow quickly stuffs grass to chew again later.",
 "Chewing the cud is the slow jaw movement you see in a cow resting in the shade.",
 "Cellulose is the tough grass fibre that gut bacteria help a cow break down.",
 "The anus is the opening through which the body finally clears its undigested waste.",
 "Assimilation is your cells putting your last meal to work building muscle and giving energy.",
 "The iodine starch test is the classroom way of catching starch hiding in a food.",
 "Bread tasting sweet after long chewing is saliva quietly turning its starch into sugar.",
]
DH_UC = [
 "Data is the bundle of numbers a cricket scorer fills in over a whole match.",
 "The mean is the average marks a teacher works out to sum up a class's test.",
 "Averaging wind speeds is exactly how a weather office reports a typical day's wind.",
 "The range tells a coach the gap between the fastest and the slowest runner in a race.",
 "The mode is the shoe size a shop stocks most because it sells the most often.",
 "The median is the middle income economists quote so one huge salary does not mislead.",
 "A bar graph is the chart a newspaper uses to show each team's points at a glance.",
 "A pictograph is the friendly picture chart you often see in a primary-class textbook.",
 "A double bar graph lets you compare two cities' rainfall month by month on one chart.",
 "Finding the mean of the first whole numbers is a neat warm-up for averaging anything.",
 "Spotting the mode of a set of marks shows the score the most students landed on.",
 "Finding the median by ordering the data is how a survey reports a typical value.",
 "Getting the total from the mean is how a shopkeeper checks a week's average sales.",
 "The range of daily temperatures tells you how much the weather swung in a day.",
 "Finding the mode of teeth counts is a playful way to practise reading repeated data.",
 "A coin's one-in-two chance is the fair way two friends decide who bats first.",
 "A certain event is the kind of sure thing you can safely bet your pocket money on.",
 "An impossible event is something you know can simply never happen, whatever you do.",
 "Ordering the data first is the habit that keeps every median calculation correct.",
 "The mode of cyclone months hints at when a coast is most often struck by storms.",
 "Knowing the mean is pulled by one big value warns you not to trust an average blindly.",
 "Averaging four numbers is the everyday maths behind working out a typical score.",
 "Reading a pictograph's symbol value turns a row of little pictures into a real count.",
 "A double bar graph's paired bars make comparing two towns' rainfall quick and clear.",
 "Tidying counts into a table is the first thing any survey team does with raw answers.",
]
PA_UC = [
 "Perimeter is the length of wire you buy to fence right around a vegetable patch.",
 "Area is the amount of carpet you need to cover a whole room's floor.",
 "The 2 × (l + b) rule is what a farmer uses to measure fencing for a rectangular plot.",
 "The length-times-breadth rule tells a tiler how many tiles a rectangular room needs.",
 "The side-times-side rule gives the area of a square chessboard at a glance.",
 "Four-times-the-side is how you measure the ribbon to edge a square photo frame.",
 "Working out a shelter floor's area shows exactly how many people it can safely hold.",
 "Measuring fencing for a cattle shed is the perimeter sum every farmer must do.",
 "A square field's area is what a farmer multiplies to know how much seed to buy.",
 "The half-base-times-height rule gives the area of a triangular garden flag.",
 "Finding a triangle's area is how a designer measures a triangular sail of cloth.",
 "The base-times-height rule gives the area of a slanting parallelogram-shaped plot.",
 "A parallelogram's area helps a painter buy enough paint for a slanted wall panel.",
 "Knowing perimeter is a length keeps you from mixing up metres with square metres.",
 "Multiplying the rate by the perimeter is how a contractor prices a fence.",
 "Multiplying the rate by the area is how a contractor prices a tiled floor.",
 "Comparing equal-perimeter shapes shows why a square encloses more land than a thin strip.",
 "Doubling the radius to get the diameter is the first step in measuring any wheel.",
 "Circumference is the length of edging you need to trim right around a round table.",
 "A rectangular plot's perimeter is the boundary a buyer walks before purchasing land.",
 "The 10000-square-cm fact stops you under-buying tiles when a plan is given in metres.",
 "Knowing doubling both sides quadruples area warns you how fast a bigger room costs more.",
 "A path around a park follows the park's perimeter, just as edging follows a lawn's edge.",
 "Finding a square shelter's side from its area is how a builder sets out the foundation.",
 "Square-metre to square-centimetre sense keeps a flooring estimate from going badly wrong.",
]


def _with_uc(lst, ucs):
    assert len(lst) == len(ucs) == 25
    out = []
    for it, uc in zip(lst, ucs):
        code, stem, correct, html, distr = it
        out.append((code, stem, correct, html + U(uc), distr))
    return out


WS = _with_uc(WS, WS_UC)
NA = _with_uc(NA, NA_UC)
DH = _with_uc(DH, DH_UC)
PA = _with_uc(PA, PA_UC)

items = []
for i in range(25):
    items += [WS[i], NA[i], DH[i], PA[i]]
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

    keydist = build_paper(PNUM, TITLE, SHORT, LABELS, items, seed=30411,
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
    split = "/".join(str(counts[c]) for c in ("WS", "NA", "DH", "PA"))
    with open("PAPERS_MANIFEST.md", "a", encoding="utf-8") as fh:
        fh.write(f"| {PNUM} | 2026-06-18 | {TITLE} | {split} | ✓ |\n")

    # ---- update QUESTION_INDEX.json ----
    idx["fingerprints"] = sorted(existing | set(new_fps))
    idx.setdefault("combos", []).append({
        "paper": PNUM,
        "chapters": ["Winds, Storms & Cyclones",
                     "Nutrition in Animals",
                     "Data Handling",
                     "Perimeter & Area"],
    })
    idx["papers"] = idx.get("papers", 0) + 1
    with open(idx_path, "w", encoding="utf-8") as fh:
        json.dump(idx, fh, ensure_ascii=False, indent=2)
        fh.write("\n")

    print("Files:", sorted(v for v in moves.values()))
    print("Answer key spread A/B/C/D =", dict(keydist))
    print("Fingerprints added:", len(new_fps))
