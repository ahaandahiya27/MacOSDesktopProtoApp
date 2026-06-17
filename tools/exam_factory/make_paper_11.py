# -*- coding: utf-8 -*-
# Boss Challenge Paper 11 — Motion & Time · Comparing Quantities · Electric Current & its Effects · Algebraic Expressions
# Content-only. Uses the dependency-free examfactory engine.
# Difficulty ramp: this paper leans into FUSION questions that blend a Science
# context (motion, electricity) with a Maths skill (ratio/percent, building an
# expression). Class-7 scope, simple wording, hard thinking.
# Produces, under Resources/BossChallengePapers/:
#   Paper_11_<SHORT>_QuestionPaper.html  (pure HTML — questions + options, no answers)
#   Paper_11_<SHORT>_QuestionPaper.pdf
#   Paper_11_<SHORT>_Questions.md
#   Paper_11_<SHORT>_Solutions.html
import os, sys, shutil, json
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from examfactory import build_paper, C, steps, U

PNUM  = "11"
SHORT = "MotionTime_ComparingQuantities_ElectricCurrent_AlgExpr"
TITLE = "Motion & Time · Comparing Quantities · Electric Current & its Effects · Algebraic Expressions"
LABELS = {
    "MT":  "Motion & Time",
    "CQ":  "Comparing Quantities",
    "EC":  "Electric Current & its Effects",
    "ALG": "Algebraic Expressions",
}

# ---------- MOTION & TIME (25) — Science ----------
MT = [
 ("MT","The speed of a moving object is found by dividing the distance it travels by the:",
   "time taken",
   C("Speed tells how fast something moves. It is the distance covered divided by the time taken to cover it.")+
   steps("Write speed = distance ÷ time","Bigger distance in the same time means more speed","Same distance in less time also means more speed.")+
   U("A speedometer in a car works out this very ratio every moment you drive."),
   [("speed of another object","Another object's speed has nothing to do with how you measure this one's speed."),
    ("mass of the object","Mass tells how heavy a thing is, not how fast it moves."),
    ("force applied to it","Force can change speed, but speed itself is distance divided by time.")]),

 ("MT","In the SI system, speed is measured using the basic unit called the:",
   "metre per second (m/s)",
   C("Speed is distance ÷ time. In SI units distance is in metres and time in seconds, so speed comes out in metre per second.")+
   steps("SI unit of distance = metre","SI unit of time = second","So SI unit of speed = metre ÷ second = m/s.")+
   U("Scientists report the speed of sound as about 340 m/s using this very unit."),
   [("kilometre per hour","km/h is a common everyday unit, but the basic SI unit is m/s."),
    ("metre","A metre measures distance alone, not speed."),
    ("second","A second measures time alone, not speed.")]),

 ("MT","A train moving at 72 km/h has a speed, in metres per second, of:",
   "20 m/s",
   C("To change km/h into m/s, multiply by 5/18 (because 1 km = 1000 m and 1 h = 3600 s).")+
   steps("72 × 5/18","= 360 / 18","= 20 m/s.")+
   U("Engineers convert like this so train speeds can be compared with the speed of sound in m/s."),
   [("72 m/s","The number does not stay the same; km/h must be multiplied by 5/18 to get m/s."),
    ("40 m/s","That would be multiplying by 5/9; the correct factor is 5/18."),
    ("26 m/s","This is just a rough guess; 72 × 5/18 gives exactly 20.")]),

 ("MT","A cyclist covers 30 km in 2 hours. The cyclist's speed is:",
   "15 km/h",
   C("Speed = distance ÷ time, so divide the kilometres by the hours.")+
   steps("Speed = 30 km ÷ 2 h","= 15 km/h","So the cyclist moves 15 km every hour.")+
   U("Fitness apps show your cycling speed by doing exactly this division."),
   [("60 km/h","That multiplies instead of dividing; speed is distance divided by time."),
    ("32 km/h","Adding 30 + 2 is not how speed works; you must divide."),
    ("28 km/h","Subtracting 30 − 2 is wrong; speed is distance ÷ time = 15.")]),

 ("MT","A bus moves at a steady 40 km/h. In 3 hours it covers a distance of:",
   "120 km",
   C("When speed is steady, distance = speed × time.")+
   steps("Distance = 40 km/h × 3 h","= 120 km","The hours cancel and leave kilometres.")+
   U("Bus timetables are planned using distance = speed × time so arrivals are predictable."),
   [("43 km","Adding 40 + 3 is wrong; distance is speed multiplied by time."),
    ("13 km","Subtracting 40 − 3 ÷ ... is wrong; distance = speed × time = 120."),
    ("80 km","That uses only 2 hours; in 3 hours the bus covers 120 km.")]),

 ("MT","A car must cover 150 km at a steady 50 km/h. The time it takes is:",
   "3 hours",
   C("Rearranging speed = distance ÷ time gives time = distance ÷ speed.")+
   steps("Time = 150 km ÷ 50 km/h","= 3 h","So the trip takes 3 hours.")+
   U("Map apps estimate your arrival time using time = distance ÷ speed."),
   [("2 hours","2 h at 50 km/h covers only 100 km, not 150."),
    ("100 hours","That subtracts the numbers; you must divide 150 by 50."),
    ("5 hours","5 h at 50 km/h would be 250 km, far more than 150.")]),

 ("MT","A boy walks 4 km in the first hour and 6 km in the next hour. His average speed for the whole trip is:",
   "5 km/h",
   C("Average speed = total distance ÷ total time, not just the middle of the two speeds for unequal stretches — but here the times are equal so it works out the same.")+
   steps("Total distance = 4 + 6 = 10 km","Total time = 1 + 1 = 2 h","Average speed = 10 ÷ 2 = 5 km/h.")+
   U("Athletes track average pace this way over a whole run, not just one stretch."),
   [("2 km/h","That divides time by distance; average speed is total distance ÷ total time."),
    ("10 km/h","10 km is the total distance, not the speed; divide by the 2 hours."),
    ("6 km/h","6 km/h is only the second hour's speed, not the average of the trip.")]),

 ("MT","An object is in uniform motion when it covers:",
   "equal distances in equal intervals of time",
   C("Uniform motion means the speed never changes — the object covers the same distance in each equal slice of time.")+
   steps("Take equal time gaps, say each of 1 second","If the distance in each gap is the same","Then the motion is uniform.")+
   U("A train running at a fixed speed on a straight track is close to uniform motion."),
   [("unequal distances in equal time","Unequal distances in equal time means the speed is changing — that is non-uniform motion."),
    ("more distance as time passes","Covering more each interval means speeding up, which is non-uniform."),
    ("no distance at all","Covering no distance means the object is at rest, not in uniform motion.")]),

 ("MT","A car speeding up and slowing down in city traffic is an example of:",
   "non-uniform motion",
   C("When speed keeps changing, the motion is non-uniform — unequal distances are covered in equal time intervals.")+
   steps("In traffic the car often brakes and accelerates","Its speed is not steady","So the distances per second keep changing — non-uniform motion.")+
   U("Almost all real road journeys are non-uniform because of signals and turns."),
   [("uniform motion","Uniform motion needs a steady speed; traffic forces constant speed changes."),
    ("no motion","The car is clearly moving, so it is not at rest."),
    ("circular motion only","Speeding up and slowing down is about changing speed, not about a circular path.")]),

 ("MT","The time taken by a simple pendulum to complete one full oscillation is called its:",
   "time period",
   C("One full oscillation is one complete to-and-fro swing. The time for it is the pendulum's time period.")+
   steps("Start the bob at one end","Let it swing across and come back to the start","The time for that whole swing is the time period.")+
   U("Old pendulum clocks keep time because each swing's time period is steady."),
   [("frequency","Frequency is the number of oscillations per second, not the time for one."),
    ("speed","Speed is distance ÷ time; a pendulum's swing is described by its time period."),
    ("amplitude","Amplitude is how far the bob swings out, not the time it takes.")]),

 ("MT","A simple pendulum makes 20 complete oscillations in 40 seconds, so its time period equals:",
   "2 seconds",
   C("Time period = total time ÷ number of oscillations.")+
   steps("Time period = 40 s ÷ 20","= 2 s","So each full swing takes 2 seconds.")+
   U("Scientists time many swings and divide, because one swing is too quick to time accurately."),
   [("20 seconds","20 is the number of oscillations, not the time for one swing."),
    ("40 seconds","40 s is the total time for all 20 swings, not one."),
    ("0.5 seconds","That divides 20 by 40; the time period is 40 ÷ 20 = 2 s.")]),

 ("MT","The instrument in a vehicle that shows its speed directly is the:",
   "speedometer",
   C("A speedometer is built to display how fast the vehicle is moving at that moment.")+
   steps("It reads the turning of the wheels","Converts it into a speed value","Shows the speed on a dial or screen.")+
   U("You glance at the speedometer to keep below the road's speed limit."),
   [("odometer","An odometer shows total distance travelled, not the current speed."),
    ("thermometer","A thermometer measures temperature, not speed."),
    ("barometer","A barometer measures air pressure, not speed.")]),

 ("MT","The total distance covered by a vehicle is measured by its:",
   "odometer",
   C("An odometer keeps adding up the distance the vehicle has travelled.")+
   steps("It counts how many times the wheels turn","Each turn equals a known distance","It adds these up to show total kilometres.")+
   U("A used-car buyer checks the odometer to see how far the car has been driven."),
   [("speedometer","A speedometer shows current speed, not the total distance."),
    ("stopwatch","A stopwatch measures time, not distance."),
    ("ammeter","An ammeter measures electric current, not distance.")]),

 ("MT","On a distance–time graph, the motion of an object moving at constant speed appears as a:",
   "straight slanting line",
   C("At constant speed, equal distances are covered in equal times, so the graph rises steadily as a straight slanting line.")+
   steps("Mark distance up the side and time along the bottom","Equal steps of time give equal steps of distance","Joining the points gives a straight slanting line.")+
   U("Physics teachers read steady speed straight off the slant of such a line."),
   [("horizontal straight line","A flat line means the distance is not changing — the object is at rest."),
    ("curved line bending up","A curve means the speed is changing, not constant."),
    ("zig-zag line","A zig-zag would mean the distance jumps up and down, which is not steady motion.")]),

 ("MT","On a distance–time graph, a horizontal (flat) line means the object is:",
   "at rest (not moving)",
   C("If time goes on but distance stays the same, the object is not moving — it is at rest.")+
   steps("Time keeps increasing along the bottom","But the distance value does not change","So the object stays put — at rest.")+
   U("A parked car drawn on such a graph gives a flat horizontal line."),
   [("moving very fast","Fast motion gives a steep slant, not a flat line."),
    ("speeding up","Speeding up gives an upward curve, not a flat line."),
    ("moving backward fast","Moving backward would lower the distance; a flat line means no movement.")]),

 ("MT","On a distance–time graph, a steeper line means the object is moving:",
   "faster",
   C("A steeper line covers more distance in the same time, which means a higher speed.")+
   steps("Pick the same time gap for two lines","The steeper line rises higher in that gap","More distance in the same time means faster.")+
   U("Comparing two runners' graphs, the steeper line belongs to the quicker runner."),
   [("slower","Slower motion gives a gentler, less steep line."),
    ("backward","Direction is not shown by steepness; a steeper line just means faster."),
    ("at rest","At rest gives a flat line, the opposite of a steep one.")]),

 ("MT","Car A goes 100 km in 2 h; Car B goes 100 km in 4 h. The ratio of A's speed to B's speed is:",
   "2 : 1",
   C("Find each speed first, then compare them as a ratio.")+
   steps("Speed of A = 100 ÷ 2 = 50 km/h","Speed of B = 100 ÷ 4 = 25 km/h","Ratio 50 : 25 = 2 : 1.")+
   U("Race reports compare cars this way: A is twice as fast as B."),
   [("1 : 2","That is B to A; the question asks A to B, which is 2 : 1."),
    ("1 : 1","Equal speeds would need equal times for the same distance, but the times differ."),
    ("3 : 1","50 : 25 simplifies to 2 : 1, not 3 : 1.")]),

 ("MT","A scooter covers 20 km in 30 minutes. Its speed in km/h is:",
   "40 km/h",
   C("Change minutes to hours first, then divide distance by time.")+
   steps("30 minutes = 0.5 hour","Speed = 20 km ÷ 0.5 h","= 40 km/h.")+
   U("Speed limits are in km/h, so we always convert the minutes before comparing."),
   [("20 km/h","That treats 30 minutes as a full hour; 30 min is only half an hour."),
    ("10 km/h","That divides by 2 hours; 30 minutes is half an hour, not two."),
    ("50 km/h","Dividing 20 by 0.5 gives 40, not 50.")]),

 ("MT","A runner's speed is 5 m/s. In km/h this is:",
   "18 km/h",
   C("To change m/s into km/h, multiply by 18/5.")+
   steps("5 × 18/5","= 18","So 5 m/s is 18 km/h.")+
   U("Sports broadcasts switch between m/s and km/h using this same factor."),
   [("5 km/h","The number changes when units change; m/s × 18/5 gives km/h."),
    ("50 km/h","That multiplies by 10; the correct factor is 18/5 = 3.6."),
    ("1.4 km/h","That divides instead of multiplying; 5 m/s is 18 km/h.")]),

 ("MT","Which of these usually moves the fastest?",
   "an aeroplane",
   C("Among everyday movers, an aeroplane travels the greatest distance in the least time.")+
   steps("Compare typical speeds","A jet flies hundreds of km/h","Far faster than a cart, a walker, or a cycle.")+
   U("This is why long trips are flown rather than cycled or walked."),
   [("a bullock cart","A bullock cart is one of the slowest movers listed."),
    ("a person walking","Walking is far slower than flying."),
    ("a bicycle","A bicycle is much slower than an aeroplane.")]),

 ("MT","If a simple pendulum is made longer, its time period generally:",
   "increases",
   C("A longer pendulum takes more time to complete each swing, so its time period increases.")+
   steps("Lengthen the thread of the pendulum","Each to-and-fro swing now takes longer","So the time period goes up.")+
   U("Tall grandfather clocks use long pendulums to give slow, steady seconds."),
   [("decreases","Shortening, not lengthening, makes the swing quicker."),
    ("becomes zero","The pendulum still swings, so the time period is never zero."),
    ("stays exactly the same","Changing the length does change the time period.")]),

 ("MT","A train travels 120 km in 2 h, then 60 km in 1 h. Its average speed for the journey is:",
   "60 km/h",
   C("Average speed = total distance ÷ total time over the whole journey.")+
   steps("Total distance = 120 + 60 = 180 km","Total time = 2 + 1 = 3 h","Average speed = 180 ÷ 3 = 60 km/h.")+
   U("Railways quote average speeds this way to plan long-route timetables."),
   [("90 km/h","That averages the two speeds (60 and 60... ) wrongly; use total distance ÷ total time."),
    ("180 km/h","180 km is the total distance, not the speed; divide by 3 hours."),
    ("45 km/h","That divides by 4 instead of the correct total time of 3 hours.")]),

 ("MT","Two towns are 240 km apart. A car at a steady 60 km/h takes how long to drive between them?",
   "4 hours",
   C("Time = distance ÷ speed.")+
   steps("Time = 240 km ÷ 60 km/h","= 4 h","So the drive takes 4 hours.")+
   U("Travel planners use time = distance ÷ speed to book overnight stops on long drives."),
   [("3 hours","3 h at 60 km/h covers only 180 km, not 240."),
    ("6 hours","6 h at 60 km/h would be 360 km, too far."),
    ("2 hours","2 h at 60 km/h covers just 120 km, half the distance.")]),

 ("MT","An object moving at a steady 10 m/s for 5 s covers a distance of:",
   "50 m",
   C("Distance = speed × time when speed is steady.")+
   steps("Distance = 10 m/s × 5 s","= 50 m","The seconds cancel, leaving metres.")+
   U("This is how a stopwatch-and-tape experiment in class measures a trolley's run."),
   [("2 m","That divides 10 by 5; distance is speed × time."),
    ("15 m","That adds 10 + 5; distance is speed multiplied by time."),
    ("10 m","That uses only 1 second; in 5 seconds it covers 50 m.")]),

 ("MT","To measure short time intervals in races we most commonly use a:",
   "stopwatch",
   C("A stopwatch can start and stop instantly and reads to fractions of a second, perfect for races.")+
   steps("Start it as the race begins","Stop it as the runner finishes","Read the short time interval directly.")+
   U("At sports day, teachers time the 100 m dash with a stopwatch."),
   [("calendar","A calendar marks days, far too coarse for a race."),
    ("measuring tape","A measuring tape measures length, not time."),
    ("weighing scale","A weighing scale measures mass, not time.")]),
]

# ---------- COMPARING QUANTITIES (25) — Maths ----------
CQ = [
 ("CQ","A ratio compares two quantities by:",
   "division",
   C("A ratio like 2 : 3 means the first quantity divided by the second, comparing how many times one is of the other.")+
   steps("Write the two quantities","Divide the first by the second","That comparison is the ratio.")+
   U("Recipes use ratios — like 2 cups water to 1 cup rice — to keep the mix right at any size."),
   [("addition","Adding the quantities gives a total, not a comparison of their sizes."),
    ("subtraction","Subtracting gives the difference, not how many times one is of the other."),
    ("multiplication of their squares","A ratio is a simple division, not a product of squares.")]),

 ("CQ","The ratio 20 : 30 in its simplest form is:",
   "2 : 3",
   C("Divide both numbers of the ratio by their highest common factor.")+
   steps("HCF of 20 and 30 is 10","20 ÷ 10 = 2 and 30 ÷ 10 = 3","So 20 : 30 = 2 : 3.")+
   U("Simplifying ratios makes mixing paint colours easy to scale up or down."),
   [("20 : 30","This is not simplified; both numbers share a common factor of 10."),
    ("3 : 2","That flips the order; 20 : 30 simplifies to 2 : 3, not 3 : 2."),
    ("1 : 2","Dividing 20 and 30 by 10 gives 2 : 3, not 1 : 2.")]),

 ("CQ","25% of 80 is:",
   "20",
   C("Per cent means 'out of 100', so 25% = 25/100 = 1/4 of the number.")+
   steps("25% = 1/4","1/4 of 80 = 80 ÷ 4","= 20.")+
   U("A 25%-off sale on an ₹80 item saves you exactly ₹20."),
   [("25","25 is the percentage figure, not 25% of 80."),
    ("40","40 is half (50%) of 80, not a quarter."),
    ("16","16 would be 20% of 80; a quarter of 80 is 20.")]),

 ("CQ","The fraction 3/4 written as a percentage is:",
   "75%",
   C("To turn a fraction into a percentage, multiply it by 100.")+
   steps("3/4 × 100","= 300 ÷ 4","= 75, so 75%.")+
   U("A test score of 3 out of 4 questions correct is reported as 75%."),
   [("34%","Writing the digits 3 and 4 side by side is not how fractions convert."),
    ("43%","Flipping to 4/3 or guessing gives the wrong value; 3/4 is 75%."),
    ("60%","60% is 3/5, not 3/4; three-quarters is 75%.")]),

 ("CQ","The decimal 0.6 written as a percentage is:",
   "60%",
   C("To change a decimal into a percentage, multiply by 100.")+
   steps("0.6 × 100","= 60","So 0.6 = 60%.")+
   U("A battery at 0.6 of full charge shows 60% on your phone."),
   [("6%","6% is 0.06, not 0.6; you must multiply by 100."),
    ("0.6%","0.6% is a tiny amount; 0.6 itself is 60%."),
    ("600%","Multiplying by 1000 is wrong; 0.6 × 100 = 60%.")]),

 ("CQ","50% as a fraction in its simplest form is:",
   "1/2",
   C("50% means 50 out of 100, which simplifies.")+
   steps("50% = 50/100","Divide top and bottom by 50","= 1/2.")+
   U("Splitting a bill 50% each means each person pays one half."),
   [("1/5","1/5 is 20%, not 50%; half is 1/2."),
    ("5/1","5/1 is five whole units, not a half."),
    ("1/50","1/50 is just 2%, far less than a half.")]),

 ("CQ","An item bought for ₹200 is sold for ₹250. The profit is:",
   "₹50",
   C("Profit = selling price − cost price when you sell for more than you paid.")+
   steps("Selling price = ₹250","Cost price = ₹200","Profit = 250 − 200 = ₹50.")+
   U("A shopkeeper works out each day's profit by subtracting cost from sales."),
   [("₹250","₹250 is the selling price, not the profit."),
    ("₹200","₹200 is the cost price, not the profit."),
    ("₹450","Adding the two prices is wrong; profit is the difference, ₹50.")]),

 ("CQ","An item bought for ₹200 is sold for ₹250. The profit percent (on the cost) is:",
   "25%",
   C("Profit percent = (profit ÷ cost price) × 100.")+
   steps("Profit = 250 − 200 = ₹50","Profit percent = (50 ÷ 200) × 100","= 25%.")+
   U("Shops quote 'profit %' so a small and a large sale can be compared fairly."),
   [("50%","₹50 is the profit amount, not the percent; divide by the cost first."),
    ("20%","That divides by the selling price; profit percent is taken on cost price."),
    ("10%","(50 ÷ 200) × 100 = 25%, not 10%.")]),

 ("CQ","A toy bought for ₹120 is sold for ₹90. This is a loss of:",
   "₹30",
   C("When the selling price is less than the cost price, loss = cost price − selling price.")+
   steps("Cost price = ₹120","Selling price = ₹90","Loss = 120 − 90 = ₹30.")+
   U("A clearance sale below cost makes a known loss the seller can plan for."),
   [("₹90","₹90 is the selling price, not the loss."),
    ("₹210","Adding the prices is wrong; loss is their difference, ₹30."),
    ("₹120","₹120 is the cost price, not the loss.")]),

 ("CQ","If 5 pens cost ₹60, then 1 pen costs:",
   "₹12",
   C("The unitary method finds the cost of one by dividing the total by the number of items.")+
   steps("5 pens cost ₹60","1 pen = 60 ÷ 5","= ₹12.")+
   U("Comparing 'price per pen' tells you which pack is the better deal."),
   [("₹60","₹60 is the cost of all 5 pens, not one."),
    ("₹300","Multiplying instead of dividing is wrong; one pen is 60 ÷ 5."),
    ("₹5","₹5 is the number of pens used wrongly as a price; one pen costs ₹12.")]),

 ("CQ","If 1 kg of apples costs ₹80, then 3 kg cost:",
   "₹240",
   C("With the unitary method, multiply the cost of one unit by how many you want.")+
   steps("1 kg costs ₹80","3 kg cost 80 × 3","= ₹240.")+
   U("Market sellers price any weight from the rate for one kilogram."),
   [("₹80","₹80 is the cost of just 1 kg, not 3 kg."),
    ("₹83","Adding 80 + 3 is wrong; multiply 80 by 3."),
    ("₹160","₹160 is the cost of 2 kg; 3 kg cost ₹240.")]),

 ("CQ","Simple interest on ₹1000 at 10% per year for 1 year is:",
   "₹100",
   C("Simple interest = (Principal × Rate × Time) ÷ 100.")+
   steps("SI = (1000 × 10 × 1) ÷ 100","= 10000 ÷ 100","= ₹100.")+
   U("Banks use this formula to tell you the interest a deposit earns in a year."),
   [("₹1000","₹1000 is the principal, not the interest earned."),
    ("₹10","That forgot to multiply by the principal; SI = ₹100."),
    ("₹110","₹110 is principal-plus-interest mixed up; the interest alone is ₹100.")]),

 ("CQ","Simple interest on ₹500 at 8% per year for 2 years is:",
   "₹80",
   C("Use SI = (P × R × T) ÷ 100 with the time in years.")+
   steps("SI = (500 × 8 × 2) ÷ 100","= 8000 ÷ 100","= ₹80.")+
   U("A two-year fixed deposit's earnings are worked out exactly like this."),
   [("₹40","That used only 1 year; the time here is 2 years."),
    ("₹160","That doubled the answer; (500 × 8 × 2) ÷ 100 = 80, not 160."),
    ("₹500","₹500 is the principal, not the interest.")]),

 ("CQ","A plant was 40 cm tall and grew to 50 cm. The percent increase in its height is:",
   "25%",
   C("Percent increase = (increase ÷ original) × 100.")+
   steps("Increase = 50 − 40 = 10 cm","Percent increase = (10 ÷ 40) × 100","= 25%.")+
   U("Gardeners describe growth in per cent so plants of any starting size can be compared."),
   [("10%","10 cm is the increase amount, not the percent; divide by the original 40."),
    ("20%","That divides by the new height (50); percent change is taken on the original."),
    ("50%","(10 ÷ 40) × 100 = 25%, not 50%.")]),

 ("CQ","In a class the ratio of boys to the total number of students is 1 : 4. The percentage of boys is:",
   "25%",
   C("A ratio of part to whole becomes a percentage by dividing and multiplying by 100.")+
   steps("Boys are 1 out of every 4 students","1/4 × 100","= 25%.")+
   U("Schools report such figures as percentages in their yearly records."),
   [("14%","Writing the digits 1 and 4 together is not how ratios convert; 1/4 is 25%."),
    ("40%","40% is 2/5, not 1/4; one quarter is 25%."),
    ("75%","75% would be the share of the non-boys (3 out of 4), not the boys.")]),

 ("CQ","Which ratio is equivalent to 2 : 5?",
   "4 : 10",
   C("Equivalent ratios are made by multiplying (or dividing) both numbers by the same value.")+
   steps("Multiply both parts of 2 : 5 by 2","2 × 2 = 4 and 5 × 2 = 10","So 4 : 10 is equivalent to 2 : 5.")+
   U("Doubling a recipe keeps the same taste because the ratio stays equivalent."),
   [("5 : 2","That flips the order; an equivalent ratio keeps the same order."),
    ("2 : 10","Only the second number was doubled; both must be multiplied by the same value."),
    ("3 : 5","Only the first number changed; that breaks the equal multiplication rule.")]),

 ("CQ","Air is about 21% oxygen. In 200 litres of air, the volume of oxygen is about:",
   "42 litres",
   C("Take 21% of the total volume to find the oxygen part.")+
   steps("21% of 200 = (21 ÷ 100) × 200","= 21 × 2","= 42 litres.")+
   U("Knowing this helps doctors work out oxygen amounts for patients."),
   [("21 litres","21 is the percentage, not 21% of 200 litres."),
    ("200 litres","200 litres is all the air; only about 21% of it is oxygen."),
    ("79 litres","79% is the nitrogen share; the oxygen is 21% = 42 litres.")]),

 ("CQ","A ₹500 shirt is sold at a 10% discount. The discount amount is:",
   "₹50",
   C("Discount amount = (discount percent ÷ 100) × marked price.")+
   steps("Discount = 10% of ₹500","= (10 ÷ 100) × 500","= ₹50.")+
   U("Sale tags show the rupees you save by taking the percent of the price."),
   [("₹10","₹10 is the percent figure, not 10% of ₹500."),
    ("₹450","₹450 is the price after discount, not the discount itself."),
    ("₹100","That is 20% of ₹500; a 10% discount is ₹50.")]),

 ("CQ","A ₹500 shirt is sold at a 10% discount. Its selling price is:",
   "₹450",
   C("Selling price = marked price − discount amount.")+
   steps("Discount = 10% of 500 = ₹50","Selling price = 500 − 50","= ₹450.")+
   U("The final bill price is the marked price minus the discount."),
   [("₹550","That adds the discount; a discount lowers the price."),
    ("₹490","That subtracts only ₹10; the discount is ₹50, giving ₹450."),
    ("₹50","₹50 is the discount amount, not the price you pay.")]),

 ("CQ","What percent is 15 out of 60?",
   "25%",
   C("Percent = (part ÷ whole) × 100.")+
   steps("(15 ÷ 60) × 100","= 0.25 × 100","= 25%.")+
   U("Marks out of a total are turned into a percentage exactly this way."),
   [("15%","15 is the part, not the percent; divide by 60 first."),
    ("45%","45 is 60 − 15, not the percentage; (15 ÷ 60) × 100 = 25%."),
    ("60%","60 is the whole, not the percent of the part.")]),

 ("CQ","₹100 is shared between two friends in the ratio 1 : 4. The smaller share is:",
   "₹20",
   C("Add the ratio parts to find the total parts, then give each share its parts.")+
   steps("Total parts = 1 + 4 = 5","One part = 100 ÷ 5 = ₹20","Smaller share = 1 part = ₹20.")+
   U("Sharing prize money in a fixed ratio uses exactly this method."),
   [("₹25","That divides by 4 parts instead of 5; the total parts are 1 + 4 = 5."),
    ("₹80","₹80 is the larger share (4 parts), not the smaller one."),
    ("₹40","That treats the ratio as 1 : 1.5 or similar; one part of five is ₹20.")]),

 ("CQ","Car A's speed is 60 km/h and Car B's is 75 km/h. Car B is faster than Car A by:",
   "25%",
   C("Percent faster = (difference ÷ A's speed) × 100, comparing the extra speed to A.")+
   steps("Difference = 75 − 60 = 15 km/h","(15 ÷ 60) × 100","= 25%.")+
   U("Car reviews say one model is 'x% faster' using this very comparison."),
   [("15%","15 km/h is the speed difference, not the percent; divide by 60 first."),
    ("20%","That divides by 75 (B's speed); the comparison is on A's speed."),
    ("75%","75 is B's speed, not the percent by which it beats A.")]),

 ("CQ","The fraction 5/8 written as a percentage is:",
   "62.5%",
   C("Multiply the fraction by 100 to get the percentage.")+
   steps("5/8 × 100","= 500 ÷ 8","= 62.5, so 62.5%.")+
   U("A score of 5 out of 8 is reported as 62.5% on a results sheet."),
   [("58%","Reading the digits 5 and 8 is not how fractions convert; 5/8 is 62.5%."),
    ("85%","Flipping to 8/5 or guessing is wrong; 5/8 is 62.5%."),
    ("40%","40% is 2/5, not 5/8; five-eighths is 62.5%.")]),

 ("CQ","₹2000 is kept at 5% per year simple interest for 1 year. The total amount after 1 year is:",
   "₹2100",
   C("First find the interest, then add it to the principal for the total amount.")+
   steps("SI = (2000 × 5 × 1) ÷ 100 = ₹100","Total = principal + interest","= 2000 + 100 = ₹2100.")+
   U("A bank passbook shows this total after a year's interest is added."),
   [("₹2000","₹2000 is only the principal; the interest must be added."),
    ("₹2500","That uses 25% interest; at 5% the interest is just ₹100."),
    ("₹100","₹100 is the interest alone, not the total amount.")]),

 ("CQ","10% of 10% of ₹1000 is:",
   "₹10",
   C("Work from the inside out: take 10% once, then 10% of that result.")+
   steps("10% of 1000 = ₹100","10% of 100 = ₹10","So the answer is ₹10.")+
   U("Layered discounts (a percent off an already-reduced price) work this way."),
   [("₹100","₹100 is only the first 10%; you must take 10% of that again."),
    ("₹1","Taking 10% twice of 1000 gives ₹10, not ₹1."),
    ("₹200","Adding the two 10% steps is wrong; the result is ₹10.")]),
]

# ---------- ELECTRIC CURRENT & ITS EFFECTS (25) — Science ----------
EC = [
 ("EC","In an electric circuit, the cell mainly provides the:",
   "energy that pushes the current around",
   C("A cell stores chemical energy and uses it to push electric charges through the circuit, making the current flow.")+
   steps("Chemical changes happen inside the cell","This pushes charges out of one terminal","The charges flow round the circuit as current.")+
   U("The cell in a torch is what makes the bulb light up when switched on."),
   [("light directly","The cell makes current flow; it is the bulb that turns that into light."),
    ("heat only","A cell drives current; heat is just one effect of that current."),
    ("magnetism only","Magnetism is an effect of the current, not what the cell provides.")]),

 ("EC","A combination of two or more cells joined together is called a:",
   "battery",
   C("When cells are joined end to end, the group is called a battery, giving more voltage than one cell.")+
   steps("Take two or more cells","Join the positive of one to the negative of the next","The group is a battery.")+
   U("A TV remote uses a battery of two cells to get enough push for the circuit."),
   [("switch","A switch only opens or closes the circuit; it does not provide energy."),
    ("fuse","A fuse is a safety device, not a group of cells."),
    ("bulb","A bulb gives light; it is not a group of cells.")]),

 ("EC","A switch is used in a circuit to:",
   "make or break the circuit (turn it on or off)",
   C("A switch is a simple gap that can be closed to let current flow or opened to stop it.")+
   steps("Closed switch: the loop is complete and current flows","Open switch: there is a gap and no current flows","So a switch turns the circuit on or off.")+
   U("The light switch on your wall opens and closes the room's circuit."),
   [("store electricity","A switch does not store energy; that is a cell's role."),
    ("increase the cell's voltage","A switch cannot raise voltage; it only opens or closes the path."),
    ("measure current","Measuring current needs an ammeter, not a switch.")]),

 ("EC","In the symbol of a single cell, the longer line stands for the:",
   "positive terminal",
   C("By convention, a cell symbol has a long thin line for the positive terminal and a short thick line for the negative.")+
   steps("Look at the two lines in the symbol","The longer, thinner one is positive (+)","The shorter, thicker one is negative (−).")+
   U("Reading these symbols correctly lets you connect a battery the right way round."),
   [("negative terminal","The negative terminal is the shorter, thicker line, not the longer one."),
    ("switch","The lines of a cell symbol are its terminals, not a switch."),
    ("wire","The connecting wires are drawn as plain lines outside the cell symbol.")]),

 ("EC","Which of these is the best conductor of electricity?",
   "copper wire",
   C("Metals like copper let current pass through easily, so they are good conductors.")+
   steps("Charges move freely through metals","Copper lets them move very easily","So copper is an excellent conductor.")+
   U("House wiring uses copper because it carries current with little loss."),
   [("rubber band","Rubber blocks current, so it is an insulator, not a conductor."),
    ("dry wood","Dry wood does not let current pass; it is an insulator."),
    ("plastic ruler","Plastic is an insulator and does not conduct electricity.")]),

 ("EC","Which of these materials is an insulator?",
   "plastic",
   C("An insulator does not let electric current pass through it.")+
   steps("Try to pass current through plastic","Almost none gets through","So plastic is an insulator.")+
   U("Wires are coated in plastic so we can hold them safely."),
   [("iron","Iron is a metal and conducts electricity, so it is not an insulator."),
    ("copper","Copper is one of the best conductors, the opposite of an insulator."),
    ("aluminium","Aluminium is a metal and conducts current, so it is not an insulator.")]),

 ("EC","When current flows through a wire and the wire becomes hot, this is called the:",
   "heating effect of electric current",
   C("Current passing through a wire produces heat; this is the heating effect of electric current.")+
   steps("Current flows through the wire","The wire resists the flow a little","That resistance produces heat.")+
   U("An electric iron and a room heater both work on the heating effect."),
   [("magnetic effect","The magnetic effect is current making a magnet, not heat."),
    ("chemical effect","The chemical effect happens in cells and electrolysis, not simple heating."),
    ("cooling effect","Current heats a wire; it does not cool it.")]),

 ("EC","The filament of an electric bulb is made of:",
   "tungsten",
   C("Tungsten is used because it has a very high melting point and can glow white-hot without melting.")+
   steps("Current heats the filament strongly","An ordinary metal would melt","Tungsten survives the heat and glows.")+
   U("This is why old-style bulbs are sometimes called tungsten-filament bulbs."),
   [("copper","Copper would melt at the bulb's glowing temperature; tungsten does not."),
    ("rubber","Rubber is an insulator and would burn, not glow."),
    ("plastic","Plastic would melt instantly; the filament must withstand great heat.")]),

 ("EC","The filament of a bulb gives off light because the current:",
   "heats it to a very high temperature",
   C("The thin filament resists the current and gets so hot that it glows, giving light.")+
   steps("Current squeezes through the thin filament","The filament heats up to white-hot","A white-hot object glows and gives light.")+
   U("This heating-then-glowing is the heating effect put to use for lighting."),
   [("cools it down","Current heats the filament; it does not cool it."),
    ("makes it magnetic","A glowing filament gives light through heat, not magnetism."),
    ("charges it with water","Water has nothing to do with how a filament glows.")]),

 ("EC","An electric fuse protects a circuit by:",
   "melting and breaking the circuit when the current is too high",
   C("A fuse has a thin wire that melts if too much current flows, cutting off the circuit before damage is done.")+
   steps("Too much current heats the fuse wire","The thin fuse wire melts first","The circuit breaks and current stops.")+
   U("A fuse can save a house from an electrical fire during a surge."),
   [("increasing the current","A fuse limits current; it never increases it."),
    ("storing extra current","A fuse does not store charge; it is a safety break."),
    ("making the bulb brighter","A fuse protects the circuit; it does not brighten bulbs.")]),

 ("EC","A wire carrying an electric current behaves like a:",
   "magnet",
   C("A current-carrying wire produces a magnetic field around it — the magnetic effect of current.")+
   steps("Pass current through a straight wire","A magnetic field forms around the wire","So the wire acts like a magnet.")+
   U("This discovery led to electric motors and electromagnets."),
   [("battery","A wire carries current; it does not store energy like a battery."),
    ("insulator","A current-carrying wire conducts, and it also acts magnetic — not an insulator."),
    ("fuse","A fuse is a safety device; the magnetic behaviour belongs to any current-carrying wire.")]),

 ("EC","When current flows in a wire placed near a magnetic compass, the compass needle:",
   "deflects (moves to a new direction)",
   C("The current's magnetic field pushes on the compass needle, making it turn.")+
   steps("Switch on the current in the nearby wire","Its magnetic field acts on the needle","The needle deflects from its usual north–south line.")+
   U("Oersted first noticed this and proved that current and magnetism are linked."),
   [("melts","A compass needle does not melt; it simply turns under the magnetic field."),
    ("catches fire","The needle only deflects; it does not catch fire."),
    ("stays exactly still","The magnetic field of the current makes the needle move, not stay still.")]),

 ("EC","A coil of wire wound on a piece of iron that becomes magnetic only while current flows is an:",
   "electromagnet",
   C("An electromagnet is magnetic only when current flows, and loses its magnetism when the current stops.")+
   steps("Wind a coil around an iron core","Pass current through the coil","The iron becomes a magnet — but only while current flows.")+
   U("Scrapyard cranes use electromagnets to lift and then drop heavy iron."),
   [("ordinary bar magnet","A bar magnet stays magnetic always; an electromagnet works only with current."),
    ("fuse","A fuse is a safety device, not a coil-and-core magnet."),
    ("battery","A battery supplies current; the coil-on-iron device is the electromagnet.")]),

 ("EC","An electric bell works mainly using the:",
   "magnetic effect of electric current",
   C("An electric bell uses an electromagnet to pull a hammer that strikes the gong again and again.")+
   steps("Current makes the electromagnet pull the hammer","The hammer hits the gong and breaks the circuit","The magnet lets go, the circuit remakes, and it repeats — ringing.")+
   U("School and doorbells ring using this magnetic effect."),
   [("heating effect only","The bell rings through magnetism, not by heating a wire."),
    ("chemical effect","The chemical effect is for cells, not for ringing a bell."),
    ("force of gravity","Gravity does not drive the repeated striking; the electromagnet does.")]),

 ("EC","In a simple series circuit with two bulbs, if one bulb fuses, the other bulb will:",
   "stop glowing too",
   C("In a series circuit there is only one path, so a break at one bulb stops current everywhere.")+
   steps("Both bulbs share one single loop","If one bulb's filament breaks, the loop is open","No current flows, so the other bulb also goes dark.")+
   U("Old string lights went fully dark when a single bulb failed, for this reason."),
   [("glow brighter","With the loop broken, no current flows, so the other bulb cannot brighten."),
    ("glow normally","A series break stops all current; the second bulb cannot stay lit."),
    ("explode","A broken series circuit simply goes dark; bulbs do not explode.")]),

 ("EC","Adding more cells (joined the correct way) to a torch usually makes the bulb glow:",
   "brighter",
   C("More cells in series give a higher total voltage, pushing more current and giving more light.")+
   steps("Each cell adds its voltage in series","More voltage pushes more current","More current makes the filament glow brighter.")+
   U("A torch with fresh, extra cells throws a stronger beam."),
   [("dimmer","More voltage gives more current and more light, not less."),
    ("the same","Adding voltage changes the brightness, so it does not stay the same."),
    ("not at all","With proper connection, more cells make it glow more, not stop it.")]),

 ("EC","Many modern houses use an MCB in place of a fuse. An MCB is a device that:",
   "switches off automatically when the current is too high",
   C("An MCB (Miniature Circuit Breaker) trips and opens the circuit when too much current flows, then can be reset.")+
   steps("It senses the current in the line","If the current is dangerously high, it trips open","Unlike a fuse, it can be switched back on after the fault is fixed.")+
   U("After an overload trips the MCB, you simply flip it back up once it is safe."),
   [("stores electricity for the night","An MCB is a safety switch, not a store of energy."),
    ("increases the supply voltage","An MCB protects the circuit; it does not raise the voltage."),
    ("measures the monthly bill","Billing is done by the energy meter, not the MCB.")]),

 ("EC","A bulb does not glow when the switch is open because the circuit is:",
   "broken (incomplete)",
   C("Current needs a complete loop. An open switch leaves a gap, so no current flows.")+
   steps("An open switch is a gap in the loop","Charges cannot cross the gap","With no current, the bulb stays dark.")+
   U("Turning the wall switch off opens the circuit and the light goes out."),
   [("complete","If the circuit were complete the bulb would glow; an open switch breaks it."),
    ("too short","A short path is not the issue; the open switch leaves a gap."),
    ("too cold","Temperature is not why the bulb stays off; the loop is broken.")]),

 ("EC","Which appliance mainly uses the heating effect of electric current?",
   "an electric room heater",
   C("A heater passes current through a high-resistance coil that gets hot and warms the room.")+
   steps("Current flows through the heater's coil","The coil resists the flow and heats up","The hot coil warms the surrounding air.")+
   U("Electric irons, toasters and heaters all rely on the heating effect."),
   [("an electric bell","A bell uses the magnetic effect, not heating."),
    ("a compass","A compass shows direction; it does not use the heating effect."),
    ("a radio antenna","An antenna handles signals, not the heating of a coil.")]),

 ("EC","To keep ourselves safe, we should never touch electrical switches with:",
   "wet hands",
   C("Water makes the skin conduct electricity, so wet hands greatly raise the risk of a shock.")+
   steps("Pure dry skin resists current fairly well","Water lowers that resistance a lot","So wet hands can let a dangerous current pass.")+
   U("This is why bathroom switches are placed away from splashing water."),
   [("a dry cloth","A dry cloth is an insulator and is comparatively safe."),
    ("dry hands","Dry hands are far safer than wet ones for handling switches."),
    ("a plastic glove","A plastic glove insulates and is safer, not dangerous.")]),

 ("EC","The strength of an electromagnet can be increased by:",
   "increasing the number of turns in the coil",
   C("More turns of wire (and more current) make a stronger magnetic field in the iron core.")+
   steps("Wind more turns of wire around the core","Each extra turn adds to the magnetic field","So the electromagnet becomes stronger.")+
   U("Powerful lifting magnets use coils with very many turns."),
   [("removing the iron core","The iron core boosts the magnet; removing it weakens the electromagnet."),
    ("using fewer cells","Fewer cells means less current and a weaker magnet."),
    ("cutting the wire","A cut wire breaks the circuit, so there is no magnet at all.")]),

 ("EC","A torch uses 2 cells of 1.5 V each, joined in a line. The total voltage of the battery is:",
   "3 V",
   C("Cells joined in series (end to end) add their voltages.")+
   steps("Each cell gives 1.5 V","Two in series: 1.5 + 1.5","= 3 V total.")+
   U("Knowing the total voltage helps you pick the right bulb for a torch."),
   [("1.5 V","1.5 V is one cell alone; two in series add up to 3 V."),
    ("0.75 V","That divides the voltage; series cells add, not divide."),
    ("2 V","2 is the number of cells, not the voltage; the total is 3 V.")]),

 ("EC","If each cell gives 1.5 V, the total voltage of 4 such cells joined in a line is:",
   "6 V",
   C("In series, the total voltage is the number of cells times each cell's voltage.")+
   steps("4 cells × 1.5 V each","= 4 × 1.5","= 6 V.")+
   U("A 6 V lantern uses four 1.5 V cells in series for a brighter, longer-lasting light."),
   [("1.5 V","1.5 V is a single cell; four in series give 6 V."),
    ("4 V","4 is just the cell count; multiply by 1.5 V to get 6 V."),
    ("5.5 V","Adding 4 + 1.5 is wrong; multiply to get 4 × 1.5 = 6 V.")]),

 ("EC","Conventional current in a circuit is taken to flow, outside the cell, from the cell's:",
   "positive terminal to its negative terminal",
   C("By the agreed convention, current outside the cell flows from the positive terminal, round the circuit, to the negative terminal.")+
   steps("Mark the + and − terminals of the cell","Outside the cell, current is taken to leave the +","It travels round and returns to the −.")+
   U("Circuit diagrams are drawn with this convention so everyone reads them the same way."),
   [("negative to positive outside the cell","That is the reverse of the agreed convention for current direction."),
    ("switch to the fuse only","Current flows round the whole loop, not just between two parts."),
    ("bulb to the wire only","Current flows through the entire circuit, following the convention.")]),

 ("EC","To measure the electric current flowing in a circuit, we connect an:",
   "ammeter",
   C("An ammeter is the meter built to read how much current is passing through the circuit.")+
   steps("Connect the ammeter into the circuit's path","Current flows through it","The ammeter shows the current value on its scale.")+
   U("Electricians use an ammeter to check whether a line is overloaded."),
   [("thermometer","A thermometer measures temperature, not electric current."),
    ("speedometer","A speedometer measures speed of a vehicle, not current."),
    ("voltmeter","A voltmeter measures voltage across parts, not the current flowing through.")]),
]

# ---------- ALGEBRAIC EXPRESSIONS (25) — Maths ----------
ALG = [
 ("ALG","A symbol such as x, which can stand for different number values, is called a:",
   "variable",
   C("A variable is a letter that can take various values, unlike a fixed number.")+
   steps("Pick a letter, say x","Its value can change from problem to problem","Such a changing-value symbol is a variable.")+
   U("Spreadsheets use variables (cell names) so one formula works for any numbers."),
   [("constant","A constant has a fixed value; a variable can change."),
    ("coefficient","A coefficient is the number multiplying a variable, not the symbol itself."),
    ("equation","An equation states two expressions are equal; a variable is just one symbol.")]),

 ("ALG","In the expression 3x + 7, the number 7 is a:",
   "constant term",
   C("A term with no variable is a constant — its value never changes.")+
   steps("Look at the parts: 3x and 7","3x changes with x, but 7 does not","So 7 is the constant term.")+
   U("In a taxi fare like 3x + 7, the 7 is the fixed booking charge."),
   [("variable","7 is a fixed number; only the part with x is variable."),
    ("coefficient of x","The coefficient of x is 3, the number multiplying x — not the 7."),
    ("exponent","An exponent is a small power; 7 here is a plain constant term.")]),

 ("ALG","In the term 5y, the number 5 is called the:",
   "coefficient of y",
   C("A coefficient is the number that multiplies the variable in a term.")+
   steps("The term is 5y, meaning 5 times y","The number multiplying y is 5","So 5 is the coefficient of y.")+
   U("If y is the price of one item, 5y is the cost of five and 5 is the coefficient."),
   [("constant","A constant stands alone; here 5 is attached to y as its multiplier."),
    ("variable","The variable is y; 5 is the number multiplying it."),
    ("power","A power is a small raised exponent; 5 here just multiplies y.")]),

 ("ALG","Among the following pairs, which one is a pair of like terms?",
   "3x and 7x",
   C("Like terms have exactly the same variable part; only their coefficients differ.")+
   steps("3x and 7x both have the variable x","Their variable parts match","So they are like terms.")+
   U("Only like terms can be added together when tidying up an expression."),
   [("3x and 3y","Different variables (x and y) make these unlike terms."),
    ("x and x²","x and x² have different powers, so they are unlike terms."),
    ("5 and 5x","5 is a constant and 5x has a variable, so they are unlike.")]),

 ("ALG","The sum of 4a and 5a is:",
   "9a",
   C("Like terms are added by adding their coefficients and keeping the variable.")+
   steps("4a + 5a","Add coefficients: 4 + 5 = 9","Keep the variable a: 9a.")+
   U("If a is the cost of one notebook, 4a + 5a is the cost of nine notebooks."),
   [("20a","That multiplies 4 × 5; like terms are added, not multiplied."),
    ("9a²","The power of a does not change when adding; it stays 9a, not 9a²."),
    ("45a","Writing 4 and 5 side by side is wrong; 4 + 5 = 9, giving 9a.")]),

 ("ALG","Subtracting 2x from 7x gives:",
   "5x",
   C("Subtract the coefficients of like terms and keep the variable.")+
   steps("7x − 2x","Subtract coefficients: 7 − 2 = 5","Keep the variable x: 5x.")+
   U("If you had 7 pencils worth x each and gave away 2, you keep 5x worth."),
   [("9x","That adds instead of subtracting; 7 − 2 = 5, not 9."),
    ("14x","That multiplies 7 × 2; you must subtract the coefficients."),
    ("5x²","The power of x stays the same; the answer is 5x, not 5x².")]),

 ("ALG","An expression with only one term, such as 6xy, is called a:",
   "monomial",
   C("'Mono' means one, so a monomial is an expression with a single term.")+
   steps("Count the terms in 6xy","There is just one term","So it is a monomial.")+
   U("Naming expressions by their number of terms keeps maths talk clear."),
   [("binomial","A binomial has two terms; 6xy has only one."),
    ("trinomial","A trinomial has three terms; 6xy has just one."),
    ("constant only","6xy contains variables, so it is not just a constant.")]),

 ("ALG","The expression x + 5 has two terms, so it is a:",
   "binomial",
   C("'Bi' means two, so a binomial is an expression with exactly two terms.")+
   steps("Count the terms: x and 5","That is two terms","So x + 5 is a binomial.")+
   U("Many area and cost formulas come out as neat binomials."),
   [("monomial","A monomial has one term; x + 5 has two."),
    ("trinomial","A trinomial has three terms; x + 5 has only two."),
    ("variable","x + 5 is a whole expression, not a single variable.")]),

 ("ALG","An expression with three terms, such as x + y + 7, is a:",
   "trinomial",
   C("'Tri' means three, so a trinomial is an expression with exactly three terms.")+
   steps("Count the terms: x, y and 7","That makes three terms","So it is a trinomial.")+
   U("Counting terms helps you choose the right method to simplify an expression."),
   [("binomial","A binomial has two terms; this one has three."),
    ("monomial","A monomial has only one term, not three."),
    ("constant","A constant is a single fixed number, not a three-term expression.")]),

 ("ALG","The value of 2x + 3 when x = 4 is:",
   "11",
   C("Substitute the value of x into the expression and work it out.")+
   steps("Replace x with 4: 2 × 4 + 3","= 8 + 3","= 11.")+
   U("Plugging a number into a formula like this is how calculators evaluate expressions."),
   [("8","8 is just 2 × 4; you must still add the 3."),
    ("14","That adds 2 + 4 + ... wrongly; 2 × 4 + 3 = 11."),
    ("9","That used x = 3; here x = 4, giving 11.")]),

 ("ALG","The value of 5a − 2 when a = 3 is:",
   "13",
   C("Put a = 3 into the expression and simplify.")+
   steps("5 × 3 − 2","= 15 − 2","= 13.")+
   U("Engineers test formulas by substituting trial values exactly like this."),
   [("15","15 is just 5 × 3; you must still subtract the 2."),
    ("10","That did 5 × 3 − 5 or similar; 15 − 2 = 13."),
    ("1","That mistakes 5 − 2 then × ...; the correct value is 13.")]),

 ("ALG","Simplify: 3x + 2x + 4.",
   "5x + 4",
   C("Add the like terms (the x terms) and keep the constant separate.")+
   steps("3x + 2x = 5x","The constant 4 stays as it is","So the answer is 5x + 4.")+
   U("Tidying expressions this way makes them easier to use in a formula."),
   [("9x","That wrongly adds the 4 to the x terms; 4 has no x, so it stays apart."),
    ("5x + 4x","There is no second x term to write; 3x + 2x is just 5x."),
    ("6x","That adds 3 + 2 + ... wrongly and drops the constant; the answer is 5x + 4.")]),

 ("ALG","The expression 3x + 2y cannot be simplified further because 3x and 2y are:",
   "unlike terms",
   C("Only like terms can be combined. 3x and 2y have different variables, so they stay separate.")+
   steps("Compare the variable parts: x and y","They are different","So 3x and 2y are unlike terms and cannot be added.")+
   U("You cannot add 3 apples and 2 oranges into one number — they are unlike."),
   [("like terms","Like terms share the same variable; x and y differ, so these are unlike."),
    ("equal","3x and 2y are not equal; they involve different variables."),
    ("constants","Both terms contain variables, so neither is a constant.")]),

 ("ALG","The perimeter of a square of side s is best written as the expression:",
   "4s",
   C("A square has four equal sides, so its perimeter is four times one side.")+
   steps("Perimeter = side + side + side + side","= s + s + s + s","= 4s.")+
   U("Using 4s lets you find the perimeter for any size square in one step."),
   [("s + 4","That adds 4 to one side; the perimeter is 4 times the side, not side plus 4."),
    ("s²","s² is the area of the square, not its perimeter."),
    ("2s","2s would be just two sides; a square has four sides, giving 4s.")]),

 ("ALG","Multiplying the term 3x by 2 gives:",
   "6x",
   C("Multiply the number part (coefficient) and keep the variable.")+
   steps("2 × 3x","= (2 × 3)x","= 6x.")+
   U("Doubling a single item's cost x written as 3x gives 6x for the doubled order."),
   [("5x","That adds 2 + 3; multiplying gives 2 × 3 = 6, so 6x."),
    ("3x²","Multiplying by a number does not raise the power; it stays 6x."),
    ("23x","Writing 2 and 3 side by side is wrong; 2 × 3 = 6, giving 6x.")]),

 ("ALG","The value of x + y when x = 2 and y = 5 is:",
   "7",
   C("Substitute both values and add.")+
   steps("Replace x with 2 and y with 5","2 + 5","= 7.")+
   U("Adding two measured amounts uses this simple substitution."),
   [("10","That multiplies 2 × 5; the expression is x + y, an addition."),
    ("25","Writing 2 and 5 together is wrong; 2 + 5 = 7."),
    ("3","That subtracts 5 − 2; the expression adds, giving 7.")]),

 ("ALG","In the term 7xy, the coefficient of xy is:",
   "7",
   C("The coefficient is the numerical factor multiplying the variable part xy.")+
   steps("The term is 7xy = 7 × xy","The number multiplying xy is 7","So the coefficient of xy is 7.")+
   U("Spotting the coefficient quickly helps when you combine like terms."),
   [("x","x is part of the variable, not the numerical coefficient."),
    ("y","y is part of the variable, not the numerical coefficient."),
    ("1","The number shown is 7, not 1; the coefficient is 7.")]),

 ("ALG","How many terms are in the expression 2x − 3y + 4?",
   "3",
   C("Terms are the parts separated by + or − signs.")+
   steps("Split at the signs: 2x, −3y, +4","Count the parts","There are 3 terms.")+
   U("Knowing the number of terms tells you whether it is a binomial, trinomial, and so on."),
   [("2","There are three separated parts, not two."),
    ("1","A single term has no + or − separating parts; this has two such signs."),
    ("4","4 is the constant term's value, not the number of terms; there are 3.")]),

 ("ALG","A car travels at a steady speed v for a time t. The distance it covers is written as the expression:",
   "v × t",
   C("Distance equals speed multiplied by time, so as an expression it is v × t.")+
   steps("Distance = speed × time","Speed is v and time is t","So distance = v × t.")+
   U("This is the algebra behind the motion formula you use in science class."),
   [("v + t","Distance is speed times time, not speed plus time."),
    ("v − t","Subtracting speed and time has no meaning here; distance = v × t."),
    ("v ÷ t","Dividing would give a different quantity; distance is v × t.")]),

 ("ALG","If one pen costs ₹p, the cost of 5 such pens is written as:",
   "5p",
   C("Multiply the cost of one pen by how many pens you buy.")+
   steps("Cost of 1 pen = p","Cost of 5 pens = 5 × p","= 5p.")+
   U("Shops compute a bill for many identical items using this kind of expression."),
   [("p + 5","Adding 5 is wrong; five pens cost 5 times p, written 5p."),
    ("p/5","Dividing gives the cost of part of a pen, not five pens."),
    ("p − 5","Subtracting has no meaning here; five pens cost 5p.")]),

 ("ALG","Simplify: 8y − 3y + y.",
   "6y",
   C("All three are like terms in y, so combine their coefficients.")+
   steps("Coefficients: 8 − 3 + 1","= 6","Keep the variable y: 6y.")+
   U("Collecting like terms shortens a long expression into a simple one."),
   [("12y","That adds all three (8 + 3 + 1); the middle term is subtracted."),
    ("4y","That forgot the final + y; 8 − 3 + 1 = 6."),
    ("6y²","The power of y stays the same; the answer is 6y, not 6y².")]),

 ("ALG","The value of 4x + 9 when x = 0 is:",
   "9",
   C("When x = 0, the term with x becomes 0, leaving only the constant.")+
   steps("4 × 0 + 9","= 0 + 9","= 9.")+
   U("Setting x = 0 in a formula often reveals its fixed starting amount."),
   [("0","Only the 4x part becomes 0; the constant 9 remains."),
    ("4","4 is the coefficient, not the value; 4 × 0 + 9 = 9."),
    ("13","That added 4 instead of 4 × 0; with x = 0 the value is 9.")]),

 ("ALG","Simplify: 2a + 3b + 4a.",
   "6a + 3b",
   C("Combine the like terms (the a terms) and leave the unlike term as it is.")+
   steps("2a + 4a = 6a","3b has no like term, so it stays","Answer: 6a + 3b.")+
   U("Grouping like terms is the first step in tidying any algebra problem."),
   [("9ab","You cannot merge a-terms and b-terms into one; they are unlike."),
    ("6ab","2a + 4a gives 6a, not 6ab; the b term stays separate."),
    ("5a + 4b","That mis-adds the coefficients; 2a + 4a = 6a and 3b stays as 3b.")]),

 ("ALG","If each cell of a battery gives a volts, the total voltage of n such cells joined in a line is written as:",
   "n × a",
   C("Series cells add their voltages, which for n equal cells is n times a.")+
   steps("Each cell gives a volts","n cells in series add up","Total = a + a + ... (n times) = n × a.")+
   U("This is the algebra behind why four 1.5 V cells make a 6 V battery."),
   [("n + a","Voltages multiply by the count, not add the count to one cell's voltage."),
    ("a ÷ n","Dividing would lower the voltage; series cells add to give n × a."),
    ("a − n","Subtracting the count has no meaning; the total is n × a.")]),

 ("ALG","The area of a rectangle of length l and breadth b is written as the expression:",
   "l × b",
   C("The area of a rectangle is its length multiplied by its breadth.")+
   steps("Area = length × breadth","Length is l and breadth is b","So area = l × b.")+
   U("Tiling a floor needs l × b to know how many tiles of a given size to buy."),
   [("l + b","Adding gives half the perimeter idea, not the area; area is l × b."),
    ("2(l + b)","2(l + b) is the perimeter of the rectangle, not its area."),
    ("l − b","Subtracting has no meaning for area; area is l × b.")]),
]

assert len(MT) == 25 and len(CQ) == 25 and len(EC) == 25 and len(ALG) == 25

# Interleave so no two consecutive questions share a chapter; Science/Maths alternate.
items = []
for i in range(25):
    items += [MT[i], CQ[i], EC[i], ALG[i]]
assert len(items) == 100

for a, b in zip(items, items[1:]):
    assert a[0] != b[0], (a[1], b[1])

if __name__ == "__main__":
    here = os.path.dirname(os.path.abspath(__file__))
    papers_dir = os.path.abspath(os.path.join(
        here, "..", "..", "desktopAhaan", "Resources", "BossChallengePapers"))
    os.chdir(papers_dir)

    keydist = build_paper(PNUM, TITLE, SHORT, LABELS, items, seed=11107,
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
    split = "/".join(str(counts[c]) for c in ("MT", "CQ", "EC", "ALG"))
    with open("PAPERS_MANIFEST.md", "a", encoding="utf-8") as fh:
        fh.write(f"| {PNUM} | 2026-06-18 | {TITLE} | {split} | ✓ |\n")

    print("Files:", sorted(v for v in moves.values()))
    print("Answer key spread A/B/C/D =", dict(keydist))
