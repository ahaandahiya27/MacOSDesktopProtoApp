# -*- coding: utf-8 -*-
# Boss Challenge Paper 19 — Motion & Time · Heat
#                          · Fractions & Decimals · Perimeter & Area
# Content-only. Uses the dependency-free examfactory engine.
# Difficulty ramp: this paper leans into FUSION — a Motion-&-Time context
# (a swinging pendulum, a moving car) wrapped around a Fractions-&-Decimals
# skill, and a Heat / real-world context wrapped around a Perimeter-&-Area
# skill (fencing a field, tiling a floor, panel areas). Class-7 scope,
# simple wording, hard thinking.
# Produces, under Resources/BossChallengePapers/:
#   Paper_19_<SHORT>_QuestionPaper.html  (pure HTML — questions + options, no answers)
#   Paper_19_<SHORT>_QuestionPaper.pdf
#   Paper_19_<SHORT>_Questions.md
#   Paper_19_<SHORT>_Solutions.html
import os, sys, shutil, json, re
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from examfactory import build_paper, C, steps, U

PNUM  = "19"
SHORT = "MotionTime_Heat_FractionsDecimals_PerimeterArea"
TITLE = "Motion & Time · Heat · Fractions & Decimals · Perimeter & Area"
LABELS = {
    "MT": "Motion & Time",
    "HE": "Heat",
    "FD": "Fractions & Decimals",
    "PA": "Perimeter & Area",
}

# ---------- MOTION & TIME (25) — Science ----------
MT = [
 ("MT","The distance a body covers divided by the time it takes is what we call its:",
   "speed",
   C("Speed tells us how fast something moves; it is the distance travelled in each unit of time.")+
   steps("Speed compares distance with time","Speed = distance ÷ time","A bigger distance in the same time means a higher speed.")+
   U("A car's speedometer is really doing this division for you, showing distance covered each hour."),
   [("distance","Distance is just how far something goes; speed is that distance shared out over the time taken."),
    ("time","Time is how long the journey lasts; speed combines that time with the distance to say how fast."),
    ("weight","Weight is how heavy a body is and has nothing to do with how fast it moves.")]),

 ("MT","In the SI system, the unit used to measure speed is the:",
   "metre per second (m/s)",
   C("Because speed is distance (metres) divided by time (seconds), its SI unit is metre per second.")+
   steps("SI distance is the metre","SI time is the second","Distance ÷ time gives metre per second (m/s).")+
   U("Scientists report a sprinter's speed in m/s so results from different countries can be compared fairly."),
   [("kilogram (kg)","The kilogram measures mass, not speed; speed is metres divided by seconds."),
    ("second (s)","The second measures time only; speed needs distance shared over that time, so m/s."),
    ("metre (m)","The metre measures distance only; speed divides that distance by the time, giving m/s.")]),

 ("MT","If a car covers a distance of 60 km in 2 hours, then its speed works out to:",
   "30 km/h",
   C("Speed = distance ÷ time = 60 km ÷ 2 h = 30 km/h.")+
   steps("Distance = 60 km, time = 2 h","Speed = 60 ÷ 2","Speed = 30 km/h.")+
   U("This is exactly how a driver works out an average pace over a long trip."),
   [("120 km/h","That comes from multiplying 60 × 2; speed is distance DIVIDED by time, giving 30 km/h."),
    ("62 km/h","Adding 60 + 2 is not how speed works; you divide distance by time to get 30 km/h."),
    ("15 km/h","That would be 60 ÷ 4; here the time is 2 hours, so 60 ÷ 2 = 30 km/h.")]),

 ("MT","When a body covers equal distances in equal intervals of time, its motion is described as:",
   "uniform motion",
   C("Equal distances in equal times means the speed never changes — that is uniform motion.")+
   steps("Check the distance covered each second","If it is the same every second, the speed is steady","Steady, unchanging speed is uniform motion.")+
   U("A train cruising steadily on a straight track at a fixed speed is in uniform motion."),
   [("non-uniform motion","Non-uniform motion is when the distances per second DIFFER; here they are equal, so it is uniform."),
    ("circular motion","Circular motion is about the PATH being a circle, not about equal distances in equal times."),
    ("no motion at all","Covering distance means the body IS moving; equal distances each second make it uniform motion.")]),

 ("MT","A bus that speeds up, slows down and speeds up again as it moves through traffic is showing:",
   "non-uniform motion",
   C("When the speed keeps changing, the distances covered each second are unequal — non-uniform motion.")+
   steps("The bus covers different distances in equal times","That means its speed is changing","Changing speed is non-uniform motion.")+
   U("Almost all real journeys through a city are non-uniform because of stops, turns and traffic."),
   [("uniform motion","Uniform motion needs a STEADY speed; a bus that speeds up and slows down does not have one."),
    ("rest","The bus is clearly moving, just at a changing speed, so it is in non-uniform motion, not at rest."),
    ("periodic motion","Periodic motion repeats at fixed times, like a pendulum; changing traffic speed is non-uniform.")]),

 ("MT","The instrument fitted in a vehicle that shows its speed at every moment is the:",
   "speedometer",
   C("The speedometer continuously displays how fast the vehicle is moving right now.")+
   steps("A driver needs to know the present speed","The speedometer reads it directly, usually in km/h","So it is the instrument that shows speed.")+
   U("Watching the speedometer helps a driver stay within the speed limit on a highway."),
   [("odometer","The odometer adds up the total DISTANCE travelled, not the speed at this moment."),
    ("thermometer","A thermometer measures temperature, not how fast the vehicle is going."),
    ("barometer","A barometer measures air pressure; it tells you nothing about a vehicle's speed.")]),

 ("MT","The instrument in a vehicle that records the total distance it has travelled is the:",
   "odometer",
   C("The odometer keeps a running total of all the distance the vehicle has covered.")+
   steps("Distance covered adds up over many trips","The odometer stores this growing total","So it shows total distance, not speed.")+
   U("A used-car buyer checks the odometer to see how many kilometres the car has already done."),
   [("speedometer","The speedometer shows the speed at this moment, not the total distance covered."),
    ("compass","A compass shows direction (north, south); it does not record distance travelled."),
    ("stopwatch","A stopwatch measures time intervals, not the total distance a vehicle has gone.")]),

 ("MT","The to-and-fro (back-and-forth) movement of a swinging pendulum is called an:",
   "oscillation",
   C("One complete back-and-forth swing of a pendulum is a single oscillation.")+
   steps("The bob swings from one side to the other and back","That full round trip is one swing","One such swing is called an oscillation.")+
   U("Old pendulum clocks count these steady oscillations to keep time."),
   [("rotation","Rotation is spinning about an axis, like a top; a pendulum swings to and fro, which is an oscillation."),
    ("translation","Translation is moving in a straight line from place to place, not swinging back and forth."),
    ("explosion","An explosion is a sudden burst; a pendulum's gentle back-and-forth swing is an oscillation.")]),

 ("MT","The time a simple pendulum takes for one complete to-and-fro swing is known as its:",
   "time period",
   C("The time period is the time for one complete to-and-fro swing of the pendulum.")+
   steps("One full swing is one oscillation","The time it takes for that one swing is fixed for a given pendulum","That fixed time is the time period.")+
   U("Clockmakers set a pendulum's length so its time period is exactly one second."),
   [("speed","Speed is distance over time; the time period is just the time for one swing."),
    ("distance","Distance is how far the bob moves; the time period is a TIME, not a length."),
    ("frequency","Frequency counts swings per second; the time period is the time for ONE swing, the reverse idea.")]),

 ("MT","The basic SI unit of time is the:",
   "second",
   C("In the SI system, time is measured in seconds.")+
   steps("Every measurement needs a standard unit","For time the agreed SI unit is the second","Minutes and hours are built from seconds.")+
   U("A stopwatch and a quartz watch both keep time by counting seconds very precisely."),
   [("hour","An hour is a larger unit made of 3600 seconds; the basic SI unit of time is the second."),
    ("metre","The metre measures distance, not time; the SI unit of time is the second."),
    ("kilogram","The kilogram measures mass; time in SI is measured in seconds.")]),

 ("MT","A train travels 150 km in 3 hours at a steady pace. Its speed is:",
   "50 km/h",
   C("Speed = distance ÷ time = 150 km ÷ 3 h = 50 km/h.")+
   steps("Distance = 150 km, time = 3 h","Speed = 150 ÷ 3","Speed = 50 km/h.")+
   U("Railway timetables are planned using exactly this kind of distance-over-time calculation."),
   [("450 km/h","That is 150 × 3; speed is distance DIVIDED by time, so 150 ÷ 3 = 50 km/h."),
    ("153 km/h","Adding 150 + 3 is not speed; dividing distance by time gives 50 km/h."),
    ("75 km/h","That would be 150 ÷ 2; the time here is 3 hours, so 150 ÷ 3 = 50 km/h.")]),

 ("MT","Which is faster: a scooter moving at 10 m/s or a cycle moving at 30 km/h? (Hint: 10 m/s = 36 km/h.)",
   "the scooter at 10 m/s",
   C("Converting 10 m/s to 36 km/h shows it beats the cycle's 30 km/h.")+
   steps("Multiply 10 m/s by 3.6 to get km/h","10 × 3.6 = 36 km/h","36 km/h is greater than 30 km/h, so the scooter is faster.")+
   U("Comparing speeds fairly always means putting them in the SAME unit first."),
   [("the cycle at 30 km/h","Once 10 m/s is changed to 36 km/h, it is MORE than 30 km/h, so the scooter is faster."),
    ("both are exactly equal","They are not equal: 10 m/s = 36 km/h, which is greater than 30 km/h."),
    ("you cannot compare them at all","You can — just convert to the same unit; 10 m/s = 36 km/h beats 30 km/h.")]),

 ("MT","On a distance–time graph, a straight line slanting upward shows that the body is moving with:",
   "uniform (steady) speed",
   C("A straight slanting line means equal distance is covered in equal time — steady speed.")+
   steps("On the graph, distance grows evenly as time passes","Even growth makes a straight slanting line","A straight slanting line means uniform speed.")+
   U("Scientists read motion graphs at a glance: straight slant = steady speed."),
   [("changing speed","A line that CURVES would show changing speed; a straight slanting line shows steady speed."),
    ("no motion","A horizontal (flat) line shows no motion; a slanting line shows the body is moving steadily."),
    ("backward motion","A line sloping downward could suggest returning; an upward straight slant shows steady forward speed.")]),

 ("MT","On a distance–time graph, a flat horizontal line means the body is:",
   "at rest (not moving)",
   C("A flat line means the distance is not changing as time passes, so the body is at rest.")+
   steps("Read the graph: distance stays the same while time moves on","No change in distance means no movement","So a flat horizontal line means the body is at rest.")+
   U("A parked car would trace a flat horizontal line on a distance–time graph."),
   [("moving very fast","A fast body covers a lot of distance, giving a STEEP line, not a flat one."),
    ("moving at steady speed","Steady speed gives a slanting straight line; a flat line means no movement at all."),
    ("speeding up","Speeding up gives a curve that gets steeper; a flat line means the body is not moving.")]),

 ("MT","A cyclist rides at a steady 40 km/h for 3 hours. The distance covered is:",
   "120 km",
   C("Distance = speed × time = 40 km/h × 3 h = 120 km.")+
   steps("Rearrange speed = distance ÷ time to distance = speed × time","40 × 3","Distance = 120 km.")+
   U("Trip planners multiply speed by time like this to estimate how far you'll get."),
   [("43 km","Adding 40 + 3 is not how distance works; multiply speed by time to get 120 km."),
    ("13 km","That looks like dividing; distance is speed × time = 40 × 3 = 120 km."),
    ("80 km","That is 40 × 2; the time here is 3 hours, so 40 × 3 = 120 km.")]),

 ("MT","A car must travel 100 km at a steady speed of 50 km/h. The time it will take is:",
   "2 hours",
   C("Time = distance ÷ speed = 100 km ÷ 50 km/h = 2 hours.")+
   steps("Rearrange to time = distance ÷ speed","100 ÷ 50","Time = 2 hours.")+
   U("Working out journey time this way tells you when to leave to arrive on time."),
   [("50 hours","That divides the wrong way; time = distance ÷ speed = 100 ÷ 50 = 2 hours."),
    ("150 hours","Adding 100 + 50 is not time; you divide distance by speed to get 2 hours."),
    ("5 hours","That would be 100 ÷ 20; here the speed is 50 km/h, so 100 ÷ 50 = 2 hours.")]),

 ("MT","A pendulum takes 20 seconds to complete 10 full oscillations. Its time period is:",
   "2 seconds",
   C("Time period = total time ÷ number of oscillations = 20 s ÷ 10 = 2 s.")+
   steps("10 oscillations take 20 seconds in total","One oscillation takes 20 ÷ 10","Time period = 2 seconds.")+
   U("Counting many swings and dividing gives a much more accurate time period than timing just one."),
   [("20 seconds","20 s is the time for ALL 10 swings; one swing takes 20 ÷ 10 = 2 seconds."),
    ("10 seconds","That would be dividing by 2; there are 10 oscillations, so 20 ÷ 10 = 2 seconds."),
    ("200 seconds","That multiplies instead of divides; the time period is 20 ÷ 10 = 2 seconds.")]),

 ("MT","Among these animals, which one moves with the highest speed?",
   "a cheetah at 30 m/s",
   C("Comparing the speeds, 30 m/s is the largest, so the cheetah is the fastest here.")+
   steps("List the speeds: 30, 10, 2 and 0.5 m/s","The biggest number is the fastest","30 m/s belongs to the cheetah.")+
   U("Knowing top speeds helps scientists understand how different animals hunt or escape."),
   [("a man running at 10 m/s","10 m/s is fast for a person but far less than the cheetah's 30 m/s."),
    ("a tortoise at 0.5 m/s","0.5 m/s is the slowest of these; the cheetah at 30 m/s is far quicker."),
    ("a flying bird at 2 m/s","2 m/s is much slower than the cheetah's 30 m/s.")]),

 ("MT","Two pendulums swing side by side. The one with the longer time period is the one that:",
   "swings more slowly",
   C("A longer time period means each swing takes more time, so that pendulum swings more slowly.")+
   steps("Time period is the time for one swing","A longer time period = each swing takes longer","Taking longer per swing means swinging more slowly.")+
   U("A tall grandfather clock has a long, slow-swinging pendulum to keep its steady beat."),
   [("swings more quickly","A quick swing has a SHORT time period; a longer time period means a slower swing."),
    ("does not swing at all","A pendulum with a time period is certainly swinging — just more slowly if the period is longer."),
    ("covers more distance per swing","The time period is about TIME, not distance; a longer period simply means a slower swing.")]),

 ("MT","When a body's speed changes during a journey, the single speed that describes the whole trip is the:",
   "average speed",
   C("Average speed is the total distance divided by the total time for the whole journey.")+
   steps("During the trip the speed went up and down","Add up all the distance and all the time","Average speed = total distance ÷ total time.")+
   U("A long road trip is summed up by its average speed, even though you sped up and slowed down."),
   [("top speed","Top speed is the fastest you went at one moment, not the overall pace of the whole trip."),
    ("starting speed","The starting speed is just the first moment; the whole trip is described by the average speed."),
    ("zero speed","The body did move, so its speed is not zero; the trip is described by its average speed.")]),

 ("MT","Two towns are 240 km apart. A bus travelling steadily at 60 km/h will cover this in:",
   "4 hours",
   C("Time = distance ÷ speed = 240 km ÷ 60 km/h = 4 hours.")+
   steps("Distance = 240 km, speed = 60 km/h","Time = 240 ÷ 60","Time = 4 hours.")+
   U("Bus operators use this to print accurate arrival times in their timetables."),
   [("3 hours","That would be 240 ÷ 80; at 60 km/h the time is 240 ÷ 60 = 4 hours."),
    ("180 hours","That subtracts instead of dividing; time = 240 ÷ 60 = 4 hours."),
    ("14400 hours","That multiplies 240 × 60; time is distance DIVIDED by speed = 4 hours.")]),

 ("MT","A boy walks 1.5 km in 30 minutes (half an hour). His speed is:",
   "3 km/h",
   C("Speed = distance ÷ time = 1.5 km ÷ 0.5 h = 3 km/h.")+
   steps("30 minutes is half an hour = 0.5 h","Speed = 1.5 ÷ 0.5","Speed = 3 km/h.")+
   U("Fitness apps work out your walking pace from distance and time in just this way."),
   [("1.5 km/h","That forgets to change 30 min to half an hour; 1.5 ÷ 0.5 = 3 km/h, not 1.5."),
    ("0.5 km/h","That divides the wrong way; speed = 1.5 ÷ 0.5 = 3 km/h."),
    ("45 km/h","That multiplies 1.5 × 30; speed is distance ÷ time = 1.5 ÷ 0.5 = 3 km/h.")]),

 ("MT","The Earth going around the Sun once every year, again and again, is an example of:",
   "periodic motion",
   C("Motion that repeats at regular, fixed intervals of time is periodic motion.")+
   steps("The Earth completes its orbit in a fixed time — one year","This repeats every year","Motion that repeats at fixed times is periodic motion.")+
   U("Calendars are built on this periodic motion, dividing the repeating year into months and days."),
   [("non-periodic motion","Non-periodic motion does NOT repeat regularly; the Earth's yearly orbit repeats, so it is periodic."),
    ("random motion","Random motion has no pattern; the Earth's orbit is a steady, repeating pattern — periodic."),
    ("straight-line motion","The Earth follows a curved orbit, not a straight line; the key point is that it repeats — periodic.")]),

 ("MT","On the same distance–time graph, the line that is steeper belongs to the body moving at:",
   "the greater speed",
   C("A steeper line means more distance is covered in the same time, so the speed is greater.")+
   steps("Steeper line = distance rises faster as time passes","More distance in the same time means a higher speed","So the steeper line shows the greater speed.")+
   U("Comparing two cars on one graph, the steeper line is instantly the faster car."),
   [("the smaller speed","A SHALLOWER line shows a smaller speed; the steeper line means the body is going faster."),
    ("no motion at all","A flat line means no motion; a steeper slanting line means greater speed, not zero."),
    ("exactly the same speed","Different steepness means different speeds; the steeper line is the faster one.")]),

 ("MT","Long ago, before clocks, people measured time during the day using the moving shadow on a:",
   "sundial",
   C("A sundial uses the shadow cast by the Sun, which moves through the day, to show the time.")+
   steps("As the Sun moves across the sky, shadows shift","A sundial's pointer casts a shadow on marked hours","Reading where the shadow falls tells the time.")+
   U("Many old forts and gardens still have stone sundials that once told the hours by sunlight."),
   [("speedometer","A speedometer shows a vehicle's speed; the old shadow-clock for telling time is a sundial."),
    ("thermometer","A thermometer measures temperature, not the time of day from a shadow."),
    ("compass","A compass shows direction; the device that told time by a moving shadow is the sundial.")]),
]

# ---------- HEAT (25) — Science ----------
HE = [
 ("HE","Heat always flows on its own from a body at:",
   "higher temperature to one at lower temperature",
   C("Heat moves naturally from the hotter object to the cooler one until they reach the same temperature.")+
   steps("Two bodies touch, one hot and one cold","Heat leaves the hot body and enters the cold one","This continues until both are equally warm.")+
   U("A hot cup of tea cools down because its heat keeps flowing into the cooler air around it."),
   [("lower temperature to one at higher temperature","Heat does not flow 'uphill' on its own; it always moves from hotter to cooler."),
    ("a heavier body to a lighter body","Weight does not decide heat flow; temperature does — hot to cold."),
    ("a larger body to a smaller body","Size does not decide the direction; heat always flows from the hotter to the cooler body.")]),

 ("HE","The quantity that tells us how hot or cold a body is, measured with a thermometer, is its:",
   "temperature",
   C("Temperature is the measure of the degree of hotness or coldness of a body.")+
   steps("We need a number for how hot something is","A thermometer gives that reading","That reading is the temperature.")+
   U("A nurse checks a patient's temperature to find out whether they have a fever."),
   [("weight","Weight is how heavy a body is, measured on a balance, not how hot it is."),
    ("length","Length is how long something is, measured with a ruler, not its hotness."),
    ("speed","Speed is how fast a body moves; how hot it is, is its temperature.")]),

 ("HE","To measure the temperature of the human body, a doctor uses a:",
   "clinical thermometer",
   C("A clinical thermometer is specially made to read body temperature, around 37°C.")+
   steps("Body temperature stays near 37°C","A clinical thermometer's small range (about 35–42°C) suits this","So it is the right tool for body temperature.")+
   U("The thermometer a doctor places under your tongue to check for fever is a clinical thermometer."),
   [("laboratory thermometer","A laboratory thermometer covers a much wider range and is for experiments, not body temperature."),
    ("barometer","A barometer measures air pressure, not body temperature."),
    ("speedometer","A speedometer measures speed; body temperature is read with a clinical thermometer.")]),

 ("HE","A healthy person's body stays at a normal temperature of roughly:",
   "37°C",
   C("A healthy person's body temperature stays close to 37 degrees Celsius.")+
   steps("Our body keeps itself at a steady warmth","That steady value is about 37°C (98.6°F)","A reading much above this usually means fever.")+
   U("A reading of 40°C on a thermometer tells a doctor the patient has a high fever."),
   [("0°C","0°C is the freezing point of water, far too cold for a living body; normal body temperature is 37°C."),
    ("100°C","100°C is the boiling point of water; a body at that temperature could not survive — normal is 37°C."),
    ("50°C","50°C is far above body temperature; a healthy body stays close to 37°C.")]),

 ("HE","Heat passing through a solid metal rod, from its hot end to its cold end, travels by:",
   "conduction",
   C("In solids, heat is passed from particle to particle without the particles moving away — this is conduction.")+
   steps("One end of the rod is heated","The heat passes along through the touching particles","This handing-on of heat through a solid is conduction.")+
   U("The handle of a metal spoon left in hot soup soon turns warm through conduction."),
   [("convection","Convection happens in liquids and gases where the heated fluid itself moves; a solid rod uses conduction."),
    ("radiation","Radiation needs no material and travels as rays; heat moving along a solid rod is conduction."),
    ("reflection","Reflection is the bouncing back of light or heat rays, not heat passing along a solid rod.")]),

 ("HE","In water and air, heat is carried by the actual movement of the heated material itself. This is called:",
   "convection",
   C("In liquids and gases, warmed material rises and cooler material sinks, carrying heat — convection.")+
   steps("Warmed water or air becomes lighter and rises","Cooler, heavier material sinks to take its place","This circulating movement carries heat — convection.")+
   U("Water boiling in a pan churns round and round as heat spreads by convection."),
   [("conduction","Conduction passes heat through a solid without the material flowing; in fluids the heat moves WITH the material — convection."),
    ("radiation","Radiation travels as rays through empty space; convection needs a moving liquid or gas."),
    ("freezing","Freezing is a liquid turning solid as it loses heat, not the way heat is carried through a fluid.")]),

 ("HE","The Sun's heat reaches the Earth across empty space, where there is no air, by the process of:",
   "radiation",
   C("Radiation carries heat as rays that can travel even through empty space, needing no material.")+
   steps("Between the Sun and Earth there is mostly empty space","Conduction and convection need a material, which is absent","So the heat must travel as rays — radiation.")+
   U("You feel a fire's warmth on your face by radiation, even without touching it or the air carrying it."),
   [("conduction","Conduction needs a solid material to pass through; empty space has none, so the Sun's heat comes by radiation."),
    ("convection","Convection needs a moving liquid or gas; the near-empty space to the Sun has none, so it is radiation."),
    ("evaporation","Evaporation is a liquid turning to vapour; it is not how the Sun's heat crosses empty space.")]),

 ("HE","Substances like iron and copper, which allow heat to pass through them readily, are known as:",
   "conductors of heat",
   C("A conductor lets heat pass through it readily; most metals are good conductors.")+
   steps("Heat tries to pass through a material","If it passes easily, the material is a conductor","Metals like iron and copper are good conductors.")+
   U("Cooking pans are made of metal so the heat reaches the food quickly through the conducting base."),
   [("insulators of heat","Insulators RESIST heat; metals let heat through easily, so they are conductors, not insulators."),
    ("liquids","Conductor and insulator describe how well heat passes, not the state of matter; metals are conductors."),
    ("gases","Gases are generally poor at carrying heat by conduction; metals, which conduct well, are the conductors.")]),

 ("HE","Materials such as wool, wood and plastic, which do not let heat pass through easily, are called:",
   "insulators of heat",
   C("An insulator resists the flow of heat; wool, wood and plastic are poor conductors, so good insulators.")+
   steps("Heat tries to pass through the material","If it passes only with difficulty, the material is an insulator","Wool, wood and plastic block heat well.")+
   U("A wooden or plastic spoon stays cool to hold even while stirring a hot pot, because it insulates."),
   [("conductors of heat","Conductors let heat through easily; wool and plastic RESIST heat, so they are insulators."),
    ("metals","Metals are good conductors; the materials that resist heat, like wool and plastic, are insulators."),
    ("magnets","A magnet attracts iron; it has nothing to do with how easily heat passes — these are insulators.")]),

 ("HE","On a hot sunny day, light-coloured clothes keep us more comfortable than dark clothes because light colours:",
   "reflect more heat and absorb less",
   C("Light colours bounce away much of the Sun's heat, so we stay cooler than in dark clothes.")+
   steps("Dark colours soak up (absorb) heat","Light colours reflect more heat away","Reflecting heat keeps us cooler in summer.")+
   U("People in hot deserts often wear white robes to reflect the fierce sunlight and stay cool."),
   [("absorb more heat and reflect less","That is what DARK colours do; light colours reflect heat away to keep us cooler."),
    ("make their own cold air","Cloth cannot make cold air; light colours simply reflect more of the Sun's heat."),
    ("stop sweat completely","Light colours do not stop sweating; they keep us cooler by reflecting heat away.")]),

 ("HE","Woollen clothes keep us warm in winter mainly because:",
   "they trap air, which is a poor conductor of heat",
   C("Wool holds tiny pockets of air, and trapped air is a poor conductor, so body heat is not lost easily.")+
   steps("Wool has many small spaces that hold air","Trapped air is a poor conductor of heat","So our body heat stays in and we feel warm.")+
   U("Two thin layers can feel warmer than one thick one because they trap an extra layer of air."),
   [("wool makes heat by itself","Wool cannot create heat; it keeps us warm by trapping air that stops our own heat escaping."),
    ("wool is a very good conductor","If wool conducted well, heat would escape fast; it keeps us warm because it is a POOR conductor."),
    ("wool is always hot to touch","Wool is not hot on its own; it simply traps air and slows the loss of our body heat.")]),

 ("HE","For an experiment needing temperatures well above 42°C, a student should use a:",
   "laboratory thermometer",
   C("A laboratory thermometer covers a wide range (often −10°C to 110°C), suiting hot experiments.")+
   steps("A clinical thermometer only reaches about 42°C","Many experiments go far hotter than that","So a wide-range laboratory thermometer is needed.")+
   U("Measuring the temperature of warm water heating on a flame calls for a laboratory thermometer."),
   [("clinical thermometer","A clinical thermometer stops near 42°C, so it cannot read the higher temperatures of an experiment."),
    ("barometer","A barometer measures air pressure, not temperature, so it is no use here."),
    ("measuring tape","A measuring tape measures length; temperature needs a laboratory thermometer.")]),

 ("HE","Why can a clinical thermometer NOT be used to measure the temperature of boiling water?",
   "its scale only goes up to about 42°C, far below boiling",
   C("Boiling water is about 100°C, but a clinical thermometer's scale stops near 42°C, so it cannot read it.")+
   steps("Boiling water is roughly 100°C","A clinical thermometer reads only up to about 42°C","The reading is off its scale, so it cannot be used.")+
   U("Trying it could even break the thermometer, which is why labs use wide-range thermometers for hot water."),
   [("it can only measure cold things","It is not that it reads only cold things; its scale simply stops near 42°C, below boiling."),
    ("water has no temperature","All water has a temperature; the problem is the thermometer's scale ends near 42°C."),
    ("it measures speed, not heat","A clinical thermometer measures temperature; the issue is its small range up to about 42°C.")]),

 ("HE","A small bend, called a kink, in the tube of a clinical thermometer is there to:",
   "stop the mercury from slipping back before you read it",
   C("The kink holds the mercury in place after it is taken out, so the reading does not drop while you read it.")+
   steps("Mercury rises as it warms to body temperature","On removal the thermometer cools","The kink traps the mercury so the reading stays until you shake it down.")+
   U("Thanks to the kink, a doctor can take the thermometer out and read the fever calmly."),
   [("make the thermometer look attractive","The kink is functional, not decorative; it stops the mercury slipping back before you read it."),
    ("let the mercury fall back quickly","The kink does the OPPOSITE — it holds the mercury so it does NOT fall back before reading."),
    ("measure two temperatures at once","A clinical thermometer reads one temperature; the kink simply holds the reading steady.")]),

 ("HE","In a pan of water heated from below, the hot water at the bottom:",
   "rises upward while cooler water sinks down",
   C("Heated water expands, becomes lighter and rises, while cooler heavier water sinks — a convection current.")+
   steps("Water at the bottom heats and expands","Being lighter, it rises to the top","Cooler heavier water sinks to take its place, setting up a current.")+
   U("This rising-and-sinking is why a whole pan of water heats up, not just the bottom."),
   [("stays exactly where it is","Heated water does not stay put; it rises because it becomes lighter, driving a convection current."),
    ("sinks straight to the bottom","Heated water RISES because it is lighter; it is the cooler water that sinks."),
    ("turns instantly to ice","Heating cannot make ice; the hot water rises and cooler water sinks in a convection current.")]),

 ("HE","Dark-coloured surfaces, compared with light-coloured ones, are:",
   "better absorbers of heat",
   C("Dark surfaces soak up more of the heat that falls on them than light surfaces do.")+
   steps("Heat falls on a surface","A dark surface absorbs most of it","So dark surfaces are better absorbers of heat.")+
   U("Solar water heaters are painted black so they absorb as much of the Sun's heat as possible."),
   [("better reflectors of heat","Dark surfaces ABSORB heat; it is light, shiny surfaces that reflect heat better."),
    ("unable to take in any heat","Dark surfaces actually take in heat very well; they are good absorbers."),
    ("always colder than light ones","In sunlight dark surfaces get HOTTER, not colder, because they absorb more heat.")]),

 ("HE","The handles of cooking pans are often made of plastic or wood because these materials are:",
   "poor conductors, so the handle stays cool to hold",
   C("Plastic and wood do not let heat pass easily, so the handle stays cool enough to grip safely.")+
   steps("The metal pan gets very hot","Plastic and wood are poor conductors (insulators)","So heat does not reach your hand through the handle.")+
   U("You can lift a hot frying pan safely because its insulating handle does not burn your hand."),
   [("good conductors, so the handle heats quickly","If the handle conducted well it would burn you; it is made of POOR conductors to stay cool."),
    ("magnets that hold the pan together","Plastic handles are not magnets; they are insulators that keep the handle cool to hold."),
    ("able to make the pan hotter","The handle's job is to stay cool, not to heat the pan; it is made of poor conductors.")]),

 ("HE","During the day at the seaside, a cool breeze blows from the sea toward the land because:",
   "land heats up faster than the sea, and cooler air moves in from the sea",
   C("Land warms faster than water; the warm air over land rises and cooler sea air flows in as the sea breeze.")+
   steps("By day the land heats faster than the sea","Warm air over the land rises","Cooler air from over the sea moves in to replace it — the sea breeze.")+
   U("This daytime sea breeze is why beaches feel pleasantly cool on a hot afternoon."),
   [("the sea heats up faster than the land","It is the LAND that heats faster; that is why the cooler air comes from the sea by day."),
    ("the sea is always hotter than the land","By day the land is hotter, so its warm air rises and cool sea air flows in."),
    ("wind has nothing to do with heat","The sea breeze is caused by uneven heating; warm air rising over land pulls in cool sea air.")]),

 ("HE","Two thin blankets together often keep you warmer than one thick blanket because:",
   "a layer of air trapped between them is a poor conductor of heat",
   C("The trapped air between the two blankets is a poor conductor, adding extra insulation.")+
   steps("Between two blankets sits a layer of air","Trapped air is a poor conductor of heat","This extra insulating layer keeps more body heat in.")+
   U("Wearing several light layers in winter can keep you cosier than one heavy coat, for this reason."),
   [("two blankets weigh more, and weight makes heat","Weight does not make heat; the warmth comes from the air trapped between the blankets."),
    ("thin blankets are naturally hotter","Thin blankets are not hotter; the trapped air between two of them is what adds warmth."),
    ("air is a very good conductor of heat","Air is a POOR conductor; that is exactly why the trapped layer keeps you warm.")]),

 ("HE","A steel spoon left standing in a cup of hot tea slowly becomes hot to touch. This shows heat travelling by:",
   "conduction",
   C("Heat passes up the metal spoon from particle to particle, an example of conduction in a solid.")+
   steps("The lower end of the spoon sits in hot tea","Heat passes along the metal to the handle","This handing-on through a solid is conduction.")+
   U("It is why a metal teaspoon can get too hot to hold if left in a fresh cup of tea."),
   [("convection","Convection moves heat through a flowing liquid or gas; heat travelling up the solid spoon is conduction."),
    ("radiation","Radiation travels as rays through space; the warmth climbing the solid spoon is conduction."),
    ("evaporation","Evaporation is a liquid turning to vapour; the spoon warming up is heat conducted through metal.")]),

 ("HE","An electric room heater warms the air in a room, and the warm air spreads around the room mainly by:",
   "convection",
   C("Air heated by the heater rises and circulates, carrying heat around the room by convection.")+
   steps("The heater warms the nearby air","Warm air rises and cooler air sinks to take its place","This circulating air spreads the heat — convection.")+
   U("This is why warm air collects near the ceiling while the floor of a room stays cooler."),
   [("conduction","Air is a poor conductor; the heat spreads through the room by the air MOVING — convection."),
    ("freezing","Freezing removes heat to make a solid; a heater warming the room spreads heat by convection."),
    ("reflection","Reflection bounces rays back; the warm air circulating through the room is convection.")]),

 ("HE","When a substance is heated, its temperature usually:",
   "rises",
   C("Adding heat to a body normally increases its temperature.")+
   steps("Heat is energy flowing into the body","The body's particles move faster","This shows up as a rise in temperature.")+
   U("Putting a pan on the flame raises the temperature of the water inside it."),
   [("falls","Adding heat does not lower temperature; removing heat does. Heating usually makes temperature rise."),
    ("stays exactly the same forever","While heat is being added the temperature generally rises, rather than staying fixed."),
    ("disappears completely","Temperature does not vanish; heating a substance normally raises its temperature.")]),

 ("HE","Why do many cooking pots have shiny, polished outer surfaces?",
   "shiny surfaces reflect heat and lose it slowly, keeping food warm",
   C("A shiny, polished surface is a poor radiator, so it loses heat slowly and keeps the food hot longer.")+
   steps("Shiny surfaces reflect heat rather than radiate it away","So a shiny pot loses its heat slowly","This keeps the food inside warm for longer.")+
   U("A shiny steel casserole keeps cooked food warm at the dinner table much longer than a dull black one."),
   [("shiny surfaces make the food tastier","Shine does not affect taste; it keeps food warm by losing heat slowly."),
    ("shiny surfaces absorb heat the fastest","Shiny surfaces actually absorb LESS and lose heat slowly, helping keep food warm."),
    ("shiny surfaces cool the food quickly","A shiny surface keeps food warm LONGER, not cooler, by radiating heat away slowly.")]),

 ("HE","Air, compared with metals, is generally a:",
   "poor conductor of heat",
   C("Air carries heat by conduction very poorly, which is why trapped air is used to insulate.")+
   steps("Metals let heat pass quickly (good conductors)","Air lets heat pass only very slowly","So air is a poor conductor of heat.")+
   U("The trapped air in a woollen sweater is exactly what keeps your body heat from escaping."),
   [("very good conductor of heat","If air conducted well, trapped air could not insulate us; air is in fact a POOR conductor."),
    ("magnet for heat","Air does not 'attract' heat like a magnet; it simply conducts heat poorly."),
    ("the same as metal for heat","Air conducts far worse than metal; that difference is why air is used as an insulator.")]),

 ("HE","To find out whether a child has a fever, the most useful thing to measure is the body's:",
   "temperature",
   C("A fever is a higher-than-normal body temperature, so temperature is what you measure.")+
   steps("A fever means the body is hotter than usual","Hotness is measured as temperature","So a clinical thermometer reads the temperature to check for fever.")+
   U("A reading above about 37.5°C on the thermometer warns a parent that a fever may be starting."),
   [("weight","Weight tells you how heavy the child is, not whether they have a fever; that needs temperature."),
    ("height","Height does not change with a fever; you check for fever by measuring temperature."),
    ("speed","Speed is about motion; a fever is detected by measuring the body's temperature.")]),
]

# ---------- FRACTIONS & DECIMALS (25) — Maths ----------
FD = [
 ("FD","The sum 1/2 + 1/4 equals:",
   "3/4",
   C("Make the denominators the same: 1/2 = 2/4, then 2/4 + 1/4 = 3/4.")+
   steps("Write 1/2 as 2/4 so both have denominator 4","2/4 + 1/4 = 3/4","So 1/2 + 1/4 = 3/4.")+
   U("Adding a half cup and a quarter cup of flour gives three-quarters of a cup."),
   [("2/6","You cannot add by adding tops and bottoms; convert to a common denominator first to get 3/4."),
    ("1/6","That looks like multiplying or wrong addition; the correct sum is 3/4."),
    ("1/2","Adding 1/4 must make the answer bigger than 1/2; the sum is 3/4.")]),

 ("FD","Multiplying the fractions 2/3 and 3/4 together gives a result of:",
   "1/2",
   C("Multiply tops and bottoms: (2×3)/(3×4) = 6/12, which simplifies to 1/2.")+
   steps("Multiply numerators: 2 × 3 = 6","Multiply denominators: 3 × 4 = 12","6/12 simplifies to 1/2.")+
   U("Two-thirds of three-quarters of a pizza is the same as half the pizza."),
   [("5/7","You do not add the numbers across; multiply tops and bottoms to get 6/12 = 1/2."),
    ("6/7","The denominators multiply too (3 × 4 = 12), giving 6/12 = 1/2, not 6/7."),
    ("5/12","The numerators multiply to 2 × 3 = 6, not 5; the answer is 6/12 = 1/2.")]),

 ("FD","Dividing 1/2 by 1/4 gives the value:",
   "2",
   C("Dividing by a fraction means multiplying by its reciprocal: 1/2 × 4/1 = 4/2 = 2.")+
   steps("Turn ÷ 1/4 into × 4/1","1/2 × 4 = 4/2","4/2 = 2.")+
   U("It tells you that a half-litre jug fills a quarter-litre cup exactly 2 times."),
   [("1/8","That is 1/2 × 1/4 (multiplying); dividing flips the second fraction, giving 2."),
    ("1/2","Dividing by a smaller fraction makes the answer bigger than 1/2; here it is 2."),
    ("8","That flips the wrong fraction; 1/2 × 4 = 2, not 8.")]),

 ("FD","The sum 0.5 + 0.25 equals:",
   "0.75",
   C("Line up the decimal points and add: 0.50 + 0.25 = 0.75.")+
   steps("Write 0.5 as 0.50","Add 0.50 + 0.25","The total is 0.75.")+
   U("Adding 0.5 m and 0.25 m of ribbon gives 0.75 m in all."),
   [("0.30","That looks like adding only the 5 and 25 carelessly; lined up properly it is 0.75."),
    ("0.7","You must add the hundredths too: 0.50 + 0.25 = 0.75, not 0.7."),
    ("7.5","The decimal point is misplaced; 0.5 + 0.25 = 0.75, not 7.5.")]),

 ("FD","Multiplying the decimals 0.2 and 0.3 gives:",
   "0.06",
   C("Multiply 2 × 3 = 6, then place two decimal places (one from each number): 0.06.")+
   steps("Ignore the points: 2 × 3 = 6","Count decimal places: 0.2 and 0.3 give 1 + 1 = 2 places","Place them: 0.06.")+
   U("A strip 0.2 m by 0.3 m covers 0.06 square metres."),
   [("0.6","That keeps only one decimal place; two decimals (0.2 and 0.3) give two places, so 0.06."),
    ("0.5","That adds 0.2 + 0.3; the question asks to multiply, giving 0.06."),
    ("6.0","The decimal point is far off; 0.2 × 0.3 = 0.06, not 6.0.")]),

 ("FD","Written as a decimal, the fraction 3/5 is:",
   "0.6",
   C("3 ÷ 5 = 0.6, so 3/5 = 0.6.")+
   steps("A fraction is the top divided by the bottom","3 ÷ 5 = 0.6","So 3/5 = 0.6.")+
   U("On a calculator, three-fifths shows up as 0.6."),
   [("0.35","That is just writing the digits 3 and 5; dividing 3 by 5 gives 0.6."),
    ("3.5","3.5 is far bigger than 1, but 3/5 is less than 1; the value is 0.6."),
    ("5.3","That flips the fraction; 3/5 means 3 ÷ 5 = 0.6.")]),

 ("FD","Which fraction is greater, 2/3 or 3/5?",
   "2/3",
   C("As decimals, 2/3 ≈ 0.67 and 3/5 = 0.6, so 2/3 is greater.")+
   steps("2 ÷ 3 ≈ 0.67","3 ÷ 5 = 0.6","0.67 is larger than 0.6, so 2/3 is greater.")+
   U("Comparing fractions as decimals quickly shows which slice of cake is bigger."),
   [("3/5","3/5 = 0.6, which is LESS than 2/3 ≈ 0.67, so 3/5 is the smaller one."),
    ("they are equal","0.67 and 0.6 are not the same, so 2/3 and 3/5 are not equal; 2/3 is greater."),
    ("neither can be compared","Fractions can be compared by turning them into decimals: 2/3 ≈ 0.67 beats 0.6.")]),

 ("FD","The improper fraction 7/4 written as a mixed number is:",
   "1 3/4",
   C("7 ÷ 4 = 1 with remainder 3, so 7/4 = 1 3/4.")+
   steps("Divide 7 by 4: it goes 1 time","The remainder is 3, over the same denominator 4","So 7/4 = 1 and 3/4.")+
   U("Seven quarter-slices of bread make up one whole loaf and three-quarters more."),
   [("3 1/4","That swaps the whole-number and remainder parts; 7/4 = 1 3/4, not 3 1/4."),
    ("7 1/4","7/4 is only a little less than 2; it cannot be 7 and a bit. It equals 1 3/4."),
    ("1 1/4","The remainder after 7 − 4 = 3, so it is 1 3/4, not 1 1/4.")]),

 ("FD","The reciprocal of the number 5 is:",
   "1/5",
   C("The reciprocal of a number is 1 divided by it, so the reciprocal of 5 is 1/5.")+
   steps("Write 5 as the fraction 5/1","Flip it upside down","You get 1/5.")+
   U("Dividing by 5 is the same as multiplying by its reciprocal, 1/5."),
   [("5","A number's reciprocal is its flip; 5 flipped is 1/5, not 5 again."),
    ("0.5","0.5 is 1/2, the reciprocal of 2, not of 5; the reciprocal of 5 is 1/5."),
    ("10","10 is 5 doubled, not its reciprocal; flipping 5 gives 1/5.")]),

 ("FD","One-third of the number 90 works out to:",
   "30",
   C("'Of' means multiply: 1/3 × 90 = 90 ÷ 3 = 30.")+
   steps("1/3 of a number means divide it by 3","90 ÷ 3 = 30","So 1/3 of 90 is 30.")+
   U("Sharing 90 marbles equally among 3 friends gives each friend 30."),
   [("3","That is 90 ÷ 30, not 1/3 of 90; one-third of 90 is 90 ÷ 3 = 30."),
    ("27","27 is one-third of 81, not of 90; one-third of 90 is 30."),
    ("60","60 is two-thirds of 90; one-third of 90 is 30.")]),

 ("FD","The decimal 0.75 written as a fraction in its lowest terms is:",
   "3/4",
   C("0.75 = 75/100, and dividing top and bottom by 25 gives 3/4.")+
   steps("0.75 means 75 hundredths = 75/100","Divide top and bottom by 25","75/100 = 3/4.")+
   U("0.75 of an hour is three-quarters of an hour, that is 45 minutes."),
   [("7/5","7/5 is greater than 1, but 0.75 is less than 1; the correct fraction is 3/4."),
    ("1/4","1/4 = 0.25, not 0.75; the decimal 0.75 equals 3/4."),
    ("75/10","75/10 = 7.5, far bigger than 0.75; written properly 0.75 = 75/100 = 3/4.")]),

 ("FD","The value of 5.6 × 10 is:",
   "56",
   C("Multiplying a decimal by 10 moves the decimal point one place to the right: 5.6 → 56.")+
   steps("To multiply by 10, shift the point one place right","5.6 becomes 56.","So 5.6 × 10 = 56.")+
   U("Ten lengths of 5.6 m of rope total 56 m."),
   [("5.60","Adding a zero at the end does not change the value; multiplying by 10 gives 56."),
    ("0.56","That divides by 10 (point moves LEFT); multiplying by 10 moves it right to 56."),
    ("560","That multiplies by 100; multiplying by 10 moves the point one place to give 56.")]),

 ("FD","The value of 4.5 ÷ 10 is:",
   "0.45",
   C("Dividing a decimal by 10 moves the decimal point one place to the left: 4.5 → 0.45.")+
   steps("To divide by 10, shift the point one place left","4.5 becomes 0.45","So 4.5 ÷ 10 = 0.45.")+
   U("Splitting 4.5 litres equally into 10 bottles puts 0.45 litre in each."),
   [("45","That multiplies by 10 (point moves RIGHT); dividing by 10 moves it left to 0.45."),
    ("0.045","That divides by 100; dividing by 10 moves the point just one place to give 0.45."),
    ("4.50","Adding a zero does not change the value; dividing 4.5 by 10 gives 0.45.")]),

 ("FD","The sum 2 1/2 + 1 1/2 equals:",
   "4",
   C("Add the whole numbers (2 + 1 = 3) and the halves (1/2 + 1/2 = 1): 3 + 1 = 4.")+
   steps("Whole parts: 2 + 1 = 3","Fraction parts: 1/2 + 1/2 = 1","3 + 1 = 4.")+
   U("Two-and-a-half hours plus one-and-a-half hours of study makes 4 hours in all."),
   [("3","That adds only the whole numbers and forgets the two halves making another 1; the total is 4."),
    ("3 1/2","The two halves add up to a whole 1, not stay as 1/2; the sum is 4, not 3 1/2."),
    ("4 1/2","2 + 1 = 3 wholes and the halves make 1 more, giving exactly 4, not 4 1/2.")]),

 ("FD","The value of 1.2 × 5 is:",
   "6",
   C("Multiply 12 × 5 = 60, then place one decimal place (from 1.2): 6.0 = 6.")+
   steps("Ignore the point: 12 × 5 = 60","1.2 has one decimal place, so the answer does too: 6.0","6.0 = 6.")+
   U("Five packets weighing 1.2 kg each weigh 6 kg altogether."),
   [("60","That forgets the decimal place; 1.2 (one decimal place) × 5 gives 6.0 = 6."),
    ("6.5","Multiplying 1.2 by 5 gives exactly 6, not 6.5."),
    ("1.7","That adds 1.2 + 0.5 or similar; multiplying 1.2 × 5 gives 6.")]),

 ("FD","The sum 0.1 + 0.01 equals:",
   "0.11",
   C("Line up the places: 0.10 + 0.01 = 0.11.")+
   steps("Write 0.1 as 0.10","Add the hundredths: 0.10 + 0.01","The total is 0.11.")+
   U("One-tenth plus one-hundredth of a metre is 0.11 m, just over a tenth."),
   [("0.2","That treats both as tenths; 0.01 is only a hundredth, so the sum is 0.11, not 0.2."),
    ("0.02","That adds them as if both were hundredths; 0.1 is a tenth, giving 0.11."),
    ("0.11 is wrong, it is 1.1","Misplacing the point gives 1.1; correctly lined up the sum is 0.11.")]),

 ("FD","Reduced to its lowest terms, the fraction 6/8 becomes:",
   "3/4",
   C("Divide top and bottom by their common factor 2: 6/8 = 3/4.")+
   steps("6 and 8 share the factor 2","Divide both by 2: 6 ÷ 2 = 3, 8 ÷ 2 = 4","So 6/8 = 3/4.")+
   U("Six of eight equal slices of a cake is the same as three of four equal slices."),
   [("6/8 is already lowest","6 and 8 can both be divided by 2, so it reduces further to 3/4."),
    ("2/4","Dividing only the top by 3 is not allowed; dividing both by 2 gives 3/4, and 2/4 itself reduces to 1/2."),
    ("12/16","That multiplies instead of reducing; the lowest-terms form is 3/4.")]),

 ("FD","The value of 1 − 3/8 is:",
   "5/8",
   C("Write 1 as 8/8, then 8/8 − 3/8 = 5/8.")+
   steps("Express 1 as 8/8","8/8 − 3/8 = 5/8","So 1 − 3/8 = 5/8.")+
   U("If 3/8 of a chocolate bar is eaten, 5/8 of it is left."),
   [("3/8","3/8 is the part taken away; what remains from a whole is 5/8."),
    ("2/8","Subtracting the wrong way gives this; 8/8 − 3/8 = 5/8."),
    ("1/8","8/8 − 3/8 = 5/8, not 1/8; check the subtraction of the numerators.")]),

 ("FD","The sum 2/5 + 1/5 equals:",
   "3/5",
   C("With the same denominator, add the numerators: 2/5 + 1/5 = 3/5.")+
   steps("Both fractions have denominator 5","Add the tops: 2 + 1 = 3","Keep the denominator: 3/5.")+
   U("Two-fifths of a tank plus one-fifth more fills three-fifths of the tank."),
   [("3/10","Do not add the denominators; with the same bottom you add only the tops, giving 3/5."),
    ("2/5","You must add the 1/5 as well: 2/5 + 1/5 = 3/5, not 2/5."),
    ("3/25","The denominator stays 5, not 25; the sum is 3/5.")]),

 ("FD","What is 0.25 of 200?",
   "50",
   C("0.25 means one-quarter, and one-quarter of 200 is 200 ÷ 4 = 50.")+
   steps("0.25 = 1/4","1/4 of 200 = 200 ÷ 4","= 50.")+
   U("A 25% (0.25) discount on a ₹200 item saves ₹50."),
   [("25","25 is just the digits of 0.25; one-quarter of 200 is 50."),
    ("75","75 is more than a quarter of 200; one-quarter of 200 is exactly 50."),
    ("100","100 is half (0.5) of 200; a quarter (0.25) of 200 is 50.")]),

 ("FD","Written as a decimal, the fraction 9/10 is:",
   "0.9",
   C("9 ÷ 10 = 0.9, so 9/10 = 0.9.")+
   steps("Dividing by 10 moves the point one place left","9 becomes 0.9","So 9/10 = 0.9.")+
   U("Nine-tenths of a metre of cloth is 0.9 m, just short of a full metre."),
   [("0.09","That is 9/100, not 9/10; nine-tenths is 0.9."),
    ("9.0","9.0 is the whole number nine; nine-tenths is less than 1, namely 0.9."),
    ("1.9","9/10 is less than 1; it equals 0.9, not 1.9.")]),

 ("FD","Which statement about 0.3 and 0.30 is correct?",
   "they are equal in value",
   C("Adding a zero at the end of a decimal does not change its value, so 0.3 = 0.30.")+
   steps("0.3 is three-tenths","0.30 is thirty-hundredths, which is also three-tenths","So 0.3 and 0.30 are equal.")+
   U("Whether a price is written 0.3 or 0.30, it is the same amount of money."),
   [("0.30 is bigger than 0.3","The extra zero adds nothing; 0.30 and 0.3 are exactly equal."),
    ("0.3 is bigger than 0.30","They are the same value; neither is bigger — 0.3 = 0.30."),
    ("0.30 is ten times 0.3","A trailing zero does not multiply by ten; 0.30 simply equals 0.3.")]),

 ("FD","The value of 1/2 × 1/2 × 1/2 is:",
   "1/8",
   C("Multiply across: (1×1×1)/(2×2×2) = 1/8.")+
   steps("Numerators: 1 × 1 × 1 = 1","Denominators: 2 × 2 × 2 = 8","So the product is 1/8.")+
   U("Halving a sheet of paper three times leaves each piece one-eighth of the whole."),
   [("3/6","You do not add the halves; multiplying three halves gives 1/8."),
    ("1/6","The denominators multiply to 2 × 2 × 2 = 8, not 6; the answer is 1/8."),
    ("1/2","Multiplying by halves makes the result smaller each time; three halves give 1/8.")]),

 ("FD","A pendulum has a time period of 0.5 seconds. In 2 seconds, how many complete oscillations does it make?",
   "4",
   C("Number of oscillations = total time ÷ time period = 2 ÷ 0.5 = 4.")+
   steps("Each oscillation takes 0.5 s","In 2 s, count how many 0.5 s fit: 2 ÷ 0.5","2 ÷ 0.5 = 4 oscillations.")+
   U("This links a Science idea (time period) with a Maths skill (dividing by a decimal)."),
   [("1","That is 2 × 0.5; you must DIVIDE the total time by the period: 2 ÷ 0.5 = 4."),
    ("2","2 is the total time in seconds, not the count of swings; 2 ÷ 0.5 = 4 oscillations."),
    ("0.5","0.5 s is the time for ONE swing; the number of swings in 2 s is 2 ÷ 0.5 = 4.")]),

 ("FD","A car covers 3/4 of a 200 km journey. How many kilometres has it travelled?",
   "150 km",
   C("3/4 of 200 = (3 × 200) ÷ 4 = 600 ÷ 4 = 150 km.")+
   steps("Find 1/4 of 200 first: 200 ÷ 4 = 50","Three-quarters is 3 × 50","= 150 km.")+
   U("This blends a Motion idea (distance of a journey) with the Maths of fractions of a quantity."),
   [("50 km","50 km is only ONE quarter of the journey; three-quarters is 3 × 50 = 150 km."),
    ("75 km","75 km would be 3/8 of 200; three-quarters of 200 is 150 km."),
    ("100 km","100 km is half (2/4) of the journey; three-quarters is 150 km.")]),
]

# ---------- PERIMETER & AREA (25) — Maths ----------
PA = [
 ("PA","The perimeter of a rectangle of length l and breadth b is given by:",
   "2 × (l + b)",
   C("A rectangle has two lengths and two breadths, so its perimeter is l + b + l + b = 2(l + b).")+
   steps("Add all four sides: l + b + l + b","Group them: 2l + 2b","Factor: 2 × (l + b).")+
   U("To fence a rectangular plot you need 2 × (length + breadth) metres of fencing."),
   [("l × b","l × b is the AREA of the rectangle, not its perimeter; the perimeter is 2 × (l + b)."),
    ("l + b","l + b is only one length plus one breadth; a rectangle has two of each, so 2 × (l + b)."),
    ("4 × l","4 × l suits a square of side l; a rectangle's perimeter is 2 × (l + b).")]),

 ("PA","The area of a rectangle of length l and breadth b is:",
   "l × b",
   C("The area of a rectangle is its length multiplied by its breadth.")+
   steps("Area is the space covered inside the shape","For a rectangle that is length × breadth","So area = l × b.")+
   U("A room 5 m by 4 m has a floor area of 5 × 4 = 20 square metres of tiles to cover."),
   [("2 × (l + b)","2 × (l + b) is the PERIMETER, the distance around; the area is l × b."),
    ("l + b","l + b just adds two sides; area needs them multiplied, l × b."),
    ("4 × l","4 × l fits the perimeter of a square; a rectangle's area is l × b.")]),

 ("PA","A square has a side of 5 cm. Its perimeter is:",
   "20 cm",
   C("A square has 4 equal sides, so perimeter = 4 × 5 = 20 cm.")+
   steps("All four sides equal 5 cm","Perimeter = 4 × side","= 4 × 5 = 20 cm.")+
   U("To put a border around a 5 cm square photo you need 20 cm of tape."),
   [("25 cm","25 cm² is the AREA (5 × 5); the perimeter is 4 × 5 = 20 cm."),
    ("10 cm","10 cm is only two sides; a square has four sides, giving 4 × 5 = 20 cm."),
    ("9 cm","9 cm comes from adding 5 + 4; the perimeter is 4 × 5 = 20 cm.")]),

 ("PA","A square has a side of 5 cm. Its area is:",
   "25 cm²",
   C("Area of a square = side × side = 5 × 5 = 25 cm².")+
   steps("Area of a square is side × side","5 × 5","= 25 cm².")+
   U("A 5 cm square tile covers 25 square centimetres of a wall."),
   [("20 cm²","20 is the PERIMETER (4 × 5); the area is side × side = 25 cm²."),
    ("10 cm²","10 comes from 5 + 5; area multiplies the sides: 5 × 5 = 25 cm²."),
    ("55 cm²","Writing the digits together is not multiplying; 5 × 5 = 25 cm².")]),

 ("PA","A rectangle is 8 cm long and 3 cm broad. Its area is:",
   "24 cm²",
   C("Area = length × breadth = 8 × 3 = 24 cm².")+
   steps("Length = 8 cm, breadth = 3 cm","Area = 8 × 3","= 24 cm².")+
   U("A card 8 cm by 3 cm covers 24 square centimetres of a scrapbook page."),
   [("22 cm²","22 cm is the PERIMETER, 2 × (8 + 3); the area is 8 × 3 = 24 cm²."),
    ("11 cm²","11 comes from 8 + 3; area multiplies them: 8 × 3 = 24 cm²."),
    ("16 cm²","16 is 2 × 8; the area uses both sides multiplied, 8 × 3 = 24 cm².")]),

 ("PA","A rectangle is 8 cm long and 3 cm broad. Its perimeter is:",
   "22 cm",
   C("Perimeter = 2 × (length + breadth) = 2 × (8 + 3) = 2 × 11 = 22 cm.")+
   steps("Add length and breadth: 8 + 3 = 11","Double it: 2 × 11","= 22 cm.")+
   U("A 8 cm by 3 cm frame needs 22 cm of edging all the way round."),
   [("24 cm","24 cm² is the AREA (8 × 3); the perimeter is 2 × (8 + 3) = 22 cm."),
    ("11 cm","11 cm is only length + breadth once; the perimeter doubles it to 22 cm."),
    ("16 cm","16 ignores the breadth pair; perimeter = 2 × (8 + 3) = 22 cm.")]),

 ("PA","The area of a square of side 7 m is:",
   "49 m²",
   C("Area = side × side = 7 × 7 = 49 m².")+
   steps("Area of a square = side × side","7 × 7","= 49 m².")+
   U("A square room 7 m on each side has 49 square metres of floor."),
   [("28 m²","28 is the PERIMETER (4 × 7); the area is 7 × 7 = 49 m²."),
    ("14 m²","14 is 7 + 7; the area multiplies them: 7 × 7 = 49 m²."),
    ("77 m²","Writing the digits together is not squaring; 7 × 7 = 49 m².")]),

 ("PA","An equilateral triangle has each side equal to 6 cm. Its perimeter is:",
   "18 cm",
   C("All three sides are 6 cm, so perimeter = 3 × 6 = 18 cm.")+
   steps("An equilateral triangle has 3 equal sides","Perimeter = 3 × side","= 3 × 6 = 18 cm.")+
   U("A triangular sign with 6 cm sides needs 18 cm of trim around its edge."),
   [("12 cm","12 cm is only two sides; the triangle has three, giving 3 × 6 = 18 cm."),
    ("6 cm","6 cm is just one side; adding all three gives 18 cm."),
    ("36 cm","36 multiplies 6 × 6; the perimeter adds the three sides: 3 × 6 = 18 cm.")]),

 ("PA","The area of a triangle with base 10 cm and height 4 cm is:",
   "20 cm²",
   C("Area of a triangle = 1/2 × base × height = 1/2 × 10 × 4 = 20 cm².")+
   steps("Use area = 1/2 × base × height","1/2 × 10 × 4 = 1/2 × 40","= 20 cm².")+
   U("A triangular flag with a 10 cm base and 4 cm height covers 20 square centimetres of cloth."),
   [("40 cm²","40 forgets the 1/2; a triangle's area is HALF of base × height, so 20 cm²."),
    ("14 cm²","14 adds 10 + 4; the area is 1/2 × 10 × 4 = 20 cm²."),
    ("20 cm","Area is measured in square units (cm²), not cm; the value is 20 cm².")]),

 ("PA","Using π = 22/7, the circumference of a circle of radius 7 cm is:",
   "44 cm",
   C("Circumference = 2 × π × r = 2 × 22/7 × 7 = 44 cm.")+
   steps("Circumference = 2 × π × r","2 × 22/7 × 7 = 2 × 22","= 44 cm.")+
   U("A round table of radius 7 cm (a model) needs 44 cm of ribbon around its edge."),
   [("154 cm","154 cm² is the AREA (π r²); the circumference (distance round) is 44 cm."),
    ("22 cm","22 cm is π × r, only half of 2πr; the full circumference is 44 cm."),
    ("14 cm","14 cm is the diameter (2 × 7); the distance around is 2πr = 44 cm.")]),

 ("PA","Using π = 22/7, the area of a circle of radius 7 cm is:",
   "154 cm²",
   C("Area = π × r × r = 22/7 × 7 × 7 = 22 × 7 = 154 cm².")+
   steps("Area = π × r²","22/7 × 7 × 7 = 22 × 7","= 154 cm².")+
   U("A circular plate of radius 7 cm covers 154 square centimetres of a table."),
   [("44 cm²","44 cm is the CIRCUMFERENCE (2πr), the distance round; the area is π r² = 154 cm²."),
    ("49 cm²","49 is just r × r; the area also multiplies by π = 22/7, giving 154 cm²."),
    ("22 cm²","22 is π × r alone; the area is π × r × r = 154 cm².")]),

 ("PA","A square garden has a side of 25 m. The length of fencing needed to go once around it is:",
   "100 m",
   C("Perimeter of a square = 4 × side = 4 × 25 = 100 m of fencing.")+
   steps("Fencing goes around the perimeter","Perimeter = 4 × side = 4 × 25","= 100 m.")+
   U("A farmer ordering fence for a 25 m square plot needs 100 m of wire."),
   [("625 m","625 m² is the AREA (25 × 25); the fencing follows the perimeter, 4 × 25 = 100 m."),
    ("50 m","50 m covers only two sides; a square has four, giving 4 × 25 = 100 m."),
    ("29 m","29 comes from 25 + 4; the perimeter is 4 × 25 = 100 m.")]),

 ("PA","The area of a parallelogram with base 6 cm and height 5 cm is:",
   "30 cm²",
   C("Area of a parallelogram = base × height = 6 × 5 = 30 cm².")+
   steps("Area of a parallelogram = base × height","6 × 5","= 30 cm².")+
   U("A slanted parallelogram tile with base 6 cm and height 5 cm covers 30 square centimetres."),
   [("11 cm²","11 adds 6 + 5; the area multiplies base by height: 6 × 5 = 30 cm²."),
    ("15 cm²","15 halves the product as if it were a triangle; a parallelogram's area is the full 6 × 5 = 30 cm²."),
    ("22 cm²","22 looks like a perimeter; the area is base × height = 30 cm².")]),

 ("PA","A rectangular field is 50 m long and 30 m broad. Its area is:",
   "1500 m²",
   C("Area = length × breadth = 50 × 30 = 1500 m².")+
   steps("Length = 50 m, breadth = 30 m","Area = 50 × 30","= 1500 m².")+
   U("A 50 m by 30 m playground covers 1500 square metres of ground."),
   [("160 m²","160 m is the PERIMETER, 2 × (50 + 30); the area is 50 × 30 = 1500 m²."),
    ("80 m²","80 m is length + breadth once; the area multiplies them: 1500 m²."),
    ("150 m²","That drops a zero; 50 × 30 = 1500 m², not 150 m².")]),

 ("PA","A square plot of side 12 m is to be fenced at ₹10 per metre. The total cost of fencing is:",
   "₹480",
   C("Perimeter = 4 × 12 = 48 m; cost = 48 × ₹10 = ₹480.")+
   steps("Perimeter = 4 × side = 4 × 12 = 48 m","Cost = length of fence × rate","= 48 × 10 = ₹480.")+
   U("Builders work out fencing bills exactly this way: find the perimeter, then multiply by the rate."),
   [("₹120","₹120 is just 12 × 10, one side's cost; the whole perimeter is 48 m, costing ₹480."),
    ("₹1440","₹1440 uses the area (144 m²) × 10; fencing follows the perimeter (48 m), costing ₹480."),
    ("₹48","₹48 is the perimeter in metres, not the cost; at ₹10/m it costs 48 × 10 = ₹480.")]),

 ("PA","A square has a side of 4.5 cm. Its perimeter is:",
   "18 cm",
   C("Perimeter = 4 × 4.5 = 18 cm.")+
   steps("All four sides are 4.5 cm","Perimeter = 4 × 4.5","= 18 cm.")+
   U("A decimal side is no problem: a 4.5 cm square needs 18 cm of border."),
   [("20.25 cm","20.25 cm² is the AREA (4.5 × 4.5); the perimeter is 4 × 4.5 = 18 cm."),
    ("9 cm","9 cm is only two sides (2 × 4.5); a square has four, giving 18 cm."),
    ("16 cm","16 would be 4 × 4; here the side is 4.5, so 4 × 4.5 = 18 cm.")]),

 ("PA","A square has a side of 0.5 m. Its area is:",
   "0.25 m²",
   C("Area = side × side = 0.5 × 0.5 = 0.25 m².")+
   steps("Area of a square = side × side","0.5 × 0.5","= 0.25 m².")+
   U("A small square tile 0.5 m on each side covers a quarter of a square metre."),
   [("1 m²","1 m² would need a side of 1 m; a 0.5 m side gives 0.5 × 0.5 = 0.25 m²."),
    ("2 m²","2 m² is far too big for a half-metre square; the area is 0.25 m²."),
    ("0.5 m²","0.5 m is the side length, not the area; the area is 0.5 × 0.5 = 0.25 m².")]),

 ("PA","A floor is 4 m long and 3 m wide. How many square tiles of side 1 m are needed to cover it exactly?",
   "12 tiles",
   C("The floor area is 4 × 3 = 12 m², and each 1 m tile covers 1 m², so 12 tiles are needed.")+
   steps("Floor area = 4 × 3 = 12 m²","Each tile covers 1 m × 1 m = 1 m²","Tiles needed = 12 ÷ 1 = 12.")+
   U("Tilers find the floor area first, then divide by one tile's area to count the tiles."),
   [("7 tiles","7 comes from 4 + 3; you need the AREA, 4 × 3 = 12, so 12 tiles."),
    ("14 tiles","14 m is the perimeter; the number of 1 m² tiles equals the area, 12."),
    ("24 tiles","24 doubles the area; the floor is 12 m², so it takes 12 one-metre tiles.")]),

 ("PA","A rectangle is 12 cm long and 8 cm broad. Its perimeter is:",
   "40 cm",
   C("Perimeter = 2 × (12 + 8) = 2 × 20 = 40 cm.")+
   steps("Add length and breadth: 12 + 8 = 20","Double it: 2 × 20","= 40 cm.")+
   U("Edging a 12 cm by 8 cm picture takes 40 cm of frame."),
   [("96 cm","96 cm² is the AREA (12 × 8); the perimeter is 2 × (12 + 8) = 40 cm."),
    ("20 cm","20 cm is length + breadth once; the perimeter doubles it to 40 cm."),
    ("24 cm","24 is 2 × 12 only; the perimeter also counts the breadths: 2 × (12 + 8) = 40 cm.")]),

 ("PA","A rectangle has an area of 24 cm² and a length of 6 cm. Its breadth is:",
   "4 cm",
   C("Breadth = area ÷ length = 24 ÷ 6 = 4 cm.")+
   steps("Area = length × breadth, so breadth = area ÷ length","24 ÷ 6","= 4 cm.")+
   U("If you know a tile's area and one side, you can work back to find the other side this way."),
   [("18 cm","18 comes from 24 − 6; breadth = area ÷ length = 24 ÷ 6 = 4 cm."),
    ("144 cm","144 multiplies 24 × 6; you must DIVIDE to get the breadth, 24 ÷ 6 = 4 cm."),
    ("30 cm","30 adds 24 + 6; breadth = area ÷ length = 4 cm.")]),

 ("PA","The perimeter of a square is 36 cm. The length of one side is:",
   "9 cm",
   C("Side = perimeter ÷ 4 = 36 ÷ 4 = 9 cm.")+
   steps("A square's perimeter is 4 × side","So side = perimeter ÷ 4","= 36 ÷ 4 = 9 cm.")+
   U("Knowing the total border length, you can work back to a square tile's side this way."),
   [("36 cm","36 cm is the whole perimeter, all four sides; one side is 36 ÷ 4 = 9 cm."),
    ("18 cm","18 cm is half the perimeter (two sides); one side is 36 ÷ 4 = 9 cm."),
    ("6 cm","6 cm would give a perimeter of 24, not 36; the side here is 36 ÷ 4 = 9 cm.")]),

 ("PA","A piece of wire 24 cm long is bent to form a square. The length of each side of the square is:",
   "6 cm",
   C("The wire becomes the perimeter, so side = 24 ÷ 4 = 6 cm.")+
   steps("The 24 cm wire is the square's perimeter","A square has 4 equal sides","Side = 24 ÷ 4 = 6 cm.")+
   U("Bending a fixed length of wire into a square is a neat way to see perimeter ÷ 4 in action."),
   [("24 cm","24 cm is the whole wire (the perimeter); one side is 24 ÷ 4 = 6 cm."),
    ("12 cm","12 cm is half the wire (two sides); each side is 24 ÷ 4 = 6 cm."),
    ("96 cm","96 multiplies instead of dividing; each side is 24 ÷ 4 = 6 cm.")]),

 ("PA","A rectangular solar panel is 2 m long and 1 m wide. The area that catches sunlight is:",
   "2 m²",
   C("Area = length × breadth = 2 × 1 = 2 m².")+
   steps("Length = 2 m, breadth = 1 m","Area = 2 × 1","= 2 m².")+
   U("Engineers find a solar panel's sunlight-catching area as length × breadth to estimate its power."),
   [("6 m²","6 m is the PERIMETER, 2 × (2 + 1); the area is 2 × 1 = 2 m²."),
    ("3 m²","3 m is length + breadth once; the area multiplies them: 2 × 1 = 2 m²."),
    ("1 m²","1 m² ignores the 2 m length; the area is 2 × 1 = 2 m².")]),

 ("PA","A rectangular notice board is 1.5 m long and 2 m wide. Its area is:",
   "3 m²",
   C("Area = length × breadth = 1.5 × 2 = 3 m².")+
   steps("Length = 1.5 m, breadth = 2 m","Area = 1.5 × 2","= 3 m².")+
   U("Working out a board's area in square metres tells you how much cloth to cover it with."),
   [("7 m²","7 m is the perimeter, 2 × (1.5 + 2); the area is 1.5 × 2 = 3 m²."),
    ("3.5 m²","3.5 adds 1.5 + 2; the area multiplies them: 1.5 × 2 = 3 m²."),
    ("1.5 m²","That drops the width; the area is 1.5 × 2 = 3 m².")]),

 ("PA","A path runs around the inside edge of a square park of side 20 m. The total distance once around the park is:",
   "80 m",
   C("Distance once around = perimeter of the square = 4 × 20 = 80 m.")+
   steps("Walking once around follows the perimeter","Perimeter of a square = 4 × side","= 4 × 20 = 80 m.")+
   U("A morning walker doing one lap of a 20 m square park covers 80 m."),
   [("400 m","400 m² is the AREA (20 × 20); one lap follows the perimeter, 4 × 20 = 80 m."),
    ("40 m","40 m covers only two sides; one full lap is all four, 4 × 20 = 80 m."),
    ("24 m","24 comes from 20 + 4; the lap is the perimeter, 4 × 20 = 80 m.")]),
]

assert len(MT) == 25 and len(HE) == 25 and len(FD) == 25 and len(PA) == 25

# Interleave so no two consecutive questions share a chapter; Science/Maths alternate.
items = []
for i in range(25):
    items += [MT[i], FD[i], HE[i], PA[i]]
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

    keydist = build_paper(PNUM, TITLE, SHORT, LABELS, items, seed=19431,
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
    split = "/".join(str(counts[c]) for c in ("MT", "FD", "HE", "PA"))
    with open("PAPERS_MANIFEST.md", "a", encoding="utf-8") as fh:
        fh.write(f"| {PNUM} | 2026-06-18 | {TITLE} | {split} | ✓ |\n")

    # ---- update QUESTION_INDEX.json ----
    idx["fingerprints"] = sorted(existing | set(new_fps))
    idx.setdefault("combos", []).append({
        "paper": PNUM,
        "chapters": ["Motion & Time", "Heat",
                     "Fractions & Decimals", "Perimeter & Area"],
    })
    idx["papers"] = idx.get("papers", 0) + 1
    with open(idx_path, "w", encoding="utf-8") as fh:
        json.dump(idx, fh, ensure_ascii=False, indent=2)
        fh.write("\n")

    print("Files:", sorted(v for v in moves.values()))
    print("Answer key spread A/B/C/D =", dict(keydist))
    print("Fingerprints added:", len(new_fps))
