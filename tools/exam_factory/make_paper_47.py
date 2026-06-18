# -*- coding: utf-8 -*-
# Boss Challenge Paper 47 — Heat · Electric Current & its Effects ·
# Simple Equations · Symmetry
# Content-only. Uses the dependency-free examfactory engine.
# Difficulty ramp: leans hard into FUSION. A rise in temperature becomes a
# SIMPLE-EQUATION solve; cells joined in series become a "find x volts"
# equation; the turns on an electromagnet become an unknown to solve for;
# a heating coil's symmetric layout and a clock face become SYMMETRY problems.
# The child meets a Science situation and reaches for a Maths skill.
# Class-7 scope, simple wording, hard thinking.
# Produces, under Resources/BossChallengePapers/:
#   Paper_47_<SHORT>_QuestionPaper.html  (pure HTML — questions + options)
#   Paper_47_<SHORT>_QuestionPaper.pdf
#   Paper_47_<SHORT>_Questions.md
#   Paper_47_<SHORT>_Solutions.html
import os, sys, shutil, json, re
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from examfactory import build_paper, C, steps, U

PNUM  = "47"
SHORT = "Heat_ElectricCurrent_SimpleEquations_Symmetry"
TITLE = ("Heat · Electric Current & its Effects · "
         "Simple Equations · Symmetry")
LABELS = {
    "HT": "Heat",
    "EC": "Electric Current & its Effects",
    "SE": "Simple Equations",
    "SY": "Symmetry",
}

# ---------- HEAT (25) — Science (several fused with simple equations) ----------
HT = [
 ("HT","Heat always flows on its own from a hotter body to a colder one until both reach the:",
   "same temperature (thermal balance)",
   C("Heat moves spontaneously from hot to cold. The flow stops when both bodies share one temperature — a state of thermal balance (equilibrium).")+
   steps("Place a hot spoon in cool water","heat leaves the spoon and enters the water","flow stops when both sit at one common temperature.")+
   U("A cup of hot tea left on the table slowly cools to room temperature, then stops changing."),
   [("colder body's freezing point","Heat does not chase a freezing point; it flows until the two bodies share one temperature."),
    ("hotter body's boiling point","Nothing pushes the cooler body up to a boiling point; the two simply meet at a common temperature."),
    ("temperature of the Sun","The Sun is irrelevant to two bodies in a room; they settle at a shared temperature between their starting values.")]),

 ("HT","The everyday unit used to state how hot or cold something is, written like 37°C, is the:",
   "degree Celsius",
   C("Temperature is most often measured in degrees Celsius (°C). Water freezes at 0°C and boils at 100°C at normal pressure.")+
   steps("Hotness is measured by a thermometer","its common scale is marked in degrees Celsius","so the unit is the degree Celsius (°C).")+
   U("A weather report saying '32°C today' is using the degree Celsius scale."),
   [("metre","A metre measures length, not how hot something is; temperature uses the degree Celsius."),
    ("kilogram","A kilogram measures mass; the hotness of a body is given in degrees Celsius."),
    ("second","A second measures time; temperature is read off in degrees Celsius.")]),

 ("HT","The thermometer a doctor uses to measure body temperature, marked roughly from 35°C to 42°C, is the:",
   "clinical thermometer",
   C("A clinical thermometer is built to read the narrow range of human body temperature (about 35–42°C) and has a kink to hold the reading.")+
   steps("You need body temperature, near 37°C","the instrument with a 35–42°C scale and a kink","is the clinical thermometer.")+
   U("A nurse shakes down a clinical thermometer before tucking it under the tongue."),
   [("laboratory thermometer","A laboratory thermometer reads a wide range like −10°C to 110°C; the body-temperature one is the clinical thermometer."),
    ("maximum-minimum thermometer","That weather instrument records daily highs and lows, not a patient's body temperature."),
    ("kitchen oven thermometer","An oven thermometer reads very high cooking temperatures, far above the human-body range.")]),

 ("HT","On a clinical thermometer, a healthy person's normal body temperature reads close to:",
   "37°C",
   C("A healthy human body sits at roughly 37°C (98.6°F). A clinical thermometer is centred on this value.")+
   steps("Recall the normal body reading","it is close to 37 on the Celsius scale","so normal body temperature is about 37°C.")+
   U("A reading well above 37°C usually means the person has a fever."),
   [("0°C","0°C is the freezing point of water, far too cold for a living body, which sits near 37°C."),
    ("100°C","100°C is the boiling point of water; a body at that temperature could not survive — normal is 37°C."),
    ("50°C","50°C is hotter than a healthy body ever runs; the normal value is about 37°C.")]),

 ("HT","The transfer of heat through a solid metal rod, passed on from particle to particle without the particles travelling, is called:",
   "conduction",
   C("Conduction passes heat along a solid as neighbouring particles vibrate and hand energy on; the particles themselves stay put.")+
   steps("Heat one end of a metal rod","its particles vibrate more and jostle the next ones","energy travels along while particles stay in place — conduction.")+
   U("The far end of a metal spoon left in hot soup soon turns warm by conduction."),
   [("convection","Convection carries heat by the actual movement of a fluid; through a solid rod the mechanism is conduction."),
    ("radiation","Radiation needs no material at all and travels as waves; passing heat along a solid rod is conduction."),
    ("evaporation","Evaporation is liquid turning to vapour, a cooling effect, not the way heat moves along a metal rod.")]),

 ("HT","In liquids and gases, heat is carried mainly by the actual movement of the warmed fluid itself. This way of transferring heat is:",
   "convection",
   C("In convection the heated fluid expands, becomes lighter and rises, while cooler fluid sinks to take its place, setting up a current that carries heat.")+
   steps("Warm the water at the bottom of a pan","hot water rises, cool water sinks to replace it","this circulating current spreads heat — convection.")+
   U("A room heater warms the whole room as warm air rises and cool air flows back down — convection."),
   [("conduction","Conduction passes heat without the material moving; in a flowing liquid or gas the carrier is convection."),
    ("radiation","Radiation travels as waves through empty space; the rising-and-sinking of a fluid is convection."),
    ("reflection","Reflection is the bouncing back of light; heat carried by a moving fluid is convection.")]),

 ("HT","The heat of the Sun reaches the Earth across empty space (no air in between). This transfer without any medium is:",
   "radiation",
   C("Radiation carries heat as electromagnetic waves and needs no material medium, which is how the Sun's heat crosses the vacuum of space to us.")+
   steps("Between the Sun and Earth there is mostly empty space","yet the heat still arrives","so it must travel as radiation, which needs no medium.")+
   U("You feel the warmth of a campfire on your face before the air around you heats up — that is radiation."),
   [("conduction","Conduction needs particles in contact; the near-vacuum between Sun and Earth rules it out, leaving radiation."),
    ("convection","Convection needs a fluid to circulate; empty space has none, so the heat arrives by radiation."),
    ("boiling","Boiling is a liquid turning to gas; it is not how the Sun's heat crosses space — that is radiation.")]),

 ("HT","Metals such as copper and aluminium let heat pass through them easily. Such materials are called:",
   "good conductors of heat",
   C("Good conductors (mostly metals) let heat flow through them quickly; poor conductors, called insulators, slow heat down.")+
   steps("Touch a metal handle left near a flame — it heats fast","metals let heat pass quickly","so metals are good conductors of heat.")+
   U("Cooking pots are made of metal so heat from the flame reaches the food quickly."),
   [("good insulators of heat","Insulators slow heat down; metals let heat through fast, so they are conductors, not insulators."),
    ("non-metals only","Most good heat conductors are metals, not non-metals; wood and plastic (non-metals) are insulators."),
    ("transparent to light","Letting light through is unrelated to heat flow; metals conduct heat well but are not transparent.")]),

 ("HT","Woollen clothes keep us warm in winter mainly because wool:",
   "traps air, which is a poor conductor of heat",
   C("Wool fibres trap pockets of air. Air is a poor conductor, so the trapped air slows the escape of body heat, keeping us warm.")+
   steps("Wool holds many tiny air pockets","air conducts heat poorly","so body heat is held in and we stay warm.")+
   U("Two thin sweaters can be warmer than one thick one because they trap an extra layer of air between them."),
   [("produces its own heat","Wool makes no heat of its own; it keeps us warm by trapping insulating air, slowing heat loss."),
    ("is a good conductor of heat","If wool conducted heat well, body heat would escape fast; it keeps us warm because the trapped air is a poor conductor."),
    ("reflects sunlight onto the body","Warmth in winter comes from trapping body heat with air pockets, not from reflecting sunlight.")]),

 ("HT","During the day at the coast, the cool breeze that blows from the sea towards the land is called the:",
   "sea breeze",
   C("By day the land heats faster than the sea; air over land rises and cooler air flows in from the sea — a sea breeze, an example of convection.")+
   steps("Daytime: land warms quicker than the sea","warm air over land rises, cool sea air flows in to replace it","this onshore wind is the sea breeze.")+
   U("People on a beach feel a refreshing sea breeze blowing inland on a hot afternoon."),
   [("land breeze","A land breeze blows from land to sea at night, when the land cools faster; the daytime onshore wind is the sea breeze."),
    ("monsoon wind","A monsoon is a seasonal large-scale wind; the daily daytime onshore coastal wind is the sea breeze."),
    ("trade wind","Trade winds are steady planet-wide winds; the local daytime coastal breeze off the sea is the sea breeze.")]),

 ("HT","Two identical metal cans, one painted dull black and one shiny white, are left in the Sun. The one that warms up faster is the:",
   "dull black can",
   C("Dark, dull surfaces absorb radiant heat better than light, shiny ones, so the black can heats up faster in the Sun.")+
   steps("Dark surfaces are better absorbers of heat radiation","the black can soaks up more of the Sun's heat","so it warms faster than the shiny white can.")+
   U("Wearing dark clothes on a sunny day feels hotter because dark cloth absorbs more heat."),
   [("shiny white can","Shiny, light surfaces reflect heat away and absorb less, so the white can warms more slowly, not faster."),
    ("both warm at exactly the same rate","Surface colour matters: the dull black surface absorbs more heat, so it warms faster than the shiny white one."),
    ("neither warms at all","Both absorb some heat in the Sun; the dull black can simply absorbs more and warms faster.")]),

 ("HT","Cooking pans are given handles made of wood or plastic because these materials are:",
   "poor conductors (insulators) of heat",
   C("Wood and plastic conduct heat poorly, so a handle made of them stays cool enough to hold while the metal pan is hot.")+
   steps("The metal pan gets very hot on the flame","wood and plastic conduct heat poorly","so the handle stays cool and is safe to grip.")+
   U("A frying pan with a plastic handle can be lifted bare-handed even when the metal base is sizzling."),
   [("good conductors of heat","A good-conductor handle would turn scalding hot; handles use poor conductors so they stay cool."),
    ("able to make their own heat","Handles make no heat; they stay cool because wood and plastic are poor conductors."),
    ("heavier than the metal pan","Weight is not the reason; the point is that wood and plastic are poor conductors and stay cool to hold.")]),

 ("HT","The liquid inside a common thermometer rises up the thin tube when heated because the liquid:",
   "expands on heating",
   C("Liquids expand when heated. The thermometer liquid expands and is pushed up the narrow tube; the height it reaches shows the temperature.")+
   steps("Heat reaches the bulb of liquid","the liquid expands and has nowhere to go but up the thin tube","the higher it rises, the higher the temperature.")+
   U("On a hot day the thermometer's thread of liquid climbs higher up the scale."),
   [("shrinks on heating","Liquids expand, not shrink, when heated; the rise up the tube is caused by expansion."),
    ("turns into a gas","The thermometer liquid does not boil away in normal use; it simply expands and rises."),
    ("changes colour with heat","The reading comes from the liquid level rising as it expands, not from any colour change.")]),

 ("HT","A clinical thermometer has a small kink (a narrow bend) just above the bulb. Its job is to:",
   "stop the liquid from slipping back so you can read the value after removing it",
   C("The kink traps the thread of liquid in place, so the reading does not fall back when the thermometer leaves the body — letting the doctor read it calmly.")+
   steps("After measuring, the thermometer is taken out and cools","without the kink the liquid would slide back at once","the kink holds the thread so the reading stays put to be read.")+
   U("You can take a clinical thermometer out of the mouth and read it a moment later because the kink holds the reading."),
   [("make the liquid rise faster","The kink does not speed the rise; it holds the reading in place after the thermometer is removed."),
    ("change Celsius into Fahrenheit","The kink does no unit conversion; it simply traps the liquid so the reading does not drop back."),
    ("store extra liquid for high fevers","The kink is not a reservoir; its purpose is to hold the thread so the reading can be read after removal.")]),

 ("HT","A laboratory thermometer is usually marked over a wide range such as:",
   "−10°C to 110°C",
   C("A laboratory thermometer covers a broad range (about −10°C to 110°C) so it can read temperatures from below freezing to above the boiling point of water.")+
   steps("Lab work spans freezing to boiling water and beyond","so the scale must run wide","about −10°C to 110°C.")+
   U("Measuring the temperature of boiling water (100°C) needs a laboratory thermometer, not a clinical one."),
   [("35°C to 42°C","That narrow range belongs to the CLINICAL thermometer for body temperature; the lab one runs much wider."),
    ("0°C to 5°C only","Such a tiny range would be useless for most experiments; a lab thermometer runs roughly −10°C to 110°C."),
    ("200°C to 500°C","That very high range is for furnaces; an ordinary laboratory thermometer reads about −10°C to 110°C.")]),

 ("HT","You should NOT use a clinical thermometer to measure the temperature of boiling water because:",
   "its scale stops near 42°C, far below water's boiling point of 100°C",
   C("A clinical thermometer only reads up to about 42°C; boiling water at 100°C is far beyond its scale and could even burst the tube.")+
   steps("Boiling water is about 100°C","a clinical thermometer reads only up to about 42°C","so it cannot measure boiling water — use a laboratory thermometer.")+
   U("To check the temperature of boiling water in the lab, a student picks a laboratory thermometer, not a clinical one."),
   [("clinical thermometers cannot touch water at all","They can touch water; the real problem is their scale ends near 42°C, far below boiling water's 100°C."),
    ("boiling water is colder than the body","Boiling water (100°C) is far HOTTER than the body (37°C); the clinical scale simply does not reach that high."),
    ("the kink melts in warm water","The kink does not melt in warm water; the issue is the 42°C scale limit versus boiling water's 100°C.")]),

 ("HT","On a sunny day you stay cooler in white clothes than in dark ones because light-coloured cloth:",
   "reflects most of the heat falling on it",
   C("Light, shiny colours reflect heat radiation and absorb little, so white clothes keep you cooler than dark ones, which absorb more.")+
   steps("White cloth reflects most of the Sun's heat","less heat is absorbed by the cloth and your body","so you feel cooler than in dark clothes.")+
   U("People in hot deserts often wear white or light robes to reflect the fierce sunlight."),
   [("makes its own cool air","Cloth cannot make cool air; white cloth keeps you cooler by reflecting heat away."),
    ("absorbs more heat than dark cloth","White cloth absorbs LESS heat than dark cloth; that is exactly why it feels cooler."),
    ("blocks all light from reaching you","White cloth reflects heat but does not block all light; the cooling comes from reflecting heat, not total darkness.")]),

 ("HT","The temperature of some water rises from 25°C to a final value of t°C, a total rise of 30°C. Writing the equation 25 + 30 = t, the final temperature t is:",
   "55°C",
   C("Set up the simple equation for the rise: final = start + rise, so t = 25 + 30 = 55. The water ends at 55°C.")+
   steps("Equation: 25 + 30 = t","add the start and the rise: 25 + 30 = 55","so t = 55°C.")+
   U("Heating bath water from 25°C by 30°C brings it to a warm 55°C."),
   [("5°C","5 comes from subtracting (30 − 25); the temperature ROSE, so final = 25 + 30 = 55°C."),
    ("30°C","30°C is the size of the rise, not the final reading; add it to 25°C to get 55°C."),
    ("750°C","750 multiplies 25 × 30; a rise is ADDED, giving 25 + 30 = 55°C.")]),

 ("HT","A metal block is heated so its temperature goes from x°C up by 40°C to reach 95°C. Solving x + 40 = 95, the starting temperature x was:",
   "55°C",
   C("Solve the simple equation x + 40 = 95. Subtract 40 from both sides: x = 95 − 40 = 55, so it started at 55°C.")+
   steps("Equation: x + 40 = 95","subtract 40 from both sides: x = 95 − 40","x = 55°C.")+
   U("If a workshop tells you a part ended at 95°C after a 40°C rise, it began the heating at 55°C."),
   [("135°C","135 ADDS 40 to 95; to undo a rise of 40 you SUBTRACT, giving 95 − 40 = 55°C."),
    ("40°C","40°C is the rise, not the start; solving x + 40 = 95 gives the start as 55°C."),
    ("95°C","95°C is the FINAL temperature; the starting value x is 95 − 40 = 55°C.")]),

 ("HT","A bimetallic strip (two different metals joined together) bends when heated because the two metals:",
   "expand by different amounts",
   C("The two metals expand by different amounts for the same heating, so the strip curves towards the side that expands less.")+
   steps("Heat the joined strip of two metals","one metal expands more than the other","the unequal expansion makes the strip bend.")+
   U("A bimetallic strip is used in a thermostat to switch a heater off when it bends at a set temperature."),
   [("both refuse to expand at all","Metals do expand on heating; the bending happens because the two expand by DIFFERENT amounts."),
    ("turn into liquid metal","The strip does not melt during normal heating; it bends because the two metals expand unequally."),
    ("lose their colour","Colour change is not the cause; the strip bends due to the two metals' different expansion.")]),

 ("HT","While water is heated in a pan, the hotter water at the bottom rises and cooler water sinks, forming:",
   "convection currents",
   C("Heated water at the bottom expands, becomes lighter and rises; cooler water sinks to replace it. This circulating flow is a convection current.")+
   steps("Bottom water is heated first and expands","being lighter, it rises while cool water sinks","the looping flow is a convection current.")+
   U("Tea leaves swirling round and round in a heating pan trace the convection currents in the water."),
   [("conduction currents","'Conduction currents' is not a real term; the circulating flow of heated water is a convection current."),
    ("radiation beams","Radiation travels as waves and does not circulate the water; the rising-and-sinking flow is convection."),
    ("electric currents","No electricity is involved in a pan of heating water; the moving warm water forms convection currents.")]),

 ("HT","Tungsten metal is chosen for the filament of an electric bulb partly because, where heat is concerned, it has a:",
   "very high melting point",
   C("A bulb filament glows white-hot, so it must be a metal that does not melt at such heat — tungsten has a very high melting point.")+
   steps("The filament must get extremely hot to glow","a low-melting metal would melt and break","tungsten survives because its melting point is very high.")+
   U("Tungsten filaments can glow for hours without melting, which is why old bulbs used them."),
   [("very low melting point","A low-melting metal would melt the moment it glowed; tungsten is chosen for its HIGH melting point."),
    ("habit of staying cold","A glowing filament is white-hot, not cold; tungsten is picked because it withstands that heat without melting."),
    ("strong smell when heated","Smell is irrelevant to a sealed bulb; tungsten is used for its very high melting point.")]),

 ("HT","Heat from a room heater spreads to warm the whole room mainly by:",
   "convection of the air",
   C("Air near the heater warms, expands, rises and is replaced by cooler air, setting up convection currents that spread warmth around the room.")+
   steps("Air by the heater warms and rises","cooler air moves in below and is warmed in turn","these circulating air currents warm the whole room by convection.")+
   U("A heater placed low in a room warms it well because the warm air rises and circulates by convection."),
   [("conduction through the air","Air is a poor conductor; a room is warmed mainly by the MOVEMENT of warm air, which is convection."),
    ("the air turning into water","Air does not turn into water when warmed; the room heats by convection currents in the air."),
    ("light reflecting off the walls","Reflected light does not warm a room; circulating warm air (convection) does the job.")]),

 ("HT","When you hold a metal spoon and a wooden spoon, both at room temperature, the metal one feels colder. This is because the metal:",
   "conducts heat away from your hand faster",
   C("Metal is a good conductor, so it draws heat from your warm hand quickly, making it feel colder; wood conducts poorly, so it feels less cold.")+
   steps("Both spoons are at the same room temperature","metal conducts heat fast, pulling warmth from your hand","that quick heat loss makes the metal feel colder.")+
   U("A metal railing on a winter morning feels far colder than a wooden one at the same temperature."),
   [("is actually at a lower temperature","Both are at the same room temperature; the metal only FEELS colder because it conducts heat from your hand faster."),
    ("makes its own cold","Nothing makes 'cold'; the metal simply conducts heat away from your hand quickly, so it feels colder."),
    ("reflects heat back into your hand","Metal draws heat AWAY from your hand by conduction; that is why it feels cold, not warm.")]),

 ("HT","At night by the sea, the breeze blows from the land towards the sea. This land breeze forms because, after sunset, the:",
   "land cools faster than the sea",
   C("Land loses heat faster than water, so at night the air over the sea stays warmer and rises, drawing cooler air out from the land — a land breeze.")+
   steps("After sunset the land cools quicker than the sea","warm air over the sea rises, cooler land air flows out to replace it","this offshore wind is the land breeze.")+
   U("Fishing boats often set out at night helped by the land breeze blowing them towards the sea."),
   [("sea cools faster than the land","Water actually cools SLOWER than land; because the land cools faster at night, the breeze blows out to sea."),
    ("Sun heats the land at night","There is no Sun at night; the land breeze forms because the land cools faster after sunset."),
    ("land makes its own wind","Wind is not 'made' by the land; the land breeze arises from the land cooling faster than the sea.")]),
]

# ---------- ELECTRIC CURRENT & ITS EFFECTS (25) — Science (several fused) ----------
EC = [
 ("EC","When an electric current passes through a wire, the wire becomes hot. This is known as the:",
   "heating effect of electric current",
   C("Current flowing through a wire makes it warm or hot — the heating effect of electric current — used in heaters, toasters and bulbs.")+
   steps("Pass a current through a thin wire","the wire heats up","this warming is the heating effect of electric current.")+
   U("The glowing coil of an electric heater is the heating effect of current at work."),
   [("magnetic effect of electric current","The magnetic effect makes a wire act like a magnet; the WARMING of the wire is the heating effect."),
    ("chemical effect of electric current","The chemical effect causes reactions like electroplating; a wire getting hot is the heating effect."),
    ("lighting effect of current","There is no separate 'lighting effect'; a bulb lights because the heating effect makes its filament glow.")]),

 ("EC","An electric bulb lights up because the current heats its thin filament until it becomes:",
   "white-hot and glows, giving out light",
   C("The heating effect makes the bulb's thin tungsten filament so hot that it glows white-hot and emits light.")+
   steps("Current flows through the thin filament","the filament heats up strongly (heating effect)","it becomes white-hot and glows, giving light.")+
   U("Switch on an old bulb and you can see the filament glow brightly as it heats."),
   [("cold and shiny","A cold filament cannot glow; the bulb lights only because the filament becomes white-hot."),
    ("magnetic and attracts iron","A glowing bulb is about heat and light, not magnetism; the filament glows because it is white-hot."),
    ("filled with coloured water","A bulb has no coloured water; it lights because its filament is heated white-hot.")]),

 ("EC","A safety device made of a wire with a low melting point that melts and breaks the circuit when the current grows too large is a:",
   "fuse",
   C("A fuse contains a low-melting wire. If the current is dangerously high, the wire melts, breaking the circuit and protecting the appliances.")+
   steps("Too much current heats the fuse wire strongly","the low-melting wire melts and snaps","the circuit breaks, cutting off the dangerous current.")+
   U("A blown fuse after a power surge has done its job — it broke the circuit before a fire could start."),
   [("switch","An ordinary switch must be turned by hand; a fuse melts on its own when the current is too high."),
    ("battery","A battery supplies current; the device that melts to break a circuit on overload is the fuse."),
    ("bulb","A bulb gives light; the protective wire that melts to cut off excess current is the fuse.")]),

 ("EC","When a compass is brought near a wire carrying a current, its needle moves (deflects). This shows that an electric current has a:",
   "magnetic effect",
   C("A current-carrying wire behaves like a magnet and deflects a nearby compass needle — evidence of the magnetic effect of electric current.")+
   steps("Place a compass beside a current-carrying wire","the needle swings away from north","so the current acts like a magnet — the magnetic effect.")+
   U("This magnetic effect is the basis of the electromagnets used in cranes and electric bells."),
   [("heating effect","The heating effect warms the wire; a compass needle moving shows the MAGNETIC effect instead."),
    ("freezing effect","There is no 'freezing effect' of current; a deflected compass shows its magnetic effect."),
    ("sound effect","A moving compass needle is about magnetism, not sound; this is the magnetic effect of current.")]),

 ("EC","A coil of wire wound on a soft iron core that becomes a magnet only while current flows through it is called an:",
   "electromagnet",
   C("An electromagnet is a coil around a soft iron core; it acts as a strong magnet while current flows and loses its magnetism when the current stops.")+
   steps("Wind a coil around a soft iron core","pass current through the coil","the core becomes a magnet — an electromagnet — only while current flows.")+
   U("A scrapyard crane uses a powerful electromagnet to lift cars and drop them by switching the current off."),
   [("permanent magnet","A permanent magnet stays magnetic always; an electromagnet is a magnet only while current flows."),
    ("simple fuse","A fuse melts to break a circuit; a coil-and-core that becomes a magnet with current is an electromagnet."),
    ("dry cell","A dry cell supplies current; the coil-and-core that turns into a magnet is the electromagnet.")]),

 ("EC","In an electric bell, the device that becomes magnetic and pulls the iron strip to strike the gong is the:",
   "electromagnet",
   C("An electric bell uses an electromagnet. When current flows, it attracts an iron strip whose hammer hits the gong; the motion breaks the circuit and the cycle repeats.")+
   steps("Current flows and the electromagnet pulls the iron strip","the hammer strikes the gong and the circuit breaks","the electromagnet lets go, the strip springs back, and it repeats — ringing.")+
   U("The continuous ring of a school bell comes from an electromagnet making and breaking the circuit rapidly."),
   [("a permanent bar magnet","A bell needs a magnet that switches on and off with the current; that is an electromagnet, not a fixed permanent magnet."),
    ("a glass fuse","A fuse protects against overload; the part that pulls the hammer in a bell is the electromagnet."),
    ("a heating coil","A heating coil makes heat; the part that attracts the iron strip is the electromagnet.")]),

 ("EC","A battery is best described as:",
   "two or more electric cells joined together",
   C("A single cell is one unit; a battery is two or more cells connected together to supply a larger voltage or run for longer.")+
   steps("Take more than one electric cell","connect them together (often end to end)","the combination is called a battery.")+
   U("A torch using two cells stacked together is powered by a battery."),
   [("a single electric cell on its own","One cell alone is just a cell; joining two or more cells makes a battery."),
    ("a type of switch","A switch only makes or breaks a circuit; a battery is two or more cells supplying current."),
    ("a wire that melts on overload","A wire that melts on overload is a fuse; a battery is a group of joined cells.")]),

 ("EC","In a circuit diagram, the longer line of a cell's symbol stands for the:",
   "positive (+) terminal",
   C("A cell's symbol has a longer thin line for the positive terminal and a shorter thick line for the negative terminal.")+
   steps("Look at the two lines of a cell symbol","the longer line marks the positive terminal","the shorter, thicker line marks the negative terminal.")+
   U("Reading a circuit diagram, you orient the cell by spotting the long line as its + terminal."),
   [("negative (−) terminal","The negative terminal is the SHORTER, thicker line; the longer line is the positive terminal."),
    ("switch","The longer line is part of the CELL symbol, marking its + terminal, not a switch."),
    ("fuse","A fuse has its own symbol; the longer line in a cell symbol marks the positive terminal.")]),

 ("EC","If two bulbs are connected one after the other in a single loop (in series) and one bulb fuses, the other bulb will:",
   "go off too, because the circuit is broken",
   C("In a series circuit there is only one path. If one bulb fuses, the path breaks and no current flows, so the other bulb also goes off.")+
   steps("Series means one single path for the current","a fused bulb breaks that single path","with the path broken, no current flows, so the other bulb goes off too.")+
   U("Old fairy lights wired in series all went dark when a single bulb failed."),
   [("glow even brighter than before","With the single path broken there is no current at all, so the other bulb cannot glow — let alone brighter."),
    ("keep glowing as if nothing happened","In series there is only one path; breaking it stops the current, so the other bulb also goes off."),
    ("turn into a magnet","A bulb does not become a magnet; when the series path breaks, the other bulb simply goes off.")]),

 ("EC","Three cells, each of 2 volts, are joined in series. Using the equation V = 2 + 2 + 2, the total voltage V they supply is:",
   "6 volts",
   C("Cells joined in series add their voltages. With three 2-volt cells, V = 2 + 2 + 2 = 6 volts.")+
   steps("Series cells add up their voltages","V = 2 + 2 + 2","V = 6 volts.")+
   U("Two such batteries of cells in a toy give more voltage than a single cell, making the motor spin faster."),
   [("2 volts","2 volts is just ONE cell; three in series add to 2 + 2 + 2 = 6 volts."),
    ("8 volts","8 volts would need four cells; three 2-volt cells give 2 + 2 + 2 = 6 volts."),
    ("0 volts","Joined cells do not cancel here; in series they add to 6 volts, not zero.")]),

 ("EC","A torch holds some 1.5-volt cells in series and the bulb works at 6 volts. Solving 1.5 × n = 6, the number of cells n needed is:",
   "4 cells",
   C("Each cell gives 1.5 V and they add in series, so 1.5 × n = 6. Solve: n = 6 ÷ 1.5 = 4 cells.")+
   steps("Equation: 1.5 × n = 6","n = 6 ÷ 1.5","n = 4 cells.")+
   U("A torch needing 6 V is built to hold four 1.5-volt cells stacked in series."),
   [("2 cells","Two cells give only 1.5 × 2 = 3 V; reaching 6 V needs 6 ÷ 1.5 = 4 cells."),
    ("6 cells","Six cells give 1.5 × 6 = 9 V, too much; 6 V needs exactly 4 cells."),
    ("3 cells","Three cells give 1.5 × 3 = 4.5 V, short of 6 V; the equation gives n = 4 cells.")]),

 ("EC","To make an electromagnet stronger, the most effective single change you can make is:",
   "increasing the number of turns in the coil",
   C("More turns of wire in the coil (and more current) make a stronger electromagnet; fewer turns make it weaker.")+
   steps("Wind more turns of wire around the iron core","each turn adds to the magnetic effect","so more turns make a stronger electromagnet.")+
   U("A crane's lifting electromagnet uses a coil with very many turns to pick up heavy iron loads."),
   [("using fewer turns of wire","Fewer turns WEAKEN the magnet; to make it stronger you add MORE turns."),
    ("removing the iron core","The soft iron core makes the magnet stronger; removing it weakens the electromagnet."),
    ("switching the current off","With the current off the electromagnet loses its magnetism entirely; strength needs current and more turns.")]),

 ("EC","An electromagnet is wound with 50 turns of wire. To triple its turns you add x more, and 50 + x = 150. Solving for x, you must add:",
   "100 turns",
   C("Solve the simple equation 50 + x = 150. Subtract 50 from both sides: x = 150 − 50 = 100 extra turns.")+
   steps("Equation: 50 + x = 150","subtract 50 from both sides: x = 150 − 50","x = 100 turns.")+
   U("To strengthen a weak electromagnet from 50 to 150 turns, a student winds on 100 more turns of wire."),
   [("200 turns","200 ADDS 50 to 150; to undo the +50 you SUBTRACT, giving 150 − 50 = 100 turns."),
    ("150 turns","150 is the FINAL number of turns, not the extra ones; the extra is 150 − 50 = 100."),
    ("50 turns","50 is the STARTING number of turns; the turns to add is x = 150 − 50 = 100.")]),

 ("EC","When the switch in a simple circuit is moved to the 'OFF' position, the circuit becomes:",
   "open, so no current flows",
   C("An open switch leaves a gap in the circuit. With the path broken, current cannot flow, so the appliance stops working.")+
   steps("Turning the switch OFF opens a gap in the loop","current cannot cross the gap","so no current flows — the circuit is open.")+
   U("Flicking a light switch off opens the circuit, and the bulb goes dark at once."),
   [("closed, so more current flows","An OFF switch OPENS the circuit; a closed loop is what lets current flow, the opposite of off."),
    ("magnetic, so it attracts iron","Turning a switch off does not make it magnetic; it simply opens the circuit so no current flows."),
    ("hotter, so the bulb glows brighter","With the switch off no current flows, so nothing heats or glows; the circuit is simply open.")]),

 ("EC","Compared with a filament bulb, a CFL or LED is preferred for lighting because it:",
   "gives the same light while wasting far less energy as heat",
   C("Filament bulbs lose much of their energy as heat. CFLs and LEDs produce similar light using far less electricity, wasting much less as heat.")+
   steps("A filament bulb turns most of its energy into heat, not light","CFLs and LEDs make light with far less wasted heat","so they give the same brightness using less energy.")+
   U("Switching from filament bulbs to LEDs noticeably lowers a home's electricity bill."),
   [("makes much more heat than a filament bulb","CFLs and LEDs make LESS heat, not more; that is precisely why they are more efficient."),
    ("needs no electricity at all","CFLs and LEDs still need electricity; they just use much less of it than filament bulbs."),
    ("works only in sunlight","These lamps work from mains electricity, day or night; their advantage is wasting less energy as heat.")]),

 ("EC","Modern homes often use an MCB (Miniature Circuit Breaker) in place of a fuse because an MCB:",
   "can be switched back on after it trips, instead of being replaced",
   C("An MCB trips (switches off) on overload like a fuse but can simply be reset by flipping it back on, whereas a blown fuse wire must be replaced.")+
   steps("On overload an MCB trips and breaks the circuit","unlike a fuse, no wire is destroyed","you just flip the MCB back on to restore power.")+
   U("After a trip, you can restore power by switching the MCB back up — no need to fit a new fuse wire."),
   [("supplies extra current to the house","An MCB does not add current; it protects the circuit and can be reset after tripping, unlike a fuse."),
    ("never breaks the circuit at all","An MCB DOES break the circuit on overload; its advantage is that it can be switched back on afterwards."),
    ("turns the house lights into magnets","An MCB is a safety switch, not a magnet maker; it can be reset after a trip, unlike a fuse.")]),

 ("EC","The hands-experiment in which a compass needle near a current-carrying wire is deflected was the discovery that linked:",
   "electricity and magnetism",
   C("Seeing a compass needle deflect near a current-carrying wire showed that electric current produces a magnetic effect, linking electricity with magnetism.")+
   steps("A current is switched on in a wire near a compass","the compass needle deflects","so the current makes magnetism — electricity and magnetism are linked.")+
   U("This link is what makes electromagnets, electric bells and motors possible."),
   [("electricity and sound","A deflecting compass shows magnetism, not sound; the discovery linked electricity and magnetism."),
    ("heat and light","Heat and light are the bulb's effects; the compass experiment links electricity and magnetism."),
    ("water and electricity","The compass deflection is about magnetic effect, linking electricity and magnetism, not water.")]),

 ("EC","The fuse wire in a household fuse is deliberately made of a metal that has a:",
   "low melting point",
   C("A fuse wire must melt easily when the current is too high, so it is made of a metal (or alloy) with a low melting point.")+
   steps("On overload the fuse must melt quickly to break the circuit","a low-melting metal melts at a safe, low temperature","so fuse wire is made of a low-melting metal.")+
   U("A fuse wire of low-melting alloy melts and snaps before the household wiring can overheat."),
   [("very high melting point","A high-melting wire would not melt in time to protect the circuit; fuse wire needs a LOW melting point."),
    ("strong magnetism","Magnetism is not the point of a fuse; it must MELT on overload, so it has a low melting point."),
    ("bright colour when cold","Colour is irrelevant; the fuse wire is chosen for its low melting point so it melts on overload.")]),

 ("EC","An electric heater and an electric iron both work mainly using the current's:",
   "heating effect",
   C("Heaters and irons pass current through a coil of high-resistance wire, which gets hot — they rely on the heating effect of current.")+
   steps("Current flows through the appliance's coil","the coil heats up strongly","that heat irons clothes or warms a room — the heating effect.")+
   U("The element of an electric iron glows and warms by the heating effect of the current."),
   [("magnetic effect","The magnetic effect makes magnets and bells; a heater and iron get HOT, using the heating effect."),
    ("chemical effect","The chemical effect drives electroplating; a heater and iron work by the heating effect."),
    ("cooling effect","There is no 'cooling effect' of current; heaters and irons rely on the heating effect.")]),

 ("EC","Why is the heating element (coil) of a room heater made of a special wire rather than ordinary copper wire?",
   "it resists the current more and so gets much hotter, without melting",
   C("The element is a high-resistance alloy that heats up strongly when current flows and has a high melting point, so it glows hot without melting.")+
   steps("The element must get hot to give heat","a high-resistance wire heats up much more than ordinary copper","and its high melting point lets it glow without melting.")+
   U("The glowing red coil of a room heater is made of such a special high-resistance wire."),
   [("it carries current without ever heating up","A heater element is MEANT to heat up; it is chosen because it heats strongly without melting."),
    ("it is a magnet that attracts the room's dust","The element is not a magnet; it is a high-resistance wire that heats up to give warmth."),
    ("it makes the current flow backwards","The element does not reverse current; it resists current so it heats up strongly without melting.")]),

 ("EC","In a circuit drawn on paper, a small circle with a cross or a loop inside it is the standard symbol for a:",
   "bulb",
   C("The standard circuit symbol for a bulb (lamp) is a circle with a cross inside it; each component has its own agreed symbol.")+
   steps("Recall the agreed circuit symbols","a circle with a cross inside","stands for a bulb (lamp).")+
   U("Reading a circuit diagram, a student spots the crossed circle and knows a bulb sits there."),
   [("cell","A cell is drawn as a long line and a short line, not a crossed circle; the crossed circle is a bulb."),
    ("switch","A switch is shown as a little gap with a lever, not a crossed circle, which represents a bulb."),
    ("battery","A battery is two or more cell symbols in a row; the crossed circle stands for a bulb.")]),

 ("EC","An electromagnet loses its magnetism the moment the current is switched off. This makes it especially useful for:",
   "picking up and then releasing iron objects on demand",
   C("Because it is magnetic only while current flows, an electromagnet can grab iron when switched on and drop it when switched off — ideal for sorting and lifting.")+
   steps("Switch the current ON — the electromagnet attracts iron and lifts it","move the load, then switch the current OFF","the magnetism vanishes and the iron is released.")+
   U("A scrapyard crane lifts a heap of iron with its electromagnet on, then drops it into a truck by switching off."),
   [("making a magnet that can never be switched off","An electromagnet's special feature is that it CAN be switched off; a never-off magnet is a permanent magnet."),
    ("storing electricity like a cell","An electromagnet does not store electricity; its use is grabbing and releasing iron by switching the current."),
    ("lighting a room without a bulb","An electromagnet gives no light; its value is lifting and releasing iron on demand.")]),

 ("EC","The energy change taking place in an electric bulb that is switched on is:",
   "electrical energy into light and heat",
   C("A glowing bulb turns electrical energy mostly into heat and some into light; this is why ordinary bulbs feel hot.")+
   steps("Electrical energy enters the bulb","the filament heats up (heating effect) and glows","so electrical energy becomes heat and light.")+
   U("Touch a bulb that has been on for a while and it feels hot — proof that much of the energy became heat."),
   [("sound energy into light","A bulb does not start from sound; it changes ELECTRICAL energy into light and heat."),
    ("light energy into electricity","That is what a solar cell does; a bulb does the reverse, turning electricity into light and heat."),
    ("heat energy into magnetism","A glowing bulb is not about magnetism; it converts electrical energy into light and heat.")]),

 ("EC","A bird can perch safely on a single high-voltage wire because:",
   "current needs a complete path, and the bird does not provide one to a different point",
   C("Current flows only through a complete circuit. Sitting on one wire, the bird's two feet are at almost the same point, so no current passes through it.")+
   steps("Current flows only when there is a complete path to a lower point","the bird touches just one wire, both feet near the same place","with no second path through it, no current flows through the bird.")+
   U("The same bird would be in danger if it also touched a pole or a second wire, completing a path."),
   [("its feathers are made of metal","Feathers are not metal; the bird is safe because it does not complete a circuit to another point."),
    ("the wire has no electricity in it","The wire is live; the bird is safe because, on one wire, it does not complete a path for the current."),
    ("birds cannot feel electricity","Feeling has nothing to do with it; no current flows because the bird does not complete a circuit.")]),

 ("EC","Which of these is the correct order of parts that lets a simple torch light up?",
   "cells → switch (on) → bulb, joined in a complete loop by wires",
   C("A torch lights when its cells, a closed switch and the bulb form one complete loop of conducting wire, so current can flow.")+
   steps("Current leaves the cells and reaches the closed switch","through the switch it flows on to the bulb","wires complete the loop back to the cells, and the bulb glows.")+
   U("If any link in this loop is broken — a dead cell or an open switch — the torch will not light."),
   [("bulb alone with no cells or wires","A bulb by itself has no current source or path; a torch needs cells, a switch and wires in a complete loop."),
    ("cells joined to a switch that is left open","An open switch breaks the loop, so no current flows; the torch lights only when the switch is closed."),
    ("two bulbs with no cells at all","With no cells there is no current; a torch must include cells, a closed switch and the bulb in a loop.")]),
]

# ---------- SIMPLE EQUATIONS (25) — Maths (several fused with science) ----------
SE = [
 ("SE","A mathematical statement that two expressions are equal, using an equals sign, is called:",
   "an equation",
   C("An equation states that the left-hand side equals the right-hand side, joined by an '=' sign, and usually contains an unknown to find.")+
   steps("Look for two expressions joined by '='","such as x + 3 = 7","that statement of equality is an equation.")+
   U("Setting up an equation lets you turn a word puzzle into something you can solve step by step."),
   [("an inequality","An inequality uses signs like < or >, not '='; a statement with an equals sign is an equation."),
    ("a fraction","A fraction is a part of a whole like 3/4; a statement that two sides are equal is an equation."),
    ("a ratio","A ratio compares two quantities like 2 : 3; an equality joined by '=' is an equation.")]),

 ("SE","The value of the variable that makes both sides of an equation equal is called its:",
   "solution (root)",
   C("The solution of an equation is the value of the variable for which the left side equals the right side.")+
   steps("Try a value for the variable","if LHS comes out equal to RHS","that value is the solution of the equation.")+
   U("Checking your answer by putting it back into the equation confirms you found the right solution."),
   [("coefficient","A coefficient is the number multiplying a variable, like the 3 in 3x; the value that satisfies the equation is its solution."),
    ("constant","A constant is a fixed number in the equation; the value of the variable that fits is the solution."),
    ("variable","The variable is the unknown letter itself; the value that makes the equation true is the solution.")]),

 ("SE","Solving the equation x + 9 = 16 (find the value of x), you get:",
   "x = 7",
   C("Subtract 9 from both sides: x = 16 − 9 = 7. Check: 7 + 9 = 16. ✓")+
   steps("x + 9 = 16","subtract 9 from both sides: x = 16 − 9","x = 7.")+
   U("If 9 sweets added to a box make 16, the box started with 7 sweets."),
   [("x = 25","25 ADDS 9 to 16; to undo '+9' you SUBTRACT, giving 16 − 9 = 7."),
    ("x = 9","9 is the number added, not the answer; solving gives x = 16 − 9 = 7."),
    ("x = 16","16 is the right-hand side total; the unknown x is 16 − 9 = 7.")]),

 ("SE","Solving the equation 4x = 28 for x gives:",
   "x = 7",
   C("Divide both sides by 4: x = 28 ÷ 4 = 7. Check: 4 × 7 = 28. ✓")+
   steps("4x = 28","divide both sides by 4: x = 28 ÷ 4","x = 7.")+
   U("If 4 equal rows hold 28 chairs in all, each row has 7 chairs."),
   [("x = 32","32 ADDS 4 to 28; to undo '×4' you DIVIDE, giving 28 ÷ 4 = 7."),
    ("x = 24","24 SUBTRACTS 4 from 28; the operation is multiplication, so divide: 28 ÷ 4 = 7."),
    ("x = 112","112 MULTIPLIES 28 × 4; to solve 4x = 28 you divide, giving x = 7.")]),

 ("SE","Solving the equation x/5 = 6 for x gives:",
   "x = 30",
   C("Multiply both sides by 5: x = 6 × 5 = 30. Check: 30 ÷ 5 = 6. ✓")+
   steps("x/5 = 6","multiply both sides by 5: x = 6 × 5","x = 30.")+
   U("If sharing a sum equally among 5 friends gives ₹6 each, the sum was ₹30."),
   [("x = 11","11 ADDS 5 to 6; to undo '÷5' you MULTIPLY, giving 6 × 5 = 30."),
    ("x = 1.2","1.2 divides 6 by 5; to solve x/5 = 6 you multiply by 5, giving x = 30."),
    ("x = 5","5 is the number we divided by, not x; solving gives x = 6 × 5 = 30.")]),

 ("SE","Solving the equation 2x + 3 = 11 for x gives:",
   "x = 4",
   C("Subtract 3: 2x = 8. Divide by 2: x = 4. Check: 2 × 4 + 3 = 11. ✓")+
   steps("2x + 3 = 11 → subtract 3: 2x = 8","divide both sides by 2: x = 8 ÷ 2","x = 4.")+
   U("Two equal payments plus a ₹3 fee come to ₹11, so each payment was ₹4."),
   [("x = 7","7 comes from 11 − 4 or ignoring the ÷2; correctly, 2x = 8 so x = 4."),
    ("x = 8","8 is the value of 2x after removing the 3; you must still divide by 2, giving x = 4."),
    ("x = 5.5","5.5 divides 11 by 2 without first removing the 3; the correct answer is x = 4.")]),

 ("SE","When the term '+ 6' is moved (transposed) from the left side to the right side of an equation, it becomes:",
   "− 6",
   C("Transposing a term across the equals sign changes its sign: a '+6' on one side becomes '−6' on the other.")+
   steps("Start with something like x + 6 = 10","move +6 to the right side across '='","it becomes −6: x = 10 − 6.")+
   U("Transposing is just a quick way of doing the same operation to both sides."),
   [("+ 6 (sign unchanged)","Transposing flips the sign; a '+6' does not stay '+6' — it becomes '−6'."),
    ("× 6","Transposing an added term changes its sign, not its operation; '+6' becomes '−6', not '×6'."),
    ("÷ 6","A term that was added becomes subtracted when transposed; '+6' becomes '−6', not '÷6'.")]),

 ("SE","Solving the equation 5x − 2 = 13 for x gives:",
   "x = 3",
   C("Add 2: 5x = 15. Divide by 5: x = 3. Check: 5 × 3 − 2 = 13. ✓")+
   steps("5x − 2 = 13 → add 2: 5x = 15","divide both sides by 5: x = 15 ÷ 5","x = 3.")+
   U("Five equal tickets after a ₹2 discount cost ₹13, so each ticket was ₹3."),
   [("x = 2.2","2.2 divides 13 by 5 without first adding the 2; correctly 5x = 15, so x = 3."),
    ("x = 11","11 comes from 13 − 2 treated as the answer; that is 5x = 15, so x = 3, not 11."),
    ("x = 15","15 is the value of 5x after adding 2; divide by 5 to get x = 3.")]),

 ("SE","\"When a number is multiplied by 3, the result is 27.\" Writing 3x = 27 and solving, the number is:",
   "9",
   C("Form the equation 3x = 27, then divide by 3: x = 27 ÷ 3 = 9.")+
   steps("Let the number be x; 'multiplied by 3 gives 27' → 3x = 27","divide both sides by 3: x = 27 ÷ 3","x = 9.")+
   U("Turning a sentence into an equation makes a word problem easy to solve."),
   [("24","24 SUBTRACTS 3 from 27; the number is found by DIVIDING: 27 ÷ 3 = 9."),
    ("30","30 ADDS 3 to 27; to undo '×3' you divide, giving 9."),
    ("81","81 MULTIPLIES 27 × 3; solving 3x = 27 needs division, giving x = 9.")]),

 ("SE","\"5 added to twice a number gives 17.\" Writing 2x + 5 = 17 and solving, the number is:",
   "6",
   C("Form 2x + 5 = 17. Subtract 5: 2x = 12. Divide by 2: x = 6.")+
   steps("'twice a number plus 5 is 17' → 2x + 5 = 17","subtract 5: 2x = 12","divide by 2: x = 6.")+
   U("Translating words into the equation 2x + 5 = 17 lets you find the hidden number, 6."),
   [("11","11 comes from 17 − 6 or skipping the ÷2; correctly 2x = 12, so x = 6."),
    ("12","12 is the value of 2x after removing the 5; divide by 2 to get x = 6."),
    ("8","8 might come from mis-subtracting; solving 2x + 5 = 17 gives 2x = 12 and x = 6.")]),

 ("SE","Solving the equation 4(x − 2) = 12 for x gives:",
   "x = 5",
   C("Divide both sides by 4: x − 2 = 3. Add 2: x = 5. Check: 4 × (5 − 2) = 12. ✓")+
   steps("4(x − 2) = 12 → divide by 4: x − 2 = 3","add 2 to both sides: x = 3 + 2","x = 5.")+
   U("If 4 boxes, each holding 2 fewer than x, total 12 items, then x is 5."),
   [("x = 3","3 is the value of (x − 2), not x; add the 2 back to get x = 5."),
    ("x = 1","1 comes from 3 − 2; you must ADD the 2, giving x = 3 + 2 = 5."),
    ("x = 14","14 expands wrongly; dividing first gives x − 2 = 3, so x = 5.")]),

 ("SE","Solving the equation 16 = x + 7 for x gives:",
   "x = 9",
   C("Subtract 7 from both sides: x = 16 − 7 = 9. The unknown can sit on either side; we still subtract 7.")+
   steps("16 = x + 7","subtract 7 from both sides: 16 − 7 = x","x = 9.")+
   U("An equation reads the same both ways: 16 = x + 7 is just x + 7 = 16."),
   [("x = 23","23 ADDS 7 to 16; to undo '+7' you SUBTRACT, giving 16 − 7 = 9."),
    ("x = 7","7 is the number added, not x; solving gives x = 16 − 7 = 9."),
    ("x = 16","16 is the left-hand side; the unknown x equals 16 − 7 = 9.")]),

 ("SE","Solving the equation 2x = −8 for x gives:",
   "x = −4",
   C("Divide both sides by 2: x = −8 ÷ 2 = −4. Check: 2 × (−4) = −8. ✓")+
   steps("2x = −8","divide both sides by 2: x = −8 ÷ 2","x = −4.")+
   U("Equations can have negative solutions, like a temperature of −4°C below zero."),
   [("x = 4","Dividing −8 by 2 keeps the minus sign: x = −4, not +4."),
    ("x = −6","−6 SUBTRACTS 2 from −8; to solve 2x = −8 you DIVIDE, giving −4."),
    ("x = −16","−16 MULTIPLIES −8 by 2; solving needs division, giving x = −4.")]),

 ("SE","A pan of water at 18°C is heated by a rise of r degrees to reach 70°C. Writing 18 + r = 70 and solving, the rise r is:",
   "52°C",
   C("Form the equation 18 + r = 70 (start + rise = final). Subtract 18: r = 70 − 18 = 52, a rise of 52°C.")+
   steps("Equation: 18 + r = 70","subtract 18 from both sides: r = 70 − 18","r = 52°C.")+
   U("Heating water from 18°C to 70°C means raising its temperature by 52°C."),
   [("88°C","88 ADDS 18 to 70; the rise is found by SUBTRACTING, giving 70 − 18 = 52°C."),
    ("70°C","70°C is the FINAL temperature, not the rise; the rise is 70 − 18 = 52°C."),
    ("18°C","18°C is the STARTING temperature; the rise r is 70 − 18 = 52°C.")]),

 ("SE","A torch's bulb runs at 9 volts using cells of 1.5 volts in series. Writing 1.5n = 9 and solving, the number of cells n is:",
   "6 cells",
   C("Series cells add, so 1.5n = 9. Divide by 1.5: n = 9 ÷ 1.5 = 6 cells.")+
   steps("Equation: 1.5n = 9","divide both sides by 1.5: n = 9 ÷ 1.5","n = 6 cells.")+
   U("A 9-volt torch built from 1.5-volt cells needs six of them stacked in series."),
   [("3 cells","Three cells give only 1.5 × 3 = 4.5 V; reaching 9 V needs 9 ÷ 1.5 = 6 cells."),
    ("9 cells","9 is the voltage, not the number of cells; solving 1.5n = 9 gives n = 6."),
    ("4 cells","Four cells give 1.5 × 4 = 6 V, short of 9 V; the equation gives n = 6 cells.")]),

 ("SE","Solving the equation 3x + 2x = 25 for x gives:",
   "x = 5",
   C("Combine like terms: 3x + 2x = 5x, so 5x = 25. Divide by 5: x = 5.")+
   steps("3x + 2x = 5x","5x = 25","divide by 5: x = 25 ÷ 5 = 5.")+
   U("Collecting like terms first turns a long equation into a one-step solve."),
   [("x = 25","25 is the right-hand side; after combining, 5x = 25, so x = 5."),
    ("x = 12.5","12.5 divides 25 by 2; the terms combine to 5x, so divide by 5, giving x = 5."),
    ("x = 10","10 might come from a wrong combination; 3x + 2x = 5x = 25 gives x = 5.")]),

 ("SE","Solving the equation x/3 = 4 for x gives:",
   "x = 12",
   C("Multiply both sides by 3: x = 4 × 3 = 12. Check: 12 ÷ 3 = 4. ✓")+
   steps("x/3 = 4","multiply both sides by 3: x = 4 × 3","x = 12.")+
   U("If a length cut into 3 equal pieces gives 4 cm each, the whole was 12 cm."),
   [("x = 7","7 ADDS 3 to 4; to undo '÷3' you MULTIPLY, giving 4 × 3 = 12."),
    ("x = 1.3","1.3 divides 4 by 3; to solve x/3 = 4 you multiply by 3, giving x = 12."),
    ("x = 4","4 is the right-hand side; solving gives x = 4 × 3 = 12.")]),

 ("SE","Solving the equation 2(x + 3) = 16 for x gives:",
   "x = 5",
   C("Divide by 2: x + 3 = 8. Subtract 3: x = 5. Check: 2 × (5 + 3) = 16. ✓")+
   steps("2(x + 3) = 16 → divide by 2: x + 3 = 8","subtract 3 from both sides: x = 8 − 3","x = 5.")+
   U("If doubling 'three more than a number' gives 16, the number is 5."),
   [("x = 8","8 is the value of (x + 3), not x; subtract the 3 to get x = 5."),
    ("x = 11","11 adds 3 to 8; you must SUBTRACT the 3, giving x = 8 − 3 = 5."),
    ("x = 2","2 may come from a wrong divide-first step; correctly x + 3 = 8, so x = 5.")]),

 ("SE","Is x = 2 a solution of the equation 3x + 1 = 7? Checking by substitution:",
   "yes, because 3 × 2 + 1 = 7",
   C("Substitute x = 2 into the left side: 3 × 2 + 1 = 6 + 1 = 7, which equals the right side, so x = 2 is the solution.")+
   steps("Put x = 2 into 3x + 1","3 × 2 + 1 = 6 + 1 = 7","LHS = RHS = 7, so yes, x = 2 is a solution.")+
   U("Substituting your answer back is a quick way to be sure you solved correctly."),
   [("no, because 3 × 2 + 1 = 9","3 × 2 + 1 is 6 + 1 = 7, not 9; so x = 2 DOES satisfy the equation."),
    ("no, because x must be 7","x is not 7; substituting x = 2 gives exactly 7, so x = 2 is the solution."),
    ("cannot be checked without a graph","Substitution alone settles it: 3 × 2 + 1 = 7, so x = 2 is a solution — no graph needed.")]),

 ("SE","Solving the equation 6x − 4 = 2x + 12 for x gives:",
   "x = 4",
   C("Bring variables together: 6x − 2x = 12 + 4 → 4x = 16 → x = 4. Check: 6×4−4 = 20 and 2×4+12 = 20. ✓")+
   steps("Transpose: 6x − 2x = 12 + 4","4x = 16","divide by 4: x = 16 ÷ 4 = 4.")+
   U("When the unknown appears on both sides, gather it on one side first, then solve."),
   [("x = 8","8 may come from a sign slip; correctly 4x = 16, so x = 4, not 8."),
    ("x = 2","2 might come from mis-transposing; gathering terms gives 4x = 16 and x = 4."),
    ("x = 16","16 is the value of 4x, not x; divide by 4 to get x = 4.")]),

 ("SE","\"Twice a number, decreased by 5, equals 9.\" Writing 2x − 5 = 9 and solving, the number is:",
   "7",
   C("Form 2x − 5 = 9. Add 5: 2x = 14. Divide by 2: x = 7.")+
   steps("'twice a number minus 5 is 9' → 2x − 5 = 9","add 5: 2x = 14","divide by 2: x = 7.")+
   U("Word problems become easy once you write them as an equation like 2x − 5 = 9."),
   [("2","2 may come from a wrong step; solving 2x − 5 = 9 gives 2x = 14 and x = 7."),
    ("14","14 is the value of 2x after adding 5; divide by 2 to get x = 7."),
    ("4","4 might come from 9 − 5; correctly 2x = 14, so x = 7.")]),

 ("SE","Solving the equation x + x + x = 21 for x gives:",
   "x = 7",
   C("Add the like terms: x + x + x = 3x, so 3x = 21, giving x = 21 ÷ 3 = 7.")+
   steps("x + x + x = 3x","3x = 21","divide by 3: x = 21 ÷ 3 = 7.")+
   U("Three equal lengths totalling 21 cm are each 7 cm long."),
   [("x = 21","21 is the total; the three equal terms make 3x = 21, so x = 7."),
    ("x = 3","3 is the number of terms, not x; solving 3x = 21 gives x = 7."),
    ("x = 63","63 MULTIPLIES 21 × 3; to solve 3x = 21 you divide, giving x = 7.")]),

 ("SE","Solving the equation 10 − x = 4 for x gives:",
   "x = 6",
   C("Transpose: 10 − 4 = x, so x = 6. Check: 10 − 6 = 4. ✓")+
   steps("10 − x = 4","move x and 4 across: 10 − 4 = x","x = 6.")+
   U("If 4 books are left after taking some from a pile of 10, then 6 were taken."),
   [("x = 14","14 ADDS 4 to 10; here x = 10 − 4 = 6, since the x is being subtracted."),
    ("x = 4","4 is the right-hand side; solving 10 − x = 4 gives x = 6."),
    ("x = −6","−6 has the wrong sign; 10 − x = 4 rearranges to x = 10 − 4 = 6.")]),

 ("SE","A pendulum makes some swings and 12 more make 40 in all. Writing s + 12 = 40 and solving, the first number of swings s was:",
   "28",
   C("Form s + 12 = 40. Subtract 12: s = 40 − 12 = 28 swings.")+
   steps("Equation: s + 12 = 40","subtract 12 from both sides: s = 40 − 12","s = 28 swings.")+
   U("If a pendulum reaches 40 swings after 12 more, it had already made 28."),
   [("52","52 ADDS 12 to 40; to undo '+12' you SUBTRACT, giving 40 − 12 = 28."),
    ("12","12 is the swings added, not the first count; solving gives s = 40 − 12 = 28."),
    ("40","40 is the TOTAL swings; the first number s is 40 − 12 = 28.")]),

 ("SE","Solving the equation 7x = 0 for x gives:",
   "x = 0",
   C("Divide both sides by 7: x = 0 ÷ 7 = 0. Any non-zero number times x giving 0 means x itself is 0.")+
   steps("7x = 0","divide both sides by 7: x = 0 ÷ 7","x = 0.")+
   U("If 7 equal groups hold 0 items in total, each group has 0 items."),
   [("x = 7","7 is the number multiplying x, not the answer; 7x = 0 means x = 0."),
    ("x = 1","If x were 1, then 7x would be 7, not 0; the solution is x = 0."),
    ("no solution exists","There is a solution: x = 0 makes 7x = 0 true, so x = 0.")]),
]

# ---------- SYMMETRY (25) — Maths (several fused with mirrors/science) ----------
SY = [
 ("SY","A figure that can be folded along a line so that the two halves fall exactly on each other is said to have:",
   "line (reflection) symmetry",
   C("If a fold along some line makes the two halves match exactly, the figure has line symmetry, and that fold line is its line of symmetry.")+
   steps("Fold the figure along a line","check whether the two halves overlap exactly","if they do, the figure has line symmetry.")+
   U("Folding a paper heart down the middle shows its two halves match — it has line symmetry."),
   [("no symmetry at all","A figure whose halves match on folding clearly HAS symmetry — line symmetry, in fact."),
    ("rotational symmetry only","Matching halves on FOLDING is line symmetry; rotational symmetry is about turning, a different test."),
    ("translation symmetry","Translation symmetry is about sliding a repeating pattern; matching halves on a fold is line symmetry.")]),

 ("SY","Counting both diagonals and both midlines, how many lines of symmetry does a square have?",
   "4",
   C("A square has 4 lines of symmetry: the 2 diagonals and the 2 lines joining the midpoints of opposite sides.")+
   steps("Fold a square corner-to-corner: 2 diagonal lines match","fold midpoint-to-midpoint: 2 more lines match","total = 2 + 2 = 4 lines of symmetry.")+
   U("A square floor tile looks the same after folding along any of its 4 lines of symmetry."),
   [("2","2 counts only the midpoint lines and forgets the 2 diagonals; a square has 4 in all."),
    ("1","1 is far too few; a square has 4 lines of symmetry, not 1."),
    ("8","8 confuses lines of symmetry with something else; a square has exactly 4.")]),

 ("SY","The number of lines of symmetry in an equilateral triangle is:",
   "3",
   C("An equilateral triangle has 3 lines of symmetry — one from each vertex to the midpoint of the opposite side.")+
   steps("From each corner draw a fold to the middle of the opposite side","each such fold makes the halves match","there are 3 corners, so 3 lines of symmetry.")+
   U("A triangular road sign with equal sides has 3 lines of symmetry."),
   [("1","1 fits an isosceles triangle, which has only one line; an EQUILATERAL triangle has 3."),
    ("2","2 is too few; the equilateral triangle has one line per vertex, giving 3."),
    ("0","0 fits a scalene triangle; the equilateral triangle has 3 lines of symmetry.")]),

 ("SY","The number of lines of symmetry in a rectangle (that is not a square) is:",
   "2",
   C("A non-square rectangle has 2 lines of symmetry — the two lines joining the midpoints of opposite sides. Its diagonals are NOT lines of symmetry.")+
   steps("Fold a rectangle so top meets bottom: halves match (1 line)","fold so left meets right: halves match (1 line)","the diagonals do not match, so total = 2 lines.")+
   U("A rectangular door folds into matching halves along its two midlines — 2 lines of symmetry."),
   [("4","4 is the SQUARE's count; a non-square rectangle has only 2 lines of symmetry."),
    ("1","1 is too few; a rectangle folds into matching halves along 2 midlines."),
    ("0","A rectangle does have symmetry — 2 lines, along its midlines, not 0.")]),

 ("SY","Drawing every possible diameter, how many lines of symmetry does a full circle have?",
   "infinitely many",
   C("Every line through the centre of a circle (a diameter) divides it into two matching halves, so a circle has infinitely many lines of symmetry.")+
   steps("Draw any line through the centre of a circle","it splits the circle into two equal matching halves","since there are endless such lines, the circle has infinitely many.")+
   U("A round plate looks identical no matter which way you fold it through the centre."),
   [("4","A circle is not limited to 4; EVERY diameter is a line of symmetry, so there are infinitely many."),
    ("1","Far more than 1; any line through the centre works, giving infinitely many lines of symmetry."),
    ("0","A circle is highly symmetric; it has infinitely many lines of symmetry, not zero.")]),

 ("SY","The number of lines of symmetry in the capital letter H is:",
   "2",
   C("The letter H has 2 lines of symmetry: one vertical (down its middle) and one horizontal (across its middle).")+
   steps("Fold H left-to-right: halves match (vertical line)","fold H top-to-bottom: halves match (horizontal line)","so H has 2 lines of symmetry.")+
   U("Letters like H, I and X have both a vertical and a horizontal line of symmetry."),
   [("1","1 misses one of H's two lines; it is symmetric both vertically AND horizontally, giving 2."),
    ("0","H is symmetric; it has 2 lines of symmetry, not zero."),
    ("4","4 is too many; H has just 2 lines of symmetry, vertical and horizontal.")]),

 ("SY","The number of lines of symmetry in the capital letter A is:",
   "1",
   C("The letter A has just 1 line of symmetry — the vertical line down its middle. It is not symmetric top-to-bottom.")+
   steps("Fold A left-to-right: the two halves match (vertical line)","fold A top-to-bottom: the halves do NOT match","so A has only 1 line of symmetry.")+
   U("Letters like A, M, T, U and V each have a single vertical line of symmetry."),
   [("2","A is symmetric only vertically, not horizontally, so it has 1 line, not 2."),
    ("0","A does have a vertical line of symmetry, so it has 1, not zero."),
    ("3","3 is far too many; A has exactly 1 line of symmetry.")]),

 ("SY","When turned once fully about its centre, a square matches itself how many times — its order of rotational symmetry?",
   "4",
   C("A square looks the same 4 times during one full turn (at 90°, 180°, 270°, 360°), so its order of rotational symmetry is 4.")+
   steps("Turn a square about its centre through a full circle","it matches its starting look at every 90°","that is 4 matches in 360°, so order 4.")+
   U("A square table looks identical after each quarter-turn — order of rotational symmetry 4."),
   [("1","Order 1 means it matches only after a full turn; a square matches 4 times, so order 4."),
    ("2","2 fits a rectangle; a SQUARE matches every 90°, giving order 4."),
    ("8","8 is too many; the square repeats its look 4 times in a full turn, so order 4.")]),

 ("SY","Turned once fully about its centre, an equilateral triangle matches itself how many times — its order of rotational symmetry?",
   "3",
   C("An equilateral triangle matches its starting look 3 times in a full turn (every 120°), so its order of rotational symmetry is 3.")+
   steps("Turn the triangle about its centre through 360°","it looks the same every 120°","that is 3 matches, so the order is 3.")+
   U("A three-bladed fan, like an equilateral triangle, looks the same after each one-third turn."),
   [("1","Order 1 means a match only after a full turn; the equilateral triangle matches 3 times, order 3."),
    ("6","6 is too many; the equilateral triangle repeats its look 3 times per turn, so order 3."),
    ("2","2 fits a shape matching every half-turn; the equilateral triangle has order 3.")]),

 ("SY","The smallest angle through which a square must be turned to look exactly the same as before is:",
   "90°",
   C("A square has order-4 rotational symmetry, so the smallest turn that maps it onto itself is 360° ÷ 4 = 90°.")+
   steps("A square matches itself 4 times in a full 360° turn","smallest matching angle = 360° ÷ 4","= 90°.")+
   U("Give a square tile a quarter-turn (90°) and you cannot tell it has moved."),
   [("45°","45° is half of 90°; a square does not match at 45°, only at 90° and its multiples."),
    ("180°","180° is a match, but it is not the SMALLEST; the square already matches at 90°."),
    ("360°","360° is a full turn (every shape matches); the smallest angle for a square is 90°.")]),

 ("SY","The number of lines of symmetry in a scalene triangle (all sides different) is:",
   "0",
   C("A scalene triangle has all three sides of different lengths, so no fold makes its halves match — it has 0 lines of symmetry.")+
   steps("Try folding a scalene triangle along any line","because all sides differ, the halves never match","so it has 0 lines of symmetry.")+
   U("A triangle with three unequal sides, like many roof gables, has no line of symmetry."),
   [("1","An ISOSCELES triangle (two equal sides) has 1 line; a SCALENE triangle has 0."),
    ("3","3 lines belong to the EQUILATERAL triangle; a scalene triangle has 0."),
    ("2","No triangle has exactly 2 lines of symmetry; a scalene one has 0.")]),

 ("SY","The number of lines of symmetry in an isosceles triangle (exactly two equal sides) is:",
   "1",
   C("An isosceles triangle has 1 line of symmetry — the line from the apex (between the equal sides) to the midpoint of the base.")+
   steps("Fold from the top vertex to the middle of the base","the two equal sides fall on each other","so there is exactly 1 line of symmetry.")+
   U("A typical roof gable shaped like an isosceles triangle has a single vertical line of symmetry."),
   [("0","0 fits a scalene triangle; an isosceles triangle has 1 line of symmetry."),
    ("2","An isosceles triangle has just 1 line of symmetry, not 2."),
    ("3","3 lines belong to the equilateral triangle; the isosceles one has 1.")]),

 ("SY","The number of lines of symmetry in a regular pentagon (5 equal sides) is:",
   "5",
   C("A regular pentagon has 5 lines of symmetry — one from each vertex to the midpoint of the opposite side.")+
   steps("From each of the 5 vertices draw a fold to the opposite side's midpoint","each fold makes the halves match","5 vertices give 5 lines of symmetry.")+
   U("A regular pentagon, like the panels on some footballs, has 5 lines of symmetry."),
   [("4","4 fits a square; a regular pentagon has 5 lines of symmetry, one per vertex."),
    ("1","1 is far too few; a regular pentagon has 5 lines of symmetry."),
    ("10","10 doubles the count; a regular pentagon has exactly 5 lines of symmetry.")]),

 ("SY","Which of these capital letters has BOTH line symmetry and rotational symmetry (of order more than 1)?",
   "O",
   C("The letter O has many lines of symmetry AND looks the same when turned half-way (order-2 rotational symmetry), so it has both kinds.")+
   steps("Check O for folding: it matches along vertical and horizontal lines → line symmetry","turn O by 180°: it looks the same → rotational symmetry","so O has both.")+
   U("Round, balanced letters like O have both line and rotational symmetry."),
   [("F","F has neither a line of symmetry nor rotational symmetry; O has both."),
    ("P","P has no line of symmetry and no rotational symmetry; O is the one with both."),
    ("R","R has neither line nor rotational symmetry; the letter with both is O.")]),

 ("SY","Saying that a shape has reflection symmetry is just another way of saying it has a:",
   "mirror line (line of symmetry)",
   C("Reflection symmetry means one half is the mirror image of the other across a line; that line is the mirror line, or line of symmetry.")+
   steps("Place a mirror along a line of the figure","if the reflection completes the figure exactly","that line is the mirror line — the figure has reflection symmetry.")+
   U("Standing a small mirror down the middle of a symmetric drawing recreates the whole picture."),
   [("centre of rotation","A centre of rotation is for TURNING symmetry; reflection symmetry is about a mirror line."),
    ("pair of parallel sides","Parallel sides do not by themselves give reflection symmetry; a mirror line does."),
    ("right angle","A right angle is a 90° corner, unrelated to reflection; reflection symmetry needs a mirror line.")]),

 ("SY","Held up to a plane mirror, which of these capital letters looks exactly the SAME as its mirror image?",
   "M",
   C("A letter with a vertical line of symmetry (like A, H, M, T, U, V, W) is unchanged by a mirror's left-right flip; M is such a letter.")+
   steps("A plane mirror swaps left and right","a letter symmetric about a vertical line is unchanged by that swap","M is vertically symmetric, so it reads the same.")+
   U("The word MUM has all vertically symmetric letters, so it reads MUM in a mirror too."),
   [("L","L has no vertical line of symmetry, so a mirror flips it to a backwards shape — it changes."),
    ("G","G is not symmetric about a vertical line; a mirror reverses it, changing how it looks."),
    ("F","F lacks vertical symmetry; in a mirror its arms point the wrong way, so it changes.")]),

 ("SY","The number of lines of symmetry in a rhombus (a slanted diamond with 4 equal sides) is:",
   "2",
   C("A rhombus has 2 lines of symmetry — its two diagonals. Its sides' midlines are NOT lines of symmetry (unlike a square).")+
   steps("Fold a rhombus along each diagonal: the halves match","fold along a midline of the sides: the halves do NOT match","so a rhombus has 2 lines of symmetry, the diagonals.")+
   U("A diamond shape on a playing card folds into matching halves along its two diagonals."),
   [("4","4 is the SQUARE's count; a (non-square) rhombus has only its 2 diagonals as lines of symmetry."),
    ("1","1 is too few; both diagonals of a rhombus are lines of symmetry, giving 2."),
    ("0","A rhombus does have symmetry — 2 lines along its diagonals, not zero.")]),

 ("SY","The order of rotational symmetry of a rectangle (that is not a square) is:",
   "2",
   C("A non-square rectangle looks the same twice in a full turn — at 180° and 360° — so its order of rotational symmetry is 2.")+
   steps("Turn a rectangle about its centre","it matches its look after a half-turn (180°) and a full turn","that is 2 matches, so order 2.")+
   U("A rectangular photo frame looks the same after a half-turn — order of rotational symmetry 2."),
   [("4","4 is the SQUARE's order; a non-square rectangle matches only at 180° and 360°, order 2."),
    ("1","Order 1 means a match only after a full turn; a rectangle also matches at 180°, so order 2."),
    ("3","3 fits an equilateral triangle; a rectangle has rotational order 2.")]),

 ("SY","What is the least angle of turn that brings an equilateral triangle back to looking the same?",
   "120°",
   C("An equilateral triangle has order-3 rotational symmetry, so the smallest turn that maps it onto itself is 360° ÷ 3 = 120°.")+
   steps("It matches itself 3 times in a full 360° turn","smallest matching angle = 360° ÷ 3","= 120°.")+
   U("A three-bladed fan returns to the same look after a 120° turn."),
   [("60°","60° is half of 120°; the equilateral triangle does not match at 60°, only at 120° and its multiples."),
    ("90°","90° fits a square (order 4); the equilateral triangle's smallest turn is 120°."),
    ("360°","360° is a full turn that maps every shape; the smallest for this triangle is 120°.")]),

 ("SY","A parallelogram that is not a rectangle or rhombus has how many lines of symmetry?",
   "0",
   C("A general parallelogram has NO line of symmetry (no fold makes its halves match), though it does have rotational symmetry of order 2.")+
   steps("Try folding a slanted parallelogram along any line","the halves never fall exactly on each other","so it has 0 lines of symmetry.")+
   U("A leaning parallelogram tile has no mirror line, yet a half-turn leaves it looking the same."),
   [("1","A general parallelogram has NO line of symmetry; the answer is 0, not 1."),
    ("2","2 lines belong to a rectangle or rhombus; a general parallelogram has 0."),
    ("4","4 is the square's count; a slanted parallelogram has 0 lines of symmetry.")]),

 ("SY","The number of lines of symmetry in a regular hexagon (6 equal sides) is:",
   "6",
   C("A regular hexagon has 6 lines of symmetry — 3 through opposite vertices and 3 through midpoints of opposite sides.")+
   steps("Fold through opposite corners: 3 matching lines","fold through opposite side-midpoints: 3 more matching lines","total = 3 + 3 = 6 lines of symmetry.")+
   U("A regular hexagon, like a honeycomb cell, has 6 lines of symmetry."),
   [("3","3 counts only one set of folds; a regular hexagon also folds through side-midpoints, giving 6."),
    ("4","4 is the square's count; a regular hexagon has 6 lines of symmetry."),
    ("12","12 doubles the count; a regular hexagon has exactly 6 lines of symmetry.")]),

 ("SY","The capital letter S has no line of symmetry, yet it looks the same when turned upside down (180°). This means S has:",
   "rotational symmetry but no line symmetry",
   C("S matches itself after a half-turn (order-2 rotational symmetry) but no fold makes its halves match, so it has rotational symmetry without line symmetry.")+
   steps("Fold S any way: the halves never match → no line symmetry","turn S by 180°: it looks the same → rotational symmetry","so S has rotational symmetry but no line symmetry.")+
   U("Letters S, N and Z all look the same upside down but have no mirror line."),
   [("line symmetry but no rotational symmetry","It is the other way round: S has rotational symmetry and NO line symmetry."),
    ("both line and rotational symmetry","S has no line of symmetry, so it cannot have both; it has only rotational symmetry."),
    ("neither line nor rotational symmetry","S does match after a 180° turn, so it DOES have rotational symmetry, just no line symmetry.")]),

 ("SY","The number of lines of symmetry in the digit 8 (written in its symmetric printed form) is:",
   "2",
   C("The digit 8, drawn symmetrically, has 2 lines of symmetry — one vertical (down the middle) and one horizontal (across the middle).")+
   steps("Fold 8 left-to-right: halves match (vertical line)","fold 8 top-to-bottom: halves match (horizontal line)","so 8 has 2 lines of symmetry.")+
   U("A printed figure-8, like two stacked circles, folds into matching halves both ways."),
   [("1","1 misses one line; the symmetric 8 is symmetric both vertically AND horizontally, giving 2."),
    ("0","The digit 8 is symmetric; it has 2 lines of symmetry, not zero."),
    ("4","4 is too many; the digit 8 has exactly 2 lines of symmetry.")]),

 ("SY","A heating coil is laid out so that its left half is a mirror image of its right half about a central vertical line. This central line is the coil's:",
   "line of symmetry",
   C("If the left half is the mirror image of the right across a line, that line is a line of symmetry — the figure has reflection (line) symmetry about it.")+
   steps("The left half mirrors the right half across the central line","that is exactly the test for a line of symmetry","so the central line is the coil's line of symmetry.")+
   U("Many appliance parts are designed with a line of symmetry so the two halves balance and match."),
   [("centre of rotation","A centre of rotation is a point for turning symmetry; a line that mirrors two halves is a line of symmetry."),
    ("angle of incidence","Angle of incidence is a light-ray term; a line mirroring two equal halves is a line of symmetry."),
    ("diagonal of a square","The described line is a mirror line for the two halves — a line of symmetry — not specifically a square's diagonal.")]),

 ("SY","The number of lines of symmetry in a semicircle (half a disc) is:",
   "1",
   C("A semicircle has just 1 line of symmetry — the line drawn from the midpoint of its straight edge perpendicular to it, splitting it into two matching halves.")+
   steps("Fold the semicircle along the line through the middle of its flat edge","the two quarter-disc halves match exactly","so a semicircle has 1 line of symmetry.")+
   U("A protractor, shaped like a semicircle, folds into matching halves along its central line."),
   [("2","A semicircle has only 1 line of symmetry; folding any other way does not make the halves match."),
    ("infinitely many","A FULL circle has infinitely many; a semicircle has just 1 line of symmetry."),
    ("0","A semicircle does have symmetry — 1 line through the middle of its straight edge.")]),
]

# ---------- assemble: interleave so no two consecutive share a chapter ----------
assert all(len(b) == 25 for b in (HT, EC, SE, SY)), [len(HT), len(EC), len(SE), len(SY)]
items = []
for i in range(25):
    items += [HT[i], EC[i], SE[i], SY[i]]
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

    keydist = build_paper(PNUM, TITLE, SHORT, LABELS, items, seed=47053,
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
    split = "/".join(str(counts[c]) for c in ("HT", "EC", "SE", "SY"))
    with open("PAPERS_MANIFEST.md", "a", encoding="utf-8") as fh:
        fh.write(f"| {PNUM} | 2026-06-18 | {TITLE} | {split} | ✓ |\n")

    # ---- update QUESTION_INDEX.json ----
    idx["fingerprints"] = sorted(existing | set(new_fps))
    idx.setdefault("combos", []).append({
        "paper": PNUM,
        "chapters": ["Heat",
                     "Electric Current & its Effects",
                     "Simple Equations",
                     "Symmetry"],
    })
    idx["papers"] = idx.get("papers", 0) + 1
    with open(idx_path, "w", encoding="utf-8") as fh:
        json.dump(idx, fh, ensure_ascii=False, indent=2)
        fh.write("\n")

    print("Files:", sorted(v for v in moves.values()))
    print("Answer key spread A/B/C/D =", dict(keydist))
