# -*- coding: utf-8 -*-
# Boss Challenge Paper 42 — Winds, Storms & Cyclones · Electric Current & its
# Effects · Algebraic Expressions · Data Handling
# Content-only. Uses the dependency-free examfactory engine.
# Difficulty ramp: leans hard into FUSION. A cyclone's wind speed jumping from
# 90 to 180 km/h becomes a RATIO; recorded daily wind speeds become a MEAN; a
# storm's run of km per hour becomes an algebraic 5d; a bulb's current i becomes
# 4i; rainfall totals become an average; the chance of a cyclone year becomes a
# PROBABILITY. The child meets a Science situation and reaches for a Maths skill.
# Class-7 scope, simple wording, hard thinking.
# Produces, under Resources/BossChallengePapers/:
#   Paper_42_<SHORT>_QuestionPaper.html  (pure HTML — questions + options)
#   Paper_42_<SHORT>_QuestionPaper.pdf
#   Paper_42_<SHORT>_Questions.md
#   Paper_42_<SHORT>_Solutions.html
import os, sys, shutil, json, re
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from examfactory import build_paper, C, steps, U

PNUM  = "42"
SHORT = "WindsStormsCyclones_ElectricCurrent_AlgebraicExpressions_DataHandling"
TITLE = ("Winds, Storms & Cyclones · Electric Current & its Effects · "
         "Algebraic Expressions · Data Handling")
LABELS = {
    "WS": "Winds, Storms & Cyclones",
    "EC": "Electric Current & its Effects",
    "AE": "Algebraic Expressions",
    "DH": "Data Handling",
}

# ---------- WINDS, STORMS & CYCLONES (25) — Science (some fused) ----------
WS = [
 ("WS","The push that the air all around us exerts on every unit of area of a surface is called:",
   "air pressure",
   C("Air has weight, so it presses on everything it touches; that push per unit area is air pressure.")+
   steps("Air is made of countless moving particles","they strike surfaces and push on them","this push spread over each unit of area is air pressure.")+
   U("A balloon stays blown up because the air pressure inside pushes its skin outward."),
   [("air temperature","Temperature tells how hot the air is; the push it exerts on a surface is air pressure."),
    ("wind speed","Wind speed is how fast air moves; the steady push it exerts is air pressure."),
    ("humidity","Humidity is how much water vapour the air holds, not the push it exerts.")]),

 ("WS","Wind is simply moving air, and it always flows from a region of high air pressure towards a region of:",
   "low air pressure",
   C("Air, like water running downhill, moves from where the pressure is high to where it is low.")+
   steps("Find two places, one of high and one of low air pressure","air pushes harder from the high-pressure side","so it flows towards the low-pressure side as wind.")+
   U("A breeze through an open window is air flowing from higher pressure outside to lower inside."),
   [("high air pressure","Air does not pile up where pressure is already high; it flows away towards low pressure."),
    ("equal air pressure","If the pressure were equal everywhere there would be no wind; wind needs a low-pressure side."),
    ("higher ground","Wind follows pressure, not height; it blows towards the low-pressure region.")]),

 ("WS","When air is warmed it expands, becomes lighter than the cooler air around it, and so it tends to:",
   "rise upward",
   C("Warm air spreads out and grows lighter than the cool air nearby, so it floats up above it.")+
   steps("Heat makes the air expand","the spread-out warm air is lighter than cool air","being lighter, it rises upward.")+
   U("Smoke from a fire drifts upward because the hot air around it is rising."),
   [("sink downward","Lighter warm air rises; it is the cooler, heavier air that sinks downward."),
    ("stay perfectly still","Heated air does not stay put; being lighter, it rises above the cooler air."),
    ("turn into water","Warming does not turn air to water; the lighter warm air simply rises.")]),

 ("WS","Cooler, heavier air rushing in to take the place of warm air that has risen is exactly what we feel as a:",
   "wind",
   C("As warm air lifts away, cool air slides in to fill the gap, and that moving air is wind.")+
   steps("Warm air rises and leaves a low-pressure gap","cooler heavier air moves in to fill it","this moving air is the wind.")+
   U("Sitting near a fire, you feel cool air drawn past you towards the flames — a small wind."),
   [("rain","Rain is falling water droplets; cool air moving in to replace warm air is wind."),
    ("sunlight","Sunlight is energy from the Sun; the moving air that replaces risen warm air is wind."),
    ("a shadow","A shadow is a dark patch where light is blocked, not moving air; that air is wind.")]),

 ("WS","An experiment shows that the faster air moves over a surface, the air pressure there becomes:",
   "lower",
   C("Fast-moving air presses less on the surface it skims over, so the pressure there drops.")+
   steps("Air moving slowly presses normally on a surface","speed it up and it presses less","so faster air means lower pressure.")+
   U("A roof can be lifted in a storm because fast wind above it lowers the pressure there."),
   [("higher","Faster air actually presses less, so the pressure falls, not rises."),
    ("exactly the same","Moving air changes the pressure; speeding it up lowers, not steadies, the pressure."),
    ("zero","The pressure drops but does not vanish; faster air simply means lower pressure.")]),

 ("WS","Blow hard through the gap between two balloons hanging side by side and, surprisingly, the balloons swing:",
   "towards each other",
   C("The fast air between the balloons lowers the pressure there, so the higher pressure outside pushes them together.")+
   steps("Blowing speeds the air in the gap","fast air lowers the pressure between the balloons","the greater pressure outside pushes them towards each other.")+
   U("This same low-pressure trick explains how aeroplane wings are pushed upward by moving air."),
   [("apart from each other","You might expect them to part, but the low pressure between pulls them together."),
    ("straight upward","The balloons swing inward, not up; the gap's low pressure draws them together."),
    ("not move at all","The pressure change does move them — inward, towards each other.")]),

 ("WS","The single biggest reason winds blow across the whole Earth is the uneven:",
   "heating of the Earth by the Sun",
   C("The Sun warms some parts of the Earth more than others, and that uneven heating sets the air moving.")+
   steps("The Sun heats the equator more than the poles","warm air rises and cool air moves in","this uneven heating drives the world's winds.")+
   U("The steady trade winds blow because the Sun heats the equator far more than the poles."),
   [("spinning of windmills","Windmills are turned by wind; they do not cause it. Uneven heating causes wind."),
    ("colour of the oceans","The ocean's colour does not move air; uneven heating by the Sun does."),
    ("weight of the clouds","Clouds do not push the air around the globe; the Sun's uneven heating drives winds.")]),

 ("WS","By day the land heats up faster than the sea, so cool air blows in from the sea towards the land as a:",
   "sea breeze",
   C("Warm land air rises by day, and cool sea air flows in to replace it — that onshore wind is the sea breeze.")+
   steps("Daytime sun warms the land faster than the sea","warm air over the land rises","cool air flows in from the sea — the sea breeze.")+
   U("On a hot afternoon at the beach you feel a cool sea breeze blowing in off the water."),
   [("land breeze","A land breeze blows from land to sea at night; the daytime onshore wind is the sea breeze."),
    ("monsoon","The monsoon is a seasonal wind over months; the daily daytime onshore wind is the sea breeze."),
    ("cyclone","A cyclone is a violent storm, not the gentle daytime onshore wind, which is the sea breeze.")]),

 ("WS","At night the land cools faster than the sea, so the breeze reverses and now blows from the land towards:",
   "the sea",
   C("At night the sea stays warmer, its air rises, and cooler land air flows out over the water as a land breeze.")+
   steps("Night cools the land faster than the sea","warmer air over the sea rises","cool land air flows out towards the sea — the land breeze.")+
   U("Fishermen once set sail at night helped by the land breeze blowing out to sea."),
   [("the hills","The night breeze blows out over the warmer water, that is towards the sea, not the hills."),
    ("the land","By night the air moves from land to sea, the reverse of daytime; not back onto the land."),
    ("straight upward","The land breeze blows sideways out to sea, not straight up.")]),

 ("WS","The seasonal winds that sweep in from the ocean and bring heavy rains to much of India are the:",
   "monsoon winds",
   C("Monsoon winds are large seasonal winds that carry moisture-laden air from the sea, drenching the land.")+
   steps("Land and sea heat unevenly across the seasons","this sets up large seasonal winds","these monsoon winds bring the rains to India.")+
   U("Farmers across India wait for the monsoon winds each year to water their crops."),
   [("land breezes","A land breeze is a small night-time wind, not the rain-bringing seasonal monsoon winds."),
    ("trade winds","Trade winds blow steadily near the equator; India's rain-bringing seasonal winds are the monsoon."),
    ("tornado winds","A tornado is a brief violent whirl; India's seasonal rain-bearing winds are the monsoon.")]),

 ("WS","A very violent storm in which high-speed winds spiral round and round a low-pressure centre is called a:",
   "cyclone",
   C("A cyclone is a huge spinning storm of fierce winds whirling around a calm low-pressure middle.")+
   steps("Warm moist air rises fast over a warm sea","more air rushes in and starts spinning","this whirling storm around a low-pressure centre is a cyclone.")+
   U("Coastal towns near the Bay of Bengal prepare every year for the cyclone season."),
   [("sea breeze","A sea breeze is a gentle daytime wind; a violent spinning storm is a cyclone."),
    ("rainbow","A rainbow is an arc of colours in the sky, not a storm; the storm is a cyclone."),
    ("monsoon","The monsoon is a rain-bearing seasonal wind, not the violent spinning storm called a cyclone.")]),

 ("WS","At the very middle of a cyclone there is a strangely calm, low-pressure region known as the:",
   "eye",
   C("The eye is the quiet, almost windless centre of a cyclone, ringed by its most violent winds.")+
   steps("A cyclone whirls around its centre","that centre is oddly calm and clear","this calm low-pressure middle is called the eye.")+
   U("People may think a cyclone has passed when the calm eye arrives, but the fierce winds return."),
   [("tail","A cyclone has no 'tail'; its calm low-pressure centre is called the eye."),
    ("crest","A crest is the top of a wave, not part of a cyclone; the calm centre is the eye."),
    ("root","A cyclone has no root; the calm region at its centre is called the eye.")]),

 ("WS","A storm exactly like a cyclone, when it forms over the seas near America, is instead given the name:",
   "hurricane",
   C("The same kind of violent spinning sea storm is called a cyclone, a hurricane or a typhoon in different parts of the world.")+
   steps("A violent spinning sea storm forms","near India it is called a cyclone","over the American seas the same storm is called a hurricane.")+
   U("News from the Atlantic coast of America reports these very storms as hurricanes."),
   [("tsunami","A tsunami is a giant sea wave from an earthquake, not a wind storm like a hurricane."),
    ("blizzard","A blizzard is a heavy snowstorm; the cyclone-type storm near America is a hurricane."),
    ("drought","A drought is a long dry spell, the opposite of a storm; the storm is a hurricane.")]),

 ("WS","A dark, funnel-shaped column of very fast spinning air that reaches down from a storm cloud to the ground is a:",
   "tornado",
   C("A tornado is a narrow, furiously spinning funnel of air stretching from cloud to ground.")+
   steps("Air spins violently inside a storm cloud","a funnel of spinning air dips towards the ground","that funnel touching down is a tornado.")+
   U("Films show tornadoes as dark funnels that can lift cars and tear off roofs."),
   [("rainbow","A rainbow is a harmless arc of colour; the spinning funnel of air is a tornado."),
    ("glacier","A glacier is a slow river of ice, not a spinning column of air, which is a tornado."),
    ("sea breeze","A sea breeze is a gentle daytime wind; the violent spinning funnel is a tornado.")]),

 ("WS","Cyclones get their huge energy and usually begin to form over:",
   "warm ocean water",
   C("Warm seawater feeds moisture and heat into the air above it, giving a cyclone the energy to grow.")+
   steps("Warm sea heats the air just above it","this warm moist air rises fast","rising air drives the storm, so cyclones form over warm ocean water.")+
   U("Cyclones strengthen over warm tropical seas and weaken once they move over land."),
   [("cold mountain peaks","Cold dry peaks cannot feed a storm; cyclones grow over warm ocean water."),
    ("dry deserts","A desert lacks the moisture a cyclone needs; cyclones form over warm seas, not deserts."),
    ("frozen polar ice","Frozen ice gives no warm moist air; cyclones form over warm ocean water.")]),

 ("WS","The instrument made to measure the speed of the wind is called the:",
   "anemometer",
   C("An anemometer has little cups that spin in the wind; the faster they spin, the higher the wind speed.")+
   steps("Wind pushes the cups of the instrument","the cups spin faster in stronger wind","the spin is read off as the wind speed — that instrument is the anemometer.")+
   U("Weather stations use an anemometer to record how fast the wind is blowing each hour."),
   [("thermometer","A thermometer measures temperature, not wind speed; wind speed needs an anemometer."),
    ("barometer","A barometer measures air pressure; the speed of the wind is measured by an anemometer."),
    ("rain gauge","A rain gauge measures how much rain falls; wind speed is measured by an anemometer.")]),

 ("WS","Just around the calm eye of a cyclone lies the ring of the fiercest winds and heaviest rain, called the:",
   "eye wall",
   C("The eye wall is the band of towering clouds and most violent winds wrapped tightly around the calm eye.")+
   steps("The eye sits calm at the centre","circling it is a ring of the strongest winds","that violent ring is the eye wall.")+
   U("Damage from a cyclone is worst where the eye wall, with its fiercest winds, crosses the coast."),
   [("eye","The eye is the calm centre; the violent ring of winds around it is the eye wall."),
    ("tail","A cyclone has no tail; the ring of fierce winds around the eye is the eye wall."),
    ("base","The fiercest winds form a ring named the eye wall, not a 'base'.")]),

 ("WS","The two conditions that join together to create a cyclone are high wind speeds and a difference in:",
   "air pressure",
   C("A cyclone is born where strong winds meet a sharp difference in air pressure, setting the air spinning.")+
   steps("Warm seas create a low-pressure centre","the pressure difference pulls air inward","high winds plus this pressure difference build the cyclone.")+
   U("Forecasters watch both wind speeds and pressure differences to warn of a forming cyclone."),
   [("soil colour","The colour of the soil has nothing to do with cyclones; what matters is air pressure difference."),
    ("ocean saltiness","How salty the sea is does not form a cyclone; a difference in air pressure does."),
    ("number of islands","Islands do not cause cyclones; a cyclone needs high winds and an air pressure difference.")]),

 ("WS","A sudden, dangerous rise of seawater that floods low coastal land during a cyclone is called a:",
   "storm surge",
   C("A storm surge is a great heap of seawater driven onto the coast by a cyclone's fierce winds and low pressure.")+
   steps("The cyclone's winds push seawater towards the shore","its low pressure lets the sea bulge upward","this wall of water floods the coast as a storm surge.")+
   U("Most cyclone deaths come from the storm surge drowning low-lying coastal villages."),
   [("land breeze","A land breeze is a gentle night wind, not a flood of seawater; that is a storm surge."),
    ("dew fall","Dew is a little moisture settling at night, nothing like the flooding storm surge."),
    ("snow drift","Snow drifts pile up dry snow; a cyclone's coastal flood of seawater is a storm surge.")]),

 ("WS","The safest action to take the moment an official cyclone warning is announced for your area is to:",
   "move to a safer, stronger shelter",
   C("When a cyclone warning sounds, getting to a sturdy shelter away from the coast keeps you safe.")+
   steps("A warning means a dangerous storm is coming","staying in a weak house near the coast is risky","so move early to a safer, stronger shelter.")+
   U("Coastal towns now evacuate people to cyclone shelters as soon as a warning is issued."),
   [("go out to watch the sea","Going to the shore during a cyclone is deadly; the safe choice is to shelter inland."),
    ("ignore the warning","Ignoring a cyclone warning risks your life; you should move to a safe shelter."),
    ("switch on all taps","Opening taps does nothing for safety; the right action is to reach a strong shelter.")]),

 ("WS","The brilliant flash of light seen across the sky during a thunderstorm is called:",
   "lightning",
   C("Lightning is a huge spark of electricity leaping through the air during a storm, lighting up the sky.")+
   steps("Charges build up inside storm clouds","they suddenly leap across as a giant spark","that bright flash is lightning.")+
   U("You see lightning split the sky a moment before you hear the thunder roll."),
   [("thunder","Thunder is the sound; the bright flash of light is lightning."),
    ("a rainbow","A rainbow is a calm arc of colours after rain, not the storm's electric flash, which is lightning."),
    ("a sunbeam","A sunbeam is steady sunlight; the sudden storm flash is lightning.")]),

 ("WS","The loud rumbling or crashing sound that reaches us a little after the lightning flash is the:",
   "thunder",
   C("Thunder is the sound made by lightning suddenly heating and pushing the air apart.")+
   steps("Lightning flashes and heats the air violently","the air expands with a bang","that sound, heard after the flash, is thunder.")+
   U("Counting the seconds between the flash and the thunder tells you how far off the storm is."),
   [("lightning","Lightning is the flash of light; the sound that follows it is thunder."),
    ("an echo","An echo is a reflected sound; the bang made by lightning itself is thunder."),
    ("a whistle","A whistle is a thin steady note; the storm's rumbling crash is thunder.")]),

 ("WS","Towering, dark thunderclouds build up mainly when warm, moist air over a heated area rapidly:",
   "rises upward",
   C("Warm damp air shooting upward cools and its water condenses, piling into the tall clouds of a thunderstorm.")+
   steps("The Sun heats moist air near the ground","this warm moist air rises fast","as it rises it cools and builds towering thunderclouds.")+
   U("On a hot, sticky afternoon you can watch thunderclouds pile up before an evening storm."),
   [("sinks to the ground","Sinking air spreads out and clears the sky; thunderclouds build when moist air rises."),
    ("freezes solid","Air does not freeze solid; thunderclouds form as warm moist air rises and cools."),
    ("stops moving","Still air builds no storm; thunderclouds grow when warm moist air rises rapidly.")]),

 ("WS","A cyclone's wind speed rose from 90 km/h to 180 km/h as it strengthened. The new speed is how many times the old speed?",
   "2 times",
   C("Comparing 180 with 90 by division shows the new speed is exactly double the old one.")+
   steps("Old speed = 90 km/h, new speed = 180 km/h","divide: 180 / 90 = 2","so the new speed is 2 times the old speed.")+
   U("Forecasters describe a storm 'doubling in strength' using exactly this kind of comparison."),
   [("3 times","3 times 90 would be 270, not 180; the new speed is 180 / 90 = 2 times the old."),
    ("half","180 is bigger than 90, so the speed grew, not halved; it became 2 times as fast."),
    ("the same","180 is not equal to 90; the new speed is double, that is 2 times, the old speed.")]),

 ("WS","Today, forming cyclones far out at sea are spotted and tracked from above by:",
   "satellites",
   C("Weather satellites high above the Earth photograph storms from space, letting forecasters track cyclones early.")+
   steps("A cyclone forms far out over the ocean","satellites in space photograph it from above","forecasters track its path and warn people in time.")+
   U("Satellite pictures on the news show the swirling cloud of a cyclone heading for the coast."),
   [("microscopes","A microscope magnifies tiny things up close; cyclones at sea are tracked by satellites."),
    ("telescopes pointed at stars","Star telescopes look outward to space; cyclones on Earth are watched by satellites."),
    ("fishing nets","Fishing nets catch fish; they cannot track a cyclone — satellites do that.")]),
]

# ---------- ELECTRIC CURRENT & ITS EFFECTS (25) — Science (some fused) ----------
EC = [
 ("EC","A long, insulated wire wound into many turns that behaves like a magnet only while current flows is an:",
   "electromagnet",
   C("Wind a wire into a coil and pass current through it: the coil acts as a magnet, an electromagnet.")+
   steps("Coil a wire into many turns","pass an electric current through it","the coil becomes a magnet — an electromagnet.")+
   U("Huge electromagnets in scrapyards lift heavy iron, then drop it when the current is switched off."),
   [("permanent magnet","A permanent magnet is magnetic all the time; a coil magnetic only with current is an electromagnet."),
    ("compass","A compass is a small free magnet that points north; a current-carrying coil is an electromagnet."),
    ("battery","A battery supplies the current; the coil that becomes magnetic with that current is the electromagnet.")]),

 ("EC","When an electric current flows through a wire, one thing that always happens to the wire is that it:",
   "becomes hot",
   C("Current forcing its way through a wire heats it up — this is the heating effect of electric current.")+
   steps("Current flows through the wire","it meets resistance and gives up energy","that energy warms the wire, so it becomes hot.")+
   U("An electric heater's coil glows red because the current passing through it makes it very hot."),
   [("becomes longer and longer","Current does not keep stretching a wire; it heats it up instead."),
    ("turns into water","A wire does not melt into water from ordinary current; it simply gets hot."),
    ("becomes invisible","A current-carrying wire stays visible; what it does is get hot.")]),

 ("EC","A short, thin piece of wire that melts and breaks the circuit when too much current flows is called a:",
   "fuse",
   C("A fuse is a deliberately weak link that melts first if the current grows dangerously large, cutting the circuit.")+
   steps("Too much current heats the thin fuse wire","the fuse wire melts before other wires do","the circuit breaks, protecting the appliances.")+
   U("If too many gadgets overload a socket, the fuse melts and saves the wiring from catching fire."),
   [("filament","A filament is the glowing wire inside a bulb; the safety wire that melts is the fuse."),
    ("battery","A battery supplies current; the thin wire that melts to break the circuit is the fuse."),
    ("switch","A switch turns a circuit on and off by choice; the wire that melts on overload is the fuse.")]),

 ("EC","In an electric circuit, current keeps flowing only while the path it travels along is:",
   "closed (complete)",
   C("Current needs an unbroken loop; only when the circuit is closed can it flow all the way round.")+
   steps("Trace the wire from the cell and back","if the loop has no break, it is closed","only then can current flow.")+
   U("Flicking a switch closes the circuit and the bulb lights; opening it breaks the flow."),
   [("open (broken)","An open circuit has a gap, so no current flows; current needs a closed circuit."),
    ("painted blue","The colour of the wire has nothing to do with current; the circuit must be closed."),
    ("very short","Length alone does not matter; the loop must be closed for current to flow.")]),

 ("EC","Within a glowing electric bulb, the slender coiled wire that lights up as current passes through is the:",
   "filament",
   C("The filament is the fine coiled wire in a bulb; current heats it white-hot so it gives out light.")+
   steps("Current enters the bulb","it flows through the thin coiled filament","the filament heats up and glows, giving light.")+
   U("When a bulb 'blows', it is usually the thin filament inside that has snapped."),
   [("fuse","A fuse is a safety wire that melts on overload; the glowing wire in a bulb is the filament."),
    ("switch","A switch turns the bulb on or off; the part that actually glows is the filament."),
    ("socket","The socket holds the bulb in place; the wire that glows inside is the filament.")]),

 ("EC","Passing an electric current through water can break it up and is shown by the slow rise of:",
   "bubbles of gas",
   C("Current can split water apart, and we see this chemical effect as tiny gas bubbles forming at the wires.")+
   steps("Dip two wires from a cell into water","pass a current through the water","bubbles of gas appear at the wires — the chemical effect.")+
   U("This bubbling is how electricity can be used to split water into its gases in a lab."),
   [("flames of fire","Passing current through water makes gas bubbles, not flames."),
    ("blocks of ice","Current warms water if anything; the visible sign of its chemical effect is gas bubbles."),
    ("grains of salt","Salt does not appear from the water; the chemical effect shows up as gas bubbles.")]),

 ("EC","The repeated striking of the hammer on the gong in an electric bell happens because its electromagnet keeps getting:",
   "magnetised and demagnetised",
   C("The bell's electromagnet switches on and off again and again, so the hammer is pulled and released over and over.")+
   steps("Current magnetises the coil, pulling the hammer to strike","this very motion breaks the circuit, so the coil loses magnetism","a spring pulls the hammer back, the circuit closes, and it repeats.")+
   U("The fast on-off magnetism is why a doorbell rings as a rapid string of strikes."),
   [("hotter and hotter","The bell does not rely on heat; its hammer strikes because the magnet turns on and off."),
    ("heavier and heavier","The hammer's weight does not change; the electromagnet keeps magnetising and demagnetising."),
    ("bigger and bigger","The coil does not grow in size; it keeps being magnetised and demagnetised.")]),

 ("EC","The larger the electric current you send through a given wire, the more the wire produces of:",
   "heat",
   C("A bigger current means more energy given up in the wire, so it produces more heat.")+
   steps("Current flowing in a wire gives up energy as heat","increase the current","more energy is given up, so more heat is produced.")+
   U("A heater set to 'high' draws a larger current and so gives out more heat."),
   [("sound","An ordinary wire makes no sound from current; a larger current makes more heat."),
    ("light only and no heat","Even a glowing wire is hot; a larger current produces more heat, not heatless light."),
    ("ice","A current-carrying wire warms up; a larger current produces more heat, never ice.")]),

 ("EC","A modern safety device used in homes in place of a fuse, which can simply be switched back on, is the:",
   "MCB (miniature circuit breaker)",
   C("An MCB is a reusable switch that trips off when the current is too large and can be reset by hand.")+
   steps("Too much current flows in the circuit","the MCB trips and breaks the circuit automatically","once the fault is fixed it is switched back on — no wire to replace.")+
   U("When too many appliances trip the power at home, you reset the MCB in the switchboard."),
   [("filament","A filament glows inside a bulb; the resettable safety switch is the MCB."),
    ("anemometer","An anemometer measures wind speed; the resettable circuit safety device is the MCB."),
    ("compass","A compass shows direction; the device that trips on overload and resets is the MCB.")]),

 ("EC","Several electric cells joined together end to end to give a larger supply form a:",
   "battery",
   C("A battery is simply two or more cells connected together to drive a stronger current.")+
   steps("Take two or more cells","join them end to end","the combination is called a battery.")+
   U("A torch often uses a battery of two cells stacked to light its bulb brightly."),
   [("single switch","A switch only opens or closes a circuit; several joined cells make a battery."),
    ("fuse","A fuse is a safety wire; several cells joined together form a battery."),
    ("conductor","A conductor is any material that carries current; joined cells make a battery.")]),

 ("EC","An electromagnet is special because it stops being a magnet the moment the current is:",
   "switched off",
   C("Unlike a permanent magnet, an electromagnet is magnetic only while current flows; cut the current and the magnetism goes.")+
   steps("Current through the coil makes it a magnet","switch off the current","the coil at once stops being a magnet.")+
   U("A scrapyard crane drops its load of iron the instant the electromagnet's current is switched off."),
   [("made longer","An electromagnet's magnetism depends on the current, not the wire's length; it dies when current is switched off."),
    ("painted red","Paint does not affect magnetism; the electromagnet loses it when the current is switched off."),
    ("warmed up","Warming does not control it; the electromagnet loses its magnetism when the current is switched off.")]),

 ("EC","Copper and the other metals that readily allow an electric current to flow through them are known as:",
   "conductors",
   C("Conductors are materials that allow current to flow through them readily, like the metals in wires.")+
   steps("Try to pass current through a material","if it flows through easily","that material is a conductor.")+
   U("Electrical wires have copper cores because copper is an excellent conductor."),
   [("insulators","Insulators block current; materials that let it pass easily are conductors."),
    ("magnets","A magnet attracts iron; a material that carries current easily is a conductor."),
    ("fuses","A fuse is a safety wire; any material that carries current well is a conductor.")]),

 ("EC","A device that changes stored chemical energy into the electrical energy that drives a current is a:",
   "cell",
   C("An electric cell stores chemical energy and turns it into electrical energy to push a current round a circuit.")+
   steps("Chemicals inside the cell react","the reaction frees electrical energy","this energy drives a current — that device is a cell.")+
   U("The dry cell in a torch turns its chemicals into the electricity that lights the bulb."),
   [("bulb","A bulb turns electrical energy into light; the source of the current is a cell."),
    ("switch","A switch only opens and closes a circuit; the source that drives current is a cell."),
    ("wire","A wire carries the current; the device that produces it from chemicals is a cell.")]),

 ("EC","A current-carrying coil can pick up steel pins and then drop them when switched off; this shows that current has a:",
   "magnetic effect",
   C("That a coil acts as a magnet when current flows is the magnetic effect of electric current.")+
   steps("Pass current through a coil","it attracts steel pins like a magnet","switch off and they drop — current has a magnetic effect.")+
   U("This magnetic effect is put to work in electric bells, cranes and many motors."),
   [("cooling effect","Current warms, not cools; picking up pins shows its magnetic effect."),
    ("sound effect","Current does not naturally make sound; lifting pins shows its magnetic effect."),
    ("freezing effect","Current does not freeze things; attracting steel pins shows its magnetic effect.")]),

 ("EC","The wire of an electric heater glows red-hot when switched on; this is a clear example of the:",
   "heating effect of current",
   C("The heater's coil glowing red shows the heating effect — current turning into heat in the wire.")+
   steps("Current flows through the heater's coil","the coil resists and heats strongly","it glows red-hot — the heating effect of current.")+
   U("Toasters, irons and geysers all rely on this same heating effect of electric current."),
   [("magnetic effect of current","The magnetic effect makes a coil a magnet; a glowing hot coil shows the heating effect."),
    ("chemical effect of current","The chemical effect splits liquids into gases; a glowing coil shows the heating effect."),
    ("cooling effect of current","Current heats, it does not cool; the red-hot coil shows the heating effect.")]),

 ("EC","A bulb draws a current of i amperes. The total current drawn by 3 such identical bulbs, all the same, is:",
   "3i amperes",
   C("Three identical bulbs each drawing i amperes together draw three lots of i, written 3i.")+
   steps("One bulb draws i amperes","there are 3 identical bulbs","total current = i + i + i = 3i amperes.")+
   U("An electrician adds up the currents of all the bulbs on a line to size its wiring."),
   [("i + 3 amperes","You add 3 of the i's by multiplying, not by adding 3; the total is 3i, not i + 3."),
    ("i/3 amperes","Three bulbs draw more, not less; together they draw 3i, not i divided by 3."),
    ("i amperes","i is just one bulb's current; three identical bulbs together draw 3i amperes.")]),

 ("EC","The filament of a bulb is made from a metal chosen because it has a very:",
   "high melting point",
   C("The filament glows extremely hot, so it must be a metal that can get that hot without melting away.")+
   steps("Current heats the filament white-hot","an ordinary metal would melt","so the filament uses a metal with a very high melting point.")+
   U("Bulb filaments use tungsten because it can glow white-hot without melting."),
   [("low melting point","A low-melting metal would melt at once when white-hot; the filament needs a high melting point."),
    ("bright colour when cold","Colour when cold does not matter; the filament needs a very high melting point."),
    ("pleasant smell","Smell is irrelevant to a filament; what it needs is a very high melting point.")]),

 ("EC","To do its job of protecting a circuit, a fuse must be connected so that the whole circuit's current:",
   "passes through it",
   C("A fuse can only guard a circuit if every bit of the current is forced to flow through it.")+
   steps("All the circuit's current must reach the fuse","so the fuse is placed in the main line","then if the current is too big, the fuse melts and breaks the circuit.")+
   U("A house fuse sits on the main line so all the current passes through and it can cut the supply."),
   [("avoids it completely","A fuse the current bypasses can protect nothing; all the current must pass through it."),
    ("only touches it slightly","A loose touch will not protect the circuit; the whole current must pass through the fuse."),
    ("flows around it","Current going around the fuse leaves it useless; the whole current must pass through it.")]),

 ("EC","The two effects of electric current you study at this level are the heating effect and the:",
   "magnetic effect",
   C("Electric current shows a heating effect (it warms wires) and a magnetic effect (a coil becomes a magnet).")+
   steps("Current warms a wire — the heating effect","current makes a coil act as a magnet","that second one is the magnetic effect.")+
   U("Heaters use the heating effect; bells and cranes use the magnetic effect of current."),
   [("freezing effect","Current does not freeze things; its second effect, beside heating, is the magnetic effect."),
    ("sound effect","Current does not naturally make sound; beside heating, its other effect is magnetic."),
    ("smell effect","Current has no 'smell effect'; beside heating, the effect you study is magnetic.")]),

 ("EC","Adding a soft-iron piece, the core, inside a current-carrying coil makes the electromagnet:",
   "stronger",
   C("A soft-iron core concentrates the magnetism, so the electromagnet pulls much more strongly.")+
   steps("A bare coil is a weak magnet","slip a soft-iron core inside it","the core boosts the magnetism, making the electromagnet stronger.")+
   U("Powerful lifting electromagnets are built around iron cores to make them as strong as possible."),
   [("weaker","An iron core boosts the magnetism, so the electromagnet gets stronger, not weaker."),
    ("colder","The core changes the magnetism, not the temperature; it makes the electromagnet stronger."),
    ("permanent forever","With a soft-iron core the magnet still dies when current stops; the core just makes it stronger while on.")]),

 ("EC","The chief job of an electric fuse in a household circuit is to protect the wiring and appliances from:",
   "too much current",
   C("A fuse melts and cuts the circuit when the current grows dangerously large, saving the wiring from overheating.")+
   steps("If too much current flows, wires can overheat and catch fire","the thin fuse melts first","this breaks the circuit and stops the danger.")+
   U("A fuse blowing during an overload is what keeps a fault from setting the house wiring alight."),
   [("too little current","A small current is harmless; the fuse guards against too much current."),
    ("bright sunlight","Sunlight does not harm a circuit; the fuse protects against too much current."),
    ("loud noise","Noise does not damage wiring; the fuse protects against an overload of current.")]),

 ("EC","A heater is used for the same number of hours, t hours, on each of 7 days. The total time it runs is:",
   "7t hours",
   C("Running t hours a day for 7 days means 7 lots of t hours, written 7t.")+
   steps("Each day the heater runs t hours","there are 7 such days","total = t + t + ... (7 times) = 7t hours.")+
   U("An electricity meter effectively totals the running hours of an appliance this same way."),
   [("t + 7 hours","You add 7 lots of t by multiplying, not by adding 7; the total is 7t, not t + 7."),
    ("7/t hours","Seven days of use give more time, not less; the total is 7t, not 7 divided by t."),
    ("t hours","t is just one day's running time; over 7 days it is 7t hours.")]),

 ("EC","An ordinary magnetic compass needle, brought near a wire carrying a current, is seen to:",
   "deflect (turn aside)",
   C("Current makes a magnetic effect around the wire, which pushes the nearby compass needle off its usual line.")+
   steps("A compass needle normally points north","bring it near a current-carrying wire","the wire's magnetic effect makes the needle turn aside.")+
   U("This very deflection was the first clue that an electric current behaves like a magnet."),
   [("melt at once","A compass needle does not melt near a wire; it simply turns aside from the magnetic effect."),
    ("stay perfectly still","If current had no magnetic effect the needle would not move; in fact it deflects."),
    ("catch fire","The needle does not burn; it deflects because the current has a magnetic effect.")]),

 ("EC","Rubber and plastic are used to cover electric wires because such materials are good:",
   "insulators",
   C("Insulators do not let current pass, so a rubber or plastic cover keeps the current safely inside the wire.")+
   steps("Current must stay inside the metal core","rubber and plastic block current","so they are used as insulating covers.")+
   U("The plastic coating on a charger cable lets you hold it safely while current flows inside."),
   [("conductors","Conductors carry current; wire coverings are made of insulators, which block it."),
    ("magnets","A magnet attracts iron; wire coverings are insulators, which stop current escaping."),
    ("fuses","A fuse is a safety wire; the protective covering of a wire is made of insulators.")]),

 ("EC","For a bulb in a torch to light up, the cell, the switch, the bulb and the wires must together form one:",
   "complete circuit",
   C("The current can only reach the bulb if all the parts join into one unbroken loop — a complete circuit.")+
   steps("The cell pushes the current","it must travel through wires, switch and bulb and return","only an unbroken loop, a complete circuit, lets the bulb light.")+
   U("If any wire in a torch comes loose, the circuit is broken and the bulb will not light."),
   [("broken circuit","A broken circuit has a gap and no current flows; the bulb lights only in a complete circuit."),
    ("single wire alone","One wire by itself is not a loop; the bulb needs a complete circuit to light."),
    ("pile of magnets","Magnets do not light a bulb; it needs a complete circuit with a cell.")]),
]

# ---------- ALGEBRAIC EXPRESSIONS (25) — Maths (several fused with Science) ----------
AE = [
 ("AE","A letter such as x or n that can stand for different number values is called a:",
   "variable",
   C("A variable is a letter used in place of a number whose value can change or is not yet known.")+
   steps("Pick a letter like x or n","let it stand for a number that can vary","that letter is called a variable.")+
   U("Using a variable lets one formula work for any number you put in its place."),
   [("constant","A constant is a fixed number such as 7; a letter that can take many values is a variable."),
    ("equation","An equation is a balanced statement with an equals sign; the changing letter is a variable."),
    ("answer","The answer is the final value found; the changing letter itself is a variable.")]),

 ("AE","A combination of variables and constants joined by operations such as + and ×, like 3x + 5, is an:",
   "algebraic expression",
   C("An algebraic expression links numbers and letters with operations but has no equals sign.")+
   steps("Take some variables and constants","join them with +, -, x or /","the result, like 3x + 5, is an algebraic expression.")+
   U("A shop's rule 'cost = 3x + 5' for x items is written as an algebraic expression."),
   [("single constant","A lone number like 5 is just a constant; 3x + 5 with its variable is an algebraic expression."),
    ("plain sentence","A sentence is written in words; numbers and letters joined by operations form an algebraic expression."),
    ("bar graph","A bar graph is a picture of data; 3x + 5 written in symbols is an algebraic expression.")]),

 ("AE","In the term 5x, the number 5 multiplying the variable is called the:",
   "coefficient",
   C("The coefficient is the number multiplied by the variable in a term, here the 5 in 5x.")+
   steps("Look at the term 5x","it is 5 times x","the number 5 multiplying x is the coefficient.")+
   U("In a cost rule like 5x, the coefficient 5 is the price of each single item."),
   [("variable","The variable is the letter x; the number 5 in front of it is the coefficient."),
    ("constant term","A constant term stands alone with no variable; the 5 multiplying x is its coefficient."),
    ("exponent","An exponent is a small raised power; the 5 multiplying x is the coefficient.")]),

 ("AE","Terms that contain exactly the same variables raised to the same powers, such as 3x and 5x, are called:",
   "like terms",
   C("Like terms have identical variable parts, so they can be added or subtracted into one term.")+
   steps("Compare the variable parts of two terms","if the variables and their powers match","the terms are like terms.")+
   U("Only like terms can be combined, just as you add apples to apples, not apples to oranges."),
   [("unlike terms","Unlike terms have different variable parts; 3x and 5x share the same x, so they are like terms."),
    ("constants","Constants are plain numbers; 3x and 5x both contain x, so they are like terms."),
    ("coefficients","Coefficients are the numbers in front; 3x and 5x are themselves like terms.")]),

 ("AE","In the algebraic expression 3x + 5, the part that has no variable, the plain number, is the:",
   "constant term",
   C("A constant term is a number on its own with no variable attached, here the 5 in 3x + 5.")+
   steps("Look at 3x + 5","3x has the variable x","5 stands alone with no variable — it is the constant term.")+
   U("In a cost rule 3x + 5, the constant 5 might be a fixed charge added whatever x is."),
   [("variable term","The variable term is 3x, which contains x; the plain 5 is the constant term."),
    ("coefficient","The coefficient is the 3 multiplying x; the lone number 5 is the constant term."),
    ("exponent","An exponent is a raised power; the standalone number 5 is the constant term.")]),

 ("AE","The algebraic expression that means 'seven more than a number x' is written as:",
   "x + 7",
   C("'More than' means addition, so seven more than x is x with 7 added on.")+
   steps("Start with the number x","'seven more than' means add 7","that gives the expression x + 7.")+
   U("If you are 7 years older than your cousin who is x years old, your age is x + 7."),
   [("x - 7","x - 7 is seven less than x; seven more than x adds 7, giving x + 7."),
    ("7x","7x means seven times x, not seven more; 'seven more than x' is x + 7."),
    ("7/x","7/x divides; 'seven more than x' means addition, giving x + 7.")]),

 ("AE","Simplifying the expression 2x + 3x by adding the like terms gives:",
   "5x",
   C("2x and 3x are like terms, so you simply add their coefficients: 2 + 3 = 5, keeping the x.")+
   steps("2x + 3x are like terms","add the coefficients: 2 + 3 = 5","so the sum is 5x.")+
   U("Adding 2 of something and 3 more of the same thing gives 5 of them — that is 5x."),
   [("6x","6 multiplies 2 and 3; adding like terms adds the coefficients, 2 + 3 = 5, giving 5x."),
    ("5x²","Adding like terms does not change the power of x; 2x + 3x = 5x, not 5x squared."),
    ("23x","23 just pushes the digits together; 2x + 3x adds to 5x.")]),

 ("AE","The result of the subtraction 7x − 4x is:",
   "3x",
   C("7x and 4x are like terms, so subtract the coefficients: 7 - 4 = 3, keeping the x.")+
   steps("7x - 4x are like terms","subtract the coefficients: 7 - 4 = 3","so the result is 3x.")+
   U("Having 7 of something and giving 4 away leaves 3 — written 3x."),
   [("11x","11 adds 7 and 4; subtracting like terms takes 7 - 4 = 3, giving 3x."),
    ("3","The x must stay; 7x - 4x = 3x, not the bare number 3."),
    ("28x","28 multiplies 7 and 4; subtracting like terms gives 7 - 4 = 3, that is 3x.")]),

 ("AE","An algebraic expression that has exactly one term, such as 5x or 7, is called a:",
   "monomial",
   C("'Mono' means one, so a monomial is an expression made of just a single term.")+
   steps("Count the terms in the expression","if there is exactly one term","it is a monomial.")+
   U("A simple cost like 5x for x items, all in one term, is a monomial."),
   [("binomial","A binomial has two terms; an expression with just one term is a monomial."),
    ("trinomial","A trinomial has three terms; a single-term expression is a monomial."),
    ("equation","An equation has an equals sign; a one-term expression is a monomial.")]),

 ("AE","An algebraic expression made up of exactly two terms, such as 3x + 5, is called a:",
   "binomial",
   C("'Bi' means two, so a binomial is an expression built from two terms joined by + or -.")+
   steps("Count the terms in the expression","if there are exactly two terms","it is a binomial.")+
   U("A cost rule like 3x + 5, with a per-item part and a fixed part, is a binomial."),
   [("monomial","A monomial has just one term; an expression with two terms is a binomial."),
    ("trinomial","A trinomial has three terms; a two-term expression is a binomial."),
    ("variable","A variable is a single letter; an expression with two terms is a binomial.")]),

 ("AE","An algebraic expression that contains exactly three terms, such as x + y + 5, is called a:",
   "trinomial",
   C("'Tri' means three, so a trinomial is an expression made of three terms.")+
   steps("Count the terms in the expression","if there are exactly three terms","it is a trinomial.")+
   U("An expression adding up three separate charges, like x + y + 5, is a trinomial."),
   [("binomial","A binomial has two terms; an expression with three terms is a trinomial."),
    ("monomial","A monomial has one term; a three-term expression is a trinomial."),
    ("constant","A constant is a single fixed number; a three-term expression is a trinomial.")]),

 ("AE","The value of the expression 2x + 1 when x = 3 is:",
   "7",
   C("Put 3 in place of x, then work out the arithmetic.")+
   steps("Replace x with 3: 2(3) + 1","2 x 3 = 6, then 6 + 1","that gives 7.")+
   U("Plugging a number into a formula like this is how you read off a real answer."),
   [("6","6 is just 2 x 3; you must still add the 1, giving 7."),
    ("9","9 would be 2(3) + 3; the constant is 1, so 6 + 1 = 7."),
    ("5","5 would be 2(3) - 1; the expression adds 1, so 6 + 1 = 7.")]),

 ("AE","The value of the expression 5a when a = 4 is:",
   "20",
   C("5a means 5 times a, so put 4 in place of a and multiply.")+
   steps("5a means 5 x a","replace a with 4: 5 x 4","that gives 20.")+
   U("If each ticket costs 5 and you buy a = 4 of them, the cost 5a is 20."),
   [("9","9 adds 5 and 4; 5a means 5 times a, so 5 x 4 = 20."),
    ("54","54 just pushes the digits together; 5a with a = 4 is 5 x 4 = 20."),
    ("1","1 would be 5 - 4; 5a means multiply, giving 5 x 4 = 20.")]),

 ("AE","The algebraic expression for 'twice a number n, decreased by 5' is:",
   "2n − 5",
   C("'Twice n' is 2n, and 'decreased by 5' means subtract 5 from it.")+
   steps("Twice the number n is 2n","'decreased by 5' means subtract 5","that gives 2n - 5.")+
   U("If a bill is twice the units used, less a 5-rupee rebate, it is 2n - 5."),
   [("2n + 5","'Decreased by 5' means subtract, not add; the expression is 2n - 5."),
    ("n - 5","'Twice the number' is 2n, not n; decreased by 5 it is 2n - 5."),
    ("5 - 2n","This subtracts 2n from 5, the wrong way round; 'twice n decreased by 5' is 2n - 5.")]),

 ("AE","Adding the two expressions 3a + 2 and 5a + 4 gives:",
   "8a + 6",
   C("Add the like terms separately: the a-terms together and the numbers together.")+
   steps("Add the a-terms: 3a + 5a = 8a","add the constants: 2 + 4 = 6","so the sum is 8a + 6.")+
   U("Combining two part-bills, each with a per-item charge and a fixed charge, works just like this."),
   [("8a + 8","The constants are 2 and 4, adding to 6, not 8; the sum is 8a + 6."),
    ("15a + 6","3a and 5a add to 8a, not 15a; 15 multiplies them. The sum is 8a + 6."),
    ("8a² + 6","Adding like terms does not change the power of a; the sum is 8a + 6, not 8a squared.")]),

 ("AE","Subtracting 2x from 7x leaves:",
   "5x",
   C("Subtract the smaller like term from the larger: 7x - 2x.")+
   steps("Start with 7x and take away 2x","7x - 2x has coefficients 7 - 2 = 5","so the result is 5x.")+
   U("Having 7 units of charge and removing 2 of them leaves 5 units — that is 5x."),
   [("9x","9 adds 7 and 2; subtracting gives 7 - 2 = 5, that is 5x."),
    ("5","The x stays; 7x - 2x = 5x, not the bare number 5."),
    ("14x","14 multiplies 7 and 2; subtracting like terms gives 5x.")]),

 ("AE","A storm moves d kilometres each hour at a steady pace. In 5 hours it moves a distance of:",
   "5d kilometres",
   C("Five hours of moving d km each hour means five lots of d, written 5d.")+
   steps("Each hour the storm moves d km","over 5 hours it is d + d + d + d + d","that is 5 x d = 5d kilometres.")+
   U("Forecasters estimate how far a storm will travel by multiplying its hourly distance by the hours."),
   [("d + 5 kilometres","You add 5 lots of d by multiplying, not by adding 5; the distance is 5d, not d + 5."),
    ("d/5 kilometres","Over more hours the storm goes farther, not less; the distance is 5d, not d divided by 5."),
    ("d kilometres","d is only one hour's distance; in 5 hours it is 5d kilometres.")]),

 ("AE","In the term 4xy, the variables present are:",
   "x and y",
   C("4xy is the number 4 multiplied by the two variables x and y.")+
   steps("Look at the term 4xy","the number 4 is the coefficient","the letters x and y are the variables.")+
   U("A term like 4xy could give the area of 4 tiles, each x by y, using both variables."),
   [("only 4","4 is the coefficient, a number, not a variable; the variables are x and y."),
    ("only x","y is a variable too; the term 4xy contains both x and y."),
    ("4 and x and y","4 is a constant number, not a variable; only x and y are the variables.")]),

 ("AE","The coefficient of the variable in the term −x is:",
   "−1",
   C("Writing -x is the same as -1 times x, so its coefficient is -1.")+
   steps("Read -x as -1 x x","the number multiplying x is -1","so the coefficient is -1.")+
   U("Recognising the hidden -1 is needed when you add terms like 3x and -x to get 2x."),
   [("1","The minus sign makes it -1, not +1; the coefficient of -x is -1."),
    ("0","If the coefficient were 0 the term would vanish; in -x it is -1."),
    ("x","x is the variable, not the coefficient; the coefficient of -x is the number -1.")]),

 ("AE","In the expression 3x + 4y + 5x, the like terms that can be combined are:",
   "3x and 5x",
   C("Like terms share the same variable; here 3x and 5x both contain x, while 4y is different.")+
   steps("Look for terms with the same variable","3x and 5x both have x","4y has a different variable, so the like terms are 3x and 5x.")+
   U("Spotting like terms lets you tidy 3x + 4y + 5x into 8x + 4y."),
   [("4y and 5x","4y has y and 5x has x — different variables, so they are not like terms; 3x and 5x are."),
    ("3x and 4y","3x has x and 4y has y, so they are unlike; the like terms are 3x and 5x."),
    ("all three terms","4y has a different variable from the x-terms; only 3x and 5x are like terms.")]),

 ("AE","Written in the shortest algebraic form, 'the product of a and b' is:",
   "ab",
   C("A product means multiplication, and in algebra a times b is written simply as ab.")+
   steps("'Product' means multiply","a multiplied by b","is written without a sign as ab.")+
   U("The area of a rectangle of sides a and b is written as the product ab."),
   [("a + b","a + b is the sum, not the product; the product of a and b is ab."),
    ("a - b","a - b is the difference; the product of a and b is ab."),
    ("a/b","a/b is a division; the product of a and b is written ab.")]),

 ("AE","The value of x² (x squared) when x = 5 is:",
   "25",
   C("x squared means x times x, so put 5 in for x and multiply it by itself.")+
   steps("x squared means x x x","replace x with 5: 5 x 5","that gives 25.")+
   U("The area of a square of side 5 is 5 x 5 = 25, the value of x squared."),
   [("10","10 is 5 + 5 or 5 x 2; x squared means 5 x 5 = 25."),
    ("7","7 is 5 + 2; x squared with x = 5 is 5 x 5 = 25."),
    ("52","52 just writes the digits together; 5 squared is 5 x 5 = 25.")]),

 ("AE","Three numbers have a mean (average) of m. Written algebraically, their total sum is:",
   "3m",
   C("The mean is the total shared among 3 numbers, so the total is 3 times the mean, 3m.")+
   steps("Mean = total / 3 = m","so total = 3 x mean","that gives a total of 3m.")+
   U("To find the total marks of 3 students from their average, you multiply the average by 3."),
   [("m/3","Dividing the mean by 3 makes it smaller; the total of 3 numbers is 3 x m = 3m."),
    ("m + 3","You scale the mean by 3 by multiplying, not adding; the total is 3m, not m + 3."),
    ("m","m is just the average of the three; their total is three times that, 3m.")]),

 ("AE","The expression for 'a number y multiplied by itself' is:",
   "y²",
   C("A number multiplied by itself is its square, written with a small 2, as y squared.")+
   steps("Take the number y","multiply it by itself: y x y","write this short as y squared, y².")+
   U("The area of a square of side y is y multiplied by itself, that is y squared."),
   [("2y","2y is y added to itself (y + y), not y times y; y multiplied by itself is y squared."),
    ("y + 2","y + 2 adds 2 to y; y multiplied by itself is y squared, y²."),
    ("y/2","y/2 halves y; y multiplied by itself is y squared.")]),

 ("AE","Removing the brackets, the expression 2(x + 3) is the same as:",
   "2x + 6",
   C("Multiplying a bracket by 2 means multiplying each term inside by 2.")+
   steps("2(x + 3) multiplies the bracket by 2","2 times x = 2x and 2 times 3 = 6","so it becomes 2x + 6.")+
   U("Buying 2 sets, each with x items plus 3 free, gives 2x + 6 items in all."),
   [("2x + 3","Only the x got doubled here; the 3 must be doubled too, giving 2x + 6."),
    ("x + 6","The x must also be multiplied by 2; the result is 2x + 6, not x + 6."),
    ("2x + 5","2 times 3 is 6, not 5; the expression becomes 2x + 6.")]),
]

# ---------- DATA HANDLING (25) — Maths (several fused with Science) ----------
DH = [
 ("DH","Information collected together in the form of numbers or facts, ready to be studied, is called:",
   "data",
   C("Data is the collection of numbers or facts you gather before you analyse them.")+
   steps("Collect numbers or facts about something","gather them together","this collection is called data.")+
   U("The daily temperatures a weather station notes down are an example of data."),
   [("a graph","A graph is a picture made from the numbers; the numbers themselves are the data."),
    ("a ruler","A ruler is a measuring tool; the measurements you collect are the data."),
    ("an average","An average is one number worked out from the figures; the figures themselves are data.")]),

 ("DH","The number you get by adding up all the values in a set and dividing by how many there are is the:",
   "mean (average)",
   C("The mean shares the total of all the values equally among them, giving the arithmetic average.")+
   steps("Add up all the values","count how many values there are","divide the total by that count to get the mean.")+
   U("A cricketer's batting average is the mean of the runs scored across the innings."),
   [("mode","The mode is the value that appears most often, not the total shared out, which is the mean."),
    ("range","The range is the spread from lowest to highest, not the average, which is the mean."),
    ("median","The median is the middle value in order; the total divided by the count is the mean.")]),

 ("DH","In a set of data, the value that occurs the greatest number of times is called the:",
   "mode",
   C("The mode is simply the most frequently occurring value in the data.")+
   steps("List how often each value appears","find the value that appears most often","that value is the mode.")+
   U("A shoe shop notes the mode of shoe sizes sold to know which size to stock most."),
   [("mean","The mean is the average of all values, not the one that appears most, which is the mode."),
    ("median","The median is the middle value in order; the most frequent value is the mode."),
    ("range","The range is the difference between highest and lowest; the most frequent value is the mode.")]),

 ("DH","When a set of values is arranged in order, the value lying right in the middle is called the:",
   "median",
   C("The median is the central value once the data is put in increasing (or decreasing) order.")+
   steps("Arrange the values in order","find the value in the very middle","that middle value is the median.")+
   U("Reporting the median income tells you the middle earner, unswayed by a few very large salaries."),
   [("mean","The mean is the average of all values; the middle value in order is the median."),
    ("mode","The mode is the most frequent value; the central value in order is the median."),
    ("range","The range is the spread of the data; the central value in order is the median.")]),

 ("DH","The mean of the three numbers 4, 6 and 8 is:",
   "6",
   C("Add the numbers and divide by how many there are: 3 numbers here.")+
   steps("Add: 4 + 6 + 8 = 18","there are 3 numbers, so divide by 3","18 / 3 = 6, the mean.")+
   U("Averaging three test scores this way gives a single fair mark."),
   [("18","18 is the total, not the mean; you must still divide by 3 to get 6."),
    ("9","9 would be 18 / 2; there are 3 numbers, so divide by 3 to get 6."),
    ("4","4 is just the smallest value, not the mean; the mean is 18 / 3 = 6.")]),

 ("DH","Wind speeds on five days were 20, 30, 40, 50 and 60 km/h. Their mean (average) wind speed was:",
   "40 km/h",
   C("Add the five wind speeds and divide by 5 to find the average.")+
   steps("Add: 20 + 30 + 40 + 50 + 60 = 200","there are 5 days, so divide by 5","200 / 5 = 40 km/h.")+
   U("A weather report gives the average wind speed for the week worked out exactly like this."),
   [("200 km/h","200 is the total of all five speeds; the mean divides it by 5, giving 40."),
    ("60 km/h","60 is the highest single speed, not the average, which is 200 / 5 = 40."),
    ("50 km/h","50 is just one day's speed; the mean of all five is 200 / 5 = 40 km/h.")]),

 ("DH","A bar graph shows and compares data using the heights or lengths of its:",
   "bars",
   C("In a bar graph the size of each bar stands for the size of the quantity it represents.")+
   steps("Each item is drawn as a bar","the taller or longer the bar, the bigger the quantity","so we read and compare the data from the bars.")+
   U("A bar graph of rainfall lets you see at a glance which month was wettest by the tallest bar."),
   [("colours only","While bars may be coloured, it is their length that shows the quantity, not the colour alone."),
    ("titles","A title names the graph; the data is shown by the lengths of the bars."),
    ("dots","Dots belong to other charts; a bar graph shows data with the lengths of bars.")]),

 ("DH","The difference between the highest value and the lowest value in a set of data is called the:",
   "range",
   C("The range measures how spread out the data is, from the smallest value to the largest.")+
   steps("Find the highest value and the lowest value","subtract the lowest from the highest","that difference is the range.")+
   U("The range of temperatures in a day tells you how much hotter noon was than dawn."),
   [("mean","The mean is the average value, not the spread; the highest minus the lowest is the range."),
    ("mode","The mode is the most frequent value; the spread from lowest to highest is the range."),
    ("median","The median is the middle value; the difference between the extremes is the range.")]),

 ("DH","During a cyclone the strongest gust was 120 km/h and the weakest 40 km/h. The range of the gust speeds was:",
   "80 km/h",
   C("The range is the highest gust minus the lowest gust.")+
   steps("Highest gust = 120 km/h, lowest = 40 km/h","range = highest - lowest = 120 - 40","that gives 80 km/h.")+
   U("Scientists quote the range of gust speeds to show how variable a storm's winds were."),
   [("160 km/h","160 adds the two speeds; the range is their difference, 120 - 40 = 80 km/h."),
    ("120 km/h","120 is the highest gust itself, not the range, which is 120 - 40 = 80 km/h."),
    ("40 km/h","40 is the lowest gust; the range is the difference, 120 - 40 = 80 km/h.")]),

 ("DH","The mode of the data set 2, 3, 3, 5 and 7 is:",
   "3",
   C("The mode is the value that appears most often, and here 3 appears twice while the others appear once.")+
   steps("Count how often each value appears","3 appears twice, the others once each","so the mode is 3.")+
   U("Finding the most common value, the mode, tells a shop its best-selling item."),
   [("7","7 is the largest value, not the most frequent; 3 appears most, so the mode is 3."),
    ("5","5 appears only once; the value appearing most often is 3, so the mode is 3."),
    ("2","2 appears only once; the most frequent value is 3, so the mode is 3.")]),

 ("DH","The mean of the first five counting numbers 1, 2, 3, 4 and 5 is:",
   "3",
   C("Add the five numbers and divide by 5.")+
   steps("Add: 1 + 2 + 3 + 4 + 5 = 15","there are 5 numbers, so divide by 5","15 / 5 = 3, the mean.")+
   U("Averaging a short run of numbers like this is the simplest use of the mean."),
   [("15","15 is the total of the numbers; the mean divides it by 5, giving 3."),
    ("5","5 is just the largest number, not the mean; the mean is 15 / 5 = 3."),
    ("2.5","2.5 would be 15 / 6; there are only 5 numbers, so 15 / 5 = 3.")]),

 ("DH","A home used 5, 5, 6 and 8 units of electricity on four days. The mean daily use was:",
   "6 units",
   C("Add the four daily readings and divide by 4 to find the average daily use.")+
   steps("Add: 5 + 5 + 6 + 8 = 24","there are 4 days, so divide by 4","24 / 4 = 6 units.")+
   U("An electricity bill is often understood through the average daily units used, found this way."),
   [("24 units","24 is the total for the four days; the mean divides it by 4, giving 6."),
    ("8 units","8 is the highest single day's use, not the average, which is 24 / 4 = 6."),
    ("5 units","5 is just one common reading; the mean of all four is 24 / 4 = 6 units.")]),

 ("DH","A number that measures how likely an event is to happen, always between 0 and 1, is called its:",
   "probability",
   C("Probability puts a number from 0 to 1 on how likely an event is, with 0 impossible and 1 certain.")+
   steps("Think of how likely an event is","give it a number from 0 (never) to 1 (sure)","that number is its probability.")+
   U("A weather forecast saying 'a 0.7 chance of rain' is quoting a probability."),
   [("range","The range measures the spread of data, not the likelihood of an event, which is its probability."),
    ("mean","The mean is an average value; the chance of an event is its probability."),
    ("mode","The mode is the most frequent value; the likelihood of an event is its probability.")]),

 ("DH","When a fair coin is tossed once, the probability of getting heads is:",
   "1/2",
   C("A coin has two equally likely results, heads or tails, so heads has 1 chance out of 2.")+
   steps("There are 2 equally likely outcomes: heads or tails","heads is 1 of these 2","so the probability of heads is 1/2.")+
   U("Calling 'heads or tails' to start a match relies on this even 1/2 chance."),
   [("1","A probability of 1 means certain; heads is not certain, its probability is 1/2."),
    ("0","A probability of 0 means impossible; heads can happen, so its probability is 1/2."),
    ("2","Probability never exceeds 1; the chance of heads is 1/2, not 2.")]),

 ("DH","A graph that draws two bars side by side for each item is especially useful for:",
   "comparing two sets of data",
   C("A double bar graph places two bars together for each category, making it easy to compare two data sets.")+
   steps("For each item, draw two bars side by side","each bar stands for a different data set","this lets you compare the two sets at a glance.")+
   U("A double bar graph comparing rainfall in two cities month by month shows which is wetter."),
   [("hiding the data","A graph reveals data, it does not hide it; a double bar graph compares two sets."),
    ("measuring time only","Time is not its purpose; a double bar graph is for comparing two sets of data."),
    ("drawing circles","Circles belong to a pie chart; side-by-side bars compare two sets of data.")]),

 ("DH","Arranged in order, the median of the five values 3, 5, 7, 9 and 11 is:",
   "7",
   C("With five values already in order, the median is the third one, sitting right in the middle.")+
   steps("The values 3, 5, 7, 9, 11 are in order","there are 5 values, so the middle is the 3rd","the 3rd value is 7, the median.")+
   U("Picking the middle value, the median, gives a typical figure not pulled by extremes."),
   [("5","5 is the 2nd value, not the middle; with 5 values the median is the 3rd, which is 7."),
    ("9","9 is the 4th value; the middle of five values is the 3rd, which is 7."),
    ("11","11 is the largest value, not the middle; the median here is 7.")]),

 ("DH","Records show that a town was hit by a cyclone in 2 of the last 10 years. The probability of a cyclone in a year is about:",
   "1/5",
   C("Two cyclone years out of ten is the fraction 2/10, which simplifies to 1/5.")+
   steps("Cyclone years = 2 out of 10","write the probability 2/10","simplify by dividing by 2 to get 1/5.")+
   U("Insurers estimate the chance of a storm hitting a place using past records exactly like this."),
   [("2/1","2/1 turns the fraction upside down; the probability is 2 out of 10, that is 1/5."),
    ("1/2","1/2 would be 5 cyclone years out of 10; only 2 occurred, giving 1/5."),
    ("10/2","10/2 reverses the fraction; the probability is 2/10, which simplifies to 1/5.")]),

 ("DH","In a set of data, the number of times a particular value appears is called its:",
   "frequency",
   C("The frequency of a value tells you how many times that value shows up in the data.")+
   steps("Pick one value in the data","count how many times it appears","that count is its frequency.")+
   U("A tally chart records the frequency of each score so you can see which came up most."),
   [("range","The range is the spread from lowest to highest, not how often a value appears, which is its frequency."),
    ("mean","The mean is the average value, not the count of how often one value occurs, the frequency."),
    ("median","The median is the middle value; how often a value appears is its frequency.")]),

 ("DH","For the even-sized set 2, 4, 6 and 8, the median is the mean of the two middle values, which is:",
   "5",
   C("With an even count there is no single middle, so the median is the average of the two central values.")+
   steps("In order, the two middle values are 4 and 6","take their mean: (4 + 6) / 2","that gives 5, the median.")+
   U("When a class has an even number of students, the median mark is found this same way."),
   [("4","4 is only the lower of the two middle values; the median averages 4 and 6 to give 5."),
    ("6","6 is only the upper middle value; the median is the mean of 4 and 6, which is 5."),
    ("20","20 is the total of all four values; the median is the mean of the two middle ones, which is 5.")]),

 ("DH","A fan ran for 4, 4, 5 and 6 hours on four days. The mode of these running hours is:",
   "4 hours",
   C("The mode is the most frequent value, and 4 hours appears twice while the others appear once.")+
   steps("Count how often each value appears","4 hours appears twice, the rest once each","so the mode is 4 hours.")+
   U("Knowing the most common running time, the mode, helps estimate a typical day's use."),
   [("6 hours","6 is the largest value, not the most frequent; 4 appears most, so the mode is 4."),
    ("5 hours","5 appears only once; the value appearing most often is 4 hours."),
    ("19 hours","19 is the total of all four days, not the mode; the most frequent value is 4 hours.")]),

 ("DH","The mean of the four numbers 10, 20, 30 and 40 is:",
   "25",
   C("Add the four numbers and divide by 4.")+
   steps("Add: 10 + 20 + 30 + 40 = 100","there are 4 numbers, so divide by 4","100 / 4 = 25, the mean.")+
   U("Averaging four monthly readings this way gives a single representative figure."),
   [("100","100 is the total of the numbers; the mean divides it by 4, giving 25."),
    ("40","40 is the largest value, not the mean; the mean is 100 / 4 = 25."),
    ("30","30 is just one of the values; the mean of all four is 100 / 4 = 25.")]),

 ("DH","The probability of an event that is absolutely certain to happen is:",
   "1",
   C("A sure event always happens, so it sits at the very top of the scale, with probability 1.")+
   steps("Probabilities run from 0 to 1","an event certain to happen is at the top","so its probability is 1.")+
   U("The probability that the Sun will set today is 1 — it is certain."),
   [("0","A probability of 0 means impossible, the opposite of certain; a sure event has probability 1."),
    ("1/2","1/2 is an even chance, like a coin; a certain event has probability 1."),
    ("100","Probability never goes above 1; a certain event has probability 1, not 100.")]),

 ("DH","The probability of an event that can never possibly happen is:",
   "0",
   C("An impossible event never happens, so it sits at the very bottom of the scale, with probability 0.")+
   steps("Probabilities run from 0 to 1","an event that cannot happen is at the bottom","so its probability is 0.")+
   U("The probability of rolling a 7 on an ordinary six-faced dice is 0 — it cannot happen."),
   [("1","A probability of 1 means certain, the opposite of impossible; an impossible event has probability 0."),
    ("1/2","1/2 is an even chance; an event that can never happen has probability 0."),
    ("-1","Probability is never negative; an impossible event has probability 0.")]),

 ("DH","Rain fell on three days, totalling 90 mm. The mean (average) daily rainfall over those days was:",
   "30 mm",
   C("Share the total rainfall equally over the three days to find the average.")+
   steps("Total rainfall = 90 mm over 3 days","mean = total / number of days = 90 / 3","that gives 30 mm.")+
   U("A weather report gives the average daily rainfall of a spell worked out exactly this way."),
   [("90 mm","90 mm is the total for all three days; the mean divides it by 3, giving 30 mm."),
    ("270 mm","270 multiplies the total by 3; the mean divides by 3, giving 30 mm."),
    ("3 mm","3 is the number of days, not the average rainfall, which is 90 / 3 = 30 mm.")]),

 ("DH","When every observation is added up and the total is divided by the number of observations, the result is the:",
   "mean (arithmetic average)",
   C("Adding all values and dividing by their count is exactly the recipe for the mean.")+
   steps("Add up every observation","count how many observations there are","divide the total by the count to get the mean.")+
   U("Working out a class's average height uses this very rule for the mean."),
   [("mode","The mode is the most frequent value, not the total divided by the count, which is the mean."),
    ("range","The range is the difference between the largest and smallest values, not the mean."),
    ("median","The median is the middle value in order; the total divided by the count is the mean.")]),
]

# ---------- assemble: interleave so no two consecutive share a chapter ----------
assert all(len(b) == 25 for b in (WS, EC, AE, DH)), [len(WS), len(EC), len(AE), len(DH)]
items = []
for i in range(25):
    items += [WS[i], EC[i], AE[i], DH[i]]
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

    keydist = build_paper(PNUM, TITLE, SHORT, LABELS, items, seed=42023,
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
    split = "/".join(str(counts[c]) for c in ("WS", "EC", "AE", "DH"))
    with open("PAPERS_MANIFEST.md", "a", encoding="utf-8") as fh:
        fh.write(f"| {PNUM} | 2026-06-18 | {TITLE} | {split} | ✓ |\n")

    # ---- update QUESTION_INDEX.json ----
    idx["fingerprints"] = sorted(existing | set(new_fps))
    idx.setdefault("combos", []).append({
        "paper": PNUM,
        "chapters": ["Winds, Storms & Cyclones",
                     "Electric Current & its Effects",
                     "Algebraic Expressions",
                     "Data Handling"],
    })
    idx["papers"] = idx.get("papers", 0) + 1
    with open(idx_path, "w", encoding="utf-8") as fh:
        json.dump(idx, fh, ensure_ascii=False, indent=2)
        fh.write("\n")

    print("Files:", sorted(v for v in moves.values()))
    print("Answer key spread A/B/C/D =", dict(keydist))
    print("Fingerprints added:", len(new_fps))
