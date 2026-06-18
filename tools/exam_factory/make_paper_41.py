# -*- coding: utf-8 -*-
# Boss Challenge Paper 41 — Motion & Time · Respiration in Organisms ·
# Comparing Quantities · Simple Equations
# Content-only. Uses the dependency-free examfactory engine.
# Difficulty ramp: leans hard into FUSION. A running cheetah's distance over time
# becomes a SPEED; two animals' speeds become a RATIO; a doubled breathing rate
# becomes a PERCENTAGE and a simple EQUATION solved for the resting rate; a
# pendulum's swings become a time period read off an EQUATION; oxygen's share of
# air becomes a PERCENT. The child meets a Science situation and reaches for a
# Maths skill. Class-7 scope, simple wording, hard thinking.
# Produces, under Resources/BossChallengePapers/:
#   Paper_41_<SHORT>_QuestionPaper.html  (pure HTML — questions + options)
#   Paper_41_<SHORT>_QuestionPaper.pdf
#   Paper_41_<SHORT>_Questions.md
#   Paper_41_<SHORT>_Solutions.html
import os, sys, shutil, json, re
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from examfactory import build_paper, C, steps, U

PNUM  = "41"
SHORT = "MotionTime_Respiration_ComparingQuantities_SimpleEquations"
TITLE = ("Motion & Time · Respiration in Organisms · "
         "Comparing Quantities · Simple Equations")
LABELS = {
    "MT": "Motion & Time",
    "RO": "Respiration in Organisms",
    "CQ": "Comparing Quantities",
    "SE": "Simple Equations",
}

# ---------- MOTION & TIME (25) — Science (several fused with Maths) ----------
MT = [
 ("MT","The distance that a moving object covers in each single unit of time is what we call its:",
   "speed",
   C("Speed measures how fast something moves — the ground it covers in one unit of time.")+
   steps("Pick a moving object","see how much distance it covers in one second or one hour","that distance per unit time is its speed.")+
   U("A car's speedometer shows its speed, telling you how many kilometres it covers each hour."),
   [("distance","Distance is the total path covered; speed is that distance shared over the time taken."),
    ("time","Time is how long the journey lasts; speed combines distance with that time."),
    ("weight","Weight is how heavy a body is and has nothing to do with how fast it moves.")]),

 ("MT","The standard SI unit in which the speed of an object is measured is the:",
   "metre per second (m/s)",
   C("Speed is distance divided by time, so its SI unit pairs the metre with the second.")+
   steps("Distance is measured in metres","time is measured in seconds","speed = metres / seconds, so the unit is m/s.")+
   U("Scientists state a sprinter's speed in m/s before converting it to km/h for a headline."),
   [("kilogram","The kilogram measures mass, not how fast a body travels."),
    ("second","The second measures time alone; speed needs distance divided by that time."),
    ("metre","The metre measures distance alone; speed is metres shared over seconds.")]),

 ("MT","A car's speedometer shows how fast it is going, while the total distance it has covered is read from the:",
   "odometer",
   C("The odometer is the dial that keeps adding up every kilometre the vehicle travels.")+
   steps("The speedometer shows the speed right now","a separate dial counts the kilometres covered","that distance-counter is the odometer.")+
   U("A used-car buyer checks the odometer to see how far the car has already been driven."),
   [("speedometer","The speedometer shows the current speed, not the total distance covered."),
    ("thermometer","A thermometer measures temperature, not the distance a car has travelled."),
    ("barometer","A barometer measures air pressure and has nothing to do with distance.")]),

 ("MT","Motion in which an object covers equal distances in equal intervals of time is called:",
   "uniform motion",
   C("When the gaps covered in equal time-slices are always the same, the motion is steady, or uniform.")+
   steps("Watch the distance covered each second","if every second's distance is the same","the motion is uniform.")+
   U("A train cruising steadily on a straight track shows nearly uniform motion."),
   [("non-uniform motion","Non-uniform motion covers unequal distances in equal times, the opposite of uniform."),
    ("circular motion","Circular motion is about moving along a curve; it may still speed up or slow down."),
    ("no motion","Covering equal distances each second means the body is moving, not at rest.")]),

 ("MT","A car that keeps speeding up, slowing down and changing its pace along a busy road is showing:",
   "non-uniform motion",
   C("When the distance covered in equal times keeps changing, the motion is uneven, or non-uniform.")+
   steps("Note the distance covered each second","here the distances keep changing","so the motion is non-uniform.")+
   U("A car in city traffic, stopping and starting at signals, moves with non-uniform motion."),
   [("uniform motion","Uniform motion keeps the same pace; this car keeps changing speed."),
    ("rest","A car that moves at all is not at rest, even if its speed keeps changing."),
    ("steady motion","Steady motion means an unchanging speed; this car's speed keeps changing.")]),

 ("MT","To work out the speed of a moving body you divide the distance travelled by the:",
   "time taken",
   C("Speed tells you distance per unit time, so you share the distance over the time it took.")+
   steps("Measure the distance covered","measure the time the journey took","speed = distance / time.")+
   U("A runner's coach divides the track length by the timing to find the runner's speed."),
   [("weight of the body","A body's weight does not enter the speed formula; you divide distance by time."),
    ("number of wheels","The count of wheels has nothing to do with speed; divide distance by time."),
    ("starting point","The starting point alone gives no speed; you divide distance by the time taken.")]),

 ("MT","A train travels 180 km in 3 hours. Its average speed for the journey is:",
   "60 km/h",
   C("Average speed is the whole distance shared evenly over the whole time taken.")+
   steps("Distance = 180 km, time = 3 h","speed = distance / time = 180 / 3","that gives 60 km/h.")+
   U("A timetable planner uses exactly this to predict when a train will reach the next city."),
   [("540 km/h","540 multiplies distance by time; speed divides distance by time, giving 60."),
    ("183 km/h","183 adds the time to the distance; speed divides them, giving 60 km/h."),
    ("30 km/h","30 would be 180 over 6; here the time is 3 hours, so the speed is 60 km/h.")]),

 ("MT","A cheetah sprints 100 metres in just 4 seconds. Its speed during the sprint is:",
   "25 m/s",
   C("Speed is the distance covered divided by the time it took to cover it.")+
   steps("Distance = 100 m, time = 4 s","speed = 100 / 4","that gives 25 m/s.")+
   U("Wildlife scientists time a cheetah over a measured stretch to find its blistering speed."),
   [("400 m/s","400 multiplies distance by time; speed divides them, giving 25 m/s."),
    ("104 m/s","104 adds time to distance; speed divides distance by time, giving 25 m/s."),
    ("4 m/s","4 is the time in seconds, not the speed; 100 divided by 4 is 25 m/s.")]),

 ("MT","One complete to-and-fro swing of a simple pendulum, from one end across to the other and back, counts as one:",
   "oscillation",
   C("A single full there-and-back swing of the pendulum bob is called one oscillation.")+
   steps("The bob swings out to one side","then back through the middle to the other side and returns","that whole round trip is one oscillation.")+
   U("Counting oscillations is how a pendulum clock measures the steady passing of time."),
   [("metre","A metre measures distance, not a swing of the pendulum bob."),
    ("second","A second is a unit of time; one full swing is an oscillation, which takes some seconds."),
    ("speed","Speed is distance per time; one full there-and-back swing is an oscillation.")]),

 ("MT","The time taken by a simple pendulum to complete one full oscillation is known as its:",
   "time period",
   C("The time period is the steady number of seconds the pendulum needs for one complete swing.")+
   steps("Watch one full to-and-fro swing","measure how many seconds it takes","that time for one oscillation is the time period.")+
   U("Because this time period stays steady, pendulums were used to keep early clocks on time."),
   [("speed","Speed is distance per time; the time for one swing is called the time period."),
    ("distance","Distance is how far the bob moves; the time for one swing is the time period."),
    ("frequency","Frequency counts swings per second; the time for one swing is the time period.")]),

 ("MT","If a simple pendulum makes 20 complete oscillations in 40 seconds, the time period of one oscillation is:",
   "2 seconds",
   C("The time period is the total time shared equally over the number of oscillations.")+
   steps("Total time = 40 s for 20 swings","time period = 40 / 20","that gives 2 seconds per oscillation.")+
   U("Timing many swings and then dividing gives a far more accurate time period than timing one."),
   [("20 seconds","20 is the count of oscillations, not the time for one; 40 / 20 is 2 seconds."),
    ("40 seconds","40 is the total time for all 20 swings; one swing takes 40 / 20 = 2 seconds."),
    ("800 seconds","800 multiplies the two numbers; the time period divides time by swings, giving 2.")]),

 ("MT","On a distance-time graph, an object that stays at rest and does not move at all is shown by a:",
   "horizontal straight line",
   C("If the object is not moving, the distance never changes as time passes, so the line stays flat.")+
   steps("Time keeps increasing along the bottom","but the distance stays the same","so the line runs flat and horizontal.")+
   U("A parked car's distance-time graph is a flat horizontal line, showing it has not moved."),
   [("steep rising line","A rising line means the distance is increasing, so the object is moving, not at rest."),
    ("curved line","A curve shows changing speed; a body at rest gives a flat, horizontal line."),
    ("vertical line","A vertical line would mean distance changing with no time passing, which is impossible.")]),

 ("MT","On a distance-time graph, the uniform motion of an object is shown by a:",
   "straight slanting line",
   C("In uniform motion the distance grows by equal steps in equal times, so the graph is a straight slope.")+
   steps("Equal time intervals add equal distances","plotting these points lines them up straight","so uniform motion gives a straight slanting line.")+
   U("A train moving at a steady speed traces a straight slanting line on its distance-time graph."),
   [("horizontal line","A horizontal line means the object is at rest, not in uniform motion."),
    ("zig-zag line","A zig-zag shows changing, non-uniform motion, not steady uniform motion."),
    ("circle","A distance-time graph of uniform motion is a straight slope, never a closed circle.")]),

 ("MT","Pendulums were once used to run clocks because, for a given pendulum, the time period stays:",
   "constant",
   C("A given pendulum always takes the same time for one swing, and that steadiness makes it a fine timekeeper.")+
   steps("Set a pendulum swinging","each full swing takes the same time as the last","this constant time period keeps the clock regular.")+
   U("Old grandfather clocks kept good time by counting a pendulum's constant swings."),
   [("always increasing","If the time period kept growing, the clock would drift; in fact it stays constant."),
    ("always decreasing","A shrinking time period would speed the clock up; the period actually stays constant."),
    ("random","A random time period could keep no time at all; the pendulum's period is constant.")]),

 ("MT","Among these everyday quantities, the one that is a unit of time is the:",
   "second",
   C("The second is the basic SI unit of time, the building block of minutes and hours.")+
   steps("List the quantity each unit measures","the metre is for length, the kilogram for mass","the second measures time.")+
   U("A stopwatch counts seconds to time how long a race or an experiment takes."),
   [("metre","The metre measures length or distance, not time."),
    ("kilogram","The kilogram measures mass, not the passing of time."),
    ("litre","The litre measures volume of liquid, not time.")]),

 ("MT","A simple pendulum is made of a small heavy ball, the bob, hung from a fixed point by a:",
   "thread (string)",
   C("A simple pendulum is just a bob tied to a thread and hung so it can swing freely.")+
   steps("Take a small heavy bob","tie it to a length of thread","hang the thread from a fixed point so the bob swings.")+
   U("You can build a simple pendulum at home with a stone tied to a piece of string."),
   [("metal rod that cannot bend","A simple pendulum hangs from a flexible thread, not a stiff rod."),
    ("spring","A spring bounces up and down; a simple pendulum swings from a thread."),
    ("rubber tube full of water","A simple pendulum is a bob on a thread, not a tube of water.")]),

 ("MT","Two towns are 240 km apart. A bus that covers the gap in exactly 4 hours travels at an average speed of:",
   "60 km/h",
   C("Average speed shares the whole distance evenly over the whole time of the trip.")+
   steps("Distance = 240 km, time = 4 h","speed = 240 / 4","that gives 60 km/h.")+
   U("A bus company prints expected arrival times worked out from this kind of speed sum."),
   [("960 km/h","960 multiplies distance by time; average speed divides them, giving 60."),
    ("244 km/h","244 adds time to distance; speed divides distance by time, giving 60 km/h."),
    ("40 km/h","40 would be 240 over 6; here the time is 4 hours, so the speed is 60 km/h.")]),

 ("MT","An object moving steadily at 10 m/s will, in 5 seconds, cover a distance of:",
   "50 metres",
   C("Distance is found by multiplying the steady speed by the time for which it moves.")+
   steps("Speed = 10 m/s, time = 5 s","distance = speed x time = 10 x 5","that gives 50 metres.")+
   U("Knowing speed and time lets a driver judge how far the car will roll before stopping."),
   [("2 metres","2 divides time by speed; distance is speed times time, giving 50 metres."),
    ("15 metres","15 adds speed and time; distance multiplies them, giving 50 metres."),
    ("10 metres","10 is the distance covered in just one second; in 5 seconds it is 50 metres.")]),

 ("MT","Since the same time gives a longer distance to a faster body, for a fixed time the distance covered is:",
   "directly proportional to the speed",
   C("Hold the time fixed: double the speed and you double the distance — distance rises in step with speed.")+
   steps("Keep the travel time the same","a faster speed covers more ground in that time","so distance grows directly with speed.")+
   U("In the same hour, a car going twice as fast as a scooter covers twice the distance."),
   [("inversely proportional to the speed","Inverse would mean more speed gives less distance; in fixed time more speed gives more distance."),
    ("not related to the speed","Distance clearly depends on speed; in fixed time a faster body covers more ground."),
    ("always equal to the speed","Distance equals speed times time, not speed alone; for fixed time it grows with speed.")]),

 ("MT","A sundial tells the time of day by using the slowly moving:",
   "shadow of a pointer",
   C("As the Sun crosses the sky, the shadow of the sundial's pointer creeps round to mark the hours.")+
   steps("The Sun moves across the sky through the day","this shifts the pointer's shadow","the shadow's position on the dial shows the time.")+
   U("Before clocks, people read the time from the moving shadow on a sundial."),
   [("swing of a pendulum","A sundial uses a moving shadow; a pendulum belongs to a clock, not a sundial."),
    ("flow of sand","Flowing sand belongs to an hourglass; a sundial uses the Sun's moving shadow."),
    ("drip of water","Dripping water belongs to a water clock; a sundial uses a shadow.")]),

 ("MT","A normal person walking at an easy pace moves at a speed closest to about:",
   "1 metre per second",
   C("A relaxed walking pace is roughly one metre every second — a handy everyday benchmark.")+
   steps("Think of an easy walking stride each second","that covers about one metre","so walking speed is about 1 m/s.")+
   U("This rough figure helps you guess how long it takes to walk a known distance."),
   [("25 metres per second","25 m/s is the sprint of a cheetah, far faster than a person walking."),
    ("100 metres per second","100 m/s is faster than most vehicles, nothing like a walking pace."),
    ("0 metres per second","0 m/s means standing still; a walking person moves at about 1 m/s.")]),

 ("MT","A car's odometer reads 5000 km at the start of a trip and 5300 km at the end. The distance travelled on the trip was:",
   "300 km",
   C("The trip distance is simply the final odometer reading minus the starting reading.")+
   steps("Start reading = 5000 km","end reading = 5300 km","distance = 5300 - 5000 = 300 km.")+
   U("Drivers note the odometer before and after a journey to log exactly how far they went."),
   [("5300 km","5300 is the final reading; the trip distance is the change, 5300 - 5000 = 300 km."),
    ("10300 km","10300 adds the two readings; the distance is their difference, 300 km."),
    ("5000 km","5000 is the starting reading; the distance travelled is the difference, 300 km.")]),

 ("MT","A body that covers 30 m in the first second, another 30 m in the next second and 30 m in the third second is moving with:",
   "uniform speed",
   C("Equal distances covered in equal one-second slices means the speed never changes — it is uniform.")+
   steps("Each second the body covers the same 30 m","equal distances in equal times","so its speed is uniform.")+
   U("A vehicle on cruise control covering the same distance each second moves at uniform speed."),
   [("increasing speed","Increasing speed would cover more each second; here every second is the same 30 m."),
    ("decreasing speed","Decreasing speed would cover less each second; here it is a steady 30 m."),
    ("zero speed","Zero speed means no movement; this body covers 30 m every second.")]),

 ("MT","The hands of an ordinary wall clock move steadily to measure the passing of:",
   "time",
   C("A clock is a machine built to track time, its hands sweeping round to count seconds, minutes and hours.")+
   steps("The clock's gears turn at a steady rate","the hands move round the dial","their position tells us the time.")+
   U("You glance at a clock to know the time and judge whether you are late for school."),
   [("distance","A clock measures time; distance is measured with a scale or odometer."),
    ("temperature","Temperature is read on a thermometer; a clock measures time."),
    ("speed","A clock alone gives time; speed needs distance divided by that time.")]),

 ("MT","Besides metres per second, the speed of vehicles on a road is most commonly stated in:",
   "kilometres per hour (km/h)",
   C("For long road journeys we use a bigger unit, the kilometre per hour, instead of metres per second.")+
   steps("Vehicles cover long distances over long times","metres per second gives awkward big numbers","so we use kilometres per hour, the everyday road unit.")+
   U("A road sign reading 60 means a speed limit of 60 km/h, not metres per second."),
   [("litres per minute","Litres per minute measures liquid flow, not a vehicle's speed."),
    ("kilograms per hour","Kilograms measure mass; road speed is given in kilometres per hour."),
    ("degrees per second","Degrees measure angles or temperature, not the speed of a vehicle.")]),
]

# ---------- RESPIRATION IN ORGANISMS (25) — Science (some fused) ----------
RO = [
 ("RO","Inside every living cell, food is broken down to set free the energy stored in it; this life process is called:",
   "respiration",
   C("Respiration is the life process that unlocks the energy held inside food, inside the cells.")+
   steps("Food carries stored chemical energy","cells break the food down","this releases energy the body can use — that is respiration.")+
   U("The energy that lets you run and think is set free by respiration in your cells."),
   [("digestion","Digestion breaks food into simpler bits; respiration then releases its energy in the cells."),
    ("transpiration","Transpiration is water vapour leaving a plant's leaves, not energy release from food."),
    ("germination","Germination is a seed sprouting, not the release of energy from food in cells.")]),

 ("RO","Breathing means taking air into the body and giving it out; one breath is made of one inhalation and one:",
   "exhalation",
   C("A single breath has two halves: drawing air in (inhalation) and pushing it out (exhalation).")+
   steps("Air is drawn in — that is inhalation","air is then pushed out — that is exhalation","together they make one breath.")+
   U("When you count someone's breaths, each in-and-out pair counts as a single breath."),
   [("digestion","Digestion happens in the gut; the out-breath of a breath is called exhalation."),
    ("circulation","Circulation is blood moving round the body; pushing air out is exhalation."),
    ("respiration","Respiration is energy release in cells; the out-breath itself is exhalation.")]),

 ("RO","During breathing, the gas that our body takes in from the air is:",
   "oxygen",
   C("We breathe in oxygen, the gas our cells need to release energy from food.")+
   steps("Air contains oxygen","we draw it into our lungs when we inhale","the blood carries it to cells for respiration.")+
   U("A patient short of breath may be given extra oxygen to help their cells get enough."),
   [("carbon dioxide","Carbon dioxide is breathed out as a waste, not taken in for respiration."),
    ("nitrogen","Nitrogen makes up most of the air but is not the gas the body uses in respiration."),
    ("hydrogen","Hydrogen is not the breathing gas; the body takes in oxygen from the air.")]),

 ("RO","The gas that the body gives out as a waste product of respiration is:",
   "carbon dioxide",
   C("Respiration leaves behind carbon dioxide, which we breathe out as waste.")+
   steps("Cells use oxygen to release energy from food","this produces carbon dioxide as waste","we breathe that carbon dioxide out.")+
   U("The carbon dioxide you breathe out can turn clear lime water milky in a science test."),
   [("oxygen","Oxygen is taken in for respiration; the waste gas breathed out is carbon dioxide."),
    ("nitrogen","Nitrogen passes in and out unchanged; the waste of respiration is carbon dioxide."),
    ("water vapour","Some water vapour leaves too, but the named waste gas of respiration is carbon dioxide.")]),

 ("RO","Respiration that uses oxygen to break down glucose and release energy is called:",
   "aerobic respiration",
   C("Aerobic respiration needs oxygen; with it, glucose is fully broken down to give plenty of energy.")+
   steps("Oxygen reaches the cells through the blood","it helps break glucose right down","this releases a large amount of energy — aerobic respiration.")+
   U("Most of the time your body uses aerobic respiration, breathing in oxygen to fuel itself."),
   [("anaerobic respiration","Anaerobic respiration happens without oxygen; using oxygen is aerobic respiration."),
    ("transpiration","Transpiration is water loss from leaves, not the oxygen-using release of energy."),
    ("photosynthesis","Photosynthesis makes food using light; aerobic respiration releases energy using oxygen.")]),

 ("RO","A kind of respiration that happens in the complete absence of oxygen is known as:",
   "anaerobic respiration",
   C("Anaerobic respiration releases energy from glucose without any oxygen, giving less energy than aerobic.")+
   steps("Sometimes cells lack enough oxygen","they break glucose down without it","this is anaerobic respiration, releasing less energy.")+
   U("Yeast respires anaerobically in dough, making the gas that lets bread rise."),
   [("aerobic respiration","Aerobic respiration needs oxygen; respiration without oxygen is anaerobic."),
    ("inhalation","Inhalation is breathing air in; respiration without oxygen is called anaerobic."),
    ("digestion","Digestion breaks food in the gut; respiration without oxygen is anaerobic respiration.")]),

 ("RO","During very hard exercise our muscles may respire without enough oxygen, building up a substance that causes cramps, namely:",
   "lactic acid",
   C("Short of oxygen, muscle cells respire anaerobically and make lactic acid, which brings on cramps.")+
   steps("Hard exercise outpaces the oxygen supply","muscles respire anaerobically","this produces lactic acid, causing the aching cramp.")+
   U("The burning ache in your legs after a hard sprint comes from this build-up of lactic acid."),
   [("oxygen","Oxygen is what the muscles run short of; the cramp-causing build-up is lactic acid."),
    ("glucose","Glucose is the fuel being broken down; the product that causes cramps is lactic acid."),
    ("water","Water is a harmless product; the substance that causes muscle cramps is lactic acid.")]),

 ("RO","Yeast respires anaerobically on sugar, producing carbon dioxide and:",
   "alcohol",
   C("Without oxygen, yeast breaks sugar down into alcohol and carbon dioxide — the basis of brewing and baking.")+
   steps("Yeast has plenty of sugar but no oxygen","it respires anaerobically","this yields alcohol and carbon dioxide.")+
   U("Brewers rely on yeast turning sugar into alcohol by this very anaerobic respiration."),
   [("oxygen","Anaerobic respiration happens without oxygen; yeast produces alcohol and carbon dioxide."),
    ("lactic acid","Our muscles make lactic acid; yeast instead makes alcohol with the carbon dioxide."),
    ("water","Yeast's anaerobic respiration mainly gives alcohol and carbon dioxide, not water.")]),

 ("RO","How many full breaths a person takes during one whole minute is measured as the:",
   "breathing rate",
   C("Breathing rate counts the full breaths — each in-and-out — taken in one minute.")+
   steps("Count each in-and-out as one breath","count how many happen in sixty seconds","that count is the breathing rate.")+
   U("A doctor measures your breathing rate to check whether you are breathing normally."),
   [("heart rate","Heart rate counts heartbeats per minute; breaths per minute is the breathing rate."),
    ("pulse","The pulse is the throb of an artery with each heartbeat, not the count of breaths."),
    ("time period","Time period is the time for one pendulum swing, not the count of breaths per minute.")]),

 ("RO","An adult human at rest breathes on average about how many times per minute?",
   "15 to 18 times",
   C("At rest a healthy adult takes roughly 15 to 18 breaths each minute.")+
   steps("Sit quietly and count the breaths in a minute","a resting adult takes about 15 to 18","that is the normal resting breathing rate.")+
   U("A nurse compares your resting breaths against this 15-to-18 range during a check-up."),
   [("1 to 2 times","Just one or two breaths a minute would be dangerously slow; the normal rate is 15 to 18."),
    ("60 to 70 times","60 to 70 breaths a minute is far too fast for rest; the normal range is 15 to 18."),
    ("120 to 150 times","120 to 150 a minute is impossibly fast; a resting adult breathes about 15 to 18 times.")]),

 ("RO","The dome-shaped sheet of muscle below the lungs that helps in breathing is the:",
   "diaphragm",
   C("The diaphragm is a muscular dome under the lungs; its movement draws air in and pushes it out.")+
   steps("The diaphragm sits below the lungs","it flattens to pull air in","it domes up again to push air out — driving breathing.")+
   U("A sudden spasm of the diaphragm is what gives you a bout of hiccups."),
   [("windpipe","The windpipe is the tube carrying air to the lungs, not the dome of muscle below them."),
    ("heart","The heart pumps blood; the breathing muscle below the lungs is the diaphragm."),
    ("rib","Ribs form the cage around the lungs; the dome of muscle beneath them is the diaphragm.")]),

 ("RO","Air on its way to the lungs passes down the windpipe, which is also called the:",
   "trachea",
   C("The windpipe, or trachea, is the tube that carries air from the throat down towards the lungs.")+
   steps("Air enters through the nose or mouth","it travels down the windpipe","this tube, the trachea, leads it to the lungs.")+
   U("Food 'going down the wrong pipe' means it slipped towards the trachea, making you cough."),
   [("oesophagus","The oesophagus carries food to the stomach; air goes down the trachea, the windpipe."),
    ("artery","An artery carries blood, not air; the air tube to the lungs is the trachea."),
    ("diaphragm","The diaphragm is the breathing muscle; the air tube is the trachea, the windpipe.")]),

 ("RO","Fish breathe by taking in the oxygen dissolved in water using their:",
   "gills",
   C("Gills are feathery organs that pull dissolved oxygen out of the water as it flows over them.")+
   steps("Water holds dissolved oxygen","the fish passes water over its gills","the gills absorb that oxygen into the blood.")+
   U("A fish out of water gasps because its gills cannot take oxygen from the air."),
   [("lungs","Lungs breathe air; fish use gills to take dissolved oxygen from the water."),
    ("skin","A few animals breathe through skin, but fish chiefly use their gills in water."),
    ("stomata","Stomata are tiny pores on plant leaves, not the breathing organs of fish.")]),

 ("RO","Lacking both lungs and gills, an earthworm takes in oxygen through its damp:",
   "skin",
   C("The earthworm takes in oxygen straight through its damp skin, so it needs no lungs.")+
   steps("The earthworm's skin stays moist","oxygen dissolves in that moisture","it passes through the skin into the blood.")+
   U("Earthworms come up after rain because waterlogged soil leaves too little air for their skin."),
   [("gills","Gills are for water-breathing fish; an earthworm breathes through its moist skin."),
    ("lungs","An earthworm has no lungs; it takes in oxygen through its damp skin."),
    ("spiracles","Spiracles are the breathing holes of insects; an earthworm breathes through its skin.")]),

 ("RO","Insects such as grasshoppers take in air through tiny holes along the sides of the body called:",
   "spiracles",
   C("Spiracles are small openings on an insect's body that let air pass into tiny breathing tubes inside.")+
   steps("An insect's body has small side openings","air enters through these spiracles","tubes inside carry the air to the cells.")+
   U("Tiny spiracles are why insects can breathe without any lungs at all."),
   [("gills","Gills are for fish in water; insects breathe through openings called spiracles."),
    ("stomata","Stomata are pores on plant leaves; the breathing holes of insects are spiracles."),
    ("nostrils","Insects have no nostrils like ours; they take in air through spiracles.")]),

 ("RO","In a green plant, gases for respiration pass in and out through tiny pores on the leaves called:",
   "stomata",
   C("Stomata are minute pores, mostly on the underside of leaves, through which gases move in and out.")+
   steps("A leaf has tiny pores called stomata","oxygen and carbon dioxide pass through them","so the leaf exchanges gases for respiration.")+
   U("The same stomata that let gases move also let water vapour escape in transpiration."),
   [("spiracles","Spiracles are an insect's breathing holes; a leaf's gas pores are called stomata."),
    ("gills","Gills belong to fish; a leaf exchanges gases through pores called stomata."),
    ("veins","Leaf veins carry water and food; the gas pores of the leaf are the stomata.")]),

 ("RO","The carbon dioxide we breathe out can be detected because, when bubbled through it, lime water turns:",
   "milky",
   C("Carbon dioxide reacts with clear lime water to form a fine white solid, turning it milky.")+
   steps("Breathe out through a straw into clear lime water","the carbon dioxide reacts with it","the lime water clouds and turns milky.")+
   U("This milky-lime-water test is the classic way to show that breath contains carbon dioxide."),
   [("bright red","Lime water does not turn red with carbon dioxide; it turns milky white."),
    ("deep blue","Carbon dioxide does not turn lime water blue; it turns it milky."),
    ("colourless and clear","Lime water starts clear; carbon dioxide makes it milky, not clearer.")]),

 ("RO","When we inhale, the diaphragm contracts and moves down, so the space inside the chest cavity:",
   "increases",
   C("As the diaphragm flattens downward, the chest makes more room, and air rushes in to fill the lungs.")+
   steps("The diaphragm contracts and flattens down","the chest cavity gets larger","the bigger space pulls air into the lungs.")+
   U("Take a deep breath and feel your chest expand as the diaphragm pulls down."),
   [("decreases","The chest space shrinks when we breathe out, not in; on inhaling it increases."),
    ("stays exactly the same","If the chest never changed size, no air would move; on inhaling it increases."),
    ("fills with blood","The chest cavity makes room for air, not blood; the space increases as we inhale.")]),

 ("RO","Respiration matters to every living cell chiefly because the process releases:",
   "energy",
   C("The whole point of respiration is to free the energy locked in food so the body can use it.")+
   steps("Food holds stored chemical energy","respiration breaks the food down","this releases energy for movement, growth and warmth.")+
   U("Even while you sleep, respiration keeps releasing the energy your body needs to stay alive."),
   [("light","Respiration does not make light; it releases energy from food for the body to use."),
    ("sound","Respiration releases usable energy, not sound."),
    ("soil","Soil is unrelated to respiration; the process releases energy from food in the cells.")]),

 ("RO","The roots of a plant also respire, taking in oxygen from the air that is present in the:",
   "spaces between soil particles",
   C("Soil is not solid through and through — air fills the gaps between its particles, and roots use that oxygen.")+
   steps("Soil grains leave tiny air-filled gaps","oxygen sits in these spaces","root cells take it in to respire.")+
   U("Waterlogged soil drowns roots because water fills the air spaces they breathe from."),
   [("green leaves at the top","Leaves are far above; roots take in oxygen from air in the soil spaces around them."),
    ("flowers of the plant","Flowers do not supply oxygen to the roots; roots use air in the soil spaces."),
    ("deep rock below the soil","Solid rock holds no breathing air; roots use the oxygen in the soil's air spaces.")]),

 ("RO","When you start to exercise hard, your breathing rate:",
   "increases",
   C("Hard work makes muscles demand more oxygen, so you breathe faster to supply it.")+
   steps("Exercising muscles need more energy","that needs more oxygen and more respiration","so the breathing rate goes up.")+
   U("You pant after a sprint because your breathing rate has shot up to meet the demand."),
   [("decreases","Exercise raises the need for oxygen, so breathing speeds up, not slows down."),
    ("stops completely","Breathing never stops during exercise; in fact it gets faster."),
    ("stays exactly the same","Hard exercise needs more oxygen, so the breathing rate rises, not stays put.")]),

 ("RO","A person's breathing rate rose from 18 breaths a minute at rest to 36 after running. It became:",
   "two times the resting rate",
   C("Comparing 36 with 18 by division shows the new rate is exactly double the resting one.")+
   steps("Resting rate = 18, new rate = 36","divide: 36 / 18 = 2","so the rate became 2 times, that is double, the resting rate.")+
   U("Doctors compare exercise and resting rates this way to see how hard the body is working."),
   [("half the resting rate","36 is more than 18, so the rate grew, not halved; it became 2 times as fast."),
    ("the same as the resting rate","36 is not equal to 18; the new rate is double the resting rate."),
    ("eighteen times the resting rate","36 is only double 18, not eighteen times it; the rate became 2 times.")]),

 ("RO","A person breathes 18 times each minute. At the same steady rate, the number of breaths in 5 minutes is:",
   "90 breaths",
   C("Multiply the breaths-per-minute by the number of minutes to get the total.")+
   steps("Rate = 18 breaths per minute","time = 5 minutes","total = 18 x 5 = 90 breaths.")+
   U("Working out breaths over several minutes helps estimate how much air the lungs move."),
   [("23 breaths","23 adds 18 and 5; you multiply them, getting 18 x 5 = 90 breaths."),
    ("13 breaths","13 subtracts 5 from 18; you multiply them, getting 90 breaths."),
    ("18 breaths","18 is the breaths in just one minute; in 5 minutes it is 18 x 5 = 90.")]),

 ("RO","Inside the lungs, the actual exchange of gases happens across millions of tiny balloon-like air sacs called:",
   "alveoli",
   C("Alveoli are the lungs' tiny air sacs; their huge combined surface lets oxygen and carbon dioxide swap quickly.")+
   steps("Air reaches the deep ends of the lungs","there it fills millions of tiny sacs, the alveoli","oxygen and carbon dioxide are exchanged across their thin walls.")+
   U("The alveoli give your lungs a surface big enough to soak up all the oxygen you need."),
   [("spiracles","Spiracles are an insect's breathing holes, not the air sacs inside human lungs."),
    ("stomata","Stomata are pores on plant leaves; the lung's air sacs are the alveoli."),
    ("nostrils","Nostrils are the openings of the nose; gas exchange happens in the alveoli.")]),

 ("RO","Compared with aerobic respiration, the anaerobic respiration in our muscles during a sudden burst of activity releases:",
   "a smaller amount of energy",
   C("Without oxygen, glucose is only partly broken down, so anaerobic respiration yields far less energy.")+
   steps("Aerobic respiration fully breaks glucose with oxygen, giving lots of energy","anaerobic respiration lacks oxygen","so it breaks glucose only partly, releasing less energy.")+
   U("This is why you cannot sprint flat-out for long — anaerobic respiration gives too little energy."),
   [("a larger amount of energy","Without oxygen, glucose is only partly used, so anaerobic respiration gives less, not more, energy."),
    ("exactly the same energy","Aerobic respiration gives much more energy; anaerobic respiration gives less."),
    ("no energy at all","Anaerobic respiration does release some energy — just less than aerobic respiration.")]),
]

# ---------- COMPARING QUANTITIES (25) — Maths (many fused with Science) ----------
CQ = [
 ("CQ","A comparison of two quantities of the same kind, made by dividing one by the other, is called a:",
   "ratio",
   C("A ratio compares two like quantities by division, telling you how many times one is of the other.")+
   steps("Take two quantities of the same kind","divide one by the other","that comparison is their ratio.")+
   U("Mixing 2 cups of water with 1 cup of squash uses a ratio of 2 to 1."),
   [("sum","A sum adds quantities together; a ratio compares them by division."),
    ("product","A product multiplies quantities; a ratio compares them by division."),
    ("difference","A difference subtracts one from the other; a ratio compares them by dividing.")]),

 ("CQ","The ratio 2 : 5, when written as a fraction, is:",
   "2/5",
   C("A ratio a : b is just another way of writing the fraction a over b.")+
   steps("Take the ratio 2 : 5","write the first number on top, the second below","that gives the fraction 2/5.")+
   U("Saying 2 girls to every 5 children is the same as the fraction 2/5 of the children being girls."),
   [("5/2","5/2 flips the ratio; 2 : 5 means 2 on top of 5, that is 2/5."),
    ("2/7","2/7 would add the parts to make 7; the ratio 2 : 5 written as a fraction is 2/5."),
    ("7/2","7/2 has nothing to do with 2 : 5, which as a fraction is 2/5.")]),

 ("CQ","The phrase 'per cent' means out of every:",
   "hundred",
   C("Per cent means 'for each hundred', so a percentage is a count out of 100.")+
   steps("Take the words 'per cent'","they mean 'per hundred'","so 7 per cent means 7 out of every 100.")+
   U("Saying air is 21 per cent oxygen means 21 parts of every 100 parts are oxygen."),
   [("ten","Per cent means out of a hundred, not out of ten."),
    ("thousand","Per cent means out of a hundred; out of a thousand would be 'per mille'."),
    ("fifty","Per cent always compares with a hundred, not fifty.")]),

 ("CQ","To change a fraction into a percentage, you multiply the fraction by:",
   "100",
   C("Multiplying a fraction by 100 (and adding the % sign) restates it as a count out of a hundred.")+
   steps("Take the fraction","multiply it by 100","attach the % sign to get the percentage.")+
   U("To say what percentage of a test you scored, you multiply your fraction of marks by 100."),
   [("10","Multiplying by 10 gives only a tenth of the percentage; you multiply a fraction by 100."),
    ("2","Multiplying by 2 just doubles the fraction; to get a percentage you multiply by 100."),
    ("1000","Multiplying by 1000 overshoots; a fraction becomes a percentage by multiplying by 100.")]),

 ("CQ","Expressed as a percentage, one quarter — that is the fraction 1/4 — comes to:",
   "25%",
   C("One quarter is 25 parts out of every 100, so 1/4 equals 25%.")+
   steps("Take 1/4","multiply by 100: (1/4) x 100 = 25","so 1/4 = 25%.")+
   U("Scoring 1/4 of the marks on a test is the same as scoring 25%."),
   [("4%","4% is far smaller than a quarter; 1/4 multiplied by 100 is 25%."),
    ("14%","14% does not equal a quarter; 1/4 is 25%."),
    ("75%","75% is three quarters, not one quarter; 1/4 equals 25%.")]),

 ("CQ","Fifty per cent (50%) of any quantity is the same as the fraction:",
   "1/2",
   C("Fifty out of a hundred simplifies to one half, so 50% is just 1/2.")+
   steps("50% means 50/100","simplify 50/100 by dividing top and bottom by 50","that gives 1/2.")+
   U("Getting 50% off a price means paying half, that is 1/2, of the original cost."),
   [("1/4","1/4 is 25%, not 50%; fifty per cent equals one half."),
    ("1/5","1/5 is 20%, not 50%; fifty per cent is one half."),
    ("5/1","5/1 is the whole number 5, far more than a half; 50% is 1/2.")]),

 ("CQ","About 1 part in every 5 of the air we breathe is oxygen. Written as a percentage, this share of oxygen is:",
   "20%",
   C("One part out of five is the fraction 1/5, which equals 20 parts out of a hundred.")+
   steps("1 in 5 is the fraction 1/5","multiply by 100: (1/5) x 100 = 20","so the oxygen share is about 20%.")+
   U("This is close to the real figure — air is roughly 21% oxygen by this kind of reckoning."),
   [("5%","5% would be 1 in 20, not 1 in 5; one fifth is 20%."),
    ("15%","15% does not match 1 in 5; the fraction 1/5 equals 20%."),
    ("50%","50% is 1 in 2, far more than 1 in 5; one fifth is 20%.")]),

 ("CQ","When two ratios are equal to each other, the four quantities are said to be in:",
   "proportion",
   C("If one ratio equals another, the numbers form a proportion — they keep the same relationship.")+
   steps("Take two ratios, such as 2 : 3 and 4 : 6","check that they are equal","when they are, the quantities are in proportion.")+
   U("A recipe scaled up keeps its ingredients in proportion so the taste stays the same."),
   [("percentage","A percentage is a count out of a hundred; two equal ratios form a proportion."),
    ("difference","A difference is found by subtracting; equal ratios form a proportion."),
    ("average","An average is a central value; two equal ratios are said to be in proportion.")]),

 ("CQ","If 2 : 3 = 4 : x, then the value of x is:",
   "6",
   C("Equal ratios stay equal when both numbers are scaled the same way; here everything doubles.")+
   steps("2 : 3 = 4 : x means 2/3 = 4/x","the left numbers doubled (2 to 4), so the right must double too","3 doubles to 6, so x = 6.")+
   U("Doubling a recipe keeps the proportion: twice the first part needs twice the second."),
   [("5","If x were 5 the ratios would not match; doubling 3 gives 6, so x = 6."),
    ("7","7 does not keep the ratio equal; the matching value is 6."),
    ("12","12 would triple 3 while 2 only doubled to 4; to match, x = 6.")]),

 ("CQ","A cheetah runs at 30 m/s and a horse at 15 m/s. The ratio of the cheetah's speed to the horse's speed is:",
   "2 : 1",
   C("A ratio compares the two speeds by division, and 30 compared with 15 is two to one.")+
   steps("Write the ratio 30 : 15","divide both by their common factor 15","that simplifies to 2 : 1.")+
   U("Saying the cheetah is 'twice as fast' is exactly this 2 : 1 ratio of their speeds."),
   [("1 : 2","1 : 2 says the cheetah is slower; in fact 30 to 15 simplifies to 2 : 1."),
    ("15 : 30","15 : 30 is the horse-to-cheetah order and is not in lowest terms; cheetah to horse is 2 : 1."),
    ("3 : 1","3 : 1 would need speeds like 45 and 15; here 30 to 15 is 2 : 1.")]),

 ("CQ","In a class, 25 students out of 100 chose science as their favourite subject. The percentage who chose science is:",
   "25%",
   C("A count out of a hundred is already a percentage, so 25 out of 100 is simply 25%.")+
   steps("25 out of 100 is the fraction 25/100","this means 25 per hundred","so 25% chose science.")+
   U("Survey results are reported as percentages exactly like this, out of every hundred people."),
   [("75%","75% would be the share who did not choose science; 25 of 100 chose it, so 25%."),
    ("100%","100% would mean everyone chose science; only 25 of 100 did, so 25%."),
    ("2.5%","2.5% is ten times too small; 25 out of 100 is 25%.")]),

 ("CQ","Thirty per cent (30%) of 200 is:",
   "60",
   C("Finding a percentage of a number means multiplying the number by that fraction out of a hundred.")+
   steps("30% means 30/100","multiply: (30/100) x 200","that gives 60.")+
   U("A 30% discount on a Rs 200 item knocks off Rs 60 from the price."),
   [("30","30 is the percentage figure, not 30% of 200, which works out to 60."),
    ("200","200 is the whole amount; 30% of it is 60, not the whole 200."),
    ("170","170 is what is left after taking 30% away; 30% of 200 itself is 60.")]),

 ("CQ","An item bought for Rs 80 and sold for Rs 100 gives a profit of:",
   "Rs 20",
   C("Profit is how much more you sold for than you paid — the selling price minus the cost price.")+
   steps("Cost price = Rs 80, selling price = Rs 100","profit = selling price - cost price = 100 - 80","that gives Rs 20.")+
   U("A shopkeeper works out daily profit by subtracting what goods cost from what they sold for."),
   [("Rs 180","Rs 180 adds the two prices; profit is their difference, Rs 100 - Rs 80 = Rs 20."),
    ("Rs 100","Rs 100 is the selling price, not the profit; the profit is 100 - 80 = Rs 20."),
    ("Rs 80","Rs 80 is the cost price, not the profit; the profit is 100 - 80 = Rs 20.")]),

 ("CQ","A trader makes a profit only when the selling price of an item is:",
   "greater than the cost price",
   C("Profit appears when you sell for more than you paid; the selling price tops the cost price.")+
   steps("Compare selling price with cost price","if selling price is higher","the extra is profit.")+
   U("A shop sets prices above cost so that each sale brings in some profit."),
   [("less than the cost price","Selling for less than cost gives a loss, not a profit."),
    ("equal to the cost price","Selling at exactly the cost price gives neither profit nor loss."),
    ("zero","A selling price of zero means giving it away — a complete loss, not a profit.")]),

 ("CQ","A shopkeeper buys a fan for Rs 500 and sells it for Rs 450. This sale results in a:",
   "loss of Rs 50",
   C("Selling below cost means a loss, found by subtracting the selling price from the cost price.")+
   steps("Cost price = Rs 500, selling price = Rs 450","selling price is lower, so it is a loss","loss = 500 - 450 = Rs 50.")+
   U("A shop clearing old stock cheaply may take a small loss like this on each item."),
   [("profit of Rs 50","Selling for less than cost is a loss, not a profit; here it is a Rs 50 loss."),
    ("loss of Rs 950","Rs 950 adds the prices; the loss is their difference, 500 - 450 = Rs 50."),
    ("no profit and no loss","The two prices differ by Rs 50, so there is a loss, not a break-even.")]),

 ("CQ","The simple interest on a sum of money depends on the principal, the rate, and the:",
   "time",
   C("Simple interest grows with how big the sum is, the rate charged, and how long it is lent or borrowed.")+
   steps("More principal earns more interest","a higher rate earns more","and a longer time earns more — so time matters too.")+
   U("A bank works out your interest from the amount, the rate, and the number of years saved."),
   [("weight of the coins","The physical weight of money is irrelevant; interest depends on principal, rate and time."),
    ("colour of the notes","The colour of currency notes has nothing to do with interest."),
    ("number of customers","Interest on one account depends on its principal, rate and time, not the customer count.")]),

 ("CQ","The simple interest on Rs 1000 at 10% per year, for one year, is:",
   "Rs 100",
   C("Ten per cent of the sum, for one year, is simply a tenth of Rs 1000.")+
   steps("10% of 1000 = (10/100) x 1000 = 100","this is for one year","so the interest is Rs 100.")+
   U("Saving Rs 1000 at 10% a year earns you Rs 100 of interest in that year."),
   [("Rs 10","Rs 10 is 1% of 1000; at 10% the one-year interest is Rs 100."),
    ("Rs 1000","Rs 1000 is the principal itself; the interest on it at 10% for a year is Rs 100."),
    ("Rs 1100","Rs 1100 is the total to be returned; the interest alone is Rs 100.")]),

 ("CQ","Air breathed out has about 16% oxygen, while air breathed in has about 21%. The drop in the oxygen percentage is about:",
   "5%",
   C("The body keeps some oxygen, so the breathed-out percentage is lower by the simple difference.")+
   steps("Breathed in = 21%, breathed out = 16%","drop = 21% - 16%","that gives a 5% drop.")+
   U("This 5% drop is the oxygen your cells took out of the air for respiration."),
   [("37%","37% adds the two figures; the drop is their difference, 21% - 16% = 5%."),
    ("16%","16% is the breathed-out figure itself, not the drop, which is 21 - 16 = 5%."),
    ("21%","21% is the breathed-in figure, not the drop; the fall is 5%.")]),

 ("CQ","One pendulum has a time period of 2 seconds and another of 1 second. The ratio of their time periods is:",
   "2 : 1",
   C("A ratio compares the two times by division, and 2 seconds to 1 second is two to one.")+
   steps("Write the ratio 2 : 1","2 and 1 share no common factor above 1","so the ratio is already 2 : 1.")+
   U("A longer pendulum swinging slower keeps a time period in simple ratios like this."),
   [("1 : 2","1 : 2 reverses the order; the first period of 2 s to the second of 1 s is 2 : 1."),
    ("2 : 2","2 : 2 would mean equal periods; here they differ, giving 2 : 1."),
    ("3 : 1","3 : 1 would need periods of 3 s and 1 s; 2 s to 1 s is 2 : 1.")]),

 ("CQ","Convert the decimal 0.6 into a percentage; it becomes:",
   "60%",
   C("To turn a decimal into a percentage you multiply by 100, so 0.6 becomes 60.")+
   steps("Take 0.6","multiply by 100: 0.6 x 100 = 60","attach the % sign to get 60%.")+
   U("If 0.6 of a class passed, that is the same as saying 60% passed."),
   [("6%","6% is ten times too small; 0.6 multiplied by 100 is 60%."),
    ("0.6%","0.6% is a hundred times too small; 0.6 as a percentage is 60%."),
    ("600%","600% is ten times too big; 0.6 equals 60%.")]),

 ("CQ","Out of 50 fish in a tank, 10 died. The percentage of the fish that died is:",
   "20%",
   C("Turn the fraction that died into a count out of a hundred to get the percentage.")+
   steps("Fraction that died = 10/50","multiply by 100: (10/50) x 100 = 20","so 20% died.")+
   U("An aquarium keeper reports losses as a percentage to judge how serious they are."),
   [("10%","10 is the number that died, but as a share of 50 it is 10/50 = 20%, not 10%."),
    ("40%","40% would mean 20 of the 50 died; only 10 died, which is 20%."),
    ("50%","50% would be half the fish; only 10 of 50 died, which is 20%.")]),

 ("CQ","The price of an item rises from Rs 100 to Rs 120. The percentage increase in the price is:",
   "20%",
   C("Percentage increase compares the rise with the original price, as a count out of a hundred.")+
   steps("Rise = 120 - 100 = Rs 20","compare with the original 100: 20/100","that is 20%.")+
   U("Shops and newspapers describe price changes as a percentage increase exactly this way."),
   [("120%","120% is the new price as a share of the old; the increase alone is 20%."),
    ("20","20 is the rise in rupees, not the percentage; as a share of 100 it is 20%."),
    ("80%","80% does not match a rise from 100 to 120; the increase is 20%.")]),

 ("CQ","Before two quantities can be compared as a ratio, they must first be expressed in the:",
   "same unit",
   C("A ratio only makes sense when both quantities are measured in the same unit, so they compare fairly.")+
   steps("You cannot compare metres directly with centimetres","first change both to the same unit","then write their ratio.")+
   U("To compare 1 m with 50 cm, you first make both centimetres: 100 cm to 50 cm, that is 2 : 1."),
   [("different units","Different units would make the comparison meaningless; a ratio needs the same unit."),
    ("percentage form","A ratio does not need percentages; it needs both quantities in the same unit."),
    ("decimal form","Decimals are not required; what matters is that both quantities share the same unit.")]),

 ("CQ","A class has boys and girls in the ratio 3 : 2. The fraction of the class that are boys is:",
   "3/5",
   C("The two parts make 5 in all, and boys are 3 of those 5 parts.")+
   steps("Boys : girls = 3 : 2, so total parts = 3 + 2 = 5","boys are 3 of these 5 parts","so the fraction of boys is 3/5.")+
   U("Knowing the boy-girl ratio lets a teacher quickly find what fraction of the class are boys."),
   [("3/2","3/2 is the boys-to-girls ratio, not the fraction of the whole; boys are 3 of 5, that is 3/5."),
    ("2/5","2/5 is the fraction that are girls; the boys are 3 of 5 parts, that is 3/5."),
    ("3/3","3/3 equals 1, the whole class; the boys alone are 3 of 5 parts, that is 3/5.")]),

 ("CQ","Twelve out of every hundred apples in a crate were found to be rotten. The percentage of rotten apples was:",
   "12%",
   C("A count out of a hundred is already a percentage, so 12 out of 100 is simply 12%.")+
   steps("12 out of 100 is the fraction 12/100","this means 12 per hundred","so 12% of the apples were rotten.")+
   U("A grocer reports spoilage as a percentage to judge how much of the stock was lost."),
   [("88%","88% is the share that were good; the rotten apples were 12 out of 100, that is 12%."),
    ("12","12 is the count of rotten apples; as a share of 100 it is the percentage 12%."),
    ("1.2%","1.2% is ten times too small; 12 out of 100 is 12%.")]),
]

# ---------- SIMPLE EQUATIONS (25) — Maths (several fused with Science) ----------
SE = [
 ("SE","A statement that two expressions are equal and that contains an unknown to be found is called an:",
   "equation",
   C("An equation is a balanced statement, with an equals sign, holding an unknown we want to find.")+
   steps("Write two expressions joined by an equals sign","let one contain an unknown letter","that balanced statement is an equation.")+
   U("Turning a word problem into an equation is the first step to solving it neatly."),
   [("average","An average is a single central value, not a balanced statement with an unknown."),
    ("ratio","A ratio compares two quantities; an equation sets two expressions equal."),
    ("graph","A graph is a picture of data; a statement of equality with an unknown is an equation.")]),

 ("SE","In the equation x + 5 = 12, the letter standing for the value we must find is called the:",
   "variable (the unknown)",
   C("The letter x is the variable — the unknown quantity the equation lets us solve for.")+
   steps("Look at the equation x + 5 = 12","the letter x has an unknown value","that letter is the variable, the unknown.")+
   U("Using a letter for an unknown is how algebra lets you solve real problems."),
   [("equals sign","The equals sign shows the two sides balance; the unknown letter is the variable."),
    ("constant","A constant is a fixed number like 5 or 12; the unknown letter x is the variable."),
    ("answer","The answer is the value you find at the end; the unknown letter itself is the variable.")]),

 ("SE","Find the value of the unknown in the equation x + 5 = 12. It is x =:",
   "7",
   C("Take 5 away from both sides to leave x by itself, and the right side becomes 7.")+
   steps("Start with x + 5 = 12","subtract 5 from both sides","x = 12 - 5 = 7.")+
   U("Working out an unknown like this is how you find a missing number in a puzzle."),
   [("17","17 adds 5 to 12; to undo '+5' you subtract, giving x = 7."),
    ("60","60 multiplies 5 and 12; the equation is solved by subtracting, giving x = 7."),
    ("5","5 is the number added to x, not its value; solving gives x = 7.")]),

 ("SE","To solve the equation x - 3 = 10, you add 3 to both sides, which gives x equal to:",
   "13",
   C("Adding 3 to both sides cancels the '-3' on the left and leaves x equal to 10 + 3.")+
   steps("Start with x - 3 = 10","add 3 to both sides","x = 10 + 3 = 13.")+
   U("Undoing a subtraction by adding the same amount is a basic step in solving equations."),
   [("7","7 subtracts 3 from 10; here you add 3 to undo '-3', giving x = 13."),
    ("30","30 multiplies 3 and 10; the equation is solved by adding, giving x = 13."),
    ("10","10 is the right-hand side, not x; adding 3 to both sides gives x = 13.")]),

 ("SE","The equation 2x = 14 is solved by dividing both sides by 2, which gives x equal to:",
   "7",
   C("Dividing both sides by 2 undoes the 'times 2' on the left, leaving x equal to 14 / 2.")+
   steps("Start with 2x = 14","divide both sides by 2","x = 14 / 2 = 7.")+
   U("Splitting a total equally is exactly this kind of dividing to find one share."),
   [("28","28 multiplies 14 by 2; to undo 'times 2' you divide, giving x = 7."),
    ("16","16 adds 2 to 14; the equation is solved by dividing, giving x = 7."),
    ("12","12 subtracts 2 from 14; the equation needs dividing by 2, giving x = 7.")]),

 ("SE","Solving x/4 = 5 by multiplying both sides by 4 gives x equal to:",
   "20",
   C("Multiplying both sides by 4 undoes the 'divide by 4' on the left, giving x equal to 5 x 4.")+
   steps("Start with x/4 = 5","multiply both sides by 4","x = 5 x 4 = 20.")+
   U("If one quarter of a number is 5, the whole number is four times that, namely 20."),
   [("9","9 adds 4 and 5; to undo 'divide by 4' you multiply, giving x = 20."),
    ("1.25","1.25 divides 5 by 4; here you multiply by 4 to undo the division, giving x = 20."),
    ("5","5 is one quarter of x, not x itself; multiplying by 4 gives x = 20.")]),

 ("SE","Moving a term from one side of an equation to the other while changing its sign is called:",
   "transposition",
   C("Transposition is the shortcut of shifting a term across the equals sign and flipping its sign.")+
   steps("Take a term on one side","move it to the other side","change its sign as it crosses — that is transposition.")+
   U("Transposing terms quickly tidies an equation so the unknown stands alone."),
   [("multiplication","Multiplication scales a quantity; moving a term across with a sign change is transposition."),
    ("rounding","Rounding adjusts a number to a near value; shifting a term across is transposition."),
    ("estimation","Estimation makes a rough guess; moving a term and flipping its sign is transposition.")]),

 ("SE","The particular value of the unknown that makes an equation true is called its:",
   "solution",
   C("The solution is the value which, put in place of the unknown, makes both sides equal.")+
   steps("Try a value for the unknown","check if both sides come out equal","the value that works is the solution.")+
   U("Checking your answer by putting it back into the equation confirms it is the solution."),
   [("variable","The variable is the unknown letter; the value that makes the equation true is its solution."),
    ("coefficient","A coefficient is the number multiplying the unknown; the true value is the solution."),
    ("constant","A constant is a fixed number in the equation; the value that satisfies it is the solution.")]),

 ("SE","A car moving at speed x km/h covers 100 km in 2 hours, giving 2x = 100. Solving this, x equals:",
   "50",
   C("Dividing both sides by 2 undoes the 'times 2', giving the speed as 100 / 2.")+
   steps("Distance = speed x time gives 2x = 100","divide both sides by 2","x = 100 / 2 = 50 km/h.")+
   U("This is how you read a journey's distance and time and work back to the speed."),
   [("200","200 multiplies 100 by 2; to undo 'times 2' you divide, giving x = 50."),
    ("102","102 adds 2 to 100; the equation is solved by dividing, giving x = 50."),
    ("98","98 subtracts 2 from 100; you divide by 2 instead, giving x = 50.")]),

 ("SE","If a number doubled equals 18, the equation is 2n = 18, and the number n is:",
   "9",
   C("Dividing both sides by 2 undoes the doubling, leaving n equal to 18 / 2.")+
   steps("Doubled means 2n, so 2n = 18","divide both sides by 2","n = 18 / 2 = 9.")+
   U("Working backwards from a doubled total to the original number uses this simple equation."),
   [("36","36 doubles 18 again; to undo the doubling you halve it, giving n = 9."),
    ("20","20 adds 2 to 18; the equation is solved by dividing by 2, giving n = 9."),
    ("16","16 subtracts 2 from 18; the doubling is undone by dividing, giving n = 9.")]),

 ("SE","When 7 is added to a number the result is 20. The number is:",
   "13",
   C("Set up x + 7 = 20, then take 7 away from both sides to find the number.")+
   steps("Write the equation x + 7 = 20","subtract 7 from both sides","x = 20 - 7 = 13.")+
   U("Turning a sentence like this into an equation is the heart of solving word problems."),
   [("27","27 adds 7 to 20; to undo '+7' you subtract, giving x = 13."),
    ("7","7 is the number added on, not the unknown; the number itself is 13."),
    ("140","140 multiplies 7 and 20; the equation is solved by subtracting, giving x = 13.")]),

 ("SE","Three times a number is 21. The number is:",
   "7",
   C("Write 3x = 21, then divide both sides by 3 to free the number.")+
   steps("Three times the number means 3x = 21","divide both sides by 3","x = 21 / 3 = 7.")+
   U("Splitting a total of 21 into 3 equal parts gives 7, the same as this equation."),
   [("63","63 multiplies 21 by 3; to undo 'times 3' you divide, giving x = 7."),
    ("24","24 adds 3 to 21; the equation is solved by dividing by 3, giving x = 7."),
    ("18","18 subtracts 3 from 21; dividing by 3 gives x = 7.")]),

 ("SE","A person's breathing rate doubled to 36 after running. If 2r = 36, the resting rate r was:",
   "18",
   C("Dividing both sides by 2 undoes the doubling, giving the resting rate as 36 / 2.")+
   steps("Doubled rate means 2r = 36","divide both sides by 2","r = 36 / 2 = 18 breaths a minute.")+
   U("Doctors work back from an exercising rate to the resting rate using a step like this."),
   [("72","72 doubles 36 again; to undo the doubling you halve it, giving r = 18."),
    ("38","38 adds 2 to 36; the equation is solved by dividing, giving r = 18."),
    ("34","34 subtracts 2 from 36; you divide by 2 instead, giving r = 18.")]),

 ("SE","Solving the equation 3x + 1 = 10 gives x equal to:",
   "3",
   C("First take 1 from both sides, then divide by 3 to leave x by itself.")+
   steps("Subtract 1: 3x = 10 - 1 = 9","divide both sides by 3","x = 9 / 3 = 3.")+
   U("Peeling off the steps one at a time is how multi-step equations are solved."),
   [("11","11 adds 1 to 10 instead of subtracting; the correct steps give x = 3."),
    ("9","9 is the value of 3x after removing the 1, not of x; dividing by 3 gives x = 3."),
    ("30","30 multiplies 10 by 3; the proper steps give x = 3.")]),

 ("SE","Solving the equation 5x - 2 = 13 gives x equal to:",
   "3",
   C("Add 2 to both sides first, then divide by 5 to isolate x.")+
   steps("Add 2: 5x = 13 + 2 = 15","divide both sides by 5","x = 15 / 5 = 3.")+
   U("Undoing the subtraction and then the multiplication is the standard order here."),
   [("11","11 subtracts 2 from 13 instead of adding; the correct steps give x = 3."),
    ("15","15 is the value of 5x after adding 2, not of x; dividing by 5 gives x = 3."),
    ("65","65 multiplies 13 by 5; the proper steps give x = 3.")]),

 ("SE","If x/2 + 1 = 5, then x equals:",
   "8",
   C("Take 1 from both sides, then multiply by 2 to undo the division.")+
   steps("Subtract 1: x/2 = 5 - 1 = 4","multiply both sides by 2","x = 4 x 2 = 8.")+
   U("Reversing each operation in turn unwinds the equation to find x."),
   [("12","12 adds rather than reverses the steps; doing them correctly gives x = 8."),
    ("4","4 is the value of x/2 after removing the 1, not x; multiplying by 2 gives x = 8."),
    ("3","3 mixes up the steps; subtracting 1 then multiplying by 2 gives x = 8.")]),

 ("SE","To keep an equation true, whatever operation you do to one side you must also do to the:",
   "other side",
   C("An equation stays balanced only if both sides are changed in exactly the same way.")+
   steps("Picture the equation as a balance","add or take away on one pan","do the very same to the other pan to keep it level.")+
   U("Solving any equation rests on this rule: treat both sides exactly alike."),
   [("equals sign","You cannot 'do' an operation to the equals sign; you must do it to the other side."),
    ("answer only","You change both whole sides equally, not just the final answer, to stay balanced."),
    ("first side again","Repeating it on the same side unbalances the equation; you must do it to the other side.")]),

 ("SE","A pendulum's time period T satisfies the equation 5T = 10 seconds. Solving it, T equals:",
   "2 seconds",
   C("Dividing both sides by 5 undoes the 'times 5', giving the time period as 10 / 5.")+
   steps("Five swings take 10 s, so 5T = 10","divide both sides by 5","T = 10 / 5 = 2 seconds.")+
   U("Timing several swings and dividing — exactly this equation — gives an accurate time period."),
   [("50 seconds","50 multiplies 10 by 5; to undo 'times 5' you divide, giving T = 2 s."),
    ("15 seconds","15 adds 5 to 10; the equation is solved by dividing, giving T = 2 s."),
    ("5 seconds","5 subtracts nothing useful here; dividing 10 by 5 gives T = 2 s.")]),

 ("SE","The sum of a number and 8 is 15. Written as an equation, this is:",
   "x + 8 = 15",
   C("The sum of the number and 8 is written x + 8, and that sum equals 15.")+
   steps("Let the number be x","'sum of the number and 8' is x + 8","this equals 15, so x + 8 = 15.")+
   U("Translating words into an equation like this is the key skill in word problems."),
   [("x - 8 = 15","'Sum' means add, not subtract; the equation is x + 8 = 15."),
    ("8x = 15","'Sum of the number and 8' is x + 8, not 8 times x; so x + 8 = 15."),
    ("x + 15 = 8","The total is 15, so it goes on the right: x + 8 = 15, not x + 15 = 8.")]),

 ("SE","Twice a number decreased by 3 equals 9, that is 2x - 3 = 9. Solving it, x equals:",
   "6",
   C("Add 3 to both sides, then divide by 2 to find the number.")+
   steps("Add 3: 2x = 9 + 3 = 12","divide both sides by 2","x = 12 / 2 = 6.")+
   U("Building and then solving such an equation answers many everyday number puzzles."),
   [("3","3 ignores the doubling; solving the full equation 2x - 3 = 9 gives x = 6."),
    ("12","12 is the value of 2x after adding 3, not of x; dividing by 2 gives x = 6."),
    ("9","9 is the right-hand side, not x; the proper steps give x = 6.")]),

 ("SE","Solving the equation x + x = 16 gives x equal to:",
   "8",
   C("Two equal x's add to 2x, so 2x = 16, and dividing by 2 gives x.")+
   steps("x + x is 2x, so 2x = 16","divide both sides by 2","x = 16 / 2 = 8.")+
   U("Recognising that x + x is 2x is a small but vital step in tidying equations."),
   [("16","16 is the total of the two x's, not one x; each x is 16 / 2 = 8."),
    ("4","4 would make x + x only 8, not 16; the correct value is x = 8."),
    ("32","32 doubles 16; the equation 2x = 16 instead gives x = 8.")]),

 ("SE","If 4 is subtracted from twice a number the result is 10, that is 2x - 4 = 10. The number x is:",
   "7",
   C("Add 4 to both sides, then divide by 2 to isolate the number.")+
   steps("Add 4: 2x = 10 + 4 = 14","divide both sides by 2","x = 14 / 2 = 7.")+
   U("Reversing the subtraction and then the doubling unwinds the puzzle to the answer."),
   [("3","3 subtracts instead of adding the 4; the correct steps give x = 7."),
    ("14","14 is the value of 2x after adding 4, not of x; dividing by 2 gives x = 7."),
    ("6","6 misreads the steps; adding 4 then dividing by 2 gives x = 7.")]),

 ("SE","A bus covers d km at 40 km/h for 3 hours, so d = 40 x 3. The distance d is:",
   "120 km",
   C("Distance equals speed multiplied by time, so multiply 40 by 3.")+
   steps("Speed = 40 km/h, time = 3 h","d = speed x time = 40 x 3","that gives d = 120 km.")+
   U("This is how a route planner predicts how far a bus will get in a set time."),
   [("43 km","43 adds 40 and 3; distance multiplies them, giving 120 km."),
    ("13 km","13 mixes up the numbers; distance is 40 x 3 = 120 km."),
    ("40 km","40 is the distance in just one hour; over 3 hours it is 40 x 3 = 120 km.")]),

 ("SE","An equation behaves like a balanced pair of pans on a:",
   "weighing balance",
   C("Both sides of an equation must stay equal, just like two pans that hang level on a balance.")+
   steps("Picture each side of the equation as a pan","they start level because the sides are equal","keeping them level as you work is the whole idea.")+
   U("Thinking of a see-saw or balance reminds you to treat both sides of an equation alike."),
   [("number line","A number line orders numbers; the balanced-sides idea is pictured as a weighing balance."),
    ("clock face","A clock face shows time; an equation's equal sides are like a weighing balance."),
    ("ruler","A ruler measures length; the equal sides of an equation are like a weighing balance.")]),

 ("SE","The solution of the equation 10 - x = 4 is x equal to:",
   "6",
   C("Rearranging gives x equal to 10 minus 4, the amount taken away to leave 4.")+
   steps("From 10 - x = 4, transpose to get x = 10 - 4","compute 10 - 4","so x = 6.")+
   U("Finding what was subtracted to leave a known amount is this kind of simple equation."),
   [("14","14 adds 4 to 10; here x = 10 - 4 = 6."),
    ("4","4 is the right-hand side, not x; solving gives x = 6."),
    ("40","40 multiplies 10 by 4; the equation gives x = 10 - 4 = 6.")]),
]

# ---------- assemble: interleave so no two consecutive share a chapter ----------
assert all(len(b) == 25 for b in (MT, RO, CQ, SE)), [len(MT), len(RO), len(CQ), len(SE)]
items = []
for i in range(25):
    items += [MT[i], RO[i], CQ[i], SE[i]]
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

    keydist = build_paper(PNUM, TITLE, SHORT, LABELS, items, seed=41019,
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
    split = "/".join(str(counts[c]) for c in ("MT", "RO", "CQ", "SE"))
    with open("PAPERS_MANIFEST.md", "a", encoding="utf-8") as fh:
        fh.write(f"| {PNUM} | 2026-06-18 | {TITLE} | {split} | ✓ |\n")

    # ---- update QUESTION_INDEX.json ----
    idx["fingerprints"] = sorted(existing | set(new_fps))
    idx.setdefault("combos", []).append({
        "paper": PNUM,
        "chapters": ["Motion & Time",
                     "Respiration in Organisms",
                     "Comparing Quantities",
                     "Simple Equations"],
    })
    idx["papers"] = idx.get("papers", 0) + 1
    with open(idx_path, "w", encoding="utf-8") as fh:
        json.dump(idx, fh, ensure_ascii=False, indent=2)
        fh.write("\n")

    print("Files:", sorted(v for v in moves.values()))
    print("Answer key spread A/B/C/D =", dict(keydist))
    print("Fingerprints added:", len(new_fps))
