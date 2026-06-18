# -*- coding: utf-8 -*-
# Boss Challenge Paper 51 — Heat · Nutrition in Plants · Fractions & Decimals
# · Data Handling
# Content-only. Uses the dependency-free examfactory engine.
# Difficulty ramp: leans hard into FUSION. A daily temperature record becomes
# a MEAN and a RANGE; a leaf's chlorophyll fraction becomes a fraction-of-a-
# whole; rainfall readings become decimals to add; a class survey of food
# habits becomes a bar-graph / mode question. The child meets a Science
# situation and reaches for a Maths skill.
# Class-7 scope, simple wording, hard thinking.
# Produces, under Resources/BossChallengePapers/:
#   Paper_51_<SHORT>_QuestionPaper.html  (pure HTML — questions + options)
#   Paper_51_<SHORT>_QuestionPaper.pdf
#   Paper_51_<SHORT>_Questions.md
#   Paper_51_<SHORT>_Solutions.html
import os, sys, shutil, json, re
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from examfactory import build_paper, C, steps, U

PNUM  = "51"
SHORT = "Heat_NutritionInPlants_FractionsDecimals_DataHandling"
TITLE = ("Heat · Nutrition in Plants · "
         "Fractions & Decimals · Data Handling")
LABELS = {
    "HE": "Heat",
    "NP": "Nutrition in Plants",
    "FD": "Fractions & Decimals",
    "DH": "Data Handling",
}

# ---------- HEAT (25) — several fused with Fractions/Data ----------
HE = [
 ("HE","A measure of how hot or cold a body is, read on a thermometer, is called its:",
   "temperature",
   C("Temperature tells us the degree of hotness or coldness of a body and is measured in degrees Celsius (°C) with a thermometer.")+
   steps("Ask 'how hot or cold is it?'","that degree of hotness, read on a thermometer","is the temperature.")+
   U("A doctor reads your temperature on a clinical thermometer to check for fever."),
   [("heat","Heat is the energy that flows from a hot body to a cold one; how hot the body itself is, is its temperature."),
    ("pressure","Pressure is a push per unit area, measured by a barometer, not the hotness measured by a thermometer."),
    ("humidity","Humidity is the moisture in air; the degree of hotness is the temperature.")]),

 ("HE","A clinical thermometer reads from 35 °C to about 42 °C because that range covers:",
   "the human body's temperatures",
   C("A healthy body is near 37 °C, so a clinical thermometer is built to read just around that range — roughly 35 °C to 42 °C.")+
   steps("The body normally sits near 37 °C","a clinical thermometer need only cover a little either side","so its scale runs about 35 °C to 42 °C.")+
   U("To measure boiling water you would need a laboratory thermometer, which reads far higher."),
   [("the boiling point of water","Water boils at 100 °C — far above a clinical thermometer's top of about 42 °C; a lab thermometer is used for that."),
    ("the temperature of ice","Ice is at 0 °C, below the clinical scale's lowest mark of 35 °C; the scale is built around body heat."),
    ("room temperature only","Rooms can sit near 25 °C, below 35 °C; the clinical scale is centred on body temperature, not room air.")]),

 ("HE","Left to itself, heat moves spontaneously out of a hotter object and into one that is at a:",
   "lower temperature",
   C("Heat is energy in transit, and it spontaneously moves from the hotter body to the cooler body until both reach the same temperature.")+
   steps("Place a hot cup on a cool table","energy leaves the hot cup for the cooler table","so heat flows from higher to lower temperature.")+
   U("A hot spoon left in cold tea cools down as heat leaves the spoon for the tea."),
   [("higher temperature","Heat never flows on its own toward a hotter body; left alone it always moves to the cooler one."),
    ("equal temperature","Equal temperature is the END state when flow stops; while temperatures differ, heat flows hot to cold."),
    ("a vacuum only","Heat flows between bodies of different temperature through matter; a vacuum blocks conduction, it is not the destination.")]),

 ("HE","Heat travelling through a solid metal rod, particle to particle without the particles moving along, is:",
   "conduction",
   C("In conduction, heat passes from particle to particle through a solid while the particles themselves stay in place — this is how a metal rod heats up end to end.")+
   steps("One end of a metal rod is heated","the energy passes neighbour to neighbour through the solid","so this mode of transfer is conduction.")+
   U("A metal spoon left in hot dal soon feels hot at the handle by conduction."),
   [("convection","Convection needs the heated material itself to move and carry heat — it happens in liquids and gases, not a solid rod."),
    ("radiation","Radiation carries heat as waves with no material at all, such as the Sun's heat across space; a rod heats by conduction."),
    ("evaporation","Evaporation is a liquid turning to vapour and cooling a surface, not heat moving through a solid rod.")]),

 ("HE","Heat reaching us from the Sun across empty space travels by:",
   "radiation",
   C("The Sun's heat crosses the vacuum of space where there are no particles, so it must travel as radiation — heat carried by waves needing no medium.")+
   steps("Between Sun and Earth lies empty space","no particles means no conduction or convection","so the heat must travel by radiation.")+
   U("You feel a campfire's warmth on your face by radiation, even without touching the flames."),
   [("conduction","Conduction needs particles touching in a solid; empty space has none, so the Sun's heat cannot reach us that way."),
    ("convection","Convection needs a fluid that can move and carry heat; the vacuum of space has no such fluid."),
    ("boiling","Boiling is a liquid changing to gas at its boiling point, not a way heat crosses empty space.")]),

 ("HE","Materials such as copper and aluminium that let heat pass through them easily are called:",
   "conductors",
   C("Conductors, mostly metals, allow heat to flow through them readily, which is why cooking pots are made of them.")+
   steps("Heat passes through copper quickly","a material that lets heat through easily","is called a conductor of heat.")+
   U("Cooking pans are made of aluminium or steel so heat reaches the food fast."),
   [("insulators","Insulators RESIST heat flow — wood and plastic; metals that let heat through easily are conductors."),
    ("radiators of light","Letting heat pass through is conduction; giving out light is a different property and not what defines a conductor."),
    ("liquids","Whether a material is solid, liquid or gas is separate from this; copper and aluminium are solid metal conductors.")]),

 ("HE","A cooking pot is metal but its handle is often plastic or wood because those materials are:",
   "poor conductors (insulators) of heat",
   C("Plastic and wood are insulators — they conduct heat poorly — so the handle stays cool enough to hold even when the metal pot is hot.")+
   steps("The metal pot conducts heat well and gets hot","the handle must stay cool to be held","so it is made of an insulator like wood or plastic.")+
   U("Oven mitts are made of thick cloth, an insulator, so you can lift a hot tray safely."),
   [("good conductors of heat","A good-conductor handle would burn the hand; handles use insulators that conduct heat poorly."),
    ("magnetic materials","Whether the handle is magnetic does not affect how hot it gets; it is chosen to be a poor heat conductor."),
    ("heavier than metal","Weight is not the reason; the handle is an insulator so it does not carry the pot's heat to your hand.")]),

 ("HE","On a hot sunny day light-coloured clothes feel more comfortable than dark ones because light colours:",
   "reflect most of the heat and absorb less",
   C("Light, especially white, reflects most of the heat falling on it and absorbs little, so light clothes keep us cooler in the Sun.")+
   steps("Light colours bounce heat away rather than soaking it in","less heat is absorbed into the cloth and body","so light clothes feel cooler on a hot day.")+
   U("In summer many people wear white or pale cotton to stay cool."),
   [("absorb most of the heat","Absorbing heat is what DARK colours do, making them hotter; light colours stay cool by reflecting heat."),
    ("are always thinner cloth","Thickness is a separate matter; colour itself decides reflection — a thin dark cloth still absorbs more heat."),
    ("block sunlight completely","No ordinary cloth blocks all sunlight; light colours simply reflect more heat than dark ones absorb.")]),

 ("HE","The warm breeze that blows from the sea toward the land during the daytime is the:",
   "sea breeze",
   C("By day the land heats faster than the sea; warm air rises over land and cooler air flows in from the sea — this daytime wind is the sea breeze.")+
   steps("Land warms faster than water in the day","air rises over hot land and sea air rushes in to fill the gap","so the daytime wind from sea to land is the sea breeze.")+
   U("People at a beach feel a cool sea breeze on their face in the afternoon."),
   [("land breeze","A land breeze blows from land to sea at NIGHT, when the land cools faster; the daytime sea-to-land wind is the sea breeze."),
    ("monsoon wind","Monsoon winds are seasonal winds over months; the daily day-time coastal wind is the sea breeze."),
    ("cyclone","A cyclone is a violent storm system, not the gentle daily coastal wind called the sea breeze.")]),

 ("HE","Water and most liquids are heated by convection, in which the heated liquid:",
   "rises and cooler liquid sinks to take its place",
   C("On heating, a liquid expands, becomes lighter and rises; cooler, denser liquid sinks to replace it, setting up convection currents that spread the heat.")+
   steps("Heated water at the bottom expands and grows lighter","it rises while cooler heavier water sinks","this circulation is a convection current.")+
   U("In a pot of boiling water you can see the swirling currents carrying heat upward."),
   [("stays at the bottom and gets denser","Heated liquid expands and grows LIGHTER, so it rises; it does not stay heavy at the bottom."),
    ("turns solid as it warms","Warming a liquid does not solidify it; convection is about hot liquid rising, not freezing."),
    ("passes heat without moving","That description is conduction; in convection the heated liquid itself moves and carries the heat.")]),

 ("HE","Two equal cups of tea start at 80 °C. After ten minutes the open cup is 50 °C and the lidded cup is 64 °C. The open cup lost how many more degrees?",
   "14 °C more",
   C("Open cup fell 80 − 50 = 30 °C; lidded cup fell 80 − 64 = 16 °C. The open cup lost 30 − 16 = 14 °C more, because its lid-free surface let heat escape faster.")+
   steps("Open cup drop = 80 - 50 = 30","Lidded cup drop = 80 - 64 = 16","Extra loss = 30 - 16 = 14 deg C.")+
   U("Covering food keeps it warm longer because a lid slows heat loss — and the maths shows by how much."),
   [("30 °C more","30 °C is the open cup's TOTAL drop, not the EXTRA over the lidded cup; the difference of the two drops is 14 °C."),
    ("16 °C more","16 °C is the lidded cup's own drop; the open cup lost 30 - 16 = 14 °C MORE, not 16."),
    ("46 °C more","46 °C would add the two drops; the question asks the DIFFERENCE, 30 - 16 = 14 °C.")]),

 ("HE","Over four days the noon temperatures were 31, 33, 30 and 34 °C. The mean (average) noon temperature was:",
   "32 °C",
   C("Add the readings and divide by how many there are: (31 + 33 + 30 + 34) ÷ 4 = 128 ÷ 4 = 32 °C.")+
   steps("Sum = 31 + 33 + 30 + 34 = 128","Divide by 4 readings: 128 / 4","Mean = 32 deg C.")+
   U("A weather report's 'average temperature' for the week is found exactly this way."),
   [("31 °C","31 °C is just one day's reading; the average needs the SUM (128) divided by 4, giving 32 °C."),
    ("33 °C","33 °C is the highest day, not the mean; 128 / 4 = 32 °C."),
    ("128 °C","128 °C is the TOTAL of the four readings; you must still divide by 4 to get the mean, 32 °C.")]),

 ("HE","A liquid thermometer works because the liquid inside it, on being heated:",
   "expands and rises up the thin tube",
   C("Heat makes the liquid expand; with nowhere to go but up the very thin bore, its thread climbs higher, marking a higher temperature.")+
   steps("Heating makes the liquid expand","the only escape is up the narrow tube","so the thread rises to show a higher temperature.")+
   U("On a hot day you can watch the red or silver thread of a thermometer climb up the scale."),
   [("contracts and falls down the tube","Heating EXPANDS the liquid so the thread rises; it falls only on COOLING, when the liquid contracts."),
    ("changes into a gas","The liquid does not boil away inside a thermometer; it simply expands and rises while staying liquid."),
    ("changes colour with heat","A thermometer reads heat by the liquid's LEVEL, not by any colour change.")]),

 ("HE","A maximum–minimum thermometer is useful to a weather station because in one reading it tells the:",
   "highest and lowest temperature of the day",
   C("A max–min thermometer records both the day's highest and lowest temperatures, so a single check captures the full daily swing.")+
   steps("The day's heat rises then falls","this thermometer locks in both the top and bottom marks","so one reading gives the day's highest and lowest.")+
   U("Weather records of daily 'highs and lows' come from a maximum–minimum thermometer."),
   [("average temperature directly","It marks the extremes, not the average; you must still compute the mean from the highs and lows yourself."),
    ("humidity of the air","Moisture in air is read by a hygrometer; this thermometer records temperature extremes only."),
    ("wind speed at noon","Wind speed is an anemometer's job; a max–min thermometer records temperature, not wind.")]),

 ("HE","In cold weather a woollen sweater keeps the body warm chiefly because its fibres:",
   "trap air, which is a poor conductor of heat",
   C("Wool traps tiny pockets of air between its fibres, and trapped air is a poor conductor, so body heat is held in and the cold is kept out.")+
   steps("Wool fibres hold pockets of still air","trapped air conducts heat very poorly","so body heat stays in and we feel warm.")+
   U("Two thin layers can be warmer than one thick one because they trap an extra layer of air."),
   [("produce heat by themselves","Wool makes no heat of its own; it keeps you warm by trapping the air that holds in your body heat."),
    ("are good conductors of heat","A good conductor would let body heat escape fast; wool is warm because trapped air is a POOR conductor."),
    ("reflect all body heat like a mirror","Wool warms by trapping insulating air, not by mirror-like reflection of heat.")]),

 ("HE","At night a land breeze blows from the land toward the sea because, after sunset, the:",
   "land cools faster than the sea",
   C("Water holds heat longer than land, so after sunset the land cools faster; warm air now rises over the sea and cooler air flows out from the land — the land breeze.")+
   steps("Land loses heat faster than water at night","air rises over the still-warm sea and land air flows out to replace it","so the night-time wind blows land to sea.")+
   U("Fishermen often set out at night helped along by the land breeze."),
   [("sea cools faster than the land","Water cools SLOWER than land, so at night the land is cooler and the breeze flows land to sea."),
    ("land and sea cool at the same rate","If both cooled equally there would be no breeze; the land cools faster, driving the night-time land breeze."),
    ("the Sun heats the land at night","There is no sunshine at night; the land breeze arises because the land has COOLED faster than the sea.")]),

 ("HE","One end of an iron rod is held in a flame. The far end becomes hot too because heat is passed along by the:",
   "vibrating particles passing energy to their neighbours",
   C("In a solid, the heated particles vibrate harder and jostle their neighbours, passing energy along the rod — conduction — without the particles travelling.")+
   steps("Flame makes the near-end particles vibrate harder","each jostles the next particle along","so energy travels the rod by conduction.")+
   U("Stirring hot food with a metal spoon, you feel the handle warm as heat conducts up it."),
   [("particles physically travelling to the far end","In a solid the particles stay in place; they pass energy by vibration, they do not move along the rod."),
    ("light shining from the flame","The far end heats by conduction through the metal, not by light from the flame."),
    ("air currents inside the metal","Air currents (convection) occur in fluids; a solid iron rod heats by conduction.")]),

 ("HE","On a sunny day a dark-coloured car gets hotter inside than a white one because dark surfaces:",
   "absorb more heat than light surfaces",
   C("Dark surfaces absorb most of the heat that falls on them, while light surfaces reflect it, so the dark car heats up far more.")+
   steps("Dark colours soak up heat rather than reflecting it","more heat is absorbed into the dark car","so it grows hotter inside than the white one.")+
   U("Solar water heaters are painted black so they absorb the maximum heat from the Sun."),
   [("reflect more heat than light surfaces","Reflecting is what LIGHT surfaces do, keeping them cool; dark surfaces get hot by ABSORBING heat."),
    ("are always made of thicker metal","Colour, not thickness, decides the absorption; a dark thin panel still absorbs more heat than a white one."),
    ("let heat pass straight through","Dark paint does not let heat pass through; it absorbs heat, which is why the car warms up.")]),

 ("HE","A laboratory thermometer differs from a clinical one mainly in that the laboratory thermometer:",
   "reads a much wider range, often −10 °C to 110 °C",
   C("A lab thermometer must measure many experiments, from below freezing to above boiling, so its scale is wide — about −10 °C to 110 °C — unlike the narrow clinical range.")+
   steps("Lab work may go below 0 deg C or above 100 deg C","the scale must cover all of that","so it spans roughly -10 to 110 deg C.")+
   U("Heating water in a beaker, a lab thermometer can follow it right up past 100 °C."),
   [("can only measure body heat","That is the CLINICAL thermometer's narrow job; the lab thermometer covers a much wider range."),
    ("does not use any liquid","Most lab thermometers still use a liquid that expands; the real difference is the much wider scale."),
    ("shows temperature in metres","Temperature is read in degrees, never metres; the lab thermometer simply has a wider degree scale.")]),

 ("HE","In physics, heat is most correctly classified as a form of what?",
   "energy",
   C("Heat is a form of energy that flows because of a temperature difference; it is measured in joules and makes particles move faster.")+
   steps("Heat can do work and is gained or lost","that capacity marks it as a kind of energy","so heat is a form of energy.")+
   U("The chemical energy in fuel becomes heat energy that boils your water."),
   [("matter","Matter has mass and takes up space; heat is energy that flows, not a substance made of matter."),
    ("temperature","Temperature MEASURES hotness; heat is the ENERGY that flows from hot to cold, a related but different idea."),
    ("a force","A force is a push or pull measured in newtons; heat is energy measured in joules, not a force.")]),

 ("HE","Sea coasts have a milder climate than inland places largely because water, compared with land:",
   "heats up and cools down more slowly",
   C("Water changes temperature slowly, so the sea warms and cools the nearby air gently, keeping coasts from the sharp highs and lows that land-locked places feel.")+
   steps("Water gains and loses heat slowly","the sea steadies the air's temperature near the coast","so coastal climates are milder than inland ones.")+
   U("Mumbai by the sea has milder swings than Delhi far inland, partly for this reason."),
   [("heats up and cools down faster","Water actually changes temperature SLOWER than land; that slowness is what makes coastal climates mild."),
    ("cannot absorb any heat","Water absorbs a great deal of heat; it simply does so slowly, which steadies coastal temperatures."),
    ("blocks all wind from the land","The sea does not block wind; its mild climate comes from water's slow heating and cooling.")]),

 ("HE","On five nights the lowest temperatures were 12, 9, 15, 9 and 10 °C. The range of these night readings is:",
   "6 °C",
   C("Range = highest − lowest = 15 − 9 = 6 °C, the spread of the night temperatures.")+
   steps("Highest reading = 15, lowest = 9","Range = 15 - 9","Range = 6 deg C.")+
   U("Meteorologists quote a 'temperature range' to show how much the weather swung that week."),
   [("9 °C","9 °C is the LOWEST reading (and the mode); the range is highest minus lowest, 15 - 9 = 6 °C."),
    ("15 °C","15 °C is just the highest reading; the range is the SPREAD, 15 - 9 = 6 °C."),
    ("11 °C","11 °C is close to the average, not the range; range = highest - lowest = 6 °C.")]),

 ("HE","A thermos flask keeps drinks hot for hours mainly because the vacuum between its double walls:",
   "stops heat loss by conduction and convection",
   C("With no particles in the gap, neither conduction nor convection can carry heat across it, so the drink's heat is trapped inside the flask.")+
   steps("The double walls have a vacuum between them","no particles means no conduction or convection across the gap","so heat cannot escape and the drink stays hot.")+
   U("The same flask keeps cold drinks cold too, by blocking heat from getting in."),
   [("speeds up heat loss by radiation","The shiny silvered walls REDUCE radiation; the vacuum is there to STOP heat loss, not speed it up."),
    ("adds heat energy to the drink","A flask adds no heat; it only slows the heat already in the drink from escaping."),
    ("lets air circulate to keep it warm","Circulating air would carry heat away by convection; the vacuum prevents exactly that.")]),

 ("HE","Why do we often wear loose, light cotton clothes in summer rather than tight ones?",
   "they let air move over the skin so sweat evaporates and cools us",
   C("Loose light cotton lets air reach the skin; sweat then evaporates easily, and evaporation cools the body, so we feel comfortable in the heat.")+
   steps("Loose cotton lets air flow over the skin","sweat evaporates into that moving air","and evaporation cools the body in summer.")+
   U("After exercise a breeze feels cooling because it speeds the evaporation of your sweat."),
   [("they trap a thick layer of warm air","Trapping warm air is what we want in WINTER; in summer we want air movement to cool us by evaporation."),
    ("cotton produces cool air by itself","Cloth makes no cool air; loose cotton simply lets sweat evaporate, and evaporation does the cooling."),
    ("they reflect all the body's heat back in","Reflecting heat inward would make us hotter; loose cotton cools by aiding evaporation of sweat.")]),

 ("HE","Why is the bulb of a clinical thermometer made small and the bore (tube) very narrow?",
   "so even a small heat change makes the thread move a lot, giving a sensitive reading",
   C("A small bulb of liquid expands quickly, and a very narrow bore makes even a tiny expansion push the thread far, so small temperature changes show clearly.")+
   steps("A small bulb of liquid responds fast to heat","a narrow bore turns a tiny expansion into a long rise","so the thermometer reads small changes sensitively.")+
   U("This sensitivity lets a clinical thermometer show the small rise of a mild fever."),
   [("so it can hold a very large amount of liquid","A small bulb holds LITTLE liquid; the point is sensitivity, not a large quantity."),
    ("so it can measure very high temperatures","The narrow bore is for sensitivity near body heat, not for reaching high temperatures — that needs a lab thermometer."),
    ("so the glass does not break in heat","The shape is chosen for a sensitive reading; ordinary clinical use is well below any breaking heat.")]),
]

# ---------- NUTRITION IN PLANTS (25) — several fused with Fractions/Data ----------
NP = [
 ("NP","The process by which green plants make their own food using sunlight, water and carbon dioxide is:",
   "photosynthesis",
   C("In photosynthesis, green leaves use sunlight, water and carbon dioxide to make their own food (glucose), releasing oxygen.")+
   steps("Green plants capture sunlight in their leaves","they combine water and carbon dioxide to make food","this food-making process is photosynthesis.")+
   U("The oxygen you breathe is released by plants during photosynthesis."),
   [("respiration","Respiration RELEASES energy from food using oxygen; photosynthesis MAKES the food using sunlight."),
    ("digestion","Digestion breaks food down; photosynthesis builds food up in green leaves from simple raw materials."),
    ("transpiration","Transpiration is loss of water vapour from leaves; making food in light is photosynthesis.")]),

 ("NP","Which green pigment, present in a plant's leaves, traps sunlight so that photosynthesis can take place?",
   "chlorophyll",
   C("Chlorophyll, the green pigment in leaves, traps the Sun's energy and so makes photosynthesis possible.")+
   steps("Leaves look green because of this pigment","it captures the energy of sunlight","that pigment is chlorophyll.")+
   U("Leaves turn yellow in autumn as their chlorophyll breaks down and the green fades."),
   [("haemoglobin","Haemoglobin carries oxygen in animal BLOOD; the green pigment that traps sunlight in plants is chlorophyll."),
    ("starch","Starch is the FOOD plants store; the green pigment that captures sunlight is chlorophyll."),
    ("cellulose","Cellulose builds the plant's cell walls; the light-capturing green pigment is chlorophyll.")]),

 ("NP","Tiny pores on the surface of a leaf through which gases enter and leave are called:",
   "stomata",
   C("Stomata are tiny pores, mostly on the underside of leaves, through which carbon dioxide enters and oxygen and water vapour leave.")+
   steps("Leaves must take in carbon dioxide and let out oxygen","tiny adjustable pores allow this gas exchange","these pores are the stomata.")+
   U("On a hot day many stomata close to slow the leaf's water loss."),
   [("veins","Veins carry water and food THROUGH the leaf; the surface pores for gas exchange are the stomata."),
    ("roots","Roots take in water from the soil; the leaf pores for gases are the stomata."),
    ("chloroplasts","Chloroplasts are the cell parts that hold chlorophyll; the leaf-surface pores for gases are the stomata.")]),

 ("NP","Plants that make their own food by photosynthesis are called:",
   "autotrophs",
   C("Autotrophs ('self-feeders') make their own food from simple raw materials — green plants are the chief example.")+
   steps("Green plants build their own food from sunlight, water and carbon dioxide","an organism that feeds itself this way","is called an autotroph.")+
   U("Because plants are autotrophs, they form the base of almost every food chain."),
   [("heterotrophs","Heterotrophs depend on OTHERS for food, like animals; plants that make their own food are autotrophs."),
    ("parasites","Parasites take ready-made food from a host; green food-makers are autotrophs, the opposite."),
    ("decomposers","Decomposers feed on dead matter; green plants that make their own food are autotrophs.")]),

 ("NP","Animals and most non-green organisms, which cannot make their own food, are called:",
   "heterotrophs",
   C("Heterotrophs ('other-feeders') cannot make their own food and must take it from plants or other organisms.")+
   steps("An organism that cannot photosynthesise must get food elsewhere","it depends on other living things for nourishment","so it is called a heterotroph.")+
   U("A goat eating grass is a heterotroph living on food the grass made."),
   [("autotrophs","Autotrophs MAKE their own food; organisms that must take food from others are heterotrophs."),
    ("producers","Producers (green plants) make food; the consumers that depend on them are heterotrophs."),
    ("chlorophyll-bearing","Having chlorophyll lets an organism make food (autotroph); heterotrophs lack that ability.")]),

 ("NP","Cuscuta (amarbel), a leafless yellow climber that takes food from the plant it twines around, is a:",
   "parasite",
   C("Cuscuta has no chlorophyll, so it cannot make food; it sends suckers into a host plant and steals the host's ready-made food — it is a parasite.")+
   steps("Cuscuta is yellow with no chlorophyll, so cannot photosynthesise","it draws food from the host it climbs on","so it is a parasitic plant.")+
   U("Farmers remove amarbel because it weakens the crop it feeds on."),
   [("saprotroph","A saprotroph feeds on DEAD, decaying matter; Cuscuta takes food from a LIVING host, so it is a parasite."),
    ("autotroph","An autotroph makes its own food; Cuscuta has no chlorophyll and steals food, so it is a parasite, not an autotroph."),
    ("insectivorous plant","Insectivorous plants trap insects for nitrogen; Cuscuta draws food from a host plant, making it a parasite.")]),

 ("NP","The pitcher plant traps and digests insects mainly to obtain the nutrient:",
   "nitrogen",
   C("Pitcher plants grow in soil poor in nitrogen, so they trap insects and digest them to get the nitrogen they need; they still photosynthesise for their energy food.")+
   steps("Their boggy soil is poor in nitrogen","insects are rich in nitrogen-containing proteins","so the plant digests insects to gain nitrogen.")+
   U("Other insect-eating plants like the Venus flytrap also live in nitrogen-poor soils."),
   [("carbon","The plant gets its carbon from carbon dioxide during photosynthesis; it traps insects for the missing NITROGEN."),
    ("sunlight","Sunlight is captured by its green parts for photosynthesis; insects are caught for the nutrient nitrogen, not light."),
    ("water","Water comes from the boggy soil and rain; insects supply the scarce nutrient nitrogen, not water.")]),

 ("NP","Fungi such as bread mould, which feed on dead and decaying matter, are called:",
   "saprotrophs",
   C("Saprotrophs secrete digestive juices onto dead matter and absorb the dissolved food — fungi like bread mould feed this way.")+
   steps("The mould lands on dead bread","it pours out juices that dissolve the food and absorbs it","feeding on dead matter this way makes it a saprotroph.")+
   U("Saprotrophic fungi help recycle nutrients by rotting fallen leaves and dead wood."),
   [("parasites","Parasites feed on LIVING hosts; saprotrophs like bread mould feed on DEAD, decaying matter."),
    ("autotrophs","Autotrophs make their own food in light; fungi have no chlorophyll and feed on dead matter as saprotrophs."),
    ("insectivores","Insectivores trap living insects; saprotrophic fungi absorb food from dead, decaying material instead.")]),

 ("NP","In the lichen, a fungus and an alga live together helping each other. This close partnership is called:",
   "symbiosis",
   C("In symbiosis two different organisms live together and both benefit: in a lichen the alga makes food while the fungus provides shelter, water and minerals.")+
   steps("Fungus and alga live closely and each gains","such a mutually helpful partnership","is called symbiosis.")+
   U("Rhizobium bacteria living in root nodules of pulses is another famous symbiosis."),
   [("parasitism","In parasitism one partner is HARMED; in symbiosis like the lichen BOTH benefit."),
    ("predation","Predation is one organism eating another; symbiosis is a mutually helpful living-together."),
    ("competition","Competition is organisms struggling against each other for resources; symbiosis is cooperation that helps both.")]),

 ("NP","How do Rhizobium bacteria, housed in the root nodules of legume crops, benefit their host plant?",
   "fixing nitrogen from the air into a usable form",
   C("Rhizobium take nitrogen gas from the air and turn it into compounds the plant can use, so legumes can grow in nitrogen-poor soil — a true symbiosis.")+
   steps("Plants cannot use nitrogen gas directly","Rhizobium in the root nodules convert it to a usable form","so the legume gets the nitrogen it needs.")+
   U("Farmers grow pulses like gram to naturally enrich the soil with nitrogen."),
   [("making the plant's chlorophyll for it","Plants make their own chlorophyll; Rhizobium's gift is converting air nitrogen into a usable form."),
    ("digesting insects for the plant","That is what pitcher plants do; Rhizobium fix NITROGEN from the air, they do not trap insects."),
    ("carrying water up from the roots","Water is carried by the plant's own xylem; Rhizobium's role is fixing nitrogen.")]),

 ("NP","Why do farmers add manure or fertilisers to fields and rotate crops?",
   "to replace the soil nutrients, especially nitrogen, that crops use up",
   C("Crops draw nutrients like nitrogen from the soil. Manure, fertilisers and growing legumes in rotation put those nutrients back so the soil stays fertile.")+
   steps("Each crop removes nutrients, mainly nitrogen, from the soil","manure, fertiliser or legumes restore them","so the next crop can grow well.")+
   U("Rotating wheat with a pulse crop lets Rhizobium naturally refill the soil's nitrogen."),
   [("to give the plants their green colour","Green colour comes from chlorophyll the plant makes; fertilisers replace soil NUTRIENTS used by crops."),
    ("to trap insects in the soil","Fertilisers do not trap insects; they restore nutrients, mainly nitrogen, that crops remove."),
    ("to block sunlight from the roots","Roots are already underground; fertilisers replenish soil nutrients, they do not deal with sunlight.")]),

 ("NP","During photosynthesis the gas a green leaf takes IN from the air is:",
   "carbon dioxide",
   C("Leaves take in carbon dioxide through their stomata and use it with water to build food, giving out oxygen.")+
   steps("Photosynthesis needs a carbon source from the air","leaves draw in carbon dioxide through their stomata","so carbon dioxide is the gas taken in.")+
   U("Plants help clean the air by absorbing the carbon dioxide we breathe out."),
   [("oxygen","Oxygen is GIVEN OUT during photosynthesis; the gas taken IN to make food is carbon dioxide."),
    ("nitrogen","Plants cannot use air nitrogen directly; the gas taken in for photosynthesis is carbon dioxide."),
    ("hydrogen","There is little free hydrogen in air; the leaf takes in carbon dioxide for photosynthesis.")]),

 ("NP","The food made by green leaves is mainly stored in the plant in the form of:",
   "starch",
   C("Glucose made in photosynthesis is converted to starch and stored; that is why we test a leaf for starch to show photosynthesis happened.")+
   steps("Leaves first make glucose in the light","extra glucose is stored as starch","so starch is the plant's stored food.")+
   U("A potato is largely starch — food the potato plant stored underground."),
   [("oxygen","Oxygen is a gas RELEASED, not a stored food; plants store their food as starch."),
    ("chlorophyll","Chlorophyll is the green pigment that captures light, not a stored food; food is stored as starch."),
    ("water","Water is a raw material taken from the soil; the food the plant makes and stores is starch.")]),

 ("NP","If iodine solution is dropped on a leaf that has photosynthesised, the leaf turns blue-black, which shows the presence of:",
   "starch",
   C("Iodine turns blue-black with starch. A leaf that has made food in the light contains starch, so it gives this blue-black colour.")+
   steps("Iodine is the classic test for starch","a photosynthesising leaf has stored starch","so it turns iodine blue-black.")+
   U("The same iodine test shows rice and bread are rich in starch."),
   [("oxygen","Oxygen is a gas and gives no colour with iodine; the blue-black shows STARCH made in the leaf."),
    ("chlorophyll","Chlorophyll is destained away before the test; the blue-black colour comes from starch, not chlorophyll."),
    ("protein","Iodine's blue-black test is for STARCH, not protein; the colour proves starch was made.")]),

 ("NP","A leaf has about 60 000 stomata in all, and 5 out of every 6 are on its lower surface. How many stomata are on the lower surface?",
   "50 000",
   C("'5 out of every 6' means the fraction 5/6 of the total. So 5/6 of 60 000 = 60 000 ÷ 6 × 5 = 10 000 × 5 = 50 000.")+
   steps("Lower surface share = 5/6 of 60 000","60 000 / 6 = 10 000, then x 5","= 50 000 stomata.")+
   U("Most leaves keep their stomata underneath, away from direct Sun, to lose less water — and the maths shows just how many."),
   [("10 000","10 000 is only ONE-sixth (60 000 / 6); the lower surface holds FIVE-sixths, which is 50 000."),
    ("12 000","12 000 comes from dividing by 5; 5/6 of 60 000 is 60 000 / 6 x 5 = 50 000."),
    ("55 000","55 000 is a guess near the total; 5/6 of 60 000 works out exactly to 50 000.")]),

 ("NP","In a forest survey, 3/5 of the plants were green food-makers and the rest were fungi. What fraction were fungi?",
   "2/5",
   C("The whole is 1 (or 5/5). If 3/5 are green plants, the fungi are 5/5 − 3/5 = 2/5.")+
   steps("Whole = 5/5","Fungi = 5/5 - 3/5","= 2/5 of the plants.")+
   U("Ecologists often describe a habitat by such fractions — what share is producers, what share decomposers."),
   [("3/5","3/5 is the share of GREEN plants; the fungi make up the REST, 5/5 - 3/5 = 2/5."),
    ("1/5","1/5 is too small; the leftover after 3/5 is 2/5, not 1/5."),
    ("3/2","A fraction of a whole cannot exceed 1; the fungi share is 2/5, well under one.")]),

 ("NP","Why are most stomata found on the LOWER surface of a leaf rather than the upper?",
   "to reduce water loss, since the lower surface is cooler and out of direct Sun",
   C("The shaded, cooler underside loses less water vapour through open stomata than the Sun-baked upper surface would, so the plant conserves water.")+
   steps("The upper surface faces direct, drying Sun","the lower surface is cooler and shaded","so stomata sit underneath to lose less water.")+
   U("Plants in dry places carry this further, with very few, sunken stomata to save water."),
   [("to catch more sunlight for photosynthesis","Sunlight is captured by chlorophyll across the leaf, not by stomata; their lower position is to save water."),
    ("to let rain fall straight into them","Stomata do not collect rain; they sit underneath to reduce water LOSS, not to gather water."),
    ("because the upper surface has no cells","The upper surface is full of cells; stomata are mostly below to cut water loss in the Sun.")]),

 ("NP","The three things, besides chlorophyll, that a green leaf needs to carry out photosynthesis are:",
   "sunlight, water and carbon dioxide",
   C("With chlorophyll to trap energy, a leaf still needs sunlight (the energy), water (from the roots) and carbon dioxide (from the air) to make food.")+
   steps("Energy comes from sunlight","raw materials are water and carbon dioxide","so these three, plus chlorophyll, drive photosynthesis.")+
   U("Take away any one — say, keep a plant in the dark — and it cannot make food."),
   [("oxygen, soil and warmth","Oxygen is RELEASED, not used, in photosynthesis; the needs are sunlight, water and carbon dioxide."),
    ("nitrogen, starch and air","Starch is the PRODUCT, not a raw material; photosynthesis needs sunlight, water and carbon dioxide."),
    ("sunlight, oxygen and salt","Oxygen is given out, not taken in; the correct raw materials are sunlight, water and carbon dioxide.")]),

 ("NP","Insectivorous plants still have green leaves and can photosynthesise. They trap insects only because their soil is poor in:",
   "nitrogen",
   C("Their green leaves make food in the usual way; the soil simply lacks nitrogen, so they catch insects to top up that one nutrient.")+
   steps("Green leaves still photosynthesise for energy food","the boggy soil is short of nitrogen","so insects supply the missing nitrogen.")+
   U("This is why a pitcher plant can live where ordinary plants would starve of nitrogen."),
   [("sunlight","Sunlight comes from above, not the soil; the soil shortage these plants make up for is nitrogen."),
    ("water","Their wet, boggy soil has plenty of water; what it lacks, and insects supply, is nitrogen."),
    ("carbon dioxide","Carbon dioxide comes from the air, not the soil; insects are trapped to gain nitrogen.")]),

 ("NP","Oxygen is released by green plants as a by-product of:",
   "photosynthesis",
   C("When leaves split water during photosynthesis to make food, oxygen is given off as a by-product into the air.")+
   steps("Photosynthesis breaks down water inside the leaf","oxygen is left over and released","so oxygen is a by-product of photosynthesis.")+
   U("Forests and ocean plankton replenish much of the oxygen we breathe through photosynthesis."),
   [("respiration","Respiration USES oxygen and gives out carbon dioxide; oxygen is RELEASED during photosynthesis."),
    ("transpiration","Transpiration releases water VAPOUR, not oxygen; oxygen comes from photosynthesis."),
    ("digestion in roots","Roots absorb water and minerals; oxygen is released by the leaves during photosynthesis.")]),

 ("NP","Why must non-green parasitic plants like Cuscuta attach to a host?",
   "they lack chlorophyll, so they cannot make their own food",
   C("Without chlorophyll a plant cannot photosynthesise, so Cuscuta cannot feed itself and must draw ready-made food from a green host.")+
   steps("Cuscuta has no chlorophyll","so it cannot make food by photosynthesis","therefore it must take food from a host plant.")+
   U("Any plant that loses its green colour entirely would face the same problem — no chlorophyll, no self-made food."),
   [("they need extra water only from the host","Cuscuta takes ready-made FOOD, not just water; it must do so because it lacks chlorophyll to make food."),
    ("the host gives them sunlight","Hosts do not give sunlight; Cuscuta clings to a host for FOOD because it cannot photosynthesise."),
    ("they grow too tall to stand alone","Cuscuta attaches for food, not support; lacking chlorophyll it cannot feed itself.")]),

 ("NP","A class lists what each named plant eats. Cuscuta on a host, bread mould on dead bread, and a mango tree in the Sun are, in order:",
   "parasite, saprotroph, autotroph",
   C("Cuscuta steals food from a living host (parasite); bread mould feeds on dead matter (saprotroph); a mango tree makes its own food in sunlight (autotroph).")+
   steps("Cuscuta takes food from a living host -> parasite","mould feeds on dead bread -> saprotroph","mango tree makes its own food -> autotroph.")+
   U("Sorting living things by HOW they feed is a basic step in studying any ecosystem."),
   [("autotroph, parasite, saprotroph","Cuscuta cannot make its own food, so it is not an autotroph; the right order is parasite, saprotroph, autotroph."),
    ("saprotroph, parasite, autotroph","Cuscuta feeds on a LIVING host (parasite), and mould on DEAD bread (saprotroph); the order is parasite, saprotroph, autotroph."),
    ("parasite, autotroph, saprotroph","Bread mould feeds on dead matter (saprotroph), not as an autotroph; the order is parasite, saprotroph, autotroph.")]),

 ("NP","The raw material that a plant draws up from the SOIL for photosynthesis, along with minerals, is:",
   "water",
   C("Roots absorb water (and dissolved minerals) from the soil and send it up to the leaves, where it joins carbon dioxide to make food.")+
   steps("Carbon dioxide comes from the air","but water is drawn from the soil by the roots","so water is the soil-supplied raw material.")+
   U("A wilting plant cannot photosynthesise well because its leaves are short of water."),
   [("carbon dioxide","Carbon dioxide comes from the AIR through the stomata, not the soil; the soil supplies water."),
    ("oxygen","Oxygen is released by the leaf, not drawn from the soil; the roots take up water."),
    ("sunlight","Sunlight comes from above and is captured by chlorophyll; from the soil the plant draws water.")]),

 ("NP","Why are green plants called the 'producers' in a food chain?",
   "they make food that all other organisms ultimately depend on",
   C("Only green plants build food from simple raw materials using sunlight; every other organism eats them or eats something that ate them, so plants are the producers.")+
   steps("Green plants make food from sunlight, water and carbon dioxide","all consumers trace their food back to plants","so plants are the producers of the food chain.")+
   U("Whether you eat a salad or a chicken, the energy began with a green plant's photosynthesis."),
   [("they are the largest living things","Size is not the reason; plants are producers because they MAKE the food others depend on."),
    ("they live the longest of all organisms","Lifespan is not the point; plants are called producers for making the food at the base of the chain."),
    ("they eat the remains of dead animals","Eating dead matter describes decomposers; producers are green plants that MAKE food.")]),

 ("NP","The tiny green structures inside leaf cells that contain chlorophyll and where photosynthesis takes place are the:",
   "chloroplasts",
   C("Chloroplasts are the green, disc-shaped structures inside leaf cells; they hold the chlorophyll and are where the leaf actually makes food.")+
   steps("Chlorophyll must be held somewhere in the cell","it sits inside green structures called chloroplasts","and that is where photosynthesis happens.")+
   U("Under a microscope you can see leaf cells dotted with tiny green chloroplasts."),
   [("stomata","Stomata are surface PORES for gas exchange; the green food-making structures inside cells are chloroplasts."),
    ("root hairs","Root hairs absorb water in the soil; the leaf structures holding chlorophyll are the chloroplasts."),
    ("veins","Veins carry water and food through the leaf; photosynthesis happens in the chloroplasts.")]),
]

# ---------- FRACTIONS & DECIMALS (25) — several fused with Science contexts ----------
FD = [
 ("FD","Among the four fractions 3/4, 2/3, 1/2 and 5/12, which one has the greatest value?",
   "3/4",
   C("With a common denominator of 12: 3/4 = 9/12, 2/3 = 8/12, 1/2 = 6/12, 5/12 stays 5/12. The biggest numerator (9) wins, so 3/4 is largest.")+
   steps("Make a common denominator 12","3/4 = 9/12, 2/3 = 8/12, 1/2 = 6/12, 5/12 = 5/12","9/12 is biggest, so 3/4 is the largest.")+
   U("Comparing fractions this way tells you which slice of a pizza is the biggest."),
   [("2/3","2/3 = 8/12, which is less than 3/4 = 9/12; 3/4 is the largest."),
    ("1/2","1/2 = 6/12, the smaller side of half; 3/4 = 9/12 is larger."),
    ("5/12","5/12 is the smallest here; 3/4 = 9/12 is the largest.")]),

 ("FD","What is 2/3 + 1/4?",
   "11/12",
   C("The LCM of 3 and 4 is 12: 2/3 = 8/12 and 1/4 = 3/12, so 8/12 + 3/12 = 11/12.")+
   steps("Common denominator 12","2/3 = 8/12, 1/4 = 3/12","8/12 + 3/12 = 11/12.")+
   U("Adding 2/3 of a cup and 1/4 of a cup of flour means measuring out 11/12 of a cup."),
   [("3/7","Adding tops and bottoms (2+1 over 3+4) is wrong for fractions; with denominator 12 the answer is 11/12."),
    ("3/12","3/12 is only the 1/4 part rewritten; you must add 8/12 to it, giving 11/12."),
    ("11/7","The denominator stays 12 after finding a common denominator, not 7; the sum is 11/12.")]),

 ("FD","What is 3/5 of 200?",
   "120",
   C("'of' means multiply: 3/5 × 200 = 200 ÷ 5 × 3 = 40 × 3 = 120.")+
   steps("200 / 5 = 40","40 x 3 = 120","so 3/5 of 200 = 120.")+
   U("If 3/5 of a 200-page book is read, that's 120 pages done."),
   [("60","60 is 3/5 of 100, not of 200; 3/5 of 200 is 120."),
    ("40","40 is just ONE-fifth of 200; three-fifths is 40 x 3 = 120."),
    ("80","80 is 2/5 of 200; three-fifths is 120.")]),

 ("FD","What is 1/2 × 4/5?",
   "2/5",
   C("Multiply numerators and denominators: (1×4)/(2×5) = 4/10, which simplifies to 2/5.")+
   steps("1 x 4 = 4, and 2 x 5 = 10","4/10","simplifies to 2/5.")+
   U("Half of 4/5 of a chocolate bar is 2/5 of the whole bar."),
   [("4/7","You multiply across (4/10), not add denominators; the answer simplifies to 2/5."),
    ("5/8","This mixes the numbers wrongly; 1/2 x 4/5 = 4/10 = 2/5."),
    ("4/5","4/5 is the original fraction; taking HALF of it gives 2/5.")]),

 ("FD","What is 3/4 ÷ 1/2?",
   "3/2 (or 1½)",
   C("To divide by a fraction, multiply by its reciprocal: 3/4 ÷ 1/2 = 3/4 × 2/1 = 6/4 = 3/2.")+
   steps("Flip the divisor: 1/2 becomes 2/1","3/4 x 2/1 = 6/4","= 3/2 = 1 1/2.")+
   U("How many half-litre cups fill 3/4 of a litre? 3/2, that is one and a half cups."),
   [("3/8","3/8 comes from multiplying by 1/2 instead of dividing; dividing means x 2/1, giving 3/2."),
    ("3/6","3/6 = 1/2 is far too small; 3/4 divided by 1/2 is 3/2, which is bigger than 3/4."),
    ("2/3","2/3 is the reciprocal-mistake; 3/4 ÷ 1/2 = 3/4 x 2 = 3/2.")]),

 ("FD","Expressed in decimal form, the fraction seven-tenths (7/10) is equal to:",
   "0.7",
   C("A denominator of 10 means one decimal place: 7/10 = 0.7 (seven tenths).")+
   steps("Denominator 10 -> tenths place","7 tenths","is written 0.7.")+
   U("7/10 of a metre is 0.7 m, or 70 centimetres."),
   [("0.07","0.07 is seven HUNDREDTHS (7/100); seven TENTHS is 0.7."),
    ("7.0","7.0 is the whole number seven; seven tenths is the fraction 0.7."),
    ("1.7","1.7 is more than one; 7/10 is less than one, namely 0.7.")]),

 ("FD","What is 0.25 + 0.4?",
   "0.65",
   C("Line up the decimal points (0.25 + 0.40) and add: 0.65.")+
   steps("Write 0.4 as 0.40","0.25 + 0.40","= 0.65.")+
   U("Adding 0.25 kg and 0.4 kg of vegetables gives 0.65 kg in the bag."),
   [("0.29","0.29 comes from adding 0.25 + 0.04; but 0.4 is 0.40, so the sum is 0.65."),
    ("0.65 is wrong, 6.5","6.5 misplaces the decimal point; 0.25 + 0.40 = 0.65, not 6.5."),
    ("0.45","0.45 ignores the 0.2; 0.25 + 0.40 = 0.65.")]),

 ("FD","Two rainfall gauges read 1.6 cm and 0.85 cm. The total rainfall recorded is:",
   "2.45 cm",
   C("Line up the decimal points: 1.60 + 0.85 = 2.45 cm.")+
   steps("Write 1.6 as 1.60","1.60 + 0.85","= 2.45 cm.")+
   U("Weather stations add up daily decimal readings exactly like this to report total rainfall."),
   [("2.41 cm","2.41 misadds the hundredths; 1.60 + 0.85 = 2.45 cm."),
    ("9.6 cm","9.6 wrongly lines up the digits; with decimal points aligned the total is 2.45 cm."),
    ("0.75 cm","0.75 is the DIFFERENCE (1.6 - 0.85); the question asks the TOTAL, which is 2.45 cm.")]),

 ("FD","What is 0.6 × 0.3?",
   "0.18",
   C("Multiply as 6 × 3 = 18, then place the decimal: the two factors have 1 + 1 = 2 decimal places, so the answer is 0.18.")+
   steps("6 x 3 = 18","total decimal places = 1 + 1 = 2","so 0.6 x 0.3 = 0.18.")+
   U("A 0.6 m by 0.3 m tile covers 0.18 square metres of floor."),
   [("1.8","1.8 has only one decimal place; multiplying two one-place decimals needs two places, giving 0.18."),
    ("0.9","0.9 comes from ADDING 0.6 + 0.3; the question asks the PRODUCT, 0.18."),
    ("0.018","0.018 has three decimal places; 0.6 x 0.3 needs exactly two, so it is 0.18.")]),

 ("FD","What is 4.5 ÷ 0.5?",
   "9",
   C("Dividing by 0.5 is the same as asking how many halves fit in 4.5; double both: 4.5 ÷ 0.5 = 45 ÷ 5 = 9.")+
   steps("Multiply both by 10: 45 / 5","= 9","so 4.5 / 0.5 = 9.")+
   U("How many half-litre bottles fill 4.5 litres? Exactly 9 bottles."),
   [("0.9","0.9 misplaces the decimal; dividing by 0.5 makes the answer BIGGER, giving 9."),
    ("2.25","2.25 is 4.5 ÷ 2; dividing by 0.5 (a half) DOUBLES, giving 9."),
    ("90","90 over-shifts the decimal; 45 / 5 = 9, not 90.")]),

 ("FD","The mixed number 2¾ written as an improper fraction is:",
   "11/4",
   C("Multiply the whole number by the denominator and add the numerator: 2 × 4 + 3 = 11, over 4 — so 11/4.")+
   steps("2 x 4 = 8, plus 3 = 11","keep the denominator 4","so 2 3/4 = 11/4.")+
   U("Recipes often need improper fractions when you scale 2¾ cups up or down."),
   [("5/4","5/4 forgets the whole 2 properly; 2 x 4 + 3 = 11, so it is 11/4."),
    ("23/4","23/4 mistakenly writes 2 and 3 side by side; the correct conversion gives 11/4."),
    ("6/4","6/4 = 1 1/2, far too small; 2 3/4 = 11/4.")]),

 ("FD","Which decimal is the smallest: 0.5, 0.45, 0.405, 0.54?",
   "0.405",
   C("Compare place by place: tenths first — 0.405 and 0.45 have 4 tenths, the others 5. Among the two, 0.405 has 0 hundredths versus 5, so 0.405 is smallest.")+
   steps("0.5 and 0.54 have 5 tenths -> larger","0.45 and 0.405 have 4 tenths","0.405 < 0.45, so 0.405 is smallest.")+
   U("Comparing decimals carefully matters when reading fine measurements like 0.405 g on a balance."),
   [("0.45","0.45 has 4 tenths but 5 hundredths; 0.405 has 0 hundredths, so 0.405 is smaller."),
    ("0.5","0.5 has 5 tenths, more than the 4 tenths of 0.405; 0.405 is the smallest."),
    ("0.54","0.54 is the LARGEST here; the smallest is 0.405.")]),

 ("FD","A 3/4-litre bottle of juice is shared equally among 3 friends. Each friend gets:",
   "1/4 litre",
   C("Sharing 3/4 among 3 means 3/4 ÷ 3 = 3/4 × 1/3 = 3/12 = 1/4 litre each.")+
   steps("3/4 / 3 = 3/4 x 1/3","= 3/12","= 1/4 litre each.")+
   U("Splitting a part-full bottle evenly is everyday fraction division."),
   [("3/4 litre","3/4 litre is the WHOLE amount; shared among 3 each gets a third of it, 1/4 litre."),
    ("1/3 litre","1/3 litre would be sharing a full litre; here only 3/4 litre is shared, giving 1/4 each."),
    ("3/12 left over","3/12 is the share itself (= 1/4), not a leftover; each friend gets 1/4 litre.")]),

 ("FD","What is 5 − 2.75?",
   "2.25",
   C("Write 5 as 5.00 and subtract: 5.00 − 2.75 = 2.25.")+
   steps("5 = 5.00","5.00 - 2.75","= 2.25.")+
   U("Pay 2.75 rupees from a 5-rupee coin and you get 2.25 back."),
   [("3.25","3.25 subtracts 1.75 by mistake; 5.00 - 2.75 = 2.25."),
    ("2.75","2.75 is the amount taken away, not what remains; 5 - 2.75 = 2.25."),
    ("2.35","2.35 misadds the hundredths; the correct difference is 2.25.")]),

 ("FD","The fraction 18/24 in its simplest (lowest) form is:",
   "3/4",
   C("Divide top and bottom by their highest common factor, 6: 18 ÷ 6 = 3 and 24 ÷ 6 = 4, giving 3/4.")+
   steps("HCF of 18 and 24 is 6","18 / 6 = 3, 24 / 6 = 4","so 18/24 = 3/4.")+
   U("Simplifying fractions makes a recipe's '18/24 cup' easy to read as 3/4 cup."),
   [("6/8","6/8 divides only by 3; it still simplifies further to 3/4."),
    ("9/12","9/12 divides only by 2; the fully simplified form is 3/4."),
    ("2/3","2/3 = 16/24, not 18/24; the correct simplest form is 3/4.")]),

 ("FD","A plant grows 0.8 cm each day. In 5 days, ignoring nothing, it grows:",
   "4.0 cm",
   C("Repeated addition is multiplication: 0.8 × 5 = 4.0 cm. (8 × 5 = 40, one decimal place gives 4.0.)")+
   steps("0.8 x 5: do 8 x 5 = 40","one decimal place -> 4.0","so it grows 4.0 cm in 5 days.")+
   U("Measuring a seedling's daily growth and multiplying gives its total growth — a real science-and-maths blend."),
   [("0.4 cm","0.4 cm misplaces the decimal; 0.8 x 5 = 4.0 cm."),
    ("4.5 cm","4.5 adds an extra half day; 0.8 x 5 is exactly 4.0 cm."),
    ("40 cm","40 cm forgets the decimal point entirely; 0.8 x 5 = 4.0 cm.")]),

 ("FD","Half of one-third of a chocolate bar is what fraction of the whole bar?",
   "1/6",
   C("'Half of one-third' means 1/2 × 1/3 = 1/6 of the whole bar.")+
   steps("1/2 x 1/3","multiply across: 1/6","so it is 1/6 of the bar.")+
   U("Splitting a third of a snack between two people gives each one-sixth."),
   [("1/5","1/5 comes from adding denominators; multiplying 1/2 x 1/3 gives 1/6."),
    ("2/3","2/3 is far too big; half of a third is much smaller, namely 1/6."),
    ("1/3","1/3 is the WHOLE third; HALF of it is 1/6.")]),

 ("FD","What is 0.125 written as a fraction in lowest terms?",
   "1/8",
   C("0.125 is 125/1000; dividing top and bottom by 125 gives 1/8.")+
   steps("0.125 = 125/1000","divide both by 125","= 1/8.")+
   U("A measuring cup marked 0.125 litre holds one-eighth of a litre."),
   [("1/4","1/4 = 0.25, twice as big; 0.125 equals 1/8."),
    ("1/5","1/5 = 0.2, not 0.125; the correct fraction is 1/8."),
    ("125/100","125/100 misplaces the decimal (that's 1.25); 0.125 = 125/1000 = 1/8.")]),

 ("FD","Comparing 5/8 and 3/5, which is larger?",
   "5/8",
   C("Cross-multiply: 5×5 = 25 against 3×8 = 24. Since 25 > 24, 5/8 > 3/5.")+
   steps("Cross-multiply: 5 x 5 = 25 and 3 x 8 = 24","25 > 24","so 5/8 is larger.")+
   U("Cross-multiplying quickly tells which of two part-shares is the bigger."),
   [("3/5","3/5 gives the smaller cross-product (24 < 25), so 3/5 is the SMALLER, not larger."),
    ("they are equal","Their cross-products differ (25 vs 24), so they are not equal; 5/8 is larger."),
    ("cannot be compared","Any two fractions can be compared by cross-multiplying; here 5/8 > 3/5.")]),

 ("FD","What is 1 − (2/5 + 1/10)?",
   "1/2",
   C("First add inside: 2/5 = 4/10, so 4/10 + 1/10 = 5/10 = 1/2. Then 1 − 1/2 = 1/2.")+
   steps("2/5 = 4/10, plus 1/10 = 5/10 = 1/2","1 - 1/2","= 1/2.")+
   U("If 2/5 of a tank drains then 1/10 more, half the tank is still left."),
   [("3/10","3/10 forgets to subtract from the whole; 1 - 1/2 = 1/2."),
    ("2/5","2/5 is only part of what was removed; the leftover is 1 - 1/2 = 1/2."),
    ("7/10","7/10 adds instead of subtracting from 1; the answer is 1/2.")]),

 ("FD","A recipe needs 2½ cups of flour, but you make half the recipe. How much flour do you need?",
   "1¼ cups",
   C("Half of 2½ is 1/2 × 5/2 = 5/4 = 1¼ cups.")+
   steps("2 1/2 = 5/2","half of it: 1/2 x 5/2 = 5/4","= 1 1/4 cups.")+
   U("Halving a recipe is everyday fraction work in the kitchen."),
   [("1½ cups","1 1/2 is more than half of 2 1/2; half of 2 1/2 is 1 1/4 cups."),
    ("5 cups","5 cups DOUBLES the recipe; HALF needs 1 1/4 cups."),
    ("2 cups","2 cups is just under the full amount; half the recipe needs only 1 1/4 cups.")]),

 ("FD","The decimal 3.07 means:",
   "3 ones, 0 tenths and 7 hundredths",
   C("Reading place values: the 3 is in the ones place, the 0 in the tenths place, and the 7 in the hundredths place.")+
   steps("First digit after the point is tenths -> 0","second is hundredths -> 7","and 3 is the whole-number ones place.")+
   U("Money like ₹3.07 is 3 rupees and 7 paise — 7 hundredths of a rupee."),
   [("3 ones and 7 tenths","7 is in the HUNDREDTHS place, not tenths; the tenths digit is 0, so it is 7 hundredths."),
    ("30 ones and 7 tenths","The 3 is just 3 ones, not 30; and the 7 is 7 hundredths."),
    ("3 ones and 7 ones","The 7 sits after the decimal point, so it is 7 hundredths, not 7 ones.")]),

 ("FD","What is 7/8 − 1/2?",
   "3/8",
   C("Make a common denominator 8: 1/2 = 4/8, so 7/8 − 4/8 = 3/8.")+
   steps("1/2 = 4/8","7/8 - 4/8","= 3/8.")+
   U("If 7/8 of a cake remains and half a whole cake is taken, 3/8 is left."),
   [("6/6","Subtracting tops and bottoms (7-1 over 8-2) is wrong; with denominator 8 the answer is 3/8."),
    ("1/2","1/2 is what was taken away; 7/8 - 1/2 leaves 3/8."),
    ("4/8","4/8 is the 1/2 rewritten, not the difference; 7/8 - 4/8 = 3/8.")]),

 ("FD","Multiplying a number by 0.1 has the same effect as:",
   "dividing it by 10",
   C("0.1 is one-tenth, so multiplying by 0.1 is the same as dividing by 10 — the digits shift one place toward smaller values.")+
   steps("0.1 = 1/10","multiplying by 1/10 = dividing by 10","so x 0.1 means / 10.")+
   U("To turn 45 millimetres into 4.5 centimetres you multiply by 0.1, i.e. divide by 10."),
   [("multiplying it by 10","Multiplying by 10 makes a number BIGGER; multiplying by 0.1 makes it smaller — like dividing by 10."),
    ("adding 0.1 to it","Multiplying scales the number, it does not add a fixed 0.1; x 0.1 means dividing by 10."),
    ("dividing it by 100","Dividing by 100 is multiplying by 0.01; multiplying by 0.1 is dividing by 10.")]),

 ("FD","A glass is 3/5 full of water. To fill it completely, the fraction of the glass still to be added is:",
   "2/5",
   C("A full glass is 5/5. If 3/5 is filled, the part still needed is 5/5 − 3/5 = 2/5.")+
   steps("Full = 5/5","still needed = 5/5 - 3/5","= 2/5.")+
   U("Topping up a part-full container is a simple subtraction of fractions."),
   [("3/5","3/5 is what is ALREADY in the glass; the part still needed is 2/5."),
    ("1/5","1/5 is too little; the gap from 3/5 to a full 5/5 is 2/5."),
    ("8/5","A fraction of one glass cannot exceed 1; the part still needed is 2/5.")]),
]

# ---------- DATA HANDLING (25) — several fused with Science contexts ----------
DH = [
 ("DH","The arithmetic mean (average) of a set of values is found by:",
   "adding all the values and dividing by how many there are",
   C("The mean is the total of the observations divided by the number of observations — it shares the total out equally.")+
   steps("Add up every value to get the total","divide the total by the number of values","the result is the mean.")+
   U("Your average marks for a term are the total of all tests divided by the number of tests."),
   [("picking the value in the middle","That is the MEDIAN; the mean ADDS all values and divides by their count."),
    ("choosing the most common value","That is the MODE; the mean is the total divided by the number of values."),
    ("subtracting the smallest from the largest","That is the RANGE; the mean is the sum divided by the count.")]),

 ("DH","The mean of 4, 8, 6, 10 and 7 is:",
   "7",
   C("Sum = 4 + 8 + 6 + 10 + 7 = 35; divide by 5 values: 35 ÷ 5 = 7.")+
   steps("Sum = 35","divide by 5 values","mean = 7.")+
   U("Five daily readings averaged like this give the week's typical value."),
   [("6","6 is one of the values, not the mean; 35 / 5 = 7."),
    ("35","35 is the TOTAL of the five values; the mean still needs dividing by 5, giving 7."),
    ("8","8 is the largest value, not the average; the mean is 7.")]),

 ("DH","In the data 5, 3, 8, 3, 9, 3, 6, the value that occurs most often (the mode) is:",
   "3",
   C("The mode is the most frequent value. Here 3 appears three times, more than any other number, so the mode is 3.")+
   steps("Count each value's appearances","3 appears 3 times, the most","so the mode is 3.")+
   U("A shoe shop tracks the mode — the most-sold size — to stock the most pairs of it."),
   [("9","9 is the largest value, not the most frequent; 3 occurs most, so the mode is 3."),
    ("6","6 appears only once; the mode is the most frequent value, 3."),
    ("5","5 appears just once; the value occurring most often is 3.")]),

 ("DH","To find the median of a data set, you first:",
   "arrange the values in order, then take the middle one",
   C("The median is the middle value once the data is arranged in ascending (or descending) order; for an even count it is the mean of the two middle values.")+
   steps("Put all the values in order","find the value in the very middle","that middle value is the median.")+
   U("To find the median height of a class, you line everyone up by height and look at the middle person."),
   [("add them all and divide","That gives the MEAN; the median needs ORDERING and taking the middle value."),
    ("pick the most frequent value","That is the MODE; the median is the middle value of the ordered data."),
    ("take the largest value","The largest value relates to range, not the median; the median is the middle of the ordered list.")]),

 ("DH","The median of the ordered data 2, 5, 7, 9, 11 is:",
   "7",
   C("With five values already in order, the middle (third) value is the median: 7.")+
   steps("Five values in order","the middle is the 3rd value","which is 7.")+
   U("The median splits a sorted list in half — as many values above it as below."),
   [("9","9 is the fourth value, not the centre; the middle of five ordered values is the third, 7."),
    ("6.8","6.8 is roughly the MEAN, not the median; the middle ordered value is 7."),
    ("5","5 is the second value; the middle of five is the third, 7.")]),

 ("DH","The range of the data 12, 7, 20, 5, 16 is:",
   "15",
   C("Range = largest − smallest = 20 − 5 = 15, the spread of the data.")+
   steps("Largest = 20, smallest = 5","range = 20 - 5","= 15.")+
   U("A weather range of 15 °C tells you how much the temperature swung that day."),
   [("20","20 is just the largest value; the range is largest minus smallest, 20 - 5 = 15."),
    ("5","5 is the smallest value; the range is the SPREAD, 20 - 5 = 15."),
    ("25","25 ADDS the extremes; the range SUBTRACTS them, giving 15.")]),

 ("DH","A bar graph is most useful for:",
   "comparing the sizes of different categories at a glance",
   C("Bars of different heights let you compare quantities across categories quickly — taller bar means larger value.")+
   steps("Each bar's height shows a category's value","taller bars stand out at once","so a bar graph compares categories at a glance.")+
   U("A bar graph of rainfall by month shows the wettest month as the tallest bar."),
   [("showing how a whole is divided into parts","Showing parts of a whole is a PIE chart's job; bar graphs compare separate categories."),
    ("plotting the exact path of a moving car","A distance-time LINE graph tracks motion; a bar graph compares category sizes."),
    ("listing values with no comparison","A bar graph's whole point is easy COMPARISON, shown by differing bar heights.")]),

 ("DH","In a pictograph, one symbol of a tree stands for 10 saplings planted. A row showing 4½ tree symbols means:",
   "45 saplings",
   C("Each full symbol = 10, and the half symbol = 5. So 4 × 10 + 5 = 45 saplings.")+
   steps("4 full symbols = 4 x 10 = 40","half symbol = 5","total = 40 + 5 = 45 saplings.")+
   U("Tree-planting drives often show progress with such pictographs in the newspaper."),
   [("4 saplings","4 is the number of symbols, not the count; each symbol stands for 10, giving 45."),
    ("40 saplings","40 ignores the HALF symbol worth 5; the total is 40 + 5 = 45."),
    ("450 saplings","450 multiplies wrongly; 4 1/2 symbols at 10 each is 45, not 450.")]),

 ("DH","A coin is tossed once. The probability of getting heads is:",
   "1/2",
   C("There are 2 equally likely outcomes — heads or tails — and heads is 1 of them, so the probability is 1/2.")+
   steps("Possible outcomes: heads, tails -> 2","favourable (heads) = 1","probability = 1/2.")+
   U("A fair coin toss is the classic 50-50 chance used to make a fair choice."),
   [("1","A probability of 1 means CERTAIN; heads is not certain, it is 1 of 2 outcomes, so 1/2."),
    ("0","A probability of 0 means impossible; heads can happen, with probability 1/2."),
    ("2","Probability is never above 1; for heads it is 1/2.")]),

 ("DH","Rolling an ordinary die once, the probability of getting a number greater than 4 is:",
   "2/6 (= 1/3)",
   C("Numbers greater than 4 are 5 and 6 — that's 2 favourable outcomes out of 6, so 2/6 = 1/3.")+
   steps("Favourable: 5 and 6 -> 2 outcomes","total faces = 6","probability = 2/6 = 1/3.")+
   U("Board games rely on such die probabilities to decide your chances of a big move."),
   [("4/6","Numbers GREATER than 4 are only 5 and 6 (two), not four; the probability is 2/6 = 1/3."),
    ("1/6","1/6 is the chance of one particular number; 'greater than 4' covers 5 and 6, giving 2/6."),
    ("3/6","3 is wrong — only 5 and 6 exceed 4; the probability is 2/6 = 1/3.")]),

 ("DH","Forty children chose a favourite fruit; the table shows mango 18, apple 12, banana 10. The most popular fruit (the mode) is:",
   "mango",
   C("The mode of a survey is the category chosen most often. Mango has the highest count, 18, so it is the most popular fruit.")+
   steps("Compare the counts: 18, 12, 10","mango has the most at 18","so mango is the mode.")+
   U("Canteens stock more of the 'mode' choice — the dish students pick most."),
   [("apple","Apple has 12, fewer than mango's 18; the mode is the MOST chosen, mango."),
    ("banana","Banana's 10 is the FEWEST; the most popular (mode) is mango."),
    ("all are equal","The counts 18, 12, 10 differ, so they are not equal; mango is the clear mode.")]),

 ("DH","Over a week a plant's daily growth (mm) was 3, 5, 4, 6, 2, 4, 4. Its mean daily growth was:",
   "4 mm",
   C("Sum = 3 + 5 + 4 + 6 + 2 + 4 + 4 = 28; divide by 7 days: 28 ÷ 7 = 4 mm.")+
   steps("Sum = 28","divide by 7 days","mean = 4 mm.")+
   U("Scientists average daily measurements like this to report a plant's typical growth rate."),
   [("28 mm","28 mm is the WEEK'S TOTAL; the mean per day is 28 / 7 = 4 mm."),
    ("6 mm","6 mm is the best single day, not the average; the mean is 4 mm."),
    ("3.5 mm","3.5 mm would divide 28 by 8; there are 7 days, so the mean is 28 / 7 = 4 mm.")]),

 ("DH","For which purpose is a double bar graph the most suitable kind of graph to draw?",
   "compare two sets of data side by side for each category",
   C("A double bar graph places two bars per category, so you can compare two data sets — like two years, or boys and girls — at once.")+
   steps("Each category gets two bars","one bar for each data set","so two sets are compared side by side.")+
   U("A double bar graph of this year's and last year's rainfall per month shows the change at a glance."),
   [("show the parts of a single whole","Parts of one whole suit a pie chart; a double bar graph compares TWO data sets."),
    ("plot one quantity changing over time","One changing quantity suits a line graph; a double bar graph compares two sets per category."),
    ("display data that has no categories","A double bar graph needs categories — two bars per category — to compare two sets.")]),

 ("DH","Picking a card at random from cards numbered 1 to 10, the probability of getting an even number is:",
   "1/2",
   C("The even numbers 2, 4, 6, 8, 10 are 5 of the 10 cards, so the probability is 5/10 = 1/2.")+
   steps("Even numbers 1-10: 2,4,6,8,10 -> 5 of them","total cards = 10","probability = 5/10 = 1/2.")+
   U("Games of chance often hinge on such even/odd probabilities."),
   [("1/10","1/10 is the chance of one specific card; the FIVE even numbers give 5/10 = 1/2."),
    ("5","Probability cannot exceed 1; the chance of an even card is 5/10 = 1/2."),
    ("2/10","Only counting two evens is wrong — there are five (2,4,6,8,10); the probability is 5/10 = 1/2.")]),

 ("DH","If an outcome is absolutely sure to occur, what value is assigned to its probability?",
   "1",
   C("Probability runs from 0 (impossible) to 1 (certain). A sure event has probability 1.")+
   steps("Impossible event -> 0","certain event -> 1","so a certain event has probability 1.")+
   U("The Sun rising tomorrow is treated as a near-certain event, probability close to 1."),
   [("0","0 means the event is IMPOSSIBLE; a CERTAIN event has probability 1."),
    ("1/2","1/2 is an even chance, like a coin toss; a certain event has probability 1."),
    ("100","Probability is at most 1, not 100; a certain event is 1.")]),

 ("DH","Eight students scored 6, 7, 5, 8, 6, 9, 7, 8 on a quiz. The mean score is:",
   "7",
   C("Sum = 6+7+5+8+6+9+7+8 = 56; divide by 8 students: 56 ÷ 8 = 7.")+
   steps("Sum = 56","divide by 8 students","mean = 7.")+
   U("A teacher reports the class average score by exactly this calculation."),
   [("8","8 is a top score, not the mean; 56 / 8 = 7."),
    ("56","56 is the TOTAL of all scores; the mean still divides by 8, giving 7."),
    ("6.5","6.5 would divide by the wrong count; 56 / 8 is exactly 7.")]),

 ("DH","The double bar graph shows boys (14) and girls (16) who like science. Together, the number who like science is:",
   "30",
   C("Read both bars and add: 14 boys + 16 girls = 30 students like science.")+
   steps("Boys = 14, girls = 16","add the two bars: 14 + 16","= 30 students.")+
   U("Reading and combining values off a double bar graph is a common exam skill."),
   [("2","2 is the DIFFERENCE between the bars (16 - 14); the question asks the TOTAL, 30."),
    ("16","16 is only the girls' bar; together with 14 boys the total is 30."),
    ("14","14 is only the boys' bar; the combined total is 14 + 16 = 30.")]),

 ("DH","In which situation is the MEDIAN a better 'typical' value than the mean?",
   "when one or two values are extremely high or low compared with the rest",
   C("A very extreme value (an outlier) drags the mean toward it, but the median, being the middle value, is barely affected — so it better represents 'typical'.")+
   steps("An outlier pulls the mean far from the bulk of the data","the median stays at the middle, ignoring the extreme","so the median is the better typical value then.")+
   U("Average house prices are often given as a median, so a few mansions don't distort the 'typical' price."),
   [("when all the values are exactly equal","If all values are equal, mean and median are the same; the median's advantage is with EXTREME values."),
    ("when there are only two values","With two values the median is just their average — no advantage; it helps when there are OUTLIERS."),
    ("when the data has no numbers at all","With no numbers neither mean nor median exists; the median helps numeric data with outliers.")]),

 ("DH","Raw data simply collected, before it is arranged or organised, is called:",
   "raw data",
   C("Information collected in its original, unorganised form is called raw data; once arranged it becomes easier to read and interpret.")+
   steps("Numbers are first gathered just as they come","still unsorted and unorganised","this is called raw data.")+
   U("A list of every student's height, jotted as called out, is raw data until you sort it."),
   [("a frequency table","A frequency table is ORGANISED data; before organising, it is raw data."),
    ("the mean","The mean is a value CALCULATED from data; the unorganised collected figures are raw data."),
    ("a bar graph","A bar graph is a PICTURE of organised data; the unsorted figures themselves are raw data.")]),

 ("DH","A frequency table is used to show:",
   "how many times each value or category occurs",
   C("A frequency table lists each value or category alongside its frequency — the count of how often it appears.")+
   steps("List each distinct value or category","write beside it how often it occurs","that count is its frequency.")+
   U("Tallying how many students got each grade builds a frequency table of the class results."),
   [("the average of all the values","The average is a single calculated number; a frequency table shows the COUNT of each value."),
    ("only the largest value","A frequency table shows ALL values with their counts, not just the largest."),
    ("the order in which data was collected","A frequency table groups by value with counts, not by collection order.")]),

 ("DH","Ten daily maximum temperatures (°C) had a total of 360. Their mean maximum temperature was:",
   "36 °C",
   C("Mean = total ÷ number of values = 360 ÷ 10 = 36 °C.")+
   steps("Total = 360 over 10 days","mean = 360 / 10","= 36 deg C.")+
   U("A weather summary's 'average high for the period' is computed exactly this way."),
   [("360 °C","360 is the TOTAL of ten days; the mean divides by 10, giving 36 °C."),
    ("3.6 °C","3.6 misplaces the decimal; 360 / 10 = 36, not 3.6."),
    ("10 °C","10 is the number of days, not the mean; the mean is 360 / 10 = 36 °C.")]),

 ("DH","Picking a day at random from a normal week, the probability that it is a weekend day (Saturday or Sunday) is:",
   "2/7",
   C("A week has 7 days; 2 of them (Saturday, Sunday) are weekend days, so the probability is 2/7.")+
   steps("Weekend days = 2 (Sat, Sun)","total days in a week = 7","probability = 2/7.")+
   U("Probabilities over a week help estimate, say, the chance a random delivery lands on a weekend."),
   [("1/7","1/7 is the chance of ONE specific day; the weekend has TWO days, giving 2/7."),
    ("5/7","5/7 is the chance of a WEEKDAY (Mon–Fri); the weekend chance is 2/7."),
    ("1/2","A week is not split evenly into weekend and not; the weekend is 2 of 7 days, so 2/7.")]),

 ("DH","The mean of four numbers is 15. Their total must be:",
   "60",
   C("If the mean is 15 for 4 numbers, the total is mean × count = 15 × 4 = 60.")+
   steps("Total = mean x count","= 15 x 4","= 60.")+
   U("Knowing the average and the count lets you recover the total — handy for checking bills or scores."),
   [("15","15 is the MEAN itself, not the total of four numbers, which is 15 x 4 = 60."),
    ("19","19 wrongly adds 15 + 4; the total is mean TIMES count, 15 x 4 = 60."),
    ("3.75","3.75 divides 15 by 4; to get the total you MULTIPLY, giving 60.")]),

 ("DH","Why must a bar graph's bars all have the same width and equal gaps between them?",
   "so that only the heights, which show the values, are compared fairly",
   C("Equal widths and gaps keep the bars visually fair, so the eye compares only their heights — and height is what represents the value.")+
   steps("If widths differed, a wide short bar could look 'bigger'","equal widths force the comparison onto height alone","and height is the value, so the comparison is fair.")+
   U("Newspapers sometimes mislead by drawing uneven bars; equal widths keep a graph honest."),
   [("to make the graph look colourful and neat","Neatness is a bonus, not the reason; equal widths ensure a FAIR comparison by height."),
    ("because the bars must touch each other","Bar-graph bars have GAPS between them; the rule is equal width so heights compare fairly."),
    ("so each bar can show a different unit","All bars share ONE unit on the axis; equal widths let their heights be compared fairly.")]),

 ("DH","The most common value, the middle value of ordered data, and the sum-divided-by-count of a data set are called, in that order, the:",
   "mode, median and mean",
   C("The mode is the most frequent value, the median is the middle of the ordered data, and the mean is the total divided by the number of values.")+
   steps("Most common value -> mode","middle of the ordered list -> median","sum / count -> mean.")+
   U("A sports report may quote the mode score, the median score and the mean score — three different 'typical' values."),
   [("mean, mode and median","The MOST COMMON value is the mode (not the mean), so the order given here is mixed up; it is mode, median, mean."),
    ("median, mean and mode","The first description (most common) is the MODE, not the median; the correct order is mode, median, mean."),
    ("range, mode and mean","The middle value is the MEDIAN, not the range; the order is mode, median, mean.")]),
]

# ---------- assemble: interleave so no two consecutive share a chapter ----------
assert all(len(b) == 25 for b in (HE, NP, FD, DH)), [len(HE), len(NP), len(FD), len(DH)]
items = []
for i in range(25):
    items += [HE[i], NP[i], FD[i], DH[i]]
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

    keydist = build_paper(PNUM, TITLE, SHORT, LABELS, items, seed=51097,
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
    split = "/".join(str(counts[c]) for c in ("HE", "NP", "FD", "DH"))
    with open("PAPERS_MANIFEST.md", "a", encoding="utf-8") as fh:
        fh.write(f"| {PNUM} | 2026-06-18 | {TITLE} | {split} | ✓ |\n")

    # ---- update QUESTION_INDEX.json ----
    idx["fingerprints"] = sorted(existing | set(new_fps))
    idx.setdefault("combos", []).append({
        "paper": PNUM,
        "chapters": ["Heat",
                     "Nutrition in Plants",
                     "Fractions & Decimals",
                     "Data Handling"],
    })
    idx["papers"] = idx.get("papers", 0) + 1
    with open(idx_path, "w", encoding="utf-8") as fh:
        json.dump(idx, fh, ensure_ascii=False, indent=2)
        fh.write("\n")

    print("Files:", sorted(v for v in moves.values()))
    print("Answer key spread A/B/C/D =", dict(keydist))
