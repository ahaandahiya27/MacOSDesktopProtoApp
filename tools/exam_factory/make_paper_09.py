# -*- coding: utf-8 -*-
# Boss Challenge Paper 09 — Rational Numbers · Motion & Time · Data Handling · Heat
# Content-only. Uses the dependency-free examfactory engine.
# Produces, under Resources/BossChallengePapers/:
#   Paper_09_<SHORT>_QuestionPaper.html  (pure HTML — questions + options, no answers)
#   Paper_09_<SHORT>_QuestionPaper.pdf
#   Paper_09_<SHORT>_Questions.md
#   Paper_09_<SHORT>_Solutions.html
import os, sys, shutil, json
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from examfactory import build_paper, C, steps, U

PNUM  = "09"
SHORT = "RationalNumbers_MotionTime_DataHandling_Heat"
TITLE = "Rational Numbers · Motion & Time · Data Handling · Heat"
LABELS = {
    "RAT":  "Rational Numbers",
    "MOT":  "Motion & Time",
    "DH":   "Data Handling",
    "HEAT": "Heat",
}

# ---------- RATIONAL NUMBERS (25) ----------
RAT = [
 ("RAT","A number is called rational only if it can be written as p/q where p and q are integers and:",
   "q is not zero",
   C("A rational number is a ratio p/q of integers. Division by zero has no meaning, so the bottom number must not be zero.")+
   steps("Rational means a ratio p/q","p and q are integers","q can be anything EXCEPT 0, since dividing by 0 is undefined.")+
   U("This is why a calculator shows 'error' if you ever divide by zero."),
   [("p is zero","p may be zero (0/5 = 0 is rational); it is q that must not be zero."),
    ("q is zero","If q were zero the fraction would be undefined, so this is exactly what is NOT allowed."),
    ("p equals q","p and q need not be equal; 2/3 is perfectly rational.")]),

 ("RAT","Why is every integer also a rational number?",
   "because any integer can be written as itself over 1",
   C("A rational number is p/q. An integer n equals n/1, which fits that form, so every integer is rational.")+
   steps("Take any integer, say -5","Write it as -5/1","-5/1 is a ratio of integers -> it is rational.")+
   U("So whole numbers and fractions all live inside the bigger family of rational numbers."),
   [("because integers have no sign","Integers do have signs; that is not why they are rational."),
    ("because integers are always positive","Integers can be negative too, yet they are still rational."),
    ("because integers cannot be written as fractions","They CAN: n = n/1, which is exactly why they are rational.")]),

 ("RAT","The rational number -3/4 lies between which two integers on the number line?",
   "-1 and 0",
   C("-3/4 is a negative number a little less than zero, so it sits just to the left of 0.")+
   steps("-3/4 is negative -> left of 0","Its size 3/4 is less than 1","So it lies between -1 and 0.")+
   U("Placing fractions between integers is how a ruler marks the small in-between lengths."),
   [("0 and 1","-3/4 is negative, so it cannot be to the right of 0."),
    ("-4 and -3","-3/4 is bigger than -1; it is nowhere near -4."),
    ("-3 and -2","-3/4 is greater than -1, so it is not between -3 and -2.")]),

 ("RAT","Express 18/24 in its lowest terms.",
   "3/4",
   C("Divide the top and bottom by their highest common factor.")+
   steps("HCF of 18 and 24 is 6","18 / 6 = 3 and 24 / 6 = 4","So 18/24 = 3/4.")+
   U("Reducing fractions keeps answers tidy and easy to compare."),
   [("9/12","9/12 still shares the factor 3; it is not yet in lowest terms."),
    ("6/8","6/8 still shares the factor 2; reduce further to 3/4."),
    ("2/3","Dividing 18 and 24 by 6 gives 3/4, not 2/3.")]),

 ("RAT","Which rational number is greater: -2/3 or -3/4?",
   "-2/3",
   C("For negative numbers, the one closer to zero is greater. Compare using a common denominator.")+
   steps("-2/3 = -8/12 and -3/4 = -9/12","-8/12 is closer to 0 than -9/12","So -2/3 is the greater number.")+
   U("Thinking 'closer to zero is larger' helps read negative temperatures correctly."),
   [("-3/4","-3/4 = -9/12 is farther from zero, so it is the smaller, not greater."),
    ("they are equal","-8/12 and -9/12 are different, so they are not equal."),
    ("they cannot be compared","Any two rational numbers can always be compared.")]),

 ("RAT","Find -3/5 + 1/5.",
   "-2/5",
   C("With the same denominator, just add the numerators and keep the denominator.")+
   steps("Denominators match (both 5)","-3 + 1 = -2","So the sum is -2/5.")+
   U("Adding like fractions is just like adding apples of the same size."),
   [("-4/5","-3 + 1 = -2, not -4; do not subtract the 1."),
    ("2/5","The signs give -3 + 1 = -2, a negative result."),
    ("-2/10","Add only the tops; the denominator stays 5, not 10.")]),

 ("RAT","Add the fractions 1/2 and (-1/3).",
   "1/6",
   C("Use a common denominator of 6, then add.")+
   steps("1/2 = 3/6 and -1/3 = -2/6","3/6 + (-2/6) = 1/6","So the answer is 1/6.")+
   U("A common denominator is the trick for adding any unlike fractions."),
   [("2/5","You cannot add tops and bottoms directly; use a common denominator."),
    ("-1/6","3/6 - 2/6 = +1/6, a positive result."),
    ("1/5","With denominator 6 the answer is 1/6, not 1/5.")]),

 ("RAT","Subtract -2/7 from 3/7.",
   "5/7",
   C("'Subtract A from B' means B - A. Subtracting a negative is the same as adding.")+
   steps("3/7 - (-2/7)","= 3/7 + 2/7","= 5/7.")+
   U("Subtracting a negative shows up when finding a temperature rise from below zero."),
   [("1/7","Subtracting -2/7 ADDS 2/7; 3 + 2 = 5, not 3 - 2 = 1."),
    ("-5/7","Both numbers give a positive result here, +5/7."),
    ("5/14","The denominator stays 7; do not add denominators.")]),

 ("RAT","Find (-2/3) x (3/5).",
   "-2/5",
   C("Multiply tops together and bottoms together, then simplify. A negative times a positive is negative.")+
   steps("(-2 x 3) / (3 x 5) = -6/15","Simplify -6/15 by dividing by 3","= -2/5.")+
   U("Multiplying fractions scales one quantity by another, e.g. two-thirds of a recipe."),
   [("-6/8","Multiply 3 x 5 = 15 on the bottom, not 8."),
    ("2/5","A negative times a positive is negative, so the sign is -."),
    ("-5/6","Multiply across: (-2x3)/(3x5) = -6/15 = -2/5, not -5/6.")]),

 ("RAT","Find (-4/9) divided by (2/3).",
   "-2/3",
   C("To divide by a fraction, multiply by its reciprocal (flip the divisor).")+
   steps("(-4/9) x (3/2)","= -12/18","= -2/3.")+
   U("Dividing fractions answers 'how many of these fit into that'."),
   [("-8/27","Do not multiply straight across; flip the second fraction first."),
    ("2/3","A negative divided by a positive stays negative."),
    ("-6/11","Multiply by the reciprocal 3/2 to get -12/18 = -2/3.")]),

 ("RAT","The reciprocal of -5/7 is:",
   "-7/5",
   C("The reciprocal of a fraction flips its top and bottom; the sign stays the same.")+
   steps("Flip -5/7 to get -7/5","Check: (-5/7) x (-7/5) = 1","A number times its reciprocal is 1.")+
   U("Reciprocals are exactly what you multiply by when dividing fractions."),
   [("5/7","Flipping changes the order of the numbers, not just the sign."),
    ("7/5","The negative sign must stay; the reciprocal is -7/5."),
    ("-5/7","That is the original number, not its reciprocal.")]),

 ("RAT","The additive inverse of -4/9 is:",
   "4/9",
   C("The additive inverse is the number you add to get 0; it has the opposite sign.")+
   steps("We need x with -4/9 + x = 0","x must be +4/9","Check: -4/9 + 4/9 = 0.")+
   U("Additive inverses cancel out, like a debt cancelled by an equal payment."),
   [("-4/9","Adding -4/9 to -4/9 gives -8/9, not 0."),
    ("9/4","That is the reciprocal, not the additive inverse."),
    ("0","Adding 0 leaves -4/9 unchanged; it does not make 0.")]),

 ("RAT","A rational number lying between 1/4 and 1/2 is:",
   "3/8",
   C("Write both with a common denominator and pick a value in between.")+
   steps("1/4 = 2/8 and 1/2 = 4/8","A number between 2/8 and 4/8 is 3/8","So 3/8 lies between them.")+
   U("Finding in-between values is how a number line is split ever finer."),
   [("3/4","3/4 = 6/8 is bigger than 1/2, so it is not between them."),
    ("1/8","1/8 is less than 1/4, so it lies below the range."),
    ("5/8","5/8 is greater than 1/2, so it is above the range.")]),

 ("RAT","Write 5/(-8) with a positive denominator (its standard form).",
   "-5/8",
   C("Move the minus sign from the bottom to the front by multiplying top and bottom by -1.")+
   steps("5/(-8) = (5 x -1)/(-8 x -1)","= -5/8","Standard form keeps the denominator positive.")+
   U("Standard form makes two rational numbers easy to compare at a glance."),
   [("5/8","The value is negative, so a plain 5/8 loses the sign."),
    ("8/5","Do not flip the numbers; just move the sign to the top."),
    ("-8/5","Moving the sign gives -5/8, not -8/5.")]),

 ("RAT","Which fraction is equal to 2/3?",
   "8/12",
   C("Equivalent fractions are made by multiplying top and bottom by the same number.")+
   steps("Multiply 2/3 by 4/4","= 8/12","8/12 reduces back to 2/3, so they are equal.")+
   U("Equivalent fractions let you add or compare unlike fractions."),
   [("6/8","6/8 = 3/4, which is not 2/3."),
    ("4/9","4/9 does not reduce to 2/3."),
    ("3/2","3/2 is the reciprocal of 2/3, not an equal value.")]),

 ("RAT","Among -1, -1/2, 0 and 1/2, the smallest number is:",
   "-1",
   C("On a number line, the value farthest to the left is the smallest.")+
   steps("Order them left to right: -1, -1/2, 0, 1/2","The leftmost is -1","So -1 is the smallest.")+
   U("Ordering negatives correctly is exactly how the coldest temperature is found."),
   [("-1/2","-1/2 is to the right of -1, so it is larger than -1."),
    ("0","0 is larger than both negative numbers here."),
    ("1/2","1/2 is the largest of the four, not the smallest.")]),

 ("RAT","The number 0 can be written as a rational number in the form:",
   "0/5",
   C("Zero is rational because 0 over any non-zero integer equals 0.")+
   steps("0 divided by any non-zero number is 0","0/5 = 0","So 0/5 is a valid way to write 0.")+
   U("Even zero fits the p/q rule, so it belongs to the rational numbers."),
   [("5/0","Dividing by 0 is undefined, so 5/0 is not a number at all."),
    ("1/0","Again the denominator is 0, which is not allowed."),
    ("0 cannot be rational","0 is rational: 0/5 = 0 fits the form p/q.")]),

 ("RAT","Which of these equals the whole number -2?",
   "-6/3",
   C("A fraction equals -2 when its top is -2 times its bottom.")+
   steps("-6/3 = -2 (since -6 / 3 = -2)","Check the others by dividing","Only -6/3 gives exactly -2.")+
   U("Spotting hidden whole numbers inside fractions speeds up arithmetic."),
   [("-3/6","-3/6 = -1/2, not -2."),
    ("-2/3","-2/3 is between 0 and -1, far from -2."),
    ("-6/2","-6/2 = -3, not -2.")]),

 ("RAT","Between any two different rational numbers there are:",
   "infinitely many rational numbers",
   C("You can always find the average of two rationals to get another one in between — and repeat forever.")+
   steps("Take any two rationals","Their average lies between them","You can keep averaging without end -> infinitely many.")+
   U("This 'always room for more' idea is special to rational and real numbers."),
   [("exactly one","You can always find more than one, in fact endlessly many."),
    ("none at all","There is always at least one (their average) in between."),
    ("only ten","There is no fixed limit; the count is infinite.")]),

 ("RAT","Find (-3/4) x 8.",
   "-6",
   C("Write 8 as 8/1, multiply across, then simplify.")+
   steps("(-3/4) x (8/1) = -24/4","-24/4 = -6","So the product is -6.")+
   U("Multiplying a fraction by a whole number scales it up, like 8 three-quarter cups."),
   [("6","A negative times a positive is negative, so it is -6."),
    ("-24","Remember to divide by the 4: -24/4 = -6."),
    ("-3/32","Do not multiply the denominator by 8; write 8 as 8/1.")]),

 ("RAT","The rational number 3/4 written as a decimal is:",
   "0.75",
   C("Divide the top by the bottom: 3 divided by 4.")+
   steps("3 / 4 = 0.75","Check: 0.75 x 4 = 3","So 3/4 = 0.75.")+
   U("Converting to decimals helps compare fractions with money or measurements."),
   [("0.34","0.34 is not 3 divided by 4; 3/4 = 0.75."),
    ("1.33","1.33 is 4/3, the reciprocal, not 3/4."),
    ("0.43","0.43 is just the digits reversed; the true value is 0.75.")]),

 ("RAT","Which of these rational numbers is the largest?",
   "-1/4",
   C("Among negative numbers, the one closest to zero is the largest.")+
   steps("Compare -1/2, -1/4, -3/4, -1","-1/4 is nearest to zero","So -1/4 is the largest.")+
   U("The same logic finds the warmest of several below-zero temperatures."),
   [("-1/2","-1/2 is farther from zero than -1/4, so it is smaller."),
    ("-3/4","-3/4 is even farther left, so smaller still."),
    ("-1","-1 is the farthest from zero, the smallest of all.")]),

 ("RAT","What must be added to -2/5 to get 0?",
   "2/5",
   C("The number that makes a sum of 0 is the additive inverse — the same number with the opposite sign.")+
   steps("We need -2/5 + x = 0","x = +2/5","Check: -2/5 + 2/5 = 0.")+
   U("This is the same idea as paying off an exact debt to reach a zero balance."),
   [("-2/5","Adding -2/5 again gives -4/5, not 0."),
    ("5/2","That is the reciprocal, which does not give a sum of 0."),
    ("0","Adding 0 leaves -2/5 unchanged.")]),

 ("RAT","On the number line, the rational number -1/2 is located:",
   "halfway between -1 and 0",
   C("-1/2 is a negative number exactly half of one unit to the left of 0.")+
   steps("It is negative -> left of 0","Its size is 1/2 of a unit","So it sits halfway between -1 and 0.")+
   U("Marking halves and quarters is how a ruler shows lengths between whole numbers."),
   [("halfway between 0 and 1","-1/2 is negative, so it is to the LEFT of 0."),
    ("exactly at -1","-1/2 is only half a unit from 0, not a full unit."),
    ("exactly at 0","-1/2 is not zero; it is half a unit below it.")]),

 ("RAT","Which of these two rational numbers is the smaller: -5/6 or -1/6?",
   "-5/6",
   C("With the same denominator, the more negative numerator gives the smaller number.")+
   steps("Both have denominator 6","-5 is to the left of -1 on the number line","So -5/6 is the smaller number.")+
   U("The same rule finds the coldest of two below-zero readings."),
   [("-1/6","-1/6 is closer to zero, so it is the larger, not the smaller."),
    ("they are equal","-5/6 and -1/6 have different numerators, so they are not equal."),
    ("neither, both are positive","Both numbers are negative, so they are below zero.")]),
]

# ---------- MOTION & TIME (25) ----------
MOT = [
 ("MOT","The speed of a moving object is found by:",
   "dividing the distance travelled by the time taken",
   C("Speed tells how much distance is covered in each unit of time, so speed = distance / time.")+
   steps("Speed measures distance per unit time","So divide distance by time","speed = distance / time.")+
   U("Reading 'km in an hour' on a road sign is exactly this idea."),
   [("dividing the time taken by the distance","That gives time per distance, which is the upside-down relation."),
    ("multiplying distance by time","Multiplying them does not give a 'per unit time' rate."),
    ("adding distance and time","You cannot add distance and time; they are different quantities.")]),

 ("MOT","The basic (SI) unit of speed is:",
   "metre per second (m/s)",
   C("Speed is distance (metre) per time (second), so its SI unit is metre per second.")+
   steps("SI distance unit = metre","SI time unit = second","So speed's unit = metre / second = m/s.")+
   U("Scientists report wind and vehicle speeds in m/s for clear comparison."),
   [("kilometre (km)","A kilometre measures distance alone, not speed."),
    ("second (s)","A second measures time alone, not speed."),
    ("metre per second squared (m/s^2)","That is the unit of acceleration, not speed.")]),

 ("MOT","Find the speed of a car that travels 60 km in 2 hours.",
   "30 km/h",
   C("Speed = distance / time.")+
   steps("Distance = 60 km, time = 2 h","Speed = 60 / 2","= 30 km/h.")+
   U("This is the average speed you might read off a long highway trip."),
   [("120 km/h","That multiplies 60 x 2; you must divide to get speed."),
    ("62 km/h","Do not add 60 + 2; speed is distance divided by time."),
    ("15 km/h","60 / 2 = 30, not 15.")]),

 ("MOT","A bus covers 150 m in 10 seconds. Its speed is:",
   "15 m/s",
   C("Speed = distance / time, using metres and seconds.")+
   steps("Distance = 150 m, time = 10 s","Speed = 150 / 10","= 15 m/s.")+
   U("City buses are often timed over a measured stretch this way."),
   [("1500 m/s","That multiplies 150 x 10; speed needs division."),
    ("160 m/s","Do not add 150 + 10; divide to find speed."),
    ("10 m/s","150 / 10 = 15, not 10.")]),

 ("MOT","An object moving at constant (uniform) speed covers:",
   "equal distances in equal intervals of time",
   C("Uniform speed means the rate never changes, so equal times always give equal distances.")+
   steps("Speed does not change","So in each equal time slot the same distance is covered","That is the meaning of uniform speed.")+
   U("A car on cruise control covers the same distance each minute."),
   [("more distance in each later second","That would mean the speed is increasing, not constant."),
    ("less distance in each later second","That would mean the speed is decreasing, not constant."),
    ("different distances each second","Constant speed gives equal distances, not different ones.")]),

 ("MOT","A pendulum bob's single complete to-and-fro swing is called one:",
   "oscillation",
   C("A single back-and-forth motion of the pendulum bob is one oscillation.")+
   steps("Bob goes out and comes back to start","That single round trip is one oscillation","Counting these measures the swinging.")+
   U("Old pendulum clocks count oscillations to keep time."),
   [("amplitude","Amplitude is how far the bob swings, not one full swing."),
    ("frequency","Frequency counts how many oscillations per second."),
    ("time period","The time period is the TIME for one oscillation, not the swing itself.")]),

 ("MOT","The time taken for one complete oscillation of a pendulum is its:",
   "time period",
   C("The time period is the time for a single full back-and-forth swing.")+
   steps("One full swing = one oscillation","The time it takes = the time period","Measured in seconds.")+
   U("A 1-second time period is the basis of the old grandfather clocks."),
   [("amplitude","Amplitude is a distance, not a time."),
    ("speed","Speed is distance over time, not the time for one swing."),
    ("frequency","Frequency is the number of swings per second, not the time for one.")]),

 ("MOT","A pendulum completes 20 oscillations in 40 seconds. Its time period is:",
   "2 s",
   C("Time period = total time / number of oscillations.")+
   steps("Total time = 40 s, oscillations = 20","Time period = 40 / 20","= 2 s.")+
   U("Averaging over many swings makes the measured time period more accurate."),
   [("20 s","Divide the time by the number of swings, not by 2."),
    ("40 s","40 s is the total time, not the time for one swing."),
    ("800 s","Do not multiply 20 x 40; divide to find the period.")]),

 ("MOT","The speedometer of a vehicle measures its:",
   "speed",
   C("As its name says, a speedometer shows how fast the vehicle is moving.")+
   steps("'Speed-o-meter' -> measures speed","It reads in km/h or m/s","So it shows the vehicle's speed.")+
   U("Watching the speedometer helps a driver obey the speed limit."),
   [("total distance travelled","Distance is shown by the odometer, not the speedometer."),
    ("time of the journey","Time is read from a clock, not the speedometer."),
    ("fuel left in the tank","That is the fuel gauge, a different instrument.")]),

 ("MOT","The odometer of a vehicle measures the:",
   "total distance travelled",
   C("An odometer adds up the distance a vehicle has covered.")+
   steps("'Odo' relates to distance/path","The odometer keeps a running total","So it shows distance travelled.")+
   U("A taxi fare is often based on the odometer reading."),
   [("speed of the vehicle","Speed is shown by the speedometer, not the odometer."),
    ("time taken","Time is measured by a clock, not the odometer."),
    ("engine temperature","That is a temperature gauge, not the odometer.")]),

 ("MOT","On a distance-time graph, a straight line sloping upward shows the object is moving with:",
   "constant (uniform) speed",
   C("A straight slanted line means distance grows by the same amount each second — a steady speed.")+
   steps("Equal distance gained per equal time","That is a straight slanted line","So the speed is constant.")+
   U("Train timetables can be drawn as such distance-time lines."),
   [("zero speed","Zero speed would be a flat horizontal line, not a slope."),
    ("steadily increasing speed","Increasing speed gives a curve that bends upward, not a straight line."),
    ("backward motion","An upward slope shows forward motion, not backward.")]),

 ("MOT","On a distance-time graph, a horizontal (flat) straight line means the object is:",
   "at rest",
   C("A flat line means the distance is not changing as time passes, so the object is not moving.")+
   steps("Distance stays the same over time","No change in position","So the object is at rest.")+
   U("A parked car would trace a flat line on such a graph."),
   [("moving very fast","Fast motion gives a steep slope, not a flat line."),
    ("speeding up","Speeding up gives an upward-bending curve, not a flat line."),
    ("slowing down","Slowing down still changes distance; a flat line shows no change at all.")]),

 ("MOT","Convert a speed of 72 km/h into metres per second.",
   "20 m/s",
   C("To go from km/h to m/s, multiply by 1000 (m per km) and divide by 3600 (s per hour).")+
   steps("72 x 1000 = 72000 m per hour","72000 / 3600 = 20","So 72 km/h = 20 m/s.")+
   U("Scientists convert vehicle speeds to m/s to use in formulas."),
   [("72 m/s","The number changes on converting units; 72 km/h is 20 m/s."),
    ("200 m/s","Divide by 3600, not 360; the answer is 20 m/s."),
    ("2 m/s","72000 / 3600 = 20, not 2.")]),

 ("MOT","A train moves at a uniform speed and covers 240 km in 4 hours. How far does it go in 1 hour?",
   "60 km",
   C("At uniform speed, distance in one hour equals the speed. Speed = distance / time.")+
   steps("Speed = 240 / 4 = 60 km/h","Uniform speed -> 60 km each hour","So 60 km in 1 hour.")+
   U("This is how you estimate arrival times on a steady journey."),
   [("240 km","240 km is the distance for 4 hours, not 1 hour."),
    ("4 km","Divide 240 by 4 to get 60, not 240 by 60."),
    ("120 km","240 / 4 = 60, not 120.")]),

 ("MOT","Which of these is the FASTEST speed?",
   "1 km per minute",
   C("Convert all to the same unit (km/h) before comparing.")+
   steps("10 m/s = 36 km/h","1 km/min = 60 km/h","60 > 36 > 30, so 1 km/min is fastest.")+
   U("Converting to one unit is the only fair way to compare speeds."),
   [("10 m/s","10 m/s is 36 km/h, slower than 60 km/h."),
    ("30 km/h","30 km/h is the slowest of the three."),
    ("they are all equal","Converted, they are 36, 30 and 60 km/h — not equal.")]),

 ("MOT","A car's position is noted every second as 0 m, 5 m, 10 m, 15 m. The car's speed is:",
   "5 m/s",
   C("The car gains 5 m every second, so its speed is 5 m per second and it is uniform.")+
   steps("Each second the distance rises by 5 m","Equal gains -> uniform speed","Speed = 5 m / 1 s = 5 m/s.")+
   U("Reading a position-time table like this is how motion sensors report speed."),
   [("15 m/s","15 m is the total after 3 s, not the speed per second."),
    ("10 m/s","The gain each second is 5 m, not 10 m."),
    ("0 m/s","The position keeps changing, so the car is not at rest.")]),

 ("MOT","If the length of a simple pendulum is increased, its time period:",
   "increases",
   C("A longer pendulum swings more slowly, so each oscillation takes more time.")+
   steps("Longer string -> slower swing","Slower swing -> more time per oscillation","So the time period increases.")+
   U("Clockmakers lengthen the pendulum slightly to make a fast clock run slower."),
   [("decreases","A longer pendulum is slower, so the period gets longer, not shorter."),
    ("stays exactly the same","Length clearly affects a pendulum's period."),
    ("becomes zero","The pendulum still swings, so its period is never zero.")]),

 ("MOT","An object that is not moving has a speed of:",
   "zero",
   C("Speed is distance covered per unit time. If no distance is covered, the speed is zero.")+
   steps("No motion -> no distance covered","Distance = 0 in any time","Speed = 0 / time = 0.")+
   U("A car waiting at a red light has a speed of zero."),
   [("one","A still object covers no distance, so its speed is 0, not 1."),
    ("its top speed","An object at rest is not moving at all, let alone at top speed."),
    ("equal to the time","Speed and time are different quantities; a still object's speed is 0.")]),

 ("MOT","Two stations are 180 km apart and a train takes 3 hours between them. Its average speed is:",
   "60 km/h",
   C("Average speed = total distance / total time.")+
   steps("Distance = 180 km, time = 3 h","Average speed = 180 / 3","= 60 km/h.")+
   U("Railway timetables are planned around such average speeds."),
   [("540 km/h","That multiplies 180 x 3; average speed needs division."),
    ("183 km/h","Do not add 180 + 3; divide distance by time."),
    ("30 km/h","180 / 3 = 60, not 30.")]),

 ("MOT","The to-and-fro motion of a child on a swing is an example of:",
   "periodic (oscillatory) motion",
   C("Motion that repeats the same path in equal times is periodic, like a swing or a pendulum.")+
   steps("The swing repeats the same back-and-forth path","Each repeat takes the same time","So the motion is periodic / oscillatory.")+
   U("Heartbeats and pendulums are other everyday periodic motions."),
   [("straight-line motion","A swing curves back and forth; it does not go in a straight line forever."),
    ("random motion","The swing repeats a fixed pattern, so it is not random."),
    ("no motion at all","The swing is clearly moving as it goes back and forth.")]),

 ("MOT","Which relation correctly gives the distance travelled?",
   "distance = speed x time",
   C("Rearranging speed = distance / time gives distance = speed x time.")+
   steps("Start from speed = distance / time","Multiply both sides by time","distance = speed x time.")+
   U("This lets you predict how far a steady-moving vehicle will travel."),
   [("speed = distance x time","Speed is distance DIVIDED by time, not multiplied."),
    ("time = speed x distance","Time = distance / speed, not speed x distance."),
    ("distance = speed / time","Distance is speed MULTIPLIED by time, not divided.")]),

 ("MOT","A car travels at a steady 40 km/h for 3 hours. The distance it covers is:",
   "120 km",
   C("Distance = speed x time.")+
   steps("Speed = 40 km/h, time = 3 h","Distance = 40 x 3","= 120 km.")+
   U("This is how you plan how far you can drive before a break."),
   [("43 km","Do not add 40 + 3; multiply speed by time."),
    ("13 km","40 / 3 is not the distance; distance = speed x time = 120 km."),
    ("400 km","40 x 3 = 120, not 400.")]),

 ("MOT","Sand clocks, sundials and water clocks were all early devices used to measure:",
   "time",
   C("Before modern clocks, people tracked the passing of time with the sun, sand and water.")+
   steps("A sundial uses the sun's shadow","Sand and water clocks track steady flow","All of them measure time.")+
   U("These ancient timers are the ancestors of today's clocks and watches."),
   [("distance","These devices track time, not how far something travels."),
    ("speed","Speed needs both distance and time; these tools measure time only."),
    ("temperature","Temperature is measured by a thermometer, not a sundial.")]),

 ("MOT","If a body covers a greater distance than another in the same time, then its speed is:",
   "greater",
   C("For the same time, more distance means a higher speed, since speed = distance / time.")+
   steps("Same time for both bodies","One covers more distance","More distance in equal time -> greater speed.")+
   U("In a race over a fixed time, the runner who covers more ground is faster."),
   [("smaller","More distance in the same time means MORE speed, not less."),
    ("exactly the same","Equal speeds would cover equal distances, but here they differ."),
    ("zero","A body covering distance is moving, so its speed is not zero.")]),

 ("MOT","A cyclist covers 100 m in 4 s and then the next 100 m in 5 s. This shows the cyclist's motion is:",
   "non-uniform (the speed is changing)",
   C("Uniform speed covers equal distances in equal times. Here equal distances took different times, so the speed changed.")+
   steps("First 100 m took 4 s, next 100 m took 5 s","Equal distances but unequal times","So the speed is not constant -> non-uniform motion.")+
   U("Real journeys with traffic and turns are almost always non-uniform."),
   [("uniform (the speed is constant)","Equal distances took different times, so the speed is NOT constant."),
    ("no motion at all","The cyclist clearly moves 200 m, so there is motion."),
    ("circular motion","The data show speed changing, not that the path is a circle.")]),
]

# ---------- DATA HANDLING (25) ----------
DH = [
 ("DH","The arithmetic mean (average) of a set of numbers is found by:",
   "adding all the values and dividing by how many there are",
   C("The mean shares the total equally among all the items.")+
   steps("Add up every value to get the total","Count how many values there are","Divide the total by that count.")+
   U("Your average marks across subjects are found exactly this way."),
   [("choosing the value that appears most often","That is the mode, not the mean."),
    ("picking the middle value","That is the median, not the mean."),
    ("subtracting the smallest from the largest","That is the range, not the mean.")]),

 ("DH","Find the mean of 4, 6, 8 and 10.",
   "7",
   C("Add the four numbers and divide by 4.")+
   steps("4 + 6 + 8 + 10 = 28","There are 4 values","28 / 4 = 7.")+
   U("This is how an average daily score is worked out."),
   [("8","8 is one of the values, not the average; the mean is 28/4 = 7."),
    ("28","28 is the total; you must still divide by 4."),
    ("6","28 / 4 = 7, not 6.")]),

 ("DH","The mode of a set of data is:",
   "the value that occurs most often",
   C("The mode is simply the most frequently appearing value.")+
   steps("Look at how many times each value appears","Find the value with the highest count","That value is the mode.")+
   U("Shops track the mode shoe size to stock the most-bought one."),
   [("the middle value","That is the median, not the mode."),
    ("the average of all values","That is the mean, not the mode."),
    ("the largest value","The most COMMON value, not the largest, is the mode.")]),

 ("DH","Find the mode of 2, 3, 3, 5, 7, 3 and 9.",
   "3",
   C("Count how often each value appears; the most frequent one is the mode.")+
   steps("3 appears three times","Every other number appears once","So the mode is 3.")+
   U("Knowing the most common value helps plan, like the busiest hour of a shop."),
   [("9","9 is the largest value but appears only once; the mode is the most frequent."),
    ("5","5 appears just once, so it is not the mode."),
    ("7","7 appears once; the value appearing most (three times) is 3.")]),

 ("DH","The median of a set of data is:",
   "the middle value when the data are arranged in order",
   C("To find the median, sort the values and pick the one in the middle.")+
   steps("Arrange the values in increasing order","Locate the middle value","That middle value is the median.")+
   U("The median income shows a 'typical' value not pulled by extremes."),
   [("the most frequent value","That is the mode, not the median."),
    ("the sum of all values","That total is used for the mean, not the median."),
    ("the difference of the largest and smallest","That is the range, not the median.")]),

 ("DH","Find the median of 5, 2, 9, 7 and 3.",
   "5",
   C("Sort the numbers first, then take the middle one.")+
   steps("Sorted: 2, 3, 5, 7, 9","There are 5 values; the 3rd is the middle","So the median is 5.")+
   U("Sorting before reading the middle is the key step in finding a median."),
   [("9","Take the middle of the SORTED list, not the largest value."),
    ("7","Sorted, the middle (3rd of 5) value is 5, not 7."),
    ("2","2 is the smallest, not the middle value.")]),

 ("DH","Find the median of 4, 8, 6 and 10.",
   "7",
   C("With an even count, the median is the mean of the two middle sorted values.")+
   steps("Sorted: 4, 6, 8, 10","Two middle values are 6 and 8","Median = (6 + 8) / 2 = 7.")+
   U("Averaging the two middles handles data sets with an even number of items."),
   [("6","6 is only one of the two middle values; average it with 8 to get 7."),
    ("8","8 is the other middle value; the median is their average, 7."),
    ("9","The median here is (6+8)/2 = 7, not 9.")]),

 ("DH","The range of the data 12, 7, 9, 20 and 4 is:",
   "16",
   C("The range is the largest value minus the smallest value.")+
   steps("Largest = 20, smallest = 4","Range = 20 - 4","= 16.")+
   U("The range shows how spread out, e.g., a week's temperatures are."),
   [("20","20 is the largest value; the range subtracts the smallest from it."),
    ("4","4 is the smallest value, not the spread."),
    ("24","Range is 20 - 4 = 16, not 20 + 4 = 24.")]),

 ("DH","In a bar graph, the size of each value is shown by the ____ of its bar.",
   "height (length)",
   C("Bars in a bar graph are drawn taller or longer to stand for bigger values.")+
   steps("Each item gets its own bar","A bigger value -> a taller/longer bar","So the height shows the size.")+
   U("Comparing bar heights is the quickest way to read a bar graph."),
   [("colour","Colour may label bars but does not show their values."),
    ("width","Bars usually have equal width; it is the height that varies."),
    ("position only","Position spaces the bars apart; height shows the values.")]),

 ("DH","A double bar graph is most useful when you want to:",
   "compare two sets of data side by side",
   C("A double bar graph places two bars per item, making comparison easy.")+
   steps("Each item gets two bars","One bar per data set","So you can compare both sets directly.")+
   U("Comparing boys' and girls' marks subject by subject uses a double bar graph."),
   [("show a single set of data","A single set needs only a simple bar graph."),
    ("measure time only","Bar graphs compare quantities, not just time."),
    ("hide the larger values","Graphs reveal data; they are not meant to hide it.")]),

 ("DH","The maximum daily temperatures for a week were 30, 31, 32, 30, 31, 32, 31 (in degC). Their mean is:",
   "31 degC",
   C("Add the seven temperatures and divide by 7.")+
   steps("Sum = 30+31+32+30+31+32+31 = 217","There are 7 days","217 / 7 = 31 degC.")+
   U("Weather reports quote such weekly average temperatures."),
   [("30 degC","30 is the lowest reading, not the average of 31."),
    ("32 degC","32 is the highest reading, not the mean."),
    ("33 degC","217 / 7 = 31, not 33.")]),

 ("DH","The chance (probability) of getting a head when tossing a fair coin is:",
   "1 out of 2",
   C("A fair coin has two equally likely results, so a head has 1 chance out of 2.")+
   steps("Two outcomes: head or tail","Both equally likely","Head = 1 out of 2 outcomes.")+
   U("This even chance is why a coin toss decides who starts a game."),
   [("1 out of 6","6 outcomes belong to a die, not a coin."),
    ("certain to happen","A head is only likely, not certain; a tail can appear."),
    ("impossible","A head can certainly appear, so it is not impossible.")]),

 ("DH","When you roll an ordinary six-faced die, the probability of getting a 4 is:",
   "1 out of 6",
   C("A die has six equally likely faces, so any one number has 1 chance out of 6.")+
   steps("Six faces: 1 to 6","Each equally likely","Getting a 4 = 1 out of 6.")+
   U("Board games rely on this equal chance for each number."),
   [("1 out of 2","1 out of 2 is for a coin, not a six-faced die."),
    ("4 out of 6","There is only ONE face showing 4, so it is 1 out of 6."),
    ("certain","A 4 is only one possible result, so it is not certain.")]),

 ("DH","An event that is certain to happen has a probability of:",
   "1",
   C("Probability runs from 0 (impossible) to 1 (certain). A sure event scores 1.")+
   steps("Probability scale: 0 to 1","Certain = the top of the scale","So a certain event has probability 1.")+
   U("'The sun will rise tomorrow' is treated as a near-certain event."),
   [("0","0 means impossible, the opposite of certain."),
    ("1/2","1/2 is an even chance, not certainty."),
    ("6","Probability never exceeds 1, so it cannot be 6.")]),

 ("DH","An event that can never happen has a probability of:",
   "0",
   C("An impossible event sits at the very bottom of the probability scale, which is 0.")+
   steps("Probability scale: 0 to 1","Impossible = the bottom of the scale","So an impossible event has probability 0.")+
   U("'Rolling a 7 on an ordinary die' is an impossible event, probability 0."),
   [("1","1 means certain, the opposite of impossible."),
    ("1/2","1/2 is an even chance, not an impossibility."),
    ("10","Probability is never above 1, so it cannot be 10.")]),

 ("DH","Information collected as numbers or facts for a definite purpose is called:",
   "data",
   C("Data is the collection of observations or numbers gathered for some purpose.")+
   steps("We gather facts or figures","For a specific purpose","This collection is called data.")+
   U("A class height survey collects data before it can be analysed."),
   [("a graph","A graph displays data; it is not the data itself."),
    ("an average","An average is calculated FROM data, not the data itself."),
    ("a range","The range is a measure found from data, not the data.")]),

 ("DH","To decide the single most popular flavour of ice cream sold, the best average to use is the:",
   "mode",
   C("The most popular item is the one chosen most often, which is exactly the mode.")+
   steps("'Most popular' means most frequently chosen","The most frequent value is the mode","So use the mode.")+
   U("Shops reorder the mode (best-selling) flavour first."),
   [("mean","An average flavour has no meaning; popularity is about frequency."),
    ("median","The middle flavour does not tell you the most popular one."),
    ("range","The range measures spread, not popularity.")]),

 ("DH","If every value in a data set is 8, then the mean of the set is:",
   "8",
   C("When all values are the same, their average is that same value.")+
   steps("All values equal 8","Total = 8 x (number of values)","Dividing by the count gives 8.")+
   U("If everyone scores the same, the class average equals that score."),
   [("0","Averaging equal 8's gives 8, not 0."),
    ("16","Doubling is not averaging; the mean of all-8 data is 8."),
    ("4","Halving is not averaging; the mean stays 8.")]),

 ("DH","On five nights the temperatures were -2, 0, -3, 1 and -1 (in degC). The lowest temperature was:",
   "-3 degC",
   C("On a number line, the lowest temperature is the one farthest to the left.")+
   steps("Order them: -3, -2, -1, 0, 1","The leftmost (smallest) is -3","So the lowest temperature is -3 degC.")+
   U("Finding the coldest night is exactly this 'most negative' search."),
   [("-1 degC","-1 is warmer (greater) than -3, so it is not the lowest."),
    ("1 degC","1 degC is the highest, not the lowest."),
    ("0 degC","0 is warmer than the negative readings, so not the lowest.")]),

 ("DH","On those same five nights (-2, 0, -3, 1, -1 degC), the range of temperature was:",
   "4 degC",
   C("Range = highest value - lowest value, even with negative numbers.")+
   steps("Highest = 1, lowest = -3","Range = 1 - (-3)","= 1 + 3 = 4 degC.")+
   U("Subtracting a negative is why winter ranges can look surprisingly large."),
   [("2 degC","Subtracting -3 ADDS 3: 1 - (-3) = 4, not 2."),
    ("-2 degC","A range is a positive spread, so it cannot be -2."),
    ("3 degC","1 - (-3) = 4, not 3.")]),

 ("DH","A bar graph is most suitable for:",
   "comparing the quantities of different items",
   C("Bar graphs line up bars of different heights so you can compare items at a glance.")+
   steps("Each item gets a bar","Heights show the values","Comparing the bar heights compares the items.")+
   U("Comparing rainfall in different cities is a classic bar-graph job."),
   [("showing how something changes every second","Rapid change over time suits other displays, not a simple bar graph."),
    ("hiding small values","A bar graph shows all values, big and small."),
    ("listing names with no numbers","A bar graph needs numerical values to draw the bars.")]),

 ("DH","Find the mean of the first five whole numbers 0, 1, 2, 3 and 4.",
   "2",
   C("Add the numbers and divide by how many there are.")+
   steps("0 + 1 + 2 + 3 + 4 = 10","There are 5 numbers","10 / 5 = 2.")+
   U("The mean often lands right in the middle of an evenly spread set."),
   [("10","10 is the total; you must divide by 5."),
    ("3","10 / 5 = 2, not 3."),
    ("2.5","With 5 numbers the mean is 10/5 = 2 exactly, not 2.5.")]),

 ("DH","For the data 7, 7, 7, 8 and 9, the mean, median and mode are respectively:",
   "7.6, 7 and 7",
   C("Work out each separately: mean by adding and dividing, median as the middle, mode as the most frequent.")+
   steps("Mean = (7+7+7+8+9)/5 = 38/5 = 7.6","Median (middle of sorted) = 7","Mode (most frequent) = 7.")+
   U("Reporting all three averages gives a fuller picture of the data."),
   [("7, 7 and 7","The mean is 38/5 = 7.6, not 7."),
    ("7.6, 8 and 7","The middle value of the sorted list is 7, not 8."),
    ("7, 7.6 and 8","The mean is 7.6 and the mode is 7; the values are mixed up here.")]),

 ("DH","A car's speed at five checkpoints was 40, 50, 60, 50 and 50 km/h. The mode of these speeds is:",
   "50 km/h",
   C("The mode is the value that appears most often.")+
   steps("50 appears three times","40 and 60 each appear once","So the mode is 50 km/h.")+
   U("Traffic studies use the mode to find the most common cruising speed."),
   [("40 km/h","40 appears only once; 50 appears most often."),
    ("60 km/h","60 appears only once, so it is not the mode."),
    ("50 km/h is wrong, the mean is the mode","The mode is simply the most frequent value, which is 50 km/h.")]),

 ("DH","Numbers or observations collected before they are organised in any way are called:",
   "raw data",
   C("Freshly collected, unsorted observations are called raw data.")+
   steps("Data is gathered first","It is not yet sorted or grouped","This unorganised form is raw data.")+
   U("A pile of survey answer slips is raw data until you tally them."),
   [("an average","An average is calculated later; it is not the unsorted data."),
    ("a frequency table","A frequency table is organised data, not raw data."),
    ("a bar graph","A bar graph is a display made from data, not raw data.")]),
]

# ---------- HEAT (25) ----------
HEAT = [
 ("HEAT","Heat always flows on its own from a body at a ____ temperature to a body at a ____ temperature.",
   "higher; lower",
   C("Heat naturally moves from hot to cold until both reach the same temperature.")+
   steps("A hotter body has more heat to give","Heat flows out of it","Into the colder body, until they are equal.")+
   U("A hot cup of tea cools because heat flows from the tea to the cooler air."),
   [("lower; higher","Heat does not flow uphill from cold to hot on its own."),
    ("equal; equal","If temperatures are already equal, no net heat flows."),
    ("higher; higher","Heat flows toward the LOWER temperature, not another high one.")]),

 ("HEAT","The instrument used to measure temperature is a:",
   "thermometer",
   C("A thermometer reads how hot or cold something is, in degrees.")+
   steps("Temperature tells the degree of hotness","A thermometer measures it","So we use a thermometer.")+
   U("A doctor uses a clinical thermometer to check for a fever."),
   [("barometer","A barometer measures air pressure, not temperature."),
    ("speedometer","A speedometer measures speed, not temperature."),
    ("ruler","A ruler measures length, not temperature.")]),

 ("HEAT","A healthy human body normally stays at a temperature of about:",
   "37 degC",
   C("A healthy human body stays close to 37 degC.")+
   steps("The body keeps itself near 37 degC","Higher than that often signals a fever","So normal body temperature is about 37 degC.")+
   U("A clinical thermometer marks 37 degC clearly for this reason."),
   [("0 degC","0 degC is the freezing point of water, far below body temperature."),
    ("100 degC","100 degC is boiling water; a body at that heat could not survive."),
    ("50 degC","Normal body temperature is about 37 degC, not 50 degC.")]),

 ("HEAT","A clinical thermometer is built to read temperatures roughly in the range:",
   "35 degC to 42 degC",
   C("A clinical thermometer only needs to cover human body temperatures, a little below and above normal.")+
   steps("Body temperature is around 37 degC","Fevers push it a few degrees higher","So the scale runs about 35 degC to 42 degC.")+
   U("This narrow range makes the small fever changes easy to read."),
   [("0 degC to 100 degC","That huge range is for a laboratory thermometer, not a clinical one."),
    ("-10 degC to 10 degC","The body is never that cold; this range is useless for fevers."),
    ("100 degC to 200 degC","No living body reaches such temperatures.")]),

 ("HEAT","Heat travels through a solid metal rod mainly by the process of:",
   "conduction",
   C("In solids, heat passes from particle to neighbouring particle without the material itself moving — that is conduction.")+
   steps("One end of the rod is heated","Heat passes along, particle to particle","This particle-to-particle transfer is conduction.")+
   U("A metal spoon left in hot soup grows warm by conduction."),
   [("convection","Convection needs a moving liquid or gas, not a solid rod."),
    ("radiation","Radiation needs no material; conduction is the path through a solid."),
    ("evaporation","Evaporation is a liquid turning to vapour, not heat moving through a rod.")]),

 ("HEAT","Heat is transferred through liquids and gases mainly by:",
   "convection",
   C("In fluids, warm portions rise and cooler ones sink, carrying heat around — this is convection.")+
   steps("Warm fluid is lighter and rises","Cooler fluid sinks to take its place","These moving currents carry heat: convection.")+
   U("Boiling water churns because of convection currents."),
   [("conduction","Conduction is the main path in solids, not in moving fluids."),
    ("radiation","Radiation can pass through empty space; convection needs a moving fluid."),
    ("freezing","Freezing is a change of state, not a way heat travels.")]),

 ("HEAT","Heat from the Sun reaches the Earth across empty space by:",
   "radiation",
   C("Radiation can travel through a vacuum, needing no material in between — the only way the Sun's heat can reach us.")+
   steps("Space between Sun and Earth is nearly empty","Conduction and convection need a material","Only radiation crosses a vacuum, so it brings the heat.")+
   U("You feel a fire's warmth across a room by radiation too."),
   [("conduction","Conduction needs a solid path, which empty space cannot give."),
    ("convection","Convection needs a fluid to move, but space is nearly empty."),
    ("only through the air","Most of the journey is through airless space, so air cannot be the path.")]),

 ("HEAT","Among these materials, which is the BEST conductor of heat?",
   "copper",
   C("Metals conduct heat well, and copper is one of the best of all.")+
   steps("Compare metal vs non-metal","Metals conduct heat far better","Copper is an excellent metal conductor.")+
   U("Cooking pans are often copper-bottomed to spread heat quickly."),
   [("wood","Wood is a poor conductor; that is why it is used for handles."),
    ("plastic","Plastic blocks heat well, so it is an insulator, not a good conductor."),
    ("air","Air is a very poor conductor of heat.")]),

 ("HEAT","Materials that do NOT let heat pass through them easily are called:",
   "insulators",
   C("Insulators resist the flow of heat, unlike conductors which let it through.")+
   steps("Some materials block heat flow","These are called insulators","Wood, plastic and wool are examples.")+
   U("A woollen sweater insulates you by slowing heat loss."),
   [("conductors","Conductors LET heat pass easily, the opposite of insulators."),
    ("radiators","A radiator gives out heat; it is not a material that blocks heat."),
    ("metals","Most metals are good conductors, not insulators.")]),

 ("HEAT","In winter we prefer to wear woollen clothes mainly because wool:",
   "traps air and is a poor conductor, keeping body heat in",
   C("Wool holds tiny pockets of air, and trapped air is a poor conductor, so body heat is not lost easily.")+
   steps("Wool traps air in its fibres","Trapped air is a poor conductor of heat","So body heat stays in and we feel warm.")+
   U("This is why fluffy, air-filled clothes feel warmer than thin ones."),
   [("produces heat by itself","Wool does not make heat; it only slows heat from escaping."),
    ("is a very good conductor of heat","A good conductor would let body heat escape, making you cold."),
    ("reflects all the cold into the body","'Cold' is not a thing that flows; wool slows heat leaving the body.")]),

 ("HEAT","During the daytime, a sea breeze blows from the:",
   "sea towards the land",
   C("By day, land heats up faster than the sea. Warm air over land rises and cooler air from the sea moves in.")+
   steps("Land warms faster than the sea by day","Warm air over the land rises","Cooler sea air flows in -> a sea breeze from sea to land.")+
   U("Coastal towns enjoy this cooling sea breeze on hot afternoons."),
   [("land towards the sea","That describes the night-time land breeze, not the day-time sea breeze."),
    ("ground towards the sky only","Breezes blow sideways from sea to land, not straight up."),
    ("east towards west always","The direction depends on land vs sea heating, not a fixed compass way.")]),

 ("HEAT","The handle of a good cooking pan is made of plastic or wood because these materials are:",
   "poor conductors (insulators) of heat",
   C("An insulating handle stays cool enough to hold while the metal pan gets hot.")+
   steps("The metal pan conducts heat strongly","A handle must NOT pass that heat to your hand","So it is made of an insulator like wood or plastic.")+
   U("This is why you can lift a hot pan by its plastic handle safely."),
   [("excellent conductors of heat","A conducting handle would burn your hand."),
    ("magnetic materials","Magnetism has nothing to do with a cool handle."),
    ("able to produce heat","Handles do not make heat; they block it from reaching you.")]),

 ("HEAT","One night the temperature rose from -4 degC to 9 degC. The rise in temperature was:",
   "13 degC",
   C("The rise is the final temperature minus the starting one; subtracting a negative adds.")+
   steps("Rise = 9 - (-4)","= 9 + 4","= 13 degC.")+
   U("Working out temperature changes across zero is everyday weather maths."),
   [("5 degC","9 - 4 ignores the minus sign; 9 - (-4) = 13."),
    ("-13 degC","A rise is positive; the temperature went up by 13 degC."),
    ("9 degC","You must subtract the starting -4; the rise is 13 degC, not 9.")]),

 ("HEAT","A liquid cooled from 10 degC down to -6 degC. The fall in temperature was:",
   "16 degC",
   C("The fall is the starting temperature minus the final one.")+
   steps("Fall = 10 - (-6)","= 10 + 6","= 16 degC.")+
   U("Freezers drop a food's temperature through zero like this."),
   [("4 degC","10 - 6 ignores the minus sign; 10 - (-6) = 16."),
    ("-16 degC","A fall is reported as a positive size: 16 degC."),
    ("6 degC","The change is 10 down to -6, a fall of 16 degC, not 6.")]),

 ("HEAT","In cold weather, dark-coloured clothes can feel warmer than light ones because dark surfaces:",
   "absorb more heat (radiation)",
   C("Dark surfaces soak up more of the heat radiation that falls on them.")+
   steps("Heat reaches us as radiation","Dark surfaces absorb more of it","So dark clothes warm up more in sunlight.")+
   U("Solar water heaters are painted black to absorb more heat."),
   [("reflect more heat away","Reflecting heat keeps you cooler, which is what LIGHT colours do."),
    ("make heat by themselves","Colour cannot create heat; it only absorbs or reflects it."),
    ("turn heat into magnetism","Heat and magnetism are unrelated here.")]),

 ("HEAT","Light-coloured clothes feel cooler in summer because they:",
   "reflect most of the heat away",
   C("Light surfaces bounce back most of the heat radiation, so they stay cooler.")+
   steps("Heat arrives as radiation","Light colours reflect most of it","So less heat is absorbed and you feel cooler.")+
   U("White summer clothes keep you comfortable in strong sunshine."),
   [("absorb most of the heat","Absorbing heat would make them hotter, like dark colours."),
    ("create a cooling breeze","Colour does not make a breeze; it reflects heat."),
    ("freeze the surrounding air","Light clothes simply reflect heat; they do not freeze air.")]),

 ("HEAT","A laboratory thermometer differs from a clinical one mainly because the laboratory one:",
   "has a wider temperature range and no kink to hold the reading",
   C("A lab thermometer must read a broad range (often -10 degC to 110 degC) and lets the reading change freely, so it has no kink.")+
   steps("Lab work needs many temperatures, not just body heat","So its range is much wider","It has no kink, so readings move freely up and down.")+
   U("A lab thermometer measures the temperature of heated water in an experiment."),
   [("can only measure body temperature","That is the clinical thermometer; the lab one has a far wider range."),
    ("has no scale of numbers","A lab thermometer certainly has a numbered scale."),
    ("is always shorter than a clinical one","Length is not the key difference; range and the kink are.")]),

 ("HEAT","The small kink (bend) in a clinical thermometer is there to:",
   "stop the mercury from slipping back so you can read the value",
   C("The kink traps the mercury after it rises, so the reading holds steady while you read it away from the body.")+
   steps("Body heat pushes the mercury up","The kink stops it sliding straight back","So the reading stays put until you shake it down.")+
   U("This is why you must shake a clinical thermometer before reusing it."),
   [("make the thermometer look attractive","The kink is functional, not decorative."),
    ("let the mercury fall back instantly","The kink does the opposite — it holds the mercury in place."),
    ("measure two temperatures at once","A thermometer reads one temperature at a time.")]),

 ("HEAT","A patient's temperature readings were 38, 39, 40 and 39 degC. The mean (average) temperature was:",
   "39 degC",
   C("Add the readings and divide by how many there are.")+
   steps("Sum = 38 + 39 + 40 + 39 = 156","There are 4 readings","156 / 4 = 39 degC.")+
   U("Doctors track an average temperature to judge how a fever is changing."),
   [("38 degC","38 is the lowest single reading, not the average of 39."),
    ("40 degC","40 is the highest reading; the mean is 156/4 = 39."),
    ("156 degC","156 is the total; you must divide by 4.")]),

 ("HEAT","Why can two thin blankets keep you warmer than a single thick blanket of the same total thickness?",
   "the air trapped between the two blankets is a poor conductor of heat",
   C("The layer of trapped air between the blankets blocks heat from escaping, adding extra insulation.")+
   steps("Two blankets trap a layer of air between them","Trapped air is a very poor conductor","So less body heat escapes, keeping you warmer.")+
   U("The same idea makes double-glazed windows good insulators."),
   [("the blankets generate heat between them","Blankets do not make heat; they trap it and slow its escape."),
    ("two blankets weigh less","Weight is not why they are warmer; trapped air is."),
    ("air conducts heat extremely well","If air conducted well it would let heat escape; in fact air insulates.")]),

 ("HEAT","Compared with the sea, land usually heats up and cools down:",
   "faster",
   C("Land changes temperature more quickly than water, which is why coasts have land and sea breezes.")+
   steps("Land warms quickly by day and cools quickly by night","Water changes temperature slowly","So land heats and cools faster than the sea.")+
   U("This difference is what drives the daily sea and land breezes."),
   [("slower","Land actually changes temperature faster than water, not slower."),
    ("at exactly the same rate","If the rates were equal, sea and land breezes would not form."),
    ("not at all","Land clearly warms by day and cools by night.")]),

 ("HEAT","A room heater warms the air near it; this warm air rises and cooler air moves in to replace it. This sets up:",
   "convection currents",
   C("Rising warm air and sinking cool air form circulating convection currents that spread heat through the room.")+
   steps("Warm air near the heater rises","Cooler air sinks and moves in","This circulation is a convection current.")+
   U("Convection currents warm a whole room from a single heater."),
   [("conduction through the walls","The heat here spreads by moving air, which is convection, not conduction."),
    ("radiation only","Although heaters radiate too, the moving air described is convection."),
    ("an electric current","An electric current flows in wires, not in the room's warm air.")]),

 ("HEAT","At sea level, water boils at a temperature of about:",
   "100 degC",
   C("Pure water at normal sea-level pressure boils at 100 degC.")+
   steps("Water turns to steam on boiling","At sea level this happens at 100 degC","So the boiling point is about 100 degC.")+
   U("Cooking instructions assume water boils at 100 degC at sea level."),
   [("0 degC","0 degC is the freezing point of water, not its boiling point."),
    ("37 degC","37 degC is human body temperature, far below boiling."),
    ("50 degC","Water is still only warm at 50 degC; it boils at 100 degC.")]),

 ("HEAT","At normal pressure, ice melts (and water freezes) at a temperature of about:",
   "0 degC",
   C("The melting point of ice and the freezing point of water are both about 0 degC.")+
   steps("Solid ice turns to liquid water on melting","At normal pressure this is at 0 degC","So ice melts at about 0 degC.")+
   U("This is why 0 degC is marked as the freezing point on thermometers."),
   [("100 degC","100 degC is the boiling point, not the melting point."),
    ("37 degC","37 degC is body temperature; ice would have melted long before."),
    ("-10 degC","Ordinary ice melts at 0 degC at normal pressure, not -10 degC.")]),

 ("HEAT","At night a land breeze blows from the land towards the sea. This happens because at night the:",
   "land cools down faster than the sea",
   C("By night the land loses heat faster, so the air over the warmer sea rises and cooler air flows out from the land.")+
   steps("At night land cools faster than the sea","Air over the warmer sea rises","Cooler air flows from land to sea -> a land breeze.")+
   U("Fishermen have long used the night land breeze to sail out to sea."),
   [("sea cools down faster than the land","The sea holds its heat longer; it is the land that cools faster."),
    ("land stays hotter than in the daytime","Land cools at night; it does not get hotter than by day."),
    ("sea freezes every night","The sea does not freeze nightly; the breeze is due to uneven cooling.")]),
]

assert len(RAT)==25 and len(MOT)==25 and len(DH)==25 and len(HEAT)==25, (
    len(RAT), len(MOT), len(DH), len(HEAT))

# Interleave so no two consecutive questions share a chapter, and Maths/Science alternate.
items = []
for i in range(25):
    items += [RAT[i], MOT[i], DH[i], HEAT[i]]
assert len(items) == 100

# Guard: no two consecutive same chapter.
for a, b in zip(items, items[1:]):
    assert a[0] != b[0], (a[1], b[1])

if __name__ == "__main__":
    here = os.path.dirname(os.path.abspath(__file__))
    papers_dir = os.path.abspath(os.path.join(
        here, "..", "..", "desktopAhaan", "Resources", "BossChallengePapers"))
    os.chdir(papers_dir)

    keydist = build_paper(PNUM, TITLE, SHORT, LABELS, items, seed=9091,
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
    split = "/".join(str(counts[c]) for c in ("RAT", "MOT", "DH", "HEAT"))
    with open("PAPERS_MANIFEST.md", "a", encoding="utf-8") as fh:
        fh.write(f"| {PNUM} | 2026-06-18 | {TITLE} | {split} | ✓ |\n")

    print("Files:", sorted(v for v in moves.values()))
    print("Answer key spread A/B/C/D =", dict(keydist))
