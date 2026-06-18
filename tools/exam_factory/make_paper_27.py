# -*- coding: utf-8 -*-
# Boss Challenge Paper 27 — Motion & Time · Forests · Algebraic Expressions · Comparing Quantities
# Content-only. Uses the dependency-free examfactory engine.
# Difficulty ramp: this paper leans hard into FUSION — many Algebraic-Expressions items are wrapped in a
# real motion situation (a jeep whose speed is (2t+5) km/h, trees as (8n+3), trees planted per day) or a
# forest situation (saplings in rows, pens/ropes as expressions). Many Comparing-Quantities items are
# wrapped in a motion context (percentage rise in a cyclist's speed, fraction of a route covered) or a
# forest context (percent of sal trees, ratio of trees to shrubs). The child reads a Science context and
# applies a Maths skill. Class-7 scope, simple wording, hard thinking.
# Produces, under Resources/BossChallengePapers/:
#   Paper_27_<SHORT>_QuestionPaper.html  (pure HTML — questions + options)
#   Paper_27_<SHORT>_QuestionPaper.pdf
#   Paper_27_<SHORT>_Questions.md
#   Paper_27_<SHORT>_Solutions.html
import os, sys, shutil, json, re
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from examfactory import build_paper, C, steps, U

PNUM  = "27"
SHORT = "MotionTime_Forests_AlgExpr_ComparingQuantities"
TITLE = ("Motion & Time · Forests · Algebraic Expressions · "
         "Comparing Quantities")
LABELS = {
    "MT": "Motion & Time",
    "FO": "Forests",
    "AE": "Algebraic Expressions",
    "CQ": "Comparing Quantities",
}

# ---------- MOTION & TIME (25) — Science ----------
MT = [
 ("MT","The distance covered by a moving body in one unit of time is what we call its:",
   "speed",
   C("Speed tells us how fast something moves — the distance it covers each second (or hour).")+
   steps("Take the distance covered","Divide by the time taken","the result is the speed."),
   [("acceleration","Acceleration is how quickly speed itself changes, not distance per unit time."),
    ("displacement","Displacement is just the distance moved; speed also brings in the time taken."),
    ("oscillation","An oscillation is one to-and-fro swing of a pendulum, not distance per unit time.")]),

 ("MT","When speed is measured using the SI units of distance and time, the unit that comes out is the:",
   "metre per second (m/s)",
   C("In SI, distance is in metres and time in seconds, so speed is metres per second.")+
   steps("SI distance unit = metre","SI time unit = second","speed = metre ÷ second = m/s."),
   [("kilometre per hour","km/h is a common unit but not the SI unit; the SI unit is m/s."),
    ("metre per minute","The SI unit of time is the second, not the minute, so it is m/s."),
    ("second per metre","Speed is distance over time (m/s), not time over distance.")]),

 ("MT","A car that covers exactly 15 metres in every single second, never speeding up or slowing down, is moving with:",
   "uniform motion",
   C("Uniform motion means equal distances are covered in equal time intervals.")+
   steps("Each second the car covers the same 15 m","equal distances in equal times","that is uniform motion."),
   [("non-uniform motion","Non-uniform motion would cover different distances in equal times; here they are equal."),
    ("circular motion","Circular motion is about the path's shape, not whether the distances per second are equal."),
    ("no motion","The car is clearly moving 15 m each second, so it is not at rest.")]),

 ("MT","A bus that covers different distances in equal time intervals as it weaves through traffic is in:",
   "non-uniform motion",
   C("Non-uniform motion means the distance covered in each equal time slice keeps changing.")+
   steps("Equal time slices are compared","the distances in them differ","so the motion is non-uniform."),
   [("uniform motion","Uniform motion needs equal distances in equal times; here they differ."),
    ("periodic motion","Periodic motion repeats after fixed intervals, like a pendulum, not traffic driving."),
    ("rest","A bus weaving through traffic is moving, so it is not at rest.")]),

 ("MT","On a distance–time graph, the motion of an object moving at a steady speed appears as a:",
   "straight slanting line",
   C("Steady speed means equal distance each second, which plots as a straight sloping line.")+
   steps("Equal distance in equal time","each point rises by the same step","the dots join into a straight slanting line."),
   [("curved line","A curve would mean the speed keeps changing; steady speed gives a straight line."),
    ("flat horizontal line","A flat line means no distance is being gained — the object is at rest."),
    ("vertical line","A vertical line would mean distance changes with no time passing, which is impossible.")]),

 ("MT","On a distance–time graph, a flat horizontal line tells us that during that time the object was:",
   "at rest (not moving)",
   C("A flat line means the distance is not changing, so the object stays put.")+
   steps("Time keeps moving along the bottom","but the distance value stays the same","so the object is at rest."),
   [("moving fast","Fast motion would make the line rise steeply, not stay flat."),
    ("moving at steady speed","Steady speed gives a rising straight line, not a flat one."),
    ("speeding up","Speeding up would make the line curve upward, not stay flat.")]),

 ("MT","The meter on a vehicle's dashboard that shows how fast it is going at that moment is the:",
   "speedometer",
   C("A speedometer reads the vehicle's speed right now, in km/h.")+
   steps("It senses how fast the wheels turn","converts that to speed","and shows it on a dial — the speedometer."),
   [("odometer","An odometer adds up total distance travelled, not the present speed."),
    ("thermometer","A thermometer measures temperature, not speed."),
    ("barometer","A barometer measures air pressure, not the speed of a vehicle.")]),

 ("MT","The meter on a vehicle that keeps adding up the total distance the vehicle has travelled is the:",
   "odometer",
   C("An odometer counts the total kilometres a vehicle has covered over its life.")+
   steps("It counts how many times the wheels turn","multiplies by the wheel's distance","showing total distance — the odometer."),
   [("speedometer","A speedometer shows the present speed, not the total distance covered."),
    ("compass","A compass shows direction, not distance travelled."),
    ("stopwatch","A stopwatch measures time intervals, not distance.")]),

 ("MT","One complete to-and-fro swing of a simple pendulum, from one extreme back to the same extreme, is called one:",
   "oscillation",
   C("An oscillation is one full back-and-forth journey of the pendulum bob.")+
   steps("The bob swings to one side","comes back through the middle to the other side and returns","that whole trip is one oscillation."),
   [("revolution","A revolution is a full circular turn around a point, not a to-and-fro swing."),
    ("rotation","Rotation is spinning about an axis, not a pendulum's swing."),
    ("vibration of sound","Sound vibrations are tiny and rapid; here we mean the pendulum's visible swing.")]),

 ("MT","The time a simple pendulum takes to finish one complete oscillation is known as its:",
   "time period",
   C("The time period is the seconds needed for exactly one full swing.")+
   steps("Pick one complete oscillation","measure how long it takes","that time is the time period."),
   [("frequency","Frequency counts how many oscillations happen in one second, not the time for one."),
    ("amplitude","Amplitude is how far the bob swings out, not the time it takes."),
    ("speed","Speed is distance per time; the time for one swing is the time period.")]),

 ("MT","The basic SI unit used to measure time is the:",
   "second",
   C("The second is the standard SI unit of time; minutes and hours are built from it.")+
   steps("All clocks ultimately count seconds","60 seconds make a minute","so the base SI unit is the second."),
   [("minute","A minute is 60 seconds; the base SI unit is the second itself."),
    ("hour","An hour is 3600 seconds; the SI base unit is the second."),
    ("day","A day is built from many seconds; the SI base unit of time is the second.")]),

 ("MT","A leopard runs at 36 km/h. Expressed in metres per second (divide by 3.6), this speed is:",
   "10 m/s",
   C("To change km/h into m/s we divide by 3.6.")+
   steps("Speed = 36 km/h","36 ÷ 3.6 = 10","so the leopard runs at 10 m/s."),
   [("36 m/s","That just copies the number without converting; you must divide 36 by 3.6."),
    ("3.6 m/s","That divides 36 by 10, not by 3.6; the correct value is 10 m/s."),
    ("100 m/s","That multiplies instead of dividing; 36 ÷ 3.6 = 10 m/s.")]),

 ("MT","A forest ranger's jeep covers 60 km along a fire-line in 2 hours. Its speed is:",
   "30 km/h",
   C("Speed equals total distance divided by total time.")+
   steps("Distance = 60 km, time = 2 h","Speed = 60 ÷ 2","Speed = 30 km/h."),
   [("120 km/h","That multiplies 60 by 2; speed is distance divided by time, not multiplied."),
    ("60 km/h","That ignores the time; you must divide 60 km by 2 hours."),
    ("15 km/h","That divides by 4; the time is 2 hours, so 60 ÷ 2 = 30 km/h.")]),

 ("MT","A deer dashes at 12 m/s for 5 seconds. The distance it covers is:",
   "60 m",
   C("Distance equals speed multiplied by time.")+
   steps("Speed = 12 m/s, time = 5 s","Distance = 12 × 5","Distance = 60 m."),
   [("17 m","That adds 12 and 5; distance is speed times time, not their sum."),
    ("2.4 m","That divides 12 by 5; distance is speed times time."),
    ("12 m","That ignores the 5 seconds; distance = 12 × 5 = 60 m.")]),

 ("MT","A boy cycles 1200 m to school at a steady 4 m/s. The time he takes is:",
   "300 s",
   C("Time equals distance divided by speed.")+
   steps("Distance = 1200 m, speed = 4 m/s","Time = 1200 ÷ 4","Time = 300 s."),
   [("4800 s","That multiplies 1200 by 4; time is distance divided by speed."),
    ("1200 s","That ignores the speed; you divide 1200 by 4 to get 300 s."),
    ("30 s","That divides by 40, not 4; 1200 ÷ 4 = 300 s.")]),

 ("MT","Object P covers 100 m in 10 s while object Q covers the same 100 m in 20 s. The faster object is:",
   "P",
   C("For the same distance, the one that takes less time is faster.")+
   steps("P's speed = 100 ÷ 10 = 10 m/s","Q's speed = 100 ÷ 20 = 5 m/s","10 m/s > 5 m/s, so P is faster."),
   [("Q","Q takes longer (20 s) for the same distance, so Q is slower, not faster."),
    ("both equal","Their times differ (10 s vs 20 s), so their speeds are not equal."),
    ("cannot be decided","Both distances and times are given, so the faster one can be worked out — it is P.")]),

 ("MT","A trekker walks 6 km in the first hour and 4 km in the next hour through a forest. His average speed is:",
   "5 km/h",
   C("Average speed is total distance divided by total time.")+
   steps("Total distance = 6 + 4 = 10 km","Total time = 1 + 1 = 2 h","Average speed = 10 ÷ 2 = 5 km/h."),
   [("10 km/h","That uses only the distance and forgets to divide by the 2 hours."),
    ("2 km/h","That subtracts 6 − 4; average speed is total distance ÷ total time."),
    ("6 km/h","That uses only the first hour; average speed uses the whole journey, giving 5 km/h.")]),

 ("MT","A pendulum completes 20 oscillations in 40 seconds. The time for one oscillation is:",
   "2 s",
   C("The time period is the total time divided by the number of oscillations.")+
   steps("Total time = 40 s for 20 swings","40 ÷ 20 = 2","each oscillation takes 2 s."),
   [("20 s","That copies the count of swings; you must divide 40 s by 20 swings."),
    ("40 s","That is the time for all 20 swings, not for one."),
    ("0.5 s","That divides 20 by 40 the wrong way round; 40 ÷ 20 = 2 s.")]),

 ("MT","On the same distance–time graph two objects are drawn. The one whose line is steeper is moving:",
   "faster",
   C("A steeper line gains more distance in the same time, meaning a higher speed.")+
   steps("Steeper line = bigger rise per second","more distance covered each second","so that object is faster."),
   [("slower","A slower object gains less distance per second, so its line would be less steep."),
    ("backwards","Steepness shows speed, not direction; a steeper rising line just means faster."),
    ("at rest","An object at rest has a flat line; a steep line means it is moving fast.")]),

 ("MT","A pendulum clock keeps good time because a pendulum's swing repeats after equal intervals; such repeating motion is called:",
   "periodic motion",
   C("Periodic motion is any motion that repeats itself after fixed, equal time intervals.")+
   steps("The bob swings the same way again and again","each swing takes equal time","this repeating is periodic motion."),
   [("random motion","Random motion has no pattern; a pendulum repeats neatly, so it is periodic."),
    ("uniform straight motion","That is moving in a straight line at steady speed, not a repeating swing."),
    ("rest","A swinging pendulum is moving, not at rest.")]),

 ("MT","Which is the greater speed: 1 m/s or 1 km/h? (Remember 1 m/s = 3.6 km/h.)",
   "1 m/s",
   C("Converting shows 1 m/s equals 3.6 km/h, which beats 1 km/h.")+
   steps("1 m/s = 3.6 km/h","compare 3.6 km/h with 1 km/h","3.6 > 1, so 1 m/s is faster."),
   [("1 km/h","1 km/h is only about 0.28 m/s, which is slower than 1 m/s."),
    ("they are equal","They are not equal: 1 m/s equals 3.6 km/h, far more than 1 km/h."),
    ("cannot compare","They can be compared once both are in the same unit; 1 m/s wins.")]),

 ("MT","Average speed for a whole journey is found by dividing the total distance covered by the:",
   "total time taken",
   C("Average speed smooths out the trip: total distance shared over total time.")+
   steps("Add up all the distance","add up all the time","divide distance by time for average speed."),
   [("highest speed reached","The top speed does not give the average; you divide by the total time."),
    ("number of stops","Stops affect the time but the formula divides distance by total time, not by stops."),
    ("starting speed","The starting speed alone is not the average; use total distance ÷ total time.")]),

 ("MT","In a simple pendulum, the small heavy object tied to the end of the thread is called the:",
   "bob",
   C("The bob is the weight at the end of a pendulum's thread that swings back and forth.")+
   steps("A thread hangs from a fixed point","a small heavy ball is tied at its lower end","that ball is the bob."),
   [("pivot","The pivot is the fixed top point the thread hangs from, not the swinging weight."),
    ("axis","An axis is a line something turns about, not the pendulum's hanging weight."),
    ("dial","A dial is the marked face of a clock, not the pendulum's weight.")]),

 ("MT","A train moves at 72 km/h. Written in metres per second (divide by 3.6), this is:",
   "20 m/s",
   C("Divide km/h by 3.6 to get m/s.")+
   steps("72 km/h ÷ 3.6","= 20","so the train moves at 20 m/s."),
   [("72 m/s","That just copies the number; you must divide 72 by 3.6 to convert."),
    ("7.2 m/s","That divides 72 by 10, not by 3.6; the answer is 20 m/s."),
    ("36 m/s","That divides by 2; dividing 72 by 3.6 gives 20 m/s.")]),

 ("MT","A snail creeps 2 cm in 4 seconds. Its speed in centimetres per second is:",
   "0.5 cm/s",
   C("Speed equals distance divided by time, even for tiny motions.")+
   steps("Distance = 2 cm, time = 4 s","Speed = 2 ÷ 4","Speed = 0.5 cm/s."),
   [("8 cm/s","That multiplies 2 by 4; speed is distance divided by time."),
    ("2 cm/s","That ignores the 4 seconds; 2 ÷ 4 = 0.5 cm/s."),
    ("4 cm/s","That uses the time as the answer; speed = 2 ÷ 4 = 0.5 cm/s.")]),
]

# ---------- FORESTS (25) — Science ----------
FO = [
 ("FO","In a forest, the green plants and trees that make their own food using sunlight are called the:",
   "producers",
   C("Producers make their own food by photosynthesis, so they begin every forest food chain.")+
   steps("Green leaves trap sunlight","they make food from water and carbon dioxide","so plants are producers."),
   [("consumers","Consumers eat other organisms for food; producers make their own."),
    ("decomposers","Decomposers break down dead matter; producers make fresh food from sunlight."),
    ("scavengers","Scavengers feed on dead animals; producers make their own food.")]),

 ("FO","The microorganisms and fungi that break down dead leaves and dead animals into humus are the forest's:",
   "decomposers",
   C("Decomposers rot away dead matter and return its nutrients to the soil.")+
   steps("Dead leaves and animals fall to the floor","fungi and microbes break them down","forming humus — they are decomposers."),
   [("producers","Producers make food from sunlight; they do not rot dead matter."),
    ("herbivores","Herbivores eat living plants, not break down dead matter into humus."),
    ("predators","Predators hunt living prey; decomposers act on dead material.")]),

 ("FO","The roof-like covering formed by the branchy tops of the tall forest trees is called the:",
   "canopy",
   C("The canopy is the leafy green roof made where the crowns of tall trees meet.")+
   steps("Tall trees grow side by side","their branchy tops spread out and overlap","forming a roof — the canopy."),
   [("understorey","The understorey is the shorter layer below the canopy, not the top roof."),
    ("humus","Humus is the rotted matter on the forest floor, not the leafy roof."),
    ("herb layer","The herb layer is the small plants near the ground, not the high roof.")]),

 ("FO","The branchy top part of a single tall tree, made of its spreading branches and leaves, is known as its:",
   "crown",
   C("The crown is one tree's branchy head; many crowns together form the canopy.")+
   steps("A trunk rises up","its branches spread out at the top","that branchy top is the tree's crown."),
   [("canopy","The canopy is made of many crowns together, not one tree's top alone."),
    ("root","The root is underground and anchors the tree, not its branchy top."),
    ("bark","Bark is the protective outer skin of the trunk, not the branchy top.")]),

 ("FO","The shorter trees and shrubs that grow in the shade below the tall canopy form the layer called the:",
   "understorey",
   C("The understorey is the middle layer of smaller, shade-tolerant trees and shrubs.")+
   steps("The canopy blocks much of the light","shorter plants grow below it","this shaded layer is the understorey."),
   [("canopy","The canopy is the top roof of tall trees, not the shaded layer beneath it."),
    ("crown","A crown is one tree's branchy top, not a whole layer of shorter plants."),
    ("forest floor","The forest floor is the ground with humus, not the layer of shorter trees.")]),

 ("FO","The dark, crumbly, nutrient-rich material formed when dead plants and animals rot in the forest is called:",
   "humus",
   C("Humus is the rich brown-black matter made by decomposed remains; it feeds the soil.")+
   steps("Dead leaves and animals decay","decomposers break them down","leaving dark, fertile humus."),
   [("clay","Clay is a fine mineral part of soil, not the rotted-matter layer."),
    ("sand","Sand is gritty mineral grains, not the rich rotted material."),
    ("gravel","Gravel is small stones, not the dark rotted plant-and-animal material.")]),

 ("FO","Forests are called the green lungs of the Earth because they absorb carbon dioxide and release:",
   "oxygen",
   C("Through photosynthesis forests give out oxygen, keeping the air fit to breathe.")+
   steps("Leaves take in carbon dioxide","they make food and release oxygen","so forests act like lungs giving oxygen."),
   [("carbon dioxide","Forests take carbon dioxide in; the gas they give out is oxygen."),
    ("nitrogen","Forests do not release nitrogen through photosynthesis; they release oxygen."),
    ("smoke","Healthy forests release oxygen, not smoke.")]),

 ("FO","Tree roots grip the soil firmly and stop it from being washed away by rain; forests therefore prevent:",
   "soil erosion",
   C("Roots bind the soil so flowing water cannot carry it off — that is preventing erosion.")+
   steps("Rain falls on bare ground and washes soil away","tree roots hold the soil in place","so forests prevent soil erosion."),
   [("photosynthesis","Photosynthesis is food-making in leaves; roots holding soil prevents erosion."),
    ("germination","Germination is a seed sprouting, not soil being washed away."),
    ("evaporation","Evaporation is water turning to vapour, not soil being carried off.")]),

 ("FO","A chain that shows who eats whom, such as grass → deer → tiger, is called a:",
   "food chain",
   C("A food chain links living things by the order in which they are eaten.")+
   steps("Grass is eaten by the deer","the deer is eaten by the tiger","this eating order is a food chain."),
   [("food web","A food web is many food chains linked together, not a single straight chain."),
    ("life cycle","A life cycle shows the stages of one organism's life, not who eats whom."),
    ("water cycle","The water cycle traces water through the environment, not feeding order.")]),

 ("FO","In the chain grass → deer → tiger, the deer that eats only plants is a:",
   "herbivore",
   C("A herbivore is an animal that feeds only on plants.")+
   steps("The deer eats grass and leaves","it does not hunt other animals","so the deer is a herbivore."),
   [("carnivore","A carnivore eats other animals; the deer eats only plants."),
    ("producer","A producer makes its own food; the deer must eat plants, so it is a consumer."),
    ("decomposer","A decomposer rots dead matter; the deer eats living plants.")]),

 ("FO","In the chain grass → deer → tiger, the tiger that hunts and eats other animals is a:",
   "carnivore",
   C("A carnivore is a flesh-eater that feeds on other animals.")+
   steps("The tiger hunts the deer","it eats the deer's flesh","so the tiger is a carnivore."),
   [("herbivore","A herbivore eats only plants; the tiger eats animals."),
    ("producer","A producer makes its own food; the tiger must hunt, so it is a consumer."),
    ("scavenger","A scavenger eats already-dead animals; the tiger hunts live prey.")]),

 ("FO","The cutting down of forest trees on a large scale, clearing the land of its trees, is called:",
   "deforestation",
   C("Deforestation is the large-scale removal of a forest's trees.")+
   steps("Trees are cut down across a wide area","the forest cover is lost","this clearing is deforestation."),
   [("afforestation","Afforestation is planting new forests, the opposite of cutting them down."),
    ("germination","Germination is a seed sprouting into a seedling, not tree-cutting."),
    ("pollination","Pollination moves pollen between flowers; it has nothing to do with felling trees.")]),

 ("FO","Forests help bring rain because the water vapour given out by their trees adds moisture to the:",
   "water cycle",
   C("Trees release water vapour, feeding the cycle that forms clouds and rain.")+
   steps("Trees give out water vapour from leaves","the vapour rises and forms clouds","this keeps the water cycle going, bringing rain."),
   [("food chain","A food chain is about eating order, not water rising to make rain."),
    ("rock cycle","The rock cycle is about rocks changing form, not water vapour and rain."),
    ("life cycle","A life cycle is the stages of an organism's life, not the movement of water.")]),

 ("FO","Decomposers are vital in a forest because they return the nutrients locked in dead matter back to the:",
   "soil",
   C("By rotting dead matter, decomposers release its nutrients into the soil for plants to reuse.")+
   steps("Dead leaves and animals hold nutrients","decomposers break them down","the nutrients go back into the soil."),
   [("clouds","Nutrients from decay go into the soil, not up into clouds."),
    ("Sun","The Sun gives light energy; decomposers return nutrients to the soil, not the Sun."),
    ("bark of trees","Released nutrients enter the soil to be taken up by roots, not the bark.")]),

 ("FO","Because its trees regrow and the forest can renew itself if cared for, a forest is described as a:",
   "renewable resource",
   C("A renewable resource can replace itself over time, as a forest does when it regrows.")+
   steps("Old trees die or are cut","new seeds sprout and grow","so a cared-for forest renews itself — it is renewable."),
   [("non-renewable resource","Non-renewable resources like coal cannot regrow; a forest can renew itself."),
    ("man-made resource","A forest is natural, not man-made, even though people can help it grow."),
    ("fossil resource","Fossils form over millions of years and cannot regrow; a forest renews itself.")]),

 ("FO","A forest gives many animals their food, shelter and space to live; for them the forest is a:",
   "habitat",
   C("A habitat is the natural home that provides an organism's needs.")+
   steps("Animals find food in the forest","they find shelter and space there","so the forest is their habitat."),
   [("predator","A predator is an animal that hunts others, not the place where animals live."),
    ("food chain","A food chain is the eating order, not the living-place of the animals."),
    ("producer","A producer is a food-making plant, not the home that animals live in.")]),

 ("FO","By soaking up rainwater and slowing the run-off down slopes, forests help to prevent:",
   "floods",
   C("Forest soil and roots act like a sponge, holding water back so rivers do not overflow.")+
   steps("Rain is caught by leaves and spongy soil","water seeps in slowly instead of rushing off","this slowing prevents floods."),
   [("photosynthesis","Photosynthesis is food-making in leaves, not water control; forests prevent floods."),
    ("sunrise","Sunrise is unrelated to water; forests holding water prevent floods."),
    ("erosion only","While forests also reduce erosion, holding rainwater specifically helps prevent floods.")]),

 ("FO","Forests keep the air balanced by taking in carbon dioxide and giving out oxygen during the process of:",
   "photosynthesis",
   C("Photosynthesis is how green plants use sunlight to make food, taking in CO2 and giving out oxygen.")+
   steps("Leaves take in carbon dioxide and water","sunlight powers food-making","oxygen is released — this is photosynthesis."),
   [("respiration","Respiration uses oxygen and gives out carbon dioxide — the opposite gas exchange."),
    ("evaporation","Evaporation turns water to vapour; it does not swap carbon dioxide for oxygen."),
    ("digestion","Digestion is the breaking down of food in animals, not gas exchange in leaves.")]),

 ("FO","Honey, gum, wood and medicinal plants that people gather from a forest are all examples of forest:",
   "products",
   C("Forest products are the useful materials we obtain from forests.")+
   steps("People collect honey, gum and wood","also medicinal leaves and roots","all these are forest products."),
   [("predators","Predators are hunting animals, not the useful materials gathered from forests."),
    ("decomposers","Decomposers are organisms that rot dead matter, not gathered products."),
    ("habitats","A habitat is a living-place; honey and wood are products taken from the forest.")]),

 ("FO","The constant falling and rotting of leaves keeps the forest floor covered with a dark layer that is rich in:",
   "nutrients",
   C("Rotting leaves form humus, a layer packed with nutrients that feeds new plants.")+
   steps("Leaves fall and decompose","they form a dark humus layer","this layer is rich in nutrients."),
   [("plastic","Forests have no plastic; the rotting-leaf layer is rich in natural nutrients."),
    ("salt","The humus layer is rich in nutrients from decay, not in salt."),
    ("metal","The forest-floor layer is rich in nutrients, not metal.")]),

 ("FO","In most forest food chains there are far more plants than top carnivores, so the number of producers is the:",
   "greatest",
   C("Energy is lost at each feeding step, so the base of producers must be the largest group.")+
   steps("Many plants feed fewer plant-eaters","fewer plant-eaters feed still fewer carnivores","so producers are the most numerous."),
   [("smallest","Producers are the most numerous, not the fewest; top carnivores are the fewest."),
    ("equal to carnivores","Producers far outnumber the top carnivores, so they are not equal."),
    ("zero","There are plenty of producers; their number is the greatest, not zero.")]),

 ("FO","Animals such as vultures that feed on the bodies of already-dead animals are called:",
   "scavengers",
   C("Scavengers clean up by eating dead animals they did not kill themselves.")+
   steps("A dead animal lies on the ground","the vulture feeds on its flesh","such carcass-eaters are scavengers."),
   [("producers","Producers make their own food; scavengers eat dead animals."),
    ("herbivores","Herbivores eat plants; scavengers eat the flesh of dead animals."),
    ("decomposers","Decomposers are microbes and fungi that rot matter; vultures are scavenging animals.")]),

 ("FO","Very little sunlight reaches the dark forest floor because most of it is caught and blocked by the:",
   "canopy",
   C("The thick leafy canopy intercepts most sunlight before it can reach the ground.")+
   steps("Sunlight falls on the treetops","the dense canopy of leaves absorbs most of it","so little light reaches the floor."),
   [("roots","Roots are underground and cannot block sunlight from above."),
    ("humus","Humus lies on the floor; it does not block sunlight from reaching the floor."),
    ("soil","Soil is on the ground; the light is blocked above by the canopy, not the soil.")]),

 ("FO","Where forests are removed, less water vapour rises into the air, which over time can reduce the:",
   "rainfall",
   C("Trees release water vapour that helps form rain; fewer trees mean less rain.")+
   steps("Trees give out water vapour","this vapour helps clouds and rain form","without forests, rainfall can fall."),
   [("sunlight","Removing forests does not dim the Sun; it reduces rainfall by cutting water vapour."),
    ("gravity","Gravity is a constant pull and is not changed by cutting forests."),
    ("number of rocks","Rocks are not affected; it is rainfall that drops when forests vanish.")]),

 ("FO","Plants make food, animals eat plants, both die and decompose, returning nutrients to the soil — this repeating flow is the forest's nutrient:",
   "cycle",
   C("Nutrients keep moving from soil to plants to animals and back to soil, again and again.")+
   steps("Soil nutrients enter plants","plants and animals die and decompose","nutrients return to soil — a never-ending cycle."),
   [("chain","A food chain shows eating order; the round-trip of nutrients is a cycle."),
    ("web","A food web links many chains; the looping return of nutrients is a cycle."),
    ("line","Nutrients return to where they started, making a cycle, not a one-way line.")]),
]

# ---------- ALGEBRAIC EXPRESSIONS (25) — Maths ----------
AE = [
 ("AE","A letter such as x or y that can stand for different number values is called a:",
   "variable",
   C("A variable is a symbol whose value can change, unlike a fixed number.")+
   steps("x can be 1, 2, 10 or any number","its value is not fixed","so x is a variable."),
   [("constant","A constant has a fixed value that never changes; a variable can take many values."),
    ("coefficient","A coefficient is the number multiplying a variable, not the changeable letter itself."),
    ("term","A term is a whole building block of an expression, not the changeable letter alone.")]),

 ("AE","In the expression 4x + 7, the number 7, whose value never changes, is called a:",
   "constant",
   C("A constant is a fixed number in an expression that does not depend on any variable.")+
   steps("4x changes as x changes","7 stays 7 no matter what x is","so 7 is a constant."),
   [("variable","A variable can change value; 7 is fixed, so it is a constant."),
    ("coefficient","A coefficient multiplies a variable; 7 stands alone, so it is a constant."),
    ("factor","A factor is a part multiplied to make a term; 7 here is a standalone constant.")]),

 ("AE","The parts of an expression that are added or subtracted, such as 3x and 5 in 3x + 5, are called its:",
   "terms",
   C("Terms are the pieces of an expression joined by plus or minus signs.")+
   steps("Look at 3x + 5","the + sign separates 3x and 5","so 3x and 5 are the two terms."),
   [("factors","Factors are quantities multiplied within one term, not the added/subtracted pieces."),
    ("coefficients","A coefficient is the number multiplying a variable, not a whole added piece."),
    ("constants","Only a fixed number like 5 is a constant; both 3x and 5 are called terms.")]),

 ("AE","In the term 6y, the number 6 that is multiplied with the variable y is called the:",
   "coefficient",
   C("The coefficient is the number multiplying the variable part of a term.")+
   steps("The term is 6y, meaning 6 × y","the number doing the multiplying is 6","so 6 is the coefficient of y."),
   [("constant","A constant stands alone; 6 here is attached to y, so it is a coefficient."),
    ("variable","The variable is y; 6 is the number multiplying it — the coefficient."),
    ("exponent","An exponent is a small power written above; 6 is the multiplying number, the coefficient.")]),

 ("AE","The pair 4x and 9x, which have exactly the same variable part, are called:",
   "like terms",
   C("Like terms share the same variables raised to the same powers, so they can be combined.")+
   steps("Both terms have the variable x","their variable parts match","so they are like terms."),
   [("unlike terms","Unlike terms have different variable parts; here both are x, so they are like."),
    ("constants","Constants are plain numbers; 4x and 9x both contain x, so they are like terms."),
    ("factors","Factors are multiplied parts of one term; 4x and 9x are separate like terms.")]),

 ("AE","The pair 5x and 5y, which have different variable parts, are called:",
   "unlike terms",
   C("Unlike terms have different variable parts and cannot simply be added together.")+
   steps("One term has x, the other has y","their variable parts differ","so they are unlike terms."),
   [("like terms","Like terms share the same variable; here x and y differ, so they are unlike."),
    ("equal terms","Equal would mean the same value; 5x and 5y differ in their variables."),
    ("constants","Constants are plain numbers; both 5x and 5y carry variables, so they are unlike terms.")]),

 ("AE","An algebraic expression that has only one term, such as 7xy, is called a:",
   "monomial",
   C("A monomial is an expression made of a single term.")+
   steps("Count the terms in 7xy","there is just one","so it is a monomial (mono = one)."),
   [("binomial","A binomial has two terms; 7xy is a single term, so it is a monomial."),
    ("trinomial","A trinomial has three terms; 7xy has only one."),
    ("polynomial of four terms","7xy has one term, far fewer than four; it is a monomial.")]),

 ("AE","An algebraic expression with exactly two terms, such as 3x + 5, is called a:",
   "binomial",
   C("A binomial is an expression made of two terms (bi = two).")+
   steps("Count the terms in 3x + 5","there are two: 3x and 5","so it is a binomial."),
   [("monomial","A monomial has one term; 3x + 5 has two, so it is a binomial."),
    ("trinomial","A trinomial has three terms; 3x + 5 has only two."),
    ("constant","A constant is a single fixed number; 3x + 5 has two terms, so it is a binomial.")]),

 ("AE","An algebraic expression with exactly three terms, such as x + y + 7, is called a:",
   "trinomial",
   C("A trinomial is an expression made of three terms (tri = three).")+
   steps("Count the terms in x + y + 7","there are three: x, y and 7","so it is a trinomial."),
   [("monomial","A monomial has one term; this expression has three."),
    ("binomial","A binomial has two terms; x + y + 7 has three, so it is a trinomial."),
    ("variable","A variable is a single letter; x + y + 7 is a three-term expression — a trinomial.")]),

 ("AE","In the term 5xy, the quantities 5, x and y that are multiplied together to make it are its:",
   "factors",
   C("Factors are the quantities multiplied together within a single term.")+
   steps("5xy means 5 × x × y","each of 5, x and y is multiplied in","so they are the factors of the term."),
   [("terms","Terms are pieces separated by + or −; 5, x and y are multiplied, so they are factors."),
    ("exponents","Exponents are powers; 5, x and y are multiplied parts — the factors."),
    ("constants","Only 5 is a constant; together 5, x and y are the factors of the term.")]),

 ("AE","Adding the like terms 3a + 5a gives:",
   "8a",
   C("Like terms add by combining their coefficients and keeping the same variable.")+
   steps("Both terms have the variable a","add the numbers: 3 + 5 = 8","keep a, giving 8a."),
   [("15a","That multiplies 3 × 5; adding like terms means adding the coefficients, not multiplying."),
    ("8a²","Adding like terms does not change the power of a; the variable stays a, giving 8a."),
    ("8","The variable a must stay; dropping it is wrong. The answer is 8a.")]),

 ("AE","Subtracting 4m from 9m gives:",
   "5m",
   C("Subtract like terms by subtracting their coefficients and keeping the variable.")+
   steps("Both have the variable m","9 − 4 = 5","keep m, giving 5m."),
   [("13m","That adds 9 + 4; the word 'subtract' means 9 − 4 = 5m."),
    ("5","The variable m must remain; the answer is 5m, not just 5."),
    ("5m²","Subtracting like terms does not change the power; the answer is 5m.")]),

 ("AE","The algebraic expression for 'a number x increased by 5' is:",
   "x + 5",
   C("'Increased by 5' means we add 5 to the number.")+
   steps("Start with the number x","increase it by 5 means add 5","so the expression is x + 5."),
   [("x − 5","Minus would mean decreased by 5; 'increased' means add, giving x + 5."),
    ("5x","5x means five times x; 'increased by 5' means add 5, giving x + 5."),
    ("x ÷ 5","Dividing is not increasing; 'increased by 5' means x + 5.")]),

 ("AE","The algebraic expression for 'three less than twice a number n' is:",
   "2n − 3",
   C("'Twice a number' is 2n, and 'three less than' it means subtract 3.")+
   steps("Twice the number n is 2n","three less means subtract 3","so the expression is 2n − 3."),
   [("3 − 2n","'Three less than 2n' subtracts 3 from 2n, not 2n from 3; it is 2n − 3."),
    ("2n + 3","'Less than' means subtract, not add; the answer is 2n − 3."),
    ("3n − 2","'Twice' makes the coefficient 2, not 3; 'three less' subtracts 3, giving 2n − 3.")]),

 ("AE","A jeep's speed is (2t + 5) km/h after t hours of driving. At t = 3, its speed is:",
   "11 km/h",
   C("Substitute the value of t into the expression and work it out.")+
   steps("Put t = 3 into 2t + 5","2 × 3 + 5 = 6 + 5","= 11 km/h."),
   [("16 km/h","That adds 2 + 3 + 5 + 6 loosely; correctly 2 × 3 + 5 = 11."),
    ("25 km/h","That multiplies (2 × 3) by something extra; 2 × 3 + 5 = 11, not 25."),
    ("10 km/h","That forgets the + 5; 2 × 3 = 6, then add 5 to get 11.")]),

 ("AE","The value of the expression 3x + 4 when x = 2 is:",
   "10",
   C("Replace x with its value and simplify.")+
   steps("Put x = 2 into 3x + 4","3 × 2 + 4 = 6 + 4","= 10."),
   [("9","That works 3 + 2 + 4; correctly 3 × 2 = 6, then + 4 = 10."),
    ("14","That does 3 × 2 + 4 wrongly as (3 × 2) + (something); 6 + 4 = 10, not 14."),
    ("18","That multiplies the whole 3x + 4 by something; 3 × 2 + 4 = 10.")]),

 ("AE","A forest patch holds (8n + 3) saplings, where n is the number of rows. The coefficient of n is:",
   "8",
   C("The coefficient is the number multiplying the variable n.")+
   steps("Look at the term with n: 8n","the number multiplying n is 8","so the coefficient of n is 8."),
   [("3","3 is the constant term, not the number multiplying n; the coefficient is 8."),
    ("n","n is the variable itself, not its coefficient; the coefficient is 8."),
    ("11","11 would be 8 + 3 added together; the coefficient of n is just 8.")]),

 ("AE","Simplifying 2x + 3x + 4 by collecting like terms gives:",
   "5x + 4",
   C("Add the like x-terms; the lone constant 4 stays as it is.")+
   steps("2x and 3x are like terms: 2 + 3 = 5x","4 has no like term","so the expression is 5x + 4."),
   [("9x","That wrongly adds 4 into the x-terms; 4 has no x, so it stays separate: 5x + 4."),
    ("5x + 4x","There is only one constant, 4, not 4x; the answer is 5x + 4."),
    ("6x","That multiplies 2 × 3 and drops the 4; correctly 2x + 3x = 5x, then + 4.")]),

 ("AE","An equilateral triangle has each side equal to s. The expression for its perimeter is:",
   "3s",
   C("Perimeter is the total of all sides; three equal sides of s add to 3s.")+
   steps("All three sides equal s","add them: s + s + s","= 3s."),
   [("s³","Adding sides means 3s, not raising s to the power 3."),
    ("s + 3","Each side is s, not 1; three sides give 3s, not s + 3."),
    ("3 + s","Three sides of s multiply to 3s; you do not just add a 3 to one side.")]),

 ("AE","From the list 7x, 3y, 2x, 5y, the like terms 7x and 2x can be added to give:",
   "9x",
   C("Like terms with the same variable add by summing their coefficients.")+
   steps("7x and 2x both have x","7 + 2 = 9","keep x, giving 9x."),
   [("9","The variable x must stay; the sum is 9x, not just 9."),
    ("14x","That multiplies 7 × 2; adding like terms means 7 + 2 = 9x."),
    ("9xy","Adding 7x and 2x keeps only x, not xy; the answer is 9x.")]),

 ("AE","A pen costs ₹p. The expression for the cost of 6 such pens is:",
   "6p",
   C("Multiplying the price of one pen by the number of pens gives the total cost.")+
   steps("One pen costs ₹p","six pens cost 6 × p","= 6p."),
   [("p + 6","Buying 6 pens multiplies the price by 6, not adds 6 to it; the cost is 6p."),
    ("p ÷ 6","Dividing would give the cost of part of a pen; 6 pens cost 6p."),
    ("p⁶","Six pens cost 6 times p, not p raised to the power 6; the answer is 6p.")]),

 ("AE","How many terms are there in the expression 4x² + 3x + 9?",
   "three",
   C("Terms are the pieces separated by plus or minus signs.")+
   steps("The signs split it into 4x², 3x and 9","count these pieces","there are three terms."),
   [("two","There are three pieces (4x², 3x, 9), separated by two plus signs."),
    ("four","Only three pieces are separated by the signs, not four."),
    ("one","The plus signs split it into three separate terms, not one.")]),

 ("AE","In the expression 7y − 2, the constant term is:",
   "−2",
   C("The constant term is the part with no variable, keeping its sign.")+
   steps("7y has the variable y","the part without a variable is −2","so the constant term is −2."),
   [("7","7 is the coefficient of y, not the constant term; the constant is −2."),
    ("2","The minus sign belongs to the constant, so it is −2, not +2."),
    ("y","y is the variable, not the constant term; the constant is −2.")]),

 ("AE","The value of the expression 2a + b when a = 3 and b = 4 is:",
   "10",
   C("Substitute both values and simplify.")+
   steps("Put a = 3, b = 4 into 2a + b","2 × 3 + 4 = 6 + 4","= 10."),
   [("14","That does 2 × (3 + 4); only a is doubled, so 2 × 3 + 4 = 10."),
    ("9","That works 2 + 3 + 4; correctly 2 × 3 + 4 = 10."),
    ("24","That multiplies everything together; 2 × 3 + 4 = 10, not 24.")]),

 ("AE","A forest guard plants t saplings each day. The expression for the number he plants in 7 days is:",
   "7t",
   C("Multiplying the daily number by the number of days gives the total.")+
   steps("Each day he plants t saplings","over 7 days that is 7 × t","= 7t."),
   [("t + 7","Seven days multiply the daily amount by 7, not add 7 to it; the total is 7t."),
    ("t ÷ 7","Dividing would give a daily fraction; 7 days give 7t in total."),
    ("t⁷","Seven days give 7 times t, not t to the power 7; the answer is 7t.")]),
]

# ---------- COMPARING QUANTITIES (25) — Maths ----------
CQ = [
 ("CQ","The comparison of two quantities by division, written in the form 2 : 3, is called their:",
   "ratio",
   C("A ratio compares two quantities by how many times one contains the other.")+
   steps("Compare quantity A with quantity B by division","write it as A : B","this comparison is a ratio."),
   [("percentage","A percentage compares with 100; a colon comparison like 2 : 3 is a ratio."),
    ("average","An average is a single middle value, not a comparison written with a colon."),
    ("product","A product is the result of multiplying; a colon comparison is a ratio.")]),

 ("CQ","The symbol % used in percentages is a short way of writing 'out of':",
   "100",
   C("Per cent means per hundred, so % stands for 'out of 100'.")+
   steps("'Cent' means hundred","per cent = per hundred","so 45% means 45 out of 100."),
   [("ten","Per cent means out of 100, not out of ten."),
    ("1000","Per cent means out of 100, not out of a thousand."),
    ("the total","% always compares with 100 specifically, not with any total.")]),

 ("CQ","The fraction 1/2 written as a percentage is:",
   "50%",
   C("To make a fraction a percentage, multiply it by 100.")+
   steps("Take 1/2","multiply by 100: (1/2) × 100 = 50","so 1/2 = 50%."),
   [("25%","25% equals 1/4, not 1/2; one half is 50%."),
    ("2%","That just copies the 2 from the denominator; 1/2 × 100 = 50%."),
    ("100%","100% is the whole (1), not a half; 1/2 = 50%.")]),

 ("CQ","The percentage 25% written as a fraction in its lowest terms is:",
   "1/4",
   C("A percentage is over 100; simplify the fraction to lowest terms.")+
   steps("25% = 25/100","divide top and bottom by 25","= 1/4."),
   [("1/2","1/2 equals 50%, not 25%; 25% simplifies to 1/4."),
    ("25/10","25% means 25/100, not 25/10; simplified it is 1/4."),
    ("4/1","That flips the fraction; 25/100 simplifies to 1/4, not 4/1.")]),

 ("CQ","20% of 200 is:",
   "40",
   C("Find a percentage of a number by multiplying the number by the percentage over 100.")+
   steps("20% = 20/100","(20/100) × 200 = 0.2 × 200","= 40."),
   [("20","That just repeats the 20; you must take 20% of 200, which is 40."),
    ("400","That doubles 200; 20% of 200 is 40, far less than 200."),
    ("100","100 would be 50% of 200; 20% of 200 is 40.")]),

 ("CQ","The decimal 0.75 written as a percentage is:",
   "75%",
   C("Multiply a decimal by 100 to turn it into a percentage.")+
   steps("Take 0.75","multiply by 100: 0.75 × 100 = 75","so 0.75 = 75%."),
   [("0.75%","That forgets to multiply by 100; 0.75 as a percent is 75%, not 0.75%."),
    ("7.5%","That multiplies by 10 instead of 100; 0.75 × 100 = 75%."),
    ("750%","That multiplies by 1000; 0.75 × 100 = 75%.")]),

 ("CQ","Which of these is an equivalent ratio to 2 : 3?",
   "4 : 6",
   C("Equivalent ratios are made by multiplying both parts by the same number.")+
   steps("Multiply both parts of 2 : 3 by 2","2 × 2 = 4 and 3 × 2 = 6","so 4 : 6 is equivalent."),
   [("3 : 2","That swaps the order; 3 : 2 is a different ratio, not equivalent to 2 : 3."),
    ("2 : 6","That multiplies only the second part; both parts must be multiplied equally."),
    ("4 : 3","That doubles only the first part; both parts must be doubled, giving 4 : 6.")]),

 ("CQ","The ratio 10 : 15 written in its simplest form is:",
   "2 : 3",
   C("Simplify a ratio by dividing both parts by their highest common factor.")+
   steps("The HCF of 10 and 15 is 5","10 ÷ 5 = 2 and 15 ÷ 5 = 3","so the simplest form is 2 : 3."),
   [("5 : 3","Only the first part was divided by 5; both must be divided, giving 2 : 3."),
    ("10 : 15","That is the original ratio, not yet simplified; it reduces to 2 : 3."),
    ("3 : 2","That reverses the order; 10 : 15 simplifies to 2 : 3, not 3 : 2.")]),

 ("CQ","A cyclist's speed rises from 10 km/h to 12 km/h. The percentage increase in her speed is:",
   "20%",
   C("Percentage increase is the rise divided by the original, times 100.")+
   steps("Increase = 12 − 10 = 2","(2 ÷ 10) × 100 = 20","so the increase is 20%."),
   [("2%","That uses the rise of 2 directly as a percent; you must divide by the original 10 first."),
    ("12%","That uses the new speed 12 as the percent; the increase is (2/10) × 100 = 20%."),
    ("120%","That compares with 10 wrongly; the rise of 2 over 10 is 20%, not 120%.")]),

 ("CQ","A shopkeeper buys a bag for ₹200 and sells it for ₹250. His profit percent is:",
   "25%",
   C("Profit percent is the profit divided by the cost price, times 100.")+
   steps("Profit = 250 − 200 = ₹50","(50 ÷ 200) × 100 = 25","so profit is 25%."),
   [("50%","That uses the ₹50 profit as the percent; you must divide by the ₹200 cost first."),
    ("20%","That divides 50 by 250 (the selling price); profit percent uses the cost price, giving 25%."),
    ("12.5%","That divides 50 by 400; the correct base is the ₹200 cost, giving 25%.")]),

 ("CQ","An item bought for ₹500 is sold for ₹400. The loss percent is:",
   "20%",
   C("Loss percent is the loss divided by the cost price, times 100.")+
   steps("Loss = 500 − 400 = ₹100","(100 ÷ 500) × 100 = 20","so the loss is 20%."),
   [("25%","That divides 100 by 400 (the selling price); loss percent uses the ₹500 cost, giving 20%."),
    ("100%","That uses the ₹100 loss as the percent; you must divide by ₹500 first."),
    ("10%","That divides 100 by 1000; the correct base is ₹500, giving 20%.")]),

 ("CQ","The extra money paid for the use of borrowed money over a fixed time is called:",
   "simple interest",
   C("Interest is the charge for borrowing money; when worked out on the original sum only, it is simple interest.")+
   steps("You borrow a principal sum","you pay extra for using it over time","that extra, on the original sum, is simple interest."),
   [("principal","The principal is the money borrowed itself, not the extra paid for using it."),
    ("discount","A discount is money taken off a price, not the charge for borrowing."),
    ("profit","Profit is gain from selling; interest is the charge on borrowed money.")]),

 ("CQ","In the simple-interest formula, the product of principal, rate and time is divided by:",
   "100",
   C("Simple interest = (P × R × T) ÷ 100, because the rate R is a percentage.")+
   steps("Multiply principal × rate × time","the rate is a percent, so divide by 100","that gives the simple interest."),
   [("10","The rate is per hundred, so you divide by 100, not 10."),
    ("1000","The percentage rate means dividing by 100, not 1000."),
    ("the time","Time is one of the things multiplied on top; the whole product is divided by 100.")]),

 ("CQ","The simple interest on ₹1000 at 5% per year for 2 years is:",
   "₹100",
   C("Use SI = (P × R × T) ÷ 100.")+
   steps("P = 1000, R = 5, T = 2","(1000 × 5 × 2) ÷ 100 = 10000 ÷ 100","= ₹100."),
   [("₹50","That uses only 1 year; for 2 years (1000 × 5 × 2) ÷ 100 = ₹100."),
    ("₹1000","That repeats the principal; the interest is (1000 × 5 × 2) ÷ 100 = ₹100."),
    ("₹200","That forgets to divide by 100 fully; the correct interest is ₹100.")]),

 ("CQ","If 5 identical pens cost ₹50, then by the unitary method 1 pen costs:",
   "₹10",
   C("The unitary method finds the value of one item first by dividing.")+
   steps("5 pens cost ₹50","one pen = 50 ÷ 5","= ₹10."),
   [("₹50","₹50 is the cost of all 5 pens; one pen is 50 ÷ 5 = ₹10."),
    ("₹250","That multiplies 50 × 5; to find one pen you divide, giving ₹10."),
    ("₹5","That divides 50 by 10; there are 5 pens, so 50 ÷ 5 = ₹10.")]),

 ("CQ","Converting the percentage 65% into a decimal number gives:",
   "0.65",
   C("To turn a percentage into a decimal, divide by 100.")+
   steps("65% = 65/100","65 ÷ 100 = 0.65","so 65% = 0.65."),
   [("6.5","That divides by 10; dividing 65 by 100 gives 0.65."),
    ("65","That forgets to divide by 100; 65% as a decimal is 0.65."),
    ("0.065","That divides by 1000; 65 ÷ 100 = 0.65.")]),

 ("CQ","If 3 out of every 4 children in a class passed a test, the percentage that passed is:",
   "75%",
   C("Turn the fraction passed into a percentage by multiplying by 100.")+
   steps("Fraction passed = 3/4","(3/4) × 100 = 75","so 75% passed."),
   [("34%","That just writes the 3 and 4 together; 3/4 of 100 is 75%."),
    ("25%","25% is the fraction 1/4 (those who failed); 3/4 passed is 75%."),
    ("43%","That reverses the digits; 3/4 as a percentage is 75%.")]),

 ("CQ","In a forest plot of 200 trees, 30% are sal trees. The number of sal trees is:",
   "60",
   C("Find a percentage of a quantity by multiplying the quantity by the percentage over 100.")+
   steps("30% of 200 = (30/100) × 200","= 0.3 × 200","= 60 sal trees."),
   [("30","That just copies the 30; 30% of 200 is 60, not 30."),
    ("170","That is the number that are not sal (70% of 200); the sal trees number 60."),
    ("600","That multiplies 200 by 3; 30% of 200 is 60, not 600.")]),

 ("CQ","A toy's price falls from ₹50 to ₹40. The percentage decrease in its price is:",
   "20%",
   C("Percentage decrease is the drop divided by the original price, times 100.")+
   steps("Decrease = 50 − 40 = ₹10","(10 ÷ 50) × 100 = 20","so the decrease is 20%."),
   [("10%","That uses the ₹10 drop directly; you must divide by the original ₹50 first."),
    ("25%","That divides 10 by 40 (the new price); decrease uses the original ₹50, giving 20%."),
    ("40%","That compares with 25; the drop of 10 over 50 is 20%.")]),

 ("CQ","If 10% of a number is 8, then the whole number is:",
   "80",
   C("If 10% is 8, the full 100% is ten times as much.")+
   steps("10% of the number = 8","100% is 10 times 10%","so the number = 8 × 10 = 80."),
   [("8","8 is only 10% of the number; the whole number is 8 × 10 = 80."),
    ("18","That adds 10 and 8; the number is 8 × 10 = 80."),
    ("800","That multiplies by 100; since 8 is 10%, the number is 8 × 10 = 80.")]),

 ("CQ","The fraction 3/5 expressed as a percentage is:",
   "60%",
   C("Multiply the fraction by 100 to express it as a percentage.")+
   steps("Take 3/5","(3/5) × 100 = 300/5","= 60, so 60%."),
   [("35%","That just writes 3 and 5 together; 3/5 of 100 is 60%."),
    ("53%","That reverses the digits; 3/5 as a percentage is 60%."),
    ("30%","30% is 3/10, not 3/5; three-fifths is 60%.")]),

 ("CQ","Trees and shrubs in a forest patch are in the ratio 3 : 2. If there are 30 in all, the number of trees is:",
   "18",
   C("Split the total in the ratio: find the value of one part, then multiply.")+
   steps("Total parts = 3 + 2 = 5","one part = 30 ÷ 5 = 6","trees = 3 parts = 3 × 6 = 18."),
   [("12","12 is the number of shrubs (2 parts); the trees are 3 parts = 18."),
    ("15","That splits 30 equally in half, ignoring the 3 : 2 ratio; trees = 18."),
    ("10","That uses 30 ÷ 3; you must first find one part as 30 ÷ 5 = 6, so trees = 18.")]),

 ("CQ","A toy's selling price is ₹120 and its cost price is ₹100. The profit made is:",
   "₹20",
   C("Profit is the selling price minus the cost price.")+
   steps("Selling price = ₹120, cost price = ₹100","Profit = 120 − 100","= ₹20."),
   [("₹120","₹120 is the selling price, not the profit; profit = 120 − 100 = ₹20."),
    ("₹220","That adds the two prices; profit is found by subtracting, giving ₹20."),
    ("₹100","₹100 is the cost price, not the profit; the profit is ₹20.")]),

 ("CQ","Out of a 50 km forest trail, a jeep has covered 35 km. The percentage of the trail covered is:",
   "70%",
   C("Turn the fraction covered into a percentage by multiplying by 100.")+
   steps("Fraction covered = 35/50","(35/50) × 100 = 70","so 70% is covered."),
   [("35%","That uses the 35 km directly; you must compare it with the 50 km whole, giving 70%."),
    ("50%","50% would be 25 km; 35 km out of 50 is 70%."),
    ("65%","That uses the 15 km left over the wrong way; 35 out of 50 is 70%.")]),

 ("CQ","If 4 metres of rope cost ₹80, then by the unitary method 7 metres cost:",
   "₹140",
   C("Find the cost of one metre first, then multiply for seven.")+
   steps("4 m cost ₹80, so 1 m = 80 ÷ 4 = ₹20","7 m = 7 × 20","= ₹140."),
   [("₹560","That multiplies 80 × 7 directly; first find one metre (₹20), then × 7 = ₹140."),
    ("₹20","₹20 is the cost of one metre; seven metres cost 7 × 20 = ₹140."),
    ("₹87","That adds 80 and 7; the unitary method gives 7 × 20 = ₹140.")]),
]

# ---------- real-life use-case lines (one per question, in order) ----------
MT_UC = [
 "When you ask 'how fast is that train?', you are really asking for its speed — distance per unit time.",
 "Lab work in physics records speeds in m/s, the SI unit, so results can be compared the world over.",
 "A car on cruise control on an empty highway covers equal distance each second — uniform motion.",
 "City driving with its stops and starts is non-uniform motion; the speed keeps changing.",
 "Scientists read a straight line on a distance–time graph and instantly know the speed was steady.",
 "A flat stretch on a vehicle's distance–time graph marks the minutes it was parked at a signal.",
 "You glance at the speedometer to check you are not crossing the speed limit.",
 "The odometer reading tells a buyer how many kilometres a second-hand car has already run.",
 "Counting a swing's complete back-and-forth — one oscillation — is how a pendulum keeps a clock ticking.",
 "Grandfather clocks are tuned by changing the pendulum's length to set the right time period.",
 "Stopwatches, race timings and cooking timers are all read in seconds, the SI unit of time.",
 "Converting an animal's 36 km/h into 10 m/s lets scientists compare it with lab measurements.",
 "Forest patrols log distance and time so they can report the jeep's speed along each fire-line.",
 "Knowing speed and time lets a coach work out how far a sprinter has run in a few seconds.",
 "Planning a cycle trip, you divide distance by speed to predict how long the ride will take.",
 "In a race, the runner who finishes the same distance in less time is the faster one.",
 "Average speed is how a map app estimates your arrival time over a whole hilly route.",
 "Counting 20 swings and dividing the time gives a quick, accurate time period for one swing.",
 "On a shared graph, the steeper traveller's line instantly shows who is moving faster.",
 "Any motion that repeats on a fixed beat — a heartbeat, a pendulum — is periodic motion.",
 "Converting units the same way both speeds is the only fair way to say which is faster.",
 "Trip computers report average speed as total distance divided by the total time of the journey.",
 "The bob is the swinging weight whose steady time period drives an old pendulum clock.",
 "Train and highway speeds in km/h are converted to m/s for engineering safety calculations.",
 "Even a snail's creep can be measured as a speed: tiny distance shared over the seconds it took.",
]

FO_UC = [
 "Every forest food chain starts with producers — the green plants that capture sunlight.",
 "Decomposers are nature's recyclers, turning the autumn's fallen leaves into fresh, fertile humus.",
 "From a hill you can see the unbroken green canopy stretching like a roof over a dense forest.",
 "A lone shade tree's spreading crown is the same branchy top that, joined to others, makes a canopy.",
 "Shade-loving ferns and shrubs of the understorey thrive in the dim light below the tall trees.",
 "Gardeners add humus-rich compost to soil because it carries the nutrients plants need.",
 "Forests are called the green lungs because the oxygen they release keeps our air breathable.",
 "Hillside forests are planted on purpose to grip the soil and stop monsoon rains eroding it away.",
 "Drawing a food chain like grass → deer → tiger shows how energy passes from one living thing to the next.",
 "Spotting that deer eat only plants tells an ecologist they are the herbivores of the forest.",
 "A tiger at the top of the chain is a carnivore, kept few in number by the energy it takes to feed it.",
 "News of large-scale deforestation warns us that wildlife is losing its home and the air its filter.",
 "The water vapour breathed out by millions of leaves feeds the clouds and the water cycle.",
 "Because decomposers return nutrients to the soil, the same patch of forest can keep growing for centuries.",
 "Calling a forest a renewable resource reminds us it can recover — but only if we let it regrow.",
 "Tigers, birds, insects and deer all find food and shelter in the forest, their shared habitat.",
 "Spongy forest soil soaks up heavy rain, which is why hillsides with forests flood far less.",
 "The same photosynthesis that feeds a tree also tops up the oxygen we breathe.",
 "Honey, gum, timber and herbal medicines are everyday forest products people have used for ages.",
 "The dark, nutrient-rich forest-floor layer is what makes a wild forest so fertile without any fertiliser.",
 "An energy pyramid shows why producers must be the most numerous group at a forest's base.",
 "Vultures, the forest's scavengers, clean up carcasses and stop disease from spreading.",
 "Walking into a thick forest feels cool and dim because the canopy blocks most of the sunlight.",
 "Regions that lose their forests often see their rainfall drop in the years that follow.",
 "Nutrients endlessly cycling from soil to plant to animal and back keep a forest alive on its own.",
]

AE_UC = [
 "Coders and scientists use a variable like x as a placeholder for a value that can change.",
 "A fixed delivery charge added to any order is a constant — it stays the same whatever you buy.",
 "Splitting a bill formula into its terms helps you see exactly what each part stands for.",
 "Reading the coefficient '3' in 3 tickets × price tells you how many of that item you are buying.",
 "You can only add like terms — 3 apples + 5 apples — just as 3x + 5x makes 8x.",
 "Trying to add 5 apples and 5 oranges shows why unlike terms cannot simply be combined.",
 "A single price-times-quantity term, like 7xy, is a monomial used all the time in shopping maths.",
 "A two-part cost such as 'base fare + 3x' is a binomial fare formula used by taxis.",
 "A three-piece formula like length + breadth + height is a trinomial used in packing boxes.",
 "Breaking 5xy into its factors 5, x and y is how you rearrange a formula to solve for one of them.",
 "Adding 3a + 5a to get 8a is the same logic as totalling money of the same kind.",
 "Subtracting 4m from 9m to get 5m is how you work out how much rope is left after cutting some.",
 "Writing 'x + 5' for '5 more than a number' is the first step in turning a word problem into algebra.",
 "Phrases like 'three less than twice' become 2n − 3 when you translate words into an expression.",
 "Plugging t = 3 into a speed formula like 2t + 5 predicts the jeep's speed after three hours.",
 "Substituting a value into 3x + 4 is exactly how a spreadsheet fills in a formula's result.",
 "Reading the coefficient of n in 8n + 3 tells a forester how many saplings each new row adds.",
 "Collecting like terms to simplify 2x + 3x + 4 keeps long formulas short and easy to use.",
 "The perimeter shortcut 3s for an equilateral triangle saves measuring each side separately.",
 "Picking out and adding like terms is how you tidy a messy bill into a clear total.",
 "Writing the cost of 6 pens as 6p lets a shopkeeper bill any number of pens with one formula.",
 "Counting the terms in 4x² + 3x + 9 tells a student what kind of expression they are working with.",
 "Spotting −2 as the constant term in 7y − 2 separates the fixed part from the changing part.",
 "Evaluating 2a + b for given a and b is the everyday work of any formula in science or money.",
 "Writing 7t for saplings over a week lets the forest guard plan a whole planting season at a glance.",
]

CQ_UC = [
 "Mixing paint or juice by a ratio like 2 : 3 keeps the colour or taste the same every time.",
 "Reading '20% off' correctly means knowing % stands for 'out of 100'.",
 "Knowing 1/2 = 50% lets you instantly judge a 'half price' offer in a shop.",
 "Turning 25% back into 1/4 makes it easy to take a quarter off a bill in your head.",
 "Working out 20% of ₹200 is exactly how you check a tip or a discount at a restaurant.",
 "Converting 0.75 to 75% is how a test score in decimals becomes a familiar percentage.",
 "Recipe scaling uses equivalent ratios: doubling 2 : 3 to 4 : 6 keeps the dish tasting right.",
 "Simplifying 10 : 15 to 2 : 3 is how you describe a mix in its plainest, clearest form.",
 "Shops and athletes describe a jump from 10 to 12 as a 20% increase to make it easy to compare.",
 "A shopkeeper works out profit percent on cost to know if a sale was really worth it.",
 "Calculating a 20% loss tells a seller exactly how much a fall in price has cost them.",
 "Understanding simple interest helps you judge how much extra a small loan will really cost.",
 "Banks use the ÷100 in the interest formula because the rate is always quoted as a percentage.",
 "Working SI on ₹1000 at 5% for 2 years is how you check the interest a savings scheme promises.",
 "The unitary method — price of one first — is how you compare which pack at the shop is cheaper.",
 "Turning 65% into 0.65 is what a calculator does before it can multiply a discount for you.",
 "Saying '3 out of 4 passed' as 75% makes class results easy to compare across different-sized classes.",
 "A forester reports '30% of the 200 trees are sal' as 60 trees to make the survey clear.",
 "Spotting a 20% price drop tells a shopper how good a 'sale' really is.",
 "Working backwards from 10% = 8 to the whole number is how you recover a bill from a known tax.",
 "Converting 3/5 to 60% lets you compare a fraction score with a percentage one at a glance.",
 "Dividing 30 trees in a 3 : 2 ratio is how a survey splits a plot into trees and shrubs.",
 "Subtracting cost from selling price to find ₹20 profit is the most basic shopkeeper's sum.",
 "Saying a jeep has covered 70% of a trail tells the team at a glance how much further to go.",
 "The unitary method scales ₹80 for 4 m up to ₹140 for 7 m when you buy a longer piece of rope.",
]


def _with_uc(lst, ucs):
    assert len(lst) == len(ucs) == 25
    out = []
    for it, uc in zip(lst, ucs):
        code, stem, correct, html, distr = it
        out.append((code, stem, correct, html + U(uc), distr))
    return out


MT = _with_uc(MT, MT_UC)
FO = _with_uc(FO, FO_UC)
AE = _with_uc(AE, AE_UC)
CQ = _with_uc(CQ, CQ_UC)

items = []
for i in range(25):
    items += [MT[i], FO[i], AE[i], CQ[i]]
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

    keydist = build_paper(PNUM, TITLE, SHORT, LABELS, items, seed=27419,
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
    split = "/".join(str(counts[c]) for c in ("MT", "FO", "AE", "CQ"))
    with open("PAPERS_MANIFEST.md", "a", encoding="utf-8") as fh:
        fh.write(f"| {PNUM} | 2026-06-18 | {TITLE} | {split} | ✓ |\n")

    # ---- update QUESTION_INDEX.json ----
    idx["fingerprints"] = sorted(existing | set(new_fps))
    idx.setdefault("combos", []).append({
        "paper": PNUM,
        "chapters": ["Motion & Time",
                     "Forests",
                     "Algebraic Expressions",
                     "Comparing Quantities"],
    })
    idx["papers"] = idx.get("papers", 0) + 1
    with open(idx_path, "w", encoding="utf-8") as fh:
        json.dump(idx, fh, ensure_ascii=False, indent=2)
        fh.write("\n")

    print("Files:", sorted(v for v in moves.values()))
    print("Answer key spread A/B/C/D =", dict(keydist))
    print("Fingerprints added:", len(new_fps))
