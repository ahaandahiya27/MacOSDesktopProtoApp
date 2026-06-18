# -*- coding: utf-8 -*-
# Boss Challenge Paper 33 — Motion & Time · Electric Current & its Effects · Simple Equations · Fractions & Decimals
# Content-only. Uses the dependency-free examfactory engine.
# Difficulty ramp: this paper leans HARD into FUSION. Speed = distance ÷ time is the bridge — several
# Simple-Equations items wear a Motion coat (2s = 60 → s = 30 km/h; n+1 cells), and several
# Fractions-&-Decimals items decode a Science situation (3.6 m in 2 s → 1.8 m/s; a fuse rated in amperes).
# The child reads a Science context and applies a Maths skill. Class-7 scope, simple wording, hard thinking.
# Produces, under Resources/BossChallengePapers/:
#   Paper_33_<SHORT>_QuestionPaper.html  (pure HTML — questions + options)
#   Paper_33_<SHORT>_QuestionPaper.pdf
#   Paper_33_<SHORT>_Questions.md
#   Paper_33_<SHORT>_Solutions.html
import os, sys, shutil, json, re
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from examfactory import build_paper, C, steps, U

PNUM  = "33"
SHORT = "MotionTime_Electricity_SimpleEquations_FracDecimals"
TITLE = ("Motion & Time · Electric Current & its Effects · Simple Equations · Fractions & Decimals")
LABELS = {
    "MT": "Motion & Time",
    "EC": "Electric Current & its Effects",
    "SE": "Simple Equations",
    "FD": "Fractions & Decimals",
}

# ---------- MOTION & TIME (25) — Science ----------
MT = [
 ("MT","The distance covered by a moving body in one unit of time is called its:",
   "speed",
   C("How much ground a body covers in each unit of time is its speed.")+
   steps("Watch how far a body goes in one second","more ground per second means it is moving faster","this distance-per-unit-time is the speed."),
   [("mass","Mass is how much matter a body has, not how far it travels each second."),
    ("weight","Weight is the pull of gravity on a body, not its distance per unit time."),
    ("volume","Volume is the space a body takes up, nothing to do with how fast it moves.")]),

 ("MT","Among these, the most common SI unit used to measure speed is:",
   "metre per second (m/s)",
   C("In the SI system speed is measured in metres per second, written m/s.")+
   steps("Distance in SI is measured in metres","time in SI is measured in seconds","so speed, distance ÷ time, comes out in metres per second."),
   [("kilogram (kg)","The kilogram measures mass, not speed."),
    ("second (s)","The second measures time alone, not speed, which needs distance ÷ time."),
    ("metre (m)","The metre measures distance only; speed also needs the time, giving m/s.")]),

 ("MT","A body that covers equal distances in equal intervals of time is said to be in:",
   "uniform motion",
   C("When a body moves so that equal distances take equal times, its motion is uniform.")+
   steps("Mark the distance covered each second","if every second the same distance is covered","the speed never changes — this is uniform motion."),
   [("non-uniform motion","Non-uniform motion means the distances per second keep changing, not staying equal."),
    ("rest","A body at rest covers no distance at all, so it is not in motion."),
    ("circular motion","Circular motion is about the path's shape, not about equal distances per second.")]),

 ("MT","The instrument fitted in a vehicle to measure the total distance it has travelled is the:",
   "odometer",
   C("The dial that totals up the distance a vehicle has run is the odometer.")+
   steps("A driver wants to know the distance covered","a meter quietly adds up every kilometre run","that distance-totalling meter is the odometer."),
   [("speedometer","A speedometer shows the current speed, not the total distance travelled."),
    ("thermometer","A thermometer measures temperature, not distance."),
    ("barometer","A barometer measures air pressure, not the distance a car has run.")]),

 ("MT","The instrument that shows a driver the speed of the vehicle at that moment is the:",
   "speedometer",
   C("The dial showing how fast a vehicle is going right now is the speedometer.")+
   steps("A driver needs to know the present speed","a meter reads it off directly in km/h","that speed-showing dial is the speedometer."),
   [("odometer","An odometer totals the distance travelled, not the present speed."),
    ("voltmeter","A voltmeter measures voltage in a circuit, not vehicle speed."),
    ("compass","A compass shows direction, not how fast the vehicle is moving.")]),

 ("MT","One complete to-and-fro swing of a pendulum, from a point back to the same point, is called one:",
   "oscillation",
   C("A pendulum's full there-and-back swing counts as one oscillation.")+
   steps("Start the bob at one extreme","let it swing across and come right back","that complete to-and-fro trip is one oscillation."),
   [("revolution","A revolution is a full circular turn, not a back-and-forth swing."),
    ("rotation","Rotation is spinning about an axis, not a pendulum's to-and-fro swing."),
    ("vibration of sound","A sound vibration is far too fast to see; here we count the pendulum's swings.")]),

 ("MT","For a swinging pendulum, the number of seconds needed for one full oscillation is known as its:",
   "time period",
   C("The seconds a pendulum needs for a single oscillation is its time period.")+
   steps("Pick one full to-and-fro swing","measure how many seconds it takes","that one-swing time is the time period."),
   [("speed","Speed is distance per unit time of a moving body, not the time for one swing."),
    ("frequency","Frequency counts swings per second; the time for one swing is the time period."),
    ("amplitude","Amplitude is how far the bob swings sideways, not the time it takes.")]),

 ("MT","The basic SI unit in which we measure time is the:",
   "second",
   C("Time in the SI system is measured in seconds.")+
   steps("We need one agreed unit for time","the SI system chooses the second","so time is measured in seconds."),
   [("metre","The metre measures length, not time."),
    ("kilogram","The kilogram measures mass, not time."),
    ("hour","An hour is a larger time unit; the basic SI unit of time is the second.")]),

 ("MT","To find the SPEED of a body when its distance and time are known, you use:",
   "speed = distance ÷ time",
   C("Speed is found by dividing the distance covered by the time taken.")+
   steps("Write down the distance covered","write down the time taken","divide distance by time to get the speed."),
   [("speed = distance × time","Multiplying would not give speed; speed is distance DIVIDED by time."),
    ("speed = time ÷ distance","This flips the rule; distance goes on top, so speed = distance ÷ time."),
    ("speed = distance + time","You cannot add a distance to a time; speed is distance ÷ time.")]),

 ("MT","A car covers 60 kilometres in 2 hours. Its speed is:",
   "30 km/h",
   C("Speed = distance ÷ time = 60 km ÷ 2 h = 30 km/h.")+
   steps("Write speed = distance ÷ time","put in 60 km ÷ 2 h","60 ÷ 2 = 30, so the speed is 30 km/h."),
   [("120 km/h","120 multiplies 60 by 2; speed needs distance DIVIDED by time, giving 30."),
    ("62 km/h","62 adds 60 and 2; speed is 60 ÷ 2 = 30 km/h, not a sum."),
    ("2 km/h","2 is the time in hours, not the speed; 60 ÷ 2 = 30 km/h.")]),

 ("MT","On a distance–time graph, the line for a body that stays at REST is:",
   "a horizontal straight line",
   C("A resting body covers no extra distance as time passes, so its graph is a flat, horizontal line.")+
   steps("As time ticks on, the distance does not change","plotting that gives the same height all along","so the line stays flat — horizontal."),
   [("a slanting straight line","A slanting line means the distance keeps growing — that is motion, not rest."),
    ("a vertical straight line","A vertical line would mean distance changing with no time passing, which is impossible."),
    ("a wavy curved line","A wavy line shows changing motion; a body at rest gives a flat horizontal line.")]),

 ("MT","On a distance–time graph, the line for a body in UNIFORM motion is:",
   "a slanting straight line",
   C("In uniform motion equal distances are covered in equal times, so the graph is a straight slanting line.")+
   steps("Each second the same extra distance is added","plotting these equal steps gives a straight rise","so the uniform-motion graph is a slanting straight line."),
   [("a horizontal straight line","A horizontal line means no distance is added — that is rest, not motion."),
    ("a zig-zag broken line","A zig-zag would show speeding up and slowing; uniform motion is a straight slant."),
    ("a circle","A distance–time graph for steady motion is a straight slanting line, not a circle.")]),

 ("MT","A train covers 150 kilometres in 3 hours at a steady speed. Its speed is:",
   "50 km/h",
   C("Speed = distance ÷ time = 150 km ÷ 3 h = 50 km/h.")+
   steps("Write speed = distance ÷ time","put in 150 km ÷ 3 h","150 ÷ 3 = 50, so the speed is 50 km/h."),
   [("450 km/h","450 multiplies 150 by 3; speed needs distance ÷ time, giving 50."),
    ("153 km/h","153 adds 150 and 3; speed is 150 ÷ 3 = 50 km/h, not a sum."),
    ("3 km/h","3 is the time in hours, not the speed; 150 ÷ 3 = 50 km/h.")]),

 ("MT","A speed of 10 m/s tells us that the body, each second, covers:",
   "10 metres",
   C("A speed of 10 m/s means exactly 10 metres are covered in every single second.")+
   steps("Read the unit: metres PER second","that is metres covered in one second","so 10 m/s means 10 metres each second."),
   [("10 seconds","10 m/s gives the distance per second, which is 10 metres, not a time."),
    ("10 kilometres","The unit is metres per second, so it is 10 metres, not 10 kilometres, per second."),
    ("100 metres","100 metres would be covered in 10 seconds; in one second it is 10 metres.")]),

 ("MT","To find the TIME taken when the distance and the speed are known, you use:",
   "time = distance ÷ speed",
   C("Rearranging speed = distance ÷ time gives time = distance ÷ speed.")+
   steps("Start from speed = distance ÷ time","swap to make time the subject","this gives time = distance ÷ speed."),
   [("time = distance × speed","Multiplying is wrong; time is distance DIVIDED by speed."),
    ("time = speed ÷ distance","This flips it; distance goes on top, so time = distance ÷ speed."),
    ("time = speed × distance","Time is found by dividing distance by speed, not by multiplying.")]),

 ("MT","To find the DISTANCE covered when the speed and the time are known, you use:",
   "distance = speed × time",
   C("Rearranging speed = distance ÷ time gives distance = speed × time.")+
   steps("Start from speed = distance ÷ time","make distance the subject","this gives distance = speed × time."),
   [("distance = speed ÷ time","Dividing is wrong here; distance = speed MULTIPLIED by time."),
    ("distance = time ÷ speed","This flips and divides; distance = speed × time."),
    ("distance = speed + time","You cannot add a speed to a time; distance = speed × time.")]),

 ("MT","A pendulum makes 20 complete oscillations in 40 seconds. Its time period is:",
   "2 seconds",
   C("Time period = total time ÷ number of oscillations = 40 s ÷ 20 = 2 s.")+
   steps("Write time period = total time ÷ number of swings","put in 40 s ÷ 20","40 ÷ 20 = 2, so each swing takes 2 seconds."),
   [("20 seconds","20 is the number of swings, not the time for one; 40 ÷ 20 = 2 s."),
    ("40 seconds","40 s is the time for all 20 swings; one swing takes 40 ÷ 20 = 2 s."),
    ("800 seconds","800 multiplies 40 by 20; the time period is 40 ÷ 20 = 2 s.")]),

 ("MT","Compared with an old sand-clock or sundial, a modern quartz wrist-watch is:",
   "much more accurate",
   C("Quartz clocks keep far steadier time than old sundials or sand-clocks, so they are much more accurate.")+
   steps("Old clocks drift with sun, sand or weather","a quartz crystal vibrates very steadily","so a quartz watch keeps time far more accurately."),
   [("much less accurate","Quartz watches are MORE accurate than old sundials, not less."),
    ("exactly as accurate","Quartz is a clear improvement; it is more accurate, not merely equal."),
    ("useless for telling time","Quartz watches tell time very well — that is why they are everywhere.")]),

 ("MT","A body whose speed keeps changing from moment to moment is moving in:",
   "non-uniform motion",
   C("When the distance covered each second is not the same, the speed changes — that is non-uniform motion.")+
   steps("Check the distance covered each second","here it is different each time","changing speed means the motion is non-uniform."),
   [("uniform motion","Uniform motion needs an unchanging speed; here the speed changes."),
    ("rest","A body at rest is not moving at all, so this is not rest."),
    ("straight-line uniform motion","If the speed changes, the motion is non-uniform even on a straight road.")]),

 ("MT","An ancient device that tells the time of day from the shadow cast by the Sun is a:",
   "sundial",
   C("A sundial reads the time from the position of a shadow the Sun throws across its face.")+
   steps("The Sun moves across the sky through the day","a fixed pointer casts a shadow that swings round","reading that shadow's position gives the time — a sundial."),
   [("pendulum clock","A pendulum clock uses a swinging bob, not the Sun's shadow."),
    ("quartz watch","A quartz watch uses a vibrating crystal, not a shadow."),
    ("speedometer","A speedometer shows a vehicle's speed, not the time of day from a shadow.")]),

 ("MT","A body moves at a steady 5 m/s for 12 seconds. The distance it covers is:",
   "60 metres",
   C("Distance = speed × time = 5 m/s × 12 s = 60 m.")+
   steps("Write distance = speed × time","put in 5 m/s × 12 s","5 × 12 = 60, so it covers 60 metres."),
   [("17 metres","17 adds 5 and 12; distance = speed × time = 5 × 12 = 60 m."),
    ("2.4 metres","2.4 divides 12 by 5; distance is speed × time = 60 m, not a division."),
    ("5 metres","5 is the speed in m/s, not the distance; 5 × 12 = 60 m.")]),

 ("MT","The faster of two bodies, given the same length of time, will always cover:",
   "more distance",
   C("In an equal time, a faster body covers more ground than a slower one.")+
   steps("Give both bodies the same time","the faster one moves more metres each second","so in that time it covers more distance."),
   [("less distance","A faster body covers MORE, not less, distance in the same time."),
    ("exactly the same distance","Equal distance in equal time would mean equal speeds, but one is faster."),
    ("no distance at all","A moving body covers some distance; the faster one covers more.")]),

 ("MT","A simple pendulum is useful for measuring time mainly because its time period stays:",
   "almost the same for each swing",
   C("A simple pendulum's time period barely changes from swing to swing, so it can mark off equal time intervals.")+
   steps("Set a pendulum swinging","each to-and-fro swing takes nearly the same time","this steady beat lets it measure time."),
   [("longer with every swing","If each swing took longer it could not keep steady time; the period stays nearly constant."),
    ("shorter with every swing","A shortening period would be useless for timing; the period stays nearly constant."),
    ("completely random each swing","Random swings could not mark time; the pendulum's period is nearly constant.")]),

 ("MT","The unit 'km/h', often seen on road signs, is used to measure the:",
   "speed of vehicles",
   C("Kilometres per hour (km/h) is a unit of speed, commonly used for vehicles on roads.")+
   steps("Read the unit: kilometres PER hour","that is distance covered in each hour","so km/h measures speed, here of vehicles."),
   [("mass of vehicles","Mass is measured in kilograms, not km/h."),
    ("time of a journey","Time is measured in hours or seconds; km/h is a speed."),
    ("fuel in the tank","Fuel is measured in litres; km/h is a speed unit.")]),

 ("MT","The shape of a distance–time graph is useful because, at a glance, it tells us whether the motion is:",
   "uniform or non-uniform",
   C("A straight slanting line shows uniform motion while a curved or bending line shows non-uniform motion, so the graph's shape reveals the kind of motion.")+
   steps("Look at the line on the graph","a straight slant means equal distances in equal times","a bending line means changing speed — so the shape shows uniform vs non-uniform."),
   [("the colour of the vehicle","A graph's line cannot show a vehicle's colour, only its motion."),
    ("the price of the fuel","Distance and time say nothing about fuel price."),
    ("the driver's name","A distance–time graph shows motion, not who is driving.")]),
]

MT_UC = [
 "Knowing speed is distance per time is how you judge whether a bus will reach school before the bell.",
 "Using m/s is how scientists compare the speeds of a runner, a car and the wind on one fair scale.",
 "Spotting uniform motion is how a train driver keeps a smooth ride at one steady speed.",
 "Reading an odometer is how a family knows when the car is due for its next service.",
 "Glancing at the speedometer is how a driver stays under the speed limit on a busy road.",
 "Counting one oscillation is the very thing that lets a pendulum clock tick off each second.",
 "Measuring a time period is how a clock-maker tunes a pendulum to swing exactly once a second.",
 "Using the second as the base unit lets stopwatches, races and experiments all agree on time.",
 "Using speed = distance ÷ time is how a coach works out an athlete's pace from a timed run.",
 "Working out 60 km in 2 h is the everyday sum behind planning when a road trip will arrive.",
 "Reading a flat distance–time line is how you instantly see a parked car has not moved.",
 "Reading a slanting line is how you spot at a glance that a body is moving at a steady speed.",
 "Finding 150 km in 3 h is exactly how a timetable-maker sets the speed a train must keep.",
 "Reading 10 m/s as ten metres a second is how you picture just how fast a sprinter really is.",
 "Using time = distance ÷ speed is how you predict how long a known journey will take.",
 "Using distance = speed × time is how you work out how far a car will get in an hour.",
 "Dividing swings into total time is how a lab finds a pendulum's period without guessing.",
 "Knowing quartz is more accurate is why exam halls and races trust modern digital clocks.",
 "Spotting non-uniform motion is how you describe a car braking and accelerating in city traffic.",
 "Recognising a sundial explains how people told the time for centuries before clocks existed.",
 "Using distance = speed × time is how a delivery rider estimates how far a 12-second dash covers.",
 "Knowing the faster body goes further is how you predict who wins a race over a fixed time.",
 "Trusting a pendulum's steady period is why grandfather clocks could keep time for over a century.",
 "Reading km/h on a sign is how every driver judges a safe speed for the road ahead.",
 "Reading a graph's shape is how a scientist tells steady motion from changing motion in one look.",
]

# ---------- ELECTRIC CURRENT & ITS EFFECTS (25) — Science ----------
EC = [
 ("EC","A single device that pushes out electricity using the chemicals stored inside it is a:",
   "cell",
   C("A cell stores chemical energy and uses it to drive an electric current; it is the basic source.")+
   steps("Chemicals inside store energy","they push electric charge round a circuit","this single source is an electric cell."),
   [("bulb","A bulb uses up electricity to give light; it does not produce the current."),
    ("switch","A switch only opens or closes the path; it does not make electricity."),
    ("wire","A wire carries the current; it does not produce it.")]),

 ("EC","When two or more cells are joined together to give more push, the combination is called a:",
   "battery",
   C("Several cells linked together form a battery, giving a bigger push than one cell alone.")+
   steps("One cell gives a small push","join two or more cells in a row","this group of cells is a battery."),
   [("a single cell","One cell on its own is just a cell; a battery is two or more joined."),
    ("a fuse","A fuse is a safety device that melts; it is not a group of cells."),
    ("a filament","A filament is the glowing wire in a bulb, not a group of cells.")]),

 ("EC","The thin coiled wire inside a torch bulb that glows brightly when current flows is the:",
   "filament",
   C("The bulb's thin coiled wire heats up and glows white-hot; this is the filament.")+
   steps("Current flows through the bulb's thin wire","the wire gets very hot and glows","that glowing thin wire is the filament."),
   [("terminal","A terminal is a connecting point of a cell, not the glowing wire."),
    ("switch","A switch opens or closes the circuit; it does not glow to give light."),
    ("electromagnet","An electromagnet is a current-made magnet, not the glowing wire of a bulb.")]),

 ("EC","When an electric current passes through a wire and makes it hot, this is called the current's:",
   "heating effect",
   C("A current warming up the wire it flows through shows the heating effect of electric current.")+
   steps("Pass a current through a wire","the wire grows warm or even hot","this warming is the heating effect of current."),
   [("magnetic effect","The magnetic effect makes a compass turn; warming the wire is the heating effect."),
    ("chemical effect","The chemical effect changes substances; here the wire simply heats up."),
    ("cooling effect","Current does not cool a wire; it warms it — the heating effect.")]),

 ("EC","A safety device that melts and breaks the circuit when too large a current flows is a:",
   "fuse",
   C("A fuse contains a wire that melts if the current grows too big, safely breaking the circuit.")+
   steps("Too large a current heats the fuse wire","the thin fuse wire melts and snaps","the broken circuit stops the dangerous current — a fuse."),
   [("cell","A cell is a source of current, not a safety device that melts."),
    ("bulb","A bulb gives light; it is not a safety device that protects the circuit."),
    ("switch","A switch is turned by hand; a fuse melts on its own to protect the circuit.")]),

 ("EC","A coil of wire wound on an iron piece that becomes a magnet only when current flows is an:",
   "electromagnet",
   C("A current-carrying coil round an iron core acts as a magnet while current flows; it is an electromagnet.")+
   steps("Wind a coil of wire on an iron rod","switch on the current","the iron becomes a magnet — an electromagnet."),
   [("permanent magnet","A permanent magnet stays magnetic always; an electromagnet works only with current."),
    ("filament","A filament is the glowing wire of a bulb, not a current-made magnet."),
    ("fuse","A fuse is a melting safety wire, not a coil that becomes a magnet.")]),

 ("EC","An electric bulb in a torch will glow only when the circuit is:",
   "closed (complete)",
   C("Current can flow and light the bulb only when the path forms an unbroken, closed loop.")+
   steps("The bulb needs current to flow through it","current flows only round an unbroken loop","so the bulb glows only when the circuit is closed."),
   [("open (broken)","In an open circuit the path is broken, so no current flows and the bulb stays dark."),
    ("made of glass","What the parts are made of does not make current flow; the loop must be closed."),
    ("painted black","Paint colour has nothing to do with whether the bulb glows; the loop must be closed.")]),

 ("EC","Materials such as copper and other metals, which let an electric current pass through them, are called:",
   "conductors",
   C("Materials that allow electric current to flow through them, like metals, are conductors.")+
   steps("Try to pass current through the material","metals like copper let it flow easily","such current-allowing materials are conductors."),
   [("insulators","Insulators block current; conductors are the ones that let it pass."),
    ("magnets","A magnet attracts iron; that is different from letting current pass."),
    ("fuses","A fuse is a safety device, not the general name for current-allowing materials.")]),

 ("EC","Materials such as rubber and plastic, which do NOT let an electric current pass, are called:",
   "insulators",
   C("Materials that block the flow of electric current, like rubber and plastic, are insulators.")+
   steps("Try to pass current through the material","rubber and plastic stop it","such current-blocking materials are insulators."),
   [("conductors","Conductors let current pass; insulators are the ones that block it."),
    ("batteries","A battery is a source of current, not a current-blocking material."),
    ("filaments","A filament is the glowing wire of a bulb, not a current-blocking material.")]),

 ("EC","Compared with an old filament bulb giving the same light, a CFL or LED lamp uses:",
   "less electricity",
   C("CFL and LED lamps give the same brightness while drawing far less electricity than a filament bulb.")+
   steps("A filament bulb wastes much energy as heat","a CFL or LED wastes far less","so for the same light it uses less electricity."),
   [("more electricity","CFL and LED lamps use LESS electricity, not more, than filament bulbs."),
    ("exactly the same electricity","They are clearly more efficient, so they use less, not the same."),
    ("no electricity at all","Every lamp needs some electricity to light up; CFL and LED just use less.")]),

 ("EC","A device used in homes that, like a fuse, breaks the circuit on too much current but can be reset is an:",
   "MCB (miniature circuit breaker)",
   C("An MCB trips to break the circuit when the current is too high and can be switched back on after — unlike a fuse it is reusable.")+
   steps("Too much current is dangerous","the MCB snaps the circuit open like a fuse","but it can be reset by hand, so it is reusable."),
   [("a permanent magnet","A permanent magnet does not break a circuit on overload."),
    ("a torch bulb","A bulb gives light; it does not protect the circuit by tripping."),
    ("a dry cell","A cell supplies current; it is not a resettable safety device.")]),

 ("EC","An electric bell rings because the current flowing through its coil turns the coil into an:",
   "electromagnet",
   C("Current through the bell's coil makes an electromagnet that pulls the hammer to strike the gong.")+
   steps("Current flows through the bell's coil","the coil becomes a magnet — an electromagnet","this magnet pulls the hammer to strike the bell."),
   [("insulator","An insulator blocks current; it cannot pull the bell's hammer."),
    ("a fuse","A fuse melts to protect a circuit; it does not ring a bell."),
    ("a cell","The cell supplies the current, but it is the coil-magnet that rings the bell.")]),

 ("EC","Bringing a compass needle near a wire carrying current makes the needle move. This shows the current's:",
   "magnetic effect",
   C("A current-carrying wire deflects a nearby compass needle, showing the magnetic effect of current.")+
   steps("Place a compass beside a current-carrying wire","the needle swings away from north","this swing shows the current has a magnetic effect."),
   [("heating effect","The heating effect warms the wire; turning a compass needle is the magnetic effect."),
    ("chemical effect","The chemical effect changes substances; deflecting a compass is the magnetic effect."),
    ("lighting effect","Lighting a bulb is not what is happening here; the compass shows the magnetic effect.")]),

 ("EC","Plugging too many appliances into one socket, drawing a very large current, is called:",
   "overloading",
   C("Drawing more current than the wiring can safely carry, by running too many appliances at once, is overloading.")+
   steps("Each appliance draws some current","too many on one socket add up to a huge current","this excess demand is called overloading."),
   [("earthing","Earthing safely carries stray current to the ground; it is not drawing too much."),
    ("insulating","Insulating covers wires to block current; it is not drawing too much current."),
    ("charging","Charging is filling a battery with energy, not overdrawing current from a socket.")]),

 ("EC","The heating element of an electric room heater is made of a special wire because that wire:",
   "becomes very hot without melting",
   C("The element is a special wire that glows red-hot to give heat yet does not melt at that temperature.")+
   steps("A heater must give out a lot of heat","its wire must get red-hot to do so","a special wire heats up strongly without melting."),
   [("stays completely cold","A heater's element must get hot to give heat, not stay cold."),
    ("blocks all current","If it blocked current it could not heat up at all."),
    ("turns into a magnet","A heater works by the heating effect, not by becoming a magnet.")]),

 ("EC","When the current to an electromagnet is switched OFF, the electromagnet:",
   "loses its magnetism",
   C("An electromagnet is a magnet only while current flows; switch the current off and the magnetism disappears.")+
   steps("The coil is a magnet because current flows","switch the current off","with no current the magnetism vanishes."),
   [("becomes a stronger magnet","Switching off REMOVES the magnetism; it does not strengthen it."),
    ("turns into a permanent magnet","An electromagnet is not permanent; off means no magnetism."),
    ("starts to give light","An electromagnet does not give light; switching off just removes its magnetism.")]),

 ("EC","Compared with one cell, two cells joined the correct way in a torch usually make the bulb glow:",
   "brighter",
   C("Two cells give a bigger push than one, so more current flows and the bulb glows brighter.")+
   steps("One cell gives a certain push","two cells joined correctly give a bigger push","more current flows, so the bulb glows brighter."),
   [("dimmer","More cells give more push and a brighter bulb, not a dimmer one."),
    ("not at all","Joined the right way, two cells make the bulb glow brighter, not go out."),
    ("a different colour","Adding a cell changes the brightness, not the colour of the bulb.")]),

 ("EC","The wire inside a fuse is chosen to have a LOW melting point so that it:",
   "melts quickly when the current is too high",
   C("A low-melting fuse wire melts fast on overload, breaking the circuit before damage is done.")+
   steps("A dangerous current heats the fuse wire","a low melting point lets it melt quickly","the circuit breaks fast and stays safe."),
   [("never melts at all","A fuse must melt on overload; a never-melting wire would not protect anything."),
    ("conducts no current","A fuse wire must carry the normal current; it only melts when it is too high."),
    ("glows to give light","A fuse is for safety, not for light; it melts when current is too high.")]),

 ("EC","In a circuit diagram, the device drawn as a small circle with a loop or cross inside stands for a:",
   "bulb",
   C("The standard symbol for an electric bulb is a small circle with a loop (or cross) inside it.")+
   steps("Each part has an agreed symbol","a circle with a loop inside is the agreed bulb symbol","so that symbol means a bulb."),
   [("cell","A cell is drawn as a long line and a short thick line, not a circle with a loop."),
    ("switch","A switch is shown as a line that lifts off a gap, not a circle with a loop."),
    ("wire","A wire is just a plain straight line, not a circle with a loop inside.")]),

 ("EC","For safety, you should never touch an electric switch or appliance when your hands are:",
   "wet",
   C("Water lets current pass, so touching electrical things with wet hands risks a dangerous shock.")+
   steps("Water conducts electricity","wet hands let current pass into the body","so touching switches with wet hands risks a shock — never do it."),
   [("clean and dry","Dry hands are the SAFE way to touch a switch; wet hands are the danger."),
    ("wearing rubber gloves","Rubber gloves are insulators and add safety; the danger is wet hands."),
    ("warm from the Sun","Warmth is not the hazard; wetness is, because water conducts current.")]),

 ("EC","In the symbol for a single cell, the longer thin line stands for the:",
   "positive terminal",
   C("By convention, the longer line in a cell symbol marks the positive terminal; the shorter thick line is negative.")+
   steps("Look at the two lines of the cell symbol","one is longer and thin, one is short and thick","the longer thin line is the positive terminal."),
   [("negative terminal","The short THICK line is the negative terminal; the long thin one is positive."),
    ("switch","The two lines are the cell's terminals, not a switch."),
    ("fuse","The cell symbol's lines mark its terminals, not a fuse.")]),

 ("EC","The main job of a switch in an electric circuit is to:",
   "open or close the circuit to stop or start the current",
   C("A switch makes or breaks the circuit, letting you start or stop the flow of current.")+
   steps("To stop the current you break the path","to start it you complete the path","a switch does both — it opens or closes the circuit."),
   [("store electricity for later","A switch does not store electricity; a cell or battery does that."),
    ("produce the current itself","A switch only opens or closes the path; the cell produces the current."),
    ("turn the wire into a magnet","A switch controls the current; it does not make the wire a magnet.")]),

 ("EC","A torch bulb is connected to a cell with a switch and wires, but it will not light. A likely simple cause is that:",
   "the circuit is broken somewhere (e.g. switch open or loose wire)",
   C("If the loop is broken anywhere — an open switch or a loose wire — no current flows and the bulb stays dark.")+
   steps("The bulb needs an unbroken loop to glow","check the switch and the wire joins","a break anywhere stops the current, so the bulb stays off."),
   [("the bulb is glowing too brightly","If it is not lighting, it cannot also be glowing too brightly."),
    ("there is too much daylight in the room","Daylight does not stop a torch bulb from lighting; a broken circuit does."),
    ("the wires are the wrong colour","Wire colour does not decide if a bulb lights; an unbroken loop does.")]),

 ("EC","The heating effect of current is put to good use in an appliance such as an:",
   "electric iron",
   C("An electric iron works by the heating effect — current heats its element to press clothes.")+
   steps("An iron needs to get hot to press clothes","current through its element heats it up","so the iron uses the heating effect of current."),
   [("electric bell","An electric bell uses the magnetic effect, not mainly the heating effect."),
    ("compass","A compass shows direction; it is not a heating appliance at all."),
    ("loudspeaker","A loudspeaker uses the magnetic effect; an iron uses the heating effect.")]),

 ("EC","In a series circuit with a bulb, if a fuse rated at 5 amperes carries 0.5 of that rating, the current flowing is:",
   "2.5 amperes",
   C("Half of the 5 A rating is 0.5 × 5 = 2.5 amperes, which is safely below the fuse's limit.")+
   steps("Take the fuse rating, 5 amperes","find 0.5 of it: 0.5 × 5","0.5 × 5 = 2.5, so the current is 2.5 amperes."),
   [("5 amperes","5 A is the full fuse rating; 0.5 of it is 0.5 × 5 = 2.5 amperes."),
    ("0.5 amperes","0.5 is the fraction, not the current; 0.5 of 5 A is 2.5 amperes."),
    ("10 amperes","10 A doubles the rating; 0.5 of 5 A is 2.5 amperes, not 10.")]),
]

EC_UC = [
 "Knowing a cell is the source is the first step when wiring up any toy or torch at home.",
 "Knowing cells make a battery is why a remote needs two or three cells stacked to work.",
 "Spotting the filament is what tells you which part of a blown bulb has snapped.",
 "Understanding the heating effect is why an electric iron and a toaster can get usefully hot.",
 "Knowing what a fuse does is why a melted fuse, not a fire, is what saves a house on overload.",
 "Understanding electromagnets is how cranes lift heavy scrap iron and then drop it on command.",
 "Knowing a circuit must be closed is the first thing you check when a torch refuses to light.",
 "Telling conductors apart is how an electrician picks copper wire to carry current safely.",
 "Knowing insulators block current is why wires are wrapped in rubber you can safely hold.",
 "Choosing a CFL or LED is how a family cuts its electricity bill while keeping rooms bright.",
 "Knowing an MCB resets is why a tripped switch can be flicked back on instead of replaced.",
 "Understanding the bell's electromagnet is how a doorbell turns a push into a ring.",
 "Knowing current turns a compass is the clue that first revealed electricity and magnetism are linked.",
 "Recognising overloading is why you avoid running a heater, iron and kettle off one socket.",
 "Knowing the element resists melting is why a heater glows red-hot night after night safely.",
 "Knowing an electromagnet switches off is why a scrapyard crane can drop its load on demand.",
 "Knowing two cells glow brighter is how you get more light from a torch when you need it.",
 "Knowing fuse wire melts easily is why the right-rated fuse protects exactly the right circuit.",
 "Reading the bulb symbol is what lets you follow any circuit diagram in a science book.",
 "Never touching switches with wet hands is the safety rule that prevents bathroom shocks.",
 "Reading the long line as positive is how you connect a cell the right way round every time.",
 "Using a switch is how every light, fan and gadget in a house is turned on and off.",
 "Checking for a break is the troubleshooting habit that fixes most dead torches in seconds.",
 "Knowing the iron uses heating is how you understand why it must be unplugged to cool down.",
 "Reading a fuse rating as a number is how an electrician picks a fuse that trips at the right current.",
]

# ---------- SIMPLE EQUATIONS (25) — Maths ----------
SE = [
 ("SE","In maths, using an equals sign to state that two expressions have the same value gives an:",
   "equation",
   C("When two expressions are set equal with an = sign, the statement is an equation.")+
   steps("Write two expressions","join them with an equals sign","this statement of equality is an equation."),
   [("expression","An expression alone has no = sign; joining two with = makes an equation."),
    ("inequality","An inequality uses < or >, not the equals sign of an equation."),
    ("product","A product is the result of multiplying, not a statement of equality.")]),

 ("SE","The value of the variable that makes an equation true is called its:",
   "solution (root)",
   C("The number you can put in for the variable to make both sides equal is the solution, or root.")+
   steps("Try a value for the variable","check if both sides come out equal","the value that works is the solution of the equation."),
   [("coefficient","A coefficient multiplies the variable; it is not the value that solves the equation."),
    ("constant","A constant is a fixed number in the equation, not the solving value of the variable."),
    ("term","A term is a piece of an expression, not the solving value of the variable.")]),

 ("SE","Solving the equation x + 5 = 12 gives x equal to:",
   "7",
   C("Take 5 from both sides: x = 12 − 5 = 7.")+
   steps("Move the +5 across the equals sign","it becomes −5: x = 12 − 5","12 − 5 = 7, so x = 7."),
   [("17","17 adds 5 instead of subtracting; to undo +5 you take 5 away, giving 7."),
    ("60","60 multiplies 12 by 5; the +5 must be subtracted, giving x = 7."),
    ("5","5 is the number added, not the answer; x = 12 − 5 = 7.")]),

 ("SE","Solving the equation 3x = 15 gives x equal to:",
   "5",
   C("Divide both sides by 3: x = 15 ÷ 3 = 5.")+
   steps("3x means 3 times x","to undo the ×3, divide both sides by 3","15 ÷ 3 = 5, so x = 5."),
   [("45","45 multiplies 15 by 3; to undo ×3 you DIVIDE, giving x = 5."),
    ("12","12 subtracts 3 from 15; but 3x means times 3, so divide: x = 5."),
    ("18","18 adds 3 to 15; 3x = 15 needs division, giving x = 5.")]),

 ("SE","Solving the equation x − 4 = 10 gives x equal to:",
   "14",
   C("Add 4 to both sides: x = 10 + 4 = 14.")+
   steps("Move the −4 across the equals sign","it becomes +4: x = 10 + 4","10 + 4 = 14, so x = 14."),
   [("6","6 subtracts 4; to undo −4 you ADD 4, giving x = 14."),
    ("40","40 multiplies 10 by 4; the −4 must be added, giving x = 14."),
    ("10","10 is the right-hand value, not the answer; x = 10 + 4 = 14.")]),

 ("SE","Solving the equation x ÷ 2 = 6 gives x equal to:",
   "12",
   C("Multiply both sides by 2: x = 6 × 2 = 12.")+
   steps("x ÷ 2 means x divided by 2","to undo the ÷2, multiply both sides by 2","6 × 2 = 12, so x = 12."),
   [("3","3 divides 6 by 2; to undo ÷2 you MULTIPLY, giving x = 12."),
    ("8","8 adds 2 to 6; x ÷ 2 = 6 needs multiplying, giving x = 12."),
    ("4","4 subtracts 2 from 6; the rule is multiply by 2, giving x = 12.")]),

 ("SE","When a term is moved from one side of an equation to the other, its sign:",
   "changes (+ becomes − and − becomes +)",
   C("Transposing a term across the equals sign flips its sign: a plus becomes a minus and a minus becomes a plus.")+
   steps("Pick a term to move across the = sign","as it crosses, its sign flips","so + becomes − and − becomes + — this is transposing."),
   [("stays exactly the same","A transposed term must change sign, not stay the same."),
    ("always becomes zero","Moving a term flips its sign; it does not turn into zero."),
    ("doubles in value","Transposing changes the sign, not the size, of the term.")]),

 ("SE","Solving the equation 2x + 3 = 11 gives x equal to:",
   "4",
   C("Take 3 from both sides to get 2x = 8, then divide by 2: x = 4.")+
   steps("Move +3 across: 2x = 11 − 3 = 8","divide both sides by 2","8 ÷ 2 = 4, so x = 4."),
   [("7","7 only subtracts 3 and forgets to divide by 2; 8 ÷ 2 = 4."),
    ("14","14 adds 3 instead of subtracting; first 2x = 8, then x = 4."),
    ("2","2 divided too early; first 2x = 8, then 8 ÷ 2 = 4, so x = 4.")]),

 ("SE","Adding the same number to BOTH sides of a true equation keeps the equation:",
   "still true (balanced)",
   C("An equation is like a balance; adding the same amount to both sides keeps it balanced and true.")+
   steps("Picture the equation as a balanced scale","add the same weight to each pan","the scale stays level — the equation stays true."),
   [("always false","Doing the same to both sides keeps it true, not false."),
    ("equal to zero","Adding the same number does not force the equation to zero; it stays balanced."),
    ("impossible to solve","Adding equally to both sides is a normal, allowed step; the equation stays solvable.")]),

 ("SE","The sentence 'a number increased by 5 gives 12' is written as the equation:",
   "x + 5 = 12",
   C("'A number' is x, 'increased by 5' is + 5, and 'gives 12' is = 12, so x + 5 = 12.")+
   steps("Let the number be x","'increased by 5' means + 5","'gives 12' means = 12, so x + 5 = 12."),
   [("x − 5 = 12","'Increased by' means add, so it is + 5, not − 5."),
    ("5x = 12","'Increased by 5' is adding 5, not multiplying by 5."),
    ("x + 12 = 5","The number plus 5 equals 12, written x + 5 = 12, not x + 12 = 5.")]),

 ("SE","The sentence 'twice a number is 18' gives the equation 2x = 18, so the number is:",
   "9",
   C("2x = 18 means divide both sides by 2: x = 18 ÷ 2 = 9.")+
   steps("'Twice a number' is 2x, and it equals 18","divide both sides by 2","18 ÷ 2 = 9, so the number is 9."),
   [("36","36 multiplies 18 by 2; to undo ×2 you DIVIDE, giving 9."),
    ("16","16 subtracts 2 from 18; 2x = 18 needs dividing, giving 9."),
    ("20","20 adds 2 to 18; the rule is divide by 2, giving the number 9.")]),

 ("SE","To CHECK that x = 3 solves the equation x + 4 = 7, you should:",
   "put 3 in place of x and see if both sides are equal",
   C("Checking means substituting the value back: 3 + 4 = 7 is true, so x = 3 is correct.")+
   steps("Replace x with 3 in x + 4","work it out: 3 + 4 = 7","both sides equal 7, so x = 3 is the right solution."),
   [("change the 7 to a 3","Checking does not alter the equation; you substitute x = 3 and test it."),
    ("rub out the + 4 sign","You cannot delete part of the equation; you substitute and test instead."),
    ("multiply both sides by 3","Checking means substituting x = 3, not multiplying the equation by 3.")]),

 ("SE","Solving the equation 4x − 1 = 11 gives x equal to:",
   "3",
   C("Add 1 to both sides to get 4x = 12, then divide by 4: x = 3.")+
   steps("Move −1 across: 4x = 11 + 1 = 12","divide both sides by 4","12 ÷ 4 = 3, so x = 3."),
   [("12","12 only adds 1 and forgets to divide by 4; 12 ÷ 4 = 3."),
    ("2.5","2.5 subtracts 1 instead of adding; first 4x = 12, then x = 3."),
    ("48","48 multiplies 12 by 4; you must divide, giving x = 3.")]),

 ("SE","A car's steady speed s satisfies the equation 2s = 60 (km/h). The speed s is:",
   "30 km/h",
   C("Divide both sides by 2: s = 60 ÷ 2 = 30 km/h — an equation hidden inside a motion problem.")+
   steps("2s = 60 means twice the speed is 60","divide both sides by 2","60 ÷ 2 = 30, so the speed is 30 km/h."),
   [("120 km/h","120 multiplies 60 by 2; to undo ×2 you DIVIDE, giving 30 km/h."),
    ("58 km/h","58 subtracts 2 from 60; 2s = 60 needs dividing, giving 30 km/h."),
    ("62 km/h","62 adds 2 to 60; the rule is divide by 2, giving 30 km/h.")]),

 ("SE","Solving the equation x + 7 = 7 gives x equal to:",
   "0",
   C("Take 7 from both sides: x = 7 − 7 = 0.")+
   steps("Move +7 across the equals sign","it becomes −7: x = 7 − 7","7 − 7 = 0, so x = 0."),
   [("7","7 forgets to subtract; x = 7 − 7 = 0, not 7."),
    ("14","14 adds 7 instead of subtracting; x = 7 − 7 = 0."),
    ("1","1 has no basis here; x = 7 − 7 = 0.")]),

 ("SE","Solving the equation 10 − x = 4 gives x equal to:",
   "6",
   C("Rearrange to x = 10 − 4 = 6.")+
   steps("10 − x = 4 means x is what is left from 10 to reach 4","so x = 10 − 4","10 − 4 = 6, so x = 6."),
   [("14","14 adds 10 and 4; here x = 10 − 4 = 6."),
    ("40","40 multiplies 10 by 4; x = 10 − 4 = 6, not a product."),
    ("4","4 is the right-hand value, not x; here x = 10 − 4 = 6.")]),

 ("SE","The process of moving a term to the other side of an equation, changing its sign, is called:",
   "transposition (transposing)",
   C("Shifting a term across the equals sign with a flipped sign is called transposing, or transposition.")+
   steps("A term is moved across the = sign","its sign flips as it crosses","this move is called transposition."),
   [("multiplication","Multiplication combines numbers; moving a term across the = is transposition."),
    ("rounding off","Rounding changes a number's look; transposition moves a term across the = sign."),
    ("factorising","Factorising splits into factors; transposing moves a term across the equals sign.")]),

 ("SE","Solving the equation x ÷ 5 = 2 gives x equal to:",
   "10",
   C("Multiply both sides by 5: x = 2 × 5 = 10.")+
   steps("x ÷ 5 means x divided by 5","to undo ÷5, multiply both sides by 5","2 × 5 = 10, so x = 10."),
   [("0.4","0.4 divides 2 by 5; to undo ÷5 you MULTIPLY, giving 10."),
    ("7","7 adds 5 to 2; x ÷ 5 = 2 needs multiplying, giving 10."),
    ("3","3 subtracts 2 from 5; the rule is multiply by 5, giving x = 10.")]),

 ("SE","Solving the equation 2x − 6 = 0 gives x equal to:",
   "3",
   C("Add 6 to both sides to get 2x = 6, then divide by 2: x = 3.")+
   steps("Move −6 across: 2x = 0 + 6 = 6","divide both sides by 2","6 ÷ 2 = 3, so x = 3."),
   [("6","6 only adds 6 and forgets to divide by 2; 6 ÷ 2 = 3."),
    ("0","0 is the right-hand value, not the answer; 2x = 6 gives x = 3."),
    ("12","12 multiplies 6 by 2; you must divide, giving x = 3.")]),

 ("SE","A bulb circuit uses n cells, and one more cell would make 3 cells in all: n + 1 = 3. The value of n is:",
   "2",
   C("Take 1 from both sides: n = 3 − 1 = 2 — an equation drawn from a circuit.")+
   steps("n + 1 = 3 means n is one less than 3","so n = 3 − 1","3 − 1 = 2, so there are 2 cells."),
   [("4","4 adds 1 instead of subtracting; n = 3 − 1 = 2."),
    ("3","3 is the total wanted, not n; n = 3 − 1 = 2."),
    ("1","1 is the cell being added, not n; n = 3 − 1 = 2.")]),

 ("SE","The sentence 'a number divided by 3 gives 4' becomes x ÷ 3 = 4, so the number is:",
   "12",
   C("x ÷ 3 = 4 means multiply both sides by 3: x = 4 × 3 = 12.")+
   steps("'Divided by 3' gives x ÷ 3, and it equals 4","multiply both sides by 3","4 × 3 = 12, so the number is 12."),
   [("7","7 adds 3 to 4; x ÷ 3 = 4 needs multiplying, giving 12."),
    ("1","1 divides 4 by 3 roughly; to undo ÷3 you MULTIPLY, giving 12."),
    ("4","4 is the result, not the number; the number is 4 × 3 = 12.")]),

 ("SE","A pendulum's time period t satisfies 3t = 6 (seconds). The time period t is:",
   "2 seconds",
   C("Divide both sides by 3: t = 6 ÷ 3 = 2 seconds — an equation hidden in a timing problem.")+
   steps("3t = 6 means three time-periods make 6 s","divide both sides by 3","6 ÷ 3 = 2, so each period is 2 seconds."),
   [("18 seconds","18 multiplies 6 by 3; to undo ×3 you DIVIDE, giving 2 s."),
    ("3 seconds","3 subtracts 3 from 6; 3t = 6 needs dividing, giving 2 s."),
    ("9 seconds","9 adds 3 to 6; the rule is divide by 3, giving t = 2 s.")]),

 ("SE","Solving the equation 7 + 2x = 13 gives x equal to:",
   "3",
   C("Take 7 from both sides to get 2x = 6, then divide by 2: x = 3.")+
   steps("Move +7 across: 2x = 13 − 7 = 6","divide both sides by 2","6 ÷ 2 = 3, so x = 3."),
   [("10","10 only subtracts 3 wrongly; first 2x = 6, then x = 3."),
    ("6","6 forgets to divide by 2; 2x = 6 gives x = 3."),
    ("20","20 adds 7 instead of subtracting; first 2x = 6, then x = 3.")]),

 ("SE","Solving the equation 5x = 5 gives x equal to:",
   "1",
   C("Divide both sides by 5: x = 5 ÷ 5 = 1.")+
   steps("5x = 5 means 5 times x is 5","divide both sides by 5","5 ÷ 5 = 1, so x = 1."),
   [("5","5 forgets to divide; 5x = 5 gives x = 5 ÷ 5 = 1."),
    ("0","0 would make 5x = 0, not 5; the answer is x = 1."),
    ("25","25 multiplies 5 by 5; you must divide, giving x = 1.")]),

 ("SE","Solving the equation 3(x) = 0, where 3(x) means 3 times x, gives x equal to:",
   "0",
   C("If 3 times x is 0, then x itself must be 0, since 3 × 0 = 0.")+
   steps("3 times x equals 0","only 0 times 3 gives 0","so x must be 0."),
   [("3","3 would give 3 × 3 = 9, not 0; the answer is x = 0."),
    ("1","1 would give 3 × 1 = 3, not 0; the answer is x = 0."),
    ("9","9 would give 3 × 9 = 27, not 0; the answer is x = 0.")]),
]

SE_UC = [
 "Writing an equation is how you turn a tricky word puzzle into a clear maths sentence to solve.",
 "Finding the solution is the whole point — it is the unknown number a puzzle is really asking for.",
 "Solving x + 5 = 12 is the kind of step behind working out how much more pocket money you need.",
 "Solving 3x = 15 is how you split a total fairly into equal groups and find each share.",
 "Solving x − 4 = 10 is how you find a starting amount after some was taken away.",
 "Solving x ÷ 2 = 6 is how you find a whole when you only know half of it.",
 "Transposing terms is the neat shortcut that lets you solve an equation without long guessing.",
 "Solving 2x + 3 = 11 is the kind of two-step sum behind many real cost-and-charge problems.",
 "Keeping both sides balanced is the golden rule that makes every equation-solving step fair.",
 "Turning a sentence into x + 5 = 12 is how word problems in exams are actually cracked.",
 "Solving 2x = 18 is how you halve a total to find one of two equal parts.",
 "Checking by substitution is the habit that catches a slip before you write a wrong final answer.",
 "Solving 4x − 1 = 11 is the kind of two-step working real timetable and pricing sums need.",
 "Solving 2s = 60 is exactly how you'd find a car's speed when told twice it is 60.",
 "Solving x + 7 = 7 shows you how an unknown can turn out to be zero in a real puzzle.",
 "Solving 10 − x = 4 is how you find how much was spent when you know what is left.",
 "Naming transposition helps you follow and explain each step of a worked solution.",
 "Solving x ÷ 5 = 2 is how you find a whole from a known fifth of it.",
 "Solving 2x − 6 = 0 is the kind of step behind finding a break-even point in money sums.",
 "Solving n + 1 = 3 is exactly how you'd find how many cells a circuit started with.",
 "Solving x ÷ 3 = 4 is how you find a total from one of its three equal shares.",
 "Solving 3t = 6 is how you'd find a pendulum's single-swing time from three swings.",
 "Solving 7 + 2x = 13 is the kind of two-step sum behind a fixed fee plus a per-item charge.",
 "Solving 5x = 5 reminds you that dividing both sides by the coefficient finds x in one move.",
 "Solving 3x = 0 shows that if a product is zero one of its parts must be zero.",
]

# ---------- FRACTIONS & DECIMALS (25) — Maths ----------
FD = [
 ("FD","The sum of the two halves, 1/2 + 1/2, equals:",
   "1",
   C("Two halves make a whole, so 1/2 + 1/2 = 1.")+
   steps("The denominators are the same, both 2","add the tops: 1 + 1 = 2, giving 2/2","2/2 is one whole, so the answer is 1."),
   [("1/4","1/4 is what you get by MULTIPLYING the halves; adding two halves gives 1."),
    ("2/4","Adding fractions does not add the bottoms; 1/2 + 1/2 = 2/2 = 1, not 2/4."),
    ("1/2","One half plus another half is a whole, 1, not still a half.")]),

 ("FD","The product 1/2 × 1/2 equals:",
   "1/4",
   C("Multiply tops and bottoms: (1×1)/(2×2) = 1/4.")+
   steps("Multiply the numerators: 1 × 1 = 1","multiply the denominators: 2 × 2 = 4","so 1/2 × 1/2 = 1/4."),
   [("1","1 is the SUM of two halves; multiplying them gives 1/4."),
    ("2/4","Multiplying gives (1×1)/(2×2) = 1/4, not 2/4."),
    ("1/2","Half of a half is a quarter, 1/4, not a half.")]),

 ("FD","Written as a fraction in simplest form, the decimal 0.5 is:",
   "1/2",
   C("0.5 means 5 tenths, and 5/10 reduces to 1/2.")+
   steps("Read 0.5 as 5 tenths, that is 5/10","divide top and bottom by 5","5 ÷ 5 = 1 and 10 ÷ 5 = 2, so 1/2."),
   [("1/5","1/5 is 0.2, not 0.5; 0.5 is 5/10 = 1/2."),
    ("5/1","5/1 is the whole number 5, far bigger than 0.5; the answer is 1/2."),
    ("1/50","0.5 is 5 tenths = 1/2, not the tiny 1/50.")]),

 ("FD","Written as a decimal, the fraction 1/4 is:",
   "0.25",
   C("1/4 means one part of four; 1 ÷ 4 = 0.25.")+
   steps("Divide the top by the bottom: 1 ÷ 4","1 ÷ 4 = 0.25","so 1/4 = 0.25."),
   [("0.14","0.14 just glues the 1 and 4; the value of 1/4 is 1 ÷ 4 = 0.25."),
    ("4.0","4.0 is 4 ÷ 1; the fraction 1/4 is 1 ÷ 4 = 0.25."),
    ("0.4","0.4 is 2/5, not 1/4; 1 ÷ 4 = 0.25.")]),

 ("FD","The sum 1/4 + 1/4 equals, in simplest form:",
   "1/2",
   C("Two quarters make a half: 1/4 + 1/4 = 2/4 = 1/2.")+
   steps("The bottoms match, both 4","add the tops: 1 + 1 = 2, giving 2/4","2/4 simplifies to 1/2."),
   [("2/8","Adding fractions does not add the bottoms; 1/4 + 1/4 = 2/4 = 1/2."),
    ("1/8","1/8 comes from MULTIPLYING the quarters; adding gives 1/2."),
    ("1/4","One quarter plus another quarter is two quarters, a half, not still a quarter.")]),

 ("FD","The product 0.2 × 10 equals:",
   "2",
   C("Multiplying by 10 shifts the decimal point one place right: 0.2 × 10 = 2.")+
   steps("Multiplying by 10 moves the point one place right","0.2 becomes 2.0","so 0.2 × 10 = 2."),
   [("0.02","0.02 moves the point the WRONG way; ×10 makes it bigger, giving 2."),
    ("20","20 moves the point two places; ×10 moves it just one, giving 2."),
    ("0.2","0.2 is unchanged; multiplying by 10 makes it 2.")]),

 ("FD","When you change the fraction 3/5 into decimal form, the value you get is:",
   "0.6",
   C("3/5 means 3 ÷ 5; the same as 6/10, which is 0.6.")+
   steps("Make the bottom 10: multiply 3/5 by 2/2 to get 6/10","6/10 is 6 tenths","so 3/5 = 0.6."),
   [("0.35","0.35 just glues 3 and 5; 3/5 is 3 ÷ 5 = 0.6."),
    ("0.3","0.3 is 3/10, not 3/5; 3/5 = 6/10 = 0.6."),
    ("5.3","5.3 swaps and misplaces the digits; 3/5 = 0.6.")]),

 ("FD","One half of 10 is:",
   "5",
   C("Half of 10 means 1/2 × 10 = 5.")+
   steps("Half of a number is that number ÷ 2","10 ÷ 2 = 5","so one half of 10 is 5."),
   [("20","20 doubles 10; HALF of 10 is 10 ÷ 2 = 5."),
    ("2","2 is roughly 10 ÷ 5; half of 10 is 10 ÷ 2 = 5."),
    ("10","10 is the whole; half of it is 5.")]),

 ("FD","Written as a fraction in simplest form, the decimal 0.75 is:",
   "3/4",
   C("0.75 means 75 hundredths, and 75/100 reduces to 3/4.")+
   steps("Read 0.75 as 75/100","divide top and bottom by 25","75 ÷ 25 = 3 and 100 ÷ 25 = 4, so 3/4."),
   [("7/5","7/5 is bigger than 1; 0.75 is less than 1 and equals 3/4."),
    ("3/40","0.75 is 75/100 = 3/4, not the tiny 3/40."),
    ("1/4","1/4 is 0.25, not 0.75; 0.75 = 3/4.")]),

 ("FD","Adding the two decimals 2.5 and 1.5 together gives a total of:",
   "4.0",
   C("Line up the points and add: 2.5 + 1.5 = 4.0.")+
   steps("Add the whole parts: 2 + 1 = 3","add the decimal parts: 0.5 + 0.5 = 1.0","3 + 1.0 = 4.0."),
   [("3.10","You cannot just stick 5 and 5 together; 0.5 + 0.5 = 1.0, giving 4.0."),
    ("1.0","1.0 subtracts the numbers; the question asks for the sum, 4.0."),
    ("4.10","0.5 + 0.5 is 1.0, not 0.10; the total is 4.0.")]),

 ("FD","One third of 9 is:",
   "3",
   C("One third of 9 means 1/3 × 9 = 9 ÷ 3 = 3.")+
   steps("A third of a number is that number ÷ 3","9 ÷ 3 = 3","so one third of 9 is 3."),
   [("27","27 multiplies 9 by 3; a THIRD means divide, giving 3."),
    ("6","6 is two thirds of 9; one third is 9 ÷ 3 = 3."),
    ("12","12 adds 3 to 9; a third of 9 is 9 ÷ 3 = 3.")]),

 ("FD","Written as a fraction in simplest form, the decimal 0.1 is:",
   "1/10",
   C("0.1 means one tenth, written 1/10.")+
   steps("Read 0.1 as one tenth","one tenth is 1/10","that is already in simplest form."),
   [("1/100","1/100 is 0.01, not 0.1; one tenth is 1/10."),
    ("10/1","10/1 is the whole number 10, far bigger than 0.1; the answer is 1/10."),
    ("1/1","1/1 is one whole; 0.1 is one tenth, 1/10.")]),

 ("FD","The product 0.3 × 0.2 equals:",
   "0.06",
   C("Multiply 3 × 2 = 6, then place two decimal digits: 0.3 × 0.2 = 0.06.")+
   steps("Ignore the points: 3 × 2 = 6","count decimal places: one in each, so two in all","place them: 0.06."),
   [("0.6","0.6 keeps only one decimal place; two are needed, giving 0.06."),
    ("0.5","0.5 adds 0.3 and 0.2; the question asks the product, 0.06."),
    ("6","6 forgets the decimal point entirely; 0.3 × 0.2 = 0.06.")]),

 ("FD","A body covers 3.6 metres in 2 seconds at a steady speed. Its speed is:",
   "1.8 m/s",
   C("Speed = distance ÷ time = 3.6 m ÷ 2 s = 1.8 m/s — a decimal division inside a motion problem.")+
   steps("Write speed = distance ÷ time","put in 3.6 ÷ 2","3.6 ÷ 2 = 1.8, so the speed is 1.8 m/s."),
   [("7.2 m/s","7.2 multiplies 3.6 by 2; speed needs distance DIVIDED by time, giving 1.8."),
    ("5.6 m/s","5.6 adds 3.6 and 2; speed is 3.6 ÷ 2 = 1.8 m/s, not a sum."),
    ("2 m/s","2 is the time in seconds, not the speed; 3.6 ÷ 2 = 1.8 m/s.")]),

 ("FD","The reciprocal of the fraction 2/3 is:",
   "3/2",
   C("To get a reciprocal you flip the fraction upside down: 2/3 becomes 3/2.")+
   steps("Take the fraction 2/3","swap its top and bottom","that gives 3/2, the reciprocal."),
   [("2/3","The reciprocal is the FLIP of 2/3, which is 3/2, not 2/3 itself."),
    ("−2/3","A reciprocal flips the fraction; it does not just add a minus sign."),
    ("6","6 multiplies 2 by 3; the reciprocal is the flip, 3/2.")]),

 ("FD","Written as a decimal, the fraction 7/10 is:",
   "0.7",
   C("7/10 means 7 tenths, which is written 0.7.")+
   steps("Read 7/10 as 7 tenths","7 tenths is written with one decimal place","so 7/10 = 0.7."),
   [("0.07","0.07 is 7 hundredths, that is 7/100; 7/10 is 0.7."),
    ("7.10","7.10 misreads the fraction; 7/10 is 7 tenths = 0.7."),
    ("10.7","10.7 swaps the numbers; 7/10 = 0.7.")]),

 ("FD","The product 0.25 × 4 equals:",
   "1",
   C("0.25 is a quarter, and four quarters make a whole: 0.25 × 4 = 1.")+
   steps("0.25 is the same as 1/4","four quarters make one whole","so 0.25 × 4 = 1."),
   [("0.100","0.25 × 4 is one whole, written 1, not 0.100."),
    ("8","8 doubles 4; four quarters make just 1, not 8."),
    ("0.29","0.29 wrongly adds 0.25 and 4 as digits; 0.25 × 4 = 1.")]),

 ("FD","The sum 1/5 + 2/5 equals:",
   "3/5",
   C("With the same bottom, add the tops: 1/5 + 2/5 = 3/5.")+
   steps("The denominators match, both 5","add the numerators: 1 + 2 = 3","so the sum is 3/5."),
   [("3/10","Adding fractions does not add the bottoms; 1/5 + 2/5 = 3/5, not 3/10."),
    ("2/5","2/5 forgets to add the 1/5; the sum is 3/5."),
    ("3/25","The bottom stays 5, not 25; the sum is 3/5.")]),

 ("FD","Of the two decimals 0.5 and 0.45, the LARGER one is:",
   "0.5",
   C("0.5 is 0.50, and 0.50 is more than 0.45, so 0.5 is larger.")+
   steps("Write 0.5 as 0.50 so both have two places","compare 0.50 with 0.45","50 hundredths beat 45 hundredths, so 0.5 is larger."),
   [("0.45","0.45 is 45 hundredths, less than 0.50; so 0.5 is the larger."),
    ("they are equal","0.50 is not the same as 0.45; 0.5 is larger."),
    ("neither is a real number","Both are ordinary decimals; 0.5 is the larger of the two.")]),

 ("FD","Written in simplest form, the fraction 2/4 is:",
   "1/2",
   C("Divide top and bottom by 2: 2/4 = 1/2.")+
   steps("Find a common factor of 2 and 4, which is 2","divide both: 2 ÷ 2 = 1 and 4 ÷ 2 = 2","so 2/4 = 1/2."),
   [("2/4","That is the original, not yet reduced; its simplest form is 1/2."),
    ("4/2","4/2 flips it and equals 2; 2/4 reduces to 1/2."),
    ("1/4","1/4 is half of 2/4; 2/4 itself simplifies to 1/2.")]),

 ("FD","The product 1.2 × 3 equals:",
   "3.6",
   C("Multiply 12 × 3 = 36, then place one decimal digit: 1.2 × 3 = 3.6.")+
   steps("Ignore the point: 12 × 3 = 36","there is one decimal place in 1.2","place it: 3.6."),
   [("3.2","3.2 only adds; 1.2 × 3 multiplies to give 3.6."),
    ("36","36 forgets the decimal point; 1.2 × 3 = 3.6."),
    ("4.2","4.2 adds 1.2 and 3; the product is 3.6.")]),

 ("FD","One half of 0.6 is:",
   "0.3",
   C("Half of 0.6 means 0.6 ÷ 2 = 0.3.")+
   steps("Half of a number is that number ÷ 2","0.6 ÷ 2 = 0.3","so one half of 0.6 is 0.3."),
   [("1.2","1.2 DOUBLES 0.6; half of it is 0.6 ÷ 2 = 0.3."),
    ("0.12","0.12 misplaces the point; 0.6 ÷ 2 = 0.3."),
    ("0.06","0.06 divides by ten times too much; half of 0.6 is 0.3.")]),

 ("FD","Written as a decimal, the fraction 5/100 is:",
   "0.05",
   C("5/100 means 5 hundredths, written 0.05.")+
   steps("Read 5/100 as 5 hundredths","hundredths need two decimal places","so 5/100 = 0.05."),
   [("0.5","0.5 is 5 tenths, that is 50/100; 5/100 is 0.05."),
    ("5.0","5.0 is the whole number 5; 5/100 is the small 0.05."),
    ("0.005","0.005 is 5 thousandths; 5/100 is 0.05.")]),

 ("FD","The sum 1/2 + 1/4 equals, in simplest form:",
   "3/4",
   C("Make the bottoms match: 1/2 = 2/4, then 2/4 + 1/4 = 3/4.")+
   steps("Rewrite 1/2 as 2/4 so the bottoms match","add: 2/4 + 1/4 = 3/4","that is already simplest, so 3/4."),
   [("2/6","Adding fractions does not add the bottoms; the answer is 3/4."),
    ("1/6","1/6 comes from multiplying, not adding; 1/2 + 1/4 = 3/4."),
    ("2/4","2/4 is just 1/2; you must add the 1/4 too, giving 3/4.")]),

 ("FD","A fuse is rated at 6 amperes and the circuit draws 1/3 of that rating. The current flowing is:",
   "2 amperes",
   C("One third of the 6 A rating is 1/3 × 6 = 2 amperes — a fraction-of-an-amount inside a circuit.")+
   steps("Take the rating, 6 amperes","find 1/3 of it: 6 ÷ 3","6 ÷ 3 = 2, so the current is 2 amperes."),
   [("18 amperes","18 multiplies 6 by 3; a THIRD means divide, giving 2 amperes."),
    ("3 amperes","3 is half of 6, not a third; 6 ÷ 3 = 2 amperes."),
    ("6 amperes","6 A is the full rating; one third of it is 6 ÷ 3 = 2 amperes.")]),
]

FD_UC = [
 "Knowing two halves make one is the everyday sense behind sharing a whole pizza between two.",
 "Multiplying 1/2 by 1/2 is how you find half of a half — a quarter of a chocolate bar.",
 "Turning 0.5 into 1/2 is how you read a 0.5 kg label as 'half a kilogram' on a packet.",
 "Turning 1/4 into 0.25 is how a shopkeeper shows a quarter as a decimal on a price tag.",
 "Adding 1/4 + 1/4 is the sense behind combining two quarter-cups into a half-cup in a recipe.",
 "Multiplying 0.2 by 10 is the quick trick for scaling a decimal up by ten in your head.",
 "Turning 3/5 into 0.6 is how you compare a fraction mark with a decimal one on a test.",
 "Finding half of 10 is the simplest split — sharing ten sweets equally between two friends.",
 "Turning 0.75 into 3/4 is how you read '0.75 of an hour' as three-quarters of an hour.",
 "Adding 2.5 + 1.5 is the money-and-measure sum behind totalling two decimal amounts.",
 "Finding a third of 9 is how you split nine items fairly among three people.",
 "Turning 0.1 into 1/10 is how you read a tenth on a ruler or a measuring jug.",
 "Multiplying 0.3 × 0.2 is the careful decimal-place skill behind areas and money sums.",
 "Dividing 3.6 by 2 is exactly how you'd find a speed in metres per second from a timed run.",
 "Flipping 2/3 to 3/2 is the reciprocal step that turns a division of fractions into a multiplication.",
 "Turning 7/10 into 0.7 is how you read seven-tenths on a fuel gauge or a scale.",
 "Multiplying 0.25 × 4 shows why four quarter-litre cups exactly fill one litre.",
 "Adding 1/5 + 2/5 is the sense behind combining same-sized shares of one whole.",
 "Comparing 0.5 with 0.45 is the skill that stops you overpaying when two prices look close.",
 "Reducing 2/4 to 1/2 is the tidying step that keeps fraction answers in their simplest form.",
 "Multiplying 1.2 × 3 is how you scale a decimal recipe or distance up by three.",
 "Halving 0.6 is the decimal version of sharing six-tenths of something between two.",
 "Turning 5/100 into 0.05 is how you read 5 out of 100 as a decimal, the root of percentages.",
 "Adding 1/2 + 1/4 is the recipe-and-measure sum behind combining unlike fraction shares.",
 "Finding a third of a fuse rating is exactly how you'd work out the current a circuit really draws.",
]


def _with_uc(lst, ucs):
    assert len(lst) == len(ucs) == 25
    out = []
    for it, uc in zip(lst, ucs):
        code, stem, correct, html, distr = it
        out.append((code, stem, correct, html + U(uc), distr))
    return out


MT = _with_uc(MT, MT_UC)
EC = _with_uc(EC, EC_UC)
SE = _with_uc(SE, SE_UC)
FD = _with_uc(FD, FD_UC)

items = []
for i in range(25):
    items += [MT[i], EC[i], SE[i], FD[i]]
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

    keydist = build_paper(PNUM, TITLE, SHORT, LABELS, items, seed=33517,
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
    split = "/".join(str(counts[c]) for c in ("MT", "EC", "SE", "FD"))
    with open("PAPERS_MANIFEST.md", "a", encoding="utf-8") as fh:
        fh.write(f"| {PNUM} | 2026-06-18 | {TITLE} | {split} | ✓ |\n")

    # ---- update QUESTION_INDEX.json ----
    idx["fingerprints"] = sorted(existing | set(new_fps))
    idx.setdefault("combos", []).append({
        "paper": PNUM,
        "chapters": ["Motion & Time",
                     "Electric Current & its Effects",
                     "Simple Equations",
                     "Fractions & Decimals"],
    })
    idx["papers"] = idx.get("papers", 0) + 1
    with open(idx_path, "w", encoding="utf-8") as fh:
        json.dump(idx, fh, ensure_ascii=False, indent=2)
        fh.write("\n")

    print("Files:", sorted(v for v in moves.values()))
    print("Answer key spread A/B/C/D =", dict(keydist))
    print("Fingerprints added:", len(new_fps))
