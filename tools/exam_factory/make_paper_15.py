# -*- coding: utf-8 -*-
# Boss Challenge Paper 15 — Heat · Winds, Storms & Cyclones
#                          · Integers · Data Handling
# Content-only. Uses the dependency-free examfactory engine.
# Difficulty ramp: this paper leans into FUSION — a Science context (a
# temperature reading, a wind-speed log, a cyclone's pressure drop) wrapped
# around a Maths skill (integer arithmetic on a number line, finding a mean /
# range / probability from data). Class-7 scope, simple wording, hard thinking.
# Produces, under Resources/BossChallengePapers/:
#   Paper_15_<SHORT>_QuestionPaper.html  (pure HTML — questions + options, no answers)
#   Paper_15_<SHORT>_QuestionPaper.pdf
#   Paper_15_<SHORT>_Questions.md
#   Paper_15_<SHORT>_Solutions.html
import os, sys, shutil, json
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from examfactory import build_paper, C, steps, U

PNUM  = "15"
SHORT = "Heat_WindsStormsCyclones_Integers_DataHandling"
TITLE = "Heat · Winds, Storms & Cyclones · Integers · Data Handling"
LABELS = {
    "HT": "Heat",
    "WS": "Winds, Storms & Cyclones",
    "IN": "Integers",
    "DH": "Data Handling",
}

# ---------- HEAT (25) — Science ----------
HT = [
 ("HT","The degree of hotness or coldness of an object is what we call its:",
   "temperature",
   C("Temperature is the scientific measure of how hot or cold something is.")+
   steps("Touch tells you 'hot' or 'cold' only roughly","A number is needed to compare exactly","That number is the temperature.")+
   U("A doctor checks your temperature to know exactly how feverish you are."),
   [("heat","Heat is the energy that flows; temperature is the measure of hotness itself."),
    ("pressure","Pressure is force on an area, not a measure of hotness or coldness."),
    ("density","Density is mass packed in a space, unrelated to how hot a body is.")]),

 ("HT","The device specially designed to measure how hot or cold a body is:",
   "a thermometer",
   C("A thermometer is the instrument made to read temperature accurately.")+
   steps("We need an exact temperature value","A thermometer has a marked scale","The liquid rises to show the reading.")+
   U("A clinical thermometer at home tells a parent whether a child has fever."),
   [("a barometer","A barometer measures air pressure, not temperature."),
    ("an anemometer","An anemometer measures wind speed, not hotness."),
    ("a speedometer","A speedometer shows how fast a vehicle moves, not its temperature.")]),

 ("HT","The temperature of a healthy human body is normally about:",
   "37°C",
   C("The standard normal body temperature is 37 degrees Celsius (about 98.6°F).")+
   steps("Body keeps a steady inner warmth","That fixed value is around 37°C","A higher reading suggests fever.")+
   U("Knowing 37°C is normal lets you spot a fever the moment the reading climbs."),
   [("0°C","0°C is the freezing point of water, far below body warmth."),
    ("100°C","100°C is the boiling point of water; no living body is that hot."),
    ("50°C","50°C is dangerously high; normal body temperature is about 37°C.")]),

 ("HT","A clinical thermometer is built to read only the small range needed for:",
   "human body temperature (about 35°C to 42°C)",
   C("A clinical thermometer covers just the band a human body can reach, for precision.")+
   steps("Body temperature stays in a narrow band","The scale is limited to about 35°C–42°C","This makes each small change easy to read.")+
   U("Its short, fine scale is why a clinical thermometer spots even a slight fever."),
   [("water from ice to boiling (0°C to 100°C)","That wide range is a laboratory thermometer, not a clinical one."),
    ("furnace temperatures above 200°C","A clinical thermometer would break long before such heat."),
    ("freezer temperatures below 0°C","The body never goes below 0°C; the clinical scale starts near 35°C.")]),

 ("HT","Heat always flows on its own from a body at higher temperature to one at:",
   "lower temperature",
   C("Heat energy naturally moves from the hotter object toward the colder one until they match.")+
   steps("Two bodies touch at different temperatures","Energy leaves the hotter one","It flows until both are equally warm.")+
   U("A hot cup of milk cools down because heat flows out into the cooler room."),
   [("higher temperature","Heat does not flow into the hotter body; it leaves it for the colder one."),
    ("the same temperature","Once they are equal, net flow stops; flow happens toward the colder body."),
    ("a body of larger size","Size does not decide the direction; temperature difference does.")]),

 ("HT","The transfer of heat through a solid, from particle to particle without the solid moving, is:",
   "conduction",
   C("In conduction, heat passes along a solid as neighbouring particles pass on the energy.")+
   steps("One end of a metal rod is heated","Its particles vibrate faster","They jostle the next particles, passing heat along.")+
   U("A metal spoon left in hot tea soon feels warm at the far end — that is conduction."),
   [("convection","Convection moves heat by the actual flow of a liquid or gas, not through a fixed solid."),
    ("radiation","Radiation carries heat as rays needing no material; conduction needs touching particles."),
    ("evaporation","Evaporation is liquid turning to vapour, not heat travelling through a solid.")]),

 ("HT","Materials such as metals, which let heat pass through them easily, are called:",
   "conductors",
   C("Conductors allow heat to travel through them quickly; most metals are good conductors.")+
   steps("Heat enters one part of the material","If it spreads fast throughout","the material is a good conductor.")+
   U("Cooking pots are made of metal because metal conducts heat quickly to the food."),
   [("insulators","Insulators resist heat flow — the opposite of conductors."),
    ("radiators of light","Letting heat pass is conduction; this is not about giving off light."),
    ("non-metals","Most non-metals are poor conductors; metals are the good conductors.")]),

 ("HT","Materials like wood, plastic and wool, which do not let heat pass easily, are called:",
   "insulators",
   C("Insulators slow down heat flow, so they stay cool to touch even when one side is hot.")+
   steps("Heat tries to pass through the material","An insulator blocks most of it","so the far side stays cooler.")+
   U("A pan's plastic handle is an insulator, so your hand does not get burnt."),
   [("conductors","Conductors let heat pass easily — the opposite of insulators."),
    ("metals","Metals are good conductors; the poor conductors are insulators."),
    ("liquids","Whether a thing is liquid does not decide this; poor conductors are insulators.")]),

 ("HT","The transfer of heat in liquids and gases by the actual movement of the heated fluid is:",
   "convection",
   C("In convection, warm fluid rises and cooler fluid sinks, carrying heat as it circulates.")+
   steps("The bottom layer of water is heated","It becomes lighter and rises","Cooler water sinks to take its place, setting up a current.")+
   U("Boiling water churns because hot water rises and cool water falls — a convection current."),
   [("conduction","Conduction passes heat through a still solid, not by fluid moving."),
    ("radiation","Radiation needs no material at all; convection needs a flowing fluid."),
    ("freezing","Freezing is a liquid turning solid, not a way of transferring heat.")]),

 ("HT","Heat from the Sun reaches the Earth across empty space mainly by:",
   "radiation",
   C("Radiation carries heat as rays that travel through vacuum, needing no material in between.")+
   steps("Between Sun and Earth is empty space","Conduction and convection need matter","So heat must travel as radiation.")+
   U("You feel a fire's warmth on your face before touching it — that warmth arrives by radiation."),
   [("conduction","Conduction needs touching particles; space between Sun and Earth has none."),
    ("convection","Convection needs a fluid to flow; the vacuum of space has no such fluid."),
    ("evaporation","Evaporation is about liquids changing to vapour, not heat crossing space.")]),

 ("HT","The handle of a cooking pan is often made of plastic or wood because these are:",
   "poor conductors of heat",
   C("A handle should stay cool, so it is made of a material that does not pass heat easily.")+
   steps("The pan body must conduct heat to food","But the handle must stay cool to hold","So the handle uses a poor conductor.")+
   U("This simple choice of material is why you can lift a hot pan without gloves."),
   [("good conductors of heat","A good conductor would make the handle too hot to hold."),
    ("heavier than metal","Weight is not the reason; the handle is chosen to block heat."),
    ("better at reflecting light","Reflecting light is irrelevant; the handle must not conduct heat.")]),

 ("HT","Woollen clothes keep us warm in winter mainly because the wool fibres:",
   "trap air, which is a poor conductor of heat",
   C("Air trapped between wool fibres blocks body heat from escaping, keeping us warm.")+
   steps("Body gives off heat","Wool traps a layer of still air","Trapped air conducts heat poorly, so warmth stays in.")+
   U("Wearing two thin layers can be warmer than one thick one — more trapped air."),
   [("themselves produce heat","Wool makes no heat of its own; it only traps the body's heat."),
    ("are very good conductors","A good conductor would let body heat escape, making you cold."),
    ("reflect sunlight onto the body","Warmth in winter clothes comes from trapped air, not reflected sunlight.")]),

 ("HT","During the day, the breeze near a coast usually blows from the sea to the land. This is called a:",
   "sea breeze",
   C("By day the land heats faster than the sea, so cool air flows in from the sea — a sea breeze.")+
   steps("Land warms quickly, air over it rises","Cooler air over the sea moves in to replace it","This daytime flow is the sea breeze.")+
   U("A sea breeze is why a beach feels pleasantly cool on a hot afternoon."),
   [("land breeze","A land breeze blows from land to sea at night, the reverse of this."),
    ("monsoon wind","Monsoon winds are seasonal and large-scale, not a daily coastal breeze."),
    ("cyclone","A cyclone is a violent rotating storm, not a gentle daytime coastal breeze.")]),

 ("HT","Why does a steel spoon feel colder than a wooden spoon, even when both are at room temperature?",
   "steel conducts heat away from your hand faster",
   C("Both are equally warm, but steel pulls heat from your skin quickly, so it feels colder.")+
   steps("Both spoons are at room temperature","Steel is a good conductor, wood a poor one","Steel draws heat from your hand faster, feeling colder.")+
   U("This is why a tiled floor feels colder underfoot than a carpet at the same temperature."),
   [("steel is actually at a lower temperature","Both are at the same temperature; the difference is how fast steel conducts heat."),
    ("wood gives out heat to your hand","Wood does not heat your hand; steel simply draws heat away faster."),
    ("steel reflects more cold","'Cold' is not reflected; steel just conducts your hand's heat away quickly.")]),

 ("HT","The narrow bend (kink) in a clinical thermometer is there to:",
   "stop the mercury from falling back on its own so you can read it",
   C("The kink traps the mercury thread after measuring, holding the reading until you shake it down.")+
   steps("Mercury rises with body heat","The kink blocks it from slipping back","The reading stays steady while you read it.")+
   U("Thanks to the kink, you can take the thermometer out and read the fever calmly."),
   [("make the mercury rise faster","The kink does not speed the rise; it holds the reading in place."),
    ("measure two patients at once","One reading is held at a time; the kink simply keeps that reading visible."),
    ("show the room temperature too","A clinical thermometer reads body temperature; the kink only holds the value.")]),

 ("HT","In hot summer weather, light-coloured clothes are more comfortable because light colours:",
   "reflect more heat and absorb less",
   C("Light shades bounce away much of the Sun's heat, so they stay cooler than dark shades.")+
   steps("Sunlight carries heat to clothing","Light colours reflect most of it","Less heat is absorbed, so you feel cooler.")+
   U("This is why people in hot regions often prefer white or pale clothing in summer."),
   [("absorb more heat and stay hot","Light colours absorb less, not more; that is why they feel cooler."),
    ("produce a cooling breeze","Cloth does not create a breeze; light colours simply reflect heat away."),
    ("conduct heat to the skin faster","Comfort comes from reflecting heat, not from conducting it to the skin.")]),

 ("HT","A small gap is deliberately left between two lengths of railway track because metal:",
   "expands when it gets hot and needs room to grow",
   C("Metal rails lengthen in the heat, so gaps are left to prevent them buckling.")+
   steps("Rails warm up in the sun","Heated metal expands and grows longer","Gaps give the extra length room, avoiding bends.")+
   U("These expansion gaps are why train tracks make a rhythmic 'clack' as you ride over them."),
   [("shrinks when heated and pulls apart","Metal expands, not shrinks, when heated; the gap allows for growth."),
    ("must be cleaned of dust regularly","The gap is for thermal expansion, not for cleaning."),
    ("carries electricity better with a gap","The gap is left for expansion, not to improve any current.")]),

 ("HT","When the bottom of a beaker of water is heated, the warm water rises because on heating it becomes:",
   "lighter (less dense)",
   C("Heated water expands and becomes less dense, so it floats up while cooler water sinks.")+
   steps("Water at the bottom is heated","It expands and grows less dense","Being lighter, it rises, starting a convection current.")+
   U("This rising of warm water is exactly how a pan of water heats evenly while boiling."),
   [("heavier (more dense)","Heated water becomes less dense, not more; that is why it rises."),
    ("solid like ice","Heating does not freeze water; it warms and expands, becoming lighter."),
    ("colder than before","Heating makes it warmer, not colder; the warm, lighter water rises.")]),

 ("HT","A laboratory thermometer differs from a clinical one mainly because it can measure:",
   "a much wider range of temperatures",
   C("A lab thermometer reads a broad span (often −10°C to 110°C), far beyond body temperature.")+
   steps("Experiments may be very hot or very cold","A clinical scale is too narrow for that","So a lab thermometer uses a wide range.")+
   U("Measuring the temperature of melting ice or boiling water needs the wider lab scale."),
   [("only the human body's temperature","That narrow job belongs to the clinical thermometer, not the lab one."),
    ("wind speed in a storm","Wind speed is measured by an anemometer, not any thermometer."),
    ("the weight of a liquid","A thermometer measures temperature, never weight.")]),

 ("HT","The common everyday unit used to express temperature in India is the:",
   "degree Celsius (°C)",
   C("Temperature in daily life is usually given in degrees Celsius, written °C.")+
   steps("Water freezes at 0°C and boils at 100°C","Weather and fever are reported in °C","So °C is the everyday temperature unit.")+
   U("A weather forecast saying '40°C today' is using the degree Celsius scale."),
   [("kilogram","The kilogram measures mass, not temperature."),
    ("metre","The metre measures length, not how hot something is."),
    ("litre","The litre measures volume of a liquid, not temperature.")]),

 ("HT","A thermos flask keeps drinks hot or cold for long because its design mainly tries to:",
   "reduce heat transfer by conduction, convection and radiation",
   C("A thermos uses a vacuum gap and shiny walls to block all three ways heat moves.")+
   steps("A vacuum gap stops conduction and convection","Shiny silvered walls reflect radiation","With all paths blocked, the temperature changes very slowly.")+
   U("This is why a thermos can keep your morning milk warm until lunch."),
   [("speed up heat transfer to the air","A thermos slows heat transfer; speeding it up would not keep drinks hot."),
    ("turn the liquid into a gas","A thermos stores liquids; it does not boil them into gas."),
    ("conduct heat quickly through metal","Quick conduction would lose heat; the thermos blocks conduction instead.")]),

 ("HT","On a sunny day, a person feels warmth from sunlight even with cool air around, showing that radiation:",
   "can transfer heat without warming the air in between",
   C("Radiation passes through air largely unchanged and heats your skin directly.")+
   steps("Sun's rays cross the cool air","They do not need to warm the air to travel","They deliver heat straight to your skin.")+
   U("This is why a sunny but breezy winter day can still feel warm on your face."),
   [("must heat all the air first","Radiation can reach you directly without first warming the air."),
    ("only works by touching the Sun","You never touch the Sun; its heat reaches you across space by radiation."),
    ("needs a metal wire to travel","Radiation needs no wire or material; it travels as rays.")]),

 ("HT","Black or dark-coloured surfaces are better than light ones at:",
   "absorbing heat",
   C("Dark surfaces soak up more radiant heat, so they warm up faster in sunlight.")+
   steps("Sunlight falls on two surfaces","A dark surface absorbs most of the heat","A light surface reflects much of it away.")+
   U("Solar water heaters paint their pipes black to absorb the most heat from the Sun."),
   [("reflecting heat","Light, shiny surfaces reflect heat; dark ones absorb it."),
    ("staying coolest in the Sun","Dark surfaces get hottest, not coolest, because they absorb heat."),
    ("blocking all sunlight","Dark surfaces absorb the heat rather than blocking light from arriving.")]),

 ("HT","If a thermometer reading rises from 28°C in the morning to 36°C by noon, the rise in temperature is:",
   "8°C",
   C("The rise is the difference between the later and earlier readings.")+
   steps("Noon reading = 36°C","Morning reading = 28°C","Rise = 36 − 28 = 8°C.")+
   U("Tracking how many degrees the day heats up is exactly this kind of subtraction."),
   [("64°C","64 adds the two readings; a rise is the difference, 8°C."),
    ("28°C","28 is the morning reading, not the change, which is 8°C."),
    ("4°C","4 mis-subtracts; 36 − 28 is 8°C.")]),

 ("HT","A clinical thermometer should never be washed in very hot water because:",
   "the mercury may expand too much and break the thermometer",
   C("Very hot water can push the mercury beyond the scale, cracking the glass.")+
   steps("Hot water heats the mercury strongly","Mercury expands and rises fast","Past the top, it can burst the bulb or tube.")+
   U("This is why you clean a clinical thermometer with cool or lukewarm antiseptic, not boiling water."),
   [("the numbers will wash off","The scale is etched on; the real danger is the mercury expanding and breaking it."),
    ("hot water makes it read too low","Hot water would raise, not lower, the reading; the risk is breakage."),
    ("it will then only read room temperature","The thermometer still reads body heat; hot water risks cracking it.")]),
]

# ---------- WINDS, STORMS & CYCLONES (25) — Science ----------
WS = [
 ("WS","Air that is moving from one place to another is what we simply call:",
   "wind",
   C("Wind is just air in motion, set going by differences in air pressure.")+
   steps("Air is normally all around us","When it moves from place to place","that moving air is called wind.")+
   U("A flag flapping shows you the wind — air moving past it."),
   [("rain","Rain is falling water drops, not moving air."),
    ("pressure","Pressure is a force air exerts; the moving air itself is wind."),
    ("humidity","Humidity is water vapour in the air, not the air's movement.")]),

 ("WS","A key idea behind winds and storms is that air around us:",
   "exerts pressure",
   C("Air has weight and pushes in all directions, so it exerts pressure.")+
   steps("Air is made of countless particles","They press on everything they touch","This push is called air pressure.")+
   U("An inflated balloon stays firm because the air inside pushes out — air pressure."),
   [("has no weight at all","Air does have weight, which is why it exerts pressure."),
    ("cannot be felt ever","You feel air pressure as wind on your face; it is very real."),
    ("only pushes downward","Air pressure acts in all directions, not only downward.")]),

 ("WS","Wind blows because air always moves from a region of high pressure toward a region of:",
   "low pressure",
   C("Differences in air pressure drive wind from where pressure is high to where it is low.")+
   steps("One area has higher air pressure","A nearby area has lower pressure","Air rushes from high to low — that is wind.")+
   U("A cyclone's fierce winds rush inward toward its very low-pressure centre."),
   [("higher pressure","Air moves away from high pressure, not toward more of it."),
    ("equal pressure everywhere","If pressure were equal, there would be no wind at all."),
    ("the nearest ocean","Direction is set by pressure difference, not by where an ocean lies.")]),

 ("WS","When air is warmed, it expands, becomes lighter and:",
   "rises up",
   C("Warm air is less dense than cool air, so it floats upward while cooler air sinks.")+
   steps("Air is heated near the ground","It expands and becomes lighter","Being less dense, it rises.")+
   U("Hot-air balloons fly because the heated air inside them rises."),
   [("sinks down","Warm air rises; it is the cooler, denser air that sinks."),
    ("turns into water","Warming air does not become water; it rises as a lighter gas."),
    ("stops moving","Warm air keeps moving upward, setting cooler air flowing in below.")]),

 ("WS","The faster air moves over a place, the air pressure there becomes:",
   "lower",
   C("Fast-moving air exerts less pressure, a fact behind many wind effects.")+
   steps("Still air presses normally","When that air speeds up","the pressure it exerts drops.")+
   U("A roof can be lifted off in a storm because fast wind above lowers the pressure there."),
   [("higher","Fast-moving air lowers pressure; it does not raise it."),
    ("unchanged","Air speed clearly changes pressure; faster air means lower pressure."),
    ("zero everywhere","Pressure drops but does not vanish; it simply becomes lower.")]),

 ("WS","Winds are caused on a large scale mainly by the:",
   "uneven heating of the Earth by the Sun",
   C("The Sun heats different parts of the Earth unequally, creating pressure differences that drive winds.")+
   steps("The Sun heats land, sea and poles differently","This makes high- and low-pressure regions","Air flows between them as wind.")+
   U("The unequal heating of equator and poles drives the planet's great wind belts."),
   [("the rotation of the Moon","The Moon mainly affects tides, not the heating that drives winds."),
    ("trees giving out air","Trees release some gases, but winds come from uneven heating by the Sun."),
    ("rivers flowing to the sea","Rivers move water, not the air; winds arise from uneven heating.")]),

 ("WS","The seasonal winds that bring heavy rains to India each year are the:",
   "monsoon winds",
   C("Monsoon winds blow in from the sea carrying moisture, bringing India's rainy season.")+
   steps("Land heats more than the sea in summer","Moist air is drawn in from the ocean","These monsoon winds bring the rains.")+
   U("Farmers across India plan their sowing around the arrival of the monsoon winds."),
   [("land breezes","A land breeze is a small night-time coastal flow, not the rain-bringing season."),
    ("cyclonic winds","Cyclones are violent storms; the regular rain-bringers are the monsoon winds."),
    ("trade-free winds","The rain-bringing seasonal winds of India are specifically the monsoon winds.")]),

 ("WS","The instrument used to measure the speed of the wind is the:",
   "anemometer",
   C("An anemometer, often with spinning cups, measures how fast the wind is blowing.")+
   steps("Wind pushes the cups of the device","The faster the wind, the faster they spin","The spin rate gives the wind speed.")+
   U("Weather stations use an anemometer to warn of dangerously high winds."),
   [("thermometer","A thermometer measures temperature, not wind speed."),
    ("barometer","A barometer measures air pressure, not how fast the wind blows."),
    ("rain gauge","A rain gauge measures rainfall, not wind speed.")]),

 ("WS","A violent storm with very high-speed winds whirling around a centre of very low pressure is a:",
   "cyclone",
   C("A cyclone is a large rotating storm spiralling around a low-pressure core.")+
   steps("Warm moist air rises over the sea","Air spirals in toward the low-pressure centre","Fast rotating winds and heavy rain form a cyclone.")+
   U("Coastal warnings of an approaching cyclone help people move to safety in time."),
   [("a gentle sea breeze","A sea breeze is a mild daytime coastal flow, not a violent storm."),
    ("a rainbow","A rainbow is a light effect in the sky, not a wind storm."),
    ("a monsoon shower","A monsoon shower is seasonal rain, not a whirling low-pressure storm.")]),

 ("WS","The calm, clear region at the very centre of a cyclone is known as the:",
   "eye of the cyclone",
   C("The eye is the still, low-pressure centre around which the cyclone's winds whirl.")+
   steps("Winds spiral around the storm's middle","The exact centre is oddly calm and clear","This calm centre is called the eye.")+
   U("People sometimes wrongly think a cyclone has passed during the calm eye — then the winds return."),
   [("tail of the cyclone","A cyclone has no 'tail'; its calm centre is the eye."),
    ("base of the cyclone","The calm low-pressure centre is the eye, not any 'base'."),
    ("shadow of the cyclone","There is no 'shadow'; the still central region is the eye.")]),

 ("WS","Lightning and thunder during a storm are caused by:",
   "a build-up of electric charges in the clouds",
   C("Charges gather in storm clouds and leap as lightning, with thunder as the sound that follows.")+
   steps("Clouds build up electric charge","The charge jumps as a bright spark — lightning","The rushing air makes the sound — thunder.")+
   U("Counting seconds between lightning and thunder roughly tells how far the storm is."),
   [("the Sun shining through rain","Sunlight through rain makes a rainbow, not lightning and thunder."),
    ("strong winds hitting trees","Wind on trees makes rustling, not the electric flash of lightning."),
    ("cold air freezing instantly","Freezing air does not spark; lightning is an electric discharge.")]),

 ("WS","During a thunderstorm, the safest thing to do is to:",
   "stay indoors, away from open fields and tall trees",
   C("Open ground and tall trees attract lightning; a building is far safer.")+
   steps("Lightning tends to strike the tallest object","A lone tree or open field is risky","Staying inside a building keeps you safe.")+
   U("Schools call children indoors during a thunderstorm for exactly this reason."),
   [("stand under the tallest tree","A tall tree is a prime lightning target — very dangerous, not safe."),
    ("fly a kite to watch the storm","A wet kite string can carry lightning; this is extremely dangerous."),
    ("swim in an open pool","Open water in a storm is dangerous; you should get indoors.")]),

 ("WS","In North America, the same kind of storm that India calls a cyclone is called a:",
   "hurricane",
   C("Cyclone, hurricane and typhoon are different regional names for the same kind of storm.")+
   steps("A rotating low-pressure sea storm forms","In the Indian Ocean it is a cyclone","In the Atlantic region it is called a hurricane.")+
   U("News from America may say 'hurricane' for the very storm Indians call a cyclone."),
   [("tornado","A tornado is a smaller, land-based twisting funnel, not the same as a cyclone."),
    ("monsoon","A monsoon is a rainy season's winds, not a single rotating storm."),
    ("blizzard","A blizzard is a snowstorm, not the warm-sea cyclone of the tropics.")]),

 ("WS","A cyclone usually forms over warm seas because warm ocean water:",
   "evaporates and the rising moist air feeds the storm",
   C("Warm seas send up plenty of moist air, whose rising and condensing powers the cyclone.")+
   steps("Warm sea water evaporates fast","Moist air rises and cools, releasing heat","That released heat drives the swirling storm.")+
   U("This is why cyclones lose strength once they move over cool land, away from warm water."),
   [("freezes into ice that spins","Cyclones form over warm, not freezing, water; ice is not involved."),
    ("turns into solid salt","Evaporation leaves salt behind but the storm is fed by rising moist air."),
    ("blocks all the wind","Warm seas feed the storm's winds; they do not block them.")]),

 ("WS","If you blow hard between two hanging paper strips, they move toward each other because:",
   "fast-moving air between them lowers the pressure there",
   C("The moving air drops the pressure between the strips, so the higher outside pressure pushes them together.")+
   steps("Air rushes fast between the strips","Fast air means lower pressure between them","Higher outside pressure pushes the strips inward.")+
   U("This same effect helps explain why a high wind can pull a roof upward off a house."),
   [("the air pushes them apart","Lower pressure between pulls them together, not apart."),
    ("your breath is warmer than the room","The effect is from air speed lowering pressure, not from warmth."),
    ("the paper attracts itself like a magnet","Paper is not magnetic; the strips move due to a pressure difference.")]),

 ("WS","Cyclone warnings to coastal communities are issued by the:",
   "meteorological (weather) department",
   C("The weather department tracks storms by satellite and warns people before a cyclone strikes.")+
   steps("Satellites and instruments track the storm","The weather department analyses the data","It issues warnings so people can prepare.")+
   U("An early cyclone warning gives fishermen time to return and families time to move inland."),
   [("the local post office","Post offices deliver mail; cyclone warnings come from the weather department."),
    ("the electricity board","The electricity board handles power, not storm forecasting."),
    ("the railway station","Railways run trains; cyclone alerts come from the meteorological department.")]),

 ("WS","Which action is a sensible part of preparing for an approaching cyclone?",
   "store drinking water, food and move valuables to a safe, high place",
   C("Cyclones can flood areas and cut supplies, so stocking essentials and protecting belongings is wise.")+
   steps("A cyclone may flood and cut off the area","Clean water and food may run short","Storing supplies and moving valuables high keeps a family safe.")+
   U("Coastal families keep an emergency kit ready every cyclone season."),
   [("go out to the beach to watch the waves","Going toward the coast in a cyclone is extremely dangerous."),
    ("open all windows to let the wind through","Open windows let in damaging wind and rain; they should be secured."),
    ("ignore the warning and carry on as usual","Ignoring a cyclone warning risks lives; preparation is essential.")]),

 ("WS","By day, the land near a coast heats up faster than the sea because land:",
   "warms up more quickly than water for the same sunshine",
   C("Land heats faster than water, so air above the land warms and rises, drawing in the sea breeze.")+
   steps("Sun shines equally on land and sea","Land's temperature climbs faster than water's","Warm air over land rises, pulling cool sea air inland.")+
   U("This faster heating of land is the engine behind the daytime sea breeze."),
   [("water warms up faster than land","Water actually warms more slowly than land, not faster."),
    ("land is closer to the Sun","Land and sea are the same distance from the Sun; land just heats faster."),
    ("the sea blocks all sunlight","The sea receives sunlight too; land simply warms more quickly.")]),

 ("WS","Strong cyclonic winds combined with heavy rain and high sea waves cause the most damage to:",
   "low-lying coastal areas",
   C("Coastal lowlands face the storm's full force — wind, rain and surging sea water together.")+
   steps("Cyclones strike from the sea","Coastal land is low and exposed","Wind, rain and storm surge flood and batter it.")+
   U("This is why coastal towns build cyclone shelters and embankments for protection."),
   [("high mountain peaks far inland","Cyclones weaken inland; the worst damage is along low coasts."),
    ("underground caves","Caves are sheltered; the damage falls on exposed coastal land."),
    ("the middle of a desert","Deserts are far from the sea; cyclones hit coastal areas hardest.")]),

 ("WS","Increasing the speed of wind over a region tends to make objects there experience:",
   "an upward or inward push as pressure drops",
   C("Faster wind lowers local pressure, so higher surrounding pressure can push or lift objects.")+
   steps("Wind speeds up over a surface","Pressure above that surface falls","Higher pressure below pushes the object up or in.")+
   U("This lifting effect is why tin sheets and roofs fly off in a severe storm."),
   [("a stronger downward pull from the wind","Fast wind lowers pressure and tends to lift, not press down harder."),
    ("no force at all","Fast wind clearly exerts force; that is how storms cause damage."),
    ("a rise in their temperature","Wind speed changes pressure, not the object's temperature.")]),

 ("WS","Which statement about air pressure and wind is correct?",
   "wind is caused by differences in air pressure between two places",
   C("Without a pressure difference there is no wind; the bigger the difference, the stronger the wind.")+
   steps("Two places have different air pressures","Air flows from high to low pressure","That flow of air is the wind.")+
   U("Forecasters predict strong winds when they see a large pressure difference on a weather map."),
   [("wind blows only where pressure is equal","Equal pressure means no wind; wind needs a difference."),
    ("air pressure has nothing to do with wind","Air pressure differences are the very cause of wind."),
    ("wind always blows from low to high pressure","Wind blows from high to low pressure, not the reverse.")]),

 ("WS","A simple home experiment crushing a sealed empty tin after heating and cooling shows that:",
   "air pressure can push hard enough to crush the tin",
   C("Cooling lowers the pressure inside, so the greater outside air pressure crushes the tin.")+
   steps("Heating drives some air out of the tin","Sealing and cooling lowers inside pressure","Higher outside air pressure crushes the tin inward.")+
   U("This classic demonstration proves how powerfully air pressure can push."),
   [("air has no pushing force","The crushed tin proves air pressure pushes very hard."),
    ("heat makes metal weak forever","The tin is crushed by pressure difference, not permanent weakening."),
    ("water inside expands and bursts it","The tin is crushed inward by outside pressure, not burst outward.")]),

 ("WS","Thunderstorms are most likely to develop in weather that is:",
   "hot and humid",
   C("Hot, moist air rises strongly and builds the tall clouds that produce thunderstorms.")+
   steps("Hot, humid air rises fast","It forms towering rain clouds","Charges build, giving lightning and thunder.")+
   U("This is why thunderstorms are common on sweaty afternoons before the monsoon."),
   [("cold and dry","Cold, dry air rises little; thunderstorms need hot, humid air."),
    ("calm and freezing","Freezing calm conditions do not build the rising clouds storms need."),
    ("dusty with no clouds","Thunderstorms need moist rising air and clouds, not dry dust.")]),

 ("WS","The main reason people are advised to move to a cyclone shelter is that the shelter is:",
   "a strong building that can withstand high winds and flooding",
   C("Cyclone shelters are built sturdy and raised, to protect people from wind and storm surge.")+
   steps("Ordinary homes may not survive a cyclone","Shelters are built strong and raised","People stay safe there until the storm passes.")+
   U("Coastal districts run drills so families know the route to the nearest cyclone shelter."),
   [("the only place with mobile signal","Shelters protect lives; their purpose is safety, not phone signal."),
    ("where the storm never reaches","Storms can reach shelters, but the buildings are made to withstand them."),
    ("a place to watch the storm closely","Shelters are for safety, not for storm-watching.")]),

 ("WS","The simple device, often shaped like an arrow on a roof, that shows the direction from which the wind blows is a:",
   "wind vane",
   C("A wind vane swings to point into the wind, showing the direction the wind comes from.")+
   steps("Wind pushes the broad tail of the vane","The arrow turns to face into the wind","Its pointing shows the wind's direction.")+
   U("A wind vane on a building lets sailors and farmers read the wind direction at a glance."),
   [("anemometer","An anemometer measures wind speed, not the direction it comes from."),
    ("thermometer","A thermometer measures temperature, not wind direction."),
    ("rain gauge","A rain gauge measures how much rain falls, not the wind's direction.")]),
]

# ---------- INTEGERS (25) — Maths ----------
IN = [
 ("IN","The sum of the integers (−5) and (+8) is:",
   "3",
   C("Adding a positive to a negative means finding the difference and keeping the larger sign.")+
   steps("(−5) + (+8)","8 is larger and positive, so the answer is positive","8 − 5 = 3.")+
   U("Owing 5 rupees then earning 8 leaves you 3 rupees ahead — the same sum."),
   [("−3","The positive 8 outweighs the −5, so the result is +3, not −3."),
    ("13","13 would add the sizes ignoring the minus sign; the answer is 3."),
    ("−13","Both the size and sign are wrong; (−5) + 8 = 3.")]),

 ("IN","The value of (−7) + (−4) is:",
   "−11",
   C("Adding two negatives makes a larger negative — add their sizes and keep the minus.")+
   steps("Both numbers are negative","Add their sizes: 7 + 4 = 11","Keep the minus sign: −11.")+
   U("Going 7 steps back and then 4 more back leaves you 11 steps behind start."),
   [("11","Two negatives add to a negative; the answer is −11, not +11."),
    ("−3","−3 subtracts the sizes; adding two negatives gives −11."),
    ("3","Adding (−7) and (−4) cannot give a positive; it is −11.")]),

 ("IN","The value of (−6) − (−9) is:",
   "3",
   C("Subtracting a negative is the same as adding its positive.")+
   steps("(−6) − (−9) becomes (−6) + 9","9 is larger and positive","9 − 6 = 3.")+
   U("Removing a 9-rupee debt while owing 6 leaves you 3 rupees in credit."),
   [("−15","−15 adds the negatives; subtracting (−9) means adding 9, giving 3."),
    ("15","15 ignores the −6; the correct result is 3."),
    ("−3","Subtracting (−9) adds 9, so the answer is +3, not −3.")]),

 ("IN","The product (−4) × (+5) equals:",
   "−20",
   C("A negative times a positive gives a negative product.")+
   steps("Multiply the sizes: 4 × 5 = 20","One factor is negative, one positive","Different signs give a negative: −20.")+
   U("Losing 4 rupees a day for 5 days is a change of −20 rupees."),
   [("20","Different signs give a negative product, so it is −20."),
    ("−9","−9 adds 4 and 5; the question is a product, giving −20."),
    ("1","1 subtracts 4 from 5; multiplying gives −20.")]),

 ("IN","The product (−6) × (−7) equals:",
   "42",
   C("A negative times a negative gives a positive product.")+
   steps("Multiply the sizes: 6 × 7 = 42","Both factors are negative","Like signs give a positive: 42.")+
   U("Knowing two negatives make a positive avoids many careless sign mistakes."),
   [("−42","Two negatives multiply to a positive, so it is +42."),
    ("−13","−13 adds the sizes with a minus; the product is +42."),
    ("13","13 only adds the sizes; multiplying gives 42.")]),

 ("IN","The value of (−36) ÷ (+9) is:",
   "−4",
   C("Dividing a negative by a positive gives a negative result.")+
   steps("Divide the sizes: 36 ÷ 9 = 4","Signs are different (− and +)","Different signs give a negative: −4.")+
   U("A debt of 36 shared equally over 9 days is −4 per day."),
   [("4","Different signs give a negative quotient, so it is −4."),
    ("−324","−324 multiplies instead of dividing; 36 ÷ 9 is 4, so −4."),
    ("−45","−45 adds the numbers; dividing gives −4.")]),

 ("IN","The value of (−48) ÷ (−6) is:",
   "8",
   C("Dividing a negative by a negative gives a positive result.")+
   steps("Divide the sizes: 48 ÷ 6 = 8","Both signs are negative","Like signs give a positive: 8.")+
   U("Two negatives cancelling to a positive shows up constantly in sign arithmetic."),
   [("−8","Like signs (both negative) give a positive quotient: +8."),
    ("8 with remainder","48 ÷ 6 is exactly 8; like signs make it positive 8."),
    ("−54","−54 adds the sizes; dividing gives +8.")]),

 ("IN","The additive inverse (opposite) of the integer −12 is:",
   "12",
   C("The additive inverse is the number that adds to it to give zero — just change the sign.")+
   steps("We need −12 + ? = 0","The opposite sign works","So the additive inverse is +12.")+
   U("On a thermometer, +12°C and −12°C are equal distances from zero — opposites."),
   [("−12","−12 added to itself gives −24, not 0; its opposite is +12."),
    ("0","0 added to −12 gives −12, not 0; the inverse is +12."),
    ("1/12","1/12 is the reciprocal idea, not the additive inverse, which is +12.")]),

 ("IN","Among the integers −3, −7, 0 and −1, the greatest is:",
   "0",
   C("On the number line, numbers further right are greater; 0 is right of every negative here.")+
   steps("All the others are negative","Negatives lie left of 0","So 0, being furthest right, is the greatest.")+
   U("A balance of 0 rupees is better than any debt — so 0 is the greatest here."),
   [("−1","−1 is the greatest negative but still less than 0."),
    ("−7","−7 is the smallest of all, far from being greatest."),
    ("−3","−3 is negative and so less than 0, which is the greatest.")]),

 ("IN","On the number line, the integer −4 lies to the ___ of −1:",
   "left",
   C("Smaller numbers sit further left on the number line; −4 is smaller than −1.")+
   steps("Compare −4 and −1","−4 is more negative, hence smaller","Smaller numbers lie to the left.")+
   U("On a thermometer, −4°C is below −1°C, just as it is left on the number line."),
   [("right","Right means larger; −4 is smaller than −1, so it is to the left."),
    ("same spot as","−4 and −1 are different numbers at different points; −4 is to the left."),
    ("above","The number line runs left–right, not up–down; −4 is to the left of −1.")]),

 ("IN","The integer that is 5 more than −2 is:",
   "3",
   C("'5 more than' means add 5 to the number.")+
   steps("Start at −2","Add 5: −2 + 5","Move 5 steps right to reach 3.")+
   U("Warming from −2°C by 5 degrees brings the temperature to 3°C."),
   [("−7","−7 subtracts 5; 'more than' means add, giving 3."),
    ("7","7 ignores the minus on 2; −2 + 5 is 3."),
    ("−3","−3 mis-adds; −2 + 5 is 3.")]),

 ("IN","The integer that is 6 less than 2 is:",
   "−4",
   C("'6 less than' means subtract 6 from the number.")+
   steps("Start at 2","Subtract 6: 2 − 6","Move 6 steps left to reach −4.")+
   U("Spending 6 rupees when you have only 2 leaves you owing 4 — a balance of −4."),
   [("8","8 adds 6; 'less than' means subtract, giving −4."),
    ("4","4 ignores the sign; 2 − 6 is −4."),
    ("−8","−8 mis-subtracts; 2 − 6 is −4.")]),

 ("IN","A morning temperature of −5°C rises by 9 degrees by noon. The noon temperature is:",
   "4°C",
   C("A rise means adding the change to the starting temperature.")+
   steps("Start at −5°C","Add the 9-degree rise: −5 + 9","Result is 4°C.")+
   U("This blends a Heat reading with integer addition on the number line."),
   [("−14°C","−14 subtracts; a rise adds, giving 4°C."),
    ("14°C","14 ignores the −5; −5 + 9 is 4°C."),
    ("−4°C","−4 mis-adds; −5 + 9 is +4°C.")]),

 ("IN","A diver at −15 m (15 m below sea level) goes down another 8 m. Her new position is:",
   "−23 m",
   C("Going further down means adding another negative, making a larger negative.")+
   steps("Start at −15 m","Going down 8 m more adds −8","−15 + (−8) = −23 m.")+
   U("Sea-level depths are recorded as negatives, so descending adds to the negative."),
   [("−7 m","−7 subtracts 8; going deeper adds, giving −23 m."),
    ("23 m","23 m would be above sea level; descending gives −23 m."),
    ("−15 m","−15 ignores the extra 8 m down; the new depth is −23 m.")]),

 ("IN","The value of (−1) × (−1) × (−1) is:",
   "−1",
   C("Three negative factors give a negative product, since an odd number of minuses stays negative.")+
   steps("(−1) × (−1) = +1","Then +1 × (−1) = −1","Three negatives → negative result.")+
   U("Counting whether the number of minus signs is odd or even is a quick sign check."),
   [("1","An odd count of negatives gives a negative; the answer is −1."),
    ("3","3 just counts the ones; their product is −1."),
    ("−3","−3 adds the sizes; the product of three (−1)s is −1.")]),

 ("IN","The product of three negative integers is always:",
   "negative",
   C("An odd number of negative factors gives a negative product.")+
   steps("Two negatives multiply to a positive","That positive times a third negative","gives a negative result.")+
   U("Spotting odd-versus-even counts of minus signs predicts the sign instantly."),
   [("positive","Three (an odd number of) negatives give a negative, not positive."),
    ("zero","A product is zero only if a factor is zero; three negatives give a negative."),
    ("always 1","The value is not fixed at 1; only the sign is fixed — negative.")]),

 ("IN","The value of 0 × (−15) is:",
   "0",
   C("Any number multiplied by zero gives zero, whatever its sign.")+
   steps("One factor is 0","Anything times 0 is 0","So 0 × (−15) = 0.")+
   U("Zero of anything — even of a debt — is still nothing, which is why it is 0."),
   [("−15","Multiplying by 0 gives 0, not −15."),
    ("15","0 times any number is 0, not 15."),
    ("−0 meaning less than zero","Zero has no sign; 0 × (−15) is simply 0.")]),

 ("IN","The only integer lying strictly between −2 and 0 is:",
   "−1",
   C("Between −2 and 0, the single whole-number step is −1.")+
   steps("List integers from −2 up to 0","They are −2, −1, 0","The one strictly between is −1.")+
   U("On a number line, −1 sits exactly one step right of −2 and one step left of 0."),
   [("0","0 is an endpoint, not strictly between −2 and 0."),
    ("−2","−2 is the other endpoint, not between them."),
    ("1","1 is to the right of 0, outside the range; the answer is −1.")]),

 ("IN","The sum of any integer and its additive inverse is always:",
   "0",
   C("A number and its opposite cancel out exactly, leaving zero.")+
   steps("Take any integer, say 7","Its additive inverse is −7","7 + (−7) = 0.")+
   U("Earning 7 rupees and then spending 7 leaves your balance unchanged at 0."),
   [("1","A number plus its opposite is 0, not 1."),
    ("the number itself","Adding the opposite cancels the number, giving 0, not the number."),
    ("always positive","The sum is exactly 0, which is neither positive nor negative.")]),

 ("IN","The value of (−8) + 8 + (−3) is:",
   "−3",
   C("Pair the opposites first; (−8) and 8 cancel, leaving the last term.")+
   steps("(−8) + 8 = 0","0 + (−3)","= −3.")+
   U("Spotting that opposites cancel makes long chains of integers quick to add."),
   [("−19","−19 adds all sizes with a minus; the +8 cancels the −8, giving −3."),
    ("3","The leftover term is −3, not +3."),
    ("13","13 ignores the signs; the correct sum is −3.")]),

 ("IN","A bank balance of −200 (overdrawn) after a deposit of 500 becomes:",
   "300",
   C("A deposit adds a positive amount to the negative balance.")+
   steps("Start at −200","Add the 500 deposit: −200 + 500","= 300.")+
   U("Clearing a 200 overdraft with a 500 deposit leaves 300 in credit."),
   [("−700","−700 adds the sizes with a minus; a deposit adds, giving 300."),
    ("700","700 ignores the −200 overdraft; the balance is 300."),
    ("−300","−300 has the wrong sign; −200 + 500 is +300.")]),

 ("IN","The property shown by a + b = b + a for all integers a and b is the:",
   "commutative property of addition",
   C("Commutativity means the order of adding does not change the sum.")+
   steps("Add a then b, or b then a","Both give the same total","This 'order does not matter' rule is commutativity.")+
   U("Knowing addition is commutative lets you rearrange numbers for easier mental sums."),
   [("associative property","Associativity is about grouping with brackets, not swapping order."),
    ("distributive property","Distributivity links multiplication over addition, not swapping addends."),
    ("closure property","Closure says the sum stays an integer; swapping order is commutativity.")]),

 ("IN","The value of (−2) × 3 × (−5) is:",
   "30",
   C("Two of the three factors are negative; an even count of minuses gives a positive product.")+
   steps("(−2) × 3 = −6","−6 × (−5) = 30","Two negatives → positive result.")+
   U("Checking that the number of minus signs is even tells you the answer is positive."),
   [("−30","Two negatives (an even count) give a positive, so it is +30."),
    ("30 with a remainder","30 is exact; the product (−2)×3×(−5) is exactly 30."),
    ("−4","−4 adds the numbers; multiplying gives 30.")]),

 ("IN","The difference between a temperature of 6°C and one of −4°C is:",
   "10°C",
   C("The difference between two temperatures is found by subtracting the lower from the higher.")+
   steps("Higher = 6°C, lower = −4°C","6 − (−4) = 6 + 4","= 10°C.")+
   U("This fuses a Heat reading with integer subtraction across zero on the scale."),
   [("2°C","2 mistakenly does 6 − 4; subtracting (−4) means adding 4, giving 10°C."),
    ("−10°C","A difference of temperatures is taken as a positive gap, 10°C."),
    ("24°C","24 multiplies; the difference is 6 − (−4) = 10°C.")]),

 ("IN","Writing −1, −5, 3 and −2 in descending (largest to smallest) order gives:",
   "3, −1, −2, −5",
   C("Descending order runs from the largest number down to the smallest.")+
   steps("Largest is the positive 3","Among negatives, −1 > −2 > −5","So: 3, −1, −2, −5.")+
   U("Ranking temperatures from warmest to coldest uses this exact ordering of integers."),
   [("−5, −2, −1, 3","That is ascending (smallest first); descending is 3, −1, −2, −5."),
    ("3, −5, −2, −1","Among negatives, −1 is largest and −5 smallest; order is 3, −1, −2, −5."),
    ("−1, −2, 3, −5","This mixes the order; correct descending is 3, −1, −2, −5.")]),
]

# ---------- DATA HANDLING (25) — Maths ----------
DH = [
 ("DH","The arithmetic mean (average) of the numbers 4, 6 and 8 is:",
   "6",
   C("The mean is the total of the values divided by how many there are.")+
   steps("Add them: 4 + 6 + 8 = 18","Count the values: 3","Mean = 18 ÷ 3 = 6.")+
   U("Finding your average marks across three tests works exactly this way."),
   [("18","18 is the total; the mean divides that by 3, giving 6."),
    ("9","9 is half the total; dividing by the count 3 gives 6."),
    ("4","4 is just the smallest value, not the average, which is 6.")]),

 ("DH","The mean of the values 10, 20 and 30 is:",
   "20",
   C("Add the values and divide by how many there are.")+
   steps("Add: 10 + 20 + 30 = 60","Count: 3 values","Mean = 60 ÷ 3 = 20.")+
   U("Averaging three monthly bills tells you a typical month's cost — the mean."),
   [("60","60 is the total; the mean is that divided by 3, which is 20."),
    ("30","30 is the largest value, not the average of all three, which is 20."),
    ("10","10 is the smallest value; the mean of all three is 20.")]),

 ("DH","In the data set 2, 3, 3, 5 and 7, the mode is:",
   "3",
   C("The mode is the value that appears most often in the data.")+
   steps("List how often each value occurs","3 appears twice, the others once","So the mode is 3.")+
   U("A shop notes its mode shoe size — the size sold most often — to stock up on it."),
   [("7","7 is the largest value but appears once; the most frequent is 3."),
    ("5","5 is the middle value, not the most frequent; the mode is 3."),
    ("4","4 is not even in the data; the mode is the most common value, 3.")]),

 ("DH","The median of the ordered data 3, 5, 7, 9 and 11 is:",
   "7",
   C("The median is the middle value once the data is arranged in order.")+
   steps("The data is already in order","Five values, so the middle is the third","The third value is 7.")+
   U("The median income of a town tells you the 'middle' earner's income."),
   [("5","5 is the second value, not the middle of five, which is 7."),
    ("9","9 is the fourth value; the middle of five values is the third, 7."),
    ("11","11 is the largest value, not the middle one, which is 7.")]),

 ("DH","The range of the data 12, 5, 9 and 20 is:",
   "15",
   C("The range is the difference between the highest and lowest values.")+
   steps("Highest = 20, lowest = 5","Range = highest − lowest","20 − 5 = 15.")+
   U("The range of daily temperatures tells you how much the weather varied."),
   [("20","20 is the highest value alone; the range subtracts the lowest, giving 15."),
    ("25","25 adds highest and lowest; the range subtracts them, giving 15."),
    ("5","5 is the lowest value; the range is 20 − 5 = 15.")]),

 ("DH","The mean of 2, 4, 6, 8 and 10 is:",
   "6",
   C("Add all five values and divide by 5.")+
   steps("Add: 2 + 4 + 6 + 8 + 10 = 30","Count: 5 values","Mean = 30 ÷ 5 = 6.")+
   U("Averaging five readings smooths out the highs and lows into one typical value."),
   [("30","30 is the total; dividing by 5 gives the mean, 6."),
    ("5","5 is the count of values, not their average, which is 6."),
    ("10","10 is the largest value; the mean of all five is 6.")]),

 ("DH","In a data set, the value that occurs most frequently is called the:",
   "mode",
   C("The mode is defined as the most frequently occurring observation.")+
   steps("Look at how often each value appears","Find the one that appears most","That value is the mode.")+
   U("Knowing the modal size helps a tailor cut the most common size first."),
   [("mean","The mean is the average of all values, not the most frequent one."),
    ("median","The median is the middle value in order, not the most frequent."),
    ("range","The range is the spread between highest and lowest, not a frequent value.")]),

 ("DH","When data is arranged in order, the median is the:",
   "middle value",
   C("The median splits ordered data into two halves; it is the middle value.")+
   steps("Arrange the data from least to greatest","Find the value in the centre","That centre value is the median.")+
   U("The median marks the half-way point — half the data lies on each side."),
   [("largest value","The largest value is the maximum, not the middle median."),
    ("most frequent value","The most frequent value is the mode, not the median."),
    ("sum of all values","The sum is used for the mean, not the median, which is the middle value.")]),

 ("DH","In a bar graph, the height (or length) of each bar represents the:",
   "value or frequency of that item",
   C("Taller bars mean larger values, so a bar's height shows the quantity it stands for.")+
   steps("Each bar stands for one item","Its height is read off the scale","That height is the item's value or count.")+
   U("A bar graph of rainfall lets you see at a glance which month was wettest."),
   [("name of the item only","The name is the label; the height shows the value or frequency."),
    ("colour chosen for the bar","Colour is just for clarity; the height carries the value."),
    ("width of the bar","Bars share equal width; it is the height that shows the value.")]),

 ("DH","A pictograph represents data using:",
   "pictures or symbols, each standing for a number",
   C("In a pictograph, repeated symbols (each worth a set amount) show the quantities.")+
   steps("Choose a symbol to stand for a number","Repeat it as many times as needed","The rows of symbols show the data.")+
   U("A pictograph of apples sold, each picture = 10 apples, is easy for anyone to read."),
   [("only long bars of equal width","That describes a bar graph, not a pictograph of symbols."),
    ("a single pie-shaped circle","A circle of slices is a pie chart, not a pictograph."),
    ("written paragraphs of text","A pictograph uses symbols, not paragraphs of text.")]),

 ("DH","When a fair coin is tossed once, the probability of getting a head is:",
   "1/2",
   C("A coin has two equally likely outcomes, so a head has a 1-in-2 chance.")+
   steps("Possible outcomes: head or tail (2)","Favourable outcome: head (1)","Probability = 1/2.")+
   U("Tossing a coin to choose who bats first relies on this fair 1/2 chance."),
   [("1","A probability of 1 means certain; a head is not certain, it is 1/2."),
    ("2","Probability is never more than 1; the chance of a head is 1/2."),
    ("0","0 means impossible; a head is quite possible, with probability 1/2.")]),

 ("DH","When a fair six-faced die is rolled once, the probability of getting a 3 is:",
   "1/6",
   C("A die has six equally likely faces, so any one number has a 1-in-6 chance.")+
   steps("Possible outcomes: 1 to 6 (six)","Favourable: getting a 3 (one)","Probability = 1/6.")+
   U("Board games use this 1/6 chance for each number when you roll the die."),
   [("1/2","1/2 is the chance for a coin's two sides; a die has six faces, so 1/6."),
    ("1/3","1/3 would be two of the six faces; a single 3 is just 1/6."),
    ("3/6","3/6 is the chance of three favourable faces; only one face is a 3, so 1/6.")]),

 ("DH","The probability of an event that is impossible is:",
   "0",
   C("If an event can never happen, its probability is zero.")+
   steps("An impossible event has no favourable outcomes","0 favourable out of the total","Probability = 0.")+
   U("The chance of rolling a 7 on an ordinary die is 0 — it simply cannot happen."),
   [("1","1 means certain, the opposite of impossible; an impossible event is 0."),
    ("1/2","1/2 is an even chance; an impossible event has probability 0."),
    ("100","Probability never exceeds 1; an impossible event is 0.")]),

 ("DH","The probability of an event that is certain to happen is:",
   "1",
   C("If an event is sure to occur, its probability is one.")+
   steps("A certain event always happens","All outcomes are favourable","Probability = 1.")+
   U("The chance that a tossed coin shows either a head or a tail is 1 — it is certain."),
   [("0","0 means impossible, the opposite of certain; a certain event is 1."),
    ("1/2","1/2 is an even chance; a certain event has probability 1."),
    ("2","Probability cannot exceed 1; a certain event is exactly 1.")]),

 ("DH","Over a week, the daytime temperatures were 30°, 32°, 31°, 33°, 29°, 34° and 31°C. Their mean is:",
   "31°C",
   C("Add the seven temperatures and divide by 7 to get the average.")+
   steps("Add: 30+32+31+33+29+34+31 = 217","Count: 7 days","Mean = 217 ÷ 7 = 31°C.")+
   U("This fuses a Heat record with finding a mean — the week's typical temperature."),
   [("217°C","217 is the total; the mean divides it by 7, giving 31°C."),
    ("34°C","34 is the hottest day, not the average, which is 31°C."),
    ("7°C","7 is the number of days, not the mean temperature, which is 31°C.")]),

 ("DH","A weather station logs wind speeds of 12, 15, 18 and 15 km/h on four days. The mode is:",
   "15 km/h",
   C("The mode is the value that appears most often — here 15 appears twice.")+
   steps("List the speeds: 12, 15, 18, 15","15 occurs twice, the others once","So the mode is 15 km/h.")+
   U("This blends a wind-speed log with finding the most common reading — the mode."),
   [("18 km/h","18 is the highest speed but appears once; the most frequent is 15."),
    ("12 km/h","12 is the lowest and appears once; the mode is 15 km/h."),
    ("60 km/h","60 is the total of all four; the mode is the most frequent value, 15.")]),

 ("DH","When a data set has an even number of ordered values, the median is found by taking:",
   "the average of the two middle values",
   C("With no single centre value, the median is the mean of the two values in the middle.")+
   steps("Arrange the data in order","Locate the two central values","Average them to get the median.")+
   U("For an even-sized list, this averaging gives a fair 'middle' figure."),
   [("the largest of all the values","The largest is the maximum, not the median of an even list."),
    ("the first value in the list","The first value is the minimum, not the central median."),
    ("the sum of all the values","The sum gives the mean's numerator, not the median.")]),

 ("DH","If the mean of 4 numbers is 10, then the total (sum) of those numbers is:",
   "40",
   C("Since mean = total ÷ count, the total is mean × count.")+
   steps("Mean = 10, count = 4","Total = mean × count","Total = 10 × 4 = 40.")+
   U("Working back from an average to the total is a handy reverse of finding the mean."),
   [("10","10 is the mean of each, not the total of all four, which is 40."),
    ("14","14 adds the mean and the count; the total is 10 × 4 = 40."),
    ("2.5","2.5 divides 10 by 4; the total is 10 × 4 = 40.")]),

 ("DH","A double bar graph is especially useful when you want to:",
   "compare two sets of data side by side",
   C("Double bar graphs place two bars per category, making comparisons easy.")+
   steps("Each category gets two bars","One bar per data set","Side-by-side bars show the comparison clearly.")+
   U("A double bar graph of boys' and girls' marks compares the two groups at a glance."),
   [("show a single set of data only","A single set needs only a simple bar graph, not a double one."),
    ("display fractions of a whole","Fractions of a whole are shown by a pie chart, not a double bar graph."),
    ("record data without any numbers","Bar graphs use a number scale; the double form compares two sets.")]),

 ("DH","The range of a data set is calculated as:",
   "highest value minus lowest value",
   C("The range measures spread: subtract the smallest value from the largest.")+
   steps("Find the highest value","Find the lowest value","Range = highest − lowest.")+
   U("The range of test scores shows how widely the class's marks were spread out."),
   [("highest value plus lowest value","Range is a difference, not a sum; it is highest minus lowest."),
    ("the most frequent value","The most frequent value is the mode, not the range."),
    ("total divided by count","That formula gives the mean, not the range.")]),

 ("DH","The mean of the numbers 0, 0, 0 and 4 is:",
   "1",
   C("Add all the values, including the zeros, and divide by how many there are.")+
   steps("Add: 0 + 0 + 0 + 4 = 4","Count: 4 values","Mean = 4 ÷ 4 = 1.")+
   U("Even values of zero count when averaging — they pull the mean down."),
   [("4","4 is the total; the mean divides it by 4, giving 1."),
    ("0","The zeros do not make the mean 0; the 4 raises the average to 1."),
    ("2","2 ignores some zeros; the mean of all four values is 1.")]),

 ("DH","The mean of the integers −2, 0 and 2 is:",
   "0",
   C("Add the values, letting the negative and positive cancel, then divide by the count.")+
   steps("Add: −2 + 0 + 2 = 0","Count: 3 values","Mean = 0 ÷ 3 = 0.")+
   U("This fuses integer addition with finding a mean — opposites cancel to give 0."),
   [("4","4 ignores the minus sign on −2; the sum is 0, so the mean is 0."),
    ("2","2 is the largest value, not the average of all three, which is 0."),
    ("−2","−2 is the smallest value; with the +2 cancelling it, the mean is 0.")]),

 ("DH","When a fair six-faced die is rolled, the probability of getting an even number is:",
   "1/2",
   C("Three of the six faces (2, 4, 6) are even, giving a 3-in-6, or 1/2, chance.")+
   steps("Even faces: 2, 4, 6 (three of them)","Total faces: 6","Probability = 3/6 = 1/2.")+
   U("Half the faces of a die are even, so an even roll is a fair even chance."),
   [("1/6","1/6 is the chance of one particular face; three even faces give 1/2."),
    ("1/3","1/3 would be two of the six faces; there are three even faces, so 1/2."),
    ("1","1 means certain; an even number is only half-likely, so 1/2.")]),

 ("DH","In the marks 5, 5, 6, 7 and 8, the mode is:",
   "5",
   C("The mode is the most frequent value, and 5 appears twice while the rest appear once.")+
   steps("Count each: 5 appears twice","6, 7 and 8 appear once each","The most frequent value is 5.")+
   U("A teacher noting the modal mark sees which score was most common in the class."),
   [("8","8 is the highest mark but appears once; the most frequent is 5."),
    ("6","6 is the middle value, not the most frequent; the mode is 5."),
    ("31","31 is the total of the marks, not the mode, which is 5.")]),

 ("DH","A pie chart (circle graph) is best used to show:",
   "how a whole is divided into parts",
   C("A pie chart slices a circle so each slice's size shows its share of the whole.")+
   steps("The full circle stands for the whole","Each slice is a part of it","Bigger slices mean bigger shares.")+
   U("A pie chart of how you spend your day shows at a glance which activity takes the most time."),
   [("the exact wind speed each hour","Changing values over time suit a bar or line graph, not a pie chart."),
    ("two data sets side by side","Comparing two sets is a job for a double bar graph, not a pie chart."),
    ("the precise temperature of a body","Temperature is read from a thermometer, not shown in a pie chart.")]),
]

assert len(HT) == 25 and len(WS) == 25 and len(IN) == 25 and len(DH) == 25

# Interleave so no two consecutive questions share a chapter; Science/Maths alternate.
items = []
for i in range(25):
    items += [HT[i], IN[i], WS[i], DH[i]]
assert len(items) == 100

for a, b in zip(items, items[1:]):
    assert a[0] != b[0], (a[1], b[1])

if __name__ == "__main__":
    here = os.path.dirname(os.path.abspath(__file__))
    papers_dir = os.path.abspath(os.path.join(
        here, "..", "..", "desktopAhaan", "Resources", "BossChallengePapers"))
    os.chdir(papers_dir)

    keydist = build_paper(PNUM, TITLE, SHORT, LABELS, items, seed=15233,
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
    split = "/".join(str(counts[c]) for c in ("HT", "WS", "IN", "DH"))
    with open("PAPERS_MANIFEST.md", "a", encoding="utf-8") as fh:
        fh.write(f"| {PNUM} | 2026-06-18 | {TITLE} | {split} | ✓ |\n")

    print("Files:", sorted(v for v in moves.values()))
    print("Answer key spread A/B/C/D =", dict(keydist))
