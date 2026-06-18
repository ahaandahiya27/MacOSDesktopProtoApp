# -*- coding: utf-8 -*-
# Boss Challenge Paper 53 — Motion & Time · Acids, Bases & Salts · Data Handling · Comparing Quantities
# Content-only. Uses the dependency-free examfactory engine.
# Difficulty ramp: leans hard into FUSION. A car's speed becomes a RATIO and a
# unit conversion; how-much-faster becomes a PERCENTAGE; a pendulum's swings
# become a RATE; a row of temperatures becomes a MEAN and a RANGE; the acid in a
# bottle becomes a percentage of the whole. The child meets a Science situation
# and reaches for a Maths skill.
# Class-7 scope, simple wording, hard thinking.
# Produces, under Resources/BossChallengePapers/:
#   Paper_53_<SHORT>_QuestionPaper.html  (pure HTML — questions + options)
#   Paper_53_<SHORT>_QuestionPaper.pdf
#   Paper_53_<SHORT>_Questions.md
#   Paper_53_<SHORT>_Solutions.html
import os, sys, shutil, json, re
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from examfactory import build_paper, C, steps, U

PNUM  = "53"
SHORT = "MotionTime_AcidsBases_DataHandling_ComparingQuantities"
TITLE = ("Motion & Time · Acids, Bases & Salts · Data Handling · Comparing Quantities")
LABELS = {
    "MT": "Motion & Time",
    "AB": "Acids, Bases & Salts",
    "DH": "Data Handling",
    "CQ": "Comparing Quantities",
}

# ---------- MOTION & TIME (25) — several fused with ratios/percent/rates ----------
MT = [
 ("MT","A scooter covers a distance of 90 kilometres in exactly 3 hours of steady riding. Its speed is:",
   "30 km/h",
   C("Speed is distance divided by time. Here 90 km / 3 h = 30 km/h — the scooter covers 30 km in each hour.")+
   steps("Speed = distance / time","= 90 km / 3 h","= 30 km/h.")+
   U("A bus timetable's 'average speed' is worked out exactly this way to predict arrival times."),
   [("90 km/h","90 km is the whole distance, not the speed; dividing by the 3 hours gives 30 km/h."),
    ("270 km/h","270 multiplies 90 by 3; speed DIVIDES distance by time, giving 90 / 3 = 30 km/h."),
    ("3 km/h","3 is the number of hours, not the speed; the speed is 90 / 3 = 30 km/h.")]),

 ("MT","When we measure speed as the number of metres travelled for every second of time, the SI unit we are using is the:",
   "metre per second (m/s)",
   C("In the SI system distance is in metres and time in seconds, so speed is measured in metres per second, written m/s.")+
   steps("Distance unit = metre","time unit = second","so speed unit = metre / second = m/s.")+
   U("Scientists report the speed of sound (about 340 m/s) in exactly these SI units."),
   [("kilogram (kg)","Kilogram measures MASS, not speed; the SI unit of speed is metre per second."),
    ("kilometre (km)","Kilometre measures DISTANCE alone; speed needs distance over time, i.e. m/s."),
    ("second (s)","Second measures TIME alone; combining metre and second gives the speed unit m/s.")]),

 ("MT","A toy train that travels the same distance in every equal slice of time is moving with:",
   "uniform motion",
   C("Uniform motion means the speed never changes — equal distances are covered in every equal slice of time.")+
   steps("Equal distances...","...in equal times","means the speed is constant — uniform motion.")+
   U("A train cruising steadily on a long straight track is close to uniform motion."),
   [("non-uniform motion","Non-uniform motion means the distances per equal time are UNEQUAL; equal distances signal uniform motion."),
    ("circular motion","Circular motion describes the PATH's shape, not whether the speed is steady; equal distances per equal time is uniform motion."),
    ("no motion at all","An object covering distance is clearly moving; covering equal distances in equal times is uniform motion.")]),

 ("MT","The time taken by a simple pendulum to complete one full to-and-fro swing is called its:",
   "time period",
   C("One complete to-and-fro swing is a single oscillation. The time it takes is the pendulum's time period.")+
   steps("One full swing = one oscillation","the time for it","is the time period.")+
   U("A pendulum clock is built so its time period is exactly the right fraction of a second to keep time."),
   [("speed","Speed is distance over time; the time for one full swing of a pendulum is its time period."),
    ("frequency","Frequency counts swings PER second; the time for ONE swing is the time period (its reciprocal)."),
    ("amplitude","Amplitude is how FAR the bob swings sideways, not how long a swing takes; that is the time period.")]),

 ("MT","Built into a car's dashboard, the instrument that records the total distance the vehicle has travelled is the:",
   "odometer",
   C("An odometer counts up the total kilometres a vehicle has covered over its life — distance, not speed.")+
   steps("'Odo' relates to distance covered","the dashboard counter of total km","is the odometer.")+
   U("When buying a used car people check the odometer to see how far it has already been driven."),
   [("speedometer","A speedometer shows the CURRENT speed, not the total distance; that running total is the odometer."),
    ("thermometer","A thermometer measures temperature, not distance; the distance counter is the odometer."),
    ("barometer","A barometer measures air pressure; the total-distance dial in a car is the odometer.")]),

 ("MT","On a distance-time graph, a straight slanting line rising steadily to the right represents an object moving with:",
   "uniform (constant) speed",
   C("A straight slanting line means distance increases by the same amount in each equal time step — a steady, unchanging speed.")+
   steps("Equal rise for equal run along the line","means equal distance per equal time","so the speed is uniform.")+
   U("A delivery van keeping a steady speed on a highway traces a straight line on such a graph."),
   [("zero speed","Zero speed would be a FLAT horizontal line; a rising slanting line shows the object is moving steadily."),
    ("increasing speed","Increasing speed makes the line CURVE upward more steeply; a straight line means a constant speed."),
    ("backward motion","A line rising to the right shows distance increasing, i.e. forward steady motion, not backward.")]),

 ("MT","On a distance-time graph, a flat horizontal line over a stretch of time means that during that time the object is:",
   "at rest (not moving)",
   C("If the line is flat, the distance is not changing as time passes — the object stays in one place, at rest.")+
   steps("Time moves on but distance stays the same","no distance is covered","so the object is at rest.")+
   U("A car waiting at a red light traces a flat line on a distance-time graph until it moves off."),
   [("moving fastest","Fastest motion gives the STEEPEST rising line, not a flat one; a flat line means no movement."),
    ("moving at uniform speed","Uniform speed is a slanting straight line; a FLAT line means the distance is not changing — at rest."),
    ("speeding up","Speeding up curves the line upward; a flat line shows the object is standing still.")]),

 ("MT","A train moves at 36 kilometres per hour. Converted into metres per second, this speed is:",
   "10 m/s",
   C("To change km/h to m/s, divide by 3.6 (since 1 km/h = 1000 m / 3600 s). So 36 / 3.6 = 10 m/s.")+
   steps("1 km/h = 1000 m / 3600 s","36 km/h = 36 / 3.6","= 10 m/s.")+
   U("Engineers convert vehicle speeds to m/s before using them in physics formulas."),
   [("36 m/s","36 is the speed in km/h; converting to m/s means dividing by 3.6, giving 10 m/s."),
    ("100 m/s","100 multiplies instead of dividing by 3.6; the correct conversion is 36 / 3.6 = 10 m/s."),
    ("3.6 m/s","3.6 is the conversion factor itself, not the answer; 36 / 3.6 = 10 m/s.")]),

 ("MT","Over a whole journey a bus covers 150 kilometres in 5 hours, including its halts. Its average speed is:",
   "30 km/h",
   C("Average speed uses the TOTAL distance over the TOTAL time, halts included: 150 km / 5 h = 30 km/h.")+
   steps("Average speed = total distance / total time","= 150 km / 5 h","= 30 km/h.")+
   U("Journey planners quote an average speed so you can estimate arrival even with stops along the way."),
   [("150 km/h","150 km is the whole distance; the average speed divides it by the 5 hours, giving 30 km/h."),
    ("5 km/h","5 is the time in hours, not the speed; average speed is 150 / 5 = 30 km/h."),
    ("750 km/h","750 multiplies distance by time; average speed DIVIDES, giving 150 / 5 = 30 km/h.")]),

 ("MT","After lightning we see the flash almost at once but hear the thunder later. This is because, compared with sound, light travels:",
   "very much faster",
   C("Light travels enormously faster than sound, so the flash reaches us almost instantly while the thunder lags behind.")+
   steps("Light speed is far greater than sound speed","so the flash arrives first","and the thunder is heard later.")+
   U("Counting seconds between a flash and its thunder tells you roughly how far away a storm is."),
   [("at the same speed","If they were equally fast we would see and hear them together; light is far faster, so the flash comes first."),
    ("much slower","Light is FASTER than sound, not slower; that is why the flash is seen before the thunder is heard."),
    ("only as fast as a fast car","Light is vastly faster than any car; its great speed is why the flash beats the thunder.")]),

 ("MT","Car P moves at 60 km/h and car Q at 40 km/h along the same road. The ratio of the speed of P to that of Q is:",
   "3 : 2",
   C("A ratio compares the two speeds: 60 : 40. Dividing both by 20 simplifies it to 3 : 2.")+
   steps("Write 60 : 40","divide both by 20","= 3 : 2.")+
   U("Comparing two vehicles' speeds as a ratio shows at a glance how much quicker one is."),
   [("2 : 3","2 : 3 is reversed; P is the FASTER car, so P : Q must be the larger-first ratio 3 : 2."),
    ("60 : 40","60 : 40 is correct but not SIMPLIFIED; dividing both by 20 gives 3 : 2."),
    ("3 : 1","3 : 1 over-simplifies; 60 : 40 reduces to 3 : 2, not 3 : 1.")]),

 ("MT","A cyclist plans to cover 150 km at a steady speed of 50 km/h. The time the journey will take is:",
   "3 hours",
   C("Time equals distance divided by speed: 150 km / 50 km/h = 3 hours.")+
   steps("Time = distance / speed","= 150 km / 50 km/h","= 3 hours.")+
   U("This is the calculation a navigation app does to tell you your arrival time."),
   [("3 minutes","The units are hours, not minutes; 150 / 50 = 3 HOURS at this speed."),
    ("50 hours","50 is the speed, not the time; time is 150 / 50 = 3 hours."),
    ("100 hours","100 wrongly subtracts (150 - 50); time DIVIDES distance by speed, giving 3 hours.")]),

 ("MT","A pendulum is timed making 30 complete oscillations in 60 seconds. The time period of the pendulum is:",
   "2 seconds",
   C("Time period is the time for ONE oscillation: total time divided by number of swings, 60 s / 30 = 2 s.")+
   steps("Time period = total time / number of swings","= 60 s / 30","= 2 seconds.")+
   U("Clockmakers time many swings and divide, getting an accurate time period for the pendulum."),
   [("30 seconds","30 is the NUMBER of swings, not the time for one; 60 / 30 = 2 seconds per swing."),
    ("60 seconds","60 s is for ALL 30 swings; one swing takes 60 / 30 = 2 seconds."),
    ("0.5 seconds","0.5 divides 30 by 60 the wrong way; time period is 60 / 30 = 2 seconds.")]),

 ("MT","Two runners start together; after 10 seconds the one who is now farther ahead must have the greater:",
   "speed",
   C("In the same time, the runner covering more distance is moving faster — greater distance in equal time means greater speed.")+
   steps("Same starting time, same elapsed 10 s","one covers more distance","so that runner has the greater speed.")+
   U("A finish-line photo shows the faster sprinter ahead — more distance in the same race time."),
   [("mass","Being ahead shows speed, not mass; a heavier runner is not automatically farther ahead."),
    ("time period","Time period belongs to a pendulum's swing, not a runner; covering more distance shows greater speed."),
    ("temperature","A runner's temperature does not decide who is ahead; covering more ground in the same time means more speed.")]),

 ("MT","In the SI system, the basic unit used to measure an interval of time is the:",
   "second",
   C("The second is the SI base unit of time. Larger units like the minute and hour are built from it.")+
   steps("SI base unit of time","is the second","with minutes and hours made from it.")+
   U("Stopwatches and lab timers read in seconds, the SI unit of time."),
   [("hour","An hour is a larger time unit made of 3600 seconds; the SI BASE unit is the second."),
    ("metre","The metre measures DISTANCE, not time; the SI unit of time is the second."),
    ("minute","A minute is 60 seconds — a multiple of the base unit; the SI base unit itself is the second.")]),

 ("MT","A bus runs at a steady speed of 60 km/h. In 30 minutes (half an hour) it will cover a distance of:",
   "30 km",
   C("Distance = speed x time. Half an hour is 0.5 h, so 60 km/h x 0.5 h = 30 km.")+
   steps("Distance = speed x time","= 60 km/h x 0.5 h","= 30 km.")+
   U("Knowing speed and time, you can predict how far you will get before a planned stop."),
   [("60 km","60 km is the distance in a FULL hour; in half an hour the bus covers half that, 30 km."),
    ("120 km","120 km doubles the time; in HALF an hour at 60 km/h the bus covers 30 km."),
    ("15 km","15 km halves too far; 60 km/h for 0.5 h gives 30 km, not 15 km.")]),

 ("MT","A car that keeps speeding up, slowing at signals and stopping shows a constantly changing speed. This kind of motion is called:",
   "non-uniform motion",
   C("When the speed keeps changing — unequal distances in equal times — the motion is non-uniform.")+
   steps("Speed changes from moment to moment","unequal distances in equal times","so the motion is non-uniform.")+
   U("Driving through a busy city is non-uniform motion: stop, start, speed up, slow down."),
   [("uniform motion","Uniform motion needs a STEADY speed; a car that keeps changing speed shows non-uniform motion."),
    ("rest","A moving car is not at rest; its changing speed makes the motion non-uniform."),
    ("circular motion","Circular motion is about a curved PATH, not changing speed; varying speed is non-uniform motion.")]),

 ("MT","The needle of a vehicle's speedometer points to a number whose usual unit, printed on the dial, is:",
   "km/h (kilometres per hour)",
   C("A speedometer shows speed, normally in kilometres per hour (km/h), so the driver knows how fast the vehicle is going.")+
   steps("Speedometer shows speed","speed is distance over time","commonly read in km/h on the dial.")+
   U("Speed-limit signs are also given in km/h to match the speedometer."),
   [("kilometres (km)","Kilometres alone measure DISTANCE; a speedometer shows speed, in km/h."),
    ("hours (h)","Hours alone measure TIME; the speedometer combines distance and time as km/h."),
    ("litres (L)","Litres measure fuel volume, shown on the FUEL gauge; the speedometer reads km/h.")]),

 ("MT","On one distance-time graph two straight lines are drawn for two objects. The steeper line belongs to the object that is moving:",
   "faster",
   C("A steeper line means more distance is covered in the same time, so that object has the greater speed — it is faster.")+
   steps("Steeper slope = more distance per unit time","more distance per time = greater speed","so the steeper line is the faster object.")+
   U("On a race graph the winner's line climbs more steeply, showing the higher speed."),
   [("slower","A slower object covers less distance per time, giving a LESS steep line; the steeper line is faster."),
    ("at rest","An object at rest has a FLAT line; a steep line means fast motion, not rest."),
    ("heavier","Steepness shows speed, not weight; the steeper line simply means the faster object.")]),

 ("MT","Bike A travels at 50 km/h while bike B travels at 40 km/h. Bike A is faster than bike B by a percentage of:",
   "25%",
   C("The extra speed is 50 - 40 = 10 km/h. As a percentage of B's 40 km/h: (10 / 40) x 100 = 25%.")+
   steps("Extra speed = 50 - 40 = 10 km/h","percent = (10 / 40) x 100","= 25%.")+
   U("Adverts say one model is '25% faster' using exactly this comparison."),
   [("10%","10 km/h is the extra SPEED, not the percentage; as a fraction of 40 it is (10/40) x 100 = 25%."),
    ("20%","20% would compare the 10 with 50, but 'faster than B' compares with B's 40, giving 25%."),
    ("80%","80% compares 40 with 50 the wrong way; A is faster than B by (10/40) x 100 = 25%.")]),

 ("MT","A boy walks the 1.5 km from home to school in 30 minutes (half an hour). His walking speed is:",
   "3 km/h",
   C("Speed = distance / time. Half an hour is 0.5 h, so 1.5 km / 0.5 h = 3 km/h.")+
   steps("Speed = distance / time","= 1.5 km / 0.5 h","= 3 km/h.")+
   U("A fitness app turns your walk's distance and time into a speed just like this."),
   [("1.5 km/h","1.5 km is the DISTANCE, not the speed; dividing by 0.5 h gives 3 km/h."),
    ("0.75 km/h","0.75 divides distance by 2 instead of by 0.5; 1.5 / 0.5 = 3 km/h."),
    ("30 km/h","30 is the time in minutes, not the speed; the speed is 1.5 / 0.5 = 3 km/h.")]),

 ("MT","Among a sundial, a sand-clock and a modern quartz wristwatch, the device that keeps time most accurately is the:",
   "quartz wristwatch",
   C("A quartz watch uses the steady vibrations of a quartz crystal, making it far more precise than a sundial or sand-clock.")+
   steps("Sundials need sunshine; sand-clocks drift","a quartz crystal vibrates very steadily","so the quartz watch is the most accurate.")+
   U("Almost every modern clock and phone keeps time with a quartz crystal."),
   [("sundial","A sundial fails at night and on cloudy days and is only roughly marked; quartz is far more accurate."),
    ("sand-clock","A sand-clock measures only a fixed short interval and runs unevenly; the quartz watch is more accurate."),
    ("all are equally accurate","They differ greatly: the quartz crystal's steady vibration makes the wristwatch the most accurate.")]),

 ("MT","The slope (steepness) of a straight line on a distance-time graph directly tells us the object's:",
   "speed",
   C("Slope is rise over run — distance covered divided by time taken — which is exactly the definition of speed.")+
   steps("Slope = distance (rise) / time (run)","that equals distance / time","which is the speed.")+
   U("Reading a graph's slope is a quick way to find a moving object's speed without a separate calculation."),
   [("mass","Mass cannot be read from a distance-time graph; the slope gives the speed."),
    ("temperature","Temperature is unrelated to a distance-time graph; its slope shows the speed."),
    ("starting position","The starting position is where the line BEGINS on the axis; the slope itself gives the speed.")]),

 ("MT","A motorbike covers 240 km in 4 hours at a steady pace. Its speed is:",
   "60 km/h",
   C("Speed = distance / time = 240 km / 4 h = 60 km/h.")+
   steps("Speed = distance / time","= 240 km / 4 h","= 60 km/h.")+
   U("Highway journey times are estimated by dividing the distance by a steady speed like this."),
   [("240 km/h","240 km is the whole distance; dividing by the 4 hours gives 60 km/h."),
    ("4 km/h","4 is the number of hours, not the speed; speed is 240 / 4 = 60 km/h."),
    ("960 km/h","960 multiplies distance by time; speed DIVIDES, giving 240 / 4 = 60 km/h.")]),

 ("MT","A pendulum's time period is 2 seconds. The number of complete oscillations it makes in 1 minute is:",
   "30",
   C("One minute is 60 seconds. With 2 seconds per swing, the number of swings is 60 / 2 = 30.")+
   steps("1 minute = 60 seconds","number of swings = 60 / 2","= 30 oscillations.")+
   U("Counting a clock pendulum's swings in a minute is a quick check that it is keeping time."),
   [("60","60 is the number of SECONDS in a minute, not the swings; 60 / 2 = 30 swings."),
    ("2","2 is the seconds per swing, not the count in a minute; that count is 60 / 2 = 30."),
    ("120","120 multiplies 60 by 2; the number of 2-second swings in 60 s is 60 / 2 = 30.")]),
]

# ---------- ACIDS, BASES & SALTS (25) — several fused with ratios/counts ----------
AB = [
 ("AB","A drop of lemon juice is placed on moist blue litmus paper. Because lemon juice is acidic, the paper turns:",
   "red",
   C("Acids turn blue litmus red. Lemon juice is acidic, so it changes the blue paper to red.")+
   steps("Lemon juice is acidic","acids turn blue litmus red","so the paper turns red.")+
   U("A simple litmus test in the kitchen shows lemon, vinegar and tamarind are all acids."),
   [("blue (no change)","Blue litmus only stays blue in a base or neutral liquid; an ACID like lemon turns it red."),
    ("green","Litmus has no green stage; in acid the blue paper turns red."),
    ("colourless","Litmus does not lose its colour; in an acid the blue paper turns red.")]),

 ("AB","Soap solution is rubbed onto red litmus paper. Being basic, the soap turns the red litmus:",
   "blue",
   C("Bases turn red litmus blue. Soap solution is basic, so it changes the red paper to blue.")+
   steps("Soap solution is basic","bases turn red litmus blue","so the paper turns blue.")+
   U("Testing soap and lime water with red litmus shows they are bases — they turn it blue."),
   [("red (no change)","Red litmus stays red only in acid or neutral liquids; a BASE like soap turns it blue."),
    ("yellow","Litmus has no yellow stage; in a base the red paper turns blue."),
    ("black","Litmus does not turn black; in a base the red paper turns blue.")]),

 ("AB","Tamarind, lemon and unripe mango all share a sharp sour taste because each of them contains a(n):",
   "acid",
   C("A sour taste is the signature of an acid. These foods are sour because they contain natural acids.")+
   steps("Sour taste is typical of acids","tamarind, lemon and mango taste sour","so they contain acids.")+
   U("Cooks add a sour, acidic ingredient like lemon or tamarind to balance a dish."),
   [("base","Bases taste BITTER and feel soapy, not sour; the sour taste comes from acids."),
    ("salt","An ordinary salt tastes salty, not sour; the sour taste is due to acids."),
    ("metal","Metals are not a taste; the sour flavour of these fruits comes from the acids in them.")]),

 ("AB","Baking soda solution and soap feel slippery and taste bitter. These properties are typical of substances that are:",
   "basic (alkaline)",
   C("Bases taste bitter and feel soapy or slippery. Baking soda solution and soap show both these signs of a base.")+
   steps("Bitter taste and soapy feel","are typical of bases","so these substances are basic.")+
   U("The slippery feel of soap on wet hands is a everyday sign that soap is basic."),
   [("acidic","Acids taste SOUR, not bitter, and are not soapy; a bitter, slippery feel marks a base."),
    ("neutral","Neutral substances like pure water have no strong taste or soapy feel; bitterness signals a base."),
    ("metallic","'Metallic' is not an acid-base class; the bitter, soapy properties mean the substance is basic.")]),

 ("AB","If an acid and a base are combined in just the right amounts, they cancel out to give salt and water. This is called:",
   "neutralisation",
   C("In neutralisation an acid and a base react to form a salt and water, cancelling each other's properties.")+
   steps("Acid + base react together","they form salt + water","this cancelling is neutralisation.")+
   U("An antacid neutralises stomach acid — a neutralisation reaction relieving acidity."),
   [("evaporation","Evaporation is water turning to vapour; an acid and base reacting to form salt and water is neutralisation."),
    ("dispersion","Dispersion splits white light into colours; it has nothing to do with acids and bases reacting."),
    ("condensation","Condensation is vapour turning to liquid; the acid-base reaction forming salt and water is neutralisation.")]),

 ("AB","A few drops of turmeric solution are added to soap water and the yellow turmeric turns red. This colour change shows the soap water is:",
   "basic",
   C("Turmeric is a natural indicator: it stays yellow in acid but turns red in a base. Turning red shows the soap water is basic.")+
   steps("Turmeric is yellow in acid","it turns red in a base","red here means the soap water is basic.")+
   U("A turmeric stain on cloth turns red where soap (a base) is rubbed on it."),
   [("acidic","In an acid turmeric stays YELLOW; turning red shows the liquid is basic, not acidic."),
    ("neutral","A neutral liquid leaves turmeric yellow; the red colour means the soap water is basic."),
    ("salty","Saltiness is a taste, not an indicator result; the red turmeric shows a base.")]),

 ("AB","The general name for a substance whose colour change is used to tell whether a liquid is acidic or basic is a(n):",
   "indicator",
   C("An indicator changes colour in acids and bases, so its colour reveals which kind the liquid is. Litmus and turmeric are examples.")+
   steps("It changes colour in acid vs base","the colour reveals the nature of the liquid","such a substance is an indicator.")+
   U("Litmus, turmeric and China rose are all indicators used to test liquids at home or in the lab."),
   [("solvent","A solvent dissolves things; an INDICATOR is what changes colour to reveal acid or base."),
    ("catalyst","A catalyst speeds a reaction without being used up; the colour-changing tester is an indicator."),
    ("salt","A salt is the product of neutralisation; the colour-change tester is called an indicator.")]),

 ("AB","Phenolphthalein is colourless in acids but turns bright pink in a base. When added to lime water it turns:",
   "pink",
   C("Lime water is a base, and phenolphthalein turns pink in bases, so the lime water becomes pink.")+
   steps("Lime water is basic","phenolphthalein turns pink in a base","so the liquid turns pink.")+
   U("Phenolphthalein's pink colour is used in labs to spot when a liquid has become basic."),
   [("colourless","Phenolphthalein is colourless only in acid or neutral liquids; in the basic lime water it turns pink."),
    ("red","Phenolphthalein's base colour is PINK, not red; lime water turns it pink."),
    ("blue","Phenolphthalein does not turn blue; in a base such as lime water it turns pink.")]),

 ("AB","Curd and yogurt taste slightly sour because, as milk sets, helpful bacteria produce a substance called:",
   "lactic acid",
   C("Bacteria in setting milk make lactic acid, an acid, which gives curd and yogurt their tangy, sour taste.")+
   steps("Bacteria act on the milk","they produce lactic acid","whose sourness flavours the curd.")+
   U("The same souring by lactic-acid bacteria is used to make cheese and pickles."),
   [("citric acid","Citric acid is found in citrus FRUITS; the souring of curd is due to lactic acid."),
    ("a base","A base would taste bitter, not sour; curd is sour because of lactic ACID."),
    ("common salt","Salt makes things salty, not sour; the sour taste of curd comes from lactic acid.")]),

 ("AB","The acid that gives vinegar its sharp sour smell and taste is:",
   "acetic acid",
   C("Vinegar is a dilute solution of acetic acid, which gives it the characteristic sour smell and taste.")+
   steps("Vinegar smells and tastes sour","that comes from its acid","which is acetic acid.")+
   U("Cooks use vinegar's acetic acid to add a sour tang and to help preserve food."),
   [("lactic acid","Lactic acid is found in CURD; vinegar's sourness comes from acetic acid."),
    ("hydrochloric acid","Hydrochloric acid is a strong lab and stomach acid, not the food acid in vinegar, which is acetic acid."),
    ("citric acid","Citric acid is in citrus fruits; vinegar contains acetic acid.")]),

 ("AB","After a heavy meal a person feels acidity in the stomach and takes an antacid tablet. The antacid relieves the discomfort because it is:",
   "a base that neutralises the excess acid",
   C("Antacids are mild bases. They neutralise the extra acid in the stomach, cancelling the acidity and easing the discomfort.")+
   steps("The stomach has excess acid","the antacid is a base","it neutralises the acid, relieving acidity.")+
   U("Milk of magnesia, a common antacid, is a base taken to settle an acidic stomach."),
   [("an acid that adds more acid","Adding more acid would worsen acidity; an antacid is a BASE that neutralises the acid."),
    ("a salt that has no effect","An antacid does have an effect — as a base it neutralises stomach acid."),
    ("a sugar that coats the stomach","Antacids work by NEUTRALISING acid as bases, not by being sugar.")]),

 ("AB","An ant's sting injects formic acid, causing a burning feeling. Rubbing the spot with baking soda helps because baking soda is:",
   "basic, so it neutralises the acid",
   C("Baking soda is a mild base. It neutralises the acidic sting, cancelling the acid and soothing the burning.")+
   steps("The sting is acidic (formic acid)","baking soda is a base","it neutralises the acid and soothes the spot.")+
   U("People dab baking soda paste on insect stings to neutralise the acid and ease the pain."),
   [("acidic, so it adds more acid","Adding acid to an acidic sting would not soothe it; baking soda is a BASE that neutralises."),
    ("a salt that washes it away","Baking soda soothes by NEUTRALISING the acid as a base, not by washing it off."),
    ("neutral, so it does nothing","Baking soda is not neutral — it is a base that neutralises the sting's acid.")]),

 ("AB","Common salt (sodium chloride) dissolved in water is tested with both blue and red litmus. The solution turns the litmus:",
   "neither colour — it is neutral",
   C("A salt-water solution of common salt is neutral. It changes neither blue nor red litmus, showing it is neither acidic nor basic.")+
   steps("Common salt solution is neutral","neutral liquids do not change litmus","so neither paper changes colour.")+
   U("Plain salt water and pure water both leave litmus unchanged because they are neutral."),
   [("blue litmus red, because it is acidic","Salt water is NEUTRAL, not acidic; it leaves both litmus papers unchanged."),
    ("red litmus blue, because it is basic","Common salt solution is neutral, not basic; neither paper changes colour."),
    ("both papers green","Litmus has no green stage; a neutral salt solution leaves both papers unchanged.")]),

 ("AB","Hydrochloric acid is exactly neutralised by sodium hydroxide. Apart from water, the product formed is the salt:",
   "sodium chloride (common salt)",
   C("Acid + base -> salt + water. Hydrochloric acid and sodium hydroxide give sodium chloride (common salt) plus water.")+
   steps("HCl (acid) + NaOH (base)","-> salt + water","the salt is sodium chloride, common salt.")+
   U("This very reaction is one way table salt can be made in the laboratory."),
   [("sugar","Sugar is not a product of an acid-base reaction; HCl and NaOH give the salt sodium chloride."),
    ("more hydrochloric acid","The acid is USED UP in neutralisation; the product is the salt sodium chloride plus water."),
    ("vinegar","Vinegar is acetic acid, unrelated here; HCl and NaOH form sodium chloride and water.")]),

 ("AB","A farmer finds a field too acidic for crops. To reduce the acidity, the soil is commonly treated by adding:",
   "lime (a base)",
   C("Lime is a base. Spread on acidic soil it neutralises the excess acid, bringing the soil closer to neutral for healthy crops.")+
   steps("The soil is too acidic","lime is a base","it neutralises the acid, balancing the soil.")+
   U("Farmers spread lime on sour fields each season to keep the soil good for crops."),
   [("vinegar (an acid)","Adding an acid like vinegar would make acidic soil WORSE; a base such as lime is needed."),
    ("common salt","Common salt is neutral and would not cancel the acid; a base such as lime neutralises it."),
    ("more acid fertiliser","More acid increases acidity; the cure for acidic soil is a base such as lime.")]),

 ("AB","Lime water, used to test for carbon dioxide, turns red litmus blue. This tells us that lime water is:",
   "basic",
   C("Turning red litmus blue is the test for a base. So lime water, which does this, is basic.")+
   steps("Lime water turns red litmus blue","that colour change marks a base","so lime water is basic.")+
   U("Blowing through a straw into lime water turns it milky — the same basic lime water that tests for CO2."),
   [("acidic","Acids turn BLUE litmus red, the opposite test; turning red litmus blue shows lime water is basic."),
    ("neutral","A neutral liquid would not change litmus at all; lime water turns red litmus blue, so it is basic."),
    ("salty","Saltiness is a taste, not a litmus result; turning red litmus blue shows lime water is basic.")]),

 ("AB","Oranges, lemons and other citrus fruits get their tangy sourness mainly from:",
   "citric acid",
   C("Citrus fruits contain citric acid, an acid that gives them their characteristic tangy, sour flavour.")+
   steps("Citrus fruits taste sour","the sourness is from an acid","that acid is citric acid.")+
   U("Citric acid from lemons is also used as a natural cleaning agent and food flavour."),
   [("lactic acid","Lactic acid is in curd and yogurt; citrus fruits get their sourness from citric acid."),
    ("acetic acid","Acetic acid is the acid of vinegar; citrus fruits contain citric acid."),
    ("a base","Bases are bitter, not sour; the tang of citrus fruit comes from citric acid.")]),

 ("AB","A factory's waste water is found to be strongly acidic. Before releasing it into a river, the factory must first treat it with a base in order to:",
   "neutralise it",
   C("Adding a base neutralises the acidic waste, cancelling the acid so the water is safe and does not harm river life.")+
   steps("The waste is strongly acidic","a base is added","it neutralises the acid, making the water safe.")+
   U("Treatment plants neutralise acidic industrial waste before it ever reaches a river."),
   [("make it more acidic","Releasing more acid would harm the river; the base is added to NEUTRALISE the acid."),
    ("colour it blue","The aim is to remove the harmful acidity by neutralising, not to colour the water."),
    ("make it taste sweet","Treating the waste is about safety through neutralisation, not changing its taste.")]),

 ("AB","A liquid is tested and changes the colour of neither blue litmus nor red litmus. The liquid must therefore be:",
   "neutral",
   C("Only a neutral liquid leaves BOTH litmus papers unchanged — it is neither acidic (would redden blue) nor basic (would blue red).")+
   steps("No change to blue litmus -> not acidic","no change to red litmus -> not basic","so the liquid is neutral.")+
   U("Pure water passes this test: it is neutral and changes neither litmus paper."),
   [("strongly acidic","A strong acid would turn blue litmus red; since neither paper changes, the liquid is neutral."),
    ("strongly basic","A strong base would turn red litmus blue; no change at all means the liquid is neutral."),
    ("both acidic and basic","A liquid cannot be both at once; changing neither litmus means it is neutral.")]),

 ("AB","Window-cleaning ammonia solution feels soapy and turns turmeric paper red. On the acid-base scale, ammonia solution is:",
   "basic",
   C("A soapy feel and turning turmeric red are both signs of a base, so ammonia solution is basic.")+
   steps("Soapy feel is typical of bases","turmeric turns red in a base","so ammonia solution is basic.")+
   U("Many household cleaners are basic, which is why they feel soapy and clean grease well."),
   [("acidic","Acids are not soapy and leave turmeric YELLOW; the soapy feel and red turmeric show ammonia is basic."),
    ("neutral","A neutral liquid would not feel soapy or turn turmeric red; ammonia solution is basic."),
    ("a salt","A salt solution is usually neutral; the soapy feel and red turmeric mark ammonia as basic.")]),

 ("AB","In a neutralisation, 30 mL of an acid is exactly cancelled by 30 mL of a base of the same strength. The volume ratio of acid to base used is:",
   "1 : 1",
   C("Equal volumes of 30 mL and 30 mL react. The ratio 30 : 30 simplifies to 1 : 1.")+
   steps("Acid : base = 30 mL : 30 mL","divide both by 30","= 1 : 1.")+
   U("Chemists record the exact ratio of acid to base that neutralises, to repeat the reaction accurately."),
   [("2 : 1","2 : 1 would mean twice as much acid; here the volumes are EQUAL, giving 1 : 1."),
    ("1 : 2","1 : 2 would mean twice as much base; the equal 30 mL volumes give 1 : 1."),
    ("30 : 1","30 : 1 keeps one volume but drops the other; 30 mL : 30 mL is simply 1 : 1.")]),

 ("AB","Toothpaste is slightly basic. Brushing the teeth with it is helpful chiefly because the toothpaste:",
   "neutralises the acid made by bacteria in the mouth",
   C("Bacteria in the mouth produce acid that attacks teeth. Basic toothpaste neutralises that acid, protecting the enamel.")+
   steps("Mouth bacteria make acid","toothpaste is basic","it neutralises the acid and protects the teeth.")+
   U("Dentists advise brushing after meals so the basic paste neutralises food acids quickly."),
   [("adds more acid to the teeth","More acid would harm the teeth; basic toothpaste NEUTRALISES the mouth's acid."),
    ("makes the mouth strongly acidic","Toothpaste is basic and neutralises acid; it does not acidify the mouth."),
    ("has no effect on mouth acid","Being basic, toothpaste does act on mouth acid — it neutralises it.")]),

 ("AB","A gardener tests rainwater that has turned slightly acidic. Compared with neutral water, this acidic rainwater will turn blue litmus:",
   "red",
   C("Any acid turns blue litmus red. Slightly acidic rainwater, being an acid, reddens blue litmus (faintly), unlike neutral water which leaves it blue.")+
   steps("Acidic rainwater is an acid","acids turn blue litmus red","so the blue paper turns red.")+
   U("Scientists test rainwater with litmus to watch for acid rain harming plants and buildings."),
   [("blue (unchanged)","Blue litmus stays blue only in neutral or basic liquids; an ACID turns it red."),
    ("green","Litmus has no green stage; acidic rainwater turns blue litmus red."),
    ("white","Litmus does not turn white; in an acid the blue paper turns red.")]),

 ("AB","China rose petals soaked in water make a natural indicator that turns dark pink in acids and green in:",
   "bases",
   C("China rose indicator turns dark pink with acids and green with bases, so the green colour tells you the liquid is a base.")+
   steps("China rose -> dark pink in acid","China rose -> green in a base","so green means a base.")+
   U("China rose extract is an easy home-made indicator for telling acids from bases."),
   [("acids","Acids turn China rose DARK PINK, not green; the green colour appears with bases."),
    ("salts","An ordinary salt solution is neutral and gives little change; the green colour signals a base."),
    ("pure metals","Metals are not tested by this indicator; the green colour of China rose means a base.")]),

 ("AB","Of these four liquids — lemon juice, soap solution, lime water and baking soda solution — the only acidic one is:",
   "lemon juice",
   C("Lemon juice is an acid (sour, reddens blue litmus). The other three — soap, lime water and baking soda — are all bases.")+
   steps("Lemon juice is sour and acidic","soap, lime water and baking soda are basic","so the only acid is lemon juice.")+
   U("Sorting kitchen liquids with litmus shows lemon juice stands out as the acid among common bases."),
   [("soap solution","Soap solution is basic (soapy, blues red litmus), not acidic; the acid here is lemon juice."),
    ("lime water","Lime water is a base that turns red litmus blue; the acidic liquid is lemon juice."),
    ("baking soda solution","Baking soda solution is basic; among these four the only acid is lemon juice.")]),
]

# ---------- DATA HANDLING (25) — several fused with science readings ----------
DH = [
 ("DH","To find the mean (average) of a set of numbers, we add up all the values and then divide the total by:",
   "the number of values",
   C("The mean is the sum of all the observations divided by how many observations there are.")+
   steps("Add all the values together","divide that total","by the number of values -> the mean.")+
   U("A cricketer's batting average is the total runs divided by the number of innings — a mean."),
   [("the largest value","Dividing by the largest value does not give an average; the mean divides by the COUNT of values."),
    ("two, always","We divide by however MANY numbers there are, not always two; that count gives the mean."),
    ("the smallest value","The smallest value is not the divisor; the mean divides the total by the number of values.")]),

 ("DH","The mean (average) of the four numbers 4, 6, 8 and 10 is:",
   "7",
   C("Add them: 4 + 6 + 8 + 10 = 28. Divide by the count, 4: 28 / 4 = 7.")+
   steps("Sum = 4 + 6 + 8 + 10 = 28","divide by 4 values","28 / 4 = 7.")+
   U("Averaging four test scores to one figure works exactly this way."),
   [("28","28 is the SUM of the numbers; the mean divides that by the 4 values, giving 7."),
    ("6","6 is one of the values, not the average; the mean is 28 / 4 = 7."),
    ("4","4 is the COUNT of numbers, not their mean; the mean is 28 / 4 = 7.")]),

 ("DH","Among a list of data values, the one that appears the greatest number of times is called the:",
   "mode",
   C("The mode is the most frequently occurring value in a data set — the one that appears the greatest number of times.")+
   steps("Look for the value that repeats most","that most-frequent value","is the mode.")+
   U("A shoe shop watches the modal (most common) size to stock the most pairs of it."),
   [("mean","The mean is the AVERAGE (sum over count), not the most frequent value; that is the mode."),
    ("median","The median is the MIDDLE value when ordered, not the most frequent one; that is the mode."),
    ("range","The range is the spread (largest minus smallest), not a repeated value; the most frequent is the mode.")]),

 ("DH","When a set of data is arranged in order, the value lying exactly in the middle is called the:",
   "median",
   C("The median is the middle value of ordered data — half the values lie below it and half above.")+
   steps("Arrange the data in order","find the middle value","that is the median.")+
   U("Median income is reported because it shows the true middle, unaffected by a few very large values."),
   [("mode","The mode is the MOST FREQUENT value, not the middle one; the middle value is the median."),
    ("mean","The mean is the AVERAGE, not the positional middle; the middle of ordered data is the median."),
    ("range","The range is the spread of the data, not its middle value; that middle is the median.")]),

 ("DH","The range of a set of data is found by subtracting the smallest value from the:",
   "largest value",
   C("Range measures spread: it is the largest value minus the smallest value in the data set.")+
   steps("Find the largest and smallest values","subtract: largest - smallest","that difference is the range.")+
   U("A weather report's daily temperature 'spread' is the range between the day's high and low."),
   [("mean value","The range uses the largest value, not the mean; range = largest - smallest."),
    ("middle value","The middle value is the median, not part of the range; range = largest - smallest."),
    ("most frequent value","The most frequent value is the mode; the range subtracts smallest from LARGEST.")]),

 ("DH","Over five days the noon temperatures were 20, 22, 24, 26 and 28 degrees Celsius. The mean noon temperature was:",
   "24 degrees Celsius",
   C("Add the temperatures: 20 + 22 + 24 + 26 + 28 = 120. Divide by 5 days: 120 / 5 = 24 degrees Celsius.")+
   steps("Sum = 120 degrees","divide by 5 readings","120 / 5 = 24 degrees Celsius.")+
   U("Weather scientists average daily temperatures to describe a place's climate."),
   [("120 degrees Celsius","120 is the SUM of the five readings; the mean divides it by 5, giving 24 degrees."),
    ("28 degrees Celsius","28 is the highest reading, not the average; the mean is 120 / 5 = 24 degrees."),
    ("5 degrees Celsius","5 is the number of days, not the mean temperature; the mean is 120 / 5 = 24 degrees.")]),

 ("DH","In a bar graph showing the rainfall of different months, the height of each bar represents the:",
   "amount of rainfall (the value of the data)",
   C("In a bar graph the taller the bar, the larger the value. The bar's height shows the amount of rainfall it stands for.")+
   steps("Each bar stands for one month","its height is read off the scale","that height is the rainfall amount.")+
   U("A glance at a rainfall bar graph shows the wettest month as the tallest bar."),
   [("the name of the month","The month is the LABEL along the bottom; the bar's HEIGHT shows the rainfall amount."),
    ("the number of months","The number of months is how many BARS there are, not a bar's height; height shows the rainfall."),
    ("the colour of the bar","Colour is only for decoration; the bar's height carries the rainfall value.")]),

 ("DH","A car's speed was noted as 30, 40 and 50 km/h at three moments. The mean of these three speed readings is:",
   "40 km/h",
   C("Add the speeds: 30 + 40 + 50 = 120. Divide by 3 readings: 120 / 3 = 40 km/h.")+
   steps("Sum = 30 + 40 + 50 = 120","divide by 3 readings","120 / 3 = 40 km/h.")+
   U("Averaging speed readings gives a single representative speed for a stretch of road."),
   [("120 km/h","120 is the SUM of the readings; the mean divides by 3, giving 40 km/h."),
    ("50 km/h","50 is the highest reading, not the mean; the average is 120 / 3 = 40 km/h."),
    ("3 km/h","3 is the number of readings, not the mean speed; that mean is 120 / 3 = 40 km/h.")]),

 ("DH","The mode of the data set 3, 5, 5, 7, 9, 5 and 2 is:",
   "5",
   C("The mode is the value that appears most often. Here 5 appears three times, more than any other value.")+
   steps("Count each value","5 occurs three times — the most","so the mode is 5.")+
   U("A survey of favourite colours reports the modal colour — the one chosen most often."),
   [("9","9 is the LARGEST value, not the most frequent; 5 appears most often, so the mode is 5."),
    ("2","2 is the smallest value, and appears only once; the most frequent value is 5."),
    ("7","7 appears just once; the value occurring most often is 5, so the mode is 5.")]),

 ("DH","A scientist records the litmus result 'acidic' for 6 samples and 'basic' for 2 samples. The more frequent result — the mode — is:",
   "acidic",
   C("The mode is the most frequent observation. 'Acidic' occurs 6 times against 'basic' 2 times, so the mode is 'acidic'.")+
   steps("Acidic: 6 samples; basic: 2 samples","6 is greater than 2","so the modal result is 'acidic'.")+
   U("Reporting the most common test result helps a lab summarise many samples at a glance."),
   [("basic","'Basic' occurs only twice; the more frequent result, the mode, is 'acidic' with 6 samples."),
    ("neutral","No sample was recorded as neutral; the most frequent recorded result is 'acidic'."),
    ("there is no mode","There is a clear most-frequent value here ('acidic', 6 times), so the mode is 'acidic'.")]),

 ("DH","In a pictograph each picture of a tree stands for 10 trees. A row showing 4 tree pictures therefore represents:",
   "40 trees",
   C("Each symbol stands for 10 trees, so 4 symbols mean 4 x 10 = 40 trees.")+
   steps("1 picture = 10 trees","4 pictures = 4 x 10","= 40 trees.")+
   U("Pictographs use one symbol for many items so large counts fit in a small picture."),
   [("4 trees","4 is the number of PICTURES, not trees; each picture is 10 trees, so it is 4 x 10 = 40."),
    ("10 trees","10 is what ONE picture stands for; four pictures mean 4 x 10 = 40 trees."),
    ("14 trees","14 adds 4 and 10; with each picture worth 10, four pictures mean 4 x 10 = 40 trees.")]),

 ("DH","A fair coin is tossed once. The probability of getting a head is:",
   "1/2",
   C("A coin has two equally likely outcomes, head and tail. The chance of a head is 1 out of 2, i.e. 1/2.")+
   steps("Outcomes: head or tail (2 equally likely)","favourable = 1 (head)","probability = 1/2.")+
   U("Tossing a coin to choose who starts a game is fair because each side has probability 1/2."),
   [("1","A probability of 1 means CERTAIN; a head is not certain, its probability is 1/2."),
    ("0","A probability of 0 means impossible; getting a head is possible, with probability 1/2."),
    ("2","2 is the number of outcomes, not a probability; probabilities lie between 0 and 1 — here 1/2.")]),

 ("DH","Arranged in increasing order, five test marks are 11, 13, 15, 17 and 19. The median (middle) mark is:",
   "15",
   C("With five ordered values the median is the third one, exactly in the middle. That value is 15.")+
   steps("Five values in order: 11, 13, 15, 17, 19","the middle (3rd) value","is 15.")+
   U("A teacher may quote the median mark to show the middle of the class's performance."),
   [("11","11 is the SMALLEST mark, not the middle one; the median of the five is 15."),
    ("19","19 is the LARGEST mark; the middle value of the ordered five is 15."),
    ("13","13 is the second value, not the middle; with five values the median is the third, 15.")]),

 ("DH","A double bar graph (two bars side by side for each category) is most useful when we want to:",
   "compare two sets of data side by side",
   C("A double bar graph places two bars together for each item, making it easy to compare two related data sets.")+
   steps("Two bars per category","placed side by side","let us compare two data sets at a glance.")+
   U("A double bar graph comparing boys' and girls' marks shows the difference subject by subject."),
   [("show how one quantity changes over time","Change over time is better shown by a line graph; a double bar graph COMPARES two data sets."),
    ("display a single value only","A single value needs no graph; a double bar graph compares TWO sets of data."),
    ("find the area of a shape","Area is a geometry calculation, not a use of bar graphs; double bars compare two data sets.")]),

 ("DH","For the numbers 12, 15, 20, 9 and 14, the smallest value is 9 and the largest is 20. Their range is:",
   "11",
   C("Range = largest - smallest = 20 - 9 = 11.")+
   steps("Largest = 20, smallest = 9","range = 20 - 9","= 11.")+
   U("The range of test scores shows how spread out the class results are."),
   [("20","20 is the LARGEST value, not the range; the range is 20 - 9 = 11."),
    ("9","9 is the SMALLEST value; the range subtracts it from the largest, giving 20 - 9 = 11."),
    ("29","29 ADDS 20 and 9; the range SUBTRACTS, giving 20 - 9 = 11.")]),

 ("DH","On a summer day a town's highest temperature was 38 degrees and its lowest 22 degrees Celsius. The range of temperature that day was:",
   "16 degrees Celsius",
   C("Range = highest - lowest = 38 - 22 = 16 degrees Celsius.")+
   steps("Highest = 38, lowest = 22","range = 38 - 22","= 16 degrees Celsius.")+
   U("Weather summaries give the day's temperature range to show how much it varied."),
   [("60 degrees Celsius","60 ADDS the two temperatures; the range SUBTRACTS, giving 38 - 22 = 16 degrees."),
    ("38 degrees Celsius","38 is the highest reading, not the range; the range is 38 - 22 = 16 degrees."),
    ("22 degrees Celsius","22 is the lowest reading; the range subtracts it from the high, giving 16 degrees.")]),

 ("DH","Before the median of a list of numbers can be read off, the numbers must first be:",
   "arranged in order (ascending or descending)",
   C("The median is the middle value of ORDERED data, so the numbers must be sorted before the middle one can be found.")+
   steps("Median = middle value","but the middle only makes sense once sorted","so first arrange the data in order.")+
   U("To find the median height in a class you first line everyone up by height."),
   [("added together","Adding gives the basis for the MEAN, not the median; for the median you first ORDER the data."),
    ("multiplied together","Multiplying has no role in the median; you must arrange the numbers in order first."),
    ("counted only","Counting alone does not locate the middle; the data must be put in order first.")]),

 ("DH","A standard six-faced die is rolled once. The probability of getting the number 3 is:",
   "1/6",
   C("A die has six equally likely faces. Only one shows a 3, so the probability is 1 out of 6, i.e. 1/6.")+
   steps("Six equally likely outcomes","favourable = 1 (the face '3')","probability = 1/6.")+
   U("Board games use a die because each number has the same fair chance, 1/6."),
   [("1/2","1/2 is the chance for a coin's two sides; a die has SIX faces, so a 3 has probability 1/6."),
    ("3/6","3/6 would count three favourable faces, but only ONE face shows a 3, so it is 1/6."),
    ("6","6 is the number of faces, not a probability; the chance of a 3 is 1/6.")]),

 ("DH","Five readings of mass are 10 g, 20 g, 30 g, 40 g and 50 g. Their mean is:",
   "30 g",
   C("Add them: 10 + 20 + 30 + 40 + 50 = 150. Divide by 5 readings: 150 / 5 = 30 g.")+
   steps("Sum = 150 g","divide by 5 readings","150 / 5 = 30 g.")+
   U("Averaging several weighings reduces small errors and gives one reliable mass."),
   [("150 g","150 g is the SUM of the readings; the mean divides it by 5, giving 30 g."),
    ("50 g","50 g is the heaviest reading, not the mean; the average is 150 / 5 = 30 g."),
    ("25 g","25 g would need a sum of 125; the actual sum is 150, so the mean is 150 / 5 = 30 g.")]),

 ("DH","The probability of an event that is certain to happen, such as the Sun setting today, is:",
   "1",
   C("A certain event always happens, so its probability is the maximum value, 1.")+
   steps("A certain event always occurs","the highest probability is 1","so its probability is 1.")+
   U("Saying an event is 'guaranteed' is the everyday way of saying its probability is 1."),
   [("0","A probability of 0 means IMPOSSIBLE; a certain event has probability 1."),
    ("1/2","1/2 is the chance of an even toss-up; a CERTAIN event has the maximum probability, 1."),
    ("100","Probabilities run only from 0 to 1, not up to 100; a certain event has probability 1.")]),

 ("DH","In a class the most common shoe size — the one worn by the largest number of students — is best described as the:",
   "mode",
   C("The value that the greatest number of students share is the most frequent value, which is the mode.")+
   steps("Most students share one size","most frequent value","is the mode.")+
   U("A shop orders the most pairs of the modal shoe size because it sells the most."),
   [("mean","The mean shoe size is an AVERAGE that might not even be a real size; the most common size is the mode."),
    ("median","The median is the MIDDLE size when ordered, not the most common one; that is the mode."),
    ("range","The range is the spread between the largest and smallest sizes, not the commonest one; that is the mode.")]),

 ("DH","Six students scored 8, 6, 10, 6, 9 and 7 marks. The mode of their scores is:",
   "6",
   C("The mode is the most frequent score. Here 6 appears twice while every other score appears once, so the mode is 6.")+
   steps("List the scores","6 appears twice — more than any other","so the mode is 6.")+
   U("A teacher noting the most common mark uses the mode to see a typical score."),
   [("10","10 is the HIGHEST score, not the most frequent; 6 repeats, so the mode is 6."),
    ("8","8 appears only once; the score that repeats is 6, so the mode is 6."),
    ("9","9 appears only once; the most frequent score is 6, which appears twice.")]),

 ("DH","While collecting data, tally marks are used mainly to:",
   "count and record observations quickly",
   C("Tally marks let you record each observation with a quick stroke and count them easily in groups of five.")+
   steps("Make one stroke per observation","group them in fives","then count the tallies quickly.")+
   U("A volunteer counting passing cars makes a tally mark for each one, then totals them."),
   [("measure the length of objects","Tally marks COUNT observations; they do not measure length, which needs a ruler."),
    ("find the area of a region","Area is a geometry calculation; tally marks are for quickly counting observations."),
    ("draw accurate circles","Tally marks are counting strokes, not a drawing tool; they record observations quickly.")]),

 ("DH","An event that can never happen — such as drawing a green ball from a bag containing only red balls — has a probability of:",
   "0",
   C("An impossible event never occurs, so its probability is the lowest possible value, 0.")+
   steps("The event can never happen","the lowest probability is 0","so its probability is 0.")+
   U("Saying something 'cannot possibly happen' is the everyday way of giving it probability 0."),
   [("1","A probability of 1 means CERTAIN; an impossible event has probability 0."),
    ("1/2","1/2 is the chance of a fair toss-up; an IMPOSSIBLE event has probability 0."),
    ("a negative number","Probabilities are never negative; the smallest value, for an impossible event, is 0.")]),

 ("DH","Three numbers have a mean of 8. If a fourth number, 16, is added, the new mean of all four numbers becomes:",
   "10",
   C("Three numbers with mean 8 have a total of 3 x 8 = 24. Adding 16 gives 40; the new mean is 40 / 4 = 10.")+
   steps("Old total = 3 x 8 = 24","new total = 24 + 16 = 40","new mean = 40 / 4 = 10.")+
   U("Adding a high new score raises a class average, found by re-totalling and re-dividing like this."),
   [("8","8 was the OLD mean; adding a larger value (16) raises it, giving a new mean of 10."),
    ("12","12 averages only 8 and 16; the correct mean uses the full total of 40 over 4 values, giving 10."),
    ("16","16 is the value just ADDED, not the new mean; the new mean of the four numbers is 40 / 4 = 10.")]),
]

# ---------- COMPARING QUANTITIES (25) — several fused with motion/acids ----------
CQ = [
 ("CQ","A ratio compares two quantities of the same kind by division. The ratio 2 : 5 means that for every 2 units of the first quantity there are:",
   "5 units of the second",
   C("A ratio 2 : 5 pairs the quantities: for each 2 units of the first there are 5 units of the second.")+
   steps("Ratio 2 : 5","first quantity 2 -> second quantity 5","so for every 2 of the first there are 5 of the second.")+
   U("A recipe ratio like 2 : 5 of two ingredients keeps the taste the same however much you make."),
   [("2 units of the second","The second number is 5, not 2; the ratio 2 : 5 pairs 2 of the first with 5 of the second."),
    ("3 units of the second","The 5 in the ratio is the second amount, not 3; for every 2 of the first there are 5 of the second."),
    ("10 units of the second","10 doubles the ratio's second part; as written, 2 : 5 means 5 of the second for every 2 of the first.")]),

 ("CQ","Written as a percentage, the fraction one-quarter (1/4) is equal to:",
   "25%",
   C("Per cent means 'out of 100'. One-quarter of 100 is 25, so 1/4 = 25%.")+
   steps("1/4 of 100","= 100 / 4","= 25, so 1/4 = 25%.")+
   U("A '25% off' sale tag means one-quarter of the price is taken off."),
   [("4%","4% confuses the denominator 4 with the percentage; one-quarter of 100 is 25, so 1/4 = 25%."),
    ("14%","14% misreads 1/4; a quarter of 100 is 25, giving 25%."),
    ("40%","40% is two-fifths, not a quarter; 1/4 equals 25%.")]),

 ("CQ","Half of a number is the same as fifty per cent of it. Therefore 50% of 80 is:",
   "40",
   C("50% means one half. Half of 80 is 80 / 2 = 40.")+
   steps("50% = one half","half of 80 = 80 / 2","= 40.")+
   U("A '50% extra free' pack gives you half as much again — easy to work out as a half."),
   [("80","80 is the whole amount; 50% (one half) of it is 40."),
    ("50","50 is the percentage figure, not 50% OF 80; half of 80 is 40."),
    ("20","20 is a quarter of 80, not a half; 50% of 80 is 40.")]),

 ("CQ","Expressed as a percentage, the decimal number 0.6 becomes:",
   "60%",
   C("To turn a decimal into a percentage, multiply by 100. 0.6 x 100 = 60%.")+
   steps("Multiply the decimal by 100","0.6 x 100","= 60%.")+
   U("A test score recorded as 0.6 is the same as scoring 60%."),
   [("6%","6% moves the decimal only one place; 0.6 x 100 = 60%."),
    ("0.6%","0.6% forgets to multiply by 100; 0.6 as a percent is 60%."),
    ("600%","600% multiplies by 1000; 0.6 x 100 = 60%.")]),

 ("CQ","Two cars have speeds of 60 km/h and 40 km/h. Written in simplest form, the ratio of their speeds is:",
   "3 : 2",
   C("The ratio is 60 : 40. Dividing both parts by 20 gives 3 : 2.")+
   steps("Speeds 60 : 40","divide both by 20","= 3 : 2.")+
   U("Comparing two vehicles' speeds as a simple ratio shows how much faster one is."),
   [("60 : 40","60 : 40 is correct but NOT in simplest form; dividing both by 20 gives 3 : 2."),
    ("2 : 3","2 : 3 is reversed; the faster car (60) comes first, giving 3 : 2."),
    ("6 : 5","6 : 5 mis-simplifies; 60 : 40 reduces to 3 : 2, not 6 : 5.")]),

 ("CQ","If 3 identical notebooks cost 60 rupees, then by the unitary method 5 such notebooks will cost:",
   "100 rupees",
   C("First find the cost of one: 60 / 3 = 20 rupees. Then 5 notebooks cost 5 x 20 = 100 rupees.")+
   steps("1 notebook = 60 / 3 = 20 rupees","5 notebooks = 5 x 20","= 100 rupees.")+
   U("Working out a single item's price lets you budget for any number of them."),
   [("60 rupees","60 rupees is the cost of just 3 notebooks; 5 of them cost 5 x 20 = 100 rupees."),
    ("120 rupees","120 doubles the price of 3; the cost of 5 at 20 rupees each is 100 rupees."),
    ("80 rupees","80 undercounts; at 20 rupees each, 5 notebooks cost 100 rupees.")]),

 ("CQ","To express any quantity as a percentage, we always write it as a fraction out of:",
   "100",
   C("Per cent means 'per hundred'. A percentage is a quantity written as a fraction with denominator 100.")+
   steps("'Per cent' = per hundred","write the quantity as a fraction of 100","that fraction is the percentage.")+
   U("Marks 'out of 100' are already percentages — that is why exams often use 100 marks."),
   [("10","Percentages are out of 100, not 10; 'per cent' literally means per hundred."),
    ("50","50 is just one possible value; every percentage is a fraction out of 100."),
    ("1000","'Per cent' means per hundred, so the whole is 100, not 1000.")]),

 ("CQ","Twenty per cent of the 50 students in a class wear spectacles. The number of students who wear spectacles is:",
   "10",
   C("20% of 50 = (20/100) x 50 = 10 students.")+
   steps("20% = 20/100","x 50 students","= 10 students.")+
   U("Health surveys report results as a percentage so classes of different sizes can be compared."),
   [("20","20 is the PERCENTAGE figure, not 20% OF 50; that is 10 students."),
    ("50","50 is the whole class; only 20% of them, i.e. 10 students, wear spectacles."),
    ("30","30 is 60% of 50; 20% of 50 is 10 students.")]),

 ("CQ","A bottle holds 200 mL of solution, of which 30 mL is acid. The percentage of acid in the solution is:",
   "15%",
   C("Percentage of acid = (acid / total) x 100 = (30 / 200) x 100 = 15%.")+
   steps("Acid = 30 mL of 200 mL","(30 / 200) x 100","= 15%.")+
   U("Chemists label a solution's strength as a percentage so its concentration is clear."),
   [("30%","30 mL is the VOLUME of acid, not the percentage; (30/200) x 100 = 15%."),
    ("85%","85% is the percentage of the OTHER liquid (170 mL); the acid (30 of 200) is 15%."),
    ("6%","6% misplaces the figures; (30 / 200) x 100 = 15%, not 6%.")]),

 ("CQ","Written as a fraction in its lowest terms, 40% equals:",
   "2/5",
   C("40% = 40/100. Dividing top and bottom by 20 gives 2/5.")+
   steps("40% = 40/100","divide both by 20","= 2/5.")+
   U("Recognising 40% as 2/5 makes mental arithmetic with the figure much quicker."),
   [("4/10","4/10 is correct but NOT in lowest terms; dividing by 2 gives 2/5."),
    ("1/40","1/40 misreads the percentage; 40% is 40/100 = 2/5."),
    ("4/5","4/5 is 80%, not 40%; 40% in lowest terms is 2/5.")]),

 ("CQ","A train covers 200 km in 4 hours. Expressed as a unit rate, its speed is:",
   "50 km per hour",
   C("A unit rate is the amount per ONE unit. Distance per hour = 200 km / 4 h = 50 km per hour.")+
   steps("Unit rate = distance / time","= 200 km / 4 h","= 50 km per hour.")+
   U("Speed is a unit rate, which is why it is given 'per hour' for easy comparison."),
   [("200 km per hour","200 km is the total distance, not the per-hour rate; that rate is 200 / 4 = 50 km/h."),
    ("4 km per hour","4 is the number of hours, not the rate; the unit rate is 200 / 4 = 50 km/h."),
    ("800 km per hour","800 multiplies distance by time; a unit rate DIVIDES, giving 200 / 4 = 50 km/h.")]),

 ("CQ","A shop offers a 10% discount on a bag marked 500 rupees. The discount amount is:",
   "50 rupees",
   C("10% of 500 = (10/100) x 500 = 50 rupees off.")+
   steps("Discount = 10% of 500","= (10/100) x 500","= 50 rupees.")+
   U("Shoppers work out the rupees saved by taking the discount percent of the marked price."),
   [("450 rupees","450 rupees is the price AFTER the discount, not the discount itself; the discount is 50 rupees."),
    ("10 rupees","10 is the PERCENTAGE, not 10% of 500; the discount is 50 rupees."),
    ("100 rupees","100 would be a 20% discount; 10% of 500 is 50 rupees.")]),

 ("CQ","Written as a fraction in its simplest form, 75% is equal to:",
   "3/4",
   C("75% = 75/100. Dividing top and bottom by 25 gives 3/4.")+
   steps("75% = 75/100","divide both by 25","= 3/4.")+
   U("Knowing 75% is three-quarters helps you judge 'three-quarters full' at a glance."),
   [("7/5","7/5 is bigger than 1 (more than 100%); 75% is 75/100 = 3/4."),
    ("75/10","75/10 misplaces the denominator; 75% is 75/100 = 3/4."),
    ("1/4","1/4 is 25%, not 75%; 75% in simplest form is 3/4.")]),

 ("CQ","When the ratio 15 : 25 is reduced to its lowest terms, it becomes:",
   "3 : 5",
   C("Divide both parts by their common factor 5: 15 / 5 = 3 and 25 / 5 = 5, giving 3 : 5.")+
   steps("Common factor of 15 and 25 is 5","15 / 5 : 25 / 5","= 3 : 5.")+
   U("Simplifying a ratio makes a comparison, like a recipe's proportions, easy to read."),
   [("5 : 3","5 : 3 is reversed; 15 : 25 keeps the first part first, giving 3 : 5."),
    ("15 : 25","15 : 25 is correct but NOT simplified; dividing both by 5 gives 3 : 5."),
    ("1 : 2","1 : 2 over-simplifies; 15 : 25 reduces exactly to 3 : 5.")]),

 ("CQ","If 25% of a number is 30, then the whole number is:",
   "120",
   C("25% is one quarter, so the whole is four times 30: 30 x 4 = 120.")+
   steps("25% = one quarter","whole = 4 x the quarter","= 4 x 30 = 120.")+
   U("Working back from a percentage finds an original price when only the part is known."),
   [("30","30 IS the 25% part, not the whole; the whole is 4 x 30 = 120."),
    ("7.5","7.5 takes 25% OF 30; here 30 IS the 25%, so the whole is 4 x 30 = 120."),
    ("55","55 just adds 25 to 30; to find the whole from a quarter you multiply by 4, giving 120.")]),

 ("CQ","A toy bought for 200 rupees is sold for 250 rupees. The profit per cent is:",
   "25%",
   C("Profit = 250 - 200 = 50 rupees. Profit per cent = (profit / cost) x 100 = (50 / 200) x 100 = 25%.")+
   steps("Profit = 250 - 200 = 50 rupees","(50 / 200) x 100","= 25%.")+
   U("Shopkeepers quote profit as a percentage of cost to compare how good different deals are."),
   [("50%","50 rupees is the profit AMOUNT, not the percentage; as a fraction of 200 it is 25%."),
    ("20%","20% compares the 50 profit with the SELLING price 250; profit per cent uses the COST, giving 25%."),
    ("25 rupees","25 is the percentage figure with the wrong unit; the profit per cent is 25%, while the profit in rupees is 50.")]),

 ("CQ","In a fruit basket the ratio of apples to the total number of fruits is 1 : 4. The percentage of apples is:",
   "25%",
   C("A ratio of 1 : 4 (apples : total) means apples are 1/4 of the fruit. As a percentage, 1/4 = 25%.")+
   steps("Apples : total = 1 : 4 means apples = 1/4","1/4 of 100","= 25%.")+
   U("Turning a ratio into a percentage makes shares easy to compare across different totals."),
   [("4%","4% confuses the ratio's 4 with a percentage; apples are 1/4 of the total, i.e. 25%."),
    ("20%","20% would be 1/5; the ratio 1 : 4 here is apples to TOTAL, giving 1/4 = 25%."),
    ("75%","75% is the share of the OTHER fruits; the apples, being 1/4, are 25%.")]),

 ("CQ","Ten per cent of a quantity is equal to 20. The whole quantity is therefore:",
   "200",
   C("10% is one tenth, so the whole is ten times 20: 20 x 10 = 200.")+
   steps("10% = one tenth","whole = 10 x the tenth","= 10 x 20 = 200.")+
   U("Reading a 10% tip or tax lets you scale back up to find the original amount."),
   [("20","20 IS the 10% part, not the whole; the whole is 10 x 20 = 200."),
    ("2","2 takes 10% OF 20; here 20 IS the 10%, so the whole is 10 x 20 = 200."),
    ("30","30 just adds 10 to 20; the whole is found by multiplying the tenth by 10, giving 200.")]),

 ("CQ","One soap pack has 4 soaps for 80 rupees; another has 6 soaps for 150 rupees. The pack that is the better buy (cheaper per soap) is the:",
   "pack of 4, at 20 rupees each",
   C("Find the price per soap: 80 / 4 = 20 rupees each, while 150 / 6 = 25 rupees each. The pack of 4 is cheaper per soap.")+
   steps("Pack of 4: 80 / 4 = 20 rupees each","pack of 6: 150 / 6 = 25 rupees each","20 < 25, so the pack of 4 is the better buy.")+
   U("Comparing unit prices is how shoppers spot the genuinely cheaper deal."),
   [("pack of 6, at 25 rupees each","The pack of 6 costs MORE per soap (25 rupees) than the pack of 4 (20 rupees), so it is the worse buy."),
    ("both cost the same per soap","They differ: 20 rupees each versus 25 rupees each, so the pack of 4 is cheaper per soap."),
    ("pack of 6, because it has more soaps","Having more soaps does not make it cheaper PER soap; at 25 rupees each it is dearer than the pack of 4.")]),

 ("CQ","Out of 20 water samples tested, 8 were found to be acidic. The percentage of acidic samples was:",
   "40%",
   C("Percentage = (acidic / total) x 100 = (8 / 20) x 100 = 40%.")+
   steps("Acidic = 8 of 20","(8 / 20) x 100","= 40%.")+
   U("Scientists report the share of polluted or acidic samples as a percentage for easy comparison."),
   [("8%","8 is the COUNT of acidic samples, not the percentage; (8/20) x 100 = 40%."),
    ("20%","20 is the TOTAL number of samples, not the percentage; the acidic share is (8/20) x 100 = 40%."),
    ("60%","60% is the share of NON-acidic samples (12 of 20); the acidic share is 40%.")]),

 ("CQ","Written as a percentage, the fraction 7/10 equals:",
   "70%",
   C("Per cent means out of 100. 7/10 = 70/100 = 70%.")+
   steps("7/10 = 70/100","70 out of 100","= 70%.")+
   U("A score of 7 out of 10 on a quiz is the same as 70%."),
   [("7%","7% confuses the numerator 7 with the percentage; 7/10 is 70/100 = 70%."),
    ("17%","17% wrongly adds 7 and 10; 7/10 equals 70%."),
    ("0.7%","0.7% forgets to express it out of 100; 7/10 = 70/100 = 70%.")]),

 ("CQ","Two ratios are equivalent when one comes from the other by multiplying both parts by the same number. The ratio equivalent to 1 : 3 is:",
   "4 : 12",
   C("Multiplying both parts of 1 : 3 by 4 gives 4 : 12, which is equivalent because the relationship is unchanged.")+
   steps("Multiply 1 : 3 by 4 on both parts","1 x 4 : 3 x 4","= 4 : 12.")+
   U("Scaling a recipe up keeps the ingredient ratio equivalent, just like 1 : 3 becoming 4 : 12."),
   [("4 : 6","4 : 6 multiplies the parts UNEQUALLY (by 4 and by 2); equivalent to 1 : 3 is 4 : 12."),
    ("3 : 1","3 : 1 is 1 : 3 REVERSED, a different ratio; the equivalent one is 4 : 12."),
    ("2 : 3","2 : 3 doubles only the first part; multiplying both parts of 1 : 3 by 4 gives 4 : 12.")]),

 ("CQ","A drink is made by mixing sugar and water in the ratio 1 : 4. The percentage of sugar in the whole drink is:",
   "20%",
   C("1 part sugar to 4 parts water makes 5 parts in all. Sugar is 1 of 5 parts = 1/5 = 20%.")+
   steps("Total parts = 1 + 4 = 5","sugar = 1 of 5 = 1/5","= 20%.")+
   U("Reading a mixture's recipe as a percentage tells you how strong or sweet it is."),
   [("25%","25% would be 1 part out of 4; but the TOTAL is 1 + 4 = 5 parts, so sugar is 1/5 = 20%."),
    ("4%","4% confuses the water's 4 parts with a percentage; sugar is 1 of 5 parts, i.e. 20%."),
    ("80%","80% is the WATER's share (4 of 5 parts); the sugar (1 of 5) is 20%.")]),

 ("CQ","The speed of car X is 80 km/h and that of car Y is 100 km/h. The ratio of X's speed to Y's speed, in simplest form, is:",
   "4 : 5",
   C("The ratio is 80 : 100. Dividing both parts by 20 gives 4 : 5.")+
   steps("Speeds 80 : 100","divide both by 20","= 4 : 5.")+
   U("A simplified speed ratio quickly shows how two vehicles compare on a journey."),
   [("5 : 4","5 : 4 is reversed; X (80) is slower than Y (100), so X : Y is 4 : 5, the smaller first."),
    ("80 : 100","80 : 100 is correct but NOT simplified; dividing both by 20 gives 4 : 5."),
    ("8 : 1","8 : 1 mis-simplifies; 80 : 100 reduces to 4 : 5, not 8 : 1.")]),

 ("CQ","A class of 40 children includes 10 left-handed children. The percentage of left-handed children is:",
   "25%",
   C("Percentage = (left-handed / total) x 100 = (10 / 40) x 100 = 25%.")+
   steps("Left-handed = 10 of 40","(10 / 40) x 100","= 25%.")+
   U("Surveys give such shares as percentages so groups of different sizes can be compared."),
   [("10%","10 is the COUNT of left-handed children, not the percentage; (10/40) x 100 = 25%."),
    ("40%","40 is the TOTAL number of children, not the percentage; the left-handed share is 25%."),
    ("75%","75% is the share of RIGHT-handed children (30 of 40); the left-handed share is 25%.")]),
]

# ---------- assemble: interleave so no two consecutive share a chapter ----------
assert all(len(b) == 25 for b in (MT, AB, DH, CQ)), [len(MT), len(AB), len(DH), len(CQ)]
items = []
for i in range(25):
    items += [MT[i], AB[i], DH[i], CQ[i]]
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

    keydist = build_paper(PNUM, TITLE, SHORT, LABELS, items, seed=53131,
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
    split = "/".join(str(counts[c]) for c in ("MT", "AB", "DH", "CQ"))
    with open("PAPERS_MANIFEST.md", "a", encoding="utf-8") as fh:
        fh.write(f"| {PNUM} | 2026-06-18 | {TITLE} | {split} | ✓ |\n")

    # ---- update QUESTION_INDEX.json ----
    idx["fingerprints"] = sorted(existing | set(new_fps))
    idx.setdefault("combos", []).append({
        "paper": PNUM,
        "chapters": ["Motion & Time",
                     "Acids, Bases & Salts",
                     "Data Handling",
                     "Comparing Quantities"],
    })
    idx["papers"] = idx.get("papers", 0) + 1
    with open(idx_path, "w", encoding="utf-8") as fh:
        json.dump(idx, fh, ensure_ascii=False, indent=2)
        fh.write("\n")

    print("Files:", sorted(v for v in moves.values()))
    print("Answer key spread A/B/C/D =", dict(keydist))
