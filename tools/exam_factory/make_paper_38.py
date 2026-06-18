# -*- coding: utf-8 -*-
# Boss Challenge Paper 38 — Winds, Storms & Cyclones · Wastewater Story · Exponents & Powers · Lines & Angles
# Content-only. Uses the dependency-free examfactory engine.
# Difficulty ramp: leans into FUSION. A cyclone's wind speed becomes a number in STANDARD FORM; a
# treatment tank's hourly throughput becomes a POWER OF TEN; a weather-vane bearing becomes a
# COMPLEMENTARY ANGLE; two roads meeting becomes a LINEAR PAIR. The child meets a Science situation
# and reaches for a Maths skill. Class-7 scope, simple wording, hard thinking.
# Produces, under Resources/BossChallengePapers/:
#   Paper_38_<SHORT>_QuestionPaper.html  (pure HTML — questions + options)
#   Paper_38_<SHORT>_QuestionPaper.pdf
#   Paper_38_<SHORT>_Questions.md
#   Paper_38_<SHORT>_Solutions.html
import os, sys, shutil, json, re
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from examfactory import build_paper, C, steps, U

PNUM  = "38"
SHORT = "WindsStorms_Wastewater_Exponents_LinesAngles"
TITLE = ("Winds, Storms & Cyclones · Wastewater Story · "
         "Exponents & Powers · Lines & Angles")
LABELS = {
    "WS": "Winds, Storms & Cyclones",
    "WW": "Wastewater Story",
    "EX": "Exponents & Powers",
    "LA": "Lines & Angles",
}

# ---------- WINDS, STORMS & CYCLONES (25) — Science ----------
WS = [
 ("WS","Air around us pushes on every surface it touches; this push spread over an area is called air:",
   "pressure",
   C("Air is real stuff with weight, and it pushes on everything it touches. That push per unit area is air pressure.")+
   steps("Air is made of tiny moving particles","they bump against every surface","this steady push over an area is called pressure."),
   [("speed","Speed tells how fast the air is moving, not how hard it pushes; the push per area is pressure."),
    ("vapour","Vapour is water in gas form floating in air, not the push of the air; that push is pressure."),
    ("humidity","Humidity is the amount of water vapour in air, not its push; the push per area is pressure.")]),

 ("WS","When air is heated it expands, becomes lighter, and tends to:",
   "rise up",
   C("Heating makes air spread out, so the same amount takes more space and weighs less per litre — light air rises.")+
   steps("Heat makes air expand","expanded air is lighter for its size","lighter air floats up over the heavier cool air."),
   [("sink down","Cool, dense air sinks; warm, light air does the opposite and rises."),
    ("stop moving","Heated air does not stop — it actively rises and sets up a wind."),
    ("turn solid","Air does not become solid when heated; it expands and rises.")]),

 ("WS","Wind is simply air that is:",
   "moving from one place to another",
   C("Wind is nothing mysterious — it is just air on the move from one spot to another.")+
   steps("Air gathers where pressure is high","it flows toward where pressure is low","this moving air is what we feel as wind."),
   [("completely still","Still air is no wind at all; wind is air in motion."),
    ("frozen into ice","Ice is frozen water, not air; wind is moving air."),
    ("trapped in a sealed jar","Trapped air cannot flow; wind needs air free to move from place to place.")]),

 ("WS","Warm air rises above cool air because, for the same volume, warm air is:",
   "lighter than cool air",
   C("Warm air has spread out, so a given volume of it holds less stuff and weighs less than the same volume of cool air.")+
   steps("Warm air expands and thins out","the same volume now weighs less","the lighter warm air floats up past the heavier cool air."),
   [("heavier than cool air","If warm air were heavier it would sink; in fact it is lighter and rises."),
    ("exactly as heavy as cool air","Heating changes the weight per volume — warm air becomes lighter, not equal."),
    ("made of water only","Air is mostly nitrogen and oxygen, not water; it rises because it is lighter when warm.")]),

 ("WS","Air always moves from a region of higher pressure toward a region of:",
   "lower pressure",
   C("Like a crowd spilling from a packed room into an empty one, air flows from where pressure is high to where it is low.")+
   steps("Pressure is uneven from place to place","air pushes hardest where pressure is high","so it streams toward the low-pressure side."),
   [("higher pressure","Air does not pile into the already-crowded high-pressure side; it flows away from it."),
    ("equal pressure","Where pressure is already equal there is no push, so no wind forms."),
    ("no air at all","Air flows toward low pressure, not into a true vacuum that rarely exists here.")]),

 ("WS","Compared with slow or still air, faster-moving air exerts ___ pressure.",
   "lower",
   C("This is the key storm idea: the faster air rushes past, the less sideways push (pressure) it has.")+
   steps("Still air pushes with its full pressure","fast-moving air spends its energy moving","so it presses sideways with less force — lower pressure."),
   [("higher","Fast air presses LESS, not more; that is why roofs lift in a gale."),
    ("exactly the same","Speed does change the push — faster air gives lower pressure."),
    ("no","Fast air still has pressure, just a lower amount than still air.")]),

 ("WS","When you blow hard across the top of a paper strip held to your lips, the strip:",
   "rises up",
   C("Fast air over the top lowers the pressure there, so the ordinary higher pressure below pushes the strip up.")+
   steps("Blowing makes fast air rush over the top","fast air means lower pressure above the strip","the higher pressure underneath pushes the strip upward."),
   [("presses flat down","The strip lifts, not flattens — low pressure is now above it."),
    ("tears apart","A gentle blow lifts the strip; it does not rip it."),
    ("stays exactly still","The pressure is no longer balanced, so the strip moves — it rises.")]),

 ("WS","During the day, land heats up faster than the sea, so near the coast the breeze blows from:",
   "sea to land",
   C("Hot land makes air above it rise; cooler sea air rushes in to fill the gap — a sea breeze blowing onto the shore.")+
   steps("By day the land heats faster than the water","warm air over the land rises","cooler air from the sea moves in, blowing from sea to land."),
   [("land to sea","That is the NIGHT pattern; by day the breeze blows from sea to land."),
    ("sky to ground","Breezes blow sideways across the coast, not straight down from the sky."),
    ("north pole to coast","Local breezes come from the nearby sea, not from the pole.")]),

 ("WS","At night the land cools faster than the sea, so near the coast the breeze blows from:",
   "land to sea",
   C("After dark the sea stays warmer, so air rises over the sea and cooler land air flows out to replace it — a land breeze.")+
   steps("At night the land cools faster than the sea","warm air now rises over the warmer sea","cooler air from the land flows out, blowing from land to sea."),
   [("sea to land","That is the DAY pattern; at night the breeze reverses to land-to-sea."),
    ("from the moon","The moon does not blow air; the breeze comes from the cooler land."),
    ("straight upward only","Air does rise over the sea, but the breeze we feel moves sideways from land to sea.")]),

 ("WS","The huge seasonal winds that bring most of India's rain are called the:",
   "monsoon winds",
   C("Monsoon winds reverse with the seasons; the summer set sweeps in from the sea carrying the rain India depends on.")+
   steps("In summer the land heats strongly and air rises over it","moist air is drawn in from the sea","these rain-bearing seasonal winds are the monsoon."),
   [("trade-free winds","There is no such named wind; India's rain comes with the monsoon."),
    ("polar winds","Polar winds are cold winds from the poles, not India's rain-bringers."),
    ("land breezes","A land breeze is a small nightly coastal wind, not the great rain-bringing monsoon.")]),

 ("WS","A cyclone forms over warm seas; its energy comes from the heat released when water vapour:",
   "condenses into droplets",
   C("Warm seas pour water vapour into the air; when that vapour turns back to liquid it releases heat that powers the storm.")+
   steps("Warm sea water evaporates into vapour","high up the vapour condenses into cloud droplets","this releases heat that drives the cyclone's winds."),
   [("freezes into hailstones","Freezing happens high in some storms, but the cyclone's energy comes from condensing vapour."),
    ("evaporates from the leaves","Plant evaporation is tiny here; the storm feeds on vapour rising from the warm sea."),
    ("splits into atoms","Water is not split into atoms in a storm; heat is released when vapour condenses.")]),

 ("WS","The calm, almost windless centre of a cyclone is called the:",
   "eye",
   C("Right at the middle of a cyclone is a strangely quiet, clear patch called the eye.")+
   steps("Winds spiral around the storm's centre","at the very centre the air is sinking and calm","this calm clear core is the eye."),
   [("tail","A cyclone has no 'tail'; the calm centre is the eye."),
    ("wall","The wall is the violent ring AROUND the calm centre; the calm core itself is the eye."),
    ("root","'Root' belongs to plants, not storms; the calm centre is the eye.")]),

 ("WS","Around the calm centre, the ring carrying the strongest winds and heaviest rain is the:",
   "eye wall",
   C("Hugging the quiet eye is a fierce ring of cloud — the eye wall — where the cyclone hits hardest.")+
   steps("The eye in the middle is calm","just around it winds spiral fastest","this most violent ring is the eye wall."),
   [("eye","The eye itself is CALM; the violent ring around it is the eye wall."),
    ("outer calm","The outer edges are weaker; the strongest winds are in the eye wall near the centre."),
    ("horizon","The horizon is just the far skyline, not a part of the storm.")]),

 ("WS","At the very centre of a cyclone the air pressure is:",
   "very low",
   C("A cyclone is a giant low-pressure system; pressure is lowest right at its centre, which is why air rushes in so fast.")+
   steps("Air rises strongly over the warm centre","this leaves very little air pressing down there","so the centre has very low pressure."),
   [("very high","High pressure pushes air away and calms weather; a cyclone centre is the opposite — very low."),
    ("exactly average","If it were average there would be no strong inrush of wind; cyclone centres are very low."),
    ("zero everywhere","Pressure never drops to true zero in our air; it is very low, not nothing.")]),

 ("WS","A dark, funnel-shaped cloud reaching from the sky to the ground with violently spinning air is a:",
   "tornado",
   C("A tornado is a tight, fast-spinning funnel of air that touches the ground — narrow but extremely destructive.")+
   steps("Air spins very fast in a thin column","the column stretches down from a storm cloud","this funnel touching the ground is a tornado."),
   [("rainbow","A rainbow is harmless coloured light, not a spinning funnel of wind."),
    ("sea breeze","A sea breeze is a gentle coastal wind, nothing like a spinning funnel."),
    ("monsoon","A monsoon is a seasonal rain wind, not a narrow spinning funnel cloud.")]),

 ("WS","Wind speed at a weather station is measured using an instrument called the:",
   "anemometer",
   C("An anemometer has little cups that spin in the wind; the faster they spin, the higher the wind speed it reads.")+
   steps("Wind pushes the cups of the instrument","the cups spin faster in stronger wind","the spin rate is read off as wind speed — that tool is the anemometer."),
   [("thermometer","A thermometer measures temperature, not how fast the wind blows."),
    ("rain gauge","A rain gauge measures how much rain falls, not the wind speed."),
    ("barometer","A barometer measures air pressure; wind speed is measured by an anemometer.")]),

 ("WS","In different parts of the world a cyclone is also called a hurricane or a:",
   "typhoon",
   C("The same kind of giant sea storm goes by different names — cyclone, hurricane, or typhoon — depending on the region.")+
   steps("Over the Indian Ocean it is a cyclone","over the Atlantic it is a hurricane","over the Pacific near Asia it is a typhoon."),
   [("tsunami","A tsunami is a giant sea wave from an undersea earthquake, not a wind storm."),
    ("monsoon","A monsoon is a rain-bringing seasonal wind, not a single spinning storm."),
    ("avalanche","An avalanche is a slide of snow down a mountain, not a sea storm.")]),

 ("WS","As a cyclone reaches the coast it can push sea water far inland in a sudden rise called a storm:",
   "surge",
   C("The cyclone's winds and low pressure heap up sea water and shove it onto the land — a storm surge that floods the coast.")+
   steps("Strong winds drive sea water toward the shore","low pressure lets the water level rise","this sudden inland flood of sea water is a storm surge."),
   [("breeze","A breeze is a gentle wind, not a wall of rising sea water."),
    ("drizzle","Drizzle is light rain; a surge is a flood of sea water onto the land."),
    ("mirage","A mirage is a trick of light in heat, not rising sea water.")]),

 ("WS","During a cyclone the roof of a weak house can be lifted off because, outside, the fast wind makes the pressure:",
   "lower than inside",
   C("Air rushing over the roof drops the pressure above it, while the calmer air inside still pushes up — and the roof lifts.")+
   steps("Fast wind rushes over the top of the roof","fast air means lower pressure above the roof","the higher pressure trapped inside pushes the roof up and off."),
   [("higher than inside","If outside pressure were higher it would press the roof down, not lift it."),
    ("exactly equal inside and out","Equal pressure would balance out and the roof would stay; the wind makes outside pressure lower."),
    ("disappear completely","Pressure outside drops but does not vanish; it just becomes lower than inside.")]),

 ("WS","A sealed tin can with a little boiling water inside is cooled; it gets crushed because the pressure inside becomes ___ the outside air pressure.",
   "lower than",
   C("Cooling turns the steam back to water and leaves little air inside, so the outside air — pressing harder — crushes the can.")+
   steps("Boiling fills the can with steam, pushing air out","sealing and cooling turns steam back to liquid","now low pressure inside lets the higher outside pressure crush the can."),
   [("higher than","If inside pressure were higher the can would bulge out, not crush in."),
    ("equal to","Equal pressure would leave the can unchanged; it is crushed because inside pressure is lower."),
    ("doubled compared to","Cooling lowers the inside pressure, it does not double it.")]),

 ("WS","The science of studying weather, clouds and storms to give warnings is done by the ___ department.",
   "meteorological",
   C("Meteorology is the study of the atmosphere; the meteorological department watches the skies and issues storm warnings.")+
   steps("Scientists track temperature, pressure and clouds","they spot conditions that lead to storms","this weather-watching body is the meteorological department."),
   [("agricultural","The agricultural department deals with farming, not weather forecasts."),
    ("electrical","The electrical department handles power supply, not weather warnings."),
    ("geological","The geological department studies rocks and earthquakes, not the weather.")]),

 ("WS","The safest action when a cyclone warning is given is to:",
   "move to a safe shelter on higher ground",
   C("Cyclones bring flooding and flying debris; the safe move is to leave low coastal spots for a sturdy shelter on higher ground.")+
   steps("A warning means dangerous winds and flooding are coming","low coastal areas flood first","so move early to a strong shelter on higher ground."),
   [("go to the beach to watch","The beach is the most dangerous place during a cyclone — never go to watch."),
    ("stand under a tall tree","Trees can be uprooted or struck by lightning; shelter in a safe building instead."),
    ("touch fallen electric wires","Fallen wires can be live and deadly; stay far away and reach a safe shelter.")]),

 ("WS","Near the equator the Sun's heat is strongest, so the air there is constantly being:",
   "warmed and made to rise",
   C("The equator gets the most direct sunlight, so its air is always heating up and rising — a key driver of global winds.")+
   steps("Sunlight hits the equator most directly","this warms the air strongly there","warm air rises, pulling in winds from cooler places."),
   [("cooled and made to sink","Cooling and sinking happen near the poles, not at the hot equator."),
    ("frozen and kept still","Equatorial air is hot, not frozen; it warms and rises."),
    ("turned into rock","Air cannot turn into rock; near the equator it warms and rises.")]),

 ("WS","Cyclones cause the worst damage along the ___ rather than deep inland.",
   "coastline",
   C("A cyclone draws its strength from warm sea water, so it is fiercest where land meets sea — the coastline.")+
   steps("Cyclones feed on warm ocean water","they are strongest as they cross the shore","so the coastline takes the worst damage."),
   [("mountain peaks","Cyclones weaken inland and over land; the coast, not high peaks, is hit hardest."),
    ("desert centre","Deserts are far from the sea that feeds cyclones; the coastline suffers most."),
    ("underground caves","Cyclones are storms in the air at the coast, not underground events.")]),

 ("WS","Two light balloons hang side by side with a small gap; when you blow air through the gap, they swing:",
   "toward each other",
   C("Blowing speeds up the air between the balloons, dropping the pressure there, so the steady outside air pushes them together.")+
   steps("Blowing makes air rush fast through the gap","fast air between them means lower pressure there","the higher outside pressure pushes the balloons toward each other."),
   [("away from each other","Lower pressure forms BETWEEN them, so they are pushed together, not apart."),
    ("straight up to the ceiling","The sideways pressure difference pulls them together, not upward."),
    ("they pop instantly","A gentle blow only moves the balloons together; it does not pop them.")]),
]

WS_UC = [
 "Knowing air has pressure explains why a packed bag of chips puffs up on a hill.",
 "Seeing that warm air rises is why a hot-air balloon floats and smoke climbs upward.",
 "Understanding wind as moving air is the first idea behind every weather forecast you hear.",
 "Knowing warm air is lighter explains the draught that rises off a warm radiator.",
 "High-to-low pressure flow is why air whistles out of a punctured tyre.",
 "Fast-air-means-low-pressure is the secret behind aeroplane wings and curving footballs.",
 "The paper-strip trick is a one-breath demo of the same lift that flies a kite.",
 "The sea breeze is why a beach feels pleasantly windy on a hot afternoon.",
 "The land breeze is why coastal nights have a gentle wind blowing out to sea.",
 "Knowing the monsoon is why Indian farmers plan their whole year around its arrival.",
 "Knowing storms feed on condensing vapour is why cyclones grow over warm seas.",
 "Spotting the calm eye on a weather map tells forecasters exactly where the storm's centre is.",
 "Knowing the eye wall is fiercest is why warnings say the worst comes just after the calm.",
 "Reading 'very low pressure' on a map is how forecasters recognise a forming cyclone.",
 "Recognising a tornado funnel early gives people precious minutes to take shelter.",
 "An anemometer's reading is what airports use to decide if it is safe to take off.",
 "Knowing the names hurricane and typhoon helps you follow storm news from around the world.",
 "Understanding storm surge is why coastal towns build sea walls and evacuate early.",
 "The roof-lift idea is why builders strap roofs down in cyclone-prone coastal areas.",
 "The crushed-can effect is the same low-pressure force that powers a vacuum-sealed jar.",
 "Trusting the meteorological department is how a fishing village knows when to stay ashore.",
 "Heading to higher ground on a warning is the single action that saves the most lives.",
 "Knowing the equator heats most explains why the world's biggest storms start in the tropics.",
 "Knowing storms hit the coast hardest is why coastal homes need the strongest building rules.",
 "The two-balloon trick is a tabletop version of why parked trucks rock when a fast bus passes.",
]

# ---------- EXPONENTS & POWERS (25) — Maths ----------
EX = [
 ("EX","In the number 2⁵, the small raised 5 is called the:",
   "exponent",
   C("A power has two parts: the big number being multiplied (base) and the small raised number that counts the multiplications (exponent).")+
   steps("2⁵ means 2 multiplied by itself again and again","the small raised 5 says HOW MANY times","that counting number is called the exponent."),
   [("base","The base is the 2 being multiplied; the small raised number is the exponent."),
    ("product","The product is the final value (32); the small raised number is the exponent."),
    ("sum","A sum comes from adding; the raised number that counts multiplications is the exponent.")]),

 ("EX","In 7³, the number 7 that is multiplied repeatedly is called the:",
   "base",
   C("In a power, the number being multiplied over and over is the base; here that number is 7.")+
   steps("7³ means 7 × 7 × 7","the 7 is the number being multiplied","that repeated number is the base."),
   [("exponent","The exponent is the small raised 3 that counts the multiplications, not the 7."),
    ("product","The product is the answer (343), not the number being multiplied."),
    ("remainder","A remainder is what is left after dividing; the 7 being multiplied is the base.")]),

 ("EX","The repeated product 2 × 2 × 2 × 2 can be written in short as:",
   "2⁴",
   C("Counting how many 2's are multiplied gives the exponent; there are four of them, so it is 2⁴.")+
   steps("Count the 2's being multiplied: there are four","the base is 2, the exponent is 4","so the short form is 2⁴."),
   [("4²","4² means 4 × 4 = 16; but here four 2's are multiplied, giving 2⁴ = 16 written differently."),
    ("2 × 4","2 × 4 is just 8; the short form for four 2's multiplied is 2⁴."),
    ("8²","8² means 8 × 8 = 64; four 2's multiplied is 2⁴, not 8².")]),

 ("EX","Worked out fully as a repeated product, the power 2⁵ has the value:",
   "32",
   C("2⁵ means five 2's multiplied together; doubling step by step reaches 32.")+
   steps("2 × 2 = 4","4 × 2 = 8, then 8 × 2 = 16","16 × 2 = 32, so 2⁵ = 32."),
   [("10","10 is 2 × 5 (adding the idea up wrongly); 2⁵ means MULTIPLYING five 2's, which is 32."),
    ("25","25 is 5²; here the base is 2 and the exponent 5, giving 32."),
    ("16","16 is 2⁴ (four 2's); one more 2 makes 2⁵ = 32.")]),

 ("EX","The value of 10³ is:",
   "1000",
   C("Each power of ten adds one zero; 10³ means 10 × 10 × 10.")+
   steps("10 × 10 = 100","100 × 10 = 1000","so 10³ = 1000 (1 with three zeros)."),
   [("30","30 is 10 × 3 (adding the idea up wrongly); 10³ means multiplying three 10's, which is 1000."),
    ("300","300 is 100 × 3; three 10's MULTIPLIED gives 1000."),
    ("100","100 is 10² (two 10's); one more 10 makes 10³ = 1000.")]),

 ("EX","Any non-zero number raised to the power 0 equals:",
   "1",
   C("By the rules of exponents, anything (except 0) to the power 0 is defined to be 1.")+
   steps("Note that aᵐ ÷ aᵐ = 1 for any non-zero a","by the division rule this is aᵐ⁻ᵐ = a⁰","so a⁰ must equal 1."),
   [("0","Zero would break the division rule; a⁰ is defined as 1, not 0."),
    ("the number itself","a¹ equals the number itself; a⁰ equals 1."),
    ("10","The answer is always 1, whatever the base; it is not 10.")]),

 ("EX","Using the rule aᵐ × aⁿ = aᵐ⁺ⁿ, the product 3² × 3⁴ equals:",
   "3⁶",
   C("When the bases are the same, multiplying powers means ADDING the exponents.")+
   steps("Same base 3, so add the exponents","2 + 4 = 6","therefore 3² × 3⁴ = 3⁶."),
   [("3⁸","3⁸ would mean 2 × 4; the rule ADDS the exponents (2 + 4 = 6), giving 3⁶."),
    ("9⁶","The base stays 3, not 9; multiplying the bases is wrong. The answer is 3⁶."),
    ("3²","3² ignores the second power; you must add the exponents to get 3⁶.")]),

 ("EX","Using aᵐ ÷ aⁿ = aᵐ⁻ⁿ, the quotient 5⁷ ÷ 5⁴ equals:",
   "5³",
   C("When the bases are the same, dividing powers means SUBTRACTING the exponents.")+
   steps("Same base 5, so subtract the exponents","7 − 4 = 3","therefore 5⁷ ÷ 5⁴ = 5³."),
   [("5¹¹","5¹¹ would mean 7 + 4; division SUBTRACTS the exponents (7 − 4 = 3), giving 5³."),
    ("5²","Subtracting carefully gives 7 − 4 = 3, not 2; the answer is 5³."),
    ("1³","The base stays 5, not 1; 5⁷ ÷ 5⁴ = 5³.")]),

 ("EX","Using (aᵐ)ⁿ = aᵐⁿ, the value of (2³)² equals:",
   "2⁶",
   C("A power raised to another power means MULTIPLYING the exponents.")+
   steps("(2³)² means 2³ multiplied by itself","multiply the exponents: 3 × 2 = 6","therefore (2³)² = 2⁶."),
   [("2⁵","2⁵ would mean 3 + 2; raising a power to a power MULTIPLIES the exponents (3 × 2 = 6)."),
    ("2⁹","2⁹ would mean 3², but you multiply 3 × 2 = 6, giving 2⁶."),
    ("4³","The base stays 2, not 4; (2³)² = 2⁶.")]),

 ("EX","The value of (−1) raised to any even power is:",
   "1",
   C("Multiplying −1 by itself an even number of times pairs up the minus signs, and each pair makes a plus.")+
   steps("(−1) × (−1) = +1","an even power groups all the −1's into such pairs","every pair gives +1, so the result is 1."),
   [("−1","−1 is the result of an ODD power; an even power gives +1."),
    ("0","Multiplying −1's never gives 0; an even power gives +1."),
    ("2","The factors are all −1, so the size stays 1; an even power gives +1, not 2.")]),

 ("EX","The value of (−1) raised to any odd power is:",
   "−1",
   C("With an odd number of −1's, the minus signs pair up but one is always left over, leaving a minus.")+
   steps("Pairs of (−1) × (−1) give +1","an odd power leaves one extra −1 unpaired","so the final result is −1."),
   [("1","+1 comes from an EVEN power; an odd power leaves a leftover minus, giving −1."),
    ("0","Multiplying −1's never gives 0; an odd power gives −1."),
    ("−2","The size stays 1, only the sign is negative; an odd power gives −1, not −2.")]),

 ("EX","Which is greater, 2⁴ or 4²?",
   "they are equal",
   C("Work each out: 2⁴ = 16 and 4² = 16 — they happen to be the same value.")+
   steps("2⁴ = 2 × 2 × 2 × 2 = 16","4² = 4 × 4 = 16","both equal 16, so they are equal."),
   [("2⁴ is greater","Both work out to 16, so neither is greater — they are equal."),
    ("4² is greater","Both work out to 16, so neither is greater — they are equal."),
    ("neither can be compared","They are ordinary numbers and both equal 16, so they can be compared and are equal.")]),

 ("EX","Written using exponents, the prime factorisation of 72 is:",
   "2³ × 3²",
   C("Break 72 into prime factors and count how many of each: 72 = 8 × 9 = (2×2×2) × (3×3).")+
   steps("72 = 8 × 9","8 = 2 × 2 × 2 = 2³ and 9 = 3 × 3 = 3²","so 72 = 2³ × 3²."),
   [("2² × 3³","2² × 3³ = 4 × 27 = 108, not 72; the correct count is 2³ × 3²."),
    ("2³ × 3³","2³ × 3³ = 8 × 27 = 216, not 72; you need only two 3's, giving 2³ × 3²."),
    ("2⁴ × 3","2⁴ × 3 = 16 × 3 = 48, not 72; the correct factorisation is 2³ × 3².")]),

 ("EX","The number 8 written as a power of 2 is:",
   "2³",
   C("Ask how many 2's multiply to give 8: 2 × 2 × 2 = 8, which is three of them.")+
   steps("2 × 2 = 4","4 × 2 = 8","that is three 2's, so 8 = 2³."),
   [("2⁴","2⁴ = 16, not 8; three 2's give 8 = 2³."),
    ("3²","3² = 9, not 8; and the base should be 2, giving 2³."),
    ("2²","2² = 4, not 8; you need one more 2, so 8 = 2³.")]),

 ("EX","In standard (scientific) form, the number 47000 is written as:",
   "4.7 × 10⁴",
   C("Standard form puts exactly one non-zero digit before the decimal point, times a power of ten.")+
   steps("Move the point so one digit stays in front: 4.7","count the places moved: four","so 47000 = 4.7 × 10⁴."),
   [("47 × 10³","Standard form needs ONE digit before the point; 47 has two, so write 4.7 × 10⁴."),
    ("4.7 × 10³","4.7 × 10³ = 4700, ten times too small; the correct power is 10⁴."),
    ("0.47 × 10⁵","Standard form needs a digit 1–9 before the point, not 0.47; the answer is 4.7 × 10⁴.")]),

 ("EX","Written as an ordinary number, 6.3 × 10² is:",
   "630",
   C("Multiplying by 10² moves the decimal point two places to the right.")+
   steps("10² = 100","6.3 × 100 = 630","so 6.3 × 10² = 630."),
   [("63","63 is 6.3 × 10 (one place); the power is 10², which moves two places to 630."),
    ("6300","6300 is 6.3 × 10³ (three places); 10² moves only two places, giving 630."),
    ("6.300","Adding zeros after the point keeps the value 6.3; multiplying by 100 gives 630.")]),

 ("EX","A cyclone's wind blows at about 2 × 10² km/h. In ordinary numbers that speed is:",
   "200 km/h",
   C("This is standard form in real life: 10² = 100, so 2 × 100 = 200.")+
   steps("10² means 100","2 × 100 = 200","so the wind speed is 200 km/h."),
   [("20 km/h","20 would be 2 × 10¹; here the power is 10² = 100, giving 200 km/h."),
    ("2000 km/h","2000 would be 2 × 10³; the power is 10², giving 200 km/h."),
    ("22 km/h","2 × 10² is multiplication, not 2 and 2 side by side; it equals 200 km/h.")]),

 ("EX","One million (1 followed by six zeros) written as a power of ten is:",
   "10⁶",
   C("The exponent on 10 equals the number of zeros after the 1.")+
   steps("Count the zeros in 1 000 000: there are six","each zero is one factor of 10","so one million = 10⁶."),
   [("10⁵","10⁵ = 100000 (five zeros) — that is one hundred thousand; a million is 10⁶."),
    ("6¹⁰","The base is 10 and the exponent counts the zeros; one million is 10⁶, not 6¹⁰."),
    ("10⁷","10⁷ = 10000000 (seven zeros) — ten million; a million is 10⁶.")]),

 ("EX","Multiplying four 3's together, the power 3⁴ comes to:",
   "81",
   C("3⁴ means four 3's multiplied together.")+
   steps("3 × 3 = 9","9 × 3 = 27","27 × 3 = 81, so 3⁴ = 81."),
   [("12","12 is 3 × 4 (adding the idea up wrongly); 3⁴ means multiplying four 3's, giving 81."),
    ("64","64 is 4³, a different power; 3⁴ = 81."),
    ("27","27 is 3³ (three 3's); one more 3 makes 3⁴ = 81.")]),

 ("EX","Using laws of exponents, 2³ × 5³ can be written as a single power:",
   "(2 × 5)³",
   C("When two powers share the SAME exponent, you can multiply the bases and keep the exponent: aᵐ × bᵐ = (ab)ᵐ.")+
   steps("Both powers have exponent 3","multiply the bases: 2 × 5 = 10","keep the exponent: (2 × 5)³ = 10³."),
   [("10⁹","10⁹ would multiply the exponents; the rule keeps the exponent, giving (2 × 5)³ = 10³."),
    ("2⁶ × 5⁶","The exponents are not added or doubled; with equal exponents you combine the bases as (2 × 5)³."),
    ("7³","The bases are MULTIPLIED, not added (2 × 5 = 10, not 7); the answer is (2 × 5)³ = 10³.")]),

 ("EX","The phrase 'four to the power three' means:",
   "4 × 4 × 4",
   C("'To the power three' means use the number 4 as a factor three times.")+
   steps("The base is 4, the exponent is 3","write 4 as a factor three times","that is 4 × 4 × 4 = 64."),
   [("4 × 3","4 × 3 = 12 is simple multiplication; the power means 4 × 4 × 4."),
    ("3 × 3 × 3 × 3","That is 'three to the power four'; here the base is 4, so 4 × 4 × 4."),
    ("4 + 4 + 4","Adding gives 12; a power means MULTIPLYING: 4 × 4 × 4.")]),

 ("EX","Using the division rule, 10⁴ ÷ 10² equals:",
   "10²",
   C("Same base, so dividing means subtracting the exponents.")+
   steps("Same base 10, subtract exponents","4 − 2 = 2","so 10⁴ ÷ 10² = 10²."),
   [("10⁶","10⁶ would ADD the exponents; division SUBTRACTS them (4 − 2 = 2), giving 10²."),
    ("10⁸","10⁸ would multiply the exponents; division subtracts, giving 10²."),
    ("1²","The base stays 10, not 1; 10⁴ ÷ 10² = 10².")]),

 ("EX","The value of 1 raised to the power 100 is:",
   "1",
   C("Multiplying 1 by itself any number of times always stays 1.")+
   steps("1 × 1 = 1","multiplying by 1 never changes the value","so 1¹⁰⁰ = 1."),
   [("100","The exponent does not multiply into the answer; 1 to any power is 1, not 100."),
    ("0","Multiplying 1's never gives 0; 1¹⁰⁰ = 1."),
    ("10","No matter the power, 1 stays 1; the answer is not 10.")]),

 ("EX","A treatment tank cleans 10³ litres of water each hour. In 10 hours, written as a power of ten, it cleans ___ litres.",
   "10⁴",
   C("Multiplying a power of ten by another ten adds one to the exponent: 10³ × 10 = 10⁴.")+
   steps("Each hour it cleans 10³ litres","over 10 hours: 10³ × 10","add the exponents (3 + 1) to get 10⁴ litres."),
   [("10²","10² is fewer litres than one hour's work; 10 hours gives 10³ × 10 = 10⁴."),
    ("10³⁰","The exponents are added (3 + 1 = 4), not multiplied; the answer is 10⁴."),
    ("10¹³","You add the small exponents, not the whole numbers; 10³ × 10¹ = 10⁴.")]),

 ("EX","Which of these has the greatest value: 2⁵, 4², 3², or 5?",
   "2⁵",
   C("Work each out and compare: 2⁵ = 32, 4² = 16, 3² = 9, and 5 is just 5.")+
   steps("2⁵ = 32, the biggest","4² = 16 and 3² = 9 are smaller","5 is smallest, so 2⁵ is the greatest."),
   [("4²","4² = 16, which is less than 2⁵ = 32."),
    ("3²","3² = 9, far smaller than 2⁵ = 32."),
    ("5","5 is the smallest value here; 2⁵ = 32 is the greatest.")]),
]

EX_UC = [
 "Naming the exponent correctly is how you read powers in science, like 'ten to the six'.",
 "Spotting the base is the first step in breaking any big number into its building blocks.",
 "Short powers like 2⁴ save you from writing long multiplication chains in physics.",
 "Computing 2⁵ is the maths behind doubling — like a folded paper or a spreading rumour.",
 "Powers of ten are how money, distances and populations get written compactly.",
 "The a⁰ = 1 rule keeps exponent calculations consistent in every science formula.",
 "Adding exponents is the shortcut that makes multiplying big powers quick and error-free.",
 "Subtracting exponents is how scientists simplify ratios of huge or tiny quantities.",
 "Multiplying exponents is the rule behind areas of squares and volumes of cubes.",
 "Knowing even powers of −1 give +1 keeps your signs right in algebra.",
 "Knowing odd powers of −1 give −1 stops a classic sign slip in calculations.",
 "Comparing 2⁴ and 4² trains you to never assume two powers differ until you check.",
 "Prime factorisation with exponents is how you find HCF, LCM and simplify roots.",
 "Writing 8 as 2³ is the kind of step that simplifies fractions and surds later.",
 "Standard form is how a textbook writes the Sun's distance without a line of zeros.",
 "Converting back from standard form is how you read a scientific measurement in full.",
 "A cyclone's '2 × 10² km/h' in the news is standard form doing a real job.",
 "Writing a million as 10⁶ is how budgets and populations fit neatly on a page.",
 "Computing 3⁴ is the same growth maths behind branching trees and family charts.",
 "The (ab)ᵐ rule is how 2³ × 5³ collapses neatly into the round number 10³.",
 "Reading 'four to the power three' correctly stops you confusing 4³ with 4 × 3.",
 "Dividing powers of ten is how you rescale between metres, kilometres and millimetres.",
 "Knowing 1 to any power is 1 is a quick sanity check inside a longer calculation.",
 "Scaling a tank's 10³ L/hour to 10⁴ L is real engineering done with one exponent.",
 "Picking the greatest of several powers is how you compare growth rates at a glance.",
]

# ---------- WASTEWATER STORY (25) — Science ----------
WW = [
 ("WW","The used, dirty water released from homes, factories and farms is called:",
   "wastewater",
   C("All the water we have dirtied — from washing, toilets, kitchens and industry — is collectively called wastewater.")+
   steps("We use clean water for many tasks","this leaves the water dirty and used","all such used dirty water is wastewater."),
   [("rainwater","Rainwater is fresh water falling from clouds; the used dirty water from our taps is wastewater."),
    ("spring water","Spring water is naturally clean water from the ground; wastewater is the dirty used water."),
    ("distilled water","Distilled water is specially purified; wastewater is the dirty water we throw out.")]),

 ("WW","Wastewater that carries human waste and dirt away from homes through pipes is also called:",
   "sewage",
   C("The dirty water flushed and washed away through drainpipes, full of human and household waste, is called sewage.")+
   steps("Toilets and sinks send dirty water into pipes","this water carries human and household waste","that waste-laden water is called sewage."),
   [("nectar","Nectar is the sweet liquid in flowers; the dirty waste water in drains is sewage."),
    ("groundwater","Groundwater is clean water stored under the soil; the dirty drain water is sewage."),
    ("dew","Dew is clean water droplets that form at night; the dirty drain water is sewage.")]),

 ("WW","The harmful substances dissolved or floating in sewage are called:",
   "contaminants",
   C("Sewage carries many unwanted, often harmful materials — germs, chemicals and dirt — together called contaminants.")+
   steps("Sewage is not pure water","it carries germs, chemicals and waste matter","these unwanted harmful substances are the contaminants."),
   [("nutrients only","Some nutrients are present, but the harmful germs and chemicals make them contaminants overall."),
    ("minerals we drink","Drinking water has helpful minerals; the harmful stuff in sewage is contaminants."),
    ("perfumes","Perfumes are pleasant added scents; the harmful matter in sewage is contaminants.")]),

 ("WW","The network of large underground pipes that carries sewage away from a town is the:",
   "sewerage (sewer system)",
   C("Beneath the streets runs a system of big pipes — the sewerage — that carries all the town's sewage to treatment.")+
   steps("Drains from every house join up underground","they feed into larger and larger pipes","this whole pipe network is the sewerage system."),
   [("canopy","A canopy is the leafy top layer of a forest, nothing to do with carrying sewage."),
    ("circuit","A circuit is a closed path for electric current; sewage is carried by the sewerage."),
    ("pipeline for drinking water","Clean-water pipelines are kept separate; sewage travels through the sewerage system.")]),

 ("WW","Sewage is cleaned before it is released back into a river at a:",
   "sewage (wastewater) treatment plant",
   C("Dirty water is not poured straight into rivers; it is first cleaned at a wastewater treatment plant.")+
   steps("Sewage from the town is collected","it passes through cleaning stages at a special facility","that facility is the sewage treatment plant."),
   [("power plant","A power plant makes electricity; sewage is cleaned at a treatment plant."),
    ("fruit-juice factory","A juice factory makes drinks; dirty water is cleaned at a treatment plant."),
    ("weather station","A weather station studies the sky; sewage is cleaned at a treatment plant.")]),

 ("WW","At the treatment plant, sewage is first passed through a bar screen to remove:",
   "large floating objects like rags and sticks",
   C("The very first step is a grille of bars that catches big floating junk before it can clog the works.")+
   steps("Sewage carries rags, sticks and plastic","it flows through a screen of metal bars","the bars catch the large floating objects."),
   [("dissolved salts","Dissolved salts pass straight through bars; the screen catches big floating solids."),
    ("germs and bacteria","Germs are far too small for bars; they are dealt with later, not at the screen."),
    ("the smell only","A bar screen removes solid objects, not the smell; that is handled in later stages.")]),

 ("WW","After the bar screen, the water is allowed to flow slowly so that heavy:",
   "sand and grit settle to the bottom",
   C("Slowing the water lets dense particles like sand and grit sink out before the finer cleaning begins.")+
   steps("Water flows slowly through a grit tank","heavy sand and grit are denser than water","so they sink and settle at the bottom."),
   [("oil rises and is bottled","Oil does float, but it is skimmed off, not bottled; the grit tank settles sand."),
    ("germs multiply faster","Slow flow does not breed germs on purpose; it lets sand and grit settle."),
    ("rags float to the top","Rags were already caught by the bar screen; this step settles sand and grit.")]),

 ("WW","In the settling tank, the solids that sink to the bottom form a thick mass called:",
   "sludge",
   C("As fine solids settle out, they pile up at the bottom of the tank as a thick, semi-solid layer called sludge.")+
   steps("Tiny solids slowly sink in the still tank","they collect at the bottom","this thick settled mass is sludge."),
   [("clear water","Clear water is the cleaner liquid on TOP; the thick settled solids are sludge."),
    ("biogas","Biogas is a gas made later from the sludge, not the settled solids themselves."),
    ("chlorine","Chlorine is a chemical added at the end to kill germs, not the settled solids.")]),

 ("WW","The clearer water from the top of the settling tank is sent on, and air is bubbled through it to grow helpful:",
   "aerobic bacteria",
   C("Bubbling air feeds oxygen-loving (aerobic) bacteria that eat up the remaining dissolved waste.")+
   steps("The cleared water still holds dissolved waste","air is bubbled through to supply oxygen","oxygen-loving bacteria grow and feed on the waste."),
   [("fish","Fish are not grown in treatment tanks; oxygen feeds helpful aerobic bacteria."),
    ("algae we eat","No food algae are farmed here; the air grows waste-eating aerobic bacteria."),
    ("salt crystals","Bubbling air does not make salt; it grows waste-eating aerobic bacteria.")]),

 ("WW","Air is bubbled into the tank mainly to help the bacteria that need:",
   "oxygen to break down waste",
   C("These helpful microbes are aerobic — they must have oxygen to digest and break down the waste in the water.")+
   steps("The cleaning bacteria are aerobic","aerobic means they require oxygen","bubbling air supplies that oxygen so they break down the waste."),
   [("salt to grow","The bacteria need oxygen, not salt, to do their cleaning work."),
    ("darkness to hide","These bacteria need oxygen to work, not darkness; air is bubbled in for them."),
    ("plastic to feed on","They feed on the dissolved waste using oxygen, not on plastic.")]),

 ("WW","The aerobic bacteria use oxygen to feed on and break down the:",
   "human waste and other dirt in the water",
   C("The microbes treat the dissolved and suspended waste as food, breaking it down and cleaning the water.")+
   steps("The water still carries dissolved waste","the bacteria use oxygen to digest it","this breaks down the waste and cleans the water."),
   [("metal pipes","Bacteria do not eat the pipes; they break down the waste in the water."),
    ("the concrete tank","The tank is not food; the bacteria break down the waste in the water."),
    ("the clean treated water","Clean water is the goal, not the food; bacteria break down the waste matter.")]),

 ("WW","Once settled and dried, the sludge can be put to good use as:",
   "manure for fields",
   C("Dried sludge is rich in nutrients, so instead of being dumped it can be spread on fields as manure.")+
   steps("The settled sludge holds plant nutrients","it is dried and treated to be safe","then it is used as manure for crops."),
   [("drinking water","Sludge is the dirty solid part — never drinking water; dried, it becomes manure."),
    ("cooking oil","Sludge is not edible oil; dried and treated it serves as manure."),
    ("window glass","Sludge is not made into glass; it is dried for use as manure.")]),

 ("WW","Sludge left to decompose without air produces a useful gas called:",
   "biogas",
   C("In the absence of oxygen, microbes break sludge down and release biogas, which can be burnt as fuel.")+
   steps("Sludge is sealed away from air","microbes break it down without oxygen","this produces biogas, a usable fuel."),
   [("oxygen","Oxygen is used UP in the tank, not produced; decomposing sludge gives off biogas."),
    ("helium","Helium is a light gas from rocks and stars, not from sludge; sludge gives biogas."),
    ("chlorine","Chlorine is a chemical added to kill germs, not a gas made by sludge; that is biogas.")]),

 ("WW","Before the treated water is released into a river, it is often disinfected with:",
   "chlorine",
   C("A final dose of chlorine kills the germs that survived the earlier steps, making the water safer to release.")+
   steps("Even treated water can carry some germs","chlorine is added as a disinfectant","it kills the germs before the water is released."),
   [("sugar","Sugar feeds germs rather than killing them; chlorine is used to disinfect."),
    ("sand","Sand can filter solids but does not kill germs; chlorine disinfects the water."),
    ("petrol","Petrol is a fuel and a pollutant; the safe disinfectant used is chlorine.")]),

 ("WW","Pouring cooking oil and fat down the kitchen drain is harmful mainly because it:",
   "blocks the drains and pipes",
   C("Fats cool and harden inside pipes, sticking to the walls and choking the flow until the drain blocks.")+
   steps("Warm oil flows easily but cools in the pipe","cooled fat sticks and builds up on the walls","over time it blocks the drain completely."),
   [("cleans the pipes","Oil does the opposite of cleaning — it coats and clogs the pipes."),
    ("makes the water drinkable","Oil makes water dirtier, not drinkable; in pipes it causes blockages."),
    ("turns into biogas instantly","Oil does not instantly become biogas; in the drain it hardens and blocks pipes.")]),

 ("WW","Used tea leaves, cotton and other solids should go in the dustbin, not the drain, because they:",
   "choke the drains",
   C("Solid bits do not dissolve; they pile up and trap other waste until the drain is choked.")+
   steps("Solids like tea leaves do not dissolve","they collect at bends in the pipe","they trap more waste and choke the drain."),
   [("feed the river fish","Throwing solids in drains harms waterways; in pipes they choke the drains."),
    ("purify the water","Solids dirty the water, not purify it; in drains they cause blockages."),
    ("make chlorine","Tea leaves do not make chlorine; in drains they simply choke the pipes.")]),

 ("WW","Open drains and stagnant pools of sewage are dangerous because they breed:",
   "disease-causing flies and mosquitoes",
   C("Standing dirty water is a perfect nursery for flies and mosquitoes, which then spread disease.")+
   steps("Sewage left in the open does not flow away","flies and mosquitoes lay eggs in the still dirty water","these insects spread diseases to people."),
   [("useful honeybees","Bees visit flowers, not sewage; stagnant sewage breeds disease-spreading flies and mosquitoes."),
    ("fresh drinking water","Open sewage is the opposite of fresh water; it breeds disease-carrying insects."),
    ("clean air","Stagnant sewage smells foul and breeds insects; it does not make clean air.")]),

 ("WW","A simple, low-cost on-site pit that treats waste where there are no sewer pipes is a:",
   "septic tank",
   C("Where a town sewer is unavailable, a septic tank quietly settles and partly digests the waste underground.")+
   steps("Some homes have no connection to a sewer","they use an underground sealed tank","the waste settles and is partly digested there — a septic tank."),
   [("transformer","A transformer changes electric voltage, nothing to do with sewage; that is a septic tank."),
    ("water cooler","A water cooler chills drinking water; on-site waste is treated in a septic tank."),
    ("wind tunnel","A wind tunnel tests airflow; on-site sewage is handled by a septic tank.")]),

 ("WW","A toilet that turns human waste into manure using worms, with no sewer connection, is a:",
   "vermi-processing (composting) toilet",
   C("A vermi-processing toilet uses worms to convert waste into useful compost right where it is produced.")+
   steps("Waste falls into a chamber, not a sewer","worms break it down into compost","this low-water, no-sewer system is a vermi-processing toilet."),
   [("flush-only city toilet","A flush toilet sends waste into the sewer; a worm-based one is a vermi-processing toilet."),
    ("rainwater tank","A rainwater tank stores rain, not human waste; the worm toilet is vermi-processing."),
    ("biogas cylinder","A biogas cylinder stores gas; the worm-based toilet is a vermi-processing toilet.")]),

 ("WW","Keeping ourselves and our surroundings clean and disposing of waste safely is together called:",
   "sanitation",
   C("Sanitation covers everything to do with clean living conditions — safe toilets, clean surroundings and proper waste disposal.")+
   steps("Disease spreads through dirt and waste","keeping clean and disposing of waste safely prevents it","this whole practice is called sanitation."),
   [("irrigation","Irrigation is supplying water to crops, not waste disposal; clean living is sanitation."),
    ("transportation","Transportation is moving people and goods; safe waste disposal is sanitation."),
    ("germination","Germination is a seed sprouting; clean, safe waste handling is sanitation.")]),

 ("WW","Poor sanitation and untreated sewage spread water-borne illnesses such as:",
   "cholera and typhoid",
   C("Dirty water carries germs that cause stomach-and-gut diseases like cholera and typhoid.")+
   steps("Untreated sewage mixes with drinking water","it carries germs into people who drink it","these germs cause diseases such as cholera and typhoid."),
   [("broken bones","Broken bones come from injuries, not dirty water; cholera and typhoid are water-borne."),
    ("colour blindness","Colour blindness is inherited, not caught from water; the water-borne illnesses are cholera and typhoid."),
    ("short-sightedness","Short-sightedness is an eye-focus problem, not a water-borne disease like cholera or typhoid.")]),

 ("WW","A worker who must enter a sewer or manhole should always:",
   "wear safety gear and check for poisonous gases first",
   C("Sewers can hold deadly gases and little oxygen, so safety gear and a gas check come before anyone goes in.")+
   steps("Sewers may contain poisonous, low-oxygen air","this can knock a person out within seconds","so wear protective gear and test the air before entering."),
   [("go in alone without telling anyone","Going in alone is extremely dangerous; never enter without gear, a check and helpers."),
    ("carry an open flame inside","Sewer gases can catch fire or explode; never take an open flame inside."),
    ("remove all protective gear","Removing gear exposes the worker to poisonous gas; gear must be WORN, not removed.")]),

 ("WW","Treated water should be released into a river only after the harmful germs in it are:",
   "destroyed",
   C("Releasing germ-filled water would spread disease, so the germs must be killed before the water rejoins a river.")+
   steps("Treated water may still carry living germs","these would pollute the river and sicken people","so the germs are destroyed (disinfected) before release."),
   [("multiplied","Letting germs multiply would make the water more dangerous; they must be destroyed."),
    ("frozen","Freezing does not reliably kill germs and is impractical here; they are destroyed by disinfecting."),
    ("bottled for sale","Germs are harmful and never bottled; they are destroyed before the water is released.")]),

 ("WW","Pouring untreated factory chemicals into a drain is a problem because they:",
   "poison the water and the bacteria that clean it",
   C("Harsh chemicals not only pollute the water but also kill the helpful bacteria the treatment plant relies on.")+
   steps("Factory chemicals can be toxic","they poison the water and the helpful cleaning bacteria","so the treatment process itself is harmed."),
   [("make the water sweeter","Chemicals make the water more toxic, not sweeter, and harm the cleaning bacteria."),
    ("speed up safe cleaning","Toxic chemicals kill the cleaning bacteria, slowing or stopping safe treatment."),
    ("turn into clean rain","Chemicals in drains do not become clean rain; they poison the water and the bacteria.")]),

 ("WW","If everyone reduces the waste they pour down drains, the load on a treatment plant becomes:",
   "smaller and easier to clean",
   C("Less waste going in means less for the plant to remove, so the water is cleaned faster and more cheaply.")+
   steps("Each person's waste adds to the plant's load","reducing waste at home lowers the total","so the plant has less to clean and works better."),
   [("larger and dirtier","Reducing waste LOWERS the load; it does not make it larger and dirtier."),
    ("exactly the same forever","Less waste in clearly changes the load; it gets smaller, not unchanged."),
    ("frozen solid","Reducing waste does not freeze anything; it simply makes the load smaller and easier to clean.")]),
]

WW_UC = [
 "Calling dirty water 'wastewater' is the first step to understanding why it must be cleaned.",
 "Knowing what sewage is helps you see why open drains near homes are a health risk.",
 "Spotting contaminants is why a lab tests river water before it is called safe.",
 "Understanding the sewerage is why cities dig deep pipe networks under every street.",
 "Knowing about treatment plants is why a city's river can stay clean despite millions of people.",
 "The bar-screen idea is why you should never flush rags or plastic down a toilet.",
 "Settling grit is the same idea as letting muddy water clear in a bucket before use.",
 "Recognising sludge explains what the thick layer at the bottom of a settling tank is.",
 "Knowing aerobic bacteria clean water shows nature itself doing the hard work for us.",
 "Understanding why air is bubbled in explains the churning tanks you see at a treatment plant.",
 "Seeing bacteria as waste-eaters is why a healthy treatment plant is a living system.",
 "Turning sludge into manure is recycling that returns nutrients to farmers' fields.",
 "Making biogas from sludge turns a waste problem into cooking and lighting fuel.",
 "Chlorinating water is the same step that keeps swimming pools and tap water germ-free.",
 "Not pouring oil down the sink is a daily habit that keeps your home's drains flowing.",
 "Binning solids instead of flushing them is why kitchens keep a separate waste bin.",
 "Knowing stagnant sewage breeds mosquitoes is why we clear puddles in the rainy season.",
 "Understanding septic tanks explains how village homes manage waste without city sewers.",
 "Knowing about composting toilets shows how dry, low-water sanitation works off the grid.",
 "Understanding sanitation is why hand-washing and clean toilets prevent so many illnesses.",
 "Linking dirty water to cholera is why boiling or filtering water saves lives in a flood.",
 "Knowing sewer-safety rules is why municipal workers must never enter manholes unprepared.",
 "Destroying germs before release is the rule that keeps a treated river safe to bathe in.",
 "Knowing chemicals harm the cleaning bacteria is why factories must treat their own waste first.",
 "Reducing what you pour down the drain is a simple personal act that helps a whole city's water.",
]

# ---------- LINES & ANGLES (25) — Maths ----------
LA = [
 ("LA","When the measures of two angles total exactly 90°, the pair is described as:",
   "complementary angles",
   C("A right angle is 90°; two angles that together make a right angle are called complementary.")+
   steps("Take any two angles","if their measures add to 90°","they are complementary angles."),
   [("supplementary angles","Supplementary angles add to 180°, not 90°; the 90° pair is complementary."),
    ("vertically opposite angles","Vertically opposite angles are simply equal; the 90°-sum pair is complementary."),
    ("reflex angles","A reflex angle is a single angle over 180°, not a pair summing to 90°.")]),

 ("LA","When the measures of two angles total exactly 180°, the pair is described as:",
   "supplementary angles",
   C("A straight angle is 180°; two angles that together make a straight angle are called supplementary.")+
   steps("Take any two angles","if their measures add to 180°","they are supplementary angles."),
   [("complementary angles","Complementary angles add to 90°, not 180°; the 180° pair is supplementary."),
    ("corresponding angles","Corresponding angles sit in matching corners at a transversal; the 180°-sum pair is supplementary."),
    ("acute angles","'Acute' describes one angle under 90°, not a pair adding to 180°.")]),

 ("LA","For a 30° angle, the angle that completes it to a right angle (its complement) is:",
   "60°",
   C("Complementary angles add to 90°, so the complement is 90° minus the given angle.")+
   steps("Complement means it pairs to 90°","90° − 30° = 60°","so the complement of 30° is 60°."),
   [("150°","150° is the SUPPLEMENT (180° − 30°); the complement uses 90°, giving 60°."),
    ("330°","330° comes from 360° − 30°, not a complement; 90° − 30° = 60°."),
    ("70°","70° would need a sum of 100°; complements add to 90°, so 90° − 30° = 60°.")]),

 ("LA","For a 110° angle, the angle that completes it to a straight line (its supplement) is:",
   "70°",
   C("Supplementary angles add to 180°, so the supplement is 180° minus the given angle.")+
   steps("Supplement means it pairs to 180°","180° − 110° = 70°","so the supplement of 110° is 70°."),
   [("20°","20° comes from 90° − 70° or a complement idea; the supplement is 180° − 110° = 70°."),
    ("250°","250° comes from adding instead of subtracting; supplements use 180° − 110° = 70°."),
    ("90°","90° would need the angles to be 110° and 90°, summing to 200°; the supplement is 70°.")]),

 ("LA","Sharing one vertex and one common arm while sitting on opposite sides of that arm, two such angles are called:",
   "adjacent angles",
   C("When two angles sit right next to each other, sharing a vertex and one arm, they are adjacent.")+
   steps("Both angles meet at the same corner (vertex)","they share one common arm","and lie on opposite sides of it — so they are adjacent."),
   [("vertically opposite angles","Vertically opposite angles are across a crossing point, not side by side sharing an arm."),
    ("complementary angles","Complementary is about adding to 90°, not about sharing a vertex and arm."),
    ("alternate angles","Alternate angles lie on opposite sides of a transversal, not side by side sharing an arm.")]),

 ("LA","When two straight lines cross, the two angles directly opposite each other at the crossing point are:",
   "equal (vertically opposite)",
   C("Crossing lines make two pairs of angles facing each other across the point; each facing pair is equal.")+
   steps("Two lines cross at a point","the angles directly across from each other are vertically opposite","such vertically opposite angles are always equal."),
   [("always 90° each","They are only 90° if the lines are perpendicular; in general they are simply equal to each other."),
    ("supplementary to each other","Opposite angles are equal; it is the ADJACENT pair on a line that is supplementary."),
    ("always different","Vertically opposite angles are always equal, never different.")]),

 ("LA","Two adjacent angles formed on one side of a straight line add up to:",
   "180°",
   C("Angles on a straight line make a linear pair, and a straight line is a 180° (straight) angle.")+
   steps("A straight line forms a straight angle of 180°","two adjacent angles split that straight angle","so together they add up to 180°."),
   [("90°","90° is a right angle; angles forming a straight line add to 180°."),
    ("360°","360° is a full turn; angles on a straight line add to half of that, 180°."),
    ("45°","45° is far too small; a straight line is 180°, so the pair adds to 180°.")]),

 ("LA","If a linear pair has one angle of 125°, the other angle is:",
   "55°",
   C("A linear pair adds to 180°, so subtract the known angle from 180°.")+
   steps("Linear pair means the two add to 180°","180° − 125° = 55°","so the other angle is 55°."),
   [("65°","65° would need a sum of 190°; a linear pair adds to 180°, giving 55°."),
    ("235°","235° comes from adding instead of subtracting; 180° − 125° = 55°."),
    ("35°","35° would make the sum 160°; the correct subtraction 180° − 125° = 55°.")]),

 ("LA","Two lines in the same plane that never meet, no matter how far they are extended, are:",
   "parallel lines",
   C("Lines that keep an equal distance apart forever and never cross are called parallel.")+
   steps("Draw two lines that stay the same distance apart","extend them as far as you like","they never meet — so they are parallel."),
   [("intersecting lines","Intersecting lines DO meet at a point; parallel lines never meet."),
    ("perpendicular lines","Perpendicular lines meet at 90°; parallel lines never meet at all."),
    ("curved lines","Parallel lines are straight; curved lines are a different thing entirely.")]),

 ("LA","Two lines that cross to make a right angle (90°) are said to be:",
   "perpendicular",
   C("When two lines meet so that the angle between them is exactly 90°, they are perpendicular.")+
   steps("Two lines cross at a point","the angle between them is exactly 90°","such lines are called perpendicular."),
   [("parallel","Parallel lines never meet; perpendicular lines meet at a right angle."),
    ("curved","Perpendicular refers to straight lines meeting at 90°, not to curves."),
    ("vertically opposite","'Vertically opposite' names a pair of equal angles, not two lines meeting at 90°.")]),

 ("LA","A line that cuts across two or more other lines is called a:",
   "transversal",
   C("A transversal is a line that crosses two or more lines, creating sets of angles at each crossing.")+
   steps("Draw two lines","draw a third line cutting across both","that crossing line is the transversal."),
   [("parallel","A parallel line runs alongside without crossing; a crossing line is a transversal."),
    ("radius","A radius is a line from a circle's centre to its edge, not a line cutting across others."),
    ("diagonal of a circle","A circle has no diagonal; the line cutting across two lines is a transversal.")]),

 ("LA","Where a transversal cuts a pair of parallel lines, every set of corresponding angles turns out to be:",
   "equal",
   C("Corresponding angles sit in the same position at each crossing; with parallel lines they are equal.")+
   steps("A transversal makes matching 'corner' angles at each line","with the lines parallel these positions match exactly","so corresponding angles are equal."),
   [("supplementary","Corresponding angles are equal, not supplementary; it is co-interior angles that sum to 180°."),
    ("complementary","Corresponding angles are equal, not adding to 90°."),
    ("always 90°","They are equal to each other but only 90° if the transversal is perpendicular.")]),

 ("LA","When a transversal crosses two parallel lines, a pair of alternate interior angles is:",
   "equal",
   C("Alternate interior angles lie between the parallel lines on opposite sides of the transversal, and they are equal.")+
   steps("Look between the two parallel lines","take the angles on opposite sides of the transversal","these alternate interior angles are equal."),
   [("complementary","Alternate interior angles are equal, not adding to 90°."),
    ("always 100°","Their size depends on the figure; whatever it is, the pair is equal, not fixed at 100°."),
    ("unequal","With parallel lines, alternate interior angles are always equal, not unequal.")]),

 ("LA","When a transversal crosses two parallel lines, the two co-interior (same-side interior) angles add up to:",
   "180°",
   C("Co-interior angles lie between the parallel lines on the SAME side of the transversal, and they are supplementary.")+
   steps("Look between the two parallel lines","take the two angles on the same side of the transversal","they are supplementary, adding to 180°."),
   [("90°","Co-interior angles add to 180°, not 90°."),
    ("360°","360° is a full turn; co-interior angles add to 180°."),
    ("270°","270° is three right angles; co-interior angles add to 180°.")]),

 ("LA","A quarter-turn angle, measuring exactly 90°, is known as a:",
   "right angle",
   C("Exactly a quarter turn, 90°, is the special angle called a right angle.")+
   steps("A full turn is 360°","a quarter of that is 90°","this 90° angle is a right angle."),
   [("acute angle","An acute angle is LESS than 90°; exactly 90° is a right angle."),
    ("obtuse angle","An obtuse angle is MORE than 90°; exactly 90° is a right angle."),
    ("straight angle","A straight angle is 180°; exactly 90° is a right angle.")]),

 ("LA","An angle that is less than 90° is called:",
   "acute",
   C("Any angle smaller than a right angle (under 90°) is acute.")+
   steps("Compare the angle with 90°","if it is smaller than 90°","it is an acute angle."),
   [("obtuse","Obtuse means more than 90°; less than 90° is acute."),
    ("reflex","Reflex means more than 180°; less than 90° is acute."),
    ("straight","A straight angle is exactly 180°; less than 90° is acute.")]),

 ("LA","An angle between 90° and 180° is called:",
   "obtuse",
   C("An angle bigger than a right angle but less than a straight angle is obtuse.")+
   steps("Compare the angle with 90° and 180°","it is more than 90° but less than 180°","so it is an obtuse angle."),
   [("acute","Acute means less than 90°; an angle between 90° and 180° is obtuse."),
    ("right","A right angle is exactly 90°; between 90° and 180° is obtuse."),
    ("reflex","Reflex means more than 180°; between 90° and 180° is obtuse.")]),

 ("LA","An angle of exactly 180°, forming a straight line, is a:",
   "straight angle",
   C("When the two arms point in exactly opposite directions, forming a straight line, the angle is 180° — a straight angle.")+
   steps("The two arms lie in a straight line","this is exactly half a full turn","half of 360° is 180° — a straight angle."),
   [("right angle","A right angle is 90°, only half of a straight angle; 180° is a straight angle."),
    ("reflex angle","A reflex angle is more than 180°; exactly 180° is a straight angle."),
    ("complete angle","A complete angle is a full 360° turn; 180° is a straight angle.")]),

 ("LA","An angle greater than 180° but less than 360° is a:",
   "reflex angle",
   C("Beyond a straight angle but short of a full turn lies the reflex range.")+
   steps("A straight angle is 180° and a full turn is 360°","an angle larger than 180° but smaller than 360°","is called a reflex angle."),
   [("obtuse angle","Obtuse angles are only up to 180°; beyond 180° it is reflex."),
    ("acute angle","Acute angles are under 90°; over 180° it is reflex."),
    ("right angle","A right angle is just 90°; over 180° it is reflex.")]),

 ("LA","Two complementary angles are equal to each other; each one therefore measures:",
   "45°",
   C("If two equal angles add to 90°, each must be half of 90°.")+
   steps("They are complementary, so they add to 90°","they are equal, so split 90° evenly","90° ÷ 2 = 45° each."),
   [("90°","90° each would total 180°; complementary equal angles are 45° each."),
    ("30°","30° each totals only 60°; to reach 90° each must be 45°."),
    ("60°","60° each totals 120°; complementary equal angles are 45° each.")]),

 ("LA","Two supplementary angles are equal to each other; each one therefore measures:",
   "90°",
   C("If two equal angles add to 180°, each must be half of 180°.")+
   steps("They are supplementary, so they add to 180°","they are equal, so split 180° evenly","180° ÷ 2 = 90° each."),
   [("45°","45° each totals only 90°; supplementary equal angles are 90° each."),
    ("180°","180° each would total 360°; equal supplementary angles are 90° each."),
    ("60°","60° each totals 120°; to reach 180° each must be 90°.")]),

 ("LA","If two angles are complementary and one of them is 25°, the other is:",
   "65°",
   C("Complementary angles add to 90°, so subtract 25° from 90°.")+
   steps("Complement means they add to 90°","90° − 25° = 65°","so the other angle is 65°."),
   [("75°","75° would need a sum of 100°; complements add to 90°, giving 65°."),
    ("155°","155° is 180° − 25°, the SUPPLEMENT; the complement is 90° − 25° = 65°."),
    ("35°","35° would make the sum only 60°; 90° − 25° = 65°.")]),

 ("LA","If two angles are supplementary and one of them is 90°, the other is:",
   "90°",
   C("Supplementary angles add to 180°, so subtract 90° from 180°.")+
   steps("Supplement means they add to 180°","180° − 90° = 90°","so the other angle is also 90°."),
   [("0°","0° is not an angle here; 180° − 90° = 90°."),
    ("180°","180° each would total 360°; the supplement of 90° is 180° − 90° = 90°."),
    ("45°","45° would make the sum only 135°; 180° − 90° = 90°.")]),

 ("LA","A weather vane points 40° east of north; to point exactly east (90° from north) it must turn a further:",
   "50°",
   C("This is a complement in real life: 40° and the extra turn together must make 90°.")+
   steps("Due east is 90° from north","the vane is already 40° from north","it must turn 90° − 40° = 50° more."),
   [("130°","130° overshoots past east; the extra turn is 90° − 40° = 50°."),
    ("40°","40° is where it already points, not the turn needed; that is 90° − 40° = 50°."),
    ("60°","60° would land past east; the turn needed is 90° − 40° = 50°.")]),

 ("LA","Two roads meet so that one angle between them is 120°; the angle on the other side, along the straight road, is:",
   "60°",
   C("The two angles along a straight road form a linear pair adding to 180°.")+
   steps("The two angles sit on a straight road, forming a linear pair","a linear pair adds to 180°","180° − 120° = 60°."),
   [("240°","240° comes from adding, not subtracting; a linear pair gives 180° − 120° = 60°."),
    ("30°","30° would make the sum only 150°; the linear pair gives 180° − 120° = 60°."),
    ("120°","Equal 120° angles would total 240°, not 180°; the linear-pair partner is 60°.")]),
]

LA_UC = [
 "Complementary angles are how a carpenter checks two cuts will meet in a perfect right angle.",
 "Supplementary angles are how you confirm a folded flap lies flat along a straight edge.",
 "Finding a complement quickly is the trick behind setting a ramp to a chosen slope.",
 "Finding a supplement is how a tailor works out the second angle of a straight seam.",
 "Spotting adjacent angles is how you read a pie chart's neighbouring slices.",
 "Vertically-opposite-are-equal is why a pair of scissors opens the same angle on both sides.",
 "Knowing a straight line is 180° is how a road sign's two angles always add up.",
 "Solving a linear pair is how you find a missing angle where two paths split.",
 "Recognising parallel lines is how railway tracks are laid to stay the same distance apart.",
 "Perpendicular lines are how a builder makes sure a wall stands square to the floor.",
 "Spotting a transversal is the key to reading the angles a road makes across two lanes.",
 "Equal corresponding angles are how surveyors check two fences are truly parallel.",
 "Alternate angles being equal is how a draughtsman copies a slope to a parallel line.",
 "Co-interior angles summing to 180° is a quick test that two drawn lines are parallel.",
 "Recognising a right angle is how you check a picture frame's corner is true.",
 "Naming acute angles helps you describe the sharp tip of a slice of pizza.",
 "Naming obtuse angles helps you describe the wide opening of a reclining chair.",
 "A straight angle is the 180° flip you make when you turn to face the opposite way.",
 "Reflex angles describe the big sweep a clock's hand makes the long way round.",
 "Equal complementary angles are how a diagonal cut splits a right angle exactly in half.",
 "Equal supplementary angles are why a perfectly straightened road meets at two right angles.",
 "Finding a complement from one angle is everyday geometry in fitting tiles to a corner.",
 "Finding a supplement from one angle is how you complete a straight edge from a single measured corner.",
 "A turning weather vane is a real-world complement: how far more to reach due east.",
 "The roads-meeting problem is a linear pair you can spot at almost any junction.",
]


def _with_uc(lst, ucs):
    assert len(lst) == len(ucs) == 25, (len(lst), len(ucs))
    out = []
    for it, uc in zip(lst, ucs):
        code, stem, correct, html, distr = it
        out.append((code, stem, correct, html + U(uc), distr))
    return out


WS = _with_uc(WS, WS_UC)
EX = _with_uc(EX, EX_UC)
WW = _with_uc(WW, WW_UC)
LA = _with_uc(LA, LA_UC)

items = []
for i in range(25):
    items += [WS[i], EX[i], WW[i], LA[i]]
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

    keydist = build_paper(PNUM, TITLE, SHORT, LABELS, items, seed=38017,
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
    split = "/".join(str(counts[c]) for c in ("WS", "EX", "WW", "LA"))
    with open("PAPERS_MANIFEST.md", "a", encoding="utf-8") as fh:
        fh.write(f"| {PNUM} | 2026-06-18 | {TITLE} | {split} | ✓ |\n")

    # ---- update QUESTION_INDEX.json ----
    idx["fingerprints"] = sorted(existing | set(new_fps))
    idx.setdefault("combos", []).append({
        "paper": PNUM,
        "chapters": ["Winds, Storms & Cyclones",
                     "Wastewater Story",
                     "Exponents & Powers",
                     "Lines & Angles"],
    })
    idx["papers"] = idx.get("papers", 0) + 1
    with open(idx_path, "w", encoding="utf-8") as fh:
        json.dump(idx, fh, ensure_ascii=False, indent=2)
        fh.write("\n")

    print("Files:", sorted(v for v in moves.values()))
    print("Answer key spread A/B/C/D =", dict(keydist))
    print("Fingerprints added:", len(new_fps))
