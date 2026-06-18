# -*- coding: utf-8 -*-
# Boss Challenge Paper 48 — Motion & Time · Soil ·
# Perimeter & Area · Algebraic Expressions
# Content-only. Uses the dependency-free examfactory engine.
# Difficulty ramp: leans hard into FUSION. A walk around a field becomes a
# speed = distance / time solve where the distance is a PERIMETER; the area
# of a plot decides how much topsoil it holds; a soil's percolation rate is
# written as an ALGEBRAIC EXPRESSION and evaluated; a uniform speed is hidden
# inside an expression the child must simplify. The child meets a Science or
# everyday situation and reaches for a Maths skill.
# Class-7 scope, simple wording, hard thinking.
# Produces, under Resources/BossChallengePapers/:
#   Paper_48_<SHORT>_QuestionPaper.html  (pure HTML — questions + options)
#   Paper_48_<SHORT>_QuestionPaper.pdf
#   Paper_48_<SHORT>_Questions.md
#   Paper_48_<SHORT>_Solutions.html
import os, sys, shutil, json, re
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from examfactory import build_paper, C, steps, U

PNUM  = "48"
SHORT = "MotionTime_Soil_PerimeterArea_AlgebraicExpressions"
TITLE = ("Motion & Time · Soil · "
         "Perimeter & Area · Algebraic Expressions")
LABELS = {
    "MT": "Motion & Time",
    "SO": "Soil",
    "PA": "Perimeter & Area",
    "AE": "Algebraic Expressions",
}

# ---------- MOTION & TIME (25) — Science (several fused with Maths) ----------
MT = [
 ("MT","A scooter that keeps covering equal distances in every equal slot of time is moving with what is called:",
   "uniform motion",
   C("In uniform motion the body covers equal distances in equal time intervals, so its speed never changes.")+
   steps("Check the distance covered in each equal time slot","they are all the same","so the speed is constant — uniform motion.")+
   U("A train moving at a steady 60 km/h on a straight track is in uniform motion."),
   [("non-uniform motion","Non-uniform motion means unequal distances in equal times; here the distances are equal, so it is uniform."),
    ("circular motion","Circular motion only tells the shape of the path, not whether equal distances are covered in equal times."),
    ("oscillatory motion","Oscillatory motion is a to-and-fro swing; covering equal distances in equal times is uniform motion.")]),

 ("MT","The basic unit used to measure time in the international (SI) system is the:",
   "second",
   C("The SI unit of time is the second. Larger units like the minute and hour are built from it.")+
   steps("Recall the SI base units","time is measured in the second","so the answer is the second.")+
   U("A stopwatch in a race counts the runner's time in seconds."),
   [("hour","An hour is a larger, everyday unit made of 3600 seconds; the SI base unit is the second."),
    ("metre","A metre measures length, not time; time's SI unit is the second."),
    ("kilogram","A kilogram measures mass; the SI unit of time is the second.")]),

 ("MT","A simple pendulum completes one full to-and-fro swing in 2 seconds. The time for one complete swing is its:",
   "time period",
   C("The time taken for one complete to-and-fro oscillation of a pendulum is called its time period.")+
   steps("One full swing there-and-back is one oscillation","the time for one oscillation","is the time period — here 2 seconds.")+
   U("A wall clock's pendulum is tuned so its time period keeps the seconds hand accurate."),
   [("frequency","Frequency counts swings per second; the time for one swing is the time period."),
    ("amplitude","Amplitude is how far the bob swings from the centre, not the time of a swing."),
    ("speed","Speed is distance over time; the duration of one oscillation is the time period.")]),

 ("MT","Aarav cycles 600 metres in 50 seconds at a steady rate. Using speed = distance ÷ time, his speed is:",
   "12 m/s",
   C("Speed = distance ÷ time. With a steady rate, divide the distance by the time taken.")+
   steps("Distance = 600 m, time = 50 s","speed = 600 ÷ 50","= 12 metres per second.")+
   U("A cyclist's bike computer shows speed by dividing distance travelled by the time taken."),
   [("10 m/s","That would need 500 m in 50 s; 600 ÷ 50 gives 12 m/s, not 10."),
    ("30 m/s","30 m/s would cover 1500 m in 50 s — far more than 600 m; the correct value is 12 m/s."),
    ("0.083 m/s","That divides time by distance (50 ÷ 600); speed is distance ÷ time = 12 m/s.")]),

 ("MT","A square park has each side 80 m. Reeta jogs once around its boundary (the perimeter) in 200 s. Her speed is:",
   "1.6 m/s",
   C("First find the distance — the perimeter of the square — then divide by time. Perimeter of a square = 4 × side.")+
   steps("Perimeter = 4 × 80 = 320 m","speed = 320 ÷ 200","= 1.6 metres per second.")+
   U("A fitness app multiplies the lap distance by laps, then divides by time to show your pace."),
   [("0.4 m/s","That uses just one side (80 ÷ 200); a full lap is the perimeter 4 × 80 = 320 m, giving 1.6 m/s."),
    ("3.2 m/s","That doubles the perimeter; one lap is 320 m, so 320 ÷ 200 = 1.6 m/s."),
    ("16 m/s","That drops a decimal place; 320 ÷ 200 = 1.6 m/s, not 16 m/s.")]),

 ("MT","On a distance–time graph, the motion of a body that stays at rest in one place is shown by a:",
   "straight horizontal line",
   C("If a body does not move, its distance from the start stays the same as time passes, so the graph is a flat horizontal line.")+
   steps("Distance is unchanged while time increases","plot constant distance against rising time","the line runs flat — horizontal.")+
   U("A parked car shows up as a flat horizontal line on a distance–time graph."),
   [("straight sloping line","A sloping straight line shows steady movement; a body at rest gives a flat horizontal line."),
    ("curved line","A curve shows changing (non-uniform) speed; a resting body gives a flat horizontal line."),
    ("vertical line","A vertical line would mean distance changes with no time passing, which is impossible; rest is a horizontal line.")]),

 ("MT","On a distance–time graph, a straight line sloping upward at a constant angle tells us the body is moving with:",
   "uniform speed",
   C("A straight, evenly sloping line means equal distances are covered in equal times, so the speed is steady — uniform.")+
   steps("The slope is the same all along the line","equal distance in equal time","means uniform (constant) speed.")+
   U("A train cruising steadily traces a straight sloping line on a distance–time graph."),
   [("zero speed","Zero speed gives a flat horizontal line; an upward slope means the body is moving at uniform speed."),
    ("increasing speed","Increasing speed bends the line into a curve; a straight slope means uniform speed."),
    ("decreasing speed","Decreasing speed also curves the line; a straight even slope is uniform speed.")]),

 ("MT","A car's odometer measures the total distance the vehicle has travelled, while the instrument that shows its speed is the:",
   "speedometer",
   C("The speedometer displays the vehicle's current speed; the odometer adds up the total distance covered.")+
   steps("You want the current speed, not total distance","the dial that reads speed","is the speedometer.")+
   U("Glancing at the speedometer tells a driver whether they are within the speed limit."),
   [("odometer","The odometer totals distance travelled; the dial that shows speed is the speedometer."),
    ("barometer","A barometer measures air pressure, not a car's speed; that is the speedometer."),
    ("thermometer","A thermometer measures temperature; a car's speed is read off the speedometer.")]),

 ("MT","If a bus travels 240 km in 4 hours, then its average speed for the journey is:",
   "60 km/h",
   C("Average speed = total distance ÷ total time, even if the bus sped up and slowed down along the way.")+
   steps("Distance = 240 km, time = 4 h","average speed = 240 ÷ 4","= 60 km/h.")+
   U("A road-trip planner divides the route length by hours to estimate an average speed."),
   [("96 km/h","That would cover 384 km in 4 h; 240 ÷ 4 = 60 km/h."),
    ("48 km/h","48 km/h gives 192 km in 4 h, short of 240; the average is 60 km/h."),
    ("240 km/h","That forgets to divide by the 4 hours; the average speed is 240 ÷ 4 = 60 km/h.")]),

 ("MT","Speed is usually written as a fraction of two quantities. Speed equals distance divided by:",
   "time",
   C("Speed tells how much distance is covered in a unit of time, so speed = distance ÷ time.")+
   steps("Speed compares distance with time","divide the distance by the time taken","speed = distance ÷ time.")+
   U("Saying a scooter does '40 km in 1 hour' is just distance ÷ time put into words."),
   [("mass","Mass has nothing to do with how fast something moves; speed is distance ÷ time."),
    ("area","Area is a measure of surface, not motion; speed divides distance by time."),
    ("force","Force can change motion, but speed itself is simply distance ÷ time.")]),

 ("MT","The hands of a clock, the spinning of a fan and a swinging pendulum are all examples used to measure or mark:",
   "time",
   C("Anything that repeats a motion at a steady rate — a pendulum, a clock's hands, a fan — can be used to keep track of time.")+
   steps("Each one repeats its motion regularly","regular repeating motion is a clock","such devices mark the passing of time.")+
   U("Ancient people used a regularly dripping water clock to mark the hours."),
   [("mass","Repeating motions help count time, not mass, which needs a balance."),
    ("temperature","Temperature is read with a thermometer; repeating motions are used to measure time."),
    ("distance","Distance is measured with a scale or tape; regular repeating motions measure time.")]),

 ("MT","A toy car moves 5 m in the first second, 9 m in the next and 14 m in the third. This motion is:",
   "non-uniform motion",
   C("Because the distances covered in each equal one-second interval are different, the speed keeps changing — the motion is non-uniform.")+
   steps("Compare distances each second: 5 m, 9 m, 14 m","they are unequal","so the speed changes — non-uniform motion.")+
   U("A car speeding up at a green light covers more distance each second — non-uniform motion."),
   [("uniform motion","Uniform motion needs equal distances in equal times; here they differ, so it is non-uniform."),
    ("rest","The car is clearly moving — it covers metres each second — so it is not at rest."),
    ("oscillatory motion","Oscillatory motion swings back and forth; this car keeps moving forward with changing speed.")]),

 ("MT","The time period of a pendulum depends mainly on the length of its thread. A longer pendulum has a:",
   "longer time period",
   C("A longer pendulum takes more time to complete one swing, so its time period is longer (it ticks more slowly).")+
   steps("Lengthen the pendulum's thread","each swing now takes more time","so the time period grows longer.")+
   U("A tall grandfather clock uses a long pendulum to give a slow, steady one-second beat."),
   [("shorter time period","Lengthening the thread slows the swing, so the time period gets longer, not shorter."),
    ("zero time period","A pendulum always takes some time to swing; lengthening it makes the period longer, never zero."),
    ("time period that does not change","Length is the main control of the period; a longer thread gives a longer period.")]),

 ("MT","A train passes a 1200 m bridge at a steady 20 m/s. The time it takes to cross the length of the bridge is about:",
   "60 s",
   C("Rearrange speed = distance ÷ time into time = distance ÷ speed.")+
   steps("Distance = 1200 m, speed = 20 m/s","time = 1200 ÷ 20","= 60 seconds.")+
   U("A railway timetable uses time = distance ÷ speed to predict when a train reaches the next station."),
   [("24 s","That divides 1200 by 50, not the given speed 20; 1200 ÷ 20 = 60 s."),
    ("120 s","That uses a speed of 10 m/s; at 20 m/s the time is 1200 ÷ 20 = 60 s."),
    ("600 s","That keeps an extra zero; 1200 ÷ 20 = 60 s, not 600 s.")]),

 ("MT","Two cities are 150 km apart. A car leaves at 9:00 a.m. driving at 50 km/h. It reaches the second city at:",
   "12:00 noon",
   C("First find the travel time using time = distance ÷ speed, then add it to the start time.")+
   steps("Time = 150 ÷ 50 = 3 hours","add 3 hours to the 9:00 a.m. start","arrival is 12:00 noon.")+
   U("A bus timetable adds the journey time to the departure time to print the arrival time."),
   [("11:00 a.m.","That assumes a 2-hour trip; 150 ÷ 50 = 3 hours, so arrival is 12:00 noon."),
    ("1:00 p.m.","That uses 4 hours; the trip takes 150 ÷ 50 = 3 hours, reaching noon."),
    ("10:30 a.m.","That uses only 1.5 hours; at 50 km/h the 150 km trip takes 3 hours.")]),

 ("MT","Among these, the SI unit of speed — built from the units of distance and time — is the:",
   "metre per second",
   C("Speed is distance ÷ time, so its SI unit combines the metre (distance) with the second (time): metre per second (m/s).")+
   steps("Distance is in metres, time in seconds","speed = metre ÷ second","so the SI unit is metre per second.")+
   U("Physics labs report a ball's speed in metres per second."),
   [("kilometre per hour","km/h is a common everyday unit, but the SI unit of speed is the metre per second."),
    ("metre only","The metre alone measures length; speed needs distance per time — metre per second."),
    ("second per metre","That inverts the formula; speed is distance per time, the metre per second.")]),

 ("MT","A girl walks once around a rectangular field 60 m long and 40 m wide in 100 s. Her speed (distance = perimeter) is:",
   "2 m/s",
   C("The distance she walks is the rectangle's perimeter, 2 × (length + breadth); then speed = distance ÷ time.")+
   steps("Perimeter = 2 × (60 + 40) = 200 m","speed = 200 ÷ 100","= 2 metres per second.")+
   U("A runner's lap distance around a rectangular ground is its perimeter, used to work out pace."),
   [("1 m/s","That uses half the perimeter (100 m); a full lap is 2 × (60 + 40) = 200 m, giving 2 m/s."),
    ("2.4 m/s","That comes from adding only 60 + 40 + 60 + 80; the perimeter is 200 m, so the speed is 2 m/s."),
    ("4 m/s","That doubles the perimeter; one lap is 200 m, so 200 ÷ 100 = 2 m/s.")]),

 ("MT","A motion in which a body retraces its path again and again about a fixed point, like a swing, is called:",
   "oscillatory motion",
   C("Oscillatory (to-and-fro) motion repeats back and forth about a central rest point, as a swing or pendulum does.")+
   steps("The body moves out and returns, over and over","it swings about one fixed central point","this repeating to-and-fro is oscillatory motion.")+
   U("A child on a playground swing moving back and forth shows oscillatory motion."),
   [("rectilinear motion","Rectilinear motion is along a straight line one way; a back-and-forth swing is oscillatory."),
    ("uniform motion","Uniform motion is about constant speed, not the to-and-fro pattern of a swing."),
    ("rotational motion","Rotational motion is spinning about an axis; a swing's back-and-forth is oscillatory.")]),

 ("MT","A scooter covers the first 30 km in 1 hour and the next 30 km in 2 hours. Its average speed for the whole trip is:",
   "20 km/h",
   C("Average speed uses the TOTAL distance over the TOTAL time, not the average of the two speeds.")+
   steps("Total distance = 30 + 30 = 60 km","total time = 1 + 2 = 3 h","average speed = 60 ÷ 3 = 20 km/h.")+
   U("A delivery rider's average pace for a day is total kilometres divided by total hours, not a guess."),
   [("25 km/h","That just averages 30 km/h and 20 km/h; correct is total distance ÷ total time = 60 ÷ 3 = 20 km/h."),
    ("30 km/h","30 km/h ignores the slower second leg; the average over 3 hours is 20 km/h."),
    ("15 km/h","That divides 60 by 4 hours; the total time is 3 hours, giving 20 km/h.")]),

 ("MT","Before clocks, people used the regularly repeating event of a shadow's movement on a marked plate, called a:",
   "sundial",
   C("A sundial tells time from the position of a shadow cast by the Sun, which sweeps steadily across a marked plate through the day.")+
   steps("The Sun's position changes regularly through the day","a pointer's shadow moves across a marked dial","reading the shadow's place gives the time — a sundial.")+
   U("An old garden sundial still shows roughly the right hour on a sunny day."),
   [("water clock","A water clock measures time by steady dripping water, not a Sun shadow on a plate — that is a sundial."),
    ("sand clock","A sand clock (hourglass) times a fixed interval by falling sand, not by a shadow."),
    ("pendulum clock","A pendulum clock uses a swinging bob; the shadow-on-a-plate device is a sundial.")]),

 ("MT","An athlete runs 100 m in 10 s, then 100 m more in 20 s. Comparing the two legs, the athlete was faster in the:",
   "first 100 m",
   C("The same distance took less time in the first leg, so the speed was higher there (speed = distance ÷ time).")+
   steps("First leg: 100 ÷ 10 = 10 m/s","second leg: 100 ÷ 20 = 5 m/s","10 m/s > 5 m/s, so the first leg was faster.")+
   U("Sprinters often slow in the last stretch — their split times reveal which part was fastest."),
   [("second 100 m","The second leg took 20 s for the same 100 m, so it was slower (5 m/s) than the first (10 m/s)."),
    ("both legs equally","The legs took different times for equal distance, so the speeds differ; the first was faster."),
    ("neither — the runner was at rest","The athlete clearly moved; the first leg, at 10 m/s, was the faster one.")]),

 ("MT","A simple pendulum makes 30 complete oscillations in 60 seconds. The time period of the pendulum is:",
   "2 s",
   C("Time period = total time ÷ number of oscillations.")+
   steps("Total time = 60 s, oscillations = 30","time period = 60 ÷ 30","= 2 seconds per oscillation.")+
   U("Timing many swings and dividing gives a more accurate pendulum period than timing just one."),
   [("0.5 s","That divides 30 by 60 (oscillations per second), the frequency, not the period; 60 ÷ 30 = 2 s."),
    ("30 s","30 s is the number of swings mistaken for seconds; the period is 60 ÷ 30 = 2 s."),
    ("90 s","That adds the two numbers; the period is total time ÷ swings = 60 ÷ 30 = 2 s.")]),

 ("MT","On a distance–time graph, the steeper the sloping line, the:",
   "greater the speed of the body",
   C("A steeper slope means more distance is covered in the same time, so the body is moving faster.")+
   steps("Compare two sloping lines over the same time","the steeper one reaches a larger distance","so a steeper slope means greater speed.")+
   U("On a race chart, the runner whose line climbs most steeply is leading."),
   [("smaller the speed of the body","A steeper line means more distance per time, i.e. a greater, not smaller, speed."),
    ("body is at rest","A body at rest gives a flat line; any slope means motion, and a steeper slope means more speed."),
    ("longer the time period","Time period belongs to oscillations; on a distance–time graph a steep slope means high speed.")]),

 ("MT","A car shows 5000 km on its odometer at the start of a trip and 5320 km at the end. The distance travelled was:",
   "320 km",
   C("The distance of the trip is the difference between the final and starting odometer readings.")+
   steps("Final reading = 5320 km, start = 5000 km","distance = 5320 − 5000","= 320 km.")+
   U("Drivers subtract the start odometer reading from the end one to log a trip's distance."),
   [("5320 km","5320 km is the final reading, not the trip; subtract the 5000 km start to get 320 km."),
    ("10320 km","That adds the readings instead of subtracting; the trip is 5320 − 5000 = 320 km."),
    ("300 km","That mis-subtracts; 5320 − 5000 is exactly 320 km.")]),

 ("MT","Walking speeds are most conveniently expressed in km/h, while a snail's creep is better expressed in:",
   "smaller units like cm per minute",
   C("Very slow motion covers tiny distances in long times, so small units (such as centimetres per minute) describe it more sensibly than km/h.")+
   steps("A snail covers only a few centimetres in a minute","km/h would give an awkward tiny decimal","so a small unit like cm/min fits better.")+
   U("A biologist times a snail in centimetres per minute, not kilometres per hour."),
   [("very large units like km per second","km/s suits rockets, not a snail; its creep is best in tiny units like cm/min."),
    ("units of mass like kilograms","Mass units cannot describe speed at all; a snail's pace needs a small distance-per-time unit."),
    ("units of time like hours alone","Time alone is not a speed; a snail's slow pace fits a small unit like cm per minute.")]),
]

# ---------- SOIL (25) — Science (several fused with Maths) ----------
SO = [
 ("SO","The loose mixture of broken rock, minerals, water, air and decayed living matter that covers the land is called:",
   "soil",
   C("Soil is the thin top layer of the land — a mixture of weathered rock, minerals, humus, water and air — in which plants grow.")+
   steps("It covers the land and holds plants","it mixes rock bits, humus, water and air","this living mixture is soil.")+
   U("A gardener digs into soil to plant seeds because it holds water, air and nutrients."),
   [("water","Water is only one ingredient inside soil; the whole land-covering mixture is the soil."),
    ("air","Air fills the gaps in soil, but the full mixture of rock bits, humus and minerals is the soil."),
    ("humus","Humus is the decayed-matter part of soil; the entire mixture itself is called soil.")]),

 ("SO","The dark, decayed remains of dead plants and animals that make soil fertile is known as:",
   "humus",
   C("Humus is the dark organic matter formed when plant and animal remains rot. It enriches soil with nutrients and helps it hold water.")+
   steps("Dead leaves and creatures break down in the soil","they form a dark, rich material","this fertile organic matter is humus.")+
   U("Adding compost (rich in humus) to a pot helps vegetables grow greener and stronger."),
   [("gravel","Gravel is small stones, not the decayed matter; the fertile organic part of soil is humus."),
    ("clay","Clay is the smallest mineral particles; the rotted organic matter that enriches soil is humus."),
    ("bedrock","Bedrock is the solid rock far below; the dark fertile organic layer is humus.")]),

 ("SO","The different horizontal layers seen when soil is cut from top to bottom together make up the:",
   "soil profile",
   C("A vertical cut through soil reveals layers called horizons; the full set of these layers is the soil profile.")+
   steps("Dig a deep pit and look at the side","you see distinct stacked layers (horizons)","the whole stack is the soil profile.")+
   U("Road-cuttings on a hillside often expose a soil profile with clear coloured bands."),
   [("water table","The water table is the level below which the ground is soaked, not the set of soil layers."),
    ("topsoil","Topsoil is only the uppermost layer; all the layers together form the soil profile."),
    ("bedrock","Bedrock is the lowest solid-rock layer; the complete stack of layers is the soil profile.")]),

 ("SO","The uppermost, darkest and most fertile layer of the soil profile, rich in humus, is called the:",
   "topsoil (A-horizon)",
   C("The topmost layer (the A-horizon, or topsoil) is rich in humus and minerals, making it the most fertile layer where most roots grow.")+
   steps("Look at the very top of the profile","it is dark and full of humus","this fertile top layer is the topsoil (A-horizon).")+
   U("Farmers protect topsoil because crops depend on its humus and nutrients."),
   [("subsoil (B-horizon)","The subsoil lies below the topsoil and is harder and less fertile; the top fertile layer is the topsoil."),
    ("bedrock (C-horizon and below)","Bedrock is the solid rock at the bottom; the rich top layer is the topsoil."),
    ("water table","The water table is a level of saturation, not the fertile surface layer (topsoil).")]),

 ("SO","Soil made mostly of the largest particles, which lets water drain through very quickly, is:",
   "sandy soil",
   C("Sandy soil has large particles with big air gaps, so water drains through it fast and it holds little water.")+
   steps("Largest particles mean big gaps between them","water rushes through the wide gaps","so sandy soil drains quickly.")+
   U("Cacti thrive in sandy soil because the quick drainage keeps their roots from rotting."),
   [("clayey soil","Clayey soil has the smallest particles and tiny gaps, so it drains slowly — the opposite of sandy soil."),
    ("loamy soil","Loamy soil is a balanced mix; the soil with the largest particles and fastest drainage is sandy soil."),
    ("humus","Humus is decayed organic matter, not a particle-size class; the fast-draining soil is sandy.")]),

 ("SO","Soil made of the smallest, tightly packed particles, which holds water well but drains slowly, is:",
   "clayey soil",
   C("Clayey soil has the finest particles packed closely with tiny gaps, so it holds water tightly and drains slowly.")+
   steps("Smallest particles pack with tiny gaps","water is held and seeps out slowly","so clayey soil retains water.")+
   U("Potters use clayey soil because, when wet, its fine particles stick and can be moulded."),
   [("sandy soil","Sandy soil has the largest particles and drains fast; the water-holding fine soil is clayey."),
    ("loamy soil","Loamy soil drains moderately; the soil with the smallest particles holding the most water is clayey."),
    ("gravel","Gravel is coarse stones that barely hold water; the fine, water-holding soil is clayey.")]),

 ("SO","The balanced soil — a mixture of sand, clay and silt with plenty of humus — best for growing most crops is:",
   "loamy soil",
   C("Loamy soil mixes sand, silt and clay in good proportion with humus, so it drains well yet holds enough water and nutrients — ideal for farming.")+
   steps("It blends large and small particles with humus","this gives both drainage and water-holding","so loamy soil suits most crops best.")+
   U("Wheat and many vegetables grow best in loamy soil because it is neither too sandy nor too clayey."),
   [("pure sandy soil","Pure sand drains too fast and holds few nutrients; the balanced crop soil is loamy."),
    ("pure clayey soil","Pure clay waterlogs and packs hard; the balanced, well-draining soil for crops is loamy."),
    ("gravelly soil","Gravel holds almost no water or nutrients; the best all-round farming soil is loamy.")]),

 ("SO","The slow downward seepage of water through soil is measured as its percolation rate. The faster the percolation, the:",
   "larger the gaps between soil particles",
   C("Water moves quickest through soils with large gaps (like sand). A high percolation rate signals big spaces between particles.")+
   steps("Big particles leave big gaps","water seeps through big gaps quickly","so fast percolation means larger gaps.")+
   U("Sports grounds prefer sandy, fast-percolating soil so puddles drain after rain."),
   [("smaller the gaps between soil particles","Small gaps slow water down; fast percolation means the gaps are larger, as in sand."),
    ("more humus the soil must contain","Humus helps water-holding, but fast percolation is mainly due to large particle gaps."),
    ("colder the soil must be","Temperature is not the main control; fast percolation reflects large gaps between particles.")]),

 ("SO","In a percolation test, 200 mL of water passes through a soil sample in 20 minutes. Its percolation rate is:",
   "10 mL per minute",
   C("Percolation rate = amount of water ÷ time taken, giving how many millilitres seep through each minute.")+
   steps("Water = 200 mL, time = 20 min","rate = 200 ÷ 20","= 10 mL per minute.")+
   U("Soil scientists report percolation in mL per minute to compare how fast different soils drain."),
   [("4000 mL per minute","That multiplies instead of divides; the rate is 200 ÷ 20 = 10 mL per minute."),
    ("0.1 mL per minute","That divides time by volume (20 ÷ 200); the rate is volume ÷ time = 10 mL per minute."),
    ("180 mL per minute","That subtracts (200 − 20); percolation rate is a division, 200 ÷ 20 = 10 mL/min.")]),

 ("SO","Two soils are tested. Soil A lets 300 mL through in 10 min; Soil B lets 300 mL through in 30 min. The sandier soil is:",
   "Soil A",
   C("Sandy soil drains fastest. For the same volume, the soil that takes LESS time has the higher percolation rate, so it is the sandier one.")+
   steps("Same 300 mL, A takes 10 min, B takes 30 min","A's rate 30 mL/min beats B's 10 mL/min","faster drainage means A is the sandier soil.")+
   U("A nursery picks the faster-draining (sandier) soil for plants that hate soggy roots."),
   [("Soil B","Soil B took longer for the same water, so it drains slowly — that is the clayey one, not the sandier."),
    ("Both are equally sandy","They drained the same volume in very different times, so they are not equally sandy; A is faster."),
    ("Neither — both are clayey","A drained quickly (30 mL/min), which is sandy behaviour, so A is the sandier soil.")]),

 ("SO","The wearing away and carrying off of the fertile top layer of soil by wind or flowing water is called:",
   "soil erosion",
   C("Soil erosion is the removal of topsoil by agents like wind and running water, which strips away the fertile layer plants need.")+
   steps("Wind or rushing water loosens the topsoil","it is carried away from the land","this loss of fertile topsoil is soil erosion.")+
   U("Heavy rain on a bare hillside washes away topsoil — visible soil erosion."),
   [("percolation","Percolation is water seeping downward through soil, not the carrying away of topsoil — that is erosion."),
    ("weathering","Weathering breaks rock into soil; the removal of formed topsoil is erosion."),
    ("humus formation","Humus formation enriches soil; the loss of fertile topsoil is the opposite — soil erosion.")]),

 ("SO","Planting trees and grass on bare slopes helps reduce soil erosion mainly because plant roots:",
   "bind the soil and hold it in place",
   C("Roots grip the soil particles and form a net that holds topsoil down, so wind and water cannot carry it away as easily.")+
   steps("Bare soil is loose and easily swept off","roots weave through and grip the particles","held soil resists wind and water — less erosion.")+
   U("Grassing over a raw embankment beside a new road stops it washing away in the rains."),
   [("make the soil drain faster","Faster drainage does not stop erosion; roots reduce erosion by binding and holding the soil."),
    ("turn the soil into pure clay","Roots do not change soil type; they cut erosion by gripping and holding the particles."),
    ("warm the soil up","Warming has no role here; roots reduce erosion by binding the soil in place.")]),

 ("SO","The process by which rocks are broken down over a very long time into smaller particles that form soil is called:",
   "weathering",
   C("Weathering is the slow breakdown of rock by Sun, water, wind and living things into the small particles that, with humus, become soil.")+
   steps("Rocks are exposed to heat, water, wind, roots","over ages they crack and crumble into bits","this breakdown of rock is weathering.")+
   U("A rock split by water freezing in its cracks each winter is being weathered into soil."),
   [("erosion","Erosion carries soil away; the breaking down of rock into particles is weathering."),
    ("percolation","Percolation is water seeping through soil, not the breakdown of rock — that is weathering."),
    ("evaporation","Evaporation is water turning to vapour; rock breaking into soil particles is weathering.")]),

 ("SO","Which soil is best suited for growing paddy (rice), a crop that needs water to stand around its roots?",
   "clayey soil",
   C("Paddy needs flooded fields, so clayey soil — which holds water and drains slowly — keeps the water standing around the roots.")+
   steps("Rice grows in standing water","clayey soil holds water and drains slowly","so clayey soil suits paddy best.")+
   U("Rice paddies are deliberately puddled into a clayey, water-holding base to stay flooded."),
   [("sandy soil","Sandy soil drains too fast to keep a field flooded, so it is poor for paddy; clay holds the water."),
    ("gravelly soil","Gravel lets water rush straight through; flooded paddy needs water-holding clayey soil."),
    ("loose dry soil","Dry, loose soil cannot hold standing water; paddy needs the water-retaining clayey soil.")]),

 ("SO","A farmer needs 4 kg of topsoil for every 1 square metre of bed. For a bed of area 6 m², the topsoil required is:",
   "24 kg",
   C("Multiply the area by the amount needed per square metre: total = rate × area.")+
   steps("Rate = 4 kg per m², area = 6 m²","total = 4 × 6","= 24 kg of topsoil.")+
   U("A gardener buying topsoil multiplies the bed's area by the kilograms needed per square metre."),
   [("10 kg","That adds 4 + 6 instead of multiplying; 4 kg/m² × 6 m² = 24 kg."),
    ("1.5 kg","That divides 6 by 4; the topsoil needed is rate × area = 4 × 6 = 24 kg."),
    ("48 kg","That doubles the answer; 4 × 6 = 24 kg, not 48 kg.")]),

 ("SO","The amount of water vapour that escapes from soil and plants together returns moisture to the air mainly through:",
   "evaporation and transpiration",
   C("Soil loses water by evaporation from its surface, and plants lose it by transpiration from leaves; together they return moisture to the air.")+
   steps("The Sun warms the soil surface — water evaporates","leaves release water vapour — transpiration","both add moisture back to the air.")+
   U("On a hot day a watered field and its plants together humidify the air above them."),
   [("erosion of the topsoil","Erosion moves solid soil, not water vapour; moisture returns by evaporation and transpiration."),
    ("percolation deep underground","Percolation sends water down, away from the air; vapour returns by evaporation and transpiration."),
    ("weathering of the bedrock","Weathering breaks rock; it does not return water vapour to the air, which evaporation and transpiration do.")]),

 ("SO","The layer of soil lying just below the topsoil, harder and containing less humus, is the:",
   "subsoil (B-horizon)",
   C("Below the fertile topsoil lies the subsoil (B-horizon): denser, paler and poorer in humus, but rich in minerals washed down from above.")+
   steps("Go one layer below the topsoil","it is harder with little humus","this is the subsoil (B-horizon).")+
   U("Deep tree roots reach into the subsoil to draw up minerals and anchor the tree."),
   [("topsoil (A-horizon)","Topsoil is the fertile top layer; the harder, humus-poor layer beneath it is the subsoil."),
    ("bedrock (C-horizon)","Bedrock is the solid rock deepest down; the layer just below topsoil is the subsoil."),
    ("humus layer","The humus-rich part is the topsoil; the layer below with little humus is the subsoil.")]),

 ("SO","Tiny soil organisms such as earthworms improve the soil chiefly by:",
   "burrowing to mix and aerate it",
   C("Earthworms tunnel through soil, mixing layers and opening air channels, which lets air and water in and brings up nutrients.")+
   steps("Earthworms burrow through the soil","their tunnels let in air and water and mix layers","so the soil becomes looser and more fertile.")+
   U("Gardeners welcome earthworms because their burrowing keeps the soil loose and rich."),
   [("packing the soil tightly together","Earthworms loosen, not pack, soil; their burrows aerate and mix it."),
    ("removing all the humus","Earthworms enrich soil with their casts; they add to humus rather than remove it."),
    ("turning the soil into solid rock","Earthworms keep soil loose and living; they do not make rock — they aerate and mix.")]),

 ("SO","Soil holds air in the gaps between its particles. This trapped air is important because it is used by:",
   "roots and soil organisms to breathe",
   C("The air in soil pores supplies oxygen for plant roots and for soil creatures like earthworms and microbes to respire.")+
   steps("Soil has air-filled gaps between particles","roots and soil animals take oxygen from this air","so the trapped air lets them breathe.")+
   U("Overwatering can drown a potted plant by filling the soil's air gaps, suffocating its roots."),
   [("the Sun to make sunlight","The Sun makes its own light; soil air is used by roots and organisms to breathe."),
    ("clouds to form rain","Clouds form from atmospheric vapour, not soil air; soil air is for roots and organisms."),
    ("rocks to grow larger","Rocks do not grow from soil air; that air lets roots and soil organisms breathe.")]),

 ("SO","A field 50 m long and 30 m wide is to be covered with 2 cm of topsoil. The area to be covered is:",
   "1500 m²",
   C("The area to spread topsoil over is the area of the rectangular field: length × breadth.")+
   steps("Length = 50 m, breadth = 30 m","area = 50 × 30","= 1500 square metres.")+
   U("A landscaper finds a plot's area first, then orders enough topsoil to cover it."),
   [("160 m²","That uses the perimeter 2 × (50 + 30); covering needs the area 50 × 30 = 1500 m²."),
    ("80 m²","That just adds 50 + 30; the area to cover is the product 50 × 30 = 1500 m²."),
    ("3000 m²","That doubles the area; 50 × 30 = 1500 m², not 3000 m².")]),

 ("SO","Over-farming the same land without rest or fresh nutrients gradually makes the soil:",
   "lose its fertility",
   C("Growing crops repeatedly without replenishing nutrients drains the soil's humus and minerals, so it slowly loses fertility.")+
   steps("Each crop takes nutrients from the soil","without rest or manure they are not replaced","so the soil's fertility falls.")+
   U("Farmers rotate crops or add manure to stop over-used soil from losing its fertility."),
   [("gain more humus on its own","Continuous cropping removes nutrients; without inputs the soil loses, not gains, fertility."),
    ("turn into solid bedrock","Soil does not become rock from over-farming; it simply loses its fertility."),
    ("drain water far more slowly","Over-farming chiefly depletes nutrients, lowering fertility, rather than mainly changing drainage.")]),

 ("SO","The level below the ground at which all the gaps in the soil and rock are completely filled with water is the:",
   "water table",
   C("Below a certain depth the soil and rock pores are fully saturated with water; the top of this saturated zone is the water table.")+
   steps("Water percolates down and fills the pores","below one level every gap is full of water","the top of that level is the water table.")+
   U("A well is dug down until it reaches below the water table so it fills with groundwater."),
   [("soil profile","The soil profile is the stack of soil layers, not the saturated water level — that is the water table."),
    ("topsoil","Topsoil is the fertile surface layer; the saturated underground level is the water table."),
    ("humus line","There is no 'humus line'; the level where pores are full of water is the water table.")]),

 ("SO","Which sequence correctly lists soil particles from the LARGEST to the smallest?",
   "gravel, sand, silt, clay",
   C("By size, soil particles run from coarse to fine: gravel (largest), then sand, then silt, then clay (smallest).")+
   steps("Start with the coarsest stones — gravel","next sand, then finer silt","ending with the finest, clay.")+
   U("Sieving soil through finer and finer meshes separates gravel, sand, silt and clay in that order."),
   [("clay, silt, sand, gravel","That is smallest to largest; the question asks largest to smallest: gravel, sand, silt, clay."),
    ("sand, gravel, clay, silt","Gravel is larger than sand and clay is smaller than silt, so the order is gravel, sand, silt, clay."),
    ("silt, clay, gravel, sand","This jumbles the sizes; correct largest-to-smallest is gravel, sand, silt, clay.")]),

 ("SO","A water-holding test shows clayey soil keeps far more water than sandy soil. This is mainly because clay has:",
   "smaller particles with tinier gaps",
   C("Clay's very fine particles pack closely, leaving tiny pores that grip water by surface attraction, so clay holds much more water than coarse sand.")+
   steps("Clay particles are very small","they pack with tiny gaps that hold water tightly","so clayey soil retains far more water than sandy.")+
   U("A clay pot kept moist stays damp for hours because its fine material clings to water."),
   [("larger particles with bigger gaps","Large particles and big gaps describe sand, which drains fast; clay holds water with tiny gaps."),
    ("more gravel mixed into it","Gravel drains quickly and holds little water; clay's water-holding comes from its tiny gaps."),
    ("a much warmer temperature","Temperature is not the cause; clay holds water because of its small particles and tiny pores.")]),

 ("SO","Adding manure or compost to a tired field helps the crops mainly because it restores the soil's:",
   "nutrients and humus",
   C("Manure and compost are rich in decayed organic matter, so they put back the humus and nutrients that repeated cropping has drained from the soil.")+
   steps("Crops remove nutrients from the soil","manure and compost add back decayed organic matter","this restores the soil's humus and nutrients.")+
   U("A farmer spreads cow-dung manure before sowing to renew the field's fertility."),
   [("sand particles","Manure adds organic matter, not sand; it restores the soil's humus and nutrients."),
    ("standing water","Manure does not flood a field; it gives back the nutrients and humus crops use up."),
    ("solid bedrock","Manure cannot make rock; it replenishes the soil's humus and nutrients.")]),
]

# ---------- PERIMETER & AREA (25) — Maths (several fused with Science) ----------
PA = [
 ("PA","The total length of the boundary that goes all the way around a flat closed shape is called its:",
   "perimeter",
   C("Perimeter is the distance once around the outside edge of a closed figure — the sum of all its boundary lengths.")+
   steps("Trace the outer edge of the shape","add up every side you cross","this total boundary length is the perimeter.")+
   U("Buying fencing for a garden means measuring its perimeter to know how much you need."),
   [("area","Area is the surface a shape covers, measured in square units; the boundary length is the perimeter."),
    ("volume","Volume is the space a solid fills; a flat shape's boundary length is its perimeter."),
    ("diameter","Diameter is a line across a circle, not the whole boundary; that total is the perimeter.")]),

 ("PA","The amount of flat surface a closed shape covers, measured in square units, is its:",
   "area",
   C("Area measures how much surface a shape covers and is given in square units such as cm² or m².")+
   steps("Think of how much surface the shape covers","count the square units that fit inside","this surface measure is the area.")+
   U("Tiling a floor needs its area, so you know how many square tiles to buy."),
   [("perimeter","Perimeter is the boundary length, measured in plain units; the surface covered is the area."),
    ("height","Height is just one dimension; the surface a shape covers is its area."),
    ("breadth","Breadth is one side's length; the whole surface covered is the area.")]),

 ("PA","To go once around a rectangle whose length is l and whose breadth is b, the correct formula is:",
   "2 × (l + b)",
   C("A rectangle has two lengths and two breadths, so its perimeter is l + b + l + b = 2 × (l + b).")+
   steps("Add the four sides: l + b + l + b","group them as 2 lengths and 2 breadths","perimeter = 2 × (l + b).")+
   U("To frame a rectangular photo you need 2 × (length + breadth) of moulding."),
   [("l × b","l × b is the AREA of the rectangle; its perimeter is 2 × (l + b)."),
    ("l + b","l + b is only one length plus one breadth; the full boundary is 2 × (l + b)."),
    ("4 × l","4 × l works for a square, where all sides are l; a rectangle's perimeter is 2 × (l + b).")]),

 ("PA","The area of a rectangle whose length is 12 cm and breadth is 5 cm is:",
   "60 cm²",
   C("Area of a rectangle = length × breadth, with the answer in square units.")+
   steps("Length = 12 cm, breadth = 5 cm","area = 12 × 5","= 60 square centimetres.")+
   U("A 12 cm by 5 cm sticker covers 60 cm² of a notebook cover."),
   [("34 cm²","34 cm is the perimeter 2 × (12 + 5); the area is 12 × 5 = 60 cm²."),
    ("17 cm²","17 cm just adds 12 + 5; area is the product 12 × 5 = 60 cm²."),
    ("60 cm","The number is right but area uses square units; it is 60 cm², not 60 cm.")]),

 ("PA","The perimeter of a square whose side measures 9 m is:",
   "36 m",
   C("All four sides of a square are equal, so perimeter = 4 × side.")+
   steps("Side = 9 m","perimeter = 4 × 9","= 36 metres.")+
   U("Fencing a square plot of side 9 m needs 4 × 9 = 36 m of wire."),
   [("81 m","81 is 9 × 9, the AREA in m²; the perimeter is 4 × 9 = 36 m."),
    ("18 m","18 m is only two sides (2 × 9); a square has four sides, so 4 × 9 = 36 m."),
    ("13 m","13 just adds 9 + 4; the perimeter of a square is 4 × side = 36 m.")]),

 ("PA","The area of a square field whose side is 15 m is:",
   "225 m²",
   C("Area of a square = side × side (side²).")+
   steps("Side = 15 m","area = 15 × 15","= 225 square metres.")+
   U("A 15 m by 15 m square lawn covers 225 m² of grass."),
   [("60 m²","60 m is the perimeter 4 × 15; the area is 15 × 15 = 225 m²."),
    ("30 m²","30 just doubles the side; area is side × side = 15 × 15 = 225 m²."),
    ("150 m²","That is 15 × 10; the side is 15, so the area is 15 × 15 = 225 m².")]),

 ("PA","A rectangle and a square have the same perimeter of 40 cm. If the rectangle is 12 cm long, its breadth is:",
   "8 cm",
   C("Use perimeter = 2 × (l + b). Plug in the known perimeter and length, then solve for the breadth.")+
   steps("2 × (12 + b) = 40, so 12 + b = 20","b = 20 − 12","breadth = 8 cm.")+
   U("Knowing a frame's perimeter and one side lets a carpenter work out the missing side."),
   [("28 cm","That forgets to halve; 12 + b = 20, so b = 8 cm, not 28 cm."),
    ("16 cm","That uses perimeter ÷ length wrongly; from 12 + b = 20 the breadth is 8 cm."),
    ("4 cm","That subtracts 12 from 16; half the perimeter is 20, so b = 20 − 12 = 8 cm.")]),

 ("PA","The area of a right triangle is ½ × base × height. A triangle with base 10 cm and height 6 cm has area:",
   "30 cm²",
   C("Area of a triangle = ½ × base × height.")+
   steps("Base = 10 cm, height = 6 cm","area = ½ × 10 × 6","= ½ × 60 = 30 cm².")+
   U("A triangular flag's cloth area is half its base times its height."),
   [("60 cm²","That forgets the ½; a triangle is half the rectangle, so ½ × 10 × 6 = 30 cm²."),
    ("16 cm²","16 just adds 10 + 6; the area is ½ × base × height = 30 cm²."),
    ("30 cm","The value is right but area is in square units; it is 30 cm², not 30 cm.")]),

 ("PA","The area of a parallelogram is base × height. One with base 14 cm and height 5 cm has area:",
   "70 cm²",
   C("Area of a parallelogram = base × height, where the height is measured perpendicular to the base.")+
   steps("Base = 14 cm, height = 5 cm","area = 14 × 5","= 70 cm².")+
   U("The slanted side of a parallelogram-shaped tile does not matter — its area is base × perpendicular height."),
   [("19 cm²","19 just adds 14 + 5; the area is base × height = 14 × 5 = 70 cm²."),
    ("35 cm²","That halves the product as if it were a triangle; a parallelogram is base × height = 70 cm²."),
    ("38 cm²","38 is a perimeter-style sum; the parallelogram's area is 14 × 5 = 70 cm².")]),

 ("PA","A rectangular garden is 20 m by 15 m. A boy runs around its boundary 3 times. The total distance he runs is:",
   "210 m",
   C("Find the perimeter once, then multiply by the number of laps.")+
   steps("Perimeter = 2 × (20 + 15) = 70 m","3 laps = 3 × 70","= 210 metres.")+
   U("A jogger multiplies one lap's perimeter by laps to log the morning's distance."),
   [("70 m","70 m is just one lap; three laps cover 3 × 70 = 210 m."),
    ("105 m","That uses 1.5 laps; three full laps of the 70 m boundary make 210 m."),
    ("900 m","That uses the area 300 m² somehow; three laps of a 70 m perimeter total 210 m.")]),

 ("PA","1 square metre equals how many square centimetres?",
   "10000 cm²",
   C("Since 1 m = 100 cm, a square metre is 100 cm × 100 cm = 10 000 cm².")+
   steps("1 m = 100 cm","1 m² = 100 × 100 cm²","= 10 000 cm².")+
   U("Converting a room's area from m² to cm² to count tiny tiles uses 1 m² = 10 000 cm²."),
   [("100 cm²","That converts only one side; both sides scale, so 1 m² = 100 × 100 = 10 000 cm²."),
    ("1000 cm²","That is the conversion for litres-like factors; 1 m² = 100 × 100 = 10 000 cm²."),
    ("1000000 cm²","That is cubic-style; for area 1 m² = 100 × 100 = 10 000 cm², not a million.")]),

 ("PA","A square and a rectangle have equal areas of 36 cm². If the rectangle is 9 cm long, its breadth is:",
   "4 cm",
   C("Area = length × breadth, so breadth = area ÷ length.")+
   steps("Area = 36 cm², length = 9 cm","breadth = 36 ÷ 9","= 4 cm.")+
   U("Knowing a sheet's area and one side, you divide to find the other side."),
   [("6 cm","6 cm is the side of the equal-area square (√36), not the rectangle's breadth, which is 36 ÷ 9 = 4 cm."),
    ("27 cm","That subtracts 9 from 36; breadth is area ÷ length = 36 ÷ 9 = 4 cm."),
    ("324 cm","That multiplies 36 × 9; breadth is found by dividing, 36 ÷ 9 = 4 cm.")]),

 ("PA","The distance once around a circle is called its circumference, found by π × diameter. With π ≈ 3.14 and diameter 10 cm, it is about:",
   "31.4 cm",
   C("A circle's circumference (its 'perimeter') = π × diameter.")+
   steps("Diameter = 10 cm, π ≈ 3.14","circumference = 3.14 × 10","≈ 31.4 cm.")+
   U("A wheel of diameter 10 cm rolls forward about 31.4 cm in one full turn."),
   [("10 cm","10 cm is the diameter itself; the way round is π × 10 ≈ 31.4 cm."),
    ("62.8 cm","That uses 2 × π × diameter; circumference is π × diameter = 31.4 cm (diameter already, not radius)."),
    ("78.5 cm","78.5 cm² is the area (π r²); the distance around is the circumference ≈ 31.4 cm.")]),

 ("PA","A path of uniform width runs inside a square plot. To find the area of just the path, you:",
   "subtract the inner area from the outer area",
   C("The path is the region between the outer boundary and the inner square, so its area = outer area − inner area.")+
   steps("Find the whole (outer) square's area","find the inner square's area","subtract: path area = outer − inner.")+
   U("Working out how much paving a border path needs uses outer area minus inner area."),
   [("add the inner area to the outer area","Adding double-counts the inside; the path is outer area MINUS inner area."),
    ("multiply the two areas together","Multiplying areas is meaningless here; the path is outer area − inner area."),
    ("divide the outer area by the inner area","Dividing gives a ratio, not the path; subtract inner from outer area.")]),

 ("PA","A rectangular sheet is 8 cm by 6 cm. A square of side 2 cm is cut from one corner. The remaining area is:",
   "44 cm²",
   C("Find the whole rectangle's area, then subtract the area of the square that was removed.")+
   steps("Rectangle = 8 × 6 = 48 cm²","square cut = 2 × 2 = 4 cm²","remaining = 48 − 4 = 44 cm².")+
   U("Cutting a square notch from a rectangular card leaves area = whole minus the notch."),
   [("48 cm²","48 cm² is the full sheet before cutting; subtract the 4 cm² square to get 44 cm²."),
    ("4 cm²","4 cm² is only the piece cut away; the remaining part is 48 − 4 = 44 cm²."),
    ("46 cm²","That subtracts only 2; the square removed is 2 × 2 = 4 cm², leaving 44 cm².")]),

 ("PA","A wire of length 48 cm is bent into a square. The length of each side of the square is:",
   "12 cm",
   C("The wire's length becomes the square's perimeter, so each side = perimeter ÷ 4.")+
   steps("Perimeter = 48 cm (the whole wire)","each side = 48 ÷ 4","= 12 cm.")+
   U("Bending a fixed length of wire into a square, you divide by 4 to get each side."),
   [("24 cm","That divides by 2; a square has four equal sides, so 48 ÷ 4 = 12 cm."),
    ("48 cm","48 cm is the total wire (the perimeter); one side is 48 ÷ 4 = 12 cm."),
    ("144 cm","144 cm² would be the area; each side is perimeter ÷ 4 = 12 cm.")]),

 ("PA","A car wheel of perimeter 2 m makes 100 full turns along a road. The distance the car covers is:",
   "200 m",
   C("In one turn a wheel rolls forward a distance equal to its perimeter (circumference); total distance = perimeter × number of turns. (Motion meets perimeter.)")+
   steps("One turn = 2 m (the wheel's perimeter)","100 turns = 100 × 2","= 200 metres travelled.")+
   U("A bicycle's distance is its wheel circumference times the number of wheel rotations."),
   [("50 m","That divides 100 by 2; distance is perimeter × turns = 2 × 100 = 200 m."),
    ("102 m","That adds 100 + 2; the car covers perimeter × turns = 2 × 100 = 200 m."),
    ("2 m","2 m is only one turn; 100 turns cover 100 × 2 = 200 m.")]),

 ("PA","Two rectangles have the same area of 24 cm². Rectangle P is 6 cm by 4 cm; rectangle Q is 8 cm by 3 cm. Their perimeters are:",
   "different (P: 20 cm, Q: 22 cm)",
   C("Equal areas do not force equal perimeters. Compute each perimeter with 2 × (l + b).")+
   steps("P: 2 × (6 + 4) = 20 cm","Q: 2 × (8 + 3) = 22 cm","areas equal (24 cm²) but perimeters differ.")+
   U("Two plots of the same area can need different amounts of fencing, depending on their shape."),
   [("equal, both 20 cm","Q's perimeter is 2 × (8 + 3) = 22 cm, not 20 cm; same area need not mean same perimeter."),
    ("equal, both 24 cm","24 is the shared area in cm², not a perimeter; P is 20 cm and Q is 22 cm."),
    ("both impossible to find","Both perimeters are easily found: P = 20 cm, Q = 22 cm.")]),

 ("PA","A floor is 4 m long and 3 m wide. Square tiles of side 1 m are used. The number of tiles needed is:",
   "12",
   C("Number of tiles = floor area ÷ area of one tile.")+
   steps("Floor area = 4 × 3 = 12 m²","each tile = 1 × 1 = 1 m²","tiles needed = 12 ÷ 1 = 12.")+
   U("A tiler divides the room's area by one tile's area to count the tiles to buy."),
   [("7","7 just adds 4 + 3; the count is floor area ÷ tile area = 12 ÷ 1 = 12."),
    ("14","14 is the perimeter 2 × (4 + 3); tiles fill the area, needing 12 of them."),
    ("24","That doubles the area; the 12 m² floor needs 12 one-square-metre tiles.")]),

 ("PA","The area of a triangle is 24 cm² and its base is 8 cm. Using area = ½ × base × height, its height is:",
   "6 cm",
   C("Rearrange area = ½ × base × height into height = (2 × area) ÷ base.")+
   steps("2 × area = 2 × 24 = 48","height = 48 ÷ base = 48 ÷ 8","= 6 cm.")+
   U("Knowing a triangular sail's area and base lets you back out its height."),
   [("3 cm","That forgets to double the area; height = (2 × 24) ÷ 8 = 6 cm, not 3 cm."),
    ("16 cm","That uses 2 × area ÷ 6 or similar; with base 8, height = 48 ÷ 8 = 6 cm."),
    ("12 cm","That divides area by 2 (24 ÷ 2); height = (2 × 24) ÷ 8 = 6 cm.")]),

 ("PA","Suppose you double every side of a square tile; compared with the first one, the new area becomes:",
   "four times the original",
   C("Area depends on side², so doubling the side multiplies the area by 2² = 4.")+
   steps("New side = 2 × old side","new area = (2 × side)² = 4 × side²","so the area becomes four times as large.")+
   U("A square tile with sides twice as long covers four times the floor."),
   [("two times the original","Only the perimeter doubles; the area, using side², becomes 2² = 4 times larger."),
    ("the same as before","Changing the side changes the area; doubling the side makes the area four times bigger."),
    ("eight times the original","Eight times suits a cube's volume; a square's area becomes 2² = 4 times larger.")]),

 ("PA","A square room has area 49 m². Walking once around its walls (the perimeter), the distance covered is:",
   "28 m",
   C("First find the side from the area (side = √area), then the perimeter = 4 × side.")+
   steps("Side = √49 = 7 m","perimeter = 4 × 7","= 28 metres.")+
   U("From a square room's floor area you can work out how much skirting runs around it."),
   [("49 m","49 m² is the area, not a length; the side is √49 = 7 m, so the perimeter is 4 × 7 = 28 m."),
    ("14 m","14 m is only two sides; all four give 4 × 7 = 28 m."),
    ("196 m","196 is 4 × 49; first take the side √49 = 7, then perimeter = 4 × 7 = 28 m.")]),

 ("PA","A field is 100 m long and 60 m wide. Manure is spread at 5 kg per 10 m². The manure needed for the whole field is:",
   "3000 kg",
   C("Find the field's area, then scale by the manure rate. (Area meets a Science application.)")+
   steps("Area = 100 × 60 = 6000 m²","rate = 5 kg per 10 m², so per m² = 0.5 kg","manure = 6000 × 0.5 = 3000 kg.")+
   U("A farmer multiplies the field area by the manure-per-square-metre rate to order enough."),
   [("6000 kg","That uses 1 kg per m²; the rate is 5 kg per 10 m² = 0.5 kg/m², giving 3000 kg."),
    ("320 kg","That uses the perimeter 320 m; manure is spread over the area 6000 m², needing 3000 kg."),
    ("600 kg","That uses 1 kg per 10 m²; at 5 kg per 10 m² the field needs 3000 kg.")]),

 ("PA","The perimeter of an equilateral triangle (all sides equal) with each side 7 cm is:",
   "21 cm",
   C("An equilateral triangle has three equal sides, so perimeter = 3 × side.")+
   steps("Each side = 7 cm","perimeter = 3 × 7","= 21 cm.")+
   U("A triangular sign with equal 7 cm sides needs 21 cm of edging."),
   [("14 cm","14 is only two sides; a triangle has three, so 3 × 7 = 21 cm."),
    ("49 cm","49 is 7 × 7, an area-style product; the perimeter is 3 × 7 = 21 cm."),
    ("28 cm","28 = 4 × 7 fits a square; an equilateral triangle has three sides, so 21 cm.")]),

 ("PA","A rectangular plot is 25 m long and 16 m wide. The cost of fencing its boundary at ₹10 per metre is:",
   "₹820",
   C("Fencing follows the perimeter, so find 2 × (l + b) first, then multiply by the rate per metre.")+
   steps("Perimeter = 2 × (25 + 16) = 82 m","cost = 82 × ₹10","= ₹820.")+
   U("A contractor prices boundary fencing as the perimeter times the cost of one metre."),
   [("₹4000","That uses the area 25 × 16 = 400 m²; fencing follows the perimeter, giving 82 × 10 = ₹820."),
    ("₹410","That uses half the perimeter (41 m); the full boundary is 82 m, so the cost is ₹820."),
    ("₹82","₹82 forgets the ₹10 rate; cost = perimeter × rate = 82 × 10 = ₹820.")]),
]

# ---------- ALGEBRAIC EXPRESSIONS (25) — Maths (several fused with Science) ----------
AE = [
 ("AE","In the algebraic term 7x, the number 7 multiplying the variable x is called the:",
   "coefficient",
   C("The numerical factor that multiplies a variable in a term is its coefficient. In 7x, 7 is the coefficient of x.")+
   steps("Look at the number stuck to the variable","in 7x that number is 7","so 7 is the coefficient.")+
   U("Reading a formula like 'cost = 7x', the 7 (the coefficient) is the price of each item x."),
   [("variable","The variable is x, the changing letter; the number multiplying it, 7, is the coefficient."),
    ("constant","A constant stands alone with no variable; in 7x the multiplying number 7 is the coefficient."),
    ("exponent","An exponent is a power, like the 2 in x²; the multiplier 7 in 7x is the coefficient.")]),

 ("AE","A symbol such as x or y that can stand for different number values in algebra is called a:",
   "variable",
   C("A variable is a letter that represents an unknown or changeable number, so its value can vary.")+
   steps("A letter stands in place of a number","its value can change from problem to problem","such a changing symbol is a variable.")+
   U("In 'distance = speed × time', each letter is a variable that can take many values."),
   [("constant","A constant has a fixed value (like 5 or π); a letter whose value can change is a variable."),
    ("coefficient","A coefficient is the number multiplying a variable, not the changing letter itself."),
    ("equation","An equation states two expressions are equal; the changeable letter inside it is a variable.")]),

 ("AE","Terms that have exactly the same variable part, such as 3x and 5x, are called:",
   "like terms",
   C("Like terms share the identical variable part (same letters to the same powers) and can be added or subtracted directly.")+
   steps("Compare the variable parts of the terms","3x and 5x both have just x","matching variable parts make them like terms.")+
   U("Adding 3 apples (3a) and 5 apples (5a) to get 8 apples (8a) is combining like terms."),
   [("unlike terms","Unlike terms have different variable parts (like 3x and 5y); 3x and 5x match, so they are like terms."),
    ("constant terms","Constant terms have no variable at all; 3x and 5x both carry x, making them like terms."),
    ("coefficients","Coefficients are the numbers 3 and 5; the matching x-terms themselves are like terms.")]),

 ("AE","Adding the like terms 4x + 9x gives:",
   "13x",
   C("To add like terms, add their coefficients and keep the same variable.")+
   steps("Coefficients are 4 and 9","4 + 9 = 13, keep the x","so 4x + 9x = 13x.")+
   U("If x is the price of one pen, buying 4 pens then 9 more costs 13x in total."),
   [("13x²","Adding like terms keeps the SAME power; 4x + 9x = 13x, not 13x²."),
    ("36x","36 multiplies 4 and 9; adding like terms adds them: 4 + 9 = 13, giving 13x."),
    ("13","Dropping the x loses the variable; 4x + 9x = 13x.")]),

 ("AE","The value of the expression 2x + 5 when x = 3 is:",
   "11",
   C("Substitute the given value of x and then simplify using order of operations.")+
   steps("Put x = 3: 2 × 3 + 5","= 6 + 5","= 11.")+
   U("A taxi fare '2x + 5' (₹2 per km plus ₹5 base) for a 3 km ride works out to ₹11."),
   [("16","16 adds before multiplying (2 × (3+5)); multiply first: 2 × 3 + 5 = 11."),
    ("10","10 forgets the +5; 2 × 3 + 5 = 6 + 5 = 11."),
    ("13","13 uses x = 4; with x = 3, 2 × 3 + 5 = 11.")]),

 ("AE","An algebraic expression that has exactly two unlike terms, such as 3x + 5, is called a:",
   "binomial",
   C("A binomial is an expression with two unlike terms. (One term is a monomial; three is a trinomial.)")+
   steps("Count the unlike terms in the expression","3x + 5 has two","two terms make it a binomial.")+
   U("A bill written as 'parts cost + fixed fee' (two terms) is a binomial expression."),
   [("monomial","A monomial has just one term, like 3x; an expression with two terms is a binomial."),
    ("trinomial","A trinomial has three terms; 3x + 5 has two, making it a binomial."),
    ("constant","A constant is a single fixed number; 3x + 5 has two terms, so it is a binomial.")]),

 ("AE","Subtracting 5a from 12a gives:",
   "7a",
   C("Subtract like terms by subtracting their coefficients and keeping the variable.")+
   steps("Coefficients: 12 and 5","12 − 5 = 7, keep the a","so 12a − 5a = 7a.")+
   U("Starting with 12 apples (12a) and giving away 5 (5a) leaves 7a apples."),
   [("7","Dropping the variable loses meaning; 12a − 5a = 7a."),
    ("17a","17a adds instead of subtracting; 12a − 5a = 7a."),
    ("7a²","Subtracting like terms keeps the same power; the answer is 7a, not 7a².")]),

 ("AE","A car travels at a steady speed v. The expression for the distance it covers in time t is:",
   "v × t",
   C("Distance = speed × time, so with speed v and time t the distance is the product v × t. (Algebra captures the motion rule.)")+
   steps("Distance = speed × time","speed is v, time is t","so distance = v × t.")+
   U("A formula sheet writes a car's distance as 'd = vt', exactly speed times time."),
   [("v + t","Speed and time are multiplied, not added; distance = v × t."),
    ("v ÷ t","Dividing speed by time is not distance; distance = speed × time = v × t."),
    ("v − t","Subtraction has no meaning here; distance = speed × time = v × t.")]),

 ("AE","A soil sample's percolation lets 8 mL drain each minute. The expression for the water drained in m minutes is:",
   "8m",
   C("If 8 mL drains every minute, then in m minutes the amount is 8 × m = 8m mL. (Soil rate becomes an expression.)")+
   steps("Each minute drains 8 mL","over m minutes multiply: 8 × m","so the water drained is 8m mL.")+
   U("A soil scientist writes the drained volume as a rate times time, here 8m."),
   [("8 + m","The rate is multiplied by the minutes, not added; the amount is 8 × m = 8m."),
    ("m ÷ 8","Dividing reverses the rule; 8 mL per minute over m minutes is 8m mL."),
    ("8 − m","Subtraction makes no sense for an accumulating amount; it is 8m mL.")]),

 ("AE","The perimeter of a square of side x is best written as the expression:",
   "4x",
   C("A square has four equal sides each of length x, so its perimeter is x + x + x + x = 4x. (Algebra meets perimeter.)")+
   steps("Four equal sides, each x","add them: x + x + x + x","= 4x.")+
   U("A formula for fencing a square plot of side x is simply 4x."),
   [("x²","x² is the AREA of the square; its perimeter is 4x."),
    ("2x","2x covers only two sides; a square's four sides give 4x."),
    ("x + 4","The side x is multiplied by 4, not added to 4; the perimeter is 4x.")]),

 ("AE","Simplifying the expression 6x + 2x − 3x gives:",
   "5x",
   C("Combine the like terms by adding and subtracting their coefficients.")+
   steps("Coefficients: 6 + 2 − 3","= 5","keep the x → 5x.")+
   U("Tracking items added and removed (6 + 2 − 3 of the same kind) leaves 5x of them."),
   [("11x","11x forgets to subtract the 3x; 6 + 2 − 3 = 5, giving 5x."),
    ("5x²","Combining like terms keeps the power; 6x + 2x − 3x = 5x, not 5x²."),
    ("5","Dropping the x loses the variable; the result is 5x.")]),

 ("AE","The area of a rectangle with length l and breadth b is written algebraically as:",
   "lb",
   C("Area of a rectangle = length × breadth, written in algebra as l × b, or simply lb. (Algebra meets area.)")+
   steps("Area = length × breadth","length is l, breadth is b","so area = l × b = lb.")+
   U("A spreadsheet formula for a plot's area multiplies its length cell by its breadth cell — lb."),
   [("2(l + b)","2(l + b) is the PERIMETER of the rectangle; its area is l × b = lb."),
    ("l + b","Area multiplies the sides, not adds them; area = lb."),
    ("l − b","Subtracting the sides is meaningless for area; area = length × breadth = lb.")]),

 ("AE","The statement 'a number x increased by 7' is written as the expression:",
   "x + 7",
   C("'Increased by 7' means add 7 to the number, so the expression is x + 7.")+
   steps("Start with the number x","'increased by 7' means add 7","write it as x + 7.")+
   U("If you save x rupees and add 7 more, you now have x + 7 rupees."),
   [("7x","7x means 7 times x, not 7 more than x; 'increased by 7' is x + 7."),
    ("x − 7","x − 7 is 'decreased by 7'; 'increased by 7' is x + 7."),
    ("x ÷ 7","Dividing is not increasing; 'increased by 7' means x + 7.")]),

 ("AE","The value of 5y − 4 when y = 2 is:",
   "6",
   C("Substitute y = 2 and simplify.")+
   steps("Put y = 2: 5 × 2 − 4","= 10 − 4","= 6.")+
   U("A phone plan '5y − 4' evaluated at y = 2 GB gives a charge of 6 units."),
   [("14","14 ignores the minus 4 and adds (5×2+4); it should be 10 − 4 = 6."),
    ("3","3 uses y = 1 (5 − 4 + ...); with y = 2, 5 × 2 − 4 = 6."),
    ("10","10 forgets to subtract 4; 5 × 2 − 4 = 6.")]),

 ("AE","Which of the following is a constant term — a number with no variable attached?",
   "9",
   C("A constant term is a fixed number on its own, with no variable, so its value never changes.")+
   steps("Look for the term with no letter attached","9 stands alone as a number","so 9 is the constant term.")+
   U("In a bill 'rate × units + 9', the 9 is a fixed charge — a constant — that never changes."),
   [("9x","9x carries the variable x, so its value changes with x; a constant has no variable, like 9."),
    ("9y","9y depends on y and is not fixed; the constant term is the bare number 9."),
    ("9x²","9x² varies with x; only a plain number such as 9 is a constant term.")]),

 ("AE","The product of multiplying 3a by 4b is:",
   "12ab",
   C("Multiply the coefficients together and the variables together: 3a × 4b = (3 × 4)(a × b) = 12ab.")+
   steps("Multiply numbers: 3 × 4 = 12","multiply letters: a × b = ab","combine: 12ab.")+
   U("Area of a 3a-by-4b rectangle is 12ab — multiply the number and letter parts separately."),
   [("7ab","7 comes from adding 3 + 4; multiplying gives 3 × 4 = 12, so 12ab."),
    ("12a + b","Multiplying joins the variables as ab, not as a sum; the product is 12ab."),
    ("12a²b²","The powers are not squared; a × b = ab once each, giving 12ab.")]),

 ("AE","A pencil costs ₹x and a pen costs ₹5 more than a pencil. The cost of the pen is written as:",
   "x + 5",
   C("'₹5 more than a pencil' means add 5 to the pencil's cost x, so the pen costs x + 5.")+
   steps("Pencil costs x rupees","the pen is 5 more, so add 5","pen's cost = x + 5.")+
   U("Pricing one item relative to another ('5 more than') is written as the first plus 5."),
   [("5x","5x means five times the pencil's cost, not 5 more than it; that is x + 5."),
    ("x − 5","x − 5 would make the pen cheaper; '5 more' means x + 5."),
    ("5 − x","5 − x reverses things; the pen costing 5 more than x is x + 5.")]),

 ("AE","An expression with only one term, such as 7xy, is called a:",
   "monomial",
   C("A monomial is an algebraic expression made of a single term.")+
   steps("Count the terms in 7xy","there is just one","one term makes it a monomial.")+
   U("A single-rate charge like '7xy' (one term) is a monomial expression."),
   [("binomial","A binomial has two terms; 7xy is a single term, so it is a monomial."),
    ("trinomial","A trinomial has three terms; one term like 7xy is a monomial."),
    ("equation","An equation needs an equals sign; 7xy is a single-term expression, a monomial.")]),

 ("AE","A pendulum's number of swings is given by 30t, where t is the time in minutes. In 4 minutes the number of swings is:",
   "120",
   C("Substitute t = 4 into the expression 30t. (An algebra expression models a Motion & Time situation.)")+
   steps("Expression = 30t, with t = 4","30 × 4","= 120 swings.")+
   U("Counting a pendulum's swings as a rate times minutes lets you predict a total quickly."),
   [("34","34 adds 30 + 4; the rule multiplies: 30 × 4 = 120."),
    ("30","30 is the swings in one minute; in 4 minutes it is 30 × 4 = 120."),
    ("7.5","7.5 divides 30 by 4; the number of swings is 30 × 4 = 120.")]),

 ("AE","Simplifying 8m + 3 − 2m + 5 by combining like terms gives:",
   "6m + 8",
   C("Group the variable terms together and the constant terms together, then combine each group.")+
   steps("Variable terms: 8m − 2m = 6m","constants: 3 + 5 = 8","so the result is 6m + 8.")+
   U("Tidying a bill with item charges and fixed fees groups the like parts — here 6m + 8."),
   [("14m","14m wrongly mixes constants into the variable terms; keep them apart: 6m + 8."),
    ("6m + 2","6m + 2 subtracts the constants (3 − 5 + ...); they add to 8, giving 6m + 8."),
    ("10m + 8","10m adds 8m + 2m; the 2m is subtracted, so 8m − 2m = 6m, giving 6m + 8.")]),

 ("AE","'Twice a number n decreased by 3' is correctly written as:",
   "2n − 3",
   C("'Twice a number' is 2n, and 'decreased by 3' means subtract 3, giving 2n − 3.")+
   steps("Twice the number n is 2n","decreased by 3 means subtract 3","write 2n − 3.")+
   U("A discount rule like 'double the points minus 3' is the expression 2n − 3."),
   [("2n + 3","'Decreased by 3' subtracts, so it is 2n − 3, not 2n + 3."),
    ("n − 3","'Twice the number' is 2n, not n; the expression is 2n − 3."),
    ("3 − 2n","This reverses the subtraction; 'twice n decreased by 3' is 2n − 3.")]),

 ("AE","The total distance covered by walking around a rectangle of length l and breadth b, then evaluated for l = 10, b = 6, is:",
   "32",
   C("The perimeter expression 2(l + b) models the walk; substitute the values. (Algebra + perimeter + a walk.)")+
   steps("Perimeter = 2(l + b)","= 2 × (10 + 6) = 2 × 16","= 32 units.")+
   U("Plugging a plot's length and breadth into 2(l + b) gives the fencing length at once."),
   [("60","60 is l × b, the AREA; the walk is the perimeter 2(10 + 6) = 32."),
    ("16","16 is just l + b; the full boundary is 2 × 16 = 32."),
    ("26","26 forgets to double one pair; 2 × (10 + 6) = 32.")]),

 ("AE","The expression 4x² + 3x − 7 is called a trinomial because it has:",
   "three unlike terms",
   C("A trinomial is an expression with exactly three unlike terms — here 4x², 3x and −7.")+
   steps("Count the separate terms","4x², 3x and −7 make three","three unlike terms make a trinomial.")+
   U("A formula with three different parts (a squared term, a linear term and a constant) is a trinomial."),
   [("only one term","One term would be a monomial; this expression has three terms, a trinomial."),
    ("two like terms","The terms are unlike and there are three of them, not two; it is a trinomial."),
    ("no variables at all","It has the variable x in two terms; with three terms it is a trinomial.")]),

 ("AE","The value of the expression 3(x + 2) when x = 4 is:",
   "18",
   C("Work inside the bracket first, then multiply by the number outside (order of operations).")+
   steps("Inside bracket: x + 2 = 4 + 2 = 6","multiply by 3: 3 × 6","= 18.")+
   U("A rule like '3 times (items plus 2)' evaluated at 4 items gives 18."),
   [("14","14 multiplies only the x (3 × 4) then adds 2; do the bracket first: 3 × 6 = 18."),
    ("9","9 adds 3 + 4 + 2; the rule is 3 × (4 + 2) = 18."),
    ("24","24 uses x = 6; with x = 4, 3 × (4 + 2) = 18.")]),

 ("AE","If 6 identical bricks have a total mass of 6m kg, then the mass of one brick is:",
   "m kg",
   C("Total mass divided equally among the bricks gives one brick's mass: 6m ÷ 6 = m.")+
   steps("Total = 6m kg for 6 bricks","one brick = 6m ÷ 6","= m kg.")+
   U("Splitting a total written as a coefficient times items gives the per-item amount — here m kg."),
   [("6m kg","6m kg is the total for all six bricks; one brick is 6m ÷ 6 = m kg."),
    ("36m kg","36m multiplies instead of dividing; one brick is 6m ÷ 6 = m kg."),
    ("6 kg","6 kg drops the variable; dividing 6m by 6 gives m kg.")]),
]

# ---------- assemble: interleave so no two consecutive share a chapter ----------
assert all(len(b) == 25 for b in (MT, SO, PA, AE)), [len(MT), len(SO), len(PA), len(AE)]
items = []
for i in range(25):
    items += [MT[i], SO[i], PA[i], AE[i]]
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

    keydist = build_paper(PNUM, TITLE, SHORT, LABELS, items, seed=48057,
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
    split = "/".join(str(counts[c]) for c in ("MT", "SO", "PA", "AE"))
    with open("PAPERS_MANIFEST.md", "a", encoding="utf-8") as fh:
        fh.write(f"| {PNUM} | 2026-06-18 | {TITLE} | {split} | ✓ |\n")

    # ---- update QUESTION_INDEX.json ----
    idx["fingerprints"] = sorted(existing | set(new_fps))
    idx.setdefault("combos", []).append({
        "paper": PNUM,
        "chapters": ["Motion & Time",
                     "Soil",
                     "Perimeter & Area",
                     "Algebraic Expressions"],
    })
    idx["papers"] = idx.get("papers", 0) + 1
    with open(idx_path, "w", encoding="utf-8") as fh:
        json.dump(idx, fh, ensure_ascii=False, indent=2)
        fh.write("\n")

    print("Files:", sorted(v for v in moves.values()))
    print("Answer key spread A/B/C/D =", dict(keydist))
