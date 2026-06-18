# -*- coding: utf-8 -*-
# Boss Challenge Paper 55 — Heat · Respiration in Organisms ·
#                           Algebraic Expressions · Data Handling
# Content-only. Uses the dependency-free examfactory engine.
# Difficulty ramp: leans hard into FUSION. A week of temperature readings
# becomes a MEAN / MEDIAN / RANGE; breaths per minute becomes an ALGEBRAIC
# expression in a variable; a rising temperature becomes a formula 20 + 2t;
# a class's pulse rates become a bar graph to read. A Science situation,
# a Maths skill. Class-7 scope, simple wording, hard thinking.
# Produces, under Resources/BossChallengePapers/:
#   Paper_55_<SHORT>_QuestionPaper.html  (pure HTML — questions + options)
#   Paper_55_<SHORT>_QuestionPaper.pdf
#   Paper_55_<SHORT>_Questions.md
#   Paper_55_<SHORT>_Solutions.html
import os, sys, shutil, json, re
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from examfactory import build_paper, C, steps, U

PNUM  = "55"
SHORT = "Heat_Respiration_AlgExpr_DataHandling"
TITLE = ("Heat · Respiration in Organisms · "
         "Algebraic Expressions · Data Handling")
LABELS = {
    "HT": "Heat",
    "RO": "Respiration in Organisms",
    "AE": "Algebraic Expressions",
    "DH": "Data Handling",
}

# 100 items, authored already interleaved as HT, RO, AE, DH in groups of four.
items = [

 # ===== ROUND 1 =====
 ("HT","To find out exactly how hot a cup of milk is, you would use an instrument that measures temperature. That instrument is called a:",
   "thermometer",
   C("Temperature — the degree of hotness or coldness of a body — is measured with a thermometer.")+
   steps("Hotness needs a number","the tool that gives that number is the thermometer.")+
   U("A clinical thermometer tells a doctor whether you are running a fever."),
   [("barometer","A barometer measures air pressure, not temperature; the temperature tool is a thermometer."),
    ("weighing scale","A weighing scale gives mass, not hotness; temperature is read on a thermometer."),
    ("ruler","A ruler measures length; the hotness of the milk is measured by a thermometer.")]),

 ("RO","Living things take in a gas from the air to break down food and release energy, and give out a different gas. The gas taken IN is:",
   "oxygen",
   C("In breathing we take in oxygen, which is used to release energy from food, and give out carbon dioxide.")+
   steps("Energy is needed from food","oxygen is used up to release it","so the gas taken in is oxygen.")+
   U("This is why a closed room full of people starts to feel stuffy — the oxygen is being used up."),
   [("carbon dioxide","Carbon dioxide is the gas given OUT in breathing; the gas taken in is oxygen."),
    ("nitrogen","Nitrogen is the most plentiful gas in air but is not used in breathing; we take in oxygen."),
    ("hydrogen","Hydrogen is not a breathing gas at all; living things take in oxygen.")]),

 ("AE","In algebra a letter such as x that can stand for many different numbers at different times is known as a:",
   "variable",
   C("A variable is a symbol whose value is not fixed — it can take different values.")+
   steps("A letter stands in for a number","its value can change","such a symbol is a variable.")+
   U("A formula with a variable lets one rule work for any number you put in."),
   [("constant","A constant has a fixed value, like 8; a letter that can change is a variable."),
    ("coefficient","A coefficient is the number multiplying a variable (the 4 in 4x); the changeable letter is a variable."),
    ("equation","An equation says two expressions are equal; the changeable symbol inside it is a variable.")]),

 ("DH","The marks of five students are 6, 8, 10, 7 and 9. To find their AVERAGE (mean) mark, you would:",
   "add all the marks and divide by 5",
   C("The mean is the sum of all the values divided by how many values there are.")+
   steps("Add: 6 + 8 + 10 + 7 + 9 = 40","there are 5 marks","40 ÷ 5 = 8, the mean.")+
   U("Cricket commentators quote a batsman's 'average' — runs divided by innings — in exactly this way."),
   [("add all the marks and divide by 2","You divide by the NUMBER of values (5), not by 2; 40 ÷ 5 = 8."),
    ("pick the largest mark","The largest mark (10) is not the average; the mean is the total shared equally, 8."),
    ("subtract the smallest from the largest","That gives the range (10 − 6 = 4), not the average; the mean is 8.")]),

 # ===== ROUND 2 =====
 ("HT","Hold a steel spoon in a cup of hot tea for a minute and the far end of the handle slowly turns warm. Heat has travelled along the solid metal by:",
   "conduction",
   C("In a solid, heat passes from the hot end to the cold end through the material itself, without the material flowing. This is conduction.")+
   steps("The metal does not flow","yet heat moves from hot end to cold end","heat passing through a solid this way is conduction.")+
   U("A metal pan handle gets hot by conduction, which is why many handles are wrapped in plastic."),
   [("convection","Convection needs a moving liquid or gas; a solid spoon carries heat by conduction."),
    ("radiation","Radiation carries heat as rays through space; heat moving through solid metal is conduction."),
    ("evaporation","Evaporation is a liquid turning to vapour, not heat moving through a spoon; that is conduction.")]),

 ("RO","When you run fast and your muscles do not get enough oxygen, they break down sugar without it and a substance builds up that makes the muscles ache. That substance is:",
   "lactic acid",
   C("With too little oxygen, muscle cells respire anaerobically and form lactic acid, which causes the cramp-like ache.")+
   steps("Hard exercise outpaces the oxygen supply","muscles respire without oxygen","this makes lactic acid, causing the ache.")+
   U("The burning feeling in your legs at the end of a sprint is the build-up of lactic acid."),
   [("oxygen","A shortage of oxygen is the CAUSE; the substance that builds up and aches is lactic acid."),
    ("glucose","Glucose is the sugar being broken DOWN; the product that causes the ache is lactic acid."),
    ("water","Water is a harmless product of normal respiration; the muscle ache comes from lactic acid.")]),

 ("AE","A number that has a fixed, unchanging value — such as the 9 in the expression x + 9 — is called a:",
   "constant",
   C("A constant keeps the same value wherever it appears; it does not change like a variable does.")+
   steps("The 9 never changes value","unlike x, which can vary","a fixed-value number is a constant.")+
   U("In the area formula for a circle, the number π is a constant — it never changes, only the radius does."),
   [("variable","A variable can take different values; the 9, which never changes, is a constant."),
    ("coefficient","A coefficient multiplies a variable; the lone fixed 9 added on is a constant."),
    ("term","A term is a part of an expression; the kind of value the 9 has is called a constant.")]),

 ("DH","In a set of numbers, the value that appears MORE OFTEN than any other is called the:",
   "mode",
   C("The mode is the value that occurs most frequently in a data set.")+
   steps("Count how many times each value appears","the one appearing most often","is the mode.")+
   U("A shoe shop watches the mode of the sizes it sells to know which size to stock the most."),
   [("mean","The mean is the average (total ÷ count), not the most common value; that is the mode."),
    ("median","The median is the middle value when the data is ordered, not the most frequent; that is the mode."),
    ("range","The range is the gap between largest and smallest, not the most common value; that is the mode.")]),

 # ===== ROUND 3 =====
 ("HT","On a sunny day a person wearing a BLACK shirt feels hotter than a person in a WHITE shirt, because dark surfaces:",
   "absorb more heat",
   C("Dark colours absorb more of the sun's heat and light, while light colours reflect more of it away.")+
   steps("Black absorbs most light and heat that falls on it","white reflects most of it","so the black shirt makes you feel hotter.")+
   U("People in hot deserts often wear white or pale clothes to stay cooler."),
   [("reflect more heat","Light colours like white reflect heat; it is dark colours that absorb more and feel hotter."),
    ("make their own heat","Cloth cannot make heat; the black shirt feels hotter because it absorbs more of the sun's heat."),
    ("block all heat","No ordinary cloth blocks all heat; black cloth in fact absorbs more, so it feels hotter.")]),

 ("RO","A fish kept in a pond does not gulp air the way we do. It takes in the oxygen that is dissolved in the water using its:",
   "gills",
   C("Fish have gills, which pull dissolved oxygen out of the water and pass it into the blood.")+
   steps("Oxygen is dissolved in the water","fish have no lungs for air","gills take the dissolved oxygen from water.")+
   U("If a pond's water loses its dissolved oxygen, fish come to the surface gasping."),
   [("lungs","Lungs breathe air and belong to animals like us; fish take dissolved oxygen using gills."),
    ("skin","An earthworm breathes through its skin, but a fish uses its gills to take oxygen from water."),
    ("spiracles","Spiracles are tiny breathing holes of insects; a fish breathes through its gills.")]),

 ("AE","In the term 7y, the number 7 that is multiplied by the variable y is called the:",
   "coefficient",
   C("A coefficient is the number that multiplies the variable in a term. In 7y, the coefficient of y is 7.")+
   steps("7y means 7 times y","the number doing the multiplying is 7","so 7 is the coefficient of y.")+
   U("In a price like 5n rupees for n items, the 5 is the coefficient that fixes the rate."),
   [("variable","The variable here is y; the number multiplying it, 7, is the coefficient."),
    ("constant","A constant stands alone with no variable; the 7 attached to y is its coefficient."),
    ("exponent","An exponent shows repeated multiplication (like the 2 in y²); the multiplying number 7 is the coefficient.")]),

 ("DH","To find the MEDIAN of an odd number of values, you first put them in order from smallest to largest and then pick the:",
   "middle value",
   C("The median is the middle value of an ordered list. With an odd count, exactly one value sits in the middle.")+
   steps("Arrange the values in order","find the one exactly in the centre","that centre value is the median.")+
   U("House prices are often reported as a 'median' so one huge mansion doesn't distort the figure."),
   [("largest value","The largest value is the maximum, not the median; the median is the middle of the ordered list."),
    ("most common value","The most common value is the mode; the median is the middle value once ordered."),
    ("average of all values","The average of all values is the mean; the median is the middle value of the ordered list.")]),

 # ===== ROUND 4 =====
 ("HT","The temperature of a healthy human body, marked on a clinical thermometer, is normally about:",
   "37°C",
   C("Normal human body temperature is close to 37°C (98.6°F). A clinical thermometer is made to read around this range.")+
   steps("A clinical thermometer reads 35°C to 42°C","the healthy body sits near the middle","that value is about 37°C.")+
   U("A nurse spots a fever the moment the thermometer climbs past about 37°C."),
   [("0°C","0°C is the freezing point of water, far too cold for a body; normal body temperature is about 37°C."),
    ("100°C","100°C is the boiling point of water; the human body is nowhere near that — it is about 37°C."),
    ("50°C","50°C would be a dangerously high fever beyond a clinical thermometer's scale; normal body temperature is about 37°C.")]),

 ("RO","When we breathe IN, a dome-shaped sheet of muscle below the lungs flattens and moves down, making more room for air. This sheet of muscle is the:",
   "diaphragm",
   C("The diaphragm contracts and moves down during inhalation, increasing the space in the chest so air rushes into the lungs.")+
   steps("More chest space is needed to draw air in","the diaphragm contracts and flattens downward","air then flows into the lungs.")+
   U("Hiccups happen when the diaphragm suddenly jerks instead of moving smoothly."),
   [("gills","Gills belong to fish; in humans the breathing muscle that moves down is the diaphragm."),
    ("windpipe","The windpipe is the tube carrying air to the lungs; the muscle that flattens to draw air in is the diaphragm."),
    ("ribs","The ribs are bones that swing out to help, but the dome-shaped muscle that flattens is the diaphragm.")]),

 ("AE","A class breathes about 18 times each minute. Written as an algebraic expression, the number of breaths taken in m minutes is:",
   "18m",
   C("18 breaths each minute, repeated for m minutes, is 18 × m, written 18m.")+
   steps("Each minute brings 18 breaths","for m minutes that repeats m times","18 × m = 18m breaths.")+
   U("This is exactly how a doctor estimates breaths over a longer time from a one-minute count."),
   [("18 + m","Adding m wrongly treats minutes as extra breaths; the breaths multiply, giving 18m."),
    ("m ÷ 18","Dividing makes the count shrink with more minutes, which is backwards; the answer is 18m."),
    ("18","18 is the breaths in just ONE minute; over m minutes it is 18m.")]),

 ("DH","The daytime temperatures for four days were 30°C, 32°C, 28°C and 30°C. The MEAN (average) temperature for these four days is:",
   "30°C",
   C("The mean is the total of the readings divided by how many readings there are.")+
   steps("Add: 30 + 32 + 28 + 30 = 120","there are 4 days","120 ÷ 4 = 30°C.")+
   U("Weather reports give a monthly 'average temperature' calculated in exactly this way."),
   [("32°C","32°C is just the highest single reading, not the average; the mean is 120 ÷ 4 = 30°C."),
    ("120°C","120°C is the TOTAL of the four readings; the mean still needs dividing by 4, giving 30°C."),
    ("28°C","28°C is the lowest single reading, not the average; the mean is 30°C.")]),

 # ===== ROUND 5 =====
 ("HT","Heat from the Sun reaches the Earth across empty space where there is no air. The Sun's heat must therefore travel by:",
   "radiation",
   C("Radiation is the transfer of heat by rays that can travel through empty space, needing no material to carry them.")+
   steps("Space between Sun and Earth is nearly empty","conduction and convection both need matter","so the heat travels by radiation.")+
   U("You feel the warmth of a glowing heater across a room the same way — by radiation."),
   [("conduction","Conduction needs a solid to pass heat along; across empty space heat travels by radiation."),
    ("convection","Convection needs a moving liquid or gas; through the vacuum of space heat travels by radiation."),
    ("boiling","Boiling is a liquid turning to gas, not a way heat crosses space; that is radiation.")]),

 ("RO","Green plants are alive and so they respire all the time, taking in oxygen and giving out carbon dioxide. In a leaf, this gas exchange happens mainly through tiny pores called:",
   "stomata",
   C("Stomata are small pores, usually on the underside of leaves, through which gases move in and out of the plant.")+
   steps("Plant cells need to swap gases with the air","leaves have tiny pores for this","those pores are the stomata.")+
   U("On a hot day many plants partly close their stomata to avoid losing too much water."),
   [("roots","Roots take in water and dissolved minerals; the leaf's gas exchange happens through stomata."),
    ("veins","Veins carry water and food through the leaf; gases pass in and out through the stomata."),
    ("petals","Petals belong to flowers and attract insects; a leaf swaps gases through its stomata.")]),

 ("AE","Terms that have exactly the same variable part — for example 4xy and 9xy — are called:",
   "like terms",
   C("Like terms have identical variable parts and can be added or subtracted by combining their coefficients.")+
   steps("4xy and 9xy both have the variable part xy","only their number parts differ","so they are like terms.")+
   U("Sorting like terms together is how you tidy a long expression into a short one."),
   [("unlike terms","Unlike terms have different variable parts; 4xy and 9xy share xy, so they are like terms."),
    ("constants","Constants have no variable part at all; 4xy and 9xy both contain xy and are like terms."),
    ("equations","An equation has an equals sign; 4xy and 9xy are just like terms, not an equation.")]),

 ("DH","A set of numbers is 4, 9 and 2. The RANGE of this data — the gap between the largest and smallest value — is:",
   "7",
   C("The range is found by subtracting the smallest value from the largest value.")+
   steps("Largest value = 9","smallest value = 2","range = 9 − 2 = 7.")+
   U("A weather report's gap between the day's high and low temperature is just this kind of range."),
   [("11","11 adds the largest and smallest (9 + 2); the range SUBTRACTS them: 9 − 2 = 7."),
    ("2","2 is just the smallest value, not the gap; the range is 9 − 2 = 7."),
    ("5","5 would be the average-ish middle, not the spread; the range is 9 − 2 = 7.")]),

 # ===== ROUND 6 =====
 ("HT","A laboratory thermometer can measure a much wider range of temperatures than a clinical one. A typical laboratory thermometer reads from about:",
   "−10°C to 110°C",
   C("A laboratory thermometer is built to read a broad range, roughly −10°C to 110°C, covering below freezing to above boiling.")+
   steps("Lab work may go below 0°C and above 100°C","the scale must cover both","so it runs about −10°C to 110°C.")+
   U("A school science lab uses this wide-range thermometer to follow water heating from near-ice to near-boiling."),
   [("35°C to 42°C","That narrow band is the CLINICAL thermometer's range; the laboratory one runs about −10°C to 110°C."),
    ("0°C to 50°C","This is too narrow for lab work, which goes below freezing and above boiling; the lab range is about −10°C to 110°C."),
    ("100°C to 500°C","An ordinary laboratory thermometer does not start at boiling point; it reads about −10°C to 110°C.")]),

 ("RO","An earthworm has no lungs and no gills. It takes in oxygen straight through its body surface, which works only as long as that surface stays:",
   "moist",
   C("An earthworm breathes through its moist skin; gases dissolve in the thin film of moisture and pass across.")+
   steps("Gases must dissolve before crossing the skin","this needs the skin to be damp","so the earthworm's skin must stay moist.")+
   U("This is why earthworms come out onto wet ground after rain and dry up if left in the sun."),
   [("dry","A dry skin cannot let gases dissolve and cross; the earthworm's skin must stay moist to breathe."),
    ("hard","A hard, tough surface would block gas exchange; the earthworm breathes through its soft, moist skin."),
    ("coloured","Colour has nothing to do with breathing; what matters is that the earthworm's skin stays moist.")]),

 ("AE","The expression for a number y that is 'increased by 5' — that is, 5 more than y — is written as:",
   "y + 5",
   C("'Increased by 5' means add 5 to the number, so y becomes y + 5.")+
   steps("Start with the number y","'increased by 5' means add 5","this gives y + 5.")+
   U("Adding a fixed ₹5 tip to a bill of ₹y is written exactly as y + 5."),
   [("y − 5","y − 5 means 5 LESS than y; 'increased by 5' means add, giving y + 5."),
    ("5y","5y means 5 times y, not 5 more; 'increased by 5' is y + 5."),
    ("y ÷ 5","y ÷ 5 means y shared into 5 parts; 'increased by 5' means add 5, giving y + 5.")]),

 ("DH","The numbers 2, 4 and 6 have a mean of 4. If you now ADD the value 8 to this set, the new mean will be:",
   "5",
   C("Recompute the mean with all four numbers: add them and divide by the new count.")+
   steps("New total = 2 + 4 + 6 + 8 = 20","there are now 4 numbers","20 ÷ 4 = 5.")+
   U("Re-working a class average after one more score comes in is daily life for any sports fan."),
   [("4","4 was the OLD mean of three numbers; adding 8 raises it — the new mean is 20 ÷ 4 = 5."),
    ("8","8 is just the value you added, not the new average; the new mean is 5."),
    ("6","6 forgets to divide by the new count of 4; the correct new mean is 20 ÷ 4 = 5.")]),

 # ===== ROUND 7 =====
 ("HT","We feel warmer wearing a woollen sweater in winter mainly because wool traps a lot of tiny pockets of air, and trapped air is a:",
   "poor conductor of heat",
   C("Trapped air is a poor conductor (a good insulator), so it slows the escape of body heat, keeping you warm.")+
   steps("Wool holds many small air pockets","trapped air hardly conducts heat","so body heat is kept in, and you feel warm.")+
   U("Two thin sweaters can be warmer than one thick one, because they trap an extra layer of air between them."),
   [("good conductor of heat","If air conducted heat well, your warmth would escape fast; trapped air is a POOR conductor, which is why wool keeps you warm."),
    ("source of heat","Air makes no heat; wool keeps you warm because the trapped air is a poor conductor that holds your body heat in."),
    ("liquid","Trapped air is a gas, not a liquid; it keeps you warm because it is a poor conductor of heat.")]),

 ("RO","When we breathe out and bubble the air through clear lime water, the lime water turns milky. This simple test shows that exhaled air is rich in:",
   "carbon dioxide",
   C("Lime water turns milky in the presence of carbon dioxide, so the test shows exhaled air contains plenty of it.")+
   steps("Lime water goes milky only with carbon dioxide","exhaled air turns it milky","so exhaled air is rich in carbon dioxide.")+
   U("The same lime-water test shows that a burning candle also gives off carbon dioxide."),
   [("oxygen","Oxygen does not turn lime water milky; the milkiness shows the exhaled air is rich in carbon dioxide."),
    ("nitrogen","Nitrogen causes no change in lime water; the milky colour means carbon dioxide is present."),
    ("water vapour","Water vapour does not make lime water milky; the test specifically detects carbon dioxide.")]),

 ("AE","To find the VALUE of the expression 2x + 3 when x = 4, you replace x with 4. The value is:",
   "11",
   C("Substitute x = 4 into the expression and work out the arithmetic.")+
   steps("2x + 3 with x = 4","2 × 4 + 3 = 8 + 3","= 11.")+
   U("Putting a value into a formula like this is exactly what a calculator does to give an answer."),
   [("14","14 wrongly does 2 × (4 + 3); you must multiply first: 2 × 4 + 3 = 11."),
    ("9","9 forgets to double x; 2 × 4 + 3 = 11, not 4 + 3 + 2."),
    ("24","24 multiplies everything together; following order of operations gives 8 + 3 = 11.")]),

 ("DH","A pictograph uses a small picture to stand for a number of things. If one apple symbol stands for 5 apples, then 4 apple symbols stand for:",
   "20 apples",
   C("In a pictograph each symbol represents a fixed quantity, so multiply the number of symbols by what one symbol stands for.")+
   steps("One symbol = 5 apples","there are 4 symbols","4 × 5 = 20 apples.")+
   U("Newspapers use 'one figure = 1000 people' pictographs to make huge numbers easy to picture."),
   [("4 apples","4 is the number of SYMBOLS, not apples; each stands for 5, so 4 × 5 = 20."),
    ("9 apples","9 adds 5 and 4 instead of multiplying; the pictograph means 4 × 5 = 20 apples."),
    ("5 apples","5 is what just ONE symbol stands for; four symbols mean 4 × 5 = 20 apples.")]),

 # ===== ROUND 8 =====
 ("HT","When you heat the liquid inside a thermometer, the liquid column rises up the tube. This happens because, on heating, the liquid:",
   "expands",
   C("Most liquids expand (take up more space) when heated, so the column is pushed up the narrow tube.")+
   steps("Heating makes the liquid take more space","the only way up is the narrow tube","so the column rises — the liquid expands.")+
   U("Railway lines and bridges are built with small gaps because metals, too, expand when heated."),
   [("contracts","Contracting would pull the column DOWN; the column rises because the liquid expands on heating."),
    ("freezes","Freezing turns a liquid solid and happens on cooling; the rising column shows the liquid expands when heated."),
    ("disappears","The liquid does not vanish; it simply takes up more room — it expands — and so rises up the tube.")]),

 ("RO","Tiny insects like a grasshopper do not breathe through a nose. Air enters and leaves their bodies through small openings along the sides called:",
   "spiracles",
   C("Insects breathe through spiracles — tiny holes along the body that lead into air tubes (tracheae) reaching every part.")+
   steps("Insects have no lungs or gills","air must still reach inside the body","it enters through openings called spiracles.")+
   U("Many insect sprays work by clogging the spiracles so the pest cannot breathe."),
   [("gills","Gills are for taking oxygen from water, as in fish; insects breathe through spiracles."),
    ("stomata","Stomata are pores on plant leaves, not on insects; insects breathe through spiracles."),
    ("nostrils","Insects have no nostrils; air enters their bodies through openings called spiracles.")]),

 ("AE","An algebraic expression that has exactly TWO unlike terms — for example 3x + 5 — is called a:",
   "binomial",
   C("A binomial is an expression made up of two unlike terms joined by a plus or minus sign.")+
   steps("3x + 5 has two parts: 3x and 5","they are unlike terms","an expression of two terms is a binomial.")+
   U("A rectangle's perimeter, written 2l + 2b, is a familiar binomial."),
   [("monomial","A monomial has just ONE term (like 3x); two terms make a binomial."),
    ("trinomial","A trinomial has THREE terms; an expression with two terms is a binomial."),
    ("variable","A variable is a single changing letter, not an expression; 3x + 5 is a binomial.")]),

 ("DH","The pulse rates of three friends are 70, 76 and 70 beats per minute. The MODE of this small data set is:",
   "70",
   C("The mode is the value that appears most often. Here 70 appears twice and 76 only once.")+
   steps("List the values: 70, 76, 70","70 appears twice, 76 once","the most frequent value, 70, is the mode.")+
   U("A clinic might note the most common (mode) pulse rate among the patients seen in a day."),
   [("76","76 appears only once; the value that occurs most often is 70."),
    ("72","72 is roughly the mean, not the mode; the most frequent value here is 70."),
    ("6","6 is the range (76 − 70), not the mode; the most common value is 70.")]),

 # ===== ROUND 9 =====
 ("HT","On its own, heat moves only from a warmer object towards a cooler one, and this transfer keeps going until the two objects settle at the:",
   "same temperature",
   C("Heat moves from hot to cold until the two bodies are at the same temperature, when the net flow stops.")+
   steps("Heat leaves the hotter body","and enters the cooler one","this continues until both reach the same temperature.")+
   U("A cup of hot tea cools to room temperature for exactly this reason."),
   [("boiling point","Bodies do not have to boil to stop exchanging heat; the flow stops when they reach the same temperature."),
    ("freezing point","Nothing has to freeze; heat simply flows until both bodies are at the same temperature."),
    ("highest temperature","The hotter body cools rather than rising; the two settle at the same temperature in between.")]),

 ("RO","Yeast can release energy from sugar even without oxygen. In this oxygen-free (anaerobic) respiration, yeast produces carbon dioxide and:",
   "alcohol",
   C("In anaerobic respiration yeast breaks sugar into alcohol and carbon dioxide, releasing some energy.")+
   steps("No oxygen is available to yeast","it still breaks down sugar","producing alcohol and carbon dioxide.")+
   U("This is how bread dough rises and how drinks are fermented — the carbon dioxide makes the bubbles."),
   [("lactic acid","Lactic acid forms in our muscles without oxygen; yeast instead makes alcohol and carbon dioxide."),
    ("oxygen","Oxygen is exactly what is MISSING here; yeast produces alcohol and carbon dioxide instead."),
    ("water","Water is a product of respiration WITH oxygen; without oxygen, yeast makes alcohol and carbon dioxide.")]),

 ("AE","An expression that contains only ONE term, such as 6xy, is called a:",
   "monomial",
   C("A monomial is an algebraic expression made up of a single term.")+
   steps("6xy is one single term","there is no + or − joining a second term","an expression of one term is a monomial.")+
   U("A plain cost like 5n (n items at ₹5 each) is a single-term monomial."),
   [("binomial","A binomial has two terms; a single term like 6xy is a monomial."),
    ("trinomial","A trinomial has three terms; 6xy is just one term, so it is a monomial."),
    ("constant","A constant has no variable; 6xy contains variables and is a one-term monomial.")]),

 ("DH","In a bar graph showing rainfall for several months, the month with the MOST rainfall is shown by the bar that is the:",
   "tallest",
   C("On a bar graph, the height (or length) of each bar shows its value, so the largest value has the tallest bar.")+
   steps("Taller bar means a bigger value","the most rainfall is the biggest value","so it is shown by the tallest bar.")+
   U("At a glance, the tallest bar on a sales chart shows the best-selling month."),
   [("shortest","The shortest bar shows the LEAST rainfall; the most is shown by the tallest bar."),
    ("widest","All bars in a bar graph are the same width; it is the HEIGHT that shows the amount, so the most is the tallest bar."),
    ("first on the left","Position on the left says nothing about size; the most rainfall is shown by the tallest bar.")]),

 # ===== ROUND 10 =====
 ("HT","Land and water are both warmed by the Sun, but during the day the LAND heats up faster than the sea. This is because, compared with water, land:",
   "warms up more quickly",
   C("Land changes temperature faster than water, so by day the land becomes hotter than the sea beside it.")+
   steps("Given the same sunshine, land's temperature rises faster","water is slower to warm","so by day the land is the hotter of the two.")+
   U("This day-time difference in heating is what sets up cool sea breezes at the coast."),
   [("warms up more slowly","It is the WATER that warms slowly; land heats up more quickly, so by day it is hotter."),
    ("cannot be heated","Land certainly gets heated by the Sun; in fact it warms up more quickly than water."),
    ("stays at one temperature","Land's temperature changes a great deal through the day; it warms up faster than water.")]),

 ("RO","Inside every living cell, food (glucose) is broken down with the help of oxygen to set free the energy stored in it. This energy-releasing process is called:",
   "respiration",
   C("Respiration is the breakdown of food inside cells to release energy that the body can use.")+
   steps("Food holds stored energy","cells break it down, usually with oxygen","this energy-releasing process is respiration.")+
   U("The energy from respiration powers everything you do — moving, growing, even thinking."),
   [("digestion","Digestion breaks food into simpler bits in the gut; releasing energy from it inside cells is respiration."),
    ("transpiration","Transpiration is loss of water vapour from plant leaves; releasing energy from food is respiration."),
    ("germination","Germination is a seed sprouting into a seedling; releasing energy inside cells is respiration.")]),

 ("AE","Look at the expression 5a + 3b + 2a. After combining the like terms, it simplifies to:",
   "7a + 3b",
   C("Only like terms can be combined. Add the a-terms together; the b-term stays as it is.")+
   steps("Like terms in a: 5a + 2a = 7a","3b has no like term to join","so the expression is 7a + 3b.")+
   U("Tidying like terms this way is how a shopkeeper totals different items on one bill."),
   [("10ab","You cannot multiply unlike terms together; combining like terms gives 7a + 3b."),
    ("8a + 2b","This wrongly mixes the numbers; the a-terms give 5a + 2a = 7a and 3b is unchanged, so 7a + 3b."),
    ("7a + 5b","The b-term is 3b, not 5b; combining only the a-terms gives 7a + 3b.")]),

 ("DH","The temperatures recorded on five days were 31, 29, 33, 30 and 32 degrees. Arranged in order, the MEDIAN temperature is:",
   "31",
   C("Order the values, then pick the middle one. With five values, the third one is the median.")+
   steps("In order: 29, 30, 31, 32, 33","the middle (3rd) value","is 31.")+
   U("A 'typical' day's temperature is often quoted as the median of the week's readings."),
   [("33","33 is the highest reading, not the middle one; once ordered, the median is 31."),
    ("29","29 is the lowest reading, not the middle one; the median of the ordered list is 31."),
    ("32","32 is the fourth value, not the centre; the middle of five ordered values is 31.")]),

 # ===== ROUND 11 =====
 ("HT","A cook fixes a wooden or plastic handle to a steel frying pan. The reason is that wood and plastic are good insulators, meaning they:",
   "do not let heat pass through easily",
   C("Insulators are poor conductors: they hardly let heat through, so the handle stays cool enough to hold.")+
   steps("Steel conducts heat to the handle area","wood and plastic barely conduct heat","so the handle stays safe to hold.")+
   U("Oven mitts work the same way — thick, poorly-conducting cloth keeps the heat off your hand."),
   [("let heat pass through quickly","If the handle conducted heat quickly it would burn you; insulators do NOT let heat pass easily."),
    ("make extra heat","A handle makes no heat; wood and plastic are chosen because they do not let heat pass through easily."),
    ("turn heat into light","Insulators do not turn heat into light; they simply do not let heat pass through easily.")]),

 ("RO","During hard exercise your breathing rate goes UP — you breathe faster and deeper. The main reason for this is that the working muscles need more:",
   "oxygen",
   C("Exercising muscles use energy faster, so they need more oxygen; faster breathing supplies it.")+
   steps("Muscles work harder during exercise","they burn food faster and need more oxygen","so breathing speeds up to deliver it.")+
   U("This is why an athlete is panting at the end of a race — repaying the body's oxygen demand."),
   [("food","Food is not taken in through breathing; faster breathing during exercise delivers more oxygen."),
    ("water","Drinking replaces water; the reason breathing speeds up in exercise is the muscles' need for more oxygen."),
    ("carbon dioxide","Carbon dioxide is a waste to be removed, not a need; muscles speed your breathing because they need more oxygen.")]),

 ("AE","The perimeter of a square is the total length around it. For a square whose side is s, the perimeter is best written as:",
   "4s",
   C("A square has four equal sides each of length s, so the distance around it is s + s + s + s = 4s.")+
   steps("Four equal sides, each s","add them: s + s + s + s","= 4 × s = 4s.")+
   U("With one short formula, 4s gives the perimeter of ANY square once you know its side."),
   [("s + 4","Adding 4 treats the sides as 'four more', not four times s; the perimeter is 4 × s = 4s."),
    ("s²","s² (s × s) is the AREA of the square, not its perimeter; the perimeter is 4s."),
    ("2s","2s would be only two sides; a square has four equal sides, giving 4s.")]),

 ("DH","When you toss a fair coin once, it is equally likely to land heads or tails. The probability (chance) of getting HEADS is:",
   "1/2",
   C("There are 2 equally likely outcomes and 1 of them is heads, so the probability is 1 out of 2.")+
   steps("Favourable outcome: heads (1 way)","total outcomes: heads or tails (2 ways)","probability = 1/2.")+
   U("A fair coin toss starts a cricket match precisely because each side has an equal 1/2 chance."),
   [("1","A probability of 1 means certain; heads is not certain — its chance is 1/2."),
    ("1/6","1/6 is the chance of one face on a DICE, not a coin; a coin gives 1/2 for heads."),
    ("2","2 is the number of outcomes, not a probability; the chance of heads is 1 out of 2, or 1/2.")]),

 # ===== ROUND 12 =====
 ("HT","A clinical thermometer has a sharp BEND, or kink, in its narrow tube just above the bulb. The purpose of this kink is to:",
   "stop the mercury from slipping back on its own",
   C("The kink holds the mercury thread in place after you remove the thermometer, so the reading does not fall before you read it.")+
   steps("After measuring, the bulb starts to cool","mercury would otherwise run back down","the kink stops it, holding the reading.")+
   U("You shake a clinical thermometer hard before use to force the mercury back past the kink."),
   [("make it heat up faster","The kink has nothing to do with heating speed; it stops the mercury from slipping back so you can read it."),
    ("show the boiling point","Clinical thermometers do not reach boiling point; the kink simply holds the reading after use."),
    ("hold extra mercury","The kink stores no mercury; it stops the thread of mercury from slipping back down on its own.")]),

 ("RO","Plant roots are buried in the soil, yet root cells still need oxygen to respire. They get this oxygen from the:",
   "air present in spaces between soil particles",
   C("Soil is not solid all through — there are air gaps between the particles, and roots take oxygen from this trapped air.")+
   steps("Root cells need oxygen to respire","soil has air-filled gaps between its particles","roots take their oxygen from this soil air.")+
   U("This is why over-watering, which fills those air gaps, can drown a plant's roots."),
   [("sunlight falling on the leaves","Sunlight is for making food in leaves, not for giving roots oxygen; roots take oxygen from soil air."),
    ("carbon dioxide in the soil","Carbon dioxide is a waste of respiration, not what roots need; they take oxygen from the air in soil spaces."),
    ("water flowing past them","Water carries minerals, not the bulk of a root's oxygen; that comes from the air in the soil spaces.")]),

 ("AE","Two terms are 'unlike terms' when their variable parts are different. Because of this, the terms 4x and 4y:",
   "cannot be added into a single term",
   C("Unlike terms have different variable parts and cannot be combined into one term; 4x + 4y must stay as it is.")+
   steps("4x has the variable x, 4y has the variable y","the variable parts differ","so they cannot be merged into one term.")+
   U("You cannot add 3 apples and 4 oranges into one number — just as 4x and 4y stay apart."),
   [("add up to 8xy","Adding unlike terms does NOT multiply the variables; 4x + 4y stays as 4x + 4y, it cannot be merged."),
    ("add up to 8x","You cannot turn a y-term into an x-term; 4x and 4y are unlike and cannot be combined."),
    ("add up to 16","There are no numbers to multiply here; 4x and 4y are unlike terms and cannot be added into one.")]),

 ("DH","Out of all the kinds of graph, a double bar graph is the best choice when your aim is to:",
   "compare two sets of data side by side",
   C("A double bar graph places two bars together for each category, making it easy to compare two related data sets.")+
   steps("Each category gets a pair of bars","one bar for each data set","so the two sets can be compared directly.")+
   U("A school might use one to compare boys' and girls' marks subject by subject."),
   [("show a single set of data","A single set needs only an ordinary bar graph; the DOUBLE bar graph compares two sets at once."),
    ("find the area of a shape","Bar graphs display data, not areas of shapes; a double bar graph compares two data sets."),
    ("show how one value changes over years","That is often a line-style display; the double bar graph is for comparing two sets side by side.")]),

 # ===== ROUND 13 =====
 ("HT","On the Celsius scale used by most thermometers, pure water freezes at 0°C. On the same scale, pure water boils at:",
   "100°C",
   C("On the Celsius scale the freezing point of water is fixed at 0°C and its boiling point at 100°C.")+
   steps("Freezing point of water = 0°C","boiling point of water = 100°C","these two fixed points define the Celsius scale.")+
   U("Every weather thermometer is built on these two fixed water points, 0°C and 100°C."),
   [("50°C","50°C is only halfway up the scale; water boils at 100°C."),
    ("37°C","37°C is normal body temperature, not the boiling point; water boils at 100°C."),
    ("212°C","212 is the boiling point on the FAHRENHEIT scale; on the Celsius scale water boils at 100°C.")]),

 ("RO","Putting it all together, the word equation for respiration that uses oxygen (aerobic respiration) is: glucose + oxygen → carbon dioxide + water + ____. The blank stands for:",
   "energy",
   C("Aerobic respiration breaks glucose using oxygen, giving carbon dioxide and water, and — most importantly — releasing energy.")+
   steps("Glucose and oxygen react in the cell","products are carbon dioxide and water","and the released ____ is energy.")+
   U("That released energy is what every cell in your body runs on, even while you sleep."),
   [("sunlight","Sunlight is taken IN during photosynthesis, not given out by respiration; respiration releases energy."),
    ("oxygen","Oxygen is a reactant USED UP in aerobic respiration, not a product; the product released is energy."),
    ("soil","Soil plays no part in cellular respiration; the process releases energy.")]),

 ("AE","To form an expression for 'the cost of buying n pens, when each pen costs 5 rupees', you would write:",
   "5n",
   C("Each pen costs 5 rupees, so n pens cost 5 × n = 5n rupees.")+
   steps("One pen costs 5 rupees","n pens cost 5 added n times","= 5 × n = 5n.")+
   U("A shop's billing software builds totals from exactly this kind of cost × quantity expression."),
   [("5 + n","Adding n treats pens as extra rupees, not as a count to multiply; the cost is 5 × n = 5n."),
    ("n − 5","Subtracting makes no sense for a total cost; n pens at 5 rupees each cost 5n."),
    ("n ÷ 5","Dividing would shrink the cost as you buy more, which is wrong; the cost is 5n.")]),

 ("DH","A bag holds an equal number of red and blue balls only. The probability of drawing out a GREEN ball from this bag is:",
   "0",
   C("There are no green balls in the bag, so drawing a green ball is impossible — a probability of 0.")+
   steps("The bag has only red and blue balls","green is not among them","an impossible event has probability 0.")+
   U("Saying 'there is no chance of snow in the desert today' is a probability of 0."),
   [("1","A probability of 1 means certain; drawing green is impossible here, so the probability is 0."),
    ("1/2","1/2 is the chance of, say, a red ball; a green ball is impossible, giving probability 0."),
    ("1/3","1/3 would suggest green is one of three equal choices; there are no green balls, so the probability is 0.")]),

 # ===== ROUND 14 =====
 ("HT","People living near the sea often find their summers and winters less extreme than people far inland. This milder coastal climate is mainly because water:",
   "heats up and cools down slowly",
   C("Water changes temperature slowly, so the nearby sea warms the coast slowly in summer and releases heat slowly in winter, evening out the climate.")+
   steps("Water gains and loses heat slowly","the sea stores summer warmth and gives it out in winter","so the coast's temperature stays moderate.")+
   U("This is why coastal cities rarely have the scorching days and freezing nights of a desert."),
   [("heats up and cools down quickly","If water changed temperature quickly it would not steady the climate; in fact water heats and cools SLOWLY, moderating the coast."),
    ("never changes temperature","The sea's temperature does change, just slowly; that slow change is what moderates coastal climate."),
    ("blocks the Sun's heat","Water does not block sunlight from the land; it moderates climate because it heats and cools slowly.")]),

 ("RO","Both breathing in and breathing out involve movements of the chest. During breathing OUT (exhalation), the diaphragm:",
   "relaxes and moves up",
   C("On exhalation the diaphragm relaxes and curves upward, shrinking the chest space and pushing air out of the lungs.")+
   steps("To push air out, the chest must get smaller","the diaphragm relaxes and moves up","so air is forced out of the lungs.")+
   U("Blowing out a candle uses this same push of air from your relaxing diaphragm."),
   [("contracts and moves down","Contracting and moving down happens when breathing IN; during exhalation the diaphragm relaxes and moves up."),
    ("disappears completely","The diaphragm is a permanent muscle; during exhalation it simply relaxes and moves up."),
    ("turns into a lung","The diaphragm is a muscle, not a lung; on breathing out it relaxes and moves up.")]),

 ("AE","Starting at a room temperature of 20°C, a heater raises the temperature by 2 degrees every hour. The temperature after t hours is given by the expression:",
   "20 + 2t",
   C("Start at 20°C and add 2 degrees for each of the t hours: that added amount is 2 × t = 2t.")+
   steps("Begin at 20°C","add 2°C per hour for t hours = 2t","total temperature = 20 + 2t.")+
   U("This is exactly how you'd predict a room's temperature from a steady heater."),
   [("20 × 2t","Multiplying the starting value distorts it; you ADD the rise, giving 20 + 2t."),
    ("2 + 20t","This wrongly multiplies 20 by t; the steady rise is 2 per hour, so the temperature is 20 + 2t."),
    ("20 − 2t","A heater RAISES the temperature, so you add, not subtract; the expression is 20 + 2t.")]),

 ("DH","An impossible event has a probability of 0 and a certain (sure) event has a probability of 1. So the probability of any event must always lie:",
   "between 0 and 1",
   C("Probability measures how likely something is, on a scale from 0 (impossible) up to 1 (certain); it can never be outside this range.")+
   steps("Impossible event = 0","certain event = 1","every probability falls somewhere between 0 and 1.")+
   U("A forecast of 'a 70% chance of rain' is a probability of 0.7 — safely between 0 and 1."),
   [("between 1 and 10","Probabilities are never bigger than 1; they lie between 0 and 1."),
    ("above 1 always","A probability cannot exceed 1; it always lies between 0 and 1."),
    ("below 0 always","A probability is never negative; it always lies between 0 and 1.")]),

 # ===== ROUND 15 =====
 ("HT","A doctor must NOT use an ordinary clinical thermometer to measure the temperature of boiling water. The main reason is that boiling water is:",
   "far hotter than the clinical thermometer's range",
   C("A clinical thermometer reads only about 35°C to 42°C; boiling water at 100°C is far beyond this, and could burst the thermometer.")+
   steps("Boiling water is about 100°C","the clinical scale stops near 42°C","100°C is far above its range, so it must not be used.")+
   U("This is why you never test boiling water with a fever thermometer — it would simply burst."),
   [("too cold to measure","Boiling water is very hot, not cold; the problem is that it is far hotter than the clinical thermometer can read."),
    ("not a liquid","Boiling water is certainly a liquid; the real issue is that its temperature exceeds the clinical range."),
    ("too pure to read","Purity has nothing to do with it; boiling water is simply far hotter than the clinical thermometer's range.")]),

 ("RO","Stems of woody plants are covered by bark, which air cannot easily cross. For gas exchange, such stems have small openings in the bark called:",
   "lenticels",
   C("Lenticels are tiny pores in the bark of woody stems that let gases pass in and out for respiration.")+
   steps("Bark blocks easy gas exchange","woody stems still need to swap gases","small bark pores called lenticels allow it.")+
   U("Look closely at a tree trunk and the tiny rough dots on the bark are its lenticels."),
   [("stomata","Stomata are pores on leaves; the small breathing pores in woody bark are called lenticels."),
    ("spiracles","Spiracles are breathing holes of insects, not plants; woody stems use lenticels."),
    ("gills","Gills belong to fish for water-breathing; woody stems exchange gases through lenticels.")]),

 ("AE","The coefficient of the variable in the term −5y is the number multiplying y, including its sign. That coefficient is:",
   "−5",
   C("The coefficient is the whole number factor in front of the variable, sign included. In −5y it is −5.")+
   steps("−5y means −5 times y","the number multiplying y, with its sign, is −5","so the coefficient is −5.")+
   U("A temperature dropping 5° an hour, written −5t, carries its minus sign just like this coefficient."),
   [("5","Dropping the minus sign is wrong; the coefficient carries its sign, so it is −5."),
    ("y","y is the variable, not the coefficient; the number multiplying it is −5."),
    ("−1","−1 is not the full factor here; the number multiplying y in −5y is −5.")]),

 ("DH","Before you can find the median of a list of marks, the first thing you must always do is:",
   "arrange the marks in order of size",
   C("The median is the middle value of an ORDERED list, so the data must first be sorted from smallest to largest.")+
   steps("The median is a position in an ordered list","an unsorted list has no clear middle","so first arrange the marks in order.")+
   U("To find the 'middle' finisher in a race, you first line everyone up in order of time."),
   [("add up all the marks","Adding the marks is the first step for the MEAN, not the median; for the median you first sort them."),
    ("pick the largest mark","The largest mark is the maximum, not the median; for the median you first arrange the marks in order."),
    ("count how many marks there are","Counting alone won't find the centre value; you must first arrange the marks in order of size.")]),

 # ===== ROUND 16 =====
 ("HT","Heat is best described not as a substance but as a form of:",
   "energy",
   C("Heat is a form of energy that flows from a hotter body to a cooler one; it is not a material you can weigh.")+
   steps("Heat can do work and raise temperature","these are the marks of energy","so heat is a form of energy.")+
   U("A rubbed pair of hands feels warm because the energy of motion turns into heat energy."),
   [("matter","Heat is not matter — you cannot collect or weigh it; heat is a form of energy."),
    ("light","Light and heat are different, though a hot object may glow; heat itself is a form of energy."),
    ("sound","Sound is a separate kind of energy you hear; heat is the form of energy that flows because of temperature differences.")]),

 ("RO","A person normally takes about 15 to 18 breaths each minute while at rest. One full 'breath' here means:",
   "one breathing in followed by one breathing out",
   C("A single breath counts as one inhalation together with the exhalation that follows it.")+
   steps("Air is drawn in (inhalation)","then pushed out (exhalation)","this in-and-out together is counted as one breath.")+
   U("A doctor counts these in-and-out breaths for a minute to check your breathing rate."),
   [("only one breathing in","A breath is not counted until the air is also let out; one breath is one in PLUS one out."),
    ("ten heartbeats","Heartbeats are separate from breaths; one breath is one inhalation plus one exhalation."),
    ("one yawn","A yawn is not the unit of counting; one breath is a breathing-in followed by a breathing-out.")]),

 ("AE","Removing the like terms, simplify 9m − 4m. The result is:",
   "5m",
   C("9m and 4m are like terms, so subtract their coefficients: 9 − 4 = 5, keeping the variable m.")+
   steps("Both terms have the variable m","subtract the numbers: 9 − 4 = 5","so 9m − 4m = 5m.")+
   U("Subtracting like terms is how you work out how much pocket money is left after spending."),
   [("13m","13m ADDS the coefficients; the operation is subtraction, giving 9 − 4 = 5m."),
    ("5","Dropping the variable is wrong; subtracting like terms keeps the m, giving 5m."),
    ("5m²","Subtracting does not change the power of m; 9m − 4m = 5m, not 5m².")]),

 ("DH","Five readings are 12, 15, 11, 18 and 14. To work out their RANGE you find:",
   "18 − 11 = 7",
   C("The range is the largest value minus the smallest value of the data set.")+
   steps("Largest reading = 18","smallest reading = 11","range = 18 − 11 = 7.")+
   U("A factory checks the range of its measurements to see how much they vary."),
   [("18 + 11 = 29","The range subtracts the smallest from the largest, it does not add them: 18 − 11 = 7."),
    ("12 − 11 = 1","You must use the largest and smallest values; that is 18 − 11 = 7, not 12 − 11."),
    ("15 − 14 = 1","These are middle values, not the extremes; the range is 18 − 11 = 7.")]),

 # ===== ROUND 17 =====
 ("HT","Imagine two metal balls, one at 80°C and one at 30°C, touching each other. Heat will flow from the:",
   "80°C ball to the 30°C ball",
   C("Heat always flows from the body at higher temperature to the one at lower temperature.")+
   steps("80°C is hotter than 30°C","heat moves from hot to cold","so it flows from the 80°C ball to the 30°C ball.")+
   U("An ice cube melts in your warm drink because heat flows from the drink into the ice."),
   [("30°C ball to the 80°C ball","Heat does not flow from cold to hot on its own; it flows from the 80°C ball to the 30°C ball."),
    ("ground into both balls","The ground is not the hotter body here; heat flows from the hotter 80°C ball to the cooler one."),
    ("air into the hotter ball","Heat leaves the hotter ball rather than entering it; it flows from the 80°C ball to the 30°C ball.")]),

 ("RO","Cockroaches, ants and other insects have a network of fine air tubes that carry air from the spiracles to every part of the body. These tubes are called:",
   "tracheae",
   C("In insects, air entering the spiracles travels through branching tubes called tracheae that reach the tissues directly.")+
   steps("Air enters the insect through spiracles","it then runs through fine branching tubes","these tubes are the tracheae.")+
   U("These branching air tubes let even a tiny ant carry oxygen to every part of its body."),
   [("blood vessels","Insects do not carry oxygen mainly in blood; their air tubes are the tracheae."),
    ("nerves","Nerves carry signals, not air; the air-carrying tubes in insects are the tracheae."),
    ("lungs","Insects have no lungs; air reaches their tissues through the tracheae.")]),

 ("AE","The value of the expression x² + 1 when x = 3 is:",
   "10",
   C("Square the value of x, then add 1: substitute x = 3 carefully.")+
   steps("x² with x = 3 is 3 × 3 = 9","then add 1","9 + 1 = 10.")+
   U("Working out areas, which use squared lengths, needs this same 'square first' step."),
   [("7","7 comes from 2 × 3 + 1, but x² means 3 × 3 = 9, so the answer is 10."),
    ("9","9 is just x²; the expression also adds 1, giving 9 + 1 = 10."),
    ("16","16 wrongly does (3 + 1)²; you must square first, then add: 9 + 1 = 10.")]),

 ("DH","A 'frequency' in a data table tells you:",
   "how many times a value occurs",
   C("The frequency of a value is simply the count of how often that value appears in the data.")+
   steps("Look at one value in the data","count how often it shows up","that count is its frequency.")+
   U("A teacher tallies the frequency of each grade to see how the whole class did."),
   [("how large the value is","Frequency is about COUNT, not size; it tells how many times the value occurs."),
    ("the average of the data","The average is the mean; frequency tells how many times a value occurs."),
    ("the largest value present","The largest value is the maximum; frequency tells how many times a value occurs.")]),

 # ===== ROUND 18 =====
 ("HT","The metal pot on a stove is made of metal on purpose, while the handle is made of wood. The pot is metal because metals are:",
   "good conductors of heat",
   C("Metals conduct heat well, so a metal pot quickly passes the stove's heat to the food inside.")+
   steps("Food must be heated quickly","metals let heat pass through easily","so a good conductor like metal makes the pot.")+
   U("Copper and aluminium, very good conductors, are favourite metals for cooking pots."),
   [("poor conductors of heat","If the pot were a poor conductor, the food would barely heat; pots are metal because metals are GOOD conductors."),
    ("able to make heat","Metal makes no heat of its own; it is used for the pot because it is a good conductor that passes the stove's heat."),
    ("lighter than wood","Many metals are heavier than wood; the pot is metal because metals are good conductors of heat.")]),

 ("RO","Even at night, when there is no sunlight and no photosynthesis, a green plant continues to:",
   "respire, taking in oxygen and giving out carbon dioxide",
   C("Respiration in plants goes on all the time, day and night, because cells always need energy; photosynthesis is the part that stops without light.")+
   steps("Photosynthesis needs light, so it stops at night","but cells always need energy","so the plant keeps respiring through the night.")+
   U("This is why a heavily planted, closed room can feel a little stuffy by morning."),
   [("make food using sunlight","Making food (photosynthesis) needs light and stops at night; what continues is respiration."),
    ("stop all life processes","A plant does not switch off at night; it keeps respiring even without light."),
    ("take in carbon dioxide only","Through the night the plant takes in oxygen for respiration and gives out carbon dioxide.")]),

 ("AE","Written as an algebraic expression, 'the sum of x and twice y' is:",
   "x + 2y",
   C("'Twice y' is 2y, and 'the sum of x and twice y' adds it to x, giving x + 2y.")+
   steps("Twice y means 2 × y = 2y","'sum of x and 2y' means add them","so x + 2y.")+
   U("Buying x notebooks and twice as many pens is captured by an expression like x + 2y."),
   [("2x + y","This doubles the wrong letter; it is y that is doubled, giving x + 2y."),
    ("2xy","2xy multiplies the letters together; the phrase means a sum, x + 2y."),
    ("x + y + 2","The 2 multiplies y, it is not added on its own; the expression is x + 2y.")]),

 ("DH","The number of glasses of water a boy drank on six days were 5, 6, 5, 7, 6 and 5. The MODE of this data is:",
   "5",
   C("The mode is the most frequent value. Here 5 occurs three times, more than any other value.")+
   steps("Count each value: 5 appears 3 times, 6 twice, 7 once","the highest count is for 5","so the mode is 5.")+
   U("A canteen notes the most-ordered (mode) dish so it can prepare more of it."),
   [("6","6 appears only twice; the value occurring most often is 5."),
    ("7","7 appears just once; the most frequent value is 5."),
    ("3","3 is how many times 5 occurs, not the mode itself; the mode (the value) is 5.")]),

 # ===== ROUND 19 =====
 ("HT","During the daytime at a beach, the cool wind that blows from the sea towards the land is called a:",
   "sea breeze",
   C("By day the land heats faster and the warm air over it rises; cooler air from over the sea flows in to take its place — a sea breeze.")+
   steps("Land gets hotter than the sea by day","warm air over the land rises","cool air rushes in from the sea — the sea breeze.")+
   U("Fishing communities along the coast have long planned their day around these breezes."),
   [("land breeze","A land breeze blows from land to sea at NIGHT; the daytime sea-to-land wind is the sea breeze."),
    ("monsoon wind","Monsoon winds are seasonal and large-scale; the daily cool wind off the sea by day is the sea breeze."),
    ("cyclone","A cyclone is a violent storm system, not a gentle daytime coastal wind; that is the sea breeze.")]),

 ("RO","In an experiment, soaked seeds are kept in a sealed flask. After a day the air in the flask has less oxygen and more carbon dioxide, and a thermometer shows the flask has grown slightly:",
   "warmer",
   C("The germinating seeds respire, and respiration releases energy partly as heat, so the flask warms up a little.")+
   steps("Germinating seeds respire actively","respiration releases energy, some as heat","so the sealed flask grows slightly warmer.")+
   U("Stored damp grain can heat up and spoil for exactly this reason — the grain is respiring."),
   [("colder","Respiration releases heat rather than absorbing it, so the flask gets warmer, not colder."),
    ("frozen","Nothing here removes heat; the respiring seeds release heat, so the flask grows slightly warmer."),
    ("unchanged in temperature","The energy released by the seeds' respiration warms the flask slightly, so the temperature does change.")]),

 ("AE","In a classroom each bench seats 2 students. An algebraic expression for the number of students seated on b benches is:",
   "2b",
   C("Each bench holds 2 students, so b benches hold 2 × b = 2b students.")+
   steps("One bench seats 2","b benches seat 2 added b times","= 2 × b = 2b.")+
   U("This is the kind of expression a school uses to work out how many benches a class needs."),
   [("b + 2","Adding 2 treats it as 'two extra students', not 2 per bench; the count is 2 × b = 2b."),
    ("b ÷ 2","Dividing would shrink the count as benches increase, which is wrong; it is 2b."),
    ("2 − b","Subtracting makes no sense for a total; b benches seat 2b students.")]),

 ("DH","On a bar graph the vertical scale is marked 0, 10, 20, 30 and so on. A bar that reaches exactly halfway between the 20 and 30 lines stands for a value of:",
   "25",
   C("Halfway between 20 and 30 on the scale is the value 25.")+
   steps("The gap from 20 to 30 is 10 units","halfway along that gap is 5 units past 20","20 + 5 = 25.")+
   U("Reading a value that falls between two gridlines is an everyday skill with bills and charts."),
   [("23","23 is not the midpoint of 20 and 30; the exact halfway value is 25."),
    ("30","30 is the next full mark, not halfway; a bar reaching the midpoint reads 25."),
    ("50","50 wrongly adds 20 and 30; the midpoint BETWEEN them is 25.")]),

 # ===== ROUND 20 =====
 ("HT","Why does a metal chair feel COLDER to touch than a wooden chair in the same cool room, even though both are at the same temperature?",
   "metal conducts heat away from your hand faster",
   C("Both are at room temperature, but metal is a far better conductor, so it pulls heat from your hand quickly, making it feel colder.")+
   steps("Metal and wood are at the same temperature","metal conducts heat from your hand much faster","so the metal feels colder to the touch.")+
   U("The same effect makes a tiled floor feel colder underfoot than a carpet at the same temperature."),
   [("the metal is actually at a lower temperature","They are stated to be at the SAME temperature; the metal only feels colder because it conducts heat away faster."),
    ("wood makes its own heat","Wood produces no heat; the metal feels colder because it conducts your hand's heat away faster."),
    ("metal reflects cold onto your hand","There is no such thing as 'cold' flowing; metal feels colder because it conducts heat away from your hand faster.")]),

 ("RO","A tadpole living in water breathes with gills, but when it grows into an adult frog living partly on land, it breathes mainly with its:",
   "lungs (and moist skin)",
   C("An adult frog breathes through lungs and also exchanges gases through its moist skin, suited to life on land and in water.")+
   steps("The water-living tadpole uses gills","the adult frog spends time on land","so it breathes mainly with lungs, plus its moist skin.")+
   U("A frog can rest underwater a long while because its moist skin keeps taking in oxygen."),
   [("gills only, like the tadpole","The adult frog leaves the water to live partly on land; it switches to breathing mainly with lungs."),
    ("spiracles like an insect","Frogs are not insects and have no spiracles; an adult frog breathes with lungs and moist skin."),
    ("roots","Roots belong to plants, not frogs; the adult frog breathes through its lungs and moist skin.")]),

 ("AE","An algebraic expression made up of THREE unlike terms, such as x + y + 7, is called a:",
   "trinomial",
   C("A trinomial is an expression containing exactly three unlike terms.")+
   steps("x + y + 7 has three parts","they are unlike terms","an expression of three terms is a trinomial.")+
   U("A bill with three different items priced in symbols is a trinomial expression."),
   [("binomial","A binomial has two terms; an expression with three terms is a trinomial."),
    ("monomial","A monomial has one term; x + y + 7 has three, making it a trinomial."),
    ("coefficient","A coefficient is a number multiplying a variable, not a whole expression; x + y + 7 is a trinomial.")]),

 ("DH","A weather station noted the day's temperature as 27°C, 27°C, 29°C, 31°C and 26°C over five days. The mean temperature is:",
   "28°C",
   C("Add the five readings and divide by 5 to get the mean.")+
   steps("Sum = 27 + 27 + 29 + 31 + 26 = 140","there are 5 days","140 ÷ 5 = 28°C.")+
   U("Climate scientists track a place's mean temperature year after year in just this way."),
   [("27°C","27°C is the most common reading (the mode), not the mean; the mean is 140 ÷ 5 = 28°C."),
    ("31°C","31°C is the highest single reading, not the average; the mean is 28°C."),
    ("140°C","140°C is the TOTAL of the readings; you must still divide by 5, giving a mean of 28°C.")]),

 # ===== ROUND 21 =====
 ("HT","A thermometer works by linking temperature to the length of a thin column of liquid. The liquid traditionally used in a clinical thermometer is:",
   "mercury",
   C("Clinical thermometers traditionally use mercury, a liquid metal whose column expands and rises evenly with temperature.")+
   steps("The liquid must expand clearly with heat","mercury does so and is easy to see","so it was the traditional clinical-thermometer liquid.")+
   U("Older clinical thermometers the world over used this silvery liquid metal, mercury."),
   [("water","Water freezes and behaves unevenly, making it unsuitable; mercury was traditionally used."),
    ("oil","Oil is not used in clinical thermometers; the traditional liquid is mercury."),
    ("milk","Milk would spoil and cannot be sealed in a thermometer; the traditional liquid is mercury.")]),

 ("RO","Compared with the fresh air we breathe in, the air we breathe OUT contains:",
   "less oxygen and more carbon dioxide",
   C("Breathing uses up some oxygen and adds carbon dioxide, so exhaled air has less oxygen and more carbon dioxide than inhaled air.")+
   steps("Oxygen is used in respiration","carbon dioxide is produced as waste","so exhaled air has less oxygen and more carbon dioxide.")+
   U("This is why rescue breathing can still help — exhaled air still holds enough oxygen to be useful."),
   [("more oxygen and less carbon dioxide","This is backwards; breathing USES oxygen and ADDS carbon dioxide, so exhaled air has less oxygen and more carbon dioxide."),
    ("no oxygen at all","Exhaled air still contains plenty of oxygen, just less than inhaled air, along with more carbon dioxide."),
    ("only carbon dioxide","Exhaled air is mostly nitrogen with some oxygen; it simply has less oxygen and more carbon dioxide than inhaled air.")]),

 ("AE","A 'term' in an algebraic expression is a single part separated from the others by a plus or minus sign. The expression 4x − 3y + 7 has how many terms?",
   "three",
   C("Each part separated by + or − is a term: 4x, 3y and 7 make three terms.")+
   steps("Split at the + and − signs","the parts are 4x, 3y and 7","that is three terms.")+
   U("Counting the terms is the first step to tidying up any algebra expression."),
   [("one","Only an expression with no + or − between parts has one term; 4x − 3y + 7 has three."),
    ("two","There are three parts, not two: 4x, 3y and 7."),
    ("four","There are exactly three parts separated by the signs: 4x, 3y and 7.")]),

 ("DH","The data 8, 3, 5, 9 and 5 is to be summarised by its MEDIAN. After ordering the values, the median is:",
   "5",
   C("Order the data, then take the middle value. With five values, the third one is the median.")+
   steps("In order: 3, 5, 5, 8, 9","the middle (3rd) value","is 5.")+
   U("The 'middle' income of a town is found by lining all incomes up and taking the centre value."),
   [("8","8 is one of the larger values, not the centre; the ordered middle value is 5."),
    ("9","9 is the maximum, not the median; once ordered, the middle value is 5."),
    ("3","3 is the smallest value, not the centre; the median of the ordered list is 5.")]),

 # ===== ROUND 22 =====
 ("HT","When a substance is heated, its tiny particles gain energy and move about more. Because of this extra movement, most substances on heating:",
   "expand (take up more space)",
   C("Heated particles move faster and spread out a little, so most solids, liquids and gases expand when warmed.")+
   steps("Heat gives particles more energy","they move and spread out more","so the substance expands.")+
   U("This is why a tight metal lid loosens after you run it under hot water."),
   [("contract (take up less space)","Heating spreads particles out, so substances expand; contracting happens on COOLING."),
    ("become heavier","Heating does not add matter, so the weight does not increase; the substance simply expands."),
    ("turn into a gas at once","Most substances merely expand a little on heating; they do not all instantly become gas.")]),

 ("RO","The opening and closing of a stoma (a leaf pore) is controlled by a pair of specially shaped cells on either side of it. These are the:",
   "guard cells",
   C("Each stoma is bordered by two guard cells that swell or shrink to open or close the pore, controlling gas exchange and water loss.")+
   steps("A stoma is a pore in the leaf","two curved cells border it","these guard cells open and close the pore.")+
   U("On a hot day a plant's guard cells close its pores to save water."),
   [("root hairs","Root hairs absorb water from soil; the cells that open and close a leaf pore are the guard cells."),
    ("nerve cells","Plants have no nerve cells; a stoma is worked by its guard cells."),
    ("blood cells","Plants have no blood cells; the cells controlling a stoma are the guard cells.")]),

 ("AE","Simplify the expression by collecting like terms: 3p + 2q + 5p + q. The simplest form is:",
   "8p + 3q",
   C("Add the p-terms together and the q-terms together separately.")+
   steps("p-terms: 3p + 5p = 8p","q-terms: 2q + q = 3q","so the expression is 8p + 3q.")+
   U("Adding up two kinds of coins separately and then writing the totals works just like this."),
   [("11pq","p and q are unlike and cannot be multiplied together; collecting like terms gives 8p + 3q."),
    ("8p + 2q","The q-terms are 2q + q = 3q, not 2q; the answer is 8p + 3q."),
    ("10p + 3q","The p-terms are 3p + 5p = 8p, not 10p; the answer is 8p + 3q.")]),

 ("DH","A coin is tossed and a single dice is rolled by two different children. The child rolling the DICE has a smaller chance of getting any one chosen number because:",
   "the dice has more equally likely outcomes than the coin",
   C("A coin has 2 outcomes (chance 1/2 each) while a dice has 6 outcomes (chance 1/6 each); more outcomes means each one is less likely.")+
   steps("Coin: 2 outcomes, each 1/2","dice: 6 outcomes, each 1/6","1/6 is smaller than 1/2, so the dice number is less likely.")+
   U("Board games feel less predictable with dice than with a coin, because a die has six outcomes."),
   [("the dice is heavier than the coin","Weight does not set the probability; the dice number is less likely because the dice has more equally likely outcomes."),
    ("the coin can land on its edge","We treat the coin as landing heads or tails only; the dice number is less likely because it has 6 outcomes, not 2."),
    ("a dice cannot be fair","A dice can be perfectly fair; each number is just less likely because there are 6 equally likely outcomes.")]),

 # ===== ROUND 23 =====
 ("HT","The actual amount of heat ENERGY a body contains depends not only on its temperature but also on how much of the substance there is. So a large bucket of warm water contains more heat than a small cup of water at the same temperature because the bucket has:",
   "more water",
   C("At the same temperature, a larger amount of a substance holds more heat energy in total, because there is more matter storing it.")+
   steps("Both are at the same temperature","the bucket holds far more water","more matter stores more heat energy in total.")+
   U("This is why a small spark, though very hot, holds far less heat than a warm bathtub of water."),
   [("a higher temperature","They are at the SAME temperature; the bucket holds more heat simply because it contains more water."),
    ("colder water","Colder water would hold LESS heat; the bucket holds more heat because it has more water at the same temperature."),
    ("no heat at all","Warm water certainly holds heat; the bucket holds more than the cup because it contains more water.")]),

 ("RO","Some bacteria can live and respire in places with no oxygen at all, such as deep in waterlogged mud. Such organisms are described as:",
   "anaerobic",
   C("Anaerobic organisms respire without oxygen, releasing energy by breaking down food in oxygen-free conditions.")+
   steps("They live where there is no oxygen","yet they still release energy from food","such oxygen-free respirers are anaerobic.")+
   U("Anaerobic bacteria in airtight tanks are used to turn waste into useful biogas."),
   [("aerobic","Aerobic organisms need oxygen to respire; those living without it are anaerobic."),
    ("herbivorous","Herbivorous describes a plant-eating diet, not a way of respiring; oxygen-free respirers are anaerobic."),
    ("nocturnal","Nocturnal means active at night, which is unrelated to oxygen; these organisms are anaerobic.")]),

 ("AE","Reading the statement carefully, the expression for 'seven less than three times a number n' is:",
   "3n − 7",
   C("'Three times a number' is 3n, and 'seven less than' that means subtract 7, giving 3n − 7.")+
   steps("Three times n is 3n","'seven less than' 3n means take 7 away","so 3n − 7.")+
   U("Translating word problems into expressions like this is the first step in solving them."),
   [("7 − 3n","'Seven less THAN 3n' subtracts 7 from 3n, not the other way round; it is 3n − 7."),
    ("3n + 7","'Less than' means subtract, not add; the expression is 3n − 7."),
    ("3(n − 7)","This subtracts 7 from n BEFORE tripling, changing the meaning; 'seven less than three times n' is 3n − 7.")]),

 ("DH","A bar graph shows the number of books read by four children: Asha 6, Ravi 4, Meena 8 and Sam 6. The total number of books read by all four is:",
   "24",
   C("Add up the value of every bar to find the total.")+
   steps("6 + 4 + 8 + 6","= 24","so 24 books in all.")+
   U("Adding up all the bars gives a shop its total sales for the week."),
   [("8","8 is just Meena's tallest bar, not the total; all four add to 24."),
    ("6","6 is the value of two of the bars, not the total; the four bars add to 24."),
    ("18","18 leaves out one of the bars; 6 + 4 + 8 + 6 = 24.")]),

 # ===== ROUND 24 =====
 ("HT","After a hot meal is served, a steel bowl of soup cools down while the cooler air around it warms up slightly. Eventually the soup stops cooling when it reaches:",
   "the temperature of the surrounding air (room temperature)",
   C("Heat flows from the hot soup to the cooler air until both reach the same temperature — roughly room temperature — and net flow stops.")+
   steps("Soup is hotter than the room air","heat flows from soup to air","cooling stops when both reach the same, room, temperature.")+
   U("Your tea always cools to room temperature and no further, for exactly this reason."),
   [("0°C, the freezing point","The soup does not cool below the room; it stops at room temperature, not at freezing point."),
    ("100°C, the boiling point","The soup is cooling DOWN, not heating to boiling; it settles at room temperature."),
    ("its own original temperature","The soup cannot stay at its serving temperature while losing heat; it cools to room temperature.")]),

 ("RO","A simple way to remember the role of breathing is that it supplies the body with oxygen and removes a waste gas. That waste gas removed by breathing is:",
   "carbon dioxide",
   C("Respiration produces carbon dioxide as waste, and breathing out is how the body gets rid of it.")+
   steps("Cells make carbon dioxide as waste","it must be cleared from the body","breathing out removes the carbon dioxide.")+
   U("Every breath out clears away the carbon dioxide your cells have made."),
   [("oxygen","Oxygen is taken IN, not removed; the waste gas breathed out is carbon dioxide."),
    ("nitrogen","Nitrogen passes in and out roughly unchanged; the waste gas removed is carbon dioxide."),
    ("water","Water is mostly removed as urine and sweat; the waste GAS removed by breathing is carbon dioxide.")]),

 ("AE","If a number is called x, then 'the number that is 1 more than double x' is written as:",
   "2x + 1",
   C("'Double x' is 2x, and '1 more than' that means add 1, giving 2x + 1.")+
   steps("Double x is 2x","'1 more than' 2x means add 1","so 2x + 1.")+
   U("An entry fee of ₹1 plus ₹2 per ride for x rides is written 2x + 1."),
   [("x + 2","This doubles nothing and adds the wrong amount; 'one more than double x' is 2x + 1."),
    ("2(x + 1)","This adds 1 to x BEFORE doubling, which is different; the answer is 2x + 1."),
    ("2x − 1","'One MORE than' means add, not subtract; the expression is 2x + 1.")]),

 ("DH","Six students were asked how many glasses of water they drank: the values were 4, 6, 5, 7, 5 and 3. Because there are an EVEN number of values, the median is found by:",
   "averaging the two middle values once the data is ordered",
   C("With an even count there is no single middle value, so the median is the mean of the two central values of the ordered list.")+
   steps("In order: 3, 4, 5, 5, 6, 7","the two middle values are 5 and 5","their average (5 + 5) ÷ 2 = 5 is the median.")+
   U("With an even-sized class, the 'middle' mark is the average of the two central students."),
   [("taking the single middle value","With an EVEN number of values there is no single middle; you average the two central values instead."),
    ("choosing the largest value","The largest value is the maximum, not the median; for an even count you average the two middle values."),
    ("adding all six values","Adding all six and dividing gives the MEAN; the median averages just the two middle values once ordered.")]),

 # ===== ROUND 25 =====
 ("HT","In summary, the single best one-word description of what a thermometer actually measures is:",
   "temperature",
   C("A thermometer measures temperature — the degree of hotness or coldness of a body — on a numbered scale.")+
   steps("Hotness needs to be put as a number","the thermometer reads it on a scale","that quantity is the temperature.")+
   U("Whether you are checking a fever or the weather, you are always reading a temperature."),
   [("weight","Weight is measured by a scale or balance; a thermometer measures temperature."),
    ("heat energy","A thermometer does not directly read total heat energy, which also depends on amount; it reads temperature."),
    ("pressure","Pressure is read by a barometer or gauge; a thermometer measures temperature.")]),

 ("RO","Tying the chapter together: the chief PURPOSE of respiration in any living organism is to:",
   "release energy from food for life processes",
   C("Respiration breaks down food to release the energy that powers growth, movement, repair and every living activity.")+
   steps("All life processes need energy","that energy is locked in food","respiration releases it for the organism to use.")+
   U("From a sprinting cheetah to a sprouting seed, every living thing is powered by respiration."),
   [("make food using sunlight","Making food from sunlight is photosynthesis, done only by green plants; respiration RELEASES the energy from food."),
    ("remove extra water from the body","Removing water is the job of excretion and transpiration; respiration's purpose is to release energy from food."),
    ("help the organism grow taller only","Growth is just one use of the energy; respiration's broad purpose is to release energy for all life processes.")]),

 ("AE","Putting respiration and algebra together: if a resting person takes 16 breaths a minute, the number of breaths in 5 minutes is found by evaluating 16m at m = 5, which gives:",
   "80",
   C("Substitute m = 5 into the expression 16m for breaths in m minutes.")+
   steps("Breaths in m minutes = 16m","put m = 5","16 × 5 = 80 breaths.")+
   U("Estimating breaths over several minutes from a one-minute count uses this exact step."),
   [("21","21 wrongly adds 16 and 5; the breaths multiply, giving 16 × 5 = 80."),
    ("16","16 is the breaths in just ONE minute; over 5 minutes it is 16 × 5 = 80."),
    ("11","11 subtracts 5 from 16, which has no meaning here; 16m at m = 5 is 80.")]),

 ("DH","Finally, combining data handling with respiration: the breathing rates of five classmates are 18, 20, 16, 22 and 19 breaths per minute. Their MEAN breathing rate is:",
   "19",
   C("Add the five rates and divide by 5 to find the mean breathing rate.")+
   steps("Sum = 18 + 20 + 16 + 22 + 19 = 95","there are 5 classmates","95 ÷ 5 = 19 breaths per minute.")+
   U("A school nurse might average the class's breathing rates to spot anything unusual."),
   [("22","22 is the fastest single rate, not the average; the mean is 95 ÷ 5 = 19."),
    ("16","16 is the slowest single rate, not the average; the mean breathing rate is 19."),
    ("95","95 is the TOTAL of the five rates; the mean still needs dividing by 5, giving 19.")]),

]

assert len(items) == 100, len(items)

# sanity: 25 of each chapter
from collections import Counter
_c = Counter(it[0] for it in items)
assert all(_c[k] == 25 for k in ("HT", "RO", "AE", "DH")), dict(_c)

# no two consecutive items share a chapter
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

    keydist = build_paper(PNUM, TITLE, SHORT, LABELS, items, seed=55155,
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
    split = "/".join(str(counts[c]) for c in ("HT", "RO", "AE", "DH"))
    with open("PAPERS_MANIFEST.md", "a", encoding="utf-8") as fh:
        fh.write(f"| {PNUM} | 2026-06-18 | {TITLE} | {split} | ✓ |\n")

    # ---- update QUESTION_INDEX.json ----
    idx["fingerprints"] = sorted(existing | set(new_fps))
    idx.setdefault("combos", []).append({
        "paper": PNUM,
        "chapters": ["Heat",
                     "Respiration in Organisms",
                     "Algebraic Expressions",
                     "Data Handling"],
    })
    idx["papers"] = idx.get("papers", 0) + 1
    with open(idx_path, "w", encoding="utf-8") as fh:
        json.dump(idx, fh, ensure_ascii=False, indent=2)
        fh.write("\n")

    print("Files:", sorted(v for v in moves.values()))
    print("Answer key spread A/B/C/D =", dict(keydist))
